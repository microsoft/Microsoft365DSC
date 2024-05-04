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
    -DscResource 'IntuneSettingCatalogASRRulesPolicyWindows10' -GenericStubModule $GenericStubPath

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

            Mock -CommandName Invoke-MgGraphRequest -MockWith {
            }

            Mock -CommandName New-IntuneDeviceConfigurationPolicy -MockWith {
            }

            Mock -CommandName Update-IntuneDeviceConfigurationPolicy -MockWith {
            }

            Mock -CommandName Remove-MgBetaDeviceManagementConfigurationPolicy -MockWith {
            }

            Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicyTemplate -MockWith {
                return @{
                    TemplateId = 'e8c053d6-9f95-42b1-a7f1-ebfd71c67a4b_1'
                }
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
                $testParams = @{
                    blockadobereaderfromcreatingchildprocesses                        = 'audit'
                    blockallofficeapplicationsfromcreatingchildprocesses              = 'warn'
                    blockcredentialstealingfromwindowslocalsecurityauthoritysubsystem = 'warn'
                    blockwin32apicallsfromofficemacros                                = 'block'
                    Assignments                                                       = @()
                    Credential                                                        = $Credential
                    Description                                                       = 'My Test'
                    DisplayName                                                       = 'asdfads'
                    Ensure                                                            = 'Present'
                    Identity                                                          = 'a90ca9bc-8a68-4901-a991-dafaa633b034'
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicy -MockWith {
                    return $null
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicySetting -MockWith {
                    return $null
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicyAssignment -MockWith {
                    return @()
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicyTemplateSettingTemplate -MockWith {
                    return @(
                        @{
                            id                      = '0'
                            SettingDefinitions      = $null
                            SettingInstanceTemplate = @(
                                {
                                    SettingDefinitionId               = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
                                    SettingInstanceTemplateReference  = @{
                                        SettingInstanceTemplateId = '19600663-e264-4c02-8f55-f2983216d6d7'
                                    }
                                    AdditionalProperties = @(
                                        @{
                                            '@odata.type'                       = '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstanceTemplate'
                                            groupSettingCollectionValueTemplate = @(
                                                @{
                                                    'settingValueTemplateId' = 'a04ad36d-3b6a-4087-b946-5bd20dce9cec'
                                                    children                 = @(
                                                        @{
                                                            '@odata.type'              = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstanceTemplate'
                                                            settingDefinitionId        = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockadobereaderfromcreatingchildprocesses'
                                                            choiceSettingValueTemplate = @{
                                                                'settingValueTemplateId' = '7b40cb1e-4b13-4ce3-b387-4b6616565793'
                                                            }
                                                        },
                                                        @{
                                                            '@odata.type'              = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstanceTemplate'
                                                            settingDefinitionId        = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockwin32apicallsfromofficemacros'
                                                            choiceSettingValueTemplate = @{
                                                                'settingValueTemplateId' = '3e6a12aa-3417-49b8-beff-88913b6935ea'
                                                            }
                                                        },
                                                        @{
                                                            '@odata.type'              = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstanceTemplate'
                                                            settingDefinitionId        = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockcredentialstealingfromwindowslocalsecurityauthoritysubsystem'
                                                            choiceSettingValueTemplate = @{
                                                                'settingValueTemplateId' = 'fa9393ac-b3b8-4f0a-a219-68971d67f9a6'
                                                            }
                                                        },
                                                        @{
                                                            '@odata.type'              = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstanceTemplate'
                                                            settingDefinitionId        = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockallofficeapplicationsfromcreatingchildprocesses'
                                                            choiceSettingValueTemplate = @{
                                                                'settingValueTemplateId' = '30792cfc-6ea0-4d3a-8766-1c4dbcb4e0f2'
                                                            }
                                                        }
                                                    )
                                                }
                                            )
                                        }
                                    )
                                }
                            )
                            AdditionalProperties    = @{}
                        }
                    )
                }
            }

            It 'Should return absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should create the policy from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-IntuneDeviceConfigurationPolicy -Exactly 1
            }
        }

        Context -Name 'When the policy already exists and is NOT in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    blockadobereaderfromcreatingchildprocesses                        = 'audit'
                    blockallofficeapplicationsfromcreatingchildprocesses              = 'warn'
                    blockcredentialstealingfromwindowslocalsecurityauthoritysubsystem = 'warn'
                    blockwin32apicallsfromofficemacros                                = 'block'
                    Credential                                                        = $Credential
                    Description                                                       = 'test'
                    DisplayName                                                       = 'asdfads'
                    Ensure                                                            = 'Present'
                    Identity                                                          = '12345-12345-12345-12345-12345'
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicy -MockWith {
                    return @{
                        Id          = '12345-12345-12345-12345-12345'
                        Description = 'My Test'
                        Name        = 'asdfads'
                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicySetting -MockWith {
                    return @{
                        id                   = '0'
                        SettingDefinitions   = $null
                        SettingInstance      = @(
                            {
                                SettingDefinitionId               = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
                                SettingInstanceTemplateReference  = @{
                                    SettingInstanceTemplateId = '19600663-e264-4c02-8f55-f2983216d6d7'
                                }
                                AdditionalProperties = @(
                                    @{
                                        '@odata.type'               = '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
                                        groupSettingCollectionValue = @(
                                            @{
                                                children = @(
                                                    @{
                                                        '@odata.type'       = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                                        settingDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockadobereaderfromcreatingchildprocesses'
                                                        choiceSettingValue  = @{
                                                            value = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockadobereaderfromcreatingchildprocesses_audit'
                                                        }
                                                    },
                                                    @{
                                                        '@odata.type'       = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                                        settingDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockwin32apicallsfromofficemacros'
                                                        choiceSettingValue  = @{
                                                            value = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockwin32apicallsfromofficemacros_block'
                                                        }
                                                    },
                                                    @{
                                                        '@odata.type'       = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                                        settingDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockcredentialstealingfromwindowslocalsecurityauthoritysubsystem'
                                                        choiceSettingValue  = @{
                                                            value = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockcredentialstealingfromwindowslocalsecurityauthoritysubsystem_block' #drift
                                                        }
                                                    },
                                                    @{
                                                        '@odata.type'       = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                                        settingDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockallofficeapplicationsfromcreatingchildprocesses'
                                                        choiceSettingValue  = @{
                                                            value = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockallofficeapplicationsfromcreatingchildprocesses_warn'
                                                        }
                                                    }
                                                )
                                            }
                                        )
                                    }
                                )
                            }
                        )
                        AdditionalProperties = @{}
                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicyAssignment -MockWith {
                    return @()
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicyTemplateSettingTemplate -MockWith {
                    return @(
                        @{
                            id                      = '0'
                            SettingDefinitions      = $null
                            SettingInstanceTemplate = @(
                                {
                                    SettingDefinitionId               = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
                                    SettingInstanceTemplateReference  = @{
                                        SettingInstanceTemplateId = '19600663-e264-4c02-8f55-f2983216d6d7'
                                    }
                                    AdditionalProperties = @(
                                        @{
                                            '@odata.type'                       = '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstanceTemplate'
                                            groupSettingCollectionValueTemplate = @(
                                                @{
                                                    'settingValueTemplateId' = 'a04ad36d-3b6a-4087-b946-5bd20dce9cec'
                                                    children                 = @(
                                                        @{
                                                            '@odata.type'              = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstanceTemplate'
                                                            settingDefinitionId        = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockadobereaderfromcreatingchildprocesses'
                                                            choiceSettingValueTemplate = @{
                                                                'settingValueTemplateId' = '7b40cb1e-4b13-4ce3-b387-4b6616565793'
                                                            }
                                                        },
                                                        @{
                                                            '@odata.type'              = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstanceTemplate'
                                                            settingDefinitionId        = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockwin32apicallsfromofficemacros'
                                                            choiceSettingValueTemplate = @{
                                                                'settingValueTemplateId' = '3e6a12aa-3417-49b8-beff-88913b6935ea'
                                                            }
                                                        },
                                                        @{
                                                            '@odata.type'              = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstanceTemplate'
                                                            settingDefinitionId        = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockcredentialstealingfromwindowslocalsecurityauthoritysubsystem'
                                                            choiceSettingValueTemplate = @{
                                                                'settingValueTemplateId' = 'fa9393ac-b3b8-4f0a-a219-68971d67f9a6'
                                                            }
                                                        },
                                                        @{
                                                            '@odata.type'              = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstanceTemplate'
                                                            settingDefinitionId        = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockallofficeapplicationsfromcreatingchildprocesses'
                                                            choiceSettingValueTemplate = @{
                                                                'settingValueTemplateId' = '30792cfc-6ea0-4d3a-8766-1c4dbcb4e0f2'
                                                            }
                                                        }
                                                    )
                                                }
                                            )
                                        }
                                    )
                                }
                            )
                            AdditionalProperties    = @{}
                        }
                    )
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should update the policy from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-IntuneDeviceConfigurationPolicy -Exactly 1
            }
        }

        Context -Name 'When the policy already exists and IS in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    blockadobereaderfromcreatingchildprocesses                        = 'audit'
                    blockallofficeapplicationsfromcreatingchildprocesses              = 'warn'
                    blockcredentialstealingfromwindowslocalsecurityauthoritysubsystem = 'warn'
                    blockwin32apicallsfromofficemacros                                = 'block'
                    Credential                                                        = $Credential
                    Description                                                       = 'My Test'
                    DisplayName                                                       = 'asdfads'
                    Ensure                                                            = 'Present'
                    Identity                                                          = '12345-12345-12345-12345-12345'
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicy -MockWith {
                    return @{
                        Id          = '12345-12345-12345-12345-12345'
                        Description = 'My Test'
                        Name        = 'asdfads'
                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicySetting -MockWith {
                    return @{
                        id                   = '0'
                        SettingDefinitions   = $null
                        SettingInstance      = @(
                            @{
                                SettingDefinitionId              = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
                                SettingInstanceTemplateReference = @{
                                    SettingInstanceTemplateId = '19600663-e264-4c02-8f55-f2983216d6d7'
                                }
                                AdditionalProperties             = @(
                                    @{
                                        '@odata.type'               = '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
                                        groupSettingCollectionValue = @(
                                            @{
                                                children = @(
                                                    @{
                                                        '@odata.type'       = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                                        settingDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockadobereaderfromcreatingchildprocesses'
                                                        choiceSettingValue  = @{
                                                            value = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockadobereaderfromcreatingchildprocesses_audit'
                                                        }
                                                    },
                                                    @{
                                                        '@odata.type'       = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                                        settingDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockwin32apicallsfromofficemacros'
                                                        choiceSettingValue  = @{
                                                            value = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockwin32apicallsfromofficemacros_block'
                                                        }
                                                    },
                                                    @{
                                                        '@odata.type'       = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                                        settingDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockcredentialstealingfromwindowslocalsecurityauthoritysubsystem'
                                                        choiceSettingValue  = @{
                                                            value = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockcredentialstealingfromwindowslocalsecurityauthoritysubsystem_warn'
                                                        }
                                                    },
                                                    @{
                                                        '@odata.type'       = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                                        settingDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockallofficeapplicationsfromcreatingchildprocesses'
                                                        choiceSettingValue  = @{
                                                            value = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockallofficeapplicationsfromcreatingchildprocesses_warn'
                                                        }
                                                    }
                                                )
                                            }
                                        )
                                    }
                                )
                            }
                        )
                        AdditionalProperties = @{}
                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicyAssignment -MockWith {
                    return @()
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicyTemplateSettingTemplate -MockWith {
                    return @(
                        @{
                            id                      = '0'
                            SettingDefinitions      = $null
                            SettingInstanceTemplate = @(
                                {
                                    SettingDefinitionId               = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
                                    SettingInstanceTemplateReference  = @{
                                        SettingInstanceTemplateId = '19600663-e264-4c02-8f55-f2983216d6d7'
                                    }
                                    AdditionalProperties = @(
                                        @{
                                            '@odata.type'                       = '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstanceTemplate'
                                            groupSettingCollectionValueTemplate = @(
                                                @{
                                                    'settingValueTemplateId' = 'a04ad36d-3b6a-4087-b946-5bd20dce9cec'
                                                    children                 = @(
                                                        @{
                                                            '@odata.type'              = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstanceTemplate'
                                                            settingDefinitionId        = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockadobereaderfromcreatingchildprocesses'
                                                            choiceSettingValueTemplate = @{
                                                                'settingValueTemplateId' = '7b40cb1e-4b13-4ce3-b387-4b6616565793'
                                                            }
                                                        },
                                                        @{
                                                            '@odata.type'              = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstanceTemplate'
                                                            settingDefinitionId        = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockwin32apicallsfromofficemacros'
                                                            choiceSettingValueTemplate = @{
                                                                'settingValueTemplateId' = '3e6a12aa-3417-49b8-beff-88913b6935ea'
                                                            }
                                                        },
                                                        @{
                                                            '@odata.type'              = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstanceTemplate'
                                                            settingDefinitionId        = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockcredentialstealingfromwindowslocalsecurityauthoritysubsystem'
                                                            choiceSettingValueTemplate = @{
                                                                'settingValueTemplateId' = 'fa9393ac-b3b8-4f0a-a219-68971d67f9a6'
                                                            }
                                                        },
                                                        @{
                                                            '@odata.type'              = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstanceTemplate'
                                                            settingDefinitionId        = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockallofficeapplicationsfromcreatingchildprocesses'
                                                            choiceSettingValueTemplate = @{
                                                                'settingValueTemplateId' = '30792cfc-6ea0-4d3a-8766-1c4dbcb4e0f2'
                                                            }
                                                        }
                                                    )
                                                }
                                            )
                                        }
                                    )
                                }
                            )
                            AdditionalProperties    = @{}
                        }
                    )
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'When the policy exists and it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    blockadobereaderfromcreatingchildprocesses                        = 'audit'
                    blockallofficeapplicationsfromcreatingchildprocesses              = 'warn'
                    blockcredentialstealingfromwindowslocalsecurityauthoritysubsystem = 'warn'
                    blockwin32apicallsfromofficemacros                                = 'block'
                    Credential                                                        = $Credential
                    Description                                                       = 'test'
                    DisplayName                                                       = 'asdfads'
                    Ensure                                                            = 'Absent'
                    Identity                                                          = '12345-12345-12345-12345-12345'
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicy -MockWith {
                    return @{
                        Id          = '12345-12345-12345-12345-12345'
                        Description = 'My Test'
                        Name        = 'asdfads'
                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicySetting -MockWith {
                    return @{
                        id                   = '0'
                        SettingDefinitions   = $null
                        SettingInstance      = @(
                            @{
                                SettingDefinitionId              = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
                                SettingInstanceTemplateReference = @{
                                    SettingInstanceTemplateId = '19600663-e264-4c02-8f55-f2983216d6d7'
                                }
                                AdditionalProperties             = @(
                                    @{
                                        '@odata.type'               = '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
                                        groupSettingCollectionValue = @(
                                            @{
                                                children = @(
                                                    @{
                                                        '@odata.type'       = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                                        settingDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockadobereaderfromcreatingchildprocesses'
                                                        choiceSettingValue  = @{
                                                            value = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockadobereaderfromcreatingchildprocesses_audit'
                                                        }
                                                    },
                                                    @{
                                                        '@odata.type'       = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                                        settingDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockwin32apicallsfromofficemacros'
                                                        choiceSettingValue  = @{
                                                            value = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockwin32apicallsfromofficemacros_block'
                                                        }
                                                    },
                                                    @{
                                                        '@odata.type'       = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                                        settingDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockcredentialstealingfromwindowslocalsecurityauthoritysubsystem'
                                                        choiceSettingValue  = @{
                                                            value = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockcredentialstealingfromwindowslocalsecurityauthoritysubsystem_warn'
                                                        }
                                                    },
                                                    @{
                                                        '@odata.type'       = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                                        settingDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockallofficeapplicationsfromcreatingchildprocesses'
                                                        choiceSettingValue  = @{
                                                            value = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockallofficeapplicationsfromcreatingchildprocesses_warn'
                                                        }
                                                    }
                                                )
                                            }
                                        )
                                    }
                                )
                            }
                        )
                        AdditionalProperties = @{}
                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicyAssignment -MockWith {
                    return @()
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicyTemplateSettingTemplate -MockWith {
                    return @(
                        @{
                            id                      = '0'
                            SettingDefinitions      = $null
                            SettingInstanceTemplate = @(
                                {
                                    SettingDefinitionId               = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
                                    SettingInstanceTemplateReference  = @{
                                        SettingInstanceTemplateId = '19600663-e264-4c02-8f55-f2983216d6d7'
                                    }
                                    AdditionalProperties = @(
                                        @{
                                            '@odata.type'                       = '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstanceTemplate'
                                            groupSettingCollectionValueTemplate = @(
                                                @{
                                                    'settingValueTemplateId' = 'a04ad36d-3b6a-4087-b946-5bd20dce9cec'
                                                    children                 = @(
                                                        @{
                                                            '@odata.type'              = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstanceTemplate'
                                                            settingDefinitionId        = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockadobereaderfromcreatingchildprocesses'
                                                            choiceSettingValueTemplate = @{
                                                                'settingValueTemplateId' = '7b40cb1e-4b13-4ce3-b387-4b6616565793'
                                                            }
                                                        },
                                                        @{
                                                            '@odata.type'              = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstanceTemplate'
                                                            settingDefinitionId        = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockwin32apicallsfromofficemacros'
                                                            choiceSettingValueTemplate = @{
                                                                'settingValueTemplateId' = '3e6a12aa-3417-49b8-beff-88913b6935ea'
                                                            }
                                                        },
                                                        @{
                                                            '@odata.type'              = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstanceTemplate'
                                                            settingDefinitionId        = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockcredentialstealingfromwindowslocalsecurityauthoritysubsystem'
                                                            choiceSettingValueTemplate = @{
                                                                'settingValueTemplateId' = 'fa9393ac-b3b8-4f0a-a219-68971d67f9a6'
                                                            }
                                                        },
                                                        @{
                                                            '@odata.type'              = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstanceTemplate'
                                                            settingDefinitionId        = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockallofficeapplicationsfromcreatingchildprocesses'
                                                            choiceSettingValueTemplate = @{
                                                                'settingValueTemplateId' = '30792cfc-6ea0-4d3a-8766-1c4dbcb4e0f2'
                                                            }
                                                        }
                                                    )
                                                }
                                            )
                                        }
                                    )
                                }
                            )
                            AdditionalProperties    = @{}
                        }
                    )
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
                Should -Invoke -CommandName Remove-MgBetaDeviceManagementConfigurationPolicy -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicy -MockWith {
                    return @{
                        Id                = '12345-12345-12345-12345-12345'
                        Description       = 'My Test'
                        Name              = 'asdfads'
                        TemplateReference = @{
                            TemplateId = 'e8c053d6-9f95-42b1-a7f1-ebfd71c67a4b_1'
                        }
                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicySetting -MockWith {
                    return @{
                        id                   = '0'
                        SettingDefinitions   = $null
                        SettingInstance      = @(
                            @{
                                SettingDefinitionId              = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
                                SettingInstanceTemplateReference = @{
                                    SettingInstanceTemplateId = '19600663-e264-4c02-8f55-f2983216d6d7'
                                }
                                AdditionalProperties             = @(
                                    @{
                                        '@odata.type'               = '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
                                        groupSettingCollectionValue = @(
                                            @{
                                                children = @(
                                                    @{
                                                        '@odata.type'       = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                                        settingDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockadobereaderfromcreatingchildprocesses'
                                                        choiceSettingValue  = @{
                                                            value = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockadobereaderfromcreatingchildprocesses_audit'
                                                        }
                                                    },
                                                    @{
                                                        '@odata.type'       = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                                        settingDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockwin32apicallsfromofficemacros'
                                                        choiceSettingValue  = @{
                                                            value = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockwin32apicallsfromofficemacros_block'
                                                        }
                                                    },
                                                    @{
                                                        '@odata.type'       = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                                        settingDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockcredentialstealingfromwindowslocalsecurityauthoritysubsystem'
                                                        choiceSettingValue  = @{
                                                            value = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockcredentialstealingfromwindowslocalsecurityauthoritysubsystem_warn'
                                                        }
                                                    },
                                                    @{
                                                        '@odata.type'       = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                                        settingDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockallofficeapplicationsfromcreatingchildprocesses'
                                                        choiceSettingValue  = @{
                                                            value = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockallofficeapplicationsfromcreatingchildprocesses_warn'
                                                        }
                                                    }
                                                )
                                            }
                                        )
                                    }
                                )
                            }
                        )
                        AdditionalProperties = @{}
                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicyAssignment -MockWith {
                    return @()
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicyTemplateSettingTemplate -MockWith {
                    return @(
                        @{
                            id                      = '0'
                            SettingDefinitions      = $null
                            SettingInstanceTemplate = @(
                                {
                                    SettingDefinitionId               = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
                                    SettingInstanceTemplateReference  = @{
                                        SettingInstanceTemplateId = '19600663-e264-4c02-8f55-f2983216d6d7'
                                    }
                                    AdditionalProperties = @(
                                        @{
                                            '@odata.type'                       = '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstanceTemplate'
                                            groupSettingCollectionValueTemplate = @(
                                                @{
                                                    'settingValueTemplateId' = 'a04ad36d-3b6a-4087-b946-5bd20dce9cec'
                                                    children                 = @(
                                                        @{
                                                            '@odata.type'              = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstanceTemplate'
                                                            settingDefinitionId        = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockadobereaderfromcreatingchildprocesses'
                                                            choiceSettingValueTemplate = @{
                                                                'settingValueTemplateId' = '7b40cb1e-4b13-4ce3-b387-4b6616565793'
                                                            }
                                                        },
                                                        @{
                                                            '@odata.type'              = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstanceTemplate'
                                                            settingDefinitionId        = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockwin32apicallsfromofficemacros'
                                                            choiceSettingValueTemplate = @{
                                                                'settingValueTemplateId' = '3e6a12aa-3417-49b8-beff-88913b6935ea'
                                                            }
                                                        },
                                                        @{
                                                            '@odata.type'              = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstanceTemplate'
                                                            settingDefinitionId        = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockcredentialstealingfromwindowslocalsecurityauthoritysubsystem'
                                                            choiceSettingValueTemplate = @{
                                                                'settingValueTemplateId' = 'fa9393ac-b3b8-4f0a-a219-68971d67f9a6'
                                                            }
                                                        },
                                                        @{
                                                            '@odata.type'              = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstanceTemplate'
                                                            settingDefinitionId        = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockallofficeapplicationsfromcreatingchildprocesses'
                                                            choiceSettingValueTemplate = @{
                                                                'settingValueTemplateId' = '30792cfc-6ea0-4d3a-8766-1c4dbcb4e0f2'
                                                            }
                                                        }
                                                    )
                                                }
                                            )
                                        }
                                    )
                                }
                            )
                            AdditionalProperties    = @{}
                        }
                    )
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
