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
    -DscResource 'IntuneEndpointDetectionAndResponsePolicyWindows10' -GenericStubModule $GenericStubPath

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
                    TemplateId = '0385b795-0f2f-44ac-8602-9f65bf6adede_1'
                }
            }

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
                                    "@odata.type"     = '#microsoft.graph.exclusionGroupAssignmentTarget'
                                    groupId = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                                }
                            )
                        }
                    })
            }
            Mock -CommandName Update-DeviceConfigurationPolicyAssignment -MockWith {
            }
            Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicyTemplateSettingTemplate -MockWith {
                return @{
                    Id       = '12345-12345-12345-12345-12345'
                    SettingInstanceTemplate = @{
                        settingDefinitionId = 'device_vendor_msft_windowsadvancedthreatprotection_configuration_samplesharing'
                        settingInstanceTemplateId = '6998c81e-2814-4f5e-b492-a6159128a97b'
                        AdditionalProperties = @{
                            '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingDefinition'
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
                            DataType     = '#microsoft.graph.exclusionGroupAssignmentTarget'
                            GroupId = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                        } -ClientOnly)
                    )
                    Credential    = $Credential
                    Description   = 'My Test Description'
                    DisplayName   = 'My Test'
                    Ensure        = 'Present'
                    Identity      = '619bd4a4-3b3b-4441-bd6f-3f4c0c444870'
                    sampleSharing = "0"
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
                            DataType     = '#microsoft.graph.exclusionGroupAssignmentTarget'
                            GroupId = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                        } -ClientOnly)
                    )
                    Credential    = $Credential
                    Description   = 'My Test Description'
                    DisplayName   = 'My Test'
                    Ensure        = 'Present'
                    Identity      = '619bd4a4-3b3b-4441-bd6f-3f4c0c444870'
                    sampleSharing = "0"
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
                            SettingDefinitionId              = 'device_vendor_msft_windowsadvancedthreatprotection_configuration_samplesharing'
                            SettingInstanceTemplateReference = @{
                                SettingInstanceTemplateId = '6998c81e-2814-4f5e-b492-a6159128a97b'
                            }
                            AdditionalProperties             = @{
                                '@odata.type'      = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                choiceSettingValue = @{
                                    children = @()
                                    value = "device_vendor_msft_windowsadvancedthreatprotection_configuration_samplesharing_1"
                                }
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
                            DataType     = '#microsoft.graph.exclusionGroupAssignmentTarget'
                            GroupId = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                            DeviceAndAppManagementAssignmentFilterType = 'none'
                        } -ClientOnly)
                    )
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicy -MockWith {
                    return @{
                        Id    = '619bd4a4-3b3b-4441-bd6f-3f4c0c444870'
                        Description = 'My Test Description'
                        Name        = 'My Test'
                        Settings = @{
                            Id                   = 0
                            SettingDefinitions   = $null
                            SettingInstance      = @{
                                SettingDefinitionId              = 'device_vendor_msft_windowsadvancedthreatprotection_configuration_samplesharing'
                                SettingInstanceTemplateReference = @{
                                    SettingInstanceTemplateId = '6998c81e-2814-4f5e-b492-a6159128a97b'
                                }
                                AdditionalProperties             = @{
                                    '@odata.type'      = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                    choiceSettingValue = @{
                                        children = @()
                                        value = "device_vendor_msft_windowsadvancedthreatprotection_configuration_samplesharing_0"
                                    }
                                }
                            }
                            AdditionalProperties = $null
                        }
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
                            DataType     = '#microsoft.graph.exclusionGroupAssignmentTarget'
                            GroupId = '26d60dd1-fab6-47bf-8656-358194c1a49d'
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
                            SettingDefinitionId              = 'device_vendor_msft_windowsadvancedthreatprotection_configuration_samplesharing'
                            SettingInstanceTemplateReference = @{
                                SettingInstanceTemplateId = '6998c81e-2814-4f5e-b492-a6159128a97b'
                            }
                            AdditionalProperties             = @{
                                '@odata.type'      = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                choiceSettingValue = @{
                                    children = @()
                                    value = "device_vendor_msft_windowsadvancedthreatprotection_configuration_samplesharing_0"
                                }
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
                            TemplateId = '0385b795-0f2f-44ac-8602-9f65bf6adede_1'
                        }
                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicySetting -MockWith {
                    return @{
                        Id                   = 0
                        SettingDefinitions   = $null
                        SettingInstance      = @{
                            SettingDefinitionId              = 'device_vendor_msft_windowsadvancedthreatprotection_configuration_samplesharing'
                            SettingInstanceTemplateReference = @{
                                SettingInstanceTemplateId = '6998c81e-2814-4f5e-b492-a6159128a97b'
                            }
                            AdditionalProperties             = @{
                                '@odata.type'      = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                choiceSettingValue = @{
                                    children = @()
                                    value = "device_vendor_msft_windowsadvancedthreatprotection_configuration_samplesharing_0"
                                }
                            }
                        }
                        AdditionalProperties = $null
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
