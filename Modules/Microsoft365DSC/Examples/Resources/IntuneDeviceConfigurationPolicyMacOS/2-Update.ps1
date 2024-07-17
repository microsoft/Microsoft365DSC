<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneDeviceConfigurationPolicyMacOS 'myMacOSDevicePolicy'
        {
            DisplayName                                     = 'MacOS device restriction'
            AddingGameCenterFriendsBlocked                  = $True
            AirDropBlocked                                  = $True # Updated Property
            AppleWatchBlockAutoUnlock                       = $False
            Assignments                                     = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments {
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType                                   = '#microsoft.graph.groupAssignmentTarget'
                    groupId                                    = 'e8cbd84d-be6a-4b72-87f0-0e677541fda0'
                }
                MSFT_DeviceManagementConfigurationPolicyAssignments {
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType                                   = '#microsoft.graph.groupAssignmentTarget'
                    groupId                                    = 'ea9199b8-3e6e-407b-afdc-e0943e0d3c20'
                })
            CameraBlocked                                   = $False
            ClassroomAppBlockRemoteScreenObservation        = $False
            ClassroomAppForceUnpromptedScreenObservation    = $False
            ClassroomForceAutomaticallyJoinClasses          = $False
            ClassroomForceRequestPermissionToLeaveClasses   = $False
            ClassroomForceUnpromptedAppAndDeviceLock        = $False
            CompliantAppListType                            = 'appsNotInListCompliant'
            CompliantAppsList                               = @(
                MSFT_MicrosoftGraphapplistitemMacOS {
                    name      = 'appname2'
                    publisher = 'publisher'
                    appId     = 'bundle'
                }
            )
            ContentCachingBlocked                           = $False
            DefinitionLookupBlocked                         = $True
            EmailInDomainSuffixes                           = @()
            EraseContentAndSettingsBlocked                  = $False
            GameCenterBlocked                               = $False
            ICloudBlockActivityContinuation                 = $False
            ICloudBlockAddressBook                          = $False
            ICloudBlockBookmarks                            = $False
            ICloudBlockCalendar                             = $False
            ICloudBlockDocumentSync                         = $False
            ICloudBlockMail                                 = $False
            ICloudBlockNotes                                = $False
            ICloudBlockPhotoLibrary                         = $False
            ICloudBlockReminders                            = $False
            ICloudDesktopAndDocumentsBlocked                = $False
            ICloudPrivateRelayBlocked                       = $False
            ITunesBlockFileSharing                          = $False
            ITunesBlockMusicService                         = $False
            KeyboardBlockDictation                          = $False
            KeychainBlockCloudSync                          = $False
            MultiplayerGamingBlocked                        = $False
            PasswordBlockAirDropSharing                     = $False
            PasswordBlockAutoFill                           = $False
            PasswordBlockFingerprintUnlock                  = $False
            PasswordBlockModification                       = $False
            PasswordBlockProximityRequests                  = $False
            PasswordBlockSimple                             = $False
            PasswordRequired                                = $False
            PasswordRequiredType                            = 'deviceDefault'
            PrivacyAccessControls                           = @(
                MSFT_MicrosoftGraphmacosprivacyaccesscontrolitem {
                    displayName                  = 'test'
                    identifier                   = 'test45'
                    identifierType               = 'path'
                    codeRequirement              = 'test'
                    blockCamera                  = $True
                    speechRecognition            = 'notConfigured'
                    accessibility                = 'notConfigured'
                    addressBook                  = 'enabled'
                    calendar                     = 'notConfigured'
                    reminders                    = 'notConfigured'
                    photos                       = 'notConfigured'
                    mediaLibrary                 = 'notConfigured'
                    fileProviderPresence         = 'notConfigured'
                    systemPolicyAllFiles         = 'notConfigured'
                    systemPolicySystemAdminFiles = 'notConfigured'
                    systemPolicyDesktopFolder    = 'notConfigured'
                    systemPolicyDocumentsFolder  = 'notConfigured'
                    systemPolicyDownloadsFolder  = 'notConfigured'
                    systemPolicyNetworkVolumes   = 'notConfigured'
                    systemPolicyRemovableVolumes = 'notConfigured'
                    postEvent                    = 'notConfigured'
                }
            )
            SafariBlockAutofill                             = $False
            ScreenCaptureBlocked                            = $False
            SoftwareUpdateMajorOSDeferredInstallDelayInDays = 30
            SoftwareUpdateMinorOSDeferredInstallDelayInDays = 30
            SoftwareUpdateNonOSDeferredInstallDelayInDays   = 30
            SoftwareUpdatesEnforcedDelayInDays              = 30
            SpotlightBlockInternetResults                   = $False
            UpdateDelayPolicy                               = @('delayOSUpdateVisibility', 'delayAppUpdateVisibility', 'delayMajorOsUpdateVisibility')
            WallpaperModificationBlocked                    = $False
            Ensure                                          = 'Present'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
