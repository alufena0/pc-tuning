@echo off
powershell -NoProfile -Command "$freq=800; $dur=300; $sr=44100; $samples=[math]::Round($sr*$dur/1000); $ms=New-Object System.IO.MemoryStream; $bw=New-Object System.IO.BinaryWriter($ms); $bw.Write([byte[]](0x52,0x49,0x46,0x46)); $bw.Write([int32](36+$samples*2)); $bw.Write([byte[]](0x57,0x41,0x56,0x45,0x66,0x6D,0x74,0x20)); $bw.Write([int32]16); $bw.Write([int16]1); $bw.Write([int16]1); $bw.Write([int32]$sr); $bw.Write([int32]($sr*2)); $bw.Write([int16]2); $bw.Write([int16]16); $bw.Write([byte[]](0x64,0x61,0x74,0x61)); $bw.Write([int32]($samples*2)); for($i=0;$i -lt $samples;$i++){$v=[math]::Sin(2*[math]::PI*$freq*$i/$sr)*32760; $bw.Write([int16]$v)}; $bw.Flush(); $ms.Position=0; (New-Object System.Media.SoundPlayer($ms)).PlaySync()"
:: used with the windhawk mod "taskbar empty space clicks" clicking empty taskbar space triggers this script
sc stop ClickToRunSvc >NUL 2>&1
sc stop EpicGamesUpdater >NUL 2>&1
sc stop NVDisplay.ContainerLocalSystem >NUL 2>&1
sc config NVDisplay.ContainerLocalSystem start= disabled >NUL 2>&1
sc stop wlidsvc >NUL 2>&1
sc stop DoSvc >NUL 2>&1
sc stop wuauserv >NUL 2>&1
sc stop EABackgroundService >NUL 2>&1
sc stop BITS >NUL 2>&1
sc stop TeamViewer >NUL 2>&1
sc stop hitmanpro37 >NUL 2>&1
sc stop "Steam Client Service" >NUL 2>&1
taskkill /F /T /IM ScreenClippingHost.exe >nul 2>&1
taskkill /F /T /IM fireshot-chrome-plugin.exe >nul 2>&1
taskkill /F /T /IM CompPkgSrv.exe >nul 2>&1
taskkill /F /T /IM RuntimeBroker.exe >nul 2>&1
taskkill /F /T /IM OfficeClickToRun.exe >nul 2>&1
taskkill /F /T /IM TrustedInstaller.exe >nul 2>&1
taskkill /F /T /IM ShellExperienceHost.exe >nul 2>&1
taskkill /F /T /IM WmiPrvSE.exe >nul 2>&1
taskkill /F /T /IM backgroundTaskHost.exe >nul 2>&1
taskkill /F /T /IM taskhostw.exe >nul 2>&1
taskkill /F /T /IM ApplicationFrameHost.exe >nul 2>&1
taskkill /F /T /IM StartMenu.exe >nul 2>&1
taskkill /F /T /IM TiWorker.exe >nul 2>&1
taskkill /F /T /IM WindowsPackageManagerServer.exe >nul 2>&1
taskkill /F /T /IM EABackgroundService.exe >nul 2>&1
taskkill /F /T /IM SppExtComObj.exe >nul 2>&1
taskkill /F /T /IM msiexec.exe >nul 2>&1
taskkill /F /T /IM SelectiveToolApp.exe >nul 2>&1
taskkill /F /T /IM WMIADAP.exe >nul 2>&1
taskkill /F /T /IM VSSVC.exe >nul 2>&1
taskkill /F /T /IM adb.exe >nul 2>&1
taskkill /F /T /IM NVDisplay.Container.exe >nul 2>&1
taskkill /F /T /IM rundll32.exe >nul 2>&1
taskkill /F /T /IM wimserv.exe >nul 2>&1
taskkill /F /T /IM mega-desktop-app-gfxworker.exe >nul 2>&1
taskkill /F /T /IM TeamViewer_Service.exe >NUL 2>&1
taskkill /F /T /IM jcef_helper.exe >NUL 2>&1
taskkill /F /T /IM perfmon.exe >NUL 2>&1
taskkill /F /T /IM node.exe >NUL 2>&1
taskkill /F /T /IM msedge.exe >NUL 2>&1
taskkill /F /T /IM SystemSettingsAdminFlows.exe >NUL 2>&1
taskkill /F /T /IM EpicOnlineServicesInstaller.exe >NUL 2>&1
taskkill /F /T /IM EpicGamesUpdater.exe >NUL 2>&1
taskkill /F /T /IM EpicGamesLauncher.exe >NUL 2>&1
taskkill /F /T /IM EpicOnlineServicesUIHelper.exe >NUL 2>&1
taskkill /F /T /IM StoreDesktopExtension.exe >NUL 2>&1
taskkill /F /T /IM Agent.exe >NUL 2>&1
taskkill /F /T /IM conhost.exe >NUL 2>&1
powershell -NoProfile -Command "Set-Clipboard -Value $null" >NUL 2>&1
rd /s /q C:\Windows\Prefetch >nul 2>&1
taskkill /F /FI "status eq not responding" >nul 2>&1
netsh interface ip delete arpcache >nul 2>&1
ipconfig /flushdns >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\Users\Administrator\Documents\Set Process Priority.ps1"
powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\Users\Administrator\Documents\Set Memory Leak Trim.ps1"
"C:\Program Files (x86)\WinMemoryCleaner\WinMemoryCleaner.exe" /StandbyList
start /B "" "C:\Users\Administrator\Documents\Kill Razer.bat"
exit
