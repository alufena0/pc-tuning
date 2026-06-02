::https://www.elevenforum.com/t/how-to-increase-the-notification-limit-in-action-center-beyond-20.28574/
<# : batch script
@echo off
powershell -nop ^
"$arg1 = '%1'; ^
$maxCount = 20; ^
if ($arg1 -ne '' -and [int]::TryParse($arg1, [ref]$maxCount)) { ^
    $maxCount = [int]$arg1 ^
} ^
if ($maxCount -lt 1) { ^
    Write-Output 'Please specify a positive number for toast:maxCount.'; ^
    exit 0 ^
} ^
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) { ^
    Start-Process 'cmd' -arg1List ('/k %~dpnx0 ' + $maxCount) -Verb RunAs ^
} ^
else { ^
    Invoke-Expression (('$maxCount = ' + $maxCount) + [System.IO.File]::ReadAllText('%~f0')) ^
}"
goto :eof
#>

Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

if ((Get-PackageProvider -ListAvailable -Name 'NuGet' -ErrorAction SilentlyContinue) -eq $null) {
    $null = Install-PackageProvider -Name NuGet -Force
}

if ((Get-Module PSSQLite -ListAvailable) -eq $null) {
    $null = Install-Module PSSQLite -Scope CurrentUser -Force
}

$DataSource = "$env:LOCALAPPDATA\Microsoft\Windows\Notifications\wpndatabase.db"

try {
    Invoke-SqliteQuery -DataSource $DataSource -Query $('UPDATE "main"."Metadata" SET "Value"=' + $maxCount + ' WHERE "_rowid_"=''2''')
    Write-Output "Changed max notifications to $maxCount."
}
catch {
    $_.Error.Exception.Message 
}
