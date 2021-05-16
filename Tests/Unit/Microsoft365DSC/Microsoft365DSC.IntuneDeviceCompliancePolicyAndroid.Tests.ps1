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
    -DscResource "IntuneDeviceCompliancePolicyAndroid" -GenericStubModule $GenericStubPath

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

            Mock -CommandName Update-IntuneDeviceCompliancePolicy -MockWith {
            }
            Mock -CommandName New-IntuneDeviceCompliancePolicy -MockWith {
            }
            Mock -CommandName Remove-IntuneDeviceCompliancePolicy -MockWith {
            }

            # Test contexts
            Context -Name "When the Android Device Compliance Policy doesn't already exist" -Fixture {
                BeforeAll {
                    $testParams = @{
                        DisplayName                                        = 'Test Android Device Compliance Policy'
                        Description                                        = 'Test Android Device Compliance Policy Description'
                        PasswordRequired                                   = $True
                        PasswordMinimumLength                              = 6
                        PasswordRequiredType                               = "DeviceDefault"
                        RequiredPasswordComplexity                         = "None"
                        PasswordMinutesOfInactivityBeforeLock              = 5
                        PasswordExpirationDays                             = 365
                        PasswordPreviousPasswordBlockCount                 = 3
                        PasswordSignInFailureCountBeforeFactoryReset       = 11
                        SecurityPreventInstallAppsFromUnknownSources       = $True
                        SecurityDisableUsbDebugging                        = $True
                        SecurityRequireVerifyApps                          = $True
                        DeviceThreatProtectionEnabled                      = $True
                        DeviceThreatProtectionRequiredSecurityLevel        = "Unavailable"
                        AdvancedThreatProtectionRequiredSecurityLevel      = "Unavailable"
                        SecurityBlockJailbrokenDevices                     = $True
                        SecurityBlockDeviceAdministratorManagedDevices     = $True
                        OsMinimumVersion                                   = 7
                        OsMaximumVersion                                   = 11
                        MinAndroidSecurityPatchLevel                       = $Null
                        StorageRequireEncryption                           = $True
                        SecurityRequireSafetyNetAttestationBasicIntegrity  = $True
                        SecurityRequireSafetyNetAttestationCertifiedDevice = $True
                        SecurityRequireGooglePlayServices                  = $True
                        SecurityRequireUpToDateSecurityProviders           = $True
                        SecurityRequireCompanyPortalAppIntegrity           = $True
                        ConditionStatementId                               = $Null
                        RestrictedApps                                     = "[]"
                        RoleScopeTagIds                                    = 0
                        Ensure                                             = 'Present'
                        GlobalAdminAccount                                 = $GlobalAdminAccount
                    }

                    Mock -CommandName Get-IntuneDeviceCompliancePolicy -MockWith {
                        return IntuneDeviceCNuNull
                    }
                }

                It "Should return absent from the Get method" {
                    (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
                }

                It "Should return false from the Test method" {
                    Test-TargetResource @testParams | Should -Be $false
                }

                It "Should create the Android Device Compliance Policy from the Set method" {
                    Set-TargetResource @testParams
                    Should -Invoke -CommandName "New-IntuneDeviceCompliancePolicy" -Exactly 1
                }
            }

            Context -Name "When the Android Device Compliance Policy already exists and is NOT in the Desired State" -Fixture {
                BeforeAll {
                    $testParams = @{
                        DisplayName                                        = 'Test Android Device Compliance Policy'
                        Description                                        = 'Test Android Device Compliance Policy Description'
                        PasswordRequired                                   = $True
                        PasswordMinimumLength                              = 6
                        PasswordRequiredType                               = "DeviceDefault"
                        RequiredPasswordComplexity                         = "None"
                        PasswordMinutesOfInactivityBeforeLock              = 5
                        PasswordExpirationDays                             = 365
                        PasswordPreviousPasswordBlockCount                 = 3
                        PasswordSignInFailureCountBeforeFactoryReset       = 11
                        SecurityPreventInstallAppsFromUnknownSources       = $True
                        SecurityDisableUsbDebugging                        = $True
                        SecurityRequireVerifyApps                          = $True
                        DeviceThreatProtectionEnabled                      = $True
                        DeviceThreatProtectionRequiredSecurityLevel        = "Unavailable"
                        AdvancedThreatProtectionRequiredSecurityLevel      = "Unavailable"
                        SecurityBlockJailbrokenDevices                     = $True
                        SecurityBlockDeviceAdministratorManagedDevices     = $True
                        OsMinimumVersion                                   = 7
                        OsMaximumVersion                                   = 11
                        MinAndroidSecurityPatchLevel                       = $Null
                        StorageRequireEncryption                           = $True
                        SecurityRequireSafetyNetAttestationBasicIntegrity  = $True
                        SecurityRequireSafetyNetAttestationCertifiedDevice = $True
                        SecurityRequireGooglePlayServices                  = $True
                        SecurityRequireUpToDateSecurityProviders           = $True
                        SecurityRequireCompanyPortalAppIntegrity           = $True
                        ConditionStatementId                               = $Null
                        RestrictedApps                                     = "[]"
                        RoleScopeTagIds                                    = 0
                        Ensure                                             = 'Present'
                        GlobalAdminAccount                                 = $GlobalAdminAccount
                    }

                    Mock -CommandName Get-IntuneDeviceCompliancePolicy -MockWith {
                        return @{
                            DisplayName                                        = 'Test Android Device Compliance Policy'
                            Description                                        = 'Different Value'
                            Id                                                 = '9c4e2ed7-706e-4874-a826-0c2778352d46'
                            PasswordRequired                                   = $True
                            PasswordMinimumLength                              = 6
                            PasswordRequiredType                               = "DeviceDefault"
                            RequiredPasswordComplexity                         = "None"
                            PasswordMinutesOfInactivityBeforeLock              = 5
                            PasswordExpirationDays                             = 365
                            PasswordPreviousPasswordBlockCount                 = 3
                            PasswordSignInFailureCountBeforeFactoryReset       = 11
                            SecurityPreventInstallAppsFromUnknownSources       = $True
                            SecurityDisableUsbDebugging                        = $True
                            SecurityRequireVerifyApps                          = $True
                            DeviceThreatProtectionEnabled                      = $True
                            DeviceThreatProtectionRequiredSecurityLevel        = "Unavailable"
                            AdvancedThreatProtectionRequiredSecurityLevel      = "Unavailable"
                            SecurityBlockJailbrokenDevices                     = $True
                            SecurityBlockDeviceAdministratorManagedDevices     = $True
                            OsMinimumVersion                                   = 7
                            OsMaximumVersion                                   = 11
                            MinAndroidSecurityPatchLevel                       = $Null
                            StorageRequireEncryption                           = $True
                            SecurityRequireSafetyNetAttestationBasicIntegrity  = $True
                            SecurityRequireSafetyNetAttestationCertifiedDevice = $True
                            SecurityRequireGooglePlayServices                  = $True
                            SecurityRequireUpToDateSecurityProviders           = $True
                            SecurityRequireCompanyPortalAppIntegrity           = $True
                            ConditionStatementId                               = $Null
                            RestrictedApps                                     = "[]"
                            RoleScopeTagIds                                    = 0
                        }
                    }
                }

                It "Should return Present from the Get method" {
                    (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
                }

                It "Should return false from the Test method" {
                    Test-TargetResource @testParams | Should -Be $false
                }

                It "Should update the iOS Device Compliance Policy from the Set method" {
                    Set-TargetResource @testParams
                    Should -Invoke -CommandName Update-IntuneDeviceCompliancePolicy -Exactly 1
                }
            }

            Context -Name "When the policy already exists and IS in the Desired State" -Fixture {
                BeforeAll {
                    $testParams = @{
                        DisplayName                                        = 'Test Android Device Compliance Policy'
                        Description                                        = 'Test Android Device Compliance Policy Description'
                        PasswordRequired                                   = $True
                        PasswordMinimumLength                              = 6
                        PasswordRequiredType                               = "DeviceDefault"
                        RequiredPasswordComplexity                         = "None"
                        PasswordMinutesOfInactivityBeforeLock              = 5
                        PasswordExpirationDays                             = 365
                        PasswordPreviousPasswordBlockCount                 = 3
                        PasswordSignInFailureCountBeforeFactoryReset       = 11
                        SecurityPreventInstallAppsFromUnknownSources       = $True
                        SecurityDisableUsbDebugging                        = $True
                        SecurityRequireVerifyApps                          = $True
                        DeviceThreatProtectionEnabled                      = $True
                        DeviceThreatProtectionRequiredSecurityLevel        = "Unavailable"
                        AdvancedThreatProtectionRequiredSecurityLevel      = "Unavailable"
                        SecurityBlockJailbrokenDevices                     = $True
                        SecurityBlockDeviceAdministratorManagedDevices     = $True
                        OsMinimumVersion                                   = 7
                        OsMaximumVersion                                   = 11
                        MinAndroidSecurityPatchLevel                       = $Null
                        StorageRequireEncryption                           = $True
                        SecurityRequireSafetyNetAttestationBasicIntegrity  = $True
                        SecurityRequireSafetyNetAttestationCertifiedDevice = $True
                        SecurityRequireGooglePlayServices                  = $True
                        SecurityRequireUpToDateSecurityProviders           = $True
                        SecurityRequireCompanyPortalAppIntegrity           = $True
                        ConditionStatementId                               = $Null
                        RestrictedApps                                     = "[]"
                        RoleScopeTagIds                                    = 0
                        Ensure                                             = 'Present'
                        GlobalAdminAccount                                 = $GlobalAdminAccount
                    }

                    Mock -CommandName Get-IntuneDeviceCompliancePolicy -MockWith {
                        return @{
                            DisplayName                                        = 'Test Android Device Compliance Policy'
                            Description                                        = 'Test Android Device Compliance Policy Description'
                            Id                                                 = '9c4e2ed7-706e-4874-a826-0c2778352d46'
                            PasswordRequired                                   = $True
                            PasswordMinimumLength                              = 6
                            PasswordRequiredType                               = "DeviceDefault"
                            RequiredPasswordComplexity                         = "None"
                            PasswordMinutesOfInactivityBeforeLock              = 5
                            PasswordExpirationDays                             = 365
                            PasswordPreviousPasswordBlockCount                 = 3
                            PasswordSignInFailureCountBeforeFactoryReset       = 11
                            SecurityPreventInstallAppsFromUnknownSources       = $True
                            SecurityDisableUsbDebugging                        = $True
                            SecurityRequireVerifyApps                          = $True
                            DeviceThreatProtectionEnabled                      = $True
                            DeviceThreatProtectionRequiredSecurityLevel        = "Unavailable"
                            AdvancedThreatProtectionRequiredSecurityLevel      = "Unavailable"
                            SecurityBlockJailbrokenDevices                     = $True
                            SecurityBlockDeviceAdministratorManagedDevices     = $True
                            OsMinimumVersion                                   = 7
                            OsMaximumVersion                                   = 11
                            MinAndroidSecurityPatchLevel                       = $Null
                            StorageRequireEncryption                           = $True
                            SecurityRequireSafetyNetAttestationBasicIntegrity  = $True
                            SecurityRequireSafetyNetAttestationCertifiedDevice = $True
                            SecurityRequireGooglePlayServices                  = $True
                            SecurityRequireUpToDateSecurityProviders           = $True
                            SecurityRequireCompanyPortalAppIntegrity           = $True
                            ConditionStatementId                               = $Null
                            RestrictedApps                                     = "[]"
                            RoleScopeTagIds                                    = 0
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
                        DisplayName                                        = 'Test Android Device Compliance Policy'
                        Description                                        = 'Test Android Device Compliance Policy Description'
                        PasswordRequired                                   = $True
                        PasswordMinimumLength                              = 6
                        PasswordRequiredType                               = "DeviceDefault"
                        RequiredPasswordComplexity                         = "None"
                        PasswordMinutesOfInactivityBeforeLock              = 5
                        PasswordExpirationDays                             = 365
                        PasswordPreviousPasswordBlockCount                 = 3
                        PasswordSignInFailureCountBeforeFactoryReset       = 11
                        SecurityPreventInstallAppsFromUnknownSources       = $True
                        SecurityDisableUsbDebugging                        = $True
                        SecurityRequireVerifyApps                          = $True
                        DeviceThreatProtectionEnabled                      = $True
                        DeviceThreatProtectionRequiredSecurityLevel        = "Unavailable"
                        AdvancedThreatProtectionRequiredSecurityLevel      = "Unavailable"
                        SecurityBlockJailbrokenDevices                     = $True
                        SecurityBlockDeviceAdministratorManagedDevices     = $True
                        OsMinimumVersion                                   = 7
                        OsMaximumVersion                                   = 11
                        MinAndroidSecurityPatchLevel                       = $Null
                        StorageRequireEncryption                           = $True
                        SecurityRequireSafetyNetAttestationBasicIntegrity  = $True
                        SecurityRequireSafetyNetAttestationCertifiedDevice = $True
                        SecurityRequireGooglePlayServices                  = $True
                        SecurityRequireUpToDateSecurityProviders           = $True
                        SecurityRequireCompanyPortalAppIntegrity           = $True
                        ConditionStatementId                               = $Null
                        RestrictedApps                                     = "[]"
                        RoleScopeTagIds                                    = 0
                        Ensure                                             = 'Present'
                        GlobalAdminAccount                                 = $GlobalAdminAccount
                    }

                    Mock -CommandName Get-IntuneDeviceCompliancePolicy -MockWith {
                        return @{
                            DisplayName                                        = 'Test Android Device Compliance Policy'
                            Description                                        = 'Test Android Device Compliance Policy Description'
                            Id                                                 = '9c4e2ed7-706e-4874-a826-0c2778352d46'
                            PasswordRequired                                   = $True
                            PasswordMinimumLength                              = 6
                            PasswordRequiredType                               = "DeviceDefault"
                            RequiredPasswordComplexity                         = "None"
                            PasswordMinutesOfInactivityBeforeLock              = 5
                            PasswordExpirationDays                             = 365
                            PasswordPreviousPasswordBlockCount                 = 3
                            PasswordSignInFailureCountBeforeFactoryReset       = 11
                            SecurityPreventInstallAppsFromUnknownSources       = $True
                            SecurityDisableUsbDebugging                        = $True
                            SecurityRequireVerifyApps                          = $True
                            DeviceThreatProtectionEnabled                      = $True
                            DeviceThreatProtectionRequiredSecurityLevel        = "Unavailable"
                            AdvancedThreatProtectionRequiredSecurityLevel      = "Unavailable"
                            SecurityBlockJailbrokenDevices                     = $True
                            SecurityBlockDeviceAdministratorManagedDevices     = $True
                            OsMinimumVersion                                   = 7
                            OsMaximumVersion                                   = 11
                            MinAndroidSecurityPatchLevel                       = $Null
                            StorageRequireEncryption                           = $True
                            SecurityRequireSafetyNetAttestationBasicIntegrity  = $True
                            SecurityRequireSafetyNetAttestationCertifiedDevice = $True
                            SecurityRequireGooglePlayServices                  = $True
                            SecurityRequireUpToDateSecurityProviders           = $True
                            SecurityRequireCompanyPortalAppIntegrity           = $True
                            ConditionStatementId                               = $Null
                            RestrictedApps                                     = "[]"
                            RoleScopeTagIds                                    = 0
                        }
                    }
                }

                It "Should return Present from the Get method" {
                    (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
                }

                It "Should return true from the Test method" {
                    Test-TargetResource @testParams | Should -Be $false
                }

                It "Should remove the iOS Device Compliance Policy from the Set method" {
                    Set-TargetResource @testParams
                    Should -Invoke -CommandName Remove-IntuneDeviceCompliancePolicy -Exactly 1
                }
            }

            Context -Name "ReverseDSC Tests" -Fixture {
                BeforeAll {
                    $testParams = @{
                        GlobalAdminAccount = $GlobalAdminAccount;
                    }

                    Mock -CommandName Get-IntuneDeviceCompliancePolicy -MockWith {
                        return @{
                            DisplayName                                        = 'Test Android Device Compliance Policy'
                            Description                                        = 'Test Android Device Compliance Policy Description'
                            Id                                                 = '9c4e2ed7-706e-4874-a826-0c2778352d46'
                            PasswordRequired                                   = $True
                            PasswordMinimumLength                              = 6
                            PasswordRequiredType                               = "DeviceDefault"
                            RequiredPasswordComplexity                         = "None"
                            PasswordMinutesOfInactivityBeforeLock              = 5
                            PasswordExpirationDays                             = 365
                            PasswordPreviousPasswordBlockCount                 = 3
                            PasswordSignInFailureCountBeforeFactoryReset       = 11
                            SecurityPreventInstallAppsFromUnknownSources       = $True
                            SecurityDisableUsbDebugging                        = $True
                            SecurityRequireVerifyApps                          = $True
                            DeviceThreatProtectionEnabled                      = $True
                            DeviceThreatProtectionRequiredSecurityLevel        = "Unavailable"
                            AdvancedThreatProtectionRequiredSecurityLevel      = "Unavailable"
                            SecurityBlockJailbrokenDevices                     = $True
                            SecurityBlockDeviceAdministratorManagedDevices     = $True
                            OsMinimumVersion                                   = 7
                            OsMaximumVersion                                   = 11
                            MinAndroidSecurityPatchLevel                       = $Null
                            StorageRequireEncryption                           = $True
                            SecurityRequireSafetyNetAttestationBasicIntegrity  = $True
                            SecurityRequireSafetyNetAttestationCertifiedDevice = $True
                            SecurityRequireGooglePlayServices                  = $True
                            SecurityRequireUpToDateSecurityProviders           = $True
                            SecurityRequireCompanyPortalAppIntegrity           = $True
                            ConditionStatementId                               = $Null
                            RestrictedApps                                     = "[]"
                            RoleScopeTagIds                                    = 0
                        }
                    }
                }

                It "Should Reverse Engineer resource from the Export method" {
                    Export-TargetResource @testParams
                }
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
