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
        $messagesBlocked,

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

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Checking for the Intune Device Configuration Policy {$DisplayName}"
    $ConnectionMode = New-M365DSCConnection -Platform 'Intune' `
        -InboundParameters $PSBoundParameters

    $nullResult = $PSBoundParameters
    $nullResult.Ensure = 'Absent'

    try
    {
        $policyInfo = Get-IntuneDeviceConfigurationPolicy -Filter "displayName eq '$DisplayName'" `
            -ErrorAction Stop | Where-Object -FilterScript { $_.'@odata.type' -eq '#microsoft.graph.iosGeneralDeviceConfiguration' }

        if ($null -eq $policyInfo)
        {
            Write-Verbose -Message "No Device Configuration Policy {$DisplayName} was found"
            return $nullResult
        }

        $policy = Get-M365DSCIntuneDeviceConfigurationPolicyiOS -PolicyId $policyInfo.Id
        Write-Verbose -Message "Found Device Configuration Policy {$DisplayName}"
        return @{
            DisplayName                                    = $policy.DisplayName
            Description                                    = $policy.Description
            AccountBlockModification                       = $policy.AccountBlockModification
            ActivationLockAllowWhenSupervised              = $policy.ActivationLockAllowWhenSupervised
            AirDropBlocked                                 = $policy.AirDropBlocked
            AirDropForceUnmanagedDropTarget                = $policy.AirDropForceUnmanagedDropTarget
            AirPlayForcePairingPasswordForOutgoingRequests = $policy.AirPlayForcePairingPasswordForOutgoingRequests
            AppleWatchBlockPairing                         = $policy.AppleWatchBlockPairing
            AppleWatchForceWristDetection                  = $policy.AppleWatchForceWristDetection
            AppleNewsBlocked                               = $policy.AppleNewsBlocked
            AppsVisibilityList                             = $policy.AppsVisibilityList
            AppsVisibilityListType                         = $policy.AppsVisibilityListType
            AppStoreBlockAutomaticDownloads                = $policy.AppStoreBlockAutomaticDownloads
            AppStoreBlocked                                = $policy.AppStoreBlocked
            AppStoreBlockInAppPurchases                    = $policy.AppStoreBlockInAppPurchases
            AppStoreBlockUIAppInstallation                 = $policy.AppStoreBlockUIAppInstallation
            AppStoreRequirePassword                        = $policy.AppStoreRequirePassword
            BluetoothBlockModification                     = $policy.BluetoothBlockModification
            CameraBlocked                                  = $policy.CameraBlocked
            CellularBlockDataRoaming                       = $policy.CellularBlockDataRoaming
            CellularBlockGlobalBackgroundFetchWhileRoaming = $policy.CellularBlockGlobalBackgroundFetchWhileRoaming
            CellularBlockPerAppDataModification            = $policy.CellularBlockPerAppDataModification
            CellularBlockVoiceRoaming                      = $policy.CellularBlockVoiceRoaming
            CertificatesBlockUntrustedTlsCertificates      = $policy.CertificatesBlockUntrustedTlsCertificates
            ClassroomAppBlockRemoteScreenObservation       = $policy.ClassroomAppBlockRemoteScreenObservation
            CompliantAppsList                              = $policy.CompliantAppsList
            CompliantAppListType                           = $policy.CompliantAppListType
            ConfigurationProfileBlockChanges               = $policy.ConfigurationProfileBlockChanges
            DefinitionLookupBlocked                        = $policy.DefinitionLookupBlocked
            DeviceBlockEnableRestrictions                  = $policy.DeviceBlockEnableRestrictions
            DeviceBlockEraseContentAndSettings             = $policy.DeviceBlockEraseContentAndSettings
            DeviceBlockNameModification                    = $policy.DeviceBlockNameModification
            DiagnosticDataBlockSubmission                  = $policy.DiagnosticDataBlockSubmission
            DiagnosticDataBlockSubmissionModification      = $policy.DiagnosticDataBlockSubmissionModification
            DocumentsBlockManagedDocumentsInUnmanagedApps  = $policy.DocumentsBlockManagedDocumentsInUnmanagedApps
            DocumentsBlockUnmanagedDocumentsInManagedApps  = $policy.DocumentsBlockUnmanagedDocumentsInManagedApps
            EmailInDomainSuffixes                          = $policy.EmailInDomainSuffixes
            EnterpriseAppBlockTrust                        = $policy.EnterpriseAppBlockTrust
            EnterpriseAppBlockTrustModification            = $policy.EnterpriseAppBlockTrustModification
            FaceTimeBlocked                                = $policy.FaceTimeBlocked
            FindMyFriendsBlocked                           = $policy.FindMyFriendsBlocked
            GamingBlockGameCenterFriends                   = $policy.GamingBlockGameCenterFriends
            GamingBlockMultiplayer                         = $policy.GamingBlockMultiplayer
            GameCenterBlocked                              = $policy.GameCenterBlocked
            HostPairingBlocked                             = $policy.HostPairingBlocked
            iBooksStoreBlocked                             = $policy.iBooksStoreBlocked
            iBooksStoreBlockErotica                        = $policy.iBooksStoreBlockErotica
            iCloudBlockActivityContinuation                = $policy.iCloudBlockActivityContinuation
            iCloudBlockBackup                              = $policy.iCloudBlockBackup
            iCloudBlockDocumentSync                        = $policy.iCloudBlockDocumentSync
            iCloudBlockManagedAppsSync                     = $policy.iCloudBlockManagedAppsSync
            iCloudBlockPhotoLibrary                        = $policy.iCloudBlockPhotoLibrary
            iCloudBlockPhotoStreamSync                     = $policy.iCloudBlockPhotoStreamSync
            iCloudBlockSharedPhotoStream                   = $policy.iCloudBlockSharedPhotoStream
            iCloudRequireEncryptedBackup                   = $policy.iCloudRequireEncryptedBackup
            iTunesBlockExplicitContent                     = $policy.iTunesBlockExplicitContent
            iTunesBlockMusicService                        = $policy.iTunesBlockMusicService
            iTunesBlockRadio                               = $policy.iTunesBlockRadio
            KeyboardBlockAutoCorrect                       = $policy.KeyboardBlockAutoCorrect
            KeyboardBlockPredictive                        = $policy.KeyboardBlockPredictive
            KeyboardBlockShortcuts                         = $policy.KeyboardBlockShortcuts
            KeyboardBlockSpellCheck                        = $policy.KeyboardBlockSpellCheck
            KioskModeAllowAssistiveSpeak                   = $policy.KioskModeAllowAssistiveSpeak
            KioskModeAllowAssistiveTouchSettings           = $policy.KioskModeAllowAssistiveTouchSettings
            KioskModeAllowAutoLock                         = $policy.KioskModeAllowAutoLock
            KioskModeAllowColorInversionSettings           = $policy.KioskModeAllowColorInversionSettings
            KioskModeAllowRingerSwitch                     = $policy.KioskModeAllowRingerSwitch
            KioskModeAllowScreenRotation                   = $policy.KioskModeAllowScreenRotation
            KioskModeAllowSleepButton                      = $policy.KioskModeAllowSleepButton
            KioskModeAllowTouchscreen                      = $policy.KioskModeAllowTouchscreen
            KioskModeAllowVoiceOverSettings                = $policy.KioskModeAllowVoiceOverSettings
            KioskModeAllowVolumeButtons                    = $policy.KioskModeAllowVolumeButtons
            KioskModeAllowZoomSettings                     = $policy.KioskModeAllowZoomSettings
            KioskModeAppStoreUrl                           = $policy.KioskModeAppStoreUrl
            KioskModeRequireAssistiveTouch                 = $policy.KioskModeRequireAssistiveTouch
            KioskModeRequireColorInversion                 = $policy.KioskModeRequireColorInversion
            KioskModeRequireMonoAudio                      = $policy.KioskModeRequireMonoAudio
            KioskModeRequireVoiceOver                      = $policy.KioskModeRequireVoiceOver
            KioskModeRequireZoom                           = $policy.KioskModeRequireZoom
            KioskModeManagedAppId                          = $policy.KioskModeManagedAppId
            LockScreenBlockControlCenter                   = $policy.LockScreenBlockControlCenter
            LockScreenBlockNotificationView                = $policy.LockScreenBlockNotificationView
            LockScreenBlockPassbook                        = $policy.LockScreenBlockPassbook
            LockScreenBlockTodayView                       = $policy.LockScreenBlockTodayView
            MediaContentRatingAustralia                    = $policy.MediaContentRatingAustralia
            MediaContentRatingCanada                       = $policy.MediaContentRatingCanada
            MediaContentRatingFrance                       = $policy.MediaContentRatingFrance
            MediaContentRatingGermany                      = $policy.MediaContentRatingGermany
            MediaContentRatingIreland                      = $policy.MediaContentRatingIreland
            MediaContentRatingJapan                        = $policy.MediaContentRatingJapan
            MediaContentRatingNewZealand                   = $policy.MediaContentRatingNewZealand
            MediaContentRatingUnitedKingdom                = $policy.MediaContentRatingUnitedKingdom
            MediaContentRatingUnitedStates                 = $policy.MediaContentRatingUnitedStates
            MediaContentRatingApps                         = $policy.MediaContentRatingApps
            messagesBlocked                                = $policy.messagesBlocked
            NotificationsBlockSettingsModification         = $policy.NotificationsBlockSettingsModification
            PasscodeBlockFingerprintUnlock                 = $policy.PasscodeBlockFingerprintUnlock
            PasscodeBlockModification                      = $policy.PasscodeBlockModification
            PasscodeBlockSimple                            = $policy.PasscodeBlockSimple
            PasscodeExpirationDays                         = $policy.PasscodeExpirationDays
            PasscodeMinimumLength                          = $policy.PasscodeMinimumLength
            PasscodeMinutesOfInactivityBeforeLock          = $policy.PasscodeMinutesOfInactivityBeforeLock
            PasscodeMinutesOfInactivityBeforeScreenTimeout = $policy.PasscodeMinutesOfInactivityBeforeScreenTimeout
            PasscodeMinimumCharacterSetCount               = $policy.PasscodeMinimumCharacterSetCount
            PasscodePreviousPasscodeBlockCount             = $policy.PasscodePreviousPasscodeBlockCount
            PasscodeSignInFailureCountBeforeWipe           = $policy.PasscodeSignInFailureCountBeforeWipe
            PasscodeRequiredType                           = $policy.PasscodeRequiredType
            PasscodeRequired                               = $policy.PasscodeRequired
            PodcastsBlocked                                = $policy.PodcastsBlocked
            SafariBlockAutofill                            = $policy.SafariBlockAutofill
            SafariBlockJavaScript                          = $policy.SafariBlockJavaScript
            SafariBlockPopups                              = $policy.SafariBlockPopups
            SafariBlocked                                  = $policy.SafariBlocked
            SafariCookieSettings                           = $policy.SafariCookieSettings
            SafariManagedDomains                           = $policy.SafariManagedDomains
            SafariPasswordAutoFillDomains                  = $policy.SafariPasswordAutoFillDomains
            SafariRequireFraudWarning                      = $policy.SafariRequireFraudWarning
            ScreenCaptureBlocked                           = $policy.ScreenCaptureBlocked
            SiriBlocked                                    = $policy.SiriBlocked
            SiriBlockedWhenLocked                          = $policy.SiriBlockedWhenLocked
            SiriBlockUserGeneratedContent                  = $policy.SiriBlockUserGeneratedContent
            SiriRequireProfanityFilter                     = $policy.SiriRequireProfanityFilter
            SpotlightBlockInternetResults                  = $policy.SpotlightBlockInternetResults
            VoiceDialingBlocked                            = $policy.VoiceDialingBlocked
            WallpaperBlockModification                     = $policy.WallpaperBlockModification
            Ensure                                         = "Present"
            GlobalAdminAccount                             = $GlobalAdminAccount
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
        $messagesBlocked,

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

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'Intune' `
        -InboundParameters $PSBoundParameters

    $currentPolicy = Get-TargetResource @PSBoundParameters
    $setParams = $PSBoundParameters
    $setParams.Remove("Ensure") | Out-Null
    $setParams.Remove("GlobalAdminAccount") | Out-Null
    if ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Device Configuration Policy {$DisplayName}"
        New-M365DSCIntuneDeviceConfigurationPolicyiOS -Parameters $setParams
    }
    elseif ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating existing Device Configuration Policy {$DisplayName}"
        $policy = Get-IntuneDeviceConfigurationPolicy -Filter "displayName eq '$DisplayName'"
        Set-M365DSCIntuneDeviceConfigurationPolicyiOS -Parameters $setParams -PolicyId ($policy.id)
    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Device Configuration Policy {$DisplayName}"
        $policy = Get-IntuneDeviceConfigurationPolicy -Filter "displayName eq '$DisplayName'"
        Remove-IntuneDeviceConfigurationPolicy -deviceConfigurationId $policy.id
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
        $messagesBlocked,

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

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
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
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'Intune' `
        -InboundParameters $PSBoundParameters

    try
    {
        [array]$policies = Get-IntuneDeviceConfigurationPolicy -ErrorAction Stop | Where-Object -FilterScript { $_.'@odata.type' -eq '#microsoft.graph.iosGeneralDeviceConfiguration' }
        $i = 1
        $content = ''
        Write-Host "`r`n" -NoNewline
        foreach ($policy in $policies)
        {
            Write-Host "    |---[$i/$($policies.Count)] $($policy.displayName)" -NoNewline
            $params = @{
                DisplayName        = $policy.displayName
                Ensure             = 'Present'
                GlobalAdminAccount = $GlobalAdminAccount
            }
            $result = Get-TargetResource @params
            $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
            $content += "        IntuneDeviceConfigurationPolicyiOS " + (New-Guid).ToString() + "`r`n"
            $content += "        {`r`n"
            $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
            $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
            $content += "        }`r`n"
            $i++
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        return $content
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

function Get-M365DSCIntuneDeviceConfigurationPolicyiOS
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $PolicyId
    )
    try
    {
        $Url = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations/$PolicyId"
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

function New-M365DSCIntuneDeviceConfigurationPolicyiOS
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
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
        $jsonString = "{`r`n`"@odata.type`":`"#microsoft.graph.iosGeneralDeviceConfiguration`",`r`n"
        foreach ($key in $Parameters.Keys)
        {
            $length = $key.Length
            $fixedKeyName = $key[0].ToString().ToLower() + $key.Substring(1, $length - 1)
            $jsonString += "`"$fixedKeyName`": "
            if ($Parameters.$key.GetType().Name -eq "String")
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
        $Url = 'https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations/'
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

function Set-M365DSCIntuneDeviceConfigurationPolicyiOS
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Parameters,

        [Parameter(Mandatory = $true)]
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
        $jsonString = "{`r`n`"@odata.type`":`"#microsoft.graph.iosGeneralDeviceConfiguration`",`r`n"
        foreach ($key in $Parameters.Keys)
        {
            $length = $key.Length
            $fixedKeyName = $key[0].ToString().ToLower() + $key.Substring(1, $length - 1)
            $jsonString += "`"$fixedKeyName`": "
            if ($Parameters.$key.GetType().Name -eq "String")
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
        $Url = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations/$PolicyId"
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
