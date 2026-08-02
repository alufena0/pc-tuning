# create-edge-shortcut-v2.ps1
# Definitive solution: .lnk shortcut with Edge icon that runs ALL flags via invisible launcher

$edgePath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
$launcherDir = "$env:LOCALAPPDATA\EdgeHardened"
$launcherPath = "$launcherDir\edge-launcher.vbs"
$shortcutPath = "$env:USERPROFILE\Desktop\Microsoft Edge.lnk"

# ── disable-features ─────────────────────────────────────────
$disableFeatures = @(
    "AllowSwiftShaderFallback",
    "AllowSoftwareGLFallbackDueToCrash",
    "AutofillServerCommunication",
    "BrowsingTopics",
    "BrowsingTopicsDocumentAPI",
    "BrowsingTopicsParameters",
    "InterestFeedV2",
    "NTPPopularSitesBakedInContent",
    "UsePopularSitesSuggestions",
    "AimEnabled",
    "LensStandalone",
    "StarterPackExpansion",
    "MediaDrmPreprovisioning",
    "OptimizationHints",
    "OptimizationHintsFetchingSRP",
    "OptimizationHintsFetching",
    "OptimizationHintsFetchingAnonymousDataConsent",
    "OptimizationPersonalizedHintsFetching",
    "OptimizationGuideModelDownloading",
    "TextSafetyClassifier",
    "PrivacySandboxSettings4",
    "Reporting",
    "CrashReporting",
    "DocumentReporting",
    "TabHoverCardImages",
    "WebGPUBlobCache",
    "WebGPUService",
    "Journeys",
    "HstsTopLevelNavigationsOnly",
    "PartitionConnectionsByNetworkIsolationKey",
    "ScopeMemoryCachePerContext",
    "SplitCacheByIncludeCredentials",
    "SplitCacheByNetworkIsolationKey",
    "SplitCodeCacheByNetworkIsolationKey",
    "LensOverlay",
    "msFeatureGroupNewLookAndFeelHoldout"
)
$disableFeatures = $disableFeatures | Select-Object -Unique

# ── enable-features ──────────────────────────────────────────
$enableFeatures = @(
    "ClearCrossSiteCrossBrowsingContextGroupWindowName",
    "CapReferrerToOriginOnCrossOrigin",
    "LocalNetworkAccessChecksWebRTC",
    # "LocalNetworkAccessChecksWebSockets",
    "LocalNetworkAccessChecksWebTransport",
    "ReduceAcceptLanguage",
    "StrictOriginIsolation",
    "NetworkServiceSandbox",
    "PartitionAllocWithAdvancedChecks:enabled-processes/all-processes",
    "AudioServiceSandbox",
    "EnableCsrssLockdown",
    "NetworkServiceCodeIntegrity",
    "RendererAppContainer",
    "WinSboxRestrictCoreSharingOnRenderer",
    "WinSboxStrictHandleChecks",
    "PrintCompositorLPAC",
    "msForceNoRoundedCornerAndMargin"
)
$enableFeatures = $enableFeatures | Select-Object -Unique

# ── simple flags (no value) ─────────────────────────────────
$simpleFlags = @(
    "--disable-breakpad",
    "--disable-crash-reporter",
    "--no-default-browser-check",
    "--no-pings",
    "--disable-remote-fonts",
    "--site-per-process"
)

# ── flags with arguments ────────────────────────────────────
$flagsWithArgs = @(
    "--component-updater=--disable-pings",
    "--extension-content-verification=enforce_strict",
    "--extensions-install-verification=enforce_strict",
    "--js-flags=--disable-optimizing-compilers",
    "--webrtc-ip-handling-policy=disable_non_proxied_udp"
)

# ── final assembly ──────────────────────────────────────────
$dfStr = "--disable-features=" + ($disableFeatures -join ",")
$efStr = "--enable-features=" + ($enableFeatures -join ",")
$sf    = $simpleFlags -join " "
$fa    = $flagsWithArgs -join " "
$argValue = "$dfStr $efStr $sf $fa"

# ── Create invisible VBS launcher ───────────────────────────
New-Item -ItemType Directory -Force -Path $launcherDir | Out-Null

# VBS that runs Edge silently (no CMD window)
$vbsContent = @"
Set WshShell = CreateObject("WScript.Shell")
edgePath = "$($edgePath -replace '\\', '\\')"
args = "$($argValue -replace '"', '""')"
WshShell.Run """" & edgePath & """ " & args, 0, False
"@

$vbsContent | Out-File -FilePath $launcherPath -Encoding ASCII -Force

# ── Create .lnk shortcut pointing to VBS ──────────────────
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($shortcutPath)

$Shortcut.TargetPath = $launcherPath
$Shortcut.WorkingDirectory = $launcherDir
$Shortcut.IconLocation = "$edgePath, 0"
$Shortcut.Description = "Microsoft Edge Hardened - All privacy flags"

$Shortcut.Save()

Write-Host ""
Write-Host "System created successfully!"
Write-Host ""
Write-Host "Files created:"
Write-Host "   Launcher: $launcherPath"
Write-Host "   Shortcut: $shortcutPath"
Write-Host ""
Write-Host "Flags size: $($argValue.Length) characters"
Write-Host ""
Write-Host "STEPS TO USE:"
Write-Host "   1. Close ALL msedge.exe processes (taskkill /f /im msedge.exe)"
Write-Host "   2. Click the 'Microsoft Edge.lnk' shortcut on desktop"
Write-Host "   3. Check msedge://version -> Command Line"
Write-Host ""
Write-Host "Shortcut has original Edge icon"
Write-Host "Launcher is invisible (no CMD window)"
Set-ItemProperty -Path $shortcutPath -Name IsReadOnly -Value $true
