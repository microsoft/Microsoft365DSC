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
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $ApplicationSecret
    )

    Write-Verbose -Message "Checking for the Intune Device Configuration Policy {$DisplayName}"
    $ConnectionMode = New-M365DSCConnection -Workload 'Intune' `
        -InboundParameters $PSBoundParameters
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    $data.Add("ConnectionMode", $ConnectionMode)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullResult = $PSBoundParameters
    $nullResult.Ensure = 'Absent'

    try
    {
        $policyInfo = Get-IntuneDeviceConfigurationPolicy -Filter "displayName eq '$DisplayName'" `
            -ErrorAction Stop | Where-Object -FilterScript { $_.'@odata.type' -eq '#microsoft.graph.windows10GeneralConfiguration' }

        if ($null -eq $policyInfo)
        {
            Write-Verbose -Message "No Device Configuration Policy {$DisplayName} was found"
            return $nullResult
        }

        $policy = Get-M365DSCIntuneDeviceConfigurationPolicyWindows -PolicyId $policyInfo.Id
        Write-Verbose -Message "Found Device Configuration Policy {$DisplayName}"
        return @{
            Description                                             = $policy.Description
            DisplayName                                             = $policy.DisplayName
            EnterpriseCloudPrintDiscoveryEndPoint                   = $policy.EnterpriseCloudPrintDiscoveryEndPoint
            EnterpriseCloudPrintOAuthAuthority                      = $policy.EnterpriseCloudPrintOAuthAuthority
            EnterpriseCloudPrintOAuthClientIdentifier               = $policy.EnterpriseCloudPrintOAuthClientIdentifier
            EnterpriseCloudPrintResourceIdentifier                  = $policy.EnterpriseCloudPrintResourceIdentifier
            EnterpriseCloudPrintDiscoveryMaxLimit                   = $policy.EnterpriseCloudPrintDiscoveryMaxLimit
            EnterpriseCloudPrintMopriaDiscoveryResourceIdentifier   = $policy.EnterpriseCloudPrintMopriaDiscoveryResourceIdentifier
            SearchBlockDiacritics                                   = $policy.SearchBlockDiacritics
            SearchDisableAutoLanguageDetection                      = $policy.SearchDisableAutoLanguageDetection
            SearchDisableIndexingEncryptedItems                     = $policy.SearchDisableIndexingEncryptedItems
            SearchEnableRemoteQueries                               = $policy.SearchEnableRemoteQueries
            SearchDisableIndexerBackoff                             = $policy.SearchDisableIndexerBackoff
            SearchDisableIndexingRemovableDrive                     = $policy.SearchDisableIndexingRemovableDrive
            SearchEnableAutomaticIndexSizeManangement               = $policy.SearchEnableAutomaticIndexSizeManangement
            DiagnosticsDataSubmissionMode                           = $policy.DiagnosticsDataSubmissionMode
            OneDriveDisableFileSync                                 = $policy.OneDriveDisableFileSync
            SmartScreenEnableAppInstallControl                      = $policy.SmartScreenEnableAppInstallControl
            PersonalizationDesktopImageUrl                          = $policy.PersonalizationDesktopImageUrl
            PersonalizationLockScreenImageUrl                       = $policy.PersonalizationLockScreenImageUrl
            BluetoothAllowedServices                                = $policy.BluetoothAllowedServices
            BluetoothBlockAdvertising                               = $policy.BluetoothBlockAdvertising
            BluetoothBlockDiscoverableMode                          = $policy.BluetoothBlockDiscoverableMode
            BluetoothBlockPrePairing                                = $policy.BluetoothBlockPrePairing
            EdgeBlockAutofill                                       = $policy.EdgeBlockAutofill
            EdgeBlocked                                             = $policy.EdgeBlocked
            EdgeCookiePolicy                                        = $policy.EdgeCookiePolicy
            EdgeBlockDeveloperTools                                 = $policy.EdgeBlockDeveloperTools
            EdgeBlockSendingDoNotTrackHeader                        = $policy.EdgeBlockSendingDoNotTrackHeader
            EdgeBlockExtensions                                     = $policy.EdgeBlockExtensions
            EdgeBlockInPrivateBrowsing                              = $policy.EdgeBlockInPrivateBrowsing
            EdgeBlockJavaScript                                     = $policy.EdgeBlockJavaScript
            EdgeBlockPasswordManager                                = $policy.EdgeBlockPasswordManager
            EdgeBlockAddressBarDropdown                             = $policy.EdgeBlockAddressBarDropdown
            EdgeBlockCompatibilityList                              = $policy.EdgeBlockCompatibilityList
            EdgeClearBrowsingDataOnExit                             = $policy.EdgeClearBrowsingDataOnExit
            EdgeAllowStartPagesModification                         = $policy.EdgeAllowStartPagesModification
            EdgeDisableFirstRunPage                                 = $policy.EdgeDisableFirstRunPage
            EdgeBlockLiveTileDataCollection                         = $policy.EdgeBlockLiveTileDataCollection
            EdgeSyncFavoritesWithInternetExplorer                   = $policy.EdgeSyncFavoritesWithInternetExplorer
            CellularBlockDataWhenRoaming                            = $policy.CellularBlockDataWhenRoaming
            CellularBlockVpn                                        = $policy.CellularBlockVpn
            CellularBlockVpnWhenRoaming                             = $policy.CellularBlockVpnWhenRoaming
            DefenderRequireRealTimeMonitoring                       = $policy.DefenderRequireRealTimeMonitoring
            DefenderRequireBehaviorMonitoring                       = $policy.DefenderRequireBehaviorMonitoring
            DefenderRequireNetworkInspectionSystem                  = $policy.DefenderRequireNetworkInspectionSystem
            DefenderScanDownloads                                   = $policy.DefenderScanDownloads
            DefenderScanScriptsLoadedInInternetExplorer             = $policy.DefenderScanScriptsLoadedInInternetExplorer
            DefenderBlockEndUserAccess                              = $policy.DefenderBlockEndUserAccess
            DefenderSignatureUpdateIntervalInHours                  = $policy.DefenderSignatureUpdateIntervalInHours
            DefenderMonitorFileActivity                             = $policy.DefenderMonitorFileActivity
            DefenderDaysBeforeDeletingQuarantinedMalware            = $policy.DefenderDaysBeforeDeletingQuarantinedMalware
            DefenderScanMaxCpu                                      = $policy.DefenderScanMaxCpu
            DefenderScanArchiveFiles                                = $policy.DefenderScanArchiveFiles
            DefenderScanIncomingMail                                = $policy.DefenderScanIncomingMail
            DefenderScanRemovableDrivesDuringFullScan               = $policy.DefenderScanRemovableDrivesDuringFullScan
            DefenderScanMappedNetworkDrivesDuringFullScan           = $policy.DefenderScanMappedNetworkDrivesDuringFullScan
            DefenderScanNetworkFiles                                = $policy.DefenderScanNetworkFiles
            DefenderRequireCloudProtection                          = $policy.DefenderRequireCloudProtection
            DefenderCloudBlockLevel                                 = $policy.DefenderCloudBlockLevel
            DefenderPromptForSampleSubmission                       = $policy.DefenderPromptForSampleSubmission
            DefenderScheduledQuickScanTime                          = $policy.DefenderScheduledQuickScanTime
            DefenderScanType                                        = $policy.DefenderScanType
            DefenderSystemScanSchedule                              = $policy.DefenderSystemScanSchedule
            DefenderScheduledScanTime                               = $policy.DefenderScheduledScanTime
            DefenderDetectedMalwareActions                          = $policy.DefenderDetectedMalwareActions
            DefenderFileExtensionsToExclude                         = $policy.DefenderFileExtensionsToExclude
            DefenderFilesAndFoldersToExclude                        = $policy.DefenderFilesAndFoldersToExclude
            DefenderProcessesToExclude                              = $policy.DefenderProcessesToExclude
            LockScreenAllowTimeoutConfiguration                     = $policy.LockScreenAllowTimeoutConfiguration
            LockScreenBlockActionCenterNotifications                = $policy.LockScreenBlockActionCenterNotifications
            LockScreenBlockCortana                                  = $policy.LockScreenBlockCortana
            LockScreenBlockToastNotifications                       = $policy.LockScreenBlockToastNotifications
            LockScreenTimeoutInSeconds                              = $policy.LockScreenTimeoutInSeconds
            PasswordBlockSimple                                     = $policy.PasswordBlockSimple
            PasswordExpirationDays                                  = $policy.PasswordExpirationDays
            PasswordMinimumLength                                   = $policy.PasswordMinimumLength
            PasswordMinutesOfInactivityBeforeScreenTimeout          = $policy.PasswordMinutesOfInactivityBeforeScreenTimeout
            PasswordMinimumCharacterSetCount                        = $policy.PasswordMinimumCharacterSetCount
            PasswordPreviousPasswordBlockCount                      = $policy.PasswordPreviousPasswordBlockCount
            PasswordRequired                                        = $policy.PasswordRequired
            PasswordRequireWhenResumeFromIdleState                  = $policy.PasswordRequireWhenResumeFromIdleState
            PasswordRequiredType                                    = $policy.PasswordRequiredType
            PasswordSignInFailureCountBeforeFactoryReset            = $policy.PasswordSignInFailureCountBeforeFactoryReset
            PrivacyAdvertisingId                                    = $policy.PrivacyAdvertisingId
            PrivacyAutoAcceptPairingAndConsentPrompts               = $policy.PrivacyAutoAcceptPairingAndConsentPrompts
            PrivacyBlockInputPersonalization                        = $policy.PrivacyBlockInputPersonalization
            StartBlockUnpinningAppsFromTaskbar                      = $policy.StartBlockUnpinningAppsFromTaskbar
            StartMenuAppListVisibility                              = $policy.StartMenuAppListVisibility
            StartMenuHideChangeAccountSettings                      = $policy.StartMenuHideChangeAccountSettings
            StartMenuHideFrequentlyUsedApps                         = $policy.StartMenuHideFrequentlyUsedApps
            StartMenuHideHibernate                                  = $policy.StartMenuHideHibernate
            StartMenuHideLock                                       = $policy.StartMenuHideLock
            StartMenuHidePowerButton                                = $policy.StartMenuHidePowerButton
            StartMenuHideRecentJumpLists                            = $policy.StartMenuHideRecentJumpLists
            StartMenuHideRecentlyAddedApps                          = $policy.StartMenuHideRecentlyAddedApps
            StartMenuHideRestartOptions                             = $policy.StartMenuHideRestartOptions
            StartMenuHideShutDown                                   = $policy.StartMenuHideShutDown
            StartMenuHideSignOut                                    = $policy.StartMenuHideSignOut
            StartMenuHideSleep                                      = $policy.StartMenuHideSleep
            StartMenuHideSwitchAccount                              = $policy.StartMenuHideSwitchAccount
            StartMenuHideUserTile                                   = $policy.StartMenuHideUserTile
            StartMenuLayoutEdgeAssetsXml                            = $policy.StartMenuLayoutEdgeAssetsXml
            StartMenuLayoutXml                                      = $policy.StartMenuLayoutXml
            StartMenuMode                                           = $policy.StartMenuMode
            StartMenuPinnedFolderDocuments                          = $policy.StartMenuPinnedFolderDocuments
            StartMenuPinnedFolderDownloads                          = $policy.StartMenuPinnedFolderDownloads
            StartMenuPinnedFolderFileExplorer                       = $policy.StartMenuPinnedFolderFileExplorer
            StartMenuPinnedFolderHomeGroup                          = $policy.StartMenuPinnedFolderHomeGroup
            StartMenuPinnedFolderMusic                              = $policy.StartMenuPinnedFolderMusic
            StartMenuPinnedFolderNetwork                            = $policy.StartMenuPinnedFolderNetwork
            StartMenuPinnedFolderPersonalFolder                     = $policy.StartMenuPinnedFolderPersonalFolder
            StartMenuPinnedFolderPictures                           = $policy.StartMenuPinnedFolderPictures
            StartMenuPinnedFolderSettings                           = $policy.StartMenuPinnedFolderSettings
            StartMenuPinnedFolderVideos                             = $policy.StartMenuPinnedFolderVideos
            SettingsBlockSettingsApp                                = $policy.SettingsBlockSettingsApp
            SettingsBlockSystemPage                                 = $policy.SettingsBlockSystemPage
            SettingsBlockDevicesPage                                = $policy.SettingsBlockDevicesPage
            SettingsBlockNetworkInternetPage                        = $policy.SettingsBlockNetworkInternetPage
            SettingsBlockPersonalizationPage                        = $policy.SettingsBlockPersonalizationPage
            SettingsBlockAccountsPage                               = $policy.SettingsBlockAccountsPage
            SettingsBlockTimeLanguagePage                           = $policy.SettingsBlockTimeLanguagePage
            SettingsBlockEaseOfAccessPage                           = $policy.SettingsBlockEaseOfAccessPage
            SettingsBlockPrivacyPage                                = $policy.SettingsBlockPrivacyPage
            SettingsBlockUpdateSecurityPage                         = $policy.SettingsBlockUpdateSecurityPage
            SettingsBlockAppsPage                                   = $policy.SettingsBlockAppsPage
            SettingsBlockGamingPage                                 = $policy.SettingsBlockGamingPage
            WindowsSpotlightBlockConsumerSpecificFeatures           = $policy.WindowsSpotlightBlockConsumerSpecificFeatures
            WindowsSpotlightBlocked                                 = $policy.WindowsSpotlightBlocked
            WindowsSpotlightBlockOnActionCenter                     = $policy.WindowsSpotlightBlockOnActionCenter
            WindowsSpotlightBlockTailoredExperiences                = $policy.WindowsSpotlightBlockTailoredExperiences
            WindowsSpotlightBlockThirdPartyNotifications            = $policy.WindowsSpotlightBlockThirdPartyNotifications
            WindowsSpotlightBlockWelcomeExperience                  = $policy.WindowsSpotlightBlockWelcomeExperience
            WindowsSpotlightBlockWindowsTips                        = $policy.WindowsSpotlightBlockWindowsTips
            WindowsSpotlightConfigureOnLockScreen                   = $policy.WindowsSpotlightConfigureOnLockScreen
            NetworkProxyApplySettingsDeviceWide                     = $policy.NetworkProxyApplySettingsDeviceWide
            NetworkProxyDisableAutoDetect                           = $policy.NetworkProxyDisableAutoDetect
            NetworkProxyAutomaticConfigurationUrl                   = $policy.NetworkProxyAutomaticConfigurationUrl
            NetworkProxyServer                                      = $policy.NetworkProxyServer
            AccountsBlockAddingNonMicrosoftAccountEmail             = $policy.AccountsBlockAddingNonMicrosoftAccountEmail
            AntiTheftModeBlocked                                    = $policy.AntiTheftModeBlocked
            BluetoothBlocked                                        = $policy.BluetoothBlocked
            CameraBlocked                                           = $policy.CameraBlocked
            ConnectedDevicesServiceBlocked                          = $policy.ConnectedDevicesServiceBlocked
            CertificatesBlockManualRootCertificateInstallation      = $policy.CertificatesBlockManualRootCertificateInstallation
            CopyPasteBlocked                                        = $policy.CopyPasteBlocked
            CortanaBlocked                                          = $policy.CortanaBlocked
            DeviceManagementBlockFactoryResetOnMobile               = $policy.DeviceManagementBlockFactoryResetOnMobile
            DeviceManagementBlockManualUnenroll                     = $policy.DeviceManagementBlockManualUnenroll
            SafeSearchFilter                                        = $policy.SafeSearchFilter
            EdgeBlockPopups                                         = $policy.EdgeBlockPopups
            EdgeBlockSearchSuggestions                              = $policy.EdgeBlockSearchSuggestions
            EdgeBlockSendingIntranetTrafficToInternetExplorer       = $policy.EdgeBlockSendingIntranetTrafficToInternetExplorer
            EdgeSendIntranetTrafficToInternetExplorer               = $policy.EdgeSendIntranetTrafficToInternetExplorer
            EdgeRequireSmartScreen                                  = $policy.EdgeRequireSmartScreen
            EdgeEnterpriseModeSiteListLocation                      = $policy.EdgeEnterpriseModeSiteListLocation
            EdgeFirstRunUrl                                         = $policy.EdgeFirstRunUrl
            EdgeSearchEngine                                        = $policy.EdgeSearchEngine
            EdgeHomepageUrls                                        = $policy.EdgeHomepageUrls
            EdgeBlockAccessToAboutFlags                             = $policy.EdgeBlockAccessToAboutFlags
            SmartScreenBlockPromptOverride                          = $policy.SmartScreenBlockPromptOverride
            SmartScreenBlockPromptOverrideForFiles                  = $policy.SmartScreenBlockPromptOverrideForFiles
            WebRtcBlockLocalhostIpAddress                           = $policy.WebRtcBlockLocalhostIpAddress
            InternetSharingBlocked                                  = $policy.InternetSharingBlocked
            SettingsBlockAddProvisioningPackage                     = $policy.SettingsBlockAddProvisioningPackage
            SettingsBlockRemoveProvisioningPackage                  = $policy.SettingsBlockRemoveProvisioningPackage
            SettingsBlockChangeSystemTime                           = $policy.SettingsBlockChangeSystemTime
            SettingsBlockEditDeviceName                             = $policy.SettingsBlockEditDeviceName
            SettingsBlockChangeRegion                               = $policy.SettingsBlockChangeRegion
            SettingsBlockChangeLanguage                             = $policy.SettingsBlockChangeLanguage
            SettingsBlockChangePowerSleep                           = $policy.SettingsBlockChangePowerSleep
            LocationServicesBlocked                                 = $policy.LocationServicesBlocked
            MicrosoftAccountBlocked                                 = $policy.MicrosoftAccountBlocked
            MicrosoftAccountBlockSettingsSync                       = $policy.MicrosoftAccountBlockSettingsSync
            NfcBlocked                                              = $policy.NfcBlocked
            ResetProtectionModeBlocked                              = $policy.ResetProtectionModeBlocked
            ScreenCaptureBlocked                                    = $policy.ScreenCaptureBlocked
            StorageBlockRemovableStorage                            = $policy.StorageBlockRemovableStorage
            StorageRequireMobileDeviceEncryption                    = $policy.StorageRequireMobileDeviceEncryption
            UsbBlocked                                              = $policy.UsbBlocked
            VoiceRecordingBlocked                                   = $policy.VoiceRecordingBlocked
            WiFiBlockAutomaticConnectHotspots                       = $policy.WiFiBlockAutomaticConnectHotspots
            WiFiBlocked                                             = $policy.WiFiBlocked
            WiFiBlockManualConfiguration                            = $policy.WiFiBlockManualConfiguration
            WiFiScanInterval                                        = $policy.WiFiScanInterval
            WirelessDisplayBlockProjectionToThisDevice              = $policy.WirelessDisplayBlockProjectionToThisDevice
            WirelessDisplayBlockUserInputFromReceiver               = $policy.WirelessDisplayBlockUserInputFromReceiver
            WirelessDisplayRequirePinForPairing                     = $policy.WirelessDisplayRequirePinForPairing
            WindowsStoreBlocked                                     = $policy.WindowsStoreBlocked
            AppsAllowTrustedAppsSideloading                         = $policy.AppsAllowTrustedAppsSideloading
            WindowsStoreBlockAutoUpdate                             = $policy.WindowsStoreBlockAutoUpdate
            DeveloperUnlockSetting                                  = $policy.DeveloperUnlockSetting
            SharedUserAppDataAllowed                                = $policy.SharedUserAppDataAllowed
            AppsBlockWindowsStoreOriginatedApps                     = $policy.AppsBlockWindowsStoreOriginatedApps
            WindowsStoreEnablePrivateStoreOnly                      = $policy.WindowsStoreEnablePrivateStoreOnly
            StorageRestrictAppDataToSystemVolume                    = $policy.StorageRestrictAppDataToSystemVolume
            StorageRestrictAppInstallToSystemVolume                 = $policy.StorageRestrictAppInstallToSystemVolume
            GameDvrBlocked                                          = $policy.GameDvrBlocked
            ExperienceBlockDeviceDiscovery                          = $policy.ExperienceBlockDeviceDiscovery
            ExperienceBlockErrorDialogWhenNoSIM                     = $policy.ExperienceBlockErrorDialogWhenNoSIM
            ExperienceBlockTaskSwitcher                             = $policy.ExperienceBlockTaskSwitcher
            LogonBlockFastUserSwitching                             = $policy.LogonBlockFastUserSwitching
            TenantLockdownRequireNetworkDuringOutOfBoxExperience    = $policy.TenantLockdownRequireNetworkDuringOutOfBoxExperience
            Ensure                                                  = "Present"
            GlobalAdminAccount                                      = $GlobalAdminAccount
            ApplicationId                                           = $ApplicationId
            TenantId                                                = $TenantId
            ApplicationSecret                                       = $ApplicationSecret
        }
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
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
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $ApplicationSecret
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'Intune' `
        -InboundParameters $PSBoundParameters

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    $data.Add("ConnectionMode", $ConnectionMode)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentPolicy = Get-TargetResource @PSBoundParameters
    $setParams = $PSBoundParameters
    $setParams.Remove("Ensure") | Out-Null
    $setParams.Remove("GlobalAdminAccount") | Out-Null
    $setParams.Remove("ApplicationId") | Out-Null
    $setParams.Remove("TenantId") | Out-Null
    $setParams.Remove("ApplicationSecret") | Out-Null
    if ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Device Configuration Policy {$DisplayName}"
        New-M365DSCIntuneDeviceConfigurationPolicyWindows -Parameters $setParams
    }
    elseif ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating existing Device Configuration Policy {$DisplayName}"
        $policy = Get-IntuneDeviceConfigurationPolicy -Filter "displayName eq '$DisplayName'"
        Set-M365DSCIntuneDeviceConfigurationPolicyWindows -Parameters $setParams -PolicyId ($policy.Id)
    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Device Configuration Policy {$DisplayName}"
        $policy = Get-IntuneDeviceConfigurationPolicy -Filter "displayName eq '$DisplayName'"
        Remove-IntuneDeviceConfigurationPolicy -deviceConfigurationId $policy.Id
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
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $ApplicationSecret
    )

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    Write-Verbose -Message "Testing configuration of Device Configuration Policy {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null
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
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $ApplicationSecret
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'Intune' `
        -InboundParameters $PSBoundParameters

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    $data.Add("ConnectionMode", $ConnectionMode)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        [array]$policies = Get-IntuneDeviceConfigurationPolicy -ErrorAction Stop | Where-Object -FilterScript { $_.'@odata.type' -eq '#microsoft.graph.Windows10GeneralConfiguration' }
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
                DisplayName        = $policy.DisplayName
                Ensure             = 'Present'
                GlobalAdminAccount = $GlobalAdminAccount
                ApplicationId      = $ApplicationId
                TenantId           = $TenantId
                ApplicationSecret  = $ApplicationSecret
            }
            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -GlobalAdminAccount $GlobalAdminAccount
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
        Write-Host $_
        if ($_.Exception -like '*401*')
        {
            Write-Host "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered for Intune."
        }
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]

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

function Get-M365DSCIntuneDeviceConfigurationPolicyWindows
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory = $True)]
        [System.String]
        $PolicyId
    )
    try
    {
        $Url = "https://graph.microsoft.com/v1.0/deviceManagement/deviceConfigurations/$($policyInfo.id)"
        $response = Invoke-MSGraphRequest -HttpMethod Get `
            -Url $Url
        return $response
    }
    catch
    {
        Write-Verbose -Message $_
        $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $tenantIdValue
    }
    return $null
}

function New-M365DSCIntuneDeviceConfigurationPolicyWindows
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True)]
        [System.Collections.Hashtable]
        $Parameters
    )
    try
    {
        if ($Parameters.ContainsKey("Verbose"))
        {
            $Parameters.Remove("Verbose") | Out-Null
        }
        # replace the first letter of each key by a lower case;
        $jsonString = "{`r`n`"@odata.type`":`"#microsoft.graph.Windows10GeneralConfiguration`",`r`n"
        foreach ($key in $Parameters.Keys)
        {
            $length = $key.Length
            $fixedKeyName = $key[0].ToString().ToLower() + $key.Substring(1, $length - 1)
            $jsonString += "`"$fixedKeyName`": "
            if ($key -like 'defenderDetectedMalwareActions')
            {
                $jsonString += "{`r`n"
                $jsonString += "`"@odata.type`": `"#microsoft.graph.defenderDetectedMalwareActions`",`r`n"

                foreach($action in $Parameters.defenderDetectedMalwareActions)
                {
                    $jsonString +=  "`"$($action.split('=')[0])" + "`" : `"" + "$($action.split('=')[1])" + "`",`r`n"
                }
                $jsonString = $jsonString.TrimEnd(",`r`n")
                $jsonString += "`r`n},`r`n"
            }
            elseif($key -like 'networkProxyServer')
            {
                $jsonString += "{`r`n"
                $jsonString += "`"@odata.type`": `"microsoft.graph.windows10NetworkProxyServer`",`r`n"
                foreach($entry in $Parameters.networkProxyServer)
                {
                    if($entry -like 'exceptions*'){
                        $jsonString +=  "`"$($entry.split('=')[0])" + "`" : [`r`n`"" + "$($entry.split('=')[1])" + "`",`r`n"
                        $jsonString += "],`r`n"
                    }
                    else
                    {
                        $jsonString +=  "`"$($entry.split('=')[0])" + "`" : `"" + "$($entry.split('=')[1])" + "`",`r`n"
                    }
                }
                $jsonString = $jsonString.TrimEnd(",`r`n")
                $jsonString += "`r`n},`r`n"
            }
            elseif ($key -like 'edgeSearchEngine')
            {
                $jsonString += "{`r`n"
                if( $Parameters.edgeSearchEngine -like 'bing')
                {
                    $jsonString += "`"@odata.type`": `"#microsoft.graph.edgeSearchEngine`",`r`n"
                    $jsonString +=  "`"edgeSearchEngineType" + "`" : `"" + "$($Parameters.edgeSearchEngine)" + "`",`r`n"
                }
                else
                {
                    $jsonString += "`"@odata.type`": `"#microsoft.graph.edgeSearchEngineCustom`",`r`n"
                    $jsonString +=  "`"edgeSearchEngineOpenSearchXmlUrl" + "`" : `"" + "$($Parameters.edgeSearchEngine)" + "`",`r`n"
                }
                $jsonString = $jsonString.TrimEnd(",`r`n")
                $jsonString += "`r`n},`r`n"
            }
            elseif ($Parameters.$key.GetType().Name -eq "String")
            {
                $jsonString += "`"$($Parameters.$key)`",`r`n"
            }
            elseif ($Parameters.$key.GetType().Name -eq "Boolean")
            {
                $jsonString += "$(($Parameters.$key).ToString().ToLower()),`r`n"
            }
            else
            {
                $jsonString += "$($Parameters.$key),`r`n"
            }
        }
        $jsonString = $jsonString.TrimEnd(",`r`n")
        $jsonString += "`r`n}"

        $Url = 'https://graph.microsoft.com/v1.0/deviceManagement/deviceConfigurations/'
        Write-Verbose -Message "Creating new Device config policy with JSON payload: `r`n$jsonString"
        Invoke-MSGraphRequest -HttpMethod POST `
            -Url $Url `
            -Content $jsonString `
            -Headers @{"Content-Type" = "application/json" } | Out-Null
    }
    catch
    {
        Write-Verbose -Message $_
        $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $tenantIdValue
    }
}

function Set-M365DSCIntuneDeviceConfigurationPolicyWindows
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True)]
        [System.Collections.Hashtable]
        $Parameters,

        [Parameter(Mandatory = $True)]
        [System.String]
        $PolicyId
    )
    try
    {
        if ($Parameters.ContainsKey("Verbose"))
        {
            $Parameters.Remove("Verbose") | Out-Null
        }
        # replace the first letter of each key by a lower case;
        $jsonString = "{`r`n`"@odata.type`":`"#microsoft.graph.windows10GeneralConfiguration`",`r`n"
        foreach ($key in $Parameters.Keys)
        {
            $length = $key.Length
            $fixedKeyName = $key[0].ToString().ToLower() + $key.Substring(1, $length - 1)
            $jsonString += "`"$fixedKeyName`": "
            if ($key -like 'defenderDetectedMalwareActions')
            {
                $jsonString += "{`r`n"
                $jsonString += "`"@odata.type`": `"microsoft.graph.defenderDetectedMalwareActions`",`r`n"

                foreach($action in $Parameters.defenderDetectedMalwareActions)
                {
                  $jsonString +=  "`"$($action.split('=')[0])" + "`" : `"" + "$($action.split('=')[1])" + "`",`r`n"
                }
                $jsonString = $jsonString.TrimEnd(",`r`n")
                $jsonString += "`r`n},`r`n"
             }
             elseif($key -like 'networkProxyServer')
             {
                $jsonString += "{`r`n"
                $jsonString += "`"@odata.type`": `"microsoft.graph.windows10NetworkProxyServer`",`r`n"
                foreach($entry in $Parameters.networkProxyServer)
                {
                    if($entry -like 'exceptions*')
                    {
                        $jsonString +=  "`"$($entry.split('=')[0])" + "`" : [`r`n`"" + "$($entry.split('=')[1])" + "`",`r`n"
                        $jsonString += "],`r`n"
                    }
                    else
                    {
                    $jsonString +=  "`"$($entry.split('=')[0])" + "`" : `"" + "$($entry.split('=')[1])" + "`",`r`n"
                    }
                }
                $jsonString = $jsonString.TrimEnd(",`r`n")
                $jsonString += "`r`n},`r`n"
            }
            elseif($key -like 'edgeSearchEngine')
            {
                $jsonString += "{`r`n"
                if( $Parameters.edgeSearchEngine -like 'bing')
                {
                    $jsonString += "`"@odata.type`": `"#microsoft.graph.edgeSearchEngine`",`r`n"
                    $jsonString +=  "`"edgeSearchEngineType" + "`" : `"" + "$($Parameters.edgeSearchEngine)" + "`",`r`n"
                }
                else
                {
                    $jsonString += "`"@odata.type`": `"#microsoft.graph.edgeSearchEngineCustom`",`r`n"
                    $jsonString +=  "`"edgeSearchEngineOpenSearchXmlUrl" + "`" : `"" + "$($Parameters.edgeSearchEngine)" + "`",`r`n"
                }
                $jsonString = $jsonString.TrimEnd(",`r`n")
                $jsonString += "`r`n},`r`n"
            }
            elseif($Parameters.$key.GetType().Name -eq "String")
            {
                $jsonString += "`"$($Parameters.$key)`",`r`n"
            }
            elseif ($Parameters.$key.GetType().Name -eq "Boolean")
            {
                $jsonString += "$(($Parameters.$key).ToString().ToLower()),`r`n"
            }
            else
            {
                $jsonString += "$($Parameters.$key),`r`n"
            }
        }
        if($PolicyId)
        {
            $jsonString = $jsonString.TrimEnd(",`r`n")
            $jsonString += "`r`n}"
            $Url = "https://graph.microsoft.com/v1.0/deviceManagement/deviceConfigurations/$PolicyId"
        }
        Write-Verbose -Message "Updating Device config policy with JSON payload: `r`n$jsonString"
        Invoke-MSGraphRequest -HttpMethod PATCH `
            -Url $Url `
            -Content $jsonString `
            -Headers @{"Content-Type" = "application/json" } | Out-Null
    }
    catch
    {
        Write-Verbose -Message $_
        $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $tenantIdValue
    }
}

Export-ModuleMember -Function *-TargetResource
