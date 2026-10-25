taskkill /f /t /im steam.exe
start "" /wait "C:\Program Files (x86)\Steam\bin\steamservice.exe" /repair
sc config "Steam Client Service" start= demand
start "" "C:\Program Files (x86)\Steam\steam.exe" -no-dwrite -nointro -nobigpicture -nofasthtml -nocrashmonitor -no-shared-textures -disablehighdpi -cef-single-process -cef-in-process-gpu -single_core -disable-winh264 -vrdisable -cef-disable-breakpad -cef-disable-d3d11 -cef-disable-gpu-compositing -cef-disable-gpu -cef-disable-js-logging -cef-disable-occlusion -cef-disable-renderer-restart -noconsole -oldtraymenu -showallbetas
pause
net stop "Steam Client Service"
sc config "Steam Client Service" start= disabled
exit
