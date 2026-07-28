Get-Content "C:\Windows\System32\drivers\etc\hosts" |
    Where-Object { $_ -match "^0\.0\.0\.0\s+" -or $_ -match "^127\.0\.0\.1\s+" } |
    ForEach-Object {
        $domain = ($_ -split "\s+")[1]
        if ($domain -and $domain -ne "localhost") {
            "local-zone: `"$domain`" always_nxdomain"
        }
    } |
    Set-Content "C:\Program Files\Unbound\blocklist.conf"
pause