//
/* You may copy+paste this file and use it as it is.
 *
 * If you make changes to your about:config while the program is running, the
 * changes will be overwritten by the user.js when the application restarts.
 *
 * To make lasting changes to preferences, you will have to edit the user.js.
 */

/****************************************************************************
 * Betterfox                                                                *
 * "Ad meliora"                                                             *
 * version: 154                                                             *
 * url: https://github.com/yokoffing/Betterfox                              *
****************************************************************************/

/****************************************************************************
 * SECTION: FASTFOX                                                         *
****************************************************************************/
/** GENERAL ***/
user_pref("gfx.content.skia-font-cache-size", 20);
user_pref("content.notify.interval", 100000);

/** GFX ***/
user_pref("gfx.canvas.accelerated.cache-size", 512);

/** MEDIA CACHE ***/
user_pref("media.cache_readahead_limit", 3600);
user_pref("media.cache_resume_threshold", 1800);

/** IMAGE CACHE ***/
user_pref("image.mem.decode_bytes_at_a_time", 32768);

/** NETWORKING ***/
user_pref("network.buffer.cache.size", 65535);
user_pref("network.buffer.cache.count", 48);
user_pref("network.http.max-connections", 1800);
user_pref("network.http.max-persistent-connections-per-server", 10);
user_pref("network.http.max-urgent-start-excessive-connections-per-host", 5);
user_pref("network.http.request.max-start-delay", 5);
user_pref("network.dnsCacheExpiration", 3600);

/****************************************************************************
 * SECTION: SECUREFOX                                                       *
****************************************************************************/
/** TRACKING PROTECTION ***/
user_pref("browser.contentblocking.category", "strict");
user_pref("browser.download.start_downloads_in_tmp_dir", true);
user_pref("browser.uitour.enabled", false);
user_pref("privacy.globalprivacycontrol.enabled", true);

/** OCSP & CERTS / HPKP ***/
user_pref("security.OCSP.enabled", 0);
user_pref("privacy.antitracking.isolateContentScriptResources", true);
user_pref("security.csp.reporting.enabled", false);

/** SSL / TLS ***/
user_pref("security.ssl.treat_unsafe_negotiation_as_broken", true);
user_pref("browser.xul.error_pages.expert_bad_cert", true);
user_pref("security.tls.enable_0rtt_data", false);

/** DISK AVOIDANCE ***/
user_pref("browser.cache.disk.enable", false);
user_pref("browser.privatebrowsing.forceMediaMemoryCache", true);
user_pref("media.memory_cache_max_size", 65536);
user_pref("browser.sessionstore.interval", 60000);

/** SHUTDOWN & SANITIZING ***/
user_pref("privacy.history.custom", true);

/** SPECULATIVE LOADING ***/
user_pref("network.http.speculative-parallel-limit", 0);
user_pref("network.dns.disablePrefetch", true);
user_pref("network.dns.disablePrefetchFromHTTPS", true);
user_pref("browser.urlbar.speculativeConnect.enabled", false);
user_pref("browser.places.speculativeConnect.enabled", false);
user_pref("network.prefetch-next", false);

/** SEARCH / URL BAR ***/
user_pref("browser.urlbar.trimHttps", true);
user_pref("browser.urlbar.untrimOnUserInteraction.featureGate", true);
user_pref("browser.search.separatePrivateDefault.ui.enabled", true);
user_pref("browser.search.suggest.enabled", false);
user_pref("browser.urlbar.quicksuggest.enabled", false);
user_pref("browser.urlbar.groupLabels.enabled", false);
user_pref("browser.formfill.enable", false);
user_pref("network.IDN_show_punycode", true);

/** HTTPS-ONLY MODE ***/
user_pref("dom.security.https_only_mode", true);
user_pref("dom.security.https_only_mode_error_page_user_suggestions", true);

/** PASSWORDS ***/
user_pref("signon.formlessCapture.enabled", false);
user_pref("signon.privateBrowsingCapture.enabled", false);
user_pref("network.auth.subresource-http-auth-allow", 1);
user_pref("editor.truncate_user_pastes", false);

/** EXTENSIONS ***/
user_pref("extensions.enabledScopes", 5);

/** HEADERS / REFERERS ***/
user_pref("network.http.referer.XOriginTrimmingPolicy", 2);

/** VARIOUS ***/
user_pref("pdfjs.enableScripting", false);

/** SAFE BROWSING ***/
user_pref("browser.safebrowsing.downloads.remote.enabled", false);

/** MOZILLA ***/
user_pref("permissions.default.desktop-notification", 2);
user_pref("permissions.default.geo", 2);
user_pref("geo.provider.network.url", "https://beacondb.net/v1/geolocate");
user_pref("browser.search.update", false);
user_pref("permissions.manager.defaultsUrl", "");
user_pref("extensions.getAddons.cache.enabled", false);

/** TELEMETRY ***/
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.server", "data:,");
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("toolkit.telemetry.newProfilePing.enabled", false);
user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
user_pref("toolkit.telemetry.updatePing.enabled", false);
user_pref("toolkit.telemetry.bhrPing.enabled", false);
user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);
user_pref("toolkit.telemetry.coverage.opt-out", true);
user_pref("toolkit.coverage.opt-out", true);
user_pref("toolkit.coverage.endpoint.base", "");
user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
user_pref("browser.newtabpage.activity-stream.telemetry", false);
user_pref("datareporting.usage.uploadEnabled", false);

/** EXPERIMENTS ***/
user_pref("app.shield.optoutstudies.enabled", false);
user_pref("app.normandy.enabled", false);
user_pref("app.normandy.api_url", "");
user_pref("nimbus.rollouts.enabled", false);

/** CRASH REPORTS ***/
user_pref("breakpad.reportURL", "");
user_pref("browser.tabs.crashReporting.sendReport", false);
user_pref("browser.crashReports.unsubmittedCheck.enabled", false);

/****************************************************************************
 * SECTION: PESKYFOX                                                        *
****************************************************************************/
/** MOZILLA UI ***/
user_pref("extensions.getAddons.showPane", false);
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);
user_pref("browser.discovery.enabled", false);
user_pref("browser.shell.checkDefaultBrowser", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);
user_pref("browser.preferences.moreFromMozilla", false);
user_pref("browser.aboutConfig.showWarning", false);
user_pref("browser.startup.homepage_override.mstone", "ignore");
user_pref("browser.aboutwelcome.enabled", false);
user_pref("browser.profiles.enabled", true);

/** THEME ADJUSTMENTS ***/
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("browser.compactmode.show", true);
user_pref("browser.privateWindowSeparation.enabled", false); // WINDOWS

/** AI ***/
user_pref("browser.ai.control.default", "blocked");
user_pref("browser.ml.enable", false);
user_pref("browser.ml.chat.enabled", false);
user_pref("browser.ml.chat.menu", false);
user_pref("browser.tabs.groups.smart.enabled", false);
user_pref("browser.ml.linkPreview.enabled", false);

/** FULLSCREEN NOTICE ***/
user_pref("full-screen-api.transition-duration.enter", "0 0");
user_pref("full-screen-api.transition-duration.leave", "0 0");
user_pref("full-screen-api.warning.timeout", 0);

/** URL BAR ***/
user_pref("browser.urlbar.trending.featureGate", false);

/** NEW TAB PAGE ***/
user_pref("browser.newtabpage.activity-stream.default.sites", "");
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredCheckboxes", false);

/** DOWNLOADS ***/
user_pref("browser.download.manager.addToRecentDocs", false);

/** PDF ***/
user_pref("browser.download.open_pdf_attachments_inline", true);

/** TAB BEHAVIOR ***/
user_pref("browser.bookmarks.openInTabClosesMenu", false);
user_pref("findbar.highlightAll", true);

/****************************************************************************
 * SECTION: SMOOTHFOX                                                       *
****************************************************************************/
// visit https://github.com/yokoffing/Betterfox/blob/main/Smoothfox.js
// Enter your scrolling overrides below this line:


/****************************************************************************
 * START: MY OVERRIDES                                                      *
****************************************************************************/
// visit https://github.com/yokoffing/Betterfox/wiki/Common-Overrides
// visit https://github.com/yokoffing/Betterfox/wiki/Optional-Hardening
// Enter your personal overrides below this line:

user_pref("accessibility.browsewithcaret_shortcut.enabled", false);
user_pref("accessibility.force_disabled", 1);
user_pref("browser.cache.jsbc_compression_level", 3);
user_pref("browser.contentblocking.category", "custom");
//user_pref("browser.contentblocking.category", "standard");
user_pref("browser.download.alwaysOpenPanel", false);
user_pref("browser.download.autohideButton", false);
user_pref("browser.download.manager.scanWhenDone", false);
user_pref("browser.engagement.downloads-button.has-used", true);
user_pref("browser.ml.chat.enabled", false);
user_pref("browser.ml.chat.menu", false);
user_pref("browser.ml.chat.page", false);
user_pref("browser.ml.chat.page.footerBadge", false);
user_pref("browser.ml.chat.page.menuBadge", false);
user_pref("browser.ml.checkForMemory", false);
user_pref("browser.ml.enable", false);
user_pref("browser.ml.linkPreview.enabled", false);
user_pref("browser.ml.linkPreview.shift", false);
user_pref("browser.ml.pageAssist.enabled", false);
user_pref("browser.ml.smartAssist.enabled", false);
user_pref("browser.newtabpage.activity-stream.filterAdult", true);
user_pref("browser.newtabpage.activity-stream.newtabLayouts.variant-a", false);
user_pref("browser.newtabpage.activity-stream.newtabLayouts.variant-b", false);
user_pref("browser.newtabpage.activity-stream.newtabShortcuts.refresh", false);
user_pref("browser.newtabpage.activity-stream.telemetry.structuredIngestion.endpoint", "");
user_pref("browser.ping-centre.telemetry", false);
user_pref("browser.preferences.defaultPerformanceSettings.enabled", false);
user_pref("browser.proton.contextmenus.enabled", 0);
user_pref("browser.proton.doorhangers.enabled", 0);
user_pref("browser.proton.enabled", 0);
user_pref("browser.proton.modals.enabled", 0);
user_pref("browser.safebrowsing.downloads.enabled", false);
user_pref("browser.safebrowsing.malware.enabled", false);
user_pref("browser.safebrowsing.phishing.enabled", false);
user_pref("browser.search.visualSearch.featureGate", false);
user_pref("browser.selfsupport.url", "");
user_pref("browser.sessionstore.interval", 150000);
user_pref("browser.startup.preXulSkeletonUI", false);
user_pref("browser.tabs.groups.enabled", false);
user_pref("browser.tabs.hoverPreview.showThumbnails", false);
user_pref("browser.tabs.loadBookmarksInTabs", true);
user_pref("browser.tabs.tabmanager.enabled", false);
user_pref("browser.taskbarTabs.enabled", false);
user_pref("browser.translations.automaticallyPopup", false);
user_pref("browser.translations.enable", false);
user_pref("browser.urlbar.suggest.recentsearches", false);
user_pref("browser.urlbar.suggest.trending", false);
user_pref("browser.vpn_promo.enabled", false);
user_pref("datareporting.policy.firstRunURL", "");
user_pref("datareporting.sessions.current.clean", false);
user_pref("devtools.onboarding.telemetry.logged", false);
user_pref("dom.allow_scripts_to_close_windows", true);
user_pref("dom.ipc.plugins.flash.subprocess.crashreporter.enabled", false);
user_pref("dom.ipc.processPriorityManager.backgroundUsesEcoQoS", false);
user_pref("dom.serviceWorkers.enabled", false);
user_pref("dom.webnotifications.serviceworker.enabled", false);
user_pref("experiments.activeExperiment", false);
user_pref("experiments.enabled", false);
user_pref("experiments.supported", false);
user_pref("extensions.ml.enabled", false);
user_pref("extensions.pocket.onSaveRecs", false);
//user_pref("full-screen-api.transition-duration.enter", 50);
//user_pref("full-screen-api.transition-duration.leave", 50);
user_pref("gfx.color_management.mode", 1);
user_pref("gfx.webrender.compositor", false);
user_pref("gtk-enable-animations", false);
user_pref("layers.acceleration.disabled", true);
user_pref("layout.css.prefers-color-scheme.content-override", 1);
user_pref("media.autoplay.blocking_policy", 2);
user_pref("media.gpu-process-decoder", false);
user_pref("media.hardwaremediakeys.enabled", false);
user_pref("media.hardware-video-decoding.enabled", false);
user_pref("media.peerconnection.enabled", false);
user_pref("media.videocontrols.picture-in-picture.video-toggle.has-used", true);
user_pref("narrate.filter-voices", false);
user_pref("network.allow-experiments", false);
user_pref("network.captive-portal-service.enabled", false);
user_pref("network.dns.disableIPv6", true);
user_pref("network.http.http3.enable", false);
//user_pref("network.trr.custom_uri", "");
//user_pref("network.trr.mode", 0);
//user_pref("network.trr.uri", "");
user_pref("pdfjs.enableAltText", false);
user_pref("permissions.default.geo", 0);
user_pref("places.semanticHistory.featureGate", false);
//user_pref("security.family_safety.mode", false);
user_pref("services.sync.prefs.sync.browser.safebrowsing.downloads.enabled", false);
user_pref("sidebar.animation.enabled", false);
user_pref("sidebar.revamp", false);
user_pref("toolkit.telemetry.hybridContent.enabled", false);
user_pref("toolkit.telemetry.prompted", 2);
user_pref("toolkit.telemetry.rejected", false);
user_pref("toolkit.telemetry.unifiedIsOptIn", false);
user_pref("ui.prefersReducedMotion", 1);
user_pref("webgl.disabled", true);
user_pref("browser.download.skipConfirmLaunchExecutable", true);
user_pref("browser.nova.enabled", false);
user_pref("sidebar.animation.expand-on-hover.delay-duration-ms", 10);
user_pref("sidebar.animation.expand-on-hover.duration-ms", 100);
user_pref("gfx.webrender.quality.force-subpixel-aa-where-possible", true);
user_pref("gfx.font_rendering.cleartype_params.rendering_mode", 5);
user_pref("gfx.font_rendering.cleartype_params.cleartype_level", 100);
user_pref("gfx.font_rendering.cleartype_params.force_gdi_classic_for_families", ""); // DEFAULT FF135+
user_pref("gfx.font_rendering.directwrite.use_gdi_table_loading", false);
user_pref("gfx.font_rendering.cleartype_params.gamma", 1750);
user_pref("gfx.font_rendering.cleartype_params.enhanced_contrast", 100);
user_pref("gfx.font_rendering.cleartype_params.pixel_structure", 1);
user_pref("browser.urlbar.weather.ignoreVPN", false);
user_pref("extensions.pocket.showHome", false);
user_pref("extensions.pocket.oAuthConsumerKey", " ");
user_pref("reader.parse-on-load.enabled", false);
user_pref("security.app_menu.recordEventTelemetry", false);
user_pref("security.certerrors.mitm.priming.enabled", false);
user_pref("security.certerrors.recordEventTelemetry", false);
user_pref("security.protectionspopup.recordEventTelemetry", false);
user_pref("signon.recipes.remoteRecipes.enabled", false);
user_pref("privacy.trackingprotection.emailtracking.data_collection.enabled", false);
user_pref("extensions.abuseReport.enabled", false);
user_pref("devtools.accessibility.enabled", false);
user_pref("app.update.BITS.enabled", false);
user_pref("dom.fs.enabled", false);
user_pref("dom.fs.writable_file_stream.enabled", false);
user_pref("browser.sessionstore.restore_pinned_tabs_on_demand", true);
user_pref("javascript.options.baselinejit.threshold", 50);
user_pref("network.buffer.cache.size", 65535);
user_pref("network.buffer.cache.count", 48);
user_pref("javascript.options.concurrent_multiprocess_gcs.cpu_divisor", 2);
user_pref("view_source.wrap_long_lines", true);
user_pref("devtools.debugger.ui.editor-wrapping", true);
user_pref("gfx.content.skia-font-cache-size", 20);
user_pref("gfx.canvas.accelerated.cache-size", 512);
user_pref("network.http.max-connections", 1800);
user_pref("network.http.max-persistent-connections-per-server", 10);
user_pref("network.http.max-urgent-start-excessive-connections-per-host", 5)
user_pref("network.http.request.max-start-delay", 5);
user_pref("network.dnsCacheEntries", 1600);
user_pref("browser.contentblocking.report.show_mobile_app", false);
user_pref("browser.search.widget.new", false);
user_pref("webgl.disable-angle", true);
user_pref("telemetry.glean.enabled", false);
//ran-sama
clearPref("app.installation.timestamp");
clearPref("app.normandy.user_id");
clearPref("beacon.enabled");
clearPref("browser.contextual-services.contextId");
clearPref("browser.newtabpage.activity-stream.impressionId");
clearPref("browser.search.totalSearches");
clearPref("datareporting.dau.cachedUsageProfileGroupID");
clearPref("datareporting.dau.cachedUsageProfileID");
clearPref("dom.push.connection.enabled");
clearPref("dom.push.enabled");
clearPref("dom.push.serverURL");
clearPref("dom.push.userAgentID");
clearPref("nimbus.profileId");
clearPref("toolkit.telemetry.cachedClientID");
clearPref("toolkit.telemetry.cachedProfileGroupID");
user_pref("accessibility.typeaheadfind.flashBar", 0);
user_pref("alerts.useSystemBackend", false);
user_pref("alerts.useSystemBackend.windows.notificationserver.enabled", false);
user_pref("browser.ai.control.default", "blocked");
user_pref("browser.aiwindow.apiKey", "");
user_pref("browser.aiwindow.enabled", false);
user_pref("browser.aiwindow.endpoint", "");
user_pref("browser.aiwindow.firstrun.modelChoice", "");
user_pref("browser.aiwindow.insights", false);
user_pref("browser.aiwindow.model", "");
user_pref("browser.contentanalysis.default_allow", false);
user_pref("browser.contentanalysis.default_result", 0);
user_pref("browser.contentanalysis.enabled", false);
user_pref("browser.contentanalysis.interception_point.clipboard.enabled", false);
user_pref("browser.contentanalysis.interception_point.download.enabled", false);
user_pref("browser.contentanalysis.interception_point.drag_and_drop.enabled", false);
user_pref("browser.contentanalysis.interception_point.file_upload.enabled", false);
user_pref("browser.contentanalysis.interception_point.print.enabled", false);
user_pref("browser.contentanalysis.max_connections", 0);
user_pref("browser.crashReports.unsubmittedCheck.autoSubmit2", false);
user_pref("browser.crashReports.unsubmittedCheck.autoSubmit", false);
user_pref("browser.crashReports.unsubmittedCheck.enabled", false);
user_pref("browser.disableResetPrompt", true);
user_pref("browser.firefox-view.feature-tour", "{\"screen\":\"\",\"complete\":true}");
user_pref("browser.firefox-view.search.enabled", false);
user_pref("browser.firefox-view.virtual-list.enabled", false);
user_pref("browser.history.collectWireframes", false);
user_pref("browser.ipProtection.enabled", false);
user_pref("browser.ipProtection.guardian.endpoint", "");
user_pref("browser.ipProtection.optedOut", true);
user_pref("browser.laterrun.enabled", false);
user_pref("browser.messaging-system.whatsNewPanel.enabled", false);
user_pref("browser.ml.chat.prompt.prefix", "");
user_pref("browser.ml.chat.prompts.0", "");
user_pref("browser.ml.chat.prompts.1", "");
user_pref("browser.ml.chat.prompts.2", "");
user_pref("browser.ml.chat.prompts.3", "");
user_pref("browser.ml.chat.prompts.4", "");
user_pref("browser.ml.chat.provider", "");
user_pref("browser.ml.chat.shortcuts.custom", false);
user_pref("browser.ml.chat.shortcuts", false);
user_pref("browser.ml.chat.sidebar", false);
user_pref("browser.ml.linkPreview.optin", false);
user_pref("browser.ml.modelHubRootUrl", "");
user_pref("browser.ml.smartAssist.endpoint", "");
user_pref("browser.newtabpage.activity-stream.asrouter.providers.snippets", "");
user_pref("browser.newtabpage.activity-stream.discoverystream.config", "");
user_pref("browser.newtabpage.activity-stream.discoverystream.contextualContent.enabled", false);
user_pref("browser.newtabpage.activity-stream.discoverystream.contextualContent.fakespot.enabled", false);
user_pref("browser.newtabpage.activity-stream.discoverystream.enabled", false);
user_pref("browser.newtabpage.activity-stream.discoverystream.endpoints", "");
user_pref("browser.newtabpage.activity-stream.discoverystream.endpointSpocsClear", "");
user_pref("browser.newtabpage.activity-stream.discoverystream.imageProxy.enabled", false);
user_pref("browser.newtabpage.activity-stream.discoverystream.merino-provider.enabled", false);
user_pref("browser.newtabpage.activity-stream.discoverystream.merino-provider.endpoint", "");
user_pref("browser.newtabpage.activity-stream.discoverystream.merino-provider.ohttp.enabled", false);
user_pref("browser.newtabpage.activity-stream.discoverystream.ohttp.configURL", "");
user_pref("browser.newtabpage.activity-stream.discoverystream.ohttp.relayURL", "");
user_pref("browser.newtabpage.activity-stream.discoverystream.personalization.enabled", false);
user_pref("browser.newtabpage.activity-stream.discoverystream.personalization.modelKeys", "");
user_pref("browser.newtabpage.activity-stream.discoverystream.placements.spocs", "");
user_pref("browser.newtabpage.activity-stream.discoverystream.placements.tiles", "");
user_pref("browser.newtabpage.activity-stream.discoverystream.promoCard.enabled", false);
user_pref("browser.newtabpage.activity-stream.discoverystream.promoCard.visible", false);
user_pref("browser.newtabpage.activity-stream.discoverystream.sections.cards.enabled", false);
user_pref("browser.newtabpage.activity-stream.discoverystream.sections.cards.thumbsUpDown.enabled", false);
user_pref("browser.newtabpage.activity-stream.discoverystream.sections.contextualAds.enabled", false);
user_pref("browser.newtabpage.activity-stream.discoverystream.sections.enabled", false);
user_pref("browser.newtabpage.activity-stream.discoverystream.sections.interestPicker.enabled", false);
user_pref("browser.newtabpage.activity-stream.discoverystream.sections.personalization.enabled", false);
user_pref("browser.newtabpage.activity-stream.discoverystream.sections.personalization.inferred.enabled", false);
user_pref("browser.newtabpage.activity-stream.discoverystream.sections.personalization.inferred.user.enabled", false);
user_pref("browser.newtabpage.activity-stream.discoverystream.sections.topicSelection.enabled", false);
user_pref("browser.newtabpage.activity-stream.discoverystream.shortcuts.personalization.enabled", false);
user_pref("browser.newtabpage.activity-stream.discoverystream.spocs.personalized", false);
user_pref("browser.newtabpage.activity-stream.discoverystream.spocs.startupCache.enabled", false);
user_pref("browser.newtabpage.activity-stream.discoverystream.spocTopsitesPlacement.enabled", false);
user_pref("browser.newtabpage.activity-stream.discoverystream.topicLabels.enabled", false);
user_pref("browser.newtabpage.activity-stream.externalComponents.enabled", false);
user_pref("browser.newtabpage.activity-stream.feeds.adsfeed", false);
user_pref("browser.newtabpage.activity-stream.feeds.externalcomponentsfeed", false);
user_pref("browser.newtabpage.activity-stream.feeds.inferredpersonalizationfeed", false);
user_pref("browser.newtabpage.activity-stream.feeds.newtabmessaging", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.highlights", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories.options", "");
user_pref("browser.newtabpage.activity-stream.feeds.smartshortcutsfeed", false);
user_pref("browser.newtabpage.activity-stream.feeds.snippets", "");
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref("browser.newtabpage.activity-stream.feeds.trendingsearchfeed", false);
user_pref("browser.newtabpage.activity-stream.feeds.weatherfeed", false);
user_pref("browser.newtabpage.activity-stream.images.smart", false);
user_pref("browser.newtabpage.activity-stream.newtabAdSize.billboard", false);
user_pref("browser.newtabpage.activity-stream.newtabAdSize.leaderboard", false);
user_pref("browser.newtabpage.activity-stream.newtabLogo.aprilfools", false);
user_pref("browser.newtabpage.activity-stream.newtabWallpapers.customColor.enabled", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeBookmarks", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeDownloads", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includePocket", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeVisited", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredCheckboxes", false);
user_pref("browser.newtabpage.activity-stream.sov.enabled", false);
user_pref("browser.newtabpage.activity-stream.system.trendingSearch.enabled", false);
user_pref("browser.newtabpage.activity-stream.telemetry.privatePing.enabled", false);
user_pref("browser.newtabpage.activity-stream.telemetry.privatePing.inferredInterests.enabled", false);
user_pref("browser.newtabpage.activity-stream.telemetry.privatePing.redactNewtabPing.enabled", false);
user_pref("browser.newtabpage.activity-stream.telemetry.ut.events", false);
user_pref("browser.newtabpage.activity-stream.trendingSearch.enabled", false);
user_pref("browser.newtabpage.activity-stream.unifiedAds.adsFeed.enabled", false);
user_pref("browser.newtabpage.activity-stream.unifiedAds.adsFeed.spocs.enabled", false);
user_pref("browser.newtabpage.activity-stream.unifiedAds.adsFeed.tiles.enabled", false);
user_pref("browser.newtabpage.activity-stream.unifiedAds.endpoint", "");
user_pref("browser.newtabpage.activity-stream.unifiedAds.ohttp.enabled", false);
user_pref("browser.newtabpage.activity-stream.unifiedAds.spocs.enabled", false);
user_pref("browser.newtabpage.activity-stream.unifiedAds.tiles.enabled", false);
user_pref("browser.newtabpage.activity-stream.weather.locationSearchEnabled", false);
user_pref("browser.newtabpage.activity-stream.weather.staticData.enabled", false);
user_pref("browser.newtabpage.activity-stream.widgets.enabled", false);
user_pref("browser.newtabpage.activity-stream.widgets.system.weatherForecast.enabled", false);
user_pref("browser.newtabpage.activity-stream.widgets.weatherForecast.enabled", false);
user_pref("browser.newtabpage.trainhopAddon.xpiBaseURL", "");
user_pref("browser.pagethumbnails.capturing_disabled", true);
user_pref("browser.promo.focus.enabled", false);
user_pref("browser.promo.pin.enabled", false);
user_pref("browser.safebrowsing.downloads.remote.block_dangerous", false);
user_pref("browser.safebrowsing.downloads.remote.block_dangerous_host", false);
user_pref("browser.safebrowsing.downloads.remote.block_potentially_unwanted", false);
user_pref("browser.safebrowsing.downloads.remote.block_uncommon", false);
user_pref("browser.safebrowsing.downloads.remote.url", "");
user_pref("browser.safebrowsing.provider.google4.advisoryURL", "");
user_pref("browser.safebrowsing.provider.google4.dataSharing.enabled", false);
user_pref("browser.safebrowsing.provider.google4.dataSharingURL", "");
user_pref("browser.safebrowsing.provider.google4.gethashURL", "");
user_pref("browser.safebrowsing.provider.google4.lists", "");
user_pref("browser.safebrowsing.provider.google4.reportMalwareMistakeURL", "");
user_pref("browser.safebrowsing.provider.google4.reportPhishMistakeURL", "");
user_pref("browser.safebrowsing.provider.google4.reportURL", "");
user_pref("browser.safebrowsing.provider.google4.updateURL", "");
user_pref("browser.safebrowsing.provider.google5.advisoryURL", "");
user_pref("browser.safebrowsing.provider.google5.enabled", false);
user_pref("browser.safebrowsing.provider.google5.gethashURL", "");
user_pref("browser.safebrowsing.provider.google5.lists", "");
user_pref("browser.safebrowsing.provider.google5.updateURL", "");
user_pref("browser.safebrowsing.provider.google.advisoryURL", "");
user_pref("browser.safebrowsing.provider.google.gethashURL", "");
user_pref("browser.safebrowsing.provider.google.lists", "");
user_pref("browser.safebrowsing.provider.google.reportMalwareMistakeURL", "");
user_pref("browser.safebrowsing.provider.google.reportPhishMistakeURL", "");
user_pref("browser.safebrowsing.provider.google.reportURL", "");
user_pref("browser.safebrowsing.provider.google.updateURL", "");
user_pref("browser.safebrowsing.provider.mozilla.gethashURL", "");
user_pref("browser.safebrowsing.provider.mozilla.lists", "");
user_pref("browser.safebrowsing.provider.mozilla.updateURL", "");
user_pref("browser.safebrowsing.reportPhishURL", "");
user_pref("browser.search.serpEventTelemetryCategorization.enabled", false);
user_pref("browser.search.serpEventTelemetry.enabled", false);
user_pref("browser.search.serpMetricsRecordedCounter", 0);
user_pref("browser.search.suggest.enabled.private", false);
user_pref("browser.search.suggest.ohttp.enabled", false);
user_pref("browser.search.suggest.ohttp.featureGate", false);
user_pref("browser.send_pings", false);
user_pref("browser.shopping.experience2023.active", false);
user_pref("browser.shopping.experience2023.ads.enabled", false);
user_pref("browser.shopping.experience2023.ads.userEnabled", false);
user_pref("browser.shopping.experience2023.autoClose.userEnabled", false);
user_pref("browser.shopping.experience2023.autoOpen.enabled", false);
user_pref("browser.shopping.experience2023.autoOpen.userEnabled", false);
user_pref("browser.shopping.experience2023.enabled", false);
user_pref("browser.shopping.experience2023.integratedSidebar", false);
user_pref("browser.shopping.experience2023.optedIn", 0);
user_pref("browser.shopping.experience2023.shoppingSidebar", false);
user_pref("browser.shopping.experience2023.survey.enabled", false);
user_pref("browser.spin_cursor_while_busy", false);
user_pref("browser.startup.homepage_override.mstone", "ignore");
user_pref("browser.startup.windowsLaunchOnLogin.disableLaunchOnLoginPrompt", true);
user_pref("browser.startup.windowsLaunchOnLogin.enabled", false);
user_pref("browser.tabs.firefox-view", false);
user_pref("browser.tabs.firefox-view-newIcon", false);
user_pref("browser.tabs.firefox-view-next", false);
user_pref("browser.tabs.groups.smart.enabled", false);
user_pref("browser.tabs.groups.smart.optin", false);
user_pref("browser.tabs.groups.smart.searchTopicEnabled", false);
user_pref("browser.tabs.groups.smart.userEnabled", false);
user_pref("browser.tabs.hoverPreview.enabled", false);
user_pref("browser.tabs.unloadOnLowMemory", false);
user_pref("browser.termsofuse.prefMigrationCheck", true);
user_pref("browser.topsites.contile.enabled", false);
user_pref("browser.uitour.url", "");
user_pref("browser.urlbar.addons.featureGate", false);
user_pref("browser.urlbar.clipboard.featureGate", false);
user_pref("browser.urlbar.dnsResolveSingleWordsAfterSearch", 0);
user_pref("browser.urlbar.fakespot.featureGate", false);
user_pref("browser.urlbar.mdn.featureGate", false);
user_pref("browser.urlbar.merino.endpointURL", "");
user_pref("browser.urlbar.merino.ohttpConfigURL", "");
user_pref("browser.urlbar.merino.ohttpRelayURL", "");
user_pref("browser.urlbar.openViewOnFocus", false);
user_pref("browser.urlbar.pocket.featureGate", false);
user_pref("browser.urlbar.quicksuggest.ampMatchingStrategy", 0);
user_pref("browser.urlbar.quicksuggest.ampTopPickCharThreshold", 0);
user_pref("browser.urlbar.quicksuggest.contextualOptIn", false);
user_pref("browser.urlbar.quicksuggest.contextualOptIn.sayHello", false);
user_pref("browser.urlbar.quicksuggest.dataCollection.enabled", false);
user_pref("browser.urlbar.quicksuggest.mlEnabled", false);
user_pref("browser.urlbar.quicksuggest.online.available", false);
user_pref("browser.urlbar.quicksuggest.shouldShowOnboardingDialog", false);
user_pref("browser.urlbar.quicksuggest.sponsoredIndex", -1);
user_pref("browser.urlbar.recentsearches.featureGate", false);
user_pref("browser.urlbar.scotchBonnet.enableOverride", true);
user_pref("browser.urlbar.showSearchSuggestionsFirst", false);
user_pref("browser.urlbar.showSearchTerms.enabled", false);
user_pref("browser.urlbar.suggest.engines", false);
user_pref("browser.urlbar.suggest.fakespot", false);
user_pref("browser.urlbar.suggest.pocket", false);
user_pref("browser.urlbar.suggest.quicksuggest.nonsponsored", false);
user_pref("browser.urlbar.suggest.quicksuggest.sponsored", false);
user_pref("browser.urlbar.suggest.topsites", false);
user_pref("browser.urlbar.suggest.weather", false);
user_pref("browser.urlbar.suggest.yelp", false);
user_pref("browser.urlbar.trimHttps", false);
user_pref("browser.urlbar.trimURLs", false);
user_pref("browser.urlbar.weather.featureGate", false);
user_pref("browser.urlbar.yelp.featureGate", false);
user_pref("browser.urlbar.yelp.mlEnabled", false);
user_pref("browser.xul.error_pages.expert_bad_cert", true);
user_pref("captivedetect.canonicalURL", "");
user_pref("clipboard.copyPrivateDataToClipboardCloudOrHistory", false);
user_pref("dap.ohttp.hpke", "");
user_pref("dap.ohttp.relayURL", "");
user_pref("datareporting.healthreport.service.enabled", false);
user_pref("default-browser-agent.enabled", false);
user_pref("devtools.selfxss.count", 10);
user_pref("dom.block_download_insecure", false);
user_pref("dom.iframe_lazy_loading.enabled", false);
user_pref("dom.image-lazy-loading.enabled", false);
user_pref("dom.prefetch_dns_for_anchor_http_document", false);
user_pref("dom.prefetch_dns_for_anchor_https_document", false);
user_pref("dom.private-attribution.submission.enabled", false);
user_pref("dom.security.unexpected_system_load_telemetry_enabled", false);
user_pref("dom.webgpu.enabled", false);
user_pref("dom.webgpu.service-workers.enabled", false);
user_pref("dom.webnotifications.enabled", false);
user_pref("dom.webnotifications.privateBrowsing.enabled", false);
user_pref("extensions.experiments.enabled", false);
user_pref("extensions.formautofill.addresses.enabled", false);
user_pref("extensions.formautofill.available", "off");
user_pref("extensions.formautofill.creditCards.enabled", false);
user_pref("extensions.pocket.api", "");
user_pref("extensions.pocket.enabled", false);
user_pref("extensions.pocket.site", "");
user_pref("extensions.quarantinedDomains.enabled", false);
user_pref("extensions.recommendations.hideNotice", true);
user_pref("extensions.webcompat.smartblockEmbeds.enabled", false);
user_pref("extensions.webextensions.restrictedDomains", "");
user_pref("full-screen-api.warning.delay", -1);
user_pref("full-screen-api.warning.timeout", -1);
user_pref("general.warnOnAboutConfig", false);
user_pref("intl.accept_languages", "en-US, en");
user_pref("media.decoder.skip-to-next-key-frame.enabled", false);
user_pref("media.devices.enumerate.legacy.enabled", false);
user_pref("media.suspend-background-video.delay-ms", 900000);
user_pref("media.suspend-background-video.enabled", false);
user_pref("media.suspend-bkgnd-video.enabled", false);
user_pref("messaging-system.rsexperimentloader.collection_id", "");
user_pref("messaging-system.rsexperimentloader.enabled", false);
user_pref("network.connectivity-service.DNS_HTTPS.domain", "");
user_pref("network.connectivity-service.enabled", false);
//user_pref("network.cookie.cookieBehavior", 0);
//user_pref("network.cookie.lifetimePolicy", 2);
user_pref("network.dns.prefetch_via_proxy", false);
user_pref("network.http.dictionaries.enable", false);
user_pref("network.http.http3.enable_0rtt", false);
user_pref("network.http.http3.enable_kyber", true);
user_pref("network.http.throttle.enable", false);
user_pref("network.preconnect", false);
user_pref("network.predictor.enabled", false);
user_pref("network.predictor.enable-prefetch", false);
user_pref("network.trr.confirmation_telemetry_enabled", false);
user_pref("network.trr.mode", 5);
user_pref("network.trr.ohttp.config_uri", "");
user_pref("network.trr.ohttp.relay_uri", "");
user_pref("network.trr.ohttp.uri", "");
user_pref("network.trr.use_ohttp", false);
user_pref("nimbus.debug", false);
user_pref("nimbus.profilesdatastoreservice.enabled", false);
user_pref("nimbus.profilesdatastoreservice.read.enabled", false);
user_pref("nimbus.profilesdatastoreservice.sync.enabled", false);
user_pref("nimbus.rollouts.enabled", false);
user_pref("nimbus.telemetry.targetingContextEnabled", false);
user_pref("nimbus.validation.enabled", false);
user_pref("pdfjs.enableAltTextModelDownload", false);
user_pref("pdfjs.enableGuessAltText", false);
user_pref("pdfjs.enableML", false);
user_pref("pdfjs.enableNewAltTextWhenAddingImage", false);
user_pref("pdfjs.enableScripting", false);
user_pref("permissions.media.query.enabled", false);
user_pref("privacy.fingerprintingProtection.overrides", "-AllTargets,+PdfjsSpoof,+WindowOuterSize,+EfficientCanvasRandomization,+FontVisibilityBaseSystem,+MediaDevices,+SpeechSynthesis,+WebGLRenderInfo,+JSLocale,+NavigatorHWConcurrency");
user_pref("privacy.fingerprintingProtection.granularOverrides", "[{\"firstPartyDomain\":\"cloudflare.com\",\"overrides\":\"-AllTargets\"},{\"thirdPartyDomain\":\"cloudflare.com\",\"overrides\":\"-AllTargets\"},{\"firstPartyDomain\":\"debug.challenges.cloudflare.com\",\"overrides\":\"-AllTargets\"},{\"thirdPartyDomain\":\"debug.challenges.cloudflare.com\",\"overrides\":\"-AllTargets\"}]");
user_pref("privacy.fingerprintingProtection.pbmode", true);
user_pref("privacy.fingerprintingProtection.remoteOverrides.enabled", false);
user_pref("privacy.fingerprintingProtection", true);
user_pref("privacy.wallet_schemes", "");
user_pref("security.certerrors.mitm.auto_enable_enterprise_roots", false);
user_pref("security.certerrors.permanentOverride", false);
user_pref("security.dialog_enable_delay", 0);
user_pref("security.enterprise_roots.enabled", false);
user_pref("security.family_safety.mode", 0);
user_pref("security.insecure_connection_text.enabled", false);
user_pref("security.insecure_connection_text.pbmode.enabled", false);
user_pref("security.ssl.enable_false_start", false);
user_pref("security.ssl.require_safe_negotiation", true);
user_pref("security.ssl.treat_unsafe_negotiation_as_broken", true);
user_pref("security.tls.enable_0rtt_data", false);
user_pref("security.tls.enable_certificate_compression_abridged", true);
user_pref("security.tls.enable_kyber", true);
user_pref("security.tls.version.enable-deprecated", false);
user_pref("sidebar.animation.duration-ms", 0);
user_pref("sidebar.main.tools", "");
user_pref("sidebar.verticalTabs", false);
user_pref("sidebar.visibility", "hide-sidebar");
user_pref("startup.homepage_override_nimbus_disable_wnp", true);
user_pref("termsofuse.acceptedDate", "1900000000000");
user_pref("termsofuse.acceptedVersion", 9999);
user_pref("toolkit.shopping.environment", "");
user_pref("toolkit.shopping.experience2023.defr", false);
user_pref("toolkit.shopping.ohttpConfigURL", "");
user_pref("toolkit.shopping.ohttpRelayURL", "");
user_pref("toolkit.telemetry.dap_enabled", false);
user_pref("toolkit.telemetry.dap_helper", "");
user_pref("toolkit.telemetry.dap.helper.hpke", "");
user_pref("toolkit.telemetry.dap_helper_owner", "");
user_pref("toolkit.telemetry.dap.helper.url", "");
user_pref("toolkit.telemetry.dap_leader", "");
user_pref("toolkit.telemetry.dap.leader.hpke", "");
user_pref("toolkit.telemetry.dap_leader_owner", "");
user_pref("toolkit.telemetry.dap.leader.url", "");
user_pref("toolkit.telemetry.dap_task1_enabled", false);
user_pref("toolkit.telemetry.dap_visit_counting_enabled", false);
user_pref("toolkit.telemetry.dap_visit_counting_experiment_list", "[]");
user_pref("toolkit.telemetry.reportingpolicy.firstRun", false);
user_pref("toolkit.telemetry.server", "data:, ");
user_pref("toolkit.telemetry.shutdownPingSender.backgroundtask.enabled", false);
user_pref("toolkit.telemetry.shutdownPingSender.enabledFirstSession", false);
user_pref("toolkit.telemetry.user_characteristics_ping.opt-out", true);
user_pref("ui.caretBlinkCount", -1);
user_pref("widget.windows.window_occlusion_tracking_display_state.enabled", false);
user_pref("widget.windows.window_occlusion_tracking.enabled", false);
user_pref("widget.windows.window_occlusion_tracking_session_lock.enabled", false);
user_pref("identity.fxaccounts.telemetry.clientAssociationPing.enabled", false);
user_pref("browser.newtabpage.activity-stream.nova.enabled", false);
user_pref("browser.newtabpage.activity-stream.weather.hourlyEndpoint", "");
user_pref("browser.newtabpage.activity-stream.weather.reportEndpoint", "");
user_pref("browser.newtabpage.activity-stream.widgets.feedback.enabled", false);
user_pref("browser.smartwindow.memories.generateFromHistory", false);
user_pref("browser.urlbar.merino.weather.hourlyEndpointURL", "");
user_pref("browser.urlbar.merino.weather.reportEndpointURL", "");
user_pref("browser.urlbar.nova.featureGate", false);
user_pref("browser.smartwindow.nova.enabled", false);
user_pref("browser.urlbar.quicksuggest.ampTopPickUseNovaIconSize", false);
user_pref("browser.smartwindow.worldcup.enabled", false);
user_pref("browser.smartwindow.worldcup.endpointURL", "");
user_pref("browser.urlbar.resultExplanations.featureGate", false);
user_pref("network.trr.preconnect_on_foreground", false);
user_pref("browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts", false);
user_pref("browser.download.improvements_to_download_panel", false);
user_pref("browser.helperApps.deleteTempFileOnExit", true);
user_pref("browser.urlbar.sports.featureGate", false);
user_pref("browser.urlbar.importantDates.featureGate", false);
user_pref("browser.urlbar.amp.featureGate", false);
user_pref("browser.urlbar.yelpRealtime.featureGate", false);
user_pref("browser.urlbar.market.featureGate", false);
user_pref("browser.urlbar.flightStatus.featureGate", false);
user_pref("browser.preferences.aiControls.showUnavailable", true);
user_pref("browser.ai.control.linkPreviewKeyPoints", "blocked");
user_pref("browser.ai.control.pdfjsAltText", "blocked");
user_pref("browser.ai.control.sidebarChatbot", "blocked");
user_pref("browser.ai.control.smartTabGroups", "blocked");
user_pref("browser.ai.control.smartWindow", "blocked");
user_pref("browser.ai.control.translations", "blocked");
user_pref("browser.safebrowsing.globalCache.enabled", false);
user_pref("browser.safebrowsing.realTime.enabled", false);
user_pref("browser.smartwindow.enabled", false);
user_pref("browser.smartwindow.model", "");
user_pref("browser.smartwindow.endpoint", "");
user_pref("browser.smartwindow.preferences.endpoint", "");
user_pref("browser.smartwindow.memories.generateFromConversation", false);
user_pref("browser.contextual-services.contextId.rotation-in-days", 1);
user_pref("browser.fixup.alternate.enabled", false);
user_pref("browser.newtab.preload", false);
user_pref("browser.tabs.cardPreview.enabled", false);
user_pref("browser.tabs.groups.hoverPreview.enabled", false);
user_pref("browser.taskbar.lists.enabled", false);
user_pref("browser.theme.colorway-closet", false);
user_pref("browser.topsites.contile.endpoint", "");
user_pref("devtools.debugger.remote-enabled", false);
user_pref("network.http.network_error_logging.enabled", false);
user_pref("sidebar.notification.badge.aichat", false);
user_pref("sidebar.revamp.defaultLauncherVisible", false);
user_pref("toolkit.aboutLogging.uploadProfileToCloud", false);
user_pref("widget.windows.hide_cursor_when_typing", false);
user_pref("layout.css.scroll-state.enabled", false);
user_pref("media.hardware-video-decoding-vulkan.enabled", false);
user_pref("image.jxl.enabled", true);
user_pref("network.ssl_tokens_cache_persistence", false);
user_pref("apz.autoscroll.scroll_wheel_cooldown", 0);
user_pref("browser.shareqrcode.embed_logo", false);
user_pref("browser.shareqrcode.enabled", false);
user_pref("places.frecency.pages.alternative.featureGate", false);
user_pref("places.frecency.origins.alternative.featureGate", false);
user_pref("browser.urlbar.trustPanel.breachAlerts", false);
user_pref("browser.urlbar.trustPanel.breachAlerts.featureGate", false);
user_pref("browser.urlbar.contextMenu.featureGate", false);
user_pref("browser.toolbars.share-button.enabled", false);
user_pref("browser.smartwindow.allowTables", false);
user_pref("browser.newtabpage.activity-stream.widgets.system.sportsWidget.enabled", false);
user_pref("browser.newtabpage.activity-stream.widgets.system.clocks.enabled", false);
user_pref("browser.newtabpage.activity-stream.widgets.sportsWidget.live.enabled", false);
user_pref("browser.newtabpage.activity-stream.widgets.sportsWidget.interaction", false);
user_pref("browser.newtabpage.activity-stream.widgets.sportsWidget.enabled", false);
user_pref("browser.newtabpage.activity-stream.sports.worldCup.matchesEndpoint", "");
user_pref("browser.newtabpage.activity-stream.sports.worldCup.teamsEndpoint", "");
user_pref("browser.newtabpage.activity-stream.feeds.sportsfeed", false);
user_pref("browser.ipProtection.fxa.useActivateFlow", false);
user_pref("browser.ml.embedGen.textEmbeddingFeatureModel", false);
user_pref("browser.newtabpage.activity-stream.sports.worldCup.liveEndpoint", "");
user_pref("browser.newtabpage.activity-stream.sports.worldCup.watchLiveEndpoint", "");
user_pref("browser.newtabpage.activity-stream.widgets.row.expanded", false);
user_pref("browser.newtabpage.activity-stream.widgets.sports.forceLiveDataTrustable", false);
user_pref("browser.newtabpage.activity-stream.widgets.sportsWidget.celebrations.enabled", false);
user_pref("extensions.formautofill.useml", false);
user_pref("telemetry.fog.enable_fog_transport", false);
user_pref("browser.aboutwelcome.experimentsGate.enabled", false);
user_pref("browser.newtabpage.activity-stream.feeds.webnotificationsfeed", false);
user_pref("browser.newtabpage.activity-stream.unifiedAds.adsClient.enabled", false);
user_pref("browser.newtabpage.activity-stream.discoverystream.spocs-endpoint", "");
user_pref("browser.newtabpage.activity-stream.discoverystream.spocs-endpoint-query", "");
user_pref("browser.newtabpage.activity-stream.widgets.crossword.endpoint", "");
user_pref("browser.newtabpage.activity-stream.widgets.pictureOfTheDay.endpoint", "");
user_pref("browser.smartwindow.searchQuery.endpointURL", "");
user_pref("browser.referrals.enabled", false);
user_pref("browser.smartwindow.mistralRelease", false);
user_pref("browser.urlbar.suggest.amp", false);
user_pref("browser.urlbar.suggest.importantDates", false);
user_pref("browser.urlbar.suggest.sports", false);
user_pref("browser.urlbar.suggest.yelpRealtime", false);
user_pref("browser.urlbar.suggest.realtimeOptIn", false);
user_pref("browser.urlbar.suggest.quicksuggest.all", false);
user_pref("browser.urlbar.trustPanel.featureGate", false);
user_pref("browser.urlbar.yelp.serviceResultDistinction", false);
user_pref("privacy.trackingprotection.cryptomining.enabled", false);
user_pref("privacy.trackingprotection.fingerprinting.enabled", false);
user_pref("privacy.trackingprotection.pbmode.enabled", false);
user_pref("general.smoothScroll", false);
user_pref("browser.uidensity", 1);
user_pref("browser.urlbar.autoFill", false);
user_pref("browser.urlbar.unitConversion.enabled", false);
user_pref("browser.toolbars.bookmarks.visibility", "always");
user_pref("browser.tabs.splitView.enabled", false);
user_pref("sidebar.position_start", false);
user_pref("sidebar.expandOnHover", false);
user_pref("layout.css.scrollbar-width-thin.disabled", true);
user_pref("browser.ml.modelHub.testing", false);
user_pref("browser.newtabpage.activity-stream.discoverystream.spocs.onDemand", false);
user_pref("browser.newtabpage.activity-stream.logowordmark.alwaysVisible", false);
user_pref("browser.newtabpage.activity-stream.newtabWallpapers.enabled", false);
user_pref("browser.newtabpage.activity-stream.newtabWallpapers.user.enabled", false);
user_pref("browser.newtabpage.activity-stream.spaces.activityOptOut", true);
user_pref("browser.newtabpage.activity-stream.spaces.storiesOptOut", true);
user_pref("browser.newtabpage.activity-stream.spaces.widgetsOptOut", true);
user_pref("browser.newtabpage.activity-stream.system.showWeatherOptIn", false);
user_pref("browser.newtabpage.activity-stream.weather.optInAccepted", false);
user_pref("browser.newtabpage.activity-stream.widgets.lists.badge.enabled", false);
user_pref("browser.newtabpage.activity-stream.widgets.weather.enabled", false);
user_pref("browser.newtabpage.enabled", false);
user_pref("browser.promo.relay.enabled", false);
user_pref("browser.region.network.url", "");
user_pref("browser.region.update.enabled", false);
user_pref("browser.search.totalSearches", 0);
user_pref("browser.smartwindow.agent.enabled", false);
user_pref("browser.smartwindow.agent.toolbar.enabled", false);
user_pref("browser.smartwindow.aitab.enabled", false);
user_pref("browser.smartwindow.smartformfill.enabled", false);
user_pref("browser.taskbar.lists.frequent.enabled", false);
user_pref("browser.urlbar.newtab.featureGate", false);
user_pref("browser.urlbar.searchModeSwitcher.skipTabStop", false);
user_pref("browser.urlbar.share-button.enabled", false);
user_pref("browser.urlbar.trackerCount.featureGate", false);
user_pref("devtools.aboutdebugging.showHiddenAddons", true);
user_pref("extensions.formautofill.creditCards.cvv.enabled", false);
user_pref("extensions.formautofill.passports.enabled", false);
user_pref("network.connectivity-service.DNSv4.domain", "");
user_pref("network.connectivity-service.DNSv6.domain", "");
user_pref("network.connectivity-service.IPv4.url", "");
user_pref("network.connectivity-service.IPv6.url", "");
user_pref("nimbus.profileId", "");
user_pref("pdfjs.enabledCache.state", false);
user_pref("sidebar.openTabsPanel.hoverPreview.enabled", false);
user_pref("browser.ai.control.speechRecognition", "blocked");
user_pref("browser.contentanalysis.interception_point.clipboard_copy.enabled", false);
user_pref("browser.contentblocking.customBlockList.preferences.ui.enabled", true);
user_pref("browser.highlightToSearch.featureGate", false);
user_pref("browser.highlightToSearch.search.enabled", false);
user_pref("browser.newtabpage.activity-stream.discoverystream.sections.topicNavigation.enabled", false);
user_pref("browser.newtabpage.activity-stream.improvesearch.handoffToAwesomebar", false);
user_pref("browser.newtabpage.activity-stream.newtabWallpapers.customWallpaper.library.enabled", false);
user_pref("browser.newtabpage.activity-stream.topSitesGroupedPins", false);
user_pref("browser.newtabpage.activity-stream.widgets.clocks.enabled", false);
user_pref("browser.newtabpage.activity-stream.widgets.crossword.enabled", false);
user_pref("browser.newtabpage.activity-stream.widgets.focusTimer.enabled", false);
user_pref("browser.newtabpage.activity-stream.widgets.lists.enabled", false);
user_pref("browser.newtabpage.activity-stream.widgets.marketGate.enabled", false);
user_pref("browser.newtabpage.activity-stream.widgets.marketGate.enforceOnNightly", false);
user_pref("browser.newtabpage.activity-stream.widgets.pictureOfTheDay.enabled", false);
user_pref("browser.newtabpage.activity-stream.widgets.recentSearches.enabled", false);
user_pref("browser.newtabpage.activity-stream.widgets.stocks.enabled", false);
user_pref("browser.newtabpage.activity-stream.widgets.system.enabled", false);
user_pref("browser.preonboarding.enabled", false);
user_pref("browser.privateWindowRedesign.enabled", false);
user_pref("browser.safebrowsing.blockedURIs.enabled", false);
user_pref("browser.safebrowsing.provider.mozilla.lists.base", "");
user_pref("browser.safebrowsing.provider.mozilla.lists.content", "");
user_pref("browser.smartwindow.agent.monitorAnnouncement", false);
user_pref("browser.smartwindow.resumeActivity.enabled", false);
user_pref("browser.smartwindow.resumeCards.enabled", false);
user_pref("browser.smartwindow.searchTheWebAnswers", false);
user_pref("browser.usedOnWindows10.introURL", "");
user_pref("datareporting.healthreport.documentServerURI", "");
user_pref("datareporting.healthreport.logging.consoleEnabled", false);
user_pref("datareporting.healthreport.service.firstRun", false);
user_pref("datareporting.policy.dataSubmissionPolicyAccepted", false);
user_pref("dom.reporting.enabled", false);
user_pref("dom.reporting.featurePolicy.enabled", false);
user_pref("dom.reporting.permissionsPolicy.enabled", false);
user_pref("privacy.trackingprotection.emailtracking.pbmode.enabled", false);
user_pref("telemetry.fog.enable_store_submitted_pings", false);
user_pref("telemetry.fog.init_on_shutdown", false);
user_pref("telemetry.fog.test.decelerate_early_events", false);
user_pref("telemetry.fog.test.localhost_port", -1);
user_pref("termsofuse.bypassNotification", true);
user_pref("urlclassifier.enabled_mode", 0);

user_pref("browser.search.separatePrivateDefault.featureGate", false);
user_pref("extensions.formautofill.useml.features", "[]");
user_pref("media.webspeech.recognition.enable", false);
user_pref("browser.urlbar.newtab.variantA", false);
user_pref("browser.urlbar.newtab.variantB", false);
user_pref("network.http.akamai_waf_telemetry.enabled", false);
user_pref("media.lazy_loading.enabled", false);
user_pref("browser.urlbar.suggest.temporal", false);
user_pref("browser.urlbar.suggest.temporal.seasonal", false);
user_pref("browser.urlbar.temporal.featureGate", false);
user_pref("browser.newtabpage.activity-stream.feeds.extensionwidgetsfeed", false);
user_pref("browser.newtabpage.activity-stream.feeds.travelfeed", false);
user_pref("browser.newtabpage.activity-stream.widgets.system.travel.enabled", false);
user_pref("browser.newtabpage.activity-stream.widgets.travel.enabled", false);
user_pref("browser.newtabpage.activity-stream.widgets.travel.interaction", false);
user_pref("browser.newtabpage.activity-stream.unifiedAds.tiles.ohttpImages.enabled", false);
user_pref("browser.newtabpage.activity-stream.widgets.solitaire.enabled", false);
user_pref("browser.newtabpage.activity-stream.widgets.solitaire.interaction", false);
user_pref("browser.newtabpage.activity-stream.widgets.system.solitaire.enabled", false);
user_pref("browser.newtabpage.activity-stream.widgets.horoscopes.enabled", false);
user_pref("browser.newtabpage.activity-stream.widgets.horoscopes.interaction", false);
user_pref("browser.newtabpage.activity-stream.widgets.horoscopes.size", false);
user_pref("browser.newtabpage.activity-stream.widgets.system.horoscopes.enabled", false);
user_pref("browser.smartwindow.location.enabled", false);
user_pref("threads.lower_mainthread_priority_in_background.enabled", false);
user_pref("threads.use_low_power.enabled", false);

user_pref("browser.urlbar.shortcuts.bookmarks", false);
user_pref("browser.urlbar.shortcuts.history", false);
user_pref("browser.urlbar.shortcuts.tabs", false);
user_pref("browser.smartwindow.aitab.menus", false);

/****************************************************************************
 * END: BETTERFOX                                                           *
****************************************************************************/
