# ============================================================================
# USAGE: 1) Run this script; 2) run it again immediately, without rebooting;
#        3) import the companion REG file; 4) reboot once.
# The first pass creates device subkeys (Device Parameters\PCI, \WDF, and the
# device-specific GUID subkey); Power/WMI values are applied on the second pass.
# Additional passes are harmless. Fixed Services/Control values belong in the
# companion REG file and are intentionally not written by this script.
# ============================================================================

# ============================================================================
# CONSOLIDATED SYSTEM TWEAKS
# No #Requires/elevation gate is used; the caller is responsible for running
# this script in the required Administrator context.
#
# Display scaling is intentionally handled separately.
# Duplicate ACPI/HAL enumeration material is retained only as audit documentation;
# the consolidated implementation performs the effective sweep once.
#
# Consolidation rules:
#   - one shared registry writer is used for DWORD writes;
#   - identical path/value writes are skipped after the first successful write;
#   - conflicting values are not skipped: later sections overwrite earlier ones,
#     preserving the documented precedence order;
#   - entries are not removed merely because another section uses the same name;
#     distinct maps remain documented, while the cache avoids redundant writes.
#
# Execution order: ENUM_MISC -> INPUT_AUDIO -> STORAGE_KERNEL -> USB.
# The USB section runs last so its final overlay takes precedence where documented
# configuration sections target the same path with conflicting values.
# ============================================================================

$ErrorActionPreference = 'SilentlyContinue'
$script:WriteCache = @{}

function Ensure-Key([string]$Path) {
    if (Test-Path -LiteralPath $Path) { return $true }
    try { New-Item -Path $Path -Force | Out-Null; return $true } catch { return $false }
}

function Set-Dword([string]$Path, [string]$Name, [object]$Value, [string]$Type = 'DWord') {
    if (-not (Ensure-Key $Path)) { return }
    $cacheKey = ($Path.TrimEnd('\') + [char]0 + $Name.ToLowerInvariant())
    $desired = $Type + '|' + [string]$Value
    if ($script:WriteCache.ContainsKey($cacheKey) -and $script:WriteCache[$cacheKey] -eq $desired) { return }
    try {
        New-ItemProperty -LiteralPath $Path -Name $Name -Value $Value -PropertyType $Type -Force | Out-Null
        $script:WriteCache[$cacheKey] = $desired
    } catch {}
}

# -Skip: value names that must not be written to this destination. This preserves
# a losing conflict variant as an audit comment while the winning value is applied.
function Apply-Map([string]$Path, [object]$Map, [string[]]$Skip = @()) {
    if (-not (Ensure-Key $Path)) { return }
    if ($Map -is [System.Collections.IDictionary]) {
        foreach ($kv in $Map.GetEnumerator()) {
            if ($Skip -contains $kv.Key) { continue }
            Set-Dword $Path $kv.Key $kv.Value
        }
    } else {
        foreach ($e in @($Map)) {
            if ($null -ne $e -and $null -ne $e.Name) {
                if ($Skip -contains $e.Name) { continue }
                Set-Dword $Path $e.Name $e.Value
            }
        }
    }
}

# ============================================================================
# CONFIGURATION DEFINITIONS
# ============================================================================

# ---------------- INPUT_AUDIO section ----------------
# Input and audio device configuration.
#
# Dynamic targets include device-class instances and enumerated devices under:
#   Control\Class\...\000x
#   Enum\HDAUDIO\...
#   Enum\HID\...
#   Enum\USB\...
#
# Fixed service and class-driver paths are handled by the companion REG file.
# Reboot after applying the script and its companion REG settings.


# ============================================================================
# HELPERS
# ============================================================================

function Words([string]$Text) {
  $Text -split '\s+' | Where-Object { $_ }
}

function New-DwordSet(
  [string[]]$Zero,
  [string[]]$One,
  [hashtable]$Other = @{}
) {
  $set = @{}

  foreach ($name in $Zero) {
    $set[$name] = 0
  }

  foreach ($name in $One) {
    $set[$name] = 1
  }

  foreach ($name in $Other.Keys) {
    $set[$name] = $Other[$name]
  }

  $set
}

function Set-Dwords(
  [string]$Path,
  [hashtable]$Values
) {
  foreach ($name in $Values.Keys) {
    Set-Dword $Path $name $Values[$name]
  }
}

# ============================================================================
# SHARED SUBKEYS
# ============================================================================

# Shared Power block for instance-level and recursively processed device nodes.
# It is applied to each node's Power subkey.
$PowerSub = New-DwordSet `
  -Zero (
  (Words '
        IdleTimeout
        ConservationTimeout
        PerformanceTimeout
        WakeEnabled
        DeviceWake
        SystemWake
        PerformanceState
    ') +
    (0..3 | ForEach-Object {
        "TransitionLatencyD$_"
        "LatencyToleranceD$_"
        "WakeFromD$_"
      }) +
    (1..3 | ForEach-Object {
        "DeviceD$_"
      })
  ) `
    -One (Words '
          DisableAllD3
      ')

$WmiSet = New-DwordSet `
  -Zero (Words '
        IdleEnabled
        IdleTimeout
    ') `
  -One @()

$PciSet = New-DwordSet `
  -Zero (Words '
        ASPM
        L0sLatency
        L1Latency
        EnableASPM
        L0sSupported
        L1Supported
        ClockPowerManagement
        CommonClockConfig
    ') `
  -One (Words '
        ASPMOptOut
        NoASPM
        DisableASPM
    ')

# Specialized Power block for audio-class Device Parameters\Power.
# This intentionally differs from $PowerSub.
$AudioClassDevicePowerSet = New-DwordSet `
  -Zero (Words '
        IdleTimeout
        ConservationTimeout
        PerformanceTimeout
        WakeEnabled
        DeviceWake
        SystemWake
    ') `
  -One (Words '
        DisableAllD3
    ')

# ============================================================================
# RECURSIVE NODE PROCESSORS
# ============================================================================

# Recursive node-processing behavior:
#
# 1. Apply the node's own value set.
# 2. Create/update node\Power with $PowerSub.
# 3. Create/update node\WMI with $WmiSet.
# 4. Recurse into ordinary descendants.
# 5. Do NOT recurse into Power, WMI or Properties.
function Process-Node(
  [string]$Path,
  [hashtable]$Values
) {
  Set-Dwords $Path $Values

  Set-Dwords `
    (Join-Path $Path 'Power') `
    $PowerSub

  Set-Dwords `
    (Join-Path $Path 'WMI') `
    $WmiSet

  foreach ($child in Get-ChildItem -LiteralPath $Path) {
    if ($child.PSChildName -in 'Power', 'WMI', 'Properties') {
      continue
    }

    Process-Node $child.PSPath $Values
  }
}

# The direct HID Device Parameters key receives one additional value:
#
#   Device Parameters\IdleUsbInSelectiveSuspend = 0
#
# That value is NOT propagated into descendants.
function Process-HidDeviceParameters(
  [string]$Path
) {
  Set-Dwords $Path $HidDirectSet

  Set-Dwords `
    (Join-Path $Path 'Power') `
    $PowerSub

  Set-Dwords `
    (Join-Path $Path 'WMI') `
    $WmiSet

  foreach ($child in Get-ChildItem -LiteralPath $Path) {
    if ($child.PSChildName -in 'Power', 'WMI', 'Properties') {
      continue
    }

    Process-Node $child.PSPath $HidSet
  }
}

# ---------------- ENUM_MISC section -------------------
# ============================================================================
# ACPI and ACPI_HAL device configuration.
#
# Architecture:
#   - Effective targets are discovered dynamically under enumerated ACPI and
#     ACPI_HAL device instances and their Device Parameters/WMI/Power subkeys.
#   - The companion REG file contains no active entries for these instance-only
#     destinations because their paths depend on the devices present on the system.
#   - Shared value blocks are applied through common maps and functions.
#   - ACPI conditional matching is preserved, including overlapping matches.
#   - ACPI_HAL timer, C-state, APIC, DMA, P-state, and NUMA blocks remain unconditional.
#   - An unused device enumeration is omitted because it performs no writes and
#     does not affect the selected targets or applied settings.
#
# Redundant identical writes are documented separately rather than executed
# multiple times.
# ============================================================================

# ============================================================================
# SHARED BLOCKS — common values used by ACPI and ACPI_HAL
# ============================================================================
$commonDeviceParameters = [ordered]@{
    EnhancedPowerManagementEnabled   = 0
    AllowIdleIrpInD3                 = 0
    DeviceSelectiveSuspended         = 0
    SelectiveSuspendEnabled          = 0
    IdleInWorkingState               = 0
    WakeEnabled                      = 0
    WdfDirectedPowerTransitionEnable = 0
    EnableSelectiveSuspend           = 0
    D3ColdSupported                  = 0
    DisableSelectiveSuspend          = 1
    WaitWakeEnabled                  = 0
    EnablePME                        = 0
    EnableRuntimePM                  = 0
    RuntimePMOnIdle                  = 0
    RuntimeD3                        = 0
    RuntimeD3Cold                    = 0
    D3TransitionLatency              = 0
    D0TransitionLatency              = 0
    D1Latency                        = 0
    D2Latency                        = 0
    D3Latency                        = 0
    EnableLPM                        = 0
    EnablePCI_PM                     = 0
    EnablePCIPME                     = 0
    PMControl                        = 0
    DisableRuntimePowerManagement    = 1
    EnableAggressivePM               = 0
    EnableConnectedStandby           = 0
    ModernStandbyEnable              = 0
    CsEnabled                        = 0
    PlatformAoAcOverride             = 0
    EnableSmartD3                    = 0
    SmartD3Enable                    = 0
    DisableLinkPowerManagement       = 1
    DisableIdlePowerManagement       = 1
    DisableRuntimeIdleDetection      = 1
    DisableAsyncSuspend              = 1
    DisableWake                      = 1
    SystemWake                       = 0
    DeviceWake                       = 0
    IoHighPriority                   = 1
    IoLatencyCap                     = 0
    DevicePriority                   = 3
    InterruptModeration              = 0
    InterruptModerationValue         = 0
    DisableHwInterruptCoalescing     = 1
    DisableCompletionCoalescing      = 1
    IdlePowerState                   = 0
    LatencyToleranceHigh             = 0
    LatencyToleranceLow              = 0
    BestEffortServiceLatency         = 0
    LinkStateChangeLatency           = 0
    DisableDynamicTickForIdleWorker  = 1
    IdleTimeout                      = 0
    ConservationIdleTime             = 0
    PerformanceIdleTime              = 0
}

$commonWmi = [ordered]@{
    IdleEnabled = 0
    IdleTimeout = 0
}

$commonPower = [ordered]@{
    IdleTimeout         = 0
    ConservationTimeout = 0
    PerformanceTimeout  = 0
    WakeEnabled         = 0
    DeviceWake          = 0
    SystemWake          = 0
    DisableAllD3        = 1
    PerformanceState    = 0
    TransitionLatencyD0 = 0
    TransitionLatencyD1 = 0
    TransitionLatencyD2 = 0
    TransitionLatencyD3 = 0
    LatencyToleranceD0  = 0
    LatencyToleranceD1  = 0
    LatencyToleranceD2  = 0
    LatencyToleranceD3  = 0
    WakeFromD0          = 0
    WakeFromD1          = 0
    WakeFromD2          = 0
    WakeFromD3          = 0
    DeviceD1            = 0
    DeviceD2            = 0
    DeviceD3            = 0
}

function Apply-CommonBlocks([string]$DeviceParametersPath) {
    foreach ($kv in $commonDeviceParameters.GetEnumerator()) {
        Set-Dword $DeviceParametersPath $kv.Key $kv.Value
    }
    $wmi = Join-Path $DeviceParametersPath "WMI"
    foreach ($kv in $commonWmi.GetEnumerator()) {
        Set-Dword $wmi $kv.Key $kv.Value
    }
    $power = Join-Path $DeviceParametersPath "Power"
    foreach ($kv in $commonPower.GetEnumerator()) {
        Set-Dword $power $kv.Key $kv.Value
    }
}

$acpiThermalMap = [ordered]@{
    PassiveTripPoint          = 127
    ActiveTripPoint           = 127
    CriticalTripPoint         = 127
    SamplingPeriod            = 0
    ThermalStandbyTemperature = 127
    DisablePassiveCooling     = 1
    DisableActiveCooling      = 1
    ThermalThrottling         = 0
    DPTF                      = 0
    EnableDPTF                = 0
    DisableDPTF               = 1
    DisableThermalThrottling  = 1
    PollingInterval           = 0
    ThermalPollingInterval    = 0
    DisableThermalPolling     = 1
}

$acpiCpuMap = [ordered]@{
    PerfBoostMode         = 2
    CpuIdleDisable        = 1
    DisableCStates        = 1
    DisableC1E            = 1
    DisableC3             = 1
    DisableC6             = 1
    Latency               = 0
    DemotePercent         = 0
    PromotePercent        = 0
    TimeCheck             = 0
    IdleDisable           = 1
    ParkingPolicy         = 0
    DistributeUtility     = 1
    DisableParkMode       = 1
    MaxThrottling         = 0
    MinThrottling         = 100
    PerfDecreasePolicy    = 1
    PerfIncreasePolicy    = 2
    PerfDecreaseThreshold = 10
    PerfIncreaseThreshold = 10
}

$acpiTimerMap = [ordered]@{
    DisableDynamicTick = 1
    AlwaysOnTimer      = 1
    HighResTimerMode   = 1
    TimerResolution    = 5000
    UseHighPerfTimer   = 1
    UsePlatformClock   = 0
    UseRdtsc           = 1
}

$acpiBatteryMap = [ordered]@{
    IdleTimeout           = 0
    PollingInterval       = 0
    DisableBatteryPolling = 1
}

$acpiButtonMap = [ordered]@{
    WakeEnabled = 0
    SystemWake  = 0
    DeviceWake  = 0
    DisableWake = 1
}

$acpiEcMap = [ordered]@{
    PollingInterval = 0
    BurstMode       = 1
    DisablePolling  = 1
}

$halTimerMap = [ordered]@{
    DisableDynamicTick = 1
    AlwaysOnTimer      = 1
    HighResTimerMode   = 1
    TimerResolution    = 5000
    UseHighPerfTimer   = 1
    UsePlatformClock   = 0
    UseRdtsc           = 1
    UseTscInvariant    = 1
    PreferTsc          = 1
    TscSyncPolicy      = 2
    DisableHpet        = 1
    HpetEnabled        = 0
    UseSyntheticTimers = 0
}

$halCstateMap = [ordered]@{
    DisableCStates = 1
    DisableC1E     = 1
    DisableC3      = 1
    DisableC6      = 1
    DisableC7      = 1
    DisableC8      = 1
    DisableC9      = 1
    DisableC10     = 1
    MaxCState      = 0
    CStateEnable   = 0
    CpuIdleDisable = 1
    IdleDisable    = 1
    Latency        = 0
}

$halApicMap = [ordered]@{
    InterruptRouting                 = 1
    DisableApicClusterMode           = 1
    ForceApicPhysicalDestinationMode = 1
    UseApicForIpi                    = 1
    ApicMode                         = 1
    EnableX2Apic                     = 1
    DisableInterruptCoalescing       = 1
    InterruptSteeringMode            = 0
    SpreadSpectrumClocking           = 0
}

$halDmaMap = [ordered]@{
    DmaRemappingCompatible = 0
    DmaMaxTransferSize     = 262144
    DisableIommu           = 0
}

$halPstateMap = [ordered]@{
    MaxPState         = 0
    MinPState         = 0
    DisablePStates    = 0
    TurboMode         = 1
    EnableTurboBoost  = 1
    PerfBoostMode     = 2
    MaxThrottling     = 0
    DisableThrottling = 1
    HwPStateEnable    = 1
    AutonomousMode    = 1
}

$halNumaMap = [ordered]@{
    DisableNuma       = 0
    NumaNodeCount     = 0
    ForcePhysicalMode = 1
}

# ============================================================================
# ACPI CONDITIONAL LOGIC
# ============================================================================
function Apply-AcpiConditionals([string]$DeviceId, [string]$DeviceParametersPath) {
    if ($DeviceId -match "ACPI0007|INT3401|INT3400|ThermalZone|THRM|LNXTHERM") {
        foreach ($kv in $acpiThermalMap.GetEnumerator()) { Set-Dword $DeviceParametersPath $kv.Key $kv.Value }
        Write-Host "  (thermal tuned)" -ForegroundColor DarkCyan
    }
    if ($DeviceId -match "ACPI0007|GenuineIntel|AuthenticAMD|ACPI0010") {
        foreach ($kv in $acpiCpuMap.GetEnumerator()) { Set-Dword $DeviceParametersPath $kv.Key $kv.Value }
        Write-Host "  (cpu tuned)" -ForegroundColor DarkCyan
    }
    if ($DeviceId -match "PNP0100|PNP0103|ACPI000E|PNP0B00") {
        foreach ($kv in $acpiTimerMap.GetEnumerator()) { Set-Dword $DeviceParametersPath $kv.Key $kv.Value }
        Write-Host "  (timer tuned)" -ForegroundColor DarkCyan
    }
    if ($DeviceId -match "PNP0C0A|ACPI0002|PNP0C09") {
        # IdleTimeout=0 already belongs to the shared common block; only the
        # unique conditional values remain here.
        Set-Dword $DeviceParametersPath "PollingInterval" 0
        Set-Dword $DeviceParametersPath "DisableBatteryPolling" 1
        Write-Host "  (battery tuned)" -ForegroundColor DarkCyan
    }
    # Button wake settings are already covered by the shared common block:
    # WakeEnabled=0, SystemWake=0, DeviceWake=0, DisableWake=1.
    # No additional write is needed for this condition.
    if ($DeviceId -match "PNP0C0C|PNP0C0D|PNP0C0E|PNP0C4C") {
        Write-Host "  (button tuned)" -ForegroundColor DarkCyan
    }
    if ($DeviceId -match "PNP0C09|ACPI000C") {
        # PollingInterval=0 may already have been written by Battery or Thermal;
        # it is the same value everywhere and remains explicitly conditional.
        Set-Dword $DeviceParametersPath "PollingInterval" 0
        Set-Dword $DeviceParametersPath "BurstMode" 1
        Set-Dword $DeviceParametersPath "DisablePolling" 1
        Write-Host "  (EC tuned)" -ForegroundColor DarkCyan
    }
}

# ---------------- STORAGE_KERNEL section -------------------
# ============================================================
# Storage and kernel configuration.
# Device-instance enumeration remains in this script; fixed registry values are
# handled by the companion REG file. Conflicting and superseded variants are
# retained as commented audit notes so their values and precedence remain visible.
# ============================================================


$PciPowerBlock = @(
    @{ Name = 'EnhancedPowerManagementEnabled'; Value = 0 }
    @{ Name = 'AllowIdleIrpInD3'; Value = 0 }
    @{ Name = 'DeviceSelectiveSuspended'; Value = 0 }
    @{ Name = 'SelectiveSuspendEnabled'; Value = 0 }
    @{ Name = 'SelectiveSuspendOn'; Value = 0 }
    @{ Name = 'IdleInWorkingState'; Value = 0 }
    @{ Name = 'WakeEnabled'; Value = 0 }
    @{ Name = 'WdfDirectedPowerTransitionEnable'; Value = 0 }
    @{ Name = 'EnableSelectiveSuspend'; Value = 0 }
    @{ Name = 'D3ColdSupported'; Value = 0 }
    @{ Name = 'DisableSelectiveSuspend'; Value = 1 }
    @{ Name = 'WaitWakeEnabled'; Value = 0 }
    @{ Name = 'EnablePME'; Value = 0 }
    @{ Name = 'EnableRuntimePM'; Value = 0 }
    @{ Name = 'RuntimePMOnIdle'; Value = 0 }
    @{ Name = 'RuntimeD3'; Value = 0 }
    @{ Name = 'RuntimeD3Cold'; Value = 0 }
    @{ Name = 'D3TransitionLatency'; Value = 0 }
    @{ Name = 'D0TransitionLatency'; Value = 0 }
    @{ Name = 'D1Latency'; Value = 0 }
    @{ Name = 'D2Latency'; Value = 0 }
    @{ Name = 'D3Latency'; Value = 0 }
    @{ Name = 'EnableLPM'; Value = 0 }
    @{ Name = 'LPMCapabilitySupported'; Value = 0 }
    @{ Name = 'LPMExitLatency'; Value = 0 }
    @{ Name = 'EnablePCI_PM'; Value = 0 }
    @{ Name = 'EnablePCIPME'; Value = 0 }
    @{ Name = 'PMControl'; Value = 0 }
    @{ Name = 'DisableRuntimePowerManagement'; Value = 1 }
    @{ Name = 'EnableAggressivePM'; Value = 0 }
    @{ Name = 'EnableConnectedStandby'; Value = 0 }
    @{ Name = 'ModernStandbyEnable'; Value = 0 }
    @{ Name = 'CsEnabled'; Value = 0 }
    @{ Name = 'PlatformAoAcOverride'; Value = 0 }
    @{ Name = 'EnableSmartD3'; Value = 0 }
    @{ Name = 'SmartD3Enable'; Value = 0 }
    @{ Name = 'DisableLinkPowerManagement'; Value = 1 }
    @{ Name = 'DisableIdlePowerManagement'; Value = 1 }
    @{ Name = 'DisableRuntimeIdleDetection'; Value = 1 }
    @{ Name = 'DisableAsyncSuspend'; Value = 1 }
    @{ Name = 'DisableWake'; Value = 1 }
    @{ Name = 'WakeFromSleepEnabled'; Value = 0 }
    @{ Name = 'WakeOnPatternMatch'; Value = 0 }
    @{ Name = 'EnablePMWake'; Value = 0 }
    @{ Name = 'PMEWakeEnabled'; Value = 0 }
    @{ Name = 'SystemWake'; Value = 0 }
    @{ Name = 'DeviceWake'; Value = 0 }
    @{ Name = 'IoHighPriority'; Value = 1 }
    @{ Name = 'IoLatencyCap'; Value = 0 }
    @{ Name = 'DevicePriority'; Value = 3 }
    @{ Name = 'InterruptModeration'; Value = 0 }
    @{ Name = 'InterruptModerationValue'; Value = 0 }
    @{ Name = 'DisableHwInterruptCoalescing'; Value = 1 }
    @{ Name = 'DisableCompletionCoalescing'; Value = 1 }
    @{ Name = 'IdlePowerState'; Value = 0 }
    @{ Name = 'LatencyToleranceHigh'; Value = 0 }
    @{ Name = 'LatencyToleranceLow'; Value = 0 }
    @{ Name = 'BestEffortServiceLatency'; Value = 0 }
    @{ Name = 'LinkStateChangeLatency'; Value = 0 }
    @{ Name = 'DisableDynamicTickForIdleWorker'; Value = 1 }
    @{ Name = 'IdleTimeout'; Value = 0 }
    @{ Name = 'ConservationIdleTime'; Value = 0 }
    @{ Name = 'PerformanceIdleTime'; Value = 0 }
    @{ Name = 'SurpriseRemovalOK'; Value = 0 }
    @{ Name = 'DisablePowerSave'; Value = 1 }
    @{ Name = 'PowerSaveMode'; Value = 0 }
    @{ Name = 'DisableDeviceSleep'; Value = 1 }
    @{ Name = 'DeviceSleepEnabled'; Value = 0 }
    @{ Name = 'EnableDeviceSleep'; Value = 0 }
    @{ Name = 'EnableLowPowerState'; Value = 0 }
    @{ Name = 'DmaRemappingCompatible'; Value = 0 }
    @{ Name = 'ReducedLatency'; Value = 1 }
    @{ Name = 'LowLatencyMode'; Value = 1 }
    @{ Name = 'DisableBusMasterOnSuspend'; Value = 1 }
    @{ Name = 'DisablePortSuspend'; Value = 1 }
)

$PciExpressBlock = @(
    @{ Name = 'ASPMOptOut'; Value = 1 }
    @{ Name = 'NoASPM'; Value = 1 }
    @{ Name = 'DisableASPM'; Value = 1 }
    @{ Name = 'ASPM'; Value = 0 }
    @{ Name = 'EnableASPM'; Value = 0 }
    @{ Name = 'L0sLatency'; Value = 0 }
    @{ Name = 'L1Latency'; Value = 0 }
    @{ Name = 'L0sSupported'; Value = 0 }
    @{ Name = 'L1Supported'; Value = 0 }
    @{ Name = 'L1SubstatesSupported'; Value = 0 }
    @{ Name = 'L1PmSubstates'; Value = 0 }
    @{ Name = 'L1PMSubstatesEnable'; Value = 0 }
    @{ Name = 'L1ssControl1'; Value = 0 }
    @{ Name = 'L1ssControl2'; Value = 0 }
    @{ Name = 'ClockPowerManagement'; Value = 0 }
    @{ Name = 'CommonClockConfig'; Value = 0 }
    @{ Name = 'SpreadSpectrumClocking'; Value = 0 }
    @{ Name = 'MaxPayloadSize'; Value = 512 }
    @{ Name = 'MaxReadRequestSize'; Value = 512 }
    @{ Name = 'ExtendedTagEnable'; Value = 1 }
    @{ Name = 'NoExtendedConfigSpace'; Value = 0 }
    @{ Name = 'RelaxedOrdering'; Value = 1 }
    @{ Name = 'NoSnoop'; Value = 1 }
    @{ Name = 'EnableMRRS'; Value = 1 }
    @{ Name = 'EnableMaxPayloadSize'; Value = 1 }
    @{ Name = 'CompletionTimeout'; Value = 0 }
    @{ Name = 'AcsEnable'; Value = 0 }
    @{ Name = 'AriEnable'; Value = 1 }
    @{ Name = 'AtomicOpRequester'; Value = 1 }
    @{ Name = 'LtrEnable'; Value = 0 }
    @{ Name = 'LtrMaxSnoopLatency'; Value = 0 }
    @{ Name = 'LtrMaxNoSnoopLatency'; Value = 0 }
    @{ Name = 'ObffEnable'; Value = 0 }
    @{ Name = 'PmeEnable'; Value = 0 }
    @{ Name = 'HotPlugSurprise'; Value = 0 }
    @{ Name = 'LinkDisable'; Value = 0 }
    @{ Name = 'PreferredPowerState'; Value = 0 }
    @{ Name = 'PciExpressCapabilitiesHide'; Value = 0 }
)

$PciPowerSubkey = @(
    @{ Name = 'IdleTimeout'; Value = 0 }
    @{ Name = 'ConservationTimeout'; Value = 0 }
    @{ Name = 'PerformanceTimeout'; Value = 0 }
    @{ Name = 'WakeEnabled'; Value = 0 }
    @{ Name = 'DeviceWake'; Value = 0 }
    @{ Name = 'SystemWake'; Value = 0 }
    @{ Name = 'DisableAllD3'; Value = 1 }
    @{ Name = 'PerformanceState'; Value = 0 }
    @{ Name = 'TransitionLatencyD0'; Value = 0 }
    @{ Name = 'TransitionLatencyD1'; Value = 0 }
    @{ Name = 'TransitionLatencyD2'; Value = 0 }
    @{ Name = 'TransitionLatencyD3'; Value = 0 }
    @{ Name = 'LatencyToleranceD0'; Value = 0 }
    @{ Name = 'LatencyToleranceD1'; Value = 0 }
    @{ Name = 'LatencyToleranceD2'; Value = 0 }
    @{ Name = 'LatencyToleranceD3'; Value = 0 }
    @{ Name = 'WakeFromD0'; Value = 0 }
    @{ Name = 'WakeFromD1'; Value = 0 }
    @{ Name = 'WakeFromD2'; Value = 0 }
    @{ Name = 'WakeFromD3'; Value = 0 }
    @{ Name = 'DeviceD1'; Value = 0 }
    @{ Name = 'DeviceD2'; Value = 0 }
    @{ Name = 'DeviceD3'; Value = 0 }
)

$ScsiDiskBlock = @(
    @{ Name = 'CmdQueuingEnabled'; Value = 1 }
    @{ Name = 'EnableNCQ'; Value = 1 }
    @{ Name = 'EnableQueryAccessAlignment'; Value = 1 }
    @{ Name = 'CachingModePageEnabled'; Value = 1 }
    @{ Name = 'WriteCacheEnabled'; Value = 1 }
    @{ Name = 'UserWriteCacheSetting'; Value = 1 }
    @{ Name = 'FUA'; Value = 0 }
    @{ Name = 'EnableWriteCache'; Value = 1 }
    @{ Name = 'WriteCacheEnable'; Value = 1 }
    @{ Name = 'WriteCacheEnableOnPower'; Value = 1 }
    @{ Name = 'WriteCacheBufferFlushing'; Value = 0 }
    @{ Name = 'WriteCacheFlushTimeout'; Value = 0 }
    @{ Name = 'WriteCacheFUA'; Value = 0 }
    @{ Name = 'WriteCacheChangeable'; Value = 1 }
    @{ Name = 'WriteCoalescing'; Value = 0 }
    @{ Name = 'ReadCacheEnable'; Value = 1 }
    @{ Name = 'EnableReadCache'; Value = 1 }
    @{ Name = 'DisableWriteCache'; Value = 0 }
    @{ Name = 'DisableReadCache'; Value = 0 }
    @{ Name = 'EnableFlushCache'; Value = 0 }
    @{ Name = 'NoFlush'; Value = 1 }
    @{ Name = 'DisableFlushOnCleanup'; Value = 1 }
    @{ Name = 'FlushCacheReleaseLock'; Value = 0 }
    @{ Name = 'FlushTimerDelta'; Value = 0 }
    @{ Name = 'FlushTimerPeriod'; Value = 0 }
    @{ Name = 'TimeoutValue'; Value = 30 }
    @{ Name = 'DisablePowerSave'; Value = 1 }
    @{ Name = 'EnableAPM'; Value = 0 }
    @{ Name = 'APMLevel'; Value = 254 }
    @{ Name = 'EnableAAM'; Value = 0 }
    @{ Name = 'AAMLevel'; Value = 254 }
    @{ Name = 'EnableDIPS'; Value = 0 }
    @{ Name = 'EnableHIPM'; Value = 0 }
    @{ Name = 'EnableDIPM'; Value = 0 }
    @{ Name = 'EnableHotPlug'; Value = 0 }
    @{ Name = 'MaxTransferLength'; Value = 262144 }
    @{ Name = 'MaximumSGList'; Value = 255 }
    @{ Name = 'NumberOfRequests'; Value = 64 }
    @{ Name = 'QueueDepth'; Value = 64 }
    @{ Name = 'MaxQueueDepth'; Value = 254 }
    @{ Name = 'EnableMultipleQueue'; Value = 1 }
    @{ Name = 'EnableStandbySpinDown'; Value = 0 }
    @{ Name = 'SpindownTimeout'; Value = 0 }
    @{ Name = 'StandbyTimeout'; Value = 0 }
    @{ Name = 'DisableDeviceSleep'; Value = 1 }
    @{ Name = 'DeviceSleepEnabled'; Value = 0 }
    @{ Name = 'EnableAutoSleep'; Value = 0 }
    @{ Name = 'EnableLowPowerState'; Value = 0 }
    @{ Name = 'DisableDeleteNotification'; Value = 0 }
    @{ Name = 'DisableUnmap'; Value = 0 }
    @{ Name = 'AllowBusReset'; Value = 0 }
    @{ Name = 'BusResetDelay'; Value = 0 }
    @{ Name = 'DisableRemovable'; Value = 1 }
    @{ Name = 'RequestTimerResolution'; Value = 1 }
    @{ Name = 'IoCoalescingEnabled'; Value = 0 }
    @{ Name = 'IoCoalescingTimeout'; Value = 0 }
    @{ Name = 'DisableIdleStatePowerManagement'; Value = 1 }
    @{ Name = 'DisableRapidStartTechnology'; Value = 1 }
    @{ Name = 'EnableWriteBoost'; Value = 1 }
    @{ Name = 'EnableReadAhead'; Value = 1 }
    @{ Name = 'ReadAheadGranularity'; Value = 262144 }
    @{ Name = 'EnablePowerProtection'; Value = 0 }
    @{ Name = 'EnablePreferredPath'; Value = 0 }
    @{ Name = 'CacheLineSize'; Value = 0 }
    @{ Name = 'DisableWriteSameOperation'; Value = 0 }
    @{ Name = 'DisableCompareAndWrite'; Value = 0 }
    @{ Name = 'MaxHwSectorTransferLength'; Value = 262144 }
    @{ Name = 'ScsiCommandTimeout'; Value = 30 }
    @{ Name = 'BypassQueueOnForcedUnitAccess'; Value = 1 }
    @{ Name = 'DisableThrottling'; Value = 1 }
    @{ Name = 'MaintainCleanOnIdle'; Value = 0 }
    @{ Name = 'EnableVolatileWriteCache'; Value = 1 }
    @{ Name = 'EnableNonVolatileWriteCache'; Value = 1 }
    @{ Name = 'SrbTimeoutDelta'; Value = 0 }
    @{ Name = 'ResetLatency'; Value = 0 }
    @{ Name = 'CacheIsPowerProtected'; Value = 0 } # 0/1
    @{ Name = 'DeviceHPAlignment'; Value = 0 }
    @{ Name = 'DeviceDsmCapFlags'; Value = 0 }
)

$ScsiStorPortEffective = @(
    @{ Name = 'EnableIdlePowerManagement'; Value = 0 }
    @{ Name = 'MinimumIdleTimeoutInMS'; Value = 0 }
    @{ Name = 'QueueDepth'; Value = 64 }
    @{ Name = 'MaxQueueDepth'; Value = 254 }
    @{ Name = 'NumberOfRequests'; Value = 64 }
    @{ Name = 'EnableMultipleQueue'; Value = 1 }
    @{ Name = 'BusyRetryCount'; Value = 0 }
    @{ Name = 'BusyPauseDelay'; Value = 0 }
    @{ Name = 'IoTimeoutValue'; Value = 30 }
    @{ Name = 'EnableSettingsProtection'; Value = 0 }
    @{ Name = 'EnablePerformanceMode'; Value = 1 }
    @{ Name = 'MaxOutstandingIo'; Value = 254 }
    @{ Name = 'UncachedExtAlignment'; Value = 0 }
    @{ Name = 'QueueFullWaitIoPercentage'; Value = 100 }
    @{ Name = 'QueueFullThreshold'; Value = 254 }
    @{ Name = 'TotalMaxIo'; Value = 254 }
)

$ScsiPartmgrEffective = @(
    @{ Name = 'EnableCounterForIoctl'; Value = 1 }
    @{ Name = 'IdleTimeout'; Value = 0 }
    @{ Name = 'Attributes'; Value = 0 }
)

$ScsiPowerSubkey = @(
    @{ Name = 'IdleTimeout'; Value = 0 }
    @{ Name = 'ConservationTimeout'; Value = 0 }
    @{ Name = 'PerformanceTimeout'; Value = 0 }
    @{ Name = 'WakeEnabled'; Value = 0 }
    @{ Name = 'DeviceWake'; Value = 0 }
    @{ Name = 'SystemWake'; Value = 0 }
    @{ Name = 'DisableAllD3'; Value = 1 }
    @{ Name = 'PerformanceState'; Value = 0 }
    @{ Name = 'TransitionLatencyD0'; Value = 0 }
    @{ Name = 'TransitionLatencyD1'; Value = 0 }
    @{ Name = 'TransitionLatencyD2'; Value = 0 }
    @{ Name = 'TransitionLatencyD3'; Value = 0 }
    @{ Name = 'LatencyToleranceD0'; Value = 0 }
    @{ Name = 'LatencyToleranceD1'; Value = 0 }
    @{ Name = 'LatencyToleranceD2'; Value = 0 }
    @{ Name = 'LatencyToleranceD3'; Value = 0 }
    @{ Name = 'WakeFromD0'; Value = 0 }
    @{ Name = 'WakeFromD1'; Value = 0 }
    @{ Name = 'WakeFromD2'; Value = 0 }
    @{ Name = 'WakeFromD3'; Value = 0 }
    @{ Name = 'DeviceD1'; Value = 0 }
    @{ Name = 'DeviceD2'; Value = 0 }
    @{ Name = 'DeviceD3'; Value = 0 }
)

$StorageClassRootBlock = @(
    @{ Name = 'EnhancedPowerManagementEnabled'; Value = 0 }
    @{ Name = 'AllowIdleIrpInD3'; Value = 0 }
    @{ Name = 'DeviceSelectiveSuspended'; Value = 0 }
    @{ Name = 'SelectiveSuspendEnabled'; Value = 0 }
    @{ Name = 'IdleInWorkingState'; Value = 0 }
    @{ Name = 'WakeEnabled'; Value = 0 }
    @{ Name = 'WdfDirectedPowerTransitionEnable'; Value = 0 }
    @{ Name = 'EnableSelectiveSuspend'; Value = 0 }
    @{ Name = 'D3ColdSupported'; Value = 0 }
    @{ Name = 'DisableSelectiveSuspend'; Value = 1 }
    @{ Name = 'WaitWakeEnabled'; Value = 0 }
    @{ Name = 'EnablePME'; Value = 0 }
    @{ Name = 'EnableRuntimePM'; Value = 0 }
    @{ Name = 'RuntimePMOnIdle'; Value = 0 }
    @{ Name = 'RuntimeD3'; Value = 0 }
    @{ Name = 'RuntimeD3Cold'; Value = 0 }
    @{ Name = 'D3TransitionLatency'; Value = 0 }
    @{ Name = 'D0TransitionLatency'; Value = 0 }
    @{ Name = 'EnableLPM'; Value = 0 }
    @{ Name = 'EnablePCI_PM'; Value = 0 }
    @{ Name = 'EnablePCIPME'; Value = 0 }
    @{ Name = 'PMControl'; Value = 0 }
    @{ Name = 'DisableRuntimePowerManagement'; Value = 1 }
    @{ Name = 'EnableAggressivePM'; Value = 0 }
    @{ Name = 'EnableConnectedStandby'; Value = 0 }
    @{ Name = 'ModernStandbyEnable'; Value = 0 }
    @{ Name = 'CsEnabled'; Value = 0 }
    @{ Name = 'PlatformAoAcOverride'; Value = 0 }
    @{ Name = 'EnableSmartD3'; Value = 0 }
    @{ Name = 'SmartD3Enable'; Value = 0 }
    @{ Name = 'DisableLinkPowerManagement'; Value = 1 }
    @{ Name = 'DisableIdlePowerManagement'; Value = 1 }
    @{ Name = 'DisableRuntimeIdleDetection'; Value = 1 }
    @{ Name = 'DisableAsyncSuspend'; Value = 1 }
    @{ Name = 'DisableWake'; Value = 1 }
    @{ Name = 'SystemWake'; Value = 0 }
    @{ Name = 'DeviceWake'; Value = 0 }
    @{ Name = 'DmaRemappingCompatible'; Value = 0 }
    @{ Name = 'IoHighPriority'; Value = 1 }
    @{ Name = 'IoLatencyCap'; Value = 0 }
    @{ Name = 'DevicePriority'; Value = 3 }
    @{ Name = 'IRQPriority'; Value = 1 }
    @{ Name = 'InterruptModeration'; Value = 0 }
    @{ Name = 'InterruptModerationValue'; Value = 0 }
    @{ Name = 'DisableHwInterruptCoalescing'; Value = 1 }
    @{ Name = 'DisableCompletionCoalescing'; Value = 1 }
    @{ Name = 'IdlePowerState'; Value = 0 }
    @{ Name = 'LatencyToleranceHigh'; Value = 0 }
    @{ Name = 'LatencyToleranceLow'; Value = 0 }
    @{ Name = 'BestEffortServiceLatency'; Value = 0 }
    @{ Name = 'LinkStateChangeLatency'; Value = 0 }
    @{ Name = 'DisableDynamicTickForIdleWorker'; Value = 1 }
    @{ Name = 'SurpriseRemovalOK'; Value = 0 }
    @{ Name = 'CmdQueuingEnabled'; Value = 1 }
    @{ Name = 'EnableNCQ'; Value = 1 }
    @{ Name = 'EnableQueryAccessAlignment'; Value = 1 }
    @{ Name = 'CachingModePageEnabled'; Value = 1 }
    @{ Name = 'WriteCacheEnabled'; Value = 1 }
    @{ Name = 'UserWriteCacheSetting'; Value = 1 }
    @{ Name = 'FUA'; Value = 0 }
    @{ Name = 'EnableWriteCache'; Value = 1 }
    @{ Name = 'WriteCacheEnable'; Value = 1 }
    @{ Name = 'WriteCacheEnableOnPower'; Value = 1 }
    @{ Name = 'ReadCacheEnable'; Value = 1 }
    @{ Name = 'EnableReadCache'; Value = 1 }
    @{ Name = 'DisableWriteCache'; Value = 0 }
    @{ Name = 'DisableReadCache'; Value = 0 }
    @{ Name = 'EnableFlushCache'; Value = 0 }
    @{ Name = 'NoFlush'; Value = 1 }
    @{ Name = 'DisableFlushOnCleanup'; Value = 1 }
    @{ Name = 'TimeoutValue'; Value = 30 }
    @{ Name = 'DisablePowerSave'; Value = 1 }
    @{ Name = 'EnableAPM'; Value = 0 }
    @{ Name = 'APMLevel'; Value = 254 }
    @{ Name = 'EnableAAM'; Value = 0 }
    @{ Name = 'AAMLevel'; Value = 254 }
    @{ Name = 'EnableDIPS'; Value = 0 }
    @{ Name = 'EnableHIPM'; Value = 0 }
    @{ Name = 'EnableDIPM'; Value = 0 }
    @{ Name = 'EnableHotPlug'; Value = 0 }
    @{ Name = 'MaxTransferLength'; Value = 262144 }
    @{ Name = 'MaximumSGList'; Value = 255 }
    @{ Name = 'NumberOfRequests'; Value = 64 }
    @{ Name = 'QueueDepth'; Value = 64 }
    @{ Name = 'MaxQueueDepth'; Value = 254 }
    @{ Name = 'EnableMultipleQueue'; Value = 1 }
    @{ Name = 'EnableStandbySpinDown'; Value = 0 }
    @{ Name = 'SpindownTimeout'; Value = 0 }
    @{ Name = 'StandbyTimeout'; Value = 0 }
    @{ Name = 'IdleTimeout'; Value = 0 }
    @{ Name = 'DisableDeviceSleep'; Value = 1 }
    @{ Name = 'DeviceSleepEnabled'; Value = 0 }
    @{ Name = 'EnableDeviceSleep'; Value = 0 }
    @{ Name = 'EnableAutoSleep'; Value = 0 }
    @{ Name = 'EnableLowPowerState'; Value = 0 }
)

$StorageDeviceParameters = @(
    @{ Name = 'EnhancedPowerManagementEnabled'; Value = 0 }
    @{ Name = 'SelectiveSuspendEnabled'; Value = 0 }
    @{ Name = 'DeviceSelectiveSuspended'; Value = 0 }
    @{ Name = 'AllowIdleIrpInD3'; Value = 0 }
    @{ Name = 'D3ColdSupported'; Value = 0 }
    @{ Name = 'WaitWakeEnabled'; Value = 0 }
    @{ Name = 'WdfDirectedPowerTransitionEnable'; Value = 0 }
    @{ Name = 'IdleInWorkingState'; Value = 0 }
    @{ Name = 'WakeEnabled'; Value = 0 }
    @{ Name = 'EnableSelectiveSuspend'; Value = 0 }
    @{ Name = 'DisableSelectiveSuspend'; Value = 1 }
    @{ Name = 'RuntimeD3'; Value = 0 }
    @{ Name = 'RuntimeD3Cold'; Value = 0 }
    @{ Name = 'EnableRuntimePM'; Value = 0 }
    @{ Name = 'RuntimePMOnIdle'; Value = 0 }
    @{ Name = 'D3TransitionLatency'; Value = 0 }
    @{ Name = 'D0TransitionLatency'; Value = 0 }
    @{ Name = 'DevicePriority'; Value = 3 }
    @{ Name = 'IoHighPriority'; Value = 1 }
    @{ Name = 'InterruptModeration'; Value = 0 }
    @{ Name = 'InterruptModerationValue'; Value = 0 }
    @{ Name = 'DisableIdlePowerManagement'; Value = 1 }
    @{ Name = 'DisableLinkPowerManagement'; Value = 1 }
    @{ Name = 'ModernStandbyEnable'; Value = 0 }
    @{ Name = 'EnableConnectedStandby'; Value = 0 }
    @{ Name = 'EnableSmartD3'; Value = 0 }
    @{ Name = 'SmartD3Enable'; Value = 0 }
    @{ Name = 'CsEnabled'; Value = 0 }
    @{ Name = 'DisableWake'; Value = 1 }
    @{ Name = 'SystemWake'; Value = 0 }
    @{ Name = 'DeviceWake'; Value = 0 }
    @{ Name = 'DisableCompletionCoalescing'; Value = 1 }
    @{ Name = 'DisableHwInterruptCoalescing'; Value = 1 }
    @{ Name = 'IdleTimeout'; Value = 0 }
)

$StorageDisk = @(
    @{ Name = 'WriteCacheEnabled'; Value = 1 }
    @{ Name = 'UserWriteCacheSetting'; Value = 1 }
    @{ Name = 'CachingModePageEnabled'; Value = 1 }
    @{ Name = 'EnableFlushCache'; Value = 0 }
    @{ Name = 'TimeoutValue'; Value = 30 }
)

$StorageStorPort = @(
    @{ Name = 'EnableIdlePowerManagement'; Value = 0 }
    @{ Name = 'MinimumIdleTimeoutInMS'; Value = 0 }
    @{ Name = 'QueueDepth'; Value = 64 }
    @{ Name = 'MaxQueueDepth'; Value = 254 }
    @{ Name = 'NumberOfRequests'; Value = 64 }
    @{ Name = 'EnableMultipleQueue'; Value = 1 }
    @{ Name = 'BusyRetryCount'; Value = 0 }
    @{ Name = 'BusyPauseDelay'; Value = 0 }
    @{ Name = 'IoTimeoutValue'; Value = 30 }
    @{ Name = 'EnableSettingsProtection'; Value = 0 }
)

$StorageClassPnP = @(
    @{ Name = 'IdleTimeout'; Value = 0 }
    @{ Name = 'DisableIdleTimeout'; Value = 1 }
)

$StorageWMI = @(
    @{ Name = 'IdleEnabled'; Value = 0 }
    @{ Name = 'IdleTimeout'; Value = 0 }
)

$StoragePCI = @(
    @{ Name = 'ASPMOptOut'; Value = 1 }
    @{ Name = 'NoASPM'; Value = 1 }
    @{ Name = 'DisableASPM'; Value = 1 }
    @{ Name = 'ASPM'; Value = 0 }
    @{ Name = 'L0sLatency'; Value = 0 }
    @{ Name = 'L1Latency'; Value = 0 }
    @{ Name = 'EnableASPM'; Value = 0 }
    @{ Name = 'L0sSupported'; Value = 0 }
    @{ Name = 'L1Supported'; Value = 0 }
    @{ Name = 'ClockPowerManagement'; Value = 0 }
    @{ Name = 'CommonClockConfig'; Value = 0 }
)

$StoragePower = @(
    @{ Name = 'IdleTimeout'; Value = 0 }
    @{ Name = 'PerformanceState'; Value = 0 }
    @{ Name = 'ConservationTimeout'; Value = 0 }
    @{ Name = 'PerformanceTimeout'; Value = 0 }
    @{ Name = 'TransitionLatencyD0'; Value = 0 }
    @{ Name = 'TransitionLatencyD1'; Value = 0 }
    @{ Name = 'TransitionLatencyD2'; Value = 0 }
    @{ Name = 'TransitionLatencyD3'; Value = 0 }
    @{ Name = 'LatencyToleranceD0'; Value = 0 }
    @{ Name = 'LatencyToleranceD1'; Value = 0 }
    @{ Name = 'LatencyToleranceD2'; Value = 0 }
    @{ Name = 'LatencyToleranceD3'; Value = 0 }
    @{ Name = 'WakeFromD0'; Value = 0 }
    @{ Name = 'WakeFromD1'; Value = 0 }
    @{ Name = 'WakeFromD2'; Value = 0 }
    @{ Name = 'WakeFromD3'; Value = 0 }
    @{ Name = 'DeviceWake'; Value = 0 }
    @{ Name = 'SystemWake'; Value = 0 }
    @{ Name = 'DeviceD1'; Value = 0 }
    @{ Name = 'DeviceD2'; Value = 0 }
    @{ Name = 'DeviceD3'; Value = 0 }
    @{ Name = 'WakeEnabled'; Value = 0 }
    @{ Name = 'DisableAllD3'; Value = 1 }
)

$StorageDevicePower = @(
    @{ Name = 'IdleTimeout'; Value = 0 }
    @{ Name = 'ConservationTimeout'; Value = 0 }
    @{ Name = 'PerformanceTimeout'; Value = 0 }
    @{ Name = 'WakeEnabled'; Value = 0 }
    @{ Name = 'DeviceWake'; Value = 0 }
    @{ Name = 'SystemWake'; Value = 0 }
    @{ Name = 'DisableAllD3'; Value = 1 }
)

# ------------------------------------------------------------
# AUDIT NOTES: the storage-port and partition-manager helpers had duplicate
# definitions. PowerShell uses the last definition, so only ScsiStorPortEffective
# (16 values) and ScsiPartmgrEffective (3 values) are applied here. Earlier variants
# are retained below as commented reference data and are not executed.
#
# Superseded storage-port variant (39 values):
#   EnableIdlePowerManagement = 0
#   MinimumIdleTimeoutInMS = 0
#   QueueDepth = 64
#   MaxQueueDepth = 254
#   NumberOfRequests = 64
#   EnableMultipleQueue = 1
#   BusyRetryCount = 0
#   BusyPauseDelay = 0
#   IoTimeoutValue = 30
#   EnableSettingsProtection = 0
#   EnablePerformanceMode = 1
#   MaxOutstandingIo = 254
#   UncachedExtAlignment = 0
#   QueueFullWaitIoPercentage = 100
#   QueueFullThreshold = 254
#   TotalMaxIo = 254
#   IoLatencyCap = 0
#   IoCoalescingEnabled = 0
#   IoCoalescingTimeout = 0
#   DisableIdleTimeout = 1
#   IdleTimeout = 0
#   D3IdleTimeout = 0
#   D3IdleLatency = 0
#   MinDmaTransferSize = 0
#   MaxDmaTransferSize = 262144
#   RequestCoalescing = 0
#   RequestCoalescingTimeout = 0
#   EnableD3Cold = 0
#   DisableD3Cold = 1
#   EnableRuntimePowerManagement = 0
#   AdapterIdleTimeoutInMS = 0
#   DeviceIdleTimeoutInMS = 0
#   UnitIdleTimeoutInMS = 0
#   MaxIoCount = 254
#   MaxLunCount = 0
#   MaxTransferLength = 262144
#   MaxBusyTime = 0
#   PerformanceOptimized = 1
#   DisableStorageIdleTimeout = 1
# Superseded partition-manager variant (7 values):
#   EnableCounterForIoctl = 1
#   IdleTimeout = 0
#   Attributes = 0
#   DiskSignatureCheck = 0
#   IoRemoteComplete = 1
#   OnlinePolicy = 1
#   SanPolicy = 1

# ---------------- USB section -------------------------
# ================================================================
# USB device configuration.
#
# Architecture:
#   REG = fixed/static registry destinations.
#   PS1 = device enumeration, dynamic paths, sweeps, conditions, removals,
#         and per-interface settings.
#
# Intentionally excluded from this section:
#   - the MSI/MSIX/DMA/interrupt block;
#   - the boot-configuration command, which is handled in the storage/kernel section;
#   - inactive blocks that depend on undefined variables.
#
# The malformed DynamicSendBufferDisable registry syntax is corrected in the
# companion REG file.
# ================================================================


function Remove-Key([string]$Path) {
    try { if (Test-Path -LiteralPath $Path) { Remove-Item -LiteralPath $Path -Recurse -Force } } catch {}
}

$genericDeviceMap = [ordered]@{
    "SelectiveSuspendEnabled" = 0
    "SelectiveSuspendOn" = 0
    "SelectiveSuspendTimeout" = 0
    "DeviceSelectiveSuspended" = 0
    "SelSuspCancelBehavior" = 0
    "SelectiveSuspendSupported" = 0
    "EnableSelectiveSuspend" = 0
    "AllowIdleIrpInD3" = 0
    "D3ColdReconnectTimeout" = 0
    "D3ColdSupported" = 0
    "AllowD3Cold" = 0
    "PreventD3Cold" = 1
    "PreventD3ColdTransition" = 1
    "PreventD3Transition" = 1
    "NoD3ColdOnDx" = 1
    "NoD3ColdOnSx" = 1
    "EnhancedPowerManagementEnabled" = 0
    "EnhancedPowerManagement" = 0
    "DisableEnhancedPowerMgmt" = 1
    "FullPowerDownOnTransientDx" = 0
    "UserSetCurrentPower" = 0
    "ForceD0" = 1
    "ForcePowerD0" = 1
    "DisableRuntimePM" = 1
    "RuntimePowerManagement" = 0
    "DeviceIdleEnabled" = 0
    "DeviceIdleIgnoreWakeEnable" = 0
    "DefaultIdleState" = 0
    "DefaultIdleTimeout" = 0
    "IdleTimeoutPeriodInMilliSec" = 0
    "IdleTimeout" = 0
    "IdleTime" = 0
    "IdleEnabled" = 0
    "IdlePowerState" = 0
    "ForcedIdlePowerState" = 0
    "ConservationIdleTime" = 0
    "PerformanceIdleTime" = 0
    "EnableIdlePowerManagement" = 0
    "IdleInWorkingState" = 0
    "DevicePowerUpOnS0Entry" = 1
    "WaitWakeEnabled" = 0
    "SystemWakeEnabled" = 0
    "WakeEnabled" = 0
    "ArmForWake" = 0
    "WakeSystemOnConnect" = 0
    "WakeScreenOnInputSupport" = 0
    "RetainWWIrpWhenDeviceAbsent" = 0
    "SuppressInputInCS" = 0
    "SystemInputSuppressionEnabled" = 0
    "InputSuppressionSupported" = 0
    "TestIdleMonitorDim" = 0
    "TestIdleTimeoutNoHandles" = 0
    "TestIdleTimeoutNoHandlesInitial" = 0
    "KsDFxSupportEnable" = 0
    "HardResetCount" = 0
    "OvercurrentDetected" = 0
    "WinUsbPowerPolicyOwnershipDisabled" = 1
    "LinkPowerManagementEnabled" = 0
    "U1Enabled" = 0
    "U2Enabled" = 0
    "U1Timeout" = 0
    "U2Timeout" = 0
    "LPMEnabled" = 0
    "L1Timeout" = 0
    "L1HirdValue" = 0
    "BeslValue" = 0
    "DisableLpmForPortInU0" = 1
    "TelemetryEnabled" = 0
    "DiagnosticsEnabled" = 0
    "DeviceChargerConnected" = 0
    "MaximumTransferSize" = 1048576
    "InitialTimersForUrbList" = 0
    "PipeTransferThrottleSize" = 1048576
    "EnableASPM" = 0
    "AspmOptOut" = 1
    "AspmOptOutPolicy" = 1
    "L0sLatency" = 0
    "L1Latency" = 0
    "L0sEnabled" = 0
    "L1PMEnabled" = 0
    "L1SubstatesEnabled" = 0
    "L1_1Enabled" = 0
    "L1_2Enabled" = 0
    "LTREnabled" = 0
    "LTRMaxNoSnoopLatency" = 0
    "LTRMaxSnoopLatency" = 0
    "OBFFEnabled" = 0
    "PoFxIdleTimeout" = 0
    "PoFxIdleTimeoutS0" = 0
    "PoFxIdleEnabled" = 0
    "PoFxIdlePowerState" = 0
    "PoFxMinimumIdleTimeout" = 0
    "PoFxIdleUnregister" = 1
    "PoFxDirectedDripsProblem" = 1
    "PowerGatingEnabled" = 0
    "ClockGatingEnabled" = 0
    "PowerManagementSupported" = 0
    "SystemPowerStateTransitionDisabled" = 1
    "DxOverride" = 0
    "PowerChannelState" = 1
    "EnableMaxPayloadSize" = 1
    "MaxPayloadSize" = 0
    "EnableMaxReadRequestSize" = 1
    "MaxReadRequestSize" = 0
    "ForcePollTimerResolution" = 0
    "DebugFlags" = 0
    "TraceFlags" = 0
    "LogFlags" = 0
    "PerfFlags" = 0
    "EtwEnabled" = 0
    "WppEnabled" = 0
    "IfrEnabled" = 0
    "PerformanceCountersEnabled" = 0
    "DiagnosticMode" = 0
    "ExtendedValidation" = 0
    "ComplianceMode" = 0
    "TestMode" = 0
    "DisableDynamicTick" = 1
    "RemoteWakeEnabled" = 0
    "DisableRemoteWakeup" = 1
    "RemovalPolicy" = 2
    "ConfigFlags" = 0
    "EnIdleEndpointSupport" = 0
    "EnIdleEndpoint" = 0
    "DisableHubSuspend" = 1
    "DisableOnSoftRemove" = 0
    "ResetOnResume" = 0
    "ForceHCResetOnResume" = 0
    "PortResetTimeout" = 500
    "FailGetStatusFromDevice" = 0
    "PollInterval" = 1
    "MaxInputReportQueueLength" = 32
    "FlushInputReportQueueOnOpen" = 0
    "ForceResetOnResume" = 0
    "IgnoreCSCOnResume" = 0
}

$wdfMap = [ordered]@{
    "IdleInWorkingState" = 0
    "WdfDefaultIdleInWorkingState" = 0
    "WdfDirectedPowerTransitionEnable" = 0
    "WdfDirectedPowerTransitionChildrenOptional" = 0
    "WdfUseWdfTimerForPofx" = 0
    "WdfDefaultWakeFromSleepState" = 0
    "WdfDefaultWakeFromS0Idle" = 0
    "WdfFxTimeoutInSeconds" = 0
    "WdfFxIdleTimeout" = 0
    "WdfFxIdleTimeoutS0" = 0
    "WdfDirectedPowerTransitionLatencyTolerance" = 0
    "WdfDirectedPowerTransitionUpLatencyTolerance" = 0
    "WdfDirectedPowerTransitionDownLatencyTolerance" = 0
    "WdfSxIdleTimeout" = 0
    "WdfSxWakeFromSleepState" = 0
    "WdfPowerPolicyS0IdlePolicy" = 0
    "WdfPowerPolicySxWakePolicy" = 0
    "WdfPowerPolicyIdleTimeout" = 0
    "WdfPowerPolicyIdleTimeoutType" = 0
    "WdfS0IdleExcludeD3Cold" = 1
    "WdfIdleTimeoutType" = 0
    "WdfFxEnabled" = 0
    "WdfDeviceIdleEnabled" = 0
    "WdfPowerPolicyOwnership" = 0
}

$diskMap = [ordered]@{
    "UserWriteCacheSetting" = 1
    "CacheIsPowerProtected" = 0 # 0/1
    "AllowLossyCompression" = 0
    "EnableNCache" = 1
    "EnableWriteCache" = 1
    "EnableNCQ" = 1
    "EnableAPM" = 0
    "APMLevel" = 254
    "EnableDIPM" = 0
    "EnableHIPM" = 0
    "TimeOutValue" = 60
}

$storPortMap = [ordered]@{
    "EnableIdlePowerManagement" = 0
    "IdleTimeoutInMS" = 0
    "D3IdleTimeout" = 0
    "EnableD3Cold" = 0
    "DisableIdleTimeout" = 1
    "DisablePowerTimeout" = 1
    "RequestCount" = 256
    "BusyRetryCount" = 255
    "QueueFullWaitIoPercentage" = 25
    "MinimumIdleTimeoutInMS" = 0
}
$genericPowerSubkeyMap = [ordered]@{
    "IdleTimeout" = 0
    "ConservationTimeout" = 0
    "PerformanceTimeout" = 0
    "WakeEnabled" = 0
    "DeviceWake" = 0
    "SystemWake" = 0
    "DisableAllD3" = 1
    "PerformanceState" = 0
    "TransitionLatencyD0" = 0
    "TransitionLatencyD1" = 0
    "TransitionLatencyD2" = 0
    "TransitionLatencyD3" = 0
    "LatencyToleranceD0" = 0
    "LatencyToleranceD1" = 0
    "LatencyToleranceD2" = 0
    "LatencyToleranceD3" = 0
    "WakeFromD0" = 0
    "WakeFromD1" = 0
    "WakeFromD2" = 0
    "WakeFromD3" = 0
    "DeviceD1" = 0
    "DeviceD2" = 0
    "DeviceD3" = 0
}

$usb3GenericExtraMap = [ordered]@{
    "WdfDirectedPowerTransitionEnable" = 0
    "DisableSelectiveSuspend" = 1
    "EnablePME" = 0
    "EnableRuntimePM" = 0
    "RuntimePMOnIdle" = 0
    "RuntimeD3" = 0
    "RuntimeD3Cold" = 0
    "D3TransitionLatency" = 0
    "D0TransitionLatency" = 0
    "D1Latency" = 0
    "D2Latency" = 0
    "D3Latency" = 0
    "EnableLPM" = 0
    "LPMCapabilitySupported" = 0
    "LPMExitLatency" = 0
    "EnablePCI_PM" = 0
    "EnablePCIPME" = 0
    "PMControl" = 0
    "DisableRuntimePowerManagement" = 1
    "EnableAggressivePM" = 0
    "EnableConnectedStandby" = 0
    "ModernStandbyEnable" = 0
    "CsEnabled" = 0
    "PlatformAoAcOverride" = 0
    "EnableSmartD3" = 0
    "SmartD3Enable" = 0
    "DisableLinkPowerManagement" = 1
    "DisableIdlePowerManagement" = 1
    "DisableRuntimeIdleDetection" = 1
    "DisableAsyncSuspend" = 1
    "DisableWake" = 1
    "WakeFromSleepEnabled" = 0
    "WakeOnPatternMatch" = 0
    "WakeOnMagicPacket" = 0
    "WakeOnLink" = 0
    "EnablePMWake" = 0
    "PMEWakeEnabled" = 0
    "SystemWake" = 0
    "DeviceWake" = 0
    "IoHighPriority" = 1
    "IoLatencyCap" = 0
    "DevicePriority" = 3
    "InterruptModeration" = 0
    "InterruptModerationValue" = 0
    "DisableHwInterruptCoalescing" = 1
    "DisableCompletionCoalescing" = 1
    "LatencyToleranceHigh" = 0
    "LatencyToleranceLow" = 0
    "BestEffortServiceLatency" = 0
    "LinkStateChangeLatency" = 0
    "DisableDynamicTickForIdleWorker" = 1
    "SurpriseRemovalOK" = 0
    "SS_Enabled" = 0
    "SSEnabled" = 0
    "NoSS" = 1
    "RootHubSS" = 0
    # "ss_enabled" = 0   # omitted: registry value names are case-insensitive; "SS_Enabled" = 0 above already writes the same value
    "HcDisableSelectiveSuspend" = 1
    "EnableU1" = 0
    "EnableU2" = 0
    "EnableU1U2" = 0
    "U1U2DisableMode" = 3
    "U1U2TransitionTimeout" = 0
    "DisablePortSuspend" = 1
    "PortSuspend" = 0
    "DisableBusMasterOnSuspend" = 1
    "ReducedLatency" = 1
    "LowLatencyMode" = 1
    "ELD" = 1
    "iSchedLatency" = 1
    "ForceMaxBandwidth" = 1
    "HighBandwidthMode" = 1
    "DisableDeviceSleep" = 1
    "DeviceSleepEnabled" = 0
    "EnableDeviceSleep" = 0
    "EnableAutoSleep" = 0
    "EnableLowPowerState" = 0
    "DisablePowerSave" = 1
    "PowerSaveMode" = 0
    "DmaRemappingCompatible" = 0
    "ConservationTimeout" = 0
    "PerformanceTimeout" = 0
    "DisableAllD3" = 1
    "PerformanceState" = 0
    "TransitionLatencyD0" = 0
    "TransitionLatencyD1" = 0
    "TransitionLatencyD2" = 0
    "TransitionLatencyD3" = 0
    "LatencyToleranceD0" = 0
    "LatencyToleranceD1" = 0
    "LatencyToleranceD2" = 0
    "LatencyToleranceD3" = 0
    "WakeFromD0" = 0
    "WakeFromD1" = 0
    "WakeFromD2" = 0
    "WakeFromD3" = 0
    "DeviceD1" = 0
    "DeviceD2" = 0
    "DeviceD3" = 0
}

$usb3RecursiveMap = [ordered]@{
    "EnhancedPowerManagementEnabled" = 0
    "AllowIdleIrpInD3" = 0
    "DeviceSelectiveSuspended" = 0
    "SelectiveSuspendEnabled" = 0
    "SelectiveSuspendOn" = 0
    "IdleInWorkingState" = 0
    "WakeEnabled" = 0
    "WdfDirectedPowerTransitionEnable" = 0
    "EnableSelectiveSuspend" = 0
    "D3ColdSupported" = 0
    "DisableSelectiveSuspend" = 1
    "WaitWakeEnabled" = 0
    "EnablePME" = 0
    "EnableRuntimePM" = 0
    "RuntimePMOnIdle" = 0
    "RuntimeD3" = 0
    "RuntimeD3Cold" = 0
    "D3TransitionLatency" = 0
    "D0TransitionLatency" = 0
    "EnableLPM" = 0
    "DisableRuntimePowerManagement" = 1
    "EnableConnectedStandby" = 0
    "ModernStandbyEnable" = 0
    "CsEnabled" = 0
    "EnableSmartD3" = 0
    "SmartD3Enable" = 0
    "DisableLinkPowerManagement" = 1
    "DisableIdlePowerManagement" = 1
    "DisableRuntimeIdleDetection" = 1
    "DisableWake" = 1
    "SystemWake" = 0
    "DeviceWake" = 0
    "IoHighPriority" = 1
    "DevicePriority" = 3
    "InterruptModeration" = 0
    "InterruptModerationValue" = 0
    "DisableHwInterruptCoalescing" = 1
    "DisableCompletionCoalescing" = 1
    "IdlePowerState" = 0
    "LatencyToleranceHigh" = 0
    "LatencyToleranceLow" = 0
    "IdleTimeout" = 0
    "SS_Enabled" = 0
    "SSEnabled" = 0
    "NoSS" = 1
    "EnableU1" = 0
    "EnableU2" = 0
    "EnableU1U2" = 0
    "U1Timeout" = 0
    "U2Timeout" = 0
    "U1U2DisableMode" = 3
    "DisablePortSuspend" = 1
    "ReducedLatency" = 1
    "LowLatencyMode" = 1
    "DisableDeviceSleep" = 1
    "DeviceSleepEnabled" = 0
    "DisablePowerSave" = 1
    "PowerSaveMode" = 0
}

$usb3InterfaceMap = [ordered]@{
    "EnhancedPowerManagementEnabled" = 0
    "SelectiveSuspendEnabled" = 0
    "D3ColdSupported" = 0
    "DisableSelectiveSuspend" = 1
    "RuntimeD3" = 0
    "RuntimeD3Cold" = 0
    "EnableLPM" = 0
    "DisableIdlePowerManagement" = 1
    "DisableLinkPowerManagement" = 1
    "IdleTimeout" = 0
    "WakeEnabled" = 0
    "DisableWake" = 1
    "EnableU1" = 0
    "EnableU2" = 0
    "U1Timeout" = 0
    "U2Timeout" = 0
    "U1U2DisableMode" = 3
    "SS_Enabled" = 0
    "DisablePortSuspend" = 1
    "DeviceSleepEnabled" = 0
}

$usb3WmiMap = [ordered]@{
    "IdleEnabled" = 0
    "IdleTimeout" = 0
}

$usb3StorPortBaseMap = [ordered]@{
    "EnableIdlePowerManagement" = 0
    "MinimumIdleTimeoutInMS" = 0
}

$classCommonMap = [ordered]@{
    "EnhancedPowerManagementEnabled" = 0
    "AllowIdleIrpInD3" = 0
    "DeviceSelectiveSuspended" = 0
    "SelectiveSuspendEnabled" = 0
    "SelectiveSuspendOn" = 0
    "IdleInWorkingState" = 0
    "WakeEnabled" = 0
    "WdfDirectedPowerTransitionEnable" = 0
    "EnableSelectiveSuspend" = 0
    "D3ColdSupported" = 0
    "DisableSelectiveSuspend" = 1
    "InterruptModeration" = 0
    "InterruptModerationValue" = 0
    "LatencyToleranceHigh" = 0
    "LatencyToleranceLow" = 0
    "WaitWakeEnabled" = 0
    "IoHighPriority" = 1
    "IoLatencyCap" = 0
    "DevicePriority" = 3
    "IdlePowerState" = 0
    "SurpriseRemovalOK" = 0
    "EnablePME" = 0
    "EnableRuntimePM" = 0
    "RuntimePMOnIdle" = 0
    "SS_Enabled" = 0
    "SSEnabled" = 0
    "RuntimeD3" = 0
    "RuntimeD3Cold" = 0
    "D3TransitionLatency" = 0
    "D0TransitionLatency" = 0
    "DmaRemappingCompatible" = 0
    "EnableLPM" = 0
    "LPMCapabilitySupported" = 0
    "DisableDynamicTickForIdleWorker" = 1
    "WakeFromSleepEnabled" = 0
    "EnablePCI_PM" = 0
    "EnablePCIPME" = 0
    "PMControl" = 0
    "DisableRuntimePowerManagement" = 1
    "DisableHwInterruptCoalescing" = 1
    "EnableAggressivePM" = 0
    "EnableConnectedStandby" = 0
    "ModernStandbyEnable" = 0
    "BestEffortServiceLatency" = 0
    "IRQPriority" = 1
    "DisableAsyncSuspend" = 1
    "DisableLinkPowerManagement" = 1
    "DisableIdlePowerManagement" = 1
    "DisableRuntimeIdleDetection" = 1
    "LinkStateChangeLatency" = 0
    "SystemWake" = 0
    "DeviceWake" = 0
    "EnableSmartD3" = 0
    "SmartD3Enable" = 0
    "CsEnabled" = 0
    "PlatformAoAcOverride" = 0
    "WakeOnPatternMatch" = 0
    "DisableWake" = 1
    "DisableCompletionCoalescing" = 1
    "DisablePortSuspend" = 1
}

$usbClass1ExtraMap = [ordered]@{
    "InterruptThrottleRate" = 0
    "ELD" = 1
    "LMD" = 0
    "USBLatencyMode" = 0
    "iSchedLatency" = 1
    "IOLBM" = 1
    "ForceRMPolling" = 1
    "ForceHCResetOnResume" = 0
    "HcDisableSelectiveSuspend" = 1
    "NoSS" = 1
    "EnableIdleCheck" = 0
    "D0PacketTimeout" = 0
    "D3PacketTimeout" = 0
    "UsbBIOSx" = 0
    "RootHubSS" = 0
    "ss_enabled" = 0
    "PowerDownPollInterval" = 0
    "PollInterval" = 0
    "TransferCompletionTimeout" = 0
    "TxCoalescingMaxPackets" = 1
    "RxCoalescingMaxPackets" = 1
    "CoalescingTimerResolution" = 0
    "ReducedLatency" = 1
    "LowLatencyMode" = 1
    "PMEnable" = 0
    "UsbFlags" = 0
    "XhciDynLPMFlags" = 0
    "U1U2DisableMode" = 3
    "U1Timeout" = 0
    "U2Timeout" = 0
    "U1U2TransitionTimeout" = 0
    "LPMExitLatency" = 0
    "KeepConnected" = 1
    "ForceMaxBandwidth" = 1
    "HighBandwidthMode" = 1
    "MaxTransferSize" = 262144
    "MaxPendingTransfers" = 8
    "MaxPendingReads" = 8
    "DpcPriority" = 3
    "IsrPriority" = 3
    "InterruptPriority" = 3
    "ThreadPriority" = 31
    "ServiceThreadPriority" = 31
    "TimerResolution" = 5000
    "SchedulingCategory" = 4
    "IoSchedulerType" = 0
    "EnableU1" = 0
    "EnableU2" = 0
    "EnableU1U2" = 0
    "L1Timeout" = 0
    "L1HubTimeout" = 0
    "D1Latency" = 0
    "D2Latency" = 0
    "D3Latency" = 0
    "DisableCompanionControllers" = 0
    "HcLowLatency" = 1
    "IoFlipPolicy" = 0
    "DisableBusMasterOnSuspend" = 1
    "WakeOnMagicPacket" = 0
    "WakeOnLink" = 0
    "EnableWakeOnPattern" = 0
    "EnablePMWake" = 0
    "PMEWakeEnabled" = 0
    "HcAsyncScheduleParkMode" = 0
    "HcPeriodicScheduleThreshold" = 0
    "HcFrameListSize" = 1024
    "ForceFullSpeed" = 0
    "DisableDPC" = 0
    "HcInterruptRate" = 1
    "XhciInterrupterMax" = 1
    "PortSuspend" = 0
}

$hidClassExtraMap = [ordered]@{
    # "MouseDataQueueSize" = 32   # (fixed setting; defined only in the companion REG file under Services\mouclass / kbdclass, not per device instance)
    # "KeyboardDataQueueSize" = 32   # (fixed setting; defined only in the companion REG file under Services\mouclass / kbdclass, not per device instance)
    "FlipFlopWheel" = 0
}

$classCommonDeviceParametersMap = [ordered]@{
    "EnhancedPowerManagementEnabled" = 0
    "SelectiveSuspendEnabled" = 0
    "DeviceSelectiveSuspended" = 0
    "AllowIdleIrpInD3" = 0
    "D3ColdSupported" = 0
    "WaitWakeEnabled" = 0
    "WdfDirectedPowerTransitionEnable" = 0
    "IdleInWorkingState" = 0
    "WakeEnabled" = 0
    "EnableSelectiveSuspend" = 0
    "DisableSelectiveSuspend" = 1
    "SS_Enabled" = 0
    "SSEnabled" = 0
    "EnableLPM" = 0
    "EnablePCI_PM" = 0
    "EnablePCIPME" = 0
    "RuntimeD3" = 0
    "RuntimeD3Cold" = 0
    "EnableRuntimePM" = 0
    "RuntimePMOnIdle" = 0
    "D3TransitionLatency" = 0
    "D0TransitionLatency" = 0
    "DevicePriority" = 3
    "IoHighPriority" = 1
    "InterruptModeration" = 0
    "InterruptModerationValue" = 0
    "DisableIdlePowerManagement" = 1
    "DisableLinkPowerManagement" = 1
    "ModernStandbyEnable" = 0
    "EnableConnectedStandby" = 0
    "EnableSmartD3" = 0
    "SmartD3Enable" = 0
    "CsEnabled" = 0
    "DisableWake" = 1
    "SystemWake" = 0
    "DeviceWake" = 0
    "DisablePortSuspend" = 1
    "DisableCompletionCoalescing" = 1
    "DisableHwInterruptCoalescing" = 1
}

$usbClass1DeviceParametersExtraMap = [ordered]@{
    "U1Timeout" = 0
    "U2Timeout" = 0
    "U1U2DisableMode" = 3
    "LPMExitLatency" = 0
    "ReducedLatency" = 1
    "LowLatencyMode" = 1
    "ForceHCResetOnResume" = 0
    "EnableU1" = 0
    "EnableU2" = 0
    "EnableU1U2" = 0
    "WakeOnPatternMatch" = 0
    "WakeOnMagicPacket" = 0
}

$hidClassDeviceParametersExtraMap = [ordered]@{
    "FlipFlopWheel" = 0
    # "MouseDataQueueSize" = 32   # (fixed setting; defined only in the companion REG file under Services\mouclass / kbdclass, not per device instance)
    # "KeyboardDataQueueSize" = 32   # (fixed setting; defined only in the companion REG file under Services\mouclass / kbdclass, not per device instance)
    "IdleTimeout" = 0
}

$classCommonPowerMap = [ordered]@{
    "IdleTimeout" = 0
    "PerformanceState" = 0
    "ConservationTimeout" = 0
    "PerformanceTimeout" = 0
    "TransitionLatencyD0" = 0
    "TransitionLatencyD1" = 0
    "TransitionLatencyD2" = 0
    "TransitionLatencyD3" = 0
    "LatencyToleranceD0" = 0
    "LatencyToleranceD1" = 0
    "LatencyToleranceD2" = 0
    "LatencyToleranceD3" = 0
    "WakeFromD0" = 0
    "WakeFromD1" = 0
    "WakeFromD2" = 0
    "WakeFromD3" = 0
    "DeviceWake" = 0
    "SystemWake" = 0
    "DeviceD1" = 0
    "DeviceD2" = 0
    "DeviceD3" = 0
    "WakeEnabled" = 0
    "DisableAllD3" = 1
}

$classCommonDevicePowerMap = [ordered]@{
    "IdleTimeout" = 0
    "ConservationTimeout" = 0
    "PerformanceTimeout" = 0
    "WakeEnabled" = 0
    "DeviceWake" = 0
    "SystemWake" = 0
    "DisableAllD3" = 1
}

$classCommonPciMap = [ordered]@{
    "ASPMOptOut" = 1
    "NoASPM" = 1
    "DisableASPM" = 1
    "ASPM" = 0
    "L0sLatency" = 0
    "L1Latency" = 0
    "EnableASPM" = 0
    "L0sSupported" = 0
    "L1Supported" = 0
    "ClockPowerManagement" = 0
    "CommonClockConfig" = 0
}

$classCommonWmiMap = [ordered]@{
    "IdleEnabled" = 0
    "IdleTimeout" = 0
}

$usbClassStorPortMap = [ordered]@{
    "EnableIdlePowerManagement" = 0
    "MinimumIdleTimeoutInMS" = 0
}

# ------------------------------------------------------------
# Generic device-enumeration overlay.
# This map covers the common generic device settings except for the intentionally
# excluded MSI/DMA/interrupt group.
# ------------------------------------------------------------
$genericEnumRoots = @(
    "USB","USBSTOR","HID","PCI","ACPI","SCSI","SWD","HDAUDIO",
    "DISPLAY","MONITOR","IDE","STORAGE","ROOT","UEFI","IOMMU","BTH",
    "BTHENUM","HTREE","SW","UMB","VMBUS","VPCI","GenCdRom","WPDBUSENUM",
    "COMPOSITEBUS","USB4","TBOLT"
)

function Apply-GenericOverlay([string]$InstancePath) {
    $dp = Join-Path $InstancePath 'Device Parameters'
    $d3 = Join-Path $dp 'e5b3b5ac-9725-4f78-963f-03dfb1d828c7'
    $wdf = Join-Path $dp 'WDF'
    $ceip = Join-Path $dp 'Ceip'
    Apply-Map $dp $genericDeviceMap
    Set-Dword $d3 'D3ColdSupported' 0
    Apply-Map $wdf $wdfMap
    if (Test-Path -LiteralPath $ceip) { Remove-Key $ceip }

    $disk = Join-Path $dp 'Disk'
    if (Test-Path -LiteralPath $disk) { Apply-Map $disk $diskMap }

    $storport = Join-Path $dp 'StorPort'
    if (Test-Path -LiteralPath $storport) { Apply-Map $storport $storPortMap }

    $classpnp = Join-Path $dp 'ClassPnP'
    if (Test-Path -LiteralPath $classpnp) {
        Set-Dword $classpnp 'IdleTimeout' 0
        Set-Dword $classpnp 'EnableIdlePowerManagement' 0
    }
}

function Apply-UsbEnumExtras([string]$InstancePath) {
    $dp = Join-Path $InstancePath 'Device Parameters'
    Apply-Map $dp $usb3GenericExtraMap
    Apply-Map (Join-Path $dp 'Power') $genericPowerSubkeyMap
    Apply-Map (Join-Path $dp 'WMI') $usb3WmiMap
    Apply-Map (Join-Path $dp 'StorPort') $usb3StorPortBaseMap

    foreach ($subKey in @(Get-ChildItem -LiteralPath $dp -Recurse -ErrorAction SilentlyContinue)) {
        $sp = $subKey.PSPath
        if ($subKey.PSChildName -in @('Power','WMI','StorPort')) { continue }
        Apply-Map $sp $usb3RecursiveMap
        $subPower = Join-Path $sp 'Power'
        if (Test-Path -LiteralPath $subPower) { Apply-Map $subPower $genericPowerSubkeyMap }
        $subWmi = Join-Path $sp 'WMI'
        if (Test-Path -LiteralPath $subWmi) { Apply-Map $subWmi $usb3WmiMap }
    }
}

function Apply-UsbInterfaceExtras([string]$InstancePath) {
    foreach ($iface in @(Get-ChildItem -LiteralPath $InstancePath -ErrorAction SilentlyContinue | Where-Object { $_.PSChildName -match '^#' -or $_.PSChildName -match '^Interface' })) {
        $ip = $iface.PSPath
        $ifDp = Join-Path $ip 'Device Parameters'
        if (Test-Path -LiteralPath $ifDp) {
            Apply-Map $ifDp $usb3GenericExtraMap
            Apply-Map (Join-Path $ifDp 'Power') $genericPowerSubkeyMap
        } else {
            Apply-Map $ip $usb3GenericExtraMap
        }

        foreach ($ifSub in @(Get-ChildItem -LiteralPath $ip -Recurse -ErrorAction SilentlyContinue)) {
            Apply-Map $ifSub.PSPath $usb3InterfaceMap
        }
    }
}

# ============================================================================
# EXECUTION PHASES
# ============================================================================

function Invoke-EnumMisc {
    Write-Host ''
    Write-Host '=== ENUM_MISC ===' -ForegroundColor Cyan
    # ============================================================================
    # ENUM\ACPI
    # ============================================================================
    $acpiBase = "HKLM:\SYSTEM\CurrentControlSet\Enum\ACPI"
    $acpiInstances = Get-ChildItem -Path $acpiBase -ErrorAction SilentlyContinue | ForEach-Object {
        Get-ChildItem -Path $_.PSPath -ErrorAction SilentlyContinue
    } | Where-Object { $_.GetValueNames() -contains "ClassGUID" -or $_.GetValueNames() -contains "Driver" }
    
    if ($acpiInstances) {
        Write-Host "ACPI: $($acpiInstances.Count) instance(s) found" -ForegroundColor Cyan
        foreach ($inst in $acpiInstances) {
            $p = $inst.PSPath
            $devId = Split-Path (Split-Path $p -Parent) -Leaf
            $instId = $inst.PSChildName
            $desc = (Get-ItemProperty -Path $p -Name "DeviceDesc" -ErrorAction SilentlyContinue).DeviceDesc
            $friendlyName = (Get-ItemProperty -Path $p -Name "FriendlyName" -ErrorAction SilentlyContinue).FriendlyName
            $label = if ($friendlyName) { $friendlyName } elseif ($desc) { $desc } else { "$devId\$instId" }
            Write-Host "[ACPI:$devId\$instId] $label" -ForegroundColor Yellow
            $dp = Join-Path $p "Device Parameters"
            Apply-CommonBlocks $dp
            Apply-AcpiConditionals $devId $dp
            Write-Host "  OK" -ForegroundColor Green
        }
    } else {
        Write-Host "ACPI instances not found" -ForegroundColor Red
    }
    
    # ============================================================================
    # ENUM\ACPI_HAL
    # ============================================================================
    $halBase = "HKLM:\SYSTEM\CurrentControlSet\Enum\ACPI_HAL"
    if (Test-Path $halBase) {
        $halInstances = Get-ChildItem -Path $halBase -ErrorAction SilentlyContinue | ForEach-Object {
            Get-ChildItem -Path $_.PSPath -ErrorAction SilentlyContinue
        }
        if ($halInstances) {
            Write-Host "ACPI_HAL: $($halInstances.Count) instance(s) found" -ForegroundColor Cyan
            foreach ($inst in $halInstances) {
                $p = $inst.PSPath
                $devId = Split-Path (Split-Path $p -Parent) -Leaf
                $instId = $inst.PSChildName
                $desc = (Get-ItemProperty -Path $p -Name "DeviceDesc" -ErrorAction SilentlyContinue).DeviceDesc
                $friendly = (Get-ItemProperty -Path $p -Name "FriendlyName" -ErrorAction SilentlyContinue).FriendlyName
                $label = if ($friendly) { $friendly } elseif ($desc) { $desc } else { "$devId\$instId" }
                Write-Host "[ACPI_HAL:$devId\$instId] $label" -ForegroundColor Yellow
                $dp = Join-Path $p "Device Parameters"
                Apply-CommonBlocks $dp
                foreach ($kv in $halTimerMap.GetEnumerator()) { Set-Dword $dp $kv.Key $kv.Value }
                foreach ($kv in $halCstateMap.GetEnumerator()) { Set-Dword $dp $kv.Key $kv.Value }
                foreach ($kv in $halApicMap.GetEnumerator()) { Set-Dword $dp $kv.Key $kv.Value }
                foreach ($kv in $halDmaMap.GetEnumerator()) { Set-Dword $dp $kv.Key $kv.Value }
                foreach ($kv in $halPstateMap.GetEnumerator()) { Set-Dword $dp $kv.Key $kv.Value }
                foreach ($kv in $halNumaMap.GetEnumerator()) { Set-Dword $dp $kv.Key $kv.Value }
                Write-Host "  OK" -ForegroundColor Green
            }
        } else {
            Write-Host "ACPI_HAL instances not found" -ForegroundColor Red
        }
    } else {
        Write-Host "ACPI_HAL root not found" -ForegroundColor Red
    }
    
    Write-Host "ACPI + ACPI_HAL dynamic sweep complete." -ForegroundColor Green
}

function Invoke-InputAudio {
    Write-Host ''
    Write-Host '=== INPUT_AUDIO ===' -ForegroundColor Cyan
    # ============================================================================
    # AUDIO CLASS: Control\Class\{4d36e96c-...}\000x
    # ============================================================================
    
    # Combined set of values applied at the root of each audio-class 000x key.
    $AudioClassRootSet = New-DwordSet `
      -Zero (Words '
            EnhancedPowerManagementEnabled
            AllowIdleIrpInD3
            DeviceSelectiveSuspended
            SelectiveSuspendEnabled
            IdleInWorkingState
            WakeEnabled
            WdfDirectedPowerTransitionEnable
            EnableSelectiveSuspend
            D3ColdSupported
            WaitWakeEnabled
            EnablePME
            EnableRuntimePM
            RuntimePMOnIdle
            RuntimeD3
            RuntimeD3Cold
            D3TransitionLatency
            D0TransitionLatency
            D1Latency
            D2Latency
            D3Latency
            EnableLPM
            EnablePCI_PM
            EnablePCIPME
            PMControl
            EnableAggressivePM
            EnableConnectedStandby
            ModernStandbyEnable
            CsEnabled
            PlatformAoAcOverride
            EnableSmartD3
            SmartD3Enable
            SystemWake
            DeviceWake
            DmaRemappingCompatible
            IoLatencyCap
            InterruptModeration
            InterruptModerationValue
            IdlePowerState
            LatencyToleranceHigh
            LatencyToleranceLow
            BestEffortServiceLatency
            LinkStateChangeLatency
            SurpriseRemovalOK
    
            IdlePowerManagement
            ConservationIdleTime
            PerformanceIdleTime
            IdleTimer
            SetPowerStateMappingToD3
            PowerSaveMode
            EnableDynamicDevices
            DisableJackDetectionAtBoot
        ') `
      -One (Words '
            DisableSelectiveSuspend
            DisableRuntimePowerManagement
            DisableLinkPowerManagement
            DisableIdlePowerManagement
            DisableRuntimeIdleDetection
            DisableAsyncSuspend
            DisableWake
            IoHighPriority
            DisableHwInterruptCoalescing
            DisableCompletionCoalescing
            DisableDynamicTickForIdleWorker
    
            DisablePowerSave
            JackDetectAtBoot
            EnableJackDetection
        ') `
      -Other @{
        DevicePriority = 3
        IRQPriority    = 1
      }
    
    # Values applied under:
    #
    #   000x\Device Parameters
    #
    $AudioClassDeviceParametersSet = New-DwordSet `
      -Zero (Words '
            EnhancedPowerManagementEnabled
            AllowIdleIrpInD3
            DeviceSelectiveSuspended
            SelectiveSuspendEnabled
            IdleInWorkingState
            WakeEnabled
            WdfDirectedPowerTransitionEnable
            EnableSelectiveSuspend
            D3ColdSupported
            WaitWakeEnabled
            EnableRuntimePM
            RuntimePMOnIdle
            RuntimeD3
            RuntimeD3Cold
            D3TransitionLatency
            D0TransitionLatency
            InterruptModeration
            InterruptModerationValue
            ModernStandbyEnable
            EnableConnectedStandby
            EnableSmartD3
            SmartD3Enable
            CsEnabled
            SystemWake
            DeviceWake
            IdleTimeout
            IdlePowerManagement
            ConservationIdleTime
            PerformanceIdleTime
            PowerSaveMode
        ') `
      -One (Words '
            DisableSelectiveSuspend
            DisableLinkPowerManagement
            DisableIdlePowerManagement
            DisableWake
            DisableCompletionCoalescing
            DisableHwInterruptCoalescing
            DisablePowerSave
        ') `
      -Other @{
        DevicePriority = 3
        IoHighPriority = 1
      }
    
    # ============================================================================
    # HDAUDIO: Enum\HDAUDIO\FUNC_*\...
    # ============================================================================
    
    # Combined values for the HDAUDIO Power-block and device settings.
    #
    # Applied by ProcessKey() to:
    #   Device Parameters
    #   descendants of Device Parameters
    #   top-level instance descendants
    $AudioEnumSet = New-DwordSet `
      -Zero (Words '
            EnhancedPowerManagementEnabled
            AllowIdleIrpInD3
            DeviceSelectiveSuspended
            SelectiveSuspendEnabled
            SelectiveSuspendOn
            IdleInWorkingState
            WakeEnabled
            WdfDirectedPowerTransitionEnable
            EnableSelectiveSuspend
            D3ColdSupported
            WaitWakeEnabled
            EnablePME
            EnableRuntimePM
            RuntimePMOnIdle
            RuntimeD3
            RuntimeD3Cold
            D3TransitionLatency
            D0TransitionLatency
            D1Latency
            D2Latency
            D3Latency
            EnableLPM
            LPMCapabilitySupported
            LPMExitLatency
            EnablePCI_PM
            EnablePCIPME
            PMControl
            EnableAggressivePM
            EnableConnectedStandby
            ModernStandbyEnable
            CsEnabled
            PlatformAoAcOverride
            EnableSmartD3
            SmartD3Enable
            WakeFromSleepEnabled
            WakeOnPatternMatch
            EnablePMWake
            PMEWakeEnabled
            SystemWake
            DeviceWake
            IoLatencyCap
            InterruptModeration
            InterruptModerationValue
            IdlePowerState
            LatencyToleranceHigh
            LatencyToleranceLow
            BestEffortServiceLatency
            LinkStateChangeLatency
            IdleTimeout
            ConservationIdleTime
            PerformanceIdleTime
            SurpriseRemovalOK
    
            IdlePowerManagement
            SetPowerStateMappingToD3
            IdleTimer
            CodecPowerDown
            PowerDownAfterLastStream
            PowerDownUnused
            IdleD3ExitLatency
            EnableDynamicDevices
            DisableJackDetectionAtBoot
            EnableAudioProcessing
            MinBufferDuration
            LatencyTimer
            DspBufferDuration
            DmaBufferSize
            DmaLatency
            DisableInterruptOnDma
            StreamWakeFromD3
            DeviceSleepEnabled
            EnableDeviceSleep
            EnableLowPowerState
        ') `
      -One (Words '
            DisableSelectiveSuspend
            DisableRuntimePowerManagement
            DisableLinkPowerManagement
            DisableIdlePowerManagement
            DisableRuntimeIdleDetection
            DisableAsyncSuspend
            DisableWake
            IoHighPriority
            DisableHwInterruptCoalescing
            DisableCompletionCoalescing
            DisableDynamicTickForIdleWorker
            DisablePowerSave
            DisableDeviceSleep
            DisableBusMasterOnSuspend
            DisablePortSuspend
    
            DisableSetPowerState
            HDAudioBusMasterMode
            DisablePositionNotifyOptimization
            EnablePositionNotify
            PositionNotifyAlwaysOn
            JackDetectAtBoot
            EnableJackDetection
            DisableProtectedContent
            DisableDSPEnhancedAudio
            DisableAudioEffects
            DisableAudioEnhancements
            DisableSoundEffects
            StreamPositionUpdateRate
            DisableStreamCoalescing
            PacketSizeInMs
            TransferMode
            ForceShortDmaTransfer
            EnableMultiStreaming
            EnableWaveRTPacketStreaming
            EnableBurstMode
        ') `
      -Other @{
        DevicePriority       = 3
        DmaRemappingCompatible = 0
        ReducedLatency       = 1
        LowLatencyMode       = 1
        DefaultSampleRate    = 48000
        DefaultBitsPerSample = 24
        WaveRTMinBufferSize  = 128
      }
    
    # ============================================================================
    # HID: Enum\HID\VID_*\...
    # ============================================================================
    
    # Combined values for the HID Power-block and device settings.
    #
    # ss_enabled is omitted because Registry value names are case-insensitive:
    # "ss_enabled" and "SS_Enabled" refer to the same registry value.
    $HidSet = New-DwordSet `
      -Zero (Words '
            EnhancedPowerManagementEnabled
            AllowIdleIrpInD3
            DeviceSelectiveSuspended
            SelectiveSuspendEnabled
            SelectiveSuspendOn
            IdleInWorkingState
            WakeEnabled
            WdfDirectedPowerTransitionEnable
            EnableSelectiveSuspend
            D3ColdSupported
            WaitWakeEnabled
            EnablePME
            EnableRuntimePM
            RuntimePMOnIdle
            RuntimeD3
            RuntimeD3Cold
            D3TransitionLatency
            D0TransitionLatency
            D1Latency
            D2Latency
            D3Latency
            EnableLPM
            LPMCapabilitySupported
            LPMExitLatency
            EnablePCI_PM
            EnablePCIPME
            PMControl
            EnableAggressivePM
            EnableConnectedStandby
            ModernStandbyEnable
            CsEnabled
            PlatformAoAcOverride
            EnableSmartD3
            SmartD3Enable
            WakeFromSleepEnabled
            WakeOnPatternMatch
            EnablePMWake
            PMEWakeEnabled
            SystemWake
            DeviceWake
            IoLatencyCap
            InterruptModeration
            InterruptModerationValue
            IdlePowerState
            LatencyToleranceHigh
            LatencyToleranceLow
            BestEffortServiceLatency
            LinkStateChangeLatency
            IdleTimeout
            ConservationIdleTime
            PerformanceIdleTime
            PowerSaveMode
            DeviceSleepEnabled
            EnableDeviceSleep
            EnableLowPowerState
            DmaRemappingCompatible
            SurpriseRemovalOK
    
            SS_Enabled
            SSEnabled
            EnableU1
            EnableU2
            EnableU1U2
            U1Timeout
            U2Timeout
            U1U2TransitionTimeout
            PortSuspend
            FlipFlopWheel
            WakeOnKeyboard
            WakeOnMouse
        ') `
      -One (Words '
            DisableSelectiveSuspend
            DisableRuntimePowerManagement
            DisableLinkPowerManagement
            DisableIdlePowerManagement
            DisableRuntimeIdleDetection
            DisableAsyncSuspend
            DisableWake
            IoHighPriority
            DisableHwInterruptCoalescing
            DisableCompletionCoalescing
            DisableDynamicTickForIdleWorker
            DisablePowerSave
            DisableDeviceSleep
            ReducedLatency
            LowLatencyMode
            NoSS
            ELD
            iSchedLatency
            DisableBusMasterOnSuspend
            DisablePortSuspend
        ') `
      -Other @{
        DevicePriority        = 3
        U1U2DisableMode       = 3
        # MouseDataQueueSize    = 32   # (fixed setting; defined only in the companion REG file under Services\mouclass / kbdclass, not per device instance)
        # KeyboardDataQueueSize = 32   # (fixed setting; defined only in the companion REG file under Services\mouclass / kbdclass, not per device instance)
      }
    
    # The direct HID instance\Device Parameters key receives this additional
    # value; it is not propagated to descendant keys.
    $HidDirectSet = $HidSet.Clone()
    $HidDirectSet['IdleUsbInSelectiveSuspend'] = 0
    
    # ============================================================================
    # USB ENDPOINTS: Enum\USB\...\...\Device Parameters
    # ============================================================================
    
    $UsbEndpointSet = New-DwordSet `
      -Zero (Words '
            SelectiveSuspendEnabled
            EnhancedPowerManagementEnabled
            AllowIdleIrpInD3
            IdleUsbInSelectiveSuspend
        ') `
      -One @()
    
    # ============================================================================
    # AUDIO CLASS DRIVER: Control\Class\...\000x
    # ============================================================================
    
    $classRoot = 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e96c-e325-11ce-bfc1-08002be10318}'
    
    $classKeys = Get-ChildItem -LiteralPath $classRoot |
      Where-Object {
        $_.PSChildName -match '^\d{4}$'
      } |
      Sort-Object {
        [int]$_.PSChildName
      }
    
    if (-not $classKeys) {
      Write-Host 'Audio class keys not found' -ForegroundColor Red
      return
    }
    
    foreach ($key in $classKeys) {
      $desc = (
        Get-ItemProperty `
          -LiteralPath $key.PSPath `
          -Name 'DriverDesc'
      ).DriverDesc
    
      Write-Host `
        "[$($key.PSChildName)] $desc" `
        -ForegroundColor Yellow
    
      # 000x root
      Set-Dwords $key.PSPath $AudioClassRootSet
    
      # 000x\Device Parameters
      $dp = Join-Path $key.PSPath 'Device Parameters'
      Set-Dwords $dp $AudioClassDeviceParametersSet
    
      # 000x\Power
      Set-Dwords `
        (Join-Path $key.PSPath 'Power') `
        $PowerSub
    
      # 000x\Device Parameters\Power
      Set-Dwords `
        (Join-Path $dp 'Power') `
        $AudioClassDevicePowerSet
    
      # 000x\Device Parameters\WMI
      Set-Dwords `
        (Join-Path $dp 'WMI') `
        $WmiSet
    
      # 000x\PCI
      Set-Dwords `
        (Join-Path $key.PSPath 'PCI') `
        $PciSet
    
      Write-Host '  OK' -ForegroundColor Green
    }
    
    # ============================================================================
    # HDAUDIO: the HDAUDIO configuration
    # ============================================================================
    
    $hdaRoot = 'HKLM:\SYSTEM\CurrentControlSet\Enum\HDAUDIO'
    
    if (-not (Test-Path -LiteralPath $hdaRoot)) {
      Write-Host 'HDAUDIO root not found' -ForegroundColor Red
      return
    }
    
    $funcKeys = Get-ChildItem -LiteralPath $hdaRoot
    
    if (-not $funcKeys) {
      Write-Host 'HDAUDIO FUNC keys not found' -ForegroundColor Red
      return
    }
    
    foreach ($func in $funcKeys) {
      $instKeys = Get-ChildItem -LiteralPath $func.PSPath
    
      foreach ($inst in $instKeys) {
        $devId  = $func.PSChildName
        $instId = $inst.PSChildName
    
        $desc = (
          Get-ItemProperty `
            -LiteralPath $inst.PSPath `
            -Name 'DeviceDesc' `
            -ErrorAction SilentlyContinue
        ).DeviceDesc
    
        $friendly = (
          Get-ItemProperty `
            -LiteralPath $inst.PSPath `
            -Name 'FriendlyName' `
            -ErrorAction SilentlyContinue
        ).FriendlyName
    
        $label = if ($friendly) {
          $friendly
        } elseif ($desc) {
          $desc
        } else {
          $devId
        }
    
        Write-Host `
          "[$devId\$instId] $label" `
          -ForegroundColor Yellow
    
        # Device Parameters
        $dp = Join-Path $inst.PSPath 'Device Parameters'
    
        Write-Host `
          '  -> Device Parameters' `
          -ForegroundColor DarkGray
    
        Process-Node $dp $AudioEnumSet
    
        # Device Parameters\PCI
        Set-Dwords `
          (Join-Path $dp 'PCI') `
          $PciSet
    
        # All instance-level descendants except Device Parameters / Properties
        $topSubs = Get-ChildItem -LiteralPath $inst.PSPath |
          Where-Object {
            $_.PSChildName -ne 'Device Parameters' -and
            $_.PSChildName -ne 'Properties'
          }
    
        foreach ($ts in $topSubs) {
          Write-Host `
            "  -> $($ts.PSChildName)" `
            -ForegroundColor DarkGray
    
          Process-Node $ts.PSPath $AudioEnumSet
        }
    
        Write-Host '  OK' -ForegroundColor Green
      }
    }
    
    # ============================================================================
    # HID: the HID configuration + the HID timeout configuration
    # ============================================================================
    
    $hidRoot = 'HKLM:\SYSTEM\CurrentControlSet\Enum\HID'
    
    if (-not (Test-Path -LiteralPath $hidRoot)) {
      Write-Host 'HID root not found' -ForegroundColor Red
      return
    }
    
    $vidKeys = Get-ChildItem -LiteralPath $hidRoot
    
    foreach ($vid in $vidKeys) {
      $instKeys = Get-ChildItem -LiteralPath $vid.PSPath
    
      foreach ($inst in $instKeys) {
        $devId  = $vid.PSChildName
        $instId = $inst.PSChildName
    
        $desc = (
          Get-ItemProperty `
            -LiteralPath $inst.PSPath `
            -Name 'DeviceDesc' `
            -ErrorAction SilentlyContinue
        ).DeviceDesc
    
        $friendly = (
          Get-ItemProperty `
            -LiteralPath $inst.PSPath `
            -Name 'FriendlyName' `
            -ErrorAction SilentlyContinue
        ).FriendlyName
    
        $label = if ($friendly) {
          $friendly
        } elseif ($desc) {
          $desc
        } else {
          $devId
        }
    
        Write-Host `
          "[$devId\$instId] $label" `
          -ForegroundColor Yellow
    
        # Direct Device Parameters also receives this value:
        # IdleUsbInSelectiveSuspend = 0.
        $dp = Join-Path $inst.PSPath 'Device Parameters'
    
        Write-Host `
          '  -> Device Parameters' `
          -ForegroundColor DarkGray
    
        Process-HidDeviceParameters $dp
    
        # Additional instance-level setting:
        #
        #   Enum\HID\...\instance\Power\D3ColdSupported = 0
        Set-Dwords `
          (Join-Path $inst.PSPath 'Power') `
          @{ D3ColdSupported = 0 }
    
        # Other instance-level descendants
        $topSubs = Get-ChildItem -LiteralPath $inst.PSPath |
          Where-Object {
            $_.PSChildName -ne 'Device Parameters' -and
            $_.PSChildName -ne 'Properties'
          }
    
        foreach ($ts in $topSubs) {
          Write-Host `
            "  -> $($ts.PSChildName)" `
            -ForegroundColor DarkGray
    
          Process-Node $ts.PSPath $HidSet
        }
    
        Write-Host '  OK' -ForegroundColor Green
      }
    }
    
    # ============================================================================
    # USB ENDPOINTS
    # ============================================================================
    
    $usbRoot = 'HKLM:\SYSTEM\CurrentControlSet\Enum\USB'
    $usbCount = 0
    
    if (Test-Path -LiteralPath $usbRoot) {
      foreach ($vid in Get-ChildItem -LiteralPath $usbRoot) {
        foreach ($inst in Get-ChildItem -LiteralPath $vid.PSPath) {
    
          $compatibleIds = (
            Get-ItemProperty `
              -LiteralPath $inst.PSPath `
              -Name 'CompatibleIDs' `
              -ErrorAction SilentlyContinue
          ).CompatibleIDs
    
          # Skip USB hubs (Class_09).
          if ($compatibleIds -match 'Class_09') {
            continue
          }
    
          Set-Dwords `
            (Join-Path $inst.PSPath 'Device Parameters') `
            $UsbEndpointSet
    
          $usbCount++
        }
      }
    }
    
    # ============================================================================
    # STATIC USB SERVICE PARAMETERS
    #
    # These fixed service settings are intentionally handled only by the
    # companion REG file, not written by this dynamic script.
    #
    #   Services\USB\Parameters
    #   Services\USBHUB3\Parameters
    #   Services\USBXHCI\Parameters
    #   Services\USBHUB\Parameters
    #
    # This avoids duplicate writes between the PS1 and REG files.
    # ============================================================================
    
    Write-Host ''
    
    Write-Host `
      ("USB endpoints tuned: {0}" -f $usbCount) `
      -ForegroundColor Green
    
    Write-Host `
      'Dynamic input/audio sweep complete.' `
      -ForegroundColor Green
    
}

function Invoke-StorageKernel {
    Write-Host ''
    Write-Host '=== STORAGE_KERNEL ===' -ForegroundColor Cyan
    # ========================= PCI ENUMERATION =========================
    $PciBase = "HKLM:\SYSTEM\CurrentControlSet\Enum\PCI"
    if (Test-Path -LiteralPath $PciBase) {
        function Process-PCIKey {
            param([string]$Path,[int]$Depth=0)
            Apply-Map $Path $PciPowerBlock
            # CONFLICT (same destination: Enum\PCI\<dev>\<inst>\Device Parameters, Depth 0):
            #   # MaxPayloadSize     = 512   <- Storage variant (loses precedence here)
            #   # MaxReadRequestSize = 512   <- Storage variant (loses precedence here)
            #   MaxPayloadSize = 0 and MaxReadRequestSize = 0 <- USB overlay (wins here)
            # The USB overlay does not write these values in descendants (Depth >= 1), so 512 remains there.
            if ($Depth -eq 0) { Apply-Map $Path $PciExpressBlock -Skip @('MaxPayloadSize','MaxReadRequestSize') }
            else              { Apply-Map $Path $PciExpressBlock }
            Apply-Map (Join-Path $Path 'Power') $PciPowerSubkey
            $wmi = Join-Path $Path 'WMI'
            Set-Dword $wmi 'IdleEnabled' 0
            Set-Dword $wmi 'IdleTimeout' 0
    
            $children = Get-ChildItem -LiteralPath $Path -ErrorAction SilentlyContinue
            foreach ($child in $children) {
                $cn = $child.PSChildName
                if ($cn -eq 'Power' -or $cn -eq 'WMI' -or $cn -eq 'Properties') { continue }
                Process-PCIKey -Path $child.PSPath -Depth ($Depth + 1)
            }
        }
    
        foreach ($dev in Get-ChildItem -LiteralPath $PciBase -ErrorAction SilentlyContinue) {
            foreach ($inst in Get-ChildItem -LiteralPath $dev.PSPath -ErrorAction SilentlyContinue) {
                $dp = Join-Path $inst.PSPath 'Device Parameters'
                Process-PCIKey -Path $dp
    
                $topSubs = Get-ChildItem -LiteralPath $inst.PSPath -ErrorAction SilentlyContinue |
                    Where-Object { $_.PSChildName -ne 'Device Parameters' -and $_.PSChildName -ne 'Properties' }
                foreach ($ts in $topSubs) { Process-PCIKey -Path $ts.PSPath -Depth 1 }
            }
        }
    }
    
    # ========================= SCSI ENUMERATION =========================
    $ScsiRoot = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey('SYSTEM\CurrentControlSet\Enum\SCSI')
    if ($ScsiRoot) {
        foreach ($devName in $ScsiRoot.GetSubKeyNames()) {
            $devKey = $ScsiRoot.OpenSubKey($devName)
            if (-not $devKey) { continue }
            foreach ($instName in $devKey.GetSubKeyNames()) {
                $instPath = "HKLM:\SYSTEM\CurrentControlSet\Enum\SCSI\$devName\$instName"
                $dp = "$instPath\Device Parameters"
                Apply-Map $dp $PciPowerBlock
                Apply-Map $dp $ScsiDiskBlock
                # CONFLICT at Enum\SCSI\...\Device Parameters\Disk:
                #   # TimeoutValue = 30   <- Storage variant (loses precedence here)
                #   TimeoutValue = 60     <- USB overlay (wins here)
                Apply-Map "$dp\Disk" $ScsiDiskBlock -Skip @('TimeoutValue')
                # CONFLICT at Enum\SCSI\...\Device Parameters\Storport:
                #   # BusyRetryCount = 0              <- Storage variant (loses precedence here)
                #   # QueueFullWaitIoPercentage = 100 <- Storage variant (loses precedence here)
                #   BusyRetryCount = 255 and QueueFullWaitIoPercentage = 25 <- USB overlay (wins here)
                Apply-Map "$dp\Storport" $ScsiStorPortEffective -Skip @('BusyRetryCount','QueueFullWaitIoPercentage')
                Apply-Map "$dp\Partmgr" $ScsiPartmgrEffective
                Set-Dword "$dp\ClassPnP" 'IdleTimeout' 0
                Set-Dword "$dp\ClassPnP" 'DisableIdleTimeout' 1
                Set-Dword "$dp\ClassPnP" 'IoLatencyMs' 0
                Set-Dword "$dp\ClassPnP" 'IoTimeoutMs' 30000
                Apply-Map "$dp\Power" $ScsiPowerSubkey
                Set-Dword "$dp\WMI" 'IdleEnabled' 0
                Set-Dword "$dp\WMI" 'IdleTimeout' 0
    
                $dpKey = $null
                try { $dpKey = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey("SYSTEM\CurrentControlSet\Enum\SCSI\$devName\$instName\Device Parameters") } catch {}
                if ($dpKey) {
                    foreach ($subName in $dpKey.GetSubKeyNames()) {
                        if ($subName -match '^(Disk|Storport|Partmgr|ClassPnP|Power|WMI|Properties)$') { continue }
                        $subPath = "$dp\$subName"
                        Apply-Map $subPath $PciPowerBlock
                        Apply-Map "$subPath\Power" $ScsiPowerSubkey
                        Set-Dword "$subPath\WMI" 'IdleEnabled' 0
                        Set-Dword "$subPath\WMI" 'IdleTimeout' 0
                    }
                    $dpKey.Close()
                }
    
                $instRegKey = $null
                try { $instRegKey = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey("SYSTEM\CurrentControlSet\Enum\SCSI\$devName\$instName") } catch {}
                if ($instRegKey) {
                    foreach ($topSubName in $instRegKey.GetSubKeyNames()) {
                        if ($topSubName -match '^(Device Parameters|Properties)$') { continue }
                        $topSubPath = "$instPath\$topSubName"
                        Apply-Map $topSubPath $PciPowerBlock
                        Apply-Map "$topSubPath\Power" $ScsiPowerSubkey
                    }
                    $instRegKey.Close()
                }
            }
            $devKey.Close()
        }
        $ScsiRoot.Close()
    }
    
    # ======================== STORAGE CLASS ENUM =======================
    $StorageBase = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e967-e325-11ce-bfc1-08002be10318}"
    $StorageSubs = Get-ChildItem -LiteralPath $StorageBase -ErrorAction SilentlyContinue |
        Where-Object { $_.PSChildName -match '^\d{4}$' } |
        Sort-Object { [int]$_.PSChildName }
    
    foreach ($sub in $StorageSubs) {
        $p = $sub.PSPath
        Apply-Map $p $StorageClassRootBlock
    
        $dp = Join-Path $p 'Device Parameters'
        Apply-Map $dp $StorageDeviceParameters
        Apply-Map (Join-Path $dp 'Disk') $StorageDisk
        Apply-Map (Join-Path $dp 'StorPort') $StorageStorPort
        Apply-Map (Join-Path $dp 'ClassPnP') $StorageClassPnP
        Apply-Map (Join-Path $dp 'WMI') $StorageWMI
        Apply-Map (Join-Path $p 'PCI') $StoragePCI
        Apply-Map (Join-Path $p 'Power') $StoragePower
        Apply-Map (Join-Path $dp 'Power') $StorageDevicePower
    }
    
    # ======================== HVCI / HYPERVISOR BOOT ========================
    # This is a boot-configuration command, not a registry value, so it must
    # remain an executable command rather than a REG entry/comment-only item.
    try {
        & bcdedit.exe /set hypervisorlaunchtype off | Out-Null
    } catch {}
    
    Write-Host 'STORAGE_KERNEL master complete.' -ForegroundColor Green
}

function Invoke-UsbTune {
    Write-Host ''
    Write-Host '=== USB ===' -ForegroundColor Cyan
    # ------------------------------------------------------------
    # Generic device enumeration. USB gets the usb3 specialization
    # before the final USB overlay, preserving the documented precedence order.
    # ------------------------------------------------------------
    foreach ($rootName in $genericEnumRoots) {
        $base = "HKLM:\SYSTEM\CurrentControlSet\Enum\$rootName"
        if (-not (Test-Path -LiteralPath $base)) { continue }
    
        foreach ($dev in @(Get-ChildItem -LiteralPath $base -ErrorAction SilentlyContinue)) {
            foreach ($inst in @(Get-ChildItem -LiteralPath $dev.PSPath -ErrorAction SilentlyContinue)) {
                $p = $inst.PSPath
                if ($rootName -eq 'USB') {
                    Apply-UsbEnumExtras $p
                }
                Apply-GenericOverlay $p
                if ($rootName -eq 'USB') {
                    Apply-UsbInterfaceExtras $p
                }
            }
        }
    }
    
    # ------------------------------------------------------------
    # USB class {36fc9e60-...}
    # ------------------------------------------------------------
    $usbClassBase = 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{36fc9e60-c465-11cf-8056-444553540000}'
    $usbClassSubs = @(Get-ChildItem -LiteralPath $usbClassBase -ErrorAction SilentlyContinue | Where-Object { $_.PSChildName -match '^\d{4}$' } | Sort-Object { [int]$_.PSChildName })
    foreach ($sub in $usbClassSubs) {
        $p = $sub.PSPath
        Apply-Map $p $classCommonMap
        Apply-Map $p $usbClass1ExtraMap
        $dp = Join-Path $p 'Device Parameters'
        Apply-Map $dp $classCommonDeviceParametersMap
        Apply-Map $dp $usbClass1DeviceParametersExtraMap
        Apply-Map (Join-Path $dp 'WMI') $classCommonWmiMap
        Apply-Map (Join-Path $dp 'StorPort') $usbClassStorPortMap
        Apply-Map (Join-Path $p 'PCI') $classCommonPciMap
        Apply-Map (Join-Path $p 'Power') $classCommonPowerMap
        Apply-Map (Join-Path $dp 'Power') $classCommonDevicePowerMap
    }
    
    # ------------------------------------------------------------
    # HID class {745a17a0-...}
    # ------------------------------------------------------------
    $hidClassBase = 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{745a17a0-74d3-11d0-b6fe-00a0c90f57da}'
    $hidClassSubs = @(Get-ChildItem -LiteralPath $hidClassBase -ErrorAction SilentlyContinue | Where-Object { $_.PSChildName -match '^\d{4}$' } | Sort-Object { [int]$_.PSChildName })
    foreach ($sub in $hidClassSubs) {
        $p = $sub.PSPath
        Apply-Map $p $classCommonMap
        Apply-Map $p $hidClassExtraMap
        $dp = Join-Path $p 'Device Parameters'
        Apply-Map $dp $classCommonDeviceParametersMap
        Apply-Map $dp $hidClassDeviceParametersExtraMap
        Apply-Map (Join-Path $dp 'WMI') $classCommonWmiMap
        Apply-Map (Join-Path $p 'PCI') $classCommonPciMap
        Apply-Map (Join-Path $p 'Power') $classCommonPowerMap
        Apply-Map (Join-Path $dp 'Power') $classCommonDevicePowerMap
    }
    
    # ------------------------------------------------------------
    # Dynamic TCP interface sweep.
    # ------------------------------------------------------------
    $tcpIntPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces'
    foreach ($iface in @(Get-ChildItem -LiteralPath $tcpIntPath -ErrorAction SilentlyContinue)) {
        Set-Dword $iface.PSPath 'TcpAckFrequency' 1
        Set-Dword $iface.PSPath 'TcpNoDelay' 1
        Set-Dword $iface.PSPath 'TcpDelAckTicks' 0
        Set-Dword $iface.PSPath 'TCPNoNagle' 1
    }
    
    # ------------------------------------------------------------
    # WMI Autologger sweep.
    # ------------------------------------------------------------
    $wmiPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\WMI\Autologger'
    foreach ($logger in @(Get-ChildItem -LiteralPath $wmiPath -ErrorAction SilentlyContinue)) {
        Set-Dword $logger.PSPath 'Start' 0
    }
}

Invoke-EnumMisc
Invoke-InputAudio
Invoke-StorageKernel
Invoke-UsbTune

Write-Host ''
Write-Host ("MONSTER MASTER complete. Cached redundant writes: {0}" -f $script:WriteCache.Count) -ForegroundColor Green
