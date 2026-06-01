if "%~1" neq "running" (start "" /b cmd /c "%~f0" running & exit /b) else (cd /d "%~dp0")
setlocal enabledelayedexpansion
@echo Disable USB Powersavings
powershell.exe -command "Get-WmiObject MSPower_DeviceEnable -Namespace root\wmi | ForEach-Object { $_.enable = $false; $_.psbase.put(); }" >nul 2>&1
powershell -ExecutionPolicy Bypass -Command "iex ([Text.Encoding]::UTF8.GetString([Convert]::FromBase64String('aWYgKC1ub3QgKFtTZWN1cml0eS5QcmluY2lwYWwuV2luZG93c1ByaW5jaXBhbF0gW1NlY3VyaXR5LlByaW5jaXBhbC5XaW5kb3dzSWRlbnRpdHldOjpHZXRDdXJyZW50KCkpLklzSW5Sb2xlKFtTZWN1cml0eS5QcmluY2lwYWwuV2luZG93c0J1aWx0SW5Sb2xlXSAiQWRtaW5pc3RyYXRvciIpKSB7DQogICAgU3RhcnQtUHJvY2VzcyBwb3dlcnNoZWxsICItRmlsZSBgIiRQU0NvbW1hbmRQYXRoYCIiIC1WZXJiIFJ1bkFzDQogICAgZXhpdA0KfQ0KDQpmdW5jdGlvbiBEaXNhYmxlLVVTQlBvd2VyTWFuYWdlbWVudCB7DQogICAgcGFyYW0gKA0KICAgICAgICBbc3RyaW5nXSRDbGFzc05hbWUNCiAgICApDQoNCiAgICAkaHVicyA9IEdldC1XbWlPYmplY3QgLUNsYXNzICRDbGFzc05hbWUNCiAgICAkcG93ZXJNZ210ID0gR2V0LVdtaU9iamVjdCAtQ2xhc3MgTVNQb3dlcl9EZXZpY2VFbmFibGUgLU5hbWVzcGFjZSByb290XHdtaQ0KDQogICAgZm9yZWFjaCAoJHAgaW4gJHBvd2VyTWdtdCkgew0KICAgICAgICAkSU4gPSAkcC5JbnN0YW5jZU5hbWUuVG9VcHBlcigpDQogICAgICAgIGZvcmVhY2ggKCRoIGluICRodWJzKSB7DQogICAgICAgICAgICAkUE5QREkgPSAkaC5QTlBEZXZpY2VJRA0KICAgICAgICAgICAgaWYgKCRJTiAtbGlrZSAiKiRQTlBESSoiKSB7DQogICAgICAgICAgICAgICAgV3JpdGUtSG9zdCAiaW5mbzogY29uZmlndXJpbmcgJElOIg0KICAgICAgICAgICAgICAgICRwLmVuYWJsZSA9ICRGYWxzZQ0KICAgICAgICAgICAgICAgICRwLnBzYmFzZS5wdXQoKSB8IE91dC1OdWxsDQogICAgICAgICAgICB9DQogICAgICAgIH0NCiAgICB9DQp9DQpEaXNhYmxlLVVTQlBvd2VyTWFuYWdlbWVudCAtQ2xhc3NOYW1lICdXaW4zMl9VU0JDb250cm9sbGVyJw0KRGlzYWJsZS1VU0JQb3dlck1hbmFnZW1lbnQgLUNsYXNzTmFtZSAnV2luMzJfVVNCQ29udHJvbGxlckRldmljZScNCkRpc2FibGUtVVNCUG93ZXJNYW5hZ2VtZW50IC1DbGFzc05hbWUgJ1dpbjMyX1VTQkh1YicNCg==')))" >nul 2>&1
set "REG_PATH=HKLM\SYSTEM\CurrentControlSet\Control\usbflags"
for /f "tokens=*" %%i in ('reg query "%REG_PATH%" 2^>nul ^| findstr /r "[0-9A-F]\{12\}"') do (
    set "DEVICE_KEY=%%i"
    for /f "tokens=*" %%a in ("!DEVICE_KEY:%REG_PATH%\=!") do (
        set "DEVICE_ID=%%a"
        echo !DEVICE_ID! | findstr /r /c:"^[0-9A-F]\{12\}$" >nul 2>&1
        if !errorlevel! EQU 0 (
            reg add "%REG_PATH%\!DEVICE_ID!" /v "DisableLPM" /t REG_DWORD /d "1" /f >nul 2>&1
        )
    )
)
set "USB_ENUM_PATH=HKLM\SYSTEM\CurrentControlSet\Enum\USB"
for /f "tokens=*" %%d in ('reg query "%USB_ENUM_PATH%" 2^>nul') do (
    set "DEVICE_PATH=%%d"
    for /f "tokens=*" %%i in ('reg query "!DEVICE_PATH!" 2^>nul') do (
        set "INSTANCE_PATH=%%i"
        reg query "!INSTANCE_PATH!\Device Parameters" >nul 2>&1
        if !errorlevel! EQU 0 (
            reg add "!INSTANCE_PATH!\Device Parameters" /v "AllowIdleIrpInD3" /t REG_DWORD /d "0" /f >nul 2>&1
            reg add "!INSTANCE_PATH!\Device Parameters" /v "DeviceSelectiveSuspended" /t REG_DWORD /d "0" /f >nul 2>&1
            reg add "!INSTANCE_PATH!\Device Parameters" /v "IdleTimeoutPeriodInMilliSec" /t REG_DWORD /d "0" /f >nul 2>&1
            reg add "!INSTANCE_PATH!\Device Parameters" /v "EnhancedPowerManagementEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
            reg add "!INSTANCE_PATH!\Device Parameters" /v "EnhancedPowerManagementUseMonitor" /t REG_DWORD /d "0" /f >nul 2>&1
            reg add "!INSTANCE_PATH!\Device Parameters" /v "SelectiveSuspendEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
            reg add "!INSTANCE_PATH!\Device Parameters" /v "SelectiveSuspendTimeout" /t REG_DWORD /d "0" /f >nul 2>&1
            reg add "!INSTANCE_PATH!\Device Parameters" /v "SuppressInputInCS" /t REG_DWORD /d "0" /f >nul 2>&1
            reg add "!INSTANCE_PATH!\Device Parameters" /v "SystemInputSuppressionEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
            reg query "!INSTANCE_PATH!\Device Parameters\Wdf" >nul 2>&1
            if !errorlevel! EQU 0 (
                reg add "!INSTANCE_PATH!\Device Parameters\Wdf" /v "IdleInWorkingState" /t REG_DWORD /d "0" /f >nul 2>&1
                reg add "!INSTANCE_PATH!\Device Parameters\Wdf" /v "SleepstudyState" /t REG_DWORD /d "0" /f >nul 2>&1
                reg add "!INSTANCE_PATH!\Device Parameters\Wdf" /v "WdfDefaultIdleInWorkingState" /t REG_DWORD /d "0" /f >nul 2>&1
                reg add "!INSTANCE_PATH!\Device Parameters\Wdf" /v "WdfDirectedPowerTransitionChildrenOptional" /t REG_DWORD /d "0" /f >nul 2>&1
                reg add "!INSTANCE_PATH!\Device Parameters\Wdf" /v "WdfDirectedPowerTransitionEnable" /t REG_DWORD /d "0" /f >nul 2>&1
                reg add "!INSTANCE_PATH!\Device Parameters\Wdf" /v "WdfUseWdfTimerForPofx" /t REG_DWORD /d "0" /f >nul 2>&1
            )
        )
    )
    set "ROOT_HUB_PATH=HKLM\SYSTEM\CurrentControlSet\Enum\USB\ROOT_HUB30"
    reg query "%ROOT_HUB_PATH%" >nul 2>&1
    if !errorlevel! EQU 0 (
        for /f "tokens=*" %%r in ('reg query "%ROOT_HUB_PATH%" 2^>nul') do (
            set "HUB_PATH=%%r"
            reg add "!HUB_PATH!\Device Parameters\Wdf" /v "IdleInWorkingState" /t REG_DWORD /d "0" /f >nul 2>&1
            reg add "!HUB_PATH!\Device Parameters\Wdf" /v "SleepstudyState" /t REG_DWORD /d "0" /f >nul 2>&1
            reg add "!HUB_PATH!\Device Parameters\Wdf" /v "WdfDefaultIdleInWorkingState" /t REG_DWORD /d "0" /f >nul 2>&1
            reg add "!HUB_PATH!\Device Parameters\Wdf" /v "WdfDirectedPowerTransitionChildrenOptional" /t REG_DWORD /d "0" /f >nul 2>&1
            reg add "!HUB_PATH!\Device Parameters\Wdf" /v "WdfDirectedPowerTransitionEnable" /t REG_DWORD /d "0" /f >nul 2>&1
            reg add "!HUB_PATH!\Device Parameters\Wdf" /v "WdfUseWdfTimerForPofx" /t REG_DWORD /d "0" /f >nul 2>&1
        )
    )
)
for %%i in (
    "EnhancedPowerManagementEnabled"
    "AllowIdleIrpInD3"
    "DeviceSelectiveSuspended"
    "DeviceResetNotificationEnabled"
    "SelectiveSuspendEnabled"
    "WaitWakeEnabled"
    "D3ColdSupported"
    "DisableD3Cold"
    "WdfDirectedPowerTransitionEnable"
    "EnableIdlePowerManagement"
    "IdleInWorkingState"
    "IdleTimeoutInMS"
    "MinimumIdleTimeoutInMS"
    "EnableHIPM"
    "EnableHDDParking"
    "EnableDIPM"
) do (
    for /f "delims=" %%k in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum" /s /f "%%~i" ^| findstr "HK"') do (
        reg add "%%k" /v "%%~i" /t reg_dword /d 0 /f >nul 2>&1
    )
)
exit