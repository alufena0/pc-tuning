# Remove old rules before recreating
Get-NetFirewallRule | Where-Object { $_.DisplayName -like "SW_Block_Out_*" -or $_.DisplayName -like "SW_Block_In_*" } | Remove-NetFirewallRule

$lists = @(
    "https://raw.githubusercontent.com/ShadowWhisperer/IPs/master/Lists/Threats",
    "https://raw.githubusercontent.com/ShadowWhisperer/IPs/master/Lists/Trackers",
    "https://raw.githubusercontent.com/ShadowWhisperer/IPs/master/Lists/Ads"
)
$ips = @()
foreach ($url in $lists) {
    $ips += (Invoke-WebRequest $url -UseBasicParsing).Content -split "`n" | Where-Object { $_ -match '^\d' }
}
$ips = $ips | Sort-Object -Unique
$chunks = [System.Collections.ArrayList]@()
for ($i = 0; $i -lt $ips.Count; $i += 300) {
    $chunks.Add($ips[$i..([Math]::Min($i+299, $ips.Count-1))]) | Out-Null
}
$n = 1
foreach ($chunk in $chunks) {
    New-NetFirewallRule -DisplayName "SW_Block_Out_$n" -Direction Outbound -Action Block -RemoteAddress $chunk
    New-NetFirewallRule -DisplayName "SW_Block_In_$n" -Direction Inbound -Action Block -RemoteAddress $chunk
    $n++
}
