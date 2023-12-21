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
        [System.Boolean]
        $SupportsScopeTags,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
        #endregion

        [Parameter()]
        [System.String]
        [ValidateSet('Absent', 'Present')]
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
        [Switch]
        $ManagedIdentity
    )

    Write-Verbose -Message "Checking for the Intune Device Configuration Policy {$DisplayName}"
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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

    try
    {
        $getValue = $null
        #region resource generator code
        $getValue = Get-MgBetaDeviceManagementDeviceConfiguration -DeviceConfigurationId $Id  -ErrorAction SilentlyContinue

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Intune Device Configuration Policy for Windows10 with Id {$Id}"

            if (-Not [string]::IsNullOrEmpty($DisplayName))
            {
                $getValue = Get-MgBetaDeviceManagementDeviceConfiguration `
                    -Filter "DisplayName eq '$DisplayName'" `
                    -ErrorAction SilentlyContinue | Where-Object `
                    -FilterScript { `
                        $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.windows10GeneralConfiguration' `
                }
            }
        }
        #endregion
        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Intune Device Configuration Policy for Windows10 with DisplayName {$DisplayName}"
            return $nullResult
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Device Configuration Policy for Windows10 with Id {$Id} and DisplayName {$DisplayName} was found."

        #region resource generator code
        $complexDefenderDetectedMalwareActions = @{}
        if ($null -ne $getValue.AdditionalProperties.defenderDetectedMalwareActions.highSeverity)
        {
            $complexDefenderDetectedMalwareActions.Add('HighSeverity', $getValue.AdditionalProperties.defenderDetectedMalwareActions.highSeverity.toString())
        }
        if ($null -ne $getValue.AdditionalProperties.defenderDetectedMalwareActions.lowSeverity)
        {
            $complexDefenderDetectedMalwareActions.Add('LowSeverity', $getValue.AdditionalProperties.defenderDetectedMalwareActions.lowSeverity.toString())
        }
        if ($null -ne $getValue.AdditionalProperties.defenderDetectedMalwareActions.moderateSeverity)
        {
            $complexDefenderDetectedMalwareActions.Add('ModerateSeverity', $getValue.AdditionalProperties.defenderDetectedMalwareActions.moderateSeverity.toString())
        }
        if ($null -ne $getValue.AdditionalProperties.defenderDetectedMalwareActions.severeSeverity)
        {
            $complexDefenderDetectedMalwareActions.Add('SevereSeverity', $getValue.AdditionalProperties.defenderDetectedMalwareActions.severeSeverity.toString())
        }
        if ($complexDefenderDetectedMalwareActions.values.Where({ $null -ne $_ }).count -eq 0)
        {
            $complexDefenderDetectedMalwareActions = $null
        }

        $complexEdgeHomeButtonConfiguration = @{}
        $complexEdgeHomeButtonConfiguration.Add('HomeButtonCustomURL', $getValue.AdditionalProperties.edgeHomeButtonConfiguration.homeButtonCustomURL)
        if ($null -ne $getValue.AdditionalProperties.edgeHomeButtonConfiguration.'@odata.type')
        {
            $complexEdgeHomeButtonConfiguration.Add('odataType', $getValue.AdditionalProperties.edgeHomeButtonConfiguration.'@odata.type'.toString())
        }
        if ($complexEdgeHomeButtonConfiguration.values.Where({ $null -ne $_ }).count -eq 0)
        {
            $complexEdgeHomeButtonConfiguration = $null
        }

        $complexEdgeSearchEngine = @{}
        if ($null -ne $getValue.AdditionalProperties.edgeSearchEngine.edgeSearchEngineType)
        {
            $complexEdgeSearchEngine.Add('EdgeSearchEngineType', $getValue.AdditionalProperties.edgeSearchEngine.edgeSearchEngineType.toString())
        }
        $complexEdgeSearchEngine.Add('EdgeSearchEngineOpenSearchXmlUrl', $getValue.AdditionalProperties.edgeSearchEngine.edgeSearchEngineOpenSearchXmlUrl)
        if ($null -ne $getValue.AdditionalProperties.edgeSearchEngine.'@odata.type')
        {
            $complexEdgeSearchEngine.Add('odataType', $getValue.AdditionalProperties.edgeSearchEngine.'@odata.type'.toString())
        }
        if ($complexEdgeSearchEngine.values.Where({ $null -ne $_ }).count -eq 0)
        {
            $complexEdgeSearchEngine = $null
        }

        $complexNetworkProxyServer = @{}
        $complexNetworkProxyServer.Add('Address', $getValue.AdditionalProperties.networkProxyServer.address)
        $complexNetworkProxyServer.Add('Exceptions', $getValue.AdditionalProperties.networkProxyServer.exceptions)
        $complexNetworkProxyServer.Add('UseForLocalAddresses', $getValue.AdditionalProperties.networkProxyServer.useForLocalAddresses)
        if ($complexNetworkProxyServer.values.Where({ $null -ne $_ }).count -eq 0)
        {
            $complexNetworkProxyServer = $null
        }

        $complexWindows10AppsForceUpdateSchedule = @{}
        if ($null -ne $getValue.AdditionalProperties.windows10AppsForceUpdateSchedule.recurrence)
        {
            $complexWindows10AppsForceUpdateSchedule.Add('Recurrence', $getValue.AdditionalProperties.windows10AppsForceUpdateSchedule.recurrence.toString())
        }
        $complexWindows10AppsForceUpdateSchedule.Add('RunImmediatelyIfAfterStartDateTime', $getValue.AdditionalProperties.windows10AppsForceUpdateSchedule.runImmediatelyIfAfterStartDateTime)
        if ($null -ne $getValue.AdditionalProperties.windows10AppsForceUpdateSchedule.startDateTime)
        {
            $complexWindows10AppsForceUpdateSchedule.Add('StartDateTime', ([DateTimeOffset]$getValue.AdditionalProperties.windows10AppsForceUpdateSchedule.startDateTime).ToString('o'))
        }
        if ($complexWindows10AppsForceUpdateSchedule.values.Where({ $null -ne $_ }).count -eq 0)
        {
            $complexWindows10AppsForceUpdateSchedule = $null
        }
        #endregion

        #region resource generator code
        $enumActivateAppsWithVoice = $null
        if ($null -ne $getValue.AdditionalProperties.activateAppsWithVoice)
        {
            $enumActivateAppsWithVoice = $getValue.AdditionalProperties.activateAppsWithVoice.ToString()
        }

        $enumAppsAllowTrustedAppsSideloading = $null
        if ($null -ne $getValue.AdditionalProperties.appsAllowTrustedAppsSideloading)
        {
            $enumAppsAllowTrustedAppsSideloading = $getValue.AdditionalProperties.appsAllowTrustedAppsSideloading.ToString()
        }

        $enumAuthenticationWebSignIn = $null
        if ($null -ne $getValue.AdditionalProperties.authenticationWebSignIn)
        {
            $enumAuthenticationWebSignIn = $getValue.AdditionalProperties.authenticationWebSignIn.ToString()
        }

        $enumCellularData = $null
        if ($null -ne $getValue.AdditionalProperties.cellularData)
        {
            $enumCellularData = $getValue.AdditionalProperties.cellularData.ToString()
        }

        $enumDefenderCloudBlockLevel = $null
        if ($null -ne $getValue.AdditionalProperties.defenderCloudBlockLevel)
        {
            $enumDefenderCloudBlockLevel = $getValue.AdditionalProperties.defenderCloudBlockLevel.ToString()
        }

        $enumDefenderMonitorFileActivity = $null
        if ($null -ne $getValue.AdditionalProperties.defenderMonitorFileActivity)
        {
            $enumDefenderMonitorFileActivity = $getValue.AdditionalProperties.defenderMonitorFileActivity.ToString()
        }

        $enumDefenderPotentiallyUnwantedAppAction = $null
        if ($null -ne $getValue.AdditionalProperties.defenderPotentiallyUnwantedAppAction)
        {
            $enumDefenderPotentiallyUnwantedAppAction = $getValue.AdditionalProperties.defenderPotentiallyUnwantedAppAction.ToString()
        }

        $enumDefenderPotentiallyUnwantedAppActionSetting = $null
        if ($null -ne $getValue.AdditionalProperties.defenderPotentiallyUnwantedAppActionSetting)
        {
            $enumDefenderPotentiallyUnwantedAppActionSetting = $getValue.AdditionalProperties.defenderPotentiallyUnwantedAppActionSetting.ToString()
        }

        $enumDefenderPromptForSampleSubmission = $null
        if ($null -ne $getValue.AdditionalProperties.defenderPromptForSampleSubmission)
        {
            $enumDefenderPromptForSampleSubmission = $getValue.AdditionalProperties.defenderPromptForSampleSubmission.ToString()
        }

        $enumDefenderScanType = $null
        if ($null -ne $getValue.AdditionalProperties.defenderScanType)
        {
            $enumDefenderScanType = $getValue.AdditionalProperties.defenderScanType.ToString()
        }

        $enumDefenderSubmitSamplesConsentType = $null
        if ($null -ne $getValue.AdditionalProperties.defenderSubmitSamplesConsentType)
        {
            $enumDefenderSubmitSamplesConsentType = $getValue.AdditionalProperties.defenderSubmitSamplesConsentType.ToString()
        }

        $enumDefenderSystemScanSchedule = $null
        if ($null -ne $getValue.AdditionalProperties.defenderSystemScanSchedule)
        {
            $enumDefenderSystemScanSchedule = $getValue.AdditionalProperties.defenderSystemScanSchedule.ToString()
        }

        $enumDeveloperUnlockSetting = $null
        if ($null -ne $getValue.AdditionalProperties.developerUnlockSetting)
        {
            $enumDeveloperUnlockSetting = $getValue.AdditionalProperties.developerUnlockSetting.ToString()
        }

        $enumDiagnosticsDataSubmissionMode = $null
        if ($null -ne $getValue.AdditionalProperties.diagnosticsDataSubmissionMode)
        {
            $enumDiagnosticsDataSubmissionMode = $getValue.AdditionalProperties.diagnosticsDataSubmissionMode.ToString()
        }

        $enumEdgeCookiePolicy = $null
        if ($null -ne $getValue.AdditionalProperties.edgeCookiePolicy)
        {
            $enumEdgeCookiePolicy = $getValue.AdditionalProperties.edgeCookiePolicy.ToString()
        }

        $enumEdgeFavoritesBarVisibility = $null
        if ($null -ne $getValue.AdditionalProperties.edgeFavoritesBarVisibility)
        {
            $enumEdgeFavoritesBarVisibility = $getValue.AdditionalProperties.edgeFavoritesBarVisibility.ToString()
        }

        $enumEdgeKioskModeRestriction = $null
        if ($null -ne $getValue.AdditionalProperties.edgeKioskModeRestriction)
        {
            $enumEdgeKioskModeRestriction = $getValue.AdditionalProperties.edgeKioskModeRestriction.ToString()
        }

        $enumEdgeOpensWith = $null
        if ($null -ne $getValue.AdditionalProperties.edgeOpensWith)
        {
            $enumEdgeOpensWith = $getValue.AdditionalProperties.edgeOpensWith.ToString()
        }

        $enumEdgeShowMessageWhenOpeningInternetExplorerSites = $null
        if ($null -ne $getValue.AdditionalProperties.edgeShowMessageWhenOpeningInternetExplorerSites)
        {
            $enumEdgeShowMessageWhenOpeningInternetExplorerSites = $getValue.AdditionalProperties.edgeShowMessageWhenOpeningInternetExplorerSites.ToString()
        }

        $enumEdgeTelemetryForMicrosoft365Analytics = $null
        if ($null -ne $getValue.AdditionalProperties.edgeTelemetryForMicrosoft365Analytics)
        {
            $enumEdgeTelemetryForMicrosoft365Analytics = $getValue.AdditionalProperties.edgeTelemetryForMicrosoft365Analytics.ToString()
        }

        $enumExperienceDoNotSyncBrowserSettings = $null
        if ($null -ne $getValue.AdditionalProperties.experienceDoNotSyncBrowserSettings)
        {
            $enumExperienceDoNotSyncBrowserSettings = $getValue.AdditionalProperties.experienceDoNotSyncBrowserSettings.ToString()
        }

        $enumFindMyFiles = $null
        if ($null -ne $getValue.AdditionalProperties.findMyFiles)
        {
            $enumFindMyFiles = $getValue.AdditionalProperties.findMyFiles.ToString()
        }

        $enumInkWorkspaceAccess = $null
        if ($null -ne $getValue.AdditionalProperties.inkWorkspaceAccess)
        {
            $enumInkWorkspaceAccess = $getValue.AdditionalProperties.inkWorkspaceAccess.ToString()
        }

        $enumInkWorkspaceAccessState = $null
        if ($null -ne $getValue.AdditionalProperties.inkWorkspaceAccessState)
        {
            $enumInkWorkspaceAccessState = $getValue.AdditionalProperties.inkWorkspaceAccessState.ToString()
        }

        $enumLockScreenActivateAppsWithVoice = $null
        if ($null -ne $getValue.AdditionalProperties.lockScreenActivateAppsWithVoice)
        {
            $enumLockScreenActivateAppsWithVoice = $getValue.AdditionalProperties.lockScreenActivateAppsWithVoice.ToString()
        }

        $enumMicrosoftAccountSignInAssistantSettings = $null
        if ($null -ne $getValue.AdditionalProperties.microsoftAccountSignInAssistantSettings)
        {
            $enumMicrosoftAccountSignInAssistantSettings = $getValue.AdditionalProperties.microsoftAccountSignInAssistantSettings.ToString()
        }

        $enumPasswordRequiredType = $null
        if ($null -ne $getValue.AdditionalProperties.passwordRequiredType)
        {
            $enumPasswordRequiredType = $getValue.AdditionalProperties.passwordRequiredType.ToString()
        }

        $enumPowerButtonActionOnBattery = $null
        if ($null -ne $getValue.AdditionalProperties.powerButtonActionOnBattery)
        {
            $enumPowerButtonActionOnBattery = $getValue.AdditionalProperties.powerButtonActionOnBattery.ToString()
        }

        $enumPowerButtonActionPluggedIn = $null
        if ($null -ne $getValue.AdditionalProperties.powerButtonActionPluggedIn)
        {
            $enumPowerButtonActionPluggedIn = $getValue.AdditionalProperties.powerButtonActionPluggedIn.ToString()
        }

        $enumPowerHybridSleepOnBattery = $null
        if ($null -ne $getValue.AdditionalProperties.powerHybridSleepOnBattery)
        {
            $enumPowerHybridSleepOnBattery = $getValue.AdditionalProperties.powerHybridSleepOnBattery.ToString()
        }

        $enumPowerHybridSleepPluggedIn = $null
        if ($null -ne $getValue.AdditionalProperties.powerHybridSleepPluggedIn)
        {
            $enumPowerHybridSleepPluggedIn = $getValue.AdditionalProperties.powerHybridSleepPluggedIn.ToString()
        }

        $enumPowerLidCloseActionOnBattery = $null
        if ($null -ne $getValue.AdditionalProperties.powerLidCloseActionOnBattery)
        {
            $enumPowerLidCloseActionOnBattery = $getValue.AdditionalProperties.powerLidCloseActionOnBattery.ToString()
        }

        $enumPowerLidCloseActionPluggedIn = $null
        if ($null -ne $getValue.AdditionalProperties.powerLidCloseActionPluggedIn)
        {
            $enumPowerLidCloseActionPluggedIn = $getValue.AdditionalProperties.powerLidCloseActionPluggedIn.ToString()
        }

        $enumPowerSleepButtonActionOnBattery = $null
        if ($null -ne $getValue.AdditionalProperties.powerSleepButtonActionOnBattery)
        {
            $enumPowerSleepButtonActionOnBattery = $getValue.AdditionalProperties.powerSleepButtonActionOnBattery.ToString()
        }

        $enumPowerSleepButtonActionPluggedIn = $null
        if ($null -ne $getValue.AdditionalProperties.powerSleepButtonActionPluggedIn)
        {
            $enumPowerSleepButtonActionPluggedIn = $getValue.AdditionalProperties.powerSleepButtonActionPluggedIn.ToString()
        }

        $enumPrivacyAdvertisingId = $null
        if ($null -ne $getValue.AdditionalProperties.privacyAdvertisingId)
        {
            $enumPrivacyAdvertisingId = $getValue.AdditionalProperties.privacyAdvertisingId.ToString()
        }

        $enumSafeSearchFilter = $null
        if ($null -ne $getValue.AdditionalProperties.safeSearchFilter)
        {
            $enumSafeSearchFilter = $getValue.AdditionalProperties.safeSearchFilter.ToString()
        }

        $enumSmartScreenAppInstallControl = $null
        if ($null -ne $getValue.AdditionalProperties.smartScreenAppInstallControl)
        {
            $enumSmartScreenAppInstallControl = $getValue.AdditionalProperties.smartScreenAppInstallControl.ToString()
        }

        $enumStartMenuAppListVisibility = $null
        if ($null -ne $getValue.AdditionalProperties.startMenuAppListVisibility)
        {
            $enumStartMenuAppListVisibility = $getValue.AdditionalProperties.startMenuAppListVisibility.ToString()
        }

        $enumStartMenuMode = $null
        if ($null -ne $getValue.AdditionalProperties.startMenuMode)
        {
            $enumStartMenuMode = $getValue.AdditionalProperties.startMenuMode.ToString()
        }

        $enumStartMenuPinnedFolderDocuments = $null
        if ($null -ne $getValue.AdditionalProperties.startMenuPinnedFolderDocuments)
        {
            $enumStartMenuPinnedFolderDocuments = $getValue.AdditionalProperties.startMenuPinnedFolderDocuments.ToString()
        }

        $enumStartMenuPinnedFolderDownloads = $null
        if ($null -ne $getValue.AdditionalProperties.startMenuPinnedFolderDownloads)
        {
            $enumStartMenuPinnedFolderDownloads = $getValue.AdditionalProperties.startMenuPinnedFolderDownloads.ToString()
        }

        $enumStartMenuPinnedFolderFileExplorer = $null
        if ($null -ne $getValue.AdditionalProperties.startMenuPinnedFolderFileExplorer)
        {
            $enumStartMenuPinnedFolderFileExplorer = $getValue.AdditionalProperties.startMenuPinnedFolderFileExplorer.ToString()
        }

        $enumStartMenuPinnedFolderHomeGroup = $null
        if ($null -ne $getValue.AdditionalProperties.startMenuPinnedFolderHomeGroup)
        {
            $enumStartMenuPinnedFolderHomeGroup = $getValue.AdditionalProperties.startMenuPinnedFolderHomeGroup.ToString()
        }

        $enumStartMenuPinnedFolderMusic = $null
        if ($null -ne $getValue.AdditionalProperties.startMenuPinnedFolderMusic)
        {
            $enumStartMenuPinnedFolderMusic = $getValue.AdditionalProperties.startMenuPinnedFolderMusic.ToString()
        }

        $enumStartMenuPinnedFolderNetwork = $null
        if ($null -ne $getValue.AdditionalProperties.startMenuPinnedFolderNetwork)
        {
            $enumStartMenuPinnedFolderNetwork = $getValue.AdditionalProperties.startMenuPinnedFolderNetwork.ToString()
        }

        $enumStartMenuPinnedFolderPersonalFolder = $null
        if ($null -ne $getValue.AdditionalProperties.startMenuPinnedFolderPersonalFolder)
        {
            $enumStartMenuPinnedFolderPersonalFolder = $getValue.AdditionalProperties.startMenuPinnedFolderPersonalFolder.ToString()
        }

        $enumStartMenuPinnedFolderPictures = $null
        if ($null -ne $getValue.AdditionalProperties.startMenuPinnedFolderPictures)
        {
            $enumStartMenuPinnedFolderPictures = $getValue.AdditionalProperties.startMenuPinnedFolderPictures.ToString()
        }

        $enumStartMenuPinnedFolderSettings = $null
        if ($null -ne $getValue.AdditionalProperties.startMenuPinnedFolderSettings)
        {
            $enumStartMenuPinnedFolderSettings = $getValue.AdditionalProperties.startMenuPinnedFolderSettings.ToString()
        }

        $enumStartMenuPinnedFolderVideos = $null
        if ($null -ne $getValue.AdditionalProperties.startMenuPinnedFolderVideos)
        {
            $enumStartMenuPinnedFolderVideos = $getValue.AdditionalProperties.startMenuPinnedFolderVideos.ToString()
        }

        $enumWindowsSpotlightConfigureOnLockScreen = $null
        if ($null -ne $getValue.AdditionalProperties.windowsSpotlightConfigureOnLockScreen)
        {
            $enumWindowsSpotlightConfigureOnLockScreen = $getValue.AdditionalProperties.windowsSpotlightConfigureOnLockScreen.ToString()
        }
        #endregion

        #region resource generator code
        $timeDefenderScheduledQuickScanTime = $null
        if ($null -ne $getValue.AdditionalProperties.defenderScheduledQuickScanTime)
        {
            $timeDefenderScheduledQuickScanTime = ([TimeSpan]$getValue.AdditionalProperties.defenderScheduledQuickScanTime).ToString()
        }

        $timeDefenderScheduledScanTime = $null
        if ($null -ne $getValue.AdditionalProperties.defenderScheduledScanTime)
        {
            $timeDefenderScheduledScanTime = ([TimeSpan]$getValue.AdditionalProperties.defenderScheduledScanTime).ToString()
        }
        #endregion

        $results = @{
            #region resource generator code
            AccountsBlockAddingNonMicrosoftAccountEmail           = $getValue.AdditionalProperties.accountsBlockAddingNonMicrosoftAccountEmail
            ActivateAppsWithVoice                                 = $enumActivateAppsWithVoice
            AntiTheftModeBlocked                                  = $getValue.AdditionalProperties.antiTheftModeBlocked
            AppManagementMSIAllowUserControlOverInstall           = $getValue.AdditionalProperties.appManagementMSIAllowUserControlOverInstall
            AppManagementMSIAlwaysInstallWithElevatedPrivileges   = $getValue.AdditionalProperties.appManagementMSIAlwaysInstallWithElevatedPrivileges
            AppManagementPackageFamilyNamesToLaunchAfterLogOn     = $getValue.AdditionalProperties.appManagementPackageFamilyNamesToLaunchAfterLogOn
            AppsAllowTrustedAppsSideloading                       = $enumAppsAllowTrustedAppsSideloading
            AppsBlockWindowsStoreOriginatedApps                   = $getValue.AdditionalProperties.appsBlockWindowsStoreOriginatedApps
            AuthenticationAllowSecondaryDevice                    = $getValue.AdditionalProperties.authenticationAllowSecondaryDevice
            AuthenticationPreferredAzureADTenantDomainName        = $getValue.AdditionalProperties.authenticationPreferredAzureADTenantDomainName
            AuthenticationWebSignIn                               = $enumAuthenticationWebSignIn
            BluetoothAllowedServices                              = $getValue.AdditionalProperties.bluetoothAllowedServices
            BluetoothBlockAdvertising                             = $getValue.AdditionalProperties.bluetoothBlockAdvertising
            BluetoothBlockDiscoverableMode                        = $getValue.AdditionalProperties.bluetoothBlockDiscoverableMode
            BluetoothBlocked                                      = $getValue.AdditionalProperties.bluetoothBlocked
            BluetoothBlockPrePairing                              = $getValue.AdditionalProperties.bluetoothBlockPrePairing
            BluetoothBlockPromptedProximalConnections             = $getValue.AdditionalProperties.bluetoothBlockPromptedProximalConnections
            CameraBlocked                                         = $getValue.AdditionalProperties.cameraBlocked
            CellularBlockDataWhenRoaming                          = $getValue.AdditionalProperties.cellularBlockDataWhenRoaming
            CellularBlockVpn                                      = $getValue.AdditionalProperties.cellularBlockVpn
            CellularBlockVpnWhenRoaming                           = $getValue.AdditionalProperties.cellularBlockVpnWhenRoaming
            CellularData                                          = $enumCellularData
            CertificatesBlockManualRootCertificateInstallation    = $getValue.AdditionalProperties.certificatesBlockManualRootCertificateInstallation
            ConfigureTimeZone                                     = $getValue.AdditionalProperties.configureTimeZone
            ConnectedDevicesServiceBlocked                        = $getValue.AdditionalProperties.connectedDevicesServiceBlocked
            CopyPasteBlocked                                      = $getValue.AdditionalProperties.copyPasteBlocked
            CortanaBlocked                                        = $getValue.AdditionalProperties.cortanaBlocked
            CryptographyAllowFipsAlgorithmPolicy                  = $getValue.AdditionalProperties.cryptographyAllowFipsAlgorithmPolicy
            DataProtectionBlockDirectMemoryAccess                 = $getValue.AdditionalProperties.dataProtectionBlockDirectMemoryAccess
            DefenderBlockEndUserAccess                            = $getValue.AdditionalProperties.defenderBlockEndUserAccess
            DefenderBlockOnAccessProtection                       = $getValue.AdditionalProperties.defenderBlockOnAccessProtection
            DefenderCloudBlockLevel                               = $enumDefenderCloudBlockLevel
            DefenderCloudExtendedTimeout                          = $getValue.AdditionalProperties.defenderCloudExtendedTimeout
            DefenderCloudExtendedTimeoutInSeconds                 = $getValue.AdditionalProperties.defenderCloudExtendedTimeoutInSeconds
            DefenderDaysBeforeDeletingQuarantinedMalware          = $getValue.AdditionalProperties.defenderDaysBeforeDeletingQuarantinedMalware
            DefenderDetectedMalwareActions                        = $complexDefenderDetectedMalwareActions
            DefenderDisableCatchupFullScan                        = $getValue.AdditionalProperties.defenderDisableCatchupFullScan
            DefenderDisableCatchupQuickScan                       = $getValue.AdditionalProperties.defenderDisableCatchupQuickScan
            DefenderFileExtensionsToExclude                       = $getValue.AdditionalProperties.defenderFileExtensionsToExclude
            DefenderFilesAndFoldersToExclude                      = $getValue.AdditionalProperties.defenderFilesAndFoldersToExclude
            DefenderMonitorFileActivity                           = $enumDefenderMonitorFileActivity
            DefenderPotentiallyUnwantedAppAction                  = $enumDefenderPotentiallyUnwantedAppAction
            DefenderPotentiallyUnwantedAppActionSetting           = $enumDefenderPotentiallyUnwantedAppActionSetting
            DefenderProcessesToExclude                            = $getValue.AdditionalProperties.defenderProcessesToExclude
            DefenderPromptForSampleSubmission                     = $enumDefenderPromptForSampleSubmission
            DefenderRequireBehaviorMonitoring                     = $getValue.AdditionalProperties.defenderRequireBehaviorMonitoring
            DefenderRequireCloudProtection                        = $getValue.AdditionalProperties.defenderRequireCloudProtection
            DefenderRequireNetworkInspectionSystem                = $getValue.AdditionalProperties.defenderRequireNetworkInspectionSystem
            DefenderRequireRealTimeMonitoring                     = $getValue.AdditionalProperties.defenderRequireRealTimeMonitoring
            DefenderScanArchiveFiles                              = $getValue.AdditionalProperties.defenderScanArchiveFiles
            DefenderScanDownloads                                 = $getValue.AdditionalProperties.defenderScanDownloads
            DefenderScanIncomingMail                              = $getValue.AdditionalProperties.defenderScanIncomingMail
            DefenderScanMappedNetworkDrivesDuringFullScan         = $getValue.AdditionalProperties.defenderScanMappedNetworkDrivesDuringFullScan
            DefenderScanMaxCpu                                    = $getValue.AdditionalProperties.defenderScanMaxCpu
            DefenderScanNetworkFiles                              = $getValue.AdditionalProperties.defenderScanNetworkFiles
            DefenderScanRemovableDrivesDuringFullScan             = $getValue.AdditionalProperties.defenderScanRemovableDrivesDuringFullScan
            DefenderScanScriptsLoadedInInternetExplorer           = $getValue.AdditionalProperties.defenderScanScriptsLoadedInInternetExplorer
            DefenderScanType                                      = $enumDefenderScanType
            DefenderScheduledQuickScanTime                        = $timeDefenderScheduledQuickScanTime
            DefenderScheduledScanTime                             = $timeDefenderScheduledScanTime
            DefenderScheduleScanEnableLowCpuPriority              = $getValue.AdditionalProperties.defenderScheduleScanEnableLowCpuPriority
            DefenderSignatureUpdateIntervalInHours                = $getValue.AdditionalProperties.defenderSignatureUpdateIntervalInHours
            DefenderSubmitSamplesConsentType                      = $enumDefenderSubmitSamplesConsentType
            DefenderSystemScanSchedule                            = $enumDefenderSystemScanSchedule
            DeveloperUnlockSetting                                = $enumDeveloperUnlockSetting
            DeviceManagementBlockFactoryResetOnMobile             = $getValue.AdditionalProperties.deviceManagementBlockFactoryResetOnMobile
            DeviceManagementBlockManualUnenroll                   = $getValue.AdditionalProperties.deviceManagementBlockManualUnenroll
            DiagnosticsDataSubmissionMode                         = $enumDiagnosticsDataSubmissionMode
            DisplayAppListWithGdiDPIScalingTurnedOff              = $getValue.AdditionalProperties.displayAppListWithGdiDPIScalingTurnedOff
            DisplayAppListWithGdiDPIScalingTurnedOn               = $getValue.AdditionalProperties.displayAppListWithGdiDPIScalingTurnedOn
            EdgeAllowStartPagesModification                       = $getValue.AdditionalProperties.edgeAllowStartPagesModification
            EdgeBlockAccessToAboutFlags                           = $getValue.AdditionalProperties.edgeBlockAccessToAboutFlags
            EdgeBlockAddressBarDropdown                           = $getValue.AdditionalProperties.edgeBlockAddressBarDropdown
            EdgeBlockAutofill                                     = $getValue.AdditionalProperties.edgeBlockAutofill
            EdgeBlockCompatibilityList                            = $getValue.AdditionalProperties.edgeBlockCompatibilityList
            EdgeBlockDeveloperTools                               = $getValue.AdditionalProperties.edgeBlockDeveloperTools
            EdgeBlocked                                           = $getValue.AdditionalProperties.edgeBlocked
            EdgeBlockEditFavorites                                = $getValue.AdditionalProperties.edgeBlockEditFavorites
            EdgeBlockExtensions                                   = $getValue.AdditionalProperties.edgeBlockExtensions
            EdgeBlockFullScreenMode                               = $getValue.AdditionalProperties.edgeBlockFullScreenMode
            EdgeBlockInPrivateBrowsing                            = $getValue.AdditionalProperties.edgeBlockInPrivateBrowsing
            EdgeBlockJavaScript                                   = $getValue.AdditionalProperties.edgeBlockJavaScript
            EdgeBlockLiveTileDataCollection                       = $getValue.AdditionalProperties.edgeBlockLiveTileDataCollection
            EdgeBlockPasswordManager                              = $getValue.AdditionalProperties.edgeBlockPasswordManager
            EdgeBlockPopups                                       = $getValue.AdditionalProperties.edgeBlockPopups
            EdgeBlockPrelaunch                                    = $getValue.AdditionalProperties.edgeBlockPrelaunch
            EdgeBlockPrinting                                     = $getValue.AdditionalProperties.edgeBlockPrinting
            EdgeBlockSavingHistory                                = $getValue.AdditionalProperties.edgeBlockSavingHistory
            EdgeBlockSearchEngineCustomization                    = $getValue.AdditionalProperties.edgeBlockSearchEngineCustomization
            EdgeBlockSearchSuggestions                            = $getValue.AdditionalProperties.edgeBlockSearchSuggestions
            EdgeBlockSendingDoNotTrackHeader                      = $getValue.AdditionalProperties.edgeBlockSendingDoNotTrackHeader
            EdgeBlockSendingIntranetTrafficToInternetExplorer     = $getValue.AdditionalProperties.edgeBlockSendingIntranetTrafficToInternetExplorer
            EdgeBlockSideloadingExtensions                        = $getValue.AdditionalProperties.edgeBlockSideloadingExtensions
            EdgeBlockTabPreloading                                = $getValue.AdditionalProperties.edgeBlockTabPreloading
            EdgeBlockWebContentOnNewTabPage                       = $getValue.AdditionalProperties.edgeBlockWebContentOnNewTabPage
            EdgeClearBrowsingDataOnExit                           = $getValue.AdditionalProperties.edgeClearBrowsingDataOnExit
            EdgeCookiePolicy                                      = $enumEdgeCookiePolicy
            EdgeDisableFirstRunPage                               = $getValue.AdditionalProperties.edgeDisableFirstRunPage
            EdgeEnterpriseModeSiteListLocation                    = $getValue.AdditionalProperties.edgeEnterpriseModeSiteListLocation
            EdgeFavoritesBarVisibility                            = $enumEdgeFavoritesBarVisibility
            EdgeFavoritesListLocation                             = $getValue.AdditionalProperties.edgeFavoritesListLocation
            EdgeFirstRunUrl                                       = $getValue.AdditionalProperties.edgeFirstRunUrl
            EdgeHomeButtonConfiguration                           = $complexEdgeHomeButtonConfiguration
            EdgeHomeButtonConfigurationEnabled                    = $getValue.AdditionalProperties.edgeHomeButtonConfigurationEnabled
            EdgeHomepageUrls                                      = $getValue.AdditionalProperties.edgeHomepageUrls
            EdgeKioskModeRestriction                              = $enumEdgeKioskModeRestriction
            EdgeKioskResetAfterIdleTimeInMinutes                  = $getValue.AdditionalProperties.edgeKioskResetAfterIdleTimeInMinutes
            EdgeNewTabPageURL                                     = $getValue.AdditionalProperties.edgeNewTabPageURL
            EdgeOpensWith                                         = $enumEdgeOpensWith
            EdgePreventCertificateErrorOverride                   = $getValue.AdditionalProperties.edgePreventCertificateErrorOverride
            EdgeRequiredExtensionPackageFamilyNames               = $getValue.AdditionalProperties.edgeRequiredExtensionPackageFamilyNames
            EdgeRequireSmartScreen                                = $getValue.AdditionalProperties.edgeRequireSmartScreen
            EdgeSearchEngine                                      = $complexEdgeSearchEngine
            EdgeSendIntranetTrafficToInternetExplorer             = $getValue.AdditionalProperties.edgeSendIntranetTrafficToInternetExplorer
            EdgeShowMessageWhenOpeningInternetExplorerSites       = $enumEdgeShowMessageWhenOpeningInternetExplorerSites
            EdgeSyncFavoritesWithInternetExplorer                 = $getValue.AdditionalProperties.edgeSyncFavoritesWithInternetExplorer
            EdgeTelemetryForMicrosoft365Analytics                 = $enumEdgeTelemetryForMicrosoft365Analytics
            EnableAutomaticRedeployment                           = $getValue.AdditionalProperties.enableAutomaticRedeployment
            EnergySaverOnBatteryThresholdPercentage               = $getValue.AdditionalProperties.energySaverOnBatteryThresholdPercentage
            EnergySaverPluggedInThresholdPercentage               = $getValue.AdditionalProperties.energySaverPluggedInThresholdPercentage
            EnterpriseCloudPrintDiscoveryEndPoint                 = $getValue.AdditionalProperties.enterpriseCloudPrintDiscoveryEndPoint
            EnterpriseCloudPrintDiscoveryMaxLimit                 = $getValue.AdditionalProperties.enterpriseCloudPrintDiscoveryMaxLimit
            EnterpriseCloudPrintMopriaDiscoveryResourceIdentifier = $getValue.AdditionalProperties.enterpriseCloudPrintMopriaDiscoveryResourceIdentifier
            EnterpriseCloudPrintOAuthAuthority                    = $getValue.AdditionalProperties.enterpriseCloudPrintOAuthAuthority
            EnterpriseCloudPrintOAuthClientIdentifier             = $getValue.AdditionalProperties.enterpriseCloudPrintOAuthClientIdentifier
            EnterpriseCloudPrintResourceIdentifier                = $getValue.AdditionalProperties.enterpriseCloudPrintResourceIdentifier
            ExperienceBlockDeviceDiscovery                        = $getValue.AdditionalProperties.experienceBlockDeviceDiscovery
            ExperienceBlockErrorDialogWhenNoSIM                   = $getValue.AdditionalProperties.experienceBlockErrorDialogWhenNoSIM
            ExperienceBlockTaskSwitcher                           = $getValue.AdditionalProperties.experienceBlockTaskSwitcher
            ExperienceDoNotSyncBrowserSettings                    = $enumExperienceDoNotSyncBrowserSettings
            FindMyFiles                                           = $enumFindMyFiles
            GameDvrBlocked                                        = $getValue.AdditionalProperties.gameDvrBlocked
            InkWorkspaceAccess                                    = $enumInkWorkspaceAccess
            InkWorkspaceAccessState                               = $enumInkWorkspaceAccessState
            InkWorkspaceBlockSuggestedApps                        = $getValue.AdditionalProperties.inkWorkspaceBlockSuggestedApps
            InternetSharingBlocked                                = $getValue.AdditionalProperties.internetSharingBlocked
            LocationServicesBlocked                               = $getValue.AdditionalProperties.locationServicesBlocked
            LockScreenActivateAppsWithVoice                       = $enumLockScreenActivateAppsWithVoice
            LockScreenAllowTimeoutConfiguration                   = $getValue.AdditionalProperties.lockScreenAllowTimeoutConfiguration
            LockScreenBlockActionCenterNotifications              = $getValue.AdditionalProperties.lockScreenBlockActionCenterNotifications
            LockScreenBlockCortana                                = $getValue.AdditionalProperties.lockScreenBlockCortana
            LockScreenBlockToastNotifications                     = $getValue.AdditionalProperties.lockScreenBlockToastNotifications
            LockScreenTimeoutInSeconds                            = $getValue.AdditionalProperties.lockScreenTimeoutInSeconds
            LogonBlockFastUserSwitching                           = $getValue.AdditionalProperties.logonBlockFastUserSwitching
            MessagingBlockMMS                                     = $getValue.AdditionalProperties.messagingBlockMMS
            MessagingBlockRichCommunicationServices               = $getValue.AdditionalProperties.messagingBlockRichCommunicationServices
            MessagingBlockSync                                    = $getValue.AdditionalProperties.messagingBlockSync
            MicrosoftAccountBlocked                               = $getValue.AdditionalProperties.microsoftAccountBlocked
            MicrosoftAccountBlockSettingsSync                     = $getValue.AdditionalProperties.microsoftAccountBlockSettingsSync
            MicrosoftAccountSignInAssistantSettings               = $enumMicrosoftAccountSignInAssistantSettings
            NetworkProxyApplySettingsDeviceWide                   = $getValue.AdditionalProperties.networkProxyApplySettingsDeviceWide
            NetworkProxyAutomaticConfigurationUrl                 = $getValue.AdditionalProperties.networkProxyAutomaticConfigurationUrl
            NetworkProxyDisableAutoDetect                         = $getValue.AdditionalProperties.networkProxyDisableAutoDetect
            NetworkProxyServer                                    = $complexNetworkProxyServer
            NfcBlocked                                            = $getValue.AdditionalProperties.nfcBlocked
            OneDriveDisableFileSync                               = $getValue.AdditionalProperties.oneDriveDisableFileSync
            PasswordBlockSimple                                   = $getValue.AdditionalProperties.passwordBlockSimple
            PasswordExpirationDays                                = $getValue.AdditionalProperties.passwordExpirationDays
            PasswordMinimumAgeInDays                              = $getValue.AdditionalProperties.passwordMinimumAgeInDays
            PasswordMinimumCharacterSetCount                      = $getValue.AdditionalProperties.passwordMinimumCharacterSetCount
            PasswordMinimumLength                                 = $getValue.AdditionalProperties.passwordMinimumLength
            PasswordMinutesOfInactivityBeforeScreenTimeout        = $getValue.AdditionalProperties.passwordMinutesOfInactivityBeforeScreenTimeout
            PasswordPreviousPasswordBlockCount                    = $getValue.AdditionalProperties.passwordPreviousPasswordBlockCount
            PasswordRequired                                      = $getValue.AdditionalProperties.passwordRequired
            PasswordRequiredType                                  = $enumPasswordRequiredType
            PasswordRequireWhenResumeFromIdleState                = $getValue.AdditionalProperties.passwordRequireWhenResumeFromIdleState
            PasswordSignInFailureCountBeforeFactoryReset          = $getValue.AdditionalProperties.passwordSignInFailureCountBeforeFactoryReset
            PersonalizationDesktopImageUrl                        = $getValue.AdditionalProperties.personalizationDesktopImageUrl
            PersonalizationLockScreenImageUrl                     = $getValue.AdditionalProperties.personalizationLockScreenImageUrl
            PowerButtonActionOnBattery                            = $enumPowerButtonActionOnBattery
            PowerButtonActionPluggedIn                            = $enumPowerButtonActionPluggedIn
            PowerHybridSleepOnBattery                             = $enumPowerHybridSleepOnBattery
            PowerHybridSleepPluggedIn                             = $enumPowerHybridSleepPluggedIn
            PowerLidCloseActionOnBattery                          = $enumPowerLidCloseActionOnBattery
            PowerLidCloseActionPluggedIn                          = $enumPowerLidCloseActionPluggedIn
            PowerSleepButtonActionOnBattery                       = $enumPowerSleepButtonActionOnBattery
            PowerSleepButtonActionPluggedIn                       = $enumPowerSleepButtonActionPluggedIn
            PrinterBlockAddition                                  = $getValue.AdditionalProperties.printerBlockAddition
            PrinterDefaultName                                    = $getValue.AdditionalProperties.printerDefaultName
            PrinterNames                                          = $getValue.AdditionalProperties.printerNames
            PrivacyAdvertisingId                                  = $enumPrivacyAdvertisingId
            PrivacyAutoAcceptPairingAndConsentPrompts             = $getValue.AdditionalProperties.privacyAutoAcceptPairingAndConsentPrompts
            PrivacyBlockActivityFeed                              = $getValue.AdditionalProperties.privacyBlockActivityFeed
            PrivacyBlockInputPersonalization                      = $getValue.AdditionalProperties.privacyBlockInputPersonalization
            PrivacyBlockPublishUserActivities                     = $getValue.AdditionalProperties.privacyBlockPublishUserActivities
            PrivacyDisableLaunchExperience                        = $getValue.AdditionalProperties.privacyDisableLaunchExperience
            ResetProtectionModeBlocked                            = $getValue.AdditionalProperties.resetProtectionModeBlocked
            SafeSearchFilter                                      = $enumSafeSearchFilter
            ScreenCaptureBlocked                                  = $getValue.AdditionalProperties.screenCaptureBlocked
            SearchBlockDiacritics                                 = $getValue.AdditionalProperties.searchBlockDiacritics
            SearchBlockWebResults                                 = $getValue.AdditionalProperties.searchBlockWebResults
            SearchDisableAutoLanguageDetection                    = $getValue.AdditionalProperties.searchDisableAutoLanguageDetection
            SearchDisableIndexerBackoff                           = $getValue.AdditionalProperties.searchDisableIndexerBackoff
            SearchDisableIndexingEncryptedItems                   = $getValue.AdditionalProperties.searchDisableIndexingEncryptedItems
            SearchDisableIndexingRemovableDrive                   = $getValue.AdditionalProperties.searchDisableIndexingRemovableDrive
            SearchDisableLocation                                 = $getValue.AdditionalProperties.searchDisableLocation
            SearchDisableUseLocation                              = $getValue.AdditionalProperties.searchDisableUseLocation
            SearchEnableAutomaticIndexSizeManangement             = $getValue.AdditionalProperties.searchEnableAutomaticIndexSizeManangement
            SearchEnableRemoteQueries                             = $getValue.AdditionalProperties.searchEnableRemoteQueries
            SecurityBlockAzureADJoinedDevicesAutoEncryption       = $getValue.AdditionalProperties.securityBlockAzureADJoinedDevicesAutoEncryption
            SettingsBlockAccountsPage                             = $getValue.AdditionalProperties.settingsBlockAccountsPage
            SettingsBlockAddProvisioningPackage                   = $getValue.AdditionalProperties.settingsBlockAddProvisioningPackage
            SettingsBlockAppsPage                                 = $getValue.AdditionalProperties.settingsBlockAppsPage
            SettingsBlockChangeLanguage                           = $getValue.AdditionalProperties.settingsBlockChangeLanguage
            SettingsBlockChangePowerSleep                         = $getValue.AdditionalProperties.settingsBlockChangePowerSleep
            SettingsBlockChangeRegion                             = $getValue.AdditionalProperties.settingsBlockChangeRegion
            SettingsBlockChangeSystemTime                         = $getValue.AdditionalProperties.settingsBlockChangeSystemTime
            SettingsBlockDevicesPage                              = $getValue.AdditionalProperties.settingsBlockDevicesPage
            SettingsBlockEaseOfAccessPage                         = $getValue.AdditionalProperties.settingsBlockEaseOfAccessPage
            SettingsBlockEditDeviceName                           = $getValue.AdditionalProperties.settingsBlockEditDeviceName
            SettingsBlockGamingPage                               = $getValue.AdditionalProperties.settingsBlockGamingPage
            SettingsBlockNetworkInternetPage                      = $getValue.AdditionalProperties.settingsBlockNetworkInternetPage
            SettingsBlockPersonalizationPage                      = $getValue.AdditionalProperties.settingsBlockPersonalizationPage
            SettingsBlockPrivacyPage                              = $getValue.AdditionalProperties.settingsBlockPrivacyPage
            SettingsBlockRemoveProvisioningPackage                = $getValue.AdditionalProperties.settingsBlockRemoveProvisioningPackage
            SettingsBlockSettingsApp                              = $getValue.AdditionalProperties.settingsBlockSettingsApp
            SettingsBlockSystemPage                               = $getValue.AdditionalProperties.settingsBlockSystemPage
            SettingsBlockTimeLanguagePage                         = $getValue.AdditionalProperties.settingsBlockTimeLanguagePage
            SettingsBlockUpdateSecurityPage                       = $getValue.AdditionalProperties.settingsBlockUpdateSecurityPage
            SharedUserAppDataAllowed                              = $getValue.AdditionalProperties.sharedUserAppDataAllowed
            SmartScreenAppInstallControl                          = $enumSmartScreenAppInstallControl
            SmartScreenBlockPromptOverride                        = $getValue.AdditionalProperties.smartScreenBlockPromptOverride
            SmartScreenBlockPromptOverrideForFiles                = $getValue.AdditionalProperties.smartScreenBlockPromptOverrideForFiles
            SmartScreenEnableAppInstallControl                    = $getValue.AdditionalProperties.smartScreenEnableAppInstallControl
            StartBlockUnpinningAppsFromTaskbar                    = $getValue.AdditionalProperties.startBlockUnpinningAppsFromTaskbar
            StartMenuAppListVisibility                            = $enumStartMenuAppListVisibility
            StartMenuHideChangeAccountSettings                    = $getValue.AdditionalProperties.startMenuHideChangeAccountSettings
            StartMenuHideFrequentlyUsedApps                       = $getValue.AdditionalProperties.startMenuHideFrequentlyUsedApps
            StartMenuHideHibernate                                = $getValue.AdditionalProperties.startMenuHideHibernate
            StartMenuHideLock                                     = $getValue.AdditionalProperties.startMenuHideLock
            StartMenuHidePowerButton                              = $getValue.AdditionalProperties.startMenuHidePowerButton
            StartMenuHideRecentJumpLists                          = $getValue.AdditionalProperties.startMenuHideRecentJumpLists
            StartMenuHideRecentlyAddedApps                        = $getValue.AdditionalProperties.startMenuHideRecentlyAddedApps
            StartMenuHideRestartOptions                           = $getValue.AdditionalProperties.startMenuHideRestartOptions
            StartMenuHideShutDown                                 = $getValue.AdditionalProperties.startMenuHideShutDown
            StartMenuHideSignOut                                  = $getValue.AdditionalProperties.startMenuHideSignOut
            StartMenuHideSleep                                    = $getValue.AdditionalProperties.startMenuHideSleep
            StartMenuHideSwitchAccount                            = $getValue.AdditionalProperties.startMenuHideSwitchAccount
            StartMenuHideUserTile                                 = $getValue.AdditionalProperties.startMenuHideUserTile
            StartMenuLayoutEdgeAssetsXml                          = $getValue.AdditionalProperties.startMenuLayoutEdgeAssetsXml
            StartMenuLayoutXml                                    = $getValue.AdditionalProperties.startMenuLayoutXml
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
            StorageBlockRemovableStorage                          = $getValue.AdditionalProperties.storageBlockRemovableStorage
            StorageRequireMobileDeviceEncryption                  = $getValue.AdditionalProperties.storageRequireMobileDeviceEncryption
            StorageRestrictAppDataToSystemVolume                  = $getValue.AdditionalProperties.storageRestrictAppDataToSystemVolume
            StorageRestrictAppInstallToSystemVolume               = $getValue.AdditionalProperties.storageRestrictAppInstallToSystemVolume
            SystemTelemetryProxyServer                            = $getValue.AdditionalProperties.systemTelemetryProxyServer
            TaskManagerBlockEndTask                               = $getValue.AdditionalProperties.taskManagerBlockEndTask
            TenantLockdownRequireNetworkDuringOutOfBoxExperience  = $getValue.AdditionalProperties.tenantLockdownRequireNetworkDuringOutOfBoxExperience
            UninstallBuiltInApps                                  = $getValue.AdditionalProperties.uninstallBuiltInApps
            UsbBlocked                                            = $getValue.AdditionalProperties.usbBlocked
            VoiceRecordingBlocked                                 = $getValue.AdditionalProperties.voiceRecordingBlocked
            WebRtcBlockLocalhostIpAddress                         = $getValue.AdditionalProperties.webRtcBlockLocalhostIpAddress
            WiFiBlockAutomaticConnectHotspots                     = $getValue.AdditionalProperties.wiFiBlockAutomaticConnectHotspots
            WiFiBlocked                                           = $getValue.AdditionalProperties.wiFiBlocked
            WiFiBlockManualConfiguration                          = $getValue.AdditionalProperties.wiFiBlockManualConfiguration
            WiFiScanInterval                                      = $getValue.AdditionalProperties.wiFiScanInterval
            Windows10AppsForceUpdateSchedule                      = $complexWindows10AppsForceUpdateSchedule
            WindowsSpotlightBlockConsumerSpecificFeatures         = $getValue.AdditionalProperties.windowsSpotlightBlockConsumerSpecificFeatures
            WindowsSpotlightBlocked                               = $getValue.AdditionalProperties.windowsSpotlightBlocked
            WindowsSpotlightBlockOnActionCenter                   = $getValue.AdditionalProperties.windowsSpotlightBlockOnActionCenter
            WindowsSpotlightBlockTailoredExperiences              = $getValue.AdditionalProperties.windowsSpotlightBlockTailoredExperiences
            WindowsSpotlightBlockThirdPartyNotifications          = $getValue.AdditionalProperties.windowsSpotlightBlockThirdPartyNotifications
            WindowsSpotlightBlockWelcomeExperience                = $getValue.AdditionalProperties.windowsSpotlightBlockWelcomeExperience
            WindowsSpotlightBlockWindowsTips                      = $getValue.AdditionalProperties.windowsSpotlightBlockWindowsTips
            WindowsSpotlightConfigureOnLockScreen                 = $enumWindowsSpotlightConfigureOnLockScreen
            WindowsStoreBlockAutoUpdate                           = $getValue.AdditionalProperties.windowsStoreBlockAutoUpdate
            WindowsStoreBlocked                                   = $getValue.AdditionalProperties.windowsStoreBlocked
            WindowsStoreEnablePrivateStoreOnly                    = $getValue.AdditionalProperties.windowsStoreEnablePrivateStoreOnly
            WirelessDisplayBlockProjectionToThisDevice            = $getValue.AdditionalProperties.wirelessDisplayBlockProjectionToThisDevice
            WirelessDisplayBlockUserInputFromReceiver             = $getValue.AdditionalProperties.wirelessDisplayBlockUserInputFromReceiver
            WirelessDisplayRequirePinForPairing                   = $getValue.AdditionalProperties.wirelessDisplayRequirePinForPairing
            Description                                           = $getValue.Description
            DisplayName                                           = $getValue.DisplayName
            SupportsScopeTags                                     = $getValue.SupportsScopeTags
            Id                                                    = $getValue.Id
            Ensure                                                = 'Present'
            Credential                                            = $Credential
            ApplicationId                                         = $ApplicationId
            TenantId                                              = $TenantId
            ApplicationSecret                                     = $ApplicationSecret
            CertificateThumbprint                                 = $CertificateThumbprint
            Managedidentity                                       = $ManagedIdentity.IsPresent
            #endregion
        }

        $rawAssignments = @()
        $rawAssignments =  Get-MgBetaDeviceManagementDeviceConfigurationAssignment -DeviceConfigurationId $Id -All
        $assignmentResult = @()
        if($null -ne $rawAssignments -and $rawAssignments.count -gt 0)
        {
            $assignmentResult += ConvertFrom-IntunePolicyAssignment -Assignments $rawAssignments
        }
        $results.Add('Assignments', $assignmentResult)

        return [System.Collections.Hashtable] $results
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $nullResult
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
        [System.Boolean]
        $SupportsScopeTags,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
        #endregion
        [Parameter()]
        [System.String]
        [ValidateSet('Absent', 'Present')]
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
        [Switch]
        $ManagedIdentity
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

    $PSBoundParameters.Remove('Ensure') | Out-Null
    $PSBoundParameters.Remove('Credential') | Out-Null
    $PSBoundParameters.Remove('ApplicationId') | Out-Null
    $PSBoundParameters.Remove('ApplicationSecret') | Out-Null
    $PSBoundParameters.Remove('TenantId') | Out-Null
    $PSBoundParameters.Remove('CertificateThumbprint') | Out-Null
    $PSBoundParameters.Remove('ManagedIdentity') | Out-Null
    $PSBoundParameters.Remove('Verbose') | Out-Null

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Device Configuration Policy for Windows10 with DisplayName {$DisplayName}"
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $CreateParameters = ([Hashtable]$PSBoundParameters).clone()
        $CreateParameters = Rename-M365DSCCimInstanceParameter -Properties $CreateParameters
        $CreateParameters.Remove('Id') | Out-Null

        $keys = (([Hashtable]$CreateParameters).clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $CreateParameters.$key -and $CreateParameters.$key.getType().Name -like '*cimInstance*')
            {
                $CreateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $CreateParameters.$key
            }
        }
        #region resource generator code
        $CreateParameters.Add("@odata.type", "#microsoft.graph.windows10GeneralConfiguration")
        $policy = New-MgBetaDeviceManagementDeviceConfiguration -BodyParameter $CreateParameters
        #endregion
        #region new Intune assignment management
        if ($policy.id)
        {
            $intuneAssignments = @()
            if($null -ne $Assignments -and $Assignments.count -gt 0)
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

        $UpdateParameters = ([Hashtable]$PSBoundParameters).clone()
        $UpdateParameters = Rename-M365DSCCimInstanceParameter -Properties $UpdateParameters

        $UpdateParameters.Remove('Id') | Out-Null

        $keys = (([Hashtable]$UpdateParameters).clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $UpdateParameters.$key -and $UpdateParameters.$key.getType().Name -like '*cimInstance*')
            {
                $UpdateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $UpdateParameters.$key
            }
        }
        #region resource generator code
        $UpdateParameters.Add("@odata.type", "#microsoft.graph.windows10GeneralConfiguration")
        Update-MgBetaDeviceManagementDeviceConfiguration  `
            -DeviceConfigurationId $currentInstance.Id `
            -BodyParameter $UpdateParameters
        #endregion
        #region new Intune assignment management
        $currentAssignments = @()
        $currentAssignments += Get-MgBetaDeviceManagementDeviceConfigurationAssignment -DeviceConfigurationId $currentInstance.id

        $intuneAssignments = @()
        if($null -ne $Assignments -and $Assignments.count -gt 0)
        {
            $intuneAssignments += ConvertTo-IntunePolicyAssignment -Assignments $Assignments
        }
        foreach ($assignment in $intuneAssignments)
        {
            if ( $null -eq ($currentAssignments | Where-Object { $_.Target.AdditionalProperties.groupId -eq $assignment.Target.groupId -and $_.Target.AdditionalProperties."@odata.type" -eq $assignment.Target.'@odata.type' }))
            {
                New-MgBetaDeviceManagementDeviceConfigurationAssignment `
                    -DeviceConfigurationId $currentInstance.id `
                    -BodyParameter $assignment
            }
            else
            {
                $currentAssignments = $currentAssignments | Where-Object { -not ($_.Target.AdditionalProperties.groupId -eq $assignment.Target.groupId -and $_.Target.AdditionalProperties."@odata.type" -eq $assignment.Target.'@odata.type') }
            }
        }
        if($currentAssignments.count -gt 0)
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
        [System.Boolean]
        $SupportsScopeTags,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
        #endregion

        [Parameter()]
        [System.String]
        [ValidateSet('Absent', 'Present')]
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
        [Switch]
        $ManagedIdentity
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

    Write-Verbose -Message "Testing configuration of the Intune Device Configuration Policy for Windows10 with Id {$Id} and DisplayName {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()

    if ($CurrentValues.Ensure -ne $PSBoundParameters.Ensure)
    {
        Write-Verbose -Message "Test-TargetResource returned $false"
        return $false
    }
    $testResult = $true

    #Compare Cim instances
    foreach ($key in $PSBoundParameters.Keys)
    {
        $source = $PSBoundParameters.$key
        $target = $CurrentValues.$key
        if ($source.getType().Name -like '*CimInstance*')
        {
            $source = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $source

            $testResult = Compare-M365DSCComplexObject `
                -Source ($source) `
                -Target ($target)

            if( $key -eq "Assignments")
            {
                $testResult = $source.count -eq $target.count
                if (-Not $testResult) { break }
                foreach ($assignment in $source)
                {
                    if ($assignment.dataType -like '*GroupAssignmentTarget')
                    {
                        $testResult = $null -ne ($target | Where-Object {$_.dataType -eq $assignment.DataType -and $_.groupId -eq $assignment.groupId})
                        #Using assignment groupDisplayName only if the groupId is not found in the directory otherwise groupId should be the key
                        if (-not $testResult)
                        {
                            $groupNotFound =  $null -eq (Get-MgGroup -GroupId ($assignment.groupId) -ErrorAction SilentlyContinue)
                        }
                        if (-not $testResult -and $groupNotFound)
                        {
                            $testResult = $null -ne ($target | Where-Object {$_.dataType -eq $assignment.DataType -and $_.groupDisplayName -eq $assignment.groupDisplayName})
                        }
                    }
                    else
                    {
                        $testResult = $null -ne ($target | Where-Object {$_.dataType -eq $assignment.DataType})
                    }
                    if (-Not $testResult) { break }
                }
                if (-Not $testResult) { break }
            }
            if (-Not $testResult) { break }

            $ValuesToCheck.Remove($key) | Out-Null
        }
    }

    $ValuesToCheck.remove('Id') | Out-Null
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

    if ($testResult)
    {
        $testResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
            -Source $($MyInvocation.MyCommand.Source) `
            -DesiredValues $PSBoundParameters `
            -ValuesToCheck $ValuesToCheck.Keys
    }

    Write-Verbose -Message "Test-TargetResource returned $testResult"

    return $testResult
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
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
        [Switch]
        $ManagedIdentity
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
        [array]$getValue = Get-MgBetaDeviceManagementDeviceConfiguration `
            -All `
            -ErrorAction Stop | Where-Object `
            -FilterScript { `
                $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.windows10GeneralConfiguration' `
        }
        #endregion

        $i = 1
        $dscContent = ''
        if ($getValue.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($config in $getValue)
        {
            $displayedKey = $config.Id
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            Write-Host "    |---[$i/$($getValue.Count)] $displayedKey" -NoNewline
            $params = @{
                Id                    = $config.Id
                DisplayName           = $config.DisplayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                Managedidentity       = $ManagedIdentity.IsPresent
            }

            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            if ($null -ne $Results.DefenderDetectedMalwareActions)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.DefenderDetectedMalwareActions `
                    -CIMInstanceName 'MicrosoftGraphdefenderDetectedMalwareActions1'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
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
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
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
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
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
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
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
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
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
                -Credential $Credential
            if ($Results.DefenderDetectedMalwareActions)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'DefenderDetectedMalwareActions' -IsCIMArray:$False
            }
            if ($Results.EdgeHomeButtonConfiguration)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'EdgeHomeButtonConfiguration' -IsCIMArray:$False
            }
            if ($Results.EdgeSearchEngine)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'EdgeSearchEngine' -IsCIMArray:$False
            }
            if ($Results.NetworkProxyServer)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'NetworkProxyServer' -IsCIMArray:$False
            }
            if ($Results.Windows10AppsForceUpdateSchedule)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'Windows10AppsForceUpdateSchedule' -IsCIMArray:$False
            }
            if ($Results.Assignments)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'Assignments' -IsCIMArray:$true
            }
            #removing trailing commas and semi colons between items of an array of cim instances added by Convert-DSCStringParamToVariable
            $currentDSCBlock = $currentDSCBlock.Replace("    ,`r`n" , "    `r`n" )
            $currentDSCBlock = $currentDSCBlock.Replace("`r`n;`r`n" , "`r`n" )
            $currentDSCBlock = $currentDSCBlock.Replace(",`r`n",'')
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        return $dscContent
    }
    catch
    {
        if ($_.Exception -like '*401*' -or $_.ErrorDetails.Message -like "*`"ErrorCode`":`"Forbidden`"*")
        {
            Write-Host "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered for Intune."
        }
        else
        {
            Write-Host $Global:M365DSCEmojiRedX

            New-M365DSCLogEntry -Message 'Error during Export:' `
                -Exception $_ `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential
        }

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
