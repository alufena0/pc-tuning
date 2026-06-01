# Check current MemoryCompression state
$mcStatus = (Get-MMAgent).MemoryCompression
Write-Output "Memory Compression is currently: $($mcStatus.ToString().ToUpper())"

# Describe what toggling does
Write-Output ""
Write-Output "Toggling will switch between:"
Write-Output " - ENABLED  : Windows compresses unused RAM pages to save memory"
Write-Output " - DISABLED : No RAM compression (lower CPU usage, higher RAM footprint)"
Write-Output ""

# Prompt for action
$choice = Read-Host "Do you want to toggle Memory Compression? (Y/N)"

if ($choice -match "^[Yy]$") {
    if ($mcStatus) {
        Write-Output "Disabling Memory Compression..."
        Disable-MMAgent -mc
    } else {
        Write-Output "Enabling Memory Compression..."
        Enable-MMAgent -mc
    }

    Start-Sleep -Seconds 1

    # Show updated status
    $newMcStatus = (Get-MMAgent).MemoryCompression
    Write-Output "New Memory Compression state: $($newMcStatus.ToString().ToUpper())"
} else {
    Write-Output "No changes were made."
}

Write-Output ""
Read-Host "Press Enter to exit."