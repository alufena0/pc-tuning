# Get current states
$agent = Get-MMAgent
$oaStatus = $agent.OperationAPI
$aplStatus = $agent.ApplicationPreLaunch

Write-Output "OperationAPI is currently: $($oaStatus.ToString().ToUpper())"
Write-Output "Application PreLaunch is currently: $($aplStatus.ToString().ToUpper())"

# Describe what toggling does
Write-Output ""
Write-Output "Toggling will switch between:"
Write-Output " - ENABLED  : Allows Windows to record I/O patterns and preload applications"
Write-Output " - DISABLED : Disables background monitoring and preloading (lower overhead)"
Write-Output ""

# Prompt for toggle
$choice = Read-Host "Do you want to toggle both OperationAPI and ApplicationPreLaunch? (Y/N)"

if ($choice -match "^[Yy]$") {
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters"

    if ($oaStatus) {
        Write-Output "Disabling features..."
        
        # Disable via MMAgent
        Disable-MMAgent -OperationAPI -ErrorAction SilentlyContinue
        Disable-MMAgent -ApplicationLaunchPrefetching -ErrorAction SilentlyContinue
        Disable-MMAgent -ApplicationPreLaunch -ErrorAction SilentlyContinue
        
        # Set Registry to 0 to ensure it's OFF
        Set-ItemProperty -Path $regPath -Name "EnablePrefetch" -Value 0 -ErrorAction SilentlyContinue
        Set-ItemProperty -Path $regPath -Name "EnablePrefetcher" -Value 0 -ErrorAction SilentlyContinue
        Set-ItemProperty -Path $regPath -Name "EnableSuperfetch" -Value 0 -ErrorAction SilentlyContinue
    } else {
        Write-Output "Enabling features..."
        
        # Set Registry to 3 first (Required to avoid Error 50)
        Set-ItemProperty -Path $regPath -Name "EnablePrefetch" -Value 3 -ErrorAction SilentlyContinue
        Set-ItemProperty -Path $regPath -Name "EnablePrefetcher" -Value 3 -ErrorAction SilentlyContinue
        Set-ItemProperty -Path $regPath -Name "EnableSuperfetch" -Value 3 -ErrorAction SilentlyContinue
        
        # Enable via MMAgent
        Enable-MMAgent -ApplicationLaunchPrefetching -ErrorAction SilentlyContinue
        Enable-MMAgent -OperationAPI -ErrorAction SilentlyContinue
        Enable-MMAgent -ApplicationPreLaunch -ErrorAction SilentlyContinue
    }

    # Restart SysMain to apply changes
    Write-Output "Restarting SysMain service..."
    Restart-Service -Name "SysMain" -Force -ErrorAction SilentlyContinue

    Start-Sleep -Seconds 1

    # Show updated status
    $newAgent = Get-MMAgent
    Write-Output ""
    Write-Output "Updated states:"
    Write-Output "OperationAPI: $($newAgent.OperationAPI.ToString().ToUpper())"
    Write-Output "Application PreLaunch: $($newAgent.ApplicationPreLaunch.ToString().ToUpper())"
} else {
    Write-Output "No changes were made."
}

Write-Output ""
Read-Host "Press Enter to exit."