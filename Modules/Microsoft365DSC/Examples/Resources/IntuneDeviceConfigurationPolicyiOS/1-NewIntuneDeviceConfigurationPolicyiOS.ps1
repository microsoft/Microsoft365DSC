<#
This example creates a new Device Configuration Policy for iOS.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneDeviceConfigurationPolicyiOS MyCustomiOSPolicy
        {
            DisplayName                                    = "iOS DSC Policy";
            AccountBlockModification                       = $False;
            ActivationLockAllowWhenSupervised              = $False;
            AirDropBlocked                                 = $False;
            AirDropForceUnmanagedDropTarget                = $False;
            AirPlayForcePairingPasswordForOutgoingRequests = $False;
            AppleNewsBlocked                               = $False;
            AppleWatchBlockPairing                         = $False;
            AppleWatchForceWristDetection                  = $False;
            AppStoreBlockAutomaticDownloads                = $False;
            AppStoreBlocked                                = $False;
            AppStoreBlockInAppPurchases                    = $False;
            AppStoreBlockUIAppInstallation                 = $False;
            AppStoreRequirePassword                        = $False;
            AppsVisibilityList                             = @();
            AppsVisibilityListType                         = "none";
            BluetoothBlockModification                     = $True;
            CameraBlocked                                  = $False;
            CellularBlockDataRoaming                       = $False;
            CellularBlockGlobalBackgroundFetchWhileRoaming = $False;
            CellularBlockPerAppDataModification            = $False;
            CellularBlockVoiceRoaming                      = $False;
            CertificatesBlockUntrustedTlsCertificates      = $False;
            ClassroomAppBlockRemoteScreenObservation       = $False;
            CompliantAppListType                           = "none";
            CompliantAppsList                              = @();
            ConfigurationProfileBlockChanges               = $False;
            DefinitionLookupBlocked                        = $False;
            Description                                    = "iOS Device Restriction Policy";
            DeviceBlockEnableRestrictions                  = $True;
            DeviceBlockEraseContentAndSettings             = $False;
            DeviceBlockNameModification                    = $False;
            DiagnosticDataBlockSubmission                  = $False;
            DiagnosticDataBlockSubmissionModification      = $False;
            DocumentsBlockManagedDocumentsInUnmanagedApps  = $False;
            DocumentsBlockUnmanagedDocumentsInManagedApps  = $False;
            EmailInDomainSuffixes                          = @();
            EnterpriseAppBlockTrust                        = $False;
            EnterpriseAppBlockTrustModification            = $False;
            FaceTimeBlocked                                = $False;
            FindMyFriendsBlocked                           = $False;
            GameCenterBlocked                              = $False;
            GamingBlockGameCenterFriends                   = $True;
            GamingBlockMultiplayer                         = $False;
            HostPairingBlocked                             = $False;
            iBooksStoreBlocked                             = $False;
            iBooksStoreBlockErotica                        = $False;
            iCloudBlockActivityContinuation                = $False;
            iCloudBlockBackup                              = $True;
            iCloudBlockDocumentSync                        = $True;
            iCloudBlockManagedAppsSync                     = $False;
            iCloudBlockPhotoLibrary                        = $False;
            iCloudBlockPhotoStreamSync                     = $True;
            iCloudBlockSharedPhotoStream                   = $False;
            iCloudRequireEncryptedBackup                   = $False;
            iTunesBlockExplicitContent                     = $False;
            iTunesBlockMusicService                        = $False;
            iTunesBlockRadio                               = $False;
            KeyboardBlockAutoCorrect                       = $False;
            KeyboardBlockPredictive                        = $False;
            KeyboardBlockShortcuts                         = $False;
            KeyboardBlockSpellCheck                        = $False;
            KioskModeAllowAssistiveSpeak                   = $False;
            KioskModeAllowAssistiveTouchSettings           = $False;
            KioskModeAllowAutoLock                         = $False;
            KioskModeAllowColorInversionSettings           = $False;
            KioskModeAllowRingerSwitch                     = $False;
            KioskModeAllowScreenRotation                   = $False;
            KioskModeAllowSleepButton                      = $False;
            KioskModeAllowTouchscreen                      = $False;
            KioskModeAllowVoiceOverSettings                = $False;
            KioskModeAllowVolumeButtons                    = $False;
            KioskModeAllowZoomSettings                     = $False;
            KioskModeRequireAssistiveTouch                 = $False;
            KioskModeRequireColorInversion                 = $False;
            KioskModeRequireMonoAudio                      = $False;
            KioskModeRequireVoiceOver                      = $False;
            KioskModeRequireZoom                           = $False;
            LockScreenBlockControlCenter                   = $False;
            LockScreenBlockNotificationView                = $False;
            LockScreenBlockPassbook                        = $False;
            LockScreenBlockTodayView                       = $False;
            MediaContentRatingApps                         = "allAllowed";
            messagesBlocked                                = $False;
            NotificationsBlockSettingsModification         = $False;
            PasscodeBlockFingerprintUnlock                 = $False;
            PasscodeBlockModification                      = $False;
            PasscodeBlockSimple                            = $True;
            PasscodeMinimumLength                          = 4;
            PasscodeRequired                               = $True;
            PasscodeRequiredType                           = "deviceDefault";
            PodcastsBlocked                                = $False;
            SafariBlockAutofill                            = $False;
            SafariBlocked                                  = $False;
            SafariBlockJavaScript                          = $False;
            SafariBlockPopups                              = $False;
            SafariCookieSettings                           = "browserDefault";
            SafariManagedDomains                           = @();
            SafariPasswordAutoFillDomains                  = @();
            SafariRequireFraudWarning                      = $False;
            ScreenCaptureBlocked                           = $False;
            SiriBlocked                                    = $False;
            SiriBlockedWhenLocked                          = $False;
            SiriBlockUserGeneratedContent                  = $False;
            SiriRequireProfanityFilter                     = $False;
            SpotlightBlockInternetResults                  = $False;
            VoiceDialingBlocked                            = $False;
            WallpaperBlockModification                     = $False;
            Ensure                                         = 'Present'
            GlobalAdminAccount                              = $credsGlobalAdmin;
        }
    }
}
