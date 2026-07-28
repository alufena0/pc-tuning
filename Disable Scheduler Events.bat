@echo off
if "%~1" neq "running" (start "" /b cmd /c "%~f0" running & exit /b) else (cd /d "%~dp0")
setlocal
::schtasks /Change /TN "\CreateExplorerShellUnelevatedTask" /Disable
::schtasks /Change /TN "\CreateExplorerShellUnelevatedTask" /Enable
for /f "skip=1 usebackq tokens=1 delims=," %%a in (`schtasks /query /fo CSV`) do (echo "%%~a" | findstr /i "GoogleUpdateTaskUser" >nul && schtasks /delete /tn "%%~a" /f)
schtasks /delete /tn "\Microsoft\Windows\PerformanceTrace\ShowFeedbackToast" /f
schtasks /delete /tn "XFSET-SetPanelDimensions" /f
schtasks /delete /tn "SimulateTouchService" /f
schtasks /delete /tn "EqualizerAPOUpdateChecker" /f
schtasks /delete /tn "klcp_update" /f
schtasks /delete /tn "MicrosoftEdgeUpdateTaskMachineCore" /f
schtasks /delete /tn "MicrosoftEdgeUpdateTaskMachineUA" /f
schtasks /delete /tn "MSIAfterburner" /f
schtasks /delete /tn "\Microsoft\Windows\HelloFace\FODCleanupTask" /f
schtasks /delete /tn "RazerCortexScheduleClean" /f
schtasks /delete /tn "PDFXChangeAutoUpdate" /f
schtasks /delete /tn "CCleanerSkipUAC - Administrator" /f
schtasks /Delete /TN "\Microsoft\Windows\Deduplication\BackgroundOptimization" /F
schtasks /Delete /TN "\Microsoft\Windows\Deduplication\WeeklyGarbageCollection" /F
schtasks /Delete /TN "\Microsoft\Windows\Deduplication\WeeklyScrubbing" /F
schtasks /Change /TN "\Microsoft\Windows\UpdateOrchestrator\Schedule Wake To Work" /Disable
schtasks /Change /TN "\Microsoft\OneDrive\OneDrive Reporting Task" /Disable
schtasks /Change /TN "\Microsoft\OneDrive\OneDrive Standalone Update Task" /Disable
schtasks /Change /TN "OneDrive Per-Machine Standalone Update" /Disable
schtasks /Change /TN "\Intel PTT EK Recertification" /Disable
schtasks /Change /TN "\IntelSURQC-Upgrade-86621605-2a0b-4128-8ffc-15514c247132" /Disable
schtasks /Change /TN "\IntelSURQC-Upgrade-86621605-2a0b-4128-8ffc-15514c247132-Logon" /Disable
schtasks /Change /TN "\MicrosoftEdgeUpdateBrowserReplacementTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\Location\Notifications" /Disable
schtasks /Change /TN "\Microsoft\Windows\ReFsRedupSvc\Initialization" /Disable
schtasks /Change /TN "\Microsoft\Windows\Shell\sSyncedImageDownload" /Disable
schtasks /Change /TN "\Microsoft\Office\Office 15 Subscription Heartbeat" /Disable
schtasks /Change /TN "\Microsoft\Windows\Sysmain\ResPriStaticDbSync" /Disable
schtasks /Change /TN "\Microsoft\Office\Office Actions Server" /Disable
schtasks /Change /TN "\Microsoft\Office\Office Automatic Updates 2.0" /Disable
schtasks /Change /TN "\Microsoft\Windows\Security\Pwdless\IntelligentPwdlessTask" /Disable
schtasks /Change /TN "\Microsoft\Office\Office Automatic Updates" /Disable
schtasks /Change /TN "\Microsoft\Office\Office ClickToRun Service Monitor" /Disable
schtasks /Change /TN "\Microsoft\Office\Office Feature Updates" /Disable
schtasks /Change /TN "\Microsoft\Office\Office Feature Updates Logon" /Disable
schtasks /Change /TN "\Microsoft\Office\OfficeTelemetryAgentFallBack2016" /Disable
schtasks /Change /TN "\Microsoft\Office\OfficeTelemetryAgentFallBack" /Disable
schtasks /Change /TN "\Microsoft\Office\OfficeTelemetryAgentLogOn2016" /Disable
schtasks /Change /TN "\Microsoft\Office\OfficeTelemetryAgentLogOn" /Disable
::schtasks /Change /TN "\Microsoft\OneCore\DirectX\DirectXDatabaseUpdater" /Disable
schtasks /Change /TN "\Microsoft\OneCore\DirectX\DirectXDatabaseUpdater" /Enable
schtasks /Change /TN "\Microsoft\VisualStudio\Updates\BackgroundDownload" /Disable
schtasks /Change /TN "\Microsoft\Windows\AccountHealth\RecoverabilityToastTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\Active Directory Rights Management Services Client\AD RMS Rights Policy Template Management (Automated)" /Disable
schtasks /Change /TN "\Microsoft\Windows\Active Directory Rights Management Services Client\AD RMS Rights Policy Template Management (Manual)" /Disable
schtasks /Change /TN "\Microsoft\Windows\AI\AIAgentUpdateTask" /Disable
schtasks /Change /TN "\Microsoft\WindowsAI\Office Actions Server" /Disable
schtasks /Change /TN "\Microsoft\Windows\AppID\EDP Policy Manager" /Disable
schtasks /Change /TN "\Microsoft\Windows\AppID\PolicyConverter" /Disable
schtasks /Change /TN "\Microsoft\Windows\AppID\SmartScreenSpecific" /Disable
schtasks /Change /TN "\Microsoft\Windows\AppID\VerifiedPublisherCertStoreCheck" /Disable
schtasks /Change /TN "\Microsoft\Windows\ApplicationData\appuriverifierdaily" /Disable
schtasks /Change /TN "\Microsoft\Windows\ApplicationData\appuriverifierinstall" /Disable
schtasks /Change /TN "\Microsoft\Windows\ApplicationData\CleanupTemporaryState" /Disable
schtasks /Change /TN "\Microsoft\Windows\ApplicationData\DsSvcCleanup" /Disable
schtasks /Change /TN "\Microsoft\Windows\Application Experience\AitAgent" /Disable
schtasks /Change /TN "\Microsoft\Windows\Application Experience\MareBackup" /Disable
schtasks /Change /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable
schtasks /Change /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser Exp" /Disable
schtasks /Change /TN "\Microsoft\Windows\Application Experience\PcaPatchDbTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\Application Experience\ProgramDataUpdater" /Disable
schtasks /Change /TN "\Microsoft\Windows\Application Experience\SdbinstMergeDbTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\Application Experience\StartupAppTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\AppListBackup\Backup" /Disable
schtasks /Change /TN "\Microsoft\Windows\AppListBackup\BackupNonMaintenance" /Disable
schtasks /Change /TN "\Microsoft\Windows\AppxDeploymentClient\Pre-staged app cleanup" /Disable
schtasks /Change /TN "\Microsoft\Windows\AppxDeploymentClient\Ucpd Velocity" /Disable
schtasks /Change /TN "\Microsoft\Windows\Autochk\Proxy" /Disable
schtasks /Change /TN "\Microsoft\Windows\BitLocker\BitLocker Encrypt All Drives" /Disable
schtasks /Change /TN "\Microsoft\Windows\BitLocker\BitLocker MDM policy Refresh" /Disable
schtasks /Change /TN "\Microsoft\Windows\Bluetooth\UninstallDeviceTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\BrokerInfrastructure\BgTaskRegistrationMaintenanceTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\CapabilityAccessManager\MaintenanceTasks" /Disable
schtasks /Change /TN "\Microsoft\Windows\CertificateServicesClient\AikCertEnrollTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\CertificateServicesClient\CryptoPolicyTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\CertificateServicesClient\KeyPreGenTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\CertificateServicesClient\SystemTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\CertificateServicesClient\UserTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\CertificateServicesClient\UserTask-Roam" /Disable
schtasks /Change /TN "\Microsoft\Windows\Chkdsk\ProactiveScan" /Disable
schtasks /Change /TN "\Microsoft\Windows\Chkdsk\SyspartRepair" /Disable
::schtasks /Change /TN "\Microsoft\Windows\Clip\LicenseImdsIntegration" /Disable
::schtasks /Change /TN "\Microsoft\Windows\Clip\License Validation" /Disable
schtasks /Change /TN "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\CloudRestore\Backup" /Disable
schtasks /Change /TN "\Microsoft\Windows\CloudRestore\Restore" /Disable
schtasks /Change /TN "\Microsoft\Windows\ConsentUX\UnifiedConsent\UnifiedConsentSyncTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\Containers\CmCleanup" /Disable
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\BthSQM" /Disable
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\Uploader" /Disable
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable
schtasks /Change /TN "\Microsoft\Windows\Data Integrity Scan\Data Integrity Check And Scan" /Disable
schtasks /Change /TN "\Microsoft\Windows\Data Integrity Scan\Data Integrity Scan" /Disable
schtasks /Change /TN "\Microsoft\Windows\Data Integrity Scan\Data Integrity Scan for Crash Recovery" /Disable
schtasks /Change /TN "\Microsoft\Windows\Defrag\ScheduledDefrag" /Disable
schtasks /Change /TN "\Microsoft\Windows\DeviceDirectoryClient\HandleCommand" /Disable
schtasks /Change /TN "\Microsoft\Windows\DeviceDirectoryClient\HandleWnsCommand" /Disable
schtasks /Change /TN "\Microsoft\Windows\DeviceDirectoryClient\IntegrityCheck" /Disable
schtasks /Change /TN "\Microsoft\Windows\DeviceDirectoryClient\LocateCommandUserSession" /Disable
schtasks /Change /TN "\Microsoft\Windows\DeviceDirectoryClient\RegisterDeviceAccountChange" /Disable
schtasks /Change /TN "\Microsoft\Windows\DeviceDirectoryClient\RegisterDeviceLocationRightsChange" /Disable
schtasks /Change /TN "\Microsoft\Windows\DeviceDirectoryClient\RegisterDevicePeriodic24" /Disable
schtasks /Change /TN "\Microsoft\Windows\DeviceDirectoryClient\RegisterDevicePolicyChange" /Disable
schtasks /Change /TN "\Microsoft\Windows\DeviceDirectoryClient\RegisterDeviceProtectionStateChanged" /Disable
schtasks /Change /TN "\Microsoft\Windows\DeviceDirectoryClient\RegisterDeviceSettingChange" /Disable
schtasks /Change /TN "\Microsoft\Windows\DeviceDirectoryClient\RegisterUserDevice" /Disable
schtasks /Change /TN "\Microsoft\Windows\Device Information\Device" /Disable
schtasks /Change /TN "\Microsoft\Windows\Device Information\Device User" /Disable
schtasks /Change /TN "\Microsoft\Windows\Device Setup\Driver Recovery on Reboot" /Disable
schtasks /Change /TN "\Microsoft\Windows\Device Setup\Metadata Refresh" /Disable
schtasks /Change /TN "\Microsoft\Windows\Diagnosis\RecommendedTroubleshootingScanner" /Disable
schtasks /Change /TN "\Microsoft\Windows\Diagnosis\Scheduled" /Disable
schtasks /Change /TN "\Microsoft\Windows\Diagnosis\UnexpectedCodepath" /Disable
::schtasks /Change /TN "\Microsoft\Windows\DirectX\DirectXDatabaseUpdater" /Disable
::schtasks /Change /TN "\Microsoft\Windows\DirectX\DXGIAdapterCache" /Disable
schtasks /Change /TN "\Microsoft\Windows\DirectX\DirectXDatabaseUpdater" /Enable
schtasks /Change /TN "\Microsoft\Windows\DirectX\DXGIAdapterCache" /Enable
schtasks /Change /TN "\Microsoft\Windows\DiskCleanup\SilentCleanup" /Disable
schtasks /Change /TN "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable
schtasks /Change /TN "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticResolver" /Disable
schtasks /Change /TN "\Microsoft\Windows\DiskFootprint\Diagnostics" /Disable
schtasks /Change /TN "\Microsoft\Windows\DiskFootprint\StorageSense" /Disable
schtasks /Change /TN "\Microsoft\Windows\DUSM\DusmTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\EDP\EDP App Launch Task" /Disable
schtasks /Change /TN "\Microsoft\Windows\EDP\EDP Auth Task" /Disable
schtasks /Change /TN "\Microsoft\Windows\EDP\EDP Inaccessible Credentials Task" /Disable
schtasks /Change /TN "\Microsoft\Windows\EDP\StorageCardEncryption Task" /Disable
schtasks /Change /TN "\Microsoft\Windows\EnterpriseMgmt\MDMMaintenenceTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\ErrorDetails\EnableErrorDetailsUpdate" /Disable
schtasks /Change /TN "\Microsoft\Windows\ExploitGuard\ExploitGuard MDM policy Refresh" /Disable
schtasks /Change /TN "\Microsoft\Windows\Feedback\Siuf\DmClient" /Disable
schtasks /Change /TN "\Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" /Disable
schtasks /Change /TN "\Microsoft\Windows\File Classification Infrastructure\Property Definition Sync" /Disable
schtasks /Change /TN "\Microsoft\Windows\FileHistory\File History (maintenance mode)" /Disable
schtasks /Change /TN "\Microsoft\Windows\Flighting\FeatureConfig\BootstrapUsageDataReporting" /Disable
schtasks /Change /TN "\Microsoft\Windows\Flighting\FeatureConfig\GovernedFeatureUsageProcessing" /Disable
schtasks /Change /TN "\Microsoft\Windows\Flighting\FeatureConfig\ReconcileConfigs" /Disable
schtasks /Change /TN "\Microsoft\Windows\Flighting\FeatureConfig\ReconcileFeatures" /Disable
schtasks /Change /TN "\Microsoft\Windows\Flighting\FeatureConfig\UsageDataFlushing" /Disable
schtasks /Change /TN "\Microsoft\Windows\Flighting\FeatureConfig\UsageDataReceiver" /Disable
schtasks /Change /TN "\Microsoft\Windows\Flighting\FeatureConfig\UsageDataReporting" /Disable
schtasks /Change /TN "\Microsoft\Windows\Flighting\OneSettings\RefreshCache" /Disable
schtasks /Change /TN "\Microsoft\Windows\Hotpatch\Monitoring" /Disable
schtasks /Change /TN "\Microsoft\Windows\Input\InputSettingsRestoreDataAvailable" /Disable
schtasks /Change /TN "\Microsoft\Windows\Input\LocalUserSyncDataAvailable" /Disable
schtasks /Change /TN "\Microsoft\Windows\Input\MouseSyncDataAvailable" /Disable
schtasks /Change /TN "\Microsoft\Windows\Input\PenSyncDataAvailable" /Disable
schtasks /Change /TN "\Microsoft\Windows\Input\RemoteMouseSyncDataAvailable" /Disable
schtasks /Change /TN "\Microsoft\Windows\Input\RemotePenSyncDataAvailable" /Disable
schtasks /Change /TN "\Microsoft\Windows\Input\RemoteTouchpadSyncDataAvailable" /Disable
schtasks /Change /TN "\Microsoft\Windows\Input\SyncPenSettings" /Disable
schtasks /Change /TN "\Microsoft\Windows\Input\TouchpadSyncDataAvailable" /Disable
schtasks /Change /TN "\Microsoft\Windows\InstallService\RestoreDevice" /Disable
schtasks /Change /TN "\Microsoft\Windows\InstallService\ScanForUpdatesAsUser" /Disable
schtasks /Change /TN "\Microsoft\Windows\InstallService\ScanForUpdates" /Disable
schtasks /Change /TN "\Microsoft\Windows\InstallService\SmartRetry" /Disable
schtasks /Change /TN "\Microsoft\Windows\InstallService\WakeUpAndContinueUpdates" /Disable
schtasks /Change /TN "\Microsoft\Windows\InstallService\WakeUpAndScanForUpdates" /Disable
schtasks /Change /TN "\Microsoft\Windows\International\Synchronize Language Settings" /Disable
schtasks /Change /TN "\Microsoft\Windows\Kernel\La57Cleanup" /Disable
schtasks /Change /TN "\Microsoft\Windows\LanguageComponentsInstaller\Installation" /Disable
schtasks /Change /TN "\Microsoft\Windows\LanguageComponentsInstaller\ReconcileLanguageResources" /Disable
schtasks /Change /TN "\Microsoft\Windows\LanguageComponentsInstaller\Uninstallation" /Disable
schtasks /Change /TN "\Microsoft\Windows\License Manager\TempSignedLicenseExchange" /Disable
schtasks /Change /TN "\Microsoft\Windows\Live\Roaming\MaintenanceTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\Live\Roaming\SynchronizeWithStorage" /Disable
schtasks /Change /TN "\Microsoft\Windows\Location\WindowsActionDialog" /Disable
schtasks /Change /TN "\Microsoft\Windows\Maintenance\WinSAT" /Disable
schtasks /Change /TN "\Microsoft\Windows\Management\Autopilot\DetectHardwareChange" /Disable
schtasks /Change /TN "\Microsoft\Windows\Management\Autopilot\RemediateHardwareChange" /Disable
schtasks /Change /TN "\Microsoft\Windows\Management\Connectivity\ESIMPM" /Disable
schtasks /Change /TN "\Microsoft\Windows\Management\Provisioning\Cellular" /Disable
schtasks /Change /TN "\Microsoft\Windows\Management\Provisioning\Logon" /Disable
schtasks /Change /TN "\Microsoft\Windows\Management\Provisioning\MdmDiagnosticsCleanup" /Disable
schtasks /Change /TN "\Microsoft\Windows\Management\Provisioning\PostResetBoot" /Disable
schtasks /Change /TN "\Microsoft\Windows\Management\Provisioning\Retry" /Disable
schtasks /Change /TN "\Microsoft\Windows\Management\Provisioning\RunOnReboot" /Disable
schtasks /Change /TN "\Microsoft\Windows\Maps\MapsToastTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\Maps\MapsUpdateTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\MemoryDiagnostic\AutomaticOfflineMemoryDiagnostic" /Disable
schtasks /Change /TN "\Microsoft\Windows\MemoryDiagnostic\CorruptionDetector" /Disable
schtasks /Change /TN "\Microsoft\Windows\MemoryDiagnostic\DecompressionFailureDetector" /Disable
schtasks /Change /TN "\Microsoft\Windows\MemoryDiagnostic\MemUsageTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\MemoryDiagnostic\ProcessMemoryDiagnosticEvents" /Disable
schtasks /Change /TN "\Microsoft\Windows\MemoryDiagnostic\RunFullMemoryDiagnostic" /Disable
schtasks /Change /TN "\Microsoft\Windows\Mobile Broadband Accounts\MNO Metadata Parser" /Disable
schtasks /Change /TN "\Microsoft\Windows\MUI\LpRemove" /Disable
schtasks /Change /TN "\Microsoft\Windows\Multimedia\SystemSoundsService" /Disable
schtasks /Change /TN "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319 64 Critical" /Disable
schtasks /Change /TN "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319 64" /Disable
schtasks /Change /TN "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319 Critical" /Disable
schtasks /Change /TN "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319" /Disable
schtasks /Change /TN "\Microsoft\Windows\NetTrace\GatherNetworkInfo" /Disable
schtasks /Change /TN "\Microsoft\Windows\Network Connectivity Status Indicator\NcsiIdentifyUserProxies" /Disable
schtasks /Change /TN "\Microsoft\Windows\NetworkExperimentation" /Disable
schtasks /Change /TN "\Microsoft\Windows\NlaSvc\WiFiTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\Offline Files\Background Synchronization" /Disable
schtasks /Change /TN "\Microsoft\Windows\Offline Files\Logon Synchronization" /Disable
schtasks /Change /TN "\Microsoft\Windows\PCRPF\PCR Prediction Framework Firmware Update Task" /Disable
schtasks /Change /TN "\Microsoft\Windows\PerformanceTrace\RequestTrace" /Disable
schtasks /Change /TN "\Microsoft\Windows\PerformanceTrace\WhesvcToast" /Disable
schtasks /Change /TN "\Microsoft\Windows\PI\Secure-Boot-Update" /Disable
schtasks /Change /TN "\Microsoft\Windows\PI\Sqm-Tasks" /Disable
schtasks /Change /TN "\Microsoft\Windows\PLA\System\ConvertLogEntries" /Disable
schtasks /Change /TN "\Microsoft\Windows\Plug and Play\Device Install Group Policy" /Disable
schtasks /Change /TN "\Microsoft\Windows\Plug and Play\Device Install Reboot Required" /Disable
schtasks /Change /TN "\Microsoft\Windows\Plug and Play\Sysprep Generalize Drivers" /Disable
schtasks /Change /TN "\Microsoft\Windows\Pluton\Pluton-Ksp-Provisioning" /Disable
schtasks /Change /TN "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" /Disable
schtasks /Change /TN "\Microsoft\Windows\Printing\EduPrintProv" /Disable
schtasks /Change /TN "\Microsoft\Windows\Printing\PrinterCleanupTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\Printing\PrintJobCleanupTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\PushToInstall\LoginCheck" /Disable
schtasks /Change /TN "\Microsoft\Windows\PushToInstall\Registration" /Disable
schtasks /Change /TN "\Microsoft\Windows\RAC\RacTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\Ras\MobilityManager" /Disable
schtasks /Change /TN "\Microsoft\Windows\RecoveryEnvironment\VerifyWinRE" /Disable
schtasks /Change /TN "\Microsoft\Windows\ReFsDedupSvc\Initialization" /Disable
schtasks /Change /TN "\Microsoft\Windows\Registry\RegIdleBackup" /Disable
schtasks /Change /TN "\Microsoft\Windows\Registry\rgnupdt-cleanup" /Disable
schtasks /Change /TN "\Microsoft\Windows\Registry\rgnupdt-run" /Disable
schtasks /Change /TN "\Microsoft\Windows\RemoteAssistance\RemoteAssistanceTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\RetailDemo\CleanupOfflineContent" /Disable
schtasks /Change /TN "\Microsoft\Windows\Sense\InstallSenseClient" /Disable
schtasks /Change /TN "\Microsoft\Windows\Servicing\OOBEFodSetup" /Disable
schtasks /Change /TN "\Microsoft\Windows\Servicing\StartComponentCleanup" /Disable
schtasks /Change /TN "\Microsoft\Windows\SettingSync\BackgroundUploadTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\SettingSync\BackupTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\SettingSync\NetworkStateChangeTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\Setup\SetupCleanupTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\Setup\SnapshotCleanupTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\SharedPC\Account Cleanup" /Disable
schtasks /Change /TN "\Microsoft\Windows\Shell\CrawlStartPages" /Disable
schtasks /Change /TN "\Microsoft\Windows\Shell\FamilySafetyMonitor" /Disable
schtasks /Change /TN "\Microsoft\Windows\Shell\FamilySafetyMonitorToastTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\Shell\FamilySafetyRefresh" /Disable
schtasks /Change /TN "\Microsoft\Windows\Shell\FamilySafetyRefreshTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\Shell\FamilySafetyUpload" /Disable
schtasks /Change /TN "\Microsoft\Windows\Shell\IndexerAutomaticMaintenance" /Disable
schtasks /Change /TN "\Microsoft\Windows\Shell\ThemeAssetTask_SyncFODState" /Disable
schtasks /Change /TN "\Microsoft\Windows\Shell\ThemesSyncedImageDownload" /Disable
schtasks /Change /TN "\Microsoft\Windows\Shell\UpdateUserPictureTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\SoftwareProtectionPlatform\SvcRestartTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\SOFTWAREProtectionPlatform\SvcRestartTaskLogon" /Disable
schtasks /Change /TN "\Microsoft\Windows\SOFTWAREProtectionPlatform\SvcRestartTaskNetwork" /Disable
schtasks /Change /TN "\Microsoft\Windows\SpacePort\SpaceAgentTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\SpacePort\SpaceManagerTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\Speech\SpeechModelDownloadTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\StateRepository\MaintenanceTasks" /Disable
schtasks /Change /TN "\Microsoft\Windows\Storage Tiers Management\Storage Tiers Management Initialization" /Disable
schtasks /Change /TN "\Microsoft\Windows\Storage Tiers Management\Storage Tiers Optimization" /Disable
::schtasks /Change /TN "\Microsoft\Windows\Subscription\EnableLicenseAcquisition" /Disable
::schtasks /Change /TN "\Microsoft\Windows\Subscription\LicenseAcquisition" /Disable
schtasks /Change /TN "\Microsoft\Windows\Sustainability\PowerGridForecastTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\Sustainability\SustainabilityTelemetry" /Disable
schtasks /Change /TN "\Microsoft\Windows\Sysmain\HybridDriveCachePrepopulate" /Disable
schtasks /Change /TN "\Microsoft\Windows\Sysmain\HybridDriveCacheRebalance" /Disable
schtasks /Change /TN "\Microsoft\Windows\Sysmain\ResPrioStaticDbSync" /Disable
schtasks /Change /TN "\Microsoft\Windows\Sysmain\WsSwapAssessmentTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\SystemRestore\SR" /Disable & rem system restore frequency off
::schtasks /Change /TN "\Microsoft\Windows\SystemRestore\SR" /Enable & rem system restore frequency on
schtasks /Change /TN "\Microsoft\Windows\Task Manager\Interactive" /Disable
schtasks /Change /TN "\Microsoft\Windows\TaskScheduler\Idle Maintenance" /Disable
schtasks /Change /TN "\Microsoft\Windows\TaskScheduler\Maintenance Configurator" /Disable
schtasks /Change /TN "\Microsoft\Windows\TaskScheduler\Manual Maintenance" /Disable
schtasks /Change /TN "\Microsoft\Windows\TaskScheduler\Regular Maintenance" /Disable
schtasks /Change /TN "\Microsoft\Windows\TextServicesFramework\MsCtfMonitor" /Disable
schtasks /Change /TN "\Microsoft\Windows\Time Synchronization\ForceSynchronizeTime" /Disable
schtasks /Change /TN "\Microsoft\Windows\Time Synchronization\SynchronizeTime" /Disable
schtasks /Change /TN "\Microsoft\Windows\Time Zone\SynchronizeTimeZone" /Disable
schtasks /Change /TN "\Microsoft\Windows\TPM\Tpm-HascertRetr" /Disable
schtasks /Change /TN "\Microsoft\Windows\TPM\Tpm-Maintenance" /Disable
schtasks /Change /TN "\Microsoft\Windows\TPM\Tpm-PreAttestationHealthCheck" /Disable
schtasks /Change /TN "\Microsoft\Windows\UNP\RunUpdateNotificationMgr" /Disable
schtasks /Change /TN "\Microsoft\Windows\UpdateOrchestrator\Report policies" /Disable
schtasks /Change /TN "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan" /Disable
schtasks /Change /TN "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan Static Task" /Disable
schtasks /Change /TN "\Microsoft\Windows\UpdateOrchestrator\Schedule Work" /Disable
::schtasks /Change /TN "\Microsoft\Windows\UpdateOrchestrator\StartOobeAppsScanAfterUpdate" /Disable
::schtasks /Change /TN "\Microsoft\Windows\UpdateOrchestrator\StartOobeAppsScan_LicenseAccepted" /Disable
::schtasks /Change /TN "\Microsoft\Windows\UpdateOrchestrator\StartOobeAppsScan_OobeAppReady" /Disable
::schtasks /Change /TN "\Microsoft\Windows\UpdateOrchestrator\Start Oobe Expedite Work" /Disable
::schtasks /Change /TN "\Microsoft\Windows\UpdateOrchestrator\UIEOrchestrator" /Disable
schtasks /Change /TN "\Microsoft\Windows\UpdateOrchestrator\UpdateModelTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\UpdateOrchestrator\USO_UxBroker" /Disable
::schtasks /Change /TN "\Microsoft\Windows\UpdateOrchestrator\UUS Failover Task" /Disable
schtasks /Change /TN "\Microsoft\Windows\UPnP\UPnPHostConfig" /Disable
schtasks /Change /TN "\Microsoft\Windows\USB\Usb-Notifications" /Disable
schtasks /Change /TN "\Microsoft\Windows\User Experience\AmbientExperienceTasks" /Disable
schtasks /Change /TN "\Microsoft\Windows\User Profile Service\HiveUploadTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\WaaSMedic\PerformRemediation" /Disable
schtasks /Change /TN "\Microsoft\Windows\WCM\WiFiTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\WDI\ResolutionHost" /Disable
::schtasks /Change /TN "\Microsoft\Windows\Windows Activation Technologies\ValidationTaskDeadline" /Disable
::schtasks /Change /TN "\Microsoft\Windows\Windows Activation Technologies\ValidationTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\WindowsBackup\ConfigNotification" /Disable
schtasks /Change /TN "\Microsoft\Windows\WindowsColorSystem\Calibration Loader" /Disable
schtasks /Change /TN "\Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance" /Disable
schtasks /Change /TN "\Microsoft\Windows\Windows Defender\Windows Defender Cleanup" /Disable
schtasks /Change /TN "\Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" /Disable
schtasks /Change /TN "\Microsoft\Windows\Windows Defender\Windows Defender Verification" /Disable
schtasks /Change /TN "\Microsoft\Windows\Windows Error Reporting\QueueReporting" /Disable
schtasks /Change /TN "\Microsoft\Windows\Windows Filtering Platform\BfeOnServiceStartTypeChange" /Disable
schtasks /Change /TN "\Microsoft\Windows\Windows Media Sharing\UpdateLibrary" /Disable
schtasks /Change /TN "\Microsoft\Windows\Windows Subsystem For Linux\AptPackageIndexUpdate" /Disable
schtasks /Change /TN "\Microsoft\Windows\WindowsUpdate\Automatic App Update" /Disable
::schtasks /Change /TN "\Microsoft\Windows\WindowsUpdate\Refresh Group Policy Cache" /Disable
schtasks /Change /TN "\Microsoft\Windows\WindowsUpdate\Scheduled Start" /Disable
::schtasks /Change /TN "\Microsoft\Windows\WindowsUpdate\sihboot" /Disable
schtasks /Change /TN "\Microsoft\Windows\Wininet\CacheTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\WlanSvc\CdsSync" /Disable
schtasks /Change /TN "\Microsoft\Windows\WlanSvc\MoProfileManagement" /Disable
schtasks /Change /TN "\Microsoft\Windows\Wof\Wim-Hash-Management" /Disable
schtasks /Change /TN "\Microsoft\Windows\Wof\Wim-Hash-Validation" /Disable
schtasks /Change /TN "\Microsoft\Windows\Work Folders\Work Folders Logon Synchronization" /Disable
schtasks /Change /TN "\Microsoft\Windows\Work Folders\Work Folders Maintenance Work" /Disable
schtasks /Change /TN "\Microsoft\Windows\Workplace Join\Automatic-Device-Join" /Disable
schtasks /Change /TN "\Microsoft\Windows\Workplace Join\Device-Sync" /Disable
schtasks /Change /TN "\Microsoft\Windows\Workplace Join\Recovery-Check" /Disable
::schtasks /Change /TN "\Microsoft\Windows\WS\Badge Update" /Disable
::schtasks /Change /TN "\Microsoft\Windows\WS\License Validation" /Disable
::schtasks /Change /TN "\Microsoft\Windows\WS\Sync Licenses" /Disable
::schtasks /Change /TN "\Microsoft\Windows\WS\WSRefreshBannedAppsListTask" /Disable
::schtasks /Change /TN "\Microsoft\Windows\WS\WSTask" /Disable
schtasks /change /tn "\Microsoft\Windows\WindowsAI\ClickToDo\ModelCachingIdle" /disable
schtasks /change /tn "\Microsoft\Windows\WindowsAI\ClickToDo\ModelCachingLimit" /disable
schtasks /change /tn "\Microsoft\Windows\WindowsAI\ClickToDo\ModelCachingUpdate" /disable
schtasks /Change /TN "\Microsoft\Windows\WwanSvc\NotificationTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\WwanSvc\OobeDiscovery" /Disable
schtasks /Change /TN "\Microsoft\XblGameSave\XblGameSaveTask" /Disable
schtasks /Change /TN "\Microsoft\XblGameSave\XblGameSaveTaskLogon" /Disable
schtasks /Change /TN "\Mozilla\Firefox Default Browser Agent 308046B0AF4A39CB" /disable
schtasks /Change /TN "\Mozilla\Firefox Background Update 308046B0AF4A39CB" /disable
schtasks /Change /TN "\NvDriverUpdateCheckDaily_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" /Disable
schtasks /Change /TN "\NVIDIA GeForce Experience SelfUpdate_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" /Disable
schtasks /Change /TN "\NvTmMon_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" /Disable
schtasks /Change /TN "\NvTmRep_CrashReport1_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" /Disable
schtasks /Change /TN "\NvTmRep_CrashReport2_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" /Disable
schtasks /Change /TN "\NvTmRep_CrashReport3_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" /Disable
schtasks /Change /TN "\NvTmRep_CrashReport4_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" /Disable
schtasks /Change /TN "\PowerToys\Autorun for Administrator" /Disable
schtasks /Change /TN "\Ubisoft\Ubisoft Connect Background Update" /Disable
schtasks /Change /TN "\USER_ESRV_SVC_QUEENCREEK" /Disable
schtasks /Delete /TN "\AMDInstallLauncher" /F
schtasks /Delete /TN "\AMD Install Manager - Check For Updates" /F
schtasks /Delete /TN "\AMD Install Manager - Install Updates" /F
schtasks /Delete /TN "\AMDInstallUEP" /F
schtasks /Delete /TN "\AMDLinkUpdate" /F
schtasks /Delete /TN "\AMDRyzenMasterSDKTask" /F
schtasks /Delete /TN "\DUpdaterTask" /F
schtasks /Delete /TN "\Microsoft\Windows\WindowsAI\Recall\InitialConfiguration" /F
schtasks /Delete /TN "\Microsoft\Windows\WindowsAI\Recall\PolicyConfiguration" /F
schtasks /Delete /TN "\ModifyLinkUpdate" /F
schtasks /Delete /TN "\StartAUEP" /F
schtasks /Delete /TN "\StartCNBM" /F
schtasks /Delete /TN "\StartCN" /F
schtasks /Delete /TN "\StartDVR" /F
powershell -Command "Get-ScheduledTask | Where-Object { $_.TaskName -like 'MEGAsync Update Task*' } | ForEach-Object { Disable-ScheduledTask -TaskName $_.TaskName -TaskPath $_.TaskPath }" >nul 2>&1
powershell -Command "Get-ScheduledTask | Where-Object { $_.TaskName -like 'GoogleUpdaterTaskSystem*' } | ForEach-Object { Disable-ScheduledTask -TaskName $_.TaskName -TaskPath $_.TaskPath }" >nul 2>&1
powershell -Command "Get-ScheduledTask | Where-Object { $_.TaskName -like 'Firefox Default Browser Agent*' } | ForEach-Object { Disable-ScheduledTask -TaskName $_.TaskName -TaskPath $_.TaskPath }" >nul 2>&1
for /f "tokens=1 delims=," %%t in ('schtasks /Query /FO CSV ^| find /v "TaskName" ^| find "NvTmMon"') do schtasks /Change /TN "%%~t" /Disable >nul 2>&1
for /f "tokens=1 delims=," %%t in ('schtasks /Query /FO CSV ^| find /v "TaskName" ^| find "NvTmRep"') do schtasks /Change /TN "%%~t" /Disable >nul 2>&1
for /f "tokens=1 delims=," %%t in ('schtasks /Query /FO CSV ^| find /v "TaskName" ^| find "NvTmRepOnLogon"') do schtasks /Change /TN "%%~t" /Disable >nul 2>&1
for /f "tokens=1 delims=," %%t in ('schtasks /Query /FO CSV ^| find /v "TaskName" ^| find "NvProfileUpdaterDaily"') do schtasks /Change /TN "%%~t" /Disable >nul 2>&1
for /f "tokens=1 delims=," %%t in ('schtasks /Query /FO CSV ^| find /v "TaskName" ^| find "NvDriverUpdateCheckDaily"') do schtasks /Change /TN "%%~t" /Disable >nul 2>&1
for /f "tokens=1 delims=," %%t in ('schtasks /Query /FO CSV ^| find /v "TaskName" ^| find "NVIDIA GeForce Experience SelfUpdate"') do schtasks /Change /TN "%%~t" /Disable >nul 2>&1
for /f "tokens=1 delims=," %%t in ('schtasks /Query /FO CSV ^| find /v "TaskName" ^| find "NvTmRep_CrashReport1"') do schtasks /Change /TN "%%~t" /Disable >nul 2>&1
for /f "tokens=1 delims=," %%t in ('schtasks /Query /FO CSV ^| find /v "TaskName" ^| find "NvTmRep_CrashReport2"') do schtasks /Change /TN "%%~t" /Disable >nul 2>&1
for /f "tokens=1 delims=," %%t in ('schtasks /Query /FO CSV ^| find /v "TaskName" ^| find "NvTmRep_CrashReport3"') do schtasks /Change /TN "%%~t" /Disable >nul 2>&1
for /f "tokens=1 delims=," %%t in ('schtasks /Query /FO CSV ^| find /v "TaskName" ^| find "NvTmRep_CrashReport4"') do schtasks /Change /TN "%%~t" /Disable >nul 2>&1
for /f "tokens=1 delims=," %%t in ('schtasks /Query /FO CSV ^| find /v "TaskName" ^| find "NvProfileUpdaterOnLogon"') do schtasks /Change /TN "%%~t" /Disable >nul 2>&1
for /f "skip=1 usebackq tokens=1 delims=," %%a in (`schtasks /query /fo CSV`) do (echo "%%~a" | findstr /i "MicrosoftEdgeUpdateTaskMachine" >nul && schtasks /delete /tn "%%~a" /f) >nul 2>&1
for /f "skip=1 usebackq tokens=1 delims=," %%a in (`schtasks /query /fo CSV`) do (echo "%%~a" | findstr /i "Optimize Push Notification Data File" >nul && schtasks /delete /tn "%%~a" /f) >nul 2>&1
for /f "tokens=1 delims=," %%i in ('schtasks /query /fo csv /nh ^| findstr /i "OneDrive Reporting Task-"') do schtasks /Change /TN "%%~i" /Disable >NUL 2>&1
for /f "tokens=1 delims=," %%i in ('schtasks /query /fo csv /nh ^| findstr /i "OneDrive Standalone Update Task-"') do schtasks /Change /TN "%%~i" /Disable >NUL 2>&1
for /f "tokens=1 delims=," %%i in ('schtasks /query /fo csv /nh ^| findstr /i "OneDrive Per-Machine Standalone Update"') do schtasks /Change /TN "%%~i" /Disable >NUL 2>&1
for /f "usebackq tokens=1 delims=," %%i in (`schtasks /query /fo csv /nh ^| findstr /i "edge onedrive office google firefox nvidia megasync googleupdater telemetry siuf ceip featureconfig consolidator bthsqm kernelceip usbc"`) do schtasks /change /tn "%%~i" /disable >NUL 2>&1
for /f "tokens=1 delims=," %%i in ('schtasks /query /fo csv /nh ^| findstr /i "\Microsoft\Windows\Application Experience\"') do schtasks /change /tn "%%~i" /disable >NUL 2>&1
for /f "tokens=1 delims=," %%i in ('schtasks /query /fo csv /nh ^| findstr /i "\Microsoft\Windows\Customer Experience Improvement Program\"') do schtasks /change /tn "%%~i" /disable >NUL 2>&1
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Get-ScheduledTask -TaskPath '\Microsoft\Windows\Windows Defender\' -ErrorAction SilentlyContinue | Disable-ScheduledTask -Confirm:$false -ErrorAction SilentlyContinue" >NUL 2>&1
powershell -Command "Get-ScheduledTask | Where-Object { $_.TaskName -like '*OneDrive Startup Task*' -or $_.TaskName -like '*OneDrive Reporting Task*' -or $_.TaskName -like '*OneDrive Standalone Update*' } | ForEach-Object { Unregister-ScheduledTask -TaskName $_.TaskName -TaskPath $_.TaskPath -Confirm:$false }" >nul 2>&1
for /f "tokens=1 delims=," %%i in ('schtasks /query /fo csv /nh ^| findstr /i "OneDrive"') do schtasks /Delete /TN "%%~i" /F >nul 2>&1
exit
