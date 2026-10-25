# create-egl-shortcut.ps1
$eglPath = "C:\Program Files\Epic Games\Launcher\Portal\Binaries\Win64\EpicGamesLauncher.exe"
$launcherDir = "$env:LOCALAPPDATA\EGLHardened"
$launcherPath = "$launcherDir\egl-launcher.vbs"
$shortcutPath = "$env:USERPROFILE\Desktop\Epic Games Launcher.lnk"

New-Item -ItemType Directory -Force -Path $launcherDir | Out-Null

# Remove read-only first, so the script can be re-run to update the shortcut
if (Test-Path $shortcutPath) {
  Set-ItemProperty -Path $shortcutPath -Name IsReadOnly -Value $false
}

$vbsContent = @"
Set WshShell = CreateObject("WScript.Shell")
WshShell.Run "cmd.exe /c sc config EpicGamesUpdater start= auto && sc start EpicGamesUpdater", 0, True
WshShell.Run "cmd.exe /c sc config EpicOnlineServices start= auto && sc start EpicOnlineServices", 0, True
eglPath = "$($eglPath -replace '\\', '\\')"
WshShell.Run """" & eglPath & """", 1, False
"@

$vbsContent | Out-File -FilePath $launcherPath -Encoding ASCII -Force

$wsh = New-Object -ComObject WScript.Shell
$sc = $wsh.CreateShortcut($shortcutPath)
$sc.TargetPath = $launcherPath
$sc.WorkingDirectory = $launcherDir
$sc.IconLocation = "$eglPath, 0"
$sc.Description = "Epic Games Launcher - starts updater + EOS services first"
$sc.Save()

Set-ItemProperty -Path $shortcutPath -Name IsReadOnly -Value $true

Write-Host "Shortcut created (read-only):" $shortcutPath
