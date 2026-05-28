Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneDeviceConfigurationPolicyiOS'

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
        [System.String[]]
        $RoleScopeTagIds,

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
        [ValidateSet('none', 'appsInListCompliant', 'appsNotInListCompliant')]
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
        [ValidateSet('none', 'appsInListCompliant', 'appsNotInListCompliant')]
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
        [ValidateSet('notConfigured', 'appStoreApp', 'managedApp', 'builtInApp')]
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
        [ValidateSet('allAllowed', 'allBlocked', 'agesAbove4', 'agesAbove9', 'agesAbove12', 'agesAbove17')]
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
        [ValidateSet('deviceDefault', 'alphanumeric', 'numeric')]
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
        $SafariBlockPopups,

        [Parameter()]
        [System.Boolean]
        $SafariBlockJavaScript,

        [Parameter()]
        [ValidateSet('browserDefault', 'blockAlways', 'allowCurrentWebSite', 'allowFromWebsitesVisited', 'allowAlways')]
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

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration of the Intune Device Configuration Policy for iOS with Id {$Id} and DisplayName {$DisplayName}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.DisplayName -ne $DisplayName)
        {
            $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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

            $nullResult = $PSBoundParameters
            $nullResult.Ensure = 'Absent'

            $getValue = $null
            #region resource generator code
            if (-not [string]::IsNullOrEmpty($Id))
            {
                $getValue = Get-MgBetaDeviceManagementDeviceConfiguration -All -Filter "Id eq '$Id'" -ErrorAction SilentlyContinue
            }

            if (-not $getValue)
            {
                $getValue = Get-MgBetaDeviceManagementDeviceConfiguration -All -Filter "DisplayName eq '$($Displayname -replace "'", "''")' and isof('microsoft.graph.iosGeneralDeviceConfiguration')" -ErrorAction SilentlyContinue
            }
            #endregion

            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Nothing with id {$id} was found"
                return $nullResult
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }

        Write-Verbose -Message "Found something with id {$id}"
        $results = @{
            #region resource generator code
            Id                                             = $getValue.Id
            Description                                    = $getValue.Description
            DisplayName                                    = $getValue.DisplayName
            RoleScopeTagIds                                = $getValue.RoleScopeTagIds
            AccountBlockModification                       = $getValue.accountBlockModification
            ActivationLockAllowWhenSupervised              = $getValue.activationLockAllowWhenSupervised
            AirDropBlocked                                 = $getValue.airDropBlocked
            AirDropForceUnmanagedDropTarget                = $getValue.airDropForceUnmanagedDropTarget
            AirPlayForcePairingPasswordForOutgoingRequests = $getValue.airPlayForcePairingPasswordForOutgoingRequests
            AirPrintBlockCredentialsStorage                = $getValue.airPrintBlockCredentialsStorage
            AirPrintBlocked                                = $getValue.airPrintBlocked
            AirPrintBlockiBeaconDiscovery                  = $getValue.airPrintBlockiBeaconDiscovery
            AirPrintForceTrustedTLS                        = $getValue.airPrintForceTrustedTLS
            AppClipsBlocked                                = $getValue.appClipsBlocked
            AppleNewsBlocked                               = $getValue.appleNewsBlocked
            ApplePersonalizedAdsBlocked                    = $getValue.applePersonalizedAdsBlocked
            AppleWatchBlockPairing                         = $getValue.appleWatchBlockPairing
            AppleWatchForceWristDetection                  = $getValue.appleWatchForceWristDetection
            AppRemovalBlocked                              = $getValue.appRemovalBlocked
            AppStoreBlockAutomaticDownloads                = $getValue.appStoreBlockAutomaticDownloads
            AppStoreBlocked                                = $getValue.appStoreBlocked
            AppStoreBlockInAppPurchases                    = $getValue.appStoreBlockInAppPurchases
            AppStoreBlockUIAppInstallation                 = $getValue.appStoreBlockUIAppInstallation
            AppStoreRequirePassword                        = $getValue.appStoreRequirePassword
            AppsVisibilityListType                         = $getValue.appsVisibilityListType
            AutoFillForceAuthentication                    = $getValue.autoFillForceAuthentication
            AutoUnlockBlocked                              = $getValue.autoUnlockBlocked
            BlockSystemAppRemoval                          = $getValue.blockSystemAppRemoval
            BluetoothBlockModification                     = $getValue.bluetoothBlockModification
            CameraBlocked                                  = $getValue.cameraBlocked
            CellularBlockDataRoaming                       = $getValue.cellularBlockDataRoaming
            CellularBlockGlobalBackgroundFetchWhileRoaming = $getValue.cellularBlockGlobalBackgroundFetchWhileRoaming
            CellularBlockPerAppDataModification            = $getValue.cellularBlockPerAppDataModification
            CellularBlockPersonalHotspot                   = $getValue.cellularBlockPersonalHotspot
            CellularBlockPersonalHotspotModification       = $getValue.cellularBlockPersonalHotspotModification
            CellularBlockPlanModification                  = $getValue.cellularBlockPlanModification
            CellularBlockVoiceRoaming                      = $getValue.cellularBlockVoiceRoaming
            CertificatesBlockUntrustedTlsCertificates      = $getValue.certificatesBlockUntrustedTlsCertificates
            ClassroomAppBlockRemoteScreenObservation       = $getValue.classroomAppBlockRemoteScreenObservation
            ClassroomAppForceUnpromptedScreenObservation   = $getValue.classroomAppForceUnpromptedScreenObservation
            ClassroomForceAutomaticallyJoinClasses         = $getValue.classroomForceAutomaticallyJoinClasses
            ClassroomForceRequestPermissionToLeaveClasses  = $getValue.classroomForceRequestPermissionToLeaveClasses
            ClassroomForceUnpromptedAppAndDeviceLock       = $getValue.classroomForceUnpromptedAppAndDeviceLock
            CompliantAppListType                           = $getValue.compliantAppListType
            ConfigurationProfileBlockChanges               = $getValue.configurationProfileBlockChanges
            ContactsAllowManagedToUnmanagedWrite           = $getValue.contactsAllowManagedToUnmanagedWrite
            ContactsAllowUnmanagedToManagedRead            = $getValue.contactsAllowUnmanagedToManagedRead
            ContinuousPathKeyboardBlocked                  = $getValue.continuousPathKeyboardBlocked
            DateAndTimeForceSetAutomatically               = $getValue.dateAndTimeForceSetAutomatically
            DefinitionLookupBlocked                        = $getValue.definitionLookupBlocked
            DeviceBlockEnableRestrictions                  = $getValue.deviceBlockEnableRestrictions
            DeviceBlockEraseContentAndSettings             = $getValue.deviceBlockEraseContentAndSettings
            DeviceBlockNameModification                    = $getValue.deviceBlockNameModification
            DiagnosticDataBlockSubmission                  = $getValue.diagnosticDataBlockSubmission
            DiagnosticDataBlockSubmissionModification      = $getValue.diagnosticDataBlockSubmissionModification
            DocumentsBlockManagedDocumentsInUnmanagedApps  = $getValue.documentsBlockManagedDocumentsInUnmanagedApps
            DocumentsBlockUnmanagedDocumentsInManagedApps  = $getValue.documentsBlockUnmanagedDocumentsInManagedApps
            EmailInDomainSuffixes                          = $getValue.emailInDomainSuffixes
            EnterpriseAppBlockTrust                        = $getValue.enterpriseAppBlockTrust
            EnterpriseAppBlockTrustModification            = $getValue.enterpriseAppBlockTrustModification
            EnterpriseBookBlockBackup                      = $getValue.enterpriseBookBlockBackup
            EnterpriseBookBlockMetadataSync                = $getValue.enterpriseBookBlockMetadataSync
            EsimBlockModification                          = $getValue.esimBlockModification
            FaceTimeBlocked                                = $getValue.faceTimeBlocked
            FilesNetworkDriveAccessBlocked                 = $getValue.filesNetworkDriveAccessBlocked
            FilesUsbDriveAccessBlocked                     = $getValue.filesUsbDriveAccessBlocked
            FindMyDeviceInFindMyAppBlocked                 = $getValue.findMyDeviceInFindMyAppBlocked
            FindMyFriendsBlocked                           = $getValue.findMyFriendsBlocked
            FindMyFriendsInFindMyAppBlocked                = $getValue.findMyFriendsInFindMyAppBlocked
            GameCenterBlocked                              = $getValue.gameCenterBlocked
            GamingBlockGameCenterFriends                   = $getValue.gamingBlockGameCenterFriends
            GamingBlockMultiplayer                         = $getValue.gamingBlockMultiplayer
            HostPairingBlocked                             = $getValue.hostPairingBlocked
            IBooksStoreBlocked                             = $getValue.iBooksStoreBlocked
            IBooksStoreBlockErotica                        = $getValue.iBooksStoreBlockErotica
            ICloudBlockActivityContinuation                = $getValue.iCloudBlockActivityContinuation
            ICloudBlockBackup                              = $getValue.iCloudBlockBackup
            ICloudBlockDocumentSync                        = $getValue.iCloudBlockDocumentSync
            ICloudBlockManagedAppsSync                     = $getValue.iCloudBlockManagedAppsSync
            ICloudBlockPhotoLibrary                        = $getValue.iCloudBlockPhotoLibrary
            ICloudBlockPhotoStreamSync                     = $getValue.iCloudBlockPhotoStreamSync
            ICloudBlockSharedPhotoStream                   = $getValue.iCloudBlockSharedPhotoStream
            ICloudPrivateRelayBlocked                      = $getValue.iCloudPrivateRelayBlocked
            ICloudRequireEncryptedBackup                   = $getValue.iCloudRequireEncryptedBackup
            ITunesBlocked                                  = $getValue.iTunesBlocked
            ITunesBlockExplicitContent                     = $getValue.iTunesBlockExplicitContent
            ITunesBlockMusicService                        = $getValue.iTunesBlockMusicService
            ITunesBlockRadio                               = $getValue.iTunesBlockRadio
            KeyboardBlockAutoCorrect                       = $getValue.keyboardBlockAutoCorrect
            KeyboardBlockDictation                         = $getValue.keyboardBlockDictation
            KeyboardBlockPredictive                        = $getValue.keyboardBlockPredictive
            KeyboardBlockShortcuts                         = $getValue.keyboardBlockShortcuts
            KeyboardBlockSpellCheck                        = $getValue.keyboardBlockSpellCheck
            KeychainBlockCloudSync                         = $getValue.keychainBlockCloudSync
            KioskModeAllowAssistiveSpeak                   = $getValue.kioskModeAllowAssistiveSpeak
            KioskModeAllowAssistiveTouchSettings           = $getValue.kioskModeAllowAssistiveTouchSettings
            KioskModeAllowAutoLock                         = $getValue.kioskModeAllowAutoLock
            KioskModeAllowColorInversionSettings           = $getValue.kioskModeAllowColorInversionSettings
            KioskModeAllowRingerSwitch                     = $getValue.kioskModeAllowRingerSwitch
            KioskModeAllowScreenRotation                   = $getValue.kioskModeAllowScreenRotation
            KioskModeAllowSleepButton                      = $getValue.kioskModeAllowSleepButton
            KioskModeAllowTouchscreen                      = $getValue.kioskModeAllowTouchscreen
            KioskModeAllowVoiceControlModification         = $getValue.kioskModeAllowVoiceControlModification
            KioskModeAllowVoiceOverSettings                = $getValue.kioskModeAllowVoiceOverSettings
            KioskModeAllowVolumeButtons                    = $getValue.kioskModeAllowVolumeButtons
            KioskModeAllowZoomSettings                     = $getValue.kioskModeAllowZoomSettings
            KioskModeAppStoreUrl                           = $getValue.kioskModeAppStoreUrl
            KioskModeAppType                               = $getValue.kioskModeAppType
            KioskModeBlockAutoLock                         = $getValue.kioskModeBlockAutoLock
            KioskModeBlockRingerSwitch                     = $getValue.kioskModeBlockRingerSwitch
            KioskModeBlockScreenRotation                   = $getValue.kioskModeBlockScreenRotation
            KioskModeBlockSleepButton                      = $getValue.kioskModeBlockSleepButton
            KioskModeBlockTouchscreen                      = $getValue.kioskModeBlockTouchscreen
            KioskModeBlockVolumeButtons                    = $getValue.kioskModeBlockVolumeButtons
            KioskModeBuiltInAppId                          = $getValue.kioskModeBuiltInAppId
            KioskModeEnableVoiceControl                    = $getValue.kioskModeEnableVoiceControl
            KioskModeManagedAppId                          = $getValue.kioskModeManagedAppId
            KioskModeRequireAssistiveTouch                 = $getValue.kioskModeRequireAssistiveTouch
            KioskModeRequireColorInversion                 = $getValue.kioskModeRequireColorInversion
            KioskModeRequireMonoAudio                      = $getValue.kioskModeRequireMonoAudio
            KioskModeRequireVoiceOver                      = $getValue.kioskModeRequireVoiceOver
            KioskModeRequireZoom                           = $getValue.kioskModeRequireZoom
            LockScreenBlockControlCenter                   = $getValue.lockScreenBlockControlCenter
            LockScreenBlockNotificationView                = $getValue.lockScreenBlockNotificationView
            LockScreenBlockPassbook                        = $getValue.lockScreenBlockPassbook
            LockScreenBlockTodayView                       = $getValue.lockScreenBlockTodayView
            ManagedPasteboardRequired                      = $getValue.managedPasteboardRequired
            MediaContentRatingApps                         = $getValue.mediaContentRatingApps
            MessagesBlocked                                = $getValue.messagesBlocked
            NfcBlocked                                     = $getValue.nfcBlocked
            NotificationsBlockSettingsModification         = $getValue.notificationsBlockSettingsModification
            OnDeviceOnlyDictationForced                    = $getValue.onDeviceOnlyDictationForced
            OnDeviceOnlyTranslationForced                  = $getValue.onDeviceOnlyTranslationForced
            PasscodeBlockFingerprintModification           = $getValue.passcodeBlockFingerprintModification
            PasscodeBlockFingerprintUnlock                 = $getValue.passcodeBlockFingerprintUnlock
            PasscodeBlockModification                      = $getValue.passcodeBlockModification
            PasscodeBlockSimple                            = $getValue.passcodeBlockSimple
            PasscodeExpirationDays                         = $getValue.passcodeExpirationDays
            PasscodeMinimumCharacterSetCount               = $getValue.passcodeMinimumCharacterSetCount
            PasscodeMinimumLength                          = $getValue.passcodeMinimumLength
            PasscodeMinutesOfInactivityBeforeLock          = $getValue.passcodeMinutesOfInactivityBeforeLock
            PasscodeMinutesOfInactivityBeforeScreenTimeout = $getValue.passcodeMinutesOfInactivityBeforeScreenTimeout
            PasscodePreviousPasscodeBlockCount             = $getValue.passcodePreviousPasscodeBlockCount
            PasscodeRequired                               = $getValue.passcodeRequired
            PasscodeRequiredType                           = $getValue.passcodeRequiredType
            PasscodeSignInFailureCountBeforeWipe           = $getValue.passcodeSignInFailureCountBeforeWipe
            PasswordBlockAirDropSharing                    = $getValue.passwordBlockAirDropSharing
            PasswordBlockAutoFill                          = $getValue.passwordBlockAutoFill
            PasswordBlockProximityRequests                 = $getValue.passwordBlockProximityRequests
            PkiBlockOTAUpdates                             = $getValue.pkiBlockOTAUpdates
            PodcastsBlocked                                = $getValue.podcastsBlocked
            PrivacyForceLimitAdTracking                    = $getValue.privacyForceLimitAdTracking
            ProximityBlockSetupToNewDevice                 = $getValue.proximityBlockSetupToNewDevice
            SafariBlockAutofill                            = $getValue.safariBlockAutofill
            SafariBlocked                                  = $getValue.safariBlocked
            SafariBlockJavaScript                          = $getValue.safariBlockJavaScript
            SafariBlockPopups                              = $getValue.safariBlockPopups
            SafariCookieSettings                           = $getValue.safariCookieSettings
            SafariManagedDomains                           = $getValue.safariManagedDomains
            SafariPasswordAutoFillDomains                  = $getValue.safariPasswordAutoFillDomains
            SafariRequireFraudWarning                      = $getValue.safariRequireFraudWarning
            ScreenCaptureBlocked                           = $getValue.screenCaptureBlocked
            SharedDeviceBlockTemporarySessions             = $getValue.sharedDeviceBlockTemporarySessions
            SiriBlocked                                    = $getValue.siriBlocked
            SiriBlockedWhenLocked                          = $getValue.siriBlockedWhenLocked
            SiriBlockUserGeneratedContent                  = $getValue.siriBlockUserGeneratedContent
            SiriRequireProfanityFilter                     = $getValue.siriRequireProfanityFilter
            SoftwareUpdatesEnforcedDelayInDays             = $getValue.softwareUpdatesEnforcedDelayInDays
            SoftwareUpdatesForceDelayed                    = $getValue.softwareUpdatesForceDelayed
            SpotlightBlockInternetResults                  = $getValue.spotlightBlockInternetResults
            UnpairedExternalBootToRecoveryAllowed          = $getValue.unpairedExternalBootToRecoveryAllowed
            UsbRestrictedModeBlocked                       = $getValue.usbRestrictedModeBlocked
            VoiceDialingBlocked                            = $getValue.voiceDialingBlocked
            VpnBlockCreation                               = $getValue.vpnBlockCreation
            WallpaperBlockModification                     = $getValue.wallpaperBlockModification
            WiFiConnectOnlyToConfiguredNetworks            = $getValue.wiFiConnectOnlyToConfiguredNetworks
            WiFiConnectToAllowedNetworksOnlyForced         = $getValue.wiFiConnectToAllowedNetworksOnlyForced
            WifiPowerOnForced                              = $getValue.wifiPowerOnForced
            ManagedIdentity                                = $ManagedIdentity.IsPresent
            Ensure                                         = 'Present'
            Credential                                     = $Credential
            ApplicationId                                  = $ApplicationId
            TenantId                                       = $TenantId
            ApplicationSecret                              = $ApplicationSecret
            CertificateThumbprint                          = $CertificateThumbprint
            AccessTokens                                   = $AccessTokens
        }

        $complexAppsSingleAppModeList = @()
        $currentValueArray = $getValue.appsSingleAppModeList
        if ($null -ne $currentValueArray -and $currentValueArray.Count -gt 0)
        {
            foreach ($currentValue in $currentValueArray)
            {
                $currentHash = @{}
                $currentHash.Add('AppId', $currentValue.appId)
                $currentHash.Add('Publisher', $currentValue.publisher)
                $currentHash.Add('AppStoreUrl', $currentValue.appStoreUrl)
                $currentHash.Add('Name', $currentValue.name)
                $currentHash.Add('oDataType', $currentValue.'@odata.type')
                $complexAppsSingleAppModeList += $currentHash
            }
        }
        $results.Add('AppsSingleAppModeList', $complexAppsSingleAppModeList)

        $complexAppsVisibilityList = @()
        $currentValueArray = $getValue.appsVisibilityList
        if ($null -ne $currentValueArray -and $currentValueArray.Count -gt 0)
        {
            foreach ($currentValue in $currentValueArray)
            {
                $currentHash = @{}
                $currentHash.Add('AppId', $currentValue.appId)
                $currentHash.Add('Publisher', $currentValue.publisher)
                $currentHash.Add('AppStoreUrl', $currentValue.appStoreUrl)
                $currentHash.Add('Name', $currentValue.name)
                $currentHash.Add('oDataType', $currentValue.'@odata.type')
                $complexAppsVisibilityList += $currentHash
            }
        }
        $results.Add('AppsVisibilityList', $complexAppsVisibilityList)

        $complexCompliantAppsList = @()
        $currentValueArray = $getValue.compliantAppsList
        if ($null -ne $currentValueArray -and $currentValueArray.Count -gt 0)
        {
            foreach ($currentValue in $currentValueArray)
            {
                $currentHash = @{}
                $currentHash.Add('AppId', $currentValue.appId)
                $currentHash.Add('Publisher', $currentValue.publisher)
                $currentHash.Add('AppStoreUrl', $currentValue.appStoreUrl)
                $currentHash.Add('Name', $currentValue.name)
                $currentHash.Add('oDataType', $currentValue.'@odata.type')
                $complexCompliantAppsList += $currentHash
            }
        }
        $results.Add('CompliantAppsList', $complexCompliantAppsList)

        $ratingCountries = @(
            'Australia'
            'Canada'
            'France'
            'Germany'
            'Ireland'
            'Japan'
            'NewZealand'
            'UnitedKingdom'
            'UnitedStates'
        )
        foreach ($country in $ratingCountries)
        {
            $complexMediaContentRating = [ordered]@{}
            $currentValue = $getValue."mediaContentRating$country"
            if ($null -ne $currentValue)
            {
                $complexMediaContentRating.Add('MovieRating', $currentValue.movieRating.ToString())
                $complexMediaContentRating.Add('TvRating', $currentValue.tvRating.ToString())
            }
            $results.Add("MediaContentRating$country", $complexMediaContentRating)
        }
        <#$results.Add('MediaContentRatingCanada', $getValue.mediaContentRatingCanada)
        $results.Add('MediaContentRatingFrance', $getValue.mediaContentRatingFrance)
        $results.Add('MediaContentRatingGermany', $getValue.mediaContentRatingGermany)
        $results.Add('MediaContentRatingIreland', $getValue.mediaContentRatingIreland)
        $results.Add('MediaContentRatingJapan', $getValue.mediaContentRatingJapan)
        $results.Add('MediaContentRatingNewZealand', $getValue.mediaContentRatingNewZealand)
        $results.Add('MediaContentRatingUnitedKingdom', $getValue.mediaContentRatingUnitedKingdom)
        $results.Add('MediaContentRatingUnitedStates', $getValue.mediaContentRatingUnitedStates)#>

        $complexNetworkUsageRules = @()
        $currentValueArray = $getValue.networkUsageRules
        if ($null -ne $currentValueArray -and $currentValueArray.Count -gt 0)
        {
            foreach ($currentValue in $currentValueArray)
            {
                $currentValueHash = @{}
                $currentValueHash.Add('CellularDataBlocked', $currentValue.cellularDataBlocked)
                $currentValueHash.Add('CellularDataBlockWhenRoaming', $currentValue.cellularDataBlockWhenRoaming)
                $complexManagedApps = @()
                $currentValueChildArray = $currentValue.managedApps
                if ($null -ne $currentValueChildArray -and $currentValueChildArray.Count -gt 0)
                {
                    foreach ($currentChildValue in $currentValueChildArray)
                    {
                        $currentHash = @{}
                        $currentHash.Add('AppId', $currentValue.appId)
                        $currentHash.Add('Publisher', $currentValue.publisher)
                        $currentHash.Add('AppStoreUrl', $currentValue.appStoreUrl)
                        $currentHash.Add('Name', $currentValue.name)
                        $currentHash.Add('oDataType', $currentValue.'@odata.type')
                        $complexManagedApps += $currentHash
                    }
                }
                $currentValueHash.Add('ManagedApps', $complexManagedApps)
                $complexNetworkUsageRules += $currentValueHash
            }
        }
        $results.Add('NetworkUsageRules', $complexNetworkUsageRules)

        $assignmentsValues = Get-MgBetaDeviceManagementDeviceConfigurationAssignment -DeviceConfigurationId $getValue.Id
        $assignmentResult = @()
        if ($assignmentsValues.Count -gt 0)
        {
            $assignmentResult += ConvertFrom-IntunePolicyAssignment `
                -IncludeDeviceFilter:$true `
                -Assignments ($assignmentsValues)
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

        throw
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
        [System.String[]]
        $RoleScopeTagIds,

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
        [ValidateSet('none', 'appsInListCompliant', 'appsNotInListCompliant')]
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
        [ValidateSet('none', 'appsInListCompliant', 'appsNotInListCompliant')]
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
        [ValidateSet('notConfigured', 'appStoreApp', 'managedApp', 'builtInApp')]
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
        [ValidateSet('allAllowed', 'allBlocked', 'agesAbove4', 'agesAbove9', 'agesAbove12', 'agesAbove17')]
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
        [ValidateSet('deviceDefault', 'alphanumeric', 'numeric')]
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
        $SafariBlockPopups,

        [Parameter()]
        [System.Boolean]
        $SafariBlockJavaScript,

        [Parameter()]
        [ValidateSet('browserDefault', 'blockAlways', 'allowCurrentWebSite', 'allowFromWebsitesVisited', 'allowAlways')]
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

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Setting configuration of the Intune Device Configuration Policy iOS with Id {$Id} and DisplayName {$DisplayName}"

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

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating {$DisplayName}"
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $CreateParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
        $CreateParameters = Rename-M365DSCCimInstanceParameter -Properties $CreateParameters
        $CreateParameters.Remove('Id') | Out-Null
        $CreateParameters.Add('@odata.type', '#microsoft.graph.iosGeneralDeviceConfiguration')

        #region resource generator code
        $policy = New-MgBetaDeviceManagementDeviceConfiguration -BodyParameter $CreateParameters
        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments

        if ($policy.id)
        {
            Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $policy.id `
                -Targets $assignmentsHash `
                -Repository 'deviceManagement/deviceConfigurations'
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating {$DisplayName}"
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $UpdateParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
        $UpdateParameters = Rename-M365DSCCimInstanceParameter -Properties $UpdateParameters
        $UpdateParameters.Remove('Id') | Out-Null
        $UpdateParameters.Add('@odata.type', '#microsoft.graph.iosGeneralDeviceConfiguration')

        #region resource generator code
        Update-MgBetaDeviceManagementDeviceConfiguration -BodyParameter $UpdateParameters `
            -DeviceConfigurationId $currentInstance.Id
        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
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
        [System.String[]]
        $RoleScopeTagIds,

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
        [ValidateSet('none', 'appsInListCompliant', 'appsNotInListCompliant')]
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
        [ValidateSet('none', 'appsInListCompliant', 'appsNotInListCompliant')]
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
        [ValidateSet('notConfigured', 'appStoreApp', 'managedApp', 'builtInApp')]
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
        [ValidateSet('allAllowed', 'allBlocked', 'agesAbove4', 'agesAbove9', 'agesAbove12', 'agesAbove17')]
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
        [ValidateSet('deviceDefault', 'alphanumeric', 'numeric')]
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
        $SafariBlockPopups,

        [Parameter()]
        [System.Boolean]
        $SafariBlockJavaScript,

        [Parameter()]
        [ValidateSet('browserDefault', 'blockAlways', 'allowCurrentWebSite', 'allowFromWebsitesVisited', 'allowAlways')]
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

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '')
    return $result
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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
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
        $baseFilter = "isof('microsoft.graph.iosGeneralDeviceConfiguration')"
        if (-not [string]::IsNullOrEmpty($Filter))
        {
            $Filter = "($baseFilter) and ($Filter)"
        }
        else
        {
            $Filter = $baseFilter
        }
        [array]$getValue = Get-MgBetaDeviceManagementDeviceConfiguration -Filter $Filter -All -ErrorAction Stop
        #endregion

        $i = 1
        $dscContent = [System.Text.StringBuilder]::new()
        if ($getValue.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($config in $getValue)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $($config.displayName)" -DeferWrite
            $params = @{
                Id                    = $config.id
                DisplayName           = $config.DisplayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $config
            $Results = Get-TargetResource @Params

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
                    $Results.AppsVisibilityList = $complexTypeStringResult
                }
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
                    $Results.CompliantAppsList = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('CompliantAppsList') | Out-Null
                }
            }
            if ($Results.MediaContentRatingAustralia.Count -gt 0)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.MediaContentRatingAustralia -CIMInstanceName MicrosoftGraphmediacontentratingaustralia
                if ($complexTypeStringResult)
                {
                    $Results.MediaContentRatingAustralia = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('MediaContentRatingAustralia') | Out-Null
                }
            }
            else
            {
                $Results.Remove('MediaContentRatingAustralia') | Out-Null
            }
            if ($Results.MediaContentRatingCanada.Count -gt 0)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.MediaContentRatingCanada -CIMInstanceName MicrosoftGraphmediacontentratingcanada
                if ($complexTypeStringResult)
                {
                    $Results.MediaContentRatingCanada = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('MediaContentRatingCanada') | Out-Null
                }
            }
            else
            {
                $Results.Remove('MediaContentRatingCanada') | Out-Null
            }
            if ($Results.MediaContentRatingFrance.Count -gt 0)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.MediaContentRatingFrance -CIMInstanceName MicrosoftGraphmediacontentratingfrance
                if ($complexTypeStringResult)
                {
                    $Results.MediaContentRatingFrance = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('MediaContentRatingFrance') | Out-Null
                }
            }
            else
            {
                $Results.Remove('MediaContentRatingFrance') | Out-Null
            }
            if ($Results.MediaContentRatingGermany.Count -gt 0)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.MediaContentRatingGermany -CIMInstanceName MicrosoftGraphmediacontentratinggermany
                if ($complexTypeStringResult)
                {
                    $Results.MediaContentRatingGermany = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('MediaContentRatingGermany') | Out-Null
                }
            }
            else
            {
                $Results.Remove('MediaContentRatingGermany') | Out-Null
            }
            if ($Results.MediaContentRatingIreland.Count -gt 0)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.MediaContentRatingIreland -CIMInstanceName MicrosoftGraphmediacontentratingireland
                if ($complexTypeStringResult)
                {
                    $Results.MediaContentRatingIreland = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('MediaContentRatingIreland') | Out-Null
                }
            }
            else
            {
                $Results.Remove('MediaContentRatingIreland') | Out-Null
            }
            if ($Results.MediaContentRatingJapan.Count -gt 0)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.MediaContentRatingJapan -CIMInstanceName MicrosoftGraphmediacontentratingjapan
                if ($complexTypeStringResult)
                {
                    $Results.MediaContentRatingJapan = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('MediaContentRatingJapan') | Out-Null
                }
            }
            else
            {
                $Results.Remove('MediaContentRatingJapan') | Out-Null
            }
            if ($Results.MediaContentRatingNewZealand.Count -gt 0)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.MediaContentRatingNewZealand -CIMInstanceName MicrosoftGraphmediacontentratingnewzealand
                if ($complexTypeStringResult)
                {
                    $Results.MediaContentRatingNewZealand = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('MediaContentRatingNewZealand') | Out-Null
                }
            }
            else
            {
                $Results.Remove('MediaContentRatingNewZealand') | Out-Null
            }
            if ($Results.MediaContentRatingUnitedKingdom.Count -gt 0)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.MediaContentRatingUnitedKingdom -CIMInstanceName MicrosoftGraphmediacontentratingunitedkingdom
                if ($complexTypeStringResult)
                {
                    $Results.MediaContentRatingUnitedKingdom = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('MediaContentRatingUnitedKingdom') | Out-Null
                }
            }
            else
            {
                $Results.Remove('MediaContentRatingUnitedKingdom') | Out-Null
            }
            if ($Results.MediaContentRatingUnitedStates.Count -gt 0)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.MediaContentRatingUnitedStates -CIMInstanceName MicrosoftGraphmediacontentratingunitedstates
                if ($complexTypeStringResult)
                {
                    $Results.MediaContentRatingUnitedStates = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('MediaContentRatingUnitedStates') | Out-Null
                }
            }
            else
            {
                $Results.Remove('MediaContentRatingUnitedStates') | Out-Null
            }
            if ($Results.NetworkUsageRules)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.NetworkUsageRules -CIMInstanceName MicrosoftGraphiosnetworkusagerule
                if ($complexTypeStringResult)
                {
                    $Results.NetworkUsageRules = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('NetworkUsageRules') | Out-Null
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
                -Credential $Credential `
                -NoEscape @('AppsSingleAppModeList', 'AppsVisibilityList', 'CompliantAppsList', 'MediaContentRatingAustralia',
                'MediaContentRatingCanada', 'MediaContentRatingFrance', 'MediaContentRatingGermany', 'MediaContentRatingIreland',
                'MediaContentRatingJapan', 'MediaContentRatingNewZealand', 'MediaContentRatingUnitedKingdom',
                'MediaContentRatingUnitedStates', 'NetworkUsageRules', 'Assignments')

            [void]$dscContent.Append($currentDSCBlock)

            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }

        return $dscContent.ToString()
    }
    catch
    {
        if ($_.Exception -like '*401*' -or $_.ErrorDetails.Message -like "*`"ErrorCode`":`"Forbidden`"*" -or `
                $_.Exception -like '*Request not applicable to target tenant*')
        {
            Write-M365DSCHost -Message "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered for Intune."
        }
        else
        {
            New-M365DSCLogEntry -Message 'Error during Export:' `
                -Exception $_ `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential

            throw
        }
    }
}

Export-ModuleMember -Function *-TargetResource
