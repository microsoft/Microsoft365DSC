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
        [System.String[]]
        $AppsVisibilityList,

        [Parameter()]
        [System.String]
        $AppsVisibilityListType = 'none',

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
        $CellularBlockVoiceRoaming,

        [Parameter()]
        [System.Boolean]
        $CertificatesBlockUntrustedTlsCertificates,

        [Parameter()]
        [System.Boolean]
        $ClassroomAppBlockRemoteScreenObservation,

        [Parameter()]
        [System.String[]]
        $CompliantAppsList,

        [Parameter()]
        [System.String]
        $CompliantAppListType = 'none',

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
        $KioskModeAllowVoiceOverSettings,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowVolumeButtons,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowZoomSettings,

        [Parameter()]
        [System.Boolean]
        $KioskModeAppStoreUrl,

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
        [System.String]
        $MediaContentRatingAustralia,

        [Parameter()]
        [System.String]
        $MediaContentRatingCanada,

        [Parameter()]
        [System.String]
        $MediaContentRatingFrance,

        [Parameter()]
        [System.String]
        $MediaContentRatingGermany,

        [Parameter()]
        [System.String]
        $MediaContentRatingIreland,

        [Parameter()]
        [System.String]
        $MediaContentRatingJapan,

        [Parameter()]
        [System.String]
        $MediaContentRatingNewZealand,

        [Parameter()]
        [System.String]
        $MediaContentRatingUnitedKingdom,

        [Parameter()]
        [System.String]
        $MediaContentRatingUnitedStates,

        [Parameter()]
        [System.String]
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
        $PasscodeMinimumLength = 4,

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
        $PasscodeRequiredType = "deviceDefault",

        [Parameter()]
        [System.Boolean]
        $PasscodeRequired,

        [Parameter()]
        [System.Boolean]
        $PodcastsBlocked,

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
        $SafariCookieSettings = 'browserDefault',

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
        [System.Boolean]
        $SpotlightBlockInternetResults,

        [Parameter()]
        [System.Boolean]
        $VoiceDialingBlocked,

        [Parameter()]
        [System.Boolean]
        $WallpaperBlockModification,

        [Parameter(Mandatory = $true)]
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
        $policy = Get-MgDeviceManagementDeviceConfiguration -Filter "displayName eq '$DisplayName'" `
            -ErrorAction Stop | Where-Object -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.iosGeneralDeviceConfiguration' }

        if ($null -eq $policy)
        {
            Write-Verbose -Message "No Device Configuration Policy {$DisplayName} was found"
            return $nullResult
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
            AppsVisibilityList                             = $policy.AdditionalProperties.appsVisibilityList
            AppsVisibilityListType                         = $policy.AdditionalProperties.appsVisibilityListType
            AppStoreBlockAutomaticDownloads                = $policy.AdditionalProperties.appStoreBlockAutomaticDownloads
            AppStoreBlocked                                = $policy.AdditionalProperties.appStoreBlocked
            AppStoreBlockInAppPurchases                    = $policy.AdditionalProperties.appStoreBlockInAppPurchases
            AppStoreBlockUIAppInstallation                 = $policy.AdditionalProperties.appStoreBlockUIAppInstallation
            AppStoreRequirePassword                        = $policy.AdditionalProperties.appStoreRequirePassword
            BluetoothBlockModification                     = $policy.AdditionalProperties.bluetoothBlockModification
            CameraBlocked                                  = $policy.AdditionalProperties.cameraBlocked
            CellularBlockDataRoaming                       = $policy.AdditionalProperties.cellularBlockDataRoaming
            CellularBlockGlobalBackgroundFetchWhileRoaming = $policy.AdditionalProperties.cellularBlockGlobalBackgroundFetchWhileRoaming
            CellularBlockPerAppDataModification            = $policy.AdditionalProperties.cellularBlockPerAppDataModification
            CellularBlockVoiceRoaming                      = $policy.AdditionalProperties.cellularBlockVoiceRoaming
            CertificatesBlockUntrustedTlsCertificates      = $policy.AdditionalProperties.certificatesBlockUntrustedTlsCertificates
            ClassroomAppBlockRemoteScreenObservation       = $policy.AdditionalProperties.classroomAppBlockRemoteScreenObservation
            CompliantAppsList                              = $policy.AdditionalProperties.compliantAppsList
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
            KeyboardBlockPredictive                        = $policy.AdditionalProperties.keyboardBlockPredictive
            KeyboardBlockShortcuts                         = $policy.AdditionalProperties.keyboardBlockShortcuts
            KeyboardBlockSpellCheck                        = $policy.AdditionalProperties.keyboardBlockSpellCheck
            KioskModeAllowAssistiveSpeak                   = $policy.AdditionalProperties.kioskModeAllowAssistiveSpeak
            KioskModeAllowAssistiveTouchSettings           = $policy.AdditionalProperties.kioskModeAllowAssistiveTouchSettings
            KioskModeAllowAutoLock                         = $policy.AdditionalProperties.kioskModeAllowAutoLock
            KioskModeAllowColorInversionSettings           = $policy.AdditionalProperties.kioskModeAllowColorInversionSettings
            KioskModeAllowRingerSwitch                     = $policy.AdditionalProperties.kioskModeAllowRingerSwitch
            KioskModeAllowScreenRotation                   = $policy.AdditionalProperties.kioskModeAllowScreenRotation
            KioskModeAllowSleepButton                      = $policy.AdditionalProperties.kioskModeAllowSleepButton
            KioskModeAllowTouchscreen                      = $policy.AdditionalProperties.kioskModeAllowTouchscreen
            KioskModeAllowVoiceOverSettings                = $policy.AdditionalProperties.kioskModeAllowVoiceOverSettings
            KioskModeAllowVolumeButtons                    = $policy.AdditionalProperties.kioskModeAllowVolumeButtons
            KioskModeAllowZoomSettings                     = $policy.AdditionalProperties.kioskModeAllowZoomSettings
            KioskModeAppStoreUrl                           = $policy.AdditionalProperties.kioskModeAppStoreUrl
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
            MediaContentRatingAustralia                    = $policy.AdditionalProperties.mediaContentRatingAustralia
            MediaContentRatingCanada                       = $policy.AdditionalProperties.mediaContentRatingCanada
            MediaContentRatingFrance                       = $policy.AdditionalProperties.mediaContentRatingFrance
            MediaContentRatingGermany                      = $policy.AdditionalProperties.mediaContentRatingGermany
            MediaContentRatingIreland                      = $policy.AdditionalProperties.mediaContentRatingIreland
            MediaContentRatingJapan                        = $policy.AdditionalProperties.mediaContentRatingJapan
            MediaContentRatingNewZealand                   = $policy.AdditionalProperties.mediaContentRatingNewZealand
            MediaContentRatingUnitedKingdom                = $policy.AdditionalProperties.mediaContentRatingUnitedKingdom
            MediaContentRatingUnitedStates                 = $policy.AdditionalProperties.mediaContentRatingUnitedStates
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
            SpotlightBlockInternetResults                  = $policy.AdditionalProperties.spotlightBlockInternetResults
            VoiceDialingBlocked                            = $policy.AdditionalProperties.voiceDialingBlocked
            WallpaperBlockModification                     = $policy.AdditionalProperties.wallpaperBlockModification
            Ensure                                         = "Present"
            Credential                             = $Credential
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
        [System.String[]]
        $AppsVisibilityList,

        [Parameter()]
        [System.String]
        $AppsVisibilityListType = 'none',

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
        $CellularBlockVoiceRoaming,

        [Parameter()]
        [System.Boolean]
        $CertificatesBlockUntrustedTlsCertificates,

        [Parameter()]
        [System.Boolean]
        $ClassroomAppBlockRemoteScreenObservation,

        [Parameter()]
        [System.String[]]
        $CompliantAppsList,

        [Parameter()]
        [System.String]
        $CompliantAppListType = 'none',

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
        $KioskModeAllowVoiceOverSettings,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowVolumeButtons,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowZoomSettings,

        [Parameter()]
        [System.Boolean]
        $KioskModeAppStoreUrl,

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
        [System.String]
        $MediaContentRatingAustralia,

        [Parameter()]
        [System.String]
        $MediaContentRatingCanada,

        [Parameter()]
        [System.String]
        $MediaContentRatingFrance,

        [Parameter()]
        [System.String]
        $MediaContentRatingGermany,

        [Parameter()]
        [System.String]
        $MediaContentRatingIreland,

        [Parameter()]
        [System.String]
        $MediaContentRatingJapan,

        [Parameter()]
        [System.String]
        $MediaContentRatingNewZealand,

        [Parameter()]
        [System.String]
        $MediaContentRatingUnitedKingdom,

        [Parameter()]
        [System.String]
        $MediaContentRatingUnitedStates,

        [Parameter()]
        [System.String]
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
        $PasscodeMinimumLength = 4,

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
        $PasscodeRequiredType = "deviceDefault",

        [Parameter()]
        [System.Boolean]
        $PasscodeRequired,

        [Parameter()]
        [System.Boolean]
        $PodcastsBlocked,

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
        $SafariCookieSettings = 'browserDefault',

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
        [System.Boolean]
        $SpotlightBlockInternetResults,

        [Parameter()]
        [System.Boolean]
        $VoiceDialingBlocked,

        [Parameter()]
        [System.Boolean]
        $WallpaperBlockModification,

        [Parameter(Mandatory = $true)]
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
        $AdditionalProperties = Get-M365DSCIntuneDeviceConfigurationPolicyiOSAdditionalProperties -Properties ([System.Collections.Hashtable]$PSBoundParameters)
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
        $AdditionalProperties = Get-M365DSCIntuneDeviceConfigurationPolicyiOSAdditionalProperties -Properties ([System.Collections.Hashtable]$PSBoundParameters)
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
        [System.String[]]
        $AppsVisibilityList,

        [Parameter()]
        [System.String]
        $AppsVisibilityListType = 'none',

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
        $CellularBlockVoiceRoaming,

        [Parameter()]
        [System.Boolean]
        $CertificatesBlockUntrustedTlsCertificates,

        [Parameter()]
        [System.Boolean]
        $ClassroomAppBlockRemoteScreenObservation,

        [Parameter()]
        [System.String[]]
        $CompliantAppsList,

        [Parameter()]
        [System.String]
        $CompliantAppListType = 'none',

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
        $KioskModeAllowVoiceOverSettings,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowVolumeButtons,

        [Parameter()]
        [System.Boolean]
        $KioskModeAllowZoomSettings,

        [Parameter()]
        [System.Boolean]
        $KioskModeAppStoreUrl,

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
        [System.String]
        $MediaContentRatingAustralia,

        [Parameter()]
        [System.String]
        $MediaContentRatingCanada,

        [Parameter()]
        [System.String]
        $MediaContentRatingFrance,

        [Parameter()]
        [System.String]
        $MediaContentRatingGermany,

        [Parameter()]
        [System.String]
        $MediaContentRatingIreland,

        [Parameter()]
        [System.String]
        $MediaContentRatingJapan,

        [Parameter()]
        [System.String]
        $MediaContentRatingNewZealand,

        [Parameter()]
        [System.String]
        $MediaContentRatingUnitedKingdom,

        [Parameter()]
        [System.String]
        $MediaContentRatingUnitedStates,

        [Parameter()]
        [System.String]
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
        $PasscodeMinimumLength = 4,

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
        $PasscodeRequiredType = "deviceDefault",

        [Parameter()]
        [System.Boolean]
        $PasscodeRequired,

        [Parameter()]
        [System.Boolean]
        $PodcastsBlocked,

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
        $SafariCookieSettings = 'browserDefault',

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
        [System.Boolean]
        $SpotlightBlockInternetResults,

        [Parameter()]
        [System.Boolean]
        $VoiceDialingBlocked,

        [Parameter()]
        [System.Boolean]
        $WallpaperBlockModification,

        [Parameter(Mandatory = $true)]
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

function Get-M365DSCIntuneDeviceConfigurationPolicyiOSAdditionalProperties
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $Properties
    )

    $results = @{"@odata.type" = "#microsoft.graph.iosGeneralDeviceConfiguration"}
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
