$target = Get-Process | Where-Object { $_.Responding -and $_.Id -ne 0 } | Sort-Object WorkingSet64 -Descending | Select-Object -First 1
if ($target) {
    try {
        $target.PriorityClass = 'AboveNormal'
    } catch {}
}
exit
