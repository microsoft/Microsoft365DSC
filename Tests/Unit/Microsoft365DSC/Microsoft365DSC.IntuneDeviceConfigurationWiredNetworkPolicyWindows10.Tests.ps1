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
    -DscResource 'IntuneDeviceConfigurationWiredNetworkPolicyWindows10' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString 'f@kepassword1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Update-MgBetaDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName New-MgBetaDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName Remove-MgBetaDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }
            Mock -CommandName Update-DeviceConfigurationPolicyAssignment -MockWith {
            }
            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false

            Mock -CommandName Get-MgBetaDeviceManagementDeviceConfigurationAssignment -MockWith {
            }

            Mock -CommandName Get-DeviceConfigurationPolicyCertificate -MockWith {
            }

            Mock -CommandName Update-DeviceConfigurationPolicyCertificateId -MockWith {
            }

            Mock -CommandName Remove-DeviceConfigurationPolicyCertificateId -MockWith {
            }

            Mock -CommandName Get-IntuneDeviceConfigurationCertificateId -MockWith {
            }

        }
        # Test contexts
        Context -Name 'The IntuneDeviceConfigurationWiredNetworkPolicyWindows10 should exist but it DOES NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    AuthenticationBlockPeriodInMinutes                             = 25
                    AuthenticationMethod                                           = 'certificate'
                    AuthenticationPeriodInSeconds                                  = 25
                    AuthenticationRetryDelayPeriodInSeconds                        = 25
                    AuthenticationType                                             = 'none'
                    CacheCredentials                                               = $True
                    Description                                                    = 'FakeStringValue'
                    DisableUserPromptForServerValidation                           = $True
                    DisplayName                                                    = 'FakeStringValue'
                    EapolStartPeriodInSeconds                                      = 25
                    EapType                                                        = 'eapTls'
                    Enforce8021X                                                   = $True
                    ForceFIPSCompliance                                            = $True
                    Id                                                             = 'FakeStringValue'
                    InnerAuthenticationProtocolForEAPTTLS                          = 'unencryptedPassword'
                    MaximumAuthenticationFailures                                  = 25
                    MaximumEAPOLStartMessages                                      = 25
                    OuterIdentityPrivacyTemporaryValue                             = 'FakeStringValue'
                    PerformServerValidation                                        = $True
                    RequireCryptographicBinding                                    = $True
                    SecondaryAuthenticationMethod                                  = 'certificate'
                    TrustedServerCertificateNames                                  = @('FakeStringValue')
                    Ensure                                                         = 'Present'
                    Credential                                                     = $Credential
                    RootCertificatesForServerValidationIds                         = @('a485d322-13cd-43ef-beda-733f656f48ea')
                    RootCertificatesForServerValidationDisplayNames                = @('RootCertificate')
                    SecondaryIdentityCertificateForClientAuthenticationId          = '0b9aef2f-1671-4260-8eb9-3ab3138e176a'
                    SecondaryIdentityCertificateForClientAuthenticationDisplayName = 'ClientCertificate'
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return $null
                }
                Mock -CommandName Get-DeviceConfigurationPolicyCertificate -MockWith {
                    return @(@{
                        Id = 'a485d322-13cd-43ef-beda-733f656f48ea'
                        DisplayName = 'RootCertificate'
                    })
                } -ParameterFilter { $CertificateName -eq 'rootCertificatesForServerValidation' }

                Mock -CommandName Get-DeviceConfigurationPolicyCertificate -MockWith {
                    return @{
                        Id = '0b9aef2f-1671-4260-8eb9-3ab3138e176a'
                        DisplayName = 'ClientCertificate'
                    }
                } -ParameterFilter { $CertificateName -eq 'secondaryIdentityCertificateForClientAuthentication' }

                Mock -CommandName Get-IntuneDeviceConfigurationCertificateId -MockWith {
                    return 'a485d322-13cd-43ef-beda-733f656f48ea'
                } -ParameterFilter { $DisplayName -eq 'RootCertificate' }

                Mock -CommandName Get-IntuneDeviceConfigurationCertificateId -MockWith {
                    return '0b9aef2f-1671-4260-8eb9-3ab3138e176a'
                } -ParameterFilter { $DisplayName -eq 'ClientCertificate' }
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

        Context -Name 'The IntuneDeviceConfigurationWiredNetworkPolicyWindows10 exists but it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    AuthenticationBlockPeriodInMinutes                    = 25
                    AuthenticationMethod                                  = 'certificate'
                    AuthenticationPeriodInSeconds                         = 25
                    AuthenticationRetryDelayPeriodInSeconds               = 25
                    AuthenticationType                                    = 'none'
                    CacheCredentials                                      = $True
                    Description                                           = 'FakeStringValue'
                    DisableUserPromptForServerValidation                  = $True
                    DisplayName                                           = 'FakeStringValue'
                    EapolStartPeriodInSeconds                             = 25
                    EapType                                               = 'eapTls'
                    Enforce8021X                                          = $True
                    ForceFIPSCompliance                                   = $True
                    Id                                                    = 'FakeStringValue'
                    InnerAuthenticationProtocolForEAPTTLS                 = 'unencryptedPassword'
                    MaximumAuthenticationFailures                         = 25
                    MaximumEAPOLStartMessages                             = 25
                    OuterIdentityPrivacyTemporaryValue                    = 'FakeStringValue'
                    PerformServerValidation                               = $True
                    RequireCryptographicBinding                           = $True
                    SecondaryAuthenticationMethod                         = 'certificate'
                    TrustedServerCertificateNames                         = @('FakeStringValue')
                    Ensure                                                = 'Absent'
                    Credential                                                     = $Credential
                    RootCertificatesForServerValidationIds                         = @('a485d322-13cd-43ef-beda-733f656f48ea')
                    RootCertificatesForServerValidationDisplayNames                = @('RootCertificate')
                    SecondaryIdentityCertificateForClientAuthenticationId          = '0b9aef2f-1671-4260-8eb9-3ab3138e176a'
                    SecondaryIdentityCertificateForClientAuthenticationDisplayName = 'ClientCertificate'
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            outerIdentityPrivacyTemporaryValue      = 'FakeStringValue'
                            eapType                                 = 'eapTls'
                            forceFIPSCompliance                     = $True
                            '@odata.type'                           = '#microsoft.graph.windowsWiredNetworkConfiguration'
                            secondaryAuthenticationMethod           = 'certificate'
                            cacheCredentials                        = $True
                            innerAuthenticationProtocolForEAPTTLS   = 'unencryptedPassword'
                            requireCryptographicBinding             = $True
                            authenticationType                      = 'none'
                            trustedServerCertificateNames           = @('FakeStringValue')
                            enforce8021X                            = $True
                            authenticationRetryDelayPeriodInSeconds = 25
                            performServerValidation                 = $True
                            authenticationBlockPeriodInMinutes      = 25
                            maximumEAPOLStartMessages               = 25
                            disableUserPromptForServerValidation    = $True
                            authenticationPeriodInSeconds           = 25
                            eapolStartPeriodInSeconds               = 25
                            authenticationMethod                    = 'certificate'
                            maximumAuthenticationFailures           = 25
                        }
                        Description          = 'FakeStringValue'
                        DisplayName          = 'FakeStringValue'
                        Id                   = 'FakeStringValue'
                    }
                }

                Mock -CommandName Get-DeviceConfigurationPolicyCertificate -MockWith {
                    return @(@{
                        Id = 'a485d322-13cd-43ef-beda-733f656f48ea'
                        DisplayName = 'RootCertificate'
                    })
                } -ParameterFilter { $CertificateName -eq 'rootCertificatesForServerValidation' }

                Mock -CommandName Get-DeviceConfigurationPolicyCertificate -MockWith {
                    return @{
                        Id = '0b9aef2f-1671-4260-8eb9-3ab3138e176a'
                        DisplayName = 'ClientCertificate'
                    }
                } -ParameterFilter { $CertificateName -eq 'secondaryIdentityCertificateForClientAuthentication' }

                Mock -CommandName Get-IntuneDeviceConfigurationCertificateId -MockWith {
                    return 'a485d322-13cd-43ef-beda-733f656f48ea'
                } -ParameterFilter { $DisplayName -eq 'RootCertificate' }

                Mock -CommandName Get-IntuneDeviceConfigurationCertificateId -MockWith {
                    return '0b9aef2f-1671-4260-8eb9-3ab3138e176a'
                } -ParameterFilter { $DisplayName -eq 'ClientCertificate' }
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
        Context -Name 'The IntuneDeviceConfigurationWiredNetworkPolicyWindows10 Exists and Values are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    AuthenticationBlockPeriodInMinutes                    = 25
                    AuthenticationMethod                                  = 'certificate'
                    AuthenticationPeriodInSeconds                         = 25
                    AuthenticationRetryDelayPeriodInSeconds               = 25
                    AuthenticationType                                    = 'none'
                    CacheCredentials                                      = $True
                    Description                                           = 'FakeStringValue'
                    DisableUserPromptForServerValidation                  = $True
                    DisplayName                                           = 'FakeStringValue'
                    EapolStartPeriodInSeconds                             = 25
                    EapType                                               = 'eapTls'
                    Enforce8021X                                          = $True
                    ForceFIPSCompliance                                   = $True
                    Id                                                    = 'FakeStringValue'
                    InnerAuthenticationProtocolForEAPTTLS                 = 'unencryptedPassword'
                    MaximumAuthenticationFailures                         = 25
                    MaximumEAPOLStartMessages                             = 25
                    OuterIdentityPrivacyTemporaryValue                    = 'FakeStringValue'
                    PerformServerValidation                               = $True
                    RequireCryptographicBinding                           = $True
                    SecondaryAuthenticationMethod                         = 'certificate'
                    TrustedServerCertificateNames                         = @('FakeStringValue')
                    Ensure                                                = 'Present'
                    Credential                                            = $Credential
                    RootCertificatesForServerValidationIds                = @('a485d322-13cd-43ef-beda-733f656f48ea')
                    SecondaryIdentityCertificateForClientAuthenticationId = '0b9aef2f-1671-4260-8eb9-3ab3138e176a'
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            outerIdentityPrivacyTemporaryValue      = 'FakeStringValue'
                            eapType                                 = 'eapTls'
                            forceFIPSCompliance                     = $True
                            '@odata.type'                           = '#microsoft.graph.windowsWiredNetworkConfiguration'
                            secondaryAuthenticationMethod           = 'certificate'
                            cacheCredentials                        = $True
                            innerAuthenticationProtocolForEAPTTLS   = 'unencryptedPassword'
                            requireCryptographicBinding             = $True
                            authenticationType                      = 'none'
                            trustedServerCertificateNames           = @('FakeStringValue')
                            enforce8021X                            = $True
                            authenticationRetryDelayPeriodInSeconds = 25
                            performServerValidation                 = $True
                            authenticationBlockPeriodInMinutes      = 25
                            maximumEAPOLStartMessages               = 25
                            disableUserPromptForServerValidation    = $True
                            authenticationPeriodInSeconds           = 25
                            eapolStartPeriodInSeconds               = 25
                            authenticationMethod                    = 'certificate'
                            maximumAuthenticationFailures           = 25
                        }
                        Description          = 'FakeStringValue'
                        DisplayName          = 'FakeStringValue'
                        Id                   = 'FakeStringValue'
                    }
                }

                Mock -CommandName Get-DeviceConfigurationPolicyCertificate -MockWith {
                    return @(@{
                        Id = 'a485d322-13cd-43ef-beda-733f656f48ea'
                        DisplayName = 'RootCertificate'
                    })
                } -ParameterFilter { $CertificateName -eq 'rootCertificatesForServerValidation' }

                Mock -CommandName Get-DeviceConfigurationPolicyCertificate -MockWith {
                    return @{
                        Id = '0b9aef2f-1671-4260-8eb9-3ab3138e176a'
                        DisplayName = 'ClientCertificate'
                    }
                } -ParameterFilter { $CertificateName -eq 'secondaryIdentityCertificateForClientAuthentication' }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'The IntuneDeviceConfigurationWiredNetworkPolicyWindows10 exists and values are NOT in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    AuthenticationBlockPeriodInMinutes                    = 25
                    AuthenticationMethod                                  = 'certificate'
                    AuthenticationPeriodInSeconds                         = 25
                    AuthenticationRetryDelayPeriodInSeconds               = 25
                    AuthenticationType                                    = 'none'
                    CacheCredentials                                      = $True
                    Description                                           = 'FakeStringValue'
                    DisableUserPromptForServerValidation                  = $True
                    DisplayName                                           = 'FakeStringValue'
                    EapolStartPeriodInSeconds                             = 25
                    EapType                                               = 'eapTls'
                    Enforce8021X                                          = $True
                    ForceFIPSCompliance                                   = $True
                    Id                                                    = 'FakeStringValue'
                    InnerAuthenticationProtocolForEAPTTLS                 = 'unencryptedPassword'
                    MaximumAuthenticationFailures                         = 25
                    MaximumEAPOLStartMessages                             = 25
                    OuterIdentityPrivacyTemporaryValue                    = 'FakeStringValue'
                    PerformServerValidation                               = $True
                    RequireCryptographicBinding                           = $True
                    SecondaryAuthenticationMethod                         = 'certificate'
                    TrustedServerCertificateNames                         = @('FakeStringValue')
                    Ensure                                                = 'Present'
                    Credential                                            = $Credential
                    RootCertificatesForServerValidationIds                = @('a485d322-13cd-43ef-beda-733f656f48ea')
                    RootCertificatesForServerValidationDisplayNames       = @('RootCertificate')
                    SecondaryIdentityCertificateForClientAuthenticationId = '0b9aef2f-1671-4260-8eb9-3ab3138e176a'
                    SecondaryIdentityCertificateForClientAuthenticationDisplayName = 'ClientCertificate'
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            eapolStartPeriodInSeconds               = 7
                            authenticationPeriodInSeconds           = 7
                            trustedServerCertificateNames           = @('FakeStringValue')
                            authenticationBlockPeriodInMinutes      = 7
                            authenticationRetryDelayPeriodInSeconds = 7
                            authenticationMethod                    = 'certificate'
                            authenticationType                      = 'none'
                            innerAuthenticationProtocolForEAPTTLS   = 'unencryptedPassword'
                            outerIdentityPrivacyTemporaryValue      = 'FakeStringValue'
                            '@odata.type'                           = '#microsoft.graph.windowsWiredNetworkConfiguration'
                            maximumEAPOLStartMessages               = 7
                            eapType                                 = 'eapTls'
                            secondaryAuthenticationMethod           = 'certificate'
                            maximumAuthenticationFailures           = 7
                        }
                        Description          = 'FakeStringValue'
                        DisplayName          = 'FakeStringValue'
                        Id                   = 'FakeStringValue'
                    }
                }

                Mock -CommandName Get-DeviceConfigurationPolicyCertificate -MockWith {
                    return @(@{
                        Id = 'a485d322-13cd-43ef-beda-733f656f48ea'
                        DisplayName = 'RootCertificate'
                    })
                } -ParameterFilter { $CertificateName -eq 'rootCertificatesForServerValidation' }

                Mock -CommandName Get-DeviceConfigurationPolicyCertificate -MockWith {
                    return @{
                        Id = '0b9aef2f-1671-4260-8eb9-3ab3138e176a'
                        DisplayName = 'ClientCertificate'
                    }
                } -ParameterFilter { $CertificateName -eq 'secondaryIdentityCertificateForClientAuthentication' }
                
                Mock -CommandName Get-IntuneDeviceConfigurationCertificateId -MockWith {
                    return 'a485d322-13cd-43ef-beda-733f656f48ea'
                } -ParameterFilter { $DisplayName -eq 'RootCertificate' }

                Mock -CommandName Get-IntuneDeviceConfigurationCertificateId -MockWith {
                    return '0b9aef2f-1671-4260-8eb9-3ab3138e176a'
                } -ParameterFilter { $DisplayName -eq 'ClientCertificate' }
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
                            outerIdentityPrivacyTemporaryValue      = 'FakeStringValue'
                            eapType                                 = 'eapTls'
                            forceFIPSCompliance                     = $True
                            '@odata.type'                           = '#microsoft.graph.windowsWiredNetworkConfiguration'
                            secondaryAuthenticationMethod           = 'certificate'
                            cacheCredentials                        = $True
                            innerAuthenticationProtocolForEAPTTLS   = 'unencryptedPassword'
                            requireCryptographicBinding             = $True
                            authenticationType                      = 'none'
                            trustedServerCertificateNames           = @('FakeStringValue')
                            enforce8021X                            = $True
                            authenticationRetryDelayPeriodInSeconds = 25
                            performServerValidation                 = $True
                            authenticationBlockPeriodInMinutes      = 25
                            maximumEAPOLStartMessages               = 25
                            disableUserPromptForServerValidation    = $True
                            authenticationPeriodInSeconds           = 25
                            eapolStartPeriodInSeconds               = 25
                            authenticationMethod                    = 'certificate'
                            maximumAuthenticationFailures           = 25
                        }
                        Description          = 'FakeStringValue'
                        DisplayName          = 'FakeStringValue'
                        Id                   = 'FakeStringValue'

                    }
                }

                Mock -CommandName Get-DeviceConfigurationPolicyCertificate -MockWith {
                    return @(@{
                        Id = 'a485d322-13cd-43ef-beda-733f656f48ea'
                        DisplayName = 'RootCertificate'
                    })
                } -ParameterFilter { $CertificateName -eq 'rootCertificatesForServerValidation' }

                Mock -CommandName Get-DeviceConfigurationPolicyCertificate -MockWith {
                    return @{
                        Id = '0b9aef2f-1671-4260-8eb9-3ab3138e176a'
                        DisplayName = 'ClientCertificate'
                    }
                } -ParameterFilter { $CertificateName -eq 'secondaryIdentityCertificateForClientAuthentication' }
            }
            It 'Should Reverse Engineer resource from the Export method' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
