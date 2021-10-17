function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $AccountBlockModification,

        [Parameter()]
        [System.Boolean]
        $ActivationLockAllowWhenSupervised,

        [Parameter()]
        [System.Boolean]
        $AirDropBlocked,

        [Parameter()]
        [System.Boolean]
        $AirDropForceUnmanagedDropTarget,

        [Parameter()]
        [System.Boolean]
        $AirPlayForcePairingPasswordForOutgoingRequests,

        [Parameter()]
        [System.Boolean]
        $AppleWatchBlockPairing,

        [Parameter()]
        [System.Boolean]
        $AppleWatchForceWristDetection,

        [Parameter()]
        [System.Boolean]
        $AppleNewsBlocked,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AppsSingleAppModeList,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AppsVisibilityList,

        [Parameter()]
        [System.String]
        [ValidateSet('None', 'AppsInListCompliant','AppsNotInListCompliant')]
        $AppsVisibilityListType,

        [Parameter()]
        [System.Boolean]
        $AppStoreBlockAutomaticDownloads,

        [Parameter()]
        [System.Boolean]
        $AppStoreBlocked,

        [Parameter()]
        [System.Boolean]
        $AppStoreBlockInAppPurchases,

        [Parameter()]
        [System.Boolean]
        $AppStoreBlockUIAppInstallation,

        [Parameter()]
        [System.Boolean]
        $AppStoreRequirePassword,

        [Parameter()]
        [System.Boolean]
        $AutoFillForceAuthentication,

        [Parameter()]
        [System.Boolean]
        $BluetoothBlockModification,

        [Parameter()]
        [System.Boolean]
        $CameraBlocked,

        [Parameter()]
        [System.Boolean]
        $CellularBlockDataRoaming,

        [Parameter()]
        [System.Boolean]
        $CellularBlockGlobalBackgroundFetchWhileRoaming,

        [Parameter()]
        [System.Boolean]
        $CellularBlockPerAppDataModification,

        [Parameter()]
        [System.Boolean]
        $CellularBlockPersonalHotspot,

        [Parameter()]
        [System.Boolean]
        $CellularBlockPlanModification,

        [Parameter()]
        [System.Boolean]
        $CellularBlockVoiceRoaming,

        [Parameter()]
        [System.Boolean]
        $CertificatesBlockUntrustedTlsCertificates,

        [Parameter()]
        [System.Boolean]
        $ClassroomAppBlockRemoteScreenObservation,

        [Parameter()]
        [System.Boolean]
        $ClassroomAppForceUnpromptedScreenObservation,

        [Parameter()]
        [System.Boolean]
        $ClassroomForceAutomaticallyJoinClasses,

        [Parameter()]
        [System.Boolean]
        $ClassroomForceUnpromptedAppAndDeviceLock,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CompliantAppsList,

        [Parameter()]
        [System.String]
        [ValidateSet('None', 'AppsInListCompliant','AppsNotInListCompliant')]
        $CompliantAppListType,

        [Parameter()]
        [System.Boolean]
        $ConfigurationProfileBlockChanges,

        [Parameter()]
        [System.Boolean]
        $DefinitionLookupBlocked,

        [Parameter()]
        [System.Boolean]
        $DeviceBlockEnableRestrictions,

        [Parameter()]
        [System.Boolean]
        $DeviceBlockEraseContentAndSettings,

        [Parameter()]
        [System.Boolean]
        $DeviceBlockNameModification,

        [Parameter()]
        [System.Boolean]
        $DiagnosticDataBlockSubmission,

        [Parameter()]
        [System.Boolean]
        $DiagnosticDataBlockSubmissionModification,

        [Parameter()]
        [System.Boolean]
        $DocumentsBlockManagedDocumentsInUnmanagedApps,

        [Parameter()]
        [System.Boolean]
        $DocumentsBlockUnmanagedDocumentsInManagedApps,

        [Parameter()]
        [System.String[]]
        $EmailInDomainSuffixes,

        [Parameter()]
        [System.Boolean]
        $EnterpriseAppBlockTrust,

        [Parameter()]
        [System.Boolean]
        $EnterpriseAppBlockTrustModification,

        [Parameter()]
        [System.Boolean]
        $FaceTimeBlocked,

        [Parameter()]
        [System.Boolean]
        $FindMyFriendsBlocked,

        [Parameter()]
        [System.Boolean]
        $GamingBlockGameCenterFriends,

        [Parameter()]
        [System.Boolean]
        $GamingBlockMultiplayer,

        [Parameter()]
        [System.Boolean]
        $GameCenterBlocked,

        [Parameter()]
        [System.Boolean]
        $HostPairingBlocked,

        [Parameter()]
        [System.Boolean]
        $iBooksStoreBlocked,

        [Parameter()]
        [System.Boolean]
        $iBooksStoreBlockErotica,

        [Parameter()]
        [System.Boolean]
        $iCloudBlockActivityContinuation,

        [Parameter()]
        [System.Boolean]
        $iCloudBlockBackup,

        [Parameter()]
        [System.Boolean]
        $iCloudBlockDocumentSync,

        [Parameter()]
        [System.Boolean]
        $iCloudBlockManagedAppsSync,

        [Parameter()]
        [System.Boolean]
        $iCloudBlockPhotoLibrary,

        [Parameter()]
        [System.Boolean]
        $iCloudBlockPhotoStreamSync,

        [Parameter()]
        [System.Boolean]
        $iCloudBlockSharedPhotoStream,

        [Parameter()]
        [System.Boolean]
        $iCloudRequireEncryptedBackup,

        [Parameter()]
        [System.Boolean]
        $iTunesBlockExplicitContent,

        [Parameter()]
        [System.Boolean]
        $iTunesBlockMusicService,

        [Parameter()]
        [System.Boolean]
        $iTunesBlockRadio,

        [Parameter()]
        [System.Boolean]
        $KeyboardBlockAutoCorrect,

        [Parameter()]
        [System.Boolean]
        $KeyboardBlockDictation,

        [Parameter()]
        [System.Boolean]
        $KeyboardBlockPredictive,

        [Parameter()]
        [System.Boolean]
        $KeyboardBlockShortcuts,

        [Parameter()]
        [System.Boolean]
        $KeyboardBlockSpellCheck,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowAssistiveSpeak,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowAssistiveTouchSettings,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowAutoLock,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockAutoLock,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowColorInversionSettings,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowRingerSwitch,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockRingerSwitch,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowScreenRotation,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockScreenRotation,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowSleepButton,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockSleepButton,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowTouchscreen,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockTouchscreen,

        [Parameter()]
        [System.Boolean]
        $KioskModeEnableVoiceControl,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowVoiceControlModification,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowVoiceOverSettings,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowVolumeButtons,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockVolumeButtons,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowZoomSettings,

        [Parameter()]
        [System.String]
        $KioskModeAppStoreUrl,

        [Parameter()]
        [System.String]
        $KioskModeBuiltInAppId,

        [Parameter()]
        [System.Boolean]
        $KioskModeRequireAssistiveTouch,

        [Parameter()]
        [System.Boolean]
        $KioskModeRequireColorInversion,

        [Parameter()]
        [System.Boolean]
        $KioskModeRequireMonoAudio,

        [Parameter()]
        [System.Boolean]
        $KioskModeRequireVoiceOver,

        [Parameter()]
        [System.Boolean]
        $KioskModeRequireZoom,

        [Parameter()]
        [System.String]
        $KioskModeManagedAppId,

        [Parameter()]
        [System.Boolean]
        $LockScreenBlockControlCenter,

        [Parameter()]
        [System.Boolean]
        $LockScreenBlockNotificationView,

        [Parameter()]
        [System.Boolean]
        $LockScreenBlockPassbook,

        [Parameter()]
        [System.Boolean]
        $LockScreenBlockTodayView,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $MediaContentRatingAustralia,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $MediaContentRatingCanada,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $MediaContentRatingFrance,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $MediaContentRatingGermany,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $MediaContentRatingIreland,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $MediaContentRatingJapan,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $MediaContentRatingNewZealand,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $MediaContentRatingUnitedKingdom,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $MediaContentRatingUnitedStates,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $NetworkUsageRules,

        [Parameter()]
        [System.String]
        [ValidateSet('AllAllowed', 'AllBlocked','AgesAbove4','AgesAbove9','AgesAbove12','AgesAbove17')]
        $MediaContentRatingApps,

        [Parameter()]
        [System.Boolean]
        $MessagesBlocked,

        [Parameter()]
        [System.Boolean]
        $NotificationsBlockSettingsModification,

        [Parameter()]
        [System.Boolean]
        $PasscodeBlockFingerprintUnlock,

        [Parameter()]
        [System.Boolean]
        $PasscodeBlockModification,

        [Parameter()]
        [System.Boolean]
        $PasscodeBlockSimple,

        [Parameter()]
        [System.String]
        $PasscodeExpirationDays,

        [Parameter()]
        [System.Uint32]
        $PasscodeMinimumLength,

        [Parameter()]
        [System.String]
        $PasscodeMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.String]
        $PasscodeMinutesOfInactivityBeforeScreenTimeout,

        [Parameter()]
        [System.String]
        $PasscodeMinimumCharacterSetCount,

        [Parameter()]
        [System.String]
        $PasscodePreviousPasscodeBlockCount,

        [Parameter()]
        [System.String]
        $PasscodeSignInFailureCountBeforeWipe,

        [Parameter()]
        [System.String]
        [ValidateSet('DeviceDefault', 'Alphanumeric','Numeric')]
        $PasscodeRequiredType = "deviceDefault",

        [Parameter()]
        [System.Boolean]
        $PasscodeRequired,

        [Parameter()]
        [System.Boolean]
        $PodcastsBlocked,

        [Parameter()]
        [System.Boolean]
        $ProximityBlockSetupToNewDevice,

        [Parameter()]
        [System.Boolean]
        $SafariBlockAutofill,

        [Parameter()]
        [System.Boolean]
        $SafariBlockJavaScript,

        [Parameter()]
        [System.Boolean]
        $SafariBlockPopups,

        [Parameter()]
        [System.Boolean]
        $SafariBlocked,

        [Parameter()]
        [System.String]
        [ValidateSet('BrowserDefault', 'BlockAlways','AllowCurrentWebSite','AllowFromWebsitesVisited','AllowAlways')]
        $SafariCookieSettings,

        [Parameter()]
        [System.String[]]
        $SafariManagedDomains,

        [Parameter()]
        [System.String[]]
        $SafariPasswordAutoFillDomains,

        [Parameter()]
        [System.Boolean]
        $SafariRequireFraudWarning,

        [Parameter()]
        [System.Boolean]
        $ScreenCaptureBlocked,

        [Parameter()]
        [System.Boolean]
        $SiriBlocked,

        [Parameter()]
        [System.Boolean]
        $SiriBlockedWhenLocked,

        [Parameter()]
        [System.Boolean]
        $SiriBlockUserGeneratedContent,

        [Parameter()]
        [System.Boolean]
        $SiriRequireProfanityFilter,

        [Parameter()]
        [System.Uint32]
        $SoftwareUpdatesEnforcedDelayInDays,

        [Parameter()]
        [System.Boolean]
        $SoftwareUpdatesForceDelayed,

        [Parameter()]
        [System.Boolean]
        $SpotlightBlockInternetResults,

        [Parameter()]
        [System.Boolean]
        $VoiceDialingBlocked,

        [Parameter()]
        [System.Boolean]
        $WallpaperBlockModification,

        [Parameter()]
        [System.Boolean]
	    $WiFiConnectOnlyToConfiguredNetworks,

	    [Parameter()]
        [System.Boolean]
	    $ClassroomForceRequestPermissionToLeaveClasses,

        [Parameter()]
        [System.Boolean]
	    $KeychainBlockCloudSync,

	    [Parameter()]
        [System.Boolean]
	    $PkiBlockOTAUpdates,

        [Parameter()]
        [System.Boolean]
	    $PrivacyForceLimitAdTracking,

        [Parameter()]
        [System.Boolean]
	    $EnterpriseBookBlockBackup,

        [Parameter()]
        [System.Boolean]
	    $EnterpriseBookBlockMetadataSync,

	    [Parameter()]
        [System.Boolean]
	    $AirPrintBlocked,

        [Parameter()]
        [System.Boolean]
	    $AirPrintBlockCredentialsStorage,

        [Parameter()]
        [System.Boolean]
	    $AirPrintForceTrustedTLS,

        [Parameter()]
        [System.Boolean]
	    $AirPrintBlockiBeaconDiscovery,

        [Parameter()]
        [System.Boolean]
	    $FilesNetworkDriveAccessBlocked,

        [Parameter()]
        [System.Boolean]
	    $FilesUsbDriveAccessBlocked,

        [Parameter()]
        [System.Boolean]
	    $WifiPowerOnForced,

        [Parameter()]
        [System.Boolean]
	    $BlockSystemAppRemoval,

        [Parameter()]
        [System.Boolean]
	    $VpnBlockCreation,

        [Parameter()]
        [System.Boolean]
	    $AppRemovalBlocked,

        [Parameter()]
        [System.Boolean]
	    $UsbRestrictedModeBlocked,

        [Parameter()]
        [System.Boolean]
	    $PasswordBlockAutoFill,

        [Parameter()]
        [System.Boolean]
	    $PasswordBlockProximityRequests,

        [Parameter()]
        [System.Boolean]
	    $PasswordBlockAirDropSharing,

        [Parameter()]
        [System.Boolean]
	    $DateAndTimeForceSetAutomatically,

        [Parameter()]
        [System.Boolean]
	    $ContactsAllowManagedToUnmanagedWrite,

        [Parameter()]
        [System.Boolean]
	    $ContactsAllowUnmanagedToManagedRead,

        [Parameter()]
        [System.Boolean]
	    $CellularBlockPersonalHotspotModification,

        [Parameter()]
        [System.Boolean]
	    $ContinuousPathKeyboardBlocked,

        [Parameter()]
        [System.Boolean]
	    $FindMyDeviceInFindMyAppBlocked,

        [Parameter()]
        [System.Boolean]
	    $FindMyFriendsInFindMyAppBlocked,

        [Parameter()]
        [System.Boolean]
	    $ITunesBlocked,

        [Parameter()]
        [System.Boolean]
	    $SharedDeviceBlockTemporarySessions,

        [Parameter()]
        [System.Boolean]
	    $AppClipsBlocked,

        [Parameter()]
        [System.Boolean]
	    $ApplePersonalizedAdsBlocked,

        [Parameter()]
        [System.Boolean]
	    $NfcBlocked,

        [Parameter()]
        [System.Boolean]
	    $AutoUnlockBlocked,

        [Parameter()]
        [System.Boolean]
	    $UnpairedExternalBootToRecoveryAllowed,

        [Parameter()]
        [System.Boolean]
	    $OnDeviceOnlyDictationForced,

        [Parameter()]
        [System.Boolean]
	    $WiFiConnectToAllowedNetworksOnlyForced,

        [Parameter()]
        [System.Boolean]
	    $OnDeviceOnlyTranslationForced,

        [Parameter()]
        [System.Boolean]
	    $ManagedPasteboardRequired,

        [Parameter()]
        [System.String]
	    [ValidateSet('NotConfigured', 'AppStoreApp','ManagedApp','BuiltInApp')]
        $KioskModeAppType,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $deviceManagementApplicabilityRuleOsVersion,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $deviceManagementApplicabilityRuleOsEdition,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $deviceManagementApplicabilityRuleDeviceMode,

        [Parameter(Mandatory = $true)]
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
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Checking for the Intune Device Configuration Policy {$DisplayName}"
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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
        $policy = Get-MgDeviceManagementDeviceConfiguration -Filter "displayName eq '$DisplayName'" `
            -ErrorAction Stop | Where-Object -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.iosGeneralDeviceConfiguration' }

        if ($null -eq $policy)
        {
            Write-Verbose -Message "No Device Configuration Policy {$DisplayName} was found"
            return $nullResult
        }
        elseif ($null -ne $policy.AdditionalProperties.appsVisibilityList)
        {
            $appsVisibilityList = Get-M365DSCIntuneNestedObject -Properties $policy.AdditionalProperties.appsVisibilityList
        }
        elseif ($null -ne $policy.AdditionalProperties.appsSingleAppModeList)
        {
            $appsSingleAppModeList = Get-M365DSCIntuneNestedObject -Properties $policy.AdditionalProperties.appsSingleAppModeList
        }
        elseif ($null -ne $policy.AdditionalProperties.compliantAppsList)
        {
            $compliantAppsList = Get-M365DSCIntuneNestedObject -Properties $policy.AdditionalProperties.compliantAppsList
        }
        elseif ($null -ne $policy.AdditionalProperties.mediaContentRatingAustralia)
        {
            #$mediaContentRatingAustralia = @{"@odata.type" = "#microsoft.graph.mediaContentRatingAustralia"}
            $mediaContentRatingAustralia = Get-M365DSCIntuneNestedObject -Properties $policy.AdditionalProperties.mediaContentRatingAustralia
        }
        elseif ($null -ne $policy.AdditionalProperties.mediaContentRatingCanada)
        {
            $mediaContentRatingCanada = Get-M365DSCIntuneNestedObject -Properties $policy.AdditionalProperties.mediaContentRatingCanada
        }
        elseif ($null -ne $policy.AdditionalProperties.mediaContentRatingFrance)
        {
            $mediaContentRatingFrance = Get-M365DSCIntuneNestedObject -Properties $policy.AdditionalProperties.mediaContentRatingFrance
        }
        elseif ($null -ne $policy.AdditionalProperties.AdditionalProperties.mediaContentRatingGermany)
        {
            $mediaContentRatingGermany = Get-M365DSCIntuneNestedObject -Properties $policy.AdditionalProperties.mediaContentRatingGermany
        }
        elseif ($null -ne $policy.AdditionalProperties.mediaContentRatingIreland)
        {
            $mediaContentRatingIreland = Get-M365DSCIntuneNestedObject -Properties $policy.AdditionalProperties.mediaContentRatingIreland
        }
        elseif ($null -ne $policy.AdditionalProperties.mediaContentRatingJapan)
        {
            $mediaContentRatingJapan = Get-M365DSCIntuneNestedObject -Properties $policy.AdditionalProperties.mediaContentRatingJapan
        }
        elseif ($null -ne $policy.AdditionalProperties.mediaContentRatingNewZealand)
        {
            $mediaContentRatingNewZealand = Get-M365DSCIntuneNestedObject -Properties $policy.AdditionalProperties.mediaContentRatingNewZealand
        }
        elseif ($null -ne $policy.AdditionalProperties.mediaContentRatingUnitedKingdom)
        {
            $mediaContentRatingUnitedKingdom = Get-M365DSCIntuneNestedObject -Properties $policy.AdditionalProperties.mediaContentRatingUnitedKingdom
        }
        elseif ($null -ne $policy.AdditionalProperties.mediaContentRatingUnitedStates)
        {
            $mediaContentRatingUnitedStates = Get-M365DSCIntuneNestedObject -Properties $policy.AdditionalProperties.mediaContentRatingUnitedStates
        }
        elseif ($null -ne $policy.AdditionalProperties.NetworkUsageRules)
        {
            $NetworkUsageRules = Get-M365DSCIntuneNestedObject -AdvancedSettings $policy.AdditionalProperties.NetworkUsageRules
        }
        elseif ($null -ne $policy.deviceManagementApplicabilityRuleOsEdition)
        {
            $deviceManagementApplicabilityRuleOsEdition = Convert-StringToAdvancedSettings -AdvancedSettings $policy.deviceManagementApplicabilityRuleOsEdition
        }
        elseif ($null -ne $policy.deviceManagementApplicabilityRuleOsVersion)
        {
            $deviceManagementApplicabilityRuleOsVersion = Convert-StringToAdvancedSettings -AdvancedSettings $policy.deviceManagementApplicabilityRuleOsVersion
        }
        elseif ($null -ne $policy.deviceManagementApplicabilityRuleDeviceMode)
        {
            $deviceManagementApplicabilityRuleDeviceMode = Convert-StringToAdvancedSettings -AdvancedSettings $policy.deviceManagementApplicabilityRuleDeviceMode
        }


        Write-Verbose -Message "Found Device Configuration Policy {$DisplayName}"
        return @{
            DisplayName                                    = $policy.DisplayName
            Description                                    = $policy.Description
            AccountBlockModification                       = $policy.AdditionalProperties.accountBlockModification
            ActivationLockAllowWhenSupervised              = $policy.AdditionalProperties.activationLockAllowWhenSupervised
            AirDropBlocked                                 = $policy.AdditionalProperties.airDropBlocked
            AirDropForceUnmanagedDropTarget                = $policy.AdditionalProperties.airDropForceUnmanagedDropTarget
            AirPlayForcePairingPasswordForOutgoingRequests = $policy.AdditionalProperties.airPlayForcePairingPasswordForOutgoingRequests
            AppleWatchBlockPairing                         = $policy.AdditionalProperties.appleWatchBlockPairing
            AppleWatchForceWristDetection                  = $policy.AdditionalProperties.appleWatchForceWristDetection
            AppleNewsBlocked                               = $policy.AdditionalProperties.appleNewsBlocked
            AppsSingleAppModeList                          = $AppsSingleAppModeList
            AppsVisibilityList                             = $AppsVisibilityList
            AppsVisibilityListType                         = $policy.AdditionalProperties.appsVisibilityListType
            AppStoreBlockAutomaticDownloads                = $policy.AdditionalProperties.appStoreBlockAutomaticDownloads
            AppStoreBlocked                                = $policy.AdditionalProperties.appStoreBlocked
            AppStoreBlockInAppPurchases                    = $policy.AdditionalProperties.appStoreBlockInAppPurchases
            AppStoreBlockUIAppInstallation                 = $policy.AdditionalProperties.appStoreBlockUIAppInstallation
            AppStoreRequirePassword                        = $policy.AdditionalProperties.appStoreRequirePassword
            AutoFillForceAuthentication                    = $policy.AdditionalProperties.autoFillForceAuthentication
            BluetoothBlockModification                     = $policy.AdditionalProperties.bluetoothBlockModification
            CameraBlocked                                  = $policy.AdditionalProperties.cameraBlocked
            CellularBlockDataRoaming                       = $policy.AdditionalProperties.cellularBlockDataRoaming
            CellularBlockGlobalBackgroundFetchWhileRoaming = $policy.AdditionalProperties.cellularBlockGlobalBackgroundFetchWhileRoaming
            CellularBlockPerAppDataModification            = $policy.AdditionalProperties.cellularBlockPerAppDataModification
            CellularBlockPersonalHotspot                   = $policy.AdditionalProperties.cellularBlockPersonalHotspot
            CellularBlockPlanModification                  = $policy.AdditionalProperties.cellularBlockPlanModification
            CellularBlockVoiceRoaming                      = $policy.AdditionalProperties.cellularBlockVoiceRoaming
            CertificatesBlockUntrustedTlsCertificates      = $policy.AdditionalProperties.certificatesBlockUntrustedTlsCertificates
            ClassroomAppBlockRemoteScreenObservation       = $policy.AdditionalProperties.classroomAppBlockRemoteScreenObservation
            ClassroomAppForceUnpromptedScreenObservation   = $policy.AdditionalProperties.classroomAppForceUnpromptedScreenObservation
            ClassroomForceAutomaticallyJoinClasses         = $policy.AdditionalProperties.classroomForceAutomaticallyJoinClasses
            ClassroomForceUnpromptedAppAndDeviceLock       = $policy.AdditionalProperties.classroomForceUnpromptedAppAndDeviceLock
            CompliantAppsList                              = $CompliantAppsList
            CompliantAppListType                           = $policy.AdditionalProperties.compliantAppListType
            ConfigurationProfileBlockChanges               = $policy.AdditionalProperties.configurationProfileBlockChanges
            DefinitionLookupBlocked                        = $policy.AdditionalProperties.definitionLookupBlocked
            DeviceBlockEnableRestrictions                  = $policy.AdditionalProperties.deviceBlockEnableRestrictions
            DeviceBlockEraseContentAndSettings             = $policy.AdditionalProperties.deviceBlockEraseContentAndSettings
            DeviceBlockNameModification                    = $policy.AdditionalProperties.deviceBlockNameModification
            DiagnosticDataBlockSubmission                  = $policy.AdditionalProperties.diagnosticDataBlockSubmission
            DiagnosticDataBlockSubmissionModification      = $policy.AdditionalProperties.diagnosticDataBlockSubmissionModification
            DocumentsBlockManagedDocumentsInUnmanagedApps  = $policy.AdditionalProperties.documentsBlockManagedDocumentsInUnmanagedApps
            DocumentsBlockUnmanagedDocumentsInManagedApps  = $policy.AdditionalProperties.documentsBlockUnmanagedDocumentsInManagedApps
            EmailInDomainSuffixes                          = $policy.AdditionalProperties.emailInDomainSuffixes
            EnterpriseAppBlockTrust                        = $policy.AdditionalProperties.enterpriseAppBlockTrust
            EnterpriseAppBlockTrustModification            = $policy.AdditionalProperties.enterpriseAppBlockTrustModification
            EsimBlockModification                          = $policy.AdditionalProperties.esimBlockModification
            FaceTimeBlocked                                = $policy.AdditionalProperties.faceTimeBlocked
            FindMyFriendsBlocked                           = $policy.AdditionalProperties.findMyFriendsBlocked
            GamingBlockGameCenterFriends                   = $policy.AdditionalProperties.gamingBlockGameCenterFriends
            GamingBlockMultiplayer                         = $policy.AdditionalProperties.gamingBlockMultiplayer
            GameCenterBlocked                              = $policy.AdditionalProperties.gameCenterBlocked
            HostPairingBlocked                             = $policy.AdditionalProperties.hostPairingBlocked
            iBooksStoreBlocked                             = $policy.AdditionalProperties.iBooksStoreBlocked
            iBooksStoreBlockErotica                        = $policy.AdditionalProperties.iBooksStoreBlockErotica
            iCloudBlockActivityContinuation                = $policy.AdditionalProperties.iCloudBlockActivityContinuation
            iCloudBlockBackup                              = $policy.AdditionalProperties.iCloudBlockBackup
            iCloudBlockDocumentSync                        = $policy.AdditionalProperties.iCloudBlockDocumentSync
            iCloudBlockManagedAppsSync                     = $policy.AdditionalProperties.iCloudBlockManagedAppsSync
            iCloudBlockPhotoLibrary                        = $policy.AdditionalProperties.iCloudBlockPhotoLibrary
            iCloudBlockPhotoStreamSync                     = $policy.AdditionalProperties.iCloudBlockPhotoStreamSync
            iCloudBlockSharedPhotoStream                   = $policy.AdditionalProperties.iCloudBlockSharedPhotoStream
            iCloudRequireEncryptedBackup                   = $policy.AdditionalProperties.iCloudRequireEncryptedBackup
            iTunesBlockExplicitContent                     = $policy.AdditionalProperties.iTunesBlockExplicitContent
            iTunesBlockMusicService                        = $policy.AdditionalProperties.iTunesBlockMusicService
            iTunesBlockRadio                               = $policy.AdditionalProperties.iTunesBlockRadio
            KeyboardBlockAutoCorrect                       = $policy.AdditionalProperties.keyboardBlockAutoCorrect
            KeyboardBlockDictation                         = $policy.AdditionalProperties.keyboardBlockDictation
            KeyboardBlockPredictive                        = $policy.AdditionalProperties.keyboardBlockPredictive
            KeyboardBlockShortcuts                         = $policy.AdditionalProperties.keyboardBlockShortcuts
            KeyboardBlockSpellCheck                        = $policy.AdditionalProperties.keyboardBlockSpellCheck
            KioskModeAllowAssistiveSpeak                   = $policy.AdditionalProperties.kioskModeAllowAssistiveSpeak
            KioskModeAllowAssistiveTouchSettings           = $policy.AdditionalProperties.kioskModeAllowAssistiveTouchSettings
            KioskModeAllowAutoLock                         = $policy.AdditionalProperties.kioskModeAllowAutoLock
            KioskModeBlockAutoLock                         = $policy.AdditionalProperties.kioskModeBlockAutoLock
            KioskModeAllowColorInversionSettings           = $policy.AdditionalProperties.kioskModeAllowColorInversionSettings
            KioskModeAllowRingerSwitch                     = $policy.AdditionalProperties.kioskModeAllowRingerSwitch
            KioskModeBlockRingerSwitch                     = $policy.AdditionalProperties.kioskModeBlockRingerSwitch
            KioskModeAllowScreenRotation                   = $policy.AdditionalProperties.kioskModeAllowScreenRotation
            KioskModeBlockScreenRotation                   = $policy.AdditionalProperties.kioskModeBlockScreenRotation
            KioskModeAllowSleepButton                      = $policy.AdditionalProperties.kioskModeAllowSleepButton
            KioskModeBlockSleepButton                      = $policy.AdditionalProperties.kioskModeBlockSleepButton
            KioskModeAllowTouchscreen                      = $policy.AdditionalProperties.kioskModeAllowTouchscreen
            KioskModeBlockTouchscreen                      = $policy.AdditionalProperties.kioskModeBlockTouchscreen
            KioskModeEnableVoiceControl                    = $policy.AdditionalProperties.kioskModeEnableVoiceControl
            KioskModeEnableVoiceControlModification        = $policy.AdditionalProperties.kioskModeEnableVoiceControlModification
            KioskModeAllowVoiceOverSettings                = $policy.AdditionalProperties.kioskModeAllowVoiceOverSettings
            KioskModeAllowVolumeButtons                    = $policy.AdditionalProperties.kioskModeAllowVolumeButtons
            KioskModeBlockVolumeButtons                    = $policy.AdditionalProperties.kioskModeBlockVolumeButtons
            KioskModeAllowZoomSettings                     = $policy.AdditionalProperties.kioskModeAllowZoomSettings
            KioskModeAppStoreUrl                           = $policy.AdditionalProperties.kioskModeAppStoreUrl
            KioskModeBuiltInAppId                          = $policy.AdditionalProperties.kioskModeBuiltInAppId
            KioskModeRequireAssistiveTouch                 = $policy.AdditionalProperties.kioskModeRequireAssistiveTouch
            KioskModeRequireColorInversion                 = $policy.AdditionalProperties.kioskModeRequireColorInversion
            KioskModeRequireMonoAudio                      = $policy.AdditionalProperties.kioskModeRequireMonoAudio
            KioskModeRequireVoiceOver                      = $policy.AdditionalProperties.kioskModeRequireVoiceOver
            KioskModeRequireZoom                           = $policy.AdditionalProperties.kioskModeRequireZoom
            KioskModeManagedAppId                          = $policy.AdditionalProperties.kioskModeManagedAppId
            LockScreenBlockControlCenter                   = $policy.AdditionalProperties.lockScreenBlockControlCenter
            LockScreenBlockNotificationView                = $policy.AdditionalProperties.lockScreenBlockNotificationView
            LockScreenBlockPassbook                        = $policy.AdditionalProperties.lockScreenBlockPassbook
            LockScreenBlockTodayView                       = $policy.AdditionalProperties.lockScreenBlockTodayView
            MediaContentRatingAustralia                    = $MediaContentRatingAustralia
            MediaContentRatingCanada                       = $MediaContentRatingCanada
            MediaContentRatingFrance                       = $MediaContentRatingFrance
            MediaContentRatingGermany                      = $MediaContentRatingGermany
            MediaContentRatingIreland                      = $MediaContentRatingIreland
            MediaContentRatingJapan                        = $MediaContentRatingJapan
            MediaContentRatingNewZealand                   = $MediaContentRatingNewZealand
            MediaContentRatingUnitedKingdom                = $MediaContentRatingUnitedKingdom
            MediaContentRatingUnitedStates                 = $MediaContentRatingUnitedStates
            NetworkUsageRules                              = $NetworkUsageRules
            MediaContentRatingApps                         = $policy.AdditionalProperties.mediaContentRatingApps
            MessagesBlocked                                = $policy.AdditionalProperties.messagesBlocked
            NotificationsBlockSettingsModification         = $policy.AdditionalProperties.notificationsBlockSettingsModification
            PasscodeBlockFingerprintUnlock                 = $policy.AdditionalProperties.passcodeBlockFingerprintUnlock
            PasscodeBlockModification                      = $policy.AdditionalProperties.passcodeBlockModification
            PasscodeBlockSimple                            = $policy.AdditionalProperties.passcodeBlockSimple
            PasscodeExpirationDays                         = $policy.AdditionalProperties.passcodeExpirationDays
            PasscodeMinimumLength                          = $policy.AdditionalProperties.passcodeMinimumLength
            PasscodeMinutesOfInactivityBeforeLock          = $policy.AdditionalProperties.passcodeMinutesOfInactivityBeforeLock
            PasscodeMinutesOfInactivityBeforeScreenTimeout = $policy.AdditionalProperties.passcodeMinutesOfInactivityBeforeScreenTimeout
            PasscodeMinimumCharacterSetCount               = $policy.AdditionalProperties.passcodeMinimumCharacterSetCount
            PasscodePreviousPasscodeBlockCount             = $policy.AdditionalProperties.passcodePreviousPasscodeBlockCount
            PasscodeSignInFailureCountBeforeWipe           = $policy.AdditionalProperties.passcodeSignInFailureCountBeforeWipe
            PasscodeRequiredType                           = $policy.AdditionalProperties.passcodeRequiredType
            PasscodeRequired                               = $policy.AdditionalProperties.passcodeRequired
            PodcastsBlocked                                = $policy.AdditionalProperties.podcastsBlocked
            ProximityBlockSetupToNewDevice                 = $policy.AdditionalProperties.proximityBlockSetupToNewDevice
            SafariBlockAutofill                            = $policy.AdditionalProperties.safariBlockAutofill
            SafariBlockJavaScript                          = $policy.AdditionalProperties.safariBlockJavaScript
            SafariBlockPopups                              = $policy.AdditionalProperties.safariBlockPopups
            SafariBlocked                                  = $policy.AdditionalProperties.safariBlocked
            SafariCookieSettings                           = $policy.AdditionalProperties.safariCookieSettings
            SafariManagedDomains                           = $policy.AdditionalProperties.safariManagedDomains
            SafariPasswordAutoFillDomains                  = $policy.AdditionalProperties.safariPasswordAutoFillDomains
            SafariRequireFraudWarning                      = $policy.AdditionalProperties.safariRequireFraudWarning
            ScreenCaptureBlocked                           = $policy.AdditionalProperties.screenCaptureBlocked
            SiriBlocked                                    = $policy.AdditionalProperties.siriBlocked
            SiriBlockedWhenLocked                          = $policy.AdditionalProperties.siriBlockedWhenLocked
            SiriBlockUserGeneratedContent                  = $policy.AdditionalProperties.siriBlockUserGeneratedContent
            SiriRequireProfanityFilter                     = $policy.AdditionalProperties.siriRequireProfanityFilter
            SoftwareUpdatesEnforcedDelayInDays             = $policy.AdditionalProperties.softwareUpdatesEnforcedDelayInDays
            SoftwareUpdatesForceDelayed                    = $policy.AdditionalProperties.softwareUpdatesForceDelayed
            SpotlightBlockInternetResults                  = $policy.AdditionalProperties.spotlightBlockInternetResults
            VoiceDialingBlocked                            = $policy.AdditionalProperties.voiceDialingBlocked
            WallpaperBlockModification                     = $policy.AdditionalProperties.wallpaperBlockModification
            WiFiConnectOnlyToConfiguredNetworks            = $policy.AdditionalProperties.WiFiConnectOnlyToConfiguredNetworks
            ClassroomForceRequestPermissionToLeaveClasses  = $policy.AdditionalProperties.ClassroomForceRequestPermissionToLeaveClasses
            KeychainBlockCloudSync                         = $policy.AdditionalProperties.KeychainBlockCloudSync
            PkiBlockOTAUpdates                             = $policy.AdditionalProperties.PkiBlockOTAUpdates
            PrivacyForceLimitAdTracking                    = $policy.AdditionalProperties.PrivacyForceLimitAdTracking
            EnterpriseBookBlockBackup                      = $policy.AdditionalProperties.EnterpriseBookBlockBackup
            EnterpriseBookBlockMetadataSync                = $policy.AdditionalProperties.EnterpriseBookBlockMetadataSync
            AirPrintBlocked                                = $policy.AdditionalProperties.AirPrintBlocked
            AirPrintBlockCredentialsStorage                = $policy.AdditionalProperties.AirPrintBlockCredentialsStorage
            AirPrintForceTrustedTLS                        = $policy.AdditionalProperties.AirPrintForceTrustedTLS
            AirPrintBlockiBeaconDiscovery                  = $policy.AdditionalProperties.AirPrintBlockiBeaconDiscovery
            FilesNetworkDriveAccessBlocked                 = $policy.AdditionalProperties.FilesNetworkDriveAccessBlocked
            FilesUsbDriveAccessBlocked                     = $policy.AdditionalProperties.FilesUsbDriveAccessBlocked
            WifiPowerOnForced                              = $policy.AdditionalProperties.WifiPowerOnForced
            BlockSystemAppRemoval                          = $policy.AdditionalProperties.BlockSystemAppRemoval
            VpnBlockCreation                               = $policy.AdditionalProperties.VpnBlockCreation
            AppRemovalBlocked                              = $policy.AdditionalProperties.AppRemovalBlocked
            UsbRestrictedModeBlocked                       = $policy.AdditionalProperties.UsbRestrictedModeBlocked
            PasswordBlockAutoFill                          = $policy.AdditionalProperties.PasswordBlockAutoFill
            PasswordBlockProximityRequests                 = $policy.AdditionalProperties.PasswordBlockProximityRequests
            PasswordBlockAirDropSharing                    = $policy.AdditionalProperties.PasswordBlockAirDropSharing
            DateAndTimeForceSetAutomatically               = $policy.AdditionalProperties.DateAndTimeForceSetAutomatically
            ContactsAllowManagedToUnmanagedWrite           = $policy.AdditionalProperties.ContactsAllowUnmanagedToManagedRead
            ContactsAllowUnmanagedToManagedRead            = $policy.AdditionalProperties.ContactsAllowUnmanagedToManagedRead
            CellularBlockPersonalHotspotModification       = $policy.AdditionalProperties.CellularBlockPersonalHotspotModification
            ContinuousPathKeyboardBlocked                  = $policy.AdditionalProperties.ContinuousPathKeyboardBlocked
            FindMyDeviceInFindMyAppBlocked                 = $policy.AdditionalProperties.FindMyDeviceInFindMyAppBlocked
            FindMyFriendsInFindMyAppBlocked                = $policy.AdditionalProperties.FindMyFriendsInFindMyAppBlocked
            ITunesBlocked                                  = $policy.AdditionalProperties.ITunesBlocked
            SharedDeviceBlockTemporarySessions             = $policy.AdditionalProperties.SharedDeviceBlockTemporarySessions
            AppClipsBlocked                                = $policy.AdditionalProperties.AppClipsBlocked
            ApplePersonalizedAdsBlocked                    = $policy.AdditionalProperties.ApplePersonalizedAdsBlocked
            NfcBlocked                                     = $policy.AdditionalProperties.NfcBlocked
            AutoUnlockBlocked                              = $policy.AdditionalProperties.AutoUnlockBlocked
            UnpairedExternalBootToRecoveryAllowed          = $policy.AdditionalProperties.UnpairedExternalBootToRecoveryAllowed
            OnDeviceOnlyDictationForced                    = $policy.AdditionalProperties.OnDeviceOnlyDictationForced
            WiFiConnectToAllowedNetworksOnlyForced         = $policy.AdditionalProperties.WiFiConnectToAllowedNetworksOnlyForced
            OnDeviceOnlyTranslationForced                  = $policy.AdditionalProperties.OnDeviceOnlyTranslationForced
            ManagedPasteboardRequired                      = $policy.AdditionalProperties.ManagedPasteboardRequired
            KioskModeAppType                               = $policy.AdditionalProperties.KioskModeAppType
            DeviceManagementApplicabilityRuleOsEdition     = $DeviceManagementApplicabilityRuleOsVersion
            DeviceManagementApplicabilityRuleOsVersion     = $DeviceManagementApplicabilityRuleOsVersion
            DeviceManagementApplicabilityRuleDeviceMode    = $DeviceManagementApplicabilityRuleDeviceMode
            Ensure                                         = "Present"
            GlobalAdminAccount                             = $GlobalAdminAccount
            ApplicationId                                  = $ApplicationId
            TenantId                                       = $TenantId
            ApplicationSecret                              = $ApplicationSecret
            CertificateThumbprint                          = $CertificateThumbprint
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
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $AccountBlockModification,

        [Parameter()]
        [System.Boolean]
        $ActivationLockAllowWhenSupervised,

        [Parameter()]
        [System.Boolean]
        $AirDropBlocked,

        [Parameter()]
        [System.Boolean]
        $AirDropForceUnmanagedDropTarget,

        [Parameter()]
        [System.Boolean]
        $AirPlayForcePairingPasswordForOutgoingRequests,

        [Parameter()]
        [System.Boolean]
        $AppleWatchBlockPairing,

        [Parameter()]
        [System.Boolean]
        $AppleWatchForceWristDetection,

        [Parameter()]
        [System.Boolean]
        $AppleNewsBlocked,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AppsSingleAppModeList,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AppsVisibilityList,

        [Parameter()]
        [System.String]
        [ValidateSet('None', 'AppsInListCompliant','AppsNotInListCompliant')]
        $AppsVisibilityListType,

        [Parameter()]
        [System.Boolean]
        $AppStoreBlockAutomaticDownloads,

        [Parameter()]
        [System.Boolean]
        $AppStoreBlocked,

        [Parameter()]
        [System.Boolean]
        $AppStoreBlockInAppPurchases,

        [Parameter()]
        [System.Boolean]
        $AppStoreBlockUIAppInstallation,

        [Parameter()]
        [System.Boolean]
        $AppStoreRequirePassword,

        [Parameter()]
        [System.Boolean]
        $AutoFillForceAuthentication,

        [Parameter()]
        [System.Boolean]
        $BluetoothBlockModification,

        [Parameter()]
        [System.Boolean]
        $CameraBlocked,

        [Parameter()]
        [System.Boolean]
        $CellularBlockDataRoaming,

        [Parameter()]
        [System.Boolean]
        $CellularBlockGlobalBackgroundFetchWhileRoaming,

        [Parameter()]
        [System.Boolean]
        $CellularBlockPerAppDataModification,

        [Parameter()]
        [System.Boolean]
        $CellularBlockPersonalHotspot,

        [Parameter()]
        [System.Boolean]
        $CellularBlockPlanModification,

        [Parameter()]
        [System.Boolean]
        $CellularBlockVoiceRoaming,

        [Parameter()]
        [System.Boolean]
        $CertificatesBlockUntrustedTlsCertificates,

        [Parameter()]
        [System.Boolean]
        $ClassroomAppBlockRemoteScreenObservation,

        [Parameter()]
        [System.Boolean]
        $ClassroomAppForceUnpromptedScreenObservation,

        [Parameter()]
        [System.Boolean]
        $ClassroomForceAutomaticallyJoinClasses,

        [Parameter()]
        [System.Boolean]
        $ClassroomForceUnpromptedAppAndDeviceLock,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CompliantAppsList,

        [Parameter()]
        [System.String]
        [ValidateSet('None', 'AppsInListCompliant','AppsNotInListCompliant')]
        $CompliantAppListType,

        [Parameter()]
        [System.Boolean]
        $ConfigurationProfileBlockChanges,

        [Parameter()]
        [System.Boolean]
        $DefinitionLookupBlocked,

        [Parameter()]
        [System.Boolean]
        $DeviceBlockEnableRestrictions,

        [Parameter()]
        [System.Boolean]
        $DeviceBlockEraseContentAndSettings,

        [Parameter()]
        [System.Boolean]
        $DeviceBlockNameModification,

        [Parameter()]
        [System.Boolean]
        $DiagnosticDataBlockSubmission,

        [Parameter()]
        [System.Boolean]
        $DiagnosticDataBlockSubmissionModification,

        [Parameter()]
        [System.Boolean]
        $DocumentsBlockManagedDocumentsInUnmanagedApps,

        [Parameter()]
        [System.Boolean]
        $DocumentsBlockUnmanagedDocumentsInManagedApps,

        [Parameter()]
        [System.String[]]
        $EmailInDomainSuffixes,

        [Parameter()]
        [System.Boolean]
        $EnterpriseAppBlockTrust,

        [Parameter()]
        [System.Boolean]
        $EnterpriseAppBlockTrustModification,

        [Parameter()]
        [System.Boolean]
        $FaceTimeBlocked,

        [Parameter()]
        [System.Boolean]
        $FindMyFriendsBlocked,

        [Parameter()]
        [System.Boolean]
        $GamingBlockGameCenterFriends,

        [Parameter()]
        [System.Boolean]
        $GamingBlockMultiplayer,

        [Parameter()]
        [System.Boolean]
        $GameCenterBlocked,

        [Parameter()]
        [System.Boolean]
        $HostPairingBlocked,

        [Parameter()]
        [System.Boolean]
        $iBooksStoreBlocked,

        [Parameter()]
        [System.Boolean]
        $iBooksStoreBlockErotica,

        [Parameter()]
        [System.Boolean]
        $iCloudBlockActivityContinuation,

        [Parameter()]
        [System.Boolean]
        $iCloudBlockBackup,

        [Parameter()]
        [System.Boolean]
        $iCloudBlockDocumentSync,

        [Parameter()]
        [System.Boolean]
        $iCloudBlockManagedAppsSync,

        [Parameter()]
        [System.Boolean]
        $iCloudBlockPhotoLibrary,

        [Parameter()]
        [System.Boolean]
        $iCloudBlockPhotoStreamSync,

        [Parameter()]
        [System.Boolean]
        $iCloudBlockSharedPhotoStream,

        [Parameter()]
        [System.Boolean]
        $iCloudRequireEncryptedBackup,

        [Parameter()]
        [System.Boolean]
        $iTunesBlockExplicitContent,

        [Parameter()]
        [System.Boolean]
        $iTunesBlockMusicService,

        [Parameter()]
        [System.Boolean]
        $iTunesBlockRadio,

        [Parameter()]
        [System.Boolean]
        $KeyboardBlockAutoCorrect,

        [Parameter()]
        [System.Boolean]
        $KeyboardBlockDictation,

        [Parameter()]
        [System.Boolean]
        $KeyboardBlockPredictive,

        [Parameter()]
        [System.Boolean]
        $KeyboardBlockShortcuts,

        [Parameter()]
        [System.Boolean]
        $KeyboardBlockSpellCheck,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowAssistiveSpeak,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowAssistiveTouchSettings,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowAutoLock,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockAutoLock,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowColorInversionSettings,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowRingerSwitch,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockRingerSwitch,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowScreenRotation,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockScreenRotation,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowSleepButton,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockSleepButton,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowTouchscreen,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockTouchscreen,

        [Parameter()]
        [System.Boolean]
        $KioskModeEnableVoiceControl,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowVoiceControlModification,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowVoiceOverSettings,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowVolumeButtons,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockVolumeButtons,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowZoomSettings,

        [Parameter()]
        [System.String]
        $KioskModeAppStoreUrl,

        [Parameter()]
        [System.String]
        $KioskModeBuiltInAppId,

        [Parameter()]
        [System.Boolean]
        $KioskModeRequireAssistiveTouch,

        [Parameter()]
        [System.Boolean]
        $KioskModeRequireColorInversion,

        [Parameter()]
        [System.Boolean]
        $KioskModeRequireMonoAudio,

        [Parameter()]
        [System.Boolean]
        $KioskModeRequireVoiceOver,

        [Parameter()]
        [System.Boolean]
        $KioskModeRequireZoom,

        [Parameter()]
        [System.String]
        $KioskModeManagedAppId,

        [Parameter()]
        [System.Boolean]
        $LockScreenBlockControlCenter,

        [Parameter()]
        [System.Boolean]
        $LockScreenBlockNotificationView,

        [Parameter()]
        [System.Boolean]
        $LockScreenBlockPassbook,

        [Parameter()]
        [System.Boolean]
        $LockScreenBlockTodayView,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $MediaContentRatingAustralia,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $MediaContentRatingCanada,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $MediaContentRatingFrance,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $MediaContentRatingGermany,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $MediaContentRatingIreland,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $MediaContentRatingJapan,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $MediaContentRatingNewZealand,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $MediaContentRatingUnitedKingdom,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $MediaContentRatingUnitedStates,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $NetworkUsageRules,

        [Parameter()]
        [System.String]
        [ValidateSet('AllAllowed', 'AllBlocked','AgesAbove4','AgesAbove9','AgesAbove12','AgesAbove17')]
        $MediaContentRatingApps,

        [Parameter()]
        [System.Boolean]
        $MessagesBlocked,

        [Parameter()]
        [System.Boolean]
        $NotificationsBlockSettingsModification,

        [Parameter()]
        [System.Boolean]
        $PasscodeBlockFingerprintUnlock,

        [Parameter()]
        [System.Boolean]
        $PasscodeBlockModification,

        [Parameter()]
        [System.Boolean]
        $PasscodeBlockSimple,

        [Parameter()]
        [System.String]
        $PasscodeExpirationDays,

        [Parameter()]
        [System.Uint32]
        $PasscodeMinimumLength,

        [Parameter()]
        [System.String]
        $PasscodeMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.String]
        $PasscodeMinutesOfInactivityBeforeScreenTimeout,

        [Parameter()]
        [System.String]
        $PasscodeMinimumCharacterSetCount,

        [Parameter()]
        [System.String]
        $PasscodePreviousPasscodeBlockCount,

        [Parameter()]
        [System.String]
        $PasscodeSignInFailureCountBeforeWipe,

        [Parameter()]
        [System.String]
        [ValidateSet('DeviceDefault', 'Alphanumeric','Numeric')]
        $PasscodeRequiredType = "deviceDefault",

        [Parameter()]
        [System.Boolean]
        $PasscodeRequired,

        [Parameter()]
        [System.Boolean]
        $PodcastsBlocked,

        [Parameter()]
        [System.Boolean]
        $ProximityBlockSetupToNewDevice,

        [Parameter()]
        [System.Boolean]
        $SafariBlockAutofill,

        [Parameter()]
        [System.Boolean]
        $SafariBlockJavaScript,

        [Parameter()]
        [System.Boolean]
        $SafariBlockPopups,

        [Parameter()]
        [System.Boolean]
        $SafariBlocked,

        [Parameter()]
        [System.String]
        [ValidateSet('BrowserDefault', 'BlockAlways','AllowCurrentWebSite','AllowFromWebsitesVisited','AllowAlways')]
        $SafariCookieSettings,

        [Parameter()]
        [System.String[]]
        $SafariManagedDomains,

        [Parameter()]
        [System.String[]]
        $SafariPasswordAutoFillDomains,

        [Parameter()]
        [System.Boolean]
        $SafariRequireFraudWarning,

        [Parameter()]
        [System.Boolean]
        $ScreenCaptureBlocked,

        [Parameter()]
        [System.Boolean]
        $SiriBlocked,

        [Parameter()]
        [System.Boolean]
        $SiriBlockedWhenLocked,

        [Parameter()]
        [System.Boolean]
        $SiriBlockUserGeneratedContent,

        [Parameter()]
        [System.Boolean]
        $SiriRequireProfanityFilter,

        [Parameter()]
        [System.Uint32]
        $SoftwareUpdatesEnforcedDelayInDays,

        [Parameter()]
        [System.Boolean]
        $SoftwareUpdatesForceDelayed,

        [Parameter()]
        [System.Boolean]
        $SpotlightBlockInternetResults,

        [Parameter()]
        [System.Boolean]
        $VoiceDialingBlocked,

        [Parameter()]
        [System.Boolean]
        $WallpaperBlockModification,

        [Parameter()]
        [System.Boolean]
	    $WiFiConnectOnlyToConfiguredNetworks,

	    [Parameter()]
        [System.Boolean]
	    $ClassroomForceRequestPermissionToLeaveClasses,

        [Parameter()]
        [System.Boolean]
	    $KeychainBlockCloudSync,

	    [Parameter()]
        [System.Boolean]
	    $PkiBlockOTAUpdates,

        [Parameter()]
        [System.Boolean]
	    $PrivacyForceLimitAdTracking,

        [Parameter()]
        [System.Boolean]
	    $EnterpriseBookBlockBackup,

        [Parameter()]
        [System.Boolean]
	    $EnterpriseBookBlockMetadataSync,

	    [Parameter()]
        [System.Boolean]
	    $AirPrintBlocked,

        [Parameter()]
        [System.Boolean]
	    $AirPrintBlockCredentialsStorage,

        [Parameter()]
        [System.Boolean]
	    $AirPrintForceTrustedTLS,

        [Parameter()]
        [System.Boolean]
	    $AirPrintBlockiBeaconDiscovery,

        [Parameter()]
        [System.Boolean]
	    $FilesNetworkDriveAccessBlocked,

        [Parameter()]
        [System.Boolean]
	    $FilesUsbDriveAccessBlocked,

        [Parameter()]
        [System.Boolean]
	    $WifiPowerOnForced,

        [Parameter()]
        [System.Boolean]
	    $BlockSystemAppRemoval,

        [Parameter()]
        [System.Boolean]
	    $VpnBlockCreation,

        [Parameter()]
        [System.Boolean]
	    $AppRemovalBlocked,

        [Parameter()]
        [System.Boolean]
	    $UsbRestrictedModeBlocked,

        [Parameter()]
        [System.Boolean]
	    $PasswordBlockAutoFill,

        [Parameter()]
        [System.Boolean]
	    $PasswordBlockProximityRequests,

        [Parameter()]
        [System.Boolean]
	    $PasswordBlockAirDropSharing,

        [Parameter()]
        [System.Boolean]
	    $DateAndTimeForceSetAutomatically,

        [Parameter()]
        [System.Boolean]
	    $ContactsAllowManagedToUnmanagedWrite,

        [Parameter()]
        [System.Boolean]
	    $ContactsAllowUnmanagedToManagedRead,

        [Parameter()]
        [System.Boolean]
	    $CellularBlockPersonalHotspotModification,

        [Parameter()]
        [System.Boolean]
	    $ContinuousPathKeyboardBlocked,

        [Parameter()]
        [System.Boolean]
	    $FindMyDeviceInFindMyAppBlocked,

        [Parameter()]
        [System.Boolean]
	    $FindMyFriendsInFindMyAppBlocked,

        [Parameter()]
        [System.Boolean]
	    $ITunesBlocked,

        [Parameter()]
        [System.Boolean]
	    $SharedDeviceBlockTemporarySessions,

        [Parameter()]
        [System.Boolean]
	    $AppClipsBlocked,

        [Parameter()]
        [System.Boolean]
	    $ApplePersonalizedAdsBlocked,

        [Parameter()]
        [System.Boolean]
	    $NfcBlocked,

        [Parameter()]
        [System.Boolean]
	    $AutoUnlockBlocked,

        [Parameter()]
        [System.Boolean]
	    $UnpairedExternalBootToRecoveryAllowed,

        [Parameter()]
        [System.Boolean]
	    $OnDeviceOnlyDictationForced,

        [Parameter()]
        [System.Boolean]
	    $WiFiConnectToAllowedNetworksOnlyForced,

        [Parameter()]
        [System.Boolean]
	    $OnDeviceOnlyTranslationForced,

        [Parameter()]
        [System.Boolean]
	    $ManagedPasteboardRequired,

        [Parameter()]
        [System.String]
	    [ValidateSet('NotConfigured', 'AppStoreApp','ManagedApp','BuiltInApp')]
        $KioskModeAppType,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $deviceManagementApplicabilityRuleOsVersion,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $deviceManagementApplicabilityRuleOsEdition,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $deviceManagementApplicabilityRuleDeviceMode,

        [Parameter(Mandatory = $true)]
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
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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

    $PSBoundParameters.Remove("Ensure") | Out-Null
    $PSBoundParameters.Remove("GlobalAdminAccount") | Out-Null
    $PSBoundParameters.Remove("ApplicationId") | Out-Null
    $PSBoundParameters.Remove("TenantId") | Out-Null
    $PSBoundParameters.Remove("ApplicationSecret") | Out-Null
    if ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Absent')
    {
        $CreationParams = $PSBoundParameters
        Write-Verbose -Message "Creating new Device Configuration Policy {$DisplayName}"
        $PSBoundParameters.Remove('DisplayName') | Out-Null
        $PSBoundParameters.Remove('Description') | Out-Null
        if ($PSBoundParameters.ContainsKey("appsVisibilityList"))
        {
            $appsVisibilityList = Convert-CIMToAdvancedSettings $appsVisibilityList
            $CreationParams["appsVisibilityList"] = $appsVisibilityList
        }
        elseif($PSBoundParameters.ContainsKey("appsSingleAppModeList"))
        {
            $appsSingleAppModeList = Convert-CIMToAdvancedSettings $appsVisibilityList
            $CreationParams["appsSingleAppModeList"] = $appsSingleAppModeList
        }
        elseif($PSBoundParameters.ContainsKey("compliantAppsList"))
        {
            $compliantAppsList = Convert-CIMToAdvancedSettings $compliantAppsList
            $CreationParams["compliantAppsList"] = $compliantAppsList
        }
        elseif($PSBoundParameters.ContainsKey("mediaContentRatingAustralia"))
        {
            $mediaContentRatingAustralia = Convert-CIMToAdvancedSettings $mediaContentRatingAustralia
            $CreationParams["mediaContentRatingAustralia"] = $mediaContentRatingAustralia
        }
        elseif($PSBoundParameters.ContainsKey("mediaContentRatingCanada"))
        {
            $mediaContentRatingCanada = Convert-CIMToAdvancedSettings $mediaContentRatingCanada
            $CreationParams["mediaContentRatingCanada"] = $mediaContentRatingCanada
        }
        elseif($PSBoundParameters.ContainsKey("mediaContentRatingFrance"))
        {
            $mediaContentRatingFrance = Convert-CIMToAdvancedSettings $mediaContentRatingFrance
            $CreationParams["mediaContentRatingFrance"] = $mediaContentRatingFrance
        }
        elseif($PSBoundParameters.ContainsKey("mediaContentRatingGermany"))
        {
            $mediaContentRatingGermany = Convert-CIMToAdvancedSettings $mediaContentRatingGermany
            $CreationParams["mediaContentRatingGermany"] = $mediaContentRatingGermany
        }
        elseif($PSBoundParameters.ContainsKey("mediaContentRatingIreland"))
        {
            $appsVisibilityList = Convert-CIMToAdvancedSettings $mediaContentRatingIreland
            $CreationParams["mediaContentRatingIreland"] = $mediaContentRatingIreland
        }
        elseif($PSBoundParameters.ContainsKey("mediaContentRatingJapan"))
        {
            $mediaContentRatingJapan = Convert-CIMToAdvancedSettings $mediaContentRatingJapan
            $CreationParams["mediaContentRatingJapan"] = $mediaContentRatingJapan
        }
        elseif($PSBoundParameters.ContainsKey("mediaContentRatingNewZealand"))
        {
            $appsVisibilityList = Convert-CIMToAdvancedSettings $mediaContentRatingNewZealand
            $CreationParams["mediaContentRatingNewZealand"] = $mediaContentRatingNewZealand
        }
        elseif($PSBoundParameters.ContainsKey("mediaContentRatingUnitedKingdom"))
        {
            $mediaContentRatingUnitedKingdom = Convert-CIMToAdvancedSettings $mediaContentRatingUnitedKingdom
            $CreationParams["mediaContentRatingUnitedKingdom"] = $mediaContentRatingUnitedKingdom
        }
        elseif($PSBoundParameters.ContainsKey("mediaContentRatingUnitedKingdom"))
        {
            $mediaContentRatingUnitedStates = Convert-CIMToAdvancedSettings $mediaContentRatingUnitedStates
            $CreationParams["mediaContentRatingUnitedStates"] = $mediaContentRatingUnitedStates
        }
        elseif($PSBoundParameters.ContainsKey("iOSNetworkUsageRules"))
        {
            $iOSNetworkUsageRules = Convert-CIMToAdvancedSettings $iOSNetworkUsageRules
            $CreationParams["iOSNetworkUsageRules"] = $iOSNetworkUsageRules
        }
        elseif($PSBoundParameters.ContainsKey("DeviceManagementApplicabilityRuleOsEdition"))
        {
            $DeviceManagementApplicabilityRuleOsEdition = Convert-CIMToAdvancedSettings $DeviceManagementApplicabilityRuleOsEdition
            $CreationParams["DeviceManagementApplicabilityRuleOsEdition"] = $DeviceManagementApplicabilityRuleOsEdition
        }
        elseif($PSBoundParameters.ContainsKey("DeviceManagementApplicabilityRuleOsVersion"))
        {
            $DeviceManagementApplicabilityRuleOsVersion = Convert-CIMToAdvancedSettings $DeviceManagementApplicabilityRuleOsVersion
            $CreationParams["DeviceManagementApplicabilityRuleOsVersion"] = $DeviceManagementApplicabilityRuleOsVersion
        }
        elseif($PSBoundParameters.ContainsKey("DeviceManagementApplicabilityRuleDeviceMode"))
        {
            $DeviceManagementApplicabilityRuleDeviceMode = Convert-CIMToAdvancedSettings $DeviceManagementApplicabilityRuleDeviceMode
            $CreationParams["DeviceManagementApplicabilityRuleDeviceMode"] = $DeviceManagementApplicabilityRuleDeviceMode
        }
        $AdditionalProperties = $appsVisibilityList + $appsSingleAppModeList + $compliantAppsList + $mediaContentRatingAustralia + $MediaContentRatingFrance `
                    + $mediaContentRatingGermany + $mediaContentRatingIreland + $mediaContentRatingIreland + $mediaContentRatingJapan + $mediaContentRatingNewZealand `
                     + $mediaContentRatingUnitedKingdom + $mediaContentRatingUnitedStates + $iOSNetworkUsageRules + $DeviceManagementApplicabilityRuleOsVersion `
                     + $DeviceManagementApplicabilityRuleOsVersion + $DeviceManagementApplicabilityRuleDeviceMode

        New-MGDeviceManagementDeviceConfiguration -DisplayName $DisplayName `
            -Description $Description `
            -AdditionalProperties $AdditionalProperties
    }
    elseif ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating existing Device Configuration Policy {$DisplayName}"
        $configDevicePolicy = Get-MGDeviceManagementDeviceConfiguration `
            -ErrorAction Stop | Where-Object `
            -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.iosGeneralDeviceConfiguration' -and `
                $_.displayName -eq $($DisplayName) }

        $PSBoundParameters.Remove('DisplayName') | Out-Null
        $PSBoundParameters.Remove('Description') | Out-Null
        if ($PSBoundParameters.ContainsKey("appsVisibilityList"))
        {
            $appsVisibilityList = Convert-CIMToAdvancedSettings $appsVisibilityList
            $CreationParams["appsVisibilityList"] = $appsVisibilityList
        }
        elseif($PSBoundParameters.ContainsKey("appsSingleAppModeList"))
        {
            $appsSingleAppModeList = Convert-CIMToAdvancedSettings $appsVisibilityList
            $CreationParams["appsSingleAppModeList"] = $appsSingleAppModeList
        }
        elseif($PSBoundParameters.ContainsKey("compliantAppsList"))
        {
            $compliantAppsList = Convert-CIMToAdvancedSettings $compliantAppsList
            $CreationParams["compliantAppsList"] = $compliantAppsList
        }
        elseif($PSBoundParameters.ContainsKey("mediaContentRatingAustralia"))
        {
            $mediaContentRatingAustralia = Convert-CIMToAdvancedSettings $mediaContentRatingAustralia
            $CreationParams["mediaContentRatingAustralia"] = $mediaContentRatingAustralia
        }
        elseif($PSBoundParameters.ContainsKey("mediaContentRatingCanada"))
        {
            $mediaContentRatingCanada = Convert-CIMToAdvancedSettings $mediaContentRatingCanada
            $CreationParams["mediaContentRatingCanada"] = $mediaContentRatingCanada
        }
        elseif($PSBoundParameters.ContainsKey("mediaContentRatingFrance"))
        {
            $mediaContentRatingFrance = Convert-CIMToAdvancedSettings $mediaContentRatingFrance
            $CreationParams["mediaContentRatingFrance"] = $mediaContentRatingFrance
        }
        elseif($PSBoundParameters.ContainsKey("mediaContentRatingGermany"))
        {
            $mediaContentRatingGermany = Convert-CIMToAdvancedSettings $mediaContentRatingGermany
            $CreationParams["mediaContentRatingGermany"] = $mediaContentRatingGermany
        }
        elseif($PSBoundParameters.ContainsKey("mediaContentRatingIreland"))
        {
            $appsVisibilityList = Convert-CIMToAdvancedSettings $mediaContentRatingIreland
            $CreationParams["mediaContentRatingIreland"] = $mediaContentRatingIreland
        }
        elseif($PSBoundParameters.ContainsKey("mediaContentRatingJapan"))
        {
            $mediaContentRatingJapan = Convert-CIMToAdvancedSettings $mediaContentRatingJapan
            $CreationParams["mediaContentRatingJapan"] = $mediaContentRatingJapan
        }
        elseif($PSBoundParameters.ContainsKey("mediaContentRatingNewZealand"))
        {
            $appsVisibilityList = Convert-CIMToAdvancedSettings $mediaContentRatingNewZealand
            $CreationParams["mediaContentRatingNewZealand"] = $mediaContentRatingNewZealand
        }
        elseif($PSBoundParameters.ContainsKey("mediaContentRatingUnitedKingdom"))
        {
            $mediaContentRatingUnitedKingdom = Convert-CIMToAdvancedSettings $mediaContentRatingUnitedKingdom
            $CreationParams["mediaContentRatingUnitedKingdom"] = $mediaContentRatingUnitedKingdom
        }
        elseif($PSBoundParameters.ContainsKey("mediaContentRatingUnitedKingdom"))
        {
            $mediaContentRatingUnitedStates = Convert-CIMToAdvancedSettings $mediaContentRatingUnitedStates
            $CreationParams["mediaContentRatingUnitedStates"] = $mediaContentRatingUnitedStates
        }
        elseif($PSBoundParameters.ContainsKey("iOSNetworkUsageRules"))
        {
            $iOSNetworkUsageRules = Convert-CIMToAdvancedSettings $iOSNetworkUsageRules
            $CreationParams["iOSNetworkUsageRules"] = $iOSNetworkUsageRules
        }
        elseif($PSBoundParameters.ContainsKey("DeviceManagementApplicabilityRuleOsEdition"))
        {
            $DeviceManagementApplicabilityRuleOsEdition = Convert-CIMToAdvancedSettings $DeviceManagementApplicabilityRuleOsEdition
            $CreationParams["DeviceManagementApplicabilityRuleOsEdition"] = $DeviceManagementApplicabilityRuleOsEdition
        }
        elseif($PSBoundParameters.ContainsKey("DeviceManagementApplicabilityRuleOsVersion"))
        {
            $DeviceManagementApplicabilityRuleOsVersion = Convert-CIMToAdvancedSettings $DeviceManagementApplicabilityRuleOsVersion
            $CreationParams["DeviceManagementApplicabilityRuleOsVersion"] = $DeviceManagementApplicabilityRuleOsVersion
        }
        elseif($PSBoundParameters.ContainsKey("DeviceManagementApplicabilityRuleDeviceMode"))
        {
            $DeviceManagementApplicabilityRuleDeviceMode = Convert-CIMToAdvancedSettings $DeviceManagementApplicabilityRuleDeviceMode
            $CreationParams["DeviceManagementApplicabilityRuleDeviceMode"] = $DeviceManagementApplicabilityRuleDeviceMode
        }
        $AdditionalProperties = $appsVisibilityList + $appsSingleAppModeList + $compliantAppsList + $mediaContentRatingAustralia + $MediaContentRatingFrance `
                    + $mediaContentRatingGermany + $mediaContentRatingIreland + $mediaContentRatingIreland + $mediaContentRatingJapan + $mediaContentRatingNewZealand `
                     + $mediaContentRatingUnitedKingdom + $mediaContentRatingUnitedStates + $iOSNetworkUsageRules + $DeviceManagementApplicabilityRuleOsVersion `
                     + $DeviceManagementApplicabilityRuleOsVersion + $DeviceManagementApplicabilityRuleDeviceMode

        Update-MGDeviceManagementDeviceConfiguration -AdditionalProperties $AdditionalProperties `
            -Description $Description `
            -DeviceConfigurationId $configDevicePolicy.Id
    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Device Configuration Policy {$DisplayName}"
        $configDevicePolicy = Get-MGDeviceManagementDeviceConfiguration `
        -ErrorAction Stop | Where-Object `
        -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.iosGeneralDeviceConfiguration' -and `
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
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $AccountBlockModification,

        [Parameter()]
        [System.Boolean]
        $ActivationLockAllowWhenSupervised,

        [Parameter()]
        [System.Boolean]
        $AirDropBlocked,

        [Parameter()]
        [System.Boolean]
        $AirDropForceUnmanagedDropTarget,

        [Parameter()]
        [System.Boolean]
        $AirPlayForcePairingPasswordForOutgoingRequests,

        [Parameter()]
        [System.Boolean]
        $AppleWatchBlockPairing,

        [Parameter()]
        [System.Boolean]
        $AppleWatchForceWristDetection,

        [Parameter()]
        [System.Boolean]
        $AppleNewsBlocked,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AppsSingleAppModeList,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AppsVisibilityList,

        [Parameter()]
        [System.String]
        [ValidateSet('None', 'AppsInListCompliant','AppsNotInListCompliant')]
        $AppsVisibilityListType,

        [Parameter()]
        [System.Boolean]
        $AppStoreBlockAutomaticDownloads,

        [Parameter()]
        [System.Boolean]
        $AppStoreBlocked,

        [Parameter()]
        [System.Boolean]
        $AppStoreBlockInAppPurchases,

        [Parameter()]
        [System.Boolean]
        $AppStoreBlockUIAppInstallation,

        [Parameter()]
        [System.Boolean]
        $AppStoreRequirePassword,

        [Parameter()]
        [System.Boolean]
        $AutoFillForceAuthentication,

        [Parameter()]
        [System.Boolean]
        $BluetoothBlockModification,

        [Parameter()]
        [System.Boolean]
        $CameraBlocked,

        [Parameter()]
        [System.Boolean]
        $CellularBlockDataRoaming,

        [Parameter()]
        [System.Boolean]
        $CellularBlockGlobalBackgroundFetchWhileRoaming,

        [Parameter()]
        [System.Boolean]
        $CellularBlockPerAppDataModification,

        [Parameter()]
        [System.Boolean]
        $CellularBlockPersonalHotspot,

        [Parameter()]
        [System.Boolean]
        $CellularBlockPlanModification,

        [Parameter()]
        [System.Boolean]
        $CellularBlockVoiceRoaming,

        [Parameter()]
        [System.Boolean]
        $CertificatesBlockUntrustedTlsCertificates,

        [Parameter()]
        [System.Boolean]
        $ClassroomAppBlockRemoteScreenObservation,

        [Parameter()]
        [System.Boolean]
        $ClassroomAppForceUnpromptedScreenObservation,

        [Parameter()]
        [System.Boolean]
        $ClassroomForceAutomaticallyJoinClasses,

        [Parameter()]
        [System.Boolean]
        $ClassroomForceUnpromptedAppAndDeviceLock,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CompliantAppsList,

        [Parameter()]
        [System.String]
        [ValidateSet('None', 'AppsInListCompliant','AppsNotInListCompliant')]
        $CompliantAppListType,

        [Parameter()]
        [System.Boolean]
        $ConfigurationProfileBlockChanges,

        [Parameter()]
        [System.Boolean]
        $DefinitionLookupBlocked,

        [Parameter()]
        [System.Boolean]
        $DeviceBlockEnableRestrictions,

        [Parameter()]
        [System.Boolean]
        $DeviceBlockEraseContentAndSettings,

        [Parameter()]
        [System.Boolean]
        $DeviceBlockNameModification,

        [Parameter()]
        [System.Boolean]
        $DiagnosticDataBlockSubmission,

        [Parameter()]
        [System.Boolean]
        $DiagnosticDataBlockSubmissionModification,

        [Parameter()]
        [System.Boolean]
        $DocumentsBlockManagedDocumentsInUnmanagedApps,

        [Parameter()]
        [System.Boolean]
        $DocumentsBlockUnmanagedDocumentsInManagedApps,

        [Parameter()]
        [System.String[]]
        $EmailInDomainSuffixes,

        [Parameter()]
        [System.Boolean]
        $EnterpriseAppBlockTrust,

        [Parameter()]
        [System.Boolean]
        $EnterpriseAppBlockTrustModification,

        [Parameter()]
        [System.Boolean]
        $FaceTimeBlocked,

        [Parameter()]
        [System.Boolean]
        $FindMyFriendsBlocked,

        [Parameter()]
        [System.Boolean]
        $GamingBlockGameCenterFriends,

        [Parameter()]
        [System.Boolean]
        $GamingBlockMultiplayer,

        [Parameter()]
        [System.Boolean]
        $GameCenterBlocked,

        [Parameter()]
        [System.Boolean]
        $HostPairingBlocked,

        [Parameter()]
        [System.Boolean]
        $iBooksStoreBlocked,

        [Parameter()]
        [System.Boolean]
        $iBooksStoreBlockErotica,

        [Parameter()]
        [System.Boolean]
        $iCloudBlockActivityContinuation,

        [Parameter()]
        [System.Boolean]
        $iCloudBlockBackup,

        [Parameter()]
        [System.Boolean]
        $iCloudBlockDocumentSync,

        [Parameter()]
        [System.Boolean]
        $iCloudBlockManagedAppsSync,

        [Parameter()]
        [System.Boolean]
        $iCloudBlockPhotoLibrary,

        [Parameter()]
        [System.Boolean]
        $iCloudBlockPhotoStreamSync,

        [Parameter()]
        [System.Boolean]
        $iCloudBlockSharedPhotoStream,

        [Parameter()]
        [System.Boolean]
        $iCloudRequireEncryptedBackup,

        [Parameter()]
        [System.Boolean]
        $iTunesBlockExplicitContent,

        [Parameter()]
        [System.Boolean]
        $iTunesBlockMusicService,

        [Parameter()]
        [System.Boolean]
        $iTunesBlockRadio,

        [Parameter()]
        [System.Boolean]
        $KeyboardBlockAutoCorrect,

        [Parameter()]
        [System.Boolean]
        $KeyboardBlockDictation,

        [Parameter()]
        [System.Boolean]
        $KeyboardBlockPredictive,

        [Parameter()]
        [System.Boolean]
        $KeyboardBlockShortcuts,

        [Parameter()]
        [System.Boolean]
        $KeyboardBlockSpellCheck,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowAssistiveSpeak,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowAssistiveTouchSettings,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowAutoLock,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockAutoLock,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowColorInversionSettings,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowRingerSwitch,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockRingerSwitch,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowScreenRotation,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockScreenRotation,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowSleepButton,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockSleepButton,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowTouchscreen,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockTouchscreen,

        [Parameter()]
        [System.Boolean]
        $KioskModeEnableVoiceControl,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowVoiceControlModification,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowVoiceOverSettings,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowVolumeButtons,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockVolumeButtons,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowZoomSettings,

        [Parameter()]
        [System.String]
        $KioskModeAppStoreUrl,

        [Parameter()]
        [System.String]
        $KioskModeBuiltInAppId,

        [Parameter()]
        [System.Boolean]
        $KioskModeRequireAssistiveTouch,

        [Parameter()]
        [System.Boolean]
        $KioskModeRequireColorInversion,

        [Parameter()]
        [System.Boolean]
        $KioskModeRequireMonoAudio,

        [Parameter()]
        [System.Boolean]
        $KioskModeRequireVoiceOver,

        [Parameter()]
        [System.Boolean]
        $KioskModeRequireZoom,

        [Parameter()]
        [System.String]
        $KioskModeManagedAppId,

        [Parameter()]
        [System.Boolean]
        $LockScreenBlockControlCenter,

        [Parameter()]
        [System.Boolean]
        $LockScreenBlockNotificationView,

        [Parameter()]
        [System.Boolean]
        $LockScreenBlockPassbook,

        [Parameter()]
        [System.Boolean]
        $LockScreenBlockTodayView,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $MediaContentRatingAustralia,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $MediaContentRatingCanada,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $MediaContentRatingFrance,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $MediaContentRatingGermany,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $MediaContentRatingIreland,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $MediaContentRatingJapan,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $MediaContentRatingNewZealand,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $MediaContentRatingUnitedKingdom,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $MediaContentRatingUnitedStates,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $NetworkUsageRules,

        [Parameter()]
        [System.String]
        [ValidateSet('AllAllowed', 'AllBlocked','AgesAbove4','AgesAbove9','AgesAbove12','AgesAbove17')]
        $MediaContentRatingApps,

        [Parameter()]
        [System.Boolean]
        $MessagesBlocked,

        [Parameter()]
        [System.Boolean]
        $NotificationsBlockSettingsModification,

        [Parameter()]
        [System.Boolean]
        $PasscodeBlockFingerprintUnlock,

        [Parameter()]
        [System.Boolean]
        $PasscodeBlockModification,

        [Parameter()]
        [System.Boolean]
        $PasscodeBlockSimple,

        [Parameter()]
        [System.String]
        $PasscodeExpirationDays,

        [Parameter()]
        [System.Uint32]
        $PasscodeMinimumLength,

        [Parameter()]
        [System.String]
        $PasscodeMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.String]
        $PasscodeMinutesOfInactivityBeforeScreenTimeout,

        [Parameter()]
        [System.String]
        $PasscodeMinimumCharacterSetCount,

        [Parameter()]
        [System.String]
        $PasscodePreviousPasscodeBlockCount,

        [Parameter()]
        [System.String]
        $PasscodeSignInFailureCountBeforeWipe,

        [Parameter()]
        [System.String]
        [ValidateSet('DeviceDefault', 'Alphanumeric','Numeric')]
        $PasscodeRequiredType = "deviceDefault",

        [Parameter()]
        [System.Boolean]
        $PasscodeRequired,

        [Parameter()]
        [System.Boolean]
        $PodcastsBlocked,

        [Parameter()]
        [System.Boolean]
        $ProximityBlockSetupToNewDevice,

        [Parameter()]
        [System.Boolean]
        $SafariBlockAutofill,

        [Parameter()]
        [System.Boolean]
        $SafariBlockJavaScript,

        [Parameter()]
        [System.Boolean]
        $SafariBlockPopups,

        [Parameter()]
        [System.Boolean]
        $SafariBlocked,

        [Parameter()]
        [System.String]
        [ValidateSet('BrowserDefault', 'BlockAlways','AllowCurrentWebSite','AllowFromWebsitesVisited','AllowAlways')]
        $SafariCookieSettings,

        [Parameter()]
        [System.String[]]
        $SafariManagedDomains,

        [Parameter()]
        [System.String[]]
        $SafariPasswordAutoFillDomains,

        [Parameter()]
        [System.Boolean]
        $SafariRequireFraudWarning,

        [Parameter()]
        [System.Boolean]
        $ScreenCaptureBlocked,

        [Parameter()]
        [System.Boolean]
        $SiriBlocked,

        [Parameter()]
        [System.Boolean]
        $SiriBlockedWhenLocked,

        [Parameter()]
        [System.Boolean]
        $SiriBlockUserGeneratedContent,

        [Parameter()]
        [System.Boolean]
        $SiriRequireProfanityFilter,

        [Parameter()]
        [System.Uint32]
        $SoftwareUpdatesEnforcedDelayInDays,

        [Parameter()]
        [System.Boolean]
        $SoftwareUpdatesForceDelayed,

        [Parameter()]
        [System.Boolean]
        $SpotlightBlockInternetResults,

        [Parameter()]
        [System.Boolean]
        $VoiceDialingBlocked,

        [Parameter()]
        [System.Boolean]
        $WallpaperBlockModification,

        [Parameter()]
        [System.Boolean]
	    $WiFiConnectOnlyToConfiguredNetworks,

	    [Parameter()]
        [System.Boolean]
	    $ClassroomForceRequestPermissionToLeaveClasses,

        [Parameter()]
        [System.Boolean]
	    $KeychainBlockCloudSync,

	    [Parameter()]
        [System.Boolean]
	    $PkiBlockOTAUpdates,

        [Parameter()]
        [System.Boolean]
	    $PrivacyForceLimitAdTracking,

        [Parameter()]
        [System.Boolean]
	    $EnterpriseBookBlockBackup,

        [Parameter()]
        [System.Boolean]
	    $EnterpriseBookBlockMetadataSync,

	    [Parameter()]
        [System.Boolean]
	    $AirPrintBlocked,

        [Parameter()]
        [System.Boolean]
	    $AirPrintBlockCredentialsStorage,

        [Parameter()]
        [System.Boolean]
	    $AirPrintForceTrustedTLS,

        [Parameter()]
        [System.Boolean]
	    $AirPrintBlockiBeaconDiscovery,

        [Parameter()]
        [System.Boolean]
	    $FilesNetworkDriveAccessBlocked,

        [Parameter()]
        [System.Boolean]
	    $FilesUsbDriveAccessBlocked,

        [Parameter()]
        [System.Boolean]
	    $WifiPowerOnForced,

        [Parameter()]
        [System.Boolean]
	    $BlockSystemAppRemoval,

        [Parameter()]
        [System.Boolean]
	    $VpnBlockCreation,

        [Parameter()]
        [System.Boolean]
	    $AppRemovalBlocked,

        [Parameter()]
        [System.Boolean]
	    $UsbRestrictedModeBlocked,

        [Parameter()]
        [System.Boolean]
	    $PasswordBlockAutoFill,

        [Parameter()]
        [System.Boolean]
	    $PasswordBlockProximityRequests,

        [Parameter()]
        [System.Boolean]
	    $PasswordBlockAirDropSharing,

        [Parameter()]
        [System.Boolean]
	    $DateAndTimeForceSetAutomatically,

        [Parameter()]
        [System.Boolean]
	    $ContactsAllowManagedToUnmanagedWrite,

        [Parameter()]
        [System.Boolean]
	    $ContactsAllowUnmanagedToManagedRead,

        [Parameter()]
        [System.Boolean]
	    $CellularBlockPersonalHotspotModification,

        [Parameter()]
        [System.Boolean]
	    $ContinuousPathKeyboardBlocked,

        [Parameter()]
        [System.Boolean]
	    $FindMyDeviceInFindMyAppBlocked,

        [Parameter()]
        [System.Boolean]
	    $FindMyFriendsInFindMyAppBlocked,

        [Parameter()]
        [System.Boolean]
	    $ITunesBlocked,

        [Parameter()]
        [System.Boolean]
	    $SharedDeviceBlockTemporarySessions,

        [Parameter()]
        [System.Boolean]
	    $AppClipsBlocked,

        [Parameter()]
        [System.Boolean]
	    $ApplePersonalizedAdsBlocked,

        [Parameter()]
        [System.Boolean]
	    $NfcBlocked,

        [Parameter()]
        [System.Boolean]
	    $AutoUnlockBlocked,

        [Parameter()]
        [System.Boolean]
	    $UnpairedExternalBootToRecoveryAllowed,

        [Parameter()]
        [System.Boolean]
	    $OnDeviceOnlyDictationForced,

        [Parameter()]
        [System.Boolean]
	    $WiFiConnectToAllowedNetworksOnlyForced,

        [Parameter()]
        [System.Boolean]
	    $OnDeviceOnlyTranslationForced,

        [Parameter()]
        [System.Boolean]
	    $ManagedPasteboardRequired,

        [Parameter()]
        [System.String]
	    [ValidateSet('NotConfigured', 'AppStoreApp','ManagedApp','BuiltInApp')]
        $KioskModeAppType,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $deviceManagementApplicabilityRuleOsVersion,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $deviceManagementApplicabilityRuleOsEdition,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $deviceManagementApplicabilityRuleDeviceMode,

        [Parameter(Mandatory = $true)]
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
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
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

    if ($null -ne $appsVisibilityList)
    {
        $TestappsVisibilityList = Test-AdvancedSettings -DesiredProperty $appsVisibilityList -CurrentProperty $CurrentValues.appsVisibilityList
        if ($false -eq $TestappsVisibilityList)
        {
            return $false
        }
    }
    elseif($null -ne $appsSingleAppModeList)
    {
        $TestappsSingleAppModeList = Test-AdvancedSettings -DesiredProperty $appsSingleAppModeList -CurrentProperty $CurrentValues.appsSingleAppModeList
        if ($false -eq $TestappsSingleAppModeList)
        {
            return $false
        }
    }
    elseif($null -ne $compliantAppsList)
    {
        $TestcompliantAppsList = Test-AdvancedSettings -DesiredProperty $compliantAppsList -CurrentProperty $CurrentValues.compliantAppsList
        if ($false -eq $TestAdvancedSettings)
        {
            return $false
        }
    }
    elseif($null -ne $mediaContentRatingAustralia)
    {
        $TestmediaContentRatingAustralia = Test-AdvancedSettings -DesiredProperty $mediaContentRatingAustralia -CurrentProperty $CurrentValues.mediaContentRatingAustralia
        if ($false -eq $TestmediaContentRatingAustralia)
        {
            return $false
        }
    }
    elseif($null -ne $mediaContentRatingCanada)
    {
        $TestmediaContentRatingCanada = Test-AdvancedSettings -DesiredProperty $mediaContentRatingCanada -CurrentProperty $CurrentValues.mediaContentRatingCanada
        if ($false -eq $TestmediaContentRatingCanada)
        {
            return $false
        }
    }
    elseif($null -ne $mediaContentRatingFrance)
    {
        $TestmediaContentRatingFrance = Test-AdvancedSettings -DesiredProperty $mediaContentRatingFrance -CurrentProperty $CurrentValues.mediaContentRatingFrance
        if ($false -eq $TestmediaContentRatingFrance)
        {
            return $false
        }
    }
    elseif($null -ne $mediaContentRatingGermany)
    {
        $TestmediaContentRatingGermany = Test-AdvancedSettings -DesiredProperty $mediaContentRatingGermany -CurrentProperty $CurrentValues.mediaContentRatingGermany
        if ($false -eq $TestmediaContentRatingGermany)
        {
            return $false
        }
    }
    elseif($null -ne $mediaContentRatingIreland)
    {
        $TestmediaContentRatingIreland = Test-AdvancedSettings -DesiredProperty $mediaContentRatingIreland -CurrentProperty $CurrentValues.mediaContentRatingIreland
        if ($false -eq $TestmediaContentRatingIreland)
        {
            return $false
        }
    }
    elseif($null -ne $mediaContentRatingJapan)
    {
        $TestmediaContentRatingJapan = Test-AdvancedSettings -DesiredProperty $mediaContentRatingJapan -CurrentProperty $CurrentValues.mediaContentRatingJapan
        if ($false -eq $TestmediaContentRatingJapan)
        {
            return $false
        }
    }
    elseif($null -ne $mediaContentRatingNewZealand)
    {
        $TestmediaContentRatingNewZealand = Test-AdvancedSettings -DesiredProperty $mediaContentRatingNewZealand -CurrentProperty $CurrentValues.mediaContentRatingNewZealand
        if ($false -eq $TestmediaContentRatingNewZealand)
        {
            return $false
        }
    }
    elseif($null -ne $mediaContentRatingUnitedKingdom)
    {
        $TestmediaContentRatingUnitedKingdom = Test-AdvancedSettings -DesiredProperty $mediaContentRatingUnitedKingdom -CurrentProperty $CurrentValues.mediaContentRatingUnitedKingdom
        if ($false -eq $TestmediaContentRatingUnitedKingdom)
        {
            return $false
        }
    }
    elseif($null -ne $mediaContentRatingUnitedStates)
    {
        $TestmediaContentRatingUnitedStates = Test-AdvancedSettings -DesiredProperty $mediaContentRatingUnitedStates -CurrentProperty $CurrentValues.mediaContentRatingUnitedStates
        if ($false -eq $TestmediaContentRatingUnitedStates)
        {
            return $false
        }
    }
    elseif($null -ne $iOSNetworkUsageRules)
    {
        $TestiOSNetworkUsageRules = Test-AdvancedSettings -DesiredProperty $iOSNetworkUsageRules -CurrentProperty $CurrentValues.iOSNetworkUsageRules
        if ($false -eq $TestiOSNetworkUsageRules)
        {
            return $false
        }
    }
    elseif($null -ne $AdvancedSettings)
    {
        $TestAdvancedSettings = Test-AdvancedSettings -DesiredProperty $AdvancedSettings -CurrentProperty $CurrentValues.AdvancedSettings
        if ($false -eq $TestAdvancedSettings)
        {
            return $false
        }
    }
    elseif($null -ne $AdvancedSettings)
    {
        $TestAdvancedSettings = Test-AdvancedSettings -DesiredProperty $AdvancedSettings -CurrentProperty $CurrentValues.AdvancedSettings
        if ($false -eq $TestAdvancedSettings)
        {
            return $false
        }
    }
    elseif($null -ne $AdvancedSettings)
    {
        $TestAdvancedSettings = Test-AdvancedSettings -DesiredProperty $AdvancedSettings -CurrentProperty $CurrentValues.AdvancedSettings
        if ($false -eq $TestAdvancedSettings)
        {
            return $false
        }
    }
    elseif($null -ne $DeviceManagementApplicabilityRuleOsEdition)
    {
        $TestDeviceManagementApplicabilityRuleOsEdition = Test-AdvancedSettings -DesiredProperty $DeviceManagementApplicabilityRuleOsEdition -CurrentProperty $CurrentValues.DeviceManagementApplicabilityRuleOsEdition
        if ($false -eq $TestDeviceManagementApplicabilityRuleOsEdition)
        {
            return $false
        }
    }
    elseif($null -ne $DeviceManagementApplicabilityRuleOsVersion)
    {
        $TestDeviceManagementApplicabilityRuleOsVersion = Test-AdvancedSettings -DesiredProperty $DeviceManagementApplicabilityRuleOsVersion -CurrentProperty $CurrentValues.DeviceManagementApplicabilityRuleOsVersion
        if ($false -eq $TestDeviceManagementApplicabilityRuleOsVersion)
        {
            return $false
        }
    }
    elseif($null -ne $DeviceManagementApplicabilityRuleDeviceMode)
    {
        $TestDeviceManagementApplicabilityRuleDeviceMode = Test-AdvancedSettings -DesiredProperty $DeviceManagementApplicabilityRuleDeviceMode -CurrentProperty $CurrentValues.DeviceManagementApplicabilityRuleDeviceMode
        if ($false -eq $TestDeviceManagementApplicabilityRuleDeviceMode)
        {
            return $false
        }
    }


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
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters -ProfileName 'Beta'
    Select-MgProfile -Name Beta | Out-Null

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
        [array]$policies = Get-MGDeviceManagementDeviceConfiguration `
            -ErrorAction Stop | Where-Object `
            -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.iosGeneralDeviceConfiguration' }
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
            Write-Host "    |---[$i/$($policies.Count)] $($policy.displayName)" -NoNewline
            $params = @{
                DisplayName           = $policy.displayName
                Ensure                = 'Present'
                GlobalAdminAccount    = $GlobalAdminAccount
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

function Convert-StringToAdvancedSettings
{
    [CmdletBinding()]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    Param(
        [parameter(Mandatory = $true)]
        [System.String[]]
        $AdvancedSettings
    )
    $settings = @()
    foreach ($setting in $AdvancedSettings)
    {
        $settingString = $setting.Replace("[", "").Replace("]", "")
        $settingKey = $settingString.Split(",")[0]

        if ($settingKey -ne 'displayname')
        {
            $startPos = $settingString.IndexOf(",", 0) + 1
            $valueString = $settingString.Substring($startPos, $settingString.Length - $startPos).Trim()
            $values = $valueString.Split(",")

            $entry = @{
                Key   = $settingKey
                Value = $values
            }
            $settings += $entry
        }
    }
    return $settings
}
function Convert-CIMToAdvancedSettings
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    Param(
        [parameter(Mandatory = $true)]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AdvancedSettings
    )

    $entry = @{ }
    foreach ($obj in $AdvancedSettings)
    {
        $settingsValues = ""
        foreach ($objVal in $obj.Value)
        {
            $settingsValues += $objVal
            $settingsValues += ","
        }
        $entry[$obj.Key] = $settingsValues.Substring(0, ($settingsValues.Length - 1))
    }

    return $entry
}

function Test-AdvancedSettings
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param(
        [Parameter (Mandatory = $true)]
        $DesiredProperty,

        [Parameter (Mandatory = $true)]
        $CurrentProperty
    )

    $foundSettings = $true
    foreach ($desiredSetting in $DesiredProperty)
    {
        $foundKey = $CurrentProperty | Where-Object { $_.Key -eq $desiredSetting.Key }
        if ($null -ne $foundKey)
        {
            if ($foundKey.Value.ToString() -ne $desiredSetting.Value.ToString())
            {
                $foundSettings = $false
                break;
            }
        }
    }

    Write-Verbose -Message "Test AdvancedSettings  returns $foundSettings"
    return $foundSettings
}

function ConvertTo-AdvancedSettingsString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        $AdvancedSettings
    )

    $StringContent = "@(`r`n"
    foreach ($advancedSetting in $AdvancedSettings)
    {
        $StringContent += "                MSFT_SCLabelSetting`r`n"
        $StringContent += "                {`r`n"
        $StringContent += "                    Key   = '$($advancedSetting.Key.Replace("'", "''"))'`r`n"
        $StringContent += "                    Value = '$($advancedSetting.Value.Replace("'", "''"))'`r`n"
        $StringContent += "                }`r`n"
    }
    $StringContent += "            )"
    return $StringContent
}

function Convert-ArrayList
{
    [CmdletBinding()]
    [OutputType([System.Collections.ArrayList])]
    param(
        [Parameter ()]
        $CurrentProperty
    )
    [System.Collections.ArrayList]$currentItems = @()
    foreach ($currentProp in $CurrentProperty)
    {
        $currentItems.Add($currentProp.Name) | Out-Null
    }

    return $currentItems

}

function New-PolicyData
{
    [CmdletBinding()]
    [OutputType([System.Collections.ArrayList])]
    param(
        [Parameter ()]
        $configData,

        [Parameter ()]
        $currentData,

        [Parameter ()]
        $removedData,

        [Parameter ()]
        $additionalData
    )
    [System.Collections.ArrayList]$desiredData = @()
    foreach ($currItem in $currentData)
    {
        if (!$desiredData.Contains($currItem))
        {
            $desiredData.add($currItem) | Out-Null
        }
    }

    foreach ($currItem in $configData)
    {
        if (!$desiredData.Contains("$curritem"))
        {
            $desiredData.add($currItem) | Out-Null
        }
    }

    foreach ($currItem in $removedData)
    {
        $desiredData.remove($currItem) | Out-Null
    }

    foreach ($currItem in $additionalData)
    {
        if (!$desiredData.Contains("$curritem"))
        {
            $desiredData.add($currItem) | Out-Null
        }
    }

    return $desiredData
}


function Get-M365DSCIntuneiOSNetworkUsageRule
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = 'true')]
        $rules
    )

    $results = @{}
    foreach ($rule in $rules)
    {
        Write-Host "Rule is"
        $rule
        if ($rule.Keys -eq 'managedApps'){
            $ManagedApps = @{}
            foreach ($app in $rule.managedApps) {
                Write-Host "App is "
                $app
                $ruleApp = @{}
                foreach ($item in $app){
                    $ruleApp.Add('name',$item.name)
                    $ruleApp.Add('publisher',$item.publisher)
                    $ruleApp.Add('appId',$item.appId)
                    #$ruleApp.Add($item.Keys,$item.Values)
                }
                #$AppKey = $item[0].ToString().ToLower() + $item.Substring(1, $item.Length - 1)
               # $AppValue = $property.$item
               # $ManagedApps.Add($AppKey, $AppValue)
            }
            $propertyName = 'ManagedApps'
            $results.Add($propertyName,$ruleApp)
        }
        elseif ($property -ne 'Verbose')
        {
            $propertyName = $property[0].ToString().ToLower() + $property.Substring(1, $property.Length - 1)
            $propertyValue = $properties.$property
            $results.Add($propertyName, $propertyValue)
        }
    }
    return $results
}

function Get-M365DSCIntuneNestedObject
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = 'true')]
        $Properties
    )

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
