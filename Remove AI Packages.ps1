# =====================================================================
# AI PACKAGE REMOVER — SAFE VERSION
# Targets: MicrosoftWindows.Client.CoreAI, .Photon, Copilot+
#          (Speion, Voiess, Livtop, InpApp, Tasbar, etc.)
#
# Requires: Administrator or TrustedInstaller (run via PowerRun/NSudo)
# Method: EndOfLife trick + InboxApplications + DISM API only
#
# SAFE: Does NOT delete physical .mum/.cat files from servicing\Packages
# SAFE: Does NOT delete CBS registry keys directly
# Windows Update remains functional after execution.
# =====================================================================

$ProgressPreference = 'SilentlyContinue'
Write-Host "=== AI PACKAGE REMOVER (SAFE) ===" -ForegroundColor Cyan

$targetPatterns = @(
    'Microsoft.AIFabric',
    'MicrosoftWindows.Client.CoreAI',
    'MicrosoftWindows.Client.Photon',
    'MicrosoftWindows.Client.CoPilot',
    'Microsoft.Windows.Ai.Copilot.Provider',
    'Microsoft.Copilot',
    'Microsoft.Office.ActionsServer',
    'Microsoft.WritingAssistant',
    'aimgr',
    'Voiess',
    'Speion',
    'Livtop',
    'InpApp',
    'Filons',
    'Tasbar',
    'WindowsWorkload'
)

# CBS patterns used ONLY for removal via DISM API (never direct deletion)
$cbsPatterns = @('AIFabric', 'CoreAI', 'Photon', 'CoPilot', 'Copilot', 'AIX', 'Voiess', 'Speion',
                 'Livtop', 'InpApp', 'Filons', 'Tasbar', 'WindowsWorkload',
                 'WritingAssistant', 'ActionsServer')

# =====================================================================
# PHASE 1: EndOfLife trick + AppxAllUserStore
# =====================================================================
Write-Host "`n[PHASE 1] Applying EndOfLife trick to AppxAllUserStore..." -ForegroundColor Yellow

$store     = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore'
$userSids  = @('S-1-5-18')
if (Test-Path $store) {
    $userSids += (Get-ChildItem $store -ErrorAction SilentlyContinue |
                  Where-Object { $_.PSChildName -like 'S-1-5-21*' }).PSChildName
}
Write-Host "  SIDs: $($userSids -join ', ')" -ForegroundColor Gray

$allInstalled   = Get-AppxPackage -AllUsers -ErrorAction SilentlyContinue
$allProvisioned = Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue

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
# (safe — these are app folders, not CBS files)
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
# PHASE 3 — INTENTIONALLY REMOVED
# We do NOT delete .mum/.cat files from servicing\Packages
# This breaks Windows Update. Use the zoicware CAB to block
# reinstallation without destroying CBS.
# =====================================================================
Write-Host "`n[PHASE 3] Skipped — CBS physical file deletion removed for safety." -ForegroundColor DarkGray
Write-Host "          Use zoicware PreventAIPackageReinstall CAB instead." -ForegroundColor DarkGray

# =====================================================================
# PHASE 4: CBS cleanup via DISM API only — NO direct key deletion
# =====================================================================
Write-Host "`n[PHASE 4] CBS cleanup via DISM API only..." -ForegroundColor Yellow

$cbsRegPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages'

Get-ChildItem $cbsRegPath -ErrorAction SilentlyContinue | ForEach-Object {
    $keyName  = $_.PSChildName
    $isTarget = $false
    foreach ($p in $cbsPatterns) { if ($keyName -like "*$p*") { $isTarget = $true; break } }
    if (!$isTarget) { return }

    Write-Host "  [CBS] $keyName" -ForegroundColor DarkRed

    # Unhide so DISM can detect the package
    try {
        Set-ItemProperty "registry::$($_.Name)" -Name Visibility -Value 1 -Force -ErrorAction SilentlyContinue
        New-ItemProperty "registry::$($_.Name)" -Name DefVis -PropertyType DWord -Value 2 -Force -ErrorAction SilentlyContinue | Out-Null
    } catch {}

    # Attempt clean removal via DISM API
    try {
        Remove-WindowsPackage -Online -PackageName $keyName -NoRestart -ErrorAction Stop *>$null
        Write-Host "    -> Removed via Remove-WindowsPackage" -ForegroundColor Green
    } catch {
        dism.exe /Online /Remove-Package /PackageName:$keyName /NoRestart /Quiet 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "    -> Removed via DISM" -ForegroundColor Green
        } else {
            # We do NOT delete the key directly — only report it
            Write-Host "    -> DISM could not remove (package may be protected). Skipping." -ForegroundColor DarkYellow
            Write-Host "       Use zoicware CAB to block reinstall instead." -ForegroundColor DarkGray
        }
    }
}

# =====================================================================
# PHASE 5: Per-user AppData cleanup
# =====================================================================
Write-Host "`n[PHASE 5] Cleaning per-user AppData..." -ForegroundColor Yellow

foreach ($user in (Get-ChildItem 'C:\Users' -Directory -ErrorAction SilentlyContinue)) {
    foreach ($pattern in $targetPatterns) {
        Get-ChildItem "$($user.FullName)\AppData\Local\Packages" -Filter "*$pattern*" -Directory -ErrorAction SilentlyContinue | ForEach-Object {
            Write-Host "  [APPDATA] $($_.FullName)" -ForegroundColor DarkRed
            Remove-Item -Path $_.FullName -Recurse -Force -ErrorAction SilentlyContinue
            if (!(Test-Path $_.FullName)) { Write-Host "    -> REMOVED" -ForegroundColor Green }
        }
    }
}

# =====================================================================
# PHASE 6: Recall Optional Feature
# =====================================================================
Write-Host "`n[PHASE 6] Removing Recall Optional Feature..." -ForegroundColor Yellow
try {
    $state = (Get-WindowsOptionalFeature -Online -FeatureName 'Recall' -ErrorAction Stop).State
    if ($state -and $state -ne 'DisabledWithPayloadRemoved') {
        Disable-WindowsOptionalFeature -Online -FeatureName 'Recall' -Remove -NoRestart -ErrorAction SilentlyContinue *>$null
        Write-Host "  -> Recall disabled and payload removed" -ForegroundColor Green
    } else {
        Write-Host "  -> Recall already removed or not present" -ForegroundColor Gray
    }
} catch {
    Write-Host "  -> Recall not found on this system" -ForegroundColor Gray
}

# =====================================================================
# DONE
# =====================================================================
Write-Host "`n=== DONE ===" -ForegroundColor Cyan
Write-Host "To block reinstallation through Windows Update, use the zoicware CAB:" -ForegroundColor Yellow
Write-Host "  & ([scriptblock]::Create((irm 'https://raw.githubusercontent.com/zoicware/RemoveWindowsAI/main/RemoveWindowsAi.ps1')))" -ForegroundColor White
Write-Host "  Option: PreventAIPackageReinstall" -ForegroundColor White
Write-Host "`nVerify: Get-AppxPackage -AllUsers | Where-Object { `$_.Name -like '*CoreAI*' -or `$_.Name -like '*Photon*' }" -ForegroundColor Gray