function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $True)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $EnterpriseCloudPrintDiscoveryEndPoint,

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
        [System.Uint64]
        $EnterpriseCloudPrintDiscoveryMaxLimit,

        [Parameter()]
        [System.String]
        $EnterpriseCloudPrintMopriaDiscoveryResourceIdentifier,

        [Parameter()]
        [System.Boolean]
        $SearchBlockDiacritics,

        [Parameter()]
        [System.Boolean]
        $SearchDisableAutoLanguageDetection,

        [Parameter()]
        [System.Boolean]
        $SearchDisableIndexingEncryptedItems,

        [Parameter()]
        [System.Boolean]
        $SearchEnableRemoteQueries,

        [Parameter()]
        [System.Boolean]
        $SearchDisableIndexerBackoff,

        [Parameter()]
        [System.Boolean]
        $SearchDisableIndexingRemovableDrive,

        [Parameter()]
        [System.Boolean]
        $SearchEnableAutomaticIndexSizeManangement,

        [Parameter()]
        [ValidateSet("userDefined", "none", "basic","enhanced","full")]
        [System.String]
        $DiagnosticsDataSubmissionMode,

        [Parameter()]
        [System.Boolean]
        $oneDriveDisableFileSync,

        [Parameter()]
        [System.Boolean]
        $SmartScreenEnableAppInstallControl,

        [Parameter()]
        [System.String]
        $PersonalizationDesktopImageUrl,

        [Parameter()]
        [System.String]
        $PersonalizationLockScreenImageUrl,

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
        $BluetoothBlockPrePairing,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockAutofill,

        [Parameter()]
        [System.Boolean]
        $EdgeBlocked,

        [Parameter()]
        [ValidateSet("userDefined", "allow", "blockThirdparty","blockAll")]
        [System.String]
        $EdgeCookiePolicy,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockDeveloperTools,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockSendingDoNotTrackHeader,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockExtensions,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockInPrivateBrowsing,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockJavaScript,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockPasswordManager,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockAddressBarDropdown,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockCompatibilityList,

        [Parameter()]
        [System.Boolean]
        $EdgeClearBrowsingDataOnExit,

        [Parameter()]
        [System.Boolean]
        $EdgeAllowStartPagesModification,

        [Parameter()]
        [System.Boolean]
        $EdgeDisableFirstRunPage,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockLiveTileDataCollection,

        [Parameter()]
        [System.Boolean]
        $EdgeSyncFavoritesWithInternetExplorer,

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
        [System.Boolean]
        $DefenderRequireRealTimeMonitoring,

        [Parameter()]
        [System.Boolean]
        $DefenderRequireBehaviorMonitoring,

        [Parameter()]
        [System.Boolean]
        $DefenderRequireNetworkInspectionSystem,

        [Parameter()]
        [System.Boolean]
        $DefenderScanDownloads,

        [Parameter()]
        [System.Boolean]
        $DefenderScanScriptsLoadedInInternetExplorer,

        [Parameter()]
        [System.Boolean]
        $DefenderBlockEndUserAccess,

        [Parameter()]
        [System.Uint64]
        $DefenderSignatureUpdateIntervalInHours,

        [Parameter()]
        [ValidateSet("userDefined", "disable", "monitorAllFiles","monitorIncomingFilesOnly","monitorOutgoingFilesOnly")]
        [System.String]
        $DefenderMonitorFileActivity,

        [Parameter()]
        [System.Uint64]
        $DefenderDaysBeforeDeletingQuarantinedMalware,

        [Parameter()]
        [System.Uint64]
        $DefenderScanMaxCpu,

        [Parameter()]
        [System.Boolean]
        $DefenderScanArchiveFiles,

        [Parameter()]
        [System.Boolean]
        $DefenderScanIncomingMail,

        [Parameter()]
        [System.Boolean]
        $DefenderScanRemovableDrivesDuringFullScan,

        [Parameter()]
        [System.Boolean]
        $DefenderScanMappedNetworkDrivesDuringFullScan,

        [Parameter()]
        [System.Boolean]
        $DefenderScanNetworkFiles,

        [Parameter()]
        [System.Boolean]
        $DefenderRequireCloudProtection,

        [Parameter()]
        [ValidateSet("notConfigured", "high", "highPlus","zeroTolerance")]
        [System.String]
        $DefenderCloudBlockLevel,

        [Parameter()]
        [ValidateSet("userDefined", "alwaysPrompt", "promptBeforeSendingPersonalData","neverSendData","sendAllDataWithoutPrompting")]
        [System.String]
        $DefenderPromptForSampleSubmission,

        [Parameter()]
        [System.String]
        $DefenderScheduledQuickScanTime,

        [Parameter()]
        [ValidateSet("userDefined", "disabled", "quick","full")]
        [System.String]
        $DefenderScanType,

        [Parameter()]
        [System.string]
        $DefenderSystemScanSchedule,

        [Parameter()]
        [System.String]
        $DefenderScheduledScanTime,

        [Parameter()]
        [System.String[]]
        $DefenderFileExtensionsToExclude,

        [Parameter()]
        [System.String[]]
        $DefenderFilesAndFoldersToExclude,

        [Parameter()]
        [System.String[]]
        $DefenderProcessesToExclude,

        [Parameter()]
        [System.String[]]
        $DefenderDetectedMalwareActions,

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
        [System.Uint64]
        $LockScreenTimeoutInSeconds,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockSimple,

        [Parameter()]
        [System.Uint64]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Uint64]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Uint64]
        $PasswordMinutesOfInactivityBeforeScreenTimeout,

        [Parameter()]
        [System.Uint64]
        $PasswordMinimumCharacterSetCount,

        [Parameter()]
        [System.Uint64]
        $PasswordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Boolean]
        $PasswordRequired,

        [Parameter()]
        [System.Boolean]
        $PasswordRequireWhenResumeFromIdleState,

        [Parameter()]
        [ValidateSet("deviceDefault", "alphanumeric", "numeric")]
        [System.String]
        $PasswordRequiredType,

        [Parameter()]
        [System.Uint64]
        $PasswordSignInFailureCountBeforeFactoryReset,

        [Parameter()]
        [ValidateSet("notConfigured", "blocked", "allowed")]
        [System.String]
        $PrivacyAdvertisingId,

        [Parameter()]
        [System.Boolean]
        $PrivacyAutoAcceptPairingAndConsentPrompts,

        [Parameter()]
        [System.Boolean]
        $PrivacyBlockInputPersonalization,

        [Parameter()]
        [System.Boolean]
        $StartBlockUnpinningAppsFromTaskbar,

        [Parameter()]
        [ValidateSet("userDefined", "collapse", "remove","disableSettingsApp")]
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
        [ValidateSet("userDefined", "fullScreen", "nonFullScreen")]
        [System.String]
        $StartMenuMode,

        [Parameter()]
        [ValidateSet("notConfigured", "hide", "show")]
        [System.String]
        $StartMenuPinnedFolderDocuments,

        [Parameter()]
        [ValidateSet("notConfigured", "hide", "show")]
        [System.String]
        $StartMenuPinnedFolderDownloads,

        [Parameter()]
        [ValidateSet("notConfigured", "hide", "show")]
        [System.String]
        $StartMenuPinnedFolderFileExplorer,

        [Parameter()]
        [ValidateSet("notConfigured", "hide", "show")]
        [System.String]
        $StartMenuPinnedFolderHomeGroup,

        [Parameter()]
        [ValidateSet("notConfigured", "hide", "show")]
        [System.String]
        $StartMenuPinnedFolderMusic,

        [Parameter()]
        [ValidateSet("notConfigured", "hide", "show")]
        [System.String]
        $StartMenuPinnedFolderNetwork,

        [Parameter()]
        [ValidateSet("notConfigured", "hide", "show")]
        [System.String]
        $StartMenuPinnedFolderPersonalFolder,

        [Parameter()]
        [ValidateSet("notConfigured", "hide", "show")]
        [System.String]
        $StartMenuPinnedFolderPictures,

        [Parameter()]
        [ValidateSet("notConfigured", "hide", "show")]
        [System.String]
        $StartMenuPinnedFolderSettings,

        [Parameter()]
        [ValidateSet("notConfigured", "hide", "show")]
        [System.String]
        $StartMenuPinnedFolderVideos,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockSettingsApp,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockSystemPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockDevicesPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockNetworkInternetPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockPersonalizationPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockAccountsPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockTimeLanguagePage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockEaseOfAccessPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockPrivacyPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockUpdateSecurityPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockAppsPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockGamingPage,

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
        [ValidateSet("notConfigured", "disabled", "enabled")]
        [System.String]
        $WindowsSpotlightConfigureOnLockScreen,

        [Parameter()]
        [System.Boolean]
        $NetworkProxyApplySettingsDeviceWide,

        [Parameter()]
        [System.Boolean]
        $NetworkProxyDisableAutoDetect,

        [Parameter()]
        [System.String]
        $NetworkProxyAutomaticConfigurationUrl,

        [Parameter()]
        [System.String[]]
        $NetworkProxyServer,

        [Parameter()]
        [System.Boolean]
        $AccountsBlockAddingNonMicrosoftAccountEmail,

        [Parameter()]
        [System.Boolean]
        $AntiTheftModeBlocked,

        [Parameter()]
        [System.Boolean]
        $BluetoothBlocked,

        [Parameter()]
        [System.Boolean]
        $CameraBlocked,

        [Parameter()]
        [System.Boolean]
        $ConnectedDevicesServiceBlocked,

        [Parameter()]
        [System.Boolean]
        $CertificatesBlockManualRootCertificateInstallation,

        [Parameter()]
        [System.Boolean]
        $CopyPasteBlocked,

        [Parameter()]
        [System.Boolean]
        $CortanaBlocked,

        [Parameter()]
        [System.Boolean]
        $DeviceManagementBlockFactoryResetOnMobile,

        [Parameter()]
        [System.Boolean]
        $DeviceManagementBlockManualUnenroll,

        [Parameter()]
        [ValidateSet("userDefined", "strict", "moderate")]
        [System.String]
        $SafeSearchFilter,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockPopups,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockSearchSuggestions,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockSendingIntranetTrafficToInternetExplorer,

        [Parameter()]
        [System.Boolean]
        $EdgeSendIntranetTrafficToInternetExplorer,

        [Parameter()]
        [System.Boolean]
        $EdgeRequireSmartScreen,

        [Parameter()]
        [System.String]
        $EdgeEnterpriseModeSiteListLocation,

        [Parameter()]
        [System.String]
        $EdgeFirstRunUrl,

        [Parameter()]
        [System.String]
        $EdgeSearchEngine,

        [Parameter()]
        [System.String[]]
        $EdgeHomepageUrls,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockAccessToAboutFlags,

        [Parameter()]
        [System.Boolean]
        $SmartScreenBlockPromptOverride,

        [Parameter()]
        [System.Boolean]
        $SmartScreenBlockPromptOverrideForFiles,

        [Parameter()]
        [System.Boolean]
        $WebRtcBlockLocalhostIpAddress,

        [Parameter()]
        [System.Boolean]
        $InternetSharingBlocked,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockAddProvisioningPackage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockRemoveProvisioningPackage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockChangeSystemTime,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockEditDeviceName,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockChangeRegion,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockChangeLanguage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockChangePowerSleep,

        [Parameter()]
        [System.Boolean]
        $LocationServicesBlocked,

        [Parameter()]
        [System.Boolean]
        $MicrosoftAccountBlocked,

        [Parameter()]
        [System.Boolean]
        $MicrosoftAccountBlockSettingsSync,

        [Parameter()]
        [System.Boolean]
        $NfcBlocked,

        [Parameter()]
        [System.Boolean]
        $ResetProtectionModeBlocked,

        [Parameter()]
        [System.Boolean]
        $ScreenCaptureBlocked,

        [Parameter()]
        [System.Boolean]
        $StorageBlockRemovableStorage,

        [Parameter()]
        [System.Boolean]
        $StorageRequireMobileDeviceEncryption,

        [Parameter()]
        [System.Boolean]
        $UsbBlocked,

        [Parameter()]
        [System.Boolean]
        $VoiceRecordingBlocked,

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
        [System.Uint64]
        $WiFiScanInterval,

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
        [System.Boolean]
        $WindowsStoreBlocked,

        [Parameter()]
        [System.String]
        [ValidateSet("notConfigured", "blocked", "allowed")]
        $AppsAllowTrustedAppsSideloading,

        [Parameter()]
        [System.Boolean]
        $WindowsStoreBlockAutoUpdate,

        [Parameter()]
        [ValidateSet("notConfigured", "blocked", "allowed")]
        [System.String]
        $DeveloperUnlockSetting,

        [Parameter()]
        [System.Boolean]
        $SharedUserAppDataAllowed,

        [Parameter()]
        [System.Boolean]
        $AppsBlockWindowsStoreOriginatedApps,

        [Parameter()]
        [System.Boolean]
        $WindowsStoreEnablePrivateStoreOnly,

        [Parameter()]
        [System.Boolean]
        $StorageRestrictAppDataToSystemVolume,

        [Parameter()]
        [System.Boolean]
        $StorageRestrictAppInstallToSystemVolume,

        [Parameter()]
        [System.Boolean]
        $GameDvrBlocked,

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
        [System.Boolean]
        $LogonBlockFastUserSwitching,

        [Parameter()]
        [System.Boolean]
        $TenantLockdownRequireNetworkDuringOutOfBoxExperience,

        [Parameter(Mandatory = $True)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure,

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
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Checking for the Intune Device Configuration Policy {$DisplayName}"
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullResult = $PSBoundParameters
    $nullResult.Ensure = 'Absent'

    try
    {
        $policy = Get-MGDeviceManagementDeviceConfiguration -Filter "displayName eq '$DisplayName'" `
            -ErrorAction Stop | Where-Object -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.windows10GeneralConfiguration' }

        if ($null -eq $policy)
        {
            Write-Verbose -Message "No Device Configuration Policy {$DisplayName} was found"
            return $nullResult
        }

        Write-Verbose -Message "Found Device Configuration Policy {$DisplayName}"
        return @{
            Description                                             = $policy.Description
            DisplayName                                             = $policy.DisplayName
            EnterpriseCloudPrintDiscoveryEndPoint                   = $policy.AdditionalProperties.enterpriseCloudPrintDiscoveryEndPoint
            EnterpriseCloudPrintOAuthAuthority                      = $policy.AdditionalProperties.enterpriseCloudPrintOAuthAuthority
            EnterpriseCloudPrintOAuthClientIdentifier               = $policy.AdditionalProperties.enterpriseCloudPrintOAuthClientIdentifier
            EnterpriseCloudPrintResourceIdentifier                  = $policy.AdditionalProperties.enterpriseCloudPrintResourceIdentifier
            EnterpriseCloudPrintDiscoveryMaxLimit                   = $policy.AdditionalProperties.enterpriseCloudPrintDiscoveryMaxLimit
            EnterpriseCloudPrintMopriaDiscoveryResourceIdentifier   = $policy.AdditionalProperties.enterpriseCloudPrintMopriaDiscoveryResourceIdentifier
            SearchBlockDiacritics                                   = $policy.AdditionalProperties.searchBlockDiacritics
            SearchDisableAutoLanguageDetection                      = $policy.AdditionalProperties.searchDisableAutoLanguageDetection
            SearchDisableIndexingEncryptedItems                     = $policy.AdditionalProperties.searchDisableIndexingEncryptedItems
            SearchEnableRemoteQueries                               = $policy.AdditionalProperties.searchEnableRemoteQueries
            SearchDisableIndexerBackoff                             = $policy.AdditionalProperties.searchDisableIndexerBackoff
            SearchDisableIndexingRemovableDrive                     = $policy.AdditionalProperties.searchDisableIndexingRemovableDrive
            SearchEnableAutomaticIndexSizeManangement               = $policy.AdditionalProperties.searchEnableAutomaticIndexSizeManangement
            DiagnosticsDataSubmissionMode                           = $policy.AdditionalProperties.diagnosticsDataSubmissionMode
            OneDriveDisableFileSync                                 = $policy.AdditionalProperties.oneDriveDisableFileSync
            SmartScreenEnableAppInstallControl                      = $policy.AdditionalProperties.smartScreenEnableAppInstallControl
            PersonalizationDesktopImageUrl                          = $policy.AdditionalProperties.personalizationDesktopImageUrl
            PersonalizationLockScreenImageUrl                       = $policy.AdditionalProperties.personalizationLockScreenImageUrl
            BluetoothAllowedServices                                = $policy.AdditionalProperties.bluetoothAllowedServices
            BluetoothBlockAdvertising                               = $policy.AdditionalProperties.bluetoothBlockAdvertising
            BluetoothBlockDiscoverableMode                          = $policy.AdditionalProperties.bluetoothBlockDiscoverableMode
            BluetoothBlockPrePairing                                = $policy.AdditionalProperties.bluetoothBlockPrePairing
            EdgeBlockAutofill                                       = $policy.AdditionalProperties.edgeBlockAutofill
            EdgeBlocked                                             = $policy.AdditionalProperties.edgeBlocked
            EdgeCookiePolicy                                        = $policy.AdditionalProperties.edgeCookiePolicy
            EdgeBlockDeveloperTools                                 = $policy.AdditionalProperties.edgeBlockDeveloperTools
            EdgeBlockSendingDoNotTrackHeader                        = $policy.AdditionalProperties.edgeBlockSendingDoNotTrackHeader
            EdgeBlockExtensions                                     = $policy.AdditionalProperties.edgeBlockExtensions
            EdgeBlockInPrivateBrowsing                              = $policy.AdditionalProperties.edgeBlockInPrivateBrowsing
            EdgeBlockJavaScript                                     = $policy.AdditionalProperties.edgeBlockJavaScript
            EdgeBlockPasswordManager                                = $policy.AdditionalProperties.edgeBlockPasswordManager
            EdgeBlockAddressBarDropdown                             = $policy.AdditionalProperties.edgeBlockAddressBarDropdown
            EdgeBlockCompatibilityList                              = $policy.AdditionalProperties.edgeBlockCompatibilityList
            EdgeClearBrowsingDataOnExit                             = $policy.AdditionalProperties.edgeClearBrowsingDataOnExit
            EdgeAllowStartPagesModification                         = $policy.AdditionalProperties.edgeAllowStartPagesModification
            EdgeDisableFirstRunPage                                 = $policy.AdditionalProperties.edgeDisableFirstRunPage
            EdgeBlockLiveTileDataCollection                         = $policy.AdditionalProperties.edgeBlockLiveTileDataCollection
            EdgeSyncFavoritesWithInternetExplorer                   = $policy.AdditionalProperties.edgeSyncFavoritesWithInternetExplorer
            CellularBlockDataWhenRoaming                            = $policy.AdditionalProperties.cellularBlockDataWhenRoaming
            CellularBlockVpn                                        = $policy.AdditionalProperties.cellularBlockVpn
            CellularBlockVpnWhenRoaming                             = $policy.AdditionalProperties.cellularBlockVpnWhenRoaming
            DefenderRequireRealTimeMonitoring                       = $policy.AdditionalProperties.defenderRequireRealTimeMonitoring
            DefenderRequireBehaviorMonitoring                       = $policy.AdditionalProperties.defenderRequireBehaviorMonitoring
            DefenderRequireNetworkInspectionSystem                  = $policy.AdditionalProperties.defenderRequireNetworkInspectionSystem
            DefenderScanDownloads                                   = $policy.AdditionalProperties.defenderScanDownloads
            DefenderScanScriptsLoadedInInternetExplorer             = $policy.AdditionalProperties.defenderScanScriptsLoadedInInternetExplorer
            DefenderBlockEndUserAccess                              = $policy.AdditionalProperties.defenderBlockEndUserAccess
            DefenderSignatureUpdateIntervalInHours                  = $policy.AdditionalProperties.defenderSignatureUpdateIntervalInHours
            DefenderMonitorFileActivity                             = $policy.AdditionalProperties.defenderMonitorFileActivity
            DefenderDaysBeforeDeletingQuarantinedMalware            = $policy.AdditionalProperties.defenderDaysBeforeDeletingQuarantinedMalware
            DefenderScanMaxCpu                                      = $policy.AdditionalProperties.defenderScanMaxCpu
            DefenderScanArchiveFiles                                = $policy.AdditionalProperties.defenderScanArchiveFiles
            DefenderScanIncomingMail                                = $policy.AdditionalProperties.defenderScanIncomingMail
            DefenderScanRemovableDrivesDuringFullScan               = $policy.AdditionalProperties.defenderScanRemovableDrivesDuringFullScan
            DefenderScanMappedNetworkDrivesDuringFullScan           = $policy.AdditionalProperties.defenderScanMappedNetworkDrivesDuringFullScan
            DefenderScanNetworkFiles                                = $policy.AdditionalProperties.defenderScanNetworkFiles
            DefenderRequireCloudProtection                          = $policy.AdditionalProperties.defenderRequireCloudProtection
            DefenderCloudBlockLevel                                 = $policy.AdditionalProperties.defenderCloudBlockLevel
            DefenderPromptForSampleSubmission                       = $policy.AdditionalProperties.defenderPromptForSampleSubmission
            DefenderScheduledQuickScanTime                          = $policy.AdditionalProperties.defenderScheduledQuickScanTime
            DefenderScanType                                        = $policy.AdditionalProperties.defenderScanType
            DefenderSystemScanSchedule                              = $policy.AdditionalProperties.defenderSystemScanSchedule
            DefenderScheduledScanTime                               = $policy.AdditionalProperties.defenderScheduledScanTime
            DefenderDetectedMalwareActions                          = $policy.AdditionalProperties.defenderDetectedMalwareActions
            DefenderFileExtensionsToExclude                         = $policy.AdditionalProperties.defenderFileExtensionsToExclude
            DefenderFilesAndFoldersToExclude                        = $policy.AdditionalProperties.defenderFilesAndFoldersToExclude
            DefenderProcessesToExclude                              = $policy.AdditionalProperties.defenderProcessesToExclude
            LockScreenAllowTimeoutConfiguration                     = $policy.AdditionalProperties.lockScreenAllowTimeoutConfiguration
            LockScreenBlockActionCenterNotifications                = $policy.AdditionalProperties.lockScreenBlockActionCenterNotifications
            LockScreenBlockCortana                                  = $policy.AdditionalProperties.lockScreenBlockCortana
            LockScreenBlockToastNotifications                       = $policy.AdditionalProperties.lockScreenBlockToastNotifications
            LockScreenTimeoutInSeconds                              = $policy.AdditionalProperties.lockScreenTimeoutInSeconds
            PasswordBlockSimple                                     = $policy.AdditionalProperties.passwordBlockSimple
            PasswordExpirationDays                                  = $policy.AdditionalProperties.passwordExpirationDays
            PasswordMinimumLength                                   = $policy.AdditionalProperties.passwordMinimumLength
            PasswordMinutesOfInactivityBeforeScreenTimeout          = $policy.AdditionalProperties.passwordMinutesOfInactivityBeforeScreenTimeout
            PasswordMinimumCharacterSetCount                        = $policy.AdditionalProperties.passwordMinimumCharacterSetCount
            PasswordPreviousPasswordBlockCount                      = $policy.AdditionalProperties.passwordPreviousPasswordBlockCount
            PasswordRequired                                        = $policy.AdditionalProperties.passwordRequired
            PasswordRequireWhenResumeFromIdleState                  = $policy.AdditionalProperties.passwordRequireWhenResumeFromIdleState
            PasswordRequiredType                                    = $policy.AdditionalProperties.passwordRequiredType
            PasswordSignInFailureCountBeforeFactoryReset            = $policy.AdditionalProperties.passwordSignInFailureCountBeforeFactoryReset
            PrivacyAdvertisingId                                    = $policy.AdditionalProperties.privacyAdvertisingId
            PrivacyAutoAcceptPairingAndConsentPrompts               = $policy.AdditionalProperties.privacyAutoAcceptPairingAndConsentPrompts
            PrivacyBlockInputPersonalization                        = $policy.AdditionalProperties.privacyBlockInputPersonalization
            StartBlockUnpinningAppsFromTaskbar                      = $policy.AdditionalProperties.startBlockUnpinningAppsFromTaskbar
            StartMenuAppListVisibility                              = $policy.AdditionalProperties.startMenuAppListVisibility
            StartMenuHideChangeAccountSettings                      = $policy.AdditionalProperties.startMenuHideChangeAccountSettings
            StartMenuHideFrequentlyUsedApps                         = $policy.AdditionalProperties.startMenuHideFrequentlyUsedApps
            StartMenuHideHibernate                                  = $policy.AdditionalProperties.startMenuHideHibernate
            StartMenuHideLock                                       = $policy.AdditionalProperties.startMenuHideLock
            StartMenuHidePowerButton                                = $policy.AdditionalProperties.startMenuHidePowerButton
            StartMenuHideRecentJumpLists                            = $policy.AdditionalProperties.startMenuHideRecentJumpLists
            StartMenuHideRecentlyAddedApps                          = $policy.AdditionalProperties.startMenuHideRecentlyAddedApps
            StartMenuHideRestartOptions                             = $policy.AdditionalProperties.startMenuHideRestartOptions
            StartMenuHideShutDown                                   = $policy.AdditionalProperties.startMenuHideShutDown
            StartMenuHideSignOut                                    = $policy.AdditionalProperties.startMenuHideSignOut
            StartMenuHideSleep                                      = $policy.AdditionalProperties.startMenuHideSleep
            StartMenuHideSwitchAccount                              = $policy.AdditionalProperties.startMenuHideSwitchAccount
            StartMenuHideUserTile                                   = $policy.AdditionalProperties.startMenuHideUserTile
            StartMenuLayoutEdgeAssetsXml                            = $policy.AdditionalProperties.startMenuLayoutEdgeAssetsXml
            StartMenuLayoutXml                                      = $policy.AdditionalProperties.startMenuLayoutXml
            StartMenuMode                                           = $policy.AdditionalProperties.startMenuMode
            StartMenuPinnedFolderDocuments                          = $policy.AdditionalProperties.startMenuPinnedFolderDocuments
            StartMenuPinnedFolderDownloads                          = $policy.AdditionalProperties.startMenuPinnedFolderDownloads
            StartMenuPinnedFolderFileExplorer                       = $policy.AdditionalProperties.startMenuPinnedFolderFileExplorer
            StartMenuPinnedFolderHomeGroup                          = $policy.AdditionalProperties.startMenuPinnedFolderHomeGroup
            StartMenuPinnedFolderMusic                              = $policy.AdditionalProperties.startMenuPinnedFolderMusic
            StartMenuPinnedFolderNetwork                            = $policy.AdditionalProperties.startMenuPinnedFolderNetwork
            StartMenuPinnedFolderPersonalFolder                     = $policy.AdditionalProperties.startMenuPinnedFolderPersonalFolder
            StartMenuPinnedFolderPictures                           = $policy.AdditionalProperties.startMenuPinnedFolderPictures
            StartMenuPinnedFolderSettings                           = $policy.AdditionalProperties.startMenuPinnedFolderSettings
            StartMenuPinnedFolderVideos                             = $policy.AdditionalProperties.startMenuPinnedFolderVideos
            SettingsBlockSettingsApp                                = $policy.AdditionalProperties.settingsBlockSettingsApp
            SettingsBlockSystemPage                                 = $policy.AdditionalProperties.settingsBlockSystemPage
            SettingsBlockDevicesPage                                = $policy.AdditionalProperties.settingsBlockDevicesPage
            SettingsBlockNetworkInternetPage                        = $policy.AdditionalProperties.settingsBlockNetworkInternetPage
            SettingsBlockPersonalizationPage                        = $policy.AdditionalProperties.settingsBlockPersonalizationPage
            SettingsBlockAccountsPage                               = $policy.AdditionalProperties.settingsBlockAccountsPage
            SettingsBlockTimeLanguagePage                           = $policy.AdditionalProperties.settingsBlockTimeLanguagePage
            SettingsBlockEaseOfAccessPage                           = $policy.AdditionalProperties.settingsBlockEaseOfAccessPage
            SettingsBlockPrivacyPage                                = $policy.AdditionalProperties.settingsBlockPrivacyPage
            SettingsBlockUpdateSecurityPage                         = $policy.AdditionalProperties.settingsBlockUpdateSecurityPage
            SettingsBlockAppsPage                                   = $policy.AdditionalProperties.settingsBlockAppsPage
            SettingsBlockGamingPage                                 = $policy.AdditionalProperties.settingsBlockGamingPage
            WindowsSpotlightBlockConsumerSpecificFeatures           = $policy.AdditionalProperties.windowsSpotlightBlockConsumerSpecificFeatures
            WindowsSpotlightBlocked                                 = $policy.AdditionalProperties.windowsSpotlightBlocked
            WindowsSpotlightBlockOnActionCenter                     = $policy.AdditionalProperties.windowsSpotlightBlockOnActionCenter
            WindowsSpotlightBlockTailoredExperiences                = $policy.AdditionalProperties.windowsSpotlightBlockTailoredExperiences
            WindowsSpotlightBlockThirdPartyNotifications            = $policy.AdditionalProperties.windowsSpotlightBlockThirdPartyNotifications
            WindowsSpotlightBlockWelcomeExperience                  = $policy.AdditionalProperties.windowsSpotlightBlockWelcomeExperience
            WindowsSpotlightBlockWindowsTips                        = $policy.AdditionalProperties.windowsSpotlightBlockWindowsTips
            WindowsSpotlightConfigureOnLockScreen                   = $policy.AdditionalProperties.windowsSpotlightConfigureOnLockScreen
            NetworkProxyApplySettingsDeviceWide                     = $policy.AdditionalProperties.networkProxyApplySettingsDeviceWide
            NetworkProxyDisableAutoDetect                           = $policy.AdditionalProperties.networkProxyDisableAutoDetect
            NetworkProxyAutomaticConfigurationUrl                   = $policy.AdditionalProperties.networkProxyAutomaticConfigurationUrl
            NetworkProxyServer                                      = $policy.AdditionalProperties.networkProxyServer
            AccountsBlockAddingNonMicrosoftAccountEmail             = $policy.AdditionalProperties.accountsBlockAddingNonMicrosoftAccountEmail
            AntiTheftModeBlocked                                    = $policy.AdditionalProperties.antiTheftModeBlocked
            BluetoothBlocked                                        = $policy.AdditionalProperties.bluetoothBlocked
            CameraBlocked                                           = $policy.AdditionalProperties.cameraBlocked
            ConnectedDevicesServiceBlocked                          = $policy.AdditionalProperties.connectedDevicesServiceBlocked
            CertificatesBlockManualRootCertificateInstallation      = $policy.AdditionalProperties.certificatesBlockManualRootCertificateInstallation
            CopyPasteBlocked                                        = $policy.AdditionalProperties.copyPasteBlocked
            CortanaBlocked                                          = $policy.AdditionalProperties.cortanaBlocked
            DeviceManagementBlockFactoryResetOnMobile               = $policy.AdditionalProperties.deviceManagementBlockFactoryResetOnMobile
            DeviceManagementBlockManualUnenroll                     = $policy.AdditionalProperties.deviceManagementBlockManualUnenroll
            SafeSearchFilter                                        = $policy.AdditionalProperties.safeSearchFilter
            EdgeBlockPopups                                         = $policy.AdditionalProperties.edgeBlockPopups
            EdgeBlockSearchSuggestions                              = $policy.AdditionalProperties.edgeBlockSearchSuggestions
            EdgeBlockSendingIntranetTrafficToInternetExplorer       = $policy.AdditionalProperties.edgeBlockSendingIntranetTrafficToInternetExplorer
            EdgeSendIntranetTrafficToInternetExplorer               = $policy.AdditionalProperties.edgeSendIntranetTrafficToInternetExplorer
            EdgeRequireSmartScreen                                  = $policy.AdditionalProperties.edgeRequireSmartScreen
            EdgeEnterpriseModeSiteListLocation                      = $policy.AdditionalProperties.edgeEnterpriseModeSiteListLocation
            EdgeFirstRunUrl                                         = $policy.AdditionalProperties.edgeFirstRunUrl
            EdgeSearchEngine                                        = $policy.AdditionalProperties.edgeSearchEngine
            EdgeHomepageUrls                                        = $policy.AdditionalProperties.edgeHomepageUrls
            EdgeBlockAccessToAboutFlags                             = $policy.AdditionalProperties.edgeBlockAccessToAboutFlags
            SmartScreenBlockPromptOverride                          = $policy.AdditionalProperties.smartScreenBlockPromptOverride
            SmartScreenBlockPromptOverrideForFiles                  = $policy.AdditionalProperties.smartScreenBlockPromptOverrideForFiles
            WebRtcBlockLocalhostIpAddress                           = $policy.AdditionalProperties.webRtcBlockLocalhostIpAddress
            InternetSharingBlocked                                  = $policy.AdditionalProperties.internetSharingBlocked
            SettingsBlockAddProvisioningPackage                     = $policy.AdditionalProperties.settingsBlockAddProvisioningPackage
            SettingsBlockRemoveProvisioningPackage                  = $policy.AdditionalProperties.settingsBlockRemoveProvisioningPackage
            SettingsBlockChangeSystemTime                           = $policy.AdditionalProperties.settingsBlockChangeSystemTime
            SettingsBlockEditDeviceName                             = $policy.AdditionalProperties.settingsBlockEditDeviceName
            SettingsBlockChangeRegion                               = $policy.AdditionalProperties.settingsBlockChangeRegion
            SettingsBlockChangeLanguage                             = $policy.AdditionalProperties.settingsBlockChangeLanguage
            SettingsBlockChangePowerSleep                           = $policy.AdditionalProperties.settingsBlockChangePowerSleep
            LocationServicesBlocked                                 = $policy.AdditionalProperties.locationServicesBlocked
            MicrosoftAccountBlocked                                 = $policy.AdditionalProperties.microsoftAccountBlocked
            MicrosoftAccountBlockSettingsSync                       = $policy.AdditionalProperties.microsoftAccountBlockSettingsSync
            NfcBlocked                                              = $policy.AdditionalProperties.nfcBlocked
            ResetProtectionModeBlocked                              = $policy.AdditionalProperties.resetProtectionModeBlocked
            ScreenCaptureBlocked                                    = $policy.AdditionalProperties.screenCaptureBlocked
            StorageBlockRemovableStorage                            = $policy.AdditionalProperties.storageBlockRemovableStorage
            StorageRequireMobileDeviceEncryption                    = $policy.AdditionalProperties.storageRequireMobileDeviceEncryption
            UsbBlocked                                              = $policy.AdditionalProperties.usbBlocked
            VoiceRecordingBlocked                                   = $policy.AdditionalProperties.voiceRecordingBlocked
            WiFiBlockAutomaticConnectHotspots                       = $policy.AdditionalProperties.wiFiBlockAutomaticConnectHotspots
            WiFiBlocked                                             = $policy.AdditionalProperties.wiFiBlocked
            WiFiBlockManualConfiguration                            = $policy.AdditionalProperties.wiFiBlockManualConfiguration
            WiFiScanInterval                                        = $policy.AdditionalProperties.wiFiScanInterval
            WirelessDisplayBlockProjectionToThisDevice              = $policy.AdditionalProperties.wirelessDisplayBlockProjectionToThisDevice
            WirelessDisplayBlockUserInputFromReceiver               = $policy.AdditionalProperties.wirelessDisplayBlockUserInputFromReceiver
            WirelessDisplayRequirePinForPairing                     = $policy.AdditionalProperties.wirelessDisplayRequirePinForPairing
            WindowsStoreBlocked                                     = $policy.AdditionalProperties.windowsStoreBlocked
            AppsAllowTrustedAppsSideloading                         = $policy.AdditionalProperties.appsAllowTrustedAppsSideloading
            WindowsStoreBlockAutoUpdate                             = $policy.AdditionalProperties.windowsStoreBlockAutoUpdate
            DeveloperUnlockSetting                                  = $policy.AdditionalProperties.developerUnlockSetting
            SharedUserAppDataAllowed                                = $policy.AdditionalProperties.sharedUserAppDataAllowed
            AppsBlockWindowsStoreOriginatedApps                     = $policy.AdditionalProperties.appsBlockWindowsStoreOriginatedApps
            WindowsStoreEnablePrivateStoreOnly                      = $policy.AdditionalProperties.windowsStoreEnablePrivateStoreOnly
            StorageRestrictAppDataToSystemVolume                    = $policy.AdditionalProperties.storageRestrictAppDataToSystemVolume
            StorageRestrictAppInstallToSystemVolume                 = $policy.AdditionalProperties.storageRestrictAppInstallToSystemVolume
            GameDvrBlocked                                          = $policy.AdditionalProperties.gameDvrBlocked
            ExperienceBlockDeviceDiscovery                          = $policy.AdditionalProperties.experienceBlockDeviceDiscovery
            ExperienceBlockErrorDialogWhenNoSIM                     = $policy.AdditionalProperties.experienceBlockErrorDialogWhenNoSIM
            ExperienceBlockTaskSwitcher                             = $policy.AdditionalProperties.experienceBlockTaskSwitcher
            LogonBlockFastUserSwitching                             = $policy.AdditionalProperties.logonBlockFastUserSwitching
            TenantLockdownRequireNetworkDuringOutOfBoxExperience    = $policy.AdditionalProperties.tenantLockdownRequireNetworkDuringOutOfBoxExperience
            Ensure                                                  = "Present"
            Credential                                      = $Credential
            ApplicationId                                           = $ApplicationId
            TenantId                                                = $TenantId
            ApplicationSecret                                       = $ApplicationSecret
            CertificateThumbprint                                   = $CertificateThumbprint
        }
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            $tenantIdValue = $Credential.UserName.Split('@')[1]
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return $nullResult
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $True)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $EnterpriseCloudPrintDiscoveryEndPoint,

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
        [System.Uint64]
        $EnterpriseCloudPrintDiscoveryMaxLimit,

        [Parameter()]
        [System.String]
        $EnterpriseCloudPrintMopriaDiscoveryResourceIdentifier,

        [Parameter()]
        [System.Boolean]
        $SearchBlockDiacritics,

        [Parameter()]
        [System.Boolean]
        $SearchDisableAutoLanguageDetection,

        [Parameter()]
        [System.Boolean]
        $SearchDisableIndexingEncryptedItems,

        [Parameter()]
        [System.Boolean]
        $SearchEnableRemoteQueries,

        [Parameter()]
        [System.Boolean]
        $SearchDisableIndexerBackoff,

        [Parameter()]
        [System.Boolean]
        $SearchDisableIndexingRemovableDrive,

        [Parameter()]
        [System.Boolean]
        $SearchEnableAutomaticIndexSizeManangement,

        [Parameter()]
        [ValidateSet("userDefined", "none", "basic","enhanced","full")]
        [System.String]
        $DiagnosticsDataSubmissionMode,

        [Parameter()]
        [System.Boolean]
        $oneDriveDisableFileSync,

        [Parameter()]
        [System.Boolean]
        $SmartScreenEnableAppInstallControl,

        [Parameter()]
        [System.String]
        $PersonalizationDesktopImageUrl,

        [Parameter()]
        [System.String]
        $PersonalizationLockScreenImageUrl,

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
        $BluetoothBlockPrePairing,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockAutofill,

        [Parameter()]
        [System.Boolean]
        $EdgeBlocked,

        [Parameter()]
        [ValidateSet("userDefined", "allow", "blockThirdparty","blockAll")]
        [System.String]
        $EdgeCookiePolicy,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockDeveloperTools,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockSendingDoNotTrackHeader,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockExtensions,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockInPrivateBrowsing,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockJavaScript,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockPasswordManager,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockAddressBarDropdown,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockCompatibilityList,

        [Parameter()]
        [System.Boolean]
        $EdgeClearBrowsingDataOnExit,

        [Parameter()]
        [System.Boolean]
        $EdgeAllowStartPagesModification,

        [Parameter()]
        [System.Boolean]
        $EdgeDisableFirstRunPage,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockLiveTileDataCollection,

        [Parameter()]
        [System.Boolean]
        $EdgeSyncFavoritesWithInternetExplorer,

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
        [System.Boolean]
        $DefenderRequireRealTimeMonitoring,

        [Parameter()]
        [System.Boolean]
        $DefenderRequireBehaviorMonitoring,

        [Parameter()]
        [System.Boolean]
        $DefenderRequireNetworkInspectionSystem,

        [Parameter()]
        [System.Boolean]
        $DefenderScanDownloads,

        [Parameter()]
        [System.Boolean]
        $DefenderScanScriptsLoadedInInternetExplorer,

        [Parameter()]
        [System.Boolean]
        $DefenderBlockEndUserAccess,

        [Parameter()]
        [System.Uint64]
        $DefenderSignatureUpdateIntervalInHours,

        [Parameter()]
        [ValidateSet("userDefined", "disable", "monitorAllFiles","monitorIncomingFilesOnly","monitorOutgoingFilesOnly")]
        [System.String]
        $DefenderMonitorFileActivity,

        [Parameter()]
        [System.Uint64]
        $DefenderDaysBeforeDeletingQuarantinedMalware,

        [Parameter()]
        [System.Uint64]
        $DefenderScanMaxCpu,

        [Parameter()]
        [System.Boolean]
        $DefenderScanArchiveFiles,

        [Parameter()]
        [System.Boolean]
        $DefenderScanIncomingMail,

        [Parameter()]
        [System.Boolean]
        $DefenderScanRemovableDrivesDuringFullScan,

        [Parameter()]
        [System.Boolean]
        $DefenderScanMappedNetworkDrivesDuringFullScan,

        [Parameter()]
        [System.Boolean]
        $DefenderScanNetworkFiles,

        [Parameter()]
        [System.Boolean]
        $DefenderRequireCloudProtection,

        [Parameter()]
        [ValidateSet("notConfigured", "high", "highPlus","zeroTolerance")]
        [System.String]
        $DefenderCloudBlockLevel,

        [Parameter()]
        [ValidateSet("userDefined", "alwaysPrompt", "promptBeforeSendingPersonalData","neverSendData","sendAllDataWithoutPrompting")]
        [System.String]
        $DefenderPromptForSampleSubmission,

        [Parameter()]
        [System.String]
        $DefenderScheduledQuickScanTime,

        [Parameter()]
        [ValidateSet("userDefined", "disabled", "quick","full")]
        [System.String]
        $DefenderScanType,

        [Parameter()]
        [System.string]
        $DefenderSystemScanSchedule,

        [Parameter()]
        [System.String]
        $DefenderScheduledScanTime,

        [Parameter()]
        [System.String[]]
        $DefenderFileExtensionsToExclude,

        [Parameter()]
        [System.String[]]
        $DefenderFilesAndFoldersToExclude,

        [Parameter()]
        [System.String[]]
        $DefenderProcessesToExclude,

        [Parameter()]
        [System.String[]]
        $DefenderDetectedMalwareActions,

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
        [System.Uint64]
        $LockScreenTimeoutInSeconds,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockSimple,

        [Parameter()]
        [System.Uint64]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Uint64]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Uint64]
        $PasswordMinutesOfInactivityBeforeScreenTimeout,

        [Parameter()]
        [System.Uint64]
        $PasswordMinimumCharacterSetCount,

        [Parameter()]
        [System.Uint64]
        $PasswordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Boolean]
        $PasswordRequired,

        [Parameter()]
        [System.Boolean]
        $PasswordRequireWhenResumeFromIdleState,

        [Parameter()]
        [ValidateSet("deviceDefault", "alphanumeric", "numeric")]
        [System.String]
        $PasswordRequiredType,

        [Parameter()]
        [System.Uint64]
        $PasswordSignInFailureCountBeforeFactoryReset,

        [Parameter()]
        [ValidateSet("notConfigured", "blocked", "allowed")]
        [System.String]
        $PrivacyAdvertisingId,

        [Parameter()]
        [System.Boolean]
        $PrivacyAutoAcceptPairingAndConsentPrompts,

        [Parameter()]
        [System.Boolean]
        $PrivacyBlockInputPersonalization,

        [Parameter()]
        [System.Boolean]
        $StartBlockUnpinningAppsFromTaskbar,

        [Parameter()]
        [ValidateSet("userDefined", "collapse", "remove","disableSettingsApp")]
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
        [ValidateSet("userDefined", "fullScreen", "nonFullScreen")]
        [System.String]
        $StartMenuMode,

        [Parameter()]
        [ValidateSet("notConfigured", "hide", "show")]
        [System.String]
        $StartMenuPinnedFolderDocuments,

        [Parameter()]
        [ValidateSet("notConfigured", "hide", "show")]
        [System.String]
        $StartMenuPinnedFolderDownloads,

        [Parameter()]
        [ValidateSet("notConfigured", "hide", "show")]
        [System.String]
        $StartMenuPinnedFolderFileExplorer,

        [Parameter()]
        [ValidateSet("notConfigured", "hide", "show")]
        [System.String]
        $StartMenuPinnedFolderHomeGroup,

        [Parameter()]
        [ValidateSet("notConfigured", "hide", "show")]
        [System.String]
        $StartMenuPinnedFolderMusic,

        [Parameter()]
        [ValidateSet("notConfigured", "hide", "show")]
        [System.String]
        $StartMenuPinnedFolderNetwork,

        [Parameter()]
        [ValidateSet("notConfigured", "hide", "show")]
        [System.String]
        $StartMenuPinnedFolderPersonalFolder,

        [Parameter()]
        [ValidateSet("notConfigured", "hide", "show")]
        [System.String]
        $StartMenuPinnedFolderPictures,

        [Parameter()]
        [ValidateSet("notConfigured", "hide", "show")]
        [System.String]
        $StartMenuPinnedFolderSettings,

        [Parameter()]
        [ValidateSet("notConfigured", "hide", "show")]
        [System.String]
        $StartMenuPinnedFolderVideos,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockSettingsApp,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockSystemPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockDevicesPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockNetworkInternetPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockPersonalizationPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockAccountsPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockTimeLanguagePage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockEaseOfAccessPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockPrivacyPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockUpdateSecurityPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockAppsPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockGamingPage,

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
        [ValidateSet("notConfigured", "disabled", "enabled")]
        [System.String]
        $WindowsSpotlightConfigureOnLockScreen,

        [Parameter()]
        [System.Boolean]
        $NetworkProxyApplySettingsDeviceWide,

        [Parameter()]
        [System.Boolean]
        $NetworkProxyDisableAutoDetect,

        [Parameter()]
        [System.String]
        $NetworkProxyAutomaticConfigurationUrl,

        [Parameter()]
        [System.String[]]
        $NetworkProxyServer,

        [Parameter()]
        [System.Boolean]
        $AccountsBlockAddingNonMicrosoftAccountEmail,

        [Parameter()]
        [System.Boolean]
        $AntiTheftModeBlocked,

        [Parameter()]
        [System.Boolean]
        $BluetoothBlocked,

        [Parameter()]
        [System.Boolean]
        $CameraBlocked,

        [Parameter()]
        [System.Boolean]
        $ConnectedDevicesServiceBlocked,

        [Parameter()]
        [System.Boolean]
        $CertificatesBlockManualRootCertificateInstallation,

        [Parameter()]
        [System.Boolean]
        $CopyPasteBlocked,

        [Parameter()]
        [System.Boolean]
        $CortanaBlocked,

        [Parameter()]
        [System.Boolean]
        $DeviceManagementBlockFactoryResetOnMobile,

        [Parameter()]
        [System.Boolean]
        $DeviceManagementBlockManualUnenroll,

        [Parameter()]
        [ValidateSet("userDefined", "strict", "moderate")]
        [System.String]
        $SafeSearchFilter,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockPopups,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockSearchSuggestions,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockSendingIntranetTrafficToInternetExplorer,

        [Parameter()]
        [System.Boolean]
        $EdgeSendIntranetTrafficToInternetExplorer,

        [Parameter()]
        [System.Boolean]
        $EdgeRequireSmartScreen,

        [Parameter()]
        [System.String]
        $EdgeEnterpriseModeSiteListLocation,

        [Parameter()]
        [System.String]
        $EdgeFirstRunUrl,

        [Parameter()]
        [System.String]
        $EdgeSearchEngine,

        [Parameter()]
        [System.String[]]
        $EdgeHomepageUrls,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockAccessToAboutFlags,

        [Parameter()]
        [System.Boolean]
        $SmartScreenBlockPromptOverride,

        [Parameter()]
        [System.Boolean]
        $SmartScreenBlockPromptOverrideForFiles,

        [Parameter()]
        [System.Boolean]
        $WebRtcBlockLocalhostIpAddress,

        [Parameter()]
        [System.Boolean]
        $InternetSharingBlocked,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockAddProvisioningPackage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockRemoveProvisioningPackage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockChangeSystemTime,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockEditDeviceName,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockChangeRegion,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockChangeLanguage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockChangePowerSleep,

        [Parameter()]
        [System.Boolean]
        $LocationServicesBlocked,

        [Parameter()]
        [System.Boolean]
        $MicrosoftAccountBlocked,

        [Parameter()]
        [System.Boolean]
        $MicrosoftAccountBlockSettingsSync,

        [Parameter()]
        [System.Boolean]
        $NfcBlocked,

        [Parameter()]
        [System.Boolean]
        $ResetProtectionModeBlocked,

        [Parameter()]
        [System.Boolean]
        $ScreenCaptureBlocked,

        [Parameter()]
        [System.Boolean]
        $StorageBlockRemovableStorage,

        [Parameter()]
        [System.Boolean]
        $StorageRequireMobileDeviceEncryption,

        [Parameter()]
        [System.Boolean]
        $UsbBlocked,

        [Parameter()]
        [System.Boolean]
        $VoiceRecordingBlocked,

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
        [System.Uint64]
        $WiFiScanInterval,

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
        [System.Boolean]
        $WindowsStoreBlocked,

        [Parameter()]
        [System.String]
        [ValidateSet("notConfigured", "blocked", "allowed")]
        $AppsAllowTrustedAppsSideloading,

        [Parameter()]
        [System.Boolean]
        $WindowsStoreBlockAutoUpdate,

        [Parameter()]
        [ValidateSet("notConfigured", "blocked", "allowed")]
        [System.String]
        $DeveloperUnlockSetting,

        [Parameter()]
        [System.Boolean]
        $SharedUserAppDataAllowed,

        [Parameter()]
        [System.Boolean]
        $AppsBlockWindowsStoreOriginatedApps,

        [Parameter()]
        [System.Boolean]
        $WindowsStoreEnablePrivateStoreOnly,

        [Parameter()]
        [System.Boolean]
        $StorageRestrictAppDataToSystemVolume,

        [Parameter()]
        [System.Boolean]
        $StorageRestrictAppInstallToSystemVolume,

        [Parameter()]
        [System.Boolean]
        $GameDvrBlocked,

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
        [System.Boolean]
        $LogonBlockFastUserSwitching,

        [Parameter()]
        [System.Boolean]
        $TenantLockdownRequireNetworkDuringOutOfBoxExperience,

        [Parameter(Mandatory = $True)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure,

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
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentPolicy = Get-TargetResource @PSBoundParameters
    $PSBoundParameters.Remove("Ensure") | Out-Null
    $PSBoundParameters.Remove("Credential") | Out-Null
    $PSBoundParameters.Remove("ApplicationId") | Out-Null
    $PSBoundParameters.Remove("TenantId") | Out-Null
    $PSBoundParameters.Remove("ApplicationSecret") | Out-Null
    if ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Device Configuration Policy {$DisplayName}"
        $PSBoundParameters.Remove('DisplayName') | Out-Null
        $PSBoundParameters.Remove('Description') | Out-Null
        $AdditionalProperties = Get-M365DSCIntuneDeviceConfigurationPolicyWindowsAdditionalProperties -Properties ([System.Collections.Hashtable]$PSBoundParameters)
        New-MGDeviceManagementDeviceConfiguration -DisplayName $DisplayName `
            -Description $Description `
            -AdditionalProperties $AdditionalProperties
    }
    elseif ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating existing Device Configuration Policy {$DisplayName}"
        $configDevicePolicy = Get-MGDeviceManagementDeviceConfiguration `
            -ErrorAction Stop | Where-Object `
            -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.windows10GeneralConfiguration' -and `
                $_.displayName -eq $($DisplayName) }

        $PSBoundParameters.Remove('DisplayName') | Out-Null
        $PSBoundParameters.Remove('Description') | Out-Null
        $AdditionalProperties = Get-M365DSCIntuneDeviceConfigurationPolicyWindowsAdditionalProperties -Properties ([System.Collections.Hashtable]$PSBoundParameters)
        Update-MGDeviceManagementDeviceConfiguration -AdditionalProperties $AdditionalProperties `
            -Description $Description `
            -DeviceConfigurationId $configDevicePolicy.Id
    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Device Configuration Policy {$DisplayName}"
        $configDevicePolicy = Get-MGDeviceManagementDeviceConfiguration `
        -ErrorAction Stop | Where-Object `
        -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.windows10GeneralConfiguration' -and `
            $_.displayName -eq $($DisplayName) }

    Remove-MGDeviceManagementDeviceConfiguration -DeviceConfigurationId $configDevicePolicy.Id
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $True)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $EnterpriseCloudPrintDiscoveryEndPoint,

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
        [System.Uint64]
        $EnterpriseCloudPrintDiscoveryMaxLimit,

        [Parameter()]
        [System.String]
        $EnterpriseCloudPrintMopriaDiscoveryResourceIdentifier,

        [Parameter()]
        [System.Boolean]
        $SearchBlockDiacritics,

        [Parameter()]
        [System.Boolean]
        $SearchDisableAutoLanguageDetection,

        [Parameter()]
        [System.Boolean]
        $SearchDisableIndexingEncryptedItems,

        [Parameter()]
        [System.Boolean]
        $SearchEnableRemoteQueries,

        [Parameter()]
        [System.Boolean]
        $SearchDisableIndexerBackoff,

        [Parameter()]
        [System.Boolean]
        $SearchDisableIndexingRemovableDrive,

        [Parameter()]
        [System.Boolean]
        $SearchEnableAutomaticIndexSizeManangement,

        [Parameter()]
        [ValidateSet("userDefined", "none", "basic","enhanced","full")]
        [System.String]
        $DiagnosticsDataSubmissionMode,

        [Parameter()]
        [System.Boolean]
        $oneDriveDisableFileSync,

        [Parameter()]
        [System.Boolean]
        $SmartScreenEnableAppInstallControl,

        [Parameter()]
        [System.String]
        $PersonalizationDesktopImageUrl,

        [Parameter()]
        [System.String]
        $PersonalizationLockScreenImageUrl,

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
        $BluetoothBlockPrePairing,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockAutofill,

        [Parameter()]
        [System.Boolean]
        $EdgeBlocked,

        [Parameter()]
        [ValidateSet("userDefined", "allow", "blockThirdparty","blockAll")]
        [System.String]
        $EdgeCookiePolicy,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockDeveloperTools,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockSendingDoNotTrackHeader,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockExtensions,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockInPrivateBrowsing,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockJavaScript,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockPasswordManager,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockAddressBarDropdown,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockCompatibilityList,

        [Parameter()]
        [System.Boolean]
        $EdgeClearBrowsingDataOnExit,

        [Parameter()]
        [System.Boolean]
        $EdgeAllowStartPagesModification,

        [Parameter()]
        [System.Boolean]
        $EdgeDisableFirstRunPage,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockLiveTileDataCollection,

        [Parameter()]
        [System.Boolean]
        $EdgeSyncFavoritesWithInternetExplorer,

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
        [System.Boolean]
        $DefenderRequireRealTimeMonitoring,

        [Parameter()]
        [System.Boolean]
        $DefenderRequireBehaviorMonitoring,

        [Parameter()]
        [System.Boolean]
        $DefenderRequireNetworkInspectionSystem,

        [Parameter()]
        [System.Boolean]
        $DefenderScanDownloads,

        [Parameter()]
        [System.Boolean]
        $DefenderScanScriptsLoadedInInternetExplorer,

        [Parameter()]
        [System.Boolean]
        $DefenderBlockEndUserAccess,

        [Parameter()]
        [System.Uint64]
        $DefenderSignatureUpdateIntervalInHours,

        [Parameter()]
        [ValidateSet("userDefined", "disable", "monitorAllFiles","monitorIncomingFilesOnly","monitorOutgoingFilesOnly")]
        [System.String]
        $DefenderMonitorFileActivity,

        [Parameter()]
        [System.Uint64]
        $DefenderDaysBeforeDeletingQuarantinedMalware,

        [Parameter()]
        [System.Uint64]
        $DefenderScanMaxCpu,

        [Parameter()]
        [System.Boolean]
        $DefenderScanArchiveFiles,

        [Parameter()]
        [System.Boolean]
        $DefenderScanIncomingMail,

        [Parameter()]
        [System.Boolean]
        $DefenderScanRemovableDrivesDuringFullScan,

        [Parameter()]
        [System.Boolean]
        $DefenderScanMappedNetworkDrivesDuringFullScan,

        [Parameter()]
        [System.Boolean]
        $DefenderScanNetworkFiles,

        [Parameter()]
        [System.Boolean]
        $DefenderRequireCloudProtection,

        [Parameter()]
        [ValidateSet("notConfigured", "high", "highPlus","zeroTolerance")]
        [System.String]
        $DefenderCloudBlockLevel,

        [Parameter()]
        [ValidateSet("userDefined", "alwaysPrompt", "promptBeforeSendingPersonalData","neverSendData","sendAllDataWithoutPrompting")]
        [System.String]
        $DefenderPromptForSampleSubmission,

        [Parameter()]
        [System.String]
        $DefenderScheduledQuickScanTime,

        [Parameter()]
        [ValidateSet("userDefined", "disabled", "quick","full")]
        [System.String]
        $DefenderScanType,

        [Parameter()]
        [System.string]
        $DefenderSystemScanSchedule,

        [Parameter()]
        [System.String]
        $DefenderScheduledScanTime,

        [Parameter()]
        [System.String[]]
        $DefenderFileExtensionsToExclude,

        [Parameter()]
        [System.String[]]
        $DefenderFilesAndFoldersToExclude,

        [Parameter()]
        [System.String[]]
        $DefenderProcessesToExclude,

        [Parameter()]
        [System.String[]]
        $DefenderDetectedMalwareActions,

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
        [System.Uint64]
        $LockScreenTimeoutInSeconds,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockSimple,

        [Parameter()]
        [System.Uint64]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Uint64]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Uint64]
        $PasswordMinutesOfInactivityBeforeScreenTimeout,

        [Parameter()]
        [System.Uint64]
        $PasswordMinimumCharacterSetCount,

        [Parameter()]
        [System.Uint64]
        $PasswordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Boolean]
        $PasswordRequired,

        [Parameter()]
        [System.Boolean]
        $PasswordRequireWhenResumeFromIdleState,

        [Parameter()]
        [ValidateSet("deviceDefault", "alphanumeric", "numeric")]
        [System.String]
        $PasswordRequiredType,

        [Parameter()]
        [System.Uint64]
        $PasswordSignInFailureCountBeforeFactoryReset,

        [Parameter()]
        [ValidateSet("notConfigured", "blocked", "allowed")]
        [System.String]
        $PrivacyAdvertisingId,

        [Parameter()]
        [System.Boolean]
        $PrivacyAutoAcceptPairingAndConsentPrompts,

        [Parameter()]
        [System.Boolean]
        $PrivacyBlockInputPersonalization,

        [Parameter()]
        [System.Boolean]
        $StartBlockUnpinningAppsFromTaskbar,

        [Parameter()]
        [ValidateSet("userDefined", "collapse", "remove","disableSettingsApp")]
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
        [ValidateSet("userDefined", "fullScreen", "nonFullScreen")]
        [System.String]
        $StartMenuMode,

        [Parameter()]
        [ValidateSet("notConfigured", "hide", "show")]
        [System.String]
        $StartMenuPinnedFolderDocuments,

        [Parameter()]
        [ValidateSet("notConfigured", "hide", "show")]
        [System.String]
        $StartMenuPinnedFolderDownloads,

        [Parameter()]
        [ValidateSet("notConfigured", "hide", "show")]
        [System.String]
        $StartMenuPinnedFolderFileExplorer,

        [Parameter()]
        [ValidateSet("notConfigured", "hide", "show")]
        [System.String]
        $StartMenuPinnedFolderHomeGroup,

        [Parameter()]
        [ValidateSet("notConfigured", "hide", "show")]
        [System.String]
        $StartMenuPinnedFolderMusic,

        [Parameter()]
        [ValidateSet("notConfigured", "hide", "show")]
        [System.String]
        $StartMenuPinnedFolderNetwork,

        [Parameter()]
        [ValidateSet("notConfigured", "hide", "show")]
        [System.String]
        $StartMenuPinnedFolderPersonalFolder,

        [Parameter()]
        [ValidateSet("notConfigured", "hide", "show")]
        [System.String]
        $StartMenuPinnedFolderPictures,

        [Parameter()]
        [ValidateSet("notConfigured", "hide", "show")]
        [System.String]
        $StartMenuPinnedFolderSettings,

        [Parameter()]
        [ValidateSet("notConfigured", "hide", "show")]
        [System.String]
        $StartMenuPinnedFolderVideos,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockSettingsApp,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockSystemPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockDevicesPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockNetworkInternetPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockPersonalizationPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockAccountsPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockTimeLanguagePage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockEaseOfAccessPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockPrivacyPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockUpdateSecurityPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockAppsPage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockGamingPage,

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
        [ValidateSet("notConfigured", "disabled", "enabled")]
        [System.String]
        $WindowsSpotlightConfigureOnLockScreen,

        [Parameter()]
        [System.Boolean]
        $NetworkProxyApplySettingsDeviceWide,

        [Parameter()]
        [System.Boolean]
        $NetworkProxyDisableAutoDetect,

        [Parameter()]
        [System.String]
        $NetworkProxyAutomaticConfigurationUrl,

        [Parameter()]
        [System.String[]]
        $NetworkProxyServer,

        [Parameter()]
        [System.Boolean]
        $AccountsBlockAddingNonMicrosoftAccountEmail,

        [Parameter()]
        [System.Boolean]
        $AntiTheftModeBlocked,

        [Parameter()]
        [System.Boolean]
        $BluetoothBlocked,

        [Parameter()]
        [System.Boolean]
        $CameraBlocked,

        [Parameter()]
        [System.Boolean]
        $ConnectedDevicesServiceBlocked,

        [Parameter()]
        [System.Boolean]
        $CertificatesBlockManualRootCertificateInstallation,

        [Parameter()]
        [System.Boolean]
        $CopyPasteBlocked,

        [Parameter()]
        [System.Boolean]
        $CortanaBlocked,

        [Parameter()]
        [System.Boolean]
        $DeviceManagementBlockFactoryResetOnMobile,

        [Parameter()]
        [System.Boolean]
        $DeviceManagementBlockManualUnenroll,

        [Parameter()]
        [ValidateSet("userDefined", "strict", "moderate")]
        [System.String]
        $SafeSearchFilter,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockPopups,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockSearchSuggestions,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockSendingIntranetTrafficToInternetExplorer,

        [Parameter()]
        [System.Boolean]
        $EdgeSendIntranetTrafficToInternetExplorer,

        [Parameter()]
        [System.Boolean]
        $EdgeRequireSmartScreen,

        [Parameter()]
        [System.String]
        $EdgeEnterpriseModeSiteListLocation,

        [Parameter()]
        [System.String]
        $EdgeFirstRunUrl,

        [Parameter()]
        [System.String]
        $EdgeSearchEngine,

        [Parameter()]
        [System.String[]]
        $EdgeHomepageUrls,

        [Parameter()]
        [System.Boolean]
        $EdgeBlockAccessToAboutFlags,

        [Parameter()]
        [System.Boolean]
        $SmartScreenBlockPromptOverride,

        [Parameter()]
        [System.Boolean]
        $SmartScreenBlockPromptOverrideForFiles,

        [Parameter()]
        [System.Boolean]
        $WebRtcBlockLocalhostIpAddress,

        [Parameter()]
        [System.Boolean]
        $InternetSharingBlocked,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockAddProvisioningPackage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockRemoveProvisioningPackage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockChangeSystemTime,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockEditDeviceName,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockChangeRegion,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockChangeLanguage,

        [Parameter()]
        [System.Boolean]
        $SettingsBlockChangePowerSleep,

        [Parameter()]
        [System.Boolean]
        $LocationServicesBlocked,

        [Parameter()]
        [System.Boolean]
        $MicrosoftAccountBlocked,

        [Parameter()]
        [System.Boolean]
        $MicrosoftAccountBlockSettingsSync,

        [Parameter()]
        [System.Boolean]
        $NfcBlocked,

        [Parameter()]
        [System.Boolean]
        $ResetProtectionModeBlocked,

        [Parameter()]
        [System.Boolean]
        $ScreenCaptureBlocked,

        [Parameter()]
        [System.Boolean]
        $StorageBlockRemovableStorage,

        [Parameter()]
        [System.Boolean]
        $StorageRequireMobileDeviceEncryption,

        [Parameter()]
        [System.Boolean]
        $UsbBlocked,

        [Parameter()]
        [System.Boolean]
        $VoiceRecordingBlocked,

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
        [System.Uint64]
        $WiFiScanInterval,

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
        [System.Boolean]
        $WindowsStoreBlocked,

        [Parameter()]
        [System.String]
        [ValidateSet("notConfigured", "blocked", "allowed")]
        $AppsAllowTrustedAppsSideloading,

        [Parameter()]
        [System.Boolean]
        $WindowsStoreBlockAutoUpdate,

        [Parameter()]
        [ValidateSet("notConfigured", "blocked", "allowed")]
        [System.String]
        $DeveloperUnlockSetting,

        [Parameter()]
        [System.Boolean]
        $SharedUserAppDataAllowed,

        [Parameter()]
        [System.Boolean]
        $AppsBlockWindowsStoreOriginatedApps,

        [Parameter()]
        [System.Boolean]
        $WindowsStoreEnablePrivateStoreOnly,

        [Parameter()]
        [System.Boolean]
        $StorageRestrictAppDataToSystemVolume,

        [Parameter()]
        [System.Boolean]
        $StorageRestrictAppInstallToSystemVolume,

        [Parameter()]
        [System.Boolean]
        $GameDvrBlocked,

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
        [System.Boolean]
        $LogonBlockFastUserSwitching,

        [Parameter()]
        [System.Boolean]
        $TenantLockdownRequireNetworkDuringOutOfBoxExperience,

        [Parameter(Mandatory = $True)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure,

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
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    Write-Verbose -Message "Testing configuration of Device Configuration Policy {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $TestResult"

    return $TestResult
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
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        [array]$policies = Get-MGDeviceManagementDeviceConfiguration `
            -ErrorAction Stop | Where-Object `
            -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.windows10GeneralConfiguration' }
        $i = 1
        $dscContent = ''
        if ($policies.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewLine
        }
        foreach ($policy in $policies)
        {
            Write-Host "    |---[$i/$($policies.Count)] $($policy.DisplayName)" -NoNewline
            $params = @{
                DisplayName           = $policy.DisplayName
                Ensure                = 'Present'
                Credential    = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
            }
            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
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
        Write-Host $Global:M365DSCEmojiRedX
        if ($_.Exception -like '*401*')
        {
            Write-Host "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered for Intune."
        }
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = $Credential.UserName.Split('@')[1]

            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return ""
    }
}

function Get-M365DSCIntuneDeviceConfigurationPolicyWindowsAdditionalProperties
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $Properties
    )

    $results = @{"@odata.type" = "#microsoft.graph.windows10GeneralConfiguration"}
    foreach ($property in $properties.Keys)
    {
        if ($property -ne 'Verbose')
        {
            $propertyName = $property[0].ToString().ToLower() + $property.Substring(1, $property.Length - 1)
            $propertyValue = $properties.$property
            $results.Add($propertyName, $propertyValue)
        }
    }
    return $results
}

Export-ModuleMember -Function *-TargetResource
