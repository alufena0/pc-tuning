# Get current ApplicationPreLaunch state
$currentState = (Get-MMAgent).ApplicationPreLaunch
Write-Output "Current ApplicationPreLaunch state: $($currentState.ToString().ToUpper())"

# Describe what toggling does
Write-Output ""
Write-Output "Toggling will switch between:"
Write-Output " - ENABLED  : Windows preloads frequently used applications"
Write-Output " - DISABLED : Prevents background preloading (lower I/O and latency)"
Write-Output ""

# Prompt for toggle
$choice = Read-Host "Do you want to toggle ApplicationPreLaunch? (Y/N)"

if ($choice -match "^[Yy]$") {
    if ($currentState) {
        Write-Output "Disabling ApplicationPreLaunch..."
        Disable-MMAgent -ApplicationPreLaunch
    } else {
        Write-Output "Enabling ApplicationPreLaunch..."
        Enable-MMAgent -ApplicationPreLaunch
    }

    Start-Sleep -Seconds 1

    # Show new state
    $newState = (Get-MMAgent).ApplicationPreLaunch
    Write-Output "New ApplicationPreLaunch state: $($newState.ToString().ToUpper())"
} else {
    Write-Output "No changes were made."
}

# Keep the window open
Write-Output ""
Read-Host "Press Enter to exit."