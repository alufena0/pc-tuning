rem # Remove StartUp Programs

reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\RunNotification" /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce" /f

reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved" /f

PAUSE