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
            -InboundParameters $PSBoundParameters
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
        $getValue = Get-MgBetaDeviceManagementDeviceConfiguration -DeviceConfigurationId $id -ErrorAction SilentlyContinue

        if (-not $getValue)
        {
            $getValue = Get-MgBetaDeviceManagementDeviceConfiguration -Filter "DisplayName eq '$Displayname'" -ErrorAction SilentlyContinue | Where-Object `
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

        $complexAzureAdSharedDeviceDataClearApps = @()
        $currentValueArray = $getValue.AdditionalProperties.azureAdSharedDeviceDataClearApps
        if ($null -ne $currentValueArray -and $currentValueArray.count -gt 0 )
        {
            foreach($currentValue in $currentValueArray)
            {
                $currentHash = @{
                    appId       = $currentValue.appId
                    publisher   = $currentValue.publisher
                    appStoreUrl = $currentValue.appStoreUrl
                    name        = $currentValue.name
                    odataType   = $currentValue.'@odata.type'
                }
                $complexAzureAdSharedDeviceDataClearApps += $currentHash
            }
        }

        $complexDetailedHelpText = @{}
        $currentValue = $getValue.AdditionalProperties.detailedHelpText
        if ($null -ne $currentValue)
        {
            $complexDetailedHelpText.Add('DefaultMessage',$currentValue.defaultMessage)
            $complexLocalizedMessages = @()
            $currentValueArray = $currentValue.localizedMessages
            if ($null -ne $currentValueArray -and $currentValueArray.count -gt 0 )
            {
                foreach($currentChildValue in $currentValueArray)
                {
                    $currentHash = @{
                        Name = $currentChildValue.name
                        Value = $currentChildValue.value
                    }
                    $complexLocalizedMessages += $currentHash
                }
            }
            $complexDetailedHelpText.Add('LocalizedMessages',$complexLocalizedMessages)
        }

        $complexDeviceOwnerLockScreenMessage = @{}
        $currentValue = $getValue.AdditionalProperties.deviceOwnerLockScreenMessage
        if ($null -ne $currentValue)
        {
            $complexDeviceOwnerLockScreenMessage.Add('DefaultMessage',$currentValue.defaultMessage)
            $complexLocalizedMessages = @()
            $currentValueArray = $currentValue.localizedMessages
            if ($null -ne $currentValueArray -and $currentValueArray.count -gt 0 )
            {
                foreach($currentChildValue in $currentValueArray)
                {
                    $currentHash = @{
                        Name = $currentChildValue.name
                        Value = $currentChildValue.value
                    }
                    $complexLocalizedMessages += $currentHash
                }
            }
            $complexDeviceOwnerLockScreenMessage.Add('LocalizedMessages',$complexLocalizedMessages)
        }

        $complexGlobalProxy = @{}
        $currentValue = $getValue.AdditionalProperties.globalProxy
        if ($null -ne $currentValue)
        {
            $complexGlobalProxy.Add('ProxyAutoConfigURL',$currentValue.proxyAutoConfigURL)
            $complexGlobalProxy.Add('ExcludedHosts',$currentValue.excludedHosts)
            $complexGlobalProxy.Add('Host',$currentValue.host)
            $complexGlobalProxy.Add('Port',$currentValue.port)
            $complexGlobalProxy.Add('oDataType',$currentValue.'@odata.type')
        }

        $complexKioskModeApps = @()
        $currentValueArray = $getValue.AdditionalProperties.kioskModeApps
        if ($null -ne $currentValueArray -and $currentValueArray.count -gt 0 )
        {
            foreach($currentValue in $currentValueArray)
            {
                $currentHash = @{}
                $currentHash.add('AppId',$currentValue.appid)
                $currentHash.add('Publisher',$currentValue.publisher)
                $currentHash.add('AppStoreUrl',$currentValue.appStoreUrl)
                $currentHash.add('Name',$currentValue.name)
                $currentHash.add('oDataType',$currentValue.'@odata.type')
                $complexKioskModeApps += $currentHash
            }
        }

        $complexPersonalProfilePersonalApplications = @()
        $currentValueArray = $getValue.AdditionalProperties.personalProfilePersonalApplications
        if ($null -ne $currentValueArray -and $currentValueArray.count -gt 0 )
        {
            foreach($currentValue in $currentValueArray)
            {
                $currentHash = @{}
                $currentHash.add('AppId',$currentValue.appid)
                $currentHash.add('Publisher',$currentValue.publisher)
                $currentHash.add('AppStoreUrl',$currentValue.appStoreUrl)
                $currentHash.add('Name',$currentValue.name)
                $currentHash.add('oDataType',$currentValue.'@odata.type')
                $complexPersonalProfilePersonalApplications += $currentHash
            }
        }

        $complexShortHelpText = @{}
        $currentValue = $getValue.AdditionalProperties.shortHelpText
        if ($null -ne $currentValue)
        {
            $complexShortHelpText.Add('DefaultMessage',$currentValue.defaultMessage)
            $complexLocalizedMessages = @()
            $currentValueArray = $currentValue.localizedMessages
            if ($null -ne $currentValueArray -and $currentValueArray.count -gt 0 )
            {
                foreach($currentChildValue in $currentValueArray)
                {
                    $currentHash = @{
                        Name = $currentChildValue.name
                        Value = $currentChildValue.value
                    }
                    $complexLocalizedMessages += $currentHash
                }
            }
            $complexShortHelpText.Add('LocalizedMessages',$complexLocalizedMessages)
        }

        $complexSystemUpdateFreezePeriods = @()
        $currentValueArray = $getValue.AdditionalProperties.systemUpdateFreezePeriods
        if ($null -ne $currentValueArray -and $currentValueArray.count -gt 0 )
        {
            foreach($currentValue in $currentValueArray)
            {
                $currentHash = @{}
                $currentHash.Add('StartDay',$currentValue.startDay)
                $currentHash.Add('EndDay',$currentValue.endDay)
                $currentHash.Add('StartMonth',$currentValue.startMonth)
                $currentHash.Add('EndMonth',$currentValue.endMonth)
                $complexSystemUpdateFreezePeriods += $currentHash
            }
        }

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
            AzureAdSharedDeviceDataClearApps                         = $complexAzureAdSharedDeviceDataClearApps
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
            DetailedHelpText                                         = $complexDetailedHelpText
            DeviceOwnerLockScreenMessage                             = $complexDeviceOwnerLockScreenMessage
            EnrollmentProfile                                        = $getValue.AdditionalProperties.enrollmentProfile
            FactoryResetBlocked                                      = $getValue.AdditionalProperties.factoryResetBlocked
            FactoryResetDeviceAdministratorEmails                    = $getValue.AdditionalProperties.factoryResetDeviceAdministratorEmails
            GlobalProxy                                              = $complexGlobalProxy
            GoogleAccountsBlocked                                    = $getValue.AdditionalProperties.googleAccountsBlocked
            KioskCustomizationDeviceSettingsBlocked                  = $getValue.AdditionalProperties.kioskCustomizationDeviceSettingsBlocked
            KioskCustomizationPowerButtonActionsBlocked              = $getValue.AdditionalProperties.kioskCustomizationPowerButtonActionsBlocked
            KioskCustomizationStatusBar                              = $getValue.AdditionalProperties.kioskCustomizationStatusBar
            KioskCustomizationSystemErrorWarnings                    = $getValue.AdditionalProperties.kioskCustomizationSystemErrorWarnings
            KioskCustomizationSystemNavigation                       = $getValue.AdditionalProperties.kioskCustomizationSystemNavigation
            KioskModeAppOrderEnabled                                 = $getValue.AdditionalProperties.kioskModeAppOrderEnabled
            KioskModeAppPositions                                    = $getValue.AdditionalProperties.kioskModeAppPositions
            KioskModeApps                                            = $complexKioskModeApps
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
            PersonalProfilePersonalApplications                      = $complexPersonalProfilePersonalApplications
            PersonalProfilePlayStoreMode                             = $getValue.AdditionalProperties.personalProfilePlayStoreMode
            PersonalProfileScreenCaptureBlocked                      = $getValue.AdditionalProperties.personalProfileScreenCaptureBlocked
            PlayStoreMode                                            = $getValue.AdditionalProperties.playStoreMode
            ScreenCaptureBlocked                                     = $getValue.AdditionalProperties.screenCaptureBlocked
            SecurityCommonCriteriaModeEnabled                        = $getValue.AdditionalProperties.securityCommonCriteriaModeEnabled
            SecurityDeveloperSettingsEnabled                         = $getValue.AdditionalProperties.securityDeveloperSettingsEnabled
            SecurityRequireVerifyApps                                = $getValue.AdditionalProperties.securityRequireVerifyApps
            ShortHelpText                                            = $complexShortHelpText
            StatusBarBlocked                                         = $getValue.AdditionalProperties.statusBarBlocked
            StayOnModes                                              = $getValue.AdditionalProperties.stayOnModes
            StorageAllowUsb                                          = $getValue.AdditionalProperties.storageAllowUsb
            StorageBlockExternalMedia                                = $getValue.AdditionalProperties.storageBlockExternalMedia
            StorageBlockUsbFileTransfer                              = $getValue.AdditionalProperties.storageBlockUsbFileTransfer
            SystemUpdateFreezePeriods                                = $complexSystemUpdateFreezePeriods
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
            Ensure                                                   = 'Present'
            Credential                                               = $Credential
            ApplicationId                                            = $ApplicationId
            TenantId                                                 = $TenantId
            ApplicationSecret                                        = $ApplicationSecret
            CertificateThumbprint                                    = $CertificateThumbprint
            Managedidentity                                          = $ManagedIdentity.IsPresent
        }

        $myAssignments=@()
        $myAssignments += Get-MgBetaDeviceManagementDeviceConfigurationAssignment -DeviceConfigurationId  $getValue.Id
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
        write-verbose $_
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
            -InboundParameters $PSBoundParameters
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
        $CreateParameters = Rename-M365DSCCimInstanceParameter -Properties $CreateParameters

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
        $policy = New-MgBetaDeviceManagementDeviceConfiguration -BodyParameter $CreateParameters
        $assignmentsHash=@()
        foreach($assignment in $Assignments)
        {
            $assignmentsHash += Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignment
        }

        if ($policy.id)
        {
            Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId  $policy.id `
                -Targets $assignmentsHash `
                -Repository 'deviceManagement/deviceConfigurations'
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating {$DisplayName}"
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $UpdateParameters = ([Hashtable]$PSBoundParameters).clone()
        $UpdateParameters = Rename-M365DSCCimInstanceParameter -Properties $UpdateParameters

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

        Update-MgBetaDeviceManagementDeviceConfiguration -BodyParameter $UpdateParameters `
            -DeviceConfigurationId $currentInstance.Id
        $assignmentsHash = @()
        foreach ($assignment in $Assignments)
        {
            $assignmentsHash += Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignment
        }
        Update-DeviceConfigurationPolicyAssignment `
            -DeviceConfigurationPolicyId $currentInstance.id `
            -Targets $assignmentsHash `
            -Repository 'deviceManagement/deviceConfigurations'
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing {$DisplayName}"

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

    if ($CurrentValues.Ensure -ne $Ensure)
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
                -Target ($target) -verbose

            if (-Not $testResult)
            {
                Write-Verbose -Message "Drift detected for the complex object key: $key"
                $testResult = $false
                break
            }

            $ValuesToCheck.Remove($key) | Out-Null
        }
    }

    if ($testResult)
    {
        $ValuesToCheck = Remove-M365DSCAuthenticationParameter -BoundParameters $ValuesToCheck
        $ValuesToCheck.Remove('Id') | Out-Null

        Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
        Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

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
        if ($_.Exception -like '*401*' -or $_.ErrorDetails.Message -like "*`"ErrorCode`":`"Forbidden`"*" -or `
        $_.Exception -like "*Request not applicable to target tenant*")
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
