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
    -DscResource "IntuneDefenderGlobalExclusionsPolicyLinux" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-MSCloudLoginConnectionProfile -MockWith {
            }

            Mock -CommandName Reset-MSCloudLoginConnectionProfileContext -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName New-MgBetaDeviceManagementConfigurationPolicy -MockWith {
                return @{
                    Id = '12345-12345-12345-12345-12345'
                }
            }

            Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicy -MockWith {
                return @{
                    Id              = '12345-12345-12345-12345-12345'
                    Description     = 'My Test'
                    Name            = 'My Test'
                    RoleScopeTagIds = @("FakeStringValue")
                    TemplateReference = @{
                        TemplateId = 'dfa57610-d11d-4bf8-89d6-1f5cb1679506_1'
                    }
                }
            }

            Mock -CommandName Remove-MgBetaDeviceManagementConfigurationPolicy -MockWith {
            }

            Mock -CommandName Update-IntuneDeviceConfigurationPolicy -MockWith {
            }

            Mock -CommandName Get-IntuneSettingCatalogPolicySetting -MockWith {
            }

            Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicySetting -MockWith {
                return @(
                    @{
                        Id = 0
                        SettingDefinitions = @(
                            @{
                                Id = 'linux_mdatp_managed_exclusionsettings_exclusions'
                                Name = 'exclusions'
                                OffsetUri = 'exclusions'
                                AdditionalProperties = @{
                                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSettingGroupCollectionDefinition'
                                    maximumCount = 600
                                    minimumCount = 0
                                    childIds = @(
                                        'linux_mdatp_managed_exclusionsettings_exclusions_item_$type',
                                        'linux_mdatp_managed_exclusionsettings_exclusions_item_isdirectory',
                                        'linux_mdatp_managed_exclusionsettings_exclusions_item_name',
                                        'linux_mdatp_managed_exclusionsettings_exclusions_item_path'
                                    )
                                }
                            },
                            @{
                                Id = 'linux_mdatp_managed_exclusionsettings_exclusions_item_$type'
                                Name = 'exclusions_item_$type'
                                OffsetUri = 'exclusions_item_$type'
                                AdditionalProperties = @{
                                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingDefinition'
                                    options = @(
                                        @{
                                            itemId = 'linux_mdatp_managed_exclusionsettings_exclusions_item_$type_0'
                                            name = 'Path'
                                            dependentOn = @(
                                                @{
                                                    dependentOn = 'linux_mdatp_managed_exclusionsettings_exclusions'
                                                    parentSettingId = 'linux_mdatp_managed_exclusionsettings_exclusions'
                                                }
                                            )
                                        }
                                    )
                                }
                            },
                            @{
                                Id = 'linux_mdatp_managed_exclusionsettings_exclusions_item_name'
                                Name = 'exclusions_item_name'
                                OffsetUri = 'exclusions/[{0}]/name'
                                AdditionalProperties = @{
                                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSimpleSettingDefinition'
                                    dependentOn = @(
                                        @{
                                            dependentOn = 'linux_mdatp_managed_exclusionsettings_exclusions_item_$type_2'
                                            parentSettingId = 'linux_mdatp_managed_exclusionsettings_exclusions_item_$type'
                                        }
                                    )
                                }
                            }
                            @{
                                Id = 'linux_mdatp_managed_exclusionsettings_exclusions_item_path'
                                Name = 'exclusions_item_path'
                                OffsetUri = 'exclusions/[{0}]/path'
                                AdditionalProperties = @{
                                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSimpleSettingDefinition'
                                    dependentOn = @(
                                        @{
                                            dependentOn = 'linux_mdatp_managed_exclusionsettings_exclusions_item_$type_0'
                                            parentSettingId = 'linux_mdatp_managed_exclusionsettings_exclusions_item_$type'
                                        }
                                    )
                                }
                            },
                            @{
                                Id = 'linux_mdatp_managed_exclusionsettings_exclusions_item_isdirectory'
                                Name = 'exclusions_item_isDirectory'
                                OffsetUri = 'exclusions/[{0}]/isDirectory'
                                AdditionalProperties = @{
                                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSimpleSettingDefinition'
                                    dependentOn = @(
                                        @{
                                            dependentOn = 'linux_mdatp_managed_exclusionsettings_exclusions_item_$type_0'
                                            parentSettingId = 'linux_mdatp_managed_exclusionsettings_exclusions_item_$type'
                                        }
                                    )
                                    options = @(
                                        @{
                                            itemId = 'linux_mdatp_managed_exclusionsettings_exclusions_item_isdirectory_false'
                                            name = 'Disabled'
                                            optionValue = @{
                                                '@odata.type' = '#microsoft.graph.deviceManagementConfigurationStringSettingValue'
                                                value = 'false'
                                            }
                                        }
                                    )
                                }
                            }
                        )
                        SettingInstance = @{
                            SettingDefinitionId = 'linux_mdatp_managed_exclusionsettings_exclusions'
                            SettingInstanceTemplateReference = @{
                                SettingInstanceTemplateId = 'e2d557ab-357e-4727-978e-0d655facbb23'
                            }
                            AdditionalProperties = @{
                                '@odata.type' = '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
                                groupSettingCollectionValue = @(
                                    @{
                                        children = @(
                                            @{
                                                '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                                settingDefinitionId = 'linux_mdatp_managed_exclusionsettings_exclusions_item_$type'
                                                choiceSettingValue = @{
                                                    children = @(
                                                        @{
                                                            '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                                            settingDefinitionId = 'linux_mdatp_managed_exclusionsettings_exclusions_item_path'
                                                            simpleSettingValue = @{
                                                                '@odata.type' = '#microsoft.graph.deviceManagementConfigurationStringSettingValue'
                                                                value = '/temp/dir/local'
                                                            }
                                                        }
                                                        @{
                                                            '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                                            settingDefinitionId = 'linux_mdatp_managed_exclusionsettings_exclusions_item_isdirectory'
                                                            choiceSettingValue = @{
                                                                '@odata.type' = '#microsoft.graph.deviceManagementConfigurationStringSettingValue'
                                                                children = @()
                                                                value = 'linux_mdatp_managed_exclusionsettings_exclusions_item_isdirectory_true'
                                                            }
                                                        }
                                                    )
                                                    value = 'linux_mdatp_managed_exclusionsettings_exclusions_item_$type_0'
                                                }
                                            }
                                        )
                                    },
                                    @{
                                        children = @(
                                            @{
                                                '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                                settingDefinitionId = 'linux_mdatp_managed_exclusionsettings_exclusions_item_$type'
                                                choiceSettingValue = @{
                                                    children = @(
                                                        @{
                                                            '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                                            settingDefinitionId = 'linux_mdatp_managed_exclusionsettings_exclusions_item_name'
                                                            simpleSettingValue = @{
                                                                '@odata.type' = '#microsoft.graph.deviceManagementConfigurationStringSettingValue'
                                                                value = 'Test'
                                                            }
                                                        }
                                                    )
                                                    value = 'linux_mdatp_managed_exclusionsettings_exclusions_item_$type_1'
                                                }
                                            }
                                        )
                                    }
                                )
                            }
                        }
                    }
                )
            }

            Mock -CommandName Update-DeviceConfigurationPolicyAssignment -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            # Mock Write-M365DSCHost to hide output during the tests
            Mock -CommandName Write-M365DSCHost -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false

            Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicyAssignment -MockWith {
                return @(@{
                    Id       = '12345-12345-12345-12345-12345'
                    Source   = 'direct'
                    SourceId = '12345-12345-12345-12345-12345'
                    Target   = @{
                        DeviceAndAppManagementAssignmentFilterId   = '12345-12345-12345-12345-12345'
                        DeviceAndAppManagementAssignmentFilterType = 'none'
                        AdditionalProperties                       = @(
                            @{
                                '@odata.type' = '#microsoft.graph.exclusionGroupAssignmentTarget'
                                groupId       = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                            }
                        )
                    }
                })
            }
        }

        # Test contexts
        Context -Name "The IntuneDefenderGlobalExclusionsPolicyLinux should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            DataType     = '#microsoft.graph.exclusionGroupAssignmentTarget'
                            groupId = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                            deviceAndAppManagementAssignmentFilterType = 'none'
                        } -ClientOnly)
                    )
                    Description = "My Test"
                    Exclusions = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphIntuneSettingsCatalogExclusions -Property @{
                            Exclusions_item_path = '/temp/dir/local'
                            Exclusions_item_type = '0'
                            Exclusions_item_isDirectory = 'true'
                        } -ClientOnly)
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphIntuneSettingsCatalogExclusions -Property @{
                            Exclusions_item_name = 'Test'
                            Exclusions_item_type = '1'
                        } -ClientOnly)
                    );
                    Id = "12345-12345-12345-12345-12345"
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

        Context -Name "The IntuneDefenderGlobalExclusionsPolicyLinux exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            DataType     = '#microsoft.graph.exclusionGroupAssignmentTarget'
                            groupId = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                            deviceAndAppManagementAssignmentFilterType = 'none'
                        } -ClientOnly)
                    )
                    Description = "My Test"
                    Exclusions = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphIntuneSettingsCatalogExclusions -Property @{
                            Exclusions_item_path = '/temp/dir/local'
                            Exclusions_item_type = '0'
                            Exclusions_item_isDirectory = 'true'
                        } -ClientOnly)
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphIntuneSettingsCatalogExclusions -Property @{
                            Exclusions_item_name = 'Test'
                            Exclusions_item_type = '1'
                        } -ClientOnly)
                    );
                    Id = "12345-12345-12345-12345-12345"
                    DisplayName = "My Test"
                    RoleScopeTagIds = @("FakeStringValue")
                    Ensure = "Absent"
                    Credential = $Credential;
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgBetaDeviceManagementConfigurationPolicy -Exactly 1
            }
        }

        Context -Name "The IntuneDefenderGlobalExclusionsPolicyLinux Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            DataType     = '#microsoft.graph.exclusionGroupAssignmentTarget'
                            groupId = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                            deviceAndAppManagementAssignmentFilterType = 'none'
                        } -ClientOnly)
                    )
                    Description = "My Test"
                    Exclusions = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphIntuneSettingsCatalogExclusions -Property @{
                            Exclusions_item_path = '/temp/dir/local'
                            Exclusions_item_type = '0'
                            Exclusions_item_isDirectory = 'true'
                        } -ClientOnly)
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphIntuneSettingsCatalogExclusions -Property @{
                            Exclusions_item_name = 'Test'
                            Exclusions_item_type = '1'
                        } -ClientOnly)
                    );
                    Id = "12345-12345-12345-12345-12345"
                    DisplayName = "My Test"
                    RoleScopeTagIds = @("FakeStringValue")
                    Ensure = "Present"
                    Credential = $Credential;
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The IntuneDefenderGlobalExclusionsPolicyLinux exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            DataType     = '#microsoft.graph.exclusionGroupAssignmentTarget'
                            groupId = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                            deviceAndAppManagementAssignmentFilterType = 'none'
                        } -ClientOnly)
                    )
                    Description = "My Test"
                    Exclusions = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphIntuneSettingsCatalogExclusions -Property @{
                            Exclusions_item_path = '/temp/dir/local/file.txt' # Updated property
                            Exclusions_item_type = '0'
                            Exclusions_item_isDirectory = 'false' # Updated property
                        } -ClientOnly)
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphIntuneSettingsCatalogExclusions -Property @{
                            Exclusions_item_name = 'Test'
                            Exclusions_item_type = '1'
                        } -ClientOnly)
                    );
                    Id = "12345-12345-12345-12345-12345"
                    DisplayName = "My Test"
                    RoleScopeTagIds = @("FakeStringValue")
                    Ensure = "Present"
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
