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
    -DscResource 'IntuneAttackSurfaceReductionRulesPolicyWindows10ConfigManager' -GenericStubModule $GenericStubPath

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

            Mock -CommandName Update-MgBetaDeviceManagementConfigurationPolicy -MockWith {
            }

            Mock -CommandName New-MgBetaDeviceManagementConfigurationPolicy -MockWith {
                return @{
                    Id = '619bd4a4-3b3b-4441-bd6f-3f4c0c444870'
                }
            }

            Mock -CommandName Remove-MgBetaDeviceManagementConfigurationPolicy -MockWith {
            }

            Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicyTemplate -MockWith {
                return @{
                    TemplateId = 'd02f2162-fcac-48db-9b7b-b0a3f160d2c2_1'
                }
            }

            Mock -CommandName Get-DeviceManagementConfigurationPolicyAssignment -MockWith {
                return @(@{

                        dataType = '#microsoft.graph.exclusionGroupAssignmentTarget'
                        collectionId       = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                    })
            }
            Mock -CommandName Update-DeviceConfigurationPolicyAssignment -MockWith {
            }
            Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicyTemplateSettingTemplate -MockWith {
                return @{
                    Id       = '12345-12345-12345-12345-12345'
                    SettingInstanceTemplate = @{
                        settingDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
                        settingInstanceTemplateId = 'd770fcd1-62cd-4217-9b20-9ee2a12062ff'
                        AdditionalProperties = @{
                            '@odata.type' = '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstanceTemplate'
                            groupSettingCollectionValueTemplate = @{
                                children =@(
                                    @{
                                        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstanceTemplate'
                                        settingInstanceTemplateId ='999c8d1b-9f4e-49b7-824d-001c5c7d0182'
                                        settingDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_useadvancedprotectionagainstransomware'
                                        choiceSettingValueTemplate = @{
                                            settingValueTemplateId = 'a212472c-c5cc-43dd-898d-d35286a408e5'
                                        }
                                    }
                                )
                            }
                        }
                    }
                }
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false

        }

        # Test contexts
        Context -Name "When the instance doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = @(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            DataType                                   = '#microsoft.graph.exclusionGroupAssignmentTarget'
                            CollectionId                               = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                        } -ClientOnly)
                    )
                    Credential  = $Credential
                    Description = 'My Test Description'
                    DisplayName = 'My Test'
                    Ensure      = 'Present'
                    Identity    = '619bd4a4-3b3b-4441-bd6f-3f4c0c444870'
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicy -MockWith {
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
                Should -Invoke -CommandName 'New-MgBetaDeviceManagementConfigurationPolicy' -Exactly 1
            }
        }

        Context -Name 'When the instance already exists and is NOT in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            DataType                                   = '#microsoft.graph.exclusionGroupAssignmentTarget'
                            CollectionId                               = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                        } -ClientOnly)
                    )
                    Credential  = $Credential
                    Description = 'My Test Description'
                    DisplayName = 'My Test'
                    Ensure      = 'Present'
                    Identity    = '619bd4a4-3b3b-4441-bd6f-3f4c0c444870'
                    useadvancedprotectionagainstransomware = "audit"
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicy -MockWith {
                    return @{
                        Id    = '619bd4a4-3b3b-4441-bd6f-3f4c0c444870'
                        Description = 'My Test Description'
                        Name        = 'My Test'
                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicySetting -MockWith {
                    return @{
                        Id                   = 0
                        SettingDefinitions   = $null
                        SettingInstance      = @{
                            SettingDefinitionId              = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
                            SettingInstanceTemplateReference = @{
                                SettingInstanceTemplateId = 'd770fcd1-62cd-4217-9b20-9ee2a12062ff'
                            }
                            AdditionalProperties             = @{
                                '@odata.type'      = '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
                                groupSettingCollectionValue = @(@{
                                    children = @(
                                        @{
                                            "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                                            "settingDefinitionId" = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_useadvancedprotectionagainstransomware"
                                            "choiceSettingValue" = @{
                                                "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                                "value" = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_useadvancedprotectionagainstransomware_block"
                                            }
                                        }
                                    )
                                })
                            }

                        }
                        AdditionalProperties = $null
                    }
                }
                Mock -CommandName Update-DeviceManagementConfigurationPolicy -MockWith {
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
                Should -Invoke -CommandName Update-DeviceManagementConfigurationPolicy -Exactly 1
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
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            DataType                                   = '#microsoft.graph.exclusionGroupAssignmentTarget'
                            CollectionId                               = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                        } -ClientOnly)
                    )
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicy -MockWith {
                    return @{
                        Id    = '619bd4a4-3b3b-4441-bd6f-3f4c0c444870'
                        Description = 'My Test Description'
                        Name        = 'My Test'
                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicySetting -MockWith {
                    return @{
                        Id                   = 0
                        SettingDefinitions   = $null
                        SettingInstance      = @{
                            SettingDefinitionId              = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
                            SettingInstanceTemplateReference = @{
                                SettingInstanceTemplateId = 'd770fcd1-62cd-4217-9b20-9ee2a12062ff'
                            }
                            AdditionalProperties             = @{
                                '@odata.type'      = '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
                                groupSettingCollectionValue = @(@{
                                    children = @(
                                        @{
                                            "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                                            "settingDefinitionId" = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_useadvancedprotectionagainstransomware"
                                            "choiceSettingValue" = @{
                                                "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                                "value" = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_useadvancedprotectionagainstransomware_block"
                                            }
                                        }
                                    )
                                })
                            }

                        }
                        AdditionalProperties = $null
                    }
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
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            DataType                                   = '#microsoft.graph.exclusionGroupAssignmentTarget'
                            CollectionId                               = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                        } -ClientOnly)
                    )
                    Credential  = $Credential
                    Description = 'My Test Description'
                    DisplayName = 'My Test'
                    Ensure      = 'Absent'
                    Identity    = '619bd4a4-3b3b-4441-bd6f-3f4c0c444870'
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicy -MockWith {
                    return @{
                        Id    = '619bd4a4-3b3b-4441-bd6f-3f4c0c444870'
                        Description = 'My Test Description'
                        Name        = 'My Test'
                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicySetting -MockWith {
                    return @{
                        Id                   = 0
                        SettingDefinitions   = $null
                        SettingInstance      = @{
                            SettingDefinitionId              = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
                            SettingInstanceTemplateReference = @{
                                SettingInstanceTemplateId = 'd770fcd1-62cd-4217-9b20-9ee2a12062ff'
                            }
                            AdditionalProperties             = @{
                                '@odata.type'      = '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
                                groupSettingCollectionValue = @(@{
                                    children = @(
                                        @{
                                            "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                                            "settingDefinitionId" = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_useadvancedprotectionagainstransomware"
                                            "choiceSettingValue" = @{
                                                "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                                "value" = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_useadvancedprotectionagainstransomware_block"
                                            }
                                        }
                                    )
                                })
                            }

                        }
                        AdditionalProperties = $null
                    }
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should remove the instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgBetaDeviceManagementConfigurationPolicy -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicy -MockWith {
                    return @{
                        Id    = '619bd4a4-3b3b-4441-bd6f-3f4c0c444870'
                        Description = 'My Test Description'
                        Name        = 'My Test'
                        TemplateReference = @{
                            TemplateId = '5dd36540-eb22-4e7e-b19c-2a07772ba627_1'
                        }
                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicySetting -MockWith {
                    return @{
                        Id                   = 0
                        SettingDefinitions   = $null
                        SettingInstance      = @{
                            SettingDefinitionId              = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
                            SettingInstanceTemplateReference = @{
                                SettingInstanceTemplateId = 'd770fcd1-62cd-4217-9b20-9ee2a12062ff'
                            }
                            AdditionalProperties             = @{
                                '@odata.type'      = '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
                                groupSettingCollectionValue = @(@{
                                    children = @(
                                        @{
                                            "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                                            "settingDefinitionId" = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_useadvancedprotectionagainstransomware"
                                            "choiceSettingValue" = @{
                                                "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                                "value" = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_useadvancedprotectionagainstransomware_block"
                                            }
                                        }
                                    )
                                })
                            }

                        }
                        AdditionalProperties = $null
                    }
                }
            }

            It 'Should Reverse Engineer resource from the Export method' {
                $result = Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
