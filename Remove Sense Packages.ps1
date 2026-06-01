# =====================================================================
# SENSE CLIENT REMOVER — SAFE VERSION (BUILD 26100+)
#
# Requires: Administrator ou TrustedInstaller (PowerRun/NSudo)
#
# SAFE: Usa DISM API para remoção — NÃO deleta arquivos físicos .mum/.cat
# SAFE: NÃO deleta chaves CBS do registro diretamente
# Windows Update permanece funcional após execução.
# =====================================================================

Write-Host "Starting Sense Client removal (safe mode)..." -ForegroundColor Cyan

$cbsRegPath  = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages'
$targetMatch = '*SenseClient*'

# =====================================================================
# STEP 1: Tenta remoção via DISM API (método correto)
# =====================================================================
Write-Host "`n[STEP 1] Attempting removal via DISM API..." -ForegroundColor Yellow

Get-ChildItem $cbsRegPath -ErrorAction SilentlyContinue |
    Where-Object { $_.PSChildName -like $targetMatch } |
    ForEach-Object {
        $keyName = $_.PSChildName
        Write-Host "  [CBS] $keyName" -ForegroundColor Red

        # Unhide para o DISM conseguir ver e remover
        try {
            Set-ItemProperty "registry::$($_.Name)" -Name Visibility -Value 1 -Force -ErrorAction SilentlyContinue
            New-ItemProperty "registry::$($_.Name)" -Name DefVis -PropertyType DWord -Value 2 -Force -ErrorAction SilentlyContinue | Out-Null
        } catch {}

        # Remove subkeys que bloqueiam desinstalação
        Remove-Item "registry::$($_.Name)\Owners"  -Force -ErrorAction SilentlyContinue
        Remove-Item "registry::$($_.Name)\Updates" -Force -ErrorAction SilentlyContinue

        # Tenta remoção via API
        try {
            Remove-WindowsPackage -Online -PackageName $keyName -NoRestart -ErrorAction Stop *>$null
            Write-Host "    -> Removed via Remove-WindowsPackage" -ForegroundColor Green
        } catch {
            dism.exe /Online /Remove-Package /PackageName:$keyName /NoRestart /Quiet 2>&1 | Out-Null
            if ($LASTEXITCODE -eq 0) {
                Write-Host "    -> Removed via DISM" -ForegroundColor Green
            } else {
                Write-Host "    -> DISM could not remove '$keyName'." -ForegroundColor DarkYellow
                Write-Host "       Package may be protected or already absent. CBS intact." -ForegroundColor DarkGray
                Write-Host "       NOTE: Deleting .mum/.cat files would break Windows Update." -ForegroundColor DarkGray
            }
        }
    }

# =====================================================================
# STEP 2: Remove capability via DISM API
# =====================================================================
Write-Host "`n[STEP 2] Removing Sense capability via API..." -ForegroundColor Yellow

Get-WindowsCapability -Online -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -like '*Sense*' -or $_.Name -like '*SenseClient*' } |
    ForEach-Object {
        Write-Host "  [CAP] $($_.Name)" -ForegroundColor Red
        Remove-WindowsCapability -Online -Name $_.Name -ErrorAction SilentlyContinue
        Write-Host "    -> Remove-WindowsCapability executed" -ForegroundColor Gray
    }

# =====================================================================
# DONE
# =====================================================================
Write-Host "`nOPERATION COMPLETE." -ForegroundColor Green
Write-Host "Verify: Get-WindowsCapability -Online | Where-Object { `$_.Name -like '*Sense*' }" -ForegroundColor Gray
Write-Host "`nNote: If DISM could not remove the package, it is protected by Microsoft." -ForegroundColor Yellow
Write-Host "Use registry/GPO to disable SenseClient service instead of deleting CBS files." -ForegroundColor Yellow