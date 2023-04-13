function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $AccountsBlockModification,

        [Parameter()]
        [System.Boolean]
        $AppsAllowInstallFromUnknownSources,

        [Parameter()]
        [ValidateSet('notConfigured', 'userChoice', 'never', 'wiFiOnly', 'always')]
        [System.String]
        $AppsAutoUpdatePolicy,

        [Parameter()]
        [ValidateSet('deviceDefault', 'prompt', 'autoGrant', 'autoDeny')]
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
        [ValidateSet('notConfigured', 'crossProfileDataSharingBlocked', 'dataSharingFromWorkToPersonalBlocked', 'crossProfileDataSharingAllowed', 'unkownFutureValue')]
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
        [ValidateSet('notConfigured', 'dedicatedDevice', 'fullyManaged')]
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
        [ValidateSet('notConfigured', 'notificationsAndSystemInfoEnabled', 'systemInfoOnly')]
        [System.String]
        $KioskCustomizationStatusBar,

        [Parameter()]
        [System.Boolean]
        $KioskCustomizationSystemErrorWarnings,

        [Parameter()]
        [ValidateSet('notConfigured', 'navigationEnabled', 'homeButtonOnly')]
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
        [ValidateSet('notConfigured', 'darkSquare', 'darkCircle', 'lightSquare', 'lightCircle')]
        [System.String]
        $KioskModeFolderIcon,

        [Parameter()]
        [System.Int32]
        $KioskModeGridHeight,

        [Parameter()]
        [System.Int32]
        $KioskModeGridWidth,

        [Parameter()]
        [ValidateSet('notConfigured', 'smallest', 'small', 'regular', 'large', 'largest')]
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
        [ValidateSet('notConfigured', 'simple', 'complex')]
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
        [ValidateSet('notConfigured', 'portrait', 'landscape', 'autoRotate')]
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
        [ValidateSet('notConfigured', 'singleAppMode', 'multiAppMode')]
        [System.String]
        $KioskModeUseManagedHomeScreenApp,

        [Parameter()]
        [System.Boolean]
        $KioskModeVirtualHomeButtonEnabled,

        [Parameter()]
        [ValidateSet('notConfigured', 'swipeUp', 'floating')]
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
        [ValidateSet('notConfigured', 'show', 'hide', 'disabled')]
        [System.String]
        $MicrosoftLauncherDockPresenceConfiguration,

        [Parameter()]
        [System.Boolean]
        $MicrosoftLauncherFeedAllowUserModification,

        [Parameter()]
        [System.Boolean]
        $MicrosoftLauncherFeedEnabled,

        [Parameter()]
        [ValidateSet('notConfigured', 'top', 'bottom', 'hide')]
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
        [ValidateSet('notConfigured', 'camera', 'notifications', 'unredactedNotifications', 'trustAgents', 'fingerprint', 'remoteInput', 'allFeatures', 'face', 'iris', 'biometrics')]
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
        [ValidateSet('deviceDefault', 'required', 'numeric', 'numericComplex', 'alphabetic', 'alphanumeric', 'alphanumericWithSymbols', 'lowSecurityBiometric', 'customPassword')]
        [System.String]
        $PasswordRequiredType,

        [Parameter()]
        [ValidateSet('deviceDefault', 'daily', 'unkownFutureValue')]
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
        [ValidateSet('notConfigured', 'blockedApps', 'allowedApps')]
        [System.String]
        $PersonalProfilePlayStoreMode,

        [Parameter()]
        [System.Boolean]
        $PersonalProfileScreenCaptureBlocked,

        [Parameter()]
        [ValidateSet('notConfigured', 'allowList', 'blockList')]
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
        [ValidateSet('notConfigured', 'ac', 'usb', 'wireless')]
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
        [ValidateSet('deviceDefault', 'postpone', 'windowed', 'automatic')]
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
        [ValidateSet('deviceDefault', 'required', 'numeric', 'numericComplex', 'alphabetic', 'alphanumeric', 'alphanumericWithSymbols', 'lowSecurityBiometric', 'customPassword')]
        [System.String]
        $WorkProfilePasswordRequiredType,

        [Parameter()]
        [ValidateSet('deviceDefault', 'daily', 'unkownFutureValue')]
        [System.String]
        $WorkProfilePasswordRequireUnlock,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordSignInFailureCountBeforeFactoryReset,

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

    try
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters `
            -ProfileName 'beta'
    }
    catch
    {
        Write-Verbose -Message $_
    }

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

    $nullResult = $PSBoundParameters
    $nullResult.Ensure = 'Absent'

    try
    {
        $getValue = $null

        #region resource generator code
        $getValue = Get-MgDeviceManagementDeviceConfiguration -DeviceConfigurationId $id -ErrorAction SilentlyContinue

        if (-not $getValue)
        {
            $getValue = Get-MgDeviceManagementDeviceConfiguration -Filter "DisplayName eq '$Displayname'" -ErrorAction SilentlyContinue | Where-Object `
            -FilterScript { `
                $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.androidDeviceOwnerGeneralDeviceConfiguration' `
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
            Id                                                       = $getValue.Id
            Description                                              = $getValue.Description
            #           DeviceManagementApplicabilityRuleDeviceMode              = $getValue.DeviceManagementApplicabilityRuleDeviceMode
            #           DeviceManagementApplicabilityRuleOsEdition               = $getValue.DeviceManagementApplicabilityRuleOsEdition
            #           DeviceManagementApplicabilityRuleOsVersion               = $getValue.DeviceManagementApplicabilityRuleOsVersion
            DisplayName                                              = $getValue.DisplayName
            #           RoleScopeTagIds                                          = $getValue.RoleScopeTagIds
            #           SupportsScopeTags                                        = $getValue.SupportsScopeTags
            #           Version                                                  = $getValue.Version
            AccountsBlockModification                                = $getValue.AdditionalProperties.accountsBlockModification
            AppsAllowInstallFromUnknownSources                       = $getValue.AdditionalProperties.appsAllowInstallFromUnknownSources
            AppsAutoUpdatePolicy                                     = $getValue.AdditionalProperties.appsAutoUpdatePolicy
            AppsDefaultPermissionPolicy                              = $getValue.AdditionalProperties.appsDefaultPermissionPolicy
            AppsRecommendSkippingFirstUseHints                       = $getValue.AdditionalProperties.appsRecommendSkippingFirstUseHints
            AzureAdSharedDeviceDataClearApps                         = $getValue.AdditionalProperties.azureAdSharedDeviceDataClearApps
            BluetoothBlockConfiguration                              = $getValue.AdditionalProperties.bluetoothBlockConfiguration
            BluetoothBlockContactSharing                             = $getValue.AdditionalProperties.bluetoothBlockContactSharing
            CameraBlocked                                            = $getValue.AdditionalProperties.cameraBlocked
            CellularBlockWiFiTethering                               = $getValue.AdditionalProperties.cellularBlockWiFiTethering
            CertificateCredentialConfigurationDisabled               = $getValue.AdditionalProperties.certificateCredentialConfigurationDisabled
            CrossProfilePoliciesAllowCopyPaste                       = $getValue.AdditionalProperties.crossProfilePoliciesAllowCopyPaste
            CrossProfilePoliciesAllowDataSharing                     = $getValue.AdditionalProperties.crossProfilePoliciesAllowDataSharing
            CrossProfilePoliciesShowWorkContactsInPersonalProfile    = $getValue.AdditionalProperties.crossProfilePoliciesShowWorkContactsInPersonalProfile
            DataRoamingBlocked                                       = $getValue.AdditionalProperties.dataRoamingBlocked
            DateTimeConfigurationBlocked                             = $getValue.AdditionalProperties.dateTimeConfigurationBlocked
            DetailedHelpText                                         = $getValue.AdditionalProperties.detailedHelpText
            DeviceOwnerLockScreenMessage                             = $getValue.additionalProperties.deviceOwnerLockScreenMessage
            EnrollmentProfile                                        = $getValue.AdditionalProperties.enrollmentProfile
            FactoryResetBlocked                                      = $getValue.AdditionalProperties.factoryResetBlocked
            FactoryResetDeviceAdministratorEmails                    = $getValue.AdditionalProperties.factoryResetDeviceAdministratorEmails
            GlobalProxy                                              = $getValue.AdditionalProperties.globalProxy
            GoogleAccountsBlocked                                    = $getValue.AdditionalProperties.googleAccountsBlocked
            KioskCustomizationDeviceSettingsBlocked                  = $getValue.AdditionalProperties.kioskCustomizationDeviceSettingsBlocked
            KioskCustomizationPowerButtonActionsBlocked              = $getValue.AdditionalProperties.kioskCustomizationPowerButtonActionsBlocked
            KioskCustomizationStatusBar                              = $getValue.AdditionalProperties.kioskCustomizationStatusBar
            KioskCustomizationSystemErrorWarnings                    = $getValue.AdditionalProperties.kioskCustomizationSystemErrorWarnings
            KioskCustomizationSystemNavigation                       = $getValue.AdditionalProperties.kioskCustomizationSystemNavigation
            KioskModeAppOrderEnabled                                 = $getValue.AdditionalProperties.kioskModeAppOrderEnabled
            KioskModeAppPositions                                    = $getValue.AdditionalProperties.kioskModeAppPositions
            KioskModeApps                                            = $getValue.AdditionalProperties.kioskModeApps
            KioskModeAppsInFolderOrderedByName                       = $getValue.AdditionalProperties.kioskModeAppsInFolderOrderedByName
            KioskModeBluetoothConfigurationEnabled                   = $getValue.AdditionalProperties.kioskModeBluetoothConfigurationEnabled
            KioskModeDebugMenuEasyAccessEnabled                      = $getValue.AdditionalProperties.kioskModeDebugMenuEasyAccessEnabled
            KioskModeExitCode                                        = $getValue.AdditionalProperties.kioskModeExitCode
            KioskModeFlashlightConfigurationEnabled                  = $getValue.AdditionalProperties.kioskModeFlashlightConfigurationEnabled
            KioskModeFolderIcon                                      = $getValue.AdditionalProperties.kioskModeFolderIcon
            KioskModeGridHeight                                      = $getValue.AdditionalProperties.kioskModeGridHeight
            KioskModeGridWidth                                       = $getValue.AdditionalProperties.kioskModeGridWidth
            KioskModeIconSize                                        = $getValue.AdditionalProperties.kioskModeIconSize
            KioskModeLockHomeScreen                                  = $getValue.AdditionalProperties.kioskModeLockHomeScreen
            KioskModeManagedFolders                                  = $getValue.AdditionalProperties.kioskModeManagedFolders
            KioskModeManagedHomeScreenAutoSignout                    = $getValue.AdditionalProperties.kioskModeManagedHomeScreenAutoSignout
            KioskModeManagedHomeScreenInactiveSignOutDelayInSeconds  = $getValue.AdditionalProperties.kioskModeManagedHomeScreenInactiveSignOutDelayInSeconds
            KioskModeManagedHomeScreenInactiveSignOutNoticeInSeconds = $getValue.AdditionalProperties.kioskModeManagedHomeScreenInactiveSignOutNoticeInSeconds
            KioskModeManagedHomeScreenPinComplexity                  = $getValue.AdditionalProperties.kioskModeManagedHomeScreenPinComplexity
            KioskModeManagedHomeScreenPinRequired                    = $getValue.AdditionalProperties.kioskModeManagedHomeScreenPinRequired
            KioskModeManagedHomeScreenPinRequiredToResume            = $getValue.AdditionalProperties.kioskModeManagedHomeScreenPinRequiredToResume
            KioskModeManagedHomeScreenSignInBackground               = $getValue.AdditionalProperties.kioskModeManagedHomeScreenSignInBackground
            KioskModeManagedHomeScreenSignInBrandingLogo             = $getValue.AdditionalProperties.kioskModeManagedHomeScreenSignInBrandingLogo
            KioskModeManagedHomeScreenSignInEnabled                  = $getValue.AdditionalProperties.kioskModeManagedHomeScreenSignInEnabled
            KioskModeManagedSettingsEntryDisabled                    = $getValue.AdditionalProperties.kioskModeManagedSettingsEntryDisabled
            KioskModeMediaVolumeConfigurationEnabled                 = $getValue.AdditionalProperties.kioskModeMediaVolumeConfigurationEnabled
            KioskModeScreenOrientation                               = $getValue.AdditionalProperties.kioskModeScreenOrientation
            KioskModeScreenSaverConfigurationEnabled                 = $getValue.AdditionalProperties.kioskModeScreenSaverConfigurationEnabled
            KioskModeScreenSaverDetectMediaDisabled                  = $getValue.AdditionalProperties.kioskModeScreenSaverDetectMediaDisabled
            KioskModeScreenSaverDisplayTimeInSeconds                 = $getValue.AdditionalProperties.kioskModeScreenSaverDisplayTimeInSeconds
            KioskModeScreenSaverImageUrl                             = $getValue.AdditionalProperties.kioskModeScreenSaverImageUrl
            KioskModeScreenSaverStartDelayInSeconds                  = $getValue.AdditionalProperties.kioskModeScreenSaverStartDelayInSeconds
            KioskModeShowAppNotificationBadge                        = $getValue.AdditionalProperties.kioskModeShowAppNotificationBadge
            KioskModeShowDeviceInfo                                  = $getValue.AdditionalProperties.kioskModeShowDeviceInfo
            KioskModeUseManagedHomeScreenApp                         = $getValue.AdditionalProperties.kioskModeUseManagedHomeScreenApp
            KioskModeVirtualHomeButtonEnabled                        = $getValue.AdditionalProperties.kioskModeVirtualHomeButtonEnabled
            KioskModeVirtualHomeButtonType                           = $getValue.AdditionalProperties.kioskModeVirtualHomeButtonType
            KioskModeWallpaperUrl                                    = $getValue.AdditionalProperties.kioskModeWallpaperUrl
            KioskModeWifiAllowedSsids                                = $getValue.AdditionalProperties.kioskModeWifiAllowedSsids
            KioskModeWiFiConfigurationEnabled                        = $getValue.AdditionalProperties.kioskModeWiFiConfigurationEnabled
            MicrophoneForceMute                                      = $getValue.AdditionalProperties.microphoneForceMute
            MicrosoftLauncherConfigurationEnabled                    = $getValue.AdditionalProperties.microsoftLauncherConfigurationEnabled
            MicrosoftLauncherCustomWallpaperAllowUserModification    = $getValue.AdditionalProperties.microsoftLauncherCustomWallpaperAllowUserModification
            MicrosoftLauncherCustomWallpaperEnabled                  = $getValue.AdditionalProperties.microsoftLauncherCustomWallpaperEnabled
            MicrosoftLauncherCustomWallpaperImageUrl                 = $getValue.AdditionalProperties.microsoftLauncherCustomWallpaperImageUrl
            MicrosoftLauncherDockPresenceAllowUserModification       = $getValue.AdditionalProperties.microsoftLauncherDockPresenceAllowUserModification
            MicrosoftLauncherDockPresenceConfiguration               = $getValue.AdditionalProperties.microsoftLauncherDockPresenceConfiguration
            MicrosoftLauncherFeedAllowUserModification               = $getValue.AdditionalProperties.microsoftLauncherFeedAllowUserModification
            MicrosoftLauncherFeedEnabled                             = $getValue.AdditionalProperties.microsoftLauncherFeedEnabled
            MicrosoftLauncherSearchBarPlacementConfiguration         = $getValue.AdditionalProperties.microsoftLauncherSearchBarPlacementConfiguration
            NetworkEscapeHatchAllowed                                = $getValue.AdditionalProperties.networkEscapeHatchAllowed
            NfcBlockOutgoingBeam                                     = $getValue.AdditionalProperties.nfcBlockOutgoingBeam
            PasswordBlockKeyguard                                    = $getValue.AdditionalProperties.passwordBlockKeyguard
            PasswordBlockKeyguardFeatures                            = $getValue.AdditionalProperties.passwordBlockKeyguardFeatures
            PasswordExpirationDays                                   = $getValue.AdditionalProperties.passwordExpirationDays
            PasswordMinimumLength                                    = $getValue.AdditionalProperties.passwordMinimumLength
            PasswordMinimumLetterCharacters                          = $getValue.AdditionalProperties.passwordMinimumLetterCharacters
            PasswordMinimumLowerCaseCharacters                       = $getValue.AdditionalProperties.passwordMinimumLowerCaseCharacters
            PasswordMinimumNonLetterCharacters                       = $getValue.AdditionalProperties.passwordMinimumNonLetterCharacters
            PasswordMinimumNumericCharacters                         = $getValue.AdditionalProperties.passwordMinimumNumericCharacters
            PasswordMinimumSymbolCharacters                          = $getValue.AdditionalProperties.passwordMinimumSymbolCharacters
            PasswordMinimumUpperCaseCharacters                       = $getValue.AdditionalProperties.passwordMinimumUpperCaseCharacters
            PasswordMinutesOfInactivityBeforeScreenTimeout           = $getValue.AdditionalProperties.passwordMinutesOfInactivityBeforeScreenTimeout
            PasswordPreviousPasswordCountToBlock                     = $getValue.AdditionalProperties.passwordPreviousPasswordCountToBlock
            PasswordRequiredType                                     = $getValue.AdditionalProperties.passwordRequiredType
            PasswordRequireUnlock                                    = $getValue.AdditionalProperties.passwordRequireUnlock
            PasswordSignInFailureCountBeforeFactoryReset             = $getValue.AdditionalProperties.passwordSignInFailureCountBeforeFactoryReset
            PersonalProfileAppsAllowInstallFromUnknownSources        = $getValue.AdditionalProperties.personalProfileAppsAllowInstallFromUnknownSources
            PersonalProfileCameraBlocked                             = $getValue.AdditionalProperties.personalProfileCameraBlocked
            PersonalProfilePersonalApplications                      = $getValue.AdditionalProperties.personalProfilePersonalApplications
            PersonalProfilePlayStoreMode                             = $getValue.AdditionalProperties.personalProfilePlayStoreMode
            PersonalProfileScreenCaptureBlocked                      = $getValue.AdditionalProperties.personalProfileScreenCaptureBlocked
            PlayStoreMode                                            = $getValue.AdditionalProperties.playStoreMode
            ScreenCaptureBlocked                                     = $getValue.AdditionalProperties.screenCaptureBlocked
            SecurityCommonCriteriaModeEnabled                        = $getValue.AdditionalProperties.securityCommonCriteriaModeEnabled
            SecurityDeveloperSettingsEnabled                         = $getValue.AdditionalProperties.securityDeveloperSettingsEnabled
            SecurityRequireVerifyApps                                = $getValue.AdditionalProperties.securityRequireVerifyApps
            ShortHelpText                                            = $getValue.additionalProperties.shortHelpText
            StatusBarBlocked                                         = $getValue.AdditionalProperties.statusBarBlocked
            StayOnModes                                              = $getValue.AdditionalProperties.stayOnModes
            StorageAllowUsb                                          = $getValue.AdditionalProperties.storageAllowUsb
            StorageBlockExternalMedia                                = $getValue.AdditionalProperties.storageBlockExternalMedia
            StorageBlockUsbFileTransfer                              = $getValue.AdditionalProperties.storageBlockUsbFileTransfer
            SystemUpdateFreezePeriods                                = $getValue.AdditionalProperties.systemUpdateFreezePeriods
            SystemUpdateInstallType                                  = $getValue.AdditionalProperties.systemUpdateInstallType
            SystemUpdateWindowEndMinutesAfterMidnight                = $getValue.AdditionalProperties.systemUpdateWindowEndMinutesAfterMidnight
            SystemUpdateWindowStartMinutesAfterMidnight              = $getValue.AdditionalProperties.systemUpdateWindowStartMinutesAfterMidnight
            SystemWindowsBlocked                                     = $getValue.AdditionalProperties.systemWindowsBlocked
            UsersBlockAdd                                            = $getValue.AdditionalProperties.usersBlockAdd
            UsersBlockRemove                                         = $getValue.AdditionalProperties.usersBlockRemove
            VolumeBlockAdjustment                                    = $getValue.AdditionalProperties.volumeBlockAdjustment
            VpnAlwaysOnLockdownMode                                  = $getValue.AdditionalProperties.vpnAlwaysOnLockdownMode
            VpnAlwaysOnPackageIdentifier                             = $getValue.AdditionalProperties.vpnAlwaysOnPackageIdentifier
            WifiBlockEditConfigurations                              = $getValue.AdditionalProperties.wifiBlockEditConfigurations
            WifiBlockEditPolicyDefinedConfigurations                 = $getValue.AdditionalProperties.wifiBlockEditPolicyDefinedConfigurations
            WorkProfilePasswordExpirationDays                        = $getValue.AdditionalProperties.workProfilePasswordExpirationDays
            WorkProfilePasswordMinimumLength                         = $getValue.AdditionalProperties.workProfilePasswordMinimumLength
            WorkProfilePasswordMinimumLetterCharacters               = $getValue.AdditionalProperties.workProfilePasswordMinimumLetterCharacters
            WorkProfilePasswordMinimumLowerCaseCharacters            = $getValue.AdditionalProperties.workProfilePasswordMinimumLowerCaseCharacters
            WorkProfilePasswordMinimumNonLetterCharacters            = $getValue.AdditionalProperties.workProfilePasswordMinimumNonLetterCharacters
            WorkProfilePasswordMinimumNumericCharacters              = $getValue.AdditionalProperties.workProfilePasswordMinimumNumericCharacters
            WorkProfilePasswordMinimumSymbolCharacters               = $getValue.AdditionalProperties.workProfilePasswordMinimumSymbolCharacters
            WorkProfilePasswordMinimumUpperCaseCharacters            = $getValue.AdditionalProperties.workProfilePasswordMinimumUpperCaseCharacters
            WorkProfilePasswordPreviousPasswordCountToBlock          = $getValue.AdditionalProperties.workProfilePasswordPreviousPasswordCountToBlock
            WorkProfilePasswordRequiredType                          = $getValue.AdditionalProperties.workProfilePasswordRequiredType
            WorkProfilePasswordRequireUnlock                         = $getValue.AdditionalProperties.workProfilePasswordRequireUnlock
            WorkProfilePasswordSignInFailureCountBeforeFactoryReset  = $getValue.AdditionalProperties.workProfilePasswordSignInFailureCountBeforeFactoryReset
            #            Assignments                                              = $getValue.AdditionalProperties.assignments
            #            DeviceSettingStateSummaries                              = $getValue.AdditionalProperties.deviceSettingStateSummaries
            #            DeviceStatuses                                           = $getValue.AdditionalProperties.deviceStatuses
            #            DeviceStatusOverview                                     = $getValue.AdditionalProperties.deviceStatusOverview
            #            GroupAssignments                                         = $getValue.AdditionalProperties.groupAssignments
            #            UserStatuses                                             = $getValue.AdditionalProperties.userStatuses
            #            UserStatusOverview                                       = $getValue.AdditionalProperties.userStatusOverview
            Ensure                                                   = 'Present'
            Credential                                               = $Credential
            ApplicationId                                            = $ApplicationId
            TenantId                                                 = $TenantId
            ApplicationSecret                                        = $ApplicationSecret
            CertificateThumbprint                                    = $CertificateThumbprint
            Managedidentity                                          = $ManagedIdentity.IsPresent
        }

        $myAssignments = @()
        $myAssignments += Get-MgDeviceManagementDeviceConfigurationAssignment -DeviceConfigurationId $getValue.Id
        $assignmentResult = @()
        foreach ($assignmentEntry in $myAssignments)
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
        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $AccountsBlockModification,

        [Parameter()]
        [System.Boolean]
        $AppsAllowInstallFromUnknownSources,

        [Parameter()]
        [ValidateSet('notConfigured', 'userChoice', 'never', 'wiFiOnly', 'always')]
        [System.String]
        $AppsAutoUpdatePolicy,

        [Parameter()]
        [ValidateSet('deviceDefault', 'prompt', 'autoGrant', 'autoDeny')]
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
        [ValidateSet('notConfigured', 'crossProfileDataSharingBlocked', 'dataSharingFromWorkToPersonalBlocked', 'crossProfileDataSharingAllowed', 'unkownFutureValue')]
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
        [ValidateSet('notConfigured', 'dedicatedDevice', 'fullyManaged')]
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
        [ValidateSet('notConfigured', 'notificationsAndSystemInfoEnabled', 'systemInfoOnly')]
        [System.String]
        $KioskCustomizationStatusBar,

        [Parameter()]
        [System.Boolean]
        $KioskCustomizationSystemErrorWarnings,

        [Parameter()]
        [ValidateSet('notConfigured', 'navigationEnabled', 'homeButtonOnly')]
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
        [ValidateSet('notConfigured', 'darkSquare', 'darkCircle', 'lightSquare', 'lightCircle')]
        [System.String]
        $KioskModeFolderIcon,

        [Parameter()]
        [System.Int32]
        $KioskModeGridHeight,

        [Parameter()]
        [System.Int32]
        $KioskModeGridWidth,

        [Parameter()]
        [ValidateSet('notConfigured', 'smallest', 'small', 'regular', 'large', 'largest')]
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
        [ValidateSet('notConfigured', 'simple', 'complex')]
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
        [ValidateSet('notConfigured', 'portrait', 'landscape', 'autoRotate')]
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
        [ValidateSet('notConfigured', 'singleAppMode', 'multiAppMode')]
        [System.String]
        $KioskModeUseManagedHomeScreenApp,

        [Parameter()]
        [System.Boolean]
        $KioskModeVirtualHomeButtonEnabled,

        [Parameter()]
        [ValidateSet('notConfigured', 'swipeUp', 'floating')]
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
        [ValidateSet('notConfigured', 'show', 'hide', 'disabled')]
        [System.String]
        $MicrosoftLauncherDockPresenceConfiguration,

        [Parameter()]
        [System.Boolean]
        $MicrosoftLauncherFeedAllowUserModification,

        [Parameter()]
        [System.Boolean]
        $MicrosoftLauncherFeedEnabled,

        [Parameter()]
        [ValidateSet('notConfigured', 'top', 'bottom', 'hide')]
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
        [ValidateSet('notConfigured', 'camera', 'notifications', 'unredactedNotifications', 'trustAgents', 'fingerprint', 'remoteInput', 'allFeatures', 'face', 'iris', 'biometrics')]
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
        [ValidateSet('deviceDefault', 'required', 'numeric', 'numericComplex', 'alphabetic', 'alphanumeric', 'alphanumericWithSymbols', 'lowSecurityBiometric', 'customPassword')]
        [System.String]
        $PasswordRequiredType,

        [Parameter()]
        [ValidateSet('deviceDefault', 'daily', 'unkownFutureValue')]
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
        [ValidateSet('notConfigured', 'blockedApps', 'allowedApps')]
        [System.String]
        $PersonalProfilePlayStoreMode,

        [Parameter()]
        [System.Boolean]
        $PersonalProfileScreenCaptureBlocked,

        [Parameter()]
        [ValidateSet('notConfigured', 'allowList', 'blockList')]
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
        [ValidateSet('notConfigured', 'ac', 'usb', 'wireless')]
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
        $storageBlockUsbFileTransfer,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $SystemUpdateFreezePeriods,

        [Parameter()]
        [ValidateSet('deviceDefault', 'postpone', 'windowed', 'automatic')]
        [System.String]
        $systemUpdateInstallType,

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
        [ValidateSet('deviceDefault', 'required', 'numeric', 'numericComplex', 'alphabetic', 'alphanumeric', 'alphanumericWithSymbols', 'lowSecurityBiometric', 'customPassword')]
        [System.String]
        $WorkProfilePasswordRequiredType,

        [Parameter()]
        [ValidateSet('deviceDefault', 'daily', 'unkownFutureValue')]
        [System.String]
        $WorkProfilePasswordRequireUnlock,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordSignInFailureCountBeforeFactoryReset,

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

    try
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters `
            -ProfileName 'beta'
    }
    catch
    {
        Write-Verbose -Message $_
    }

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

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating {$DisplayName}"
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $CreateParameters = ([Hashtable]$PSBoundParameters).clone()
        $CreateParameters = Rename-M365DSCCimInstanceODataParameter -Properties $CreateParameters

        $CreateParameters.Remove('Id') | Out-Null
        $CreateParameters.Remove('Verbose') | Out-Null

        foreach ($key in ($CreateParameters.clone()).Keys)
        {
            if ($CreateParameters[$key].getType().Fullname -like '*CimInstance*')
            {
                $CreateParameters[$key] = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $CreateParameters[$key]
            }

            if ($key -ne '@odata.type')
            {
                $keyName = $key.substring(0, 1).ToLower() + $key.substring(1, $key.length - 1)
                $keyValue = $CreateParameters.$key
                $CreateParameters.remove($key) | Out-Null
                $CreateParameters.add($keyName, $keyValue) | Out-Null
            }
        }
        $CreateParameters.add('@odata.type', '#microsoft.graph.androidDeviceOwnerGeneralDeviceConfiguration')

        #region resource generator code
        $policy = New-MgDeviceManagementDeviceConfiguration -BodyParameter $CreateParameters
        $assignmentsHash = @()
        foreach ($assignment in $Assignments)
        {
            $assignmentsHash += Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignment
        }

        if ($policy.id)
        {
            Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $policy.id `
                -Targets $assignmentsHash
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating {$DisplayName}"
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $UpdateParameters = ([Hashtable]$PSBoundParameters).clone()
        $UpdateParameters = Rename-M365DSCCimInstanceODataParameter -Properties $UpdateParameters

        $UpdateParameters.Remove('Id') | Out-Null
        $UpdateParameters.Remove('Verbose') | Out-Null

        foreach ($key in (($UpdateParameters.clone()).Keys | Sort-Object))
        {
            if ($UpdateParameters.$key.getType().Fullname -like '*CimInstance*')
            {
                $UpdateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $UpdateParameters.$key
            }

            if ($key -ne '@odata.type')
            {
                $keyName = $key.substring(0, 1).ToLower() + $key.substring(1, $key.length - 1)
                $keyValue = $UpdateParameters.$key
                $UpdateParameters.remove($key)
                $UpdateParameters.add($keyName, $keyValue)
            }
        }
        $UpdateParameters.add('@odata.type', '#microsoft.graph.androidDeviceOwnerGeneralDeviceConfiguration')

        Update-MgDeviceManagementDeviceConfiguration -BodyParameter $UpdateParameters `
            -DeviceConfigurationId $currentInstance.Id
        $assignmentsHash = @()
        foreach ($assignment in $Assignments)
        {
            $assignmentsHash += Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignment
        }
        Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $currentInstance.id `
            -Targets $assignmentsHash
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing {$DisplayName}"

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
        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $AccountsBlockModification,

        [Parameter()]
        [System.Boolean]
        $AppsAllowInstallFromUnknownSources,

        [Parameter()]
        [ValidateSet('notConfigured', 'userChoice', 'never', 'wiFiOnly', 'always')]
        [System.String]
        $AppsAutoUpdatePolicy,

        [Parameter()]
        [ValidateSet('deviceDefault', 'prompt', 'autoGrant', 'autoDeny')]
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
        [ValidateSet('notConfigured', 'crossProfileDataSharingBlocked', 'dataSharingFromWorkToPersonalBlocked', 'crossProfileDataSharingAllowed', 'unkownFutureValue')]
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
        [ValidateSet('notConfigured', 'dedicatedDevice', 'fullyManaged')]
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
        [ValidateSet('notConfigured', 'notificationsAndSystemInfoEnabled', 'systemInfoOnly')]
        [System.String]
        $KioskCustomizationStatusBar,

        [Parameter()]
        [System.Boolean]
        $KioskCustomizationSystemErrorWarnings,

        [Parameter()]
        [ValidateSet('notConfigured', 'navigationEnabled', 'homeButtonOnly')]
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
        [ValidateSet('notConfigured', 'darkSquare', 'darkCircle', 'lightSquare', 'lightCircle')]
        [System.String]
        $KioskModeFolderIcon,

        [Parameter()]
        [System.Int32]
        $KioskModeGridHeight,

        [Parameter()]
        [System.Int32]
        $KioskModeGridWidth,

        [Parameter()]
        [ValidateSet('notConfigured', 'smallest', 'small', 'regular', 'large', 'largest')]
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
        [ValidateSet('notConfigured', 'simple', 'complex')]
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
        [ValidateSet('notConfigured', 'portrait', 'landscape', 'autoRotate')]
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
        [ValidateSet('notConfigured', 'singleAppMode', 'multiAppMode')]
        [System.String]
        $KioskModeUseManagedHomeScreenApp,

        [Parameter()]
        [System.Boolean]
        $KioskModeVirtualHomeButtonEnabled,

        [Parameter()]
        [ValidateSet('notConfigured', 'swipeUp', 'floating')]
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
        [ValidateSet('notConfigured', 'show', 'hide', 'disabled')]
        [System.String]
        $MicrosoftLauncherDockPresenceConfiguration,

        [Parameter()]
        [System.Boolean]
        $MicrosoftLauncherFeedAllowUserModification,

        [Parameter()]
        [System.Boolean]
        $MicrosoftLauncherFeedEnabled,

        [Parameter()]
        [ValidateSet('notConfigured', 'top', 'bottom', 'hide')]
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
        [ValidateSet('notConfigured', 'camera', 'notifications', 'unredactedNotifications', 'trustAgents', 'fingerprint', 'remoteInput', 'allFeatures', 'face', 'iris', 'biometrics')]
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
        [ValidateSet('deviceDefault', 'required', 'numeric', 'numericComplex', 'alphabetic', 'alphanumeric', 'alphanumericWithSymbols', 'lowSecurityBiometric', 'customPassword')]
        [System.String]
        $PasswordRequiredType,

        [Parameter()]
        [ValidateSet('deviceDefault', 'daily', 'unkownFutureValue')]
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
        [ValidateSet('notConfigured', 'blockedApps', 'allowedApps')]
        [System.String]
        $PersonalProfilePlayStoreMode,

        [Parameter()]
        [System.Boolean]
        $PersonalProfileScreenCaptureBlocked,

        [Parameter()]
        [ValidateSet('notConfigured', 'allowList', 'blockList')]
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
        [ValidateSet('notConfigured', 'ac', 'usb', 'wireless')]
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
        [ValidateSet('deviceDefault', 'postpone', 'windowed', 'automatic')]
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
        [ValidateSet('deviceDefault', 'required', 'numeric', 'numericComplex', 'alphabetic', 'alphanumeric', 'alphanumericWithSymbols', 'lowSecurityBiometric', 'customPassword')]
        [System.String]
        $WorkProfilePasswordRequiredType,

        [Parameter()]
        [ValidateSet('deviceDefault', 'daily', 'unkownFutureValue')]
        [System.String]
        $WorkProfilePasswordRequireUnlock,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordSignInFailureCountBeforeFactoryReset,

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

    Write-Verbose -Message "Testing configuration of {$id}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()

    if ($CurrentValues.Ensure -eq 'Absent')
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

            if (-Not $testResult)
            {
                $testResult = $false
                break
            }

            $ValuesToCheck.Remove($key) | Out-Null
        }
    }

    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null
    $ValuesToCheck.Remove('Id') | Out-Null

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

    #Convert any DateTime to String
    foreach ($key in $ValuesToCheck.Keys)
    {
        if (($null -ne $CurrentValues[$key]) `
                -and ($CurrentValues[$key].getType().Name -eq 'DateTime'))
        {
            $CurrentValues[$key] = $CurrentValues[$key].toString()
        }
    }

    #Compare basic parameters
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
        -InboundParameters $PSBoundParameters `
        -ProfileName 'beta'

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
                Id                    = $config.id
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

            if ($Results.AzureAdSharedDeviceDataClearApps)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.AzureAdSharedDeviceDataClearApps -CIMInstanceName MicrosoftGraphapplistitem
                if ($complexTypeStringResult)
                {
                    $Results.AzureAdSharedDeviceDataClearApps = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('AzureAdSharedDeviceDataClearApps') | Out-Null
                }
            }
            if ($Results.DetailedHelpText)
            {
                $complexTypeMapping = @(
                    @{
                        Name            = 'DetailedHelpText'
                        CimInstanceName = 'MicrosoftGraphandroiddeviceowneruserfacingmessage'
                    }
                    @{
                        Name            = 'localizedMessages'
                        CimInstanceName = 'MicrosoftGraphkeyvaluepair'
                    }
                )

                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.DetailedHelpText `
                    -CIMInstanceName MicrosoftGraphandroiddeviceowneruserfacingmessage `
                    -ComplexTypeMapping $complexTypeMapping

                if ($complexTypeStringResult)
                {
                    $Results.DetailedHelpText = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('DetailedHelpText') | Out-Null
                }
            }
            if ($Results.DeviceOwnerLockScreenMessage)
            {
                $complexTypeMapping = @(
                    @{
                        Name            = 'DeviceOwnerLockScreenMessage'
                        CimInstanceName = 'MicrosoftGraphandroiddeviceowneruserfacingmessage'
                    }
                    @{
                        Name            = 'localizedMessages'
                        CimInstanceName = 'MicrosoftGraphkeyvaluepair'
                        isRequired      = $true
                    }
                )

                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.DeviceOwnerLockScreenMessage `
                    -CIMInstanceName MicrosoftGraphandroiddeviceowneruserfacingmessage `
                    -ComplexTypeMapping $complexTypeMapping
                if ($complexTypeStringResult)
                {
                    $Results.DeviceOwnerLockScreenMessage = $complexTypeStringResult
                }
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
                    $Results.GlobalProxy = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('GlobalProxy') | Out-Null
                }
            }
            if ($Results.KioskModeAppPositions)
            {
                $complexTypeMapping = @(
                    @{
                        Name            = 'kioskModeAppPositions'
                        CimInstanceName = 'MicrosoftGraphandroiddeviceownerkioskmodeapppositionitem'
                    }
                    @{
                        Name            = 'item'
                        CimInstanceName = 'MicrosoftGraphandroiddeviceownerkioskmodefolderitem'
                        isRequired      = $true
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.KioskModeAppPositions `
                    -CIMInstanceName MicrosoftGraphandroiddeviceownerkioskmodeapppositionitem `
                    -ComplexTypeMapping $complexTypeMapping
                if ($complexTypeStringResult)
                {
                    $Results.KioskModeAppPositions = $complexTypeStringResult
                }
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
                    $Results.KioskModeApps = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('KioskModeApps') | Out-Null
                }
            }


            if ($Results.KioskModeManagedFolders)
            {
                $complexTypeMapping = @(
                    @{
                        Name            = 'kioskModeManagedFolders'
                        CimInstanceName = 'MicrosoftGraphandroiddeviceownerkioskmodemanagedfolder'
                    }
                    @{
                        Name            = 'items'
                        CimInstanceName = 'MicrosoftGraphandroiddeviceownerkioskmodefolderitem'
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.KioskModeManagedFolders `
                    -CIMInstanceName MicrosoftGraphandroiddeviceownerkioskmodemanagedfolder `
                    -ComplexTypeMapping $complexTypeMapping

                if ($complexTypeStringResult)
                {
                    $Results.KioskModeManagedFolders = $complexTypeStringResult
                }
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
                    $Results.PersonalProfilePersonalApplications = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('PersonalProfilePersonalApplications') | Out-Null
                }
            }
            if ($Results.ShortHelpText)
            {
                $complexTypeMapping = @(
                    @{
                        Name            = 'ShortHelpText'
                        CimInstanceName = 'MicrosoftGraphandroiddeviceowneruserfacingmessage'
                    }
                    @{
                        Name            = 'localizedMessages'
                        CimInstanceName = 'MicrosoftGraphkeyvaluepair'
                        isRequired      = $true
                        isArray         = $true
                    }
                )

                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.ShortHelpText `
                    -CIMInstanceName MicrosoftGraphandroiddeviceowneruserfacingmessage `
                    -ComplexTypeMapping $complexTypeMapping
                if ($complexTypeStringResult)
                {
                    $Results.ShortHelpText = $complexTypeStringResult
                }
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
                    $Results.SystemUpdateFreezePeriods = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('SystemUpdateFreezePeriods') | Out-Null
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
            if ($Results.AzureAdSharedDeviceDataClearApps)
            {
                $isCIMArray = $false
                if ($Results.AzureAdSharedDeviceDataClearApps.getType().Fullname -like '*[[\]]')
                {
                    $isCIMArray = $true
                }
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'AzureAdSharedDeviceDataClearApps' -IsCIMArray:$isCIMArray
            }
            if ($Results.DetailedHelpText)
            {
                $isCIMArray = $false
                if ($Results.DetailedHelpText.getType().Fullname -like '*[[\]]')
                {
                    $isCIMArray = $true
                }
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'DetailedHelpText' -IsCIMArray:$isCIMArray
            }
            if ($Results.DeviceOwnerLockScreenMessage)
            {
                $isCIMArray = $false
                if ($Results.DeviceOwnerLockScreenMessage.getType().Fullname -like '*[[\]]')
                {
                    $isCIMArray = $true
                }
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'DeviceOwnerLockScreenMessage' -IsCIMArray:$isCIMArray
            }
            if ($Results.GlobalProxy)
            {
                $isCIMArray = $false
                if ($Results.GlobalProxy.getType().Fullname -like '*[[\]]')
                {
                    $isCIMArray = $true
                }
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'GlobalProxy' -IsCIMArray:$isCIMArray
            }
            if ($Results.KioskModeAppPositions)
            {
                $isCIMArray = $false
                if ($Results.KioskModeAppPositions.getType().Fullname -like '*[[\]]')
                {
                    $isCIMArray = $true
                }
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'KioskModeAppPositions' -IsCIMArray:$isCIMArray
            }

            if ($Results.KioskModeApps)
            {
                $isCIMArray = $false
                if ($Results.KioskModeApps.getType().Fullname -like '*[[\]]')
                {
                    $isCIMArray = $true
                }
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'KioskModeApps' -IsCIMArray:$isCIMArray
            }

            if ($Results.KioskModeManagedFolders)
            {
                $isCIMArray = $false
                if ($Results.KioskModeManagedFolders.getType().Fullname -like '*[[\]]')
                {
                    $isCIMArray = $true
                }
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'KioskModeManagedFolders' -IsCIMArray:$isCIMArray -Verbose
            }

            if ($Results.PersonalProfilePersonalApplications)
            {
                $isCIMArray = $false
                if ($Results.PersonalProfilePersonalApplications.getType().Fullname -like '*[[\]]')
                {
                    $isCIMArray = $true
                }
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'PersonalProfilePersonalApplications' -IsCIMArray:$isCIMArray
            }
            if ($Results.ShortHelpText)
            {
                $isCIMArray = $false
                if ($Results.ShortHelpText.getType().Fullname -like '*[[\]]')
                {
                    $isCIMArray = $true
                }
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'ShortHelpText' -IsCIMArray:$isCIMArray
            }
            if ($Results.SystemUpdateFreezePeriods)
            {
                $isCIMArray = $false
                if ($Results.SystemUpdateFreezePeriods.getType().Fullname -like '*[[\]]')
                {
                    $isCIMArray = $true
                }
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'SystemUpdateFreezePeriods' -IsCIMArray:$isCIMArray
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
        Write-Host $Global:M365DSCEmojiGreenCheckMark
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ''
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
        return ''
    }
}


function Get-M365DSCDRGComplexTypeToHashtable
{
    [CmdletBinding()]
    [OutputType([hashtable], [hashtable[]])]
    param(
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
    param(
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
function Rename-M365DSCCimInstanceODataParameter
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = 'true')]
        $Properties
    )
    $clonedProperties = $Properties.clone()
    foreach ($key in $Properties.keys)
    {
        if ($Properties.$key)
        {

            switch -Wildcard ($Properties.$key.GetType().Fullname)
            {
                '*CimInstance[[\]]'
                {
                    if ($properties.$key.count -gt 0)
                    {
                        $values = @()

                        foreach ($item in $Properties.$key)
                        {
                            $CIMHash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
                            $values += Rename-M365DSCCimInstanceODataParameter -Properties $CIMHash
                        }
                        $clonedProperties.$key = $values
                    }
                    break
                }
                '*hashtable[[\]]'
                {
                    if ($properties.$key.count -gt 0)
                    {
                        $values = @()

                        foreach ($item in $Properties.$key)
                        {
                            $CIMHash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
                            $values += Rename-M365DSCCimInstanceODataParameter -Properties $CIMHash
                        }
                        $clonedProperties.$key = $values
                    }
                    break
                }
                '*CimInstance'
                {
                    $CIMHash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Properties.$key
                    $keys = ($CIMHash.clone()).keys

                    if ($keys -contains 'odataType')
                    {
                        $CIMHash.add('@odata.type', $CIMHash.odataType)
                        $CIMHash.remove('odataType')
                        $clonedProperties.$key = $CIMHash
                    }
                    break
                }
                '*Hashtable'
                {
                    $keys = ($Properties.$key).keys
                    if ($keys -contains 'odataType')
                    {
                        $Properties.$key.add('@odata.type', $Properties.$key.odataType)
                        $Properties.$key.remove('odataType')
                        $clonedProperties.$key = $Properties.$key
                    }
                    break
                }
                Default
                {
                    if ($key -eq 'odataType')
                    {
                        $clonedProperties.remove('odataType')
                        $clonedProperties.add('@odata.type', $properties.$key)
                    }
                }
            }
        }
    }

    return $clonedProperties
}
function Compare-M365DSCComplexObject
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param(
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
    param(
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
        $deviceManagementPolicyAssignments = @()

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
            $deviceManagementPolicyAssignments += @{'target' = $formattedTarget }
        }
        $body = @{'assignments' = $deviceManagementPolicyAssignments } | ConvertTo-Json -Depth 20
        #write-verbose -Message $body
        Invoke-MgGraphRequest -Method POST -Uri $Uri -Body $body -ErrorAction Stop

    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ''
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
