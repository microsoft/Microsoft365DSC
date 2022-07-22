function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DeviceManagementApplicabilityRuleDeviceMode,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DeviceManagementApplicabilityRuleOsEdition,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DeviceManagementApplicabilityRuleOsVersion,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.Boolean]
        $SupportsScopeTags,

        [Parameter()]
        [System.Int32]
        $Version,

        [Parameter()]
        [System.Boolean]
        $AccountsBlockModification,

        [Parameter()]
        [System.Boolean]
        $AppsAllowInstallFromUnknownSources,

        [Parameter()]
        [System.String[]]
        $AppsAutoUpdatePolicy,

        [Parameter()]
        [System.String[]]
        $AppsDefaultPermissionPolicy,

        [Parameter()]
        [System.Boolean]
        $AppsRecommendSkippingFirstUseHints,

        [Parameter()]
        [System.String[]]
        $AzureAdSharedDeviceDataClearApps,

        [Parameter()]
        [System.Boolean]
        $BluetoothBlockConfiguration,

        [Parameter()]
        [System.Boolean]
        $BluetoothBlockContactSharing,

        [Parameter()]
        [System.Boolean]
        $CameraBlocked,

        [Parameter()]
        [System.Boolean]
        $CellularBlockWiFiTethering,

        [Parameter()]
        [System.Boolean]
        $CertificateCredentialConfigurationDisabled,

        [Parameter()]
        [System.Boolean]
        $CrossProfilePoliciesAllowCopyPaste,

        [Parameter()]
        [System.String[]]
        $CrossProfilePoliciesAllowDataSharing,

        [Parameter()]
        [System.Boolean]
        $CrossProfilePoliciesShowWorkContactsInPersonalProfile,

        [Parameter()]
        [System.Boolean]
        $DataRoamingBlocked,

        [Parameter()]
        [System.Boolean]
        $DateTimeConfigurationBlocked,

        [Parameter()]
        [System.String[]]
        $EnrollmentProfile,

        [Parameter()]
        [System.Boolean]
        $FactoryResetBlocked,

        [Parameter()]
        [System.String[]]
        $FactoryResetDeviceAdministratorEmails,

        [Parameter()]
        [System.String[]]
        $GlobalProxy,

        [Parameter()]
        [System.Boolean]
        $GoogleAccountsBlocked,

        [Parameter()]
        [System.Boolean]
        $KioskCustomizationDeviceSettingsBlocked,

        [Parameter()]
        [System.Boolean]
        $KioskCustomizationPowerButtonActionsBlocked,

        [Parameter()]
        [System.String[]]
        $KioskCustomizationStatusBar,

        [Parameter()]
        [System.Boolean]
        $KioskCustomizationSystemErrorWarnings,

        [Parameter()]
        [System.String[]]
        $KioskCustomizationSystemNavigation,

        [Parameter()]
        [System.Boolean]
        $KioskModeAppOrderEnabled,

        [Parameter()]
        [System.String[]]
        $KioskModeAppPositions,

        [Parameter()]
        [System.String[]]
        $KioskModeApps,

        [Parameter()]
        [System.Boolean]
        $KioskModeAppsInFolderOrderedByName,

        [Parameter()]
        [System.Boolean]
        $KioskModeBluetoothConfigurationEnabled,

        [Parameter()]
        [System.Boolean]
        $KioskModeDebugMenuEasyAccessEnabled,

        [Parameter()]
        [System.String]
        $KioskModeExitCode,

        [Parameter()]
        [System.Boolean]
        $KioskModeFlashlightConfigurationEnabled,

        [Parameter()]
        [System.String[]]
        $KioskModeFolderIcon,

        [Parameter()]
        [System.Int32]
        $KioskModeGridHeight,

        [Parameter()]
        [System.Int32]
        $KioskModeGridWidth,

        [Parameter()]
        [System.String[]]
        $KioskModeIconSize,

        [Parameter()]
        [System.Boolean]
        $KioskModeLockHomeScreen,

        [Parameter()]
        [System.String[]]
        $KioskModeManagedFolders,

        [Parameter()]
        [System.Boolean]
        $KioskModeManagedHomeScreenAutoSignout,

        [Parameter()]
        [System.Int32]
        $KioskModeManagedHomeScreenInactiveSignOutDelayInSeconds,

        [Parameter()]
        [System.Int32]
        $KioskModeManagedHomeScreenInactiveSignOutNoticeInSeconds,

        [Parameter()]
        [System.String[]]
        $KioskModeManagedHomeScreenPinComplexity,

        [Parameter()]
        [System.Boolean]
        $KioskModeManagedHomeScreenPinRequired,

        [Parameter()]
        [System.Boolean]
        $KioskModeManagedHomeScreenPinRequiredToResume,

        [Parameter()]
        [System.String]
        $KioskModeManagedHomeScreenSignInBackground,

        [Parameter()]
        [System.String]
        $KioskModeManagedHomeScreenSignInBrandingLogo,

        [Parameter()]
        [System.Boolean]
        $KioskModeManagedHomeScreenSignInEnabled,

        [Parameter()]
        [System.Boolean]
        $KioskModeManagedSettingsEntryDisabled,

        [Parameter()]
        [System.Boolean]
        $KioskModeMediaVolumeConfigurationEnabled,

        [Parameter()]
        [System.String[]]
        $KioskModeScreenOrientation,

        [Parameter()]
        [System.Boolean]
        $KioskModeScreenSaverConfigurationEnabled,

        [Parameter()]
        [System.Boolean]
        $KioskModeScreenSaverDetectMediaDisabled,

        [Parameter()]
        [System.Int32]
        $KioskModeScreenSaverDisplayTimeInSeconds,

        [Parameter()]
        [System.String]
        $KioskModeScreenSaverImageUrl,

        [Parameter()]
        [System.Int32]
        $KioskModeScreenSaverStartDelayInSeconds,

        [Parameter()]
        [System.Boolean]
        $KioskModeShowAppNotificationBadge,

        [Parameter()]
        [System.Boolean]
        $KioskModeShowDeviceInfo,

        [Parameter()]
        [System.Boolean]
        $KioskModeVirtualHomeButtonEnabled,

        [Parameter()]
        [System.String[]]
        $KioskModeVirtualHomeButtonType,

        [Parameter()]
        [System.String]
        $KioskModeWallpaperUrl,

        [Parameter()]
        [System.String[]]
        $KioskModeWifiAllowedSsids,

        [Parameter()]
        [System.Boolean]
        $KioskModeWiFiConfigurationEnabled,

        [Parameter()]
        [System.Boolean]
        $MicrophoneForceMute,

        [Parameter()]
        [System.Boolean]
        $MicrosoftLauncherConfigurationEnabled,

        [Parameter()]
        [System.Boolean]
        $MicrosoftLauncherCustomWallpaperAllowUserModification,

        [Parameter()]
        [System.Boolean]
        $MicrosoftLauncherCustomWallpaperEnabled,

        [Parameter()]
        [System.String]
        $MicrosoftLauncherCustomWallpaperImageUrl,

        [Parameter()]
        [System.Boolean]
        $MicrosoftLauncherDockPresenceAllowUserModification,

        [Parameter()]
        [System.String[]]
        $MicrosoftLauncherDockPresenceConfiguration,

        [Parameter()]
        [System.Boolean]
        $MicrosoftLauncherFeedAllowUserModification,

        [Parameter()]
        [System.Boolean]
        $MicrosoftLauncherFeedEnabled,

        [Parameter()]
        [System.String[]]
        $MicrosoftLauncherSearchBarPlacementConfiguration,

        [Parameter()]
        [System.Boolean]
        $NetworkEscapeHatchAllowed,

        [Parameter()]
        [System.Boolean]
        $NfcBlockOutgoingBeam,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockKeyguard,

        [Parameter()]
        [System.String[]]
        $PasswordBlockKeyguardFeatures,

        [Parameter()]
        [System.Int32]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLetterCharacters,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLowerCaseCharacters,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumNonLetterCharacters,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumNumericCharacters,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumSymbolCharacters,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumUpperCaseCharacters,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeScreenTimeout,

        [Parameter()]
        [System.Int32]
        $PasswordPreviousPasswordCountToBlock,

        [Parameter()]
        [System.String[]]
        $PasswordRequiredType,

        [Parameter()]
        [System.Int32]
        $PasswordSignInFailureCountBeforeFactoryReset,

        [Parameter()]
        [System.Boolean]
        $PersonalProfileAppsAllowInstallFromUnknownSources,

        [Parameter()]
        [System.Boolean]
        $PersonalProfileCameraBlocked,

        [Parameter()]
        [System.String[]]
        $PersonalProfilePersonalApplications,

        [Parameter()]
        [System.String[]]
        $PersonalProfilePlayStoreMode,

        [Parameter()]
        [System.Boolean]
        $PersonalProfileScreenCaptureBlocked,

        [Parameter()]
        [System.String[]]
        $PlayStoreMode,

        [Parameter()]
        [System.Boolean]
        $ScreenCaptureBlocked,

        [Parameter()]
        [System.Boolean]
        $SecurityDeveloperSettingsEnabled,

        [Parameter()]
        [System.Boolean]
        $SecurityRequireVerifyApps,

        [Parameter()]
        [System.Boolean]
        $StatusBarBlocked,

        [Parameter()]
        [System.String[]]
        $StayOnModes,

        [Parameter()]
        [System.Boolean]
        $StorageAllowUsb,

        [Parameter()]
        [System.Boolean]
        $StorageBlockExternalMedia,

        [Parameter()]
        [System.Boolean]
        $StorageBlockUsbFileTransfer,

        [Parameter()]
        [System.String[]]
        $SystemUpdateFreezePeriods,

        [Parameter()]
        [System.String[]]
        $SystemUpdateInstallType,

        [Parameter()]
        [System.Int32]
        $SystemUpdateWindowEndMinutesAfterMidnight,

        [Parameter()]
        [System.Int32]
        $SystemUpdateWindowStartMinutesAfterMidnight,

        [Parameter()]
        [System.Boolean]
        $SystemWindowsBlocked,

        [Parameter()]
        [System.Boolean]
        $UsersBlockAdd,

        [Parameter()]
        [System.Boolean]
        $UsersBlockRemove,

        [Parameter()]
        [System.Boolean]
        $VolumeBlockAdjustment,

        [Parameter()]
        [System.Boolean]
        $VpnAlwaysOnLockdownMode,

        [Parameter()]
        [System.String]
        $VpnAlwaysOnPackageIdentifier,

        [Parameter()]
        [System.Boolean]
        $WifiBlockEditConfigurations,

        [Parameter()]
        [System.Boolean]
        $WifiBlockEditPolicyDefinedConfigurations,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinimumLetterCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinimumLowerCaseCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinimumNonLetterCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinimumNumericCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinimumSymbolCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinimumUpperCaseCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordPreviousPasswordCountToBlock,

        [Parameter()]
        [System.String[]]
        $WorkProfilePasswordRequiredType,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordSignInFailureCountBeforeFactoryReset,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DeviceSettingStateSummaries,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DeviceStatuses,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DeviceStatusOverview,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $GroupAssignments,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $UserStatuses,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserStatusOverview,


        #endregion


        [Parameter(Mandatory = $true)]
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
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    try
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters `
            -ProfileName 'beta'
        Write-Verbose -Message "1 - There are currently {$((dir function: | measure).Count) functions}"
        Write-Verbose -Message "Here1 - Loading Profile {beta}"
        Select-MgProfile 'beta' -ErrorAction Stop
    }
    catch
    {
        Write-Verbose -Message "Reloading1"
    }

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
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

        #region resource generator code
        $getValue = Get-MgDeviceManagementDeviceConfiguration `
            -ErrorAction Stop | Where-Object `
            -FilterScript {
                $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.androidDeviceOwnerGeneralDeviceConfiguration' -and  $_.displayName -eq $($DisplayName)
            }

        if (-not $getValue)
        {
            [array]$getValue = Get-MgDeviceManagementDeviceConfiguration `
                -ErrorAction Stop | Where-Object `
            -FilterScript {
                $_.displayName -eq $DisplayName
            }
        }
        #endregion


        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Nothing with displayName {$DisplayName} was found"
            return $nullResult
        }

        Write-Verbose -Message "Found something with displayName {$DisplayName}"
        $results = @{

            #region resource generator code
            Id = $getValue.Id
            Description = $getValue.Description
            DeviceManagementApplicabilityRuleDeviceMode = $getValue.DeviceManagementApplicabilityRuleDeviceMode
            DeviceManagementApplicabilityRuleOsEdition = $getValue.DeviceManagementApplicabilityRuleOsEdition
            DeviceManagementApplicabilityRuleOsVersion = $getValue.DeviceManagementApplicabilityRuleOsVersion
            DisplayName = $getValue.DisplayName
            RoleScopeTagIds = $getValue.RoleScopeTagIds
            SupportsScopeTags = $getValue.SupportsScopeTags
            Version = $getValue.Version
            AccountsBlockModification = $getValue.AdditionalProperties.accountsBlockModification
            AppsAllowInstallFromUnknownSources = $getValue.AdditionalProperties.appsAllowInstallFromUnknownSources
            AppsAutoUpdatePolicy = $getValue.AdditionalProperties.appsAutoUpdatePolicy
            AppsDefaultPermissionPolicy = $getValue.AdditionalProperties.appsDefaultPermissionPolicy
            AppsRecommendSkippingFirstUseHints = $getValue.AdditionalProperties.appsRecommendSkippingFirstUseHints
            AzureAdSharedDeviceDataClearApps = $getValue.AdditionalProperties.azureAdSharedDeviceDataClearApps
            BluetoothBlockConfiguration = $getValue.AdditionalProperties.bluetoothBlockConfiguration
            BluetoothBlockContactSharing = $getValue.AdditionalProperties.bluetoothBlockContactSharing
            CameraBlocked = $getValue.AdditionalProperties.cameraBlocked
            CellularBlockWiFiTethering = $getValue.AdditionalProperties.cellularBlockWiFiTethering
            CertificateCredentialConfigurationDisabled = $getValue.AdditionalProperties.certificateCredentialConfigurationDisabled
            CrossProfilePoliciesAllowCopyPaste = $getValue.AdditionalProperties.crossProfilePoliciesAllowCopyPaste
            CrossProfilePoliciesAllowDataSharing = $getValue.AdditionalProperties.crossProfilePoliciesAllowDataSharing
            CrossProfilePoliciesShowWorkContactsInPersonalProfile = $getValue.AdditionalProperties.crossProfilePoliciesShowWorkContactsInPersonalProfile
            DataRoamingBlocked = $getValue.AdditionalProperties.dataRoamingBlocked
            DateTimeConfigurationBlocked = $getValue.AdditionalProperties.dateTimeConfigurationBlocked
            EnrollmentProfile = $getValue.AdditionalProperties.enrollmentProfile
            FactoryResetBlocked = $getValue.AdditionalProperties.factoryResetBlocked
            FactoryResetDeviceAdministratorEmails = $getValue.AdditionalProperties.factoryResetDeviceAdministratorEmails
            GlobalProxy = $getValue.AdditionalProperties.globalProxy
            GoogleAccountsBlocked = $getValue.AdditionalProperties.googleAccountsBlocked
            KioskCustomizationDeviceSettingsBlocked = $getValue.AdditionalProperties.kioskCustomizationDeviceSettingsBlocked
            KioskCustomizationPowerButtonActionsBlocked = $getValue.AdditionalProperties.kioskCustomizationPowerButtonActionsBlocked
            KioskCustomizationStatusBar = $getValue.AdditionalProperties.kioskCustomizationStatusBar
            KioskCustomizationSystemErrorWarnings = $getValue.AdditionalProperties.kioskCustomizationSystemErrorWarnings
            KioskCustomizationSystemNavigation = $getValue.AdditionalProperties.kioskCustomizationSystemNavigation
            KioskModeAppOrderEnabled = $getValue.AdditionalProperties.kioskModeAppOrderEnabled
            KioskModeAppPositions = $getValue.AdditionalProperties.kioskModeAppPositions
            KioskModeApps = $getValue.AdditionalProperties.kioskModeApps
            KioskModeAppsInFolderOrderedByName = $getValue.AdditionalProperties.kioskModeAppsInFolderOrderedByName
            KioskModeBluetoothConfigurationEnabled = $getValue.AdditionalProperties.kioskModeBluetoothConfigurationEnabled
            KioskModeDebugMenuEasyAccessEnabled = $getValue.AdditionalProperties.kioskModeDebugMenuEasyAccessEnabled
            KioskModeExitCode = $getValue.AdditionalProperties.kioskModeExitCode
            KioskModeFlashlightConfigurationEnabled = $getValue.AdditionalProperties.kioskModeFlashlightConfigurationEnabled
            KioskModeFolderIcon = $getValue.AdditionalProperties.kioskModeFolderIcon
            KioskModeGridHeight = $getValue.AdditionalProperties.kioskModeGridHeight
            KioskModeGridWidth = $getValue.AdditionalProperties.kioskModeGridWidth
            KioskModeIconSize = $getValue.AdditionalProperties.kioskModeIconSize
            KioskModeLockHomeScreen = $getValue.AdditionalProperties.kioskModeLockHomeScreen
            KioskModeManagedFolders = $getValue.AdditionalProperties.kioskModeManagedFolders
            KioskModeManagedHomeScreenAutoSignout = $getValue.AdditionalProperties.kioskModeManagedHomeScreenAutoSignout
            KioskModeManagedHomeScreenInactiveSignOutDelayInSeconds = $getValue.AdditionalProperties.kioskModeManagedHomeScreenInactiveSignOutDelayInSeconds
            KioskModeManagedHomeScreenInactiveSignOutNoticeInSeconds = $getValue.AdditionalProperties.kioskModeManagedHomeScreenInactiveSignOutNoticeInSeconds
            KioskModeManagedHomeScreenPinComplexity = $getValue.AdditionalProperties.kioskModeManagedHomeScreenPinComplexity
            KioskModeManagedHomeScreenPinRequired = $getValue.AdditionalProperties.kioskModeManagedHomeScreenPinRequired
            KioskModeManagedHomeScreenPinRequiredToResume = $getValue.AdditionalProperties.kioskModeManagedHomeScreenPinRequiredToResume
            KioskModeManagedHomeScreenSignInBackground = $getValue.AdditionalProperties.kioskModeManagedHomeScreenSignInBackground
            KioskModeManagedHomeScreenSignInBrandingLogo = $getValue.AdditionalProperties.kioskModeManagedHomeScreenSignInBrandingLogo
            KioskModeManagedHomeScreenSignInEnabled = $getValue.AdditionalProperties.kioskModeManagedHomeScreenSignInEnabled
            KioskModeManagedSettingsEntryDisabled = $getValue.AdditionalProperties.kioskModeManagedSettingsEntryDisabled
            KioskModeMediaVolumeConfigurationEnabled = $getValue.AdditionalProperties.kioskModeMediaVolumeConfigurationEnabled
            KioskModeScreenOrientation = $getValue.AdditionalProperties.kioskModeScreenOrientation
            KioskModeScreenSaverConfigurationEnabled = $getValue.AdditionalProperties.kioskModeScreenSaverConfigurationEnabled
            KioskModeScreenSaverDetectMediaDisabled = $getValue.AdditionalProperties.kioskModeScreenSaverDetectMediaDisabled
            KioskModeScreenSaverDisplayTimeInSeconds = $getValue.AdditionalProperties.kioskModeScreenSaverDisplayTimeInSeconds
            KioskModeScreenSaverImageUrl = $getValue.AdditionalProperties.kioskModeScreenSaverImageUrl
            KioskModeScreenSaverStartDelayInSeconds = $getValue.AdditionalProperties.kioskModeScreenSaverStartDelayInSeconds
            KioskModeShowAppNotificationBadge = $getValue.AdditionalProperties.kioskModeShowAppNotificationBadge
            KioskModeShowDeviceInfo = $getValue.AdditionalProperties.kioskModeShowDeviceInfo
            KioskModeVirtualHomeButtonEnabled = $getValue.AdditionalProperties.kioskModeVirtualHomeButtonEnabled
            KioskModeVirtualHomeButtonType = $getValue.AdditionalProperties.kioskModeVirtualHomeButtonType
            KioskModeWallpaperUrl = $getValue.AdditionalProperties.kioskModeWallpaperUrl
            KioskModeWifiAllowedSsids = $getValue.AdditionalProperties.kioskModeWifiAllowedSsids
            KioskModeWiFiConfigurationEnabled = $getValue.AdditionalProperties.kioskModeWiFiConfigurationEnabled
            MicrophoneForceMute = $getValue.AdditionalProperties.microphoneForceMute
            MicrosoftLauncherConfigurationEnabled = $getValue.AdditionalProperties.microsoftLauncherConfigurationEnabled
            MicrosoftLauncherCustomWallpaperAllowUserModification = $getValue.AdditionalProperties.microsoftLauncherCustomWallpaperAllowUserModification
            MicrosoftLauncherCustomWallpaperEnabled = $getValue.AdditionalProperties.microsoftLauncherCustomWallpaperEnabled
            MicrosoftLauncherCustomWallpaperImageUrl = $getValue.AdditionalProperties.microsoftLauncherCustomWallpaperImageUrl
            MicrosoftLauncherDockPresenceAllowUserModification = $getValue.AdditionalProperties.microsoftLauncherDockPresenceAllowUserModification
            MicrosoftLauncherDockPresenceConfiguration = $getValue.AdditionalProperties.microsoftLauncherDockPresenceConfiguration
            MicrosoftLauncherFeedAllowUserModification = $getValue.AdditionalProperties.microsoftLauncherFeedAllowUserModification
            MicrosoftLauncherFeedEnabled = $getValue.AdditionalProperties.microsoftLauncherFeedEnabled
            MicrosoftLauncherSearchBarPlacementConfiguration = $getValue.AdditionalProperties.microsoftLauncherSearchBarPlacementConfiguration
            NetworkEscapeHatchAllowed = $getValue.AdditionalProperties.networkEscapeHatchAllowed
            NfcBlockOutgoingBeam = $getValue.AdditionalProperties.nfcBlockOutgoingBeam
            PasswordBlockKeyguard = $getValue.AdditionalProperties.passwordBlockKeyguard
            PasswordBlockKeyguardFeatures = $getValue.AdditionalProperties.passwordBlockKeyguardFeatures
            PasswordExpirationDays = $getValue.AdditionalProperties.passwordExpirationDays
            PasswordMinimumLength = $getValue.AdditionalProperties.passwordMinimumLength
            PasswordMinimumLetterCharacters = $getValue.AdditionalProperties.passwordMinimumLetterCharacters
            PasswordMinimumLowerCaseCharacters = $getValue.AdditionalProperties.passwordMinimumLowerCaseCharacters
            PasswordMinimumNonLetterCharacters = $getValue.AdditionalProperties.passwordMinimumNonLetterCharacters
            PasswordMinimumNumericCharacters = $getValue.AdditionalProperties.passwordMinimumNumericCharacters
            PasswordMinimumSymbolCharacters = $getValue.AdditionalProperties.passwordMinimumSymbolCharacters
            PasswordMinimumUpperCaseCharacters = $getValue.AdditionalProperties.passwordMinimumUpperCaseCharacters
            PasswordMinutesOfInactivityBeforeScreenTimeout = $getValue.AdditionalProperties.passwordMinutesOfInactivityBeforeScreenTimeout
            PasswordPreviousPasswordCountToBlock = $getValue.AdditionalProperties.passwordPreviousPasswordCountToBlock
            PasswordRequiredType = $getValue.AdditionalProperties.passwordRequiredType
            PasswordSignInFailureCountBeforeFactoryReset = $getValue.AdditionalProperties.passwordSignInFailureCountBeforeFactoryReset
            PersonalProfileAppsAllowInstallFromUnknownSources = $getValue.AdditionalProperties.personalProfileAppsAllowInstallFromUnknownSources
            PersonalProfileCameraBlocked = $getValue.AdditionalProperties.personalProfileCameraBlocked
            PersonalProfilePersonalApplications = $getValue.AdditionalProperties.personalProfilePersonalApplications
            PersonalProfilePlayStoreMode = $getValue.AdditionalProperties.personalProfilePlayStoreMode
            PersonalProfileScreenCaptureBlocked = $getValue.AdditionalProperties.personalProfileScreenCaptureBlocked
            PlayStoreMode = $getValue.AdditionalProperties.playStoreMode
            ScreenCaptureBlocked = $getValue.AdditionalProperties.screenCaptureBlocked
            SecurityDeveloperSettingsEnabled = $getValue.AdditionalProperties.securityDeveloperSettingsEnabled
            SecurityRequireVerifyApps = $getValue.AdditionalProperties.securityRequireVerifyApps
            StatusBarBlocked = $getValue.AdditionalProperties.statusBarBlocked
            StayOnModes = $getValue.AdditionalProperties.stayOnModes
            StorageAllowUsb = $getValue.AdditionalProperties.storageAllowUsb
            StorageBlockExternalMedia = $getValue.AdditionalProperties.storageBlockExternalMedia
            StorageBlockUsbFileTransfer = $getValue.AdditionalProperties.storageBlockUsbFileTransfer
            SystemUpdateFreezePeriods = $getValue.AdditionalProperties.systemUpdateFreezePeriods
            SystemUpdateInstallType = $getValue.AdditionalProperties.systemUpdateInstallType
            SystemUpdateWindowEndMinutesAfterMidnight = $getValue.AdditionalProperties.systemUpdateWindowEndMinutesAfterMidnight
            SystemUpdateWindowStartMinutesAfterMidnight = $getValue.AdditionalProperties.systemUpdateWindowStartMinutesAfterMidnight
            SystemWindowsBlocked = $getValue.AdditionalProperties.systemWindowsBlocked
            UsersBlockAdd = $getValue.AdditionalProperties.usersBlockAdd
            UsersBlockRemove = $getValue.AdditionalProperties.usersBlockRemove
            VolumeBlockAdjustment = $getValue.AdditionalProperties.volumeBlockAdjustment
            VpnAlwaysOnLockdownMode = $getValue.AdditionalProperties.vpnAlwaysOnLockdownMode
            VpnAlwaysOnPackageIdentifier = $getValue.AdditionalProperties.vpnAlwaysOnPackageIdentifier
            WifiBlockEditConfigurations = $getValue.AdditionalProperties.wifiBlockEditConfigurations
            WifiBlockEditPolicyDefinedConfigurations = $getValue.AdditionalProperties.wifiBlockEditPolicyDefinedConfigurations
            WorkProfilePasswordExpirationDays = $getValue.AdditionalProperties.workProfilePasswordExpirationDays
            WorkProfilePasswordMinimumLength = $getValue.AdditionalProperties.workProfilePasswordMinimumLength
            WorkProfilePasswordMinimumLetterCharacters = $getValue.AdditionalProperties.workProfilePasswordMinimumLetterCharacters
            WorkProfilePasswordMinimumLowerCaseCharacters = $getValue.AdditionalProperties.workProfilePasswordMinimumLowerCaseCharacters
            WorkProfilePasswordMinimumNonLetterCharacters = $getValue.AdditionalProperties.workProfilePasswordMinimumNonLetterCharacters
            WorkProfilePasswordMinimumNumericCharacters = $getValue.AdditionalProperties.workProfilePasswordMinimumNumericCharacters
            WorkProfilePasswordMinimumSymbolCharacters = $getValue.AdditionalProperties.workProfilePasswordMinimumSymbolCharacters
            WorkProfilePasswordMinimumUpperCaseCharacters = $getValue.AdditionalProperties.workProfilePasswordMinimumUpperCaseCharacters
            WorkProfilePasswordPreviousPasswordCountToBlock = $getValue.AdditionalProperties.workProfilePasswordPreviousPasswordCountToBlock
            WorkProfilePasswordRequiredType = $getValue.AdditionalProperties.workProfilePasswordRequiredType
            WorkProfilePasswordSignInFailureCountBeforeFactoryReset = $getValue.AdditionalProperties.workProfilePasswordSignInFailureCountBeforeFactoryReset
            Assignments = $getValue.AdditionalProperties.assignments
            DeviceSettingStateSummaries = $getValue.AdditionalProperties.deviceSettingStateSummaries
            DeviceStatuses = $getValue.AdditionalProperties.deviceStatuses
            DeviceStatusOverview = $getValue.AdditionalProperties.deviceStatusOverview
            GroupAssignments = $getValue.AdditionalProperties.groupAssignments
            UserStatuses = $getValue.AdditionalProperties.userStatuses
            UserStatusOverview = $getValue.AdditionalProperties.userStatusOverview


            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
        }

        return [System.Collections.Hashtable] $results
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
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

        #region resource generator code
        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DeviceManagementApplicabilityRuleDeviceMode,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DeviceManagementApplicabilityRuleOsEdition,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DeviceManagementApplicabilityRuleOsVersion,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.Boolean]
        $SupportsScopeTags,

        [Parameter()]
        [System.Int32]
        $Version,

        [Parameter()]
        [System.Boolean]
        $AccountsBlockModification,

        [Parameter()]
        [System.Boolean]
        $AppsAllowInstallFromUnknownSources,

        [Parameter()]
        [System.String[]]
        $AppsAutoUpdatePolicy,

        [Parameter()]
        [System.String[]]
        $AppsDefaultPermissionPolicy,

        [Parameter()]
        [System.Boolean]
        $AppsRecommendSkippingFirstUseHints,

        [Parameter()]
        [System.String[]]
        $AzureAdSharedDeviceDataClearApps,

        [Parameter()]
        [System.Boolean]
        $BluetoothBlockConfiguration,

        [Parameter()]
        [System.Boolean]
        $BluetoothBlockContactSharing,

        [Parameter()]
        [System.Boolean]
        $CameraBlocked,

        [Parameter()]
        [System.Boolean]
        $CellularBlockWiFiTethering,

        [Parameter()]
        [System.Boolean]
        $CertificateCredentialConfigurationDisabled,

        [Parameter()]
        [System.Boolean]
        $CrossProfilePoliciesAllowCopyPaste,

        [Parameter()]
        [System.String[]]
        $CrossProfilePoliciesAllowDataSharing,

        [Parameter()]
        [System.Boolean]
        $CrossProfilePoliciesShowWorkContactsInPersonalProfile,

        [Parameter()]
        [System.Boolean]
        $DataRoamingBlocked,

        [Parameter()]
        [System.Boolean]
        $DateTimeConfigurationBlocked,

        [Parameter()]
        [System.String[]]
        $EnrollmentProfile,

        [Parameter()]
        [System.Boolean]
        $FactoryResetBlocked,

        [Parameter()]
        [System.String[]]
        $FactoryResetDeviceAdministratorEmails,

        [Parameter()]
        [System.String[]]
        $GlobalProxy,

        [Parameter()]
        [System.Boolean]
        $GoogleAccountsBlocked,

        [Parameter()]
        [System.Boolean]
        $KioskCustomizationDeviceSettingsBlocked,

        [Parameter()]
        [System.Boolean]
        $KioskCustomizationPowerButtonActionsBlocked,

        [Parameter()]
        [System.String[]]
        $KioskCustomizationStatusBar,

        [Parameter()]
        [System.Boolean]
        $KioskCustomizationSystemErrorWarnings,

        [Parameter()]
        [System.String[]]
        $KioskCustomizationSystemNavigation,

        [Parameter()]
        [System.Boolean]
        $KioskModeAppOrderEnabled,

        [Parameter()]
        [System.String[]]
        $KioskModeAppPositions,

        [Parameter()]
        [System.String[]]
        $KioskModeApps,

        [Parameter()]
        [System.Boolean]
        $KioskModeAppsInFolderOrderedByName,

        [Parameter()]
        [System.Boolean]
        $KioskModeBluetoothConfigurationEnabled,

        [Parameter()]
        [System.Boolean]
        $KioskModeDebugMenuEasyAccessEnabled,

        [Parameter()]
        [System.String]
        $KioskModeExitCode,

        [Parameter()]
        [System.Boolean]
        $KioskModeFlashlightConfigurationEnabled,

        [Parameter()]
        [System.String[]]
        $KioskModeFolderIcon,

        [Parameter()]
        [System.Int32]
        $KioskModeGridHeight,

        [Parameter()]
        [System.Int32]
        $KioskModeGridWidth,

        [Parameter()]
        [System.String[]]
        $KioskModeIconSize,

        [Parameter()]
        [System.Boolean]
        $KioskModeLockHomeScreen,

        [Parameter()]
        [System.String[]]
        $KioskModeManagedFolders,

        [Parameter()]
        [System.Boolean]
        $KioskModeManagedHomeScreenAutoSignout,

        [Parameter()]
        [System.Int32]
        $KioskModeManagedHomeScreenInactiveSignOutDelayInSeconds,

        [Parameter()]
        [System.Int32]
        $KioskModeManagedHomeScreenInactiveSignOutNoticeInSeconds,

        [Parameter()]
        [System.String[]]
        $KioskModeManagedHomeScreenPinComplexity,

        [Parameter()]
        [System.Boolean]
        $KioskModeManagedHomeScreenPinRequired,

        [Parameter()]
        [System.Boolean]
        $KioskModeManagedHomeScreenPinRequiredToResume,

        [Parameter()]
        [System.String]
        $KioskModeManagedHomeScreenSignInBackground,

        [Parameter()]
        [System.String]
        $KioskModeManagedHomeScreenSignInBrandingLogo,

        [Parameter()]
        [System.Boolean]
        $KioskModeManagedHomeScreenSignInEnabled,

        [Parameter()]
        [System.Boolean]
        $KioskModeManagedSettingsEntryDisabled,

        [Parameter()]
        [System.Boolean]
        $KioskModeMediaVolumeConfigurationEnabled,

        [Parameter()]
        [System.String[]]
        $KioskModeScreenOrientation,

        [Parameter()]
        [System.Boolean]
        $KioskModeScreenSaverConfigurationEnabled,

        [Parameter()]
        [System.Boolean]
        $KioskModeScreenSaverDetectMediaDisabled,

        [Parameter()]
        [System.Int32]
        $KioskModeScreenSaverDisplayTimeInSeconds,

        [Parameter()]
        [System.String]
        $KioskModeScreenSaverImageUrl,

        [Parameter()]
        [System.Int32]
        $KioskModeScreenSaverStartDelayInSeconds,

        [Parameter()]
        [System.Boolean]
        $KioskModeShowAppNotificationBadge,

        [Parameter()]
        [System.Boolean]
        $KioskModeShowDeviceInfo,

        [Parameter()]
        [System.Boolean]
        $KioskModeVirtualHomeButtonEnabled,

        [Parameter()]
        [System.String[]]
        $KioskModeVirtualHomeButtonType,

        [Parameter()]
        [System.String]
        $KioskModeWallpaperUrl,

        [Parameter()]
        [System.String[]]
        $KioskModeWifiAllowedSsids,

        [Parameter()]
        [System.Boolean]
        $KioskModeWiFiConfigurationEnabled,

        [Parameter()]
        [System.Boolean]
        $MicrophoneForceMute,

        [Parameter()]
        [System.Boolean]
        $MicrosoftLauncherConfigurationEnabled,

        [Parameter()]
        [System.Boolean]
        $MicrosoftLauncherCustomWallpaperAllowUserModification,

        [Parameter()]
        [System.Boolean]
        $MicrosoftLauncherCustomWallpaperEnabled,

        [Parameter()]
        [System.String]
        $MicrosoftLauncherCustomWallpaperImageUrl,

        [Parameter()]
        [System.Boolean]
        $MicrosoftLauncherDockPresenceAllowUserModification,

        [Parameter()]
        [System.String[]]
        $MicrosoftLauncherDockPresenceConfiguration,

        [Parameter()]
        [System.Boolean]
        $MicrosoftLauncherFeedAllowUserModification,

        [Parameter()]
        [System.Boolean]
        $MicrosoftLauncherFeedEnabled,

        [Parameter()]
        [System.String[]]
        $MicrosoftLauncherSearchBarPlacementConfiguration,

        [Parameter()]
        [System.Boolean]
        $NetworkEscapeHatchAllowed,

        [Parameter()]
        [System.Boolean]
        $NfcBlockOutgoingBeam,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockKeyguard,

        [Parameter()]
        [System.String[]]
        $PasswordBlockKeyguardFeatures,

        [Parameter()]
        [System.Int32]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLetterCharacters,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLowerCaseCharacters,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumNonLetterCharacters,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumNumericCharacters,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumSymbolCharacters,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumUpperCaseCharacters,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeScreenTimeout,

        [Parameter()]
        [System.Int32]
        $PasswordPreviousPasswordCountToBlock,

        [Parameter()]
        [System.String[]]
        $PasswordRequiredType,

        [Parameter()]
        [System.Int32]
        $PasswordSignInFailureCountBeforeFactoryReset,

        [Parameter()]
        [System.Boolean]
        $PersonalProfileAppsAllowInstallFromUnknownSources,

        [Parameter()]
        [System.Boolean]
        $PersonalProfileCameraBlocked,

        [Parameter()]
        [System.String[]]
        $PersonalProfilePersonalApplications,

        [Parameter()]
        [System.String[]]
        $PersonalProfilePlayStoreMode,

        [Parameter()]
        [System.Boolean]
        $PersonalProfileScreenCaptureBlocked,

        [Parameter()]
        [System.String[]]
        $PlayStoreMode,

        [Parameter()]
        [System.Boolean]
        $ScreenCaptureBlocked,

        [Parameter()]
        [System.Boolean]
        $SecurityDeveloperSettingsEnabled,

        [Parameter()]
        [System.Boolean]
        $SecurityRequireVerifyApps,

        [Parameter()]
        [System.Boolean]
        $StatusBarBlocked,

        [Parameter()]
        [System.String[]]
        $StayOnModes,

        [Parameter()]
        [System.Boolean]
        $StorageAllowUsb,

        [Parameter()]
        [System.Boolean]
        $StorageBlockExternalMedia,

        [Parameter()]
        [System.Boolean]
        $StorageBlockUsbFileTransfer,

        [Parameter()]
        [System.String[]]
        $SystemUpdateFreezePeriods,

        [Parameter()]
        [System.String[]]
        $SystemUpdateInstallType,

        [Parameter()]
        [System.Int32]
        $SystemUpdateWindowEndMinutesAfterMidnight,

        [Parameter()]
        [System.Int32]
        $SystemUpdateWindowStartMinutesAfterMidnight,

        [Parameter()]
        [System.Boolean]
        $SystemWindowsBlocked,

        [Parameter()]
        [System.Boolean]
        $UsersBlockAdd,

        [Parameter()]
        [System.Boolean]
        $UsersBlockRemove,

        [Parameter()]
        [System.Boolean]
        $VolumeBlockAdjustment,

        [Parameter()]
        [System.Boolean]
        $VpnAlwaysOnLockdownMode,

        [Parameter()]
        [System.String]
        $VpnAlwaysOnPackageIdentifier,

        [Parameter()]
        [System.Boolean]
        $WifiBlockEditConfigurations,

        [Parameter()]
        [System.Boolean]
        $WifiBlockEditPolicyDefinedConfigurations,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinimumLetterCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinimumLowerCaseCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinimumNonLetterCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinimumNumericCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinimumSymbolCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinimumUpperCaseCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordPreviousPasswordCountToBlock,

        [Parameter()]
        [System.String[]]
        $WorkProfilePasswordRequiredType,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordSignInFailureCountBeforeFactoryReset,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DeviceSettingStateSummaries,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DeviceStatuses,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DeviceStatusOverview,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $GroupAssignments,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $UserStatuses,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserStatusOverview,


        #endregion

        [Parameter(Mandatory = $true)]
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
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    try
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters `
            -ProfileName 'beta'
        Write-Verbose -Message "2 - There are currently {$((dir function: | measure).Count) functions}"
        Write-Verbose -Message "Here2"
    }
    catch
    {
        Write-Verbose -Message "Reloading2"
    }

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
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

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating {$DisplayName}"
        $CreateParameters = $PSBoundParameters
        $CreateParameters.Remove("Id") | Out-Null

        $AdditionalProperties = Get-M365DSCAdditionalProperties -Properties ([System.Collections.Hashtable]$PSBoundParameters)

        #region resource generator code
        New-MgDeviceManagementDeviceConfiguration @CreateParameters
        #endregion

    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating {$DisplayName}"
        [System.Collections.Hashtable]$UpdateParameters = $PSBoundParameters
        $UpdateParameters.Remove("Id") | Out-Null
        $AdditionalProperties = Get-M365DSCAdditionalProperties -Properties ([System.Collections.Hashtable]$PSBoundParameters)

        $ConvertedParameters = @()
        foreach ($key in $UpdateParameters.Keys)
        {
            if (($UpdateParameters[$key]).GetType().Name -eq 'CimInstance')
            {
                Write-Verbose -Message "Converting complex property {$key} to Hashtable"
                $hashtableValue = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $UpdateParameters[$key]
                $currentParameter = @{
                    Name = $key
                    Value = $hashtableValue
                }
                $ConvertedParameters += $currentParameter
            }
        }

        foreach ($convertedParameter in $ConvertedParameters)
        {
            $UpdateParameters[$convertedParameter.Name] = $convertedParameter.Value
        }
        <#
        if ($AdditionalProperties)
        {
            $UpdateParameters.Add("AdditionalProperties", $AdditionalProperties)
        }#>

        #region resource generator code
        Write-Verbose -Message ($UpdateParameters | Out-String)
        Update-MgDeviceManagementDeviceConfiguration @UpdateParameters `
            -DeviceConfigurationId $currentInstance.Id
        #endregion

    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing {$DisplayName}"


        #region resource generator code
        #endregion



        #region resource generator code
        Remove-MgDeviceManagementDeviceConfiguration -DeviceConfigurationId $currentInstance.Id
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
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DeviceManagementApplicabilityRuleDeviceMode,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DeviceManagementApplicabilityRuleOsEdition,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DeviceManagementApplicabilityRuleOsVersion,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.Boolean]
        $SupportsScopeTags,

        [Parameter()]
        [System.Int32]
        $Version,

        [Parameter()]
        [System.Boolean]
        $AccountsBlockModification,

        [Parameter()]
        [System.Boolean]
        $AppsAllowInstallFromUnknownSources,

        [Parameter()]
        [System.String[]]
        $AppsAutoUpdatePolicy,

        [Parameter()]
        [System.String[]]
        $AppsDefaultPermissionPolicy,

        [Parameter()]
        [System.Boolean]
        $AppsRecommendSkippingFirstUseHints,

        [Parameter()]
        [System.String[]]
        $AzureAdSharedDeviceDataClearApps,

        [Parameter()]
        [System.Boolean]
        $BluetoothBlockConfiguration,

        [Parameter()]
        [System.Boolean]
        $BluetoothBlockContactSharing,

        [Parameter()]
        [System.Boolean]
        $CameraBlocked,

        [Parameter()]
        [System.Boolean]
        $CellularBlockWiFiTethering,

        [Parameter()]
        [System.Boolean]
        $CertificateCredentialConfigurationDisabled,

        [Parameter()]
        [System.Boolean]
        $CrossProfilePoliciesAllowCopyPaste,

        [Parameter()]
        [System.String[]]
        $CrossProfilePoliciesAllowDataSharing,

        [Parameter()]
        [System.Boolean]
        $CrossProfilePoliciesShowWorkContactsInPersonalProfile,

        [Parameter()]
        [System.Boolean]
        $DataRoamingBlocked,

        [Parameter()]
        [System.Boolean]
        $DateTimeConfigurationBlocked,

        [Parameter()]
        [System.String[]]
        $EnrollmentProfile,

        [Parameter()]
        [System.Boolean]
        $FactoryResetBlocked,

        [Parameter()]
        [System.String[]]
        $FactoryResetDeviceAdministratorEmails,

        [Parameter()]
        [System.String[]]
        $GlobalProxy,

        [Parameter()]
        [System.Boolean]
        $GoogleAccountsBlocked,

        [Parameter()]
        [System.Boolean]
        $KioskCustomizationDeviceSettingsBlocked,

        [Parameter()]
        [System.Boolean]
        $KioskCustomizationPowerButtonActionsBlocked,

        [Parameter()]
        [System.String[]]
        $KioskCustomizationStatusBar,

        [Parameter()]
        [System.Boolean]
        $KioskCustomizationSystemErrorWarnings,

        [Parameter()]
        [System.String[]]
        $KioskCustomizationSystemNavigation,

        [Parameter()]
        [System.Boolean]
        $KioskModeAppOrderEnabled,

        [Parameter()]
        [System.String[]]
        $KioskModeAppPositions,

        [Parameter()]
        [System.String[]]
        $KioskModeApps,

        [Parameter()]
        [System.Boolean]
        $KioskModeAppsInFolderOrderedByName,

        [Parameter()]
        [System.Boolean]
        $KioskModeBluetoothConfigurationEnabled,

        [Parameter()]
        [System.Boolean]
        $KioskModeDebugMenuEasyAccessEnabled,

        [Parameter()]
        [System.String]
        $KioskModeExitCode,

        [Parameter()]
        [System.Boolean]
        $KioskModeFlashlightConfigurationEnabled,

        [Parameter()]
        [System.String[]]
        $KioskModeFolderIcon,

        [Parameter()]
        [System.Int32]
        $KioskModeGridHeight,

        [Parameter()]
        [System.Int32]
        $KioskModeGridWidth,

        [Parameter()]
        [System.String[]]
        $KioskModeIconSize,

        [Parameter()]
        [System.Boolean]
        $KioskModeLockHomeScreen,

        [Parameter()]
        [System.String[]]
        $KioskModeManagedFolders,

        [Parameter()]
        [System.Boolean]
        $KioskModeManagedHomeScreenAutoSignout,

        [Parameter()]
        [System.Int32]
        $KioskModeManagedHomeScreenInactiveSignOutDelayInSeconds,

        [Parameter()]
        [System.Int32]
        $KioskModeManagedHomeScreenInactiveSignOutNoticeInSeconds,

        [Parameter()]
        [System.String[]]
        $KioskModeManagedHomeScreenPinComplexity,

        [Parameter()]
        [System.Boolean]
        $KioskModeManagedHomeScreenPinRequired,

        [Parameter()]
        [System.Boolean]
        $KioskModeManagedHomeScreenPinRequiredToResume,

        [Parameter()]
        [System.String]
        $KioskModeManagedHomeScreenSignInBackground,

        [Parameter()]
        [System.String]
        $KioskModeManagedHomeScreenSignInBrandingLogo,

        [Parameter()]
        [System.Boolean]
        $KioskModeManagedHomeScreenSignInEnabled,

        [Parameter()]
        [System.Boolean]
        $KioskModeManagedSettingsEntryDisabled,

        [Parameter()]
        [System.Boolean]
        $KioskModeMediaVolumeConfigurationEnabled,

        [Parameter()]
        [System.String[]]
        $KioskModeScreenOrientation,

        [Parameter()]
        [System.Boolean]
        $KioskModeScreenSaverConfigurationEnabled,

        [Parameter()]
        [System.Boolean]
        $KioskModeScreenSaverDetectMediaDisabled,

        [Parameter()]
        [System.Int32]
        $KioskModeScreenSaverDisplayTimeInSeconds,

        [Parameter()]
        [System.String]
        $KioskModeScreenSaverImageUrl,

        [Parameter()]
        [System.Int32]
        $KioskModeScreenSaverStartDelayInSeconds,

        [Parameter()]
        [System.Boolean]
        $KioskModeShowAppNotificationBadge,

        [Parameter()]
        [System.Boolean]
        $KioskModeShowDeviceInfo,

        [Parameter()]
        [System.Boolean]
        $KioskModeVirtualHomeButtonEnabled,

        [Parameter()]
        [System.String[]]
        $KioskModeVirtualHomeButtonType,

        [Parameter()]
        [System.String]
        $KioskModeWallpaperUrl,

        [Parameter()]
        [System.String[]]
        $KioskModeWifiAllowedSsids,

        [Parameter()]
        [System.Boolean]
        $KioskModeWiFiConfigurationEnabled,

        [Parameter()]
        [System.Boolean]
        $MicrophoneForceMute,

        [Parameter()]
        [System.Boolean]
        $MicrosoftLauncherConfigurationEnabled,

        [Parameter()]
        [System.Boolean]
        $MicrosoftLauncherCustomWallpaperAllowUserModification,

        [Parameter()]
        [System.Boolean]
        $MicrosoftLauncherCustomWallpaperEnabled,

        [Parameter()]
        [System.String]
        $MicrosoftLauncherCustomWallpaperImageUrl,

        [Parameter()]
        [System.Boolean]
        $MicrosoftLauncherDockPresenceAllowUserModification,

        [Parameter()]
        [System.String[]]
        $MicrosoftLauncherDockPresenceConfiguration,

        [Parameter()]
        [System.Boolean]
        $MicrosoftLauncherFeedAllowUserModification,

        [Parameter()]
        [System.Boolean]
        $MicrosoftLauncherFeedEnabled,

        [Parameter()]
        [System.String[]]
        $MicrosoftLauncherSearchBarPlacementConfiguration,

        [Parameter()]
        [System.Boolean]
        $NetworkEscapeHatchAllowed,

        [Parameter()]
        [System.Boolean]
        $NfcBlockOutgoingBeam,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockKeyguard,

        [Parameter()]
        [System.String[]]
        $PasswordBlockKeyguardFeatures,

        [Parameter()]
        [System.Int32]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLetterCharacters,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLowerCaseCharacters,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumNonLetterCharacters,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumNumericCharacters,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumSymbolCharacters,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumUpperCaseCharacters,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeScreenTimeout,

        [Parameter()]
        [System.Int32]
        $PasswordPreviousPasswordCountToBlock,

        [Parameter()]
        [System.String[]]
        $PasswordRequiredType,

        [Parameter()]
        [System.Int32]
        $PasswordSignInFailureCountBeforeFactoryReset,

        [Parameter()]
        [System.Boolean]
        $PersonalProfileAppsAllowInstallFromUnknownSources,

        [Parameter()]
        [System.Boolean]
        $PersonalProfileCameraBlocked,

        [Parameter()]
        [System.String[]]
        $PersonalProfilePersonalApplications,

        [Parameter()]
        [System.String[]]
        $PersonalProfilePlayStoreMode,

        [Parameter()]
        [System.Boolean]
        $PersonalProfileScreenCaptureBlocked,

        [Parameter()]
        [System.String[]]
        $PlayStoreMode,

        [Parameter()]
        [System.Boolean]
        $ScreenCaptureBlocked,

        [Parameter()]
        [System.Boolean]
        $SecurityDeveloperSettingsEnabled,

        [Parameter()]
        [System.Boolean]
        $SecurityRequireVerifyApps,

        [Parameter()]
        [System.Boolean]
        $StatusBarBlocked,

        [Parameter()]
        [System.String[]]
        $StayOnModes,

        [Parameter()]
        [System.Boolean]
        $StorageAllowUsb,

        [Parameter()]
        [System.Boolean]
        $StorageBlockExternalMedia,

        [Parameter()]
        [System.Boolean]
        $StorageBlockUsbFileTransfer,

        [Parameter()]
        [System.String[]]
        $SystemUpdateFreezePeriods,

        [Parameter()]
        [System.String[]]
        $SystemUpdateInstallType,

        [Parameter()]
        [System.Int32]
        $SystemUpdateWindowEndMinutesAfterMidnight,

        [Parameter()]
        [System.Int32]
        $SystemUpdateWindowStartMinutesAfterMidnight,

        [Parameter()]
        [System.Boolean]
        $SystemWindowsBlocked,

        [Parameter()]
        [System.Boolean]
        $UsersBlockAdd,

        [Parameter()]
        [System.Boolean]
        $UsersBlockRemove,

        [Parameter()]
        [System.Boolean]
        $VolumeBlockAdjustment,

        [Parameter()]
        [System.Boolean]
        $VpnAlwaysOnLockdownMode,

        [Parameter()]
        [System.String]
        $VpnAlwaysOnPackageIdentifier,

        [Parameter()]
        [System.Boolean]
        $WifiBlockEditConfigurations,

        [Parameter()]
        [System.Boolean]
        $WifiBlockEditPolicyDefinedConfigurations,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinimumLetterCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinimumLowerCaseCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinimumNonLetterCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinimumNumericCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinimumSymbolCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinimumUpperCaseCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordPreviousPasswordCountToBlock,

        [Parameter()]
        [System.String[]]
        $WorkProfilePasswordRequiredType,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordSignInFailureCountBeforeFactoryReset,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DeviceSettingStateSummaries,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DeviceStatuses,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DeviceStatusOverview,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $GroupAssignments,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $UserStatuses,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserStatusOverview,


        #endregion

        [Parameter(Mandatory = $true)]
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
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of {$DisplayName}"

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
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters `
        -ProfileName 'beta'

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        #region resource generator code
        [array]$getValue = Get-MgDeviceManagementDeviceConfiguration `
            -ErrorAction Stop -All:$true -Filter $Filter | Where-Object `
            -FilterScript {
                $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.androidDeviceOwnerGeneralDeviceConfiguration'
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
            Write-Host "    |---[$i/$($getValue.Count)] $($config.displayName)" -NoNewline
            $params = @{
                DisplayName           = $config.DisplayName
                Ensure                = 'Present'
                Credential            = $Credential
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
        Write-Host $Global:M365DSCEmojiGreenCheckMark
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
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


function Get-M365DSCDRGComplexTypeToHashtable
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.Object]
        $ComplexObject
    )

    $keys = $ComplexObject | Get-Member | Where-Object -FilterScript {$_.MemberType -eq 'Property' -and $_.Name -ne 'AdditionalProperties'}
    $results = @{}
    foreach ($key in $keys)
    {
        $results.Add($key.Name, $ComplexObject.$($key.Name))
    }
    return $results
}

function Get-M365DSCDRGComplexTypeToString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $ComplexObject,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CIMInstanceName
    )
    if ($null -eq $ComplexObject)
    {
        return $null
    }
    $currentProperty = "MSFT_$CIMInstanceName{`r`n"
    $keyNotNull = 0
    foreach ($key in $ComplexObject.Keys)
    {
        if ($ComplexObject[$key])
        {
            $keyNotNull++

            if ($ComplexObject[$key].GetType().Name -eq 'Boolean')
            {
                $currentProperty += "                " + $key + " = `$" + $ComplexObject[$key].ToString() + "`r`n"
            }
            else
            {
                $currentProperty += "                " + $key + " = '" + $ComplexObject[$key] + "'`r`n"
            }
        }
    }
    $currentProperty += "            }"

    if ($keyNotNull -eq 0)
    {
        $currentProperty = $null
    }
    return $currentProperty
}

function Get-M365DSCAdditionalProperties
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $Properties
    )

    $results = @{"@odata.type" = "#microsoft.graph.androidDeviceOwnerGeneralDeviceConfiguration" }
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
