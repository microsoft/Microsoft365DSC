Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneDeviceConfigurationPolicyWindows10'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.Boolean]
        $AccountsBlockAddingNonMicrosoftAccountEmail,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $ActivateAppsWithVoice,

        [Parameter()]
        [System.Boolean]
        $AntiTheftModeBlocked,

        [Parameter()]
        [System.Boolean]
        $AppManagementMSIAllowUserControlOverInstall,

        [Parameter()]
        [System.Boolean]
        $AppManagementMSIAlwaysInstallWithElevatedPrivileges,

        [Parameter()]
        [System.String[]]
        $AppManagementPackageFamilyNamesToLaunchAfterLogOn,

        [Parameter()]
        [ValidateSet('notConfigured', 'blocked', 'allowed')]
        [System.String]
        $AppsAllowTrustedAppsSideloading,

        [Parameter()]
        [System.Boolean]
        $AppsBlockWindowsStoreOriginatedApps,

        [Parameter()]
        [System.Boolean]
        $AuthenticationAllowSecondaryDevice,

        [Parameter()]
        [System.String]
        $AuthenticationPreferredAzureADTenantDomainName,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $AuthenticationWebSignIn,

        [Parameter()]
        [System.String[]]
        $BluetoothAllowedServices,

        [Parameter()]
        [System.Boolean]
        $BluetoothBlockAdvertising,

        [Parameter()]
        [System.Boolean]
        $BluetoothBlockDiscoverableMode,

        [Parameter()]
        [System.Boolean]
        $BluetoothBlocked,

        [Parameter()]
        [System.Boolean]
        $BluetoothBlockPrePairing,

        [Parameter()]
        [System.Boolean]
        $BluetoothBlockPromptedProximalConnections,

        [Parameter()]
        [System.Boolean]
        $CameraBlocked,

        [Parameter()]
        [System.Boolean]
        $CellularBlockDataWhenRoaming,

        [Parameter()]
        [System.Boolean]
        $CellularBlockVpn,

        [Parameter()]
        [System.Boolean]
        $CellularBlockVpnWhenRoaming,

        [Parameter()]
        [ValidateSet('blocked', 'required', 'allowed', 'notConfigured')]
        [System.String]
        $CellularData,

        [Parameter()]
        [System.Boolean]
        $CertificatesBlockManualRootCertificateInstallation,

        [Parameter()]
        [System.String]
        $ConfigureTimeZone,

        [Parameter()]
        [System.Boolean]
        $ConnectedDevicesServiceBlocked,

        [Parameter()]
        [System.Boolean]
        $CopyPasteBlocked,

        [Parameter()]
        [System.Boolean]
        $CortanaBlocked,

        [Parameter()]
        [System.Boolean]
        $CryptographyAllowFipsAlgorithmPolicy,

        [Parameter()]
        [System.Boolean]
        $DataProtectionBlockDirectMemoryAccess,

        [Parameter()]
        [System.Boolean]
        $DefenderBlockEndUserAccess,

        [Parameter()]
        [System.Boolean]
        $DefenderBlockOnAccessProtection,

        [Parameter()]
        [ValidateSet('notConfigured', 'high', 'highPlus', 'zeroTolerance')]
        [System.String]
        $DefenderCloudBlockLevel,

        [Parameter()]
        [System.Int32]
        $DefenderCloudExtendedTimeout,

        [Parameter()]
        [System.Int32]
        $DefenderCloudExtendedTimeoutInSeconds,

        [Parameter()]
        [System.Int32]
        $DefenderDaysBeforeDeletingQuarantinedMalware,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DefenderDetectedMalwareActions,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableCatchupFullScan,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableCatchupQuickScan,

        [Parameter()]
        [System.String[]]
        $DefenderFileExtensionsToExclude,

        [Parameter()]
        [System.String[]]
        $DefenderFilesAndFoldersToExclude,

        [Parameter()]
        [ValidateSet('userDefined', 'disable', 'monitorAllFiles', 'monitorIncomingFilesOnly', 'monitorOutgoingFilesOnly')]
        [System.String]
        $DefenderMonitorFileActivity,

        [Parameter()]
        [ValidateSet('deviceDefault', 'block', 'audit')]
        [System.String]
        $DefenderPotentiallyUnwantedAppAction,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderPotentiallyUnwantedAppActionSetting,

        [Parameter()]
        [System.String[]]
        $DefenderProcessesToExclude,

        [Parameter()]
        [ValidateSet('userDefined', 'alwaysPrompt', 'promptBeforeSendingPersonalData', 'neverSendData', 'sendAllDataWithoutPrompting')]
        [System.String]
        $DefenderPromptForSampleSubmission,

        [Parameter()]
        [System.Boolean]
        $DefenderRequireBehaviorMonitoring,

        [Parameter()]
        [System.Boolean]
        $DefenderRequireCloudProtection,

        [Parameter()]
        [System.Boolean]
        $DefenderRequireNetworkInspectionSystem,

        [Parameter()]
        [System.Boolean]
        $DefenderRequireRealTimeMonitoring,

        [Parameter()]
        [System.Boolean]
        $DefenderScanArchiveFiles,

        [Parameter()]
        [System.Boolean]
        $DefenderScanDownloads,

        [Parameter()]
        [System.Boolean]
        $DefenderScanIncomingMail,

        [Parameter()]
        [System.Boolean]
        $DefenderScanMappedNetworkDrivesDuringFullScan,

        [Parameter()]
        [System.Int32]
        $DefenderScanMaxCpu,

        [Parameter()]
        [System.Boolean]
        $DefenderScanNetworkFiles,

        [Parameter()]
        [System.Boolean]
        $DefenderScanRemovableDrivesDuringFullScan,

        [Parameter()]
        [System.Boolean]
        $DefenderScanScriptsLoadedInInternetExplorer,

        [Parameter()]
        [ValidateSet('userDefined', 'disabled', 'quick', 'full')]
        [System.String]
        $DefenderScanType,

        [Parameter()]
        [System.TimeSpan]
        $DefenderScheduledQuickScanTime,

        [Parameter()]
        [System.TimeSpan]
        $DefenderScheduledScanTime,

        [Parameter()]
        [System.Boolean]
        $DefenderScheduleScanEnableLowCpuPriority,

        [Parameter()]
        [System.Int32]
        $DefenderSignatureUpdateIntervalInHours,

        [Parameter()]
        [ValidateSet('sendSafeSamplesAutomatically', 'alwaysPrompt', 'neverSend', 'sendAllSamplesAutomatically')]
        [System.String]
        $DefenderSubmitSamplesConsentType,

        [Parameter()]
        [ValidateSet('userDefined', 'everyday', 'sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'noScheduledScan')]
        [System.String]
        $DefenderSystemScanSchedule,

        [Parameter()]
        [ValidateSet('notConfigured', 'blocked', 'allowed')]
        [System.String]
        $DeveloperUnlockSetting,

        [Parameter()]
        [System.Boolean]
        $DeviceManagementBlockFactoryResetOnMobile,

        [Parameter()]
        [System.Boolean]
        $DeviceManagementBlockManualUnenroll,

        [Parameter()]
        [ValidateSet('userDefined', 'none', 'basic', 'enhanced', 'full')]
        [System.String]
        $DiagnosticsDataSubmissionMode,

        [Parameter()]
        [System.String[]]
        $DisplayAppListWithGdiDPIScalingTurnedOff,

        [Parameter()]
        [System.String[]]
        $DisplayAppListWithGdiDPIScalingTurnedOn,

        [Parameter()]
        [System.Boolean]
        $EdgeAllowStartPagesModification,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockAccessToAboutFlags,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockAddressBarDropdown,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockAutofill,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockCompatibilityList,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockDeveloperTools,

        [Parameter()]
        [System.Boolean]
        $EdgeBlocked,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockEditFavorites,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockExtensions,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockFullScreenMode,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockInPrivateBrowsing,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockJavaScript,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockLiveTileDataCollection,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockPasswordManager,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockPopups,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockPrelaunch,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockPrinting,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockSavingHistory,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockSearchEngineCustomization,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockSearchSuggestions,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockSendingDoNotTrackHeader,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockSendingIntranetTrafficToInternetExplorer,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockSideloadingExtensions,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockTabPreloading,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockWebContentOnNewTabPage,

        [Parameter()]
        [System.Boolean]
        $EdgeClearBrowsingDataOnExit,

        [Parameter()]
        [ValidateSet('userDefined', 'allow', 'blockThirdParty', 'blockAll')]
        [System.String]
        $EdgeCookiePolicy,

        [Parameter()]
        [System.Boolean]
        $EdgeDisableFirstRunPage,

        [Parameter()]
        [System.String]
        $EdgeEnterpriseModeSiteListLocation,

        [Parameter()]
        [ValidateSet('notConfigured', 'hide', 'show')]
        [System.String]
        $EdgeFavoritesBarVisibility,

        [Parameter()]
        [System.String]
        $EdgeFavoritesListLocation,

        [Parameter()]
        [System.String]
        $EdgeFirstRunUrl,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EdgeHomeButtonConfiguration,

        [Parameter()]
        [System.Boolean]
        $EdgeHomeButtonConfigurationEnabled,

        [Parameter()]
        [System.String[]]
        $EdgeHomepageUrls,

        [Parameter()]
        [ValidateSet('notConfigured', 'digitalSignage', 'normalMode', 'publicBrowsingSingleApp', 'publicBrowsingMultiApp')]
        [System.String]
        $EdgeKioskModeRestriction,

        [Parameter()]
        [System.Int32]
        $EdgeKioskResetAfterIdleTimeInMinutes,

        [Parameter()]
        [System.String]
        $EdgeNewTabPageURL,

        [Parameter()]
        [ValidateSet('notConfigured', 'startPage', 'newTabPage', 'previousPages', 'specificPages')]
        [System.String]
        $EdgeOpensWith,

        [Parameter()]
        [System.Boolean]
        $EdgePreventCertificateErrorOverride,

        [Parameter()]
        [System.String[]]
        $EdgeRequiredExtensionPackageFamilyNames,

        [Parameter()]
        [System.Boolean]
        $EdgeRequireSmartScreen,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EdgeSearchEngine,

        [Parameter()]
        [System.Boolean]
        $EdgeSendIntranetTrafficToInternetExplorer,

        [Parameter()]
        [ValidateSet('notConfigured', 'disabled', 'enabled', 'keepGoing')]
        [System.String]
        $EdgeShowMessageWhenOpeningInternetExplorerSites,

        [Parameter()]
        [System.Boolean]
        $EdgeSyncFavoritesWithInternetExplorer,

        [Parameter()]
        [ValidateSet('notConfigured', 'intranet', 'internet', 'intranetAndInternet')]
        [System.String]
        $EdgeTelemetryForMicrosoft365Analytics,

        [Parameter()]
        [System.Boolean]
        $EnableAutomaticRedeployment,

        [Parameter()]
        [System.Int32]
        $EnergySaverOnBatteryThresholdPercentage,

        [Parameter()]
        [System.Int32]
        $EnergySaverPluggedInThresholdPercentage,

        [Parameter()]
        [System.String]
        $EnterpriseCloudPrintDiscoveryEndPoint,

        [Parameter()]
        [System.Int32]
        $EnterpriseCloudPrintDiscoveryMaxLimit,

        [Parameter()]
        [System.String]
        $EnterpriseCloudPrintMopriaDiscoveryResourceIdentifier,

        [Parameter()]
        [System.String]
        $EnterpriseCloudPrintOAuthAuthority,

        [Parameter()]
        [System.String]
        $EnterpriseCloudPrintOAuthClientIdentifier,

        [Parameter()]
        [System.String]
        $EnterpriseCloudPrintResourceIdentifier,

        [Parameter()]
        [System.Boolean]
        $ExperienceBlockDeviceDiscovery,

        [Parameter()]
        [System.Boolean]
        $ExperienceBlockErrorDialogWhenNoSIM,

        [Parameter()]
        [System.Boolean]
        $ExperienceBlockTaskSwitcher,

        [Parameter()]
        [ValidateSet('notConfigured', 'blockedWithUserOverride', 'blocked')]
        [System.String]
        $ExperienceDoNotSyncBrowserSettings,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $FindMyFiles,

        [Parameter()]
        [System.Boolean]
        $GameDvrBlocked,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $InkWorkspaceAccess,

        [Parameter()]
        [ValidateSet('notConfigured', 'blocked', 'allowed')]
        [System.String]
        $InkWorkspaceAccessState,

        [Parameter()]
        [System.Boolean]
        $InkWorkspaceBlockSuggestedApps,

        [Parameter()]
        [System.Boolean]
        $InternetSharingBlocked,

        [Parameter()]
        [System.Boolean]
        $LocationServicesBlocked,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $LockScreenActivateAppsWithVoice,

        [Parameter()]
        [System.Boolean]
        $LockScreenAllowTimeoutConfiguration,

        [Parameter()]
        [System.Boolean]
        $LockScreenBlockActionCenterNotifications,

        [Parameter()]
        [System.Boolean]
        $LockScreenBlockCortana,

        [Parameter()]
        [System.Boolean]
        $LockScreenBlockToastNotifications,

        [Parameter()]
        [System.Int32]
        $LockScreenTimeoutInSeconds,

        [Parameter()]
        [System.Boolean]
        $LogonBlockFastUserSwitching,

        [Parameter()]
        [System.Boolean]
        $MessagingBlockMMS,

        [Parameter()]
        [System.Boolean]
        $MessagingBlockRichCommunicationServices,

        [Parameter()]
        [System.Boolean]
        $MessagingBlockSync,

        [Parameter()]
        [System.Boolean]
        $MicrosoftAccountBlocked,

        [Parameter()]
        [System.Boolean]
        $MicrosoftAccountBlockSettingsSync,

        [Parameter()]
        [ValidateSet('notConfigured', 'disabled')]
        [System.String]
        $MicrosoftAccountSignInAssistantSettings,

        [Parameter()]
        [System.Boolean]
        $NetworkProxyApplySettingsDeviceWide,

        [Parameter()]
        [System.String]
        $NetworkProxyAutomaticConfigurationUrl,

        [Parameter()]
        [System.Boolean]
        $NetworkProxyDisableAutoDetect,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $NetworkProxyServer,

        [Parameter()]
        [System.Boolean]
        $NfcBlocked,

        [Parameter()]
        [System.Boolean]
        $OneDriveDisableFileSync,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockSimple,

        [Parameter()]
        [System.Int32]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumAgeInDays,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumCharacterSetCount,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeScreenTimeout,

        [Parameter()]
        [System.Int32]
        $PasswordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Boolean]
        $PasswordRequired,

        [Parameter()]
        [ValidateSet('deviceDefault', 'alphanumeric', 'numeric')]
        [System.String]
        $PasswordRequiredType,

        [Parameter()]
        [System.Boolean]
        $PasswordRequireWhenResumeFromIdleState,

        [Parameter()]
        [System.Int32]
        $PasswordSignInFailureCountBeforeFactoryReset,

        [Parameter()]
        [System.String]
        $PersonalizationDesktopImageUrl,

        [Parameter()]
        [System.String]
        $PersonalizationLockScreenImageUrl,

        [Parameter()]
        [ValidateSet('notConfigured', 'noAction', 'sleep', 'hibernate', 'shutdown')]
        [System.String]
        $PowerButtonActionOnBattery,

        [Parameter()]
        [ValidateSet('notConfigured', 'noAction', 'sleep', 'hibernate', 'shutdown')]
        [System.String]
        $PowerButtonActionPluggedIn,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $PowerHybridSleepOnBattery,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $PowerHybridSleepPluggedIn,

        [Parameter()]
        [ValidateSet('notConfigured', 'noAction', 'sleep', 'hibernate', 'shutdown')]
        [System.String]
        $PowerLidCloseActionOnBattery,

        [Parameter()]
        [ValidateSet('notConfigured', 'noAction', 'sleep', 'hibernate', 'shutdown')]
        [System.String]
        $PowerLidCloseActionPluggedIn,

        [Parameter()]
        [ValidateSet('notConfigured', 'noAction', 'sleep', 'hibernate', 'shutdown')]
        [System.String]
        $PowerSleepButtonActionOnBattery,

        [Parameter()]
        [ValidateSet('notConfigured', 'noAction', 'sleep', 'hibernate', 'shutdown')]
        [System.String]
        $PowerSleepButtonActionPluggedIn,

        [Parameter()]
        [System.Boolean]
        $PrinterBlockAddition,

        [Parameter()]
        [System.String]
        $PrinterDefaultName,

        [Parameter()]
        [System.String[]]
        $PrinterNames,

        [Parameter()]
        [ValidateSet('notConfigured', 'blocked', 'allowed')]
        [System.String]
        $PrivacyAdvertisingId,

        [Parameter()]
        [System.Boolean]
        $PrivacyAutoAcceptPairingAndConsentPrompts,

        [Parameter()]
        [System.Boolean]
        $PrivacyBlockActivityFeed,

        [Parameter()]
        [System.Boolean]
        $PrivacyBlockInputPersonalization,

        [Parameter()]
        [System.Boolean]
        $PrivacyBlockPublishUserActivities,

        [Parameter()]
        [System.Boolean]
        $PrivacyDisableLaunchExperience,

        [Parameter()]
        [System.Boolean]
        $ResetProtectionModeBlocked,

        [Parameter()]
        [ValidateSet('userDefined', 'strict', 'moderate')]
        [System.String]
        $SafeSearchFilter,

        [Parameter()]
        [System.Boolean]
        $ScreenCaptureBlocked,

        [Parameter()]
        [System.Boolean]
        $SearchBlockDiacritics,

        [Parameter()]
        [System.Boolean]
        $SearchBlockWebResults,

        [Parameter()]
        [System.Boolean]
        $SearchDisableAutoLanguageDetection,

        [Parameter()]
        [System.Boolean]
        $SearchDisableIndexerBackoff,

        [Parameter()]
        [System.Boolean]
        $SearchDisableIndexingEncryptedItems,

        [Parameter()]
        [System.Boolean]
        $SearchDisableIndexingRemovableDrive,

        [Parameter()]
        [System.Boolean]
        $SearchDisableLocation,

        [Parameter()]
        [System.Boolean]
        $SearchDisableUseLocation,

        [Parameter()]
        [System.Boolean]
        $SearchEnableAutomaticIndexSizeManangement,

        [Parameter()]
        [System.Boolean]
        $SearchEnableRemoteQueries,

        [Parameter()]
        [System.Boolean]
        $SecurityBlockAzureADJoinedDevicesAutoEncryption,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockAccountsPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockAddProvisioningPackage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockAppsPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockChangeLanguage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockChangePowerSleep,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockChangeRegion,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockChangeSystemTime,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockDevicesPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockEaseOfAccessPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockEditDeviceName,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockGamingPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockNetworkInternetPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockPersonalizationPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockPrivacyPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockRemoveProvisioningPackage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockSettingsApp,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockSystemPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockTimeLanguagePage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockUpdateSecurityPage,

        [Parameter()]
        [System.Boolean]
        $SharedUserAppDataAllowed,

        [Parameter()]
        [ValidateSet('notConfigured', 'anywhere', 'storeOnly', 'recommendations', 'preferStore')]
        [System.String]
        $SmartScreenAppInstallControl,

        [Parameter()]
        [System.Boolean]
        $SmartScreenBlockPromptOverride,

        [Parameter()]
        [System.Boolean]
        $SmartScreenBlockPromptOverrideForFiles,

        [Parameter()]
        [System.Boolean]
        $SmartScreenEnableAppInstallControl,

        [Parameter()]
        [System.Boolean]
        $StartBlockUnpinningAppsFromTaskbar,

        [Parameter()]
        [ValidateSet('userDefined', 'collapse', 'remove', 'disableSettingsApp')]
        [System.String]
        $StartMenuAppListVisibility,

        [Parameter()]
        [System.Boolean]
        $StartMenuHideChangeAccountSettings,

        [Parameter()]
        [System.Boolean]
        $StartMenuHideFrequentlyUsedApps,

        [Parameter()]
        [System.Boolean]
        $StartMenuHideHibernate,

        [Parameter()]
        [System.Boolean]
        $StartMenuHideLock,

        [Parameter()]
        [System.Boolean]
        $StartMenuHidePowerButton,

        [Parameter()]
        [System.Boolean]
        $StartMenuHideRecentJumpLists,

        [Parameter()]
        [System.Boolean]
        $StartMenuHideRecentlyAddedApps,

        [Parameter()]
        [System.Boolean]
        $StartMenuHideRestartOptions,

        [Parameter()]
        [System.Boolean]
        $StartMenuHideShutDown,

        [Parameter()]
        [System.Boolean]
        $StartMenuHideSignOut,

        [Parameter()]
        [System.Boolean]
        $StartMenuHideSleep,

        [Parameter()]
        [System.Boolean]
        $StartMenuHideSwitchAccount,

        [Parameter()]
        [System.Boolean]
        $StartMenuHideUserTile,

        [Parameter()]
        [System.String]
        $StartMenuLayoutEdgeAssetsXml,

        [Parameter()]
        [System.String]
        $StartMenuLayoutXml,

        [Parameter()]
        [ValidateSet('userDefined', 'fullScreen', 'nonFullScreen')]
        [System.String]
        $StartMenuMode,

        [Parameter()]
        [ValidateSet('notConfigured', 'hide', 'show')]
        [System.String]
        $StartMenuPinnedFolderDocuments,

        [Parameter()]
        [ValidateSet('notConfigured', 'hide', 'show')]
        [System.String]
        $StartMenuPinnedFolderDownloads,

        [Parameter()]
        [ValidateSet('notConfigured', 'hide', 'show')]
        [System.String]
        $StartMenuPinnedFolderFileExplorer,

        [Parameter()]
        [ValidateSet('notConfigured', 'hide', 'show')]
        [System.String]
        $StartMenuPinnedFolderHomeGroup,

        [Parameter()]
        [ValidateSet('notConfigured', 'hide', 'show')]
        [System.String]
        $StartMenuPinnedFolderMusic,

        [Parameter()]
        [ValidateSet('notConfigured', 'hide', 'show')]
        [System.String]
        $StartMenuPinnedFolderNetwork,

        [Parameter()]
        [ValidateSet('notConfigured', 'hide', 'show')]
        [System.String]
        $StartMenuPinnedFolderPersonalFolder,

        [Parameter()]
        [ValidateSet('notConfigured', 'hide', 'show')]
        [System.String]
        $StartMenuPinnedFolderPictures,

        [Parameter()]
        [ValidateSet('notConfigured', 'hide', 'show')]
        [System.String]
        $StartMenuPinnedFolderSettings,

        [Parameter()]
        [ValidateSet('notConfigured', 'hide', 'show')]
        [System.String]
        $StartMenuPinnedFolderVideos,

        [Parameter()]
        [System.Boolean]
        $StorageBlockRemovableStorage,

        [Parameter()]
        [System.Boolean]
        $StorageRequireMobileDeviceEncryption,

        [Parameter()]
        [System.Boolean]
        $StorageRestrictAppDataToSystemVolume,

        [Parameter()]
        [System.Boolean]
        $StorageRestrictAppInstallToSystemVolume,

        [Parameter()]
        [System.String]
        $SystemTelemetryProxyServer,

        [Parameter()]
        [System.Boolean]
        $TaskManagerBlockEndTask,

        [Parameter()]
        [System.Boolean]
        $TenantLockdownRequireNetworkDuringOutOfBoxExperience,

        [Parameter()]
        [System.Boolean]
        $UninstallBuiltInApps,

        [Parameter()]
        [System.Boolean]
        $UsbBlocked,

        [Parameter()]
        [System.Boolean]
        $VoiceRecordingBlocked,

        [Parameter()]
        [System.Boolean]
        $WebRtcBlockLocalhostIpAddress,

        [Parameter()]
        [System.Boolean]
        $WiFiBlockAutomaticConnectHotspots,

        [Parameter()]
        [System.Boolean]
        $WiFiBlocked,

        [Parameter()]
        [System.Boolean]
        $WiFiBlockManualConfiguration,

        [Parameter()]
        [System.Int32]
        $WiFiScanInterval,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $Windows10AppsForceUpdateSchedule,

        [Parameter()]
        [System.Boolean]
        $WindowsSpotlightBlockConsumerSpecificFeatures,

        [Parameter()]
        [System.Boolean]
        $WindowsSpotlightBlocked,

        [Parameter()]
        [System.Boolean]
        $WindowsSpotlightBlockOnActionCenter,

        [Parameter()]
        [System.Boolean]
        $WindowsSpotlightBlockTailoredExperiences,

        [Parameter()]
        [System.Boolean]
        $WindowsSpotlightBlockThirdPartyNotifications,

        [Parameter()]
        [System.Boolean]
        $WindowsSpotlightBlockWelcomeExperience,

        [Parameter()]
        [System.Boolean]
        $WindowsSpotlightBlockWindowsTips,

        [Parameter()]
        [ValidateSet('notConfigured', 'disabled', 'enabled')]
        [System.String]
        $WindowsSpotlightConfigureOnLockScreen,

        [Parameter()]
        [System.Boolean]
        $WindowsStoreBlockAutoUpdate,

        [Parameter()]
        [System.Boolean]
        $WindowsStoreBlocked,

        [Parameter()]
        [System.Boolean]
        $WindowsStoreEnablePrivateStoreOnly,

        [Parameter()]
        [System.Boolean]
        $WirelessDisplayBlockProjectionToThisDevice,

        [Parameter()]
        [System.Boolean]
        $WirelessDisplayBlockUserInputFromReceiver,

        [Parameter()]
        [System.Boolean]
        $WirelessDisplayRequirePinForPairing,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
        #endregion

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration of the Intune Device Configuration Policy for Windows 10 with Id {$Id} and DisplayName {$DisplayName}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.DisplayName -ne $DisplayName)
        {
            $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
                -InboundParameters $PSBoundParameters

            #Ensure the proper dependencies are installed in the current environment.
            Confirm-M365DSCDependencies

            #region Telemetry
            $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
            $CommandName = $MyInvocation.MyCommand
            $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
                -CommandName $CommandName `
                -Parameters $PSBoundParameters
            Add-M365DSCTelemetryEvent -Data $data
            #endregion

            $nullResult = $PSBoundParameters
            $nullResult.Ensure = 'Absent'

            $getValue = $null
            #region resource generator code
            if (-not [string]::IsNullOrEmpty($Id))
            {
                $getValue = Get-MgBetaDeviceManagementDeviceConfiguration -DeviceConfigurationId $Id -ErrorAction SilentlyContinue
            }

            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Device Configuration Policy for Windows10 with Id {$Id}"

                if (-not [string]::IsNullOrEmpty($DisplayName))
                {
                    $getValue = Get-MgBetaDeviceManagementDeviceConfiguration `
                        -All `
                        -Filter "DisplayName eq '$($DisplayName -replace "'", "''")' and isof('microsoft.graph.windows10GeneralConfiguration')" `
                        -ErrorAction SilentlyContinue
                }
            }
            #endregion
            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Device Configuration Policy for Windows10 with DisplayName {$DisplayName}"
                return $nullResult
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Device Configuration Policy for Windows10 with Id {$Id} and DisplayName {$DisplayName} was found."

        #region resource generator code
        $complexDefenderDetectedMalwareActions = [ordered]@{}
        if ($null -ne $getValue.defenderDetectedMalwareActions.highSeverity)
        {
            $complexDefenderDetectedMalwareActions.Add('HighSeverity', $getValue.defenderDetectedMalwareActions.highSeverity.ToString())
        }
        if ($null -ne $getValue.defenderDetectedMalwareActions.lowSeverity)
        {
            $complexDefenderDetectedMalwareActions.Add('LowSeverity', $getValue.defenderDetectedMalwareActions.lowSeverity.ToString())
        }
        if ($null -ne $getValue.defenderDetectedMalwareActions.moderateSeverity)
        {
            $complexDefenderDetectedMalwareActions.Add('ModerateSeverity', $getValue.defenderDetectedMalwareActions.moderateSeverity.ToString())
        }
        if ($null -ne $getValue.defenderDetectedMalwareActions.severeSeverity)
        {
            $complexDefenderDetectedMalwareActions.Add('SevereSeverity', $getValue.defenderDetectedMalwareActions.severeSeverity.ToString())
        }
        if ($complexDefenderDetectedMalwareActions.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexDefenderDetectedMalwareActions = $null
        }

        $complexEdgeHomeButtonConfiguration = [ordered]@{}
        $complexEdgeHomeButtonConfiguration.Add('HomeButtonCustomURL', $getValue.edgeHomeButtonConfiguration.homeButtonCustomURL)
        if ($null -ne $getValue.edgeHomeButtonConfiguration.'@odata.type')
        {
            $complexEdgeHomeButtonConfiguration.Add('odataType', $getValue.edgeHomeButtonConfiguration.'@odata.type'.ToString())
        }
        if ($complexEdgeHomeButtonConfiguration.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexEdgeHomeButtonConfiguration = $null
        }

        $complexEdgeSearchEngine = [ordered]@{}
        if ($null -ne $getValue.edgeSearchEngine.edgeSearchEngineType)
        {
            $complexEdgeSearchEngine.Add('EdgeSearchEngineType', $getValue.edgeSearchEngine.edgeSearchEngineType.ToString())
        }
        $complexEdgeSearchEngine.Add('EdgeSearchEngineOpenSearchXmlUrl', $getValue.edgeSearchEngine.edgeSearchEngineOpenSearchXmlUrl)
        if ($null -ne $getValue.edgeSearchEngine.'@odata.type')
        {
            $complexEdgeSearchEngine.Add('odataType', $getValue.edgeSearchEngine.'@odata.type'.ToString())
        }
        if ($complexEdgeSearchEngine.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexEdgeSearchEngine = $null
        }

        $complexNetworkProxyServer = [ordered]@{}
        $complexNetworkProxyServer.Add('Address', $getValue.networkProxyServer.address)
        $complexNetworkProxyServer.Add('Exceptions', $getValue.networkProxyServer.exceptions)
        $complexNetworkProxyServer.Add('UseForLocalAddresses', $getValue.networkProxyServer.useForLocalAddresses)
        if ($complexNetworkProxyServer.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexNetworkProxyServer = $null
        }

        $complexWindows10AppsForceUpdateSchedule = [ordered]@{}
        if ($null -ne $getValue.windows10AppsForceUpdateSchedule.recurrence)
        {
            $complexWindows10AppsForceUpdateSchedule.Add('Recurrence', $getValue.windows10AppsForceUpdateSchedule.recurrence.ToString())
        }
        $complexWindows10AppsForceUpdateSchedule.Add('RunImmediatelyIfAfterStartDateTime', $getValue.windows10AppsForceUpdateSchedule.runImmediatelyIfAfterStartDateTime)
        if ($null -ne $getValue.windows10AppsForceUpdateSchedule.startDateTime)
        {
            $complexWindows10AppsForceUpdateSchedule.Add('StartDateTime', ([DateTimeOffset]$getValue.windows10AppsForceUpdateSchedule.startDateTime).ToString('o'))
        }
        if ($complexWindows10AppsForceUpdateSchedule.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexWindows10AppsForceUpdateSchedule = $null
        }
        #endregion

        #region resource generator code
        $enumActivateAppsWithVoice = $null
        if ($null -ne $getValue.activateAppsWithVoice)
        {
            $enumActivateAppsWithVoice = $getValue.activateAppsWithVoice.ToString()
        }

        $enumAppsAllowTrustedAppsSideloading = $null
        if ($null -ne $getValue.appsAllowTrustedAppsSideloading)
        {
            $enumAppsAllowTrustedAppsSideloading = $getValue.appsAllowTrustedAppsSideloading.ToString()
        }

        $enumAuthenticationWebSignIn = $null
        if ($null -ne $getValue.authenticationWebSignIn)
        {
            $enumAuthenticationWebSignIn = $getValue.authenticationWebSignIn.ToString()
        }

        $enumCellularData = $null
        if ($null -ne $getValue.cellularData)
        {
            $enumCellularData = $getValue.cellularData.ToString()
        }

        $enumDefenderCloudBlockLevel = $null
        if ($null -ne $getValue.defenderCloudBlockLevel)
        {
            $enumDefenderCloudBlockLevel = $getValue.defenderCloudBlockLevel.ToString()
        }

        $enumDefenderMonitorFileActivity = $null
        if ($null -ne $getValue.defenderMonitorFileActivity)
        {
            $enumDefenderMonitorFileActivity = $getValue.defenderMonitorFileActivity.ToString()
        }

        $enumDefenderPotentiallyUnwantedAppAction = $null
        if ($null -ne $getValue.defenderPotentiallyUnwantedAppAction)
        {
            $enumDefenderPotentiallyUnwantedAppAction = $getValue.defenderPotentiallyUnwantedAppAction.ToString()
        }

        $enumDefenderPotentiallyUnwantedAppActionSetting = $null
        if ($null -ne $getValue.defenderPotentiallyUnwantedAppActionSetting)
        {
            $enumDefenderPotentiallyUnwantedAppActionSetting = $getValue.defenderPotentiallyUnwantedAppActionSetting.ToString()
        }

        $enumDefenderPromptForSampleSubmission = $null
        if ($null -ne $getValue.defenderPromptForSampleSubmission)
        {
            $enumDefenderPromptForSampleSubmission = $getValue.defenderPromptForSampleSubmission.ToString()
        }

        $enumDefenderScanType = $null
        if ($null -ne $getValue.defenderScanType)
        {
            $enumDefenderScanType = $getValue.defenderScanType.ToString()
        }

        $enumDefenderSubmitSamplesConsentType = $null
        if ($null -ne $getValue.defenderSubmitSamplesConsentType)
        {
            $enumDefenderSubmitSamplesConsentType = $getValue.defenderSubmitSamplesConsentType.ToString()
        }

        $enumDefenderSystemScanSchedule = $null
        if ($null -ne $getValue.defenderSystemScanSchedule)
        {
            $enumDefenderSystemScanSchedule = $getValue.defenderSystemScanSchedule.ToString()
        }

        $enumDeveloperUnlockSetting = $null
        if ($null -ne $getValue.developerUnlockSetting)
        {
            $enumDeveloperUnlockSetting = $getValue.developerUnlockSetting.ToString()
        }

        $enumDiagnosticsDataSubmissionMode = $null
        if ($null -ne $getValue.diagnosticsDataSubmissionMode)
        {
            $enumDiagnosticsDataSubmissionMode = $getValue.diagnosticsDataSubmissionMode.ToString()
        }

        $enumEdgeCookiePolicy = $null
        if ($null -ne $getValue.edgeCookiePolicy)
        {
            $enumEdgeCookiePolicy = $getValue.edgeCookiePolicy.ToString()
        }

        $enumEdgeFavoritesBarVisibility = $null
        if ($null -ne $getValue.edgeFavoritesBarVisibility)
        {
            $enumEdgeFavoritesBarVisibility = $getValue.edgeFavoritesBarVisibility.ToString()
        }

        $enumEdgeKioskModeRestriction = $null
        if ($null -ne $getValue.edgeKioskModeRestriction)
        {
            $enumEdgeKioskModeRestriction = $getValue.edgeKioskModeRestriction.ToString()
        }

        $enumEdgeOpensWith = $null
        if ($null -ne $getValue.edgeOpensWith)
        {
            $enumEdgeOpensWith = $getValue.edgeOpensWith.ToString()
        }

        $enumEdgeShowMessageWhenOpeningInternetExplorerSites = $null
        if ($null -ne $getValue.edgeShowMessageWhenOpeningInternetExplorerSites)
        {
            $enumEdgeShowMessageWhenOpeningInternetExplorerSites = $getValue.edgeShowMessageWhenOpeningInternetExplorerSites.ToString()
        }

        $enumEdgeTelemetryForMicrosoft365Analytics = $null
        if ($null -ne $getValue.edgeTelemetryForMicrosoft365Analytics)
        {
            $enumEdgeTelemetryForMicrosoft365Analytics = $getValue.edgeTelemetryForMicrosoft365Analytics.ToString()
        }

        $enumExperienceDoNotSyncBrowserSettings = $null
        if ($null -ne $getValue.experienceDoNotSyncBrowserSettings)
        {
            $enumExperienceDoNotSyncBrowserSettings = $getValue.experienceDoNotSyncBrowserSettings.ToString()
        }

        $enumFindMyFiles = $null
        if ($null -ne $getValue.findMyFiles)
        {
            $enumFindMyFiles = $getValue.findMyFiles.ToString()
        }

        $enumInkWorkspaceAccess = $null
        if ($null -ne $getValue.inkWorkspaceAccess)
        {
            $enumInkWorkspaceAccess = $getValue.inkWorkspaceAccess.ToString()
        }

        $enumInkWorkspaceAccessState = $null
        if ($null -ne $getValue.inkWorkspaceAccessState)
        {
            $enumInkWorkspaceAccessState = $getValue.inkWorkspaceAccessState.ToString()
        }

        $enumLockScreenActivateAppsWithVoice = $null
        if ($null -ne $getValue.lockScreenActivateAppsWithVoice)
        {
            $enumLockScreenActivateAppsWithVoice = $getValue.lockScreenActivateAppsWithVoice.ToString()
        }

        $enumMicrosoftAccountSignInAssistantSettings = $null
        if ($null -ne $getValue.microsoftAccountSignInAssistantSettings)
        {
            $enumMicrosoftAccountSignInAssistantSettings = $getValue.microsoftAccountSignInAssistantSettings.ToString()
        }

        $enumPasswordRequiredType = $null
        if ($null -ne $getValue.passwordRequiredType)
        {
            $enumPasswordRequiredType = $getValue.passwordRequiredType.ToString()
        }

        $enumPowerButtonActionOnBattery = $null
        if ($null -ne $getValue.powerButtonActionOnBattery)
        {
            $enumPowerButtonActionOnBattery = $getValue.powerButtonActionOnBattery.ToString()
        }

        $enumPowerButtonActionPluggedIn = $null
        if ($null -ne $getValue.powerButtonActionPluggedIn)
        {
            $enumPowerButtonActionPluggedIn = $getValue.powerButtonActionPluggedIn.ToString()
        }

        $enumPowerHybridSleepOnBattery = $null
        if ($null -ne $getValue.powerHybridSleepOnBattery)
        {
            $enumPowerHybridSleepOnBattery = $getValue.powerHybridSleepOnBattery.ToString()
        }

        $enumPowerHybridSleepPluggedIn = $null
        if ($null -ne $getValue.powerHybridSleepPluggedIn)
        {
            $enumPowerHybridSleepPluggedIn = $getValue.powerHybridSleepPluggedIn.ToString()
        }

        $enumPowerLidCloseActionOnBattery = $null
        if ($null -ne $getValue.powerLidCloseActionOnBattery)
        {
            $enumPowerLidCloseActionOnBattery = $getValue.powerLidCloseActionOnBattery.ToString()
        }

        $enumPowerLidCloseActionPluggedIn = $null
        if ($null -ne $getValue.powerLidCloseActionPluggedIn)
        {
            $enumPowerLidCloseActionPluggedIn = $getValue.powerLidCloseActionPluggedIn.ToString()
        }

        $enumPowerSleepButtonActionOnBattery = $null
        if ($null -ne $getValue.powerSleepButtonActionOnBattery)
        {
            $enumPowerSleepButtonActionOnBattery = $getValue.powerSleepButtonActionOnBattery.ToString()
        }

        $enumPowerSleepButtonActionPluggedIn = $null
        if ($null -ne $getValue.powerSleepButtonActionPluggedIn)
        {
            $enumPowerSleepButtonActionPluggedIn = $getValue.powerSleepButtonActionPluggedIn.ToString()
        }

        $enumPrivacyAdvertisingId = $null
        if ($null -ne $getValue.privacyAdvertisingId)
        {
            $enumPrivacyAdvertisingId = $getValue.privacyAdvertisingId.ToString()
        }

        $enumSafeSearchFilter = $null
        if ($null -ne $getValue.safeSearchFilter)
        {
            $enumSafeSearchFilter = $getValue.safeSearchFilter.ToString()
        }

        $enumSmartScreenAppInstallControl = $null
        if ($null -ne $getValue.smartScreenAppInstallControl)
        {
            $enumSmartScreenAppInstallControl = $getValue.smartScreenAppInstallControl.ToString()
        }

        $enumStartMenuAppListVisibility = $null
        if ($null -ne $getValue.startMenuAppListVisibility)
        {
            $enumStartMenuAppListVisibility = $getValue.startMenuAppListVisibility.ToString()
        }

        $enumStartMenuMode = $null
        if ($null -ne $getValue.startMenuMode)
        {
            $enumStartMenuMode = $getValue.startMenuMode.ToString()
        }

        $enumStartMenuPinnedFolderDocuments = $null
        if ($null -ne $getValue.startMenuPinnedFolderDocuments)
        {
            $enumStartMenuPinnedFolderDocuments = $getValue.startMenuPinnedFolderDocuments.ToString()
        }

        $enumStartMenuPinnedFolderDownloads = $null
        if ($null -ne $getValue.startMenuPinnedFolderDownloads)
        {
            $enumStartMenuPinnedFolderDownloads = $getValue.startMenuPinnedFolderDownloads.ToString()
        }

        $enumStartMenuPinnedFolderFileExplorer = $null
        if ($null -ne $getValue.startMenuPinnedFolderFileExplorer)
        {
            $enumStartMenuPinnedFolderFileExplorer = $getValue.startMenuPinnedFolderFileExplorer.ToString()
        }

        $enumStartMenuPinnedFolderHomeGroup = $null
        if ($null -ne $getValue.startMenuPinnedFolderHomeGroup)
        {
            $enumStartMenuPinnedFolderHomeGroup = $getValue.startMenuPinnedFolderHomeGroup.ToString()
        }

        $enumStartMenuPinnedFolderMusic = $null
        if ($null -ne $getValue.startMenuPinnedFolderMusic)
        {
            $enumStartMenuPinnedFolderMusic = $getValue.startMenuPinnedFolderMusic.ToString()
        }

        $enumStartMenuPinnedFolderNetwork = $null
        if ($null -ne $getValue.startMenuPinnedFolderNetwork)
        {
            $enumStartMenuPinnedFolderNetwork = $getValue.startMenuPinnedFolderNetwork.ToString()
        }

        $enumStartMenuPinnedFolderPersonalFolder = $null
        if ($null -ne $getValue.startMenuPinnedFolderPersonalFolder)
        {
            $enumStartMenuPinnedFolderPersonalFolder = $getValue.startMenuPinnedFolderPersonalFolder.ToString()
        }

        $enumStartMenuPinnedFolderPictures = $null
        if ($null -ne $getValue.startMenuPinnedFolderPictures)
        {
            $enumStartMenuPinnedFolderPictures = $getValue.startMenuPinnedFolderPictures.ToString()
        }

        $enumStartMenuPinnedFolderSettings = $null
        if ($null -ne $getValue.startMenuPinnedFolderSettings)
        {
            $enumStartMenuPinnedFolderSettings = $getValue.startMenuPinnedFolderSettings.ToString()
        }

        $enumStartMenuPinnedFolderVideos = $null
        if ($null -ne $getValue.startMenuPinnedFolderVideos)
        {
            $enumStartMenuPinnedFolderVideos = $getValue.startMenuPinnedFolderVideos.ToString()
        }

        $enumWindowsSpotlightConfigureOnLockScreen = $null
        if ($null -ne $getValue.windowsSpotlightConfigureOnLockScreen)
        {
            $enumWindowsSpotlightConfigureOnLockScreen = $getValue.windowsSpotlightConfigureOnLockScreen.ToString()
        }
        #endregion

        #region resource generator code
        $timeDefenderScheduledQuickScanTime = $null
        if ($null -ne $getValue.defenderScheduledQuickScanTime)
        {
            $timeDefenderScheduledQuickScanTime = ([TimeSpan]$getValue.defenderScheduledQuickScanTime).ToString()
        }

        $timeDefenderScheduledScanTime = $null
        if ($null -ne $getValue.defenderScheduledScanTime)
        {
            $timeDefenderScheduledScanTime = ([TimeSpan]$getValue.defenderScheduledScanTime).ToString()
        }
        #endregion

        $results = @{
            #region resource generator code
            AccountsBlockAddingNonMicrosoftAccountEmail           = $getValue.accountsBlockAddingNonMicrosoftAccountEmail
            ActivateAppsWithVoice                                 = $enumActivateAppsWithVoice
            AntiTheftModeBlocked                                  = $getValue.antiTheftModeBlocked
            AppManagementMSIAllowUserControlOverInstall           = $getValue.appManagementMSIAllowUserControlOverInstall
            AppManagementMSIAlwaysInstallWithElevatedPrivileges   = $getValue.appManagementMSIAlwaysInstallWithElevatedPrivileges
            AppManagementPackageFamilyNamesToLaunchAfterLogOn     = $getValue.appManagementPackageFamilyNamesToLaunchAfterLogOn
            AppsAllowTrustedAppsSideloading                       = $enumAppsAllowTrustedAppsSideloading
            AppsBlockWindowsStoreOriginatedApps                   = $getValue.appsBlockWindowsStoreOriginatedApps
            AuthenticationAllowSecondaryDevice                    = $getValue.authenticationAllowSecondaryDevice
            AuthenticationPreferredAzureADTenantDomainName        = $getValue.authenticationPreferredAzureADTenantDomainName
            AuthenticationWebSignIn                               = $enumAuthenticationWebSignIn
            BluetoothAllowedServices                              = $getValue.bluetoothAllowedServices
            BluetoothBlockAdvertising                             = $getValue.bluetoothBlockAdvertising
            BluetoothBlockDiscoverableMode                        = $getValue.bluetoothBlockDiscoverableMode
            BluetoothBlocked                                      = $getValue.bluetoothBlocked
            BluetoothBlockPrePairing                              = $getValue.bluetoothBlockPrePairing
            BluetoothBlockPromptedProximalConnections             = $getValue.bluetoothBlockPromptedProximalConnections
            CameraBlocked                                         = $getValue.cameraBlocked
            CellularBlockDataWhenRoaming                          = $getValue.cellularBlockDataWhenRoaming
            CellularBlockVpn                                      = $getValue.cellularBlockVpn
            CellularBlockVpnWhenRoaming                           = $getValue.cellularBlockVpnWhenRoaming
            CellularData                                          = $enumCellularData
            CertificatesBlockManualRootCertificateInstallation    = $getValue.certificatesBlockManualRootCertificateInstallation
            ConfigureTimeZone                                     = $getValue.configureTimeZone
            ConnectedDevicesServiceBlocked                        = $getValue.connectedDevicesServiceBlocked
            CopyPasteBlocked                                      = $getValue.copyPasteBlocked
            CortanaBlocked                                        = $getValue.cortanaBlocked
            CryptographyAllowFipsAlgorithmPolicy                  = $getValue.cryptographyAllowFipsAlgorithmPolicy
            DataProtectionBlockDirectMemoryAccess                 = $getValue.dataProtectionBlockDirectMemoryAccess
            DefenderBlockEndUserAccess                            = $getValue.defenderBlockEndUserAccess
            DefenderBlockOnAccessProtection                       = $getValue.defenderBlockOnAccessProtection
            DefenderCloudBlockLevel                               = $enumDefenderCloudBlockLevel
            DefenderCloudExtendedTimeout                          = $getValue.defenderCloudExtendedTimeout
            DefenderCloudExtendedTimeoutInSeconds                 = $getValue.defenderCloudExtendedTimeoutInSeconds
            DefenderDaysBeforeDeletingQuarantinedMalware          = $getValue.defenderDaysBeforeDeletingQuarantinedMalware
            DefenderDetectedMalwareActions                        = $complexDefenderDetectedMalwareActions
            DefenderDisableCatchupFullScan                        = $getValue.defenderDisableCatchupFullScan
            DefenderDisableCatchupQuickScan                       = $getValue.defenderDisableCatchupQuickScan
            DefenderFileExtensionsToExclude                       = $getValue.defenderFileExtensionsToExclude
            DefenderFilesAndFoldersToExclude                      = $getValue.defenderFilesAndFoldersToExclude
            DefenderMonitorFileActivity                           = $enumDefenderMonitorFileActivity
            DefenderPotentiallyUnwantedAppAction                  = $enumDefenderPotentiallyUnwantedAppAction
            DefenderPotentiallyUnwantedAppActionSetting           = $enumDefenderPotentiallyUnwantedAppActionSetting
            DefenderProcessesToExclude                            = $getValue.defenderProcessesToExclude
            DefenderPromptForSampleSubmission                     = $enumDefenderPromptForSampleSubmission
            DefenderRequireBehaviorMonitoring                     = $getValue.defenderRequireBehaviorMonitoring
            DefenderRequireCloudProtection                        = $getValue.defenderRequireCloudProtection
            DefenderRequireNetworkInspectionSystem                = $getValue.defenderRequireNetworkInspectionSystem
            DefenderRequireRealTimeMonitoring                     = $getValue.defenderRequireRealTimeMonitoring
            DefenderScanArchiveFiles                              = $getValue.defenderScanArchiveFiles
            DefenderScanDownloads                                 = $getValue.defenderScanDownloads
            DefenderScanIncomingMail                              = $getValue.defenderScanIncomingMail
            DefenderScanMappedNetworkDrivesDuringFullScan         = $getValue.defenderScanMappedNetworkDrivesDuringFullScan
            DefenderScanMaxCpu                                    = $getValue.defenderScanMaxCpu
            DefenderScanNetworkFiles                              = $getValue.defenderScanNetworkFiles
            DefenderScanRemovableDrivesDuringFullScan             = $getValue.defenderScanRemovableDrivesDuringFullScan
            DefenderScanScriptsLoadedInInternetExplorer           = $getValue.defenderScanScriptsLoadedInInternetExplorer
            DefenderScanType                                      = $enumDefenderScanType
            DefenderScheduledQuickScanTime                        = $timeDefenderScheduledQuickScanTime
            DefenderScheduledScanTime                             = $timeDefenderScheduledScanTime
            DefenderScheduleScanEnableLowCpuPriority              = $getValue.defenderScheduleScanEnableLowCpuPriority
            DefenderSignatureUpdateIntervalInHours                = $getValue.defenderSignatureUpdateIntervalInHours
            DefenderSubmitSamplesConsentType                      = $enumDefenderSubmitSamplesConsentType
            DefenderSystemScanSchedule                            = $enumDefenderSystemScanSchedule
            DeveloperUnlockSetting                                = $enumDeveloperUnlockSetting
            DeviceManagementBlockFactoryResetOnMobile             = $getValue.deviceManagementBlockFactoryResetOnMobile
            DeviceManagementBlockManualUnenroll                   = $getValue.deviceManagementBlockManualUnenroll
            DiagnosticsDataSubmissionMode                         = $enumDiagnosticsDataSubmissionMode
            DisplayAppListWithGdiDPIScalingTurnedOff              = $getValue.displayAppListWithGdiDPIScalingTurnedOff
            DisplayAppListWithGdiDPIScalingTurnedOn               = $getValue.displayAppListWithGdiDPIScalingTurnedOn
            EdgeAllowStartPagesModification                       = $getValue.edgeAllowStartPagesModification
            EdgeBlockAccessToAboutFlags                           = $getValue.edgeBlockAccessToAboutFlags
            EdgeBlockAddressBarDropdown                           = $getValue.edgeBlockAddressBarDropdown
            EdgeBlockAutofill                                     = $getValue.edgeBlockAutofill
            EdgeBlockCompatibilityList                            = $getValue.edgeBlockCompatibilityList
            EdgeBlockDeveloperTools                               = $getValue.edgeBlockDeveloperTools
            EdgeBlocked                                           = $getValue.edgeBlocked
            EdgeBlockEditFavorites                                = $getValue.edgeBlockEditFavorites
            EdgeBlockExtensions                                   = $getValue.edgeBlockExtensions
            EdgeBlockFullScreenMode                               = $getValue.edgeBlockFullScreenMode
            EdgeBlockInPrivateBrowsing                            = $getValue.edgeBlockInPrivateBrowsing
            EdgeBlockJavaScript                                   = $getValue.edgeBlockJavaScript
            EdgeBlockLiveTileDataCollection                       = $getValue.edgeBlockLiveTileDataCollection
            EdgeBlockPasswordManager                              = $getValue.edgeBlockPasswordManager
            EdgeBlockPopups                                       = $getValue.edgeBlockPopups
            EdgeBlockPrelaunch                                    = $getValue.edgeBlockPrelaunch
            EdgeBlockPrinting                                     = $getValue.edgeBlockPrinting
            EdgeBlockSavingHistory                                = $getValue.edgeBlockSavingHistory
            EdgeBlockSearchEngineCustomization                    = $getValue.edgeBlockSearchEngineCustomization
            EdgeBlockSearchSuggestions                            = $getValue.edgeBlockSearchSuggestions
            EdgeBlockSendingDoNotTrackHeader                      = $getValue.edgeBlockSendingDoNotTrackHeader
            EdgeBlockSendingIntranetTrafficToInternetExplorer     = $getValue.edgeBlockSendingIntranetTrafficToInternetExplorer
            EdgeBlockSideloadingExtensions                        = $getValue.edgeBlockSideloadingExtensions
            EdgeBlockTabPreloading                                = $getValue.edgeBlockTabPreloading
            EdgeBlockWebContentOnNewTabPage                       = $getValue.edgeBlockWebContentOnNewTabPage
            EdgeClearBrowsingDataOnExit                           = $getValue.edgeClearBrowsingDataOnExit
            EdgeCookiePolicy                                      = $enumEdgeCookiePolicy
            EdgeDisableFirstRunPage                               = $getValue.edgeDisableFirstRunPage
            EdgeEnterpriseModeSiteListLocation                    = $getValue.edgeEnterpriseModeSiteListLocation
            EdgeFavoritesBarVisibility                            = $enumEdgeFavoritesBarVisibility
            EdgeFavoritesListLocation                             = $getValue.edgeFavoritesListLocation
            EdgeFirstRunUrl                                       = $getValue.edgeFirstRunUrl
            EdgeHomeButtonConfiguration                           = $complexEdgeHomeButtonConfiguration
            EdgeHomeButtonConfigurationEnabled                    = $getValue.edgeHomeButtonConfigurationEnabled
            EdgeHomepageUrls                                      = $getValue.edgeHomepageUrls
            EdgeKioskModeRestriction                              = $enumEdgeKioskModeRestriction
            EdgeKioskResetAfterIdleTimeInMinutes                  = $getValue.edgeKioskResetAfterIdleTimeInMinutes
            EdgeNewTabPageURL                                     = $getValue.edgeNewTabPageURL
            EdgeOpensWith                                         = $enumEdgeOpensWith
            EdgePreventCertificateErrorOverride                   = $getValue.edgePreventCertificateErrorOverride
            EdgeRequiredExtensionPackageFamilyNames               = $getValue.edgeRequiredExtensionPackageFamilyNames
            EdgeRequireSmartScreen                                = $getValue.edgeRequireSmartScreen
            EdgeSearchEngine                                      = $complexEdgeSearchEngine
            EdgeSendIntranetTrafficToInternetExplorer             = $getValue.edgeSendIntranetTrafficToInternetExplorer
            EdgeShowMessageWhenOpeningInternetExplorerSites       = $enumEdgeShowMessageWhenOpeningInternetExplorerSites
            EdgeSyncFavoritesWithInternetExplorer                 = $getValue.edgeSyncFavoritesWithInternetExplorer
            EdgeTelemetryForMicrosoft365Analytics                 = $enumEdgeTelemetryForMicrosoft365Analytics
            EnableAutomaticRedeployment                           = $getValue.enableAutomaticRedeployment
            EnergySaverOnBatteryThresholdPercentage               = $getValue.energySaverOnBatteryThresholdPercentage
            EnergySaverPluggedInThresholdPercentage               = $getValue.energySaverPluggedInThresholdPercentage
            EnterpriseCloudPrintDiscoveryEndPoint                 = $getValue.enterpriseCloudPrintDiscoveryEndPoint
            EnterpriseCloudPrintDiscoveryMaxLimit                 = $getValue.enterpriseCloudPrintDiscoveryMaxLimit
            EnterpriseCloudPrintMopriaDiscoveryResourceIdentifier = $getValue.enterpriseCloudPrintMopriaDiscoveryResourceIdentifier
            EnterpriseCloudPrintOAuthAuthority                    = $getValue.enterpriseCloudPrintOAuthAuthority
            EnterpriseCloudPrintOAuthClientIdentifier             = $getValue.enterpriseCloudPrintOAuthClientIdentifier
            EnterpriseCloudPrintResourceIdentifier                = $getValue.enterpriseCloudPrintResourceIdentifier
            ExperienceBlockDeviceDiscovery                        = $getValue.experienceBlockDeviceDiscovery
            ExperienceBlockErrorDialogWhenNoSIM                   = $getValue.experienceBlockErrorDialogWhenNoSIM
            ExperienceBlockTaskSwitcher                           = $getValue.experienceBlockTaskSwitcher
            ExperienceDoNotSyncBrowserSettings                    = $enumExperienceDoNotSyncBrowserSettings
            FindMyFiles                                           = $enumFindMyFiles
            GameDvrBlocked                                        = $getValue.gameDvrBlocked
            InkWorkspaceAccess                                    = $enumInkWorkspaceAccess
            InkWorkspaceAccessState                               = $enumInkWorkspaceAccessState
            InkWorkspaceBlockSuggestedApps                        = $getValue.inkWorkspaceBlockSuggestedApps
            InternetSharingBlocked                                = $getValue.internetSharingBlocked
            LocationServicesBlocked                               = $getValue.locationServicesBlocked
            LockScreenActivateAppsWithVoice                       = $enumLockScreenActivateAppsWithVoice
            LockScreenAllowTimeoutConfiguration                   = $getValue.lockScreenAllowTimeoutConfiguration
            LockScreenBlockActionCenterNotifications              = $getValue.lockScreenBlockActionCenterNotifications
            LockScreenBlockCortana                                = $getValue.lockScreenBlockCortana
            LockScreenBlockToastNotifications                     = $getValue.lockScreenBlockToastNotifications
            LockScreenTimeoutInSeconds                            = $getValue.lockScreenTimeoutInSeconds
            LogonBlockFastUserSwitching                           = $getValue.logonBlockFastUserSwitching
            MessagingBlockMMS                                     = $getValue.messagingBlockMMS
            MessagingBlockRichCommunicationServices               = $getValue.messagingBlockRichCommunicationServices
            MessagingBlockSync                                    = $getValue.messagingBlockSync
            MicrosoftAccountBlocked                               = $getValue.microsoftAccountBlocked
            MicrosoftAccountBlockSettingsSync                     = $getValue.microsoftAccountBlockSettingsSync
            MicrosoftAccountSignInAssistantSettings               = $enumMicrosoftAccountSignInAssistantSettings
            NetworkProxyApplySettingsDeviceWide                   = $getValue.networkProxyApplySettingsDeviceWide
            NetworkProxyAutomaticConfigurationUrl                 = $getValue.networkProxyAutomaticConfigurationUrl
            NetworkProxyDisableAutoDetect                         = $getValue.networkProxyDisableAutoDetect
            NetworkProxyServer                                    = $complexNetworkProxyServer
            NfcBlocked                                            = $getValue.nfcBlocked
            OneDriveDisableFileSync                               = $getValue.oneDriveDisableFileSync
            PasswordBlockSimple                                   = $getValue.passwordBlockSimple
            PasswordExpirationDays                                = $getValue.passwordExpirationDays
            PasswordMinimumAgeInDays                              = $getValue.passwordMinimumAgeInDays
            PasswordMinimumCharacterSetCount                      = $getValue.passwordMinimumCharacterSetCount
            PasswordMinimumLength                                 = $getValue.passwordMinimumLength
            PasswordMinutesOfInactivityBeforeScreenTimeout        = $getValue.passwordMinutesOfInactivityBeforeScreenTimeout
            PasswordPreviousPasswordBlockCount                    = $getValue.passwordPreviousPasswordBlockCount
            PasswordRequired                                      = $getValue.passwordRequired
            PasswordRequiredType                                  = $enumPasswordRequiredType
            PasswordRequireWhenResumeFromIdleState                = $getValue.passwordRequireWhenResumeFromIdleState
            PasswordSignInFailureCountBeforeFactoryReset          = $getValue.passwordSignInFailureCountBeforeFactoryReset
            PersonalizationDesktopImageUrl                        = $getValue.personalizationDesktopImageUrl
            PersonalizationLockScreenImageUrl                     = $getValue.personalizationLockScreenImageUrl
            PowerButtonActionOnBattery                            = $enumPowerButtonActionOnBattery
            PowerButtonActionPluggedIn                            = $enumPowerButtonActionPluggedIn
            PowerHybridSleepOnBattery                             = $enumPowerHybridSleepOnBattery
            PowerHybridSleepPluggedIn                             = $enumPowerHybridSleepPluggedIn
            PowerLidCloseActionOnBattery                          = $enumPowerLidCloseActionOnBattery
            PowerLidCloseActionPluggedIn                          = $enumPowerLidCloseActionPluggedIn
            PowerSleepButtonActionOnBattery                       = $enumPowerSleepButtonActionOnBattery
            PowerSleepButtonActionPluggedIn                       = $enumPowerSleepButtonActionPluggedIn
            PrinterBlockAddition                                  = $getValue.printerBlockAddition
            PrinterDefaultName                                    = $getValue.printerDefaultName
            PrinterNames                                          = $getValue.printerNames
            PrivacyAdvertisingId                                  = $enumPrivacyAdvertisingId
            PrivacyAutoAcceptPairingAndConsentPrompts             = $getValue.privacyAutoAcceptPairingAndConsentPrompts
            PrivacyBlockActivityFeed                              = $getValue.privacyBlockActivityFeed
            PrivacyBlockInputPersonalization                      = $getValue.privacyBlockInputPersonalization
            PrivacyBlockPublishUserActivities                     = $getValue.privacyBlockPublishUserActivities
            PrivacyDisableLaunchExperience                        = $getValue.privacyDisableLaunchExperience
            ResetProtectionModeBlocked                            = $getValue.resetProtectionModeBlocked
            SafeSearchFilter                                      = $enumSafeSearchFilter
            ScreenCaptureBlocked                                  = $getValue.screenCaptureBlocked
            SearchBlockDiacritics                                 = $getValue.searchBlockDiacritics
            SearchBlockWebResults                                 = $getValue.searchBlockWebResults
            SearchDisableAutoLanguageDetection                    = $getValue.searchDisableAutoLanguageDetection
            SearchDisableIndexerBackoff                           = $getValue.searchDisableIndexerBackoff
            SearchDisableIndexingEncryptedItems                   = $getValue.searchDisableIndexingEncryptedItems
            SearchDisableIndexingRemovableDrive                   = $getValue.searchDisableIndexingRemovableDrive
            SearchDisableLocation                                 = $getValue.searchDisableLocation
            SearchDisableUseLocation                              = $getValue.searchDisableUseLocation
            SearchEnableAutomaticIndexSizeManangement             = $getValue.searchEnableAutomaticIndexSizeManangement
            SearchEnableRemoteQueries                             = $getValue.searchEnableRemoteQueries
            SecurityBlockAzureADJoinedDevicesAutoEncryption       = $getValue.securityBlockAzureADJoinedDevicesAutoEncryption
            SettingsBlockAccountsPage                             = $getValue.settingsBlockAccountsPage
            SettingsBlockAddProvisioningPackage                   = $getValue.settingsBlockAddProvisioningPackage
            SettingsBlockAppsPage                                 = $getValue.settingsBlockAppsPage
            SettingsBlockChangeLanguage                           = $getValue.settingsBlockChangeLanguage
            SettingsBlockChangePowerSleep                         = $getValue.settingsBlockChangePowerSleep
            SettingsBlockChangeRegion                             = $getValue.settingsBlockChangeRegion
            SettingsBlockChangeSystemTime                         = $getValue.settingsBlockChangeSystemTime
            SettingsBlockDevicesPage                              = $getValue.settingsBlockDevicesPage
            SettingsBlockEaseOfAccessPage                         = $getValue.settingsBlockEaseOfAccessPage
            SettingsBlockEditDeviceName                           = $getValue.settingsBlockEditDeviceName
            SettingsBlockGamingPage                               = $getValue.settingsBlockGamingPage
            SettingsBlockNetworkInternetPage                      = $getValue.settingsBlockNetworkInternetPage
            SettingsBlockPersonalizationPage                      = $getValue.settingsBlockPersonalizationPage
            SettingsBlockPrivacyPage                              = $getValue.settingsBlockPrivacyPage
            SettingsBlockRemoveProvisioningPackage                = $getValue.settingsBlockRemoveProvisioningPackage
            SettingsBlockSettingsApp                              = $getValue.settingsBlockSettingsApp
            SettingsBlockSystemPage                               = $getValue.settingsBlockSystemPage
            SettingsBlockTimeLanguagePage                         = $getValue.settingsBlockTimeLanguagePage
            SettingsBlockUpdateSecurityPage                       = $getValue.settingsBlockUpdateSecurityPage
            SharedUserAppDataAllowed                              = $getValue.sharedUserAppDataAllowed
            SmartScreenAppInstallControl                          = $enumSmartScreenAppInstallControl
            SmartScreenBlockPromptOverride                        = $getValue.smartScreenBlockPromptOverride
            SmartScreenBlockPromptOverrideForFiles                = $getValue.smartScreenBlockPromptOverrideForFiles
            SmartScreenEnableAppInstallControl                    = $getValue.smartScreenEnableAppInstallControl
            StartBlockUnpinningAppsFromTaskbar                    = $getValue.startBlockUnpinningAppsFromTaskbar
            StartMenuAppListVisibility                            = $enumStartMenuAppListVisibility
            StartMenuHideChangeAccountSettings                    = $getValue.startMenuHideChangeAccountSettings
            StartMenuHideFrequentlyUsedApps                       = $getValue.startMenuHideFrequentlyUsedApps
            StartMenuHideHibernate                                = $getValue.startMenuHideHibernate
            StartMenuHideLock                                     = $getValue.startMenuHideLock
            StartMenuHidePowerButton                              = $getValue.startMenuHidePowerButton
            StartMenuHideRecentJumpLists                          = $getValue.startMenuHideRecentJumpLists
            StartMenuHideRecentlyAddedApps                        = $getValue.startMenuHideRecentlyAddedApps
            StartMenuHideRestartOptions                           = $getValue.startMenuHideRestartOptions
            StartMenuHideShutDown                                 = $getValue.startMenuHideShutDown
            StartMenuHideSignOut                                  = $getValue.startMenuHideSignOut
            StartMenuHideSleep                                    = $getValue.startMenuHideSleep
            StartMenuHideSwitchAccount                            = $getValue.startMenuHideSwitchAccount
            StartMenuHideUserTile                                 = $getValue.startMenuHideUserTile
            StartMenuLayoutEdgeAssetsXml                          = $getValue.startMenuLayoutEdgeAssetsXml
            StartMenuLayoutXml                                    = $getValue.startMenuLayoutXml
            StartMenuMode                                         = $enumStartMenuMode
            StartMenuPinnedFolderDocuments                        = $enumStartMenuPinnedFolderDocuments
            StartMenuPinnedFolderDownloads                        = $enumStartMenuPinnedFolderDownloads
            StartMenuPinnedFolderFileExplorer                     = $enumStartMenuPinnedFolderFileExplorer
            StartMenuPinnedFolderHomeGroup                        = $enumStartMenuPinnedFolderHomeGroup
            StartMenuPinnedFolderMusic                            = $enumStartMenuPinnedFolderMusic
            StartMenuPinnedFolderNetwork                          = $enumStartMenuPinnedFolderNetwork
            StartMenuPinnedFolderPersonalFolder                   = $enumStartMenuPinnedFolderPersonalFolder
            StartMenuPinnedFolderPictures                         = $enumStartMenuPinnedFolderPictures
            StartMenuPinnedFolderSettings                         = $enumStartMenuPinnedFolderSettings
            StartMenuPinnedFolderVideos                           = $enumStartMenuPinnedFolderVideos
            StorageBlockRemovableStorage                          = $getValue.storageBlockRemovableStorage
            StorageRequireMobileDeviceEncryption                  = $getValue.storageRequireMobileDeviceEncryption
            StorageRestrictAppDataToSystemVolume                  = $getValue.storageRestrictAppDataToSystemVolume
            StorageRestrictAppInstallToSystemVolume               = $getValue.storageRestrictAppInstallToSystemVolume
            SystemTelemetryProxyServer                            = $getValue.systemTelemetryProxyServer
            TaskManagerBlockEndTask                               = $getValue.taskManagerBlockEndTask
            TenantLockdownRequireNetworkDuringOutOfBoxExperience  = $getValue.tenantLockdownRequireNetworkDuringOutOfBoxExperience
            UninstallBuiltInApps                                  = $getValue.uninstallBuiltInApps
            UsbBlocked                                            = $getValue.usbBlocked
            VoiceRecordingBlocked                                 = $getValue.voiceRecordingBlocked
            WebRtcBlockLocalhostIpAddress                         = $getValue.webRtcBlockLocalhostIpAddress
            WiFiBlockAutomaticConnectHotspots                     = $getValue.wiFiBlockAutomaticConnectHotspots
            WiFiBlocked                                           = $getValue.wiFiBlocked
            WiFiBlockManualConfiguration                          = $getValue.wiFiBlockManualConfiguration
            WiFiScanInterval                                      = $getValue.wiFiScanInterval
            Windows10AppsForceUpdateSchedule                      = $complexWindows10AppsForceUpdateSchedule
            WindowsSpotlightBlockConsumerSpecificFeatures         = $getValue.windowsSpotlightBlockConsumerSpecificFeatures
            WindowsSpotlightBlocked                               = $getValue.windowsSpotlightBlocked
            WindowsSpotlightBlockOnActionCenter                   = $getValue.windowsSpotlightBlockOnActionCenter
            WindowsSpotlightBlockTailoredExperiences              = $getValue.windowsSpotlightBlockTailoredExperiences
            WindowsSpotlightBlockThirdPartyNotifications          = $getValue.windowsSpotlightBlockThirdPartyNotifications
            WindowsSpotlightBlockWelcomeExperience                = $getValue.windowsSpotlightBlockWelcomeExperience
            WindowsSpotlightBlockWindowsTips                      = $getValue.windowsSpotlightBlockWindowsTips
            WindowsSpotlightConfigureOnLockScreen                 = $enumWindowsSpotlightConfigureOnLockScreen
            WindowsStoreBlockAutoUpdate                           = $getValue.windowsStoreBlockAutoUpdate
            WindowsStoreBlocked                                   = $getValue.windowsStoreBlocked
            WindowsStoreEnablePrivateStoreOnly                    = $getValue.windowsStoreEnablePrivateStoreOnly
            WirelessDisplayBlockProjectionToThisDevice            = $getValue.wirelessDisplayBlockProjectionToThisDevice
            WirelessDisplayBlockUserInputFromReceiver             = $getValue.wirelessDisplayBlockUserInputFromReceiver
            WirelessDisplayRequirePinForPairing                   = $getValue.wirelessDisplayRequirePinForPairing
            Description                                           = $getValue.Description
            DisplayName                                           = $getValue.DisplayName
            Id                                                    = $getValue.Id
            RoleScopeTagIds                                       = $getValue.RoleScopeTagIds
            Ensure                                                = 'Present'
            Credential                                            = $Credential
            ApplicationId                                         = $ApplicationId
            TenantId                                              = $TenantId
            ApplicationSecret                                     = $ApplicationSecret
            CertificateThumbprint                                 = $CertificateThumbprint
            CertificatePath                                       = $CertificatePath
            CertificatePassword                                   = $CertificatePassword
            ManagedIdentity                                       = $ManagedIdentity.IsPresent
            AccessTokens                                          = $AccessTokens
            #endregion
        }

        $rawAssignments = @()
        $rawAssignments = Get-MgBetaDeviceManagementDeviceConfigurationAssignment -DeviceConfigurationId $Id -All
        $assignmentResult = @()
        if ($null -ne $rawAssignments -and $rawAssignments.Count -gt 0)
        {
            $assignmentResult += ConvertFrom-IntunePolicyAssignment -Assignments $rawAssignments
        }
        $results.Add('Assignments', $assignmentResult)

        return $results
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.Boolean]
        $AccountsBlockAddingNonMicrosoftAccountEmail,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $ActivateAppsWithVoice,

        [Parameter()]
        [System.Boolean]
        $AntiTheftModeBlocked,

        [Parameter()]
        [System.Boolean]
        $AppManagementMSIAllowUserControlOverInstall,

        [Parameter()]
        [System.Boolean]
        $AppManagementMSIAlwaysInstallWithElevatedPrivileges,

        [Parameter()]
        [System.String[]]
        $AppManagementPackageFamilyNamesToLaunchAfterLogOn,

        [Parameter()]
        [ValidateSet('notConfigured', 'blocked', 'allowed')]
        [System.String]
        $AppsAllowTrustedAppsSideloading,

        [Parameter()]
        [System.Boolean]
        $AppsBlockWindowsStoreOriginatedApps,

        [Parameter()]
        [System.Boolean]
        $AuthenticationAllowSecondaryDevice,

        [Parameter()]
        [System.String]
        $AuthenticationPreferredAzureADTenantDomainName,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $AuthenticationWebSignIn,

        [Parameter()]
        [System.String[]]
        $BluetoothAllowedServices,

        [Parameter()]
        [System.Boolean]
        $BluetoothBlockAdvertising,

        [Parameter()]
        [System.Boolean]
        $BluetoothBlockDiscoverableMode,

        [Parameter()]
        [System.Boolean]
        $BluetoothBlocked,

        [Parameter()]
        [System.Boolean]
        $BluetoothBlockPrePairing,

        [Parameter()]
        [System.Boolean]
        $BluetoothBlockPromptedProximalConnections,

        [Parameter()]
        [System.Boolean]
        $CameraBlocked,

        [Parameter()]
        [System.Boolean]
        $CellularBlockDataWhenRoaming,

        [Parameter()]
        [System.Boolean]
        $CellularBlockVpn,

        [Parameter()]
        [System.Boolean]
        $CellularBlockVpnWhenRoaming,

        [Parameter()]
        [ValidateSet('blocked', 'required', 'allowed', 'notConfigured')]
        [System.String]
        $CellularData,

        [Parameter()]
        [System.Boolean]
        $CertificatesBlockManualRootCertificateInstallation,

        [Parameter()]
        [System.String]
        $ConfigureTimeZone,

        [Parameter()]
        [System.Boolean]
        $ConnectedDevicesServiceBlocked,

        [Parameter()]
        [System.Boolean]
        $CopyPasteBlocked,

        [Parameter()]
        [System.Boolean]
        $CortanaBlocked,

        [Parameter()]
        [System.Boolean]
        $CryptographyAllowFipsAlgorithmPolicy,

        [Parameter()]
        [System.Boolean]
        $DataProtectionBlockDirectMemoryAccess,

        [Parameter()]
        [System.Boolean]
        $DefenderBlockEndUserAccess,

        [Parameter()]
        [System.Boolean]
        $DefenderBlockOnAccessProtection,

        [Parameter()]
        [ValidateSet('notConfigured', 'high', 'highPlus', 'zeroTolerance')]
        [System.String]
        $DefenderCloudBlockLevel,

        [Parameter()]
        [System.Int32]
        $DefenderCloudExtendedTimeout,

        [Parameter()]
        [System.Int32]
        $DefenderCloudExtendedTimeoutInSeconds,

        [Parameter()]
        [System.Int32]
        $DefenderDaysBeforeDeletingQuarantinedMalware,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DefenderDetectedMalwareActions,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableCatchupFullScan,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableCatchupQuickScan,

        [Parameter()]
        [System.String[]]
        $DefenderFileExtensionsToExclude,

        [Parameter()]
        [System.String[]]
        $DefenderFilesAndFoldersToExclude,

        [Parameter()]
        [ValidateSet('userDefined', 'disable', 'monitorAllFiles', 'monitorIncomingFilesOnly', 'monitorOutgoingFilesOnly')]
        [System.String]
        $DefenderMonitorFileActivity,

        [Parameter()]
        [ValidateSet('deviceDefault', 'block', 'audit')]
        [System.String]
        $DefenderPotentiallyUnwantedAppAction,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderPotentiallyUnwantedAppActionSetting,

        [Parameter()]
        [System.String[]]
        $DefenderProcessesToExclude,

        [Parameter()]
        [ValidateSet('userDefined', 'alwaysPrompt', 'promptBeforeSendingPersonalData', 'neverSendData', 'sendAllDataWithoutPrompting')]
        [System.String]
        $DefenderPromptForSampleSubmission,

        [Parameter()]
        [System.Boolean]
        $DefenderRequireBehaviorMonitoring,

        [Parameter()]
        [System.Boolean]
        $DefenderRequireCloudProtection,

        [Parameter()]
        [System.Boolean]
        $DefenderRequireNetworkInspectionSystem,

        [Parameter()]
        [System.Boolean]
        $DefenderRequireRealTimeMonitoring,

        [Parameter()]
        [System.Boolean]
        $DefenderScanArchiveFiles,

        [Parameter()]
        [System.Boolean]
        $DefenderScanDownloads,

        [Parameter()]
        [System.Boolean]
        $DefenderScanIncomingMail,

        [Parameter()]
        [System.Boolean]
        $DefenderScanMappedNetworkDrivesDuringFullScan,

        [Parameter()]
        [System.Int32]
        $DefenderScanMaxCpu,

        [Parameter()]
        [System.Boolean]
        $DefenderScanNetworkFiles,

        [Parameter()]
        [System.Boolean]
        $DefenderScanRemovableDrivesDuringFullScan,

        [Parameter()]
        [System.Boolean]
        $DefenderScanScriptsLoadedInInternetExplorer,

        [Parameter()]
        [ValidateSet('userDefined', 'disabled', 'quick', 'full')]
        [System.String]
        $DefenderScanType,

        [Parameter()]
        [System.TimeSpan]
        $DefenderScheduledQuickScanTime,

        [Parameter()]
        [System.TimeSpan]
        $DefenderScheduledScanTime,

        [Parameter()]
        [System.Boolean]
        $DefenderScheduleScanEnableLowCpuPriority,

        [Parameter()]
        [System.Int32]
        $DefenderSignatureUpdateIntervalInHours,

        [Parameter()]
        [ValidateSet('sendSafeSamplesAutomatically', 'alwaysPrompt', 'neverSend', 'sendAllSamplesAutomatically')]
        [System.String]
        $DefenderSubmitSamplesConsentType,

        [Parameter()]
        [ValidateSet('userDefined', 'everyday', 'sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'noScheduledScan')]
        [System.String]
        $DefenderSystemScanSchedule,

        [Parameter()]
        [ValidateSet('notConfigured', 'blocked', 'allowed')]
        [System.String]
        $DeveloperUnlockSetting,

        [Parameter()]
        [System.Boolean]
        $DeviceManagementBlockFactoryResetOnMobile,

        [Parameter()]
        [System.Boolean]
        $DeviceManagementBlockManualUnenroll,

        [Parameter()]
        [ValidateSet('userDefined', 'none', 'basic', 'enhanced', 'full')]
        [System.String]
        $DiagnosticsDataSubmissionMode,

        [Parameter()]
        [System.String[]]
        $DisplayAppListWithGdiDPIScalingTurnedOff,

        [Parameter()]
        [System.String[]]
        $DisplayAppListWithGdiDPIScalingTurnedOn,

        [Parameter()]
        [System.Boolean]
        $EdgeAllowStartPagesModification,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockAccessToAboutFlags,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockAddressBarDropdown,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockAutofill,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockCompatibilityList,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockDeveloperTools,

        [Parameter()]
        [System.Boolean]
        $EdgeBlocked,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockEditFavorites,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockExtensions,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockFullScreenMode,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockInPrivateBrowsing,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockJavaScript,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockLiveTileDataCollection,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockPasswordManager,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockPopups,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockPrelaunch,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockPrinting,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockSavingHistory,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockSearchEngineCustomization,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockSearchSuggestions,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockSendingDoNotTrackHeader,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockSendingIntranetTrafficToInternetExplorer,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockSideloadingExtensions,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockTabPreloading,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockWebContentOnNewTabPage,

        [Parameter()]
        [System.Boolean]
        $EdgeClearBrowsingDataOnExit,

        [Parameter()]
        [ValidateSet('userDefined', 'allow', 'blockThirdParty', 'blockAll')]
        [System.String]
        $EdgeCookiePolicy,

        [Parameter()]
        [System.Boolean]
        $EdgeDisableFirstRunPage,

        [Parameter()]
        [System.String]
        $EdgeEnterpriseModeSiteListLocation,

        [Parameter()]
        [ValidateSet('notConfigured', 'hide', 'show')]
        [System.String]
        $EdgeFavoritesBarVisibility,

        [Parameter()]
        [System.String]
        $EdgeFavoritesListLocation,

        [Parameter()]
        [System.String]
        $EdgeFirstRunUrl,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EdgeHomeButtonConfiguration,

        [Parameter()]
        [System.Boolean]
        $EdgeHomeButtonConfigurationEnabled,

        [Parameter()]
        [System.String[]]
        $EdgeHomepageUrls,

        [Parameter()]
        [ValidateSet('notConfigured', 'digitalSignage', 'normalMode', 'publicBrowsingSingleApp', 'publicBrowsingMultiApp')]
        [System.String]
        $EdgeKioskModeRestriction,

        [Parameter()]
        [System.Int32]
        $EdgeKioskResetAfterIdleTimeInMinutes,

        [Parameter()]
        [System.String]
        $EdgeNewTabPageURL,

        [Parameter()]
        [ValidateSet('notConfigured', 'startPage', 'newTabPage', 'previousPages', 'specificPages')]
        [System.String]
        $EdgeOpensWith,

        [Parameter()]
        [System.Boolean]
        $EdgePreventCertificateErrorOverride,

        [Parameter()]
        [System.String[]]
        $EdgeRequiredExtensionPackageFamilyNames,

        [Parameter()]
        [System.Boolean]
        $EdgeRequireSmartScreen,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EdgeSearchEngine,

        [Parameter()]
        [System.Boolean]
        $EdgeSendIntranetTrafficToInternetExplorer,

        [Parameter()]
        [ValidateSet('notConfigured', 'disabled', 'enabled', 'keepGoing')]
        [System.String]
        $EdgeShowMessageWhenOpeningInternetExplorerSites,

        [Parameter()]
        [System.Boolean]
        $EdgeSyncFavoritesWithInternetExplorer,

        [Parameter()]
        [ValidateSet('notConfigured', 'intranet', 'internet', 'intranetAndInternet')]
        [System.String]
        $EdgeTelemetryForMicrosoft365Analytics,

        [Parameter()]
        [System.Boolean]
        $EnableAutomaticRedeployment,

        [Parameter()]
        [System.Int32]
        $EnergySaverOnBatteryThresholdPercentage,

        [Parameter()]
        [System.Int32]
        $EnergySaverPluggedInThresholdPercentage,

        [Parameter()]
        [System.String]
        $EnterpriseCloudPrintDiscoveryEndPoint,

        [Parameter()]
        [System.Int32]
        $EnterpriseCloudPrintDiscoveryMaxLimit,

        [Parameter()]
        [System.String]
        $EnterpriseCloudPrintMopriaDiscoveryResourceIdentifier,

        [Parameter()]
        [System.String]
        $EnterpriseCloudPrintOAuthAuthority,

        [Parameter()]
        [System.String]
        $EnterpriseCloudPrintOAuthClientIdentifier,

        [Parameter()]
        [System.String]
        $EnterpriseCloudPrintResourceIdentifier,

        [Parameter()]
        [System.Boolean]
        $ExperienceBlockDeviceDiscovery,

        [Parameter()]
        [System.Boolean]
        $ExperienceBlockErrorDialogWhenNoSIM,

        [Parameter()]
        [System.Boolean]
        $ExperienceBlockTaskSwitcher,

        [Parameter()]
        [ValidateSet('notConfigured', 'blockedWithUserOverride', 'blocked')]
        [System.String]
        $ExperienceDoNotSyncBrowserSettings,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $FindMyFiles,

        [Parameter()]
        [System.Boolean]
        $GameDvrBlocked,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $InkWorkspaceAccess,

        [Parameter()]
        [ValidateSet('notConfigured', 'blocked', 'allowed')]
        [System.String]
        $InkWorkspaceAccessState,

        [Parameter()]
        [System.Boolean]
        $InkWorkspaceBlockSuggestedApps,

        [Parameter()]
        [System.Boolean]
        $InternetSharingBlocked,

        [Parameter()]
        [System.Boolean]
        $LocationServicesBlocked,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $LockScreenActivateAppsWithVoice,

        [Parameter()]
        [System.Boolean]
        $LockScreenAllowTimeoutConfiguration,

        [Parameter()]
        [System.Boolean]
        $LockScreenBlockActionCenterNotifications,

        [Parameter()]
        [System.Boolean]
        $LockScreenBlockCortana,

        [Parameter()]
        [System.Boolean]
        $LockScreenBlockToastNotifications,

        [Parameter()]
        [System.Int32]
        $LockScreenTimeoutInSeconds,

        [Parameter()]
        [System.Boolean]
        $LogonBlockFastUserSwitching,

        [Parameter()]
        [System.Boolean]
        $MessagingBlockMMS,

        [Parameter()]
        [System.Boolean]
        $MessagingBlockRichCommunicationServices,

        [Parameter()]
        [System.Boolean]
        $MessagingBlockSync,

        [Parameter()]
        [System.Boolean]
        $MicrosoftAccountBlocked,

        [Parameter()]
        [System.Boolean]
        $MicrosoftAccountBlockSettingsSync,

        [Parameter()]
        [ValidateSet('notConfigured', 'disabled')]
        [System.String]
        $MicrosoftAccountSignInAssistantSettings,

        [Parameter()]
        [System.Boolean]
        $NetworkProxyApplySettingsDeviceWide,

        [Parameter()]
        [System.String]
        $NetworkProxyAutomaticConfigurationUrl,

        [Parameter()]
        [System.Boolean]
        $NetworkProxyDisableAutoDetect,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $NetworkProxyServer,

        [Parameter()]
        [System.Boolean]
        $NfcBlocked,

        [Parameter()]
        [System.Boolean]
        $OneDriveDisableFileSync,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockSimple,

        [Parameter()]
        [System.Int32]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumAgeInDays,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumCharacterSetCount,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeScreenTimeout,

        [Parameter()]
        [System.Int32]
        $PasswordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Boolean]
        $PasswordRequired,

        [Parameter()]
        [ValidateSet('deviceDefault', 'alphanumeric', 'numeric')]
        [System.String]
        $PasswordRequiredType,

        [Parameter()]
        [System.Boolean]
        $PasswordRequireWhenResumeFromIdleState,

        [Parameter()]
        [System.Int32]
        $PasswordSignInFailureCountBeforeFactoryReset,

        [Parameter()]
        [System.String]
        $PersonalizationDesktopImageUrl,

        [Parameter()]
        [System.String]
        $PersonalizationLockScreenImageUrl,

        [Parameter()]
        [ValidateSet('notConfigured', 'noAction', 'sleep', 'hibernate', 'shutdown')]
        [System.String]
        $PowerButtonActionOnBattery,

        [Parameter()]
        [ValidateSet('notConfigured', 'noAction', 'sleep', 'hibernate', 'shutdown')]
        [System.String]
        $PowerButtonActionPluggedIn,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $PowerHybridSleepOnBattery,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $PowerHybridSleepPluggedIn,

        [Parameter()]
        [ValidateSet('notConfigured', 'noAction', 'sleep', 'hibernate', 'shutdown')]
        [System.String]
        $PowerLidCloseActionOnBattery,

        [Parameter()]
        [ValidateSet('notConfigured', 'noAction', 'sleep', 'hibernate', 'shutdown')]
        [System.String]
        $PowerLidCloseActionPluggedIn,

        [Parameter()]
        [ValidateSet('notConfigured', 'noAction', 'sleep', 'hibernate', 'shutdown')]
        [System.String]
        $PowerSleepButtonActionOnBattery,

        [Parameter()]
        [ValidateSet('notConfigured', 'noAction', 'sleep', 'hibernate', 'shutdown')]
        [System.String]
        $PowerSleepButtonActionPluggedIn,

        [Parameter()]
        [System.Boolean]
        $PrinterBlockAddition,

        [Parameter()]
        [System.String]
        $PrinterDefaultName,

        [Parameter()]
        [System.String[]]
        $PrinterNames,

        [Parameter()]
        [ValidateSet('notConfigured', 'blocked', 'allowed')]
        [System.String]
        $PrivacyAdvertisingId,

        [Parameter()]
        [System.Boolean]
        $PrivacyAutoAcceptPairingAndConsentPrompts,

        [Parameter()]
        [System.Boolean]
        $PrivacyBlockActivityFeed,

        [Parameter()]
        [System.Boolean]
        $PrivacyBlockInputPersonalization,

        [Parameter()]
        [System.Boolean]
        $PrivacyBlockPublishUserActivities,

        [Parameter()]
        [System.Boolean]
        $PrivacyDisableLaunchExperience,

        [Parameter()]
        [System.Boolean]
        $ResetProtectionModeBlocked,

        [Parameter()]
        [ValidateSet('userDefined', 'strict', 'moderate')]
        [System.String]
        $SafeSearchFilter,

        [Parameter()]
        [System.Boolean]
        $ScreenCaptureBlocked,

        [Parameter()]
        [System.Boolean]
        $SearchBlockDiacritics,

        [Parameter()]
        [System.Boolean]
        $SearchBlockWebResults,

        [Parameter()]
        [System.Boolean]
        $SearchDisableAutoLanguageDetection,

        [Parameter()]
        [System.Boolean]
        $SearchDisableIndexerBackoff,

        [Parameter()]
        [System.Boolean]
        $SearchDisableIndexingEncryptedItems,

        [Parameter()]
        [System.Boolean]
        $SearchDisableIndexingRemovableDrive,

        [Parameter()]
        [System.Boolean]
        $SearchDisableLocation,

        [Parameter()]
        [System.Boolean]
        $SearchDisableUseLocation,

        [Parameter()]
        [System.Boolean]
        $SearchEnableAutomaticIndexSizeManangement,

        [Parameter()]
        [System.Boolean]
        $SearchEnableRemoteQueries,

        [Parameter()]
        [System.Boolean]
        $SecurityBlockAzureADJoinedDevicesAutoEncryption,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockAccountsPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockAddProvisioningPackage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockAppsPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockChangeLanguage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockChangePowerSleep,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockChangeRegion,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockChangeSystemTime,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockDevicesPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockEaseOfAccessPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockEditDeviceName,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockGamingPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockNetworkInternetPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockPersonalizationPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockPrivacyPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockRemoveProvisioningPackage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockSettingsApp,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockSystemPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockTimeLanguagePage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockUpdateSecurityPage,

        [Parameter()]
        [System.Boolean]
        $SharedUserAppDataAllowed,

        [Parameter()]
        [ValidateSet('notConfigured', 'anywhere', 'storeOnly', 'recommendations', 'preferStore')]
        [System.String]
        $SmartScreenAppInstallControl,

        [Parameter()]
        [System.Boolean]
        $SmartScreenBlockPromptOverride,

        [Parameter()]
        [System.Boolean]
        $SmartScreenBlockPromptOverrideForFiles,

        [Parameter()]
        [System.Boolean]
        $SmartScreenEnableAppInstallControl,

        [Parameter()]
        [System.Boolean]
        $StartBlockUnpinningAppsFromTaskbar,

        [Parameter()]
        [ValidateSet('userDefined', 'collapse', 'remove', 'disableSettingsApp')]
        [System.String]
        $StartMenuAppListVisibility,

        [Parameter()]
        [System.Boolean]
        $StartMenuHideChangeAccountSettings,

        [Parameter()]
        [System.Boolean]
        $StartMenuHideFrequentlyUsedApps,

        [Parameter()]
        [System.Boolean]
        $StartMenuHideHibernate,

        [Parameter()]
        [System.Boolean]
        $StartMenuHideLock,

        [Parameter()]
        [System.Boolean]
        $StartMenuHidePowerButton,

        [Parameter()]
        [System.Boolean]
        $StartMenuHideRecentJumpLists,

        [Parameter()]
        [System.Boolean]
        $StartMenuHideRecentlyAddedApps,

        [Parameter()]
        [System.Boolean]
        $StartMenuHideRestartOptions,

        [Parameter()]
        [System.Boolean]
        $StartMenuHideShutDown,

        [Parameter()]
        [System.Boolean]
        $StartMenuHideSignOut,

        [Parameter()]
        [System.Boolean]
        $StartMenuHideSleep,

        [Parameter()]
        [System.Boolean]
        $StartMenuHideSwitchAccount,

        [Parameter()]
        [System.Boolean]
        $StartMenuHideUserTile,

        [Parameter()]
        [System.String]
        $StartMenuLayoutEdgeAssetsXml,

        [Parameter()]
        [System.String]
        $StartMenuLayoutXml,

        [Parameter()]
        [ValidateSet('userDefined', 'fullScreen', 'nonFullScreen')]
        [System.String]
        $StartMenuMode,

        [Parameter()]
        [ValidateSet('notConfigured', 'hide', 'show')]
        [System.String]
        $StartMenuPinnedFolderDocuments,

        [Parameter()]
        [ValidateSet('notConfigured', 'hide', 'show')]
        [System.String]
        $StartMenuPinnedFolderDownloads,

        [Parameter()]
        [ValidateSet('notConfigured', 'hide', 'show')]
        [System.String]
        $StartMenuPinnedFolderFileExplorer,

        [Parameter()]
        [ValidateSet('notConfigured', 'hide', 'show')]
        [System.String]
        $StartMenuPinnedFolderHomeGroup,

        [Parameter()]
        [ValidateSet('notConfigured', 'hide', 'show')]
        [System.String]
        $StartMenuPinnedFolderMusic,

        [Parameter()]
        [ValidateSet('notConfigured', 'hide', 'show')]
        [System.String]
        $StartMenuPinnedFolderNetwork,

        [Parameter()]
        [ValidateSet('notConfigured', 'hide', 'show')]
        [System.String]
        $StartMenuPinnedFolderPersonalFolder,

        [Parameter()]
        [ValidateSet('notConfigured', 'hide', 'show')]
        [System.String]
        $StartMenuPinnedFolderPictures,

        [Parameter()]
        [ValidateSet('notConfigured', 'hide', 'show')]
        [System.String]
        $StartMenuPinnedFolderSettings,

        [Parameter()]
        [ValidateSet('notConfigured', 'hide', 'show')]
        [System.String]
        $StartMenuPinnedFolderVideos,

        [Parameter()]
        [System.Boolean]
        $StorageBlockRemovableStorage,

        [Parameter()]
        [System.Boolean]
        $StorageRequireMobileDeviceEncryption,

        [Parameter()]
        [System.Boolean]
        $StorageRestrictAppDataToSystemVolume,

        [Parameter()]
        [System.Boolean]
        $StorageRestrictAppInstallToSystemVolume,

        [Parameter()]
        [System.String]
        $SystemTelemetryProxyServer,

        [Parameter()]
        [System.Boolean]
        $TaskManagerBlockEndTask,

        [Parameter()]
        [System.Boolean]
        $TenantLockdownRequireNetworkDuringOutOfBoxExperience,

        [Parameter()]
        [System.Boolean]
        $UninstallBuiltInApps,

        [Parameter()]
        [System.Boolean]
        $UsbBlocked,

        [Parameter()]
        [System.Boolean]
        $VoiceRecordingBlocked,

        [Parameter()]
        [System.Boolean]
        $WebRtcBlockLocalhostIpAddress,

        [Parameter()]
        [System.Boolean]
        $WiFiBlockAutomaticConnectHotspots,

        [Parameter()]
        [System.Boolean]
        $WiFiBlocked,

        [Parameter()]
        [System.Boolean]
        $WiFiBlockManualConfiguration,

        [Parameter()]
        [System.Int32]
        $WiFiScanInterval,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $Windows10AppsForceUpdateSchedule,

        [Parameter()]
        [System.Boolean]
        $WindowsSpotlightBlockConsumerSpecificFeatures,

        [Parameter()]
        [System.Boolean]
        $WindowsSpotlightBlocked,

        [Parameter()]
        [System.Boolean]
        $WindowsSpotlightBlockOnActionCenter,

        [Parameter()]
        [System.Boolean]
        $WindowsSpotlightBlockTailoredExperiences,

        [Parameter()]
        [System.Boolean]
        $WindowsSpotlightBlockThirdPartyNotifications,

        [Parameter()]
        [System.Boolean]
        $WindowsSpotlightBlockWelcomeExperience,

        [Parameter()]
        [System.Boolean]
        $WindowsSpotlightBlockWindowsTips,

        [Parameter()]
        [ValidateSet('notConfigured', 'disabled', 'enabled')]
        [System.String]
        $WindowsSpotlightConfigureOnLockScreen,

        [Parameter()]
        [System.Boolean]
        $WindowsStoreBlockAutoUpdate,

        [Parameter()]
        [System.Boolean]
        $WindowsStoreBlocked,

        [Parameter()]
        [System.Boolean]
        $WindowsStoreEnablePrivateStoreOnly,

        [Parameter()]
        [System.Boolean]
        $WirelessDisplayBlockProjectionToThisDevice,

        [Parameter()]
        [System.Boolean]
        $WirelessDisplayBlockUserInputFromReceiver,

        [Parameter()]
        [System.Boolean]
        $WirelessDisplayRequirePinForPairing,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
        #endregion
        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentInstance = Get-TargetResource @PSBoundParameters

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Device Configuration Policy for Windows10 with DisplayName {$DisplayName}"
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $CreateParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
        $createParameters = Rename-M365DSCCimInstanceParameter -Properties $createParameters
        $createParameters.Remove('Id') | Out-Null

        #region resource generator code
        $CreateParameters.Add('@odata.type', '#microsoft.graph.windows10GeneralConfiguration')
        $policy = New-MgBetaDeviceManagementDeviceConfiguration -BodyParameter $CreateParameters
        #endregion
        #region new Intune assignment management
        if ($policy.id)
        {
            $intuneAssignments = @()
            if ($null -ne $Assignments -and $Assignments.Count -gt 0)
            {
                $intuneAssignments += ConvertTo-IntunePolicyAssignment -Assignments $Assignments
            }
            foreach ($assignment in $intuneAssignments)
            {
                New-MgBetaDeviceManagementDeviceConfigurationAssignment `
                    -DeviceConfigurationId $policy.id `
                    -BodyParameter $assignment
            }
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune Device Configuration Policy for Windows10 with Id {$($currentInstance.Id)}"
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $UpdateParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
        $UpdateParameters = Rename-M365DSCCimInstanceParameter -Properties $UpdateParameters
        $UpdateParameters.Remove('Id') | Out-Null

        #region resource generator code
        $UpdateParameters.Add('@odata.type', '#microsoft.graph.windows10GeneralConfiguration')
        Update-MgBetaDeviceManagementDeviceConfiguration `
            -DeviceConfigurationId $currentInstance.Id `
            -BodyParameter $UpdateParameters
        #endregion
        #region new Intune assignment management
        $currentAssignments = @()
        $currentAssignments += Get-MgBetaDeviceManagementDeviceConfigurationAssignment -DeviceConfigurationId $currentInstance.id

        $intuneAssignments = @()
        if ($null -ne $Assignments -and $Assignments.Count -gt 0)
        {
            $intuneAssignments += ConvertTo-IntunePolicyAssignment -Assignments $Assignments
        }
        foreach ($assignment in $intuneAssignments)
        {
            if ( $null -eq ($currentAssignments | Where-Object { $_.Target.groupId -eq $assignment.Target.groupId -and $_.Target.'@odata.type' -eq $assignment.Target.'@odata.type' }))
            {
                New-MgBetaDeviceManagementDeviceConfigurationAssignment `
                    -DeviceConfigurationId $currentInstance.id `
                    -BodyParameter $assignment
            }
            else
            {
                $currentAssignments = $currentAssignments | Where-Object { -not ($_.Target.groupId -eq $assignment.Target.groupId -and $_.Target.'@odata.type' -eq $assignment.Target.'@odata.type') }
            }
        }
        if ($currentAssignments.Count -gt 0)
        {
            foreach ($assignment in $currentAssignments)
            {
                Remove-MgBetaDeviceManagementDeviceConfigurationAssignment `
                    -DeviceConfigurationId $currentInstance.Id `
                    -DeviceConfigurationAssignmentId $assignment.Id
            }
        }
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune Device Configuration Policy for Windows10 with Id {$($currentInstance.Id)}"
        #region resource generator code
        Remove-MgBetaDeviceManagementDeviceConfiguration -DeviceConfigurationId $currentInstance.Id
        #endregion
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.Boolean]
        $AccountsBlockAddingNonMicrosoftAccountEmail,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $ActivateAppsWithVoice,

        [Parameter()]
        [System.Boolean]
        $AntiTheftModeBlocked,

        [Parameter()]
        [System.Boolean]
        $AppManagementMSIAllowUserControlOverInstall,

        [Parameter()]
        [System.Boolean]
        $AppManagementMSIAlwaysInstallWithElevatedPrivileges,

        [Parameter()]
        [System.String[]]
        $AppManagementPackageFamilyNamesToLaunchAfterLogOn,

        [Parameter()]
        [ValidateSet('notConfigured', 'blocked', 'allowed')]
        [System.String]
        $AppsAllowTrustedAppsSideloading,

        [Parameter()]
        [System.Boolean]
        $AppsBlockWindowsStoreOriginatedApps,

        [Parameter()]
        [System.Boolean]
        $AuthenticationAllowSecondaryDevice,

        [Parameter()]
        [System.String]
        $AuthenticationPreferredAzureADTenantDomainName,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $AuthenticationWebSignIn,

        [Parameter()]
        [System.String[]]
        $BluetoothAllowedServices,

        [Parameter()]
        [System.Boolean]
        $BluetoothBlockAdvertising,

        [Parameter()]
        [System.Boolean]
        $BluetoothBlockDiscoverableMode,

        [Parameter()]
        [System.Boolean]
        $BluetoothBlocked,

        [Parameter()]
        [System.Boolean]
        $BluetoothBlockPrePairing,

        [Parameter()]
        [System.Boolean]
        $BluetoothBlockPromptedProximalConnections,

        [Parameter()]
        [System.Boolean]
        $CameraBlocked,

        [Parameter()]
        [System.Boolean]
        $CellularBlockDataWhenRoaming,

        [Parameter()]
        [System.Boolean]
        $CellularBlockVpn,

        [Parameter()]
        [System.Boolean]
        $CellularBlockVpnWhenRoaming,

        [Parameter()]
        [ValidateSet('blocked', 'required', 'allowed', 'notConfigured')]
        [System.String]
        $CellularData,

        [Parameter()]
        [System.Boolean]
        $CertificatesBlockManualRootCertificateInstallation,

        [Parameter()]
        [System.String]
        $ConfigureTimeZone,

        [Parameter()]
        [System.Boolean]
        $ConnectedDevicesServiceBlocked,

        [Parameter()]
        [System.Boolean]
        $CopyPasteBlocked,

        [Parameter()]
        [System.Boolean]
        $CortanaBlocked,

        [Parameter()]
        [System.Boolean]
        $CryptographyAllowFipsAlgorithmPolicy,

        [Parameter()]
        [System.Boolean]
        $DataProtectionBlockDirectMemoryAccess,

        [Parameter()]
        [System.Boolean]
        $DefenderBlockEndUserAccess,

        [Parameter()]
        [System.Boolean]
        $DefenderBlockOnAccessProtection,

        [Parameter()]
        [ValidateSet('notConfigured', 'high', 'highPlus', 'zeroTolerance')]
        [System.String]
        $DefenderCloudBlockLevel,

        [Parameter()]
        [System.Int32]
        $DefenderCloudExtendedTimeout,

        [Parameter()]
        [System.Int32]
        $DefenderCloudExtendedTimeoutInSeconds,

        [Parameter()]
        [System.Int32]
        $DefenderDaysBeforeDeletingQuarantinedMalware,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DefenderDetectedMalwareActions,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableCatchupFullScan,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableCatchupQuickScan,

        [Parameter()]
        [System.String[]]
        $DefenderFileExtensionsToExclude,

        [Parameter()]
        [System.String[]]
        $DefenderFilesAndFoldersToExclude,

        [Parameter()]
        [ValidateSet('userDefined', 'disable', 'monitorAllFiles', 'monitorIncomingFilesOnly', 'monitorOutgoingFilesOnly')]
        [System.String]
        $DefenderMonitorFileActivity,

        [Parameter()]
        [ValidateSet('deviceDefault', 'block', 'audit')]
        [System.String]
        $DefenderPotentiallyUnwantedAppAction,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderPotentiallyUnwantedAppActionSetting,

        [Parameter()]
        [System.String[]]
        $DefenderProcessesToExclude,

        [Parameter()]
        [ValidateSet('userDefined', 'alwaysPrompt', 'promptBeforeSendingPersonalData', 'neverSendData', 'sendAllDataWithoutPrompting')]
        [System.String]
        $DefenderPromptForSampleSubmission,

        [Parameter()]
        [System.Boolean]
        $DefenderRequireBehaviorMonitoring,

        [Parameter()]
        [System.Boolean]
        $DefenderRequireCloudProtection,

        [Parameter()]
        [System.Boolean]
        $DefenderRequireNetworkInspectionSystem,

        [Parameter()]
        [System.Boolean]
        $DefenderRequireRealTimeMonitoring,

        [Parameter()]
        [System.Boolean]
        $DefenderScanArchiveFiles,

        [Parameter()]
        [System.Boolean]
        $DefenderScanDownloads,

        [Parameter()]
        [System.Boolean]
        $DefenderScanIncomingMail,

        [Parameter()]
        [System.Boolean]
        $DefenderScanMappedNetworkDrivesDuringFullScan,

        [Parameter()]
        [System.Int32]
        $DefenderScanMaxCpu,

        [Parameter()]
        [System.Boolean]
        $DefenderScanNetworkFiles,

        [Parameter()]
        [System.Boolean]
        $DefenderScanRemovableDrivesDuringFullScan,

        [Parameter()]
        [System.Boolean]
        $DefenderScanScriptsLoadedInInternetExplorer,

        [Parameter()]
        [ValidateSet('userDefined', 'disabled', 'quick', 'full')]
        [System.String]
        $DefenderScanType,

        [Parameter()]
        [System.TimeSpan]
        $DefenderScheduledQuickScanTime,

        [Parameter()]
        [System.TimeSpan]
        $DefenderScheduledScanTime,

        [Parameter()]
        [System.Boolean]
        $DefenderScheduleScanEnableLowCpuPriority,

        [Parameter()]
        [System.Int32]
        $DefenderSignatureUpdateIntervalInHours,

        [Parameter()]
        [ValidateSet('sendSafeSamplesAutomatically', 'alwaysPrompt', 'neverSend', 'sendAllSamplesAutomatically')]
        [System.String]
        $DefenderSubmitSamplesConsentType,

        [Parameter()]
        [ValidateSet('userDefined', 'everyday', 'sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'noScheduledScan')]
        [System.String]
        $DefenderSystemScanSchedule,

        [Parameter()]
        [ValidateSet('notConfigured', 'blocked', 'allowed')]
        [System.String]
        $DeveloperUnlockSetting,

        [Parameter()]
        [System.Boolean]
        $DeviceManagementBlockFactoryResetOnMobile,

        [Parameter()]
        [System.Boolean]
        $DeviceManagementBlockManualUnenroll,

        [Parameter()]
        [ValidateSet('userDefined', 'none', 'basic', 'enhanced', 'full')]
        [System.String]
        $DiagnosticsDataSubmissionMode,

        [Parameter()]
        [System.String[]]
        $DisplayAppListWithGdiDPIScalingTurnedOff,

        [Parameter()]
        [System.String[]]
        $DisplayAppListWithGdiDPIScalingTurnedOn,

        [Parameter()]
        [System.Boolean]
        $EdgeAllowStartPagesModification,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockAccessToAboutFlags,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockAddressBarDropdown,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockAutofill,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockCompatibilityList,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockDeveloperTools,

        [Parameter()]
        [System.Boolean]
        $EdgeBlocked,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockEditFavorites,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockExtensions,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockFullScreenMode,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockInPrivateBrowsing,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockJavaScript,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockLiveTileDataCollection,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockPasswordManager,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockPopups,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockPrelaunch,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockPrinting,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockSavingHistory,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockSearchEngineCustomization,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockSearchSuggestions,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockSendingDoNotTrackHeader,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockSendingIntranetTrafficToInternetExplorer,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockSideloadingExtensions,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockTabPreloading,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockWebContentOnNewTabPage,

        [Parameter()]
        [System.Boolean]
        $EdgeClearBrowsingDataOnExit,

        [Parameter()]
        [ValidateSet('userDefined', 'allow', 'blockThirdParty', 'blockAll')]
        [System.String]
        $EdgeCookiePolicy,

        [Parameter()]
        [System.Boolean]
        $EdgeDisableFirstRunPage,

        [Parameter()]
        [System.String]
        $EdgeEnterpriseModeSiteListLocation,

        [Parameter()]
        [ValidateSet('notConfigured', 'hide', 'show')]
        [System.String]
        $EdgeFavoritesBarVisibility,

        [Parameter()]
        [System.String]
        $EdgeFavoritesListLocation,

        [Parameter()]
        [System.String]
        $EdgeFirstRunUrl,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EdgeHomeButtonConfiguration,

        [Parameter()]
        [System.Boolean]
        $EdgeHomeButtonConfigurationEnabled,

        [Parameter()]
        [System.String[]]
        $EdgeHomepageUrls,

        [Parameter()]
        [ValidateSet('notConfigured', 'digitalSignage', 'normalMode', 'publicBrowsingSingleApp', 'publicBrowsingMultiApp')]
        [System.String]
        $EdgeKioskModeRestriction,

        [Parameter()]
        [System.Int32]
        $EdgeKioskResetAfterIdleTimeInMinutes,

        [Parameter()]
        [System.String]
        $EdgeNewTabPageURL,

        [Parameter()]
        [ValidateSet('notConfigured', 'startPage', 'newTabPage', 'previousPages', 'specificPages')]
        [System.String]
        $EdgeOpensWith,

        [Parameter()]
        [System.Boolean]
        $EdgePreventCertificateErrorOverride,

        [Parameter()]
        [System.String[]]
        $EdgeRequiredExtensionPackageFamilyNames,

        [Parameter()]
        [System.Boolean]
        $EdgeRequireSmartScreen,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EdgeSearchEngine,

        [Parameter()]
        [System.Boolean]
        $EdgeSendIntranetTrafficToInternetExplorer,

        [Parameter()]
        [ValidateSet('notConfigured', 'disabled', 'enabled', 'keepGoing')]
        [System.String]
        $EdgeShowMessageWhenOpeningInternetExplorerSites,

        [Parameter()]
        [System.Boolean]
        $EdgeSyncFavoritesWithInternetExplorer,

        [Parameter()]
        [ValidateSet('notConfigured', 'intranet', 'internet', 'intranetAndInternet')]
        [System.String]
        $EdgeTelemetryForMicrosoft365Analytics,

        [Parameter()]
        [System.Boolean]
        $EnableAutomaticRedeployment,

        [Parameter()]
        [System.Int32]
        $EnergySaverOnBatteryThresholdPercentage,

        [Parameter()]
        [System.Int32]
        $EnergySaverPluggedInThresholdPercentage,

        [Parameter()]
        [System.String]
        $EnterpriseCloudPrintDiscoveryEndPoint,

        [Parameter()]
        [System.Int32]
        $EnterpriseCloudPrintDiscoveryMaxLimit,

        [Parameter()]
        [System.String]
        $EnterpriseCloudPrintMopriaDiscoveryResourceIdentifier,

        [Parameter()]
        [System.String]
        $EnterpriseCloudPrintOAuthAuthority,

        [Parameter()]
        [System.String]
        $EnterpriseCloudPrintOAuthClientIdentifier,

        [Parameter()]
        [System.String]
        $EnterpriseCloudPrintResourceIdentifier,

        [Parameter()]
        [System.Boolean]
        $ExperienceBlockDeviceDiscovery,

        [Parameter()]
        [System.Boolean]
        $ExperienceBlockErrorDialogWhenNoSIM,

        [Parameter()]
        [System.Boolean]
        $ExperienceBlockTaskSwitcher,

        [Parameter()]
        [ValidateSet('notConfigured', 'blockedWithUserOverride', 'blocked')]
        [System.String]
        $ExperienceDoNotSyncBrowserSettings,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $FindMyFiles,

        [Parameter()]
        [System.Boolean]
        $GameDvrBlocked,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $InkWorkspaceAccess,

        [Parameter()]
        [ValidateSet('notConfigured', 'blocked', 'allowed')]
        [System.String]
        $InkWorkspaceAccessState,

        [Parameter()]
        [System.Boolean]
        $InkWorkspaceBlockSuggestedApps,

        [Parameter()]
        [System.Boolean]
        $InternetSharingBlocked,

        [Parameter()]
        [System.Boolean]
        $LocationServicesBlocked,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $LockScreenActivateAppsWithVoice,

        [Parameter()]
        [System.Boolean]
        $LockScreenAllowTimeoutConfiguration,

        [Parameter()]
        [System.Boolean]
        $LockScreenBlockActionCenterNotifications,

        [Parameter()]
        [System.Boolean]
        $LockScreenBlockCortana,

        [Parameter()]
        [System.Boolean]
        $LockScreenBlockToastNotifications,

        [Parameter()]
        [System.Int32]
        $LockScreenTimeoutInSeconds,

        [Parameter()]
        [System.Boolean]
        $LogonBlockFastUserSwitching,

        [Parameter()]
        [System.Boolean]
        $MessagingBlockMMS,

        [Parameter()]
        [System.Boolean]
        $MessagingBlockRichCommunicationServices,

        [Parameter()]
        [System.Boolean]
        $MessagingBlockSync,

        [Parameter()]
        [System.Boolean]
        $MicrosoftAccountBlocked,

        [Parameter()]
        [System.Boolean]
        $MicrosoftAccountBlockSettingsSync,

        [Parameter()]
        [ValidateSet('notConfigured', 'disabled')]
        [System.String]
        $MicrosoftAccountSignInAssistantSettings,

        [Parameter()]
        [System.Boolean]
        $NetworkProxyApplySettingsDeviceWide,

        [Parameter()]
        [System.String]
        $NetworkProxyAutomaticConfigurationUrl,

        [Parameter()]
        [System.Boolean]
        $NetworkProxyDisableAutoDetect,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $NetworkProxyServer,

        [Parameter()]
        [System.Boolean]
        $NfcBlocked,

        [Parameter()]
        [System.Boolean]
        $OneDriveDisableFileSync,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockSimple,

        [Parameter()]
        [System.Int32]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumAgeInDays,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumCharacterSetCount,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeScreenTimeout,

        [Parameter()]
        [System.Int32]
        $PasswordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Boolean]
        $PasswordRequired,

        [Parameter()]
        [ValidateSet('deviceDefault', 'alphanumeric', 'numeric')]
        [System.String]
        $PasswordRequiredType,

        [Parameter()]
        [System.Boolean]
        $PasswordRequireWhenResumeFromIdleState,

        [Parameter()]
        [System.Int32]
        $PasswordSignInFailureCountBeforeFactoryReset,

        [Parameter()]
        [System.String]
        $PersonalizationDesktopImageUrl,

        [Parameter()]
        [System.String]
        $PersonalizationLockScreenImageUrl,

        [Parameter()]
        [ValidateSet('notConfigured', 'noAction', 'sleep', 'hibernate', 'shutdown')]
        [System.String]
        $PowerButtonActionOnBattery,

        [Parameter()]
        [ValidateSet('notConfigured', 'noAction', 'sleep', 'hibernate', 'shutdown')]
        [System.String]
        $PowerButtonActionPluggedIn,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $PowerHybridSleepOnBattery,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $PowerHybridSleepPluggedIn,

        [Parameter()]
        [ValidateSet('notConfigured', 'noAction', 'sleep', 'hibernate', 'shutdown')]
        [System.String]
        $PowerLidCloseActionOnBattery,

        [Parameter()]
        [ValidateSet('notConfigured', 'noAction', 'sleep', 'hibernate', 'shutdown')]
        [System.String]
        $PowerLidCloseActionPluggedIn,

        [Parameter()]
        [ValidateSet('notConfigured', 'noAction', 'sleep', 'hibernate', 'shutdown')]
        [System.String]
        $PowerSleepButtonActionOnBattery,

        [Parameter()]
        [ValidateSet('notConfigured', 'noAction', 'sleep', 'hibernate', 'shutdown')]
        [System.String]
        $PowerSleepButtonActionPluggedIn,

        [Parameter()]
        [System.Boolean]
        $PrinterBlockAddition,

        [Parameter()]
        [System.String]
        $PrinterDefaultName,

        [Parameter()]
        [System.String[]]
        $PrinterNames,

        [Parameter()]
        [ValidateSet('notConfigured', 'blocked', 'allowed')]
        [System.String]
        $PrivacyAdvertisingId,

        [Parameter()]
        [System.Boolean]
        $PrivacyAutoAcceptPairingAndConsentPrompts,

        [Parameter()]
        [System.Boolean]
        $PrivacyBlockActivityFeed,

        [Parameter()]
        [System.Boolean]
        $PrivacyBlockInputPersonalization,

        [Parameter()]
        [System.Boolean]
        $PrivacyBlockPublishUserActivities,

        [Parameter()]
        [System.Boolean]
        $PrivacyDisableLaunchExperience,

        [Parameter()]
        [System.Boolean]
        $ResetProtectionModeBlocked,

        [Parameter()]
        [ValidateSet('userDefined', 'strict', 'moderate')]
        [System.String]
        $SafeSearchFilter,

        [Parameter()]
        [System.Boolean]
        $ScreenCaptureBlocked,

        [Parameter()]
        [System.Boolean]
        $SearchBlockDiacritics,

        [Parameter()]
        [System.Boolean]
        $SearchBlockWebResults,

        [Parameter()]
        [System.Boolean]
        $SearchDisableAutoLanguageDetection,

        [Parameter()]
        [System.Boolean]
        $SearchDisableIndexerBackoff,

        [Parameter()]
        [System.Boolean]
        $SearchDisableIndexingEncryptedItems,

        [Parameter()]
        [System.Boolean]
        $SearchDisableIndexingRemovableDrive,

        [Parameter()]
        [System.Boolean]
        $SearchDisableLocation,

        [Parameter()]
        [System.Boolean]
        $SearchDisableUseLocation,

        [Parameter()]
        [System.Boolean]
        $SearchEnableAutomaticIndexSizeManangement,

        [Parameter()]
        [System.Boolean]
        $SearchEnableRemoteQueries,

        [Parameter()]
        [System.Boolean]
        $SecurityBlockAzureADJoinedDevicesAutoEncryption,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockAccountsPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockAddProvisioningPackage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockAppsPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockChangeLanguage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockChangePowerSleep,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockChangeRegion,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockChangeSystemTime,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockDevicesPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockEaseOfAccessPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockEditDeviceName,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockGamingPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockNetworkInternetPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockPersonalizationPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockPrivacyPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockRemoveProvisioningPackage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockSettingsApp,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockSystemPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockTimeLanguagePage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockUpdateSecurityPage,

        [Parameter()]
        [System.Boolean]
        $SharedUserAppDataAllowed,

        [Parameter()]
        [ValidateSet('notConfigured', 'anywhere', 'storeOnly', 'recommendations', 'preferStore')]
        [System.String]
        $SmartScreenAppInstallControl,

        [Parameter()]
        [System.Boolean]
        $SmartScreenBlockPromptOverride,

        [Parameter()]
        [System.Boolean]
        $SmartScreenBlockPromptOverrideForFiles,

        [Parameter()]
        [System.Boolean]
        $SmartScreenEnableAppInstallControl,

        [Parameter()]
        [System.Boolean]
        $StartBlockUnpinningAppsFromTaskbar,

        [Parameter()]
        [ValidateSet('userDefined', 'collapse', 'remove', 'disableSettingsApp')]
        [System.String]
        $StartMenuAppListVisibility,

        [Parameter()]
        [System.Boolean]
        $StartMenuHideChangeAccountSettings,

        [Parameter()]
        [System.Boolean]
        $StartMenuHideFrequentlyUsedApps,

        [Parameter()]
        [System.Boolean]
        $StartMenuHideHibernate,

        [Parameter()]
        [System.Boolean]
        $StartMenuHideLock,

        [Parameter()]
        [System.Boolean]
        $StartMenuHidePowerButton,

        [Parameter()]
        [System.Boolean]
        $StartMenuHideRecentJumpLists,

        [Parameter()]
        [System.Boolean]
        $StartMenuHideRecentlyAddedApps,

        [Parameter()]
        [System.Boolean]
        $StartMenuHideRestartOptions,

        [Parameter()]
        [System.Boolean]
        $StartMenuHideShutDown,

        [Parameter()]
        [System.Boolean]
        $StartMenuHideSignOut,

        [Parameter()]
        [System.Boolean]
        $StartMenuHideSleep,

        [Parameter()]
        [System.Boolean]
        $StartMenuHideSwitchAccount,

        [Parameter()]
        [System.Boolean]
        $StartMenuHideUserTile,

        [Parameter()]
        [System.String]
        $StartMenuLayoutEdgeAssetsXml,

        [Parameter()]
        [System.String]
        $StartMenuLayoutXml,

        [Parameter()]
        [ValidateSet('userDefined', 'fullScreen', 'nonFullScreen')]
        [System.String]
        $StartMenuMode,

        [Parameter()]
        [ValidateSet('notConfigured', 'hide', 'show')]
        [System.String]
        $StartMenuPinnedFolderDocuments,

        [Parameter()]
        [ValidateSet('notConfigured', 'hide', 'show')]
        [System.String]
        $StartMenuPinnedFolderDownloads,

        [Parameter()]
        [ValidateSet('notConfigured', 'hide', 'show')]
        [System.String]
        $StartMenuPinnedFolderFileExplorer,

        [Parameter()]
        [ValidateSet('notConfigured', 'hide', 'show')]
        [System.String]
        $StartMenuPinnedFolderHomeGroup,

        [Parameter()]
        [ValidateSet('notConfigured', 'hide', 'show')]
        [System.String]
        $StartMenuPinnedFolderMusic,

        [Parameter()]
        [ValidateSet('notConfigured', 'hide', 'show')]
        [System.String]
        $StartMenuPinnedFolderNetwork,

        [Parameter()]
        [ValidateSet('notConfigured', 'hide', 'show')]
        [System.String]
        $StartMenuPinnedFolderPersonalFolder,

        [Parameter()]
        [ValidateSet('notConfigured', 'hide', 'show')]
        [System.String]
        $StartMenuPinnedFolderPictures,

        [Parameter()]
        [ValidateSet('notConfigured', 'hide', 'show')]
        [System.String]
        $StartMenuPinnedFolderSettings,

        [Parameter()]
        [ValidateSet('notConfigured', 'hide', 'show')]
        [System.String]
        $StartMenuPinnedFolderVideos,

        [Parameter()]
        [System.Boolean]
        $StorageBlockRemovableStorage,

        [Parameter()]
        [System.Boolean]
        $StorageRequireMobileDeviceEncryption,

        [Parameter()]
        [System.Boolean]
        $StorageRestrictAppDataToSystemVolume,

        [Parameter()]
        [System.Boolean]
        $StorageRestrictAppInstallToSystemVolume,

        [Parameter()]
        [System.String]
        $SystemTelemetryProxyServer,

        [Parameter()]
        [System.Boolean]
        $TaskManagerBlockEndTask,

        [Parameter()]
        [System.Boolean]
        $TenantLockdownRequireNetworkDuringOutOfBoxExperience,

        [Parameter()]
        [System.Boolean]
        $UninstallBuiltInApps,

        [Parameter()]
        [System.Boolean]
        $UsbBlocked,

        [Parameter()]
        [System.Boolean]
        $VoiceRecordingBlocked,

        [Parameter()]
        [System.Boolean]
        $WebRtcBlockLocalhostIpAddress,

        [Parameter()]
        [System.Boolean]
        $WiFiBlockAutomaticConnectHotspots,

        [Parameter()]
        [System.Boolean]
        $WiFiBlocked,

        [Parameter()]
        [System.Boolean]
        $WiFiBlockManualConfiguration,

        [Parameter()]
        [System.Int32]
        $WiFiScanInterval,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $Windows10AppsForceUpdateSchedule,

        [Parameter()]
        [System.Boolean]
        $WindowsSpotlightBlockConsumerSpecificFeatures,

        [Parameter()]
        [System.Boolean]
        $WindowsSpotlightBlocked,

        [Parameter()]
        [System.Boolean]
        $WindowsSpotlightBlockOnActionCenter,

        [Parameter()]
        [System.Boolean]
        $WindowsSpotlightBlockTailoredExperiences,

        [Parameter()]
        [System.Boolean]
        $WindowsSpotlightBlockThirdPartyNotifications,

        [Parameter()]
        [System.Boolean]
        $WindowsSpotlightBlockWelcomeExperience,

        [Parameter()]
        [System.Boolean]
        $WindowsSpotlightBlockWindowsTips,

        [Parameter()]
        [ValidateSet('notConfigured', 'disabled', 'enabled')]
        [System.String]
        $WindowsSpotlightConfigureOnLockScreen,

        [Parameter()]
        [System.Boolean]
        $WindowsStoreBlockAutoUpdate,

        [Parameter()]
        [System.Boolean]
        $WindowsStoreBlocked,

        [Parameter()]
        [System.Boolean]
        $WindowsStoreEnablePrivateStoreOnly,

        [Parameter()]
        [System.Boolean]
        $WirelessDisplayBlockProjectionToThisDevice,

        [Parameter()]
        [System.Boolean]
        $WirelessDisplayBlockUserInputFromReceiver,

        [Parameter()]
        [System.Boolean]
        $WirelessDisplayRequirePinForPairing,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
        #endregion

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '')
    return $result
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        #region resource generator code
        $baseFilter = "isof('microsoft.graph.windows10GeneralConfiguration')"
        if (-not [string]::IsNullOrEmpty($Filter))
        {
            $Filter = "($baseFilter) and ($Filter)"
        }
        else
        {
            $Filter = $baseFilter
        }
        [array]$getValue = Get-MgBetaDeviceManagementDeviceConfiguration -Filter $Filter -All -ErrorAction Stop
        #endregion

        $i = 1
        $dscContent = [System.Text.StringBuilder]::new()
        if ($getValue.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($config in $getValue)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $displayedKey = $config.Id
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
            $params = @{
                Id                    = $config.Id
                DisplayName           = $config.DisplayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $config
            $Results = Get-TargetResource @Params
            if ($null -ne $Results.DefenderDetectedMalwareActions)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.DefenderDetectedMalwareActions `
                    -CIMInstanceName 'MicrosoftGraphdefenderDetectedMalwareActions1'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.DefenderDetectedMalwareActions = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('DefenderDetectedMalwareActions') | Out-Null
                }
            }
            if ($null -ne $Results.EdgeHomeButtonConfiguration)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.EdgeHomeButtonConfiguration `
                    -CIMInstanceName 'MicrosoftGraphedgeHomeButtonConfiguration'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.EdgeHomeButtonConfiguration = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('EdgeHomeButtonConfiguration') | Out-Null
                }
            }
            if ($null -ne $Results.EdgeSearchEngine)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.EdgeSearchEngine `
                    -CIMInstanceName 'MicrosoftGraphedgeSearchEngineBase'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.EdgeSearchEngine = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('EdgeSearchEngine') | Out-Null
                }
            }
            if ($null -ne $Results.NetworkProxyServer)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.NetworkProxyServer `
                    -CIMInstanceName 'MicrosoftGraphwindows10NetworkProxyServer'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.NetworkProxyServer = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('NetworkProxyServer') | Out-Null
                }
            }
            if ($null -ne $Results.Windows10AppsForceUpdateSchedule)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.Windows10AppsForceUpdateSchedule `
                    -CIMInstanceName 'MicrosoftGraphwindows10AppsForceUpdateSchedule'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.Windows10AppsForceUpdateSchedule = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('Windows10AppsForceUpdateSchedule') | Out-Null
                }
            }
            if ($Results.Assignments)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.Assignments -CIMInstanceName DeviceManagementConfigurationPolicyAssignments
                if ($complexTypeStringResult)
                {
                    $Results.Assignments = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('Assignments') | Out-Null
                }
            }
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('DefenderDetectedMalwareActions', 'EdgeHomeButtonConfiguration', 'EdgeSearchEngine',
                'NetworkProxyServer', 'Windows10AppsForceUpdateSchedule', 'Assignments')

            [void]$dscContent.Append($currentDSCBlock)
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        return $dscContent.ToString()
    }
    catch
    {
        if ($_.Exception -like '*401*' -or $_.ErrorDetails.Message -like "*`"ErrorCode`":`"Forbidden`"*" -or `
                $_.Exception -like '*Request not applicable to target tenant*')
        {
            Write-M365DSCHost -Message "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered for Intune."
        }
        else
        {
            New-M365DSCLogEntry -Message 'Error during Export:' `
                -Exception $_ `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential

            throw
        }
    }
}

Export-ModuleMember -Function *-TargetResource
