@echo off
if "%~1" neq "running" (start "" /b cmd /c "%~f0" running & exit /b) else (cd /d "%~dp0")
set "TargetDir=%USERPROFILE%\AppData\Local\Packages"
takeown /f "%TargetDir%" /r /d y
icacls "%TargetDir%" /inheritance:e /t /c
icacls "%TargetDir%" /reset /t /c
icacls "%TargetDir%" /grant *S-1-5-32-544:F /t /c
icacls "%TargetDir%" /grant *S-1-5-32-545:F /t /c
icacls "%TargetDir%" /grant "%USERNAME%":F /t /c
exit