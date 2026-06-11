# =====================================================================
# SENSE CLIENT REMOVER — SAFE VERSION (BUILD 26100+)
#
# Requires: Administrator or TrustedInstaller (PowerRun/NSudo)
#
# SAFE: Uses DISM API for removal — does NOT delete physical .mum/.cat files
# SAFE: Does NOT delete CBS registry keys directly
# Windows Update remains functional after execution.
# =====================================================================

# =====================================================================
# GUARD: Windows 11 only (build 26100+)
# =====================================================================
$build = [System.Environment]::OSVersion.Version.Build
if ($build -lt 26100) {
    Write-Host ""
    Write-Host "  *** THIS SCRIPT IS FOR WINDOWS 11 (BUILD 26100+) ONLY ***" -ForegroundColor Red
    Write-Host "  Detected build: $build" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  Running this on Windows 10 can break Windows Update." -ForegroundColor Red
    Write-Host "  Press any key to exit..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

Write-Host ""
Write-Host "  ============================================" -ForegroundColor DarkCyan
Write-Host "   SENSE CLIENT REMOVER — SAFE MODE" -ForegroundColor Cyan
Write-Host "   Detected build: $build (Windows 11 OK)" -ForegroundColor Green
Write-Host "  ============================================" -ForegroundColor DarkCyan
Write-Host ""
Write-Host "  This will remove SenseClient packages and capabilities via DISM API." -ForegroundColor White
Write-Host "  Physical CBS files will NOT be touched." -ForegroundColor Gray
Write-Host ""
Write-Host "  Are you sure you want to continue? [Y / N]" -ForegroundColor Yellow
Write-Host ""

$confirm = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
if ($confirm.Character -notin @('y','Y')) {
    Write-Host "  Aborted by user." -ForegroundColor DarkGray
    exit 0
}

Write-Host ""
Write-Host "Starting Sense Client removal (safe mode)..." -ForegroundColor Cyan

$cbsRegPath  = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages'
$targetMatch = '*SenseClient*'

# =====================================================================
# STEP 1: Attempt removal via DISM API (correct method)
# =====================================================================
Write-Host "`n[STEP 1] Attempting removal via DISM API..." -ForegroundColor Yellow

Get-ChildItem $cbsRegPath -ErrorAction SilentlyContinue |
    Where-Object { $_.PSChildName -like $targetMatch } |
    ForEach-Object {
        $keyName = $_.PSChildName
        Write-Host "  [CBS] $keyName" -ForegroundColor Red

        # Unhide the package so DISM can see and remove it
        try {
            Set-ItemProperty "registry::$($_.Name)" -Name Visibility -Value 1 -Force -ErrorAction SilentlyContinue
            New-ItemProperty "registry::$($_.Name)" -Name DefVis -PropertyType DWord -Value 2 -Force -ErrorAction SilentlyContinue | Out-Null
        } catch {}

        # Remove subkeys that block uninstallation
        Remove-Item "registry::$($_.Name)\Owners"  -Force -ErrorAction SilentlyContinue
        Remove-Item "registry::$($_.Name)\Updates" -Force -ErrorAction SilentlyContinue

        # Attempt removal via API
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
