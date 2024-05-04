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
    -DscResource 'IntuneDeviceConfigurationPolicyAndroidWorkProfile' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString ((New-Guid).ToString()) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName New-MgBetaDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName Update-MgBetaDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName Remove-MgBetaDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName Get-MgBetaDeviceManagementDeviceConfigurationAssignment -MockWith {
                return @()
            }
            Mock -CommandName Update-DeviceConfigurationPolicyAssignment -MockWith {
            }
            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name "When the policy doesn't already exist" -Fixture {
            BeforeAll {
                $TestParams = @{
                    description                                               = 'Android device configuration policy'
                    displayName                                               = 'Android Work Profile - Device Restrictions - Standard'
                    passwordBlockFingerprintUnlock                            = $False
                    passwordBlockTrustAgents                                  = $False
                    passwordExpirationDays                                    = 10
                    passwordMinimumLength                                     = 8
                    passwordMinutesOfInactivityBeforeScreenTimeout            = 3
                    passwordPreviousPasswordBlockCount                        = 3
                    passwordSignInFailureCountBeforeFactoryReset              = 10
                    passwordRequiredType                                      = 'deviceDefault'
                    workProfileDataSharingType                                = 'deviceDefault'
                    workProfileBlockNotificationsWhileDeviceLocked            = $False
                    workProfileBlockAddingAccounts                            = $False
                    workProfileBluetoothEnableContactSharing                  = $False
                    workProfileBlockScreenCapture                             = $False
                    workProfileBlockCrossProfileCallerId                      = $False
                    workProfileBlockCamera                                    = $False
                    workProfileBlockCrossProfileContactsSearch                = $False
                    workProfileBlockCrossProfileCopyPaste                     = $False
                    workProfileDefaultAppPermissionPolicy                     = 'deviceDefault'
                    workProfilePasswordBlockFingerprintUnlock                 = $False
                    workProfilePasswordBlockTrustAgents                       = $False
                    workProfilePasswordExpirationDays                         = 90
                    workProfilePasswordMinimumLength                          = 4
                    workProfilePasswordMinNumericCharacters                   = 3
                    workProfilePasswordMinNonLetterCharacters                 = 3
                    workProfilePasswordMinLetterCharacters                    = 3
                    workProfilePasswordMinLowerCaseCharacters                 = 3
                    workProfilePasswordMinUpperCaseCharacters                 = 3
                    workProfilePasswordMinSymbolCharacters                    = 3
                    workProfilePasswordMinutesOfInactivityBeforeScreenTimeout = 3
                    workProfilePasswordPreviousPasswordBlockCount             = 3
                    workProfilePasswordSignInFailureCountBeforeFactoryReset   = 3
                    workProfilePasswordRequiredType                           = 'deviceDefault'
                    workProfileRequirePassword                                = $False
                    securityRequireVerifyApps                                 = $False
                    Ensure                                                    = 'Present'
                    Credential                                                = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return $null
                }
            }

            It 'Should return absent from the Get method' {
                (Get-TargetResource @TestParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @TestParams | Should -Be $false
            }

            It 'Should create the policy from the Set method' {
                Set-TargetResource @TestParams
                Should -Invoke -CommandName 'New-MgBetaDeviceManagementDeviceConfiguration' -Exactly 1
            }
        }

        Context -Name 'When the policy already exists and is NOT in the Desired State' -Fixture {
            BeforeAll {
                $TestParams = @{
                    description                                               = 'Android device configuration policy'
                    displayName                                               = 'Android Work Profile - Device Restrictions - Standard'
                    passwordBlockFingerprintUnlock                            = $False
                    passwordBlockTrustAgents                                  = $False
                    passwordExpirationDays                                    = 10
                    passwordMinimumLength                                     = 8
                    passwordMinutesOfInactivityBeforeScreenTimeout            = 3
                    passwordPreviousPasswordBlockCount                        = 3
                    passwordSignInFailureCountBeforeFactoryReset              = 10
                    passwordRequiredType                                      = 'deviceDefault'
                    workProfileDataSharingType                                = 'deviceDefault'
                    workProfileBlockNotificationsWhileDeviceLocked            = $False
                    workProfileBlockAddingAccounts                            = $False
                    workProfileBluetoothEnableContactSharing                  = $False
                    workProfileBlockScreenCapture                             = $False
                    workProfileBlockCrossProfileCallerId                      = $False
                    workProfileBlockCamera                                    = $False
                    workProfileBlockCrossProfileContactsSearch                = $False
                    workProfileBlockCrossProfileCopyPaste                     = $False
                    workProfileDefaultAppPermissionPolicy                     = 'deviceDefault'
                    workProfilePasswordBlockFingerprintUnlock                 = $False
                    workProfilePasswordBlockTrustAgents                       = $False
                    workProfilePasswordExpirationDays                         = 90
                    workProfilePasswordMinimumLength                          = 4
                    workProfilePasswordMinNumericCharacters                   = 3
                    workProfilePasswordMinNonLetterCharacters                 = 3
                    workProfilePasswordMinLetterCharacters                    = 3
                    workProfilePasswordMinLowerCaseCharacters                 = 3
                    workProfilePasswordMinUpperCaseCharacters                 = 3
                    workProfilePasswordMinSymbolCharacters                    = 3
                    workProfilePasswordMinutesOfInactivityBeforeScreenTimeout = 3
                    workProfilePasswordPreviousPasswordBlockCount             = 3
                    workProfilePasswordSignInFailureCountBeforeFactoryReset   = 3
                    workProfilePasswordRequiredType                           = 'deviceDefault'
                    workProfileRequirePassword                                = $False
                    securityRequireVerifyApps                                 = $False
                    Ensure                                                    = 'Present'
                    Credential                                                = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        id                                                        = '12345-12345-12345-12345-12345'
                        AdditionalProperties                                      = @{
                            '@odata.type' = '#microsoft.graph.androidWorkProfileGeneralDeviceConfiguration'
                        }
                        description                                               = 'Android device configuration policy'
                        displayName                                               = 'Android Work Profile - Device Restrictions - Standard'
                        passwordBlockFingerprintUnlock                            = $False
                        passwordBlockTrustAgents                                  = $True; #drift
                        passwordExpirationDays                                    = 10
                        passwordMinimumLength                                     = 8
                        passwordMinutesOfInactivityBeforeScreenTimeout            = 3
                        passwordPreviousPasswordBlockCount                        = 3
                        passwordSignInFailureCountBeforeFactoryReset              = 10
                        passwordRequiredType                                      = 'deviceDefault'
                        workProfileDataSharingType                                = 'deviceDefault'
                        workProfileBlockNotificationsWhileDeviceLocked            = $False
                        workProfileBlockAddingAccounts                            = $False
                        workProfileBluetoothEnableContactSharing                  = $False
                        workProfileBlockScreenCapture                             = $False
                        workProfileBlockCrossProfileCallerId                      = $False
                        workProfileBlockCamera                                    = $False
                        workProfileBlockCrossProfileContactsSearch                = $False
                        workProfileBlockCrossProfileCopyPaste                     = $False
                        workProfileDefaultAppPermissionPolicy                     = 'deviceDefault'
                        workProfilePasswordBlockFingerprintUnlock                 = $False
                        workProfilePasswordBlockTrustAgents                       = $False
                        workProfilePasswordExpirationDays                         = 90
                        workProfilePasswordMinimumLength                          = 4
                        workProfilePasswordMinNumericCharacters                   = 3
                        workProfilePasswordMinNonLetterCharacters                 = 3
                        workProfilePasswordMinLetterCharacters                    = 3
                        workProfilePasswordMinLowerCaseCharacters                 = 3
                        workProfilePasswordMinUpperCaseCharacters                 = 3
                        workProfilePasswordMinSymbolCharacters                    = 3
                        workProfilePasswordMinutesOfInactivityBeforeScreenTimeout = 3
                        workProfilePasswordPreviousPasswordBlockCount             = 3
                        workProfilePasswordSignInFailureCountBeforeFactoryReset   = 3
                        workProfilePasswordRequiredType                           = 'deviceDefault'
                        workProfileRequirePassword                                = $False
                        securityRequireVerifyApps                                 = $False
                    }
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @TestParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @TestParams | Should -Be $false
            }

            It 'Should update the policy from the Set method' {
                Set-TargetResource @TestParams
                Should -Invoke -CommandName Update-MgBetaDeviceManagementDeviceConfiguration -Exactly 1
            }
        }

        Context -Name 'When the policy already exists and IS in the Desired State' -Fixture {
            BeforeAll {

                $TestParams = @{
                    description                                               = 'Android device configuration policy'
                    displayName                                               = 'Android Work Profile - Device Restrictions - Standard'
                    passwordBlockFingerprintUnlock                            = $False
                    passwordBlockTrustAgents                                  = $False
                    passwordExpirationDays                                    = 10
                    passwordMinimumLength                                     = 8
                    passwordMinutesOfInactivityBeforeScreenTimeout            = 3
                    passwordPreviousPasswordBlockCount                        = 3
                    passwordSignInFailureCountBeforeFactoryReset              = 10
                    passwordRequiredType                                      = 'deviceDefault'
                    workProfileDataSharingType                                = 'deviceDefault'
                    workProfileBlockNotificationsWhileDeviceLocked            = $False
                    workProfileBlockAddingAccounts                            = $False
                    workProfileBluetoothEnableContactSharing                  = $False
                    workProfileBlockScreenCapture                             = $False
                    workProfileBlockCrossProfileCallerId                      = $False
                    workProfileBlockCamera                                    = $False
                    workProfileBlockCrossProfileContactsSearch                = $False
                    workProfileBlockCrossProfileCopyPaste                     = $False
                    workProfileDefaultAppPermissionPolicy                     = 'deviceDefault'
                    workProfilePasswordBlockFingerprintUnlock                 = $False
                    workProfilePasswordBlockTrustAgents                       = $False
                    workProfilePasswordExpirationDays                         = 90
                    workProfilePasswordMinimumLength                          = 4
                    workProfilePasswordMinNumericCharacters                   = 3
                    workProfilePasswordMinNonLetterCharacters                 = 3
                    workProfilePasswordMinLetterCharacters                    = 3
                    workProfilePasswordMinLowerCaseCharacters                 = 3
                    workProfilePasswordMinUpperCaseCharacters                 = 3
                    workProfilePasswordMinSymbolCharacters                    = 3
                    workProfilePasswordMinutesOfInactivityBeforeScreenTimeout = 3
                    workProfilePasswordPreviousPasswordBlockCount             = 3
                    workProfilePasswordSignInFailureCountBeforeFactoryReset   = 3
                    workProfilePasswordRequiredType                           = 'deviceDefault'
                    workProfileRequirePassword                                = $False
                    securityRequireVerifyApps                                 = $False
                    Ensure                                                    = 'Present'
                    Credential                                                = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        id                   = '12345-12345-12345-12345-12345'
                        displayName          = 'Android Work Profile - Device Restrictions - Standard'
                        description          = 'Android device configuration policy'
                        AdditionalProperties = @{
                            '@odata.type'                                             = '#microsoft.graph.androidWorkProfileGeneralDeviceConfiguration'
                            passwordBlockFingerprintUnlock                            = $False
                            passwordBlockTrustAgents                                  = $False
                            passwordExpirationDays                                    = 10
                            passwordMinimumLength                                     = 8
                            passwordMinutesOfInactivityBeforeScreenTimeout            = 3
                            passwordPreviousPasswordBlockCount                        = 3
                            passwordSignInFailureCountBeforeFactoryReset              = 10
                            passwordRequiredType                                      = 'deviceDefault'
                            workProfileDataSharingType                                = 'deviceDefault'
                            workProfileBlockNotificationsWhileDeviceLocked            = $False
                            workProfileBlockAddingAccounts                            = $False
                            workProfileBluetoothEnableContactSharing                  = $False
                            workProfileBlockScreenCapture                             = $False
                            workProfileBlockCrossProfileCallerId                      = $False
                            workProfileBlockCamera                                    = $False
                            workProfileBlockCrossProfileContactsSearch                = $False
                            workProfileBlockCrossProfileCopyPaste                     = $False
                            workProfileDefaultAppPermissionPolicy                     = 'deviceDefault'
                            workProfilePasswordBlockFingerprintUnlock                 = $False
                            workProfilePasswordBlockTrustAgents                       = $False
                            workProfilePasswordExpirationDays                         = 90
                            workProfilePasswordMinimumLength                          = 4
                            workProfilePasswordMinNumericCharacters                   = 3
                            workProfilePasswordMinNonLetterCharacters                 = 3
                            workProfilePasswordMinLetterCharacters                    = 3
                            workProfilePasswordMinLowerCaseCharacters                 = 3
                            workProfilePasswordMinUpperCaseCharacters                 = 3
                            workProfilePasswordMinSymbolCharacters                    = 3
                            workProfilePasswordMinutesOfInactivityBeforeScreenTimeout = 3
                            workProfilePasswordPreviousPasswordBlockCount             = 3
                            workProfilePasswordSignInFailureCountBeforeFactoryReset   = 3
                            workProfilePasswordRequiredType                           = 'deviceDefault'
                            workProfileRequirePassword                                = $False
                            securityRequireVerifyApps                                 = $False
                        }
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @TestParams | Should -Be $true
            }
        }

        Context -Name 'When the policy exists and it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName = 'Android Work Profile - Device Restrictions - Standard'
                    Ensure      = 'Absent'
                    Credential  = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        id                   = '12345-12345-12345-12345-12345'
                        displayName          = 'Android Work Profile - Device Restrictions - Standard'
                        description          = 'Android device configuration policy'
                        AdditionalProperties = @{
                            '@odata.type'                                             = '#microsoft.graph.androidWorkProfileGeneralDeviceConfiguration'
                            passwordBlockFingerprintUnlock                            = $False
                            passwordBlockTrustAgents                                  = $False
                            passwordExpirationDays                                    = 10
                            passwordMinimumLength                                     = 8
                            passwordMinutesOfInactivityBeforeScreenTimeout            = 3
                            passwordPreviousPasswordBlockCount                        = 3
                            passwordSignInFailureCountBeforeFactoryReset              = 10
                            passwordRequiredType                                      = 'deviceDefault'
                            workProfileDataSharingType                                = 'deviceDefault'
                            workProfileBlockNotificationsWhileDeviceLocked            = $False
                            workProfileBlockAddingAccounts                            = $False
                            workProfileBluetoothEnableContactSharing                  = $False
                            workProfileBlockScreenCapture                             = $False
                            workProfileBlockCrossProfileCallerId                      = $False
                            workProfileBlockCamera                                    = $False
                            workProfileBlockCrossProfileContactsSearch                = $False
                            workProfileBlockCrossProfileCopyPaste                     = $False
                            workProfileDefaultAppPermissionPolicy                     = 'deviceDefault'
                            workProfilePasswordBlockFingerprintUnlock                 = $False
                            workProfilePasswordBlockTrustAgents                       = $False
                            workProfilePasswordExpirationDays                         = 90
                            workProfilePasswordMinimumLength                          = 4
                            workProfilePasswordMinNumericCharacters                   = 3
                            workProfilePasswordMinNonLetterCharacters                 = 3
                            workProfilePasswordMinLetterCharacters                    = 3
                            workProfilePasswordMinLowerCaseCharacters                 = 3
                            workProfilePasswordMinUpperCaseCharacters                 = 3
                            workProfilePasswordMinSymbolCharacters                    = 3
                            workProfilePasswordMinutesOfInactivityBeforeScreenTimeout = 3
                            workProfilePasswordPreviousPasswordBlockCount             = 3
                            workProfilePasswordSignInFailureCountBeforeFactoryReset   = 3
                            workProfilePasswordRequiredType                           = 'deviceDefault'
                            workProfileRequirePassword                                = $False
                            securityRequireVerifyApps                                 = $False
                        }
                    }
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should remove the policy from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgBetaDeviceManagementDeviceConfiguration -Exactly 1
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
                        id                   = '12345-12345-12345-12345-12345'
                        displayName          = 'Android Work Profile - Device Restrictions - Standard'
                        description          = 'Android device configuration policy'
                        AdditionalProperties = @{
                            '@odata.type'                                             = '#microsoft.graph.androidWorkProfileGeneralDeviceConfiguration'
                            passwordBlockFingerprintUnlock                            = $False
                            passwordBlockTrustAgents                                  = $False
                            passwordExpirationDays                                    = 10
                            passwordMinimumLength                                     = 8
                            passwordMinutesOfInactivityBeforeScreenTimeout            = 3
                            passwordPreviousPasswordBlockCount                        = 3
                            passwordSignInFailureCountBeforeFactoryReset              = 10
                            passwordRequiredType                                      = 'deviceDefault'
                            workProfileDataSharingType                                = 'deviceDefault'
                            workProfileBlockNotificationsWhileDeviceLocked            = $False
                            workProfileBlockAddingAccounts                            = $False
                            workProfileBluetoothEnableContactSharing                  = $False
                            workProfileBlockScreenCapture                             = $False
                            workProfileBlockCrossProfileCallerId                      = $False
                            workProfileBlockCamera                                    = $False
                            workProfileBlockCrossProfileContactsSearch                = $False
                            workProfileBlockCrossProfileCopyPaste                     = $False
                            workProfileDefaultAppPermissionPolicy                     = 'deviceDefault'
                            workProfilePasswordBlockFingerprintUnlock                 = $False
                            workProfilePasswordBlockTrustAgents                       = $False
                            workProfilePasswordExpirationDays                         = 90
                            workProfilePasswordMinimumLength                          = 4
                            workProfilePasswordMinNumericCharacters                   = 3
                            workProfilePasswordMinNonLetterCharacters                 = 3
                            workProfilePasswordMinLetterCharacters                    = 3
                            workProfilePasswordMinLowerCaseCharacters                 = 3
                            workProfilePasswordMinUpperCaseCharacters                 = 3
                            workProfilePasswordMinSymbolCharacters                    = 3
                            workProfilePasswordMinutesOfInactivityBeforeScreenTimeout = 3
                            workProfilePasswordPreviousPasswordBlockCount             = 3
                            workProfilePasswordSignInFailureCountBeforeFactoryReset   = 3
                            workProfilePasswordRequiredType                           = 'deviceDefault'
                            workProfileRequirePassword                                = $False
                            securityRequireVerifyApps                                 = $False
                        }
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
