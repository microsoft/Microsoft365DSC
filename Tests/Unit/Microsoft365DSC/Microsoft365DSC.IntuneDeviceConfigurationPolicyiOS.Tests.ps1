[CmdletBinding()]
param(
)
$M365DSCTestFolder = Join-Path -Path $PSScriptRoot `
    -ChildPath '..\..\Unit' `
    -Resolve
$CmdletModule = (Join-Path -Path $M365DSCTestFolder `
        -ChildPath '\Stubs\Microsoft365.psm1' `
        -Resolve)
$GenericStubPath = (Join-Path -Path $M365DSCTestFolder `
        -ChildPath '\Stubs\Generic.psm1' `
        -Resolve)
Import-Module -Name (Join-Path -Path $M365DSCTestFolder `
        -ChildPath '\UnitTestHelper.psm1' `
        -Resolve)

$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource 'IntuneDeviceConfigurationPolicyiOS' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString 'test@password1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)


            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-MgBetaDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName New-MgBetaDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName Remove-MgBetaDeviceManagementDeviceConfiguration -MockWith {
            }
            Mock -CommandName Update-DeviceConfigurationPolicyAssignment -MockWith {
            }
            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'The IntuneDeviceConfigurationPolicyIOS should exist but it DOES NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    AccountBlockModification                       = $True
                    ActivationLockAllowWhenSupervised              = $True
                    AirDropBlocked                                 = $True
                    AirDropForceUnmanagedDropTarget                = $True
                    AirPlayForcePairingPasswordForOutgoingRequests = $True
                    AirPrintBlockCredentialsStorage                = $True
                    AirPrintBlocked                                = $True
                    AirPrintBlockiBeaconDiscovery                  = $True
                    AirPrintForceTrustedTLS                        = $True
                    AppClipsBlocked                                = $True
                    AppleNewsBlocked                               = $True
                    ApplePersonalizedAdsBlocked                    = $True
                    AppleWatchBlockPairing                         = $True
                    AppleWatchForceWristDetection                  = $True
                    AppRemovalBlocked                              = $True
                    AppsSingleAppModeList                          = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                            appId       = 'FakeStringValue'
                            publisher   = 'FakeStringValue'
                            appStoreUrl = 'FakeStringValue'
                            name        = 'FakeStringValue'
                            odataType   = '#microsoft.graph.appleAppListItem'

                        } -ClientOnly)
                    )
                    AppStoreBlockAutomaticDownloads                = $True
                    AppStoreBlocked                                = $True
                    AppStoreBlockInAppPurchases                    = $True
                    AppStoreBlockUIAppInstallation                 = $True
                    AppStoreRequirePassword                        = $True
                    AppsVisibilityList                             = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                            appId       = 'FakeStringValue'
                            publisher   = 'FakeStringValue'
                            appStoreUrl = 'FakeStringValue'
                            name        = 'FakeStringValue'
                            odataType   = '#microsoft.graph.appleAppListItem'

                        } -ClientOnly)
                    )
                    AppsVisibilityListType                         = 'none'
                    AutoFillForceAuthentication                    = $True
                    AutoUnlockBlocked                              = $True
                    BlockSystemAppRemoval                          = $True
                    BluetoothBlockModification                     = $True
                    CameraBlocked                                  = $True
                    CellularBlockDataRoaming                       = $True
                    CellularBlockGlobalBackgroundFetchWhileRoaming = $True
                    CellularBlockPerAppDataModification            = $True
                    CellularBlockPersonalHotspot                   = $True
                    CellularBlockPersonalHotspotModification       = $True
                    CellularBlockPlanModification                  = $True
                    CellularBlockVoiceRoaming                      = $True
                    CertificatesBlockUntrustedTlsCertificates      = $True
                    ClassroomAppBlockRemoteScreenObservation       = $True
                    ClassroomAppForceUnpromptedScreenObservation   = $True
                    ClassroomForceAutomaticallyJoinClasses         = $True
                    ClassroomForceRequestPermissionToLeaveClasses  = $True
                    ClassroomForceUnpromptedAppAndDeviceLock       = $True
                    CompliantAppListType                           = 'none'
                    CompliantAppsList                              = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                            appId       = 'FakeStringValue'
                            publisher   = 'FakeStringValue'
                            appStoreUrl = 'FakeStringValue'
                            name        = 'FakeStringValue'
                            odataType   = '#microsoft.graph.appleAppListItem'

                        } -ClientOnly)
                    )
                    ConfigurationProfileBlockChanges               = $True
                    ContactsAllowManagedToUnmanagedWrite           = $True
                    ContactsAllowUnmanagedToManagedRead            = $True
                    ContinuousPathKeyboardBlocked                  = $True
                    DateAndTimeForceSetAutomatically               = $True
                    DefinitionLookupBlocked                        = $True
                    Description                                    = 'FakeStringValue'
                    DeviceBlockEnableRestrictions                  = $True
                    DeviceBlockEraseContentAndSettings             = $True
                    DeviceBlockNameModification                    = $True
                    DiagnosticDataBlockSubmission                  = $True
                    DiagnosticDataBlockSubmissionModification      = $True
                    DisplayName                                    = 'FakeStringValue'
                    DocumentsBlockManagedDocumentsInUnmanagedApps  = $True
                    DocumentsBlockUnmanagedDocumentsInManagedApps  = $True
                    EnterpriseAppBlockTrust                        = $True
                    EnterpriseAppBlockTrustModification            = $True
                    EnterpriseBookBlockBackup                      = $True
                    EnterpriseBookBlockMetadataSync                = $True
                    EsimBlockModification                          = $True
                    FaceTimeBlocked                                = $True
                    FilesNetworkDriveAccessBlocked                 = $True
                    FilesUsbDriveAccessBlocked                     = $True
                    FindMyDeviceInFindMyAppBlocked                 = $True
                    FindMyFriendsBlocked                           = $True
                    FindMyFriendsInFindMyAppBlocked                = $True
                    GameCenterBlocked                              = $True
                    GamingBlockGameCenterFriends                   = $True
                    GamingBlockMultiplayer                         = $True
                    HostPairingBlocked                             = $True
                    IBooksStoreBlocked                             = $True
                    IBooksStoreBlockErotica                        = $True
                    ICloudBlockActivityContinuation                = $True
                    ICloudBlockBackup                              = $True
                    ICloudBlockDocumentSync                        = $True
                    ICloudBlockManagedAppsSync                     = $True
                    ICloudBlockPhotoLibrary                        = $True
                    ICloudBlockPhotoStreamSync                     = $True
                    ICloudBlockSharedPhotoStream                   = $True
                    ICloudPrivateRelayBlocked                      = $True
                    ICloudRequireEncryptedBackup                   = $True
                    Id                                             = 'FakeStringValue'
                    ITunesBlocked                                  = $True
                    ITunesBlockExplicitContent                     = $True
                    ITunesBlockMusicService                        = $True
                    ITunesBlockRadio                               = $True
                    KeyboardBlockAutoCorrect                       = $True
                    KeyboardBlockDictation                         = $True
                    KeyboardBlockPredictive                        = $True
                    KeyboardBlockShortcuts                         = $True
                    KeyboardBlockSpellCheck                        = $True
                    KeychainBlockCloudSync                         = $True
                    KioskModeAllowAssistiveSpeak                   = $True
                    KioskModeAllowAssistiveTouchSettings           = $True
                    KioskModeAllowAutoLock                         = $True
                    KioskModeAllowColorInversionSettings           = $True
                    KioskModeAllowRingerSwitch                     = $True
                    KioskModeAllowScreenRotation                   = $True
                    KioskModeAllowSleepButton                      = $True
                    KioskModeAllowTouchscreen                      = $True
                    KioskModeAllowVoiceControlModification         = $True
                    KioskModeAllowVoiceOverSettings                = $True
                    KioskModeAllowVolumeButtons                    = $True
                    KioskModeAllowZoomSettings                     = $True
                    KioskModeAppStoreUrl                           = 'FakeStringValue'
                    KioskModeAppType                               = 'notConfigured'
                    KioskModeBlockAutoLock                         = $True
                    KioskModeBlockRingerSwitch                     = $True
                    KioskModeBlockScreenRotation                   = $True
                    KioskModeBlockSleepButton                      = $True
                    KioskModeBlockTouchscreen                      = $True
                    KioskModeBlockVolumeButtons                    = $True
                    KioskModeBuiltInAppId                          = 'FakeStringValue'
                    KioskModeEnableVoiceControl                    = $True
                    KioskModeManagedAppId                          = 'FakeStringValue'
                    KioskModeRequireAssistiveTouch                 = $True
                    KioskModeRequireColorInversion                 = $True
                    KioskModeRequireMonoAudio                      = $True
                    KioskModeRequireVoiceOver                      = $True
                    KioskModeRequireZoom                           = $True
                    LockScreenBlockControlCenter                   = $True
                    LockScreenBlockNotificationView                = $True
                    LockScreenBlockPassbook                        = $True
                    LockScreenBlockTodayView                       = $True
                    ManagedPasteboardRequired                      = $True
                    MediaContentRatingApps                         = 'allAllowed'
                    MediaContentRatingAustralia                    = (New-CimInstance -ClassName MSFT_MicrosoftGraphmediacontentratingaustralia -Property @{
                            movieRating = 'allAllowed'
                            tvRating    = 'allAllowed'
                        } -ClientOnly)
                    MediaContentRatingCanada                       = (New-CimInstance -ClassName MSFT_MicrosoftGraphmediacontentratingcanada -Property @{
                            movieRating = 'allAllowed'
                            tvRating    = 'allAllowed'
                        } -ClientOnly)
                    MediaContentRatingFrance                       = (New-CimInstance -ClassName MSFT_MicrosoftGraphmediacontentratingfrance -Property @{
                            movieRating = 'allAllowed'
                            tvRating    = 'allAllowed'
                        } -ClientOnly)
                    MediaContentRatingGermany                      = (New-CimInstance -ClassName MSFT_MicrosoftGraphmediacontentratinggermany -Property @{
                            movieRating = 'allAllowed'
                            tvRating    = 'allAllowed'
                        } -ClientOnly)
                    MediaContentRatingIreland                      = (New-CimInstance -ClassName MSFT_MicrosoftGraphmediacontentratingireland -Property @{
                            movieRating = 'allAllowed'
                            tvRating    = 'allAllowed'
                        } -ClientOnly)
                    MediaContentRatingJapan                        = (New-CimInstance -ClassName MSFT_MicrosoftGraphmediacontentratingjapan -Property @{
                            movieRating = 'allAllowed'
                            tvRating    = 'allAllowed'
                        } -ClientOnly)
                    MediaContentRatingNewZealand                   = (New-CimInstance -ClassName MSFT_MicrosoftGraphmediacontentratingnewzealand -Property @{
                            movieRating = 'allAllowed'
                            tvRating    = 'allAllowed'
                        } -ClientOnly)
                    MediaContentRatingUnitedKingdom                = (New-CimInstance -ClassName MSFT_MicrosoftGraphmediacontentratingunitedkingdom -Property @{
                            movieRating = 'allAllowed'
                            tvRating    = 'allAllowed'
                        } -ClientOnly)
                    MediaContentRatingUnitedStates                 = (New-CimInstance -ClassName MSFT_MicrosoftGraphmediacontentratingunitedstates -Property @{
                            movieRating = 'allAllowed'
                            tvRating    = 'allAllowed'
                        } -ClientOnly)
                    MessagesBlocked                                = $True
                    NetworkUsageRules                              = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphiosnetworkusagerule -Property @{
                            cellularDataBlocked          = $True
                            cellularDataBlockWhenRoaming = $True

                        } -ClientOnly)
                    )
                    NfcBlocked                                     = $True
                    NotificationsBlockSettingsModification         = $True
                    OnDeviceOnlyDictationForced                    = $True
                    OnDeviceOnlyTranslationForced                  = $True
                    PasscodeBlockFingerprintModification           = $True
                    PasscodeBlockFingerprintUnlock                 = $True
                    PasscodeBlockModification                      = $True
                    PasscodeBlockSimple                            = $True
                    PasscodeExpirationDays                         = 25
                    PasscodeMinimumCharacterSetCount               = 25
                    PasscodeMinimumLength                          = 25
                    PasscodeMinutesOfInactivityBeforeLock          = 25
                    PasscodeMinutesOfInactivityBeforeScreenTimeout = 25
                    PasscodePreviousPasscodeBlockCount             = 25
                    PasscodeRequired                               = $True
                    PasscodeRequiredType                           = 'deviceDefault'
                    PasscodeSignInFailureCountBeforeWipe           = 25
                    PasswordBlockAirDropSharing                    = $True
                    PasswordBlockAutoFill                          = $True
                    PasswordBlockProximityRequests                 = $True
                    PkiBlockOTAUpdates                             = $True
                    PodcastsBlocked                                = $True
                    PrivacyForceLimitAdTracking                    = $True
                    ProximityBlockSetupToNewDevice                 = $True
                    SafariBlockAutofill                            = $True
                    SafariBlocked                                  = $True
                    SafariBlockJavaScript                          = $True
                    SafariBlockPopups                              = $True
                    SafariCookieSettings                           = 'browserDefault'
                    SafariRequireFraudWarning                      = $True
                    ScreenCaptureBlocked                           = $True
                    SharedDeviceBlockTemporarySessions             = $True
                    SiriBlocked                                    = $True
                    SiriBlockedWhenLocked                          = $True
                    SiriBlockUserGeneratedContent                  = $True
                    SiriRequireProfanityFilter                     = $True
                    SoftwareUpdatesEnforcedDelayInDays             = 25
                    SoftwareUpdatesForceDelayed                    = $True
                    SpotlightBlockInternetResults                  = $True
                    UnpairedExternalBootToRecoveryAllowed          = $True
                    UsbRestrictedModeBlocked                       = $True
                    VoiceDialingBlocked                            = $True
                    VpnBlockCreation                               = $True
                    WallpaperBlockModification                     = $True
                    WiFiConnectOnlyToConfiguredNetworks            = $True
                    WiFiConnectToAllowedNetworksOnlyForced         = $True
                    WifiPowerOnForced                              = $True

                    Ensure                                         = 'Present'
                    Credential                                     = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return $null
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfigurationAssignment -MockWith {
                    return @()
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should Create the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-MgBetaDeviceManagementDeviceConfiguration -Exactly 1
            }
        }

        Context -Name 'The IntuneDeviceConfigurationPolicyIOS exists but it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    AccountBlockModification                       = $True
                    ActivationLockAllowWhenSupervised              = $True
                    AirDropBlocked                                 = $True
                    AirDropForceUnmanagedDropTarget                = $True
                    AirPlayForcePairingPasswordForOutgoingRequests = $True
                    AirPrintBlockCredentialsStorage                = $True
                    AirPrintBlocked                                = $True
                    AirPrintBlockiBeaconDiscovery                  = $True
                    AirPrintForceTrustedTLS                        = $True
                    AppClipsBlocked                                = $True
                    AppleNewsBlocked                               = $True
                    ApplePersonalizedAdsBlocked                    = $True
                    AppleWatchBlockPairing                         = $True
                    AppleWatchForceWristDetection                  = $True
                    AppRemovalBlocked                              = $True
                    AppsSingleAppModeList                          = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                            appId       = 'FakeStringValue'
                            publisher   = 'FakeStringValue'
                            appStoreUrl = 'FakeStringValue'
                            name        = 'FakeStringValue'
                            odataType   = '#microsoft.graph.appleAppListItem'

                        } -ClientOnly)
                    )
                    AppStoreBlockAutomaticDownloads                = $True
                    AppStoreBlocked                                = $True
                    AppStoreBlockInAppPurchases                    = $True
                    AppStoreBlockUIAppInstallation                 = $True
                    AppStoreRequirePassword                        = $True
                    AppsVisibilityList                             = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                            appId       = 'FakeStringValue'
                            publisher   = 'FakeStringValue'
                            appStoreUrl = 'FakeStringValue'
                            name        = 'FakeStringValue'
                            odataType   = '#microsoft.graph.appleAppListItem'

                        } -ClientOnly)
                    )
                    AppsVisibilityListType                         = 'none'
                    AutoFillForceAuthentication                    = $True
                    AutoUnlockBlocked                              = $True
                    BlockSystemAppRemoval                          = $True
                    BluetoothBlockModification                     = $True
                    CameraBlocked                                  = $True
                    CellularBlockDataRoaming                       = $True
                    CellularBlockGlobalBackgroundFetchWhileRoaming = $True
                    CellularBlockPerAppDataModification            = $True
                    CellularBlockPersonalHotspot                   = $True
                    CellularBlockPersonalHotspotModification       = $True
                    CellularBlockPlanModification                  = $True
                    CellularBlockVoiceRoaming                      = $True
                    CertificatesBlockUntrustedTlsCertificates      = $True
                    ClassroomAppBlockRemoteScreenObservation       = $True
                    ClassroomAppForceUnpromptedScreenObservation   = $True
                    ClassroomForceAutomaticallyJoinClasses         = $True
                    ClassroomForceRequestPermissionToLeaveClasses  = $True
                    ClassroomForceUnpromptedAppAndDeviceLock       = $True
                    CompliantAppListType                           = 'none'
                    CompliantAppsList                              = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                            appId       = 'FakeStringValue'
                            publisher   = 'FakeStringValue'
                            appStoreUrl = 'FakeStringValue'
                            name        = 'FakeStringValue'
                            odataType   = '#microsoft.graph.appleAppListItem'

                        } -ClientOnly)
                    )
                    ConfigurationProfileBlockChanges               = $True
                    ContactsAllowManagedToUnmanagedWrite           = $True
                    ContactsAllowUnmanagedToManagedRead            = $True
                    ContinuousPathKeyboardBlocked                  = $True
                    DateAndTimeForceSetAutomatically               = $True
                    DefinitionLookupBlocked                        = $True
                    Description                                    = 'FakeStringValue'
                    DeviceBlockEnableRestrictions                  = $True
                    DeviceBlockEraseContentAndSettings             = $True
                    DeviceBlockNameModification                    = $True
                    DiagnosticDataBlockSubmission                  = $True
                    DiagnosticDataBlockSubmissionModification      = $True
                    DisplayName                                    = 'FakeStringValue'
                    DocumentsBlockManagedDocumentsInUnmanagedApps  = $True
                    DocumentsBlockUnmanagedDocumentsInManagedApps  = $True
                    EnterpriseAppBlockTrust                        = $True
                    EnterpriseAppBlockTrustModification            = $True
                    EnterpriseBookBlockBackup                      = $True
                    EnterpriseBookBlockMetadataSync                = $True
                    EsimBlockModification                          = $True
                    FaceTimeBlocked                                = $True
                    FilesNetworkDriveAccessBlocked                 = $True
                    FilesUsbDriveAccessBlocked                     = $True
                    FindMyDeviceInFindMyAppBlocked                 = $True
                    FindMyFriendsBlocked                           = $True
                    FindMyFriendsInFindMyAppBlocked                = $True
                    GameCenterBlocked                              = $True
                    GamingBlockGameCenterFriends                   = $True
                    GamingBlockMultiplayer                         = $True
                    HostPairingBlocked                             = $True
                    IBooksStoreBlocked                             = $True
                    IBooksStoreBlockErotica                        = $True
                    ICloudBlockActivityContinuation                = $True
                    ICloudBlockBackup                              = $True
                    ICloudBlockDocumentSync                        = $True
                    ICloudBlockManagedAppsSync                     = $True
                    ICloudBlockPhotoLibrary                        = $True
                    ICloudBlockPhotoStreamSync                     = $True
                    ICloudBlockSharedPhotoStream                   = $True
                    ICloudPrivateRelayBlocked                      = $True
                    ICloudRequireEncryptedBackup                   = $True
                    Id                                             = 'FakeStringValue'
                    ITunesBlocked                                  = $True
                    ITunesBlockExplicitContent                     = $True
                    ITunesBlockMusicService                        = $True
                    ITunesBlockRadio                               = $True
                    KeyboardBlockAutoCorrect                       = $True
                    KeyboardBlockDictation                         = $True
                    KeyboardBlockPredictive                        = $True
                    KeyboardBlockShortcuts                         = $True
                    KeyboardBlockSpellCheck                        = $True
                    KeychainBlockCloudSync                         = $True
                    KioskModeAllowAssistiveSpeak                   = $True
                    KioskModeAllowAssistiveTouchSettings           = $True
                    KioskModeAllowAutoLock                         = $True
                    KioskModeAllowColorInversionSettings           = $True
                    KioskModeAllowRingerSwitch                     = $True
                    KioskModeAllowScreenRotation                   = $True
                    KioskModeAllowSleepButton                      = $True
                    KioskModeAllowTouchscreen                      = $True
                    KioskModeAllowVoiceControlModification         = $True
                    KioskModeAllowVoiceOverSettings                = $True
                    KioskModeAllowVolumeButtons                    = $True
                    KioskModeAllowZoomSettings                     = $True
                    KioskModeAppStoreUrl                           = 'FakeStringValue'
                    KioskModeAppType                               = 'notConfigured'
                    KioskModeBlockAutoLock                         = $True
                    KioskModeBlockRingerSwitch                     = $True
                    KioskModeBlockScreenRotation                   = $True
                    KioskModeBlockSleepButton                      = $True
                    KioskModeBlockTouchscreen                      = $True
                    KioskModeBlockVolumeButtons                    = $True
                    KioskModeBuiltInAppId                          = 'FakeStringValue'
                    KioskModeEnableVoiceControl                    = $True
                    KioskModeManagedAppId                          = 'FakeStringValue'
                    KioskModeRequireAssistiveTouch                 = $True
                    KioskModeRequireColorInversion                 = $True
                    KioskModeRequireMonoAudio                      = $True
                    KioskModeRequireVoiceOver                      = $True
                    KioskModeRequireZoom                           = $True
                    LockScreenBlockControlCenter                   = $True
                    LockScreenBlockNotificationView                = $True
                    LockScreenBlockPassbook                        = $True
                    LockScreenBlockTodayView                       = $True
                    ManagedPasteboardRequired                      = $True
                    MediaContentRatingApps                         = 'allAllowed'
                    MediaContentRatingAustralia                    = (New-CimInstance -ClassName MSFT_MicrosoftGraphmediacontentratingaustralia -Property @{
                            movieRating = 'allAllowed'
                            tvRating    = 'allAllowed'
                        } -ClientOnly)
                    MediaContentRatingCanada                       = (New-CimInstance -ClassName MSFT_MicrosoftGraphmediacontentratingcanada -Property @{
                            movieRating = 'allAllowed'
                            tvRating    = 'allAllowed'
                        } -ClientOnly)
                    MediaContentRatingFrance                       = (New-CimInstance -ClassName MSFT_MicrosoftGraphmediacontentratingfrance -Property @{
                            movieRating = 'allAllowed'
                            tvRating    = 'allAllowed'
                        } -ClientOnly)
                    MediaContentRatingGermany                      = (New-CimInstance -ClassName MSFT_MicrosoftGraphmediacontentratinggermany -Property @{
                            movieRating = 'allAllowed'
                            tvRating    = 'allAllowed'
                        } -ClientOnly)
                    MediaContentRatingIreland                      = (New-CimInstance -ClassName MSFT_MicrosoftGraphmediacontentratingireland -Property @{
                            movieRating = 'allAllowed'
                            tvRating    = 'allAllowed'
                        } -ClientOnly)
                    MediaContentRatingJapan                        = (New-CimInstance -ClassName MSFT_MicrosoftGraphmediacontentratingjapan -Property @{
                            movieRating = 'allAllowed'
                            tvRating    = 'allAllowed'
                        } -ClientOnly)
                    MediaContentRatingNewZealand                   = (New-CimInstance -ClassName MSFT_MicrosoftGraphmediacontentratingnewzealand -Property @{
                            movieRating = 'allAllowed'
                            tvRating    = 'allAllowed'
                        } -ClientOnly)
                    MediaContentRatingUnitedKingdom                = (New-CimInstance -ClassName MSFT_MicrosoftGraphmediacontentratingunitedkingdom -Property @{
                            movieRating = 'allAllowed'
                            tvRating    = 'allAllowed'
                        } -ClientOnly)
                    MediaContentRatingUnitedStates                 = (New-CimInstance -ClassName MSFT_MicrosoftGraphmediacontentratingunitedstates -Property @{
                            movieRating = 'allAllowed'
                            tvRating    = 'allAllowed'
                        } -ClientOnly)
                    MessagesBlocked                                = $True
                    NetworkUsageRules                              = @(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphiosnetworkusagerule -Property @{
                            cellularDataBlocked          = $True
                            cellularDataBlockWhenRoaming = $True

                        } -ClientOnly)
                    )
                    NfcBlocked                                     = $True
                    NotificationsBlockSettingsModification         = $True
                    OnDeviceOnlyDictationForced                    = $True
                    OnDeviceOnlyTranslationForced                  = $True
                    PasscodeBlockFingerprintModification           = $True
                    PasscodeBlockFingerprintUnlock                 = $True
                    PasscodeBlockModification                      = $True
                    PasscodeBlockSimple                            = $True
                    PasscodeExpirationDays                         = 25
                    PasscodeMinimumCharacterSetCount               = 25
                    PasscodeMinimumLength                          = 25
                    PasscodeMinutesOfInactivityBeforeLock          = 25
                    PasscodeMinutesOfInactivityBeforeScreenTimeout = 25
                    PasscodePreviousPasscodeBlockCount             = 25
                    PasscodeRequired                               = $True
                    PasscodeRequiredType                           = 'deviceDefault'
                    PasscodeSignInFailureCountBeforeWipe           = 25
                    PasswordBlockAirDropSharing                    = $True
                    PasswordBlockAutoFill                          = $True
                    PasswordBlockProximityRequests                 = $True
                    PkiBlockOTAUpdates                             = $True
                    PodcastsBlocked                                = $True
                    PrivacyForceLimitAdTracking                    = $True
                    ProximityBlockSetupToNewDevice                 = $True
                    SafariBlockAutofill                            = $True
                    SafariBlocked                                  = $True
                    SafariBlockJavaScript                          = $True
                    SafariBlockPopups                              = $True
                    SafariCookieSettings                           = 'browserDefault'
                    SafariRequireFraudWarning                      = $True
                    ScreenCaptureBlocked                           = $True
                    SharedDeviceBlockTemporarySessions             = $True
                    SiriBlocked                                    = $True
                    SiriBlockedWhenLocked                          = $True
                    SiriBlockUserGeneratedContent                  = $True
                    SiriRequireProfanityFilter                     = $True
                    SoftwareUpdatesEnforcedDelayInDays             = 25
                    SoftwareUpdatesForceDelayed                    = $True
                    SpotlightBlockInternetResults                  = $True
                    UnpairedExternalBootToRecoveryAllowed          = $True
                    UsbRestrictedModeBlocked                       = $True
                    VoiceDialingBlocked                            = $True
                    VpnBlockCreation                               = $True
                    WallpaperBlockModification                     = $True
                    WiFiConnectOnlyToConfiguredNetworks            = $True
                    WiFiConnectToAllowedNetworksOnlyForced         = $True
                    WifiPowerOnForced                              = $True

                    Ensure                                         = 'Absent'
                    Credential                                     = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            FaceTimeBlocked                                = $True
                            KioskModeAllowSleepButton                      = $True
                            MediaContentRatingCanada                       = @{
                                movieRating = 'allAllowed'
                                tvRating    = 'allAllowed'
                            }
                            UnpairedExternalBootToRecoveryAllowed          = $True
                            ICloudBlockPhotoStreamSync                     = $True
                            KeyboardBlockPredictive                        = $True
                            SafariBlockPopups                              = $True
                            GameCenterBlocked                              = $True
                            PasscodeBlockSimple                            = $True
                            ITunesBlocked                                  = $True
                            PasscodeMinimumCharacterSetCount               = 25
                            AppleWatchForceWristDetection                  = $True
                            PasscodeExpirationDays                         = 25
                            EnterpriseAppBlockTrustModification            = $True
                            AirPlayForcePairingPasswordForOutgoingRequests = $True
                            KeyboardBlockAutoCorrect                       = $True
                            ITunesBlockExplicitContent                     = $True
                            IBooksStoreBlockErotica                        = $True
                            KioskModeAllowRingerSwitch                     = $True
                            DocumentsBlockUnmanagedDocumentsInManagedApps  = $True
                            MessagesBlocked                                = $True
                            DeviceBlockEnableRestrictions                  = $True
                            AppStoreBlocked                                = $True
                            SpotlightBlockInternetResults                  = $True
                            KioskModeAppType                               = 'notConfigured'
                            KioskModeAllowVolumeButtons                    = $True
                            VoiceDialingBlocked                            = $True
                            PasscodeMinimumLength                          = 25
                            ICloudBlockSharedPhotoStream                   = $True
                            ActivationLockAllowWhenSupervised              = $True
                            CellularBlockVoiceRoaming                      = $True
                            MediaContentRatingIreland                      = @{
                                movieRating = 'allAllowed'
                                tvRating    = 'allAllowed'
                            }
                            PkiBlockOTAUpdates                             = $True
                            KeyboardBlockDictation                         = $True
                            PasscodeBlockModification                      = $True
                            AutoUnlockBlocked                              = $True
                            PasswordBlockProximityRequests                 = $True
                            MediaContentRatingAustralia                    = @{
                                movieRating = 'allAllowed'
                                tvRating    = 'allAllowed'
                            }
                            ITunesBlockMusicService                        = $True
                            DiagnosticDataBlockSubmissionModification      = $True
                            EnterpriseAppBlockTrust                        = $True
                            ManagedPasteboardRequired                      = $True
                            ProximityBlockSetupToNewDevice                 = $True
                            PasscodeMinutesOfInactivityBeforeScreenTimeout = 25
                            ITunesBlockRadio                               = $True
                            CellularBlockGlobalBackgroundFetchWhileRoaming = $True
                            SiriBlocked                                    = $True
                            MediaContentRatingJapan                        = @{
                                movieRating = 'allAllowed'
                                tvRating    = 'allAllowed'
                            }
                            FindMyFriendsInFindMyAppBlocked                = $True
                            CellularBlockPerAppDataModification            = $True
                            ClassroomForceAutomaticallyJoinClasses         = $True
                            SiriBlockUserGeneratedContent                  = $True
                            MediaContentRatingApps                         = 'allAllowed'
                            SafariCookieSettings                           = 'browserDefault'
                            DeviceBlockNameModification                    = $True
                            WifiPowerOnForced                              = $True
                            ContactsAllowManagedToUnmanagedWrite           = $True
                            AirPrintBlockCredentialsStorage                = $True
                            '@odata.type'                                  = '#microsoft.graph.iosGeneralDeviceConfiguration'
                            KioskModeAllowAssistiveTouchSettings           = $True
                            PasscodeRequiredType                           = 'deviceDefault'
                            PasscodePreviousPasscodeBlockCount             = 25
                            AutoFillForceAuthentication                    = $True
                            CompliantAppListType                           = 'none'
                            ICloudBlockBackup                              = $True
                            KioskModeAllowAutoLock                         = $True
                            LockScreenBlockControlCenter                   = $True
                            EsimBlockModification                          = $True
                            AppleNewsBlocked                               = $True
                            CellularBlockPersonalHotspot                   = $True
                            KioskModeBuiltInAppId                          = 'FakeStringValue'
                            AirPrintForceTrustedTLS                        = $True
                            CameraBlocked                                  = $True
                            SiriRequireProfanityFilter                     = $True
                            PasscodeBlockFingerprintUnlock                 = $True
                            DateAndTimeForceSetAutomatically               = $True
                            KioskModeAllowAssistiveSpeak                   = $True
                            AccountBlockModification                       = $True
                            BlockSystemAppRemoval                          = $True
                            DocumentsBlockManagedDocumentsInUnmanagedApps  = $True
                            FindMyFriendsBlocked                           = $True
                            ICloudBlockManagedAppsSync                     = $True
                            LockScreenBlockTodayView                       = $True
                            BluetoothBlockModification                     = $True
                            KioskModeManagedAppId                          = 'FakeStringValue'
                            SoftwareUpdatesForceDelayed                    = $True
                            ConfigurationProfileBlockChanges               = $True
                            WiFiConnectOnlyToConfiguredNetworks            = $True
                            MediaContentRatingNewZealand                   = @{
                                movieRating = 'allAllowed'
                                tvRating    = 'allAllowed'
                            }
                            KioskModeRequireMonoAudio                      = $True
                            AppStoreRequirePassword                        = $True
                            ICloudBlockDocumentSync                        = $True
                            CellularBlockDataRoaming                       = $True
                            ICloudRequireEncryptedBackup                   = $True
                            ApplePersonalizedAdsBlocked                    = $True
                            KioskModeBlockAutoLock                         = $True
                            ClassroomAppBlockRemoteScreenObservation       = $True
                            PasscodeBlockFingerprintModification           = $True
                            FindMyDeviceInFindMyAppBlocked                 = $True
                            IBooksStoreBlocked                             = $True
                            KioskModeRequireVoiceOver                      = $True
                            KioskModeAllowVoiceOverSettings                = $True
                            AirDropForceUnmanagedDropTarget                = $True
                            SafariBlockAutofill                            = $True
                            PasscodeSignInFailureCountBeforeWipe           = 25
                            ContinuousPathKeyboardBlocked                  = $True
                            KeychainBlockCloudSync                         = $True
                            VpnBlockCreation                               = $True
                            KioskModeAllowVoiceControlModification         = $True
                            MediaContentRatingUnitedStates                 = @{
                                movieRating = 'allAllowed'
                                tvRating    = 'allAllowed'
                            }
                            KioskModeBlockVolumeButtons                    = $True
                            HostPairingBlocked                             = $True
                            AppClipsBlocked                                = $True
                            PasscodeRequired                               = $True
                            AppStoreBlockInAppPurchases                    = $True
                            LockScreenBlockNotificationView                = $True
                            KioskModeBlockSleepButton                      = $True
                            OnDeviceOnlyDictationForced                    = $True
                            NetworkUsageRules                              = @(
                                @{
                                    cellularDataBlocked          = $True
                                    cellularDataBlockWhenRoaming = $True

                                }
                            )
                            ICloudBlockActivityContinuation                = $True
                            SoftwareUpdatesEnforcedDelayInDays             = 25
                            AppsSingleAppModeList                          = @(
                                @{
                                    name          = 'FakeStringValue'
                                    appId         = 'FakeStringValue'
                                    appStoreUrl   = 'FakeStringValue'
                                    '@odata.type' = '#microsoft.graph.appleAppListItem'
                                    publisher     = 'FakeStringValue'

                                }
                            )
                            ICloudBlockPhotoLibrary                        = $True
                            PrivacyForceLimitAdTracking                    = $True
                            MediaContentRatingGermany                      = @{
                                movieRating = 'allAllowed'
                                tvRating    = 'allAllowed'
                            }
                            KeyboardBlockShortcuts                         = $True
                            OnDeviceOnlyTranslationForced                  = $True
                            FilesUsbDriveAccessBlocked                     = $True
                            AppStoreBlockAutomaticDownloads                = $True
                            KioskModeRequireColorInversion                 = $True
                            SharedDeviceBlockTemporarySessions             = $True
                            GamingBlockGameCenterFriends                   = $True
                            EnterpriseBookBlockBackup                      = $True
                            EnterpriseBookBlockMetadataSync                = $True
                            AirDropBlocked                                 = $True
                            KioskModeBlockRingerSwitch                     = $True
                            KioskModeEnableVoiceControl                    = $True
                            MediaContentRatingUnitedKingdom                = @{
                                movieRating = 'allAllowed'
                                tvRating    = 'allAllowed'
                            }
                            CellularBlockPlanModification                  = $True
                            AirPrintBlocked                                = $True
                            KioskModeAllowZoomSettings                     = $True
                            AppRemovalBlocked                              = $True
                            ICloudPrivateRelayBlocked                      = $True
                            PodcastsBlocked                                = $True
                            WallpaperBlockModification                     = $True
                            ClassroomForceRequestPermissionToLeaveClasses  = $True
                            AppsVisibilityList                             = @(
                                @{
                                    name          = 'FakeStringValue'
                                    appId         = 'FakeStringValue'
                                    appStoreUrl   = 'FakeStringValue'
                                    '@odata.type' = '#microsoft.graph.appleAppListItem'
                                    publisher     = 'FakeStringValue'

                                }
                            )
                            SiriBlockedWhenLocked                          = $True
                            MediaContentRatingFrance                       = @{
                                movieRating = 'allAllowed'
                                tvRating    = 'allAllowed'
                            }
                            DefinitionLookupBlocked                        = $True
                            SafariBlockJavaScript                          = $True
                            AppsVisibilityListType                         = 'none'
                            AppleWatchBlockPairing                         = $True
                            KioskModeAppStoreUrl                           = 'FakeStringValue'
                            NfcBlocked                                     = $True
                            LockScreenBlockPassbook                        = $True
                            PasswordBlockAutoFill                          = $True
                            CompliantAppsList                              = @(
                                @{
                                    name          = 'FakeStringValue'
                                    appId         = 'FakeStringValue'
                                    appStoreUrl   = 'FakeStringValue'
                                    '@odata.type' = '#microsoft.graph.appleAppListItem'
                                    publisher     = 'FakeStringValue'

                                }
                            )
                            AirPrintBlockiBeaconDiscovery                  = $True
                            ScreenCaptureBlocked                           = $True
                            KioskModeAllowTouchscreen                      = $True
                            ContactsAllowUnmanagedToManagedRead            = $True
                            KioskModeBlockTouchscreen                      = $True
                            UsbRestrictedModeBlocked                       = $True
                            DeviceBlockEraseContentAndSettings             = $True
                            PasswordBlockAirDropSharing                    = $True
                            CellularBlockPersonalHotspotModification       = $True
                            NotificationsBlockSettingsModification         = $True
                            SafariBlocked                                  = $True
                            CertificatesBlockUntrustedTlsCertificates      = $True
                            FilesNetworkDriveAccessBlocked                 = $True
                            KeyboardBlockSpellCheck                        = $True
                            ClassroomAppForceUnpromptedScreenObservation   = $True
                            ClassroomForceUnpromptedAppAndDeviceLock       = $True
                            KioskModeAllowScreenRotation                   = $True
                            KioskModeAllowColorInversionSettings           = $True
                            PasscodeMinutesOfInactivityBeforeLock          = 25
                            DiagnosticDataBlockSubmission                  = $True
                            GamingBlockMultiplayer                         = $True
                            SafariRequireFraudWarning                      = $True
                            KioskModeRequireAssistiveTouch                 = $True
                            AppStoreBlockUIAppInstallation                 = $True
                            KioskModeBlockScreenRotation                   = $True
                            WiFiConnectToAllowedNetworksOnlyForced         = $True
                            KioskModeRequireZoom                           = $True

                        }
                        Description          = 'FakeStringValue'
                        DisplayName          = 'FakeStringValue'
                        Id                   = 'FakeStringValue'

                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfigurationAssignment -MockWith {
                    return @()
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgBetaDeviceManagementDeviceConfiguration -Exactly 1
            }
        }
        Context -Name 'The IntuneDeviceConfigurationPolicyIOS Exists and Values are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    AccountBlockModification                       = $True
                    ActivationLockAllowWhenSupervised              = $True
                    AirDropBlocked                                 = $True
                    AirDropForceUnmanagedDropTarget                = $True
                    AirPlayForcePairingPasswordForOutgoingRequests = $True
                    AirPrintBlockCredentialsStorage                = $True
                    AirPrintBlocked                                = $True
                    AirPrintBlockiBeaconDiscovery                  = $True
                    AirPrintForceTrustedTLS                        = $True
                    AppClipsBlocked                                = $True
                    AppleNewsBlocked                               = $True
                    ApplePersonalizedAdsBlocked                    = $True
                    AppleWatchBlockPairing                         = $True
                    AppleWatchForceWristDetection                  = $True
                    AppRemovalBlocked                              = $True
                    AppsSingleAppModeList                          = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                            appId       = 'FakeStringValue'
                            publisher   = 'FakeStringValue'
                            appStoreUrl = 'FakeStringValue'
                            name        = 'FakeStringValue'
                            odataType   = '#microsoft.graph.appleAppListItem'

                        } -ClientOnly)
                    )
                    AppStoreBlockAutomaticDownloads                = $True
                    AppStoreBlocked                                = $True
                    AppStoreBlockInAppPurchases                    = $True
                    AppStoreBlockUIAppInstallation                 = $True
                    AppStoreRequirePassword                        = $True
                    AppsVisibilityList                             = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                            appId       = 'FakeStringValue'
                            publisher   = 'FakeStringValue'
                            appStoreUrl = 'FakeStringValue'
                            name        = 'FakeStringValue'
                            odataType   = '#microsoft.graph.appleAppListItem'

                        } -ClientOnly)
                    )
                    AppsVisibilityListType                         = 'none'
                    AutoFillForceAuthentication                    = $True
                    AutoUnlockBlocked                              = $True
                    BlockSystemAppRemoval                          = $True
                    BluetoothBlockModification                     = $True
                    CameraBlocked                                  = $True
                    CellularBlockDataRoaming                       = $True
                    CellularBlockGlobalBackgroundFetchWhileRoaming = $True
                    CellularBlockPerAppDataModification            = $True
                    CellularBlockPersonalHotspot                   = $True
                    CellularBlockPersonalHotspotModification       = $True
                    CellularBlockPlanModification                  = $True
                    CellularBlockVoiceRoaming                      = $True
                    CertificatesBlockUntrustedTlsCertificates      = $True
                    ClassroomAppBlockRemoteScreenObservation       = $True
                    ClassroomAppForceUnpromptedScreenObservation   = $True
                    ClassroomForceAutomaticallyJoinClasses         = $True
                    ClassroomForceRequestPermissionToLeaveClasses  = $True
                    ClassroomForceUnpromptedAppAndDeviceLock       = $True
                    CompliantAppListType                           = 'none'
                    CompliantAppsList                              = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                            appId       = 'FakeStringValue'
                            publisher   = 'FakeStringValue'
                            appStoreUrl = 'FakeStringValue'
                            name        = 'FakeStringValue'
                            odataType   = '#microsoft.graph.appleAppListItem'

                        } -ClientOnly)
                    )
                    ConfigurationProfileBlockChanges               = $True
                    ContactsAllowManagedToUnmanagedWrite           = $True
                    ContactsAllowUnmanagedToManagedRead            = $True
                    ContinuousPathKeyboardBlocked                  = $True
                    DateAndTimeForceSetAutomatically               = $True
                    DefinitionLookupBlocked                        = $True
                    Description                                    = 'FakeStringValue'
                    DeviceBlockEnableRestrictions                  = $True
                    DeviceBlockEraseContentAndSettings             = $True
                    DeviceBlockNameModification                    = $True
                    DiagnosticDataBlockSubmission                  = $True
                    DiagnosticDataBlockSubmissionModification      = $True
                    DisplayName                                    = 'FakeStringValue'
                    DocumentsBlockManagedDocumentsInUnmanagedApps  = $True
                    DocumentsBlockUnmanagedDocumentsInManagedApps  = $True
                    EnterpriseAppBlockTrust                        = $True
                    EnterpriseAppBlockTrustModification            = $True
                    EnterpriseBookBlockBackup                      = $True
                    EnterpriseBookBlockMetadataSync                = $True
                    EsimBlockModification                          = $True
                    FaceTimeBlocked                                = $True
                    FilesNetworkDriveAccessBlocked                 = $True
                    FilesUsbDriveAccessBlocked                     = $True
                    FindMyDeviceInFindMyAppBlocked                 = $True
                    FindMyFriendsBlocked                           = $True
                    FindMyFriendsInFindMyAppBlocked                = $True
                    GameCenterBlocked                              = $True
                    GamingBlockGameCenterFriends                   = $True
                    GamingBlockMultiplayer                         = $True
                    HostPairingBlocked                             = $True
                    IBooksStoreBlocked                             = $True
                    IBooksStoreBlockErotica                        = $True
                    ICloudBlockActivityContinuation                = $True
                    ICloudBlockBackup                              = $True
                    ICloudBlockDocumentSync                        = $True
                    ICloudBlockManagedAppsSync                     = $True
                    ICloudBlockPhotoLibrary                        = $True
                    ICloudBlockPhotoStreamSync                     = $True
                    ICloudBlockSharedPhotoStream                   = $True
                    ICloudPrivateRelayBlocked                      = $True
                    ICloudRequireEncryptedBackup                   = $True
                    Id                                             = 'FakeStringValue'
                    ITunesBlocked                                  = $True
                    ITunesBlockExplicitContent                     = $True
                    ITunesBlockMusicService                        = $True
                    ITunesBlockRadio                               = $True
                    KeyboardBlockAutoCorrect                       = $True
                    KeyboardBlockDictation                         = $True
                    KeyboardBlockPredictive                        = $True
                    KeyboardBlockShortcuts                         = $True
                    KeyboardBlockSpellCheck                        = $True
                    KeychainBlockCloudSync                         = $True
                    KioskModeAllowAssistiveSpeak                   = $True
                    KioskModeAllowAssistiveTouchSettings           = $True
                    KioskModeAllowAutoLock                         = $True
                    KioskModeAllowColorInversionSettings           = $True
                    KioskModeAllowRingerSwitch                     = $True
                    KioskModeAllowScreenRotation                   = $True
                    KioskModeAllowSleepButton                      = $True
                    KioskModeAllowTouchscreen                      = $True
                    KioskModeAllowVoiceControlModification         = $True
                    KioskModeAllowVoiceOverSettings                = $True
                    KioskModeAllowVolumeButtons                    = $True
                    KioskModeAllowZoomSettings                     = $True
                    KioskModeAppStoreUrl                           = 'FakeStringValue'
                    KioskModeAppType                               = 'notConfigured'
                    KioskModeBlockAutoLock                         = $True
                    KioskModeBlockRingerSwitch                     = $True
                    KioskModeBlockScreenRotation                   = $True
                    KioskModeBlockSleepButton                      = $True
                    KioskModeBlockTouchscreen                      = $True
                    KioskModeBlockVolumeButtons                    = $True
                    KioskModeBuiltInAppId                          = 'FakeStringValue'
                    KioskModeEnableVoiceControl                    = $True
                    KioskModeManagedAppId                          = 'FakeStringValue'
                    KioskModeRequireAssistiveTouch                 = $True
                    KioskModeRequireColorInversion                 = $True
                    KioskModeRequireMonoAudio                      = $True
                    KioskModeRequireVoiceOver                      = $True
                    KioskModeRequireZoom                           = $True
                    LockScreenBlockControlCenter                   = $True
                    LockScreenBlockNotificationView                = $True
                    LockScreenBlockPassbook                        = $True
                    LockScreenBlockTodayView                       = $True
                    ManagedPasteboardRequired                      = $True
                    MediaContentRatingApps                         = 'allAllowed'
                    MediaContentRatingAustralia                    = (New-CimInstance -ClassName MSFT_MicrosoftGraphmediacontentratingaustralia -Property @{
                            movieRating = 'allAllowed'
                            tvRating    = 'allAllowed'
                        } -ClientOnly)
                    MediaContentRatingCanada                       = (New-CimInstance -ClassName MSFT_MicrosoftGraphmediacontentratingcanada -Property @{
                            movieRating = 'allAllowed'
                            tvRating    = 'allAllowed'
                        } -ClientOnly)
                    MediaContentRatingFrance                       = (New-CimInstance -ClassName MSFT_MicrosoftGraphmediacontentratingfrance -Property @{
                            movieRating = 'allAllowed'
                            tvRating    = 'allAllowed'
                        } -ClientOnly)
                    MediaContentRatingGermany                      = (New-CimInstance -ClassName MSFT_MicrosoftGraphmediacontentratinggermany -Property @{
                            movieRating = 'allAllowed'
                            tvRating    = 'allAllowed'
                        } -ClientOnly)
                    MediaContentRatingIreland                      = (New-CimInstance -ClassName MSFT_MicrosoftGraphmediacontentratingireland -Property @{
                            movieRating = 'allAllowed'
                            tvRating    = 'allAllowed'
                        } -ClientOnly)
                    MediaContentRatingJapan                        = (New-CimInstance -ClassName MSFT_MicrosoftGraphmediacontentratingjapan -Property @{
                            movieRating = 'allAllowed'
                            tvRating    = 'allAllowed'
                        } -ClientOnly)
                    MediaContentRatingNewZealand                   = (New-CimInstance -ClassName MSFT_MicrosoftGraphmediacontentratingnewzealand -Property @{
                            movieRating = 'allAllowed'
                            tvRating    = 'allAllowed'
                        } -ClientOnly)
                    MediaContentRatingUnitedKingdom                = (New-CimInstance -ClassName MSFT_MicrosoftGraphmediacontentratingunitedkingdom -Property @{
                            movieRating = 'allAllowed'
                            tvRating    = 'allAllowed'
                        } -ClientOnly)
                    MediaContentRatingUnitedStates                 = (New-CimInstance -ClassName MSFT_MicrosoftGraphmediacontentratingunitedstates -Property @{
                            movieRating = 'allAllowed'
                            tvRating    = 'allAllowed'
                        } -ClientOnly)
                    MessagesBlocked                                = $True
                    NetworkUsageRules                              = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphiosnetworkusagerule -Property @{
                            cellularDataBlocked          = $True
                            cellularDataBlockWhenRoaming = $True

                        } -ClientOnly)
                    )
                    NfcBlocked                                     = $True
                    NotificationsBlockSettingsModification         = $True
                    OnDeviceOnlyDictationForced                    = $True
                    OnDeviceOnlyTranslationForced                  = $True
                    PasscodeBlockFingerprintModification           = $True
                    PasscodeBlockFingerprintUnlock                 = $True
                    PasscodeBlockModification                      = $True
                    PasscodeBlockSimple                            = $True
                    PasscodeExpirationDays                         = 25
                    PasscodeMinimumCharacterSetCount               = 25
                    PasscodeMinimumLength                          = 25
                    PasscodeMinutesOfInactivityBeforeLock          = 25
                    PasscodeMinutesOfInactivityBeforeScreenTimeout = 25
                    PasscodePreviousPasscodeBlockCount             = 25
                    PasscodeRequired                               = $True
                    PasscodeRequiredType                           = 'deviceDefault'
                    PasscodeSignInFailureCountBeforeWipe           = 25
                    PasswordBlockAirDropSharing                    = $True
                    PasswordBlockAutoFill                          = $True
                    PasswordBlockProximityRequests                 = $True
                    PkiBlockOTAUpdates                             = $True
                    PodcastsBlocked                                = $True
                    PrivacyForceLimitAdTracking                    = $True
                    ProximityBlockSetupToNewDevice                 = $True
                    SafariBlockAutofill                            = $True
                    SafariBlocked                                  = $True
                    SafariBlockJavaScript                          = $True
                    SafariBlockPopups                              = $True
                    SafariCookieSettings                           = 'browserDefault'
                    SafariRequireFraudWarning                      = $True
                    ScreenCaptureBlocked                           = $True
                    SharedDeviceBlockTemporarySessions             = $True
                    SiriBlocked                                    = $True
                    SiriBlockedWhenLocked                          = $True
                    SiriBlockUserGeneratedContent                  = $True
                    SiriRequireProfanityFilter                     = $True
                    SoftwareUpdatesEnforcedDelayInDays             = 25
                    SoftwareUpdatesForceDelayed                    = $True
                    SpotlightBlockInternetResults                  = $True
                    UnpairedExternalBootToRecoveryAllowed          = $True
                    UsbRestrictedModeBlocked                       = $True
                    VoiceDialingBlocked                            = $True
                    VpnBlockCreation                               = $True
                    WallpaperBlockModification                     = $True
                    WiFiConnectOnlyToConfiguredNetworks            = $True
                    WiFiConnectToAllowedNetworksOnlyForced         = $True
                    WifiPowerOnForced                              = $True

                    Ensure                                         = 'Present'
                    Credential                                     = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            FaceTimeBlocked                                = $True
                            KioskModeAllowSleepButton                      = $True
                            MediaContentRatingCanada                       = @{
                                movieRating = 'allAllowed'
                                tvRating    = 'allAllowed'
                            }
                            UnpairedExternalBootToRecoveryAllowed          = $True
                            ICloudBlockPhotoStreamSync                     = $True
                            KeyboardBlockPredictive                        = $True
                            SafariBlockPopups                              = $True
                            GameCenterBlocked                              = $True
                            PasscodeBlockSimple                            = $True
                            ITunesBlocked                                  = $True
                            PasscodeMinimumCharacterSetCount               = 25
                            AppleWatchForceWristDetection                  = $True
                            PasscodeExpirationDays                         = 25
                            EnterpriseAppBlockTrustModification            = $True
                            AirPlayForcePairingPasswordForOutgoingRequests = $True
                            KeyboardBlockAutoCorrect                       = $True
                            ITunesBlockExplicitContent                     = $True
                            IBooksStoreBlockErotica                        = $True
                            KioskModeAllowRingerSwitch                     = $True
                            DocumentsBlockUnmanagedDocumentsInManagedApps  = $True
                            MessagesBlocked                                = $True
                            DeviceBlockEnableRestrictions                  = $True
                            AppStoreBlocked                                = $True
                            SpotlightBlockInternetResults                  = $True
                            KioskModeAppType                               = 'notConfigured'
                            KioskModeAllowVolumeButtons                    = $True
                            VoiceDialingBlocked                            = $True
                            PasscodeMinimumLength                          = 25
                            ICloudBlockSharedPhotoStream                   = $True
                            ActivationLockAllowWhenSupervised              = $True
                            CellularBlockVoiceRoaming                      = $True
                            MediaContentRatingIreland                      = @{
                                movieRating = 'allAllowed'
                                tvRating    = 'allAllowed'
                            }
                            PkiBlockOTAUpdates                             = $True
                            KeyboardBlockDictation                         = $True
                            PasscodeBlockModification                      = $True
                            AutoUnlockBlocked                              = $True
                            PasswordBlockProximityRequests                 = $True
                            MediaContentRatingAustralia                    = @{
                                movieRating = 'allAllowed'
                                tvRating    = 'allAllowed'
                            }
                            ITunesBlockMusicService                        = $True
                            DiagnosticDataBlockSubmissionModification      = $True
                            EnterpriseAppBlockTrust                        = $True
                            ManagedPasteboardRequired                      = $True
                            ProximityBlockSetupToNewDevice                 = $True
                            PasscodeMinutesOfInactivityBeforeScreenTimeout = 25
                            ITunesBlockRadio                               = $True
                            CellularBlockGlobalBackgroundFetchWhileRoaming = $True
                            SiriBlocked                                    = $True
                            MediaContentRatingJapan                        = @{
                                movieRating = 'allAllowed'
                                tvRating    = 'allAllowed'
                            }
                            FindMyFriendsInFindMyAppBlocked                = $True
                            CellularBlockPerAppDataModification            = $True
                            ClassroomForceAutomaticallyJoinClasses         = $True
                            SiriBlockUserGeneratedContent                  = $True
                            MediaContentRatingApps                         = 'allAllowed'
                            SafariCookieSettings                           = 'browserDefault'
                            DeviceBlockNameModification                    = $True
                            WifiPowerOnForced                              = $True
                            ContactsAllowManagedToUnmanagedWrite           = $True
                            AirPrintBlockCredentialsStorage                = $True
                            '@odata.type'                                  = '#microsoft.graph.iosGeneralDeviceConfiguration'
                            KioskModeAllowAssistiveTouchSettings           = $True
                            PasscodeRequiredType                           = 'deviceDefault'
                            PasscodePreviousPasscodeBlockCount             = 25
                            AutoFillForceAuthentication                    = $True
                            CompliantAppListType                           = 'none'
                            ICloudBlockBackup                              = $True
                            KioskModeAllowAutoLock                         = $True
                            LockScreenBlockControlCenter                   = $True
                            EsimBlockModification                          = $True
                            AppleNewsBlocked                               = $True
                            CellularBlockPersonalHotspot                   = $True
                            KioskModeBuiltInAppId                          = 'FakeStringValue'
                            AirPrintForceTrustedTLS                        = $True
                            CameraBlocked                                  = $True
                            SiriRequireProfanityFilter                     = $True
                            PasscodeBlockFingerprintUnlock                 = $True
                            DateAndTimeForceSetAutomatically               = $True
                            KioskModeAllowAssistiveSpeak                   = $True
                            AccountBlockModification                       = $True
                            BlockSystemAppRemoval                          = $True
                            DocumentsBlockManagedDocumentsInUnmanagedApps  = $True
                            FindMyFriendsBlocked                           = $True
                            ICloudBlockManagedAppsSync                     = $True
                            LockScreenBlockTodayView                       = $True
                            BluetoothBlockModification                     = $True
                            KioskModeManagedAppId                          = 'FakeStringValue'
                            SoftwareUpdatesForceDelayed                    = $True
                            ConfigurationProfileBlockChanges               = $True
                            WiFiConnectOnlyToConfiguredNetworks            = $True
                            MediaContentRatingNewZealand                   = @{
                                movieRating = 'allAllowed'
                                tvRating    = 'allAllowed'
                            }
                            KioskModeRequireMonoAudio                      = $True
                            AppStoreRequirePassword                        = $True
                            ICloudBlockDocumentSync                        = $True
                            CellularBlockDataRoaming                       = $True
                            ICloudRequireEncryptedBackup                   = $True
                            ApplePersonalizedAdsBlocked                    = $True
                            KioskModeBlockAutoLock                         = $True
                            ClassroomAppBlockRemoteScreenObservation       = $True
                            PasscodeBlockFingerprintModification           = $True
                            FindMyDeviceInFindMyAppBlocked                 = $True
                            IBooksStoreBlocked                             = $True
                            KioskModeRequireVoiceOver                      = $True
                            KioskModeAllowVoiceOverSettings                = $True
                            AirDropForceUnmanagedDropTarget                = $True
                            SafariBlockAutofill                            = $True
                            PasscodeSignInFailureCountBeforeWipe           = 25
                            ContinuousPathKeyboardBlocked                  = $True
                            KeychainBlockCloudSync                         = $True
                            VpnBlockCreation                               = $True
                            KioskModeAllowVoiceControlModification         = $True
                            MediaContentRatingUnitedStates                 = @{
                                movieRating = 'allAllowed'
                                tvRating    = 'allAllowed'
                            }
                            KioskModeBlockVolumeButtons                    = $True
                            HostPairingBlocked                             = $True
                            AppClipsBlocked                                = $True
                            PasscodeRequired                               = $True
                            AppStoreBlockInAppPurchases                    = $True
                            LockScreenBlockNotificationView                = $True
                            KioskModeBlockSleepButton                      = $True
                            OnDeviceOnlyDictationForced                    = $True
                            NetworkUsageRules                              = @(
                                @{
                                    cellularDataBlocked          = $True
                                    cellularDataBlockWhenRoaming = $True

                                }
                            )
                            ICloudBlockActivityContinuation                = $True
                            SoftwareUpdatesEnforcedDelayInDays             = 25
                            AppsSingleAppModeList                          = @(
                                @{
                                    name          = 'FakeStringValue'
                                    appId         = 'FakeStringValue'
                                    appStoreUrl   = 'FakeStringValue'
                                    '@odata.type' = '#microsoft.graph.appleAppListItem'
                                    publisher     = 'FakeStringValue'

                                }
                            )
                            ICloudBlockPhotoLibrary                        = $True
                            PrivacyForceLimitAdTracking                    = $True
                            MediaContentRatingGermany                      = @{
                                movieRating = 'allAllowed'
                                tvRating    = 'allAllowed'
                            }
                            KeyboardBlockShortcuts                         = $True
                            OnDeviceOnlyTranslationForced                  = $True
                            FilesUsbDriveAccessBlocked                     = $True
                            AppStoreBlockAutomaticDownloads                = $True
                            KioskModeRequireColorInversion                 = $True
                            SharedDeviceBlockTemporarySessions             = $True
                            GamingBlockGameCenterFriends                   = $True
                            EnterpriseBookBlockBackup                      = $True
                            EnterpriseBookBlockMetadataSync                = $True
                            AirDropBlocked                                 = $True
                            KioskModeBlockRingerSwitch                     = $True
                            KioskModeEnableVoiceControl                    = $True
                            MediaContentRatingUnitedKingdom                = @{
                                movieRating = 'allAllowed'
                                tvRating    = 'allAllowed'
                            }
                            CellularBlockPlanModification                  = $True
                            AirPrintBlocked                                = $True
                            KioskModeAllowZoomSettings                     = $True
                            AppRemovalBlocked                              = $True
                            ICloudPrivateRelayBlocked                      = $True
                            PodcastsBlocked                                = $True
                            WallpaperBlockModification                     = $True
                            ClassroomForceRequestPermissionToLeaveClasses  = $True
                            AppsVisibilityList                             = @(
                                @{
                                    name          = 'FakeStringValue'
                                    appId         = 'FakeStringValue'
                                    appStoreUrl   = 'FakeStringValue'
                                    '@odata.type' = '#microsoft.graph.appleAppListItem'
                                    publisher     = 'FakeStringValue'

                                }
                            )
                            SiriBlockedWhenLocked                          = $True
                            MediaContentRatingFrance                       = @{
                                movieRating = 'allAllowed'
                                tvRating    = 'allAllowed'
                            }
                            DefinitionLookupBlocked                        = $True
                            SafariBlockJavaScript                          = $True
                            AppsVisibilityListType                         = 'none'
                            AppleWatchBlockPairing                         = $True
                            KioskModeAppStoreUrl                           = 'FakeStringValue'
                            NfcBlocked                                     = $True
                            LockScreenBlockPassbook                        = $True
                            PasswordBlockAutoFill                          = $True
                            CompliantAppsList                              = @(
                                @{
                                    name          = 'FakeStringValue'
                                    appId         = 'FakeStringValue'
                                    appStoreUrl   = 'FakeStringValue'
                                    '@odata.type' = '#microsoft.graph.appleAppListItem'
                                    publisher     = 'FakeStringValue'

                                }
                            )
                            AirPrintBlockiBeaconDiscovery                  = $True
                            ScreenCaptureBlocked                           = $True
                            KioskModeAllowTouchscreen                      = $True
                            ContactsAllowUnmanagedToManagedRead            = $True
                            KioskModeBlockTouchscreen                      = $True
                            UsbRestrictedModeBlocked                       = $True
                            DeviceBlockEraseContentAndSettings             = $True
                            PasswordBlockAirDropSharing                    = $True
                            CellularBlockPersonalHotspotModification       = $True
                            NotificationsBlockSettingsModification         = $True
                            SafariBlocked                                  = $True
                            CertificatesBlockUntrustedTlsCertificates      = $True
                            FilesNetworkDriveAccessBlocked                 = $True
                            KeyboardBlockSpellCheck                        = $True
                            ClassroomAppForceUnpromptedScreenObservation   = $True
                            ClassroomForceUnpromptedAppAndDeviceLock       = $True
                            KioskModeAllowScreenRotation                   = $True
                            KioskModeAllowColorInversionSettings           = $True
                            PasscodeMinutesOfInactivityBeforeLock          = 25
                            DiagnosticDataBlockSubmission                  = $True
                            GamingBlockMultiplayer                         = $True
                            SafariRequireFraudWarning                      = $True
                            KioskModeRequireAssistiveTouch                 = $True
                            AppStoreBlockUIAppInstallation                 = $True
                            KioskModeBlockScreenRotation                   = $True
                            WiFiConnectToAllowedNetworksOnlyForced         = $True
                            KioskModeRequireZoom                           = $True

                        }
                        Description          = 'FakeStringValue'
                        DisplayName          = 'FakeStringValue'
                        Id                   = 'FakeStringValue'

                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfigurationAssignment -MockWith {
                    return @()
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'The IntuneDeviceConfigurationPolicyIOS exists and values are NOT in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    AccountBlockModification                       = $True
                    ActivationLockAllowWhenSupervised              = $True
                    AirDropBlocked                                 = $True
                    AirDropForceUnmanagedDropTarget                = $True
                    AirPlayForcePairingPasswordForOutgoingRequests = $True
                    AirPrintBlockCredentialsStorage                = $True
                    AirPrintBlocked                                = $True
                    AirPrintBlockiBeaconDiscovery                  = $True
                    AirPrintForceTrustedTLS                        = $True
                    AppClipsBlocked                                = $True
                    AppleNewsBlocked                               = $True
                    ApplePersonalizedAdsBlocked                    = $True
                    AppleWatchBlockPairing                         = $True
                    AppleWatchForceWristDetection                  = $True
                    AppRemovalBlocked                              = $True
                    AppsSingleAppModeList                          = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                            appId       = 'FakeStringValue'
                            publisher   = 'FakeStringValue'
                            appStoreUrl = 'FakeStringValue'
                            name        = 'FakeStringValue'
                            odataType   = '#microsoft.graph.appleAppListItem'

                        } -ClientOnly)
                    )
                    AppStoreBlockAutomaticDownloads                = $True
                    AppStoreBlocked                                = $True
                    AppStoreBlockInAppPurchases                    = $True
                    AppStoreBlockUIAppInstallation                 = $True
                    AppStoreRequirePassword                        = $True
                    AppsVisibilityList                             = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                            appId       = 'FakeStringValue'
                            publisher   = 'FakeStringValue'
                            appStoreUrl = 'FakeStringValue'
                            name        = 'FakeStringValue'
                            odataType   = '#microsoft.graph.appleAppListItem'

                        } -ClientOnly)
                    )
                    AppsVisibilityListType                         = 'none'
                    AutoFillForceAuthentication                    = $True
                    AutoUnlockBlocked                              = $True
                    BlockSystemAppRemoval                          = $True
                    BluetoothBlockModification                     = $True
                    CameraBlocked                                  = $True
                    CellularBlockDataRoaming                       = $True
                    CellularBlockGlobalBackgroundFetchWhileRoaming = $True
                    CellularBlockPerAppDataModification            = $True
                    CellularBlockPersonalHotspot                   = $True
                    CellularBlockPersonalHotspotModification       = $True
                    CellularBlockPlanModification                  = $True
                    CellularBlockVoiceRoaming                      = $True
                    CertificatesBlockUntrustedTlsCertificates      = $True
                    ClassroomAppBlockRemoteScreenObservation       = $True
                    ClassroomAppForceUnpromptedScreenObservation   = $True
                    ClassroomForceAutomaticallyJoinClasses         = $True
                    ClassroomForceRequestPermissionToLeaveClasses  = $True
                    ClassroomForceUnpromptedAppAndDeviceLock       = $True
                    CompliantAppListType                           = 'none'
                    CompliantAppsList                              = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                            appId       = 'FakeStringValue'
                            publisher   = 'FakeStringValue'
                            appStoreUrl = 'FakeStringValue'
                            name        = 'FakeStringValue'
                            odataType   = '#microsoft.graph.appleAppListItem'

                        } -ClientOnly)
                    )
                    ConfigurationProfileBlockChanges               = $True
                    ContactsAllowManagedToUnmanagedWrite           = $True
                    ContactsAllowUnmanagedToManagedRead            = $True
                    ContinuousPathKeyboardBlocked                  = $True
                    DateAndTimeForceSetAutomatically               = $True
                    DefinitionLookupBlocked                        = $True
                    Description                                    = 'FakeStringValue'
                    DeviceBlockEnableRestrictions                  = $True
                    DeviceBlockEraseContentAndSettings             = $True
                    DeviceBlockNameModification                    = $True
                    DiagnosticDataBlockSubmission                  = $True
                    DiagnosticDataBlockSubmissionModification      = $True
                    DisplayName                                    = 'FakeStringValue'
                    DocumentsBlockManagedDocumentsInUnmanagedApps  = $True
                    DocumentsBlockUnmanagedDocumentsInManagedApps  = $True
                    EnterpriseAppBlockTrust                        = $True
                    EnterpriseAppBlockTrustModification            = $True
                    EnterpriseBookBlockBackup                      = $True
                    EnterpriseBookBlockMetadataSync                = $True
                    EsimBlockModification                          = $True
                    FaceTimeBlocked                                = $True
                    FilesNetworkDriveAccessBlocked                 = $True
                    FilesUsbDriveAccessBlocked                     = $True
                    FindMyDeviceInFindMyAppBlocked                 = $True
                    FindMyFriendsBlocked                           = $True
                    FindMyFriendsInFindMyAppBlocked                = $True
                    GameCenterBlocked                              = $True
                    GamingBlockGameCenterFriends                   = $True
                    GamingBlockMultiplayer                         = $True
                    HostPairingBlocked                             = $True
                    IBooksStoreBlocked                             = $True
                    IBooksStoreBlockErotica                        = $True
                    ICloudBlockActivityContinuation                = $True
                    ICloudBlockBackup                              = $True
                    ICloudBlockDocumentSync                        = $True
                    ICloudBlockManagedAppsSync                     = $True
                    ICloudBlockPhotoLibrary                        = $True
                    ICloudBlockPhotoStreamSync                     = $True
                    ICloudBlockSharedPhotoStream                   = $True
                    ICloudPrivateRelayBlocked                      = $True
                    ICloudRequireEncryptedBackup                   = $True
                    Id                                             = 'FakeStringValue'
                    ITunesBlocked                                  = $True
                    ITunesBlockExplicitContent                     = $True
                    ITunesBlockMusicService                        = $True
                    ITunesBlockRadio                               = $True
                    KeyboardBlockAutoCorrect                       = $True
                    KeyboardBlockDictation                         = $True
                    KeyboardBlockPredictive                        = $True
                    KeyboardBlockShortcuts                         = $True
                    KeyboardBlockSpellCheck                        = $True
                    KeychainBlockCloudSync                         = $True
                    KioskModeAllowAssistiveSpeak                   = $True
                    KioskModeAllowAssistiveTouchSettings           = $True
                    KioskModeAllowAutoLock                         = $True
                    KioskModeAllowColorInversionSettings           = $True
                    KioskModeAllowRingerSwitch                     = $True
                    KioskModeAllowScreenRotation                   = $True
                    KioskModeAllowSleepButton                      = $True
                    KioskModeAllowTouchscreen                      = $True
                    KioskModeAllowVoiceControlModification         = $True
                    KioskModeAllowVoiceOverSettings                = $True
                    KioskModeAllowVolumeButtons                    = $True
                    KioskModeAllowZoomSettings                     = $True
                    KioskModeAppStoreUrl                           = 'FakeStringValue'
                    KioskModeAppType                               = 'notConfigured'
                    KioskModeBlockAutoLock                         = $True
                    KioskModeBlockRingerSwitch                     = $True
                    KioskModeBlockScreenRotation                   = $True
                    KioskModeBlockSleepButton                      = $True
                    KioskModeBlockTouchscreen                      = $True
                    KioskModeBlockVolumeButtons                    = $True
                    KioskModeBuiltInAppId                          = 'FakeStringValue'
                    KioskModeEnableVoiceControl                    = $True
                    KioskModeManagedAppId                          = 'FakeStringValue'
                    KioskModeRequireAssistiveTouch                 = $True
                    KioskModeRequireColorInversion                 = $True
                    KioskModeRequireMonoAudio                      = $True
                    KioskModeRequireVoiceOver                      = $True
                    KioskModeRequireZoom                           = $True
                    LockScreenBlockControlCenter                   = $True
                    LockScreenBlockNotificationView                = $True
                    LockScreenBlockPassbook                        = $True
                    LockScreenBlockTodayView                       = $True
                    ManagedPasteboardRequired                      = $True
                    MediaContentRatingApps                         = 'allAllowed'
                    MediaContentRatingAustralia                    = (New-CimInstance -ClassName MSFT_MicrosoftGraphmediacontentratingaustralia -Property @{
                            movieRating = 'allAllowed'
                            tvRating    = 'allAllowed'
                        } -ClientOnly)
                    MediaContentRatingCanada                       = (New-CimInstance -ClassName MSFT_MicrosoftGraphmediacontentratingcanada -Property @{
                            movieRating = 'allAllowed'
                            tvRating    = 'allAllowed'
                        } -ClientOnly)
                    MediaContentRatingFrance                       = (New-CimInstance -ClassName MSFT_MicrosoftGraphmediacontentratingfrance -Property @{
                            movieRating = 'allAllowed'
                            tvRating    = 'allAllowed'
                        } -ClientOnly)
                    MediaContentRatingGermany                      = (New-CimInstance -ClassName MSFT_MicrosoftGraphmediacontentratinggermany -Property @{
                            movieRating = 'allAllowed'
                            tvRating    = 'allAllowed'
                        } -ClientOnly)
                    MediaContentRatingIreland                      = (New-CimInstance -ClassName MSFT_MicrosoftGraphmediacontentratingireland -Property @{
                            movieRating = 'allAllowed'
                            tvRating    = 'allAllowed'
                        } -ClientOnly)
                    MediaContentRatingJapan                        = (New-CimInstance -ClassName MSFT_MicrosoftGraphmediacontentratingjapan -Property @{
                            movieRating = 'allAllowed'
                            tvRating    = 'allAllowed'
                        } -ClientOnly)
                    MediaContentRatingNewZealand                   = (New-CimInstance -ClassName MSFT_MicrosoftGraphmediacontentratingnewzealand -Property @{
                            movieRating = 'allAllowed'
                            tvRating    = 'allAllowed'
                        } -ClientOnly)
                    MediaContentRatingUnitedKingdom                = (New-CimInstance -ClassName MSFT_MicrosoftGraphmediacontentratingunitedkingdom -Property @{
                            movieRating = 'allAllowed'
                            tvRating    = 'allAllowed'
                        } -ClientOnly)
                    MediaContentRatingUnitedStates                 = (New-CimInstance -ClassName MSFT_MicrosoftGraphmediacontentratingunitedstates -Property @{
                            movieRating = 'allAllowed'
                            tvRating    = 'allAllowed'
                        } -ClientOnly)
                    MessagesBlocked                                = $True
                    NetworkUsageRules                              = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphiosnetworkusagerule -Property @{
                            cellularDataBlocked          = $True
                            cellularDataBlockWhenRoaming = $True

                        } -ClientOnly)
                    )
                    NfcBlocked                                     = $True
                    NotificationsBlockSettingsModification         = $True
                    OnDeviceOnlyDictationForced                    = $True
                    OnDeviceOnlyTranslationForced                  = $True
                    PasscodeBlockFingerprintModification           = $True
                    PasscodeBlockFingerprintUnlock                 = $True
                    PasscodeBlockModification                      = $True
                    PasscodeBlockSimple                            = $True
                    PasscodeExpirationDays                         = 25
                    PasscodeMinimumCharacterSetCount               = 25
                    PasscodeMinimumLength                          = 25
                    PasscodeMinutesOfInactivityBeforeLock          = 25
                    PasscodeMinutesOfInactivityBeforeScreenTimeout = 25
                    PasscodePreviousPasscodeBlockCount             = 25
                    PasscodeRequired                               = $True
                    PasscodeRequiredType                           = 'deviceDefault'
                    PasscodeSignInFailureCountBeforeWipe           = 25
                    PasswordBlockAirDropSharing                    = $True
                    PasswordBlockAutoFill                          = $True
                    PasswordBlockProximityRequests                 = $True
                    PkiBlockOTAUpdates                             = $True
                    PodcastsBlocked                                = $True
                    PrivacyForceLimitAdTracking                    = $True
                    ProximityBlockSetupToNewDevice                 = $True
                    SafariBlockAutofill                            = $True
                    SafariBlocked                                  = $True
                    SafariBlockJavaScript                          = $True
                    SafariBlockPopups                              = $True
                    SafariCookieSettings                           = 'browserDefault'
                    SafariRequireFraudWarning                      = $True
                    ScreenCaptureBlocked                           = $True
                    SharedDeviceBlockTemporarySessions             = $True
                    SiriBlocked                                    = $True
                    SiriBlockedWhenLocked                          = $True
                    SiriBlockUserGeneratedContent                  = $True
                    SiriRequireProfanityFilter                     = $True
                    SoftwareUpdatesEnforcedDelayInDays             = 25
                    SoftwareUpdatesForceDelayed                    = $True
                    SpotlightBlockInternetResults                  = $True
                    UnpairedExternalBootToRecoveryAllowed          = $True
                    UsbRestrictedModeBlocked                       = $True
                    VoiceDialingBlocked                            = $True
                    VpnBlockCreation                               = $True
                    WallpaperBlockModification                     = $True
                    WiFiConnectOnlyToConfiguredNetworks            = $True
                    WiFiConnectToAllowedNetworksOnlyForced         = $True
                    WifiPowerOnForced                              = $True

                    Ensure                                         = 'Present'
                    Credential                                     = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            MediaContentRatingCanada                       = @{
                                movieRating = 'allAllowed'
                                tvRating    = 'allAllowed'
                            }
                            PasscodeMinutesOfInactivityBeforeLock          = 7
                            PasscodeMinimumLength                          = 7
                            MediaContentRatingIreland                      = @{
                                movieRating = 'allAllowed'
                                tvRating    = 'allAllowed'
                            }
                            PasscodeMinutesOfInactivityBeforeScreenTimeout = 7
                            NetworkUsageRules                              = @(
                                @{
                                    cellularDataBlocked          = $True
                                    cellularDataBlockWhenRoaming = $True

                                }
                            )
                            PasscodePreviousPasscodeBlockCount             = 7
                            MediaContentRatingNewZealand                   = @{
                                movieRating = 'allAllowed'
                                tvRating    = 'allAllowed'
                            }
                            KioskModeManagedAppId                          = 'FakeStringValue'
                            MediaContentRatingApps                         = 'allAllowed'
                            PasscodeMinimumCharacterSetCount               = 7
                            MediaContentRatingUnitedStates                 = @{
                                movieRating = 'allAllowed'
                                tvRating    = 'allAllowed'
                            }
                            SafariCookieSettings                           = 'browserDefault'
                            CompliantAppListType                           = 'none'
                            AppsSingleAppModeList                          = @(
                                @{
                                    name          = 'FakeStringValue'
                                    appId         = 'FakeStringValue'
                                    appStoreUrl   = 'FakeStringValue'
                                    '@odata.type' = '#microsoft.graph.appleAppListItem'
                                    publisher     = 'FakeStringValue'

                                }
                            )
                            MediaContentRatingFrance                       = @{
                                movieRating = 'allAllowed'
                                tvRating    = 'allAllowed'
                            }
                            MediaContentRatingAustralia                    = @{
                                movieRating = 'allAllowed'
                                tvRating    = 'allAllowed'
                            }
                            MediaContentRatingGermany                      = @{
                                movieRating = 'allAllowed'
                                tvRating    = 'allAllowed'
                            }
                            PasscodeSignInFailureCountBeforeWipe           = 7
                            KioskModeAppStoreUrl                           = 'FakeStringValue'
                            AppsVisibilityListType                         = 'none'
                            KioskModeAppType                               = 'notConfigured'
                            AppsVisibilityList                             = @(
                                @{
                                    name          = 'FakeStringValue'
                                    appId         = 'FakeStringValue'
                                    appStoreUrl   = 'FakeStringValue'
                                    '@odata.type' = '#microsoft.graph.appleAppListItem'
                                    publisher     = 'FakeStringValue'

                                }
                            )
                            MediaContentRatingJapan                        = @{
                                movieRating = 'allAllowed'
                                tvRating    = 'allAllowed'
                            }
                            SoftwareUpdatesEnforcedDelayInDays             = 7
                            PasscodeExpirationDays                         = 7
                            CompliantAppsList                              = @(
                                @{
                                    name          = 'FakeStringValue'
                                    appId         = 'FakeStringValue'
                                    appStoreUrl   = 'FakeStringValue'
                                    '@odata.type' = '#microsoft.graph.appleAppListItem'
                                    publisher     = 'FakeStringValue'

                                }
                            )
                            '@odata.type'                                  = '#microsoft.graph.iosGeneralDeviceConfiguration'
                            KioskModeBuiltInAppId                          = 'FakeStringValue'
                            MediaContentRatingUnitedKingdom                = @{
                                movieRating = 'allAllowed'
                                tvRating    = 'allAllowed'
                            }
                            PasscodeRequiredType                           = 'deviceDefault'

                        }
                        Description          = 'FakeStringValue'
                        DisplayName          = 'FakeStringValue'
                        Id                   = 'FakeStringValue'

                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfigurationAssignment -MockWith {
                    return @()
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgBetaDeviceManagementDeviceConfiguration -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            FaceTimeBlocked                                = $True
                            KioskModeAllowSleepButton                      = $True
                            MediaContentRatingCanada                       = @{
                                movieRating = 'allAllowed'
                                tvRating    = 'allAllowed'
                            }
                            UnpairedExternalBootToRecoveryAllowed          = $True
                            ICloudBlockPhotoStreamSync                     = $True
                            KeyboardBlockPredictive                        = $True
                            SafariBlockPopups                              = $True
                            GameCenterBlocked                              = $True
                            PasscodeBlockSimple                            = $True
                            ITunesBlocked                                  = $True
                            PasscodeMinimumCharacterSetCount               = 25
                            AppleWatchForceWristDetection                  = $True
                            PasscodeExpirationDays                         = 25
                            EnterpriseAppBlockTrustModification            = $True
                            AirPlayForcePairingPasswordForOutgoingRequests = $True
                            KeyboardBlockAutoCorrect                       = $True
                            ITunesBlockExplicitContent                     = $True
                            IBooksStoreBlockErotica                        = $True
                            KioskModeAllowRingerSwitch                     = $True
                            DocumentsBlockUnmanagedDocumentsInManagedApps  = $True
                            MessagesBlocked                                = $True
                            DeviceBlockEnableRestrictions                  = $True
                            AppStoreBlocked                                = $True
                            SpotlightBlockInternetResults                  = $True
                            KioskModeAppType                               = 'notConfigured'
                            KioskModeAllowVolumeButtons                    = $True
                            VoiceDialingBlocked                            = $True
                            PasscodeMinimumLength                          = 25
                            ICloudBlockSharedPhotoStream                   = $True
                            ActivationLockAllowWhenSupervised              = $True
                            CellularBlockVoiceRoaming                      = $True
                            MediaContentRatingIreland                      = @{
                                movieRating = 'allAllowed'
                                tvRating    = 'allAllowed'
                            }
                            PkiBlockOTAUpdates                             = $True
                            KeyboardBlockDictation                         = $True
                            PasscodeBlockModification                      = $True
                            AutoUnlockBlocked                              = $True
                            PasswordBlockProximityRequests                 = $True
                            MediaContentRatingAustralia                    = @{
                                movieRating = 'allAllowed'
                                tvRating    = 'allAllowed'
                            }
                            ITunesBlockMusicService                        = $True
                            DiagnosticDataBlockSubmissionModification      = $True
                            EnterpriseAppBlockTrust                        = $True
                            ManagedPasteboardRequired                      = $True
                            ProximityBlockSetupToNewDevice                 = $True
                            PasscodeMinutesOfInactivityBeforeScreenTimeout = 25
                            ITunesBlockRadio                               = $True
                            CellularBlockGlobalBackgroundFetchWhileRoaming = $True
                            SiriBlocked                                    = $True
                            MediaContentRatingJapan                        = @{
                                movieRating = 'allAllowed'
                                tvRating    = 'allAllowed'
                            }
                            FindMyFriendsInFindMyAppBlocked                = $True
                            CellularBlockPerAppDataModification            = $True
                            ClassroomForceAutomaticallyJoinClasses         = $True
                            SiriBlockUserGeneratedContent                  = $True
                            MediaContentRatingApps                         = 'allAllowed'
                            SafariCookieSettings                           = 'browserDefault'
                            DeviceBlockNameModification                    = $True
                            WifiPowerOnForced                              = $True
                            ContactsAllowManagedToUnmanagedWrite           = $True
                            AirPrintBlockCredentialsStorage                = $True
                            '@odata.type'                                  = '#microsoft.graph.iosGeneralDeviceConfiguration'
                            KioskModeAllowAssistiveTouchSettings           = $True
                            PasscodeRequiredType                           = 'deviceDefault'
                            PasscodePreviousPasscodeBlockCount             = 25
                            AutoFillForceAuthentication                    = $True
                            CompliantAppListType                           = 'none'
                            ICloudBlockBackup                              = $True
                            KioskModeAllowAutoLock                         = $True
                            LockScreenBlockControlCenter                   = $True
                            EsimBlockModification                          = $True
                            AppleNewsBlocked                               = $True
                            CellularBlockPersonalHotspot                   = $True
                            KioskModeBuiltInAppId                          = 'FakeStringValue'
                            AirPrintForceTrustedTLS                        = $True
                            CameraBlocked                                  = $True
                            SiriRequireProfanityFilter                     = $True
                            PasscodeBlockFingerprintUnlock                 = $True
                            DateAndTimeForceSetAutomatically               = $True
                            KioskModeAllowAssistiveSpeak                   = $True
                            AccountBlockModification                       = $True
                            BlockSystemAppRemoval                          = $True
                            DocumentsBlockManagedDocumentsInUnmanagedApps  = $True
                            FindMyFriendsBlocked                           = $True
                            ICloudBlockManagedAppsSync                     = $True
                            LockScreenBlockTodayView                       = $True
                            BluetoothBlockModification                     = $True
                            KioskModeManagedAppId                          = 'FakeStringValue'
                            SoftwareUpdatesForceDelayed                    = $True
                            ConfigurationProfileBlockChanges               = $True
                            WiFiConnectOnlyToConfiguredNetworks            = $True
                            MediaContentRatingNewZealand                   = @{
                                movieRating = 'allAllowed'
                                tvRating    = 'allAllowed'
                            }
                            KioskModeRequireMonoAudio                      = $True
                            AppStoreRequirePassword                        = $True
                            ICloudBlockDocumentSync                        = $True
                            CellularBlockDataRoaming                       = $True
                            ICloudRequireEncryptedBackup                   = $True
                            ApplePersonalizedAdsBlocked                    = $True
                            KioskModeBlockAutoLock                         = $True
                            ClassroomAppBlockRemoteScreenObservation       = $True
                            PasscodeBlockFingerprintModification           = $True
                            FindMyDeviceInFindMyAppBlocked                 = $True
                            IBooksStoreBlocked                             = $True
                            KioskModeRequireVoiceOver                      = $True
                            KioskModeAllowVoiceOverSettings                = $True
                            AirDropForceUnmanagedDropTarget                = $True
                            SafariBlockAutofill                            = $True
                            PasscodeSignInFailureCountBeforeWipe           = 25
                            ContinuousPathKeyboardBlocked                  = $True
                            KeychainBlockCloudSync                         = $True
                            VpnBlockCreation                               = $True
                            KioskModeAllowVoiceControlModification         = $True
                            MediaContentRatingUnitedStates                 = @{
                                movieRating = 'allAllowed'
                                tvRating    = 'allAllowed'
                            }
                            KioskModeBlockVolumeButtons                    = $True
                            HostPairingBlocked                             = $True
                            AppClipsBlocked                                = $True
                            PasscodeRequired                               = $True
                            AppStoreBlockInAppPurchases                    = $True
                            LockScreenBlockNotificationView                = $True
                            KioskModeBlockSleepButton                      = $True
                            OnDeviceOnlyDictationForced                    = $True
                            NetworkUsageRules                              = @(
                                @{
                                    cellularDataBlocked          = $True
                                    cellularDataBlockWhenRoaming = $True

                                }
                            )
                            ICloudBlockActivityContinuation                = $True
                            SoftwareUpdatesEnforcedDelayInDays             = 25
                            AppsSingleAppModeList                          = @(
                                @{
                                    name          = 'FakeStringValue'
                                    appId         = 'FakeStringValue'
                                    appStoreUrl   = 'FakeStringValue'
                                    '@odata.type' = '#microsoft.graph.appleAppListItem'
                                    publisher     = 'FakeStringValue'

                                }
                            )
                            ICloudBlockPhotoLibrary                        = $True
                            PrivacyForceLimitAdTracking                    = $True
                            MediaContentRatingGermany                      = @{
                                movieRating = 'allAllowed'
                                tvRating    = 'allAllowed'
                            }
                            KeyboardBlockShortcuts                         = $True
                            OnDeviceOnlyTranslationForced                  = $True
                            FilesUsbDriveAccessBlocked                     = $True
                            AppStoreBlockAutomaticDownloads                = $True
                            KioskModeRequireColorInversion                 = $True
                            SharedDeviceBlockTemporarySessions             = $True
                            GamingBlockGameCenterFriends                   = $True
                            EnterpriseBookBlockBackup                      = $True
                            EnterpriseBookBlockMetadataSync                = $True
                            AirDropBlocked                                 = $True
                            KioskModeBlockRingerSwitch                     = $True
                            KioskModeEnableVoiceControl                    = $True
                            MediaContentRatingUnitedKingdom                = @{
                                movieRating = 'allAllowed'
                                tvRating    = 'allAllowed'
                            }
                            CellularBlockPlanModification                  = $True
                            AirPrintBlocked                                = $True
                            KioskModeAllowZoomSettings                     = $True
                            AppRemovalBlocked                              = $True
                            ICloudPrivateRelayBlocked                      = $True
                            PodcastsBlocked                                = $True
                            WallpaperBlockModification                     = $True
                            ClassroomForceRequestPermissionToLeaveClasses  = $True
                            AppsVisibilityList                             = @(
                                @{
                                    name          = 'FakeStringValue'
                                    appId         = 'FakeStringValue'
                                    appStoreUrl   = 'FakeStringValue'
                                    '@odata.type' = '#microsoft.graph.appleAppListItem'
                                    publisher     = 'FakeStringValue'

                                }
                            )
                            SiriBlockedWhenLocked                          = $True
                            MediaContentRatingFrance                       = @{
                                movieRating = 'allAllowed'
                                tvRating    = 'allAllowed'
                            }
                            DefinitionLookupBlocked                        = $True
                            SafariBlockJavaScript                          = $True
                            AppsVisibilityListType                         = 'none'
                            AppleWatchBlockPairing                         = $True
                            KioskModeAppStoreUrl                           = 'FakeStringValue'
                            NfcBlocked                                     = $True
                            LockScreenBlockPassbook                        = $True
                            PasswordBlockAutoFill                          = $True
                            CompliantAppsList                              = @(
                                @{
                                    name          = 'FakeStringValue'
                                    appId         = 'FakeStringValue'
                                    appStoreUrl   = 'FakeStringValue'
                                    '@odata.type' = '#microsoft.graph.appleAppListItem'
                                    publisher     = 'FakeStringValue'

                                }
                            )
                            AirPrintBlockiBeaconDiscovery                  = $True
                            ScreenCaptureBlocked                           = $True
                            KioskModeAllowTouchscreen                      = $True
                            ContactsAllowUnmanagedToManagedRead            = $True
                            KioskModeBlockTouchscreen                      = $True
                            UsbRestrictedModeBlocked                       = $True
                            DeviceBlockEraseContentAndSettings             = $True
                            PasswordBlockAirDropSharing                    = $True
                            CellularBlockPersonalHotspotModification       = $True
                            NotificationsBlockSettingsModification         = $True
                            SafariBlocked                                  = $True
                            CertificatesBlockUntrustedTlsCertificates      = $True
                            FilesNetworkDriveAccessBlocked                 = $True
                            KeyboardBlockSpellCheck                        = $True
                            ClassroomAppForceUnpromptedScreenObservation   = $True
                            ClassroomForceUnpromptedAppAndDeviceLock       = $True
                            KioskModeAllowScreenRotation                   = $True
                            KioskModeAllowColorInversionSettings           = $True
                            PasscodeMinutesOfInactivityBeforeLock          = 25
                            DiagnosticDataBlockSubmission                  = $True
                            GamingBlockMultiplayer                         = $True
                            SafariRequireFraudWarning                      = $True
                            KioskModeRequireAssistiveTouch                 = $True
                            AppStoreBlockUIAppInstallation                 = $True
                            KioskModeBlockScreenRotation                   = $True
                            WiFiConnectToAllowedNetworksOnlyForced         = $True
                            KioskModeRequireZoom                           = $True

                        }
                        Description          = 'FakeStringValue'
                        DisplayName          = 'FakeStringValue'
                        Id                   = 'FakeStringValue'

                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfigurationAssignment -MockWith {
                    return @()
                }
            }
            It 'Should Reverse Engineer resource from the Export method' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
