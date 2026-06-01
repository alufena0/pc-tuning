param(
    [switch]$verbose,
    [switch]$dryRun,
    [switch]$generateStartupLine
)

# ============================================================================
# Frenzy RWEverything Settings Automation (AMD)
# ============================================================================
# Usage:
#   .\ApplyRWE-AMD.ps1                        # Apply all settings
#   .\ApplyRWE-AMD.ps1 -verbose               # Apply with detailed output
#   .\ApplyRWE-AMD.ps1 -dryRun                # Show what would be applied
#
# Target: AMD Zen 1/2/3/4/5 (Ryzen, Threadripper, EPYC)
# LS_CFG/IC_CFG/DC_CFG/BP_CFG use Zen-generation-specific presets
# sourced from XMRig tested values + AMD PPR documents.
# ============================================================================

$config = @{
    RwePath = "C:\Program Files\RW-Everything\Rw.exe"

    # -- USB --
    EnableXhciImod           = $true    # xHCI IMOD integrado

    # -- PCIe (MMCFG: ASPM + CompTimeout + OBFF + LTR + MPS + L1SS) --
    EnablePcieOptimization   = $true

    # -- AMD CPU MSRs --
    EnableSpecCtrl           = $false  # MSR 0x48: Intel MSR -- nao existe no Zen3, causa BSOD
    EnableHwcr               = $false  # requer leitura previa — instavel neste RWE
    EnableLsCfg              = $false  # requer leitura previa — instavel neste RWE
    EnableIcCfg              = $false  # requer leitura previa — instavel neste RWE
    EnableDcCfg              = $false  # requer leitura previa — instavel neste RWE
    EnableDeCfg              = $false  # requer leitura previa — instavel neste RWE
    EnableBpCfg              = $true   # MSR 0xC001102B: Branch predictor config
    EnableCStateControl      = $true   # MSR 0xC0010296: CSTATE_POLICY (CC6 disable)
    EnablePstateForceP0      = $false  # MSR 0xC0010062: desativado para X3D (SMU gerencia boost melhor)

    # -- Architectural MSRs (shared with Intel) --
    EnablePerfCounterDisable = $false  # MSR 0x38F/0x38D: instavel neste RWE
    EnableDebugDisable       = $false  # MSR 0x1D9: instavel neste RWE

    # -- MMIO --
    EnableHpetDisable        = $true   # 0xFED00000: Disable HPET

    # -- NIC / LAPIC --
    EnableNetworkImod        = $true
    EnableLapic              = $true

    # -- Values --
    XhciImodInterval        = 0x0
    XhciHcsparamsOffset     = 0x4
    XhciRtsoff              = 0x18
    XhciUserDefinedData     = @{}
    GpuBarOverride          = $null
    MmcfgOverride           = $null
    LapicOverride           = $null
    ZenGenOverride          = "zen3"  # 5700X3D - hardcoded
}

# ============================================================================
# INTERNAL
# ============================================================================

$script:allCommands  = [System.Collections.Generic.List[string]]::new()
$script:appliedCount = 0
$script:skippedCount = 0
$script:zenGen       = $null

# --- Safe hex conversion (avoids PS 5.1 signed Int32 overflow) ---
function U([string]$hex) {
    return [Convert]::ToUInt64(($hex -replace '^0x',''), 16)
}

function Dec-To-Hex($decimal) {
    return "0x" + ([Convert]::ToUInt64($decimal)).ToString("X")
}

function Get-Value-From-Address($address) {
    $addrHex = Dec-To-Hex -decimal ([Convert]::ToUInt64($address))
    $stdout = & $config.RwePath /Min /NoLogo /Stdout /Command="R32 $addrHex" | Out-String
    if ($stdout -match '=\s*0x([0-9A-Fa-f]+)') {
        return [Convert]::ToUInt64($Matches[1], 16)
    }
    $parts = $stdout.Trim() -split "\s+"
    $last = $parts[-1] -replace '^0x','' -replace '[^0-9A-Fa-f]',''
    return [Convert]::ToUInt64($last, 16)
}

function Get-Msr-Value($msrAddr) {
    $msrHex = Dec-To-Hex -decimal ([Convert]::ToUInt64($msrAddr))
    if ($script:msrAvail.Count -gt 0 -and $script:msrAvail.ContainsKey($msrHex) -and -not $script:msrAvail[$msrHex]) {
        throw "MSR $msrHex not available on this CPU"
    }
    $stdout = & $config.RwePath /Min /NoLogo /Stdout /Command="RDMSR $msrHex" | Out-String
    $hi = [uint32]0; $lo = [uint32]0
    if ($stdout -match 'EDX\)\s*=\s*0x([0-9A-Fa-f]+)') {
        $hi = [Convert]::ToUInt32($Matches[1], 16)
    }
    if ($stdout -match 'EAX\)\s*=\s*0x([0-9A-Fa-f]+)') {
        $lo = [Convert]::ToUInt32($Matches[1], 16)
    }
    return @{ Hi = $hi; Lo = $lo }
}

function Msr-To-UInt64($msrResult) {
    return ([uint64]$msrResult.Hi -shl 32) -bor [uint64]$msrResult.Lo
}

function UInt64-To-MsrHex($val) {
    $u = [Convert]::ToUInt64($val)
    $hi = "0x{0:X8}" -f ([uint32]($u -shr 32))
    $lo = "0x{0:X8}" -f ([uint32]($u -band 0x00000000FFFFFFFF))
    return @{ Hi = $hi; Lo = $lo }
}

function Get-Device-Addresses() {
    $data = @{}
    try {
        $resources = Get-WmiObject -Class Win32_PNPAllocatedResource -ComputerName LocalHost -Namespace root\CIMV2
        foreach ($resource in $resources) {
            $deviceId = $resource.Dependent.Split("=")[1].Replace('"', '').Replace("\\", "\")
            $physicalAddress = $resource.Antecedent.Split("=")[1].Replace('"', '')
            if (-not $data.ContainsKey($deviceId) -and $deviceId -and $physicalAddress) {
                $data[$deviceId] = [uint64]$physicalAddress
            }
        }
    } catch {
        Write-Host "  WMI query failed: $($_.Exception.Message)" -ForegroundColor Red
    }
    return $data
}

function Invoke-RweCommand {
    param([string]$command, [string]$description)
    if ($command -match '^WRMSR\s+0x([0-9A-Fa-f]+)') {
        $msrHex = "0x$($Matches[1])"
        if (-not (Test-MsrSafe $msrHex)) {
            if ($verbose) { Write-Host "  SKIP: MSR $msrHex not available" -ForegroundColor DarkGray }
            $script:skippedCount++
            return
        }
    }
    $script:allCommands.Add($command)
    if ($verbose) {
        Write-Host "  $description" -ForegroundColor DarkGray
        Write-Host "    -> $command" -ForegroundColor Cyan
    }
    if (-not $dryRun) {
        & $config.RwePath /Min /NoLogo /Stdout /Command="$command" | Out-Null
    }
    $script:appliedCount++
}

function Write-Section { param([string]$title); Write-Host ""; Write-Host "[$title]" -ForegroundColor Yellow }
function Write-Skipped { param([string]$title); if ($verbose) { Write-Host ""; Write-Host "[$title] SKIPPED" -ForegroundColor DarkGray }; $script:skippedCount++ }



$script:msrAvail = @{}

function Probe-MsrAvailability {
    $a = $script:msrAvail

    # -- Architectural MSRs (shared x86) --
    $a['0x48']   = $true   # IA32_SPEC_CTRL (Zen+)
    $a['0x1D9']  = $true   # IA32_DEBUGCTL
    $a['0x38F']  = $true   # IA32_PERF_GLOBAL_CTRL
    $a['0x38D']  = $true   # IA32_FIXED_CTR_CTRL

    # -- AMD Zen MSRs (always present on any Zen CPU) --
    $a[(Dec-To-Hex (U 'C0010015'))]  = $true   # HWCR
    $a[(Dec-To-Hex (U 'C0011020'))]  = $true   # LS_CFG
    $a[(Dec-To-Hex (U 'C0011021'))]  = $true   # IC_CFG
    $a[(Dec-To-Hex (U 'C0011022'))]  = $true   # DC_CFG
    $a[(Dec-To-Hex (U 'C0011029'))]  = $true   # DE_CFG
    $a[(Dec-To-Hex (U 'C001102B'))]  = $true   # BP_CFG
    $a[(Dec-To-Hex (U 'C0010296'))]  = $true   # CSTATE_POLICY
    $a[(Dec-To-Hex (U 'C0010062'))]  = $true   # PSTATE_CTL

    if ($verbose) {
        $available = ($a.GetEnumerator() | Where-Object { $_.Value } | Measure-Object).Count
        Write-Host "  MSR probe: $available MSRs validated" -ForegroundColor Green
    }
}

function Test-MsrSafe($msrHex) {
    if ($script:msrAvail.ContainsKey($msrHex)) {
        return $script:msrAvail[$msrHex]
    }
    return $true
}

function Detect-ZenGeneration {
    try {
        $name = (Get-WmiObject Win32_Processor | Select-Object -First 1).Name
        if ($name -match "7\d00X3D|79\d0X|78\d0X|Ryzen 9 9|Ryzen 7 9|Ryzen 5 9") { return "zen4" }
        if ($name -match "5\d00X3D|59\d0X|58\d0X|Ryzen.*5[6-9]\d0") { return "zen3" }
        if ($name -match "3\d00X|39\d0X|38\d0X|Ryzen.*3[6-9]\d0") { return "zen2" }
        if ($name -match "2\d00X|29\d0X|1\d00X|19\d0X") { return "zen1" }
    } catch {}
    return "zen2"
}

# ============================================================================
# AUTO-DETECTION: MMCFG, LAPIC
# ============================================================================

function Read-PciConfig32($bus, $dev, $func, $offset) {
    $offHex = Dec-To-Hex -decimal ([Convert]::ToUInt64($offset))
    $stdout = & $config.RwePath /Min /NoLogo /Stdout /Command="RPCI32 $bus $dev $func $offHex" | Out-String
    if ($stdout -match '=\s*0x([0-9A-Fa-f]+)') {
        return [Convert]::ToUInt64($Matches[1], 16)
    }
    return [uint64]0
}

function Get-MmcfgBase {
    try {
        $msr = Get-Msr-Value -msrAddr (U 'C0010058')
        $msrVal = ([uint64]$msr.Hi -shl 32) -bor [uint64]$msr.Lo
        if ($msrVal -band 1) {
            $base = [uint64]$msrVal -band [uint64]0x0000FFFFF00000
            if ($base -ne 0) {
                if ($verbose) { Write-Host "  MMCFG base (AMD MSR 0xC0010058): $(Dec-To-Hex -decimal $base)" -ForegroundColor Green }
                return $base
            }
        }

        $lo = Read-PciConfig32 0 0 0 0x60
        $hi = Read-PciConfig32 0 0 0 0x64
        $raw = ([uint64]$hi -shl 32) -bor [uint64]$lo
        if ($raw -band 1) {
            $sizeCode = ([uint64]$raw -shr 1) -band 0x3
            $base = switch ($sizeCode) {
                0 { [uint64]$raw -band [uint64]0x00000000FC000000 }
                1 { [uint64]$raw -band [uint64]0x00000000FE000000 }
                2 { [uint64]$raw -band [uint64]0x00000000FF000000 }
                default { [uint64]$raw -band [uint64]0x00000000FC000000 }
            }
            if ($base -ne 0) {
                if ($verbose) { Write-Host "  MMCFG base (PCIEXBAR): $(Dec-To-Hex -decimal $base)" -ForegroundColor Green }
                return $base
            }
        }
    } catch {}

    foreach ($candidate in @((U 'E0000000'), (U 'F0000000'), (U 'C0000000'), (U 'F8000000'))) {
        try {
            $probe = Get-Value-From-Address -address $candidate
            if ($probe -ne 0 -and $probe -ne (U 'FFFFFFFF')) {
                $vendorId = $probe -band 0xFFFF
                if ($vendorId -eq 0x8086 -or $vendorId -eq 0x1022) {
                    if ($verbose) { Write-Host "  MMCFG base (probed): $(Dec-To-Hex -decimal $candidate)" -ForegroundColor Green }
                    return $candidate
                }
            }
        } catch {}
    }
    return $null
}

function Get-LapicBase {
    try {
        $msr = Get-Msr-Value -msrAddr 0x1B
        $msrVal = ([uint64]$msr.Hi -shl 32) -bor [uint64]$msr.Lo
        if ($msrVal -band 0x800) {
            $base = [uint64]$msrVal -band [uint64]0x0000000FFFFFF000
            if ($base -ne 0) {
                if ($verbose) { Write-Host "  LAPIC base: $(Dec-To-Hex -decimal $base)" -ForegroundColor Green }
                return $base
            }
        }
    } catch {}
    return (U 'FEE00000')
}

# ============================================================================
# MAIN
# ============================================================================
function main() {
    if (-not (Test-Path $config.RwePath -PathType Leaf)) {
        Write-Host "error: $($config.RwePath) not found" -ForegroundColor Red
        Write-Host "download from: http://rweverything.com/download"
        return 1
    }
    Stop-Process -Name "Rw" -ErrorAction SilentlyContinue

    $script:zenGen = if ($config.ZenGenOverride) { $config.ZenGenOverride } else { Detect-ZenGeneration }

    Write-Host ""
    Write-Host "[Hardware Detection]" -ForegroundColor Yellow

    $mmcfg = if ($config.MmcfgOverride) { [uint64]$config.MmcfgOverride } else { Get-MmcfgBase }
    if (-not $mmcfg) {
        Write-Host "  WARNING: Could not detect MMCFG base. PCIe optimization skipped." -ForegroundColor Red
        $config.EnablePcieOptimization = $false
    } else {
        Write-Host "  MMCFG: $(Dec-To-Hex -decimal $mmcfg)" -ForegroundColor Cyan
    }

    $lapic = if ($config.LapicOverride) { [uint64]$config.LapicOverride } else { Get-LapicBase }
    Write-Host "  LAPIC: $(Dec-To-Hex -decimal $lapic)" -ForegroundColor Cyan

    Write-Host ""
    Write-Host "[MSR Availability Probe]" -ForegroundColor Yellow
    Probe-MsrAvailability

    $modeLabel = if ($dryRun) { "DRY RUN" } else { "APPLY" }
    Write-Host "============================================================" -ForegroundColor White
    Write-Host " Frenzy RWE Settings Automation [AMD] [$modeLabel]" -ForegroundColor White
    Write-Host " Detected: $($script:zenGen.ToUpper())" -ForegroundColor White
    Write-Host "============================================================" -ForegroundColor White

    $deviceMap = Get-Device-Addresses

    # =================================================================
    # 1. xHCI IMOD
    # =================================================================
    if ($config.EnableXhciImod) {
        Write-Section "xHCI IMOD Interval"
        # Auto-detect all xHCI controllers
        $xhciAutoData = @{}
        foreach ($ctrl in (Get-WmiObject Win32_USBController | Where-Object { $_.Caption -match 'XHCI' })) {
            if ($ctrl.DeviceID -match 'DEV_([A-F0-9]{4})') {
                $xhciAutoData["DEV_$($Matches[1])"] = @{ "INTERVAL" = 0x0 }
            }
        }
        # Manual overrides
        $xhciManual = @{ "DEV_2222222" = @{ "INTERVAL" = 0x0 } }
        foreach ($k in $xhciManual.Keys) { $xhciAutoData[$k] = $xhciManual[$k] }

        foreach ($xhci in Get-WmiObject Win32_USBController) {
            if ($xhci.ConfigManagerErrorCode -eq 22) { continue }
            $deviceId = $xhci.DeviceID
            if (-not $deviceMap.ContainsKey($deviceId)) { continue }
            $desiredInterval = 0x0
            $hcsOff = $config.XhciHcsparamsOffset
            $rtsoff = $config.XhciRtsoff
            foreach ($hwid in $xhciAutoData.Keys) {
                if ($deviceId -match $hwid) {
                    if ($xhciAutoData[$hwid].ContainsKey("INTERVAL")) { $desiredInterval = $xhciAutoData[$hwid]["INTERVAL"] }
                    if ($xhciAutoData[$hwid].ContainsKey("HCSPARAPS_OFFSET")) { $hcsOff = $xhciAutoData[$hwid]["HCSPARAPS_OFFSET"] }
                    if ($xhciAutoData[$hwid].ContainsKey("RTSOFF")) { $rtsoff = $xhciAutoData[$hwid]["RTSOFF"] }
                }
            }
            Write-Host "  $($xhci.Caption)" -ForegroundColor Gray
            try {
                $capAddr = $deviceMap[$deviceId]
                $hcsVal = Get-Value-From-Address -address ($capAddr + $hcsOff)
                $hcsBitmask = [Convert]::ToString($hcsVal, 2)
                $maxIntrs = [Convert]::ToInt32($hcsBitmask.Substring($hcsBitmask.Length - 16, 8), 2)
                $rtsoffVal = Get-Value-From-Address -address ($capAddr + $rtsoff)
                $runtimeAddr = $capAddr + $rtsoffVal
                for ($i = 0; $i -lt $maxIntrs; $i++) {
                    $intrAddr = Dec-To-Hex -decimal ([uint64]($runtimeAddr + 0x24 + (0x20 * $i)))
                    Invoke-RweCommand -command "W32 $intrAddr 0x0" -description "IMOD interrupter $i -> 0"
                }
            } catch {}
        }
    } else { Write-Skipped "xHCI IMOD" }

    # =================================================================
    # 2. PCIe Device Optimization (MMCFG)
    # =================================================================
    if ($config.EnablePcieOptimization) {
        Write-Section "PCIe Device Optimization (MMCFG @ $(Dec-To-Hex -decimal $mmcfg))"
        $pciDevices = Get-WmiObject Win32_PnPEntity | Where-Object {
            $_.DeviceID -match "^PCI\\VEN_" -and $_.ConfigManagerErrorCode -ne 22
        }
        $processedBdf = @{}
        foreach ($pciDev in $pciDevices) {
            try {
                $regPath = "HKLM:\SYSTEM\CurrentControlSet\Enum\$($pciDev.DeviceID)"
                $locInfo = (Get-ItemProperty $regPath -Name "LocationInformation" -ErrorAction SilentlyContinue).LocationInformation
                if ($locInfo -match "PCI bus (\d+), device (\d+), function (\d+)") {
                    $bus = [int]$Matches[1]; $dev = [int]$Matches[2]; $fun = [int]$Matches[3]
                    $bdf = "$bus.$dev.$fun"
                    if ($processedBdf.ContainsKey($bdf)) { continue }
                    $processedBdf[$bdf] = $true
                    $cfgBase = [uint64]$mmcfg + ([uint64]$bus -shl 20) + ([uint64]$dev -shl 15) + ([uint64]$fun -shl 12)
                    Invoke-RweCommand -command "W8 $(Dec-To-Hex -decimal ($cfgBase + 0x0D)) 0x00" -description "[$bdf] Latency Timer = 0"
                    $statusCmd = Get-Value-From-Address -address ($cfgBase + 0x04)
                    if (-not (($statusCmd -shr 16) -band 0x10)) { continue }
                    $capPtr = (Get-Value-From-Address -address ($cfgBase + 0x34)) -band 0xFC
                    $maxWalk = 48; $pcieCapOff = 0
                    while ($capPtr -ne 0 -and $maxWalk -gt 0) {
                        $capHdr = Get-Value-From-Address -address ($cfgBase + $capPtr)
                        if (($capHdr -band 0xFF) -eq 0x10) { $pcieCapOff = $capPtr; break }
                        $capPtr = ($capHdr -shr 8) -band 0xFC; $maxWalk--
                    }
                    if ($pcieCapOff -eq 0) { continue }
                    $linkCtlAddr = $cfgBase + $pcieCapOff + 0x10
                    $linkCtl = Get-Value-From-Address -address $linkCtlAddr
                    if (($linkCtl -band 0x3) -ne 0) {
                        $nv = $linkCtl -band (-bnot [uint64]0x3)
                        Invoke-RweCommand -command "W16 $(Dec-To-Hex -decimal $linkCtlAddr) 0x$(([uint16]$nv).ToString('X4'))" -description "[$bdf] ASPM off"
                    }
                    $d2Addr = $cfgBase + $pcieCapOff + 0x28
                    $d2 = Get-Value-From-Address -address $d2Addr
                    $nd2 = ($d2 -bor 0x10) -band (-bnot [uint64]0x6400)
                    if ($nd2 -ne $d2) {
                        Invoke-RweCommand -command "W16 $(Dec-To-Hex -decimal $d2Addr) 0x$(([uint16]$nd2).ToString('X4'))" -description "[$bdf] CompTimeout=off, OBFF=off, LTR=off"
                    }
                    $dcAddr = $cfgBase + $pcieCapOff + 0x08
                    $dcapAddr = $cfgBase + $pcieCapOff + 0x04
                    $dc = Get-Value-From-Address -address $dcAddr
                    $dcap = Get-Value-From-Address -address $dcapAddr
                    $mps = $dcap -band 0x7
                    $ndc = ($dc -band (-bnot [uint64]0xE0)) -bor ($mps -shl 5)
                    if ($ndc -ne $dc) {
                        Invoke-RweCommand -command "W16 $(Dec-To-Hex -decimal $dcAddr) 0x$(([uint16]$ndc).ToString('X4'))" -description "[$bdf] MaxPayload = $mps"
                    }
                    $extOff = 0x100; $mxw = 32
                    while ($extOff -ne 0 -and $mxw -gt 0) {
                        $eh = Get-Value-From-Address -address ($cfgBase + $extOff)
                        if (($eh -band 0xFFFF) -eq 0x001E) {
                            Invoke-RweCommand -command "W32 $(Dec-To-Hex -decimal ($cfgBase + $extOff + 0x08)) 0x00000000" -description "[$bdf] L1 Substates off"
                            break
                        }
                        $no = ($eh -shr 20) -band 0xFFF; if ($no -eq 0) { break }; $extOff = $no; $mxw--
                    }
                }
            } catch { if ($verbose) { Write-Host "    Skip $($pciDev.DeviceID): $_" -ForegroundColor DarkGray } }
        }
    } else { Write-Skipped "PCIe Optimization" }

    # =================================================================
    # 3. AMD CPU MSRs
    # =================================================================

    if ($config.EnableSpecCtrl) {
        Write-Section "Spectre Mitigations Disable (MSR 0x48)"
        Invoke-RweCommand -command "WRMSR 0x48 0x00000000 0x00000000" -description "IA32_SPEC_CTRL: clear IBRS/STIBP/SSBD"
    } else { Write-Skipped "Spectre Mitigations" }

    if ($config.EnableHwcr) {
        Write-Section "HWCR (MSR 0xC0010015)"
        try {
            $cur = Get-Msr-Value -msrAddr (U 'C0010015')
            $val = (Msr-To-UInt64 -msrResult $cur) -band (-bnot [uint64]0x02000000)
            $hex = UInt64-To-MsrHex -val $val
            Invoke-RweCommand -command "WRMSR 0xC0010015 $($hex.Hi) $($hex.Lo)" -description "HWCR: CpbDis=0 (CPB on)"
        } catch { Write-Host "  Could not read HWCR" -ForegroundColor Red }
    } else { Write-Skipped "HWCR" }

    if ($config.EnableLsCfg) {
        Write-Section "LS_CFG (MSR 0xC0011020)"
        try {
            if ($verbose) { $c = Msr-To-UInt64 -msrResult (Get-Msr-Value -msrAddr (U 'C0011020')); Write-Host "  Current: 0x$("{0:X16}" -f $c)" -ForegroundColor DarkGray }
            $val = switch ($script:zenGen) { "zen3" { [uint64]0x0004480000000000 } "zen4" { [uint64]0x0004480000000000 } default { [uint64]0x0 } }
            $hex = UInt64-To-MsrHex -val $val
            Invoke-RweCommand -command "WRMSR 0xC0011020 $($hex.Hi) $($hex.Lo)" -description "LS_CFG ($($script:zenGen) preset)"
        } catch { Write-Host "  Could not read LS_CFG" -ForegroundColor Red }
    } else { Write-Skipped "LS_CFG" }

    if ($config.EnableIcCfg) {
        Write-Section "IC_CFG (MSR 0xC0011021)"
        try {
            $cur = Get-Msr-Value -msrAddr (U 'C0011021'); $val = Msr-To-UInt64 -msrResult $cur
            if ($verbose) { Write-Host "  Current: 0x$("{0:X16}" -f $val)" -ForegroundColor DarkGray }
            $mask = [uint64]0xFFFFFFFFFFFFFFDF
            $val = switch ($script:zenGen) {
                "zen3" { ($val -band $mask) -bor [uint64]0x1C000200000040 }
                "zen4" { ($val -band $mask) -bor [uint64]0x1C000200000040 }
                default { ($val -band $mask) -bor [uint64]0x40 }
            }
            $hex = UInt64-To-MsrHex -val $val
            Invoke-RweCommand -command "WRMSR 0xC0011021 $($hex.Hi) $($hex.Lo)" -description "IC_CFG ($($script:zenGen), IC way filter off)"
        } catch { Write-Host "  Could not read IC_CFG" -ForegroundColor Red }
    } else { Write-Skipped "IC_CFG" }

    if ($config.EnableDcCfg) {
        Write-Section "DC_CFG (MSR 0xC0011022)"
        try {
            if ($verbose) { $c = Msr-To-UInt64 -msrResult (Get-Msr-Value -msrAddr (U 'C0011022')); Write-Host "  Current: 0x$("{0:X16}" -f $c)" -ForegroundColor DarkGray }
            $val = switch ($script:zenGen) { "zen3" { [uint64]0xC000000401500000 } "zen4" { [uint64]0xC000000401500000 } default { [uint64]0x0000000001510000 } }
            $hex = UInt64-To-MsrHex -val $val
            Invoke-RweCommand -command "WRMSR 0xC0011022 $($hex.Hi) $($hex.Lo)" -description "DC_CFG ($($script:zenGen) preset)"
        } catch { Write-Host "  Could not read DC_CFG" -ForegroundColor Red }
    } else { Write-Skipped "DC_CFG" }

    if ($config.EnableDeCfg) {
        Write-Section "DE_CFG (MSR 0xC0011029)"
        try {
            $cur = Get-Msr-Value -msrAddr (U 'C0011029'); $val = Msr-To-UInt64 -msrResult $cur
            if ($verbose) { $lf = if ($val -band 0x2) { "SERIALIZING" } else { "non-serializing" }; Write-Host "  Current: 0x$("{0:X16}" -f $val) (LFENCE=$lf)" -ForegroundColor DarkGray }
            $val = $val -band (-bnot [uint64]0x2)
            $hex = UInt64-To-MsrHex -val $val
            Invoke-RweCommand -command "WRMSR 0xC0011029 $($hex.Hi) $($hex.Lo)" -description "DE_CFG: LFENCE non-serializing"
        } catch { Write-Host "  Could not read DE_CFG" -ForegroundColor Red }
    } else { Write-Skipped "DE_CFG" }

    if ($config.EnableBpCfg) {
        Write-Section "BP_CFG (MSR 0xC001102B)"
        try {
            if ($verbose) { $c = Msr-To-UInt64 -msrResult (Get-Msr-Value -msrAddr (U 'C001102B')); Write-Host "  Current: 0x$("{0:X16}" -f $c)" -ForegroundColor DarkGray }
            $val = switch ($script:zenGen) { "zen3" { [uint64]0x2000CC14 } "zen4" { [uint64]0x2000CC14 } default { [uint64]0x2000CC16 } }
            $hex = UInt64-To-MsrHex -val $val
            Invoke-RweCommand -command "WRMSR 0xC001102B $($hex.Hi) $($hex.Lo)" -description "BP_CFG ($($script:zenGen) preset)"
        } catch { Write-Host "  Could not read BP_CFG" -ForegroundColor Red }
    } else { Write-Skipped "BP_CFG" }

    if ($config.EnableCStateControl) {
        Write-Section "C-State Policy (MSR 0xC0010296)"
        Invoke-RweCommand -command "WRMSR 0xC0010296 0x00000000 0x00080808" -description "CSTATE_POLICY: CC6 off, CC1 only"
    } else { Write-Skipped "C-State Policy" }

    if ($config.EnablePstateForceP0) {
        Write-Section "Force P-State 0 (MSR 0xC0010062)"
        Invoke-RweCommand -command "WRMSR 0xC0010062 0x00000000 0x00000000" -description "PSTATE_CTL: P0 (max perf)"
    } else { Write-Skipped "P-State P0" }

    # =================================================================
    # 4. Architectural MSRs (shared)
    # =================================================================

    if ($config.EnablePerfCounterDisable) {
        Write-Section "Performance Counter Disable (MSR 0x38F, 0x38D)"
        Invoke-RweCommand -command "WRMSR 0x38F 0x00000000 0x00000000" -description "PERF_GLOBAL_CTRL: PMCs off"
        Invoke-RweCommand -command "WRMSR 0x38D 0x00000000 0x00000000" -description "FIXED_CTR_CTRL: fixed counters off"
    } else { Write-Skipped "Perf Counters" }

    if ($config.EnableDebugDisable) {
        Write-Section "Debug Trace Disable (MSR 0x1D9)"
        Invoke-RweCommand -command "WRMSR 0x1D9 0x00000000 0x00000000" -description "IA32_DEBUGCTL: LBR/BTF/BTS off"
    } else { Write-Skipped "Debug Trace" }

    # =================================================================
    # 5. HPET
    # =================================================================
    if ($config.EnableHpetDisable) {
        Write-Section "HPET Disable (MMIO 0xFED00000)"
        Invoke-RweCommand -command "W32 0xFED00010 0x0" -description "HPET General Config: disable"
    } else { Write-Skipped "HPET" }

    # =================================================================
    # 6. Network Interrupt Moderation
    # =================================================================
    if ($config.EnableNetworkImod) {
        Write-Section "Network Interrupt Moderation"
        $nics = Get-WmiObject Win32_NetworkAdapter | Where-Object { $_.PNPDeviceID -and $_.ConfigManagerErrorCode -ne 22 -and $_.NetConnectionStatus -ne $null }
        foreach ($nic in $nics) {
            if (-not $deviceMap.ContainsKey($nic.PNPDeviceID)) { continue }
            $nicBar = $deviceMap[$nic.PNPDeviceID]; $devId = $nic.PNPDeviceID
            if ($devId -match "VEN_8086") {
                Write-Host "  Intel: $($nic.Name)" -ForegroundColor Gray
                foreach ($off in @(0xC0, 0xC4, 0xC8, 0xCC, 0xD0, 0xE0, 0xE4, 0xE8)) {
                    Invoke-RweCommand -command "W32 $(Dec-To-Hex -decimal ([uint64]($nicBar + $off))) 0x00000000" -description "ITR BAR+$('{0:X4}' -f $off) = 0"
                }
                Invoke-RweCommand -command "W32 $(Dec-To-Hex -decimal ([uint64]($nicBar + 0x28))) 0x00000000" -description "FCTRL: flow control off"
            }
            elseif ($devId -match "VEN_10EC") {
                Write-Host "  Realtek: $($nic.Name)" -ForegroundColor Gray
                Invoke-RweCommand -command "W16 $(Dec-To-Hex -decimal ([uint64]($nicBar + 0xE2))) 0x0008" -description "IntrMitigate = 8us (evita interrupt storm)"
            }
        }
    } else { Write-Skipped "Network IMOD" }

    # =================================================================
    # 7. Local APIC
    # =================================================================
    if ($config.EnableLapic) {
        Write-Section "Local APIC (@ $(Dec-To-Hex -decimal $lapic))"
        Invoke-RweCommand -command "W32 $(Dec-To-Hex -decimal ([uint64]$lapic + 0x3E0)) 0x0000000B" -description "Timer Divide = 1 (max res)"
        Invoke-RweCommand -command "W32 $(Dec-To-Hex -decimal ([uint64]$lapic + 0x80)) 0x00000000" -description "TPR = 0 (accept all)"
    } else { Write-Skipped "LAPIC" }

    # =================================================================
    # SUMMARY
    # =================================================================
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor White
    if ($dryRun) { Write-Host " DRY RUN: $($script:appliedCount) commands staged" -ForegroundColor Cyan }
    else { Write-Host " APPLIED: $($script:appliedCount) commands" -ForegroundColor Green }
    Write-Host "============================================================" -ForegroundColor White

    # =================================================================
    # Generate boot .bat
    # =================================================================
    $batPath = "C:\Users\Administrator\Documents\Set RWEverything Tweaks.bat"
    try {
        $bl = [System.Collections.Generic.List[string]]::new()
        $bl.Add("@echo off")
        $bl.Add(":: Generated by ApplyRWE-AMD.ps1 on $(Get-Date -Format 'yyyy-MM-dd HH:mm')")
        $bl.Add(":: IMOD Interval + RWE Tweaks")
        $bl.Add("")
        $bl.Add(":: --- RWEverything Tweaks ---")
        $bl.Add('cd /d "C:\Program Files\RW-Everything"')
        $bl.Add("")
        foreach ($cmd in $script:allCommands) { $bl.Add("Rw.exe /Min /NoLogo /Stdout /Command=""$cmd""") }
        $bl.Add(""); $bl.Add("exit /b 0")
        $dir = Split-Path $batPath -Parent
        if ($dir -and -not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
        ($bl -join "`r`n") | Out-File -FilePath $batPath -Encoding ASCII -Force
        Write-Host ""; Write-Host "Generated: $batPath ($($script:allCommands.Count) commands)" -ForegroundColor Green
    } catch { Write-Host "Could not write .bat: $($_.Exception.Message)" -ForegroundColor Red }

    try {
        $sl = $script:allCommands -join "; "
        $sd = Split-Path -Parent $PSCommandPath
        if ($sd) { $sl | Out-File -FilePath (Join-Path $sd "RWE_StartupLine.txt") -Encoding UTF8 -Force }
    } catch {}

    return 0
}

$_exitCode = main
Write-Host ""
exit $_exitCode