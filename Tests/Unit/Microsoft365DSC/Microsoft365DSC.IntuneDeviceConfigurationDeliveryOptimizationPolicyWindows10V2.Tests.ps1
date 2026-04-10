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
    -DscResource "IntuneDeviceConfigurationDeliveryOptimizationPolicyWindows10V2" -GenericStubModule $GenericStubPath
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

            Mock -CommandName Update-IntuneDeviceConfigurationPolicy -MockWith {
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
                    Id              = '12345-12345-12345-12345-12345'
                    Description     = 'My Test'
                    Name            = 'My Test'
                    RoleScopeTagIds = @("FakeStringValue")
                    TemplateReference = @{
                        TemplateId = '132f1027-0325-45e0-854a-6955cd3c68c0_1'
                    }
                }
            }

            Mock -CommandName Get-IntuneSettingCatalogPolicySetting -MockWith {
            }

            Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicySetting -MockWith {
                return @(
                    @{
                        Id                   = '0'
                        SettingDefinitions   = @(
                            @{
                                Id = 'device_vendor_msft_policy_config_deliveryoptimization_dodownloadmode'
                                Name = 'DODownloadMode'
                                OffsetUri = '/Config/DeliveryOptimization/DODownloadMode'
                                AdditionalProperties = @{
                                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingDefinition'
                                    options = @(
                                        @{
                                            itemId = 'device_vendor_msft_policy_config_deliveryoptimization_dodownloadmode_0'
                                            name = 'HTTP only, no peering'
                                            optionValue = @{
                                                '@odata.type' = '#microsoft.graph.deviceManagementConfigurationIntegerSettingValue'
                                                value = 0
                                            }
                                        }
                                    )
                                }
                            }
                        )
                        SettingInstance      = @{
                            SettingDefinitionId              = 'device_vendor_msft_policy_config_deliveryoptimization_dodownloadmode'
                            SettingInstanceTemplateReference = @{
                                SettingInstanceTemplateId = '8e5ed494-b8fa-49cc-8b80-94e4149296fa'
                            }
                            AdditionalProperties             = @{
                                '@odata.type'               = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                choiceSettingValue = @{
                                    children = @()
                                    value = 'device_vendor_msft_policy_config_deliveryoptimization_dodownloadmode_0'
                                }
                            }
                        }
                    }
                    @{
                        Id = '1'
                        SettingDefinitions = @(
                            @{
                                Id = 'device_vendor_msft_policy_config_deliveryoptimization_domaxforegrounddownloadbandwidth'
                                Name = 'DOMaxForegroundDownloadBandwidth'
                                OffsetUri = '/Config/DeliveryOptimization/DOMaxForegroundDownloadBandwidth'
                                AdditionalProperties = @{
                                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSimpleSettingDefinition'
                                }
                            }
                        )
                        SettingInstance = @{
                            SettingDefinitionId              = 'device_vendor_msft_policy_config_deliveryoptimization_domaxforegrounddownloadbandwidth'
                            SettingInstanceTemplateReference = @{
                                SettingInstanceTemplateId = '1d9aa48a-2059-40eb-b211-5ad1d82cf27b'
                            }
                            AdditionalProperties             = @{
                                '@odata.type'               = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                simpleSettingValue          = @{
                                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationIntegerSettingValue'
                                    value         = 100
                                }
                            }
                        }
                    }
                    @{
                        Id = '2'
                        SettingDefinitions = @(
                            @{
                                Id = 'device_vendor_msft_policy_config_deliveryoptimization_docachehost'
                                Name = 'DOCacheHost'
                                OffsetUri = '/Config/DeliveryOptimization/DOCacheHost'
                                AdditionalProperties = @{
                                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionDefinition'
                                    maximumCount = 1000
                                    minimumCount = 0
                                }
                            }
                        )
                        SettingInstance = @{
                            SettingDefinitionId              = 'device_vendor_msft_policy_config_deliveryoptimization_docachehost'
                            SettingInstanceTemplateReference = @{
                                SettingInstanceTemplateId = '5ff7d429-fa5b-410f-b72e-91f6c8cadb31'
                            }
                            AdditionalProperties             = @{
                                '@odata.type'               = '#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance'
                                simpleSettingCollectionValue = @(
                                    @{
                                        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationStringSettingValue'
                                        value         = 'CacheHost1'
                                    },
                                    @{
                                        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationStringSettingValue'
                                        value         = 'CacheHost2'
                                    }
                                )
                            }
                        }
                    }
                )
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            Mock -ModuleName M365DSCIntuneUtil -CommandName Get-MgGroup -MockWith {
                return @{
                    Id = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                    DisplayName = 'Exclude'
                }
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
        Context -Name "The IntuneDeviceConfigurationDeliveryOptimizationPolicyWindows10V2 should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            DataType     = '#microsoft.graph.exclusionGroupAssignmentTarget'
                            groupId = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                            deviceAndAppManagementAssignmentFilterType = 'none'
                            groupDisplayName = 'Exclude'
                        } -ClientOnly)
                    )
                    Description = "My Test"
                    DODownloadMode = 0
                    DOMaxForegroundDownloadBandwidth = 100
                    DOCacheHost = @("CacheHost1", "CacheHost2")
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

        Context -Name "The IntuneDeviceConfigurationDeliveryOptimizationPolicyWindows10V2 exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            DataType     = '#microsoft.graph.exclusionGroupAssignmentTarget'
                            groupId = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                            deviceAndAppManagementAssignmentFilterType = 'none'
                            groupDisplayName = 'Exclude'
                        } -ClientOnly)
                    )
                    Description = "My Test"
                    DODownloadMode = 0
                    DOMaxForegroundDownloadBandwidth = 100
                    DOCacheHost = @("CacheHost1", "CacheHost2")
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

            It 'Should Remove the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgBetaDeviceManagementConfigurationPolicy -Exactly 1
            }
        }

        Context -Name "The IntuneDeviceConfigurationDeliveryOptimizationPolicyWindows10V2 Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            DataType     = '#microsoft.graph.exclusionGroupAssignmentTarget'
                            groupId = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                            deviceAndAppManagementAssignmentFilterType = 'none'
                            groupDisplayName = 'Exclude'
                        } -ClientOnly)
                    )
                    Description = "My Test"
                    DODownloadMode = 0
                    DOMaxForegroundDownloadBandwidth = 100
                    DOCacheHost = @("CacheHost1", "CacheHost2")
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

        Context -Name "The IntuneDeviceConfigurationDeliveryOptimizationPolicyWindows10V2 exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            DataType     = '#microsoft.graph.exclusionGroupAssignmentTarget'
                            groupId = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                            deviceAndAppManagementAssignmentFilterType = 'none'
                            groupDisplayName = 'Exclude'
                        } -ClientOnly)
                    )
                    Description = "My Test"
                    DODownloadMode = 1 # Updated property
                    DOMaxForegroundDownloadBandwidth = 100
                    DOCacheHost = @("CacheHost1", "CacheHost2")
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
