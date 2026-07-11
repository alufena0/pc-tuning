@echo off
SETLOCAL

set "DEST=%ProgramFiles%\NVIDIA Corporation\Control Panel Client"

echo Removing registry entries...
reg delete "HKCR\DesktopBackground\Shell\NVIDIAControlPanel" /f >nul 2>&1
reg delete "HKCR\Directory\Background\shell\NVIDIAControlPanel" /f >nul 2>&1
reg delete "HKCR\Directory\Background\shell\NVCPLWin32" /f >nul 2>&1
reg delete "HKCR\Directory\Background\shell\Item0" /f >nul 2>&1
reg delete "HKCU\Software\NVIDIA Corporation\NVControlPanel2" /f >nul 2>&1
reg delete "HKCU\Software\NVIDIA Corporation\Global\NvCplApi" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "%DEST%\nvcplui.exe" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "C:\NVIDIA_ControlPanel_Win32\nvcplui.exe" /f >nul 2>&1

echo Removing files...
rmdir /s /q "%DEST%" >nul 2>&1
rmdir /s /q "C:\NVIDIA_ControlPanel_Win32" >nul 2>&1

echo Removing shortcuts...
del /f /q "%ProgramData%\Microsoft\Windows\Start Menu\Programs\NVIDIA Control Panel.lnk" >nul 2>&1
del /f /q "%USERPROFILE%\Desktop\NVIDIA Control Panel (Win32).lnk" >nul 2>&1

echo Clearing icon cache...
taskkill /f /im explorer.exe >nul 2>&1
del /f /q "%localappdata%\IconCache.db" >nul 2>&1
del /f /q "%localappdata%\Microsoft\Windows\Explorer\iconcache*" >nul 2>&1
start explorer.exe

echo Done.
pause
