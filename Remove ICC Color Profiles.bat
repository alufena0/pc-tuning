if "%~1" neq "running" (start "" /b cmd /c "%~f0" running & exit /b) else (cd /d "%~dp0")
takeown /f "%SystemRoot%\System32\spool\drivers\color" /r /d y >nul
icacls "%SystemRoot%\System32\spool\drivers\color" /grant Administrators:F /t >nul
del /f /s /q "%SystemRoot%\System32\spool\drivers\color\*.*" >nul
for /D %%D in ("%SystemRoot%\System32\spool\drivers\color\*") do rmdir /s /q "%%D"
timeout /t 3 >nul
exit