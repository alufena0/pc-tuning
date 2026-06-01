for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services"') do (echo %%i | findstr /i "Xbl Xbox" >nul || reg add "%%i" /v SvcHostSplitDisable /t REG_DWORD /d 1 /f >nul 2>&1)
exit