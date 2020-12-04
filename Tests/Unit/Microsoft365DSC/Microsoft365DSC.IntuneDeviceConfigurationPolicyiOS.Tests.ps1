[CmdletBinding()]
param(
)
$M365DSCTestFolder = Join-Path -Path $PSScriptRoot `
    -ChildPath "..\..\Unit" `
    -Resolve
$CmdletModule = (Join-Path -Path $M365DSCTestFolder `
        -ChildPath "\Stubs\Microsoft365.psm1" `
        -Resolve)
$GenericStubPath = (Join-Path -Path $M365DSCTestFolder `
        -ChildPath "\Stubs\Generic.psm1" `
        -Resolve)
Import-Module -Name (Join-Path -Path $M365DSCTestFolder `
        -ChildPath "\UnitTestHelper.psm1" `
        -Resolve)

$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource "IntuneDeviceConfigurationPolicyiOS" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString "Pass@word1" -AsPlainText -Force
            $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credential"
            }

            Mock -CommandName New-M365DSCIntuneDeviceConfigurationPolicyiOS -MockWith {
            }
            Mock -CommandName Set-M365DSCIntuneDeviceConfigurationPolicyiOS -MockWith {
            }
            Mock -CommandName Remove-IntuneDeviceConfigurationPolicy -MockWith {
            }
        }

        # Test contexts
        Context -Name "When the policy doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
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
                    DisplayName                                    = "iOS DSC Created";
                    DocumentsBlockManagedDocumentsInUnmanagedApps  = $False;
                    DocumentsBlockUnmanagedDocumentsInManagedApps  = $False;
                    EmailInDomainSuffixes                          = @();
                    Ensure                                         = "Present";
                    EnterpriseAppBlockTrust                        = $False;
                    EnterpriseAppBlockTrustModification            = $False;
                    FaceTimeBlocked                                = $False;
                    FindMyFriendsBlocked                           = $False;
                    GameCenterBlocked                              = $False;
                    GamingBlockGameCenterFriends                   = $True;
                    GamingBlockMultiplayer                         = $False;
                    GlobalAdminAccount                             = $GlobalAdminAccount;
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
                }

                Mock -CommandName Get-M365DSCIntuneDeviceConfigurationPolicyiOS -MockWith {
                    return $null
                }
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should create the policy from the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName "New-M365DSCIntuneDeviceConfigurationPolicyiOS" -Exactly 1
            }
        }

        Context -Name "When the policy already exists and is NOT in the Desired State" -Fixture {
            BeforeAll {
                $testParams = @{
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
                    DisplayName                                    = "iOS DSC Created";
                    DocumentsBlockManagedDocumentsInUnmanagedApps  = $False;
                    DocumentsBlockUnmanagedDocumentsInManagedApps  = $False;
                    EmailInDomainSuffixes                          = @();
                    Ensure                                         = "Present";
                    EnterpriseAppBlockTrust                        = $False;
                    EnterpriseAppBlockTrustModification            = $False;
                    FaceTimeBlocked                                = $False;
                    FindMyFriendsBlocked                           = $False;
                    GameCenterBlocked                              = $False;
                    GamingBlockGameCenterFriends                   = $True;
                    GamingBlockMultiplayer                         = $False;
                    GlobalAdminAccount                             = $GlobalAdminAccount;
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
                }

                Mock -CommandName Get-IntuneDeviceConfigurationPolicy -MockWith {
                    return @{
                        '@odata.type' = "#microsoft.graph.iosGeneralDeviceConfiguration"
                        displayName   = "iOS DSC Created"
                        id            = "12345-12345-12345-12345-12345"
                    }
                }

                Mock -CommandName Get-M365DSCIntuneDeviceConfigurationPolicyiOS -MockWith {
                    return @{
                        '@odata.type'                                  = "#microsoft.graph.iosGeneralDeviceConfiguration"
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
                        DisplayName                                    = "iOS DSC Created";
                        DocumentsBlockManagedDocumentsInUnmanagedApps  = $False;
                        DocumentsBlockUnmanagedDocumentsInManagedApps  = $False;
                        EmailInDomainSuffixes                          = @();
                        Ensure                                         = "Present";
                        EnterpriseAppBlockTrust                        = $False;
                        EnterpriseAppBlockTrustModification            = $False;
                        FaceTimeBlocked                                = $False;
                        FindMyFriendsBlocked                           = $False;
                        GameCenterBlocked                              = $False;
                        GamingBlockGameCenterFriends                   = $True;
                        GamingBlockMultiplayer                         = $False;
                        GlobalAdminAccount                             = $GlobalAdminAccount;
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
                        SafariRequireFraudWarning                      = $True; # Drift
                        ScreenCaptureBlocked                           = $False;
                        SiriBlocked                                    = $False;
                        SiriBlockedWhenLocked                          = $False;
                        SiriBlockUserGeneratedContent                  = $False;
                        SiriRequireProfanityFilter                     = $False;
                        SpotlightBlockInternetResults                  = $False;
                        VoiceDialingBlocked                            = $False;
                        WallpaperBlockModification                     = $False;
                    }
                }
            }

            Mock -CommandName Get-IntuneDeviceConfigurationPolicy -MockWith {
                return @{
                    displayName = "iOS DSC Created"
                    id          = "12345-12345-12345-12345-12345"
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should update the policy from the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-M365DSCIntuneDeviceConfigurationPolicyiOS -Exactly 1
            }
        }

        Context -Name "When the policy already exists and IS in the Desired State" -Fixture {
            BeforeAll {

                Mock -CommandName Get-IntuneDeviceConfigurationPolicy -MockWith {
                    return @{
                        '@odata.type' = "#microsoft.graph.iosGeneralDeviceConfiguration"
                        displayName   = "iOS DSC Created"
                        id            = "12345-12345-12345-12345-12345"
                    }
                }
                $testParams = @{
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
                    DisplayName                                    = "iOS DSC Created";
                    DocumentsBlockManagedDocumentsInUnmanagedApps  = $False;
                    DocumentsBlockUnmanagedDocumentsInManagedApps  = $False;
                    EmailInDomainSuffixes                          = @();
                    Ensure                                         = "Present";
                    EnterpriseAppBlockTrust                        = $False;
                    EnterpriseAppBlockTrustModification            = $False;
                    FaceTimeBlocked                                = $False;
                    FindMyFriendsBlocked                           = $False;
                    GameCenterBlocked                              = $False;
                    GamingBlockGameCenterFriends                   = $True;
                    GamingBlockMultiplayer                         = $False;
                    GlobalAdminAccount                             = $GlobalAdminAccount;
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
                }

                Mock -CommandName Get-M365DSCIntuneDeviceConfigurationPolicyiOS -MockWith {
                    return @{
                        '@odata.type'                                  = "#microsoft.graph.iosGeneralDeviceConfiguration"
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
                        DisplayName                                    = "iOS DSC Created";
                        DocumentsBlockManagedDocumentsInUnmanagedApps  = $False;
                        DocumentsBlockUnmanagedDocumentsInManagedApps  = $False;
                        EmailInDomainSuffixes                          = @();
                        Ensure                                         = "Present";
                        EnterpriseAppBlockTrust                        = $False;
                        EnterpriseAppBlockTrustModification            = $False;
                        FaceTimeBlocked                                = $False;
                        FindMyFriendsBlocked                           = $False;
                        GameCenterBlocked                              = $False;
                        GamingBlockGameCenterFriends                   = $True;
                        GamingBlockMultiplayer                         = $False;
                        GlobalAdminAccount                             = $GlobalAdminAccount;
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
                    }
                }
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "When the policy exists and it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName        = "iOS DSC Created";
                    Ensure             = 'Absent'
                    GlobalAdminAccount = $GlobalAdminAccount;
                }

                Mock -CommandName Get-IntuneDeviceConfigurationPolicy -MockWith {
                    return @{
                        '@odata.type' = "#microsoft.graph.iosGeneralDeviceConfiguration"
                        displayName   = "iOS DSC Created"
                        id            = "12345-12345-12345-12345-12345"
                    }
                }

                Mock -CommandName Get-M365DSCIntuneDeviceConfigurationPolicyiOS -MockWith {
                    return @{
                        '@odata.type'                                  = "#microsoft.graph.iosGeneralDeviceConfiguration"
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
                        DisplayName                                    = "iOS DSC Created";
                        DocumentsBlockManagedDocumentsInUnmanagedApps  = $False;
                        DocumentsBlockUnmanagedDocumentsInManagedApps  = $False;
                        EmailInDomainSuffixes                          = @();
                        Ensure                                         = "Present";
                        EnterpriseAppBlockTrust                        = $False;
                        EnterpriseAppBlockTrustModification            = $False;
                        FaceTimeBlocked                                = $False;
                        FindMyFriendsBlocked                           = $False;
                        GameCenterBlocked                              = $False;
                        GamingBlockGameCenterFriends                   = $True;
                        GamingBlockMultiplayer                         = $False;
                        GlobalAdminAccount                             = $GlobalAdminAccount;
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
                    }
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should remove the policy from the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-IntuneDeviceConfigurationPolicy -Exactly 1
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount = $GlobalAdminAccount;
                }

                Mock -CommandName Get-IntuneDeviceConfigurationPolicy -MockWith {
                    return @{
                        displayName = "iOS DSC Created"
                        id          = "12345-12345-12345-12345-12345"
                    }
                }

                Mock -CommandName Get-M365DSCIntuneDeviceConfigurationPolicyiOS -MockWith {
                    return @{
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
                        DisplayName                                    = "iOS DSC Created";
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
                    }
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
