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
    -DscResource 'IntuneAccountProtectionPolicy' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'Pass@word1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Get-MgBetaDeviceManagementIntent -MockWith {
            }

            Mock -CommandName Get-MgBetaDeviceManagementIntentSetting -MockWith {
            }

            Mock -CommandName Update-MgBetaDeviceManagementIntent -MockWith {
            }

            Mock -CommandName New-MgBetaDeviceManagementIntent -MockWith {
                return @{
                    Id = '619bd4a4-3b3b-4441-bd6f-3f4c0c444870'
                }
            }

            Mock -CommandName Remove-MgBetaDeviceManagementIntent -MockWith {
            }

            Mock -CommandName Get-MgBetaDeviceManagementTemplateCategory -MockWith {
                return @{
                    Id = '9d151a3d-a0c6-4a5e-8d9f-f379369f7ef0'
                }
            }

            Mock -CommandName Get-MgBetaDeviceManagementTemplateCategoryRecommendedSetting -MockWith {
                return @{
                    DefinitionId = 'deviceConfiguration--windowsIdentityProtectionConfiguration_useSecurityKeyForSignin'
                    Id = '516bbd8e-dc08-4870-85d5-03d0cd7266ae'
                    ValueJson = 'false'
                    AdditionalProperties = @{
                        '@odata.type' = '#microsoft.graph.deviceManagementBooleanSettingInstance'
                        value = $false
                    }
                }
            }

            Mock -CommandName Get-MgBetaDeviceManagementIntentAssignment -MockWith {
                return @(@{
                    target = @{
                        deviceAndAppManagementAssignmentFilterType = 'none'
                        deviceAndAppManagementAssignmentFilterId = $null
                        AdditionalProperties = @{
                            '@odata.type' = '#microsoft.graph.exclusionGroupAssignmentTarget'
                            groupId  = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                        }
                    }
                })
            }
            Mock -CommandName Update-DeviceConfigurationPolicyAssignment -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }

        }

        # Test contexts
        Context -Name "When the instance doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = @(
                        (New-CimInstance -ClassName MSFT_IntuneAccountProtectionPolicyAssignments -Property @{
                            DataType = '#microsoft.graph.exclusionGroupAssignmentTarget'
                            deviceAndAppManagementAssignmentFilterType = 'none'
                            groupId  = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                        } -ClientOnly)
                    )
                    Credential    = $Credential
                    Description             = 'My Test Description'
                    DisplayName             = 'My Test'
                    Ensure                  = 'Present'
                    Identity                = '619bd4a4-3b3b-4441-bd6f-3f4c0c444870'
                    UseSecurityKeyForSignin = $true
                }

                Mock -CommandName Get-MgBetaDeviceManagementIntent -MockWith {
                    return $null
                }
            }

            It 'Should return absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should create the instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'New-MgBetaDeviceManagementIntent' -Exactly 1
            }
        }

        Context -Name 'When the instance already exists and is NOT in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_IntuneAccountProtectionPolicyAssignments -Property @{
                            DataType     = '#microsoft.graph.exclusionGroupAssignmentTarget'
                            deviceAndAppManagementAssignmentFilterType = 'none'
                            groupId = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                        } -ClientOnly)
                    )
                    Credential              = $Credential
                    Description             = 'My Test Description'
                    DisplayName             = 'My Test'
                    Ensure                  = 'Present'
                    Identity                = '619bd4a4-3b3b-4441-bd6f-3f4c0c444870'
                    UseSecurityKeyForSignin = $true
                }

                Mock -CommandName Get-MgBetaDeviceManagementIntent -MockWith {
                    return @{
                        Id          = '619bd4a4-3b3b-4441-bd6f-3f4c0c444870'
                        Description = 'My Test Description'
                        DisplayName = 'My Test'
                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementIntentSetting -MockWith {
                    return @(@{
                        Id                   = 0
                        DefinitionId         = 'deviceConfiguration--windowsIdentityProtectionConfiguration_useSecurityKeyForSignin'
                        ValueJson            = 'false'
                        AdditionalProperties = @{
                            '@odata.type' = '#microsoft.graph.deviceManagementBooleanSettingInstance'
                            value = $false
                        }
                    })
                }
                Mock -CommandName Update-MgBetaDeviceManagementIntent -MockWith {
                }
                Mock -CommandName Invoke-MgGraphRequest -MockWith {
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should update the instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgBetaDeviceManagementIntent -Exactly 1
                Should -Invoke -CommandName Invoke-MgGraphRequest -Exactly 1
            }
        }

        Context -Name 'When the instance already exists and IS in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    Credential  = $Credential
                    Description = 'My Test Description'
                    DisplayName = 'My Test'
                    Ensure      = 'Present'
                    Identity    = '619bd4a4-3b3b-4441-bd6f-3f4c0c444870'
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_IntuneAccountProtectionPolicyAssignments -Property @{
                            DataType     = '#microsoft.graph.exclusionGroupAssignmentTarget'
                            deviceAndAppManagementAssignmentFilterType = 'none'
                            GroupId = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                        } -ClientOnly)
                    )
                }

                Mock -CommandName Get-MgBetaDeviceManagementIntent -MockWith {
                    return @{
                        Id          = '619bd4a4-3b3b-4441-bd6f-3f4c0c444870'
                        Description = 'My Test Description'
                        DisplayName = 'My Test'
                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementIntentSetting -MockWith {
                    return @(@{
                        Id                   = 0
                        DefinitionId         = 'deviceConfiguration--windowsIdentityProtectionConfiguration_useSecurityKeyForSignin'
                        ValueJson            = 'true'
                        AdditionalProperties = @{
                            '@odata.type' = '#microsoft.graph.deviceManagementBooleanSettingInstance'
                            value = $true
                        }
                    })
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'When the instance exists and it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = @(
                        (New-CimInstance -ClassName MSFT_IntuneAccountProtectionPolicyAssignments -Property @{
                            DataType = '#microsoft.graph.exclusionGroupAssignmentTarget'
                            deviceAndAppManagementAssignmentFilterType = 'none'
                            GroupId  = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                        } -ClientOnly)
                    )
                    Credential  = $Credential
                    Description = 'My Test Description'
                    DisplayName = 'My Test'
                    Ensure      = 'Absent'
                    Identity    = '619bd4a4-3b3b-4441-bd6f-3f4c0c444870'
                }

                Mock -CommandName Get-MgBetaDeviceManagementIntent -MockWith {
                    return @{
                        Id          = '619bd4a4-3b3b-4441-bd6f-3f4c0c444870'
                        Description = 'My Test Description'
                        DisplayName = 'My Test'
                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementIntentSetting -MockWith {
                    return @(@{
                        Id                   = 0
                        DefinitionId         = 'deviceConfiguration--windowsIdentityProtectionConfiguration_useSecurityKeyForSignin'
                        ValueJson            = 'false'
                        AdditionalProperties = @{
                            '@odata.type' = '#microsoft.graph.deviceManagementBooleanSettingInstance'
                            value = $false
                        }
                    })
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams -Verbose).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should remove the instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgBetaDeviceManagementIntent -Exactly 1
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
                        Id          = '619bd4a4-3b3b-4441-bd6f-3f4c0c444870'
                        Description = 'My Test Description'
                        DisplayName = 'My Test'
                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementIntentSetting -MockWith {
                    return @(@{
                        Id                   = 0
                        DefinitionId         = 'deviceConfiguration--windowsIdentityProtectionConfiguration_useSecurityKeyForSignin'
                        ValueJson            = 'false'
                        AdditionalProperties = @{
                            '@odata.type' = '#microsoft.graph.deviceManagementBooleanSettingInstance'
                            value = $false
                        }
                    })
                }
            }

            It 'Should Reverse Engineer resource from the Export method' {
                $result = Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
