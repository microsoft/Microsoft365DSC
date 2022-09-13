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
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $AccountsBlockModification,

        [Parameter()]
        [System.Boolean]
        $AppsAllowInstallFromUnknownSources,

        [Parameter()]
        [ValidateSet('notConfigured','userChoice','never','wiFiOnly','always')]
        [System.String]
        $AppsAutoUpdatePolicy,

        [Parameter()]
        [ValidateSet('deviceDefault','prompt','autoGrant','autoDeny')]
        [System.String]
        $AppsDefaultPermissionPolicy,

        [Parameter()]
        [System.Boolean]
        $AppsRecommendSkippingFirstUseHints,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
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
        [ValidateSet('notConfigured','crossProfileDataSharingBlocked','dataSharingFromWorkToPersonalBlocked','crossProfileDataSharingAllowed','unkownFutureValue')]
        [System.String]
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
        [Microsoft.Management.Infrastructure.CimInstance]
        $DetailedHelpText,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DeviceOwnerLockScreenMessage,

        [Parameter()]
        [ValidateSet('notConfigured','dedicatedDevice','fullyManaged')]
        [System.String]
        $EnrollmentProfile,

        [Parameter()]
        [System.Boolean]
        $FactoryResetBlocked,

        [Parameter()]
        [System.String[]]
        $FactoryResetDeviceAdministratorEmails,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
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
        [ValidateSet('notConfigured','notificationsAndSystemInfoEnabled','systemInfoOnly')]
        [System.String]
        $KioskCustomizationStatusBar,

        [Parameter()]
        [System.Boolean]
        $KioskCustomizationSystemErrorWarnings,

        [Parameter()]
        [ValidateSet('notConfigured','navigationEnabled','homeButtonOnly')]
        [System.String]
        $KioskCustomizationSystemNavigation,

        [Parameter()]
        [System.Boolean]
        $KioskModeAppOrderEnabled,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $KioskModeAppPositions,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
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
        [ValidateSet('notConfigured','darkSquare','darkCircle','lightSquare','lightCircle')]
        [System.String]
        $KioskModeFolderIcon,

        [Parameter()]
        [System.Int32]
        $KioskModeGridHeight,

        [Parameter()]
        [System.Int32]
        $KioskModeGridWidth,

        [Parameter()]
        [ValidateSet('notConfigured','smallest','small','regular','large','largest')]
        [System.String]
        $KioskModeIconSize,

        [Parameter()]
        [System.Boolean]
        $KioskModeLockHomeScreen,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
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
        [ValidateSet('notConfigured','simple','complex')]
        [System.String]
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
        [ValidateSet('notConfigured','portrait','landscape','autoRotate')]
        [System.String]
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
        [ValidateSet('notConfigured','singleAppMode','multiAppMode')]
        [System.String]
        $KioskModeUseManagedHomeScreenApp,

        [Parameter()]
        [System.Boolean]
        $KioskModeVirtualHomeButtonEnabled,

        [Parameter()]
        [ValidateSet('notConfigured','swipeUp','floating')]
        [System.String]
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
        [ValidateSet('notConfigured','show','hide','disabled')]
        [System.String]
        $MicrosoftLauncherDockPresenceConfiguration,

        [Parameter()]
        [System.Boolean]
        $MicrosoftLauncherFeedAllowUserModification,

        [Parameter()]
        [System.Boolean]
        $MicrosoftLauncherFeedEnabled,

        [Parameter()]
        [ValidateSet('notConfigured','top','bottom','hide')]
        [System.String]
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
        [ValidateSet('notConfigured','camera','notifications','unredactedNotifications','trustAgents','fingerprint','remoteInput','allFeatures','face','iris','biometrics')]
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
        [ValidateSet('deviceDefault','required','numeric','numericComplex','alphabetic','alphanumeric','alphanumericWithSymbols','lowSecurityBiometric','customPassword')]
        [System.String]
        $PasswordRequiredType,

        [Parameter()]
        [ValidateSet('deviceDefault','daily','unkownFutureValue')]
        [System.String]
        $PasswordRequireUnlock,

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
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $PersonalProfilePersonalApplications,

        [Parameter()]
        [ValidateSet('notConfigured','blockedApps','allowedApps')]
        [System.String]
        $PersonalProfilePlayStoreMode,

        [Parameter()]
        [System.Boolean]
        $PersonalProfileScreenCaptureBlocked,

        [Parameter()]
        [ValidateSet('notConfigured','allowList','blockList')]
        [System.String]
        $PlayStoreMode,

        [Parameter()]
        [System.Boolean]
        $ScreenCaptureBlocked,

        [Parameter()]
        [System.Boolean]
        $SecurityCommonCriteriaModeEnabled,

        [Parameter()]
        [System.Boolean]
        $SecurityDeveloperSettingsEnabled,

        [Parameter()]
        [System.Boolean]
        $SecurityRequireVerifyApps,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ShortHelpText,

        [Parameter()]
        [System.Boolean]
        $StatusBarBlocked,

        [Parameter()]
        [ValidateSet('notConfigured','ac','usb','wireless')]
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
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $SystemUpdateFreezePeriods,

        [Parameter()]
        [ValidateSet('deviceDefault','postpone','windowed','automatic')]
        [System.String]
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
        [ValidateSet('deviceDefault','required','numeric','numericComplex','alphabetic','alphanumeric','alphanumericWithSymbols','lowSecurityBiometric','customPassword')]
        [System.String]
        $WorkProfilePasswordRequiredType,

        [Parameter()]
        [ValidateSet('deviceDefault','daily','unkownFutureValue')]
        [System.String]
        $WorkProfilePasswordRequireUnlock,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordSignInFailureCountBeforeFactoryReset,


        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

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
    }
    catch
    {
        Write-Verbose -Message "Connection to the workload failed."
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
        $getValue=$null

        #region resource generator code
        if(-Not [string]::IsNullOrEmpty($DisplayName))
        {
            $getValue = Get-MgDeviceManagementDeviceConfiguration `
                -ErrorAction Stop | Where-Object `
                -FilterScript { `
                    $_.DisplayName -eq "$($DisplayName)" `
                }
        }

        if (-not $getValue)
        {
            [array]$getValue = Get-MgDeviceManagementDeviceConfiguration `
                -ErrorAction Stop | Where-Object `
            -FilterScript { `
                $_.id -eq $id `
            }
        }
        #endregion


        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Nothing with id {$id} was found"
            return $nullResult
        }

        Write-Verbose -Message "Found something with id {$id}"
        $results = @{

            #region resource generator code
            Id = $getValue.Id
            Description = $getValue.Description
            DisplayName = $getValue.DisplayName
            AccountsBlockModification = $getValue.AdditionalProperties.accountsBlockModification
            AppsAllowInstallFromUnknownSources = $getValue.AdditionalProperties.appsAllowInstallFromUnknownSources
            AppsAutoUpdatePolicy = $getValue.AdditionalProperties.appsAutoUpdatePolicy
            AppsDefaultPermissionPolicy = $getValue.AdditionalProperties.appsDefaultPermissionPolicy
            AppsRecommendSkippingFirstUseHints = $getValue.AdditionalProperties.appsRecommendSkippingFirstUseHints
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
            GoogleAccountsBlocked = $getValue.AdditionalProperties.googleAccountsBlocked
            KioskCustomizationDeviceSettingsBlocked = $getValue.AdditionalProperties.kioskCustomizationDeviceSettingsBlocked
            KioskCustomizationPowerButtonActionsBlocked = $getValue.AdditionalProperties.kioskCustomizationPowerButtonActionsBlocked
            KioskCustomizationStatusBar = $getValue.AdditionalProperties.kioskCustomizationStatusBar
            KioskCustomizationSystemErrorWarnings = $getValue.AdditionalProperties.kioskCustomizationSystemErrorWarnings
            KioskCustomizationSystemNavigation = $getValue.AdditionalProperties.kioskCustomizationSystemNavigation
            KioskModeAppOrderEnabled = $getValue.AdditionalProperties.kioskModeAppOrderEnabled
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
            KioskModeUseManagedHomeScreenApp = $getValue.AdditionalProperties.kioskModeUseManagedHomeScreenApp
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
            PasswordRequireUnlock = $getValue.AdditionalProperties.passwordRequireUnlock
            PasswordSignInFailureCountBeforeFactoryReset = $getValue.AdditionalProperties.passwordSignInFailureCountBeforeFactoryReset
            PersonalProfileAppsAllowInstallFromUnknownSources = $getValue.AdditionalProperties.personalProfileAppsAllowInstallFromUnknownSources
            PersonalProfileCameraBlocked = $getValue.AdditionalProperties.personalProfileCameraBlocked
            PersonalProfilePlayStoreMode = $getValue.AdditionalProperties.personalProfilePlayStoreMode
            PersonalProfileScreenCaptureBlocked = $getValue.AdditionalProperties.personalProfileScreenCaptureBlocked
            PlayStoreMode = $getValue.AdditionalProperties.playStoreMode
            ScreenCaptureBlocked = $getValue.AdditionalProperties.screenCaptureBlocked
            SecurityCommonCriteriaModeEnabled = $getValue.AdditionalProperties.securityCommonCriteriaModeEnabled
            SecurityDeveloperSettingsEnabled = $getValue.AdditionalProperties.securityDeveloperSettingsEnabled
            SecurityRequireVerifyApps = $getValue.AdditionalProperties.securityRequireVerifyApps
            StatusBarBlocked = $getValue.AdditionalProperties.statusBarBlocked
            StayOnModes = $getValue.AdditionalProperties.stayOnModes
            StorageAllowUsb = $getValue.AdditionalProperties.storageAllowUsb
            StorageBlockExternalMedia = $getValue.AdditionalProperties.storageBlockExternalMedia
            StorageBlockUsbFileTransfer = $getValue.AdditionalProperties.storageBlockUsbFileTransfer
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
            WorkProfilePasswordRequireUnlock = $getValue.AdditionalProperties.workProfilePasswordRequireUnlock
            WorkProfilePasswordSignInFailureCountBeforeFactoryReset = $getValue.AdditionalProperties.workProfilePasswordSignInFailureCountBeforeFactoryReset


            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
        }
        if ($getValue.additionalProperties.azureAdSharedDeviceDataClearApps)
        {
            $results.Add("AzureAdSharedDeviceDataClearApps", $getValue.additionalProperties.azureAdSharedDeviceDataClearApps)
        }
        if ($getValue.additionalProperties.detailedHelpText)
        {
            $results.Add("DetailedHelpText", $getValue.additionalProperties.detailedHelpText)
        }
        if ($getValue.additionalProperties.deviceOwnerLockScreenMessage)
        {
            $results.Add("DeviceOwnerLockScreenMessage", $getValue.additionalProperties.deviceOwnerLockScreenMessage)
        }
        if ($getValue.additionalProperties.globalProxy)
        {
            $results.Add("GlobalProxy", $getValue.additionalProperties.globalProxy)
        }
        if ($getValue.additionalProperties.kioskModeAppPositions)
        {
            $results.Add("KioskModeAppPositions", $getValue.additionalProperties.kioskModeAppPositions)
        }
        if ($getValue.additionalProperties.kioskModeApps)
        {
            $results.Add("KioskModeApps", $getValue.additionalProperties.kioskModeApps)
        }
        if ($getValue.additionalProperties.kioskModeManagedFolders)
        {
            $results.Add("KioskModeManagedFolders", $getValue.additionalProperties.kioskModeManagedFolders)
        }
        if ($getValue.additionalProperties.personalProfilePersonalApplications)
        {
            $results.Add("PersonalProfilePersonalApplications", $getValue.additionalProperties.personalProfilePersonalApplications)
        }
        if ($getValue.additionalProperties.shortHelpText)
        {
            $results.Add("ShortHelpText", $getValue.additionalProperties.shortHelpText)
        }
        if ($getValue.additionalProperties.systemUpdateFreezePeriods)
        {
            $results.Add("SystemUpdateFreezePeriods", $getValue.additionalProperties.systemUpdateFreezePeriods)
        }

        $myAssignments=@()
        $myAssignments+=Get-MgDeviceManagementDeviceConfigurationAssignment -DeviceConfigurationId  $getValue.Id
        $assignmentResult = @()
        foreach ($assignmentEntry in $myAssignments)
        {
            $assignmentValue = @{
                dataType = $assignmentEntry.Target.AdditionalProperties.'@odata.type'
                deviceAndAppManagementAssignmentFilterType = $assignmentEntry.Target.DeviceAndAppManagementAssignmentFilterType.toString()
                deviceAndAppManagementAssignmentFilterId = $assignmentEntry.Target.DeviceAndAppManagementAssignmentFilterId
                groupId = $assignmentEntry.Target.AdditionalProperties.groupId
            }
            $assignmentResult += $assignmentValue
        }
        $results.Add('Assignments',$assignmentResult)

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
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $AccountsBlockModification,

        [Parameter()]
        [System.Boolean]
        $AppsAllowInstallFromUnknownSources,

        [Parameter()]
        [ValidateSet('notConfigured','userChoice','never','wiFiOnly','always')]
        [System.String]
        $AppsAutoUpdatePolicy,

        [Parameter()]
        [ValidateSet('deviceDefault','prompt','autoGrant','autoDeny')]
        [System.String]
        $AppsDefaultPermissionPolicy,

        [Parameter()]
        [System.Boolean]
        $AppsRecommendSkippingFirstUseHints,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
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
        [ValidateSet('notConfigured','crossProfileDataSharingBlocked','dataSharingFromWorkToPersonalBlocked','crossProfileDataSharingAllowed','unkownFutureValue')]
        [System.String]
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
        [Microsoft.Management.Infrastructure.CimInstance]
        $DetailedHelpText,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DeviceOwnerLockScreenMessage,

        [Parameter()]
        [ValidateSet('notConfigured','dedicatedDevice','fullyManaged')]
        [System.String]
        $EnrollmentProfile,

        [Parameter()]
        [System.Boolean]
        $FactoryResetBlocked,

        [Parameter()]
        [System.String[]]
        $FactoryResetDeviceAdministratorEmails,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
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
        [ValidateSet('notConfigured','notificationsAndSystemInfoEnabled','systemInfoOnly')]
        [System.String]
        $KioskCustomizationStatusBar,

        [Parameter()]
        [System.Boolean]
        $KioskCustomizationSystemErrorWarnings,

        [Parameter()]
        [ValidateSet('notConfigured','navigationEnabled','homeButtonOnly')]
        [System.String]
        $KioskCustomizationSystemNavigation,

        [Parameter()]
        [System.Boolean]
        $KioskModeAppOrderEnabled,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $KioskModeAppPositions,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
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
        [ValidateSet('notConfigured','darkSquare','darkCircle','lightSquare','lightCircle')]
        [System.String]
        $KioskModeFolderIcon,

        [Parameter()]
        [System.Int32]
        $KioskModeGridHeight,

        [Parameter()]
        [System.Int32]
        $KioskModeGridWidth,

        [Parameter()]
        [ValidateSet('notConfigured','smallest','small','regular','large','largest')]
        [System.String]
        $KioskModeIconSize,

        [Parameter()]
        [System.Boolean]
        $KioskModeLockHomeScreen,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
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
        [ValidateSet('notConfigured','simple','complex')]
        [System.String]
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
        [ValidateSet('notConfigured','portrait','landscape','autoRotate')]
        [System.String]
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
        [ValidateSet('notConfigured','singleAppMode','multiAppMode')]
        [System.String]
        $KioskModeUseManagedHomeScreenApp,

        [Parameter()]
        [System.Boolean]
        $KioskModeVirtualHomeButtonEnabled,

        [Parameter()]
        [ValidateSet('notConfigured','swipeUp','floating')]
        [System.String]
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
        [ValidateSet('notConfigured','show','hide','disabled')]
        [System.String]
        $MicrosoftLauncherDockPresenceConfiguration,

        [Parameter()]
        [System.Boolean]
        $MicrosoftLauncherFeedAllowUserModification,

        [Parameter()]
        [System.Boolean]
        $MicrosoftLauncherFeedEnabled,

        [Parameter()]
        [ValidateSet('notConfigured','top','bottom','hide')]
        [System.String]
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
        [ValidateSet('notConfigured','camera','notifications','unredactedNotifications','trustAgents','fingerprint','remoteInput','allFeatures','face','iris','biometrics')]
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
        [ValidateSet('deviceDefault','required','numeric','numericComplex','alphabetic','alphanumeric','alphanumericWithSymbols','lowSecurityBiometric','customPassword')]
        [System.String]
        $PasswordRequiredType,

        [Parameter()]
        [ValidateSet('deviceDefault','daily','unkownFutureValue')]
        [System.String]
        $PasswordRequireUnlock,

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
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $PersonalProfilePersonalApplications,

        [Parameter()]
        [ValidateSet('notConfigured','blockedApps','allowedApps')]
        [System.String]
        $PersonalProfilePlayStoreMode,

        [Parameter()]
        [System.Boolean]
        $PersonalProfileScreenCaptureBlocked,

        [Parameter()]
        [ValidateSet('notConfigured','allowList','blockList')]
        [System.String]
        $PlayStoreMode,

        [Parameter()]
        [System.Boolean]
        $ScreenCaptureBlocked,

        [Parameter()]
        [System.Boolean]
        $SecurityCommonCriteriaModeEnabled,

        [Parameter()]
        [System.Boolean]
        $SecurityDeveloperSettingsEnabled,

        [Parameter()]
        [System.Boolean]
        $SecurityRequireVerifyApps,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ShortHelpText,

        [Parameter()]
        [System.Boolean]
        $StatusBarBlocked,

        [Parameter()]
        [ValidateSet('notConfigured','ac','usb','wireless')]
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
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $SystemUpdateFreezePeriods,

        [Parameter()]
        [ValidateSet('deviceDefault','postpone','windowed','automatic')]
        [System.String]
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
        [ValidateSet('deviceDefault','required','numeric','numericComplex','alphabetic','alphanumeric','alphanumericWithSymbols','lowSecurityBiometric','customPassword')]
        [System.String]
        $WorkProfilePasswordRequiredType,

        [Parameter()]
        [ValidateSet('deviceDefault','daily','unkownFutureValue')]
        [System.String]
        $WorkProfilePasswordRequireUnlock,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordSignInFailureCountBeforeFactoryReset,


        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

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
            -ProfileName 'v1.0'
        $context=Get-MgContext
        if($null -eq $context)
        {
            $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
                -InboundParameters $PSBoundParameters -ProfileName 'beta'
        }
        Select-MgProfile 'beta' -ErrorAction Stop
    }
    catch
    {
        Write-Verbose -Message $_
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
    $PSBoundParameters.Remove('CertificateThumbprint') | Out-Null


    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating {$DisplayName}"
        $PSBoundParameters.Remove("Assignments") | Out-Null

        $CreateParameters = ([Hashtable]$PSBoundParameters).clone()
        $CreateParameters=Rename-M365DSCCimInstanceODataParameter -Properties $CreateParameters

        $AdditionalProperties = Get-M365DSCAdditionalProperties -Properties ($CreateParameters)
        foreach($key in $AdditionalProperties.keys)
        {
            if($key -ne '@odata.type')
            {
                $keyName=$key.substring(0,1).ToUpper()+$key.substring(1,$key.length-1)
                $CreateParameters.remove($keyName)
            }
        }

        $CreateParameters.Remove("Id") | Out-Null
        $CreateParameters.Remove("Verbose") | Out-Null

        foreach($key in ($CreateParameters.clone()).Keys)
        {
            if($CreateParameters[$key].getType().Fullname -like "*CimInstance*")
            {
                $CreateParameters[$key]=Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $CreateParameters[$key]
            }
        }

        if($AdditionalProperties)
        {
            $CreateParameters.add('AdditionalProperties',$AdditionalProperties)
        }


        #region resource generator code
        $policy=New-MgDeviceManagementDeviceConfiguration @CreateParameters
        $assignmentsHash=@()
        foreach($assignment in $Assignments)
        {
            $assignmentsHash+=Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignment
        }

        if($policy.id)        {
            Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $policy.id `
                -Targets $assignmentsHash
        }

        #endregion

    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating {$DisplayName}"
        $PSBoundParameters.Remove("Assignments") | Out-Null

        $UpdateParameters = ([Hashtable]$PSBoundParameters).clone()
        $UpdateParameters=Rename-M365DSCCimInstanceODataParameter -Properties $UpdateParameters

        $AdditionalProperties = Get-M365DSCAdditionalProperties -Properties ($UpdateParameters)
        foreach($key in $AdditionalProperties.keys)
        {
            if($key -ne '@odata.type')
            {
                $keyName=$key.substring(0,1).ToUpper()+$key.substring(1,$key.length-1)
                $UpdateParameters.remove($keyName)
            }
        }

        $UpdateParameters.Remove("Id") | Out-Null
        $UpdateParameters.Remove("Verbose") | Out-Null

        foreach($key in ($UpdateParameters.clone()).Keys)
        {
            if($UpdateParameters[$key].getType().Fullname -like "*CimInstance*")
            {
                $UpdateParameters[$key]=Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $UpdateParameters[$key]
            }
        }

        if($AdditionalProperties)
        {
            $UpdateParameters.add('AdditionalProperties',$AdditionalProperties)
        }


        #region resource generator code
        Update-MgDeviceManagementDeviceConfiguration @UpdateParameters `
            -DeviceConfigurationId $currentInstance.Id
        $assignmentsHash=@()
        foreach($assignment in $Assignments)
        {
            $assignmentsHash+=Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignment
        }
        Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $currentInstance.id `
            -Targets $assignmentsHash

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
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $AccountsBlockModification,

        [Parameter()]
        [System.Boolean]
        $AppsAllowInstallFromUnknownSources,

        [Parameter()]
        [ValidateSet('notConfigured','userChoice','never','wiFiOnly','always')]
        [System.String]
        $AppsAutoUpdatePolicy,

        [Parameter()]
        [ValidateSet('deviceDefault','prompt','autoGrant','autoDeny')]
        [System.String]
        $AppsDefaultPermissionPolicy,

        [Parameter()]
        [System.Boolean]
        $AppsRecommendSkippingFirstUseHints,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
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
        [ValidateSet('notConfigured','crossProfileDataSharingBlocked','dataSharingFromWorkToPersonalBlocked','crossProfileDataSharingAllowed','unkownFutureValue')]
        [System.String]
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
        [Microsoft.Management.Infrastructure.CimInstance]
        $DetailedHelpText,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DeviceOwnerLockScreenMessage,

        [Parameter()]
        [ValidateSet('notConfigured','dedicatedDevice','fullyManaged')]
        [System.String]
        $EnrollmentProfile,

        [Parameter()]
        [System.Boolean]
        $FactoryResetBlocked,

        [Parameter()]
        [System.String[]]
        $FactoryResetDeviceAdministratorEmails,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
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
        [ValidateSet('notConfigured','notificationsAndSystemInfoEnabled','systemInfoOnly')]
        [System.String]
        $KioskCustomizationStatusBar,

        [Parameter()]
        [System.Boolean]
        $KioskCustomizationSystemErrorWarnings,

        [Parameter()]
        [ValidateSet('notConfigured','navigationEnabled','homeButtonOnly')]
        [System.String]
        $KioskCustomizationSystemNavigation,

        [Parameter()]
        [System.Boolean]
        $KioskModeAppOrderEnabled,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $KioskModeAppPositions,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
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
        [ValidateSet('notConfigured','darkSquare','darkCircle','lightSquare','lightCircle')]
        [System.String]
        $KioskModeFolderIcon,

        [Parameter()]
        [System.Int32]
        $KioskModeGridHeight,

        [Parameter()]
        [System.Int32]
        $KioskModeGridWidth,

        [Parameter()]
        [ValidateSet('notConfigured','smallest','small','regular','large','largest')]
        [System.String]
        $KioskModeIconSize,

        [Parameter()]
        [System.Boolean]
        $KioskModeLockHomeScreen,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
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
        [ValidateSet('notConfigured','simple','complex')]
        [System.String]
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
        [ValidateSet('notConfigured','portrait','landscape','autoRotate')]
        [System.String]
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
        [ValidateSet('notConfigured','singleAppMode','multiAppMode')]
        [System.String]
        $KioskModeUseManagedHomeScreenApp,

        [Parameter()]
        [System.Boolean]
        $KioskModeVirtualHomeButtonEnabled,

        [Parameter()]
        [ValidateSet('notConfigured','swipeUp','floating')]
        [System.String]
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
        [ValidateSet('notConfigured','show','hide','disabled')]
        [System.String]
        $MicrosoftLauncherDockPresenceConfiguration,

        [Parameter()]
        [System.Boolean]
        $MicrosoftLauncherFeedAllowUserModification,

        [Parameter()]
        [System.Boolean]
        $MicrosoftLauncherFeedEnabled,

        [Parameter()]
        [ValidateSet('notConfigured','top','bottom','hide')]
        [System.String]
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
        [ValidateSet('notConfigured','camera','notifications','unredactedNotifications','trustAgents','fingerprint','remoteInput','allFeatures','face','iris','biometrics')]
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
        [ValidateSet('deviceDefault','required','numeric','numericComplex','alphabetic','alphanumeric','alphanumericWithSymbols','lowSecurityBiometric','customPassword')]
        [System.String]
        $PasswordRequiredType,

        [Parameter()]
        [ValidateSet('deviceDefault','daily','unkownFutureValue')]
        [System.String]
        $PasswordRequireUnlock,

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
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $PersonalProfilePersonalApplications,

        [Parameter()]
        [ValidateSet('notConfigured','blockedApps','allowedApps')]
        [System.String]
        $PersonalProfilePlayStoreMode,

        [Parameter()]
        [System.Boolean]
        $PersonalProfileScreenCaptureBlocked,

        [Parameter()]
        [ValidateSet('notConfigured','allowList','blockList')]
        [System.String]
        $PlayStoreMode,

        [Parameter()]
        [System.Boolean]
        $ScreenCaptureBlocked,

        [Parameter()]
        [System.Boolean]
        $SecurityCommonCriteriaModeEnabled,

        [Parameter()]
        [System.Boolean]
        $SecurityDeveloperSettingsEnabled,

        [Parameter()]
        [System.Boolean]
        $SecurityRequireVerifyApps,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ShortHelpText,

        [Parameter()]
        [System.Boolean]
        $StatusBarBlocked,

        [Parameter()]
        [ValidateSet('notConfigured','ac','usb','wireless')]
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
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $SystemUpdateFreezePeriods,

        [Parameter()]
        [ValidateSet('deviceDefault','postpone','windowed','automatic')]
        [System.String]
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
        [ValidateSet('deviceDefault','required','numeric','numericComplex','alphabetic','alphanumeric','alphanumericWithSymbols','lowSecurityBiometric','customPassword')]
        [System.String]
        $WorkProfilePasswordRequiredType,

        [Parameter()]
        [ValidateSet('deviceDefault','daily','unkownFutureValue')]
        [System.String]
        $WorkProfilePasswordRequireUnlock,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordSignInFailureCountBeforeFactoryReset,


        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

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

    Write-Verbose -Message "Testing configuration of {$id}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()

    if($CurrentValues.Ensure -eq "Absent")
    {
        Write-Verbose -Message "Test-TargetResource returned $false"
        return $false
    }
    $testResult=$true

    foreach($key in $PSBoundParameters.Keys)
    {
        if($PSBoundParameters[$key].getType().Name -like "*CimInstance*")
        {

            $CIMArraySource=@()
            $CIMArrayTarget=@()
            $CIMArraySource+=$PSBoundParameters[$key]
            $CIMArrayTarget+=$CurrentValues.$key
            if($CIMArraySource.count -ne $CIMArrayTarget.count)
            {
                Write-Verbose -Message "Configuration drift:Number of items does not match: Source=$($CIMArraySource.count) Target=$($CIMArrayTarget.count)"
                $testResult=$false
                break
            }
            $i=0
            foreach($item in $CIMArraySource )
            {
                $testResult=Compare-M365DSCComplexObject `
                    -Source (Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $CIMArraySource[$i]) `
                    -Target ($CIMArrayTarget[$i])

                $i++
                if(-Not $testResult)
                {
                    $testResult=$false
                    break;
                }
            }
            if(-Not $testResult)
            {
                $testResult=$false
                break;
            }

            $ValuesToCheck.Remove($key)|Out-Null
        }
    }

    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null

    #Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    #Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

    #Convert any DateTime to String
    foreach ($key in $ValuesToCheck.Keys)
    {
        if(($null -ne $CurrentValues[$key]) `
            -and ($CurrentValues[$key].getType().Name -eq 'DateTime'))
        {
            $CurrentValues[$key]=$CurrentValues[$key].toString()
        }
    }

    if($testResult)
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
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters `
        -ProfileName 'v1.0'
    $context=Get-MgContext
    if($null -eq $context)
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters -ProfileName 'beta'
    }
    Select-MgProfile 'beta' -ErrorAction Stop

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
            -ErrorAction Stop | Where-Object `
            -FilterScript { `
                $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.androidDeviceOwnerGeneralDeviceConfiguration'  `
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
                id                    = $config.id
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

        if ($Results.AzureAdSharedDeviceDataClearApps)
        {
            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.AzureAdSharedDeviceDataClearApps -CIMInstanceName MicrosoftGraphapplistitem
            if ($complexTypeStringResult)
            {
                $Results.AzureAdSharedDeviceDataClearApps = $complexTypeStringResult            }
            else
            {
                $Results.Remove('AzureAdSharedDeviceDataClearApps') | Out-Null
            }
        }
        if ($Results.DetailedHelpText)
        {
            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.DetailedHelpText -CIMInstanceName MicrosoftGraphandroiddeviceowneruserfacingmessage
            if ($complexTypeStringResult)
            {
                $Results.DetailedHelpText = $complexTypeStringResult            }
            else
            {
                $Results.Remove('DetailedHelpText') | Out-Null
            }
        }
        if ($Results.DeviceOwnerLockScreenMessage)
        {
            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.DeviceOwnerLockScreenMessage -CIMInstanceName MicrosoftGraphandroiddeviceowneruserfacingmessage
            if ($complexTypeStringResult)
            {
                $Results.DeviceOwnerLockScreenMessage = $complexTypeStringResult            }
            else
            {
                $Results.Remove('DeviceOwnerLockScreenMessage') | Out-Null
            }
        }
        if ($Results.GlobalProxy)
        {
            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.GlobalProxy -CIMInstanceName MicrosoftGraphandroiddeviceownerglobalproxy
            if ($complexTypeStringResult)
            {
                $Results.GlobalProxy = $complexTypeStringResult            }
            else
            {
                $Results.Remove('GlobalProxy') | Out-Null
            }
        }
        if ($Results.KioskModeAppPositions)
        {
            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.KioskModeAppPositions -CIMInstanceName MicrosoftGraphandroiddeviceownerkioskmodeapppositionitem
            if ($complexTypeStringResult)
            {
                $Results.KioskModeAppPositions = $complexTypeStringResult            }
            else
            {
                $Results.Remove('KioskModeAppPositions') | Out-Null
            }
        }
        if ($Results.KioskModeApps)
        {
            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.KioskModeApps -CIMInstanceName MicrosoftGraphapplistitem
            if ($complexTypeStringResult)
            {
                $Results.KioskModeApps = $complexTypeStringResult            }
            else
            {
                $Results.Remove('KioskModeApps') | Out-Null
            }
        }
        if ($Results.KioskModeManagedFolders)
        {
            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.KioskModeManagedFolders -CIMInstanceName MicrosoftGraphandroiddeviceownerkioskmodemanagedfolder
            if ($complexTypeStringResult)
            {
                $Results.KioskModeManagedFolders = $complexTypeStringResult            }
            else
            {
                $Results.Remove('KioskModeManagedFolders') | Out-Null
            }
        }
        if ($Results.PersonalProfilePersonalApplications)
        {
            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.PersonalProfilePersonalApplications -CIMInstanceName MicrosoftGraphapplistitem
            if ($complexTypeStringResult)
            {
                $Results.PersonalProfilePersonalApplications = $complexTypeStringResult            }
            else
            {
                $Results.Remove('PersonalProfilePersonalApplications') | Out-Null
            }
        }
        if ($Results.ShortHelpText)
        {
            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.ShortHelpText -CIMInstanceName MicrosoftGraphandroiddeviceowneruserfacingmessage
            if ($complexTypeStringResult)
            {
                $Results.ShortHelpText = $complexTypeStringResult            }
            else
            {
                $Results.Remove('ShortHelpText') | Out-Null
            }
        }
        if ($Results.SystemUpdateFreezePeriods)
        {
            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.SystemUpdateFreezePeriods -CIMInstanceName MicrosoftGraphandroiddeviceownersystemupdatefreezeperiod
            if ($complexTypeStringResult)
            {
                $Results.SystemUpdateFreezePeriods = $complexTypeStringResult            }
            else
            {
                $Results.Remove('SystemUpdateFreezePeriods') | Out-Null
            }
        }

        if($Results.Assignments)
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

        if ($Results.AzureAdSharedDeviceDataClearApps)
        {
            $isCIMArray=$false
            if($Results.AzureAdSharedDeviceDataClearApps.getType().Fullname -like "*[[\]]")
            {
                $isCIMArray=$true
            }
            $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "AzureAdSharedDeviceDataClearApps" -isCIMArray:$isCIMArray
        }
        if ($Results.DetailedHelpText)
        {
            $isCIMArray=$false
            if($Results.DetailedHelpText.getType().Fullname -like "*[[\]]")
            {
                $isCIMArray=$true
            }
            $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "DetailedHelpText" -isCIMArray:$isCIMArray
        }
        if ($Results.DeviceOwnerLockScreenMessage)
        {
            $isCIMArray=$false
            if($Results.DeviceOwnerLockScreenMessage.getType().Fullname -like "*[[\]]")
            {
                $isCIMArray=$true
            }
            $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "DeviceOwnerLockScreenMessage" -isCIMArray:$isCIMArray
        }
        if ($Results.GlobalProxy)
        {
            $isCIMArray=$false
            if($Results.GlobalProxy.getType().Fullname -like "*[[\]]")
            {
                $isCIMArray=$true
            }
            $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalProxy" -isCIMArray:$isCIMArray
        }
        if ($Results.KioskModeAppPositions)
        {
            $isCIMArray=$false
            if($Results.KioskModeAppPositions.getType().Fullname -like "*[[\]]")
            {
                $isCIMArray=$true
            }
            $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "KioskModeAppPositions" -isCIMArray:$isCIMArray
        }
        if ($Results.KioskModeApps)
        {
            $isCIMArray=$false
            if($Results.KioskModeApps.getType().Fullname -like "*[[\]]")
            {
                $isCIMArray=$true
            }
            $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "KioskModeApps" -isCIMArray:$isCIMArray
        }
        if ($Results.KioskModeManagedFolders)
        {
            $isCIMArray=$false
            if($Results.KioskModeManagedFolders.getType().Fullname -like "*[[\]]")
            {
                $isCIMArray=$true
            }
            $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "KioskModeManagedFolders" -isCIMArray:$isCIMArray
        }
        if ($Results.PersonalProfilePersonalApplications)
        {
            $isCIMArray=$false
            if($Results.PersonalProfilePersonalApplications.getType().Fullname -like "*[[\]]")
            {
                $isCIMArray=$true
            }
            $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "PersonalProfilePersonalApplications" -isCIMArray:$isCIMArray
        }
        if ($Results.ShortHelpText)
        {
            $isCIMArray=$false
            if($Results.ShortHelpText.getType().Fullname -like "*[[\]]")
            {
                $isCIMArray=$true
            }
            $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "ShortHelpText" -isCIMArray:$isCIMArray
        }
        if ($Results.SystemUpdateFreezePeriods)
        {
            $isCIMArray=$false
            if($Results.SystemUpdateFreezePeriods.getType().Fullname -like "*[[\]]")
            {
                $isCIMArray=$true
            }
            $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "SystemUpdateFreezePeriods" -isCIMArray:$isCIMArray
        }

        if ($Results.Assignments)
        {
            $isCIMArray=$false
            if($Results.Assignments.getType().Fullname -like "*[[\]]")
            {
                $isCIMArray=$true
            }
            $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "Assignments" -isCIMArray:$isCIMArray
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
    param(
        [Parameter()]
        $ComplexObject
    )

    if($null -eq $ComplexObject)
    {
        return $null
    }

    if($ComplexObject.gettype().fullname -like "*[[\]]")
    {
        $results=@()

        foreach($item in $ComplexObject)
        {
            if($item)
            {
                $hash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
                $results+=$hash
            }
        }
        if($results.count -eq 0)
        {
            return $null
        }
        return $results
    }

    $results = @{}
    $keys = $ComplexObject | Get-Member | Where-Object -FilterScript {$_.MemberType -eq 'Property' -and $_.Name -ne 'AdditionalProperties'}

    foreach ($key in $keys)
    {
        if($ComplexObject.$($key.Name))
        {
            $results.Add($key.Name, $ComplexObject.$($key.Name))
        }
    }
    if($results.count -eq 0)
    {
        return $null
    }
    return $results
}

function Get-M365DSCDRGComplexTypeToString
{
    [CmdletBinding()]
    #[OutputType([System.String])]
    param(
        [Parameter()]
        $ComplexObject,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CIMInstanceName,

        [Parameter()]
        [System.String]
        $Whitespace="",

        [Parameter()]
        [switch]
        $isArray=$false
    )
    if ($null -eq $ComplexObject)
    {
        return $null
    }

    #If ComplexObject  is an Array
    if ($ComplexObject.GetType().FullName -like "*[[\]]")
    {
        $currentProperty=@()
        foreach ($item in $ComplexObject)
        {
            $currentProperty += Get-M365DSCDRGComplexTypeToString `
                -ComplexObject $item `
                -isArray:$true `
                -CIMInstanceName $CIMInstanceName `
                -Whitespace "                "

        }
        if ([string]::IsNullOrEmpty($currentProperty))
        {
            return $null
        }
        return $currentProperty

    }

    #If ComplexObject is a single CIM Instance
    if(-Not (Test-M365DSCComplexObjectHasValues -ComplexObject $ComplexObject))
    {
        return $null
    }
    $currentProperty=""
    if($isArray)
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

            if ($ComplexObject[$key].GetType().FullName -like "Microsoft.Graph.PowerShell.Models.*")
            {
                $hashPropertyType=$ComplexObject[$key].GetType().Name.tolower()
                $hashProperty=Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject[$key]

                if (Test-M365DSCComplexObjectHasValues -ComplexObject $hashProperty)
                {
                    $Whitespace+="            "
                    if(-not $isArray)
                    {
                        $currentProperty += "                " + $key + " = "
                    }
                    $currentProperty += Get-M365DSCDRGComplexTypeToString `
                                    -ComplexObject $hashProperty `
                                    -CIMInstanceName $hashPropertyType `
                                    -Whitespace $Whitespace
                }
            }
            else
            {
                if(-not $isArray)
                {
                    $Whitespace= "            "
                }
                $currentProperty += Get-M365DSCDRGSimpleObjectTypeToString -Key $key -Value $ComplexObject[$key] -Space ($Whitespace+"    ")
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
function Test-M365DSCComplexObjectHasValues
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $ComplexObject
    )
    $keys=$ComplexObject.keys
    $hasValue=$false
    foreach($key in $keys)
    {
        if($ComplexObject[$key])
        {
            if($ComplexObject[$key].GetType().FullName -like "Microsoft.Graph.PowerShell.Models.*")
            {
                $hash=Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject[$key]
                if(-Not $hash)
                {
                    return $false
                }
                $hasValue=Test-M365DSCComplexObjectHasValues -ComplexObject ($hash)
            }
            else
            {
                $hasValue=$true
                return $hasValue
            }
        }
    }
    return $hasValue
}
Function Get-M365DSCDRGSimpleObjectTypeToString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.String]
        $Key,

        [Parameter(Mandatory = 'true')]
        $Value,

        [Parameter()]
        [System.String]
        $Space="                "

    )

    $returnValue=""
    switch -Wildcard ($Value.GetType().Fullname )
    {
        "*.Boolean"
        {
            $returnValue= $Space + $Key + " = `$" + $Value.ToString() + "`r`n"
        }
        "*.String"
        {
            if($key -eq '@odata.type')
            {
                $key='odataType'
            }
            $returnValue= $Space + $Key + " = '" + $Value + "'`r`n"
        }
        "*.DateTime"
        {
            $returnValue= $Space + $Key + " = '" + $Value + "'`r`n"
        }
        "*[[\]]"
        {
            $returnValue= $Space + $key + " = @("
            $whitespace=""
            $newline=""
            if($Value.count -gt 1)
            {
                $returnValue += "`r`n"
                $whitespace=$Space+"    "
                $newline="`r`n"
            }
            foreach ($item in $Value)
            {
                switch -Wildcard ($item.GetType().Fullname )
                {
                    "*.String"
                    {
                        $returnValue += "$whitespace'$item'$newline"
                    }
                    "*.DateTime"
                    {
                        $returnValue += "$whitespace'$item'$newline"
                    }
                    Default
                    {
                        $returnValue += "$whitespace$item$newline"
                    }
                }
            }
            if($Value.count -gt 1)
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
            $returnValue= $Space + $Key + " = " + $Value + "`r`n"
        }
    }
    return $returnValue
}
function Rename-M365DSCCimInstanceODataParameter
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $Properties
    )
        $CIMparameters=$Properties.getEnumerator()|Where-Object -FilterScript {$_.value.GetType().Fullname -like '*CimInstance*'}
        foreach($CIMParam in $CIMparameters)
        {
            if($CIMParam.value.GetType().Fullname -like '*[[\]]')
            {
                $CIMvalues=@()
                foreach($item in $CIMParam.value)
                {
                    $CIMHash= Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
                    $keys=($CIMHash.clone()).keys
                    if($keys -contains 'odataType')
                    {
                        $CIMHash.add('@odata.type',$CIMHash.odataType)
                        $CIMHash.remove('odataType')
                    }
                    $CIMvalues+=$CIMHash
                }
                $Properties.($CIMParam.key)=$CIMvalues
            }
            else
            {
                $CIMHash= Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $CIMParam.value
                $keys=($CIMHash.clone()).keys
                if($keys -contains 'odataType')
                {
                    $CIMHash.add('@odata.type',$CIMHash.odataType)
                    $CIMHash.remove('odataType')
                    $Properties.($CIMParam.key)=$CIMHash
                }
            }
        }
        return $Properties
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

    $additionalProperties=@(
        "AccountsBlockModification"
        "AppsAllowInstallFromUnknownSources"
        "AppsAutoUpdatePolicy"
        "AppsDefaultPermissionPolicy"
        "AppsRecommendSkippingFirstUseHints"
        "AzureAdSharedDeviceDataClearApps"
        "BluetoothBlockConfiguration"
        "BluetoothBlockContactSharing"
        "CameraBlocked"
        "CellularBlockWiFiTethering"
        "CertificateCredentialConfigurationDisabled"
        "CrossProfilePoliciesAllowCopyPaste"
        "CrossProfilePoliciesAllowDataSharing"
        "CrossProfilePoliciesShowWorkContactsInPersonalProfile"
        "DataRoamingBlocked"
        "DateTimeConfigurationBlocked"
        "DetailedHelpText"
        "DeviceOwnerLockScreenMessage"
        "EnrollmentProfile"
        "FactoryResetBlocked"
        "FactoryResetDeviceAdministratorEmails"
        "GlobalProxy"
        "GoogleAccountsBlocked"
        "KioskCustomizationDeviceSettingsBlocked"
        "KioskCustomizationPowerButtonActionsBlocked"
        "KioskCustomizationStatusBar"
        "KioskCustomizationSystemErrorWarnings"
        "KioskCustomizationSystemNavigation"
        "KioskModeAppOrderEnabled"
        "KioskModeAppPositions"
        "KioskModeApps"
        "KioskModeAppsInFolderOrderedByName"
        "KioskModeBluetoothConfigurationEnabled"
        "KioskModeDebugMenuEasyAccessEnabled"
        "KioskModeExitCode"
        "KioskModeFlashlightConfigurationEnabled"
        "KioskModeFolderIcon"
        "KioskModeGridHeight"
        "KioskModeGridWidth"
        "KioskModeIconSize"
        "KioskModeLockHomeScreen"
        "KioskModeManagedFolders"
        "KioskModeManagedHomeScreenAutoSignout"
        "KioskModeManagedHomeScreenInactiveSignOutDelayInSeconds"
        "KioskModeManagedHomeScreenInactiveSignOutNoticeInSeconds"
        "KioskModeManagedHomeScreenPinComplexity"
        "KioskModeManagedHomeScreenPinRequired"
        "KioskModeManagedHomeScreenPinRequiredToResume"
        "KioskModeManagedHomeScreenSignInBackground"
        "KioskModeManagedHomeScreenSignInBrandingLogo"
        "KioskModeManagedHomeScreenSignInEnabled"
        "KioskModeManagedSettingsEntryDisabled"
        "KioskModeMediaVolumeConfigurationEnabled"
        "KioskModeScreenOrientation"
        "KioskModeScreenSaverConfigurationEnabled"
        "KioskModeScreenSaverDetectMediaDisabled"
        "KioskModeScreenSaverDisplayTimeInSeconds"
        "KioskModeScreenSaverImageUrl"
        "KioskModeScreenSaverStartDelayInSeconds"
        "KioskModeShowAppNotificationBadge"
        "KioskModeShowDeviceInfo"
        "KioskModeUseManagedHomeScreenApp"
        "KioskModeVirtualHomeButtonEnabled"
        "KioskModeVirtualHomeButtonType"
        "KioskModeWallpaperUrl"
        "KioskModeWifiAllowedSsids"
        "KioskModeWiFiConfigurationEnabled"
        "MicrophoneForceMute"
        "MicrosoftLauncherConfigurationEnabled"
        "MicrosoftLauncherCustomWallpaperAllowUserModification"
        "MicrosoftLauncherCustomWallpaperEnabled"
        "MicrosoftLauncherCustomWallpaperImageUrl"
        "MicrosoftLauncherDockPresenceAllowUserModification"
        "MicrosoftLauncherDockPresenceConfiguration"
        "MicrosoftLauncherFeedAllowUserModification"
        "MicrosoftLauncherFeedEnabled"
        "MicrosoftLauncherSearchBarPlacementConfiguration"
        "NetworkEscapeHatchAllowed"
        "NfcBlockOutgoingBeam"
        "PasswordBlockKeyguard"
        "PasswordBlockKeyguardFeatures"
        "PasswordExpirationDays"
        "PasswordMinimumLength"
        "PasswordMinimumLetterCharacters"
        "PasswordMinimumLowerCaseCharacters"
        "PasswordMinimumNonLetterCharacters"
        "PasswordMinimumNumericCharacters"
        "PasswordMinimumSymbolCharacters"
        "PasswordMinimumUpperCaseCharacters"
        "PasswordMinutesOfInactivityBeforeScreenTimeout"
        "PasswordPreviousPasswordCountToBlock"
        "PasswordRequiredType"
        "PasswordRequireUnlock"
        "PasswordSignInFailureCountBeforeFactoryReset"
        "PersonalProfileAppsAllowInstallFromUnknownSources"
        "PersonalProfileCameraBlocked"
        "PersonalProfilePersonalApplications"
        "PersonalProfilePlayStoreMode"
        "PersonalProfileScreenCaptureBlocked"
        "PlayStoreMode"
        "ScreenCaptureBlocked"
        "SecurityCommonCriteriaModeEnabled"
        "SecurityDeveloperSettingsEnabled"
        "SecurityRequireVerifyApps"
        "ShortHelpText"
        "StatusBarBlocked"
        "StayOnModes"
        "StorageAllowUsb"
        "StorageBlockExternalMedia"
        "StorageBlockUsbFileTransfer"
        "SystemUpdateFreezePeriods"
        "SystemUpdateInstallType"
        "SystemUpdateWindowEndMinutesAfterMidnight"
        "SystemUpdateWindowStartMinutesAfterMidnight"
        "SystemWindowsBlocked"
        "UsersBlockAdd"
        "UsersBlockRemove"
        "VolumeBlockAdjustment"
        "VpnAlwaysOnLockdownMode"
        "VpnAlwaysOnPackageIdentifier"
        "WifiBlockEditConfigurations"
        "WifiBlockEditPolicyDefinedConfigurations"
        "WorkProfilePasswordExpirationDays"
        "WorkProfilePasswordMinimumLength"
        "WorkProfilePasswordMinimumLetterCharacters"
        "WorkProfilePasswordMinimumLowerCaseCharacters"
        "WorkProfilePasswordMinimumNonLetterCharacters"
        "WorkProfilePasswordMinimumNumericCharacters"
        "WorkProfilePasswordMinimumSymbolCharacters"
        "WorkProfilePasswordMinimumUpperCaseCharacters"
        "WorkProfilePasswordPreviousPasswordCountToBlock"
        "WorkProfilePasswordRequiredType"
        "WorkProfilePasswordRequireUnlock"
        "WorkProfilePasswordSignInFailureCountBeforeFactoryReset"

    )
    $results = @{"@odata.type" = "#microsoft.graph.androidDeviceOwnerGeneralDeviceConfiguration" }
    $cloneProperties=$Properties.clone()
    foreach ($property in $cloneProperties.Keys)
    {
        if ($property -in ($additionalProperties) )
        {
            $propertyName = $property[0].ToString().ToLower() + $property.Substring(1, $property.Length - 1)
            if($properties.$property -and $properties.$property.getType().FullName -like "*CIMInstance*")
            {
                if($properties.$property.getType().FullName -like "*[[\]]")
                {
                    $array=@()
                    foreach($item in $properties.$property)
                    {
                        $array+=Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $item

                    }
                    $propertyValue=$array
                }
                else
                {
                    $propertyValue=Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $properties.$property
                }

            }
            else
            {
                $propertyValue = $properties.$property
            }


            $results.Add($propertyName, $propertyValue)

        }
    }
    if($results.Count -eq 1)
    {
        return $null
    }
    return $results
}
function Compare-M365DSCComplexObject
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param(
        [Parameter()]
        [System.Collections.Hashtable]
        $Source,
        [Parameter()]
        [System.Collections.Hashtable]
        $Target
    )

    $keys= $Source.Keys|Where-Object -FilterScript {$_ -ne "PSComputerName"}
    foreach ($key in $keys)
    {
        write-verbose -message "Comparing key: {$key}"
        $skey=$key
        if($key -eq 'odataType')
        {
            $skey='@odata.type'
        }

        #Marking Target[key] to null if empty complex object or array
        if($null -ne $Target[$key])
        {
            switch -Wildcard ($Target[$key].getType().Fullname )
            {
                "Microsoft.Graph.PowerShell.Models.*"
                {
                    $hashProperty=Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Target[$key]
                    if(-not (Test-M365DSCComplexObjectHasValues -ComplexObject $hashProperty))
                    {
                        $Target[$key]=$null
                    }
                }
                "*[[\]]"
                {
                    if($Target[$key].count -eq 0)
                    {
                        $Target[$key]=$null
                    }
                }
            }
        }
        $sourceValue=$Source[$key]
        $targetValue=$Target[$key]
        #One of the item is null
        if (($null -eq $Source[$skey]) -xor ($null -eq $Target[$key]))
        {
            if($null -eq $Source[$skey])
            {
                $sourceValue="null"
            }

            if($null -eq $Target[$key])
            {
                $targetValue="null"
            }
            Write-Verbose -Message "Configuration drift - key: $key Source{$sourceValue} Target{$targetValue}"
            return $false
        }
        #Both source and target aren't null or empty
        if(($null -ne $Source[$skey]) -and ($null -ne $Target[$key]))
        {
            if($Source[$skey].getType().FullName -like "*CimInstance*")
            {
                #Recursive call for complex object
                $compareResult= Compare-M365DSCComplexObject `
                    -Source (Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Source[$skey]) `
                    -Target (Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Target[$key])

                if(-not $compareResult)
                {
                    Write-Verbose -Message "Configuration drift - key: $key Source{$sourceValue} Target{$targetValue}"
                    return $false
                }
            }
            else
            {
                #Simple object comparison
                $referenceObject=$Target[$key]
                $differenceObject=$Source[$skey]

                $compareResult = Compare-Object `
                    -ReferenceObject ($referenceObject) `
                    -DifferenceObject ($differenceObject)

                if ($null -ne $compareResult)
                {
                    Write-Verbose -Message "Configuration drift - key: $key Source{$sourceValue} Target{$targetValue}"
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
    param(
        [Parameter(Mandatory = 'true')]
        $ComplexObject
    )

    if($ComplexObject.getType().Fullname -like "*[[\]]")
    {
        $results=@()
        foreach($item in $ComplexObject)
        {
            $hash=Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
            if(Test-M365DSCComplexObjectHasValues -ComplexObject $hash)
            {
                $results+=$hash
            }
        }
        if($results.count -eq 0)
        {
            return $null
        }
        return $Results
    }
    $hashComplexObject = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject
    if($hashComplexObject)
    {
        $results=$hashComplexObject.clone()
        $keys=$hashComplexObject.Keys|Where-Object -FilterScript {$_ -ne 'PSComputerName'}
        foreach ($key in $keys)
        {
            if(($null -ne $hashComplexObject[$key]) -and ($hashComplexObject[$key].getType().Fullname -like "*CimInstance*"))
            {
                $results[$key]=Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $hashComplexObject[$key]
            }
            if($null -eq $results[$key])
            {
                $results.remove($key)|out-null
            }

        }
    }
    return $results
}
function Update-DeviceConfigurationPolicyAssignment
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [Parameter(Mandatory = 'true')]
        [System.String]
        $DeviceConfigurationPolicyId,

        [Parameter()]
        [Array]
        $Targets
    )
    try
    {
        $deviceManagementPolicyAssignments=@()

        $Uri="https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations/$DeviceConfigurationPolicyId/assign"

        foreach($target in $targets)
        {
            $formattedTarget=@{"@odata.type"=$target.dataType}
            if($target.groupId)
            {
                $formattedTarget.Add('groupId',$target.groupId)
            }
            if($target.collectionId)
            {
                $formattedTarget.Add('collectionId',$target.collectionId)
            }
            if($target.deviceAndAppManagementAssignmentFilterType)
            {
                $formattedTarget.Add('deviceAndAppManagementAssignmentFilterType',$target.deviceAndAppManagementAssignmentFilterType)
            }
            if($target.deviceAndAppManagementAssignmentFilterId)
            {
                $formattedTarget.Add('deviceAndAppManagementAssignmentFilterId',$target.deviceAndAppManagementAssignmentFilterId)
            }
            $deviceManagementPolicyAssignments+=@{'target'= $formattedTarget}
        }
        $body=@{'assignments'=$deviceManagementPolicyAssignments}|ConvertTo-Json -Depth 20
        #write-verbose -Message $body
        Invoke-MgGraphRequest -Method POST -Uri $Uri -Body $body -ErrorAction Stop

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
        return $null
    }


}
Export-ModuleMember -Function *-TargetResource
