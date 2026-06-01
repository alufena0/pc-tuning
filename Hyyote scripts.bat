@echo off
if "%~1" neq "running" (start "" /b cmd /c "%~f0" running & exit /b) else (cd /d "%~dp0")
setlocal EnableDelayedExpansion

POWERSHELL "ForEach($v in (Get-Command -Name \"Set-ProcessMitigation\").Parameters[\"Disable\"].Attributes.ValidValues){Set-ProcessMitigation -System -Disable $v.ToString() -ErrorAction SilentlyContinue}" >NUL 2>&1

ECHO Disabling IoLatencyCap...
FOR /F "eol=E" %%a in ('REG QUERY "HKLM\System\CurrentControlSet\Services" /S /F "IoLatencyCap"^| FINDSTR /V "IoLatencyCap"') DO (
    REG ADD "%%a" /v "IoLatencyCap" /t REG_DWORD /d "0" /f >NUL 2>&1
)

ECHO Disabling HIPM and DIPM...
FOR /F "eol=E" %%a in ('REG QUERY "HKLM\System\CurrentControlSet\Services" /S /F "EnableHIPM"^| FINDSTR /V "EnableHIPM"') DO (
    REG ADD "%%a" /v "EnableHIPM" /t REG_DWORD /d "0" /f >NUL 2>&1
    REG ADD "%%a" /v "EnableDIPM" /t REG_DWORD /d "0" /f >NUL 2>&1
)

ECHO Removing adapters off QoS Service...
FOR /F %%a in ('REG QUERY "HKLM\System\CurrentControlSet\Services\Psched\Parameters\Adapters"') DO (
    REG DELETE "%%a" /F >NUL 2>&1
)

ECHO Disabling QoS and NdisCap...
FOR /F "tokens=3*" %%I IN ('REG QUERY "HKLM\Software\Microsoft\Windows NT\CurrentVersion\NetworkCards" /F "ServiceName" /S^| FINDSTR /I /L "ServiceName"') DO (
    FOR /F %%a IN ('REG QUERY "HKLM\System\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}" /F "%%I" /D /E /S^| FINDSTR /I /L "\\Class\\"') DO SET "REGPATH=%%a"
    FOR /F "tokens=3*" %%n in ('REG QUERY "!REGPATH!" /V "FilterList"') DO SET "newFilterList=%%n"
    SET newFilterList=!newFilterList:-{B5F4D659-7DAA-4565-8E41-BE220ED60542}=!
    SET newFilterList=!newFilterList:-{430BDADD-BAB0-41AB-A369-94B67FA5BE0A}=!
    REG QUERY "!REGPATH!" /V "FilterList" | FINDSTR /I "{B5F4D659-7DAA-4565-8E41-BE220ED60542} {430BDADD-BAB0-41AB-A369-94B67FA5BE0A}" >NUL 2>&1
    IF NOT ERRORLEVEL 1 (
        REG ADD "!REGPATH!" /F /V "FilterList" /T REG_MULTI_SZ /d "!newFilterList!" >NUL 2>&1
    )
)

ECHO Disabling StorPort idle...
FOR /F "tokens=*" %%a in ('REG QUERY "HKLM\System\CurrentControlSet\Enum" /S /F "StorPort"^| FINDSTR /E "StorPort"') DO (
    REG ADD "%%a" /v "EnableIdlePowerManagement" /t REG_DWORD /d "0" /f >NUL 2>&1
)

for %%a in ("SleepStudy" "Kernel-Processor-Power" "UserModePowerService") do (
    wevtutil sl Microsoft-Windows-%%~a/Diagnostic /e:false >NUL 2>&1
)

ECHO Disabling background access of default apps...
POWERSHELL "ForEach($key in (Get-ChildItem 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications')) { Set-ItemProperty -Path ('HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\' + $key.PSChildName) -Name 'Disabled' -Value 1 -ErrorAction SilentlyContinue }" >NUL 2>&1

ECHO Disabling synchronisation of settings...
POWERSHELL -Command "Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync' -Name 'BackupPolicy' -Value 0x3c -ErrorAction SilentlyContinue; Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync' -Name 'DeviceMetadataUploaded' -Value 0 -ErrorAction SilentlyContinue; Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync' -Name 'PriorLogons' -Value 1 -ErrorAction SilentlyContinue" >NUL 2>&1
POWERSHELL -Command "$groups = @('Accessibility','AppSync','BrowserSettings','Credentials','DesktopTheme','Language','PackageState','Personalization','StartLayout','Windows'); foreach ($group in $groups) { $path = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\' + $group; New-Item -Path $path -Force -ErrorAction SilentlyContinue | Out-Null; Set-ItemProperty -Path $path -Name 'Enabled' -Value 0 -ErrorAction SilentlyContinue }" >NUL 2>&1

ECHO Removing SystemApps telemetry...
set key=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\InboxApplications
for %%i in (
AppRep.ChxApp
CloudExperienceHost
SecHealthUI
) do (
    for /f %%a in ('reg query "%key%" /f %%i /k ^| find /i "InboxApplications"') do (
        reg delete "%%a" /f >NUL 2>&1
    )
)

ECHO Display tweaks (Questionable)
REM FIX: original (Add-Type ...).AllScreens.Length is broken - Add-Type returns void
for /f %%i in ('powershell -NoProfile -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.Screen]::AllScreens.Count"') do set "MonitorAmount=%%i"
if not defined MonitorAmount set "MonitorAmount=1"
REG ADD "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v Display%MonitorAmount%_PipeOptimizationEnable /t REG_DWORD /d 1 /f >NUL 2>&1

ECHO Disabling disk power savings...
for %%i in (EnableHIPM EnableDIPM EnableHDDParking) do (
    for /f "delims=" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services" /s /f "%%i" 2^>nul ^| findstr /i "^HKEY"') do (
        reg add "%%a" /v "%%i" /t REG_DWORD /d 0 /f >nul 2>&1
    )
)

if exist "%~dp0resources\smartctl.exe" (
    "%~dp0resources\smartctl.exe" --scan > "%temp%\smartctl_scan.txt" 2>&1
    for /f "usebackq tokens=1" %%d in ("%temp%\smartctl_scan.txt") do (
        "%~dp0resources\smartctl.exe" -s apm,off %%d >nul 2>&1
        "%~dp0resources\smartctl.exe" -s aam,off %%d >nul 2>&1
    )
    del "%temp%\smartctl_scan.txt" 2>nul
)

ECHO Enabling MSI mode support for IDE controller...
for /f "skip=1 tokens=*" %%i in ('wmic path Win32_IDEController get PNPDeviceID 2^>nul') do (
    if not "%%i"=="" (
        reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v MSISupported /t REG_DWORD /d 1 /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v DevicePriority /t REG_DWORD /d 0 /f >nul 2>&1
    )
)

DISM >nul 2>&1 || (
  echo error: administrator privileges required
  pause
  exit /b 1
)

for %%a in (
    "EnhancedPowerManagementEnabled"
    "AllowIdleIrpInD3"
    "DeviceSelectiveSuspended"
    "DeviceResetNotificationEnabled"
    "EnableSelectiveSuspend"
    "SelectiveSuspendEnabled"
    "SelectiveSuspendOn"
    "SelectiveSuspendTimeout"
    "WaitWakeEnabled"
    "WakeEnabled"
    "D3ColdSupported"
    "DisableD3Cold"
    "WdfDirectedPowerTransitionEnable"
    "EnableIdlePowerManagement"
    "IdleInWorkingState"
    "IdleTimeoutInMS"
    "IdleTimeoutPeriodInMilliSec"
    "MinimumIdleTimeoutInMS"
    "EnableHIPM"
    "EnableHDDParking"
    "EnableDIPM"
    "SuppressInputInCS"
    "SystemInputSuppressionEnabled"
    "WdfDefaultIdleInWorkingState"
    "WdfDirectedPowerTransitionChildrenOptional"
    "WdfUseWdfTimerForPofx"
    "SleepstudyState"
) do (
    echo info: configuring %%~a
    for /f "delims=" %%b in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum" /s /f "%%~a" ^| findstr "HKEY"') do (
        reg.exe add "%%b" /v "%%~a" /t REG_DWORD /d "0" /f >nul 2>&1
    )
)

for %%a in (
    "WakeEnabled"
    "WdkSelectiveSuspendEnable"
) do (
    echo info: configuring %%~a
    for /f "delims=" %%b in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class" /s /f "%%~a" ^| findstr "HKEY"') do (
        reg.exe add "%%b" /v "%%~a" /t REG_DWORD /d "0" /f >nul 2>&1
    )
)
echo info: done

ECHO USB tweaks...
REM FIX: added /k flag so reg query searches KEY names (Device Parameters is a subkey, not a value)
for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\USB" /s /k /f "Device Parameters" 2^>nul ^| findstr /i "Device Parameters$"') do (
    reg add "%%i" /v "AllowIdleIrpInD3" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "%%i" /v "D3ColdSupported" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "%%i" /v "DeviceSelectiveSuspended" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "%%i" /v "EnableSelectiveSuspend" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "%%i" /v "EnhancedPowerManagementEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "%%i" /v "SelectiveSuspendEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "%%i" /v "SelectiveSuspendOn" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "%%i" /v "fid_D1Latency" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "%%i" /v "fid_D2Latency" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "%%i" /v "fid_D3Latency" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "%%i" /v "PowerManaged" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "%%i" /v "UserSetDeviceIdleEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "%%i" /v "IdleEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "%%i" /v "SystemManagedIdleTimeout" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "%%i" /v "UserWriteCacheSetting" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "%%i" /v "WriteCacheEnableOverride" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "%%i" /v "DefaultPowerState" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "%%i\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f >nul 2>&1
)

ECHO WppRecorder_UseTimeStamp to 0 wherever it is found
for %%H in (HKLM HKCU HKCR HKU) do (
    for /f "delims=" %%K in ('reg query "%%H" /f WppRecorder_UseTimeStamp /s /t REG_DWORD 2^>nul ^| findstr /r /i "^HKEY"') do (
        reg add "%%K" /v WppRecorder_UseTimeStamp /t REG_DWORD /d 0 /f >nul 2>&1
    )
)
echo All occurrences of WppRecorder_UseTimeStamp have been set to 0.

REM FIX: added >NUL 2>&1 to suppress autologger output
powershell -NoProfile -Command "Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Control\WMI\Autologger' -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.Name -notmatch 'Eventlog-Security|EventLog-Application|EventLog-System' } | ForEach-Object { $p=$_.PSPath; New-ItemProperty -Path $p -Name Start -PropertyType DWord -Value 0 -Force; $props=Get-ItemProperty -Path $p -ErrorAction SilentlyContinue; if ($props -and $props.PSObject.Properties.Name -contains 'Enabled') { Set-ItemProperty -Path $p -Name Enabled -Value 0 } }" >NUL 2>&1

for /f "tokens=*" %%A in ('reg query "HKCU\Software\Classes" ^| find "AppX"') do (reg add "%%A\Shell\Print" /v LegacyDisable /t REG_SZ /d "" /f >nul 2>&1 & reg add "%%A\Shell\PrintTo" /v LegacyDisable /t REG_SZ /d "" /f >nul 2>&1)
for /f "tokens=*" %%A in ('reg query "HKLM\Software\Classes" ^| find "AppX"') do (reg add "%%A\Shell\Print" /v LegacyDisable /t REG_SZ /d "" /f >nul 2>&1 & reg add "%%A\Shell\PrintTo" /v LegacyDisable /t REG_SZ /d "" /f >nul 2>&1)

echo Disable DMA Remapping...
for /f %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services" /s /f "DmaRemappingCompatible" ^| find /i "Services\"') do (
    reg add "%%i" /v "DmaRemappingCompatible" /t REG_DWORD /d 0 /f >nul 2>&1
)

echo Disable Power Management...
for %%i in (
    "DisableIdlePowerManagement"
    "DisableRuntimePowerManagement"
) do (
    for /f "delims=" %%k in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum" /s /f "%%~i" ^| findstr "HK"') do (
        reg add "%%k" /v "%%~i" /t reg_dword /d 1 /f >nul 2>&1
    )
)

echo Disable NetBios...
for /f "tokens=*" %%B in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces" 2^>nul') do (
    reg add "%%B" /v "NetbiosOptions" /t REG_DWORD /d "2" /f >nul 2>&1
)

echo Disable Wake Devices...
for /f "tokens=*" %%a in ('powercfg /devicequery wake_armed 2^>nul') do powercfg /devicedisablewake "%%a" >nul 2>&1

endlocal
timeout 8
exit