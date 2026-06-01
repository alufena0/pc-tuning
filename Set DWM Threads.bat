@echo off
timeout /t 2 /nobreak >nul
"C:\Users\Administrator\Documents\RunAsTI.bat" powershell -NonInteractive -WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\Users\Administrator\Documents\Set DWM Threads.ps1"