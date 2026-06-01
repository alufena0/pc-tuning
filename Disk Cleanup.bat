cleanmgr /d C: /sagerun:6553
cleanmgr /d D: /sagerun:6553
cleanmgr /d E: /sagerun:6553
cleanmgr /d F: /sagerun:6553
cleanmgr /d G: /sagerun:6553
taskkill /f /t /im TrustedInstaller.exe >NUL 2>&1
taskkill /f /t /im TiWorker.exe >NUL 2>&1
exit