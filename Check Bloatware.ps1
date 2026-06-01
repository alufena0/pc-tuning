$sep = '=' * 80

$Host.UI.RawUI.BackgroundColor = 'Black'
$Host.UI.RawUI.ForegroundColor = 'Green'
Clear-Host

Write-Host "`n$sep" -ForegroundColor Cyan
Write-Host "[1] ENABLED FEATURES" -ForegroundColor Yellow
Write-Host "$sep`n" -ForegroundColor Cyan
DISM /Online /Get-Features /Format:Table | Where-Object { $_ -match 'Enabled' }

Write-Host "`n$sep" -ForegroundColor Cyan
Write-Host "[2] INSTALLED CAPABILITIES" -ForegroundColor Yellow
Write-Host "$sep`n" -ForegroundColor Cyan
Get-WindowsCapability -Online | Where-Object { $_.State -eq 'Installed' } | Select-Object Name, State | Format-Table -AutoSize

Write-Host "`n$sep" -ForegroundColor Cyan
Write-Host "[3] APPX ALL USERS" -ForegroundColor Yellow
Write-Host "$sep`n" -ForegroundColor Cyan
Get-AppxPackage -AllUsers | Select-Object Name, NonRemovable | Sort-Object Name | Format-Table -AutoSize

Write-Host "`n$sep" -ForegroundColor Cyan
Write-Host "[4] APPX PROVISIONED" -ForegroundColor Yellow
Write-Host "$sep`n" -ForegroundColor Cyan
Get-AppxProvisionedPackage -Online | Select-Object DisplayName | Sort-Object DisplayName | Format-Table -AutoSize

Write-Host "`n$sep" -ForegroundColor Cyan
Write-Host "[5] ALL RUNNING SCHEDULED TASKS" -ForegroundColor Yellow
Write-Host "$sep`n" -ForegroundColor Cyan
Get-ScheduledTask | Where-Object { $_.State -ne 'Disabled' } | Select-Object TaskName, TaskPath, State | Sort-Object TaskPath, TaskName | Format-Table -AutoSize

Write-Host "`n$sep" -ForegroundColor Cyan
Write-Host "[6] ALL RUNNING SERVICES" -ForegroundColor Yellow
Write-Host "$sep`n" -ForegroundColor Cyan
Get-Service | Where-Object { $_.Status -eq 'Running' } | Select-Object Name, DisplayName, StartType | Sort-Object Name | Format-Table -AutoSize

Write-Host "`n$sep" -ForegroundColor Cyan
Write-Host "[7] ALL RUNNING DRIVERS" -ForegroundColor Yellow
Write-Host "$sep`n" -ForegroundColor Cyan
Get-WmiObject Win32_SystemDriver | Where-Object { $_.State -eq 'Running' } | Select-Object Name, DisplayName, PathName | Sort-Object Name | Format-Table -AutoSize

Write-Host "`n$sep" -ForegroundColor Cyan
Write-Host "[8] STARTUP PROGRAMS" -ForegroundColor Yellow
Write-Host "$sep`n" -ForegroundColor Cyan
Get-CimInstance Win32_StartupCommand | Select-Object Name, Command, Location, User | Format-Table -AutoSize

Write-Host "`n$sep" -ForegroundColor Cyan
Write-Host "[9] INSTALLED PROGRAMS (Win32)" -ForegroundColor Yellow
Write-Host "$sep`n" -ForegroundColor Cyan
Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*","HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" | Where-Object { $_.DisplayName } | Select-Object DisplayName, Publisher, InstallDate | Sort-Object DisplayName | Format-Table -AutoSize

Read-Host "`nDone. Press Enter to close"