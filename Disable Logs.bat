echo Y | auditpol /clear
Auditpol /Remove /AllUsers
Auditpol /Set /Category:* /Success:Disable /Failure:Disable
Auditpol /set /subcategory:"Process Termination" /success:disable /failure:disable
Auditpol /set /subcategory:"RPC Events" /success:disable /failure:disable
Auditpol /set /subcategory:"Filtering Platform Connection" /success:disable /failure:disable
Auditpol /set /subcategory:"DPAPI Activity" /success:disable /failure:disable
Auditpol /set /subcategory:"IPsec Driver" /success:disable /failure:disable
Auditpol /set /subcategory:"Other System Events" /success:disable /failure:disable
Auditpol /set /subcategory:"Security State Change" /success:disable /failure:disable
Auditpol /set /subcategory:"Security System Extension" /success:disable /failure:disable
Auditpol /set /subcategory:"System Integrity" /success:disable /failure:disable
auditpol /set /subcategory:"Special Logon" /success:disable
auditpol /set /subcategory:"Audit Policy Change" /success:disable
auditpol /set /subcategory:"User Account Management" /success:disable
wevtutil.exe set-log "Microsoft-Windows-SleepStudy/Diagnostic" /e:false
wevtutil.exe set-log "Microsoft-Windows-Kernel-Processor-Power/Diagnostic" /e:false
wevtutil.exe set-log "Microsoft-Windows-UserModePowerService/Diagnostic" /e:false
wevtutil sl Microsoft-Windows-Application-Experience/Program-Telemetry /e:false
wevtutil sl Microsoft-Windows-Application-Experience/Steps-Recorder /e:false
wevtutil sl Microsoft-Windows-ApplicationExperienceInfrastructure/Process-Efficiency-Manager /e:false
wevtutil.exe cl Application
wevtutil.exe cl System
wevtutil.exe cl Security
wevtutil.exe cl Setup
wevtutil.exe cl "Windows PowerShell"
exit