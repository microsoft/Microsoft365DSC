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
    -DscResource "IntuneAppControlForBusinessPolicyWindows10" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -ModuleName M365DSCUtil -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-MSCloudLoginConnectionProfile -MockWith {
            }

            Mock -CommandName Reset-MSCloudLoginConnectionProfileContext -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
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

            Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicy -MockWith {
                return @{
                    Id    = '619bd4a4-3b3b-4441-bd6f-3f4c0c444870'
                    Description = 'My Test Description'
                    Name        = 'My Test'
                    RoleScopeTagIds = @('FakeStringValue')
                    TemplateReference = @{
                        TemplateId = '4321b946-b76b-4450-8afd-769c08b16ffc_1'
                    }
                }
            }

            Mock -CommandName Update-IntuneDeviceConfigurationPolicy -MockWith {
            }

            Mock -CommandName Get-IntuneSettingCatalogPolicySetting -MockWith {
            }

            Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicySetting -MockWith {
                return @{
                    Id                   = 0
                    SettingDefinitions   = @(
                        @{
                            Id = 'device_vendor_msft_policy_config_applicationcontrol_built_in_controls_trust_apps'
                            Name = 'ConfigureApplicationControlSelectAdditionalRulesForTrustingApps'
                            OffsetUri = '/{0}/Policy'
                            AdditionalProperties = @{
                                '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionDefinition'
                                maximumCount = 100
                                minimumCount = 0
                                options = @(
                                    @{
                                        dependentOn = @(
                                            @{
                                                dependentOn = 'device_vendor_msft_policy_config_applicationcontrol_built_in_controls'
                                                parentSettingId = 'device_vendor_msft_policy_config_applicationcontrol_built_in_controls'
                                            }
                                        )
                                        itemId = 'device_vendor_msft_policy_config_applicationcontrol_built_in_controls_trust_apps_0'
                                        name = 'Trust apps with good reputation'
                                        optionValue = @{
                                            '@odata.type' = '#microsoft.graph.deviceManagementConfigurationIntegerSettingValue'
                                            value = 1
                                        }
                                    }
                                )
                            }
                        },
                        @{
                            Id = 'device_vendor_msft_policy_config_applicationcontrol_built_in_controls'
                            Name = 'ConfigureApplicationControlBuiltInControls'
                            OffsetUri = '/{0}/Policy'
                            AdditionalProperties = @{
                                '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSettingGroupCollectionDefinition'
                                'childIds' = @(
                                    'device_vendor_msft_policy_config_applicationcontrol_built_in_controls_enable_app_control'
                                    'device_vendor_msft_policy_config_applicationcontrol_built_in_controls_trust_apps'
                                )
                                minimumCount = 0
                                maximumCount = 1
                            }
                        },
                        @{
                            Id = 'device_vendor_msft_policy_config_applicationcontrol_built_in_controls_enable_app_control'
                            Name = 'ConfigureApplicationControlEnableAppControlPolicy'
                            OffsetUri = '/{0}/Policy'
                            AdditionalProperties = @{
                                '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingDefinition'
                                options = @(
                                    @{
                                        dependentOn = @(
                                            @{
                                                dependentOn = 'device_vendor_msft_policy_config_applicationcontrol_built_in_controls'
                                                parentSettingId = 'device_vendor_msft_policy_config_applicationcontrol_built_in_controls'
                                            }
                                        )
                                        itemId = 'device_vendor_msft_policy_config_applicationcontrol_built_in_controls_enable_app_control_0'
                                        name = 'Enforce'
                                        optionValue = @{
                                            '@odata.type' = '#microsoft.graph.deviceManagementConfigurationIntegerSettingValue'
                                            value = 0
                                        }
                                    }
                                )
                            }
                        },
                        @{
                            Id = 'device_vendor_msft_policy_config_applicationcontrol_policies_{policyguid}_policiesoptions'
                            Name = 'ConfigureApplicationControlOptions'
                            OffsetUri = '/{0}/Policy'
                            AdditionalProperties = @{
                                '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingDefinition'
                                options = @(
                                    @{
                                        itemId = 'device_vendor_msft_policy_config_applicationcontrol_built_in_controls_selected'
                                        name = 'Use built-in controls'
                                        optionValue = @{
                                            '@odata.type' = '#microsoft.graph.deviceManagementConfigurationIntegerSettingValue'
                                            value = 1
                                        }
                                    }
                                )
                            }
                        }
                    )
                    SettingInstance      = @{
                        SettingDefinitionId              = 'device_vendor_msft_policy_config_applicationcontrol_policies_{policyguid}_policiesoptions'
                        SettingInstanceTemplateReference = @{
                            SettingInstanceTemplateId = '1de98212-6949-42dc-a89c-e0ff6e5da04b'
                        }
                        AdditionalProperties             = @{
                            '@odata.type'      = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                            choiceSettingValue = @{
                                children = @(
                                    @{
                                        "@odata.type" = "#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance"
                                        "settingDefinitionId" = "device_vendor_msft_policy_config_applicationcontrol_built_in_controls"
                                        "groupSettingCollectionValue" = @(
                                            @{
                                                children = @(
                                                    @{
                                                        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance'
                                                        choiceSettingCollectionValue = @(
                                                            @{
                                                                children = @()
                                                                value = 'device_vendor_msft_policy_config_applicationcontrol_built_in_controls_trust_apps_0'
                                                            }
                                                        )
                                                        settingDefinitionId = 'device_vendor_msft_policy_config_applicationcontrol_built_in_controls_trust_apps'
                                                    }
                                                    @{
                                                        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                                        settingDefinitionId = 'device_vendor_msft_policy_config_applicationcontrol_built_in_controls_enable_app_control'
                                                        choiceSettingValue = @{
                                                            children = @()
                                                            value = 'device_vendor_msft_policy_config_applicationcontrol_built_in_controls_enable_app_control_0'
                                                        }
                                                    }
                                                )
                                            }
                                        )
                                    }
                                )
                                value = 'device_vendor_msft_policy_config_applicationcontrol_built_in_controls_selected'
                            }
                        }
                    }
                    AdditionalProperties = $null
                }
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            # Mock Write-M365DSCHost to hide output during the tests
            Mock -CommandName Write-M365DSCHost -MockWith {
            }
            $Script:exportedInstance = $null
            $Script:ExportMode = $false

            Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicyAssignment -MockWith {
                return @(@{
                    Id       = '12345-12345-12345-12345-12345'
                    Source   = 'direct'
                    SourceId = '12345-12345-12345-12345-12345'
                    Target   = @{
                        DeviceAndAppManagementAssignmentFilterType = 'none'
                        AdditionalProperties                       = @(
                            @{
                                '@odata.type' = '#microsoft.graph.configurationManagerCollectionAssignmentTarget'
                                collectionId  = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                            }
                        )
                    }
                })
            }
        }

        # Test contexts
        Context -Name "The IntuneAppControlForBusinessPolicyWindows10 should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = @(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            DataType     = '#microsoft.graph.configurationManagerCollectionAssignmentTarget'
                            CollectionId = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                        } -ClientOnly)
                    )
                    ConfigureApplicationControlEnableAppControlPolicy               = 0;
                    ConfigureApplicationControlOptions                              = 1;
                    ConfigureApplicationControlSelectAdditionalRulesForTrustingApps = @(1);
                    Description = "My Test Description"
                    Id = "FakeStringValue"
                    DisplayName = "My Test"
                    RoleScopeTagIds = @("FakeStringValue")
                    Ensure = "Present"
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicy -MockWith {
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
                Should -Invoke -CommandName New-MgBetaDeviceManagementConfigurationPolicy -Exactly 1
            }
        }

        Context -Name "The IntuneAppControlForBusinessPolicyWindows10 exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = @(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            DataType     = '#microsoft.graph.configurationManagerCollectionAssignmentTarget'
                            CollectionId = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                        } -ClientOnly)
                    )
                    ConfigureApplicationControlEnableAppControlPolicy               = 0;
                    ConfigureApplicationControlOptions                              = 1;
                    ConfigureApplicationControlSelectAdditionalRulesForTrustingApps = @(1);
                    Description = "My Test Description"
                    Id = "FakeStringValue"
                    DisplayName = "My Test"
                    RoleScopeTagIds = @("FakeStringValue")
                    Ensure = 'Absent'
                    Credential = $Credential;
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgBetaDeviceManagementConfigurationPolicy -Exactly 1
            }
        }

        Context -Name "The IntuneAppControlForBusinessPolicyWindows10 Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = @(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            DataType     = '#microsoft.graph.configurationManagerCollectionAssignmentTarget'
                            CollectionId = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                        } -ClientOnly)
                    )
                    ConfigureApplicationControlEnableAppControlPolicy               = 0;
                    ConfigureApplicationControlOptions                              = 1;
                    ConfigureApplicationControlSelectAdditionalRulesForTrustingApps = @(1);
                    Description = "My Test Description"
                    Id = "FakeStringValue"
                    DisplayName = "My Test"
                    RoleScopeTagIds = @("FakeStringValue")
                    Ensure = 'Present'
                    Credential = $Credential;
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The IntuneAppControlForBusinessPolicyWindows10 exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = @(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            DataType     = '#microsoft.graph.configurationManagerCollectionAssignmentTarget'
                            CollectionId = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                        } -ClientOnly)
                    )
                    ConfigureApplicationControlEnableAppControlPolicy               = 1; # Drift
                    ConfigureApplicationControlOptions                              = 1;
                    ConfigureApplicationControlSelectAdditionalRulesForTrustingApps = @(1);
                    Description = "My Test Description"
                    Id = "FakeStringValue"
                    DisplayName = "My Test"
                    RoleScopeTagIds = @("FakeStringValue")
                    Ensure = 'Present'
                    Credential = $Credential;
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
                Should -Invoke -CommandName Update-IntuneDeviceConfigurationPolicy -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
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
