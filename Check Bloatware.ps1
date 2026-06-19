$sep = '=' * 80

$Host.UI.RawUI.BackgroundColor = 'Black'
$Host.UI.RawUI.ForegroundColor = 'Green'
Clear-Host

# [1] ENABLED FEATURES
$section1 = DISM /Online /Get-Features /Format:Table | Where-Object { $_ -match 'Enabled' }
$count1 = ($section1 | Measure-Object).Count
Write-Host "`n$sep" -ForegroundColor Cyan
Write-Host "[1] ENABLED FEATURES  ($count1)" -ForegroundColor Yellow
Write-Host "$sep`n" -ForegroundColor Cyan
$section1

# [2] INSTALLED CAPABILITIES
$section2 = Get-WindowsCapability -Online | Where-Object { $_.State -eq 'Installed' }
$count2 = ($section2 | Measure-Object).Count
Write-Host "`n$sep" -ForegroundColor Cyan
Write-Host "[2] INSTALLED CAPABILITIES  ($count2)" -ForegroundColor Yellow
Write-Host "$sep`n" -ForegroundColor Cyan
$section2 | Select-Object Name, State | Format-Table -AutoSize

# [3] APPX ALL USERS
$section3 = Get-AppxPackage -AllUsers | Sort-Object Name
$count3 = ($section3 | Measure-Object).Count
Write-Host "`n$sep" -ForegroundColor Cyan
Write-Host "[3] APPX ALL USERS  ($count3)" -ForegroundColor Yellow
Write-Host "$sep`n" -ForegroundColor Cyan
$section3 | Select-Object Name, NonRemovable | Format-Table -AutoSize

# [4] APPX PROVISIONED
$section4 = Get-AppxProvisionedPackage -Online | Sort-Object DisplayName
$count4 = ($section4 | Measure-Object).Count
Write-Host "`n$sep" -ForegroundColor Cyan
Write-Host "[4] APPX PROVISIONED  ($count4)" -ForegroundColor Yellow
Write-Host "$sep`n" -ForegroundColor Cyan
$section4 | Select-Object DisplayName | Format-Table -AutoSize

# [5] ALL RUNNING SCHEDULED TASKS
$section5 = Get-ScheduledTask | Where-Object { $_.State -ne 'Disabled' } | Sort-Object TaskPath, TaskName
$count5 = ($section5 | Measure-Object).Count
Write-Host "`n$sep" -ForegroundColor Cyan
Write-Host "[5] ALL RUNNING SCHEDULED TASKS  ($count5)" -ForegroundColor Yellow
Write-Host "$sep`n" -ForegroundColor Cyan
$section5 | Select-Object TaskName, TaskPath, State | Format-Table -AutoSize

# [6] ALL RUNNING SERVICES
$section6 = Get-Service | Where-Object { $_.Status -eq 'Running' } | Sort-Object Name
$count6 = ($section6 | Measure-Object).Count
Write-Host "`n$sep" -ForegroundColor Cyan
Write-Host "[6] ALL RUNNING SERVICES  ($count6)" -ForegroundColor Yellow
Write-Host "$sep`n" -ForegroundColor Cyan
$section6 | Select-Object Name, DisplayName, StartType | Format-Table -AutoSize

# [7] ALL RUNNING DRIVERS
$section7 = Get-WmiObject Win32_SystemDriver | Where-Object { $_.State -eq 'Running' } | Sort-Object Name
$count7 = ($section7 | Measure-Object).Count
Write-Host "`n$sep" -ForegroundColor Cyan
Write-Host "[7] ALL RUNNING DRIVERS  ($count7)" -ForegroundColor Yellow
Write-Host "$sep`n" -ForegroundColor Cyan
$section7 | Select-Object Name, DisplayName, PathName | Format-Table -AutoSize

# [8] STARTUP PROGRAMS
$section8 = Get-CimInstance Win32_StartupCommand
$count8 = ($section8 | Measure-Object).Count
Write-Host "`n$sep" -ForegroundColor Cyan
Write-Host "[8] STARTUP PROGRAMS  ($count8)" -ForegroundColor Yellow
Write-Host "$sep`n" -ForegroundColor Cyan
$section8 | Select-Object Name, Command, Location, User | Format-Table -AutoSize

# [9] INSTALLED PROGRAMS (Win32)
$section9 = Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*","HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" |
    Where-Object { $_.DisplayName } | Sort-Object DisplayName
$count9 = ($section9 | Measure-Object).Count
Write-Host "`n$sep" -ForegroundColor Cyan
Write-Host "[9] INSTALLED PROGRAMS (Win32)  ($count9)" -ForegroundColor Yellow
Write-Host "$sep`n" -ForegroundColor Cyan
$section9 | Select-Object DisplayName, Publisher, InstallDate | Format-Table -AutoSize

Read-Host "`nDone. Press Enter to close"
