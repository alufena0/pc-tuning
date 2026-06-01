if "%~1" neq "running" (start "" /b cmd /c "%~f0" running & exit /b) else (cd /d "%~dp0")
netcfg -d
netsh winsock reset
netsh int ip reset
netsh int ipv4 reset
netsh int ipv6 reset
netsh int tcp reset
netsh int tcp reset all
netsh int 6to4 reset all
netsh int httpstunnel reset all
netsh int isatap reset all
netsh int teredo reset all
netsh int portproxy reset all
netsh winhttp reset proxy
netsh advfirewall reset
netsh branchcache reset
route -f
ipconfig /flushdns
ipconfig /release
ipconfig /renew
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\FirewallRules" /va /f
for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"') do reg delete "%%i" /f
exit