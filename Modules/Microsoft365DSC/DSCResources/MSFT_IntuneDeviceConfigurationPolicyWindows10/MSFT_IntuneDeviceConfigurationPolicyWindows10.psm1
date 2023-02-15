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
        [ValidateSet('userDefined', 'none', 'basic', 'enhanced', 'full')]
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
        [ValidateSet('userDefined', 'allow', 'blockThirdparty', 'blockAll')]
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
        [ValidateSet('userDefined', 'disable', 'monitorAllFiles', 'monitorIncomingFilesOnly', 'monitorOutgoingFilesOnly')]
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
        [ValidateSet('notConfigured', 'high', 'highPlus', 'zeroTolerance')]
        [System.String]
        $DefenderCloudBlockLevel,

        [Parameter()]
        [ValidateSet('userDefined', 'alwaysPrompt', 'promptBeforeSendingPersonalData', 'neverSendData', 'sendAllDataWithoutPrompting')]
        [System.String]
        $DefenderPromptForSampleSubmission,

        [Parameter()]
        [System.String]
        $DefenderScheduledQuickScanTime,

        [Parameter()]
        [ValidateSet('userDefined', 'disabled', 'quick', 'full')]
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
        [Microsoft.Management.Infrastructure.CimInstance]
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
        [ValidateSet('deviceDefault', 'alphanumeric', 'numeric')]
        [System.String]
        $PasswordRequiredType,

        [Parameter()]
        [System.Uint64]
        $PasswordSignInFailureCountBeforeFactoryReset,

        [Parameter()]
        [ValidateSet('notConfigured', 'blocked', 'allowed')]
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
        [ValidateSet('notConfigured', 'disabled', 'enabled')]
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
        [ValidateSet('userDefined', 'strict', 'moderate')]
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
        [ValidateSet('notConfigured', 'blocked', 'allowed')]
        $AppsAllowTrustedAppsSideloading,

        [Parameter()]
        [System.Boolean]
        $WindowsStoreBlockAutoUpdate,

        [Parameter()]
        [ValidateSet('notConfigured', 'blocked', 'allowed')]
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

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter(Mandatory = $True)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure = $true,

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
        $policy = Get-MgBetaDeviceManagementDeviceConfiguration -Filter "displayName eq '$DisplayName'" `
            -ErrorAction Stop | Where-Object -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.windows10GeneralConfiguration' }

        if ($null -eq $policy)
        {
            Write-Verbose -Message "No Device Configuration Policy {$DisplayName} was found"
            return $nullResult
        }

        $DefenderDetectedMalwareActionsValues = $null
        if (-not [System.String]::IsNullOrEmpty($policy.AdditionalProperties.defenderDetectedMalwareActions.lowSeverity) -or
            -not [System.String]::IsNullOrEmpty($policy.AdditionalProperties.defenderDetectedMalwareActions.moderateSeverity) -or
            -not [System.String]::IsNullOrEmpty($policy.AdditionalProperties.defenderDetectedMalwareActions.highSeverity) -or
            -not [System.String]::IsNullOrEmpty($policy.AdditionalProperties.defenderDetectedMalwareActions.severeSeverity))
        {
            $DefenderDetectedMalwareActionsValues = @{
                LowSeverity      = $policy.AdditionalProperties.defenderDetectedMalwareActions.lowSeverity
                ModerateSeverity = $policy.AdditionalProperties.defenderDetectedMalwareActions.moderateSeverity
                HighSeverity     = $policy.AdditionalProperties.defenderDetectedMalwareActions.highSeverity
                SevereSeverity   = $policy.AdditionalProperties.defenderDetectedMalwareActions.severeSeverity
            }
        }

        Write-Verbose -Message "Found Device Configuration Policy {$DisplayName}"
        $results = @{
            Description                                           = $policy.Description
            DisplayName                                           = $policy.DisplayName
            EnterpriseCloudPrintDiscoveryEndPoint                 = $policy.AdditionalProperties.enterpriseCloudPrintDiscoveryEndPoint
            EnterpriseCloudPrintOAuthAuthority                    = $policy.AdditionalProperties.enterpriseCloudPrintOAuthAuthority
            EnterpriseCloudPrintOAuthClientIdentifier             = $policy.AdditionalProperties.enterpriseCloudPrintOAuthClientIdentifier
            EnterpriseCloudPrintResourceIdentifier                = $policy.AdditionalProperties.enterpriseCloudPrintResourceIdentifier
            EnterpriseCloudPrintDiscoveryMaxLimit                 = $policy.AdditionalProperties.enterpriseCloudPrintDiscoveryMaxLimit
            EnterpriseCloudPrintMopriaDiscoveryResourceIdentifier = $policy.AdditionalProperties.enterpriseCloudPrintMopriaDiscoveryResourceIdentifier
            SearchBlockDiacritics                                 = $policy.AdditionalProperties.searchBlockDiacritics
            SearchDisableAutoLanguageDetection                    = $policy.AdditionalProperties.searchDisableAutoLanguageDetection
            SearchDisableIndexingEncryptedItems                   = $policy.AdditionalProperties.searchDisableIndexingEncryptedItems
            SearchEnableRemoteQueries                             = $policy.AdditionalProperties.searchEnableRemoteQueries
            SearchDisableIndexerBackoff                           = $policy.AdditionalProperties.searchDisableIndexerBackoff
            SearchDisableIndexingRemovableDrive                   = $policy.AdditionalProperties.searchDisableIndexingRemovableDrive
            SearchEnableAutomaticIndexSizeManangement             = $policy.AdditionalProperties.searchEnableAutomaticIndexSizeManangement
            DiagnosticsDataSubmissionMode                         = $policy.AdditionalProperties.diagnosticsDataSubmissionMode
            OneDriveDisableFileSync                               = $policy.AdditionalProperties.oneDriveDisableFileSync
            SmartScreenEnableAppInstallControl                    = $policy.AdditionalProperties.smartScreenEnableAppInstallControl
            PersonalizationDesktopImageUrl                        = $policy.AdditionalProperties.personalizationDesktopImageUrl
            PersonalizationLockScreenImageUrl                     = $policy.AdditionalProperties.personalizationLockScreenImageUrl
            BluetoothAllowedServices                              = $policy.AdditionalProperties.bluetoothAllowedServices
            BluetoothBlockAdvertising                             = $policy.AdditionalProperties.bluetoothBlockAdvertising
            BluetoothBlockDiscoverableMode                        = $policy.AdditionalProperties.bluetoothBlockDiscoverableMode
            BluetoothBlockPrePairing                              = $policy.AdditionalProperties.bluetoothBlockPrePairing
            EdgeBlockAutofill                                     = $policy.AdditionalProperties.edgeBlockAutofill
            EdgeBlocked                                           = $policy.AdditionalProperties.edgeBlocked
            EdgeCookiePolicy                                      = $policy.AdditionalProperties.edgeCookiePolicy
            EdgeBlockDeveloperTools                               = $policy.AdditionalProperties.edgeBlockDeveloperTools
            EdgeBlockSendingDoNotTrackHeader                      = $policy.AdditionalProperties.edgeBlockSendingDoNotTrackHeader
            EdgeBlockExtensions                                   = $policy.AdditionalProperties.edgeBlockExtensions
            EdgeBlockInPrivateBrowsing                            = $policy.AdditionalProperties.edgeBlockInPrivateBrowsing
            EdgeBlockJavaScript                                   = $policy.AdditionalProperties.edgeBlockJavaScript
            EdgeBlockPasswordManager                              = $policy.AdditionalProperties.edgeBlockPasswordManager
            EdgeBlockAddressBarDropdown                           = $policy.AdditionalProperties.edgeBlockAddressBarDropdown
            EdgeBlockCompatibilityList                            = $policy.AdditionalProperties.edgeBlockCompatibilityList
            EdgeClearBrowsingDataOnExit                           = $policy.AdditionalProperties.edgeClearBrowsingDataOnExit
            EdgeAllowStartPagesModification                       = $policy.AdditionalProperties.edgeAllowStartPagesModification
            EdgeDisableFirstRunPage                               = $policy.AdditionalProperties.edgeDisableFirstRunPage
            EdgeBlockLiveTileDataCollection                       = $policy.AdditionalProperties.edgeBlockLiveTileDataCollection
            EdgeSyncFavoritesWithInternetExplorer                 = $policy.AdditionalProperties.edgeSyncFavoritesWithInternetExplorer
            CellularBlockDataWhenRoaming                          = $policy.AdditionalProperties.cellularBlockDataWhenRoaming
            CellularBlockVpn                                      = $policy.AdditionalProperties.cellularBlockVpn
            CellularBlockVpnWhenRoaming                           = $policy.AdditionalProperties.cellularBlockVpnWhenRoaming
            DefenderRequireRealTimeMonitoring                     = $policy.AdditionalProperties.defenderRequireRealTimeMonitoring
            DefenderRequireBehaviorMonitoring                     = $policy.AdditionalProperties.defenderRequireBehaviorMonitoring
            DefenderRequireNetworkInspectionSystem                = $policy.AdditionalProperties.defenderRequireNetworkInspectionSystem
            DefenderScanDownloads                                 = $policy.AdditionalProperties.defenderScanDownloads
            DefenderScanScriptsLoadedInInternetExplorer           = $policy.AdditionalProperties.defenderScanScriptsLoadedInInternetExplorer
            DefenderBlockEndUserAccess                            = $policy.AdditionalProperties.defenderBlockEndUserAccess
            DefenderSignatureUpdateIntervalInHours                = $policy.AdditionalProperties.defenderSignatureUpdateIntervalInHours
            DefenderMonitorFileActivity                           = $policy.AdditionalProperties.defenderMonitorFileActivity
            DefenderDaysBeforeDeletingQuarantinedMalware          = $policy.AdditionalProperties.defenderDaysBeforeDeletingQuarantinedMalware
            DefenderScanMaxCpu                                    = $policy.AdditionalProperties.defenderScanMaxCpu
            DefenderScanArchiveFiles                              = $policy.AdditionalProperties.defenderScanArchiveFiles
            DefenderScanIncomingMail                              = $policy.AdditionalProperties.defenderScanIncomingMail
            DefenderScanRemovableDrivesDuringFullScan             = $policy.AdditionalProperties.defenderScanRemovableDrivesDuringFullScan
            DefenderScanMappedNetworkDrivesDuringFullScan         = $policy.AdditionalProperties.defenderScanMappedNetworkDrivesDuringFullScan
            DefenderScanNetworkFiles                              = $policy.AdditionalProperties.defenderScanNetworkFiles
            DefenderRequireCloudProtection                        = $policy.AdditionalProperties.defenderRequireCloudProtection
            DefenderCloudBlockLevel                               = $policy.AdditionalProperties.defenderCloudBlockLevel
            DefenderPromptForSampleSubmission                     = $policy.AdditionalProperties.defenderPromptForSampleSubmission
            DefenderScheduledQuickScanTime                        = $policy.AdditionalProperties.defenderScheduledQuickScanTime
            DefenderScanType                                      = $policy.AdditionalProperties.defenderScanType
            DefenderSystemScanSchedule                            = $policy.AdditionalProperties.defenderSystemScanSchedule
            DefenderScheduledScanTime                             = $policy.AdditionalProperties.defenderScheduledScanTime
            DefenderDetectedMalwareActions                        = $DefenderDetectedMalwareActionsValues
            DefenderFileExtensionsToExclude                       = $policy.AdditionalProperties.defenderFileExtensionsToExclude
            DefenderFilesAndFoldersToExclude                      = $policy.AdditionalProperties.defenderFilesAndFoldersToExclude
            DefenderProcessesToExclude                            = $policy.AdditionalProperties.defenderProcessesToExclude
            LockScreenAllowTimeoutConfiguration                   = $policy.AdditionalProperties.lockScreenAllowTimeoutConfiguration
            LockScreenBlockActionCenterNotifications              = $policy.AdditionalProperties.lockScreenBlockActionCenterNotifications
            LockScreenBlockCortana                                = $policy.AdditionalProperties.lockScreenBlockCortana
            LockScreenBlockToastNotifications                     = $policy.AdditionalProperties.lockScreenBlockToastNotifications
            LockScreenTimeoutInSeconds                            = $policy.AdditionalProperties.lockScreenTimeoutInSeconds
            PasswordBlockSimple                                   = $policy.AdditionalProperties.passwordBlockSimple
            PasswordExpirationDays                                = $policy.AdditionalProperties.passwordExpirationDays
            PasswordMinimumLength                                 = $policy.AdditionalProperties.passwordMinimumLength
            PasswordMinutesOfInactivityBeforeScreenTimeout        = $policy.AdditionalProperties.passwordMinutesOfInactivityBeforeScreenTimeout
            PasswordMinimumCharacterSetCount                      = $policy.AdditionalProperties.passwordMinimumCharacterSetCount
            PasswordPreviousPasswordBlockCount                    = $policy.AdditionalProperties.passwordPreviousPasswordBlockCount
            PasswordRequired                                      = $policy.AdditionalProperties.passwordRequired
            PasswordRequireWhenResumeFromIdleState                = $policy.AdditionalProperties.passwordRequireWhenResumeFromIdleState
            PasswordRequiredType                                  = $policy.AdditionalProperties.passwordRequiredType
            PasswordSignInFailureCountBeforeFactoryReset          = $policy.AdditionalProperties.passwordSignInFailureCountBeforeFactoryReset
            PrivacyAdvertisingId                                  = $policy.AdditionalProperties.privacyAdvertisingId
            PrivacyAutoAcceptPairingAndConsentPrompts             = $policy.AdditionalProperties.privacyAutoAcceptPairingAndConsentPrompts
            PrivacyBlockInputPersonalization                      = $policy.AdditionalProperties.privacyBlockInputPersonalization
            StartBlockUnpinningAppsFromTaskbar                    = $policy.AdditionalProperties.startBlockUnpinningAppsFromTaskbar
            StartMenuAppListVisibility                            = $policy.AdditionalProperties.startMenuAppListVisibility
            StartMenuHideChangeAccountSettings                    = $policy.AdditionalProperties.startMenuHideChangeAccountSettings
            StartMenuHideFrequentlyUsedApps                       = $policy.AdditionalProperties.startMenuHideFrequentlyUsedApps
            StartMenuHideHibernate                                = $policy.AdditionalProperties.startMenuHideHibernate
            StartMenuHideLock                                     = $policy.AdditionalProperties.startMenuHideLock
            StartMenuHidePowerButton                              = $policy.AdditionalProperties.startMenuHidePowerButton
            StartMenuHideRecentJumpLists                          = $policy.AdditionalProperties.startMenuHideRecentJumpLists
            StartMenuHideRecentlyAddedApps                        = $policy.AdditionalProperties.startMenuHideRecentlyAddedApps
            StartMenuHideRestartOptions                           = $policy.AdditionalProperties.startMenuHideRestartOptions
            StartMenuHideShutDown                                 = $policy.AdditionalProperties.startMenuHideShutDown
            StartMenuHideSignOut                                  = $policy.AdditionalProperties.startMenuHideSignOut
            StartMenuHideSleep                                    = $policy.AdditionalProperties.startMenuHideSleep
            StartMenuHideSwitchAccount                            = $policy.AdditionalProperties.startMenuHideSwitchAccount
            StartMenuHideUserTile                                 = $policy.AdditionalProperties.startMenuHideUserTile
            StartMenuLayoutEdgeAssetsXml                          = $policy.AdditionalProperties.startMenuLayoutEdgeAssetsXml
            StartMenuLayoutXml                                    = $policy.AdditionalProperties.startMenuLayoutXml
            StartMenuMode                                         = $policy.AdditionalProperties.startMenuMode
            StartMenuPinnedFolderDocuments                        = $policy.AdditionalProperties.startMenuPinnedFolderDocuments
            StartMenuPinnedFolderDownloads                        = $policy.AdditionalProperties.startMenuPinnedFolderDownloads
            StartMenuPinnedFolderFileExplorer                     = $policy.AdditionalProperties.startMenuPinnedFolderFileExplorer
            StartMenuPinnedFolderHomeGroup                        = $policy.AdditionalProperties.startMenuPinnedFolderHomeGroup
            StartMenuPinnedFolderMusic                            = $policy.AdditionalProperties.startMenuPinnedFolderMusic
            StartMenuPinnedFolderNetwork                          = $policy.AdditionalProperties.startMenuPinnedFolderNetwork
            StartMenuPinnedFolderPersonalFolder                   = $policy.AdditionalProperties.startMenuPinnedFolderPersonalFolder
            StartMenuPinnedFolderPictures                         = $policy.AdditionalProperties.startMenuPinnedFolderPictures
            StartMenuPinnedFolderSettings                         = $policy.AdditionalProperties.startMenuPinnedFolderSettings
            StartMenuPinnedFolderVideos                           = $policy.AdditionalProperties.startMenuPinnedFolderVideos
            SettingsBlockSettingsApp                              = $policy.AdditionalProperties.settingsBlockSettingsApp
            SettingsBlockSystemPage                               = $policy.AdditionalProperties.settingsBlockSystemPage
            SettingsBlockDevicesPage                              = $policy.AdditionalProperties.settingsBlockDevicesPage
            SettingsBlockNetworkInternetPage                      = $policy.AdditionalProperties.settingsBlockNetworkInternetPage
            SettingsBlockPersonalizationPage                      = $policy.AdditionalProperties.settingsBlockPersonalizationPage
            SettingsBlockAccountsPage                             = $policy.AdditionalProperties.settingsBlockAccountsPage
            SettingsBlockTimeLanguagePage                         = $policy.AdditionalProperties.settingsBlockTimeLanguagePage
            SettingsBlockEaseOfAccessPage                         = $policy.AdditionalProperties.settingsBlockEaseOfAccessPage
            SettingsBlockPrivacyPage                              = $policy.AdditionalProperties.settingsBlockPrivacyPage
            SettingsBlockUpdateSecurityPage                       = $policy.AdditionalProperties.settingsBlockUpdateSecurityPage
            SettingsBlockAppsPage                                 = $policy.AdditionalProperties.settingsBlockAppsPage
            SettingsBlockGamingPage                               = $policy.AdditionalProperties.settingsBlockGamingPage
            WindowsSpotlightBlockConsumerSpecificFeatures         = $policy.AdditionalProperties.windowsSpotlightBlockConsumerSpecificFeatures
            WindowsSpotlightBlocked                               = $policy.AdditionalProperties.windowsSpotlightBlocked
            WindowsSpotlightBlockOnActionCenter                   = $policy.AdditionalProperties.windowsSpotlightBlockOnActionCenter
            WindowsSpotlightBlockTailoredExperiences              = $policy.AdditionalProperties.windowsSpotlightBlockTailoredExperiences
            WindowsSpotlightBlockThirdPartyNotifications          = $policy.AdditionalProperties.windowsSpotlightBlockThirdPartyNotifications
            WindowsSpotlightBlockWelcomeExperience                = $policy.AdditionalProperties.windowsSpotlightBlockWelcomeExperience
            WindowsSpotlightBlockWindowsTips                      = $policy.AdditionalProperties.windowsSpotlightBlockWindowsTips
            WindowsSpotlightConfigureOnLockScreen                 = $policy.AdditionalProperties.windowsSpotlightConfigureOnLockScreen
            NetworkProxyApplySettingsDeviceWide                   = $policy.AdditionalProperties.networkProxyApplySettingsDeviceWide
            NetworkProxyDisableAutoDetect                         = $policy.AdditionalProperties.networkProxyDisableAutoDetect
            NetworkProxyAutomaticConfigurationUrl                 = $policy.AdditionalProperties.networkProxyAutomaticConfigurationUrl
            NetworkProxyServer                                    = $policy.AdditionalProperties.networkProxyServer
            AccountsBlockAddingNonMicrosoftAccountEmail           = $policy.AdditionalProperties.accountsBlockAddingNonMicrosoftAccountEmail
            AntiTheftModeBlocked                                  = $policy.AdditionalProperties.antiTheftModeBlocked
            BluetoothBlocked                                      = $policy.AdditionalProperties.bluetoothBlocked
            CameraBlocked                                         = $policy.AdditionalProperties.cameraBlocked
            ConnectedDevicesServiceBlocked                        = $policy.AdditionalProperties.connectedDevicesServiceBlocked
            CertificatesBlockManualRootCertificateInstallation    = $policy.AdditionalProperties.certificatesBlockManualRootCertificateInstallation
            CopyPasteBlocked                                      = $policy.AdditionalProperties.copyPasteBlocked
            CortanaBlocked                                        = $policy.AdditionalProperties.cortanaBlocked
            DeviceManagementBlockFactoryResetOnMobile             = $policy.AdditionalProperties.deviceManagementBlockFactoryResetOnMobile
            DeviceManagementBlockManualUnenroll                   = $policy.AdditionalProperties.deviceManagementBlockManualUnenroll
            SafeSearchFilter                                      = $policy.AdditionalProperties.safeSearchFilter
            EdgeBlockPopups                                       = $policy.AdditionalProperties.edgeBlockPopups
            EdgeBlockSearchSuggestions                            = $policy.AdditionalProperties.edgeBlockSearchSuggestions
            EdgeBlockSendingIntranetTrafficToInternetExplorer     = $policy.AdditionalProperties.edgeBlockSendingIntranetTrafficToInternetExplorer
            EdgeSendIntranetTrafficToInternetExplorer             = $policy.AdditionalProperties.edgeSendIntranetTrafficToInternetExplorer
            EdgeRequireSmartScreen                                = $policy.AdditionalProperties.edgeRequireSmartScreen
            EdgeEnterpriseModeSiteListLocation                    = $policy.AdditionalProperties.edgeEnterpriseModeSiteListLocation
            EdgeFirstRunUrl                                       = $policy.AdditionalProperties.edgeFirstRunUrl
            EdgeSearchEngine                                      = $policy.AdditionalProperties.edgeSearchEngine.edgeSearchEngineType
            EdgeHomepageUrls                                      = $policy.AdditionalProperties.edgeHomepageUrls
            EdgeBlockAccessToAboutFlags                           = $policy.AdditionalProperties.edgeBlockAccessToAboutFlags
            SmartScreenBlockPromptOverride                        = $policy.AdditionalProperties.smartScreenBlockPromptOverride
            SmartScreenBlockPromptOverrideForFiles                = $policy.AdditionalProperties.smartScreenBlockPromptOverrideForFiles
            WebRtcBlockLocalhostIpAddress                         = $policy.AdditionalProperties.webRtcBlockLocalhostIpAddress
            InternetSharingBlocked                                = $policy.AdditionalProperties.internetSharingBlocked
            SettingsBlockAddProvisioningPackage                   = $policy.AdditionalProperties.settingsBlockAddProvisioningPackage
            SettingsBlockRemoveProvisioningPackage                = $policy.AdditionalProperties.settingsBlockRemoveProvisioningPackage
            SettingsBlockChangeSystemTime                         = $policy.AdditionalProperties.settingsBlockChangeSystemTime
            SettingsBlockEditDeviceName                           = $policy.AdditionalProperties.settingsBlockEditDeviceName
            SettingsBlockChangeRegion                             = $policy.AdditionalProperties.settingsBlockChangeRegion
            SettingsBlockChangeLanguage                           = $policy.AdditionalProperties.settingsBlockChangeLanguage
            SettingsBlockChangePowerSleep                         = $policy.AdditionalProperties.settingsBlockChangePowerSleep
            LocationServicesBlocked                               = $policy.AdditionalProperties.locationServicesBlocked
            MicrosoftAccountBlocked                               = $policy.AdditionalProperties.microsoftAccountBlocked
            MicrosoftAccountBlockSettingsSync                     = $policy.AdditionalProperties.microsoftAccountBlockSettingsSync
            NfcBlocked                                            = $policy.AdditionalProperties.nfcBlocked
            ResetProtectionModeBlocked                            = $policy.AdditionalProperties.resetProtectionModeBlocked
            ScreenCaptureBlocked                                  = $policy.AdditionalProperties.screenCaptureBlocked
            StorageBlockRemovableStorage                          = $policy.AdditionalProperties.storageBlockRemovableStorage
            StorageRequireMobileDeviceEncryption                  = $policy.AdditionalProperties.storageRequireMobileDeviceEncryption
            UsbBlocked                                            = $policy.AdditionalProperties.usbBlocked
            VoiceRecordingBlocked                                 = $policy.AdditionalProperties.voiceRecordingBlocked
            WiFiBlockAutomaticConnectHotspots                     = $policy.AdditionalProperties.wiFiBlockAutomaticConnectHotspots
            WiFiBlocked                                           = $policy.AdditionalProperties.wiFiBlocked
            WiFiBlockManualConfiguration                          = $policy.AdditionalProperties.wiFiBlockManualConfiguration
            WiFiScanInterval                                      = $policy.AdditionalProperties.wiFiScanInterval
            WirelessDisplayBlockProjectionToThisDevice            = $policy.AdditionalProperties.wirelessDisplayBlockProjectionToThisDevice
            WirelessDisplayBlockUserInputFromReceiver             = $policy.AdditionalProperties.wirelessDisplayBlockUserInputFromReceiver
            WirelessDisplayRequirePinForPairing                   = $policy.AdditionalProperties.wirelessDisplayRequirePinForPairing
            WindowsStoreBlocked                                   = $policy.AdditionalProperties.windowsStoreBlocked
            AppsAllowTrustedAppsSideloading                       = $policy.AdditionalProperties.appsAllowTrustedAppsSideloading
            WindowsStoreBlockAutoUpdate                           = $policy.AdditionalProperties.windowsStoreBlockAutoUpdate
            DeveloperUnlockSetting                                = $policy.AdditionalProperties.developerUnlockSetting
            SharedUserAppDataAllowed                              = $policy.AdditionalProperties.sharedUserAppDataAllowed
            AppsBlockWindowsStoreOriginatedApps                   = $policy.AdditionalProperties.appsBlockWindowsStoreOriginatedApps
            WindowsStoreEnablePrivateStoreOnly                    = $policy.AdditionalProperties.windowsStoreEnablePrivateStoreOnly
            StorageRestrictAppDataToSystemVolume                  = $policy.AdditionalProperties.storageRestrictAppDataToSystemVolume
            StorageRestrictAppInstallToSystemVolume               = $policy.AdditionalProperties.storageRestrictAppInstallToSystemVolume
            GameDvrBlocked                                        = $policy.AdditionalProperties.gameDvrBlocked
            ExperienceBlockDeviceDiscovery                        = $policy.AdditionalProperties.experienceBlockDeviceDiscovery
            ExperienceBlockErrorDialogWhenNoSIM                   = $policy.AdditionalProperties.experienceBlockErrorDialogWhenNoSIM
            ExperienceBlockTaskSwitcher                           = $policy.AdditionalProperties.experienceBlockTaskSwitcher
            LogonBlockFastUserSwitching                           = $policy.AdditionalProperties.logonBlockFastUserSwitching
            TenantLockdownRequireNetworkDuringOutOfBoxExperience  = $policy.AdditionalProperties.tenantLockdownRequireNetworkDuringOutOfBoxExperience
            Ensure                                                = 'Present'
            Credential                                            = $Credential
            ApplicationId                                         = $ApplicationId
            TenantId                                              = $TenantId
            ApplicationSecret                                     = $ApplicationSecret
            CertificateThumbprint                                 = $CertificateThumbprint
            Managedidentity                                       = $ManagedIdentity.IsPresent
        }

        $returnAssignments = @()
        $returnAssignments += Get-MgBetaDeviceManagementDeviceConfigurationAssignment -DeviceConfigurationId $policy.Id
        $assignmentResult = @()
        foreach ($assignmentEntry in $returnAssignments)
        {
            $assignmentValue = @{
                dataType                                   = $assignmentEntry.Target.AdditionalProperties.'@odata.type'
                deviceAndAppManagementAssignmentFilterType = $assignmentEntry.Target.DeviceAndAppManagementAssignmentFilterType.toString()
                deviceAndAppManagementAssignmentFilterId   = $assignmentEntry.Target.DeviceAndAppManagementAssignmentFilterId
                groupId                                    = $assignmentEntry.Target.AdditionalProperties.groupId
            }
            $assignmentResult += $assignmentValue
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
        [ValidateSet('userDefined', 'none', 'basic', 'enhanced', 'full')]
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
        [ValidateSet('userDefined', 'allow', 'blockThirdparty', 'blockAll')]
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
        [ValidateSet('userDefined', 'disable', 'monitorAllFiles', 'monitorIncomingFilesOnly', 'monitorOutgoingFilesOnly')]
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
        [ValidateSet('notConfigured', 'high', 'highPlus', 'zeroTolerance')]
        [System.String]
        $DefenderCloudBlockLevel,

        [Parameter()]
        [ValidateSet('userDefined', 'alwaysPrompt', 'promptBeforeSendingPersonalData', 'neverSendData', 'sendAllDataWithoutPrompting')]
        [System.String]
        $DefenderPromptForSampleSubmission,

        [Parameter()]
        [System.String]
        $DefenderScheduledQuickScanTime,

        [Parameter()]
        [ValidateSet('userDefined', 'disabled', 'quick', 'full')]
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
        [Microsoft.Management.Infrastructure.CimInstance]
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
        [ValidateSet('deviceDefault', 'alphanumeric', 'numeric')]
        [System.String]
        $PasswordRequiredType,

        [Parameter()]
        [System.Uint64]
        $PasswordSignInFailureCountBeforeFactoryReset,

        [Parameter()]
        [ValidateSet('notConfigured', 'blocked', 'allowed')]
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
        [ValidateSet('notConfigured', 'disabled', 'enabled')]
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
        [ValidateSet('userDefined', 'strict', 'moderate')]
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
        [ValidateSet('notConfigured', 'blocked', 'allowed')]
        $AppsAllowTrustedAppsSideloading,

        [Parameter()]
        [System.Boolean]
        $WindowsStoreBlockAutoUpdate,

        [Parameter()]
        [ValidateSet('notConfigured', 'blocked', 'allowed')]
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

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter(Mandatory = $True)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure = $true,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentPolicy = Get-TargetResource @PSBoundParameters
    $PSBoundParameters.Remove('Ensure') | Out-Null
    $PSBoundParameters.Remove('Credential') | Out-Null
    $PSBoundParameters.Remove('ApplicationId') | Out-Null
    $PSBoundParameters.Remove('TenantId') | Out-Null
    $PSBoundParameters.Remove('ApplicationSecret') | Out-Null
    if ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Device Configuration Policy {$DisplayName}"
        $PSBoundParameters.Remove('DisplayName') | Out-Null
        $PSBoundParameters.Remove('Description') | Out-Null
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $AdditionalProperties = Get-M365DSCIntuneDeviceConfigurationPolicyWindowsAdditionalProperties -Properties ([System.Collections.Hashtable]$PSBoundParameters)
        if ($AdditionalProperties.DefenderDetectedMalwareActions)
        {
            $AdditionalProperties.DefenderDetectedMalwareActions.Add('@odata.type', '#microsoft.graph.defenderDetectedMalwareActions')
        }
        $policy = New-MgBetaDeviceManagementDeviceConfiguration -DisplayName $DisplayName `
            -Description $Description `
            -AdditionalProperties $AdditionalProperties

        #region Assignments
        $assignmentsHash = @()
        foreach ($assignment in $Assignments)
        {
            $assignmentsHash += Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignment
        }
        if ($policy.id)
        {
            Update-DeviceConfigurationPolicyAssignments -DeviceConfigurationPolicyId $policy.id `
                -Targets $assignmentsHash
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating existing Device Configuration Policy {$DisplayName}"
        $configDevicePolicy = Get-MgBetaDeviceManagementDeviceConfiguration `
            -ErrorAction Stop | Where-Object `
            -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.windows10GeneralConfiguration' -and `
                $_.displayName -eq $($DisplayName) }

        $PSBoundParameters.Remove('DisplayName') | Out-Null
        $PSBoundParameters.Remove('Description') | Out-Null
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $AdditionalProperties = Get-M365DSCIntuneDeviceConfigurationPolicyWindowsAdditionalProperties -Properties ([System.Collections.Hashtable]$PSBoundParameters)
        if ($AdditionalProperties.DefenderDetectedMalwareActions)
        {
            $AdditionalProperties.DefenderDetectedMalwareActions.Add('@odata.type', '#microsoft.graph.defenderDetectedMalwareActions')
        }
        Update-MgBetaDeviceManagementDeviceConfiguration -AdditionalProperties $AdditionalProperties `
            -Description $Description `
            -DeviceConfigurationId $configDevicePolicy.Id

        #region Assignments
        $assignmentsHash = @()
        foreach ($assignment in $Assignments)
        {
            $assignmentsHash += Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignment
        }
        Update-DeviceConfigurationPolicyAssignments -DeviceConfigurationPolicyId $configDevicePolicy.Id `
            -Targets $assignmentsHash
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Device Configuration Policy {$DisplayName}"
        $configDevicePolicy = Get-MgBetaDeviceManagementDeviceConfiguration `
            -ErrorAction Stop | Where-Object `
            -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.windows10GeneralConfiguration' -and `
                $_.displayName -eq $($DisplayName) }

        Remove-MgBetaDeviceManagementDeviceConfiguration -DeviceConfigurationId $configDevicePolicy.Id
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
        [ValidateSet('userDefined', 'none', 'basic', 'enhanced', 'full')]
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
        [ValidateSet('userDefined', 'allow', 'blockThirdparty', 'blockAll')]
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
        [ValidateSet('userDefined', 'disable', 'monitorAllFiles', 'monitorIncomingFilesOnly', 'monitorOutgoingFilesOnly')]
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
        [ValidateSet('notConfigured', 'high', 'highPlus', 'zeroTolerance')]
        [System.String]
        $DefenderCloudBlockLevel,

        [Parameter()]
        [ValidateSet('userDefined', 'alwaysPrompt', 'promptBeforeSendingPersonalData', 'neverSendData', 'sendAllDataWithoutPrompting')]
        [System.String]
        $DefenderPromptForSampleSubmission,

        [Parameter()]
        [System.String]
        $DefenderScheduledQuickScanTime,

        [Parameter()]
        [ValidateSet('userDefined', 'disabled', 'quick', 'full')]
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
        [Microsoft.Management.Infrastructure.CimInstance]
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
        [ValidateSet('deviceDefault', 'alphanumeric', 'numeric')]
        [System.String]
        $PasswordRequiredType,

        [Parameter()]
        [System.Uint64]
        $PasswordSignInFailureCountBeforeFactoryReset,

        [Parameter()]
        [ValidateSet('notConfigured', 'blocked', 'allowed')]
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
        [ValidateSet('notConfigured', 'disabled', 'enabled')]
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
        [ValidateSet('userDefined', 'strict', 'moderate')]
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
        [ValidateSet('notConfigured', 'blocked', 'allowed')]
        $AppsAllowTrustedAppsSideloading,

        [Parameter()]
        [System.Boolean]
        $WindowsStoreBlockAutoUpdate,

        [Parameter()]
        [ValidateSet('notConfigured', 'blocked', 'allowed')]
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

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter(Mandatory = $True)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure = $true,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
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

    # Check DefenderDetectedMalwareActions
    if ($CurrentValues.DefenderDetectedMalwareActions.LowSeverity -ne $DefenderDetectedMalwareActions.LowSeverity -or
        $CurrentValues.DefenderDetectedMalwareActions.ModerateSeverity -ne $DefenderDetectedMalwareActions.ModerateSeverity -or
        $CurrentValues.DefenderDetectedMalwareActions.HighSeverity -ne $DefenderDetectedMalwareActions.HighSeverity -or
        $CurrentValues.DefenderDetectedMalwareActions.SevereSeverity -ne $DefenderDetectedMalwareActions.SevereSeverity)
    {
        Write-Verbose -Message "Test-TargetResource returned $false"
        return $false
    }
    $ValuesToCheck.Remove('DefenderDetectedMalwareActions') | Out-Null

    if ($CurrentValues.Ensure -ne $PSBoundParameters.Ensure)
    {
        Write-Verbose -Message "Test-TargetResource returned $false"
        return $false
    }
    #region Assignments
    $testResult = $true

    if ((-not $CurrentValues.Assignments) -xor (-not $ValuesToCheck.Assignments))
    {
        Write-Verbose -Message 'Configuration drift: one the assignment is null'
        return $false
    }

    if ($CurrentValues.Assignments)
    {
        if ($CurrentValues.Assignments.count -ne $ValuesToCheck.Assignments.count)
        {
            Write-Verbose -Message "Configuration drift: Number of assignment has changed - current {$($CurrentValues.Assignments.count)} target {$($ValuesToCheck.Assignments.count)}"
            return $false
        }
        foreach ($assignment in $CurrentValues.Assignments)
        {
            #GroupId Assignment
            if (-not [String]::IsNullOrEmpty($assignment.groupId))
            {
                $source = [Array]$ValuesToCheck.Assignments | Where-Object -FilterScript { $_.groupId -eq $assignment.groupId }
                if (-not $source)
                {
                    Write-Verbose -Message "Configuration drift: groupId {$($assignment.groupId)} not found"
                    $testResult = $false
                    break
                }
                $sourceHash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $source
                $testResult = Compare-M365DSCComplexObject -Source $sourceHash -Target $assignment
            }
            #AllDevices/AllUsers assignment
            else
            {
                $source = [Array]$ValuesToCheck.Assignments | Where-Object -FilterScript { $_.dataType -eq $assignment.dataType }
                if (-not $source)
                {
                    Write-Verbose -Message "Configuration drift: {$($assignment.dataType)} not found"
                    $testResult = $false
                    break
                }
                $sourceHash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $source
                $testResult = Compare-M365DSCComplexObject -Source $sourceHash -Target $assignment
            }

            if (-not $testResult)
            {
                $testResult = $false
                break
            }
        }
    }
    if (-not $testResult)
    {
        return $false
    }
    $ValuesToCheck.Remove('Assignments') | Out-Null
    #endregion

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
        [Switch]
        $ManagedIdentity
    )

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

    try
    {
        [array]$policies = Get-MgBetaDeviceManagementDeviceConfiguration `
            -ErrorAction Stop -All:$true -Filter $Filter | Where-Object `
            -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.windows10GeneralConfiguration' }
        $i = 1
        $dscContent = ''
        if ($policies.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($policy in $policies)
        {
            Write-Host "    |---[$i/$($policies.Count)] $($policy.DisplayName)" -NoNewline
            $params = @{
                DisplayName           = $policy.DisplayName
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

            if ($Results.DefenderDetectedMalwareActions)
            {
                $StringContent = [System.Text.StringBuilder]::new()
                $StringContent.AppendLine('MSFT_IntuneDefenderDetectedMalwareActions {') | Out-Null
                $StringContent.AppendLine("                LowSeverity       = '" + $Results.DefenderDetectedMalwareActions.LowSeverity + "'") | Out-Null
                $StringContent.AppendLine("                ModerateSeverity  = '" + $Results.DefenderDetectedMalwareActions.ModerateSeverity + "'") | Out-Null
                $StringContent.AppendLine("                HighSeverity      = '" + $Results.DefenderDetectedMalwareActions.HighSeverity + "'") | Out-Null
                $StringContent.AppendLine("                SevereSeverity    = '" + $Results.DefenderDetectedMalwareActions.SevereSeverity + "'") | Out-Null
                $StringContent.AppendLine('            }') | Out-Null
                $Results.DefenderDetectedMalwareActions = $StringContent.ToString()
            }
            if ($Results.Assignments)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject ([Array]$Results.Assignments) -CIMInstanceName DeviceManagementConfigurationPolicyAssignments

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
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock `
                    -ParameterName 'DefenderDetectedMalwareActions'
            }

            if ($Results.Assignments)
            {
                $isCIMArray = $false
                if ($Results.Assignments.getType().Fullname -like '*[[\]]')
                {
                    $isCIMArray = $true
                }
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'Assignments' -IsCIMArray:$isCIMArray
            }

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

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

function Get-M365DSCIntuneDeviceConfigurationPolicyWindowsAdditionalProperties
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $Properties
    )

    $results = @{'@odata.type' = '#microsoft.graph.windows10GeneralConfiguration' }
    foreach ($property in $properties.Keys)
    {
        if ($property -ne 'Verbose')
        {
            $propertyName = $property[0].ToString().ToLower() + $property.Substring(1, $property.Length - 1)
            if ($propertyName -eq 'defenderDetectedMalwareActions')
            {
                $propertyValue = @{
                    lowSeverity      = $properties.$property.lowSeverity
                    moderateSeverity = $properties.$property.moderateSeverity
                    highSeverity     = $properties.$property.highSeverity
                    severeSeverity   = $properties.$property.severeSeverity
                }
            }
            else
            {
                $propertyValue = $properties.$property
            }
            $results.Add($propertyName, $propertyValue)
        }
    }
    return $results
}

function Update-DeviceConfigurationPolicyAssignments
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = 'true')]
        [System.String]
        $DeviceConfigurationPolicyId,

        [Parameter()]
        [Array]
        $Targets
    )

    try
    {
        $configurationPolicyAssignments = @()

        $Uri = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations/$DeviceConfigurationPolicyId/assign"

        foreach ($target in $targets)
        {
            $formattedTarget = @{'@odata.type' = $target.dataType }
            if ($target.groupId)
            {
                $formattedTarget.Add('groupId', $target.groupId)
            }
            if ($target.collectionId)
            {
                $formattedTarget.Add('collectionId', $target.collectionId)
            }
            if ($target.deviceAndAppManagementAssignmentFilterType)
            {
                $formattedTarget.Add('deviceAndAppManagementAssignmentFilterType', $target.deviceAndAppManagementAssignmentFilterType)
            }
            if ($target.deviceAndAppManagementAssignmentFilterId)
            {
                $formattedTarget.Add('deviceAndAppManagementAssignmentFilterId', $target.deviceAndAppManagementAssignmentFilterId)
            }
            $configurationPolicyAssignments += @{'target' = $formattedTarget }
        }
        $body = @{'assignments' = $configurationPolicyAssignments } | ConvertTo-Json -Depth 20
        #write-verbose -Message $body
        Invoke-MgGraphRequest -Method POST -Uri $Uri -Body $body -ErrorAction Stop

    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error updating data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $null
    }
}

function Get-M365DSCDRGComplexTypeToHashtable
{
    [CmdletBinding()]
    [OutputType([hashtable], [hashtable[]])]
    param
    (
        [Parameter()]
        $ComplexObject
    )

    if ($null -eq $ComplexObject)
    {
        return $null
    }


    if ($ComplexObject.getType().Fullname -like '*hashtable')
    {
        return $ComplexObject
    }
    if ($ComplexObject.getType().Fullname -like '*hashtable[[\]]')
    {
        return [hashtable[]]$ComplexObject
    }


    if ($ComplexObject.gettype().fullname -like '*[[\]]')
    {
        $results = @()

        foreach ($item in $ComplexObject)
        {
            if ($item)
            {
                $hash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
                $results += $hash
            }
        }

        # PowerShell returns all non-captured stream output, not just the argument of the return statement.
        #An empty array is mangled into $null in the process.
        #However, an array can be preserved on return by prepending it with the array construction operator (,)
        return , [hashtable[]]$results
    }

    $results = @{}
    $keys = $ComplexObject | Get-Member | Where-Object -FilterScript { $_.MemberType -eq 'Property' -and $_.Name -ne 'AdditionalProperties' }

    foreach ($key in $keys)
    {

        if ($ComplexObject.$($key.Name))
        {
            $keyName = $key.Name[0].ToString().ToLower() + $key.Name.Substring(1, $key.Name.Length - 1)

            if ($ComplexObject.$($key.Name).gettype().fullname -like '*CimInstance*')
            {
                $hash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject.$($key.Name)

                $results.Add($keyName, $hash)
            }
            else
            {
                $results.Add($keyName, $ComplexObject.$($key.Name))
            }
        }
    }

    return [hashtable]$results
}

function Get-M365DSCDRGComplexTypeToString
{
    [CmdletBinding()]
    #[OutputType([System.String])]
    param
    (
        [Parameter()]
        $ComplexObject,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CIMInstanceName,

        [Parameter()]
        [Array]
        $ComplexTypeMapping,

        [Parameter()]
        [System.String]
        $Whitespace = '',

        [Parameter()]
        [switch]
        $isArray = $false
    )

    if ($null -eq $ComplexObject)
    {
        return $null
    }

    #If ComplexObject  is an Array
    if ($ComplexObject.GetType().FullName -like '*[[\]]')
    {
        $currentProperty = @()
        foreach ($item in $ComplexObject)
        {
            $split = @{
                'ComplexObject'   = $item
                'CIMInstanceName' = $CIMInstanceName
                'Whitespace'      = "                $whitespace"
            }
            if ($ComplexTypeMapping)
            {
                $split.add('ComplexTypeMapping', $ComplexTypeMapping)
            }

            $currentProperty += Get-M365DSCDRGComplexTypeToString -isArray:$true @split

        }

        # PowerShell returns all non-captured stream output, not just the argument of the return statement.
        #An empty array is mangled into $null in the process.
        #However, an array can be preserved on return by prepending it with the array construction operator (,)
        return , $currentProperty
    }

    $currentProperty = ''
    if ($isArray)
    {
        $currentProperty += "`r`n"
    }
    $currentProperty += "$whitespace`MSFT_$CIMInstanceName{`r`n"
    $keyNotNull = 0
    foreach ($key in $ComplexObject.Keys)
    {

        if ($ComplexObject[$key])
        {
            $keyNotNull++
            if ($ComplexObject[$key].GetType().FullName -like 'Microsoft.Graph.PowerShell.Models.*' -or $key -in $ComplexTypeMapping.Name)
            {
                $hashPropertyType = $ComplexObject[$key].GetType().Name.tolower()

                #overwrite type if object defined in mapping complextypemapping
                if ($key -in $ComplexTypeMapping.Name)
                {
                    $hashPropertyType = ($ComplexTypeMapping | Where-Object -FilterScript { $_.Name -eq $key }).CimInstanceName
                    $hashProperty = $ComplexObject[$key]
                }
                else
                {
                    $hashProperty = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject[$key]
                }

                if ($key -notin $ComplexTypeMapping.Name)
                {
                    $Whitespace += '            '
                }

                if (-not $isArray -or ($isArray -and $key -in $ComplexTypeMapping.Name ))
                {
                    $currentProperty += $whitespace + $key + ' = '
                    if ($ComplexObject[$key].GetType().FullName -like '*[[\]]')
                    {
                        $currentProperty += '@('
                    }
                }

                if ($key -in $ComplexTypeMapping.Name)
                {
                    $Whitespace = ''

                }
                $currentProperty += Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $hashProperty `
                    -CIMInstanceName $hashPropertyType `
                    -Whitespace $Whitespace `
                    -ComplexTypeMapping $ComplexTypeMapping

                if ($ComplexObject[$key].GetType().FullName -like '*[[\]]')
                {
                    $currentProperty += ')'
                }
            }
            else
            {
                if (-not $isArray)
                {
                    $Whitespace = '            '
                }
                $currentProperty += Get-M365DSCDRGSimpleObjectTypeToString -Key $key -Value $ComplexObject[$key] -Space ($Whitespace + '    ')
            }
        }
        else
        {
            $mappedKey = $ComplexTypeMapping | Where-Object -FilterScript { $_.name -eq $key }

            if ($mappedKey -and $mappedKey.isRequired)
            {
                if ($mappedKey.isArray)
                {
                    $currentProperty += "$Whitespace    $key = @()`r`n"
                }
                else
                {
                    $currentProperty += "$Whitespace    $key = `$null`r`n"
                }
            }
        }
    }
    $currentProperty += "$Whitespace}"

    return $currentProperty
}

function Get-M365DSCDRGSimpleObjectTypeToString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = 'true')]
        [System.String]
        $Key,

        [Parameter(Mandatory = 'true')]
        $Value,

        [Parameter()]
        [System.String]
        $Space = '                '
    )

    $returnValue = ''
    switch -Wildcard ($Value.GetType().Fullname )
    {
        '*.Boolean'
        {
            $returnValue = $Space + $Key + " = `$" + $Value.ToString() + "`r`n"
        }
        '*.String'
        {
            if ($key -eq '@odata.type')
            {
                $key = 'odataType'
            }
            $returnValue = $Space + $Key + " = '" + $Value + "'`r`n"
        }
        '*.DateTime'
        {
            $returnValue = $Space + $Key + " = '" + $Value + "'`r`n"
        }
        '*[[\]]'
        {
            $returnValue = $Space + $key + ' = @('
            $whitespace = ''
            $newline = ''
            if ($Value.count -gt 1)
            {
                $returnValue += "`r`n"
                $whitespace = $Space + '    '
                $newline = "`r`n"
            }
            foreach ($item in $Value)
            {
                switch -Wildcard ($item.GetType().Fullname )
                {
                    '*.String'
                    {
                        $returnValue += "$whitespace'$item'$newline"
                    }
                    '*.DateTime'
                    {
                        $returnValue += "$whitespace'$item'$newline"
                    }
                    Default
                    {
                        $returnValue += "$whitespace$item$newline"
                    }
                }
            }
            if ($Value.count -gt 1)
            {
                $returnValue += "$Space)`r`n"
            }
            else
            {
                $returnValue += ")`r`n"

            }
        }
        Default
        {
            $returnValue = $Space + $Key + ' = ' + $Value + "`r`n"
        }
    }
    return $returnValue
}

function Compare-M365DSCComplexObject
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter()]
        $Source,

        [Parameter()]
        $Target
    )

    #Comparing full objects
    if ($null -eq $Source -and $null -eq $Target)
    {
        return $true
    }

    $sourceValue = ''
    $targetValue = ''
    if (($null -eq $Source) -xor ($null -eq $Target))
    {
        if ($null -eq $Source)
        {
            $sourceValue = 'Source is null'
        }

        if ($null -eq $Target)
        {
            $targetValue = 'Target is null'
        }
        Write-Verbose -Message "Configuration drift - Complex object: {$sourceValue$targetValue}"
        return $false
    }

    if ($Source.getType().FullName -like '*CimInstance[[\]]' -or $Source.getType().FullName -like '*Hashtable[[\]]')
    {
        if ($source.count -ne $target.count)
        {
            Write-Verbose -Message "Configuration drift - The complex array have different number of items: Source {$($source.count)} Target {$($target.count)}"
            return $false
        }
        if ($source.count -eq 0)
        {
            return $true
        }

        $i = 0
        foreach ($item in $Source)
        {

            $compareResult = Compare-M365DSCComplexObject `
                -Source (Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Source[$i]) `
                -Target $Target[$i]

            if (-not $compareResult)
            {
                Write-Verbose -Message 'Configuration drift - The complex array items are not identical'
                return $false
            }
            $i++
        }
        return $true
    }

    $keys = $Source.Keys | Where-Object -FilterScript { $_ -ne 'PSComputerName' }
    foreach ($key in $keys)
    {
        #write-verbose -message "Comparing key: {$key}"
        #Matching possible key names between Source and Target
        $skey = $key
        $tkey = $key
        if ($key -eq 'odataType')
        {
            $skey = '@odata.type'
        }
        else
        {
            $tmpkey = $Target.keys | Where-Object -FilterScript { $_ -eq "$key" }
            if ($tkey)
            {
                $tkey = $tmpkey | Select-Object -First 1
            }
        }

        $sourceValue = $Source.$key
        $targetValue = $Target.$tkey
        #One of the item is null and not the other
        if (($null -eq $Source.$skey) -xor ($null -eq $Target.$tkey))
        {

            if ($null -eq $Source.$skey)
            {
                $sourceValue = 'null'
            }

            if ($null -eq $Target.$tkey)
            {
                $targetValue = 'null'
            }

            Write-Verbose -Message "Configuration drift - key: $key Source {$sourceValue} Target {$targetValue}"
            return $false
        }

        #Both keys aren't null or empty
        if (($null -ne $Source.$skey) -and ($null -ne $Target.$tkey))
        {
            if ($Source.$skey.getType().FullName -like '*CimInstance*' -or $Source.$skey.getType().FullName -like '*hashtable*'  )
            {
                #Recursive call for complex object
                $compareResult = Compare-M365DSCComplexObject `
                    -Source (Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Source.$skey) `
                    -Target $Target.$tkey

                if (-not $compareResult)
                {
                    Write-Verbose -Message "Configuration drift - complex object key: $key Source {$sourceValue} Target {$targetValue}"
                    return $false
                }
            }
            else
            {
                #Simple object comparison
                $referenceObject = $Target.$tkey
                $differenceObject = $Source.$skey

                $compareResult = Compare-Object `
                    -ReferenceObject ($referenceObject) `
                    -DifferenceObject ($differenceObject)

                if ($null -ne $compareResult)
                {
                    Write-Verbose -Message "Configuration drift - simple object key: $key Source {$sourceValue} Target {$targetValue}"
                    return $false
                }
            }
        }
    }

    return $true
}

function Convert-M365DSCDRGComplexTypeToHashtable
{
    [CmdletBinding()]
    [OutputType([hashtable], [hashtable[]])]
    param
    (
        [Parameter(Mandatory = 'true')]
        $ComplexObject
    )

    if ($ComplexObject.getType().Fullname -like '*[[\]]')
    {
        $results = @()
        foreach ($item in $ComplexObject)
        {
            $hash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
            $results += $hash
        }

        #Write-Verbose -Message ("Convert-M365DSCDRGComplexTypeToHashtable >>> results: "+(convertTo-JSON $results -Depth 20))
        # PowerShell returns all non-captured stream output, not just the argument of the return statement.
        #An empty array is mangled into $null in the process.
        #However, an array can be preserved on return by prepending it with the array construction operator (,)
        return , [hashtable[]]$results
    }
    $hashComplexObject = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject

    if ($hashComplexObject)
    {

        $results = $hashComplexObject.clone()
        $keys = $hashComplexObject.Keys | Where-Object -FilterScript { $_ -ne 'PSComputerName' }
        foreach ($key in $keys)
        {
            if ($hashComplexObject[$key] -and $hashComplexObject[$key].getType().Fullname -like '*CimInstance*')
            {
                $results[$key] = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $hashComplexObject[$key]
            }
            else
            {
                $propertyName = $key[0].ToString().ToLower() + $key.Substring(1, $key.Length - 1)
                $propertyValue = $results[$key]
                $results.remove($key) | Out-Null
                $results.add($propertyName, $propertyValue)
            }
        }
    }
    return [hashtable]$results
}

Export-ModuleMember -Function *-TargetResource
