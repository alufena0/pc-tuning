if "%~1" neq "running" (start "" /b cmd /c "%~f0" running & exit /b) else (cd /d "%~dp0")
netsh interface set interface "Ethernet" disable & timeout /t 1 >nul & netsh interface set interface "Ethernet" enable
::reg import C:\Users\Administrator\Documents\Tweaks.reg >NUL 2>&1
sc start TabletInputService >NUL 2>&1
sc config TabletInputService start= auto >NUL 2>&1
sc start TextInputManagementService >NUL 2>&1
sc config TextInputManagementService start= auto >NUL 2>&1
taskkill /f /t /im WmiPrvSE.exe >nul 2>&1
net stop winmgmt /Y >nul 2>&1
sc config winmgmt start= auto >nul 2>&1
sc start winmgmt >nul 2>&1
powershell -nop -ex bypass -c "& takeown /f 'C:\Windows\System32\restore\MachineGuid.txt' /a; & icacls 'C:\Windows\System32\restore\MachineGuid.txt' /grant '*S-1-5-32-544:F'; Remove-Item -Force 'C:\Windows\System32\restore\MachineGuid.txt'" >nul 2>&1
::reg delete HKLM\SYSTEM\CurrentControlSet\Enum\DISPLAY\GSM60B2\1&8713bca&0&UID0\Device Parameters /v EDID /f >NUL 2>&1
::reg delete HKLM\SYSTEM\CurrentControlSet\Enum\DISPLAY\GSM60B2\5&2adb58f6&0&UID0\Device Parameters /v EDID /f >NUL 2>&1
::reg delete HKLM\SYSTEM\CurrentControlSet\Enum\DISPLAY\GSM60B2\5&2adb58f6&0&UID37124\Device Parameters /v EDID /f >NUL 2>&1
::reg delete HKLM\SYSTEM\CurrentControlSet\Enum\DISPLAY\GSM60B2\5&2adb58f6&1&UID0\Device Parameters /v EDID /f >NUL 2>&1
::reg delete HKLM\SYSTEM\CurrentControlSet\Enum\DISPLAY\GSM60B2\5&2adb58f6&1&UID37124\Device Parameters /v EDID /f >NUL 2>&1
::reg delete HKLM\SYSTEM\CurrentControlSet\Enum\DISPLAY\GSM60B2\5&2adb58f6&2&UID37124\Device Parameters /v EDID /f >NUL 2>&1
::reg delete HKLM\SYSTEM\CurrentControlSet\Enum\DISPLAY\GSM60B2\5&2adb58f6&3&UID37124\Device Parameters /v EDID /f >NUL 2>&1
::reg delete HKLM\SYSTEM\CurrentControlSet\Enum\DISPLAY\GSM60B2\5&2adb58f6&4&UID37124\Device Parameters /v EDID /f >NUL 2>&1
"G:\Setups\patchciv.exe" "D:\SteamLibrary\steamapps\common\Sid Meier's Civilization V\CivilizationV.exe" >NUL 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ShellServiceObjectDelayLoad" /f >NUL 2>&1 & reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ShellServiceObjectDelayLoad" /f >NUL 2>&1
for /f "tokens=1" %%A in ('reg query "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" ^| findstr /i "Mozilla-Firefox-"') do reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "%%A" /f >NUL 2>&1
reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\IrisService /f >NUL 2>&1
reg delete HKEY_CURRENT_USER\Software\Spoon /f >NUL 2>&1
::reg delete HKLM\SOFTWARE\Microsoft\Windows\Dwm /v ShaderLinkingGPUBlacklist /f >NUL 2>&1
takeown /f C:\Windows\Prefetch /r /d y >nul 2>&1
icacls C:\Windows\Prefetch /grant Administrator:(OI)(CI)F /t >nul 2>&1
rd /s /q C:\Windows\Prefetch >nul 2>&1
takeown /f C:\Users\Administrator\AppData\Local\Microsoft\GameDVR /r /d y >nul 2>&1
icacls C:\Users\Administrator\AppData\Local\Microsoft\GameDVR /grant Administrator:(OI)(CI)F /t >nul 2>&1
rd /s /q C:\Users\Administrator\AppData\Local\Microsoft\GameDVR >nul 2>&1
sc stop ClickToRunSvc >NUL 2>&1
sc stop NVDisplay.ContainerLocalSystem >NUL 2>&1
sc config NVDisplay.ContainerLocalSystem start= disabled >NUL 2>&1
sc config "Razer Chroma SDK Diagnostic Service" start= demand >NUL 2>&1
sc stop "Razer Chroma SDK Diagnostic Service" >NUL 2>&1
sc config "Razer Chroma SDK Server" start= demand >NUL 2>&1
sc stop "Razer Chroma SDK Server" >NUL 2>&1
sc config "Razer Chroma SDK Service" start= demand >NUL 2>&1
sc stop "Razer Chroma SDK Service" >NUL 2>&1
sc config "Razer Chroma Stream Server" start= demand >NUL 2>&1
sc stop "Razer Chroma Stream Server" >NUL 2>&1
sc config "Razer Elevation Service" start= demand >NUL 2>&1
sc stop "Razer Elevation Service" >NUL 2>&1
sc config "Razer Game Manager Service 3" start= demand >NUL 2>&1
sc stop "Razer Game Manager Service 3" >NUL 2>&1
sc config "Razer Synapse Service" start= demand >NUL 2>&1
sc stop "Razer Synapse Service" >NUL 2>&1
sc config HapticService start= demand >NUL 2>&1
sc stop HapticService >NUL 2>&1
sc stop EABackgroundService >NUL 2>&1
sc stop vds >NUL 2>&1
sc stop EpicGamesUpdater >NUL 2>&1
sc stop InstallService >NUL 2>&1
sc stop BITS >NUL 2>&1
sc stop swprv >NUL 2>&1
sc stop wuauserv >NUL 2>&1
sc stop seclogon >NUL 2>&1
sc stop seclogon >NUL 2>&1
sc stop InstallService >NUL 2>&1
sc stop Volmgrx >NUL 2>&1
sc stop wlidsvc >NUL 2>&1
sc stop DoSvc >NUL 2>&1
sc stop TeamViewer >NUL 2>&1
taskkill /f /t /im WindowsMigration.exe >NUL 2>&1
taskkill /f /t /im WindowsBackupClient.exe >NUL 2>&1
taskkill /f /t /im SoftLandingTask.exe >NUL 2>&1
taskkill /f /t /im DesktopStickerEditorWin32Exe.exe >NUL 2>&1
taskkill /f /t /im CrossDeviceResume.exe >NUL 2>&1
taskkill /f /t /im DiscoveryHubApp.exe >NUL 2>&1
taskkill /f /t /im RRCsrv.exe >NUL 2>&1
taskkill /f /t /im acrotray.exe >NUL 2>&1
taskkill /f /t /im alg.exe >NUL 2>&1
taskkill /f /t /im msdtc.exe >NUL 2>&1
taskkill /f /t /im PresentationFontCache.exe >NUL 2>&1
taskkill /f /t /im SMSvcHost.exe >NUL 2>&1
taskkill /f /t /im snmptrap.exe >NUL 2>&1
taskkill /f /t /im CredentialEnrollmentManager.exe >NUL 2>&1
taskkill /f /t /im adb.exe >NUL 2>&1
taskkill /f /t /im AdobeIPCBroker.exe >NUL 2>&1
taskkill /f /t /im Agent.exe >NUL 2>&1
taskkill /f /t /im ai.exe >NUL 2>&1
taskkill /f /t /im ApplicationFrameHost.exe >NUL 2>&1
taskkill /f /t /im AppVShNotify.exe >NUL 2>&1
taskkill /f /t /im armsvc.exe >NUL 2>&1
taskkill /f /t /im backgroundTaskHost.exe >NUL 2>&1
taskkill /f /t /im CalculatorApp.exe >NUL 2>&1
taskkill /f /t /im identity_helper.exe >NUL 2>&1
taskkill /f /t /im calculator.exe >NUL 2>&1
taskkill /f /t /im CCLibrary.exe >NUL 2>&1
taskkill /f /t /im CCXProcess.exe >NUL 2>&1
taskkill /f /t /im CEPHtmlEngine.exe >NUL 2>&1
taskkill /f /t /im cfbackd.w32.exe >NUL 2>&1
taskkill /f /t /im provtool.exe >NUL 2>&1
taskkill /f /t /im CHXSmartScreen.exe >NUL 2>&1
taskkill /f /t /im CompPkgSrv.exe >NUL 2>&1
taskkill /f /t /im CoreSync.exe >NUL 2>&1
taskkill /f /t /im CrashMailer_64.exe >NUL 2>&1
taskkill /f /t /im DashboardNotificationManager.exe >NUL 2>&1
taskkill /f /t /im DataExchangeHost.exe >NUL 2>&1
taskkill /f /t /im EABackgroundService.exe >NUL 2>&1
taskkill /f /t /im fdm.exe >NUL 2>&1
taskkill /f /t /im steamservice.exe >NUL 2>&1
taskkill /f /t /im FESearchHost.exe >NUL 2>&1
taskkill /f /t /im FileCoAuth.exe >NUL 2>&1
taskkill /f /t /im gamebar.exe >NUL 2>&1
taskkill /f /t /im UpdateHub.exe >NUL 2>&1
taskkill /f /t /im GameBarPresenceWriter.exe >NUL 2>&1
taskkill /f /t /im GameInputSvc.exe >NUL 2>&1
taskkill /f /t /im GameManagerService.exe >NUL 2>&1
taskkill /f /t /im helperservice.exe >NUL 2>&1
taskkill /f /t /im HelpPane.exe >NUL 2>&1
taskkill /f /t /im hxaccounts.exe >NUL 2>&1
taskkill /f /t /im hxoutlook.exe >NUL 2>&1
taskkill /f /t /im HxTsr.exe >NUL 2>&1
taskkill /f /t /im JackettConsole.exe >NUL 2>&1
taskkill /f /t /im jcef_helper.exe >NUL 2>&1
taskkill /f /t /im lockapp.exe >NUL 2>&1
taskkill /f /t /im memBoost.exe >NUL 2>&1
taskkill /f /t /im MicrosoftEdgeUpdate.exe >NUL 2>&1
taskkill /f /t /im microsoft.photos.exe >NUL 2>&1
taskkill /f /t /im MpCmdRun.exe >NUL 2>&1
taskkill /f /t /im msedgewebview2.exe >NUL 2>&1
taskkill /f /t /im msiexec.exe >NUL 2>&1
taskkill /f /t /im NVDisplay.Container.exe >NUL 2>&1
taskkill /f /t /im OSE.exe >NUL 2>&1
taskkill /f /t /im StoreDesktopExtension.exe >NUL 2>&1
taskkill /f /t /im MBAMService.exe >NUL 2>&1
taskkill /f /t /im PerfWatson2.exe >NUL 2>&1
taskkill /f /t /im PhoneExperienceHost.exe >NUL 2>&1
taskkill /f /t /im PhotosService.exe >NUL 2>&1
taskkill /f /t /im "Razer Central.exe" >NUL 2>&1
taskkill /f /t /im RazerCentralService.exe >NUL 2>&1
taskkill /f /t /im "Razer Synapse 3.exe" >NUL 2>&1
taskkill /f /t /im "Razer Synapse Service.exe" >NUL 2>&1
taskkill /f /t /im "Razer Synapse Service Process.exe" >NUL 2>&1
taskkill /f /t /im RtkAudUService64.exe >NUL 2>&1
taskkill /f /t /im RtkNGUI64.exe >NUL 2>&1
taskkill /f /t /im rundll32.exe >NUL 2>&1
taskkill /f /t /im SDXHelper.exe >NUL 2>&1
taskkill /f /t /im SearchHost.exe >NUL 2>&1
taskkill /f /t /im node.exe >NUL 2>&1
taskkill /f /t /im MeasureSleep.exe >NUL 2>&1
taskkill /f /t /im SecurityHealthHost.exe >NUL 2>&1
taskkill /f /t /im SecurityHealthService.exe >NUL 2>&1
taskkill /f /t /im SelectiveToolApp.exe >NUL 2>&1
taskkill /f /t /im set-up.exe >NUL 2>&1
taskkill /f /t /im smartscreen.exe >NUL 2>&1
taskkill /f /t /im smss.exe >NUL 2>&1
taskkill /f /t /im SnippingTool.exe >NUL 2>&1
taskkill /f /t /im splwow64.exe >NUL 2>&1
taskkill /f /t /im spoolsv.exe >NUL 2>&1
taskkill /f /t /im WinUpdateHelper.exe >NUL 2>&1
taskkill /f /t /im sppsvc.exe >NUL 2>&1
taskkill /f /t /im sqlwriter.exe >NUL 2>&1
taskkill /f /t /im ssh-agent.exe >NUL 2>&1
taskkill /f /t /im provtool.exe >NUL 2>&1
taskkill /f /t /im ssh.exe >NUL 2>&1
taskkill /f /t /im StartMenuExperienceHost.exe >NUL 2>&1
taskkill /f /t /im SystemSettingsBroker.exe >NUL 2>&1
taskkill /f /t /im TabTip.exe >NUL 2>&1
taskkill /f /t /im textinputhost.exe >NUL 2>&1
taskkill /f /t /im TiWorker.exe >NUL 2>&1
taskkill /f /t /im TrustedInstaller.exe >NUL 2>&1
taskkill /f /t /im uhssvc.exe >NUL 2>&1
taskkill /f /t /im vds.exe >NUL 2>&1
taskkill /f /t /im video.ui.exe >NUL 2>&1
taskkill /f /t /im vssadmin.exe >NUL 2>&1
taskkill /f /t /im VSSVC.exe >NUL 2>&1
taskkill /f /t /im werfault.exe >NUL 2>&1
taskkill /f /t /im WidgetService.exe >NUL 2>&1
taskkill /f /t /im Widgets.exe >NUL 2>&1
taskkill /f /t /im WindowsPackageManagerServer.exe >NUL 2>&1
taskkill /f /t /im winstore.app.exe >NUL 2>&1
taskkill /f /t /im WmiApSrv.exe >NUL 2>&1
taskkill /f /t /im WmiPrvSE.exe >NUL 2>&1
taskkill /f /t /im WUDFHost.exe >NUL 2>&1
taskkill /f /t /im yourphone.exe >NUL 2>&1
taskkill /f /t /im crashhelper.exe >NUL 2>&1
taskkill /f /t /im SystemSettingsAdminFlows.exe >NUL 2>&1
taskkill /f /t /im steamerrorreporter.exe >NUL 2>&1
taskkill /f /t /im UnityCrashHandler64.exe >NUL 2>&1
taskkill /f /t /im CrashMailer_64.exe >NUL 2>&1
taskkill /f /t /im EpicOnlineServicesUserHelper.exe >NUL 2>&1
taskkill /f /t /im SndVol.exe >NUL 2>&1
taskkill /f /t /im nvcplui.exe >NUL 2>&1
taskkill /f /t /im EpicWebHelper.exe >NUL 2>&1
taskkill /f /t /im CrashReportClient.exe >NUL 2>&1
taskkill /f /t /im PnPUtil.exe >NUL 2>&1
taskkill /f /t /im ShellExperienceHost.exe >NUL 2>&1
taskkill /f /t /im SystemSettings.exe >NUL 2>&1
taskkill /f /t /im perfhost.exe >NUL 2>&1
taskkill /f /t /im TieringEngineService.exe >NUL 2>&1
taskkill /f /t /im wbengine.exe >NUL 2>&1
taskkill /f /t /im PerceptionSimulationService.exe >NUL 2>&1
taskkill /f /t /im Locator.exe >NUL 2>&1
taskkill /f /t /im upfc.exe >NUL 2>&1
taskkill /f /t /im userinit.exe >NUL 2>&1
taskkill /f /t /im nvidia-smi.exe >NUL 2>&1
taskkill /f /t /im elevation_service.exe >NUL 2>&1
taskkill /f /t /im prevhost.exe >NUL 2>&1
taskkill /f /t /im wimserv.exe >NUL 2>&1
taskkill /f /t /im PickerHost.exe >NUL 2>&1
taskkill /f /t /im netsh.exe >NUL 2>&1
taskkill /f /t /im OfficeClickToRun.exe >NUL 2>&1
taskkill /f /t /im ShellHost.exe >NUL 2>&1
taskkill /f /t /im winget.exe >NUL 2>&1
taskkill /f /t /im AppxDeploymentServer.exe >NUL 2>&1
taskkill /f /t /im WMIC.exe >NUL 2>&1
taskkill /f /t /im SkypeApp.exe >NUL 2>&1
taskkill /f /t /im WWAHost.exe >NUL 2>&1
taskkill /f /t /im NisSrv.exe >NUL 2>&1
taskkill /f /t /im MsMpEng.exe >NUL 2>&1
taskkill /f /t /im AggregatorHost.exe >NUL 2>&1
taskkill /f /t /im SppExtComObj.exe >NUL 2>&1
taskkill /f /t /im attrib.exe >NUL 2>&1
taskkill /f /t /im wuauclt.exe >NUL 2>&1
taskkill /f /t /im wowreg32.exe >NUL 2>&1
taskkill /f /t /im wuaucltcore.exe >NUL 2>&1
taskkill /f /t /im Dism.exe >NUL 2>&1
taskkill /f /t /im DismHost.exe >NUL 2>&1
taskkill /f /t /im RazerAppEngine.exe >NUL 2>&1
taskkill /f /t /im razerwdl.exe >NUL 2>&1
taskkill /f /t /im razer_elevation_service.exe >NUL 2>&1
taskkill /f /t /im RzAppManager.exe >NUL 2>&1
taskkill /f /t /im RzBTLEManager.exe >NUL 2>&1
taskkill /f /t /im RzChromaConnectManager.exe >NUL 2>&1
taskkill /f /t /im RzChromaConnectServer.exe >NUL 2>&1
taskkill /f /t /im RzChromaStreamServer.exe >NUL 2>&1
taskkill /f /t /im RzDeviceManager.exe >NUL 2>&1
taskkill /f /t /im RzDeviceManagerEx.exe >NUL 2>&1
taskkill /f /t /im RzDiagnosticService.exe >NUL 2>&1
taskkill /f /t /im RzEngineMon.exe >NUL 2>&1
taskkill /f /t /im RzIoTDeviceManager.exe >NUL 2>&1
taskkill /f /t /im RzSDKServer.exe >NUL 2>&1
taskkill /f /t /im RzSDKService.exe >NUL 2>&1
taskkill /f /t /im RzSmartlightingDeviceManager.exe >NUL 2>&1
taskkill /f /t /im RzWDLDeviceManager.exe >NUL 2>&1
taskkill /f /t /im CortexLauncherService.exe >NUL 2>&1
taskkill /f /t /im RazerCortex.exe >NUL 2>&1
taskkill /f /t /im RazerCortex.Shell.exe >NUL 2>&1
taskkill /f /fi "imagename eq Rz*.exe" >NUL 2>&1
taskkill /f /fi "imagename eq Razer*.exe" >NUL 2>&1
taskkill /f /t /im GoogleUpdate.exe >NUL 2>&1
taskkill /f /t /im StartMenu.exe >NUL 2>&1
taskkill /f /t /im CCleaner64.exe >NUL 2>&1
taskkill /f /t /im WinaeroTweakerHelper.exe >NUL 2>&1
taskkill /f /t /im GameInputRedistService.exe >NUL 2>&1
taskkill /f /t /im UCheck_portable64_win10.exe >NUL 2>&1
taskkill /f /t /im TeamViewer_Service.exe >NUL 2>&1
taskkill /f /t /im RGSUpdater.exe >NUL 2>&1
taskkill /f /t /im RGSUpdaterAgent.exe >NUL 2>&1
fsutil usn deletejournal /d /n c:
fsutil usn deletejournal /d /n d:
fsutil usn deletejournal /d /n e:
fsutil usn deletejournal /d /n f:
fsutil usn deletejournal /d /n g:
bitsadmin.exe /reset /allusers >NUL 2>&1
ie4uinit.exe -ClearIconCache >NUL 2>&1
w32tm /resync >NUL 2>&1
powercfg /hibernate /type reduced >NUL 2>&1
powercfg.exe hibernate off >NUL 2>&1
powercfg /h off >NUL 2>&1
powercfg -h off >NUL 2>&1
bcdedit /set disabledynamictick Yes >NUL 2>&1
::bcdedit /set disabledynamictick No >NUL 2>&1
::bcdedit /deletevalue disabledynamictick >NUL 2>&1
bcdedit /set useplatformclock No >NUL 2>&1
::bcdedit /deletevalue useplatformclock >NUL 2>&1
::bcdedit /set useplatformtick Yes >NUL 2>&1
bcdedit /set useplatformtick No >NUL 2>&1
::bcdedit /deletevalue useplatformtick >NUL 2>&1
bcdedit /set uselegacyapicmode No >NUL 2>&1
::bcdedit /set uselegacyapicmode Yes >NUL 2>&1
::bcdedit /deletevalue uselegacyapicmode >NUL 2>&1
bcdedit /set x2apicpolicy Enable >NUL 2>&1
::bcdedit /set x2apicpolicy Disable >NUL 2>&1
::bcdedit /deletevalue x2apicpolicy >NUL 2>&1
bcdedit /set tscsyncpolicy Enhanced >NUL 2>&1
::bcdedit /set tscsyncpolicy Legacy >NUL 2>&1
::bcdedit /deletevalue tscsyncpolicy >NUL 2>&1
bcdedit /set hypervisorlaunchtype Off >NUL 2>&1
::bcdedit /set hypervisorlaunchtype Auto >NUL 2>&1
::bcdedit /deletevalue hypervisorlaunchtype >NUL 2>&1
bcdedit /set allowedinmemorysettings 0x0 >NUL 2>&1
::bcdedit /deletevalue allowedinmemorysettings >NUL 2>&1
bcdedit /set avoidlowmemory 0x8000000 >NUL 2>&1
::bcdedit /deletevalue avoidlowmemory >NUL 2>&1
bcdedit /set bootems No >NUL 2>&1
bcdedit /bootems Off >NUL 2>&1
::bcdedit /deletevalue bootems >NUL 2>&1
bcdedit /set bootux Disabled >NUL 2>&1
::bcdedit /deletevalue bootux >NUL 2>&1
bcdedit /set configaccesspolicy Default >NUL 2>&1
::bcdedit /deletevalue configaccesspolicy >NUL 2>&1
bcdedit /set disableelamdrivers Yes >NUL 2>&1
::bcdedit /deletevalue disableelamdrivers >NUL 2>&1
::bcdedit /set debug Yes >NUL 2>&1
bcdedit /set debug No >NUL 2>&1
bcdedit /debug Off >NUL 2>&1
::bcdedit /deletevalue debug >NUL 2>&1
bcdedit /set ems No >NUL 2>&1
bcdedit /ems Off >NUL 2>&1
::bcdedit /deletevalue ems >NUL 2>&1
bcdedit /set increaseuserva 268435328 >NUL 2>&1
::bcdedit /deletevalue increaseuserva >NUL 2>&1
bcdedit /set isolatedcontext No >NUL 2>&1
::bcdedit /deletevalue isolatedcontext >NUL 2>&1
bcdedit /set linearaddress57 OptOut >NUL 2>&1
::bcdedit /set linearaddress57 OptIn >NUL 2>&1
::bcdedit /deletevalue linearaddress57 >NUL 2>&1
::bcdedit /set maxproc Yes >NUL 2>&1
bcdedit /set maxproc No >NUL 2>&1
::bcdedit /deletevalue maxproc >NUL 2>&1
bcdedit /set nolowmem Yes >NUL 2>&1
::bcdedit /deletevalue nolowmem >NUL 2>&1
bcdedit /set numproc 16 >NUL 2>&1
::bcdedit /deletevalue numproc >NUL 2>&1
bcdedit /set MSI Default >NUL 2>&1
::bcdedit /deletevalue MSI >NUL 2>&1
bcdedit /set onecpu No >NUL 2>&1
::bcdedit /deletevalue onecpu >NUL 2>&1
bcdedit /set quietboot Yes >NUL 2>&1
::bcdedit /deletevalue quietboot >NUL 2>&1
bcdedit /set tpmbootentropy ForceDisable >NUL 2>&1
::bcdedit /deletevalue tpmbootentropy >NUL 2>&1
bcdedit /set usefirmwarepcisettings No >NUL 2>&1
::bcdedit /deletevalue usefirmwarepcisettings >NUL 2>&1
bcdedit /set usephysicaldestination No >NUL 2>&1
::bcdedit /deletevalue usephysicaldestination >NUL 2>&1
bcdedit /set vm No >NUL 2>&1
::bcdedit /deletevalue vm >NUL 2>&1
::bcdedit /set vsmlaunchtype Auto >NUL 2>&1
bcdedit /set vsmlaunchtype Off >NUL 2>&1
::bcdedit /deletevalue vsmlaunchtype >NUL 2>&1
bcdedit /set bootdebug Off >NUL 2>&1
bcdedit /bootdebug Off >NUL 2>&1
::bcdedit /deletevalue bootdebug >NUL 2>&1
bcdedit /set bootlog No >NUL 2>&1
::bcdedit /deletevalue bootlog >NUL 2>&1
bcdedit /set bootmenupolicy Legacy >NUL 2>&1
::bcdedit /deletevalue bootmenupolicy >NUL 2>&1
bcdedit /set debugstart Disable >NUL 2>&1
::bcdedit /deletevalue debugstart >NUL 2>&1
bcdedit /set extendedinput Yes >NUL 2>&1
::bcdedit /deletevalue extendedinput >NUL 2>&1
bcdedit /set forcefipscrypto No >NUL 2>&1
::bcdedit /deletevalue forcefipscrypto >NUL 2>&1
bcdedit /set halbreakpoint No >NUL 2>&1
::bcdedit /deletevalue halbreakpoint >NUL 2>&1
bcdedit /set highestmode Yes >NUL 2>&1
::bcdedit /deletevalue highestmode >NUL 2>&1
bcdedit /set noumex Yes >NUL 2>&1
::bcdedit /deletevalue noumex >NUL 2>&1
bcdedit /set pae ForceDisable >NUL 2>&1
::bcdedit /set pae ForceEnable >NUL 2>&1
::bcdedit /deletevalue pae >NUL 2>&1
bcdedit /set sos No >NUL 2>&1
::bcdedit /set sos On >NUL 2>&1
::bcdedit /deletevalue sos >NUL 2>&1
bcdedit /timeout 0 >NUL 2>&1
::bcdedit /deletevalue timeout >NUL 2>&1
bcdedit /set pciexpress ForceDisable >NUL 2>&1
::bcdedit /deletevalue pciexpress >NUL 2>&1
::bcdedit /set disabledynamicparks yes >NUL 2>&1
bcdedit /set perfmem 0 >NUL 2>&1
bcdedit /set clustermodeaddressing 1 >NUL 2>&1
bcdedit /set configflags 0 >NUL 2>&1
bcdedit /set forcelegacyplatform No >NUL 2>&1
bcdedit /set disablecoalescing yes >NUL 2>&1
bcdedit /set recoveryenabled Yes >NUL 2>&1
bcdedit /set restrictapicluster 0 >NUL 2>&1
::bcdedit /deletevalue restrictapicluster >NUL 2>&1
::bcdedit /set testsigning No >NUL 2>&1
::bcdedit /deletevalue testsigning >NUL 2>&1
bcdedit /set {globalsettings} custom:16000067 true >NUL 2>&1
bcdedit /set {globalsettings} custom:16000069 true >NUL 2>&1
bcdedit /set {globalsettings} custom:16000068 true >NUL 2>&1
::bcdedit /set xsavedisable Yes >NUL 2>&1
::bcdedit /set xsavedisable 1 >NUL 2>&1
::bcdedit /deletevalue xsavedisable >NUL 2>&1
::bcdedit /set graphicsmodedisabled No >NUL 2>&1
::bcdedit /deletevalue graphicsmodedisabled >NUL 2>&1
::bcdedit /set integrityservices disable >NUL 2>&1
::bcdedit /deletevalue integrityservices >NUL 2>&1
::bcdedit /set firstmegabytepolicy UseAll >NUL 2>&1 & rem breaks modern windows builds
::bcdedit /deletevalue firstmegabytepolicy >NUL 2>&1
::bcdedit /set {default} bootstatuspolicy ignoreallfailures >NUL 2>&1
bcdedit /set event no >NUL 2>&1
bcdedit /set lastknowngood no >NUL 2>&1
%windir%\system32\lodctr /R >NUL 2>&1
%windir%\sysWOW64\lodctr /R >NUL 2>&1
C:\Windows\SysWOW64\wbem\winmgmt.exe /RESYNCPERF >NUL 2>&1
C:\Windows\System32\wbem\winmgmt.exe /RESYNCPERF >NUL 2>&1
lodctr /e:PerfOS >NUL 2>&1
DISM /Online /Add-Capability /CapabilityName:Language.Basic~~~en-US~0.0.1.0 /NoRestart >NUL 2>&1 & rem emoji picker
DISM /Online /Add-Capability /CapabilityName:Language.Basic~~~pt-BR~0.0.1.0 /NoRestart >NUL 2>&1 & rem emoji picker
dism /online /add-capability /capabilityname:DirectX.Configuration.Database~~~~0.0.1.0 /NoRestart >NUL 2>&1
DISM /Online /Add-Capability /CapabilityName:WMIC~~~~0.0.1.0 /NoRestart >NUL 2>&1
::dism /online /remove-capability /capabilityname:DirectX.Configuration.Database~~~~0.0.1.0 /NoRestart >NUL 2>&1
::packages
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "$apps=@('MSTeams','Microsoft.AIFabric','Microsoft.StartExperiencesApp','MSPaint','Microsoft.Services.Store.Engagement','NcsiUwpApp','Microsoft.Advertising.Xaml','Microsoft-Windows-Hello-Face','9E2F88E3.Twitter','1527c705-839a-4832-9118-54d4Bd6a0c89','46928bounde.EclipseManager','ActiproSoftwareLLC.562882FEEB491','AdobeSystemsIncorporated.AdobePhotoshopExpress','ClearChannelRadioDigital.iHeartRadio','D5EA27B7.Duolingo-LearnLanguagesforFree','Flipboard.Flipboard','InputApp','king.com.CandyCrushSaga','king.com.CandyCrushSodaSaga','Microsoft.3DBuilder','Microsoft.549981C3F5F10','Microsoft.AAD.BrokerPlugin','Microsoft.AccountsControl','Microsoft.Appconnector','Microsoft.AsyncTextService','Microsoft.BingFinance','Microsoft.BingNews','Microsoft.BingSports','Microsoft.BingWeather','Microsoft.BioEnrollment','Microsoft.CommsPhone','Microsoft.CredDialogHost','Microsoft.ECApp','Microsoft.GamingApp','Microsoft.GetHelp','Microsoft.Getstarted','Microsoft.GroupMe10','Microsoft.LockApp','Microsoft.Messaging','Microsoft.Microsoft3DViewer','Microsoft.MicrosoftOfficeHub','Microsoft.MicrosoftSolitaireCollection','Microsoft.MicrosoftStickyNotes','Microsoft.MinecraftUWP','Microsoft.MixedReality.Portal','Microsoft.NetworkSpeedTest','Microsoft.Office.OneNote','Microsoft.Office.Sway','Microsoft.OneConnect','Microsoft.People','Microsoft.PPIProjection','Microsoft.Print3D','Microsoft.RemoteDesktop','Microsoft.SkypeApp','Microsoft.Todos','Microsoft.Wallet','Microsoft.Win32WebViewHost','Microsoft.WindowsAlarms','Microsoft.Windows.Apprep.ChxApp','Microsoft.Windows.AssignedAccessLockApp','Microsoft.Windows.CallingShellApp','Microsoft.Windows.CapturePicker','MicrosoftWindows.Client.WebExperience','microsoft.windowscommunicationsapps','Microsoft.Windows.ContentDeliveryManager','Microsoft.WindowsFeedback','Microsoft.WindowsFeedbackHub','Microsoft.Windows.Holographic.FirstRun','Microsoft.WindowsMaps','Microsoft.Windows.OOBENetworkCaptivePortal','Microsoft.Windows.OOBENetworkConnectionFlow','Microsoft.Windows.ParentalControls','Microsoft.Windows.PeopleExperienceHost','Microsoft.WindowsPhone','Microsoft.Windows.Photos','Microsoft.Windows.PinningConfirmationDialog','Microsoft.Windows.PrintQueueActionCenter','Microsoft.Windows.SecondaryTileExperience','Microsoft.Windows.SecureAssessmentBrowser','Microsoft.WindowsSoundRecorder','MicrosoftWindows.UndockedDevKit','Microsoft.Windows.XGpuEjectDialog','Microsoft.XboxApp','Microsoft.XboxGameCallableUI','Microsoft.XboxGameOverlay','Microsoft.XboxGamingOverlay','Microsoft.XboxIdentityProvider','Microsoft.XboxSpeechToTextOverlay','Microsoft.Xbox.TCUI','Microsoft.YourPhone','Microsoft.ZuneMusic','Microsoft.ZuneVideo','NarratorQuickStart','PandoraMediaInc.29680B314EFC2','ShazamEntertainmentLtd.Shazam','SpotifyAB.SpotifyMusic','Windows.CBSPreview','Windows.ContactSupport','Windows.PrintDialog','Clipchamp.Clipchamp','Microsoft.ApplicationCompatibilityEnhancements','Microsoft.BingSearch','MicrosoftCorporationII.QuickAssist','Microsoft.OutlookForWindows','Microsoft.PowerAutomateDesktop','MicrosoftWindows.CrossDevice','Microsoft.Windows.DevHome','GameAssist','WindowsWebExperiencePack','Windows Web Experience Pack','PowerToys.SparseApp','PowerToys.FileLocksmithContextMenu','PowerToys.ImageResizerContextMenu','PowerToys.PowerRenameContextMenu','MicrosoftWindows.Client.CoreAI','MicrosoftWindows.Client.Photon','MicrosoftWindows.Client.CoPilot','Microsoft.Windows.Ai.Copilot.Provider','Microsoft.Copilot','Microsoft.Office.ActionsServer','aimgr','Microsoft.WritingAssistant','Microsoft.MicrosoftEdgeDevToolsClient','Microsoft.Windows.AugLoop.CBS','Voiess','Speion','Livtop','InpApp','Filons','WindowsWorkload','Microsoft-Copilot-Package','Microsoft.WidgetsPlatformRuntime','Microsoft.WindowsTerminal','LinkedIn');$allInstalled=Get-AppxPackage -AllUsers -ErrorAction SilentlyContinue;$prov=Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue;foreach($a in $apps){$allInstalled | Where-Object {$_.Name -like \"*$a*\"} | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue;$prov | Where-Object {$_.DisplayName -like \"*$a*\"} | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue};$patterns=@('Microsoft-Windows-CodeIntegrity-Diagnostics-Package','Microsoft-Windows-HVSI-*','Microsoft-Windows-HypervisorEnforcedCodeIntegrity-Package','Microsoft-Windows-SenseClient-*','Microsoft-Windows-Wifi-Client-*','Windows-Defender-*','Microsoft-Windows-Ethernet-Client-Vmware-*','Microsoft-Windows-Ethernet-Client-Intel-*','Microsoft-Copilot-Package*');$allPackages=Get-WindowsPackage -Online -ErrorAction SilentlyContinue;foreach($p in $patterns){$allPackages | Where-Object {$_.PackageName -like \"*$p*\"} | Remove-WindowsPackage -Online -NoRestart -ErrorAction SilentlyContinue}" >nul 2>&1
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "$apps=@('MSTeams','Microsoft.AIFabric','Microsoft.StartExperiencesApp','MSPaint','Microsoft.Services.Store.Engagement','NcsiUwpApp','Microsoft.Advertising.Xaml','Microsoft-Windows-Hello-Face','9E2F88E3.Twitter','1527c705-839a-4832-9118-54d4Bd6a0c89','46928bounde.EclipseManager','ActiproSoftwareLLC.562882FEEB491','AdobeSystemsIncorporated.AdobePhotoshopExpress','ClearChannelRadioDigital.iHeartRadio','D5EA27B7.Duolingo-LearnLanguagesforFree','Flipboard.Flipboard','InputApp','king.com.CandyCrushSaga','king.com.CandyCrushSodaSaga','Microsoft.3DBuilder','Microsoft.549981C3F5F10','Microsoft.AAD.BrokerPlugin','Microsoft.AccountsControl','Microsoft.Appconnector','Microsoft.AsyncTextService','Microsoft.BingFinance','Microsoft.BingNews','Microsoft.BingSports','Microsoft.BingWeather','Microsoft.BioEnrollment','Microsoft.CommsPhone','Microsoft.CredDialogHost','Microsoft.ECApp','Microsoft.GamingApp','Microsoft.GetHelp','Microsoft.Getstarted','Microsoft.GroupMe10','Microsoft.LockApp','Microsoft.Messaging','Microsoft.Microsoft3DViewer','Microsoft.MicrosoftOfficeHub','Microsoft.MicrosoftSolitaireCollection','Microsoft.MicrosoftStickyNotes','Microsoft.MinecraftUWP','Microsoft.MixedReality.Portal','Microsoft.NetworkSpeedTest','Microsoft.Office.OneNote','Microsoft.Office.Sway','Microsoft.OneConnect','Microsoft.People','Microsoft.PPIProjection','Microsoft.Print3D','Microsoft.RemoteDesktop','Microsoft.SkypeApp','Microsoft.Todos','Microsoft.Wallet','Microsoft.Win32WebViewHost','Microsoft.WindowsAlarms','Microsoft.Windows.Apprep.ChxApp','Microsoft.Windows.AssignedAccessLockApp','Microsoft.Windows.CallingShellApp','Microsoft.Windows.CapturePicker','MicrosoftWindows.Client.WebExperience','microsoft.windowscommunicationsapps','Microsoft.Windows.ContentDeliveryManager','Microsoft.WindowsFeedback','Microsoft.WindowsFeedbackHub','Microsoft.Windows.Holographic.FirstRun','Microsoft.WindowsMaps','Microsoft.Windows.OOBENetworkCaptivePortal','Microsoft.Windows.OOBENetworkConnectionFlow','Microsoft.Windows.ParentalControls','Microsoft.Windows.PeopleExperienceHost','Microsoft.WindowsPhone','Microsoft.Windows.Photos','Microsoft.Windows.PinningConfirmationDialog','Microsoft.Windows.PrintQueueActionCenter','Microsoft.Windows.SecondaryTileExperience','Microsoft.Windows.SecureAssessmentBrowser','Microsoft.WindowsSoundRecorder','MicrosoftWindows.UndockedDevKit','Microsoft.Windows.XGpuEjectDialog','Microsoft.XboxApp','Microsoft.XboxGameCallableUI','Microsoft.XboxGameOverlay','Microsoft.XboxGamingOverlay','Microsoft.XboxIdentityProvider','Microsoft.XboxSpeechToTextOverlay','Microsoft.Xbox.TCUI','Microsoft.YourPhone','Microsoft.ZuneMusic','Microsoft.ZuneVideo','NarratorQuickStart','PandoraMediaInc.29680B314EFC2','ShazamEntertainmentLtd.Shazam','SpotifyAB.SpotifyMusic','Windows.CBSPreview','Windows.ContactSupport','Windows.PrintDialog','Clipchamp.Clipchamp','Microsoft.ApplicationCompatibilityEnhancements','Microsoft.BingSearch','MicrosoftCorporationII.QuickAssist','Microsoft.OutlookForWindows','Microsoft.PowerAutomateDesktop','MicrosoftWindows.CrossDevice','Microsoft.Windows.DevHome','GameAssist','WindowsWebExperiencePack','Windows Web Experience Pack','PowerToys.SparseApp','PowerToys.FileLocksmithContextMenu','PowerToys.ImageResizerContextMenu','PowerToys.PowerRenameContextMenu','MicrosoftWindows.Client.CoreAI','MicrosoftWindows.Client.Photon','MicrosoftWindows.Client.CoPilot','Microsoft.Windows.Ai.Copilot.Provider','Microsoft.Copilot','Microsoft.Office.ActionsServer','aimgr','Microsoft.WritingAssistant','Microsoft.MicrosoftEdgeDevToolsClient','Microsoft.Windows.AugLoop.CBS','Voiess','Speion','Livtop','InpApp','Filons','WindowsWorkload','Microsoft-Copilot-Package','Microsoft.WidgetsPlatformRuntime','Microsoft.WindowsTerminal','LinkedIn');$users=Get-ChildItem 'C:\Users' -Directory -ErrorAction SilentlyContinue;foreach($a in $apps){foreach($u in $users){Get-ChildItem \"$($u.FullName)\AppData\Local\Packages\" -Filter \"*$a*\" -Directory -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue}}" >nul 2>&1
::features
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "$features=@('FileAndStorage-Services','Storage-Services','File-Services','CoreFileServer','Dedup-Core','HypervisorPlatform','HyperV-KernelInt-VirtualDevice','HyperV-Guest-KernelInt','App-Recorder','AppServerClient','App.StepsRecorder','Browser.InternetExplorer','Client-EmbeddedShellLauncher','ClientForNFS-Infrastructure','Client-KeyboardFilter','Client-ProjFS','Client-UnifiedWriteFilter','Containers-DisposableClientVM','Containers-HNS','Containers','Containers-SDN','Containers-Server-For-Application-Guard','DataCenterBridging','DirectoryServices-ADAM-Client','FaxServicesClientPackage','Hello.Face.20134','HostGuardian','IIS-ApplicationDevelopment','IIS-ApplicationInit','IIS-ASPNET45','IIS-ASP','IIS-BasicAuthentication','IIS-CertProvider','IIS-CGI','IIS-ClientCertificateMappingAuthentication','IIS-CommonHttpFeatures','IIS-CustomLogging','IIS-DefaultDocument','IIS-DigestAuthentication','IIS-DirectoryBrowsing','IIS-FTPExtensibility','IIS-FTPServer','IIS-FTPSvc','IIS-HealthAndDiagnostics','IIS-HostableWebCore','IIS-HttpCompressionDynamic','IIS-HttpCompressionStatic','IIS-HttpErrors','IIS-HttpLogging','IIS-HttpRedirect','IIS-HttpTracing','IIS-IIS6ManagementCompatibility','IIS-IISCertificateMappingAuthentication','IIS-IPSecurity','IIS-ISAPIExtensions','IIS-ISAPIFilter','IIS-LoggingLibraries','IIS-ManagementConsole','IIS-ManagementScriptingTools','IIS-ManagementService','IIS-Metabase','IIS-NetFxExtensibility45','IIS-ODBCLogging','IIS-Performance','IIS-RequestFiltering','IIS-RequestMonitor','IIS-Security','IIS-ServerSideIncludes','IIS-StaticContent','IIS-URLAuthorization','IIS-WebDAV','IIS-WebServerManagementTools','IIS-WebServer','IIS-WebServerRole','IIS-WebSockets','IIS-WindowsAuthentication','IIS-WMICompatibility','Internet-Explorer-Optional-amd64','Language.Basic','Language.Handwriting','Language.OCR','Language.Speech','Language.TextToSpeech','MathRecognizer','MediaPlayback','Media.WindowsMediaPlayer','Microsoft-Hyper-V-All','Microsoft-Hyper-V-Hypervisor','Microsoft-Hyper-V-Management-Clients','Microsoft-Hyper-V-Management-PowerShell','Microsoft-Hyper-V','Microsoft-Hyper-V-Services','Microsoft-Hyper-V-Tools-All','Microsoft-RemoteDesktopConnection','Microsoft.Wallpapers.Extended','Microsoft.Windows.Ethernet.Client.Vmware.Vmxnet3','Microsoft.Windows.PowerShell.ISE','MicrosoftWindowsPowerShellV2','MicrosoftWindowsPowerShellV2Root','Microsoft-Windows-Subsystem-Linux','MSMQ-ADIntegration','MSMQ-Container','MSMQ-DCOMProxy','MSMQ-HTTP','MSMQ-Multicast','MSMQ-Server','MSMQ-Triggers','MSRDC-Infrastructure','MultiPoint-Connector','MultiPoint-Connector-Services','MultiPoint-Tools','NetFx4Extended-ASPNET45','NFS-Administration','OneCoreUAP.OneSync','Printing-Foundation-Features','Printing-Foundation-InternetPrinting-Client','Printing-Foundation-LPDPrintService','Printing-Foundation-LPRPortMonitor','Printing-PrintToPDFServices-Features','Printing-XPSServices-Features','RasRip','recall','SearchEngine-Client-Package','ServicesForNFS-ClientOnly','SimpleTCP','SMB1Protocol-Client','SMB1Protocol-Deprecation','SMB1Protocol','SMB1Protocol-Server','SmbDirect','SNMP','StepsRecorder','Sysmon','TelnetClient','TelnetServer','TFTP','TIFFIFilter','VirtualMachinePlatform','WAS-ConfigurationAPI','WAS-NetFxEnvironment','WAS-ProcessModel','WAS-WindowsActivationService','WCF-HTTP-Activation45','WCF-HTTP-Activation','WCF-MSMQ-Activation45','WCF-NonHTTP-Activation','WCF-Pipe-Activation45','WCF-Services45','WCF-TCP-Activation45','WCF-TCP-PortSharing45','Windows-Defender-ApplicationGuard','Windows-Defender-Default-Definitions','Windows-Defender-Features','Windows-Defender-Gui','Windows-Defender','Windows.DirectoryServices.ADAM.Client.Content','Windows.HyperV.OptionalFeature.VirtualMachinePlatform.Client.Disabled','Windows-Identity-Foundation','Windows.Kernel.LA57','WindowsMediaPlayer','WindowsMixedReality','Windows.SimpleTCP.Content','Windows.SmbDirect','Windows.TFTP.Client','Windows.WinOcr','Windows.WorkFolders.Client','WMISnmpProvider','WorkFolders-Client','Xps-Foundation-Xps-Viewer','Internet-Explorer-Optional-x64','Internet-Explorer-Optional-x86','ScanManagementConsole');foreach($f in $features){Disable-WindowsOptionalFeature -Online -FeatureName $f -Remove -NoRestart -ErrorAction SilentlyContinue}" >nul 2>&1
::capabilities
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "$caps=@('Hello.Face.18967','Accessibility.Braille','Analog.Holographic.Desktop','App.StepsRecorder','App.Support.QuickAssist','App.WirelessDisplay.Connect','Browser.InternetExplorer','Hello.Face.20134','MathRecognizer','Microsoft.OneCore.StorageManagement','Microsoft.WebDriver','Microsoft.Windows.PowerShell.ISE','Microsoft.Windows.Sense.Client','Microsoft.Windows.Wifi.Client.Realtek.Rtl8192se','Microsoft.Windows.Wifi.Client.Realtek.Rtwlane','Microsoft.Windows.Wifi.Client.Realtek.Rtwlane01','Microsoft.Windows.Wifi.Client.Realtek.Rtwlane13','Msix.PackagingTool.Driver','Network.Irda','OneCoreUAP.OneSync','OpenSSH.Client','OpenSSH.Server','Print.EnterpriseCloudPrint','Print.Fax.Scan','Rsat.HyperV.Tools','Print.Management.Console','Print.MopriaCloudService','Rsat.ActiveDirectory.DS-LDS.Tools','Rsat.BitLocker.Recovery.Tools','Rsat.CertificateServices.Tools','Rsat.DHCP.Tools','Rsat.Dns.Tools','Rsat.FailoverCluster.Management.Tools','Rsat.FileServices.Tools','Rsat.GroupPolicy.Management.Tools','Rsat.IPAM.Client.Tools','Rsat.LLDP.Tools','Rsat.NetworkController.Tools','Rsat.NetworkLoadBalancing.Tools','Rsat.RemoteAccess.Management.Tools','Rsat.ServerManager.Tools','Rsat.Shielded.VM.Tools','Rsat.StorageMigrationService.Management.Tools','Rsat.StorageReplica.Tools','Rsat.SystemInsights.Management.Tools','Rsat.VolumeActivation.Tools','Rsat.WSUS.Tools','Tools.DeveloperMode.Core','Windows.Desktop.EMS-SAC.Tools','Windows.Kernel.LA57','XPS.Viewer','Media.WindowsMediaPlayer','Microsoft.Wallpapers.Extended','Microsoft.Windows.Ethernet.Client.Intel.E2f68','Microsoft.Windows.Wifi.Client.Broadcom.Bcmwl63al','Microsoft.Windows.Wifi.Client.Broadcom.Bcmwl63a','Microsoft.Windows.Wifi.Client.Intel.Netwbw02','Microsoft.Windows.Wifi.Client.Intel.Netwew00','Microsoft.Windows.Wifi.Client.Intel.Netwew01','Microsoft.Windows.Wifi.Client.Intel.Netwlv64','Microsoft.Windows.Wifi.Client.Intel.Netwns64','Microsoft.Windows.Wifi.Client.Intel.Netwsw00','Microsoft.Windows.Wifi.Client.Intel.Netwtw02','Microsoft.Windows.Wifi.Client.Intel.Netwtw04','Microsoft.Windows.Wifi.Client.Intel.Netwtw06','Microsoft.Windows.Wifi.Client.Intel.Netwtw08','Microsoft.Windows.Wifi.Client.Intel.Netwtw10','Microsoft.Windows.Wifi.Client.Marvel.Mrvlpcie8897','Microsoft.Windows.Wifi.Client.Qualcomm.Athw8x','Microsoft.Windows.Wifi.Client.Qualcomm.Athwnx','Microsoft.Windows.Wifi.Client.Qualcomm.Qcamain10x64','Microsoft.Windows.Wifi.Client.Ralink.Netr28x');$allC=Get-WindowsCapability -Online -ErrorAction SilentlyContinue;foreach($c in $caps){$allC | Where-Object {$_.Name -like \"$c*\"} | Remove-WindowsCapability -Online -ErrorAction SilentlyContinue}" >nul 2>&1
::dism /online /enable-feature /featurename:DirectPlay /all /norestart >NUL 2>&1
::DISM /Online /Disable-Feature /FeatureName:IIS-LegacyScripts /Remove /NoRestart >NUL 2>&1 & rem directplay
::DISM /Online /Disable-Feature /FeatureName:LegacyComponents /Remove /NoRestart >NUL 2>&1 & rem directplay
::Dism /Online /Disable-Feature /FeatureName:NetFx4-AdvSrvs /Remove /Quiet /NoRestart >NUL 2>&1
::DISM /Online /Remove-Capability /CapabilityName:VBSCRIPT~~~~ /NoRestart >NUL 2>&1
DISM /Online /Set-ReservedStorageState /State:Disabled /NoRestart >NUL 2>&1
DISM /Online /Cleanup-Image /StartComponentCleanup /ResetBase >NUL 2>&1
::if not exist C:\Windows\System32\wbem\WMIC.exe DISM /Online /Add-Capability /CapabilityName:WMIC~~~~ >NUL 2>&1
wmic process where "name='Adobe Crash Processor.exe'" CALL terminate >NUL 2>&1
powershell -NoProfile -Command "Get-CimInstance Win32_Process -Filter 'Name=''Adobe Crash Processor.exe''' | Invoke-CimMethod -MethodName Terminate" >NUL 2>&1
wmic process where "name='ctfmon.exe'" CALL setpriority 16384 >NUL 2>&1
powershell -NoProfile -Command "Get-CimInstance Win32_Process -Filter 'Name=''ctfmon.exe''' | Invoke-CimMethod -MethodName SetPriority -Arguments @{Priority=16384}" >NUL 2>&1
wmic process where "name='dllhost.exe'" CALL setpriority 16384 >NUL 2>&1
powershell -NoProfile -Command "Get-CimInstance Win32_Process -Filter 'Name=''dllhost.exe''' | Invoke-CimMethod -MethodName SetPriority -Arguments @{Priority=16384}" >NUL 2>&1
wmic process where "name='dwm.exe'" CALL setpriority 128 >NUL 2>&1
powershell -NoProfile -Command "Get-CimInstance Win32_Process -Filter 'Name=''dwm.exe''' | Invoke-CimMethod -MethodName SetPriority -Arguments @{Priority=128}" >NUL 2>&1
wmic process where "name='fontdrvhost.exe'" CALL setpriority 64 >NUL 2>&1
powershell -NoProfile -Command "Get-CimInstance Win32_Process -Filter 'Name=''fontdrvhost.exe''' | Invoke-CimMethod -MethodName SetPriority -Arguments @{Priority=64}" >NUL 2>&1
wmic process where "name='audiodg.exe'" CALL setpriority 64 >NUL 2>&1
powershell -NoProfile -Command "Get-CimInstance Win32_Process -Filter 'Name=''audiodg.exe''' | Invoke-CimMethod -MethodName SetPriority -Arguments @{Priority=64}" >NUL 2>&1
wmic process where "name='MoUsoCoreWorker.exe'" CALL terminate >NUL 2>&1
powershell -NoProfile -Command "Get-CimInstance Win32_Process -Filter 'Name=''MoUsoCoreWorker.exe''' | Invoke-CimMethod -MethodName Terminate" >NUL 2>&1
wmic process where "name='MpDefenderCoreService.exe'" CALL terminate >NUL 2>&1
powershell -NoProfile -Command "Get-CimInstance Win32_Process -Filter 'Name=''MpDefenderCoreService.exe''' | Invoke-CimMethod -MethodName Terminate" >NUL 2>&1
wmic process where "name='OfficeClickToRun.exe'" CALL terminate >NUL 2>&1
powershell -NoProfile -Command "Get-CimInstance Win32_Process -Filter 'Name=''OfficeClickToRun.exe''' | Invoke-CimMethod -MethodName Terminate" >NUL 2>&1
wmic process where "name='taskhostw.exe'" CALL terminate >NUL 2>&1
powershell -NoProfile -Command "Get-CimInstance Win32_Process -Filter 'Name=''taskhostw.exe''' | Invoke-CimMethod -MethodName Terminate" >NUL 2>&1
wmic process where "name='winlogon.exe'" CALL setpriority 64 >NUL 2>&1
powershell -NoProfile -Command "Get-CimInstance Win32_Process -Filter 'Name=''winlogon.exe''' | Invoke-CimMethod -MethodName SetPriority -Arguments @{Priority=64}" >NUL 2>&1
wmic process where "name='svchost.exe'" CALL setpriority 16384 >NUL 2>&1
powershell -NoProfile -Command "Get-CimInstance Win32_Process -Filter 'Name=''svchost.exe''' | Invoke-CimMethod -MethodName SetPriority -Arguments @{Priority=16384}" >NUL 2>&1
wmic process where "name='ShellHost.exe'" CALL setpriority 16384 >NUL 2>&1
powershell -NoProfile -Command "Get-CimInstance Win32_Process -Filter 'Name=''ShellHost.exe''' | Invoke-CimMethod -MethodName SetPriority -Arguments @{Priority=16384}" >NUL 2>&1
wmic process where "name='WmiPrvSE.exe'" CALL setpriority 16384 >NUL 2>&1
powershell -NoProfile -Command "Get-CimInstance Win32_Process -Filter 'Name=''WmiPrvSE.exe''' | Invoke-CimMethod -MethodName SetPriority -Arguments @{Priority=16384}" >NUL 2>&1
wmic process where "name='WmiPrvSvc.exe'" CALL terminate >NUL 2>&1
powershell -NoProfile -Command "Get-CimInstance Win32_Process -Filter 'Name=''WmiPrvSvc.exe''' | Invoke-CimMethod -MethodName Terminate" >NUL 2>&1
::powershell -NoProfile -Command $p = Get-Process audiodg -ErrorAction SilentlyContinue; if ($p) { $p.ProcessorAffinity = 1 } >NUL 2>&1
bcdedit /set {current} nx OptOut >NUL 2>&1
bcdedit /set {current} nx AlwaysOff >NUL 2>&1
::bcdedit /deletevalue nx >NUL 2>&1
bcdedit /deletevalue nointegritychecks >NUL 2>&1
::bcdedit /deletevalue loadoptions >NUL 2>&1
bcdedit /set loadoptions DISABLE-LSA-ISO,DISABLE-VBS >NUL 2>&1
::for /f tokens=* %%a in ('logman query ^| findstr /i trace') do logman stop %%a -ets
::for /f tokens=1 %%i in ('logman query -ets ^| findstr Running') do logman stop %%i -ets
powershell -NoProfile -ExecutionPolicy Bypass -Command "logman query -ets | Where-Object {$_ -match 'Running'} | ForEach-Object { $n=($_ -replace '\s{2,}.*$', '').Trim(); if($n -and $n -notmatch '-+$'){ logman stop $n -ets } }" >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "Set-ProcessMitigation -System -Disable DEP,EmulateAtlThunks,SEHOP,ForceRelocateImages,RequireInfo,BottomUp,HighEntropy,StrictHandle,DisableWin32kSystemCalls,AuditSystemCall,DisableExtensionPoints,DisableFsctlSystemCalls,AuditFsctlSystemCall,BlockDynamicCode,AllowThreadsToOptOut,AuditDynamicCode,CFG,SuppressExports,StrictCFG,MicrosoftSignedOnly,AllowStoreSignedBinaries,AuditMicrosoftSigned,AuditStoreSigned,EnforceModuleDependencySigning,DisableNonSystemFonts,AuditFont,BlockRemoteImageLoads,BlockLowLabelImageLoads,PreferSystem32,AuditRemoteImageLoads,AuditLowLabelImageLoads,AuditPreferSystem32,EnableExportAddressFilter,AuditEnableExportAddressFilter,EnableExportAddressFilterPlus,AuditEnableExportAddressFilterPlus,EnableImportAddressFilter,AuditEnableImportAddressFilter,EnableRopStackPivot,AuditEnableRopStackPivot,EnableRopCallerCheck,AuditEnableRopCallerCheck,EnableRopSimExec,AuditEnableRopSimExec,AuditSEHOP,SEHOPTelemetry,TerminateOnError,DisallowChildProcessCreation,AuditChildProcess,UserShadowStack,UserShadowStackStrictMode,AuditUserShadowStack" >nul 2>&1
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "Get-PnpDevice | Where-Object {$_.FriendlyName -eq 'High precision event timer'} | Select-Object -ExpandProperty InstanceId"') do pnputil /disable-device "%%i" >nul 2>&1
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "Get-PnpDevice | Where-Object {$_.FriendlyName -eq 'Microsoft Device Association Root Enumerator'} | Select-Object -ExpandProperty InstanceId"') do pnputil /disable-device "%%i" >nul 2>&1
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "Get-PnpDevice | Where-Object { $_.FriendlyName -eq 'Device Association' } | Select-Object -ExpandProperty InstanceId"') do pnputil /disable-device "%%i" >nul 2>&1
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "Get-PnpDevice | Where-Object { $_.FriendlyName -like '*PCI Device*' -and $_.Status -eq 'Error' } | Select-Object -ExpandProperty InstanceId"') do pnputil /disable-device "%%i" >nul 2>&1
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "Get-PnpDevice | Where-Object {$_.FriendlyName -eq 'Microsoft GS Wavetable Synth'} | Select-Object -ExpandProperty InstanceId"') do pnputil /disable-device "%%i" >nul 2>&1
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "Get-PnpDevice | Where-Object {$_.FriendlyName -like '*RRAS*'} | Select-Object -ExpandProperty InstanceId"') do pnputil /disable-device "%%i" >nul 2>&1
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "Get-PnpDevice | Where-Object {$_.FriendlyName -eq 'Composite Bus Enumerator'} | Select-Object -ExpandProperty InstanceId"') do pnputil /disable-device "%%i" >nul 2>&1
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "Get-PnpDevice | Where-Object {$_.FriendlyName -eq 'Microsoft Virtual Drive Enumerator'} | Select-Object -ExpandProperty InstanceId"') do pnputil /disable-device "%%i" >nul 2>&1
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "Get-PnpDevice | Where-Object {$_.FriendlyName -like '*Remote Desktop*'} | Select-Object -ExpandProperty InstanceId"') do pnputil /disable-device "%%i" >nul 2>&1
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "Get-PnpDevice | Where-Object {$_.FriendlyName -eq 'UMBus Root Bus Enumerator'} | Select-Object -ExpandProperty InstanceId"') do pnputil /disable-device "%%i" >nul 2>&1
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "Get-PnpDevice | Where-Object {$_.FriendlyName -eq 'NDIS Virtual Network Adapter Enumerator'} | Select-Object -ExpandProperty InstanceId"') do pnputil /disable-device "%%i" >nul 2>&1
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "Get-PnpDevice | Where-Object { $_.FriendlyName -like '*AMD PSP*' -or $_.FriendlyName -like '*Platform Security Processor*' } | Select-Object -ExpandProperty InstanceId"') do pnputil /disable-device "%%i" >nul 2>&1
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "Get-PnpDevice | Where-Object { $_.FriendlyName -like '*ISA*Bridge*' } | Select-Object -ExpandProperty InstanceId"') do pnputil /disable-device "%%i" >nul 2>&1
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "Get-PnpDevice | Where-Object { $_.FriendlyName -like '*RAM Controller*' } | Select-Object -ExpandProperty InstanceId"') do pnputil /disable-device "%%i" >nul 2>&1
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "Get-PnpDevice | Where-Object {$_.FriendlyName -eq 'Microsoft System Management BIOS Driver'} | Select-Object -ExpandProperty InstanceId"') do pnputil /disable-device "%%i" >nul 2>&1
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "Get-PnpDevice | Where-Object {$_.FriendlyName -eq 'System Speaker'} | Select-Object -ExpandProperty InstanceId"') do pnputil /disable-device "%%i" >nul 2>&1
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "Get-PnpDevice | Where-Object {$_.FriendlyName -eq 'AMD SMBus'} | Select-Object -ExpandProperty InstanceId"') do pnputil /disable-device "%%i" >nul 2>&1
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "Get-PnpDevice | Where-Object {$_.FriendlyName -eq 'Motherboard resources'} | Select-Object -ExpandProperty InstanceId"') do pnputil /disable-device "%%i" >nul 2>&1
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "Get-PnpDevice -PresentOnly:$false | Where-Object { $_.FriendlyName -eq 'Microsoft Device Association Root Enumerator' } | Select-Object -ExpandProperty InstanceId"') do pnputil /remove-device "%%i" >nul 2>&1
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "Get-PnpDevice -PresentOnly:$false | Where-Object { $_.FriendlyName -eq 'Microsoft Streaming Service Proxy' } | Select-Object -ExpandProperty InstanceId"') do pnputil /remove-device "%%i" >nul 2>&1
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
powershell -NoProfile -Command "$me=[System.Security.Principal.WindowsIdentity]::GetCurrent().User; $sys=[System.Security.Principal.SecurityIdentifier]'S-1-5-18'; $full=[System.Security.AccessControl.RegistryRights]'FullControl'; $dw=[System.Security.AccessControl.RegistryRights]'SetValue,CreateSubKey,Delete'; $allow=[System.Security.AccessControl.AccessControlType]::Allow; $deny=[System.Security.AccessControl.AccessControlType]::Deny; $ci=[System.Security.AccessControl.InheritanceFlags]::ContainerInherit; $none=[System.Security.AccessControl.PropagationFlags]::None; foreach($p in @('HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR','HKCU:\System\GameConfigStore','Registry::HKEY_USERS\.DEFAULT\System\GameConfigStore')){ if(-not(Test-Path $p)){New-Item $p -Force|Out-Null}; $acl=New-Object System.Security.AccessControl.RegistrySecurity; $acl.SetAccessRuleProtection($true,$false); $acl.AddAccessRule((New-Object System.Security.AccessControl.RegistryAccessRule($me,$full,$ci,$none,$allow))); $acl.AddAccessRule((New-Object System.Security.AccessControl.RegistryAccessRule($sys,$dw,$ci,$none,$deny))); Set-Acl $p $acl}" >nul 2>&1
powershell -NoProfile -Command "$me=[System.Security.Principal.WindowsIdentity]::GetCurrent().User; $sys=[System.Security.Principal.SecurityIdentifier]'S-1-5-18'; $full=[System.Security.AccessControl.RegistryRights]'FullControl'; $wblock=[System.Security.AccessControl.RegistryRights]'SetValue,CreateSubKey'; $allow=[System.Security.AccessControl.AccessControlType]::Allow; $deny=[System.Security.AccessControl.AccessControlType]::Deny; $ci=[System.Security.AccessControl.InheritanceFlags]::ContainerInherit; $none=[System.Security.AccessControl.PropagationFlags]::None; $p='HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FeatureUsage'; Remove-Item $p -Recurse -Force -EA SilentlyContinue; $null=New-Item $p -Force; $acl=New-Object System.Security.AccessControl.RegistrySecurity; $acl.SetAccessRuleProtection($true,$false); $acl.AddAccessRule((New-Object System.Security.AccessControl.RegistryAccessRule($me,$full,$ci,$none,$allow))); $acl.AddAccessRule((New-Object System.Security.AccessControl.RegistryAccessRule($me,$wblock,$ci,$none,$deny))); $acl.AddAccessRule((New-Object System.Security.AccessControl.RegistryAccessRule($sys,$wblock,$ci,$none,$deny))); Set-Acl $p $acl" >nul 2>&1
powershell -nop -ep bypass -c "$sid=[System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value; $p='HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\InstallService\Stubification\'+$sid; New-Item $p -Force | Out-Null; New-ItemProperty $p EnableAppOffloading -Type DWord -Value 0 -Force" >nul 2>&1
powershell -nop -ep bypass -c "$sid=[System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value; Remove-Item -Path ('HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\'+$sid) -Recurse -Force -ErrorAction SilentlyContinue" >nul 2>&1
powershell -NoProfile -Command "$me=[System.Security.Principal.WindowsIdentity]::GetCurrent().User; $sys=[System.Security.Principal.SecurityIdentifier]'S-1-5-18'; $read=[System.Security.AccessControl.RegistryRights]'ReadKey'; $dw=[System.Security.AccessControl.RegistryRights]'SetValue,CreateSubKey,Delete'; $allow=[System.Security.AccessControl.AccessControlType]::Allow; $deny=[System.Security.AccessControl.AccessControlType]::Deny; $ci=[System.Security.AccessControl.InheritanceFlags]::ContainerInherit; $none=[System.Security.AccessControl.PropagationFlags]::None; $p='HKLM:\SYSTEM\Software\Microsoft\TIP\AggregateResults'; if(-not(Test-Path $p)){New-Item $p -Force|Out-Null}; $acl=New-Object System.Security.AccessControl.RegistrySecurity; $acl.SetAccessRuleProtection($true,$false); $acl.AddAccessRule((New-Object System.Security.AccessControl.RegistryAccessRule($me,$read,$ci,$none,$allow))); $acl.AddAccessRule((New-Object System.Security.AccessControl.RegistryAccessRule($sys,$dw,$ci,$none,$deny))); Set-Acl $p $acl; Set-ItemProperty -Path $p -Name 'data' -Value '' -Force|Out-Null; Set-ItemProperty -Path $p -Name 'timestamp' -Value '' -Force|Out-Null" >nul 2>&1
powershell -NoProfile -Command "$base='HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\SystemAppData'; $me=[System.Security.Principal.WindowsIdentity]::GetCurrent().User; $sys=[System.Security.Principal.SecurityIdentifier]'S-1-5-18'; $read=[System.Security.AccessControl.RegistryRights]'ReadKey'; $wblock=[System.Security.AccessControl.RegistryRights]'SetValue,CreateSubKey'; $allow=[System.Security.AccessControl.AccessControlType]::Allow; $deny=[System.Security.AccessControl.AccessControlType]::Deny; $ci=[System.Security.AccessControl.InheritanceFlags]::ContainerInherit; $none=[System.Security.AccessControl.PropagationFlags]::None; Get-ChildItem $base -EA 0 | %%{ $ham=Join-Path $_.PSPath 'HAM'; if(Test-Path $ham){ Get-ChildItem $ham -Recurse -EA 0 | ?{$_.PSChildName -eq 'LU'} | %%{ $k=$_; $k.GetValueNames()|%%{Remove-ItemProperty -LiteralPath $k.PSPath -Name $_ -EA 0}; $acl=New-Object System.Security.AccessControl.RegistrySecurity; $acl.SetAccessRuleProtection($true,$false); $acl.AddAccessRule((New-Object System.Security.AccessControl.RegistryAccessRule($me,$read,$ci,$none,$allow))); $acl.AddAccessRule((New-Object System.Security.AccessControl.RegistryAccessRule($me,$wblock,$ci,$none,$deny))); $acl.AddAccessRule((New-Object System.Security.AccessControl.RegistryAccessRule($sys,$wblock,$ci,$none,$deny))); Set-Acl -LiteralPath $k.PSPath $acl }; $acl2=New-Object System.Security.AccessControl.RegistrySecurity; $acl2.SetAccessRuleProtection($true,$false); $acl2.AddAccessRule((New-Object System.Security.AccessControl.RegistryAccessRule($me,$read,$ci,$none,$allow))); $acl2.AddAccessRule((New-Object System.Security.AccessControl.RegistryAccessRule($me,$wblock,$ci,$none,$deny))); $acl2.AddAccessRule((New-Object System.Security.AccessControl.RegistryAccessRule($sys,$wblock,$ci,$none,$deny))); Set-Acl -LiteralPath $ham $acl2 } }" >nul 2>&1
powershell -NoProfile -Command "$me=[System.Security.Principal.WindowsIdentity]::GetCurrent().User; $sys=[System.Security.Principal.SecurityIdentifier]'S-1-5-18'; $read=[System.Security.AccessControl.RegistryRights]'ReadKey'; $dw=[System.Security.AccessControl.RegistryRights]'SetValue,CreateSubKey,Delete'; $al=[System.Security.AccessControl.AccessControlType]::Allow; $dn=[System.Security.AccessControl.AccessControlType]::Deny; $ci=[System.Security.AccessControl.InheritanceFlags]::ContainerInherit; $no=[System.Security.AccessControl.PropagationFlags]::None; $p='HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Notifications\Data'; if(-not(Test-Path $p)){New-Item $p -Force|Out-Null}; Get-Item $p|Select-Object -ExpandProperty Property|%%{Remove-ItemProperty -Path $p -Name $_ -EA 0}; $acl=New-Object System.Security.AccessControl.RegistrySecurity; $acl.SetAccessRuleProtection($true,$false); $acl.AddAccessRule((New-Object System.Security.AccessControl.RegistryAccessRule($me,$read,$ci,$no,$al))); $acl.AddAccessRule((New-Object System.Security.AccessControl.RegistryAccessRule($sys,$dw,$ci,$no,$dn))); Set-Acl $p $acl" >nul 2>&1
powershell -NoProfile -Command "$me=[System.Security.Principal.WindowsIdentity]::GetCurrent().User; $sys=[System.Security.Principal.SecurityIdentifier]'S-1-5-18'; $read=[System.Security.AccessControl.RegistryRights]'ReadKey'; $dw=[System.Security.AccessControl.RegistryRights]'SetValue,CreateSubKey,Delete'; $al=[System.Security.AccessControl.AccessControlType]::Allow; $dn=[System.Security.AccessControl.AccessControlType]::Deny; $ci=[System.Security.AccessControl.InheritanceFlags]::ContainerInherit; $no=[System.Security.AccessControl.PropagationFlags]::None; $p='HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Notifications'; if(-not(Test-Path $p)){New-Item $p -Force|Out-Null}; Get-Item $p|Select-Object -ExpandProperty Property|%%{Remove-ItemProperty -Path $p -Name $_ -EA 0}; $acl=New-Object System.Security.AccessControl.RegistrySecurity; $acl.SetAccessRuleProtection($true,$false); $acl.AddAccessRule((New-Object System.Security.AccessControl.RegistryAccessRule($me,$read,$ci,$no,$al))); $acl.AddAccessRule((New-Object System.Security.AccessControl.RegistryAccessRule($sys,$dw,$ci,$no,$dn))); Set-Acl $p $acl" >nul 2>&1
powershell -NoProfile -Command "$me=[System.Security.Principal.WindowsIdentity]::GetCurrent().User; $sys=[System.Security.Principal.SecurityIdentifier]'S-1-5-18'; $read=[System.Security.AccessControl.RegistryRights]'ReadKey'; $dw=[System.Security.AccessControl.RegistryRights]'SetValue,CreateSubKey,Delete'; $al=[System.Security.AccessControl.AccessControlType]::Allow; $dn=[System.Security.AccessControl.AccessControlType]::Deny; $ci=[System.Security.AccessControl.InheritanceFlags]::ContainerInherit; $no=[System.Security.AccessControl.PropagationFlags]::None; $p='HKCU:\Software\Microsoft\Windows\CurrentVersion\Search\JumplistData'; if(-not(Test-Path $p)){New-Item $p -Force|Out-Null}; Get-Item $p|Select-Object -ExpandProperty Property|%%{Remove-ItemProperty -Path $p -Name $_ -EA 0}; $acl=New-Object System.Security.AccessControl.RegistrySecurity; $acl.SetAccessRuleProtection($true,$false); $acl.AddAccessRule((New-Object System.Security.AccessControl.RegistryAccessRule($me,$read,$ci,$no,$al))); $acl.AddAccessRule((New-Object System.Security.AccessControl.RegistryAccessRule($sys,$dw,$ci,$no,$dn))); Set-Acl $p $acl" >nul 2>&1
powershell -NoProfile -Command "$me=[System.Security.Principal.WindowsIdentity]::GetCurrent().User; $sys=[System.Security.Principal.SecurityIdentifier]'S-1-5-18'; $full=[System.Security.AccessControl.RegistryRights]'FullControl'; $dw=[System.Security.AccessControl.RegistryRights]'SetValue,CreateSubKey,Delete'; $allow=[System.Security.AccessControl.AccessControlType]::Allow; $deny=[System.Security.AccessControl.AccessControlType]::Deny; $ci=[System.Security.AccessControl.InheritanceFlags]::ContainerInherit; $none=[System.Security.AccessControl.PropagationFlags]::None; $p='HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe'; $acl=New-Object System.Security.AccessControl.RegistrySecurity; $acl.SetAccessRuleProtection($true,$false); $acl.AddAccessRule((New-Object System.Security.AccessControl.RegistryAccessRule($me,$full,$ci,$none,$allow))); $acl.AddAccessRule((New-Object System.Security.AccessControl.RegistryAccessRule($sys,$dw,$ci,$none,$deny))); Set-Acl $p $acl" >nul 2>&1
powershell -NoP -C "$k='HKCU:\Software\Microsoft\Windows\CurrentVersion\RunNotification';if(Test-Path $k){$n=(Get-Item $k).Property|?{$_ -like '*MicrosoftCopilotAutoLaunch*'};if($n){Remove-ItemProperty $k -Name $n -Force}}" >nul 2>&1
pnputil /disable-device "ROOT\AMDLOG\0000" >nul 2>&1
pnputil /disable-device "ROOT\AMDSAFD&FUN_01&REV_01\0000" >nul 2>&1
pnputil /remove-device "ROOT\KDNIC\0000" >nul 2>&1 & rem disable/remove
pnputil /disable-device "ROOT\VID\0000" >nul 2>&1
pnputil /disable-device "SWD\DRIVERENUM\AMDWIN&7&3675a230&0" >nul 2>&1
pnputil /disable-device "SWD\MSRRAS\{3e259276-bc7e-40e3-b93b-8f89b5f3abc0}" >nul 2>&1
pnputil /disable-device "SWD\MSRRAS\MS_AGILEVPNMINIPORT" >nul 2>&1
pnputil /disable-device "SWD\MSRRAS\MS_L2TPMINIPORT" >nul 2>&1
pnputil /disable-device "SWD\MSRRAS\MS_NDISWANBH" >nul 2>&1
pnputil /disable-device "SWD\MSRRAS\MS_NDISWANIP" >nul 2>&1
pnputil /disable-device "SWD\MSRRAS\MS_NDISWANIPV6" >nul 2>&1
pnputil /disable-device "SWD\MSRRAS\MS_PPPOEMINIPORT" >nul 2>&1
pnputil /disable-device "SWD\MSRRAS\MS_PPTPMINIPORT" >nul 2>&1
pnputil /disable-device "SWD\MSRRAS\MS_SSTPMINIPORT" >nul 2>&1
pnputil /disable-device "SWD\PRINTENUM\{3C9B425C-5DD5-4DC1-AFDE-4EDFD21FFDAE}" >nul 2>&1
pnputil /disable-device "SWD\PRINTENUM\PrintQueues" >nul 2>&1
pnputil /disable-device "SWD\RADIO\{3DB5895D-CC28-44B3-AD3D-6F01A782B8D2}" >nul 2>&1
pnputil /disable-device "SWD\MIDISRV\MIDIU_APP_TRANSPORT" >nul 2>&1
pnputil /disable-device "SWD\MIDISRV\MIDIU_DIAG_PING" >nul 2>&1
pnputil /disable-device "SWD\MIDISRV\MIDIU_DIAG_LOOPBACK_B" >nul 2>&1
pnputil /disable-device "SWD\MIDISRV\MIDIU_DIAG_LOOPBACK_A" >nul 2>&1
pnputil /disable-device "SWD\MIDISRV\MIDIU_DIAG_TRANSPORT" >nul 2>&1
pnputil /disable-device "USB\VID_045E&PID_028E\20492BE" >nul 2>&1 & rem xbox joystick
::pnputil /enable-device "USB\VID_045E&PID_028E\20492BE" >nul 2>&1 & rem xbox joystick
takeown /f %SystemRoot%\System32\drivers\Acpidev.sys >nul 2>&1
takeown /f %SystemRoot%\System32\drivers\Acpipagr.sys >nul 2>&1
takeown /f %SystemRoot%\System32\drivers\Acpitime.sys >nul 2>&1
takeown /f %SystemRoot%\System32\drivers\Acpipmi.sys >nul 2>&1
icacls %SystemRoot%\System32\drivers\Acpidev.sys /grant %username%:F >nul 2>&1
icacls %SystemRoot%\System32\drivers\Acpipagr.sys /grant %username%:F >nul 2>&1
icacls %SystemRoot%\System32\drivers\Acpitime.sys /grant %username%:F >nul 2>&1
icacls %SystemRoot%\System32\drivers\Acpipmi.sys /grant %username%:F >nul 2>&1
del /f /q %SystemRoot%\System32\drivers\Acpidev.sys >nul 2>&1
del /f /q %SystemRoot%\System32\drivers\Acpipagr.sys >nul 2>&1
del /f /q %SystemRoot%\System32\drivers\Acpitime.sys >nul 2>&1
del /f /q %SystemRoot%\System32\drivers\Acpipmi.sys >nul 2>&1
takeown /f C:\Windows\System32\mcupdate_GenuineIntel.dll >nul 2>&1
takeown /f C:\Windows\System32\mcupdate_AuthenticAMD.dll >nul 2>&1
icacls %SystemRoot%\System32\mcupdate_GenuineIntel.dll /grant %username%:F >nul 2>&1
icacls %SystemRoot%\System32\mcupdate_AuthenticAMD.dll /grant %username%:F >nul 2>&1
del C:\Windows\System32\mcupdate_GenuineIntel.dll >nul 2>&1
del C:\Windows\System32\mcupdate_AuthenticAMD.dll >nul 2>&1
takeown /f C:\Windows\System32\GameBarPresenceWriter.exe >nul 2>&1
takeown /f C:\Windows\System32\GameBarPresenceWriter.proxy.dll >nul 2>&1
takeown /f C:\Windows\System32\Windows.Gaming.UI.GameBar.dll >nul 2>&1
icacls %SystemRoot%\System32\GameBarPresenceWriter.exe /grant %username%:F >nul 2>&1
icacls %SystemRoot%\System32\GameBarPresenceWriter.proxy.dll /grant %username%:F >nul 2>&1
icacls %SystemRoot%\System32\Windows.Gaming.UI.GameBar.dll /grant %username%:F >nul 2>&1
del C:\Windows\System32\GameBarPresenceWriter.exe >nul 2>&1
del C:\Windows\System32\GameBarPresenceWriter.proxy.dll >nul 2>&1
del C:\Windows\System32\Windows.Gaming.UI.GameBar.dll >nul 2>&1
takeown /f C:\Windows\System32\bcastdvr.exe >nul 2>&1
takeown /f C:\Windows\System32\bcastdvruserservice.dll >nul 2>&1
takeown /f C:\Windows\System32\bcastdvr.proxy.dll >nul 2>&1
takeown /f C:\Windows\System32\BcastDVRCommon.dll >nul 2>&1
takeown /f C:\Windows\System32\BcastDVRBroker.dll >nul 2>&1
takeown /f C:\Windows\System32\BcastDVRClient.dll >nul 2>&1
takeown /f C:\Windows\System32\en-US\bcastdvruserservice.dll.mui >nul 2>&1
icacls %SystemRoot%\System32\bcastdvr.exe /grant %username%:F >nul 2>&1
icacls %SystemRoot%\System32\bcastdvruserservice.dll /grant %username%:F >nul 2>&1
icacls %SystemRoot%\System32\bcastdvr.proxy.dll /grant %username%:F >nul 2>&1
icacls %SystemRoot%\System32\BcastDVRCommon.dll /grant %username%:F >nul 2>&1
icacls %SystemRoot%\System32\BcastDVRBroker.dll /grant %username%:F >nul 2>&1
icacls %SystemRoot%\System32\BcastDVRClient.dll /grant %username%:F >nul 2>&1
icacls %SystemRoot%\System32\en-US\bcastdvruserservice.dll.mui /grant %username%:F >nul 2>&1
del C:\Windows\System32\bcastdvr.exe >nul 2>&1
del C:\Windows\System32\bcastdvruserservice.dll >nul 2>&1
del C:\Windows\System32\bcastdvr.proxy.dll >nul 2>&1
del C:\Windows\System32\BcastDVRCommon.dll >nul 2>&1
del C:\Windows\System32\BcastDVRBroker.dll >nul 2>&1
del C:\Windows\System32\BcastDVRClient.dll >nul 2>&1
del C:\Windows\System32\en-US\bcastdvruserservice.dll.mui >nul 2>&1
takeown /f %SystemRoot%\System32\spool\drivers\color /r /d y >nul 2>&1
icacls %SystemRoot%\System32\spool\drivers\color /grant Administrators:F /t >nul 2>&1
del /f /s /q %SystemRoot%\System32\spool\drivers\color\*.* >nul 2>&1
for /D %%D in (%SystemRoot%\System32\spool\drivers\color\*) do rmdir /s /q %%D >nul 2>&1
takeown /f %WinDir%\HelpPane.exe >nul 2>&1
icacls %WinDir%\HelpPane.exe /deny Everyone:(X) >nul 2>&1
takeown /F %windir%\System32\CompatTelRunner.exe >nul 2>&1
icacls %windir%\System32\CompatTelRunner.exe /grant %username%:F >nul 2>&1
del %windir%\System32\CompatTelRunner.exe /f >nul 2>&1
takeown /f "%ProgramFiles%\Microsoft GameInput" /r /d y >nul 2>&1
icacls "%ProgramFiles%\Microsoft GameInput" /grant %username%:F /t >nul 2>&1
rd /s /q "%ProgramFiles%\Microsoft GameInput" >nul 2>&1
takeown /f "%SystemRoot%\System32\GameInputRedist.dll" >nul 2>&1
icacls "%SystemRoot%\System32\GameInputRedist.dll" /grant %username%:F >nul 2>&1
del /f /q "%SystemRoot%\System32\GameInputRedist.dll" >nul 2>&1
::for %%F in (wlidsvc.dll dosvc.dll) do takeown /f %SystemRoot%\System32\%%F >nul 2>&1 & icacls %SystemRoot%\System32\%%F /grant %username%:F >nul 2>&1 & del /f /q %SystemRoot%\System32\%%F >nul 2>&1
::for %%F in (wlidsvc.dll.mui dosvc.dll.mui) do takeown /f %SystemRoot%\System32\en-US\%%F >nul 2>&1 & icacls %SystemRoot%\System32\en-US\%%F /grant %username%:F >nul 2>&1 & del /f /q %SystemRoot%\System32\en-US\%%F >nul 2>&1
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
( taskkill /f /t /im SearchHost.exe & takeown /s %computername% /u %username% /f C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\SearchHost.exe & icacls C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\SearchHost.exe /grant:r %username%:F & taskkill /im SearchHost.exe /f & del C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\SearchHost.exe /s /f /q ) >nul 2>&1
( taskkill /f /t /im SearchApp.exe & takeown /s %computername% /u %username% /f C:\Windows\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy\SearchApp.exe & icacls C:\Windows\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy\SearchApp.exe /grant:r %username%:F & taskkill /im SearchApp.exe /f & del C:\Windows\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy\SearchApp.exe /s /f /q ) >nul 2>&1
( takeown /s %computername% /u %username% /f C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\CrossDeviceResumeView.dll & icacls C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\CrossDeviceResumeView.dll /grant:r %username%:F & taskkill /im CrossDeviceResume.exe /f & del C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\CrossDeviceResumeView.dll /s /f /q ) >nul 2>&1
( takeown /s %computername% /u %username% /f C:\Windows\System32\AggregatorHost.exe & icacls C:\Windows\System32\AggregatorHost.exe /grant:r %username%:F & taskkill /im AggregatorHost.exe /f & del C:\Windows\System32\AggregatorHost.exe /s /f /q ) >nul 2>&1
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
( takeown /s %computername% /u %username% /f "C:\ProgramData\Microsoft\Windows Defender\Platform" & icacls "C:\ProgramData\Microsoft\Windows Defender\Platform" /grant:r %username%:F & taskkill /im MsMpEng.exe /f & taskkill /im NisSrv.exe /f & del "C:\ProgramData\Microsoft\Windows Defender\Platform" /s /f /q ) >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "Set-WinLanguageBarOption -UseLegacyLanguageBar"
::( for /R "C:\Program Files (x86)\Microsoft\EdgeUpdate" %%F in (CopilotUpdate.exe) do if exist %%~fF del /F /Q %%~fF ) >nul 2>&1
::( for /R "C:\Program Files (x86)\Microsoft\Edge\Application" %%F in (mscopilot.exe) do if exist %%~fF del /F /Q %%~fF ) >nul 2>&1
::( for /R "C:\Program Files (x86)\Microsoft\EdgeCore" %%F in (mscopilot.exe) do if exist %%~fF del /F /Q %%~fF ) >nul 2>&1
::( for /R "C:\Program Files (x86)\Microsoft\EdgeWebView\Application" %%F in (mscopilot.exe) do if exist %%~fF del /F /Q %%~fF ) >nul 2>&1
"C:\Program Files (x86)\Microsoft\Copilot\Application\*\Installer\copilot_setup.exe" --uninstall --mscopilot --channel=stable --system-level --force-uninstall >nul 2>&1
rd /s /q "C:\Program Files (x86)\Microsoft\Copilot" >nul 2>&1
reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Copilot" /f >nul 2>&1
del /f /q "%ProgramData%\Microsoft\Windows\Start Menu\Programs\*Copilot*" >nul 2>&1
del /f /q "%AppData%\Microsoft\Windows\Start Menu\Programs\*Copilot*" >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v Copilot /f >nul 2>&1
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v Copilot /f >nul 2>&1
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f >nul 2>&1
reg delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths /va /f >nul 2>&1
reg delete HKCU\Software\Microsoft\Direct3D\MostRecentApplication /va /f >nul 2>&1
reg delete HKLM\SOFTWARE\Microsoft\Direct3D\MostRecentApplication /va /f >nul 2>&1
reg delete HKCU\Software\Microsoft\MediaPlayer\Player\RecentFileList /va /f >nul 2>&1
reg delete HKCU\Software\Microsoft\MediaPlayer\Player\RecentURLList /va /f >nul 2>&1
reg delete HKLM\SOFTWARE\Microsoft\MediaPlayer\Player\RecentFileList /va /f >nul 2>&1
reg delete HKLM\SOFTWARE\Microsoft\MediaPlayer\Player\RecentURLList /va /f >nul 2>&1
reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs /va /f >nul 2>&1
reg delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs /va /f >nul 2>&1
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSaveMRU /va /f >nul 2>&1
reg delete HKCU\Software\Microsoft\Search Assistant\ACMru /va /f >nul 2>&1
reg delete HKCU\Software\Adobe\MediaBrowser\MRU /va /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Applets\Paint\Recent File List" /va /f >nul 2>&1
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedMRU /va /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Paint\Recent File List" /va /f >nul 2>&1
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Wordpad\Recent File List" /va /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Map Network Drive MRU" /va /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Map Network Drive MRU" /va /f >nul 2>&1
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedPidlMRU /va /f >nul 2>&1
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedPidlMRULegacy /va /f >nul 2>&1
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit /va /f >nul 2>&1
reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Regedit /va /f >nul 2>&1
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit\Favorites /va /f >nul 2>&1
reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Regedit\Favorites /va /f >nul 2>&1
reg delete HKLM\SOFTWARE\Microsoft\Wbem\WDM /va /f >nul 2>&1
reg delete HKLM\SOFTWARE\Microsoft\Wbem\WDM\DREDGE /va /f >nul 2>&1
reg delete HKLM\SOFTWARE\Microsoft\FTH\State /va /f >nul 2>&1
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\WordWheelQuery /va /f >nul 2>&1
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\SearchHistory /va /f >nul 2>&1
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSavePidlMRU /va /f >nul 2>&1
reg delete "HKCU\Software\Gabest\Media Player Classic\Recent File List" /va /f >nul 2>&1
reg delete "HKCU\SOFTWARE\Microsoft\Internet Explorer\TypedURLs" /va /f >nul 2>&1
reg delete "HKCU\SOFTWARE\Microsoft\Internet Explorer\TypedURLsTime" /va /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\ShellNoRoam\MUICache" /f >nul 2>&1
reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache" /f >nul 2>&1
reg delete "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "PUUActive" /f >NUL 2>&1
reg delete "HKU\.DEFAULT\Software\Classes\Local Settings\MuiCache" /f >NUL 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\StructuredQuery" /v "SchemaChangedLast" /f >NUL 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Superfetch\PfAp" /f >NUL 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Superfetch" /v "LastResPriGenTime" /f >NUL 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Superfetch" /v "StartedComponents" /f >NUL 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Superfetch" /v "PfIuHistory" /f >NUL 2>&1
rundll32.exe setupapi.dll,InstallHinfSection DefaultInstall 132 %windir%\inf\input.inf >nul 2>&1
rundll32.exe advapi32.dll,ProcessIdleTasks >nul 2>&1
rundll32.exe pnpclean.dll,RunDLL_PnpClean /DRIVERS /MAXCLEAN >nul 2>&1
rundll32.exe fthsvc.dll,FthSysprepSpecialize >nul 2>&1
rundll32.exe "%PROGRAMFILES%\NVIDIA Corporation\Installer2\InstallerCore\NVI2.DLL",UninstallPackage NvTelemetryContainer >nul 2>&1
rundll32.exe "%PROGRAMFILES%\NVIDIA Corporation\Installer2\InstallerCore\NVI2.DLL",UninstallPackage NvTelemetry >nul 2>&1
nvidia-smi.exe -e 0 >nul 2>&1
nvidia-smi.exe -acp 0 >nul 2>&1
c:\windows\system32\rundll32.exe AppxDeploymentClient.dll,AppxCleanupOrphanPackages >nul 2>&1
mkdir "%USERPROFILE%\Desktop" "%USERPROFILE%\Documents" "%USERPROFILE%\Pictures" "%USERPROFILE%\Music" "%USERPROFILE%\Videos" "%USERPROFILE%\Favorites" "%USERPROFILE%\Downloads" "%USERPROFILE%\Pictures\Screenshots" 2>nul
for /f "delims=" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services" /f "GoogleUpdater" /k /s') do reg add "%%i" /v Start /t REG_DWORD /d 3 /f >NUL 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-ChildItem 'HKCU:\Software\Classes\Local Settings\MrtCache' -Recurse -EA 0 | %%{ $k=$_; $k.GetValueNames() | ?{ $_ -like '*ShellNewDisplayName_Bmp*' } | %%{ if($k.GetValue($_) -ne ''){Set-ItemProperty $k.PSPath $_ ''} } }"
for /d %%F in ("C:\Windows\System32\config\systemprofile\AppData\Local\tw-*.tmp") do rd /s /q "%%F" >NUL 2>&1
::for /F "tokens=*" %%i in ('wevtutil.exe el') do wevtutil.exe cl "%%i" >nul 2>&1
if exist %SystemDrive%\hiberfil.sys (takeown /f %SystemDrive%\hiberfil.sys /d y >nul 2>&1 & icacls %SystemDrive%\hiberfil.sys /grant Administrators:F >nul 2>&1 & attrib -s -h %SystemDrive%\hiberfil.sys >nul 2>&1 & del /f /q %SystemDrive%\hiberfil.sys >nul 2>&1)
icacls C:\Windows\System32\SleepStudy /remove:g SYSTEM >nul 2>&1
icacls C:\Windows\System32\SleepStudy /remove:g Administrators >nul 2>&1
takeown /f C:\$WinREAgent /r /d y >nul 2>&1
icacls C:\$WinREAgent /grant %username%:F /t /q >nul 2>&1
rd /s /q C:\$WinREAgent >nul 2>&1
"C:\Program Files (x86)\ViVeTool\ViVeTool.exe" /disable /id:45624564,46892085,53397005,37926450,56517033,47205210,44571814,44573982,57703775,52580392,50902630,59765208,58989070 >nul 2>&1
"C:\Program Files (x86)\ViVeTool\ViVeTool.exe" /enable /id:49453572,42651849,48433719,55369237,60786016,46719714,60716524,61391826 >nul 2>&1
"C:\Program Files (x86)\ViVeTool\ViVeTool.exe" /reset /id:55182474,56625728 >nul 2>&1
RD /S /Q %windir%\System32\Tasks\Microsoft\Windows\WindowsAI >nul 2>&1
gpupdate /force /wait:0 >nul 2>&1
assoc folder=Folder
ftype Folder=explorer.exe "%%1"
for /f "tokens=2" %%S in ('whoami /user ^| findstr /r "S-1-5-21"') do (reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\SystemProtectedUserData\%%S\AnyoneRead\LockScreen" /v "HideLogonBackgroundImage" /t REG_DWORD /d 1 /f >nul 2>&1 & reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\SystemProtectedUserData\%%S\AnyoneRead\Logon" /v "ShowEmail" /t REG_DWORD /d 0 /f >nul 2>&1)
for /f "tokens=*" %%G in ('reg query "HKCU\SOFTWARE\Microsoft\EdgeUpdate\ClientState" /s /v metricsid 2^>nul ^| findstr /i "HKEY"') do reg add "%%G" /v metricsid /t REG_SZ /d "" /f >nul 2>&1 & reg add "%%G" /v metricsid_installdate /t REG_SZ /d "" /f >nul 2>&1 & reg add "%%G" /v metricsid_enableddate /t REG_SZ /d "" /f >nul 2>&1 & reg add "%%G" /v metricsid_hash /t REG_SZ /d "" /f >nul 2>&1
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "$p=[Environment]::GetFolderPath('LocalApplicationData')+'\Microsoft\Edge\User Data\Local State';$j=Get-Content -LiteralPath $p -Raw|ConvertFrom-Json;$j.user_experience_metrics.client_id2=[guid]::NewGuid().ToString();$j.user_experience_metrics.machine_id=(Get-Random -Min 1000000 -Max 9999999);$j|ConvertTo-Json -Depth 50|Set-Content -LiteralPath $p -Encoding UTF8" >nul 2>&1
::gdid, lid
for /f "tokens=2" %%S in ('whoami /user ^| findstr /r "S-1-5-21"') do (for /f "tokens=*" %%G in ('reg query "HKU\%%S\SOFTWARE\Microsoft\IdentityCRL\Immersive\production\Token" 2^>nul') do reg delete "%%G" /f >nul 2>&1 & reg delete "HKU\%%S\SOFTWARE\Microsoft\IdentityCRL\Immersive\production\Property" /f >nul 2>&1 & for /f "tokens=*" %%G in ('reg query "HKU\%%S\SOFTWARE\WOW6432Node\Microsoft\IdentityCRL\Immersive\production\Token" 2^>nul') do reg delete "%%G" /f >nul 2>&1 & for /f "tokens=*" %%G in ('reg query "HKU\.DEFAULT\SOFTWARE\Microsoft\IdentityCRL\Immersive\production\Token" 2^>nul') do reg delete "%%G" /f >nul 2>&1 & reg delete "HKU\.DEFAULT\SOFTWARE\Microsoft\IdentityCRL\Immersive\production\Property" /f >nul 2>&1 & for /f "tokens=*" %%G in ('reg query "HKU\S-1-5-18\SOFTWARE\Microsoft\IdentityCRL\Immersive\production\Token" 2^>nul') do reg delete "%%G" /f >nul 2>&1 & reg delete "HKU\S-1-5-18\SOFTWARE\Microsoft\IdentityCRL\Immersive\production\Property" /f >nul 2>&1 & for /f "tokens=*" %%G in ('reg query "HKU\S-1-5-19\SOFTWARE\Microsoft\IdentityCRL\Immersive\production\Token" 2^>nul') do reg delete "%%G" /f >nul 2>&1 & reg delete "HKU\S-1-5-19\SOFTWARE\Microsoft\IdentityCRL\Immersive\production\Property" /f >nul 2>&1 & for /f "tokens=*" %%G in ('reg query "HKU\S-1-5-20\SOFTWARE\Microsoft\IdentityCRL\Immersive\production\Token" 2^>nul') do reg delete "%%G" /f >nul 2>&1 & reg delete "HKU\S-1-5-20\SOFTWARE\Microsoft\IdentityCRL\Immersive\production\Property" /f >nul 2>&1 & reg delete "HKU\.DEFAULT\SOFTWARE\Microsoft\IdentityCRL\DeviceIdentities" /f >nul 2>&1 & reg delete "HKU\S-1-5-18\SOFTWARE\Microsoft\IdentityCRL\DeviceIdentities" /f >nul 2>&1 & reg delete "HKU\S-1-5-19\SOFTWARE\Microsoft\IdentityCRL\DeviceIdentities" /f >nul 2>&1 & reg delete "HKU\S-1-5-20\SOFTWARE\Microsoft\IdentityCRL\DeviceIdentities" /f >nul 2>&1 & reg delete "HKU\%%S\SOFTWARE\Microsoft\IdentityCRL\DeviceIdentities" /f >nul 2>&1 & reg delete "HKLM\SOFTWARE\Microsoft\IdentityStore\Cache" /f >nul 2>&1 & reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\IdentityStore\Cache" /f >nul 2>&1 & reg delete "HKLM\SOFTWARE\Microsoft\IdentityStore\LogonCache" /f >nul 2>&1 & reg delete "HKLM\SOFTWARE\Microsoft\IdentityCRL\NegativeCache" /f >nul 2>&1)
cmdkey /delete:MicrosoftAccount:target=SSO_POP_Device >nul 2>&1
cmdkey /delete:WindowsLive:target=virtualapp/didlogical >nul 2>&1
::taskkill /f /t /im ctfmon.exe>nul 2>&1 & timeout /t 1>nul & start "" "%SystemRoot%\System32\ctfmon.exe" /n
taskkill /f /t /im AppActions.exe >nul 2>&1
taskkill /f /t /im fireshot-chrome-plugin.exe >nul 2>&1
taskkill /f /t /im TiWorker.exe >nul 2>&1
taskkill /f /t /im VSSVC.exe >nul 2>&1
taskkill /f /t /im rundll32.exe >nul 2>&1
taskkill /f /t /im gpupdate.exe >nul 2>&1
taskkill /f /t /im MoUsoCoreWorker.exe >nul 2>&1
taskkill /f /t /im RuntimeBroker.exe >nul 2>&1
taskkill /f /t /im UserOOBEBroker.exe >nul 2>&1
taskkill /f /t /im wevtutil.exe >nul 2>&1
taskkill /f /t /im WMIADAP.exe >nul 2>&1
taskkill /f /t /im ApplicationFrameHost.exe >NUL 2>&1
taskkill /f /t /im findstr.exe >nul 2>&1
taskkill /f /t /im CompPkgSrv.exe >nul 2>&1
taskkill /f /t /im Dism.exe >nul 2>&1
taskkill /f /t /im DismHost.exe >nul 2>&1
taskkill /f /t /im SearchProtocolHost.exe >nul 2>&1
taskkill /f /t /im SearchIndexer.exe >nul 2>&1
taskkill /f /t /im SearchFilterHost.exe >nul 2>&1
taskkill /f /t /im SearchApp.exe >nul 2>&1
taskkill /f /t /im winget.exe >nul 2>&1
taskkill /f /t /im node.exe >nul 2>&1
taskkill /f /t /im WMIC.exe >nul 2>&1
taskkill /f /t /im upfc.exe >nul 2>&1
taskkill /f /t /im vds.exe >nul 2>&1
taskkill /f /t /im sc.exe >nul 2>&1
taskkill /f /t /im bcdedit.exe >nul 2>&1
taskkill /f /t /im bitsadmin.exe >nul 2>&1
taskkill /f /t /im Taskmgr.exe >nul 2>&1
taskkill /f /t /im fsutil.exe >nul 2>&1
taskkill /f /t /im lodctr.exe >nul 2>&1
taskkill /f /t /im provtool.exe >nul 2>&1
taskkill /f /t /im WUDFHost.exe >nul 2>&1
taskkill /f /t /im TrustedInstaller.exe >nul 2>&1
taskkill /f /t /im powershell.exe >nul 2>&1
taskkill /f /t /im PnPUtil.exe >nul 2>&1
taskkill /f /t /im mmc.exe >nul 2>&1
taskkill /f /t /im taskhostw.exe >nul 2>&1
taskkill /f /t /im OpenConsole.exe >nul 2>&1
taskkill /f /t /im WindowsTerminal.exe >nul 2>&1
taskkill /f /t /im cmd.exe >nul 2>&1
taskkill /f /t /im conhost.exe >nul 2>&1
