# Disable All Device Manager Power Management
# Disables power management for ALL devices (USB, NIC, audio, storage, etc.)
# Run as Administrator

# Disable 'Allow the computer to turn off this device to save power' - all devices
# Also writes IdleInWorkingState=0 per device in registry (persistent)
$basePath = 'HKLM\SYSTEM\ControlSet001\Enum'
Get-CimInstance -Namespace root\wmi -ClassName MSPower_DeviceEnable -ErrorAction SilentlyContinue | ForEach-Object {
    Set-CimInstance -InputObject $_ -Property @{ Enable = $false }
    $instanceID = $_.InstanceName -replace '_0$', ''
    reg add "$basePath\$instanceID\Device Parameters\WDF" /v 'IdleInWorkingState' /t REG_DWORD /d '0' /f *>$null
}

# Disable 'Allow this device to wake the computer' - all wake_armed devices via powercfg (persistent)
foreach ($line in (powercfg -devicequery wake_armed)) {
    if ($line -ne 'NONE') {
        powercfg -devicedisablewake "$line" *>$null
    }
}