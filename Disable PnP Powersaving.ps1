# Disable PnP Powersaving
# Disables power management specifically for USB PnP devices
# Targets USB Controllers and USB Hubs via WMI instance name matching
# Run as Administrator

$powerMgmt = Get-WmiObject MSPower_DeviceEnable -Namespace root\wmi

foreach ($class in @('Win32_USBController', 'Win32_USBHub')) {
    $devices = Get-WmiObject $class
    foreach ($p in $powerMgmt) {
        $IN = $p.InstanceName.ToUpper()
        foreach ($d in $devices) {
            if ($IN -like "*$($d.PNPDeviceID)*") {
                $p.enable = $false
                $p.psbase.put() | Out-Null
            }
        }
    }
}