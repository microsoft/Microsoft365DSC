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
    -DscResource 'IntuneDeviceConfigurationPolicyAndroidDeviceAdministrator' -GenericStubModule $GenericStubPath
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

            Mock -CommandName Update-MgDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName New-MgDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName Remove-MgDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }

        # Test contexts
        Context -Name 'The IntuneDeviceConfigurationPolicyAndroidDeviceAdministrator should exist but it DOES NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    AppsBlockClipboardSharing                      = $True
                    AppsBlockCopyPaste                             = $True
                    AppsBlockYouTube                               = $True
                    AppsHideList                                   = @(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                            appId       = 'FakeStringValue'
                            publisher   = 'FakeStringValue'
                            appStoreUrl = 'FakeStringValue'
                            name        = 'FakeStringValue'
                            odataType   = '#microsoft.graph.appleAppListItem'

                        } -ClientOnly)
                    )
                    AppsInstallAllowList                           = @(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                            appId       = 'FakeStringValue'
                            publisher   = 'FakeStringValue'
                            appStoreUrl = 'FakeStringValue'
                            name        = 'FakeStringValue'
                            odataType   = '#microsoft.graph.appleAppListItem'

                        } -ClientOnly)
                    )
                    AppsLaunchBlockList                            = @(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                            appId       = 'FakeStringValue'
                            publisher   = 'FakeStringValue'
                            appStoreUrl = 'FakeStringValue'
                            name        = 'FakeStringValue'
                            odataType   = '#microsoft.graph.appleAppListItem'

                        } -ClientOnly)
                    )
                    BluetoothBlocked                               = $True
                    CameraBlocked                                  = $True
                    CellularBlockDataRoaming                       = $True
                    CellularBlockMessaging                         = $True
                    CellularBlockVoiceRoaming                      = $True
                    CellularBlockWiFiTethering                     = $True
                    CompliantAppListType                           = 'none'
                    CompliantAppsList                              = @(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                            appId       = 'FakeStringValue'
                            publisher   = 'FakeStringValue'
                            appStoreUrl = 'FakeStringValue'
                            name        = 'FakeStringValue'
                            odataType   = '#microsoft.graph.appleAppListItem'

                        } -ClientOnly)
                    )
                    DateAndTimeBlockChanges                        = $True
                    Description                                    = 'FakeStringValue'
                    DeviceSharingAllowed                           = $True
                    DiagnosticDataBlockSubmission                  = $True
                    DisplayName                                    = 'FakeStringValue'
                    FactoryResetBlocked                            = $True
                    GoogleAccountBlockAutoSync                     = $True
                    GooglePlayStoreBlocked                         = $True
                    Id                                             = 'FakeStringValue'
                    KioskModeApps                                  = @(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                            appId       = 'FakeStringValue'
                            publisher   = 'FakeStringValue'
                            appStoreUrl = 'FakeStringValue'
                            name        = 'FakeStringValue'
                            odataType   = '#microsoft.graph.appleAppListItem'

                        } -ClientOnly)
                    )
                    KioskModeBlockSleepButton                      = $True
                    KioskModeBlockVolumeButtons                    = $True
                    LocationServicesBlocked                        = $True
                    NfcBlocked                                     = $True
                    PasswordBlockFingerprintUnlock                 = $True
                    PasswordBlockTrustAgents                       = $True
                    PasswordExpirationDays                         = 25
                    PasswordMinimumLength                          = 25
                    PasswordMinutesOfInactivityBeforeScreenTimeout = 25
                    PasswordPreviousPasswordBlockCount             = 25
                    PasswordRequired                               = $True
                    PasswordRequiredType                           = 'deviceDefault'
                    PasswordSignInFailureCountBeforeFactoryReset   = 25
                    PowerOffBlocked                                = $True
                    RequiredPasswordComplexity                     = 'none'
                    ScreenCaptureBlocked                           = $True
                    SecurityRequireVerifyApps                      = $True
                    StorageBlockGoogleBackup                       = $True
                    StorageBlockRemovableStorage                   = $True
                    StorageRequireDeviceEncryption                 = $True
                    StorageRequireRemovableStorageEncryption       = $True
                    VoiceAssistantBlocked                          = $True
                    VoiceDialingBlocked                            = $True
                    WebBrowserBlockAutofill                        = $True
                    WebBrowserBlocked                              = $True
                    WebBrowserBlockJavaScript                      = $True
                    WebBrowserBlockPopups                          = $True
                    WebBrowserCookieSettings                       = 'browserDefault'
                    WiFiBlocked                                    = $True

                    Ensure                                         = 'Present'
                    Credential                                     = $Credential
                }

                Mock -CommandName Get-MgDeviceManagementDeviceConfiguration -MockWith {
                    return $null
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
                Should -Invoke -CommandName New-MgDeviceManagementDeviceConfiguration -Exactly 1
            }
        }

        Context -Name 'The IntuneDeviceConfigurationPolicyAndroidDeviceAdministrator exists but it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    AppsBlockClipboardSharing                      = $True
                    AppsBlockCopyPaste                             = $True
                    AppsBlockYouTube                               = $True
                    AppsHideList                                   = @(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                            appId       = 'FakeStringValue'
                            publisher   = 'FakeStringValue'
                            appStoreUrl = 'FakeStringValue'
                            name        = 'FakeStringValue'
                            odataType   = '#microsoft.graph.appleAppListItem'

                        } -ClientOnly)
                    )
                    AppsInstallAllowList                           = @(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                            appId       = 'FakeStringValue'
                            publisher   = 'FakeStringValue'
                            appStoreUrl = 'FakeStringValue'
                            name        = 'FakeStringValue'
                            odataType   = '#microsoft.graph.appleAppListItem'

                        } -ClientOnly)
                    )
                    AppsLaunchBlockList                            = @(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                            appId       = 'FakeStringValue'
                            publisher   = 'FakeStringValue'
                            appStoreUrl = 'FakeStringValue'
                            name        = 'FakeStringValue'
                            odataType   = '#microsoft.graph.appleAppListItem'

                        } -ClientOnly)
                    )
                    BluetoothBlocked                               = $True
                    CameraBlocked                                  = $True
                    CellularBlockDataRoaming                       = $True
                    CellularBlockMessaging                         = $True
                    CellularBlockVoiceRoaming                      = $True
                    CellularBlockWiFiTethering                     = $True
                    CompliantAppListType                           = 'none'
                    CompliantAppsList                              = @(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                            appId       = 'FakeStringValue'
                            publisher   = 'FakeStringValue'
                            appStoreUrl = 'FakeStringValue'
                            name        = 'FakeStringValue'
                            odataType   = '#microsoft.graph.appleAppListItem'

                        } -ClientOnly)
                    )
                    DateAndTimeBlockChanges                        = $True
                    Description                                    = 'FakeStringValue'
                    DeviceSharingAllowed                           = $True
                    DiagnosticDataBlockSubmission                  = $True
                    DisplayName                                    = 'FakeStringValue'
                    FactoryResetBlocked                            = $True
                    GoogleAccountBlockAutoSync                     = $True
                    GooglePlayStoreBlocked                         = $True
                    Id                                             = 'FakeStringValue'
                    KioskModeApps                                  = @(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                            appId       = 'FakeStringValue'
                            publisher   = 'FakeStringValue'
                            appStoreUrl = 'FakeStringValue'
                            name        = 'FakeStringValue'
                            odataType   = '#microsoft.graph.appleAppListItem'

                        } -ClientOnly)
                    )
                    KioskModeBlockSleepButton                      = $True
                    KioskModeBlockVolumeButtons                    = $True
                    LocationServicesBlocked                        = $True
                    NfcBlocked                                     = $True
                    PasswordBlockFingerprintUnlock                 = $True
                    PasswordBlockTrustAgents                       = $True
                    PasswordExpirationDays                         = 25
                    PasswordMinimumLength                          = 25
                    PasswordMinutesOfInactivityBeforeScreenTimeout = 25
                    PasswordPreviousPasswordBlockCount             = 25
                    PasswordRequired                               = $True
                    PasswordRequiredType                           = 'deviceDefault'
                    PasswordSignInFailureCountBeforeFactoryReset   = 25
                    PowerOffBlocked                                = $True
                    RequiredPasswordComplexity                     = 'none'
                    ScreenCaptureBlocked                           = $True
                    SecurityRequireVerifyApps                      = $True
                    StorageBlockGoogleBackup                       = $True
                    StorageBlockRemovableStorage                   = $True
                    StorageRequireDeviceEncryption                 = $True
                    StorageRequireRemovableStorageEncryption       = $True
                    VoiceAssistantBlocked                          = $True
                    VoiceDialingBlocked                            = $True
                    WebBrowserBlockAutofill                        = $True
                    WebBrowserBlocked                              = $True
                    WebBrowserBlockJavaScript                      = $True
                    WebBrowserBlockPopups                          = $True
                    WebBrowserCookieSettings                       = 'browserDefault'
                    WiFiBlocked                                    = $True

                    Ensure                                         = 'Absent'
                    Credential                                     = $Credential
                }

                Mock -CommandName Get-MgDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            AppsBlockCopyPaste                             = $True
                            StorageBlockRemovableStorage                   = $True
                            PowerOffBlocked                                = $True
                            KioskModeBlockSleepButton                      = $True
                            ScreenCaptureBlocked                           = $True
                            AppsLaunchBlockList                            = @(
                                @{
                                    name          = 'FakeStringValue'
                                    appId         = 'FakeStringValue'
                                    appStoreUrl   = 'FakeStringValue'
                                    '@odata.type' = '#microsoft.graph.appleAppListItem'
                                    publisher     = 'FakeStringValue'

                                }
                            )
                            PasswordMinimumLength                          = 25
                            PasswordRequired                               = $True
                            KioskModeBlockVolumeButtons                    = $True
                            PasswordSignInFailureCountBeforeFactoryReset   = 25
                            AppsBlockYouTube                               = $True
                            PasswordExpirationDays                         = 25
                            AppsHideList                                   = @(
                                @{
                                    name          = 'FakeStringValue'
                                    appId         = 'FakeStringValue'
                                    appStoreUrl   = 'FakeStringValue'
                                    '@odata.type' = '#microsoft.graph.appleAppListItem'
                                    publisher     = 'FakeStringValue'

                                }
                            )
                            LocationServicesBlocked                        = $True
                            WebBrowserBlockAutofill                        = $True
                            DateAndTimeBlockChanges                        = $True
                            FactoryResetBlocked                            = $True
                            PasswordRequiredType                           = 'deviceDefault'
                            WebBrowserBlockPopups                          = $True
                            StorageRequireRemovableStorageEncryption       = $True
                            PasswordPreviousPasswordBlockCount             = 25
                            KioskModeApps                                  = @(
                                @{
                                    name          = 'FakeStringValue'
                                    appId         = 'FakeStringValue'
                                    appStoreUrl   = 'FakeStringValue'
                                    '@odata.type' = '#microsoft.graph.appleAppListItem'
                                    publisher     = 'FakeStringValue'

                                }
                            )
                            WebBrowserBlockJavaScript                      = $True
                            PasswordMinutesOfInactivityBeforeScreenTimeout = 25
                            PasswordBlockFingerprintUnlock                 = $True
                            WiFiBlocked                                    = $True
                            CellularBlockMessaging                         = $True
                            GooglePlayStoreBlocked                         = $True
                            CellularBlockWiFiTethering                     = $True
                            StorageRequireDeviceEncryption                 = $True
                            NfcBlocked                                     = $True
                            DiagnosticDataBlockSubmission                  = $True
                            CellularBlockDataRoaming                       = $True
                            PasswordBlockTrustAgents                       = $True
                            RequiredPasswordComplexity                     = 'none'
                            '@odata.type'                                  = '#microsoft.graph.androidGeneralDeviceConfiguration'
                            CameraBlocked                                  = $True
                            WebBrowserCookieSettings                       = 'browserDefault'
                            DeviceSharingAllowed                           = $True
                            CompliantAppsList                              = @(
                                @{
                                    name          = 'FakeStringValue'
                                    appId         = 'FakeStringValue'
                                    appStoreUrl   = 'FakeStringValue'
                                    '@odata.type' = '#microsoft.graph.appleAppListItem'
                                    publisher     = 'FakeStringValue'

                                }
                            )
                            VoiceAssistantBlocked                          = $True
                            GoogleAccountBlockAutoSync                     = $True
                            VoiceDialingBlocked                            = $True
                            CompliantAppListType                           = 'none'
                            AppsBlockClipboardSharing                      = $True
                            AppsInstallAllowList                           = @(
                                @{
                                    name          = 'FakeStringValue'
                                    appId         = 'FakeStringValue'
                                    appStoreUrl   = 'FakeStringValue'
                                    '@odata.type' = '#microsoft.graph.appleAppListItem'
                                    publisher     = 'FakeStringValue'

                                }
                            )
                            WebBrowserBlocked                              = $True
                            SecurityRequireVerifyApps                      = $True
                            BluetoothBlocked                               = $True
                            StorageBlockGoogleBackup                       = $True
                            CellularBlockVoiceRoaming                      = $True

                        }
                        Description          = 'FakeStringValue'
                        DisplayName          = 'FakeStringValue'
                        Id                   = 'FakeStringValue'

                    }
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
                Should -Invoke -CommandName Remove-MgDeviceManagementDeviceConfiguration -Exactly 1
            }
        }
        Context -Name 'The IntuneDeviceConfigurationPolicyAndroidDeviceAdministrator Exists and Values are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    AppsBlockClipboardSharing                      = $True
                    AppsBlockCopyPaste                             = $True
                    AppsBlockYouTube                               = $True
                    AppsHideList                                   = @(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                            appId       = 'FakeStringValue'
                            publisher   = 'FakeStringValue'
                            appStoreUrl = 'FakeStringValue'
                            name        = 'FakeStringValue'
                            odataType   = '#microsoft.graph.appleAppListItem'

                        } -ClientOnly)
                    )
                    AppsInstallAllowList                           = @(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                            appId       = 'FakeStringValue'
                            publisher   = 'FakeStringValue'
                            appStoreUrl = 'FakeStringValue'
                            name        = 'FakeStringValue'
                            odataType   = '#microsoft.graph.appleAppListItem'

                        } -ClientOnly)
                    )
                    AppsLaunchBlockList                            = @(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                            appId       = 'FakeStringValue'
                            publisher   = 'FakeStringValue'
                            appStoreUrl = 'FakeStringValue'
                            name        = 'FakeStringValue'
                            odataType   = '#microsoft.graph.appleAppListItem'

                        } -ClientOnly)
                    )
                    BluetoothBlocked                               = $True
                    CameraBlocked                                  = $True
                    CellularBlockDataRoaming                       = $True
                    CellularBlockMessaging                         = $True
                    CellularBlockVoiceRoaming                      = $True
                    CellularBlockWiFiTethering                     = $True
                    CompliantAppListType                           = 'none'
                    CompliantAppsList                              = @(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                            appId       = 'FakeStringValue'
                            publisher   = 'FakeStringValue'
                            appStoreUrl = 'FakeStringValue'
                            name        = 'FakeStringValue'
                            odataType   = '#microsoft.graph.appleAppListItem'

                        } -ClientOnly)
                    )
                    DateAndTimeBlockChanges                        = $True
                    Description                                    = 'FakeStringValue'
                    DeviceSharingAllowed                           = $True
                    DiagnosticDataBlockSubmission                  = $True
                    DisplayName                                    = 'FakeStringValue'
                    FactoryResetBlocked                            = $True
                    GoogleAccountBlockAutoSync                     = $True
                    GooglePlayStoreBlocked                         = $True
                    Id                                             = 'FakeStringValue'
                    KioskModeApps                                  = @(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                            appId       = 'FakeStringValue'
                            publisher   = 'FakeStringValue'
                            appStoreUrl = 'FakeStringValue'
                            name        = 'FakeStringValue'
                            odataType   = '#microsoft.graph.appleAppListItem'

                        } -ClientOnly)
                    )
                    KioskModeBlockSleepButton                      = $True
                    KioskModeBlockVolumeButtons                    = $True
                    LocationServicesBlocked                        = $True
                    NfcBlocked                                     = $True
                    PasswordBlockFingerprintUnlock                 = $True
                    PasswordBlockTrustAgents                       = $True
                    PasswordExpirationDays                         = 25
                    PasswordMinimumLength                          = 25
                    PasswordMinutesOfInactivityBeforeScreenTimeout = 25
                    PasswordPreviousPasswordBlockCount             = 25
                    PasswordRequired                               = $True
                    PasswordRequiredType                           = 'deviceDefault'
                    PasswordSignInFailureCountBeforeFactoryReset   = 25
                    PowerOffBlocked                                = $True
                    RequiredPasswordComplexity                     = 'none'
                    ScreenCaptureBlocked                           = $True
                    SecurityRequireVerifyApps                      = $True
                    StorageBlockGoogleBackup                       = $True
                    StorageBlockRemovableStorage                   = $True
                    StorageRequireDeviceEncryption                 = $True
                    StorageRequireRemovableStorageEncryption       = $True
                    VoiceAssistantBlocked                          = $True
                    VoiceDialingBlocked                            = $True
                    WebBrowserBlockAutofill                        = $True
                    WebBrowserBlocked                              = $True
                    WebBrowserBlockJavaScript                      = $True
                    WebBrowserBlockPopups                          = $True
                    WebBrowserCookieSettings                       = 'browserDefault'
                    WiFiBlocked                                    = $True

                    Ensure                                         = 'Present'
                    Credential                                     = $Credential
                }

                Mock -CommandName Get-MgDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            AppsBlockCopyPaste                             = $True
                            StorageBlockRemovableStorage                   = $True
                            PowerOffBlocked                                = $True
                            KioskModeBlockSleepButton                      = $True
                            ScreenCaptureBlocked                           = $True
                            AppsLaunchBlockList                            = @(
                                @{
                                    name          = 'FakeStringValue'
                                    appId         = 'FakeStringValue'
                                    appStoreUrl   = 'FakeStringValue'
                                    '@odata.type' = '#microsoft.graph.appleAppListItem'
                                    publisher     = 'FakeStringValue'

                                }
                            )
                            PasswordMinimumLength                          = 25
                            PasswordRequired                               = $True
                            KioskModeBlockVolumeButtons                    = $True
                            PasswordSignInFailureCountBeforeFactoryReset   = 25
                            AppsBlockYouTube                               = $True
                            PasswordExpirationDays                         = 25
                            AppsHideList                                   = @(
                                @{
                                    name          = 'FakeStringValue'
                                    appId         = 'FakeStringValue'
                                    appStoreUrl   = 'FakeStringValue'
                                    '@odata.type' = '#microsoft.graph.appleAppListItem'
                                    publisher     = 'FakeStringValue'

                                }
                            )
                            LocationServicesBlocked                        = $True
                            WebBrowserBlockAutofill                        = $True
                            DateAndTimeBlockChanges                        = $True
                            FactoryResetBlocked                            = $True
                            PasswordRequiredType                           = 'deviceDefault'
                            WebBrowserBlockPopups                          = $True
                            StorageRequireRemovableStorageEncryption       = $True
                            PasswordPreviousPasswordBlockCount             = 25
                            KioskModeApps                                  = @(
                                @{
                                    name          = 'FakeStringValue'
                                    appId         = 'FakeStringValue'
                                    appStoreUrl   = 'FakeStringValue'
                                    '@odata.type' = '#microsoft.graph.appleAppListItem'
                                    publisher     = 'FakeStringValue'

                                }
                            )
                            WebBrowserBlockJavaScript                      = $True
                            PasswordMinutesOfInactivityBeforeScreenTimeout = 25
                            PasswordBlockFingerprintUnlock                 = $True
                            WiFiBlocked                                    = $True
                            CellularBlockMessaging                         = $True
                            GooglePlayStoreBlocked                         = $True
                            CellularBlockWiFiTethering                     = $True
                            StorageRequireDeviceEncryption                 = $True
                            NfcBlocked                                     = $True
                            DiagnosticDataBlockSubmission                  = $True
                            CellularBlockDataRoaming                       = $True
                            PasswordBlockTrustAgents                       = $True
                            RequiredPasswordComplexity                     = 'none'
                            '@odata.type'                                  = '#microsoft.graph.androidGeneralDeviceConfiguration'
                            CameraBlocked                                  = $True
                            WebBrowserCookieSettings                       = 'browserDefault'
                            DeviceSharingAllowed                           = $True
                            CompliantAppsList                              = @(
                                @{
                                    name          = 'FakeStringValue'
                                    appId         = 'FakeStringValue'
                                    appStoreUrl   = 'FakeStringValue'
                                    '@odata.type' = '#microsoft.graph.appleAppListItem'
                                    publisher     = 'FakeStringValue'

                                }
                            )
                            VoiceAssistantBlocked                          = $True
                            GoogleAccountBlockAutoSync                     = $True
                            VoiceDialingBlocked                            = $True
                            CompliantAppListType                           = 'none'
                            AppsBlockClipboardSharing                      = $True
                            AppsInstallAllowList                           = @(
                                @{
                                    name          = 'FakeStringValue'
                                    appId         = 'FakeStringValue'
                                    appStoreUrl   = 'FakeStringValue'
                                    '@odata.type' = '#microsoft.graph.appleAppListItem'
                                    publisher     = 'FakeStringValue'

                                }
                            )
                            WebBrowserBlocked                              = $True
                            SecurityRequireVerifyApps                      = $True
                            BluetoothBlocked                               = $True
                            StorageBlockGoogleBackup                       = $True
                            CellularBlockVoiceRoaming                      = $True

                        }
                        Description          = 'FakeStringValue'
                        DisplayName          = 'FakeStringValue'
                        Id                   = 'FakeStringValue'

                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'The IntuneDeviceConfigurationPolicyAndroidDeviceAdministrator exists and values are NOT in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    AppsBlockClipboardSharing                      = $True
                    AppsBlockCopyPaste                             = $True
                    AppsBlockYouTube                               = $True
                    AppsHideList                                   = @(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                            appId       = 'FakeStringValue'
                            publisher   = 'FakeStringValue'
                            appStoreUrl = 'FakeStringValue'
                            name        = 'FakeStringValue'
                            odataType   = '#microsoft.graph.appleAppListItem'

                        } -ClientOnly)
                    )
                    AppsInstallAllowList                           = @(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                            appId       = 'FakeStringValue'
                            publisher   = 'FakeStringValue'
                            appStoreUrl = 'FakeStringValue'
                            name        = 'FakeStringValue'
                            odataType   = '#microsoft.graph.appleAppListItem'

                        } -ClientOnly)
                    )
                    AppsLaunchBlockList                            = @(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                            appId       = 'FakeStringValue'
                            publisher   = 'FakeStringValue'
                            appStoreUrl = 'FakeStringValue'
                            name        = 'FakeStringValue'
                            odataType   = '#microsoft.graph.appleAppListItem'

                        } -ClientOnly)
                    )
                    BluetoothBlocked                               = $True
                    CameraBlocked                                  = $True
                    CellularBlockDataRoaming                       = $True
                    CellularBlockMessaging                         = $True
                    CellularBlockVoiceRoaming                      = $True
                    CellularBlockWiFiTethering                     = $True
                    CompliantAppListType                           = 'none'
                    CompliantAppsList                              = @(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                            appId       = 'FakeStringValue'
                            publisher   = 'FakeStringValue'
                            appStoreUrl = 'FakeStringValue'
                            name        = 'FakeStringValue'
                            odataType   = '#microsoft.graph.appleAppListItem'

                        } -ClientOnly)
                    )
                    DateAndTimeBlockChanges                        = $True
                    Description                                    = 'FakeStringValue'
                    DeviceSharingAllowed                           = $True
                    DiagnosticDataBlockSubmission                  = $True
                    DisplayName                                    = 'FakeStringValue'
                    FactoryResetBlocked                            = $True
                    GoogleAccountBlockAutoSync                     = $True
                    GooglePlayStoreBlocked                         = $True
                    Id                                             = 'FakeStringValue'
                    KioskModeApps                                  = @(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                            appId       = 'FakeStringValue'
                            publisher   = 'FakeStringValue'
                            appStoreUrl = 'FakeStringValue'
                            name        = 'FakeStringValue'
                            odataType   = '#microsoft.graph.appleAppListItem'

                        } -ClientOnly)
                    )
                    KioskModeBlockSleepButton                      = $True
                    KioskModeBlockVolumeButtons                    = $True
                    LocationServicesBlocked                        = $True
                    NfcBlocked                                     = $True
                    PasswordBlockFingerprintUnlock                 = $True
                    PasswordBlockTrustAgents                       = $True
                    PasswordExpirationDays                         = 25
                    PasswordMinimumLength                          = 25
                    PasswordMinutesOfInactivityBeforeScreenTimeout = 25
                    PasswordPreviousPasswordBlockCount             = 25
                    PasswordRequired                               = $True
                    PasswordRequiredType                           = 'deviceDefault'
                    PasswordSignInFailureCountBeforeFactoryReset   = 25
                    PowerOffBlocked                                = $True
                    RequiredPasswordComplexity                     = 'none'
                    ScreenCaptureBlocked                           = $True
                    SecurityRequireVerifyApps                      = $True
                    StorageBlockGoogleBackup                       = $True
                    StorageBlockRemovableStorage                   = $True
                    StorageRequireDeviceEncryption                 = $True
                    StorageRequireRemovableStorageEncryption       = $True
                    VoiceAssistantBlocked                          = $True
                    VoiceDialingBlocked                            = $True
                    WebBrowserBlockAutofill                        = $True
                    WebBrowserBlocked                              = $True
                    WebBrowserBlockJavaScript                      = $True
                    WebBrowserBlockPopups                          = $True
                    WebBrowserCookieSettings                       = 'browserDefault'
                    WiFiBlocked                                    = $True

                    Ensure                                         = 'Present'
                    Credential                                     = $Credential
                }

                Mock -CommandName Get-MgDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            AppsLaunchBlockList                            = @(
                                @{
                                    name          = 'FakeStringValue'
                                    appId         = 'FakeStringValue'
                                    appStoreUrl   = 'FakeStringValue'
                                    '@odata.type' = '#microsoft.graph.appleAppListItem'
                                    publisher     = 'FakeStringValue'

                                }
                            )
                            AppsInstallAllowList                           = @(
                                @{
                                    name          = 'FakeStringValue'
                                    appId         = 'FakeStringValue'
                                    appStoreUrl   = 'FakeStringValue'
                                    '@odata.type' = '#microsoft.graph.appleAppListItem'
                                    publisher     = 'FakeStringValue'

                                }
                            )
                            PasswordSignInFailureCountBeforeFactoryReset   = 7
                            '@odata.type'                                  = '#microsoft.graph.androidGeneralDeviceConfiguration'
                            RequiredPasswordComplexity                     = 'none'
                            AppsHideList                                   = @(
                                @{
                                    name          = 'FakeStringValue'
                                    appId         = 'FakeStringValue'
                                    appStoreUrl   = 'FakeStringValue'
                                    '@odata.type' = '#microsoft.graph.appleAppListItem'
                                    publisher     = 'FakeStringValue'

                                }
                            )
                            PasswordRequiredType                           = 'deviceDefault'
                            PasswordMinutesOfInactivityBeforeScreenTimeout = 7
                            CompliantAppListType                           = 'none'
                            WebBrowserCookieSettings                       = 'browserDefault'
                            CompliantAppsList                              = @(
                                @{
                                    name          = 'FakeStringValue'
                                    appId         = 'FakeStringValue'
                                    appStoreUrl   = 'FakeStringValue'
                                    '@odata.type' = '#microsoft.graph.appleAppListItem'
                                    publisher     = 'FakeStringValue'

                                }
                            )
                            PasswordPreviousPasswordBlockCount             = 7
                            KioskModeApps                                  = @(
                                @{
                                    name          = 'FakeStringValue'
                                    appId         = 'FakeStringValue'
                                    appStoreUrl   = 'FakeStringValue'
                                    '@odata.type' = '#microsoft.graph.appleAppListItem'
                                    publisher     = 'FakeStringValue'

                                }
                            )
                            PasswordExpirationDays                         = 7
                            PasswordMinimumLength                          = 7

                        }
                        Description          = 'FakeStringValue'
                        DisplayName          = 'FakeStringValue'
                        Id                   = 'FakeStringValue'

                    }
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
                Should -Invoke -CommandName Update-MgDeviceManagementDeviceConfiguration -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            AppsBlockCopyPaste                             = $True
                            StorageBlockRemovableStorage                   = $True
                            PowerOffBlocked                                = $True
                            KioskModeBlockSleepButton                      = $True
                            ScreenCaptureBlocked                           = $True
                            AppsLaunchBlockList                            = @(
                                @{
                                    name          = 'FakeStringValue'
                                    appId         = 'FakeStringValue'
                                    appStoreUrl   = 'FakeStringValue'
                                    '@odata.type' = '#microsoft.graph.appleAppListItem'
                                    publisher     = 'FakeStringValue'

                                }
                            )
                            PasswordMinimumLength                          = 25
                            PasswordRequired                               = $True
                            KioskModeBlockVolumeButtons                    = $True
                            PasswordSignInFailureCountBeforeFactoryReset   = 25
                            AppsBlockYouTube                               = $True
                            PasswordExpirationDays                         = 25
                            AppsHideList                                   = @(
                                @{
                                    name          = 'FakeStringValue'
                                    appId         = 'FakeStringValue'
                                    appStoreUrl   = 'FakeStringValue'
                                    '@odata.type' = '#microsoft.graph.appleAppListItem'
                                    publisher     = 'FakeStringValue'

                                }
                            )
                            LocationServicesBlocked                        = $True
                            WebBrowserBlockAutofill                        = $True
                            DateAndTimeBlockChanges                        = $True
                            FactoryResetBlocked                            = $True
                            PasswordRequiredType                           = 'deviceDefault'
                            WebBrowserBlockPopups                          = $True
                            StorageRequireRemovableStorageEncryption       = $True
                            PasswordPreviousPasswordBlockCount             = 25
                            KioskModeApps                                  = @(
                                @{
                                    name          = 'FakeStringValue'
                                    appId         = 'FakeStringValue'
                                    appStoreUrl   = 'FakeStringValue'
                                    '@odata.type' = '#microsoft.graph.appleAppListItem'
                                    publisher     = 'FakeStringValue'

                                }
                            )
                            WebBrowserBlockJavaScript                      = $True
                            PasswordMinutesOfInactivityBeforeScreenTimeout = 25
                            PasswordBlockFingerprintUnlock                 = $True
                            WiFiBlocked                                    = $True
                            CellularBlockMessaging                         = $True
                            GooglePlayStoreBlocked                         = $True
                            CellularBlockWiFiTethering                     = $True
                            StorageRequireDeviceEncryption                 = $True
                            NfcBlocked                                     = $True
                            DiagnosticDataBlockSubmission                  = $True
                            CellularBlockDataRoaming                       = $True
                            PasswordBlockTrustAgents                       = $True
                            RequiredPasswordComplexity                     = 'none'
                            '@odata.type'                                  = '#microsoft.graph.androidGeneralDeviceConfiguration'
                            CameraBlocked                                  = $True
                            WebBrowserCookieSettings                       = 'browserDefault'
                            DeviceSharingAllowed                           = $True
                            CompliantAppsList                              = @(
                                @{
                                    name          = 'FakeStringValue'
                                    appId         = 'FakeStringValue'
                                    appStoreUrl   = 'FakeStringValue'
                                    '@odata.type' = '#microsoft.graph.appleAppListItem'
                                    publisher     = 'FakeStringValue'

                                }
                            )
                            VoiceAssistantBlocked                          = $True
                            GoogleAccountBlockAutoSync                     = $True
                            VoiceDialingBlocked                            = $True
                            CompliantAppListType                           = 'none'
                            AppsBlockClipboardSharing                      = $True
                            AppsInstallAllowList                           = @(
                                @{
                                    name          = 'FakeStringValue'
                                    appId         = 'FakeStringValue'
                                    appStoreUrl   = 'FakeStringValue'
                                    '@odata.type' = '#microsoft.graph.appleAppListItem'
                                    publisher     = 'FakeStringValue'

                                }
                            )
                            WebBrowserBlocked                              = $True
                            SecurityRequireVerifyApps                      = $True
                            BluetoothBlocked                               = $True
                            StorageBlockGoogleBackup                       = $True
                            CellularBlockVoiceRoaming                      = $True

                        }
                        Description          = 'FakeStringValue'
                        DisplayName          = 'FakeStringValue'
                        Id                   = 'FakeStringValue'

                    }
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
