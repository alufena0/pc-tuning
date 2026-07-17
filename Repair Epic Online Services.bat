@echo off
:: =============================================================================
:: Repair-EOS.bat
:: Fixes "Epic Online Services Unavailable" error in Epic Games Launcher.
::
:: Root cause: the EOS service (EpicOnlineServicesUserHelper.exe) fails to start
:: with exit code 77 ("No updater mode specified") after certain registry changes.
:: This is a known fragility in EOS — the service depends on specific registry
:: state that can be disrupted by system tweaks, third-party tools, or even
:: Epic's own incomplete updates. Reinstalling EOS via MSI restores the expected
:: state and resolves the issue.
::
:: What this script does:
::   1. Kills all EOS processes and stops related services
::   2. Locates the EOS uninstall GUID dynamically (both 32-bit and 64-bit hives)
::   3. Uninstalls EOS via MSI
::   4. Removes leftover service entries, registry keys, and folders
::   5. Reinstalls EOS using the installer bundled with the Epic Games Launcher
::   6. Verifies the service registered and started successfully
::
:: Usage: Run as Administrator. Do NOT run while relying on EOS being active.
:: =============================================================================
setlocal EnableDelayedExpansion

echo [1/6] Killing EOS processes...
for %%p in (
    EpicOnlineServicesHost.exe
    EpicOnlineServicesUserHelper.exe
    EpicOnlineServicesUIHelper.exe
    EpicOnlineServicesInstallHelper.exe
) do taskkill /f /im %%p >nul 2>&1
sc stop EpicOnlineServices >nul 2>&1
sc stop EpicGamesUpdater >nul 2>&1
timeout /t 2 /nobreak >nul

echo [2/6] Finding EOS uninstall GUID...
set "EOS_GUID="
for %%H in (
    "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
    "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
) do (
    if not defined EOS_GUID (
        for /f "tokens=*" %%k in ('reg query %%H /s /f "Epic Online Services" /t REG_SZ 2^>nul ^| findstr /i "HKEY_LOCAL"') do (
            if not defined EOS_GUID (
                for /f "skip=2 tokens=1,2,*" %%a in ('reg query "%%k" /v DisplayName 2^>nul') do (
                    if /i "%%c"=="Epic Online Services" (
                        for %%g in ("%%k") do set "EOS_GUID=%%~ng"
                    )
                )
            )
        )
    )
)

if defined EOS_GUID (
    echo Found GUID: !EOS_GUID!
    echo [3/6] Uninstalling via MSI...
    MsiExec.exe /X!EOS_GUID! /quiet /norestart
    timeout /t 6 /nobreak >nul
) else (
    echo EOS not found in registry, skipping MSI uninstall.
)

echo [4/6] Removing service, registry keys, and folders...
sc delete EpicOnlineServices >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\EpicOnlineServices" /f >nul 2>&1
if defined EOS_GUID (
    reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\!EOS_GUID!" /f >nul 2>&1
    reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\!EOS_GUID!" /f >nul 2>&1
)
rd /s /q "C:\Program Files (x86)\Epic Games\Epic Online Services" >nul 2>&1
rd /s /q "C:\ProgramData\Epic\EpicOnlineServices" >nul 2>&1
rd /s /q "%localappdata%\Epic Games\Epic Online Services" >nul 2>&1

echo [5/6] Running EOS installer...
set "INSTALLER=C:\Program Files\Epic Games\Launcher\Portal\Extras\EOS\EpicOnlineServicesInstaller.exe"
if not exist "!INSTALLER!" set "INSTALLER=C:\ProgramData\Epic\EpicGamesLauncher\Data\Update\Install\Portal\Extras\EOS\EpicOnlineServicesInstaller.exe"
if not exist "!INSTALLER!" (
    echo ERROR: EpicOnlineServicesInstaller.exe not found.
    pause
    exit /b 1
)
echo Installer: !INSTALLER!
start "" /wait "!INSTALLER!"

echo [6/6] Verifying service...
sc query EpicOnlineServices >nul 2>&1
if !errorlevel! equ 0 (
    sc start EpicOnlineServices >nul 2>&1
    timeout /t 3 /nobreak >nul
    sc query EpicOnlineServices | find "RUNNING" >nul 2>&1
    if !errorlevel! equ 0 (
        echo.
        echo OK - EOS is running. Open the Launcher.
    ) else (
        echo.
        echo Service registered but not yet running. Try opening the Launcher anyway.
    )
) else (
    echo.
    echo WARNING: Service not registered after install.
)
echo.
pause