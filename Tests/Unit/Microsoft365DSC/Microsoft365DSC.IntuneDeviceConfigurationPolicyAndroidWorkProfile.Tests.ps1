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
    -DscResource "IntuneDeviceConfigurationPolicyAndroidWorkProfile" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString "Pass@word1" -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credential"
            }

            Mock -CommandName Select-MGProfile -MockWith {

            }

            Mock -CommandName New-MgDeviceManagementDeviceConfiguration -MockWith {
            }
            Mock -CommandName Update-MgDeviceManagementDeviceConfiguration -MockWith {
            }
            Mock -CommandName Remove-MgDeviceManagementDeviceConfiguration -MockWith {
            }
        }

        # Test contexts
        Context -Name "When the policy doesn't already exist" -Fixture {
            BeforeAll {
                $TestParams = @{
                    description                                                 = "Android device configuration policy";
                    displayName                                                 = "Android Work Profile - Device Restrictions - Standard";
                    passwordBlockFingerprintUnlock                              = $False;
                    passwordBlockTrustAgents                                    = $False;
                    passwordExpirationDays                                      = 10;
                    passwordMinimumLength                                       = 8;
                    passwordMinutesOfInactivityBeforeScreenTimeout              = 3;
                    passwordPreviousPasswordBlockCount                          = 3;
                    passwordSignInFailureCountBeforeFactoryReset                = 10;
                    passwordRequiredType                                        = "deviceDefault";
                    workProfileDataSharingType                                  = "deviceDefault";
                    workProfileBlockNotificationsWhileDeviceLocked              = $False;
                    workProfileBlockAddingAccounts                              = $False;
                    workProfileBluetoothEnableContactSharing                    = $False;
                    workProfileBlockScreenCapture                               = $False;
                    workProfileBlockCrossProfileCallerId                        = $False;
                    workProfileBlockCamera                                      = $False;
                    workProfileBlockCrossProfileContactsSearch                  = $False;
                    workProfileBlockCrossProfileCopyPaste                       = $False;
                    workProfileDefaultAppPermissionPolicy                       = "deviceDefault";
                    workProfilePasswordBlockFingerprintUnlock                   = $False;
                    workProfilePasswordBlockTrustAgents                         = $False;
                    workProfilePasswordExpirationDays                           = 90;
                    workProfilePasswordMinimumLength                            = 4;
                    workProfilePasswordMinNumericCharacters                     = 3;
                    workProfilePasswordMinNonLetterCharacters                   = 3;
                    workProfilePasswordMinLetterCharacters                      = 3;
                    workProfilePasswordMinLowerCaseCharacters                   = 3;
                    workProfilePasswordMinUpperCaseCharacters                   = 3;
                    workProfilePasswordMinSymbolCharacters                      = 3;
                    workProfilePasswordMinutesOfInactivityBeforeScreenTimeout   = 3;
                    workProfilePasswordPreviousPasswordBlockCount               = 3;
                    workProfilePasswordSignInFailureCountBeforeFactoryReset     = 3;
                    workProfilePasswordRequiredType                             = "deviceDefault";
                    workProfileRequirePassword                                  = $False;
                    securityRequireVerifyApps                                   = $False;
                    Ensure                                                      = "Present";
                    Credential                                                  = $Credential;
                }

                Mock -CommandName Get-MgDeviceManagementDeviceConfiguration -MockWith {
                    return $null
                }
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @TestParams).Ensure | Should -Be 'Absent'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @TestParams | Should -Be $false
            }

            It "Should create the policy from the Set method" {
                Set-TargetResource @TestParams -verbose
                Should -Invoke -CommandName "New-MgDeviceManagementDeviceConfiguration" -Exactly 1
            }
        }

        Context -Name "When the policy already exists and is NOT in the Desired State" -Fixture {
            BeforeAll {
                $TestParams = @{
                    description                                                 = "Android device configuration policy";
                    displayName                                                 = "Android Work Profile - Device Restrictions - Standard";
                    passwordBlockFingerprintUnlock                              = $False;
                    passwordBlockTrustAgents                                    = $False;
                    passwordExpirationDays                                      = 10;
                    passwordMinimumLength                                       = 8;
                    passwordMinutesOfInactivityBeforeScreenTimeout              = 3;
                    passwordPreviousPasswordBlockCount                          = 3;
                    passwordSignInFailureCountBeforeFactoryReset                = 10;
                    passwordRequiredType                                        = "deviceDefault";
                    workProfileDataSharingType                                  = "deviceDefault";
                    workProfileBlockNotificationsWhileDeviceLocked              = $False;
                    workProfileBlockAddingAccounts                              = $False;
                    workProfileBluetoothEnableContactSharing                    = $False;
                    workProfileBlockScreenCapture                               = $False;
                    workProfileBlockCrossProfileCallerId                        = $False;
                    workProfileBlockCamera                                      = $False;
                    workProfileBlockCrossProfileContactsSearch                  = $False;
                    workProfileBlockCrossProfileCopyPaste                       = $False;
                    workProfileDefaultAppPermissionPolicy                       = "deviceDefault";
                    workProfilePasswordBlockFingerprintUnlock                   = $False;
                    workProfilePasswordBlockTrustAgents                         = $False;
                    workProfilePasswordExpirationDays                           = 90;
                    workProfilePasswordMinimumLength                            = 4;
                    workProfilePasswordMinNumericCharacters                     = 3;
                    workProfilePasswordMinNonLetterCharacters                   = 3;
                    workProfilePasswordMinLetterCharacters                      = 3;
                    workProfilePasswordMinLowerCaseCharacters                   = 3;
                    workProfilePasswordMinUpperCaseCharacters                   = 3;
                    workProfilePasswordMinSymbolCharacters                      = 3;
                    workProfilePasswordMinutesOfInactivityBeforeScreenTimeout   = 3;
                    workProfilePasswordPreviousPasswordBlockCount               = 3;
                    workProfilePasswordSignInFailureCountBeforeFactoryReset     = 3;
                    workProfilePasswordRequiredType                             = "deviceDefault";
                    workProfileRequirePassword                                  = $False;
                    securityRequireVerifyApps                                   = $False;
                    Ensure                                                      = "Present";
                    Credential                                                  = $Credential;
                }

                Mock -CommandName Get-MgDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        id            = "12345-12345-12345-12345-12345"
                        AdditionalProperties = @{
                            '@odata.type'                                           = "#microsoft.graph.androidWorkProfileGeneralDeviceConfiguration"
                        }
                        description                                                 = "Android device configuration policy";
                        displayName                                                 = "Android Work Profile - Device Restrictions - Standard";
                        passwordBlockFingerprintUnlock                              = $False;
                        passwordBlockTrustAgents                                    = $True; #drift
                        passwordExpirationDays                                      = 10;
                        passwordMinimumLength                                       = 8;
                        passwordMinutesOfInactivityBeforeScreenTimeout              = 3;
                        passwordPreviousPasswordBlockCount                          = 3;
                        passwordSignInFailureCountBeforeFactoryReset                = 10;
                        passwordRequiredType                                        = "deviceDefault";
                        workProfileDataSharingType                                  = "deviceDefault";
                        workProfileBlockNotificationsWhileDeviceLocked              = $False;
                        workProfileBlockAddingAccounts                              = $False;
                        workProfileBluetoothEnableContactSharing                    = $False;
                        workProfileBlockScreenCapture                               = $False;
                        workProfileBlockCrossProfileCallerId                        = $False;
                        workProfileBlockCamera                                      = $False;
                        workProfileBlockCrossProfileContactsSearch                  = $False;
                        workProfileBlockCrossProfileCopyPaste                       = $False;
                        workProfileDefaultAppPermissionPolicy                       = "deviceDefault";
                        workProfilePasswordBlockFingerprintUnlock                   = $False;
                        workProfilePasswordBlockTrustAgents                         = $False;
                        workProfilePasswordExpirationDays                           = 90;
                        workProfilePasswordMinimumLength                            = 4;
                        workProfilePasswordMinNumericCharacters                     = 3;
                        workProfilePasswordMinNonLetterCharacters                   = 3;
                        workProfilePasswordMinLetterCharacters                      = 3;
                        workProfilePasswordMinLowerCaseCharacters                   = 3;
                        workProfilePasswordMinUpperCaseCharacters                   = 3;
                        workProfilePasswordMinSymbolCharacters                      = 3;
                        workProfilePasswordMinutesOfInactivityBeforeScreenTimeout   = 3;
                        workProfilePasswordPreviousPasswordBlockCount               = 3;
                        workProfilePasswordSignInFailureCountBeforeFactoryReset     = 3;
                        workProfilePasswordRequiredType                             = "deviceDefault";
                        workProfileRequirePassword                                  = $False;
                        securityRequireVerifyApps                                   = $False;
                    }
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @TestParams).Ensure | Should -Be 'Present'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @TestParams | Should -Be $false
            }

            It "Should update the policy from the Set method" {
                Set-TargetResource @TestParams
                Should -Invoke -CommandName Update-MgDeviceManagementDeviceConfiguration -Exactly 1
            }
        }

        Context -Name "When the policy already exists and IS in the Desired State" -Fixture {
            BeforeAll {

                $TestParams = @{
                    description                                                 = "Android device configuration policy";
                    displayName                                                 = "Android Work Profile - Device Restrictions - Standard";
                    passwordBlockFingerprintUnlock                              = $False;
                    passwordBlockTrustAgents                                    = $False;
                    passwordExpirationDays                                      = 10;
                    passwordMinimumLength                                       = 8;
                    passwordMinutesOfInactivityBeforeScreenTimeout              = 3;
                    passwordPreviousPasswordBlockCount                          = 3;
                    passwordSignInFailureCountBeforeFactoryReset                = 10;
                    passwordRequiredType                                        = "deviceDefault";
                    workProfileDataSharingType                                  = "deviceDefault";
                    workProfileBlockNotificationsWhileDeviceLocked              = $False;
                    workProfileBlockAddingAccounts                              = $False;
                    workProfileBluetoothEnableContactSharing                    = $False;
                    workProfileBlockScreenCapture                               = $False;
                    workProfileBlockCrossProfileCallerId                        = $False;
                    workProfileBlockCamera                                      = $False;
                    workProfileBlockCrossProfileContactsSearch                  = $False;
                    workProfileBlockCrossProfileCopyPaste                       = $False;
                    workProfileDefaultAppPermissionPolicy                       = "deviceDefault";
                    workProfilePasswordBlockFingerprintUnlock                   = $False;
                    workProfilePasswordBlockTrustAgents                         = $False;
                    workProfilePasswordExpirationDays                           = 90;
                    workProfilePasswordMinimumLength                            = 4;
                    workProfilePasswordMinNumericCharacters                     = 3;
                    workProfilePasswordMinNonLetterCharacters                   = 3;
                    workProfilePasswordMinLetterCharacters                      = 3;
                    workProfilePasswordMinLowerCaseCharacters                   = 3;
                    workProfilePasswordMinUpperCaseCharacters                   = 3;
                    workProfilePasswordMinSymbolCharacters                      = 3;
                    workProfilePasswordMinutesOfInactivityBeforeScreenTimeout   = 3;
                    workProfilePasswordPreviousPasswordBlockCount               = 3;
                    workProfilePasswordSignInFailureCountBeforeFactoryReset     = 3;
                    workProfilePasswordRequiredType                             = "deviceDefault";
                    workProfileRequirePassword                                  = $False;
                    securityRequireVerifyApps                                   = $False;
                    Ensure                                                      = "Present";
                    Credential                                                  = $Credential;
                }

                Mock -CommandName Get-MgDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        id = "12345-12345-12345-12345-12345"
                        displayName = "Android Work Profile - Device Restrictions - Standard"
                        description = "Android device configuration policy"
                        AdditionalProperties = @{
                            '@odata.type'                                  = "#microsoft.graph.androidWorkProfileGeneralDeviceConfiguration"
                            passwordBlockFingerprintUnlock                              = $False;
                            passwordBlockTrustAgents                                    = $False;
                            passwordExpirationDays                                      = 10;
                            passwordMinimumLength                                       = 8;
                            passwordMinutesOfInactivityBeforeScreenTimeout              = 3;
                            passwordPreviousPasswordBlockCount                          = 3;
                            passwordSignInFailureCountBeforeFactoryReset                = 10;
                            passwordRequiredType                                        = "deviceDefault";
                            workProfileDataSharingType                                  = "deviceDefault";
                            workProfileBlockNotificationsWhileDeviceLocked              = $False;
                            workProfileBlockAddingAccounts                              = $False;
                            workProfileBluetoothEnableContactSharing                    = $False;
                            workProfileBlockScreenCapture                               = $False;
                            workProfileBlockCrossProfileCallerId                        = $False;
                            workProfileBlockCamera                                      = $False;
                            workProfileBlockCrossProfileContactsSearch                  = $False;
                            workProfileBlockCrossProfileCopyPaste                       = $False;
                            workProfileDefaultAppPermissionPolicy                       = "deviceDefault";
                            workProfilePasswordBlockFingerprintUnlock                   = $False;
                            workProfilePasswordBlockTrustAgents                         = $False;
                            workProfilePasswordExpirationDays                           = 90;
                            workProfilePasswordMinimumLength                            = 4;
                            workProfilePasswordMinNumericCharacters                     = 3;
                            workProfilePasswordMinNonLetterCharacters                   = 3;
                            workProfilePasswordMinLetterCharacters                      = 3;
                            workProfilePasswordMinLowerCaseCharacters                   = 3;
                            workProfilePasswordMinUpperCaseCharacters                   = 3;
                            workProfilePasswordMinSymbolCharacters                      = 3;
                            workProfilePasswordMinutesOfInactivityBeforeScreenTimeout   = 3;
                            workProfilePasswordPreviousPasswordBlockCount               = 3;
                            workProfilePasswordSignInFailureCountBeforeFactoryReset     = 3;
                            workProfilePasswordRequiredType                             = "deviceDefault";
                            workProfileRequirePassword                                  = $False;
                            securityRequireVerifyApps                                   = $False;
                        }
                    }
                }
            }

            It "Should return true from the Test method" {
                Test-TargetResource @TestParams | Should -Be $true
            }
        }

        Context -Name "When the policy exists and it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName        = "Android Work Profile - Device Restrictions - Standard"
                    Ensure             = 'Absent'
                    Credential         = $Credential;
                }

                Mock -CommandName Get-MgDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        id = "12345-12345-12345-12345-12345"
                        displayName = "Android Work Profile - Device Restrictions - Standard"
                        description = "Android device configuration policy"
                        AdditionalProperties = @{
                            '@odata.type'                                               = "#microsoft.graph.androidWorkProfileGeneralDeviceConfiguration"
                            passwordBlockFingerprintUnlock                              = $False;
                            passwordBlockTrustAgents                                    = $False;
                            passwordExpirationDays                                      = 10;
                            passwordMinimumLength                                       = 8;
                            passwordMinutesOfInactivityBeforeScreenTimeout              = 3;
                            passwordPreviousPasswordBlockCount                          = 3;
                            passwordSignInFailureCountBeforeFactoryReset                = 10;
                            passwordRequiredType                                        = "deviceDefault";
                            workProfileDataSharingType                                  = "deviceDefault";
                            workProfileBlockNotificationsWhileDeviceLocked              = $False;
                            workProfileBlockAddingAccounts                              = $False;
                            workProfileBluetoothEnableContactSharing                    = $False;
                            workProfileBlockScreenCapture                               = $False;
                            workProfileBlockCrossProfileCallerId                        = $False;
                            workProfileBlockCamera                                      = $False;
                            workProfileBlockCrossProfileContactsSearch                  = $False;
                            workProfileBlockCrossProfileCopyPaste                       = $False;
                            workProfileDefaultAppPermissionPolicy                       = "deviceDefault";
                            workProfilePasswordBlockFingerprintUnlock                   = $False;
                            workProfilePasswordBlockTrustAgents                         = $False;
                            workProfilePasswordExpirationDays                           = 90;
                            workProfilePasswordMinimumLength                            = 4;
                            workProfilePasswordMinNumericCharacters                     = 3;
                            workProfilePasswordMinNonLetterCharacters                   = 3;
                            workProfilePasswordMinLetterCharacters                      = 3;
                            workProfilePasswordMinLowerCaseCharacters                   = 3;
                            workProfilePasswordMinUpperCaseCharacters                   = 3;
                            workProfilePasswordMinSymbolCharacters                      = 3;
                            workProfilePasswordMinutesOfInactivityBeforeScreenTimeout   = 3;
                            workProfilePasswordPreviousPasswordBlockCount               = 3;
                            workProfilePasswordSignInFailureCountBeforeFactoryReset     = 3;
                            workProfilePasswordRequiredType                             = "deviceDefault";
                            workProfileRequirePassword                                  = $False;
                            securityRequireVerifyApps                                   = $False;
                        }
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
                Should -Invoke -CommandName Remove-MgDeviceManagementDeviceConfiguration -Exactly 1
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        id = "12345-12345-12345-12345-12345"
                        displayName = "Android Work Profile - Device Restrictions - Standard"
                        description = "Android device configuration policy"
                        AdditionalProperties = @{
                            '@odata.type'                                               = "#microsoft.graph.androidWorkProfileGeneralDeviceConfiguration"
                            passwordBlockFingerprintUnlock                              = $False;
                            passwordBlockTrustAgents                                    = $False;
                            passwordExpirationDays                                      = 10;
                            passwordMinimumLength                                       = 8;
                            passwordMinutesOfInactivityBeforeScreenTimeout              = 3;
                            passwordPreviousPasswordBlockCount                          = 3;
                            passwordSignInFailureCountBeforeFactoryReset                = 10;
                            passwordRequiredType                                        = "deviceDefault";
                            workProfileDataSharingType                                  = "deviceDefault";
                            workProfileBlockNotificationsWhileDeviceLocked              = $False;
                            workProfileBlockAddingAccounts                              = $False;
                            workProfileBluetoothEnableContactSharing                    = $False;
                            workProfileBlockScreenCapture                               = $False;
                            workProfileBlockCrossProfileCallerId                        = $False;
                            workProfileBlockCamera                                      = $False;
                            workProfileBlockCrossProfileContactsSearch                  = $False;
                            workProfileBlockCrossProfileCopyPaste                       = $False;
                            workProfileDefaultAppPermissionPolicy                       = "deviceDefault";
                            workProfilePasswordBlockFingerprintUnlock                   = $False;
                            workProfilePasswordBlockTrustAgents                         = $False;
                            workProfilePasswordExpirationDays                           = 90;
                            workProfilePasswordMinimumLength                            = 4;
                            workProfilePasswordMinNumericCharacters                     = 3;
                            workProfilePasswordMinNonLetterCharacters                   = 3;
                            workProfilePasswordMinLetterCharacters                      = 3;
                            workProfilePasswordMinLowerCaseCharacters                   = 3;
                            workProfilePasswordMinUpperCaseCharacters                   = 3;
                            workProfilePasswordMinSymbolCharacters                      = 3;
                            workProfilePasswordMinutesOfInactivityBeforeScreenTimeout   = 3;
                            workProfilePasswordPreviousPasswordBlockCount               = 3;
                            workProfilePasswordSignInFailureCountBeforeFactoryReset     = 3;
                            workProfilePasswordRequiredType                             = "deviceDefault";
                            workProfileRequirePassword                                  = $False;
                            securityRequireVerifyApps                                   = $False;
                        }
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
