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
        $AirPrintBlockCredentialsStorage,

        [Parameter()]
        [System.Boolean]
        $AirPrintBlocked,

        [Parameter()]
        [System.Boolean]
        $AirPrintBlockiBeaconDiscovery,

        [Parameter()]
        [System.Boolean]
        $AirPrintForceTrustedTLS,

        [Parameter()]
        [System.Boolean]
        $AppClipsBlocked,

        [Parameter()]
        [System.Boolean]
        $AppleNewsBlocked,

        [Parameter()]
        [System.Boolean]
        $ApplePersonalizedAdsBlocked,

        [Parameter()]
        [System.Boolean]
        $AppleWatchBlockPairing,

        [Parameter()]
        [System.Boolean]
        $AppleWatchForceWristDetection,

        [Parameter()]
        [System.Boolean]
        $AppRemovalBlocked,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AppsSingleAppModeList,

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
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AppsVisibilityList,

        [Parameter()]
        [ValidateSet('none','appsInListCompliant','appsNotInListCompliant')]
        [System.String]
        $AppsVisibilityListType,

        [Parameter()]
        [System.Boolean]
        $AutoFillForceAuthentication,

        [Parameter()]
        [System.Boolean]
        $AutoUnlockBlocked,

        [Parameter()]
        [System.Boolean]
        $BlockSystemAppRemoval,

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
        $CellularBlockPersonalHotspotModification,

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
        $ClassroomForceRequestPermissionToLeaveClasses,

        [Parameter()]
        [System.Boolean]
        $ClassroomForceUnpromptedAppAndDeviceLock,

        [Parameter()]
        [ValidateSet('none','appsInListCompliant','appsNotInListCompliant')]
        [System.String]
        $CompliantAppListType,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CompliantAppsList,

        [Parameter()]
        [System.Boolean]
        $ConfigurationProfileBlockChanges,

        [Parameter()]
        [System.Boolean]
        $ContactsAllowManagedToUnmanagedWrite,

        [Parameter()]
        [System.Boolean]
        $ContactsAllowUnmanagedToManagedRead,

        [Parameter()]
        [System.Boolean]
        $ContinuousPathKeyboardBlocked,

        [Parameter()]
        [System.Boolean]
        $DateAndTimeForceSetAutomatically,

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
        $EnterpriseBookBlockBackup,

        [Parameter()]
        [System.Boolean]
        $EnterpriseBookBlockMetadataSync,

        [Parameter()]
        [System.Boolean]
        $EsimBlockModification,

        [Parameter()]
        [System.Boolean]
        $FaceTimeBlocked,

        [Parameter()]
        [System.Boolean]
        $FilesNetworkDriveAccessBlocked,

        [Parameter()]
        [System.Boolean]
        $FilesUsbDriveAccessBlocked,

        [Parameter()]
        [System.Boolean]
        $FindMyDeviceInFindMyAppBlocked,

        [Parameter()]
        [System.Boolean]
        $FindMyFriendsBlocked,

        [Parameter()]
        [System.Boolean]
        $FindMyFriendsInFindMyAppBlocked,

        [Parameter()]
        [System.Boolean]
        $GameCenterBlocked,

        [Parameter()]
        [System.Boolean]
        $GamingBlockGameCenterFriends,

        [Parameter()]
        [System.Boolean]
        $GamingBlockMultiplayer,

        [Parameter()]
        [System.Boolean]
        $HostPairingBlocked,

        [Parameter()]
        [System.Boolean]
        $IBooksStoreBlocked,

        [Parameter()]
        [System.Boolean]
        $IBooksStoreBlockErotica,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockActivityContinuation,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockBackup,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockDocumentSync,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockManagedAppsSync,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockPhotoLibrary,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockPhotoStreamSync,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockSharedPhotoStream,

        [Parameter()]
        [System.Boolean]
        $ICloudPrivateRelayBlocked,

        [Parameter()]
        [System.Boolean]
        $ICloudRequireEncryptedBackup,

        [Parameter()]
        [System.Boolean]
        $ITunesBlocked,

        [Parameter()]
        [System.Boolean]
        $ITunesBlockExplicitContent,

        [Parameter()]
        [System.Boolean]
        $ITunesBlockMusicService,

        [Parameter()]
        [System.Boolean]
        $ITunesBlockRadio,

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
        $KeychainBlockCloudSync,

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
        $KioskModeAllowColorInversionSettings,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowRingerSwitch,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowScreenRotation,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowSleepButton,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowTouchscreen,

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
        $KioskModeAllowZoomSettings,

        [Parameter()]
        [System.String]
        $KioskModeAppStoreUrl,

        [Parameter()]
        [ValidateSet('notConfigured','appStoreApp','managedApp','builtInApp')]
        [System.String]
        $KioskModeAppType,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockAutoLock,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockRingerSwitch,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockScreenRotation,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockSleepButton,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockTouchscreen,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockVolumeButtons,

        [Parameter()]
        [System.String]
        $KioskModeBuiltInAppId,

        [Parameter()]
        [System.Boolean]
        $KioskModeEnableVoiceControl,

        [Parameter()]
        [System.String]
        $KioskModeManagedAppId,

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
        [System.Boolean]
        $ManagedPasteboardRequired,

        [Parameter()]
        [ValidateSet('allAllowed','allBlocked','agesAbove4','agesAbove9','agesAbove12','agesAbove17')]
        [System.String]
        $MediaContentRatingApps,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MediaContentRatingAustralia,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MediaContentRatingCanada,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MediaContentRatingFrance,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MediaContentRatingGermany,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MediaContentRatingIreland,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MediaContentRatingJapan,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MediaContentRatingNewZealand,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MediaContentRatingUnitedKingdom,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MediaContentRatingUnitedStates,

        [Parameter()]
        [System.Boolean]
        $MessagesBlocked,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $NetworkUsageRules,

        [Parameter()]
        [System.Boolean]
        $NfcBlocked,

        [Parameter()]
        [System.Boolean]
        $NotificationsBlockSettingsModification,

        [Parameter()]
        [System.Boolean]
        $OnDeviceOnlyDictationForced,

        [Parameter()]
        [System.Boolean]
        $OnDeviceOnlyTranslationForced,

        [Parameter()]
        [System.Boolean]
        $PasscodeBlockFingerprintModification,

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
        [System.Int32]
        $PasscodeExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasscodeMinimumCharacterSetCount,

        [Parameter()]
        [System.Int32]
        $PasscodeMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasscodeMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.Int32]
        $PasscodeMinutesOfInactivityBeforeScreenTimeout,

        [Parameter()]
        [System.Int32]
        $PasscodePreviousPasscodeBlockCount,

        [Parameter()]
        [System.Boolean]
        $PasscodeRequired,

        [Parameter()]
        [ValidateSet('deviceDefault','alphanumeric','numeric')]
        [System.String]
        $PasscodeRequiredType,

        [Parameter()]
        [System.Int32]
        $PasscodeSignInFailureCountBeforeWipe,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockAirDropSharing,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockAutoFill,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockProximityRequests,

        [Parameter()]
        [System.Boolean]
        $PkiBlockOTAUpdates,

        [Parameter()]
        [System.Boolean]
        $PodcastsBlocked,

        [Parameter()]
        [System.Boolean]
        $PrivacyForceLimitAdTracking,

        [Parameter()]
        [System.Boolean]
        $ProximityBlockSetupToNewDevice,

        [Parameter()]
        [System.Boolean]
        $SafariBlockAutofill,

        [Parameter()]
        [System.Boolean]
        $SafariBlockPopups,

        [Parameter()]
        [System.Boolean]
        $SafariBlockJavaScript,

        [Parameter()]
        [ValidateSet('browserDefault','blockAlways','allowCurrentWebSite','allowFromWebsitesVisited','allowAlways')]
        [System.String]
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
        $SharedDeviceBlockTemporarySessions,

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
        [System.Int32]
        $SoftwareUpdatesEnforcedDelayInDays,

        [Parameter()]
        [System.Boolean]
        $SoftwareUpdatesForceDelayed,

        [Parameter()]
        [System.Boolean]
        $SpotlightBlockInternetResults,

        [Parameter()]
        [System.Boolean]
        $UnpairedExternalBootToRecoveryAllowed,

        [Parameter()]
        [System.Boolean]
        $UsbRestrictedModeBlocked,

        [Parameter()]
        [System.Boolean]
        $VoiceDialingBlocked,

        [Parameter()]
        [System.Boolean]
        $VpnBlockCreation,

        [Parameter()]
        [System.Boolean]
        $WallpaperBlockModification,

        [Parameter()]
        [System.Boolean]
        $WiFiConnectOnlyToConfiguredNetworks,

        [Parameter()]
        [System.Boolean]
        $WiFiConnectToAllowedNetworksOnlyForced,

        [Parameter()]
        [System.Boolean]
        $WifiPowerOnForced,


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
            AccountBlockModification = $getValue.AdditionalProperties.accountBlockModification
            ActivationLockAllowWhenSupervised = $getValue.AdditionalProperties.activationLockAllowWhenSupervised
            AirDropBlocked = $getValue.AdditionalProperties.airDropBlocked
            AirDropForceUnmanagedDropTarget = $getValue.AdditionalProperties.airDropForceUnmanagedDropTarget
            AirPlayForcePairingPasswordForOutgoingRequests = $getValue.AdditionalProperties.airPlayForcePairingPasswordForOutgoingRequests
            AirPrintBlockCredentialsStorage = $getValue.AdditionalProperties.airPrintBlockCredentialsStorage
            AirPrintBlocked = $getValue.AdditionalProperties.airPrintBlocked
            AirPrintBlockiBeaconDiscovery = $getValue.AdditionalProperties.airPrintBlockiBeaconDiscovery
            AirPrintForceTrustedTLS = $getValue.AdditionalProperties.airPrintForceTrustedTLS
            AppClipsBlocked = $getValue.AdditionalProperties.appClipsBlocked
            AppleNewsBlocked = $getValue.AdditionalProperties.appleNewsBlocked
            ApplePersonalizedAdsBlocked = $getValue.AdditionalProperties.applePersonalizedAdsBlocked
            AppleWatchBlockPairing = $getValue.AdditionalProperties.appleWatchBlockPairing
            AppleWatchForceWristDetection = $getValue.AdditionalProperties.appleWatchForceWristDetection
            AppRemovalBlocked = $getValue.AdditionalProperties.appRemovalBlocked
            AppStoreBlockAutomaticDownloads = $getValue.AdditionalProperties.appStoreBlockAutomaticDownloads
            AppStoreBlocked = $getValue.AdditionalProperties.appStoreBlocked
            AppStoreBlockInAppPurchases = $getValue.AdditionalProperties.appStoreBlockInAppPurchases
            AppStoreBlockUIAppInstallation = $getValue.AdditionalProperties.appStoreBlockUIAppInstallation
            AppStoreRequirePassword = $getValue.AdditionalProperties.appStoreRequirePassword
            AppsVisibilityListType = $getValue.AdditionalProperties.appsVisibilityListType
            AutoFillForceAuthentication = $getValue.AdditionalProperties.autoFillForceAuthentication
            AutoUnlockBlocked = $getValue.AdditionalProperties.autoUnlockBlocked
            BlockSystemAppRemoval = $getValue.AdditionalProperties.blockSystemAppRemoval
            BluetoothBlockModification = $getValue.AdditionalProperties.bluetoothBlockModification
            CameraBlocked = $getValue.AdditionalProperties.cameraBlocked
            CellularBlockDataRoaming = $getValue.AdditionalProperties.cellularBlockDataRoaming
            CellularBlockGlobalBackgroundFetchWhileRoaming = $getValue.AdditionalProperties.cellularBlockGlobalBackgroundFetchWhileRoaming
            CellularBlockPerAppDataModification = $getValue.AdditionalProperties.cellularBlockPerAppDataModification
            CellularBlockPersonalHotspot = $getValue.AdditionalProperties.cellularBlockPersonalHotspot
            CellularBlockPersonalHotspotModification = $getValue.AdditionalProperties.cellularBlockPersonalHotspotModification
            CellularBlockPlanModification = $getValue.AdditionalProperties.cellularBlockPlanModification
            CellularBlockVoiceRoaming = $getValue.AdditionalProperties.cellularBlockVoiceRoaming
            CertificatesBlockUntrustedTlsCertificates = $getValue.AdditionalProperties.certificatesBlockUntrustedTlsCertificates
            ClassroomAppBlockRemoteScreenObservation = $getValue.AdditionalProperties.classroomAppBlockRemoteScreenObservation
            ClassroomAppForceUnpromptedScreenObservation = $getValue.AdditionalProperties.classroomAppForceUnpromptedScreenObservation
            ClassroomForceAutomaticallyJoinClasses = $getValue.AdditionalProperties.classroomForceAutomaticallyJoinClasses
            ClassroomForceRequestPermissionToLeaveClasses = $getValue.AdditionalProperties.classroomForceRequestPermissionToLeaveClasses
            ClassroomForceUnpromptedAppAndDeviceLock = $getValue.AdditionalProperties.classroomForceUnpromptedAppAndDeviceLock
            CompliantAppListType = $getValue.AdditionalProperties.compliantAppListType
            ConfigurationProfileBlockChanges = $getValue.AdditionalProperties.configurationProfileBlockChanges
            ContactsAllowManagedToUnmanagedWrite = $getValue.AdditionalProperties.contactsAllowManagedToUnmanagedWrite
            ContactsAllowUnmanagedToManagedRead = $getValue.AdditionalProperties.contactsAllowUnmanagedToManagedRead
            ContinuousPathKeyboardBlocked = $getValue.AdditionalProperties.continuousPathKeyboardBlocked
            DateAndTimeForceSetAutomatically = $getValue.AdditionalProperties.dateAndTimeForceSetAutomatically
            DefinitionLookupBlocked = $getValue.AdditionalProperties.definitionLookupBlocked
            DeviceBlockEnableRestrictions = $getValue.AdditionalProperties.deviceBlockEnableRestrictions
            DeviceBlockEraseContentAndSettings = $getValue.AdditionalProperties.deviceBlockEraseContentAndSettings
            DeviceBlockNameModification = $getValue.AdditionalProperties.deviceBlockNameModification
            DiagnosticDataBlockSubmission = $getValue.AdditionalProperties.diagnosticDataBlockSubmission
            DiagnosticDataBlockSubmissionModification = $getValue.AdditionalProperties.diagnosticDataBlockSubmissionModification
            DocumentsBlockManagedDocumentsInUnmanagedApps = $getValue.AdditionalProperties.documentsBlockManagedDocumentsInUnmanagedApps
            DocumentsBlockUnmanagedDocumentsInManagedApps = $getValue.AdditionalProperties.documentsBlockUnmanagedDocumentsInManagedApps
            EmailInDomainSuffixes = $getValue.AdditionalProperties.emailInDomainSuffixes
            EnterpriseAppBlockTrust = $getValue.AdditionalProperties.enterpriseAppBlockTrust
            EnterpriseAppBlockTrustModification = $getValue.AdditionalProperties.enterpriseAppBlockTrustModification
            EnterpriseBookBlockBackup = $getValue.AdditionalProperties.enterpriseBookBlockBackup
            EnterpriseBookBlockMetadataSync = $getValue.AdditionalProperties.enterpriseBookBlockMetadataSync
            EsimBlockModification = $getValue.AdditionalProperties.esimBlockModification
            FaceTimeBlocked = $getValue.AdditionalProperties.faceTimeBlocked
            FilesNetworkDriveAccessBlocked = $getValue.AdditionalProperties.filesNetworkDriveAccessBlocked
            FilesUsbDriveAccessBlocked = $getValue.AdditionalProperties.filesUsbDriveAccessBlocked
            FindMyDeviceInFindMyAppBlocked = $getValue.AdditionalProperties.findMyDeviceInFindMyAppBlocked
            FindMyFriendsBlocked = $getValue.AdditionalProperties.findMyFriendsBlocked
            FindMyFriendsInFindMyAppBlocked = $getValue.AdditionalProperties.findMyFriendsInFindMyAppBlocked
            GameCenterBlocked = $getValue.AdditionalProperties.gameCenterBlocked
            GamingBlockGameCenterFriends = $getValue.AdditionalProperties.gamingBlockGameCenterFriends
            GamingBlockMultiplayer = $getValue.AdditionalProperties.gamingBlockMultiplayer
            HostPairingBlocked = $getValue.AdditionalProperties.hostPairingBlocked
            IBooksStoreBlocked = $getValue.AdditionalProperties.iBooksStoreBlocked
            IBooksStoreBlockErotica = $getValue.AdditionalProperties.iBooksStoreBlockErotica
            ICloudBlockActivityContinuation = $getValue.AdditionalProperties.iCloudBlockActivityContinuation
            ICloudBlockBackup = $getValue.AdditionalProperties.iCloudBlockBackup
            ICloudBlockDocumentSync = $getValue.AdditionalProperties.iCloudBlockDocumentSync
            ICloudBlockManagedAppsSync = $getValue.AdditionalProperties.iCloudBlockManagedAppsSync
            ICloudBlockPhotoLibrary = $getValue.AdditionalProperties.iCloudBlockPhotoLibrary
            ICloudBlockPhotoStreamSync = $getValue.AdditionalProperties.iCloudBlockPhotoStreamSync
            ICloudBlockSharedPhotoStream = $getValue.AdditionalProperties.iCloudBlockSharedPhotoStream
            ICloudPrivateRelayBlocked = $getValue.AdditionalProperties.iCloudPrivateRelayBlocked
            ICloudRequireEncryptedBackup = $getValue.AdditionalProperties.iCloudRequireEncryptedBackup
            ITunesBlocked = $getValue.AdditionalProperties.iTunesBlocked
            ITunesBlockExplicitContent = $getValue.AdditionalProperties.iTunesBlockExplicitContent
            ITunesBlockMusicService = $getValue.AdditionalProperties.iTunesBlockMusicService
            ITunesBlockRadio = $getValue.AdditionalProperties.iTunesBlockRadio
            KeyboardBlockAutoCorrect = $getValue.AdditionalProperties.keyboardBlockAutoCorrect
            KeyboardBlockDictation = $getValue.AdditionalProperties.keyboardBlockDictation
            KeyboardBlockPredictive = $getValue.AdditionalProperties.keyboardBlockPredictive
            KeyboardBlockShortcuts = $getValue.AdditionalProperties.keyboardBlockShortcuts
            KeyboardBlockSpellCheck = $getValue.AdditionalProperties.keyboardBlockSpellCheck
            KeychainBlockCloudSync = $getValue.AdditionalProperties.keychainBlockCloudSync
            KioskModeAllowAssistiveSpeak = $getValue.AdditionalProperties.kioskModeAllowAssistiveSpeak
            KioskModeAllowAssistiveTouchSettings = $getValue.AdditionalProperties.kioskModeAllowAssistiveTouchSettings
            KioskModeAllowAutoLock = $getValue.AdditionalProperties.kioskModeAllowAutoLock
            KioskModeAllowColorInversionSettings = $getValue.AdditionalProperties.kioskModeAllowColorInversionSettings
            KioskModeAllowRingerSwitch = $getValue.AdditionalProperties.kioskModeAllowRingerSwitch
            KioskModeAllowScreenRotation = $getValue.AdditionalProperties.kioskModeAllowScreenRotation
            KioskModeAllowSleepButton = $getValue.AdditionalProperties.kioskModeAllowSleepButton
            KioskModeAllowTouchscreen = $getValue.AdditionalProperties.kioskModeAllowTouchscreen
            KioskModeAllowVoiceControlModification = $getValue.AdditionalProperties.kioskModeAllowVoiceControlModification
            KioskModeAllowVoiceOverSettings = $getValue.AdditionalProperties.kioskModeAllowVoiceOverSettings
            KioskModeAllowVolumeButtons = $getValue.AdditionalProperties.kioskModeAllowVolumeButtons
            KioskModeAllowZoomSettings = $getValue.AdditionalProperties.kioskModeAllowZoomSettings
            KioskModeAppStoreUrl = $getValue.AdditionalProperties.kioskModeAppStoreUrl
            KioskModeAppType = $getValue.AdditionalProperties.kioskModeAppType
            KioskModeBlockAutoLock = $getValue.AdditionalProperties.kioskModeBlockAutoLock
            KioskModeBlockRingerSwitch = $getValue.AdditionalProperties.kioskModeBlockRingerSwitch
            KioskModeBlockScreenRotation = $getValue.AdditionalProperties.kioskModeBlockScreenRotation
            KioskModeBlockSleepButton = $getValue.AdditionalProperties.kioskModeBlockSleepButton
            KioskModeBlockTouchscreen = $getValue.AdditionalProperties.kioskModeBlockTouchscreen
            KioskModeBlockVolumeButtons = $getValue.AdditionalProperties.kioskModeBlockVolumeButtons
            KioskModeBuiltInAppId = $getValue.AdditionalProperties.kioskModeBuiltInAppId
            KioskModeEnableVoiceControl = $getValue.AdditionalProperties.kioskModeEnableVoiceControl
            KioskModeManagedAppId = $getValue.AdditionalProperties.kioskModeManagedAppId
            KioskModeRequireAssistiveTouch = $getValue.AdditionalProperties.kioskModeRequireAssistiveTouch
            KioskModeRequireColorInversion = $getValue.AdditionalProperties.kioskModeRequireColorInversion
            KioskModeRequireMonoAudio = $getValue.AdditionalProperties.kioskModeRequireMonoAudio
            KioskModeRequireVoiceOver = $getValue.AdditionalProperties.kioskModeRequireVoiceOver
            KioskModeRequireZoom = $getValue.AdditionalProperties.kioskModeRequireZoom
            LockScreenBlockControlCenter = $getValue.AdditionalProperties.lockScreenBlockControlCenter
            LockScreenBlockNotificationView = $getValue.AdditionalProperties.lockScreenBlockNotificationView
            LockScreenBlockPassbook = $getValue.AdditionalProperties.lockScreenBlockPassbook
            LockScreenBlockTodayView = $getValue.AdditionalProperties.lockScreenBlockTodayView
            ManagedPasteboardRequired = $getValue.AdditionalProperties.managedPasteboardRequired
            MediaContentRatingApps = $getValue.AdditionalProperties.mediaContentRatingApps
            MessagesBlocked = $getValue.AdditionalProperties.messagesBlocked
            NfcBlocked = $getValue.AdditionalProperties.nfcBlocked
            NotificationsBlockSettingsModification = $getValue.AdditionalProperties.notificationsBlockSettingsModification
            OnDeviceOnlyDictationForced = $getValue.AdditionalProperties.onDeviceOnlyDictationForced
            OnDeviceOnlyTranslationForced = $getValue.AdditionalProperties.onDeviceOnlyTranslationForced
            PasscodeBlockFingerprintModification = $getValue.AdditionalProperties.passcodeBlockFingerprintModification
            PasscodeBlockFingerprintUnlock = $getValue.AdditionalProperties.passcodeBlockFingerprintUnlock
            PasscodeBlockModification = $getValue.AdditionalProperties.passcodeBlockModification
            PasscodeBlockSimple = $getValue.AdditionalProperties.passcodeBlockSimple
            PasscodeExpirationDays = $getValue.AdditionalProperties.passcodeExpirationDays
            PasscodeMinimumCharacterSetCount = $getValue.AdditionalProperties.passcodeMinimumCharacterSetCount
            PasscodeMinimumLength = $getValue.AdditionalProperties.passcodeMinimumLength
            PasscodeMinutesOfInactivityBeforeLock = $getValue.AdditionalProperties.passcodeMinutesOfInactivityBeforeLock
            PasscodeMinutesOfInactivityBeforeScreenTimeout = $getValue.AdditionalProperties.passcodeMinutesOfInactivityBeforeScreenTimeout
            PasscodePreviousPasscodeBlockCount = $getValue.AdditionalProperties.passcodePreviousPasscodeBlockCount
            PasscodeRequired = $getValue.AdditionalProperties.passcodeRequired
            PasscodeRequiredType = $getValue.AdditionalProperties.passcodeRequiredType
            PasscodeSignInFailureCountBeforeWipe = $getValue.AdditionalProperties.passcodeSignInFailureCountBeforeWipe
            PasswordBlockAirDropSharing = $getValue.AdditionalProperties.passwordBlockAirDropSharing
            PasswordBlockAutoFill = $getValue.AdditionalProperties.passwordBlockAutoFill
            PasswordBlockProximityRequests = $getValue.AdditionalProperties.passwordBlockProximityRequests
            PkiBlockOTAUpdates = $getValue.AdditionalProperties.pkiBlockOTAUpdates
            PodcastsBlocked = $getValue.AdditionalProperties.podcastsBlocked
            PrivacyForceLimitAdTracking = $getValue.AdditionalProperties.privacyForceLimitAdTracking
            ProximityBlockSetupToNewDevice = $getValue.AdditionalProperties.proximityBlockSetupToNewDevice
            SafariBlockAutofill = $getValue.AdditionalProperties.safariBlockAutofill
            SafariBlocked = $getValue.AdditionalProperties.safariBlocked
            SafariBlockJavaScript = $getValue.AdditionalProperties.safariBlockJavaScript
            SafariBlockPopups = $getValue.AdditionalProperties.safariBlockPopups
            SafariCookieSettings = $getValue.AdditionalProperties.safariCookieSettings
            SafariManagedDomains = $getValue.AdditionalProperties.safariManagedDomains
            SafariPasswordAutoFillDomains = $getValue.AdditionalProperties.safariPasswordAutoFillDomains
            SafariRequireFraudWarning = $getValue.AdditionalProperties.safariRequireFraudWarning
            ScreenCaptureBlocked = $getValue.AdditionalProperties.screenCaptureBlocked
            SharedDeviceBlockTemporarySessions = $getValue.AdditionalProperties.sharedDeviceBlockTemporarySessions
            SiriBlocked = $getValue.AdditionalProperties.siriBlocked
            SiriBlockedWhenLocked = $getValue.AdditionalProperties.siriBlockedWhenLocked
            SiriBlockUserGeneratedContent = $getValue.AdditionalProperties.siriBlockUserGeneratedContent
            SiriRequireProfanityFilter = $getValue.AdditionalProperties.siriRequireProfanityFilter
            SoftwareUpdatesEnforcedDelayInDays = $getValue.AdditionalProperties.softwareUpdatesEnforcedDelayInDays
            SoftwareUpdatesForceDelayed = $getValue.AdditionalProperties.softwareUpdatesForceDelayed
            SpotlightBlockInternetResults = $getValue.AdditionalProperties.spotlightBlockInternetResults
            UnpairedExternalBootToRecoveryAllowed = $getValue.AdditionalProperties.unpairedExternalBootToRecoveryAllowed
            UsbRestrictedModeBlocked = $getValue.AdditionalProperties.usbRestrictedModeBlocked
            VoiceDialingBlocked = $getValue.AdditionalProperties.voiceDialingBlocked
            VpnBlockCreation = $getValue.AdditionalProperties.vpnBlockCreation
            WallpaperBlockModification = $getValue.AdditionalProperties.wallpaperBlockModification
            WiFiConnectOnlyToConfiguredNetworks = $getValue.AdditionalProperties.wiFiConnectOnlyToConfiguredNetworks
            WiFiConnectToAllowedNetworksOnlyForced = $getValue.AdditionalProperties.wiFiConnectToAllowedNetworksOnlyForced
            WifiPowerOnForced = $getValue.AdditionalProperties.wifiPowerOnForced
            Managedidentity= $ManagedIdentity.IsPresent

            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
        }
        if ($getValue.additionalProperties.appsSingleAppModeList)
        {
            $results.Add("AppsSingleAppModeList", $getValue.additionalProperties.appsSingleAppModeList)
        }
        if ($getValue.additionalProperties.appsVisibilityList)
        {
            $results.Add("AppsVisibilityList", $getValue.additionalProperties.appsVisibilityList)
        }
        if ($getValue.additionalProperties.compliantAppsList)
        {
            $results.Add("CompliantAppsList", $getValue.additionalProperties.compliantAppsList)
        }
        if ($getValue.additionalProperties.mediaContentRatingAustralia)
        {
            $results.Add("MediaContentRatingAustralia", $getValue.additionalProperties.mediaContentRatingAustralia)
        }
        if ($getValue.additionalProperties.mediaContentRatingCanada)
        {
            $results.Add("MediaContentRatingCanada", $getValue.additionalProperties.mediaContentRatingCanada)
        }
        if ($getValue.additionalProperties.mediaContentRatingFrance)
        {
            $results.Add("MediaContentRatingFrance", $getValue.additionalProperties.mediaContentRatingFrance)
        }
        if ($getValue.additionalProperties.mediaContentRatingGermany)
        {
            $results.Add("MediaContentRatingGermany", $getValue.additionalProperties.mediaContentRatingGermany)
        }
        if ($getValue.additionalProperties.mediaContentRatingIreland)
        {
            $results.Add("MediaContentRatingIreland", $getValue.additionalProperties.mediaContentRatingIreland)
        }
        if ($getValue.additionalProperties.mediaContentRatingJapan)
        {
            $results.Add("MediaContentRatingJapan", $getValue.additionalProperties.mediaContentRatingJapan)
        }
        if ($getValue.additionalProperties.mediaContentRatingNewZealand)
        {
            $results.Add("MediaContentRatingNewZealand", $getValue.additionalProperties.mediaContentRatingNewZealand)
        }
        if ($getValue.additionalProperties.mediaContentRatingUnitedKingdom)
        {
            $results.Add("MediaContentRatingUnitedKingdom", $getValue.additionalProperties.mediaContentRatingUnitedKingdom)
        }
        if ($getValue.additionalProperties.mediaContentRatingUnitedStates)
        {
            $results.Add("MediaContentRatingUnitedStates", $getValue.additionalProperties.mediaContentRatingUnitedStates)
        }
        if ($getValue.additionalProperties.networkUsageRules)
        {
            $results.Add("NetworkUsageRules", $getValue.additionalProperties.networkUsageRules)
        }

        $returnAssignments=@()
        $returnAssignments+=Get-MgDeviceManagementDeviceConfigurationAssignment -DeviceConfigurationId $getValue.Id
        $assignmentResult = @()
        foreach ($assignmentEntry in $returnAssignments)
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
        $AirPrintBlockCredentialsStorage,

        [Parameter()]
        [System.Boolean]
        $AirPrintBlocked,

        [Parameter()]
        [System.Boolean]
        $AirPrintBlockiBeaconDiscovery,

        [Parameter()]
        [System.Boolean]
        $AirPrintForceTrustedTLS,

        [Parameter()]
        [System.Boolean]
        $AppClipsBlocked,

        [Parameter()]
        [System.Boolean]
        $AppleNewsBlocked,

        [Parameter()]
        [System.Boolean]
        $ApplePersonalizedAdsBlocked,

        [Parameter()]
        [System.Boolean]
        $AppleWatchBlockPairing,

        [Parameter()]
        [System.Boolean]
        $AppleWatchForceWristDetection,

        [Parameter()]
        [System.Boolean]
        $AppRemovalBlocked,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AppsSingleAppModeList,

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
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AppsVisibilityList,

        [Parameter()]
        [ValidateSet('none','appsInListCompliant','appsNotInListCompliant')]
        [System.String]
        $AppsVisibilityListType,

        [Parameter()]
        [System.Boolean]
        $AutoFillForceAuthentication,

        [Parameter()]
        [System.Boolean]
        $AutoUnlockBlocked,

        [Parameter()]
        [System.Boolean]
        $BlockSystemAppRemoval,

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
        $CellularBlockPersonalHotspotModification,

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
        $ClassroomForceRequestPermissionToLeaveClasses,

        [Parameter()]
        [System.Boolean]
        $ClassroomForceUnpromptedAppAndDeviceLock,

        [Parameter()]
        [ValidateSet('none','appsInListCompliant','appsNotInListCompliant')]
        [System.String]
        $CompliantAppListType,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CompliantAppsList,

        [Parameter()]
        [System.Boolean]
        $ConfigurationProfileBlockChanges,

        [Parameter()]
        [System.Boolean]
        $ContactsAllowManagedToUnmanagedWrite,

        [Parameter()]
        [System.Boolean]
        $ContactsAllowUnmanagedToManagedRead,

        [Parameter()]
        [System.Boolean]
        $ContinuousPathKeyboardBlocked,

        [Parameter()]
        [System.Boolean]
        $DateAndTimeForceSetAutomatically,

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
        $EnterpriseBookBlockBackup,

        [Parameter()]
        [System.Boolean]
        $EnterpriseBookBlockMetadataSync,

        [Parameter()]
        [System.Boolean]
        $EsimBlockModification,

        [Parameter()]
        [System.Boolean]
        $FaceTimeBlocked,

        [Parameter()]
        [System.Boolean]
        $FilesNetworkDriveAccessBlocked,

        [Parameter()]
        [System.Boolean]
        $FilesUsbDriveAccessBlocked,

        [Parameter()]
        [System.Boolean]
        $FindMyDeviceInFindMyAppBlocked,

        [Parameter()]
        [System.Boolean]
        $FindMyFriendsBlocked,

        [Parameter()]
        [System.Boolean]
        $FindMyFriendsInFindMyAppBlocked,

        [Parameter()]
        [System.Boolean]
        $GameCenterBlocked,

        [Parameter()]
        [System.Boolean]
        $GamingBlockGameCenterFriends,

        [Parameter()]
        [System.Boolean]
        $GamingBlockMultiplayer,

        [Parameter()]
        [System.Boolean]
        $HostPairingBlocked,

        [Parameter()]
        [System.Boolean]
        $IBooksStoreBlocked,

        [Parameter()]
        [System.Boolean]
        $IBooksStoreBlockErotica,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockActivityContinuation,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockBackup,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockDocumentSync,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockManagedAppsSync,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockPhotoLibrary,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockPhotoStreamSync,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockSharedPhotoStream,

        [Parameter()]
        [System.Boolean]
        $ICloudPrivateRelayBlocked,

        [Parameter()]
        [System.Boolean]
        $ICloudRequireEncryptedBackup,

        [Parameter()]
        [System.Boolean]
        $ITunesBlocked,

        [Parameter()]
        [System.Boolean]
        $ITunesBlockExplicitContent,

        [Parameter()]
        [System.Boolean]
        $ITunesBlockMusicService,

        [Parameter()]
        [System.Boolean]
        $ITunesBlockRadio,

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
        $KeychainBlockCloudSync,

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
        $KioskModeAllowColorInversionSettings,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowRingerSwitch,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowScreenRotation,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowSleepButton,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowTouchscreen,

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
        $KioskModeAllowZoomSettings,

        [Parameter()]
        [System.String]
        $KioskModeAppStoreUrl,

        [Parameter()]
        [ValidateSet('notConfigured','appStoreApp','managedApp','builtInApp')]
        [System.String]
        $KioskModeAppType,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockAutoLock,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockRingerSwitch,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockScreenRotation,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockSleepButton,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockTouchscreen,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockVolumeButtons,

        [Parameter()]
        [System.String]
        $KioskModeBuiltInAppId,

        [Parameter()]
        [System.Boolean]
        $KioskModeEnableVoiceControl,

        [Parameter()]
        [System.String]
        $KioskModeManagedAppId,

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
        [System.Boolean]
        $ManagedPasteboardRequired,

        [Parameter()]
        [ValidateSet('allAllowed','allBlocked','agesAbove4','agesAbove9','agesAbove12','agesAbove17')]
        [System.String]
        $MediaContentRatingApps,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MediaContentRatingAustralia,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MediaContentRatingCanada,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MediaContentRatingFrance,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MediaContentRatingGermany,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MediaContentRatingIreland,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MediaContentRatingJapan,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MediaContentRatingNewZealand,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MediaContentRatingUnitedKingdom,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MediaContentRatingUnitedStates,

        [Parameter()]
        [System.Boolean]
        $MessagesBlocked,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $NetworkUsageRules,

        [Parameter()]
        [System.Boolean]
        $NfcBlocked,

        [Parameter()]
        [System.Boolean]
        $NotificationsBlockSettingsModification,

        [Parameter()]
        [System.Boolean]
        $OnDeviceOnlyDictationForced,

        [Parameter()]
        [System.Boolean]
        $OnDeviceOnlyTranslationForced,

        [Parameter()]
        [System.Boolean]
        $PasscodeBlockFingerprintModification,

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
        [System.Int32]
        $PasscodeExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasscodeMinimumCharacterSetCount,

        [Parameter()]
        [System.Int32]
        $PasscodeMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasscodeMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.Int32]
        $PasscodeMinutesOfInactivityBeforeScreenTimeout,

        [Parameter()]
        [System.Int32]
        $PasscodePreviousPasscodeBlockCount,

        [Parameter()]
        [System.Boolean]
        $PasscodeRequired,

        [Parameter()]
        [ValidateSet('deviceDefault','alphanumeric','numeric')]
        [System.String]
        $PasscodeRequiredType,

        [Parameter()]
        [System.Int32]
        $PasscodeSignInFailureCountBeforeWipe,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockAirDropSharing,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockAutoFill,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockProximityRequests,

        [Parameter()]
        [System.Boolean]
        $PkiBlockOTAUpdates,

        [Parameter()]
        [System.Boolean]
        $PodcastsBlocked,

        [Parameter()]
        [System.Boolean]
        $PrivacyForceLimitAdTracking,

        [Parameter()]
        [System.Boolean]
        $ProximityBlockSetupToNewDevice,

        [Parameter()]
        [System.Boolean]
        $SafariBlockAutofill,

        [Parameter()]
        [System.Boolean]
        $SafariBlocked,

        [Parameter()]
        [System.Boolean]
        $SafariBlockJavaScript,

        [Parameter()]
        [System.Boolean]
        $SafariBlockPopups,

        [Parameter()]
        [ValidateSet('browserDefault','blockAlways','allowCurrentWebSite','allowFromWebsitesVisited','allowAlways')]
        [System.String]
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
        $SharedDeviceBlockTemporarySessions,

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
        [System.Int32]
        $SoftwareUpdatesEnforcedDelayInDays,

        [Parameter()]
        [System.Boolean]
        $SoftwareUpdatesForceDelayed,

        [Parameter()]
        [System.Boolean]
        $SpotlightBlockInternetResults,

        [Parameter()]
        [System.Boolean]
        $UnpairedExternalBootToRecoveryAllowed,

        [Parameter()]
        [System.Boolean]
        $UsbRestrictedModeBlocked,

        [Parameter()]
        [System.Boolean]
        $VoiceDialingBlocked,

        [Parameter()]
        [System.Boolean]
        $VpnBlockCreation,

        [Parameter()]
        [System.Boolean]
        $WallpaperBlockModification,

        [Parameter()]
        [System.Boolean]
        $WiFiConnectOnlyToConfiguredNetworks,

        [Parameter()]
        [System.Boolean]
        $WiFiConnectToAllowedNetworksOnlyForced,

        [Parameter()]
        [System.Boolean]
        $WifiPowerOnForced,


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

        if($policy.id)
        {
            Update-DeviceConfigurationPolicyAssignments -DeviceConfigurationPolicyId $policy.id `
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
        Update-DeviceConfigurationPolicyAssignments -DeviceConfigurationPolicyId $currentInstance.id `
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
        $AirPrintBlockCredentialsStorage,

        [Parameter()]
        [System.Boolean]
        $AirPrintBlocked,

        [Parameter()]
        [System.Boolean]
        $AirPrintBlockiBeaconDiscovery,

        [Parameter()]
        [System.Boolean]
        $AirPrintForceTrustedTLS,

        [Parameter()]
        [System.Boolean]
        $AppClipsBlocked,

        [Parameter()]
        [System.Boolean]
        $AppleNewsBlocked,

        [Parameter()]
        [System.Boolean]
        $ApplePersonalizedAdsBlocked,

        [Parameter()]
        [System.Boolean]
        $AppleWatchBlockPairing,

        [Parameter()]
        [System.Boolean]
        $AppleWatchForceWristDetection,

        [Parameter()]
        [System.Boolean]
        $AppRemovalBlocked,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AppsSingleAppModeList,

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
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AppsVisibilityList,

        [Parameter()]
        [ValidateSet('none','appsInListCompliant','appsNotInListCompliant')]
        [System.String]
        $AppsVisibilityListType,

        [Parameter()]
        [System.Boolean]
        $AutoFillForceAuthentication,

        [Parameter()]
        [System.Boolean]
        $AutoUnlockBlocked,

        [Parameter()]
        [System.Boolean]
        $BlockSystemAppRemoval,

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
        $CellularBlockPersonalHotspotModification,

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
        $ClassroomForceRequestPermissionToLeaveClasses,

        [Parameter()]
        [System.Boolean]
        $ClassroomForceUnpromptedAppAndDeviceLock,

        [Parameter()]
        [ValidateSet('none','appsInListCompliant','appsNotInListCompliant')]
        [System.String]
        $CompliantAppListType,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CompliantAppsList,

        [Parameter()]
        [System.Boolean]
        $ConfigurationProfileBlockChanges,

        [Parameter()]
        [System.Boolean]
        $ContactsAllowManagedToUnmanagedWrite,

        [Parameter()]
        [System.Boolean]
        $ContactsAllowUnmanagedToManagedRead,

        [Parameter()]
        [System.Boolean]
        $ContinuousPathKeyboardBlocked,

        [Parameter()]
        [System.Boolean]
        $DateAndTimeForceSetAutomatically,

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
        $EnterpriseBookBlockBackup,

        [Parameter()]
        [System.Boolean]
        $EnterpriseBookBlockMetadataSync,

        [Parameter()]
        [System.Boolean]
        $EsimBlockModification,

        [Parameter()]
        [System.Boolean]
        $FaceTimeBlocked,

        [Parameter()]
        [System.Boolean]
        $FilesNetworkDriveAccessBlocked,

        [Parameter()]
        [System.Boolean]
        $FilesUsbDriveAccessBlocked,

        [Parameter()]
        [System.Boolean]
        $FindMyDeviceInFindMyAppBlocked,

        [Parameter()]
        [System.Boolean]
        $FindMyFriendsBlocked,

        [Parameter()]
        [System.Boolean]
        $FindMyFriendsInFindMyAppBlocked,

        [Parameter()]
        [System.Boolean]
        $GameCenterBlocked,

        [Parameter()]
        [System.Boolean]
        $GamingBlockGameCenterFriends,

        [Parameter()]
        [System.Boolean]
        $GamingBlockMultiplayer,

        [Parameter()]
        [System.Boolean]
        $HostPairingBlocked,

        [Parameter()]
        [System.Boolean]
        $IBooksStoreBlocked,

        [Parameter()]
        [System.Boolean]
        $IBooksStoreBlockErotica,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockActivityContinuation,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockBackup,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockDocumentSync,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockManagedAppsSync,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockPhotoLibrary,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockPhotoStreamSync,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockSharedPhotoStream,

        [Parameter()]
        [System.Boolean]
        $ICloudPrivateRelayBlocked,

        [Parameter()]
        [System.Boolean]
        $ICloudRequireEncryptedBackup,

        [Parameter()]
        [System.Boolean]
        $ITunesBlocked,

        [Parameter()]
        [System.Boolean]
        $ITunesBlockExplicitContent,

        [Parameter()]
        [System.Boolean]
        $ITunesBlockMusicService,

        [Parameter()]
        [System.Boolean]
        $ITunesBlockRadio,

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
        $KeychainBlockCloudSync,

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
        $KioskModeAllowColorInversionSettings,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowRingerSwitch,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowScreenRotation,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowSleepButton,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowTouchscreen,

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
        $KioskModeAllowZoomSettings,

        [Parameter()]
        [System.String]
        $KioskModeAppStoreUrl,

        [Parameter()]
        [ValidateSet('notConfigured','appStoreApp','managedApp','builtInApp')]
        [System.String]
        $KioskModeAppType,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockAutoLock,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockRingerSwitch,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockScreenRotation,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockSleepButton,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockTouchscreen,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockVolumeButtons,

        [Parameter()]
        [System.String]
        $KioskModeBuiltInAppId,

        [Parameter()]
        [System.Boolean]
        $KioskModeEnableVoiceControl,

        [Parameter()]
        [System.String]
        $KioskModeManagedAppId,

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
        [System.Boolean]
        $ManagedPasteboardRequired,

        [Parameter()]
        [ValidateSet('allAllowed','allBlocked','agesAbove4','agesAbove9','agesAbove12','agesAbove17')]
        [System.String]
        $MediaContentRatingApps,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MediaContentRatingAustralia,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MediaContentRatingCanada,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MediaContentRatingFrance,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MediaContentRatingGermany,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MediaContentRatingIreland,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MediaContentRatingJapan,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MediaContentRatingNewZealand,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MediaContentRatingUnitedKingdom,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MediaContentRatingUnitedStates,

        [Parameter()]
        [System.Boolean]
        $MessagesBlocked,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $NetworkUsageRules,

        [Parameter()]
        [System.Boolean]
        $NfcBlocked,

        [Parameter()]
        [System.Boolean]
        $NotificationsBlockSettingsModification,

        [Parameter()]
        [System.Boolean]
        $OnDeviceOnlyDictationForced,

        [Parameter()]
        [System.Boolean]
        $OnDeviceOnlyTranslationForced,

        [Parameter()]
        [System.Boolean]
        $PasscodeBlockFingerprintModification,

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
        [System.Int32]
        $PasscodeExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasscodeMinimumCharacterSetCount,

        [Parameter()]
        [System.Int32]
        $PasscodeMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasscodeMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.Int32]
        $PasscodeMinutesOfInactivityBeforeScreenTimeout,

        [Parameter()]
        [System.Int32]
        $PasscodePreviousPasscodeBlockCount,

        [Parameter()]
        [System.Boolean]
        $PasscodeRequired,

        [Parameter()]
        [ValidateSet('deviceDefault','alphanumeric','numeric')]
        [System.String]
        $PasscodeRequiredType,

        [Parameter()]
        [System.Int32]
        $PasscodeSignInFailureCountBeforeWipe,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockAirDropSharing,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockAutoFill,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockProximityRequests,

        [Parameter()]
        [System.Boolean]
        $PkiBlockOTAUpdates,

        [Parameter()]
        [System.Boolean]
        $PodcastsBlocked,

        [Parameter()]
        [System.Boolean]
        $PrivacyForceLimitAdTracking,

        [Parameter()]
        [System.Boolean]
        $ProximityBlockSetupToNewDevice,

        [Parameter()]
        [System.Boolean]
        $SafariBlockAutofill,

        [Parameter()]
        [System.Boolean]
        $SafariBlocked,

        [Parameter()]
        [System.Boolean]
        $SafariBlockJavaScript,

        [Parameter()]
        [System.Boolean]
        $SafariBlockPopups,

        [Parameter()]
        [ValidateSet('browserDefault','blockAlways','allowCurrentWebSite','allowFromWebsitesVisited','allowAlways')]
        [System.String]
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
        $SharedDeviceBlockTemporarySessions,

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
        [System.Int32]
        $SoftwareUpdatesEnforcedDelayInDays,

        [Parameter()]
        [System.Boolean]
        $SoftwareUpdatesForceDelayed,

        [Parameter()]
        [System.Boolean]
        $SpotlightBlockInternetResults,

        [Parameter()]
        [System.Boolean]
        $UnpairedExternalBootToRecoveryAllowed,

        [Parameter()]
        [System.Boolean]
        $UsbRestrictedModeBlocked,

        [Parameter()]
        [System.Boolean]
        $VoiceDialingBlocked,

        [Parameter()]
        [System.Boolean]
        $VpnBlockCreation,

        [Parameter()]
        [System.Boolean]
        $WallpaperBlockModification,

        [Parameter()]
        [System.Boolean]
        $WiFiConnectOnlyToConfiguredNetworks,

        [Parameter()]
        [System.Boolean]
        $WiFiConnectToAllowedNetworksOnlyForced,

        [Parameter()]
        [System.Boolean]
        $WifiPowerOnForced,


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
            -ErrorAction Stop -All:$true | Where-Object `
            -FilterScript { `
                $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.iosGeneralDeviceConfiguration'  `
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
                id           = $config.id
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

        if ($Results.AppsSingleAppModeList)
        {
            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.AppsSingleAppModeList -CIMInstanceName MicrosoftGraphapplistitem
            if ($complexTypeStringResult)
            {
                $Results.AppsSingleAppModeList = $complexTypeStringResult
            }
            else
            {
                $Results.Remove('AppsSingleAppModeList') | Out-Null
            }
        }
        if ($Results.AppsVisibilityList)
        {
            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.AppsVisibilityList -CIMInstanceName MicrosoftGraphapplistitem
            if ($complexTypeStringResult)
            {
                $Results.AppsVisibilityList = $complexTypeStringResult            }
            else
            {
                $Results.Remove('AppsVisibilityList') | Out-Null
            }
        }
        if ($Results.CompliantAppsList)
        {
            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.CompliantAppsList -CIMInstanceName MicrosoftGraphapplistitem
            if ($complexTypeStringResult)
            {
                $Results.CompliantAppsList = $complexTypeStringResult            }
            else
            {
                $Results.Remove('CompliantAppsList') | Out-Null
            }
        }
        if ($Results.MediaContentRatingAustralia)
        {
            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.MediaContentRatingAustralia -CIMInstanceName MicrosoftGraphmediacontentratingaustralia
            if ($complexTypeStringResult)
            {
                $Results.MediaContentRatingAustralia = $complexTypeStringResult            }
            else
            {
                $Results.Remove('MediaContentRatingAustralia') | Out-Null
            }
        }
        if ($Results.MediaContentRatingCanada)
        {
            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.MediaContentRatingCanada -CIMInstanceName MicrosoftGraphmediacontentratingcanada
            if ($complexTypeStringResult)
            {
                $Results.MediaContentRatingCanada = $complexTypeStringResult            }
            else
            {
                $Results.Remove('MediaContentRatingCanada') | Out-Null
            }
        }
        if ($Results.MediaContentRatingFrance)
        {
            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.MediaContentRatingFrance -CIMInstanceName MicrosoftGraphmediacontentratingfrance
            if ($complexTypeStringResult)
            {
                $Results.MediaContentRatingFrance = $complexTypeStringResult            }
            else
            {
                $Results.Remove('MediaContentRatingFrance') | Out-Null
            }
        }
        if ($Results.MediaContentRatingGermany)
        {
            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.MediaContentRatingGermany -CIMInstanceName MicrosoftGraphmediacontentratinggermany
            if ($complexTypeStringResult)
            {
                $Results.MediaContentRatingGermany = $complexTypeStringResult            }
            else
            {
                $Results.Remove('MediaContentRatingGermany') | Out-Null
            }
        }
        if ($Results.MediaContentRatingIreland)
        {
            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.MediaContentRatingIreland -CIMInstanceName MicrosoftGraphmediacontentratingireland
            if ($complexTypeStringResult)
            {
                $Results.MediaContentRatingIreland = $complexTypeStringResult            }
            else
            {
                $Results.Remove('MediaContentRatingIreland') | Out-Null
            }
        }
        if ($Results.MediaContentRatingJapan)
        {
            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.MediaContentRatingJapan -CIMInstanceName MicrosoftGraphmediacontentratingjapan
            if ($complexTypeStringResult)
            {
                $Results.MediaContentRatingJapan = $complexTypeStringResult            }
            else
            {
                $Results.Remove('MediaContentRatingJapan') | Out-Null
            }
        }
        if ($Results.MediaContentRatingNewZealand)
        {
            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.MediaContentRatingNewZealand -CIMInstanceName MicrosoftGraphmediacontentratingnewzealand
            if ($complexTypeStringResult)
            {
                $Results.MediaContentRatingNewZealand = $complexTypeStringResult            }
            else
            {
                $Results.Remove('MediaContentRatingNewZealand') | Out-Null
            }
        }
        if ($Results.MediaContentRatingUnitedKingdom)
        {
            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.MediaContentRatingUnitedKingdom -CIMInstanceName MicrosoftGraphmediacontentratingunitedkingdom
            if ($complexTypeStringResult)
            {
                $Results.MediaContentRatingUnitedKingdom = $complexTypeStringResult            }
            else
            {
                $Results.Remove('MediaContentRatingUnitedKingdom') | Out-Null
            }
        }
        if ($Results.MediaContentRatingUnitedStates)
        {
            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.MediaContentRatingUnitedStates -CIMInstanceName MicrosoftGraphmediacontentratingunitedstates
            if ($complexTypeStringResult)
            {
                $Results.MediaContentRatingUnitedStates = $complexTypeStringResult            }
            else
            {
                $Results.Remove('MediaContentRatingUnitedStates') | Out-Null
            }
        }
        if ($Results.NetworkUsageRules)
        {
            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.NetworkUsageRules -CIMInstanceName MicrosoftGraphiosnetworkusagerule
            if ($complexTypeStringResult)
            {
                $Results.NetworkUsageRules = $complexTypeStringResult            }
            else
            {
                $Results.Remove('NetworkUsageRules') | Out-Null
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

            if ($null -ne $Results.MediaContentRatingAustralia)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "MediaContentRatingAustralia"
            }
            if ($null -ne $Results.MediaContentRatingCanada)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "MediaContentRatingCanada"
            }
            if ($null -ne $Results.MediaContentRatingFrance)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "MediaContentRatingFrance"
            }
            if ($null -ne $Results.MediaContentRatingGermany)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "MediaContentRatingGermany"
            }
            if ($null -ne $Results.MediaContentRatingIreland)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "MediaContentRatingIreland"
            }
            if ($null -ne $Results.MediaContentRatingJapan)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "MediaContentRatingJapan"
            }
            if ($null -ne $Results.MediaContentRatingNewZealand)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "MediaContentRatingNewZealand"
            }
            if ($null -ne $Results.MediaContentRatingUnitedKingdom)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "MediaContentRatingUnitedKingdom"
            }
            if ($null -ne $Results.MediaContentRatingUnitedStates)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "MediaContentRatingUnitedStates"
            }
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
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
        return ''
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
        "AccountBlockModification"
        "ActivationLockAllowWhenSupervised"
        "AirDropBlocked"
        "AirDropForceUnmanagedDropTarget"
        "AirPlayForcePairingPasswordForOutgoingRequests"
        "AirPrintBlockCredentialsStorage"
        "AirPrintBlocked"
        "AirPrintBlockiBeaconDiscovery"
        "AirPrintForceTrustedTLS"
        "AppClipsBlocked"
        "AppleNewsBlocked"
        "ApplePersonalizedAdsBlocked"
        "AppleWatchBlockPairing"
        "AppleWatchForceWristDetection"
        "AppRemovalBlocked"
        "AppsSingleAppModeList"
        "AppStoreBlockAutomaticDownloads"
        "AppStoreBlocked"
        "AppStoreBlockInAppPurchases"
        "AppStoreBlockUIAppInstallation"
        "AppStoreRequirePassword"
        "AppsVisibilityList"
        "AppsVisibilityListType"
        "AutoFillForceAuthentication"
        "AutoUnlockBlocked"
        "BlockSystemAppRemoval"
        "BluetoothBlockModification"
        "CameraBlocked"
        "CellularBlockDataRoaming"
        "CellularBlockGlobalBackgroundFetchWhileRoaming"
        "CellularBlockPerAppDataModification"
        "CellularBlockPersonalHotspot"
        "CellularBlockPersonalHotspotModification"
        "CellularBlockPlanModification"
        "CellularBlockVoiceRoaming"
        "CertificatesBlockUntrustedTlsCertificates"
        "ClassroomAppBlockRemoteScreenObservation"
        "ClassroomAppForceUnpromptedScreenObservation"
        "ClassroomForceAutomaticallyJoinClasses"
        "ClassroomForceRequestPermissionToLeaveClasses"
        "ClassroomForceUnpromptedAppAndDeviceLock"
        "CompliantAppListType"
        "CompliantAppsList"
        "ConfigurationProfileBlockChanges"
        "ContactsAllowManagedToUnmanagedWrite"
        "ContactsAllowUnmanagedToManagedRead"
        "ContinuousPathKeyboardBlocked"
        "DateAndTimeForceSetAutomatically"
        "DefinitionLookupBlocked"
        "DeviceBlockEnableRestrictions"
        "DeviceBlockEraseContentAndSettings"
        "DeviceBlockNameModification"
        "DiagnosticDataBlockSubmission"
        "DiagnosticDataBlockSubmissionModification"
        "DocumentsBlockManagedDocumentsInUnmanagedApps"
        "DocumentsBlockUnmanagedDocumentsInManagedApps"
        "EmailInDomainSuffixes"
        "EnterpriseAppBlockTrust"
        "EnterpriseAppBlockTrustModification"
        "EnterpriseBookBlockBackup"
        "EnterpriseBookBlockMetadataSync"
        "EsimBlockModification"
        "FaceTimeBlocked"
        "FilesNetworkDriveAccessBlocked"
        "FilesUsbDriveAccessBlocked"
        "FindMyDeviceInFindMyAppBlocked"
        "FindMyFriendsBlocked"
        "FindMyFriendsInFindMyAppBlocked"
        "GameCenterBlocked"
        "GamingBlockGameCenterFriends"
        "GamingBlockMultiplayer"
        "HostPairingBlocked"
        "IBooksStoreBlocked"
        "IBooksStoreBlockErotica"
        "ICloudBlockActivityContinuation"
        "ICloudBlockBackup"
        "ICloudBlockDocumentSync"
        "ICloudBlockManagedAppsSync"
        "ICloudBlockPhotoLibrary"
        "ICloudBlockPhotoStreamSync"
        "ICloudBlockSharedPhotoStream"
        "ICloudPrivateRelayBlocked"
        "ICloudRequireEncryptedBackup"
        "ITunesBlocked"
        "ITunesBlockExplicitContent"
        "ITunesBlockMusicService"
        "ITunesBlockRadio"
        "KeyboardBlockAutoCorrect"
        "KeyboardBlockDictation"
        "KeyboardBlockPredictive"
        "KeyboardBlockShortcuts"
        "KeyboardBlockSpellCheck"
        "KeychainBlockCloudSync"
        "KioskModeAllowAssistiveSpeak"
        "KioskModeAllowAssistiveTouchSettings"
        "KioskModeAllowAutoLock"
        "KioskModeAllowColorInversionSettings"
        "KioskModeAllowRingerSwitch"
        "KioskModeAllowScreenRotation"
        "KioskModeAllowSleepButton"
        "KioskModeAllowTouchscreen"
        "KioskModeAllowVoiceControlModification"
        "KioskModeAllowVoiceOverSettings"
        "KioskModeAllowVolumeButtons"
        "KioskModeAllowZoomSettings"
        "KioskModeAppStoreUrl"
        "KioskModeAppType"
        "KioskModeBlockAutoLock"
        "KioskModeBlockRingerSwitch"
        "KioskModeBlockScreenRotation"
        "KioskModeBlockSleepButton"
        "KioskModeBlockTouchscreen"
        "KioskModeBlockVolumeButtons"
        "KioskModeBuiltInAppId"
        "KioskModeEnableVoiceControl"
        "KioskModeManagedAppId"
        "KioskModeRequireAssistiveTouch"
        "KioskModeRequireColorInversion"
        "KioskModeRequireMonoAudio"
        "KioskModeRequireVoiceOver"
        "KioskModeRequireZoom"
        "LockScreenBlockControlCenter"
        "LockScreenBlockNotificationView"
        "LockScreenBlockPassbook"
        "LockScreenBlockTodayView"
        "ManagedPasteboardRequired"
        "MediaContentRatingApps"
        "MediaContentRatingAustralia"
        "MediaContentRatingCanada"
        "MediaContentRatingFrance"
        "MediaContentRatingGermany"
        "MediaContentRatingIreland"
        "MediaContentRatingJapan"
        "MediaContentRatingNewZealand"
        "MediaContentRatingUnitedKingdom"
        "MediaContentRatingUnitedStates"
        "MessagesBlocked"
        "NetworkUsageRules"
        "NfcBlocked"
        "NotificationsBlockSettingsModification"
        "OnDeviceOnlyDictationForced"
        "OnDeviceOnlyTranslationForced"
        "PasscodeBlockFingerprintModification"
        "PasscodeBlockFingerprintUnlock"
        "PasscodeBlockModification"
        "PasscodeBlockSimple"
        "PasscodeExpirationDays"
        "PasscodeMinimumCharacterSetCount"
        "PasscodeMinimumLength"
        "PasscodeMinutesOfInactivityBeforeLock"
        "PasscodeMinutesOfInactivityBeforeScreenTimeout"
        "PasscodePreviousPasscodeBlockCount"
        "PasscodeRequired"
        "PasscodeRequiredType"
        "PasscodeSignInFailureCountBeforeWipe"
        "PasswordBlockAirDropSharing"
        "PasswordBlockAutoFill"
        "PasswordBlockProximityRequests"
        "PkiBlockOTAUpdates"
        "PodcastsBlocked"
        "PrivacyForceLimitAdTracking"
        "ProximityBlockSetupToNewDevice"
        "SafariBlockAutofill"
        "SafariBlocked"
        "SafariBlockJavaScript"
        "SafariBlockPopups"
        "SafariCookieSettings"
        "SafariManagedDomains"
        "SafariPasswordAutoFillDomains"
        "SafariRequireFraudWarning"
        "ScreenCaptureBlocked"
        "SharedDeviceBlockTemporarySessions"
        "SiriBlocked"
        "SiriBlockedWhenLocked"
        "SiriBlockUserGeneratedContent"
        "SiriRequireProfanityFilter"
        "SoftwareUpdatesEnforcedDelayInDays"
        "SoftwareUpdatesForceDelayed"
        "SpotlightBlockInternetResults"
        "UnpairedExternalBootToRecoveryAllowed"
        "UsbRestrictedModeBlocked"
        "VoiceDialingBlocked"
        "VpnBlockCreation"
        "WallpaperBlockModification"
        "WiFiConnectOnlyToConfiguredNetworks"
        "WiFiConnectToAllowedNetworksOnlyForced"
        "WifiPowerOnForced"

    )
    $results = @{"@odata.type" = "#microsoft.graph.iosGeneralDeviceConfiguration" }
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

            $propertyValue = $properties.$property

            if ($propertyName -like 'MediaContentRating*' -and $propertyName -ne 'MediaContentRatingApps')
            {
                $countryName = $propertyName.Replace('MediaContentRating', '')
                $newValue = @{
                    '@odata.type' = "microsoft.graph.mediaContentRating$countryName"
                    tvRating      = $propertyValue.TVRating
                    movieRating   = $propertyValue.MovieRating
                }
                $propertyValue = $newValue
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
function Update-DeviceConfigurationPolicyAssignments
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [Parameter(Mandatory = 'true')]
        [System.String]
        $DeviceConfigurationPolicyId,
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

