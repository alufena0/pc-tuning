$script:firstSection = $true
function Write-Section {
    param($title)
    if (-not $script:firstSection) { Write-Host "" }
    Write-Host "==== $title ===="
    $script:firstSection = $false
}

function Write-Trimmed {
    param($string)
    $s = $string.ToString().TrimEnd()
    if ($s -ne "") { Write-Host $s } else { Write-Host $s }
}

# elevation warning
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) { Write-Host "WARNING: Not elevated. Some checks may fail." -ForegroundColor Yellow }

Write-Section "TCP SETTINGS (templates & congestion providers)"
if (Get-Command Get-NetTCPSetting -ErrorAction SilentlyContinue) {
    try {
        $out = Get-NetTCPSetting | Select-Object SettingName, CongestionProvider | Format-Table -AutoSize | Out-String
        Write-Trimmed $out
    } catch { Write-Host "Get-NetTCPSetting failed: $($_.Exception.Message)" }
} else { Write-Host "Get-NetTCPSetting not available in this session." }

Write-Section "NETWORK ADAPTERS (safe fallback)"
try {
    $out = Get-CimInstance -Namespace "root/standardcimv2" -ClassName "MSFT_NetAdapter" -ErrorAction Stop |
        Select-Object ifIndex, Name, InterfaceDescription, LinkSpeed, Status, DriverVersion | Format-Table -AutoSize | Out-String
    Write-Trimmed $out
} catch {
    Write-Host "MSFT_NetAdapter/CIM query failed: $($_.Exception.Message)"
    try {
        $out = Get-WmiObject -Class Win32_NetworkAdapter | Where-Object { $_.NetConnectionStatus -ne $null } |
            Select-Object DeviceID, Name, NetConnectionID, NetConnectionStatus, Manufacturer | Format-Table -AutoSize | Out-String
        Write-Trimmed $out
    } catch { Write-Host "Win32_NetworkAdapter fallback failed: $($_.Exception.Message)" }
}

Write-Section "GET-MMAGENT (all properties)"
if (Get-Command Get-MMAgent -ErrorAction SilentlyContinue) {
    try {
        $out = Get-MMAgent -ErrorAction Stop | Select-Object * | Format-List -Force | Out-String
        Write-Trimmed $out
    } catch { Write-Host "Get-MMAgent failed: $($_.Exception.Message)" }
} else { Write-Host "Get-MMAgent not present in this session." }

Write-Section "FIREWALL (profiles)"
if (Get-Command Get-NetFirewallProfile -ErrorAction SilentlyContinue) {
    try {
        $out = Get-NetFirewallProfile | Select-Object Name, Enabled, DefaultInboundAction, DefaultOutboundAction | Format-Table -AutoSize | Out-String
        Write-Trimmed $out
        $profiles = Get-NetFirewallProfile
        $enabledCount = ($profiles | Where-Object { $_.Enabled -eq $true } | Measure-Object).Count
        if ($enabledCount -eq $profiles.Count) { Write-Host "Overall firewall: OK (all profiles enabled)" -ForegroundColor Green }
        else { Write-Host "Overall firewall: NOT OK (some profiles disabled)" -ForegroundColor Red }
    } catch { Write-Host "Firewall query failed: $($_.Exception.Message)" }
} else { Write-Host "Get-NetFirewallProfile not available in this session." }

Write-Section "WINDOWS DEFENDER / ANTIVIRUS"
if (Get-Command Get-MpComputerStatus -ErrorAction SilentlyContinue) {
    try {
        $out = Get-MpComputerStatus | Select-Object * | Format-List | Out-String
        Write-Trimmed $out
    } catch { Write-Host "Get-MpComputerStatus failed: $($_.Exception.Message)" }
} else {
    Write-Host "Get-MpComputerStatus not present. Defender may be removed or module missing."
    try {
        $out = Get-Service -Name WinDefend -ErrorAction Stop | Select-Object Name, Status, StartType | Format-List | Out-String
        Write-Trimmed $out
    } catch { Write-Host "WinDefend service not found." }
    try {
        $out = Get-CimInstance -Namespace "root/SecurityCenter2" -ClassName "AntiVirusProduct" -ErrorAction Stop |
            Select-Object displayName, productState, pathToSignedProductExe | Format-Table -AutoSize | Out-String
        Write-Trimmed $out
    } catch { Write-Host "SecurityCenter2 query failed or no AV registered: $($_.Exception.Message)" }
}

Write-Section "LOGMAN (trace sessions)"
try {
    $out = logman query -ets 2>&1 | Out-String
    Write-Trimmed $out
} catch { Write-Host "logman query failed: $($_.Exception.Message)" }

Read-Host -Prompt "Press Enter to exit"
