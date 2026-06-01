# create-chrome-shortcut-v2.ps1
# Definitive solution: .lnk shortcut with Chrome icon that runs ALL flags via invisible launcher

$chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
$launcherDir = "$env:LOCALAPPDATA\ChromeHardened"
$launcherPath = "$launcherDir\chrome-launcher.vbs"
$shortcutPath = "$env:USERPROFILE\Desktop\Google Chrome.lnk"

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
    "optimization-guide-on-device-model",
    "OnDeviceModelBackgroundDownload",
    "prompt-api-for-gemini-nano",
    "prompt-api-for-gemini-nano-multimodal-input",
    "summarization-api-for-gemini-nano",
    "writer-api-for-gemini-nano",
    "rewriter-api-for-gemini-nano",
    "proofreader-api-for-gemini-nano",
    "ai-mode-omnibox-entry-point",
    "omnibox-allow-ai-mode-matches",
    "enable-lens-overlay",
    "permissions-ai-v3",
    "permissions-ai-v4",
    "GenAILocalFoundationalModel"
)
$disableFeatures = $disableFeatures | Select-Object -Unique

# ── enable-features ──────────────────────────────────────────
$enableFeatures = @(
    "ClearCrossSiteCrossBrowsingContextGroupWindowName",
    "CapReferrerToOriginOnCrossOrigin",
    "LocalNetworkAccessChecksWebRTC",
    "LocalNetworkAccessChecksWebSockets",
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
    "PrintCompositorLPAC"
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

# VBS that runs Chrome silently (no CMD window)
$vbsContent = @"
Set WshShell = CreateObject("WScript.Shell")
chromePath = "$($chromePath -replace '\\', '\\')"
args = "$($argValue -replace '"', '""')"
WshShell.Run """" & chromePath & """ " & args, 0, False
"@

$vbsContent | Out-File -FilePath $launcherPath -Encoding ASCII -Force

# ── Create .lnk shortcut pointing to VBS ──────────────────
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($shortcutPath)

$Shortcut.TargetPath = $launcherPath
$Shortcut.WorkingDirectory = $launcherDir
$Shortcut.IconLocation = "$chromePath, 0"
$Shortcut.Description = "Google Chrome Hardened - All privacy flags"

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
Write-Host "   1. Close ALL chrome.exe processes (taskkill /f /im chrome.exe)"
Write-Host "   2. Click the 'Google Chrome.lnk' shortcut on desktop"
Write-Host "   3. Check chrome://version -> Command Line"
Write-Host ""
Write-Host "Shortcut has original Chrome icon"
Write-Host "Launcher is invisible (no CMD window)"