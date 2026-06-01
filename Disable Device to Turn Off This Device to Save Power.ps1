# Disable 'Allow the computer to turn off this device to save power'
# Disable 'Allow this device to wake the computer'
# Run as Administrator

$devices    = Get-WmiObject Win32_PnPEntity
$powerOff   = Get-WmiObject MSPower_DeviceEnable  -Namespace root\wmi
$powerWake  = Get-WmiObject MSPower_DeviceWakeEnable -Namespace root\wmi

foreach ($p in $powerOff) {
    $IN = $p.InstanceName.ToUpper()
    foreach ($d in $devices) {
        if ($IN -like "*$($d.PNPDeviceID)*") {
            $p.enable = $false
            $p.psbase.put() | Out-Null
        }
    }
}

foreach ($p in $powerWake) {
    $IN = $p.InstanceName.ToUpper()
    foreach ($d in $devices) {
        if ($IN -like "*$($d.PNPDeviceID)*") {
            $p.enable = $false
            $p.psbase.put() | Out-Null
        }
    }
}