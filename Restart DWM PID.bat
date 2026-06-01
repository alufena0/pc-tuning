@echo off
setlocal enabledelayedexpansion

echo Restarting Desktop Window Manager until PID < 1000...

:RESTART
taskkill /f /im dwm.exe >nul 2>&1
echo Waiting for DWM to stop...
timeout /t 3 /nobreak >nul

rem Start the process
start "" "%SystemRoot%\System32\dwm.exe"
echo Waiting for DWM to start...
timeout /t 3 /nobreak >nul

rem Get the PID of dwm.exe (the most recent one)
for /f "tokens=2" %%a in ('tasklist /fi "imagename eq dwm.exe" ^| findstr "dwm.exe"') do (
    set PID=%%a
)

rem Remove commas (in case of 1,234 formatting)
set PID=!PID:,=!
echo Found PID: !PID!

rem Check if PID is below 1000
if !PID! lss 1000 (
    echo Success: dwm.exe is running with PID !PID!
    goto END
) else (
    echo PID !PID! is too high, retrying in 3 seconds...
    timeout /t 3 /nobreak >nul
    goto RESTART
)

:END
exit