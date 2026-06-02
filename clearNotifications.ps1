# https://www.reddit.com/r/PowerShell/comments/qzxh5n/comment/ioeb90b/?sort=new
[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null

# get the list of all registry keys
$notifications = Get-ChildItem HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings | Select-Object Name

# iterate through the keys, extract the name that will be used in the clear function, and clear the notifications
for ($index = 0; $index -lt $notifications.Count; $index++) {
    $name = $notifications[$index]
    $split = $name -split "\\"
    $last = $split[$split.Count - 1]
    $last = $last.Substring(0, $last.Length - 1)
    ([Windows.UI.Notifications.ToastNotificationManager]::History).clear($last)
}