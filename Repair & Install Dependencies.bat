@echo off
::if "%~1" neq "running" (start "" /b cmd /c "%~f0" running & exit /b) else (cd /d "%~dp0")
::title Runtimes - Combined Install
color 1F
::echo Visual C++ Redistributable...
::set "COMMON=--accept-package-agreements --accept-source-agreements --silent"
::winget install --id=Microsoft.VCRedist.2005.x86 %COMMON% --override "/Q" >NUL 2>&1
::winget install --id=Microsoft.VCRedist.2005.x64 %COMMON% --override "/Q" >NUL 2>&1
::winget install --id=Microsoft.VCRedist.2008.x86 %COMMON% --override "/q" >NUL 2>&1
::winget install --id=Microsoft.VCRedist.2008.x64 %COMMON% --override "/q" >NUL 2>&1
::winget install --id=Microsoft.VCRedist.2010.x86 %COMMON% --override "/q /norestart" >NUL 2>&1
::winget install --id=Microsoft.VCRedist.2010.x64 %COMMON% --override "/q /norestart" >NUL 2>&1
::winget install --id=Microsoft.VCRedist.2012.x86 %COMMON% --override "/install /quiet /norestart" >NUL 2>&1
::winget install --id=Microsoft.VCRedist.2012.x64 %COMMON% --override "/install /quiet /norestart" >NUL 2>&1
::winget install --id=Microsoft.VCRedist.2013.x86 %COMMON% --override "/install /quiet /norestart" >NUL 2>&1
::winget install --id=Microsoft.VCRedist.2013.x64 %COMMON% --override "/install /quiet /norestart" >NUL 2>&1
::winget install --id=Microsoft.VCRedist.2015+.x86 %COMMON% --override "/install /quiet /norestart" >NUL 2>&1
::winget install --id=Microsoft.VCRedist.2015+.x64 %COMMON% --override "/install /quiet /norestart" >NUL 2>&1
echo .NET 3.1...
"G:\Setups\NET Core\windowsdesktop-runtime-3.1.32-win-x86.exe" /quiet /norestart /repair >NUL 2>&1
"G:\Setups\NET Core\windowsdesktop-runtime-3.1.32-win-x64.exe" /quiet /norestart /repair >NUL 2>&1
echo .NET 6.0...
"G:\Setups\NET Core\windowsdesktop-runtime-6.0.36-win-x86.exe" /quiet /norestart /repair >NUL 2>&1
"G:\Setups\NET Core\windowsdesktop-runtime-6.0.36-win-x64.exe" /quiet /norestart /repair >NUL 2>&1
echo .NET 7.0...
"G:\Setups\NET Core\windowsdesktop-runtime-7.0.20-win-x86.exe" /quiet /norestart /repair >NUL 2>&1
"G:\Setups\NET Core\windowsdesktop-runtime-7.0.20-win-x64.exe" /quiet /norestart /repair >NUL 2>&1
echo .NET 8.0...
"G:\Setups\NET Core\windowsdesktop-runtime-8.0.27-win-x86.exe" /quiet /norestart /repair >NUL 2>&1
"G:\Setups\NET Core\windowsdesktop-runtime-8.0.27-win-x64.exe" /quiet /norestart /repair >NUL 2>&1
echo .NET 9.0...
"G:\Setups\NET Core\windowsdesktop-runtime-9.0.16-win-x86.exe" /quiet /norestart /repair >NUL 2>&1
"G:\Setups\NET Core\windowsdesktop-runtime-9.0.16-win-x64.exe" /quiet /norestart /repair >NUL 2>&1
echo .NET 10.0...
"G:\Setups\NET Core\windowsdesktop-runtime-10.0.8-win-x64.exe" /uninstall /quiet /norestart >NUL 2>&1
"G:\Setups\NET Core\windowsdesktop-runtime-10.0.8-win-x64.exe" /quiet /norestart >NUL 2>&1
"G:\Setups\NET Core\windowsdesktop-runtime-10.0.8-win-x86.exe" /uninstall /quiet /norestart >NUL 2>&1
"G:\Setups\NET Core\windowsdesktop-runtime-10.0.8-win-x86.exe" /quiet /norestart >NUL 2>&1
echo .NET 4.8/4.8.1...
"G:\Setups\NDP48-x86-x64-AllOS-ENU.exe" /passive /norestart >NUL 2>&1
::"G:\Setups\NDP48-x86-x64-AllOS-ENU.exe" /quiet /norestart /repair >NUL 2>&1
"G:\Setups\NDP481-x86-x64-AllOS-ENU.exe" /passive /norestart >NUL 2>&1
::"G:\Setups\NDP481-x86-x64-AllOS-ENU.exe" /quiet /norestart /repair >NUL 2>&1
echo Python...
"G:\Setups\python-3.14.5-amd64.exe" /quiet /uninstall >NUL 2>&1
"G:\Setups\python-3.14.5-amd64.exe" /quiet PrependPath=1 >NUL 2>&1
for /f %%G in ('powershell -NoP -C "(Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*','HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' -EA 0 | Where-Object {$_.DisplayName -like '*Python Launcher*'}).PSChildName" 2^>nul') do msiexec /fvomus %%G /quiet /norestart >NUL 2>&1
echo Visual C++ AIO...
"G:\Setups\VisualCppRedist_AIO_x86_x64.exe" /aiR /gm2 >NUL 2>&1
"G:\Setups\VisualCppRedist_AIO_x86_x64.exe" /ai /gm2 >NUL 2>&1
echo .NET Framework Repair Tool...
"G:\Setups\NetFxRepairTool.exe" /q /norestart >NUL 2>&1
echo .NET Framework 3.5...
DISM /Online /Enable-Feature /FeatureName:NetFx3 /All >NUL 2>&1
echo DirectX...
"G:\Setups\DirectX_Redist_Repack_x86_x64.exe" /ai3 /gm2 >NUL 2>&1
"G:\Setups\DirectX_Redist_Repack_x86_x64.exe" /ai /gm2 >NUL 2>&1
echo Realtek Ethernet...
start /wait "" "G:\Setups\Install_Win11_Win10_10079_20_DMAROFF_04212026.exe" /s /v"/qn REINSTALL=ALL REINSTALLMODE=VOMUS REBOOT=REALLYSUPPRESS" >NUL 2>&1
::echo Vulkan Runtime...
::start /wait "" "G:\Setups\VulkanRT-X64-1.4.335.0-Installer.exe" /S >NUL 2>&1
taskkill /f /t /im MoUsoCoreWorker.exe >NUL 2>&1
taskkill /f /t /im msiexec.exe >NUL 2>&1
taskkill /f /t /im TiWorker.exe >NUL 2>&1
taskkill /f /t /im TrustedInstaller.exe >NUL 2>&1
exit