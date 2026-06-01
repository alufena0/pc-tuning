# =====================================================================
# REMOVE SURVIVING BLOAT — SAFE VERSION
# Microsoft.Windows.AugLoop.CBS        (Microsoft 365 AI toolchain)
# Microsoft.Windows.NarratorQuickStart (Narrator welcome screen)
# Microsoft.XboxGameCallableUI         (Xbox overlay UI)
#
# Requires: PowerRun / NSudo (TrustedInstaller ou SYSTEM)
# Method: EndOfLife trick + InboxApplications + DISM API only
#
# SAFE: Does NOT delete physical .mum/.cat files from servicing\Packages
# SAFE: Does NOT delete CBS registry keys directly
# =====================================================================

$ProgressPreference = 'SilentlyContinue'
Write-Host "=== REMOVE SURVIVING BLOAT (SAFE) ===" -ForegroundColor Cyan

$targetPatterns = @(
    'Microsoft.Windows.AugLoop.CBS',
    'Microsoft.Windows.NarratorQuickStart',
    'Microsoft.XboxGameCallableUI'
)

$cbsPatterns = @(
    'AugLoop',
    'NarratorQuickStart',
    'XboxGameCallableUI'
)

$store    = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore'
$userSids = @('S-1-5-18')
if (Test-Path $store) {
    $userSids += (Get-ChildItem $store -ErrorAction SilentlyContinue |
                  Where-Object { $_.PSChildName -like 'S-1-5-21*' }).PSChildName
}

$allInstalled   = Get-AppxPackage -AllUsers -ErrorAction SilentlyContinue
$allProvisioned = Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue

# =====================================================================
# PHASE 1: EndOfLife trick
# =====================================================================
Write-Host "`n[PHASE 1] EndOfLife trick..." -ForegroundColor Yellow

foreach ($pattern in $targetPatterns) {
    $pkgs     = $allInstalled   | Where-Object { $_.Name        -like "*$pattern*" }
    $provPkgs = $allProvisioned | Where-Object { $_.DisplayName -like "*$pattern*" -or
                                                  $_.PackageName -like "*$pattern*" }

    foreach ($pkg in $pkgs) {
        $fullName   = $pkg.PackageFullName
        $familyName = $pkg.PackageFamilyName
        Write-Host "  [TARGET] $fullName" -ForegroundColor Red

        try { Set-NonRemovableAppsPolicy -Online -PackageFamilyName $familyName -NonRemovable 0 -ErrorAction SilentlyContinue } catch {}

        New-Item "$store\Deprovisioned\$familyName" -Force -ErrorAction SilentlyContinue | Out-Null

        $inboxPath = "$store\InboxApplications\$fullName"
        if (Test-Path $inboxPath) {
            Remove-Item -Path $inboxPath -Force -ErrorAction SilentlyContinue
            Write-Host "    -> InboxApplications removed" -ForegroundColor Gray
        }

        foreach ($sid in $userSids) {
            New-Item "$store\EndOfLife\$sid\$fullName" -Force -ErrorAction SilentlyContinue | Out-Null
        }

        foreach ($userInfo in $pkg.PackageUserInformation) {
            $sid = $userInfo.UserSecurityID.SID
            New-Item "$store\EndOfLife\$sid\$fullName" -Force -ErrorAction SilentlyContinue | Out-Null
            Remove-AppxPackage -Package $fullName -User $sid -ErrorAction SilentlyContinue
        }

        Remove-AppxPackage -Package $fullName -AllUsers -ErrorAction SilentlyContinue
        Write-Host "    -> Remove-AppxPackage executed" -ForegroundColor Gray
    }

    foreach ($prov in $provPkgs) {
        Write-Host "  [PROVISIONED] $($prov.PackageName)" -ForegroundColor DarkRed
        $fam = ($allInstalled | Where-Object { $_.Name -eq $prov.DisplayName } | Select-Object -First 1).PackageFamilyName
        if ($fam) { New-Item "$store\Deprovisioned\$fam" -Force -ErrorAction SilentlyContinue | Out-Null }
        Remove-AppxProvisionedPackage -Online -PackageName $prov.PackageName -AllUsers -ErrorAction SilentlyContinue
        Write-Host "    -> Remove-AppxProvisionedPackage executed" -ForegroundColor Gray
    }
}

# =====================================================================
# PHASE 2: Physical folder removal from WindowsApps and SystemApps
# =====================================================================
Write-Host "`n[PHASE 2] Removing physical package folders..." -ForegroundColor Yellow

foreach ($dir in @("$env:ProgramFiles\WindowsApps", "$env:windir\SystemApps")) {
    if (!(Test-Path $dir)) { continue }
    foreach ($pattern in $targetPatterns) {
        Get-ChildItem $dir -Filter "*$pattern*" -Directory -ErrorAction SilentlyContinue | ForEach-Object {
            Write-Host "  [FOLDER] $($_.FullName)" -ForegroundColor Red
            takeown /f "$($_.FullName)" /r /d Y 2>$null | Out-Null
            icacls "$($_.FullName)" /grant "*S-1-5-32-544:F" /t /c /q 2>$null | Out-Null
            Remove-Item -Path $_.FullName -Recurse -Force -ErrorAction SilentlyContinue
            if (!(Test-Path $_.FullName)) { Write-Host "    -> REMOVED" -ForegroundColor Green }
            else { Write-Host "    -> Still present (reboot and retry)" -ForegroundColor DarkYellow }
        }
    }
}

# =====================================================================
# PHASE 3 — REMOVIDO INTENCIONALMENTE
# NÃO deletamos arquivos .mum/.cat de servicing\Packages
# =====================================================================
Write-Host "`n[PHASE 3] Skipped — CBS physical file deletion removed for safety." -ForegroundColor DarkGray

# =====================================================================
# PHASE 4: CBS cleanup via DISM API apenas — SEM deleção direta
# =====================================================================
Write-Host "`n[PHASE 4] CBS cleanup via DISM API only..." -ForegroundColor Yellow

$cbsRegPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages'
Get-ChildItem $cbsRegPath -ErrorAction SilentlyContinue | ForEach-Object {
    $keyName  = $_.PSChildName
    $isTarget = $false
    foreach ($p in $cbsPatterns) { if ($keyName -like "*$p*") { $isTarget = $true; break } }
    if (!$isTarget) { return }

    Write-Host "  [CBS] $keyName" -ForegroundColor DarkRed

    try {
        Set-ItemProperty "registry::$($_.Name)" -Name Visibility -Value 1 -Force -ErrorAction SilentlyContinue
        New-ItemProperty "registry::$($_.Name)" -Name DefVis -PropertyType DWord -Value 2 -Force -ErrorAction SilentlyContinue | Out-Null
    } catch {}

    try {
        Remove-WindowsPackage -Online -PackageName $keyName -NoRestart -ErrorAction Stop *>$null
        Write-Host "    -> Removed via Remove-WindowsPackage" -ForegroundColor Green
    } catch {
        dism.exe /Online /Remove-Package /PackageName:$keyName /NoRestart /Quiet 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "    -> Removed via DISM" -ForegroundColor Green
        } else {
            Write-Host "    -> DISM could not remove (protected). Skipping — CBS intact." -ForegroundColor DarkYellow
        }
    }
}

# =====================================================================
# PHASE 5: Per-user AppData cleanup
# =====================================================================
Write-Host "`n[PHASE 5] Cleaning per-user AppData..." -ForegroundColor Yellow

Get-ChildItem 'C:\Users' -Directory -ErrorAction SilentlyContinue | ForEach-Object {
    $pkgDir = "$($_.FullName)\AppData\Local\Packages"
    foreach ($pattern in $targetPatterns) {
        Get-ChildItem $pkgDir -Filter "*$pattern*" -Directory -ErrorAction SilentlyContinue | ForEach-Object {
            Write-Host "  [APPDATA] $($_.FullName)" -ForegroundColor DarkRed
            Remove-Item -Path $_.FullName -Recurse -Force -ErrorAction SilentlyContinue
            if (!(Test-Path $_.FullName)) { Write-Host "    -> REMOVED" -ForegroundColor Green }
        }
    }
}

# =====================================================================
# DONE
# =====================================================================
Write-Host "`n=== DONE ===" -ForegroundColor Cyan
Write-Host "Verify:" -ForegroundColor White
Write-Host 'Get-AppxPackage -AllUsers | Where-Object { $_.Name -like "*AugLoop*" -or $_.Name -like "*NarratorQuickStart*" -or $_.Name -like "*XboxGameCallableUI*" }' -ForegroundColor Gray
Write-Host "`nReboot Windows to confirm." -ForegroundColor Yellow