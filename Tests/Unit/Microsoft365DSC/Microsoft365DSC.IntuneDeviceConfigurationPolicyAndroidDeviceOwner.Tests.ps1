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
    -DscResource "IntuneDeviceConfigurationPolicyAndroidDeviceOwner" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)


            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {
            }

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
                return "Credential"
            }
        }
        # Test contexts
        Context -Name "The instance should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Credential                                  = $Credential;
                    DisplayName                                 = "Display Name value";
                    EnrollmentProfile                           = "notConfigured";
                    Ensure                                      = "Present";
                    Id                                          = "746a47b3-118a-487d-a3ec-7a04149825ca";
                    RoleScopeTagIds                             = @("0");
                    SupportsScopeTags                           = $True;
                    Version                                     = 1;
                }

                Mock -CommandName Get-MgDeviceManagementDeviceConfiguration -MockWith {
                    return $null
                }
            }
            It "Should return Values from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should create the instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-MgDeviceManagementDeviceConfiguration -Exactly 1
            }
        }

        Context -Name "The instance exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Credential                                  = $Credential;
                    DisplayName                                 = "Display Name value";
                    EnrollmentProfile                           = "notConfigured";
                    Ensure                                      = "Absent";
                    Id                                          = "746a47b3-118a-487d-a3ec-7a04149825ca";
                    RoleScopeTagIds                             = @("0");
                    SupportsScopeTags                           = $True;
                    Version                                     = 1;
                }

                Mock -CommandName Get-MgDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        DisplayName          = "Display Name value"
                        AdditionalProperties = @{
                            '@odata.type'                         = '#microsoft.graph.androidDeviceOwnerGeneralDeviceConfiguration'
                            crossProfilePoliciesAllowDataSharing  = 'notConfigured'
                            enrollmentProfile                     = 'notConfigured'
                            factoryResetDeviceAdministratorEmails = @()
                            kioskCustomizationStatusBar           = 'notConfigured'
                            kioskCustomizationSystemNavigation    = 'notConfigured'
                            kioskModeWifiAllowedSsids             = @()
                            kioskModeUseManagedHomeScreenApp      = 'notConfigured'
                            passwordBlockKeyguardFeatures         = @()
                            passwordRequiredType                  = 'deviceDefault'
                            passwordRequireUnlock                 = 'deviceDefault'
                            securityRequireVerifyApps             = $True
                            stayOnModes                           = @()
                            vpnAlwaysOnLockdownMode               = $False
                            vpnAlwaysOnPackageIdentifier          = $null
                            personalProfilePlayStoreMode          ='notConfigured'
                            workProfilePasswordRequiredType       ='deviceDefault'
                            workProfilePasswordRequireUnlock      ='deviceDefault'
                            azureAdSharedDeviceDataClearApps      = @()
                            kioskModeApps                         = @()
                            kioskModeManagedFolders               = @()
                            kioskModeAppPositions                 = @()
                            systemUpdateFreezePeriods             = @()
                            personalProfilePersonalApplications   = @()
                        }
                    }
                }
            }

            It "Should return Values from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgDeviceManagementDeviceConfiguration -Exactly 1
            }
        }
        Context -Name "The instance Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{

                    Credential                                  = $Credential;
                    DisplayName                                 = "Display Name value";
                    EnrollmentProfile                           = "notConfigured";
                    Ensure                                      = "Present";
                }

                Mock -CommandName Get-MgDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        DisplayName          = "Display Name value"
                        AdditionalProperties = @{
                            '@odata.type'                         = '#microsoft.graph.androidDeviceOwnerGeneralDeviceConfiguration'
                            crossProfilePoliciesAllowDataSharing  = 'notConfigured'
                            enrollmentProfile                     = 'notConfigured'
                            factoryResetDeviceAdministratorEmails = @()
                            kioskCustomizationStatusBar           = 'notConfigured'
                            kioskCustomizationSystemNavigation    = 'notConfigured'
                            kioskModeWifiAllowedSsids             = @()
                            kioskModeUseManagedHomeScreenApp      = 'notConfigured'
                            passwordBlockKeyguardFeatures         = @()
                            passwordRequiredType                  = 'deviceDefault'
                            passwordRequireUnlock                 = 'deviceDefault'
                            securityRequireVerifyApps             = $True
                            stayOnModes                           = @()
                            vpnAlwaysOnLockdownMode               = $False
                            vpnAlwaysOnPackageIdentifier          = $null
                            personalProfilePlayStoreMode          ='notConfigured'
                            workProfilePasswordRequiredType       ='deviceDefault'
                            workProfilePasswordRequireUnlock      ='deviceDefault'
                            azureAdSharedDeviceDataClearApps      = @()
                            kioskModeApps                         = @()
                            kioskModeManagedFolders               = @()
                            kioskModeAppPositions                 = @()
                            systemUpdateFreezePeriods             = @()
                            personalProfilePersonalApplications   = @()
                        }
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The instance exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Credential                                  = $Credential;
                    DisplayName                                 = "Display Name value";
                    EnrollmentProfile                           = "notConfigured";
                    Ensure                                      = "Present";
                    Id                                          = "746a47b3-118a-487d-a3ec-7a04149825ca";
                    RoleScopeTagIds                             = @("0");
                    SupportsScopeTags                           = $True;
                    Version                                     = 1;
                }

                Mock -CommandName Get-MgDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        DisplayName          = "Display Name value"
                        AdditionalProperties = @{
                            '@odata.type'                         = '#microsoft.graph.androidDeviceOwnerGeneralDeviceConfiguration'
                            crossProfilePoliciesAllowDataSharing  = 'notConfigured'
                            enrollmentProfile                     = 'deviceDefault' #drift
                            factoryResetDeviceAdministratorEmails = @()
                            kioskCustomizationStatusBar           = 'notConfigured'
                            kioskCustomizationSystemNavigation    = 'notConfigured'
                            kioskModeWifiAllowedSsids             = @()
                            kioskModeUseManagedHomeScreenApp      = 'notConfigured'
                            passwordBlockKeyguardFeatures         = @()
                            passwordRequiredType                  = 'deviceDefault'
                            passwordRequireUnlock                 = 'deviceDefault'
                            securityRequireVerifyApps             = $True
                            stayOnModes                           = @()
                            vpnAlwaysOnLockdownMode               = $False
                            vpnAlwaysOnPackageIdentifier          = $null
                            personalProfilePlayStoreMode          ='notConfigured'
                            workProfilePasswordRequiredType       ='deviceDefault'
                            workProfilePasswordRequireUnlock      ='deviceDefault'
                            azureAdSharedDeviceDataClearApps      = @()
                            kioskModeApps                         = @()
                            kioskModeManagedFolders               = @()
                            kioskModeAppPositions                 = @()
                            systemUpdateFreezePeriods             = @()
                            personalProfilePersonalApplications   = @()
                        }
                    }
                }
            }

            It "Should return Values from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgDeviceManagementDeviceConfiguration -Exactly 1
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties =@{
                            AppsBlockCopyPaste = $True
                            StorageBlockRemovableStorage = $True
                            PowerOffBlocked = $True
                            KioskModeBlockSleepButton = $True
                            ScreenCaptureBlocked = $True
                            AppsLaunchBlockList =@(
                                @{
                                    name = "FakeStringValue"
                                    appId = "FakeStringValue"
                                    appStoreUrl = "FakeStringValue"
                                    '@odata.type' = "#microsoft.graph.appleAppListItem"
                                    publisher = "FakeStringValue"

                                }
                            )
                            PasswordMinimumLength = 25
                            PasswordRequired = $True
                            KioskModeBlockVolumeButtons = $True
                            PasswordSignInFailureCountBeforeFactoryReset = 25
                            AppsBlockYouTube = $True
                            PasswordExpirationDays = 25
                            AppsHideList =@(
                                @{
                                    name = "FakeStringValue"
                                    appId = "FakeStringValue"
                                    appStoreUrl = "FakeStringValue"
                                    '@odata.type' = "#microsoft.graph.appleAppListItem"
                                    publisher = "FakeStringValue"

                                }
                            )
                            LocationServicesBlocked = $True
                            WebBrowserBlockAutofill = $True
                            DateAndTimeBlockChanges = $True
                            FactoryResetBlocked = $True
                            PasswordRequiredType = "deviceDefault"
                            WebBrowserBlockPopups = $True
                            StorageRequireRemovableStorageEncryption = $True
                            PasswordPreviousPasswordBlockCount = 25
                            KioskModeApps =@(
                                @{
                                    name = "FakeStringValue"
                                    appId = "FakeStringValue"
                                    appStoreUrl = "FakeStringValue"
                                    '@odata.type' = "#microsoft.graph.appleAppListItem"
                                    publisher = "FakeStringValue"

                                }
                            )
                            WebBrowserBlockJavaScript = $True
                            PasswordMinutesOfInactivityBeforeScreenTimeout = 25
                            PasswordBlockFingerprintUnlock = $True
                            WiFiBlocked = $True
                            CellularBlockMessaging = $True
                            GooglePlayStoreBlocked = $True
                            CellularBlockWiFiTethering = $True
                            StorageRequireDeviceEncryption = $True
                            NfcBlocked = $True
                            DiagnosticDataBlockSubmission = $True
                            CellularBlockDataRoaming = $True
                            PasswordBlockTrustAgents = $True
                            RequiredPasswordComplexity = "none"
                            '@odata.type' = "#microsoft.graph.androidGeneralDeviceConfiguration"
                            CameraBlocked = $True
                            WebBrowserCookieSettings = "browserDefault"
                            DeviceSharingAllowed = $True
                            CompliantAppsList =@(
                                @{
                                    name = "FakeStringValue"
                                    appId = "FakeStringValue"
                                    appStoreUrl = "FakeStringValue"
                                    '@odata.type' = "#microsoft.graph.appleAppListItem"
                                    publisher = "FakeStringValue"

                                }
                            )
                            VoiceAssistantBlocked = $True
                            GoogleAccountBlockAutoSync = $True
                            VoiceDialingBlocked = $True
                            CompliantAppListType = "none"
                            AppsBlockClipboardSharing = $True
                            AppsInstallAllowList =@(
                                @{
                                    name = "FakeStringValue"
                                    appId = "FakeStringValue"
                                    appStoreUrl = "FakeStringValue"
                                    '@odata.type' = "#microsoft.graph.appleAppListItem"
                                    publisher = "FakeStringValue"

                                }
                            )
                            WebBrowserBlocked = $True
                            SecurityRequireVerifyApps = $True
                            BluetoothBlocked = $True
                            StorageBlockGoogleBackup = $True
                            CellularBlockVoiceRoaming = $True

                        }
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        Id = "FakeStringValue"

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
