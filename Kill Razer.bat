sc config "Razer Chroma SDK Diagnostic Service" start= demand
sc stop "Razer Chroma SDK Diagnostic Service"
sc config "Razer Chroma SDK Server" start= demand
sc stop "Razer Chroma SDK Server"
sc config "Razer Chroma SDK Service" start= demand
sc stop "Razer Chroma SDK Service"
sc config "Razer Chroma Stream Server" start= demand
sc stop "Razer Chroma Stream Server"
sc config "Razer Elevation Service" start= demand
sc stop "Razer Elevation Service"
sc config "Razer Game Manager Service 3" start= demand
sc stop "Razer Game Manager Service 3"
sc config "Razer Synapse Service" start= demand
sc stop "Razer Synapse Service"
sc config HapticService start= demand
sc stop HapticService
taskkill /f /t /im "RazerAppEngine.exe"
taskkill /f /t /im "Razer Central.exe"
taskkill /f /t /im "Razer Synapse 3.exe"
taskkill /f /t /im "Razer Synapse Service Process.exe"
taskkill /f /t /im "Razer Synapse Service.exe"
taskkill /f /t /im "RazerCentralService.exe"
taskkill /f /t /im "GameManagerService.exe"
taskkill /f /t /im "razerwdl.exe"
taskkill /f /t /im "razer_elevation_service.exe"
taskkill /f /t /im "RzAppManager.exe"
taskkill /f /t /im "RzBTLEManager.exe"
taskkill /f /t /im "RzChromaConnectManager.exe"
taskkill /f /t /im "RzChromaConnectServer.exe"
taskkill /f /t /im "RzChromaStreamServer.exe"
taskkill /f /t /im "RzDeviceManager.exe"
taskkill /f /t /im "RzDeviceManagerEx.exe"
taskkill /f /t /im "RzDiagnosticService.exe"
taskkill /f /t /im "RzEngineMon.exe"
taskkill /f /t /im "RzIoTDeviceManager.exe"
taskkill /f /t /im "RzSDKServer.exe"
taskkill /f /t /im "RzSDKService.exe"
taskkill /f /t /im "RzSmartlightingDeviceManager.exe"
taskkill /f /t /im "RzWDLDeviceManager.exe"
taskkill /f /t /im "CortexLauncherService.exe"
taskkill /f /t /im "RazerCortex.exe"
taskkill /f /t /im "RazerCortex.Shell.exe"
taskkill /f /fi "imagename eq Rz*.exe"
taskkill /f /fi "imagename eq Razer*.exe"
taskkill /f /fi "msedgewebview2.exe"
taskkill /f /t /im "conhost.exe"
taskkill /f /t /im "TrustedInstaller.exe"
::taskkill /f /t /im "steamwebhelper.exe"
::taskkill /f /t /im "steamwebhelper.exe"
::taskkill /f /t /im "steamwebhelper.exe"
exit