pnputil /restart-device "HID\VID_1532&PID_008A&MI_02\8&1C8C0C5F&0&0000" & rem Razer Keyboard (Interface)
pnputil /restart-device "HID\VID_1B1C&PID_1B15&MI_00&COL01\8&12AB0AA0&0&0000" & rem Corsair Keyboard
pnputil /restart-device "HID\VID_0D8C&PID_000C&MI_03\8&E0E3017&0&0000" & rem USB Audio (HID Control)
pnputil /restart-device "HID\VID_1532&PID_008A&MI_00&COL03\9&2DBD5052&0&0000" & rem Razer Mouse (Interface)
pnputil /restart-device "HID\VID_1532&PID_008A&MI_01&COL02\8&4C8801A&0&0001" & rem Razer Mouse (Interface)
pnputil /restart-device "HID\VID_1B1C&PID_1B15&MI_00&COL02\8&12AB0AA0&0&0001" & rem Corsair Keyboard (Multimedia)
pnputil /restart-device "HID\VID_1532&PID_008A&MI_01&COL04\8&4C8801A&0&0003" & rem Razer Mouse (Interface)
pnputil /restart-device "HID\VID_1532&PID_008A&MI_01&COL05\8&4C8801A&0&0004" & rem Razer Mouse (Interface)
pnputil /restart-device "HID\VID_1532&PID_008A&MI_01&COL03\8&4C8801A&0&0002" & rem Razer Mouse (Interface)
pnputil /restart-device "HID\VID_1B1C&PID_1B15&MI_00&COL03\8&12AB0AA0&0&0002" & rem Corsair Keyboard (Interface)
pnputil /restart-device "HID\VID_1B1C&PID_1B15&MI_00&COL04\8&12AB0AA0&0&0003" & rem Corsair Keyboard (Interface)
pnputil /restart-device "HID\VID_1B1C&PID_1B15&MI_01\8&36824862&0&0000" & rem Corsair Keyboard (Interface)
pnputil /restart-device "HID\VID_1532&PID_008A&MI_00\8&289FBDDC&0&0000" & rem Razer Mouse (Viper Mini)
pnputil /restart-device "HID\VID_1532&PID_008A&MI_01&COL01\8&4C8801A&0&0000" & rem Razer Mouse (Viper Mini)
pnputil /restart-device "USB\VID_0D8C&PID_000C&MI_00\7&995C93B&0&0000" & rem USB Audio (Headset)
pnputil /restart-device "USB\VID_32E6&PID_9221&MI_00\7&2D495844&0&0000" & rem Web Camera (Video)
pnputil /restart-device "USB\VID_32E6&PID_9221&MI_02\7&2D495844&0&0002" & rem Web Camera (UVC control)
pnputil /restart-device "USB\VID_32E6&PID_9221\2024120914230143508" & rem Web Camera (Base/Composite)
pnputil /restart-device "USB\VID_1532&PID_008A&MI_01\7&36E435ED&0&0001" & rem Razer Mouse (USB Interface)
pnputil /restart-device "USB\VID_1532&PID_008A&MI_02\7&36E435ED&0&0002" & rem Razer Mouse (USB Interface)
pnputil /restart-device "USB\VID_0D8C&PID_000C\6&C1A2E2F&0&1" & rem USB Audio (Composite)
pnputil /restart-device "USB\VID_1532&PID_008A\6&C1A2E2F&0&2" & rem Razer Mouse (Composite)
pnputil /restart-device "USB\VID_1B1C&PID_1B15\15027002AEA7A44454E1DF3EF5001940" & rem Corsair Keyboard (Base)
pnputil /restart-device "USB\VID_0D8C&PID_000C&MI_03\7&995C93B&0&0003" & rem USB Audio (Interface)
pnputil /restart-device "USB\VID_1532&PID_008A&MI_00\7&36E435ED&0&0000" & rem Razer Mouse (USB Interface)
pnputil /restart-device "USB\VID_1B1C&PID_1B15&MI_00\7&30365890&0&0000" & rem Corsair Keyboard (USB Interface)
pnputil /restart-device "USB\VID_1B1C&PID_1B15&MI_01\7&30365890&0&0001" & rem Corsair Keyboard (USB Interface)
pnputil /restart-device "USB\ROOT_HUB30\5&2C35141&0&0" & rem USB Root Hub
pnputil /restart-device "USB\ROOT_HUB30\5&2F66366D&0&0" & rem USB Root Hub
pnputil /restart-device "USB\ROOT_HUB30\5&4087D53&0&0" & rem USB Root Hub
pnputil /restart-device "USB\VID_045E&PID_028E\20492BE" & rem Xbox 360 Controller (Joystick)
pnputil /restart-device "PCI\VEN_10EC&DEV_8168&SUBSYS_86771043&REV_15\6&21b587d9&0&0038020B" & rem Realtek NIC
::timeout /t 2
::pnputil /restart-device "PCI\VEN_10DE&DEV_2182&SUBSYS_3FBE1458&REV_A1\4&1FC990D7&0&0019" & rem GPU
::timeout /t 5
::taskkill /f /t /im flux.exe
::start "" "%USERPROFILE%\AppData\Local\FluxSoftware\Flux\flux.exe" -noshow
exit