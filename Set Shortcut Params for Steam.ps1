# Set Steam Shortcut Flags.ps1

# Path to Steam executable
$steamPath = "C:\Program Files (x86)\Steam\Steam.exe"

# Path to the shortcut to be created or updated
$shortcutPath = "$env:USERPROFILE\Desktop\Steam.lnk"

# Steam launch flags
$steamFlags = @(
    "-no-dwrite",
    "-nointro",
    "-nobigpicture",
    "-nofasthtml",
    "-nocrashmonitor",
    "-no-shared-textures",
    "-disablehighdpi",
    "-cef-single-process",
    "-cef-in-process-gpu",
    "-single_core",
    "-disable-winh264",
    "-vrdisable",
    "-cef-disable-breakpad",
    "-cef-disable-d3d11",
    "-cef-disable-gpu-compositing",
    "-cef-disable-gpu",
    "-cef-disable-js-logging",
    "-cef-disable-occlusion",
    "-cef-disable-renderer-restart",
    "-noconsole",
    "-oldtraymenu",
    "-showallbetas"
)

# Convert array to a single argument string
$argValue = $steamFlags -join " "

# Create or update the .lnk shortcut via COM (clean TargetPath + separate Arguments)
$wsh = New-Object -ComObject WScript.Shell
$sc = $wsh.CreateShortcut($shortcutPath)
$sc.TargetPath = $steamPath
$sc.Arguments = $argValue
$sc.WorkingDirectory = Split-Path $steamPath
$sc.IconLocation = "$steamPath, 0"
$sc.Save()

Write-Host "Shortcut created or updated:" $shortcutPath
Write-Host "If Steam is pinned to the taskbar, unpin the old one, launch this shortcut, then pin it again."
Write-Host "Close all steam.exe processes before launching it."
