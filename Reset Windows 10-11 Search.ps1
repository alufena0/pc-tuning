# Copyright © 2019, Microsoft Corporation. All rights reserved.

<# If the Windows 10 May 2019 Update or a later update is installed, use Windows PowerShell to reset Windows Search. To do this, follow these steps.

Note You must have administrator permissions to run this script.

    1. Click the Download button and save ResetWindowsSearchBox.ps1 to a local folder.
    2. Right-click the file that you saved, and select Run with PowerShell.
    3. If you are asked "Do you want to allow this app to make changes to your device?," select Yes.
    4. The PowerShell script resets the Windows Search feature. When the word "Done" appears, close the PowerShell window.
    5. If you receive a "Cannot be loaded because running scripts is disabled on this system" error message, enter the following command on the command line of the PowerShell window, and then press Enter: Get-ExecutionPolicy Note The current policy appears in the window. For example, you might see Restricted. We recommend that you note this value because you'll have to use it later.
    6. Enter the following command on the command line of the PowerShell window, and then press Enter: Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy 7. Unrestricted Note You'll receive a warning message that explains the security risks of an execution policy change. Press Y, and then press Enter to accept the change. To learn more about PowerShell execution policies, see About Execution Policies.
    7. After the policy change is completed, close the window, and then repeat steps 2–4. However, when the "Done" message appears this time, DON'T close the PowerShell window. Instead, press any key to continue.
    8. Revert to your previous PowerShell execution policy setting. To do this, enter the following command on the command line of the PowerShell window, press the Spacebar, enter the policy value that you noted in step 5, and then press Enter: Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy For example, if the policy that you noted in step 5 was Restricted, the command would resemble the following: Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Restricted Note You'll receive a warning message that explains the security risks of an execution policy change. Press Y, and then press Enter to accept the change and revert to your previous policy setting.
    9. Close the PowerShell window.

Note If your organization has disabled the ability to run scripts, contact your administrator for help. #>

function T-R
{
    [CmdletBinding()]
    Param(
        [String] $n
    )

    $o = Get-Item -LiteralPath $n -ErrorAction SilentlyContinue
    return ($o -ne $null)
}

function R-R
{
    [CmdletBinding()]
    Param(
        [String] $l
    )

    $m = T-R $l
    if ($m) {
        Remove-Item -Path $l -Recurse -ErrorAction SilentlyContinue
    }
}

function S-D {
    R-R "HKLM:\SOFTWARE\Microsoft\Cortana\Testability"
    R-R "HKLM:\SOFTWARE\Microsoft\Search\Testability"
}

function K-P {
    [CmdletBinding()]
    Param(
        [String] $g
    )

    $h = Get-Process $g -ErrorAction SilentlyContinue

    $i = $(get-date).AddSeconds(2)
    $k = $(get-date)

    while ((($i - $k) -gt 0) -and $h) {
        $k = $(get-date)

        $h = Get-Process $g -ErrorAction SilentlyContinue
        if ($h) {
            $h.CloseMainWindow() | Out-Null
            Stop-Process -Id $h.Id -Force
        }

        $h = Get-Process $g -ErrorAction SilentlyContinue
    }
}

function D-FF {
    [CmdletBinding()]
    Param(
        [string[]] $e
    )

    foreach ($f in $e) {
        if (Test-Path -Path $f) {
            Remove-Item -Recurse -Force $f -ErrorAction SilentlyContinue
        }
    }
}

function D-W {

    $d = @("$Env:localappdata\Packages\Microsoft.Cortana_8wekyb3d8bbwe\AC\AppCache",
        "$Env:localappdata\Packages\Microsoft.Cortana_8wekyb3d8bbwe\AC\INetCache",
        "$Env:localappdata\Packages\Microsoft.Cortana_8wekyb3d8bbwe\AC\INetCookies",
        "$Env:localappdata\Packages\Microsoft.Cortana_8wekyb3d8bbwe\AC\INetHistory",
        "$Env:localappdata\Packages\Microsoft.Windows.Cortana_cw5n1h2txyewy\AC\AppCache",
        "$Env:localappdata\Packages\Microsoft.Windows.Cortana_cw5n1h2txyewy\AC\INetCache",
        "$Env:localappdata\Packages\Microsoft.Windows.Cortana_cw5n1h2txyewy\AC\INetCookies",
        "$Env:localappdata\Packages\Microsoft.Windows.Cortana_cw5n1h2txyewy\AC\INetHistory",
        "$Env:localappdata\Packages\Microsoft.Search_8wekyb3d8bbwe\AC\AppCache",
        "$Env:localappdata\Packages\Microsoft.Search_8wekyb3d8bbwe\AC\INetCache",
        "$Env:localappdata\Packages\Microsoft.Search_8wekyb3d8bbwe\AC\INetCookies",
        "$Env:localappdata\Packages\Microsoft.Search_8wekyb3d8bbwe\AC\INetHistory",
        "$Env:localappdata\Packages\Microsoft.Windows.Search_cw5n1h2txyewy\AC\AppCache",
        "$Env:localappdata\Packages\Microsoft.Windows.Search_cw5n1h2txyewy\AC\INetCache",
        "$Env:localappdata\Packages\Microsoft.Windows.Search_cw5n1h2txyewy\AC\INetCookies",
        "$Env:localappdata\Packages\Microsoft.Windows.Search_cw5n1h2txyewy\AC\INetHistory")

    D-FF $d
}

function R-L {
    [CmdletBinding()]
    Param(
        [String] $c
    )
 
    K-P $c 2>&1 | out-null
    D-W # 2>&1 | out-null
    K-P $c 2>&1 | out-null

    Start-Sleep -s 5
}

function D-E {
    Write-Host "Press any key to continue..."
    $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp") > $null
}

Write-Output "Verifying that the script is running elevated"
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
 if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
  $Cx = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
  Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList "-noexit",$Cx
  Exit
 }
}

$a = "searchui"
$b = "$Env:localappdata\Packages\Microsoft.Windows.Search_cw5n1h2txyewy"
if (Test-Path -Path $b) {
    $a = "searchapp"
} 


Write-Output "Resetting Windows Search Box"
S-D 2>&1 | out-null
R-L $a

Write-Output "Done..."
D-E