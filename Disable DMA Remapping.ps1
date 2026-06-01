$build = [Environment]::OSVersion.Version.Build

if ($build -ge 26100) {
    Write-Host "Windows 11 24H2+ — per-device method (PCI only)"

    Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services" | ForEach-Object {
        $params = "$($_.PSPath)\Parameters"
        if (Test-Path $params) {
            Remove-ItemProperty -Path $params -Name "RemappingSupported" -ErrorAction SilentlyContinue
        }
    }

    Get-PnpDevice -PresentOnly | Where-Object { $_.InstanceId -like "PCI\*" } | ForEach-Object {
        $path = "HKLM:\SYSTEM\CurrentControlSet\Enum\$($_.InstanceId)\Device Parameters\DMA Management"
        if (-not (Test-Path $path)) {
            New-Item $path -Force | Out-Null
        }
        New-ItemProperty $path -Name "DmaRemappingCompatible" -Value 0 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null
        Write-Host "  Opt-out: $($_.InstanceId)"
    }
}
else {
    Write-Host "Windows 10 / legacy — per-driver method (Parameters existentes only)"

    Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services" | ForEach-Object {
        $params = "$($_.PSPath)\Parameters"
        if (Test-Path $params) {  # ? não cria, só seta onde já existe
            New-ItemProperty $params -Name "RemappingSupported" -Value 0 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null
        }
    }
}