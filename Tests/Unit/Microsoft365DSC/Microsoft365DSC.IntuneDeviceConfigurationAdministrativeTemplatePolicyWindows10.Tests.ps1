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
    -DscResource 'IntuneDeviceConfigurationAdministrativeTemplatePolicyWindows10' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-GUID).ToString() -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Write-Host -MockWith {
            }

            Mock -CommandName Update-MgBetaDeviceManagementGroupPolicyConfiguration -MockWith {
            }

            Mock -CommandName Remove-MgBetaDeviceManagementGroupPolicyConfiguration -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Get-MgBetaDeviceManagementGroupPolicyConfigurationAssignment -MockWith {
                return @(@{
                        target = @{
                            deviceAndAppManagementAssignmentFilterType = 'none'
                            AdditionalProperties                       = @{'@odata.type' = '#microsoft.graph.allDevicesAssignmentTarget' }
                        }
                    })
            }
            Mock -CommandName Update-DeviceConfigurationPolicyAssignment -MockWith {
            }
            Mock -CommandName Update-DeviceConfigurationGroupPolicyDefinitionValue -MockWith {
            }
        }
        # Test contexts
        Context -Name 'The IntuneDeviceConfigurationAdministrativeTemplatePolicyWindows10 should exist but it DOES NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    Description                      = 'FakeStringValue'
                    DisplayName                      = 'FakeStringValue'
                    Id                               = 'FakeStringValue'
                    PolicyConfigurationIngestionType = 'unknown'
                    Ensure                           = 'Present'
                    Credential                       = $Credential
                    Assignments                      = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            deviceAndAppManagementAssignmentFilterType = 'none'
                            dataType                                   = '#microsoft.graph.allDevicesAssignmentTarget'
                        } -ClientOnly)
                    )
                    DefinitionValues                 = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_IntuneGroupPolicyDefinitionValue -Property @{
                            ConfigurationType  = 'policy'
                            PresentationValues = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_IntuneGroupPolicyDefinitionValuePresentationValue -Property @{
                                    presentationDefinitionId    = '98210829-af9b-4020-8d96-3e4108557a95'
                                    presentationDefinitionLabel = 'Types of extensions/apps that are allowed to be installed'
                                    KeyValuePairValues          = [CimInstance[]]@(
                                        (New-CimInstance -ClassName MSFT_IntuneGroupPolicyDefinitionValuePresentationValueKeyValuePair -Property @{
                                            Name = 'hosted_app'
                                        } -ClientOnly)
                                    )
                                    Id                          = '7312a452-e087-4290-9b9f-3f14a304c18d'
                                    odataType                   = '#microsoft.graph.groupPolicyPresentationValueList'
                                } -ClientOnly)
                            )
                            Id                 = 'f3047f6a-550e-4b5e-b3da-48fc951b72fc'
                            Definition         = (New-CimInstance -ClassName MSFT_IntuneGroupPolicyDefinitionValueDefinition -Property @{
                                    Id           = '37ab8b81-47d7-46d8-8b99-81d9cecdcce9'
                                    DisplayName  = 'Configure allowed app/extension types'
                                    CategoryPath = '\Google\Google Chrome\Extensions'
                                    PolicyType   = 'admxIngested'
                                    SupportedOn  = 'Microsoft Windows 7 or later'
                                    ClassType    = 'machine'
                                } -ClientOnly)
                            Enabled            = $True
                        } -ClientOnly)
                    )
                }

                Mock -CommandName Get-MgBetaDeviceManagementGroupPolicyConfiguration -MockWith {
                    return $null
                }

                Mock -CommandName New-MgBetaDeviceManagementGroupPolicyConfiguration -MockWith {
                    return @{
                        id          = 'fakeNewId'
                        displayName = 'fakeNewDisplayName'
                    }
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
                Should -Invoke -CommandName New-MgBetaDeviceManagementGroupPolicyConfiguration -Exactly 1
                Should -Invoke -CommandName Update-DeviceConfigurationPolicyAssignment -Exactly 1
            }
        }

        Context -Name 'The IntuneDeviceConfigurationAdministrativeTemplatePolicyWindows10 exists but it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    Description                      = 'FakeStringValue'
                    DisplayName                      = 'FakeStringValue'
                    Id                               = 'FakeStringValue'
                    PolicyConfigurationIngestionType = 'unknown'
                    Ensure                           = 'Absent'
                    Credential                       = $Credential
                    Assignments                      = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            deviceAndAppManagementAssignmentFilterType = 'none'
                            dataType                                   = '#microsoft.graph.allDevicesAssignmentTarget'
                        } -ClientOnly)
                    )
                    DefinitionValues                 = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_IntuneGroupPolicyDefinitionValue -Property @{
                            ConfigurationType  = 'policy'
                            PresentationValues = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_IntuneGroupPolicyDefinitionValuePresentationValue -Property @{
                                    presentationDefinitionId    = '98210829-af9b-4020-8d96-3e4108557a95'
                                    presentationDefinitionLabel = 'Types of extensions/apps that are allowed to be installed'
                                    KeyValuePairValues          = [CimInstance[]]@(
                                        (New-CimInstance -ClassName MSFT_IntuneGroupPolicyDefinitionValuePresentationValueKeyValuePair -Property @{
                                            Name = 'hosted_app'
                                        } -ClientOnly)
                                    )
                                    Id                          = '7312a452-e087-4290-9b9f-3f14a304c18d'
                                    odataType                   = '#microsoft.graph.groupPolicyPresentationValueList'
                                } -ClientOnly)
                            )
                            Id                 = 'f3047f6a-550e-4b5e-b3da-48fc951b72fc'
                            Definition         = (New-CimInstance -ClassName MSFT_IntuneGroupPolicyDefinitionValueDefinition -Property @{
                                    Id           = '37ab8b81-47d7-46d8-8b99-81d9cecdcce9'
                                    DisplayName  = 'Configure allowed app/extension types'
                                    CategoryPath = '\Google\Google Chrome\Extensions'
                                    PolicyType   = 'admxIngested'
                                    SupportedOn  = 'Microsoft Windows 7 or later'
                                    ClassType    = 'machine'
                                } -ClientOnly)
                            Enabled            = $True
                        } -ClientOnly)
                    )
                }

                Mock -CommandName Get-MgBetaDeviceManagementGroupPolicyConfiguration -MockWith {
                    return @{
                        AdditionalProperties             = @{
                            '@odata.type' = '#microsoft.graph.GroupPolicyConfiguration'
                        }
                        Description                      = 'FakeStringValue'
                        DisplayName                      = 'FakeStringValue'
                        Id                               = 'FakeStringValue'
                        PolicyConfigurationIngestionType = 'unknown'
                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementGroupPolicyConfigurationDefinitionValue -MockWith {
                    return @(
                        @{
                            ConfigurationType                = 'fakeConfigurationType'
                            Enabled                          = $true
                            Id                               = 'fakeDefinitionValueId'
                            PolicyConfigurationIngestionType = 'unknown'
                        }
                    )
                }

                Mock -CommandName Get-MgBetaDeviceManagementGroupPolicyConfigurationDefinitionValueDefinition -MockWith {
                    return @{
                        Id           = '37ab8b81-47d7-46d8-8b99-81d9cecdcce9'
                        DisplayName  = 'Configure allowed app/extension types'
                        CategoryPath = '\Google\Google Chrome\Extensions'
                        PolicyType   = 'admxIngested'
                        SupportedOn  = 'Microsoft Windows 7 or later'
                        ClassType    = 'machine'
                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementGroupPolicyConfigurationDefinitionValuePresentationValue -MockWith {
                    return @{
                        AdditionalProperties             = @{
                            '@odata.type' = '#microsoft.graph.groupPolicyPresentationValueList'
                            values        = @(
                                @{
                                    name = "`"hosted_app`""
                                }
                            )
                        }
                        Id                               = 'fakePresentationId'
                        Presentation                     = @{
                            Id    = 'fakePresentationDefinitionId'
                            Label = 'fakePresentationLabel'
                        }
                        PolicyConfigurationIngestionType = 'unknown'
                    }
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
                Should -Invoke -CommandName Remove-MgBetaDeviceManagementGroupPolicyConfiguration -Exactly 1
            }
        }
        Context -Name 'The IntuneDeviceConfigurationAdministrativeTemplatePolicyWindows10 Exists and Values are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    Description                      = 'FakeStringValue'
                    DisplayName                      = 'FakeStringValue'
                    Id                               = 'FakeStringValue'
                    PolicyConfigurationIngestionType = 'unknown'
                    Ensure                           = 'Present'
                    Credential                       = $Credential
                    Assignments                      = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            deviceAndAppManagementAssignmentFilterType = 'none'
                            dataType                                   = '#microsoft.graph.allDevicesAssignmentTarget'
                        } -ClientOnly)
                    )
                    DefinitionValues                 = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_IntuneGroupPolicyDefinitionValue -Property @{
                            ConfigurationType  = 'policy'
                            PresentationValues = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_IntuneGroupPolicyDefinitionValuePresentationValue -Property @{
                                    presentationDefinitionId    = 'fakePresentationDefinitionId'
                                    presentationDefinitionLabel = 'fakePresentationDefinitionLabel'
                                    KeyValuePairValues          = [CimInstance[]]@(
                                        (New-CimInstance -ClassName MSFT_IntuneGroupPolicyDefinitionValuePresentationValueKeyValuePair -Property @{
                                            Name = 'hosted_app'
                                        } -ClientOnly)
                                    )
                                    Id                          = 'fakePresentationId'
                                    odataType                   = '#microsoft.graph.groupPolicyPresentationValueList'
                                } -ClientOnly)
                            )
                            Id                 = 'fakeDefinitionValueId'
                            Definition         = (New-CimInstance -ClassName MSFT_IntuneGroupPolicyDefinitionValueDefinition -Property @{
                                    Id           = '37ab8b81-47d7-46d8-8b99-81d9cecdcce9'
                                    DisplayName  = 'Configure allowed app/extension types'
                                    CategoryPath = '\Google\Google Chrome\Extensions'
                                    PolicyType   = 'admxIngested'
                                    SupportedOn  = 'Microsoft Windows 7 or later'
                                    ClassType    = 'machine'
                                } -ClientOnly)
                            Enabled            = $True
                        } -ClientOnly)
                    )
                }

                Mock -CommandName Get-MgBetaDeviceManagementGroupPolicyConfiguration -MockWith {
                    return @{
                        AdditionalProperties             = @{
                            '@odata.type' = '#microsoft.graph.GroupPolicyConfiguration'
                        }
                        Description                      = 'FakeStringValue'
                        DisplayName                      = 'FakeStringValue'
                        Id                               = 'FakeStringValue'
                        PolicyConfigurationIngestionType = 'unknown'
                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementGroupPolicyConfigurationDefinitionValue -MockWith {
                    return @(
                        @{
                            Enabled           = $true
                            Id                = 'fakeDefinitionValueId'
                            ConfigurationType = 'policy'
                        }
                    )
                }

                Mock -CommandName Get-MgBetaDeviceManagementGroupPolicyConfigurationDefinitionValueDefinition -MockWith {
                    return @{
                        Id           = '37ab8b81-47d7-46d8-8b99-81d9cecdcce9'
                        DisplayName  = 'Configure allowed app/extension types'
                        CategoryPath = '\Google\Google Chrome\Extensions'
                        PolicyType   = 'admxIngested'
                        SupportedOn  = 'Microsoft Windows 7 or later'
                        ClassType    = 'machine'
                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementGroupPolicyConfigurationDefinitionValuePresentationValue -MockWith {
                    return @{
                        AdditionalProperties = @{
                            '@odata.type' = '#microsoft.graph.groupPolicyPresentationValueList'
                            values        = @(
                                @{
                                    name = "`"hosted_app`""
                                }
                            )
                        }
                        Id                   = 'fakePresentationId'
                        Presentation         = @{
                            Id    = 'fakePresentationDefinitionId'
                            Label = 'fakePresentationDefinitionLabel'
                        }
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'The IntuneDeviceConfigurationAdministrativeTemplatePolicyWindows10 exists and values are NOT in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    Description                      = 'FakeStringValue'
                    DisplayName                      = 'FakeStringValue'
                    Id                               = 'FakeStringValue'
                    PolicyConfigurationIngestionType = 'unknown'
                    Ensure                           = 'Present'
                    Credential                       = $Credential
                    Assignments                      = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            deviceAndAppManagementAssignmentFilterType = 'none'
                            dataType                                   = '#microsoft.graph.allDevicesAssignmentTarget'
                        } -ClientOnly)
                    )
                    DefinitionValues                 = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_IntuneGroupPolicyDefinitionValue -Property @{
                            ConfigurationType  = 'policy'
                            PresentationValues = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_IntuneGroupPolicyDefinitionValuePresentationValue -Property @{
                                    presentationDefinitionId    = 'fakePresentationDefinitionId'
                                    presentationDefinitionLabel = 'fakePresentationDefinitionLabel'
                                    KeyValuePairValues          = [CimInstance[]]@(
                                        (New-CimInstance -ClassName MSFT_IntuneGroupPolicyDefinitionValuePresentationValueKeyValuePair -Property @{
                                            Name = 'hosted_app'
                                        } -ClientOnly)
                                    )
                                    Id                          = 'fakePresentationId'
                                    odataType                   = '#microsoft.graph.groupPolicyPresentationValueList'
                                } -ClientOnly)
                            )
                            Id                 = 'fakeDefinitionValueId'
                            Definition         = (New-CimInstance -ClassName MSFT_IntuneGroupPolicyDefinitionValueDefinition -Property @{
                                    Id           = '37ab8b81-47d7-46d8-8b99-81d9cecdcce9'
                                    DisplayName  = 'Configure allowed app/extension types'
                                    CategoryPath = '\Google\Google Chrome\Extensions'
                                    PolicyType   = 'admxIngested'
                                    SupportedOn  = 'Microsoft Windows 7 or later'
                                    ClassType    = 'machine'
                                } -ClientOnly)
                            Enabled            = $True
                        } -ClientOnly)
                    )
                }

                Mock -CommandName Get-MgBetaDeviceManagementGroupPolicyConfiguration -MockWith {
                    return @{
                        AdditionalProperties             = @{
                            '@odata.type' = '#microsoft.graph.GroupPolicyConfiguration'
                        }
                        Description                      = 'FakeStringValue'
                        DisplayName                      = 'FakeStringValue'
                        Id                               = 'FakeStringValue'
                        PolicyConfigurationIngestionType = 'unknown'
                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementGroupPolicyConfigurationDefinitionValue -MockWith {
                    return @(
                        @{
                            Enabled           = $true
                            Id                = 'fakeDefinitionValueId'
                            ConfigurationType = 'policy'
                        }
                    )
                }

                Mock -CommandName Get-MgBetaDeviceManagementGroupPolicyConfigurationDefinitionValueDefinition -MockWith {
                    return @{
                        Id           = '37ab8b81-47d7-46d8-8b99-81d9cecdcce9'
                        DisplayName  = 'Configure allowed app/extension types'
                        CategoryPath = '\Google\Google Chrome\Extensions'
                        PolicyType   = 'admxIngested'
                        SupportedOn  = 'Microsoft Windows 7 or later'
                        ClassType    = 'machine'
                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementGroupPolicyConfigurationDefinitionValuePresentationValue -MockWith {
                    return @{
                        AdditionalProperties = @{
                            '@odata.type' = '#microsoft.graph.groupPolicyPresentationValueList'
                            values        = @(
                                @{
                                    name = "`"user_script`""
                                }
                            )
                        }
                        Id                   = 'fakePresentationId'
                        Presentation         = @{
                            Id    = 'fakePresentationDefinitionId'
                            Label = 'fakePresentationDefinitionLabel'
                        }
                    }
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
                Should -Invoke -CommandName Update-MgBetaDeviceManagementGroupPolicyConfiguration -Exactly 1
                Should -Invoke -CommandName Update-DeviceConfigurationPolicyAssignment -Exactly 1
                Should -Invoke -CommandName Update-DeviceConfigurationGroupPolicyDefinitionValue -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementGroupPolicyConfiguration -MockWith {
                    return @(@{
                            AdditionalProperties             = @{
                                '@odata.type' = '#microsoft.graph.GroupPolicyConfiguration'
                            }
                            Description                      = 'FakeStringValue'
                            DisplayName                      = 'AdministrativeTemplatePolicyWindows10'
                            Id                               = 'FakeStringValue'
                            PolicyConfigurationIngestionType = 'unknown'
                        })
                }

                Mock -CommandName Get-MgBetaDeviceManagementGroupPolicyConfigurationDefinitionValue -MockWith {
                    return @(
                        @{
                            ConfigurationType                = 'fakeConfigurationType'
                            Enabled                          = $true
                            Id                               = 'fakeDefinitionValueId'
                            PolicyConfigurationIngestionType = 'unknown'
                        }
                    )
                }

                Mock -CommandName Get-MgBetaDeviceManagementGroupPolicyConfigurationDefinitionValueDefinition -MockWith {
                    return @{
                        Id           = '37ab8b81-47d7-46d8-8b99-81d9cecdcce9'
                        DisplayName  = 'Configure allowed app/extension types'
                        CategoryPath = '\Google\Google Chrome\Extensions'
                        PolicyType   = 'admxIngested'
                        SupportedOn  = 'Microsoft Windows 7 or later'
                        ClassType    = 'machine'
                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementGroupPolicyConfigurationDefinitionValuePresentationValue -MockWith {
                    return @{
                        AdditionalProperties             = @{
                            '@odata.type' = '#microsoft.graph.groupPolicyPresentationValueList'
                            values        = @(
                                @{
                                    name = "`"hosted_app`""
                                }
                            )
                        }
                        Id                               = 'fakePresentationId'
                        Presentation                     = @{
                            Id    = 'fakePresentationDefinitionId'
                            Label = 'fakePresentationLabel'
                        }
                        PolicyConfigurationIngestionType = 'unknown'
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
