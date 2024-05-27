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
    -DscResource "IntuneDiskEncryptionMacOS" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-MgBetaDeviceManagementIntent -MockWith {
            }

            Mock -CommandName New-MgBetaDeviceManagementIntent -MockWith {
            }

            Mock -CommandName Remove-MgBetaDeviceManagementIntent -MockWith {
            }

            Mock -CommandName Invoke-MgGraphRequest -MockWith {
            }

            Mock -CommandName Update-DeviceConfigurationPolicyAssignment -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false

            Mock -CommandName Get-MgBetaDeviceManagementIntentAssignment -MockWith {
            }

        }
        # Test contexts
        Context -Name "The IntuneDiskEncryptionMacOS should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowDeferralUntilSignOut           = $True;
                    Assignments                         = @();
                    Description                         = "FakeStringValue";
                    DisplayName                         = "FakeStringValue";
                    Enabled                             = $True;
                    Id                                  = "FakeStringValue";
                    NumberOfTimesUserCanIgnore          = -1;
                    PersonalRecoveryKeyHelpMessage      = "FakeStringValue";
                    PersonalRecoveryKeyRotationInMonths = 2;
                    RoleScopeTagIds                     = @("0");
                    SelectedRecoveryKeyTypes            = @("personalRecoveryKey");
                    Ensure                              = "Present";
                    Credential                          = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementIntent -MockWith {
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
                Should -Invoke -CommandName New-MgBetaDeviceManagementIntent -Exactly 1
            }
        }

        Context -Name "The IntuneDiskEncryptionMacOS exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowDeferralUntilSignOut           = $True;
                    Assignments                         = @();
                    Description                         = "FakeStringValue";
                    DisplayName                         = "FakeStringValue";
                    Enabled                             = $True;
                    Id                                  = "FakeStringValue";
                    NumberOfTimesUserCanIgnore          = -1;
                    PersonalRecoveryKeyHelpMessage      = "FakeStringValue";
                    PersonalRecoveryKeyRotationInMonths = 2;
                    RoleScopeTagIds                     = @("0");
                    SelectedRecoveryKeyTypes            = @("personalRecoveryKey");
                    Ensure                              = "Absent";
                    Credential                          = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementIntent -MockWith {
                    return @{
                        Description     = "FakeStringValue"
                        DisplayName     = "FakeStringValue"
                        Id              = "FakeStringValue"
                        RoleScopeTagIds = @("0")
                        TemplateId      = "a239407c-698d-4ef8-b314-e3ae409204b8"
                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementIntentSetting -MockWith {
                    return @(
                        @{
                            definitionId = "deviceConfiguration--macOSEndpointProtectionConfiguration_fileVaultSelectedRecoveryKeyTypes"
                            Id = "cba611e9-3084-4a42-a6f2-c6ac2c13f331"
                            valueJson = "[""personalRecoveryKey""]"
                        },
                        @{
                            definitionId = "deviceConfiguration--macOSEndpointProtectionConfiguration_fileVaultNumberOfTimesUserCanIgnore"
                            Id = "c3106770-f35d-4486-95cb-e23cb5c18651"
                            valueJson = "-1"
                        },
                        @{
                            definitionId = "deviceConfiguration--macOSEndpointProtectionConfiguration_fileVaultPersonalRecoveryKeyRotationInMonths"
                            Id = "dee4e9bb-14d8-4523-afd6-4a4906f9f214"
                            valueJson = "2"
                        },
                        @{
                            definitionId = "deviceConfiguration--macOSEndpointProtectionConfiguration_fileVaultEnabled"
                            Id = "9456793f-b37e-461b-86df-0ade0dc11ecc"
                            valueJson = "true"
                        },
                        @{
                            definitionId = "deviceConfiguration--macOSEndpointProtectionConfiguration_fileVaultPersonalRecoveryKeyHelpMessage"
                            Id = "6b1e229a-ba62-44f9-a04b-ed9321192fe3"
                            valueJson = """FakeStringValue"""
                        },
                        @{
                            definitionId = "deviceConfiguration--macOSEndpointProtectionConfiguration_fileVaultAllowDeferralUntilSignOut"
                            Id = "ac30133a-5607-4450-8e16-d8442dbb20aa"
                            valueJson = "true"
                        },
                        @{
                            definitionId = "deviceConfiguration--macOSEndpointProtectionConfiguration_fileVaultDisablePromptAtSignOut"
                            Id = "4585e424-abce-4bb5-84bc-bf073eaf7cee"
                            valueJson = "false"
                        },
                        @{
                            definitionId = "deviceConfiguration--macOSEndpointProtectionConfiguration_fileVaultHidePersonalRecoveryKey"
                            Id = "5608d7db-5990-45b7-bf40-ecb2125e060b"
                            valueJson = "false"
                        }
                    )
                }

                Mock -CommandName Get-MgBetaDeviceManagementIntentAssignment -MockWith {
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
                Should -Invoke -CommandName Remove-MgBetaDeviceManagementIntent -Exactly 1
            }
        }
        Context -Name "The IntuneDiskEncryptionMacOS Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowDeferralUntilSignOut           = $True;
                    Assignments                         = @();
                    Description                         = "FakeStringValue";
                    DisplayName                         = "FakeStringValue";
                    Enabled                             = $True;
                    Id                                  = "FakeStringValue";
                    NumberOfTimesUserCanIgnore          = -1;
                    PersonalRecoveryKeyHelpMessage      = "FakeStringValue";
                    PersonalRecoveryKeyRotationInMonths = 2;
                    RoleScopeTagIds                     = @("0");
                    SelectedRecoveryKeyTypes            = @("personalRecoveryKey");
                    Ensure                              = "Present";
                    Credential                          = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementIntent -MockWith {
                    return @{
                        Description     = "FakeStringValue"
                        DisplayName     = "FakeStringValue"
                        Id              = "FakeStringValue"
                        RoleScopeTagIds = @("0")
                        TemplateId      = "a239407c-698d-4ef8-b314-e3ae409204b8"
                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementIntentSetting -MockWith {
                    return @(
                        @{
                            definitionId = "deviceConfiguration--macOSEndpointProtectionConfiguration_fileVaultSelectedRecoveryKeyTypes"
                            Id = "cba611e9-3084-4a42-a6f2-c6ac2c13f331"
                            valueJson = "[""personalRecoveryKey""]"
                        },
                        @{
                            definitionId = "deviceConfiguration--macOSEndpointProtectionConfiguration_fileVaultNumberOfTimesUserCanIgnore"
                            Id = "c3106770-f35d-4486-95cb-e23cb5c18651"
                            valueJson = "-1"
                        },
                        @{
                            definitionId = "deviceConfiguration--macOSEndpointProtectionConfiguration_fileVaultPersonalRecoveryKeyRotationInMonths"
                            Id = "dee4e9bb-14d8-4523-afd6-4a4906f9f214"
                            valueJson = "2"
                        },
                        @{
                            definitionId = "deviceConfiguration--macOSEndpointProtectionConfiguration_fileVaultEnabled"
                            Id = "9456793f-b37e-461b-86df-0ade0dc11ecc"
                            valueJson = "true"
                        },
                        @{
                            definitionId = "deviceConfiguration--macOSEndpointProtectionConfiguration_fileVaultPersonalRecoveryKeyHelpMessage"
                            Id = "6b1e229a-ba62-44f9-a04b-ed9321192fe3"
                            valueJson = """FakeStringValue"""
                        },
                        @{
                            definitionId = "deviceConfiguration--macOSEndpointProtectionConfiguration_fileVaultAllowDeferralUntilSignOut"
                            Id = "ac30133a-5607-4450-8e16-d8442dbb20aa"
                            valueJson = "true"
                        },
                        @{
                            definitionId = "deviceConfiguration--macOSEndpointProtectionConfiguration_fileVaultDisablePromptAtSignOut"
                            Id = "4585e424-abce-4bb5-84bc-bf073eaf7cee"
                            valueJson = "false"
                        },
                        @{
                            definitionId = "deviceConfiguration--macOSEndpointProtectionConfiguration_fileVaultHidePersonalRecoveryKey"
                            Id = "5608d7db-5990-45b7-bf40-ecb2125e060b"
                            valueJson = "false"
                        }
                    )
                }

                Mock -CommandName Get-MgBetaDeviceManagementIntentAssignment -MockWith {
                    return @()
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The IntuneDiskEncryptionMacOS exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowDeferralUntilSignOut           = $True;
                    Assignments                         = @();
                    Description                         = "FakeStringValue";
                    DisplayName                         = "FakeStringValue";
                    Enabled                             = $True;
                    Id                                  = "FakeStringValue";
                    NumberOfTimesUserCanIgnore          = -1;
                    PersonalRecoveryKeyHelpMessage      = "FakeStringValue";
                    PersonalRecoveryKeyRotationInMonths = 2;
                    RoleScopeTagIds                     = @("0");
                    SelectedRecoveryKeyTypes            = @("personalRecoveryKey");
                    Ensure                              = "Present";
                    Credential                          = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementIntent -MockWith {
                    return @{
                        Description     = "FakeStringValue"
                        DisplayName     = "FakeStringValue"
                        Id              = "FakeStringValue"
                        RoleScopeTagIds = @("0")
                        TemplateId      = "a239407c-698d-4ef8-b314-e3ae409204b8"
                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementIntentSetting -MockWith {
                    return @(
                        @{
                            definitionId = "deviceConfiguration--macOSEndpointProtectionConfiguration_fileVaultSelectedRecoveryKeyTypes"
                            Id = "cba611e9-3084-4a42-a6f2-c6ac2c13f331"
                            valueJson = "[""personalRecoveryKey""]"
                        },
                        @{
                            definitionId = "deviceConfiguration--macOSEndpointProtectionConfiguration_fileVaultNumberOfTimesUserCanIgnore"
                            Id = "c3106770-f35d-4486-95cb-e23cb5c18651"
                            valueJson = "-1"
                        },
                        @{
                            definitionId = "deviceConfiguration--macOSEndpointProtectionConfiguration_fileVaultPersonalRecoveryKeyRotationInMonths"
                            Id = "dee4e9bb-14d8-4523-afd6-4a4906f9f214"
                            valueJson = "3" # Updated property
                        },
                        @{
                            definitionId = "deviceConfiguration--macOSEndpointProtectionConfiguration_fileVaultEnabled"
                            Id = "9456793f-b37e-461b-86df-0ade0dc11ecc"
                            valueJson = "true"
                        },
                        @{
                            definitionId = "deviceConfiguration--macOSEndpointProtectionConfiguration_fileVaultPersonalRecoveryKeyHelpMessage"
                            Id = "6b1e229a-ba62-44f9-a04b-ed9321192fe3"
                            valueJson = """FakeStringValue"""
                        },
                        @{
                            definitionId = "deviceConfiguration--macOSEndpointProtectionConfiguration_fileVaultAllowDeferralUntilSignOut"
                            Id = "ac30133a-5607-4450-8e16-d8442dbb20aa"
                            valueJson = "true"
                        },
                        @{
                            definitionId = "deviceConfiguration--macOSEndpointProtectionConfiguration_fileVaultDisablePromptAtSignOut"
                            Id = "4585e424-abce-4bb5-84bc-bf073eaf7cee"
                            valueJson = "false"
                        },
                        @{
                            definitionId = "deviceConfiguration--macOSEndpointProtectionConfiguration_fileVaultHidePersonalRecoveryKey"
                            Id = "5608d7db-5990-45b7-bf40-ecb2125e060b"
                            valueJson = "false"
                        }
                    )
                }

                Mock -CommandName Get-MgBetaDeviceManagementIntentAssignment -MockWith {
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
                Should -Invoke -CommandName Update-MgBetaDeviceManagementIntent -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementIntent -MockWith {
                    return @{
                        Description     = "FakeStringValue"
                        DisplayName     = "FakeStringValue"
                        Id              = "FakeStringValue"
                        RoleScopeTagIds = @("0")
                        TemplateId      = "a239407c-698d-4ef8-b314-e3ae409204b8"
                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementIntentSetting -MockWith {
                    return @(
                        @{
                            definitionId = "deviceConfiguration--macOSEndpointProtectionConfiguration_fileVaultSelectedRecoveryKeyTypes"
                            Id = "cba611e9-3084-4a42-a6f2-c6ac2c13f331"
                            valueJson = "[""personalRecoveryKey""]"
                        },
                        @{
                            definitionId = "deviceConfiguration--macOSEndpointProtectionConfiguration_fileVaultNumberOfTimesUserCanIgnore"
                            Id = "c3106770-f35d-4486-95cb-e23cb5c18651"
                            valueJson = "-1"
                        },
                        @{
                            definitionId = "deviceConfiguration--macOSEndpointProtectionConfiguration_fileVaultPersonalRecoveryKeyRotationInMonths"
                            Id = "dee4e9bb-14d8-4523-afd6-4a4906f9f214"
                            valueJson = "2"
                        },
                        @{
                            definitionId = "deviceConfiguration--macOSEndpointProtectionConfiguration_fileVaultEnabled"
                            Id = "9456793f-b37e-461b-86df-0ade0dc11ecc"
                            valueJson = "true"
                        },
                        @{
                            definitionId = "deviceConfiguration--macOSEndpointProtectionConfiguration_fileVaultPersonalRecoveryKeyHelpMessage"
                            Id = "6b1e229a-ba62-44f9-a04b-ed9321192fe3"
                            valueJson = """FakeStringValue"""
                        },
                        @{
                            definitionId = "deviceConfiguration--macOSEndpointProtectionConfiguration_fileVaultAllowDeferralUntilSignOut"
                            Id = "ac30133a-5607-4450-8e16-d8442dbb20aa"
                            valueJson = "true"
                        },
                        @{
                            definitionId = "deviceConfiguration--macOSEndpointProtectionConfiguration_fileVaultDisablePromptAtSignOut"
                            Id = "4585e424-abce-4bb5-84bc-bf073eaf7cee"
                            valueJson = "false"
                        },
                        @{
                            definitionId = "deviceConfiguration--macOSEndpointProtectionConfiguration_fileVaultHidePersonalRecoveryKey"
                            Id = "5608d7db-5990-45b7-bf40-ecb2125e060b"
                            valueJson = "false"
                        }
                    )
                }

                Mock -CommandName Get-MgBetaDeviceManagementIntentAssignment -MockWith {
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
