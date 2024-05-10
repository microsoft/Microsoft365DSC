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
    -DscResource 'IntuneSettingCatalogCustomPolicyWindows10' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString 'f@kepassword1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName New-MgBetaDeviceManagementConfigurationPolicy -MockWith {
            }

            Mock -CommandName Remove-MgBetaDeviceManagementConfigurationPolicy -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false

            Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicyAssignment -MockWith {
            }
            Mock -CommandName Update-DeviceConfigurationPolicyAssignment -MockWith {
            }
        }
        # Test contexts
        Context -Name 'The IntuneSettingCatalogCustomPolicyWindows10 should exist but it DOES NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    Description  = 'FakeStringValue'
                    Id           = 'FakeStringValue'
                    Name         = 'FakeStringValue'
                    Platforms    = 'Windows10'
                    Settings     = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSetting -Property @{
                            SettingInstance = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                    simpleSettingValue  = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                            StringValue = 'fakeValue'
                                            odataType   = '#microsoft.graph.deviceManagementConfigurationStringSettingValue'
                                        } -ClientOnly)
                                    SettingDefinitionId = 'stringSettingDefinitionId'
                                    odataType           = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                } -ClientOnly)
                        } -ClientOnly)
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSetting -Property @{
                            SettingInstance = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                    simpleSettingValue  = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                            valueState  = 'invalid'
                                            StringValue = 'fakeValue'
                                            odataType   = '#microsoft.graph.deviceManagementConfigurationSecretSettingValue'
                                        } -ClientOnly)
                                    SettingDefinitionId = 'stringSettingDefinitionId'
                                    odataType           = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                } -ClientOnly)
                        } -ClientOnly)
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSetting -Property @{
                            SettingInstance = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                    simpleSettingValue  = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                            IntValue  = 25
                                            odataType = '#microsoft.graph.deviceManagementConfigurationIntegerSettingValue'
                                        } -ClientOnly)
                                    SettingDefinitionId = 'stringSettingDefinitionId'
                                    odataType           = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                } -ClientOnly)
                        } -ClientOnly)
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSetting -Property @{
                            SettingInstance = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                    choiceSettingValue  = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                            value    = 'choiceSettingValue'
                                            children = [CimInstance[]]@()
                                        } -ClientOnly)
                                    SettingDefinitionId = 'stringSettingDefinitionId'
                                    odataType           = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                } -ClientOnly)
                        } -ClientOnly)
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSetting -Property @{
                            SettingInstance = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                    groupSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                            odataType = '#microsoft.graph.deviceManagementConfigurationGroupSettingValue'
                                            children  = [CimInstance[]]@(
                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                                    simpleSettingValue  = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                            StringValue = 'fakeValue'
                                                            odataType   = '#microsoft.graph.deviceManagementConfigurationStringSettingValue'
                                                        } -ClientOnly)
                                                    SettingDefinitionId = 'stringSettingDefinitionId'
                                                    odataType           = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                                } -ClientOnly)
                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                                    simpleSettingValue  = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                            valueState  = 'invalid'
                                                            StringValue = 'fakeValue'
                                                            odataType   = '#microsoft.graph.deviceManagementConfigurationSecretSettingValue'
                                                        } -ClientOnly)
                                                    SettingDefinitionId = 'stringSettingDefinitionId'
                                                    odataType           = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                                } -ClientOnly)
                                            )
                                        } -ClientOnly)
                                } -ClientOnly)
                        } -ClientOnly)
                    )
                    Technologies = 'mdm'
                    Ensure       = 'Present'
                    Credential   = $Credential
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

        Context -Name 'The IntuneSettingCatalogCustomPolicyWindows10 exists but it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    Description  = 'FakeStringValue'
                    Id           = 'FakeStringValue'
                    Name         = 'FakeStringValue'
                    Platforms    = 'windows10'
                    Settings     = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSetting -Property @{
                            SettingInstance = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                    simpleSettingValue  = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                            StringValue = 'fakeValue'
                                            odataType   = '#microsoft.graph.deviceManagementConfigurationStringSettingValue'
                                        } -ClientOnly)
                                    SettingDefinitionId = 'stringSettingDefinitionId'
                                    odataType           = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                } -ClientOnly)
                        } -ClientOnly)
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSetting -Property @{
                            SettingInstance = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                    simpleSettingValue  = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                            valueState  = 'invalid'
                                            StringValue = 'fakeValue'
                                            odataType   = '#microsoft.graph.deviceManagementConfigurationSecretSettingValue'
                                        } -ClientOnly)
                                    SettingDefinitionId = 'stringSettingDefinitionId'
                                    odataType           = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                } -ClientOnly)
                        } -ClientOnly)
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSetting -Property @{
                            SettingInstance = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                    simpleSettingValue  = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                            IntValue  = 25
                                            odataType = '#microsoft.graph.deviceManagementConfigurationIntegerSettingValue'
                                        } -ClientOnly)
                                    SettingDefinitionId = 'stringSettingDefinitionId'
                                    odataType           = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                } -ClientOnly)
                        } -ClientOnly)
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSetting -Property @{
                            SettingInstance = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                    choiceSettingValue  = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                            value    = 'choiceSettingValue'
                                            children = [CimInstance[]]@()
                                        } -ClientOnly)
                                    SettingDefinitionId = 'stringSettingDefinitionId'
                                    odataType           = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                } -ClientOnly)
                        } -ClientOnly)
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSetting -Property @{
                            SettingInstance = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                    groupSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                            odataType = '#microsoft.graph.deviceManagementConfigurationGroupSettingValue'
                                            children  = [CimInstance[]]@(
                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                                    simpleSettingValue  = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                            StringValue = 'fakeValue'
                                                            odataType   = '#microsoft.graph.deviceManagementConfigurationStringSettingValue'
                                                        } -ClientOnly)
                                                    SettingDefinitionId = 'stringSettingDefinitionId'
                                                    odataType           = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                                } -ClientOnly)
                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                                    simpleSettingValue  = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                            valueState  = 'invalid'
                                                            StringValue = 'fakeValue'
                                                            odataType   = '#microsoft.graph.deviceManagementConfigurationSecretSettingValue'
                                                        } -ClientOnly)
                                                    SettingDefinitionId = 'stringSettingDefinitionId'
                                                    odataType           = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                                } -ClientOnly)
                                            )
                                        } -ClientOnly)
                                } -ClientOnly)
                        } -ClientOnly)
                    )
                    Technologies = 'mdm'
                    Ensure       = 'Absent'
                    Credential   = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicy -MockWith {
                    return @{
                        Description  = 'FakeStringValue'
                        Id           = 'FakeStringValue'
                        Name         = 'FakeStringValue'
                        Platforms    = 'windows10'
                        Settings     = @(
                            @{
                                SettingInstance = @{
                                    AdditionalProperties = @{
                                        simpleSettingValue = @{
                                            StringValue   = 'fakeValue'
                                            '@odata.type' = '#microsoft.graph.deviceManagementConfigurationStringSettingValue'
                                        }
                                        '@odata.type'      = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                    }
                                    SettingDefinitionId  = 'stringSettingDefinitionId'
                                }
                            }
                            @{
                                SettingInstance = @{
                                    AdditionalProperties = @{
                                        simpleSettingValue = @{
                                            valueState    = 'invalid'
                                            StringValue   = 'fakeValue'
                                            '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSecretSettingValue'
                                        }
                                        '@odata.type'      = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                    }
                                    SettingDefinitionId  = 'secretSettingDefinitionId'
                                }
                            }
                            @{
                                SettingInstance = @{
                                    AdditionalProperties = @{
                                        simpleSettingValue = @{
                                            IntValue      = 25
                                            '@odata.type' = '#microsoft.graph.deviceManagementConfigurationIntegerSettingValue'
                                        }
                                        '@odata.type'      = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                    }
                                    SettingDefinitionId  = 'integerSettingDefinitionId'
                                }
                            }
                            @{
                                SettingInstance = @{
                                    AdditionalProperties = @{
                                        choiceSettingValue = @{
                                            value    = 'choiceSettingValue'
                                            children = @()
                                        }
                                        '@odata.type'      = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                    }
                                    SettingDefinitionId  = 'stringSettingDefinitionId'
                                }
                            }
                            @{
                                SettingInstance = @{
                                    AdditionalProperties = @{
                                        '@odata.type'     = '#microsoft.graph.deviceManagementConfigurationGroupSettingValue'
                                        groupSettingValue = @{
                                            children = @(
                                                @{
                                                    simpleSettingValue  = @{
                                                        StringValue   = 'fakeValue'
                                                        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationStringSettingValue'
                                                    }
                                                    SettingDefinitionId = 'stringSettingDefinitionId'
                                                    '@odata.type'       = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                                }
                                                @{
                                                    simpleSettingValue  = @{
                                                        valueState    = 'invalid'
                                                        StringValue   = 'fakeValue'
                                                        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSecretSettingValue'
                                                    }
                                                    SettingDefinitionId = 'secretSettingDefinitionId'
                                                    '@odata.type'       = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                                }
                                            )
                                        }
                                    }
                                    SettingDefinitionId  = 'groupSettingDefinitionId'
                                }
                            }
                        )
                        Technologies = 'mdm'
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
                Should -Invoke -CommandName Remove-MgBetaDeviceManagementConfigurationPolicy -Exactly 1
            }
        }
        Context -Name 'The IntuneSettingCatalogCustomPolicyWindows10 Exists and Values are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    Description  = 'FakeStringValue'
                    Id           = 'FakeStringValue'
                    Name         = 'FakeStringValue'
                    Platforms    = 'windows10'
                    Settings     = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSetting -Property @{
                            SettingInstance = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                    simpleSettingValue  = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                            StringValue = 'fakeValue'
                                            odataType   = '#microsoft.graph.deviceManagementConfigurationStringSettingValue'
                                        } -ClientOnly)
                                    SettingDefinitionId = 'stringSettingDefinitionId'
                                    odataType           = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                } -ClientOnly)
                        } -ClientOnly)
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSetting -Property @{
                            SettingInstance = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                    simpleSettingValue  = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                            valueState  = 'invalid'
                                            StringValue = 'fakeValue'
                                            odataType   = '#microsoft.graph.deviceManagementConfigurationSecretSettingValue'
                                        } -ClientOnly)
                                    SettingDefinitionId = 'secretSettingDefinitionId'
                                    odataType           = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                } -ClientOnly)
                        } -ClientOnly)
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSetting -Property @{
                            SettingInstance = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                    simpleSettingValue  = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                            IntValue  = 25
                                            odataType = '#microsoft.graph.deviceManagementConfigurationIntegerSettingValue'
                                        } -ClientOnly)
                                    SettingDefinitionId = 'integerSettingDefinitionId'
                                    odataType           = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                } -ClientOnly)
                        } -ClientOnly)
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSetting -Property @{
                            SettingInstance = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                    choiceSettingValue  = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                            value    = 'choiceSettingValue'
                                            children = [CimInstance[]]@()
                                        } -ClientOnly)
                                    SettingDefinitionId = 'choiceSettingDefinitionId'
                                    odataType           = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                } -ClientOnly)
                        } -ClientOnly)
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSetting -Property @{
                            SettingInstance = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                    odataType = '#microsoft.graph.deviceManagementConfigurationGroupSettingInstance'
                                    SettingDefinitionId = 'groupSettingDefinitionId'
                                    groupSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                            odataType = '#microsoft.graph.deviceManagementConfigurationGroupSettingValue'
                                            children  = [CimInstance[]]@(
                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                                    simpleSettingValue  = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                            StringValue = 'fakeValue'
                                                            odataType   = '#microsoft.graph.deviceManagementConfigurationStringSettingValue'
                                                        } -ClientOnly)
                                                    SettingDefinitionId = 'stringSettingDefinitionId'
                                                    odataType           = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                                } -ClientOnly)
                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                                    simpleSettingValue  = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                            valueState  = 'invalid'
                                                            StringValue = 'fakeValue'
                                                            odataType   = '#microsoft.graph.deviceManagementConfigurationSecretSettingValue'
                                                        } -ClientOnly)
                                                    SettingDefinitionId = 'secretSettingDefinitionId'
                                                    odataType           = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                                } -ClientOnly)
                                            )
                                        } -ClientOnly)
                                } -ClientOnly)
                        } -ClientOnly)
                    )
                    Technologies = 'mdm'
                    Ensure       = 'Present'
                    Credential   = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicy -MockWith {
                    return @{
                        Description  = 'FakeStringValue'
                        Id           = 'FakeStringValue'
                        Name         = 'FakeStringValue'
                        Platforms    = 'windows10'
                        Settings     = @(
                            @{
                                SettingInstance = @{
                                    AdditionalProperties = @{
                                        simpleSettingValue = @{
                                            value         = 'fakeValue'
                                            '@odata.type' = '#microsoft.graph.deviceManagementConfigurationStringSettingValue'
                                        }
                                        '@odata.type'      = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                    }
                                    SettingDefinitionId  = 'stringSettingDefinitionId'
                                }
                            }
                            @{
                                SettingInstance = @{
                                    AdditionalProperties = @{
                                        simpleSettingValue = @{
                                            valueState    = 'invalid'
                                            value         = 'fakeValue'
                                            '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSecretSettingValue'
                                        }
                                        '@odata.type'      = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                    }
                                    SettingDefinitionId  = 'secretSettingDefinitionId'
                                }
                            }
                            @{
                                SettingInstance = @{
                                    AdditionalProperties = @{
                                        simpleSettingValue = @{
                                            value         = 25
                                            '@odata.type' = '#microsoft.graph.deviceManagementConfigurationIntegerSettingValue'
                                        }
                                        '@odata.type'      = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                    }
                                    SettingDefinitionId  = 'integerSettingDefinitionId'
                                }
                            }
                            @{
                                SettingInstance = @{
                                    AdditionalProperties = @{
                                        choiceSettingValue = @{
                                            value    = 'choiceSettingValue'
                                            children = @()
                                        }
                                        '@odata.type'      = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                    }
                                    SettingDefinitionId  = 'choiceSettingDefinitionId'
                                }
                            }
                            @{
                                SettingInstance = @{
                                    SettingDefinitionId  = 'groupSettingDefinitionId'
                                    AdditionalProperties = @{
                                        '@odata.type'     = '#microsoft.graph.deviceManagementConfigurationGroupSettingInstance'
                                        groupSettingValue = @{
                                            '@odata.type'     = '#microsoft.graph.deviceManagementConfigurationGroupSettingValue'
                                            children = @(
                                                @{
                                                    simpleSettingValue  = @{
                                                        value         = 'fakeValue'
                                                        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationStringSettingValue'
                                                    }
                                                    SettingDefinitionId = 'stringSettingDefinitionId'
                                                    '@odata.type'       = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                                }
                                                @{
                                                    simpleSettingValue  = @{
                                                        valueState    = 'invalid'
                                                        value         = 'fakeValue'
                                                        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSecretSettingValue'
                                                    }
                                                    SettingDefinitionId = 'secretSettingDefinitionId'
                                                    '@odata.type'       = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                                }
                                            )
                                        }
                                    }
                                }
                            }
                        )
                        Technologies = 'mdm'
                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'The IntuneSettingCatalogCustomPolicyWindows10 exists and values are NOT in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    Description  = 'FakeStringValue'
                    Id           = 'FakeStringValue'
                    Name         = 'FakeStringValue'
                    Platforms    = 'windows10'
                    Settings     = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSetting -Property @{
                            SettingInstance = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                    simpleSettingValue  = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                            StringValue = 'fakeValue'
                                            odataType   = '#microsoft.graph.deviceManagementConfigurationStringSettingValue'
                                        } -ClientOnly)
                                    SettingDefinitionId = 'stringSettingDefinitionId'
                                    odataType           = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                } -ClientOnly)
                        } -ClientOnly)
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSetting -Property @{
                            SettingInstance = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                    simpleSettingValue  = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                            valueState  = 'invalid'
                                            StringValue = 'fakeValue'
                                            odataType   = '#microsoft.graph.deviceManagementConfigurationSecretSettingValue'
                                        } -ClientOnly)
                                    SettingDefinitionId = 'secretSettingDefinitionId'
                                    odataType           = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                } -ClientOnly)
                        } -ClientOnly)
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSetting -Property @{
                            SettingInstance = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                    simpleSettingValue  = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                            IntValue  = 25
                                            odataType = '#microsoft.graph.deviceManagementConfigurationIntegerSettingValue'
                                        } -ClientOnly)
                                    SettingDefinitionId = 'integerSettingDefinitionId'
                                    odataType           = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                } -ClientOnly)
                        } -ClientOnly)
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSetting -Property @{
                            SettingInstance = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                    choiceSettingValue  = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                            value    = 'choiceSettingValue'
                                            children = [CimInstance[]]@()
                                        } -ClientOnly)
                                    SettingDefinitionId = 'choiceSettingDefinitionId'
                                    odataType           = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                } -ClientOnly)
                        } -ClientOnly)
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSetting -Property @{
                            SettingInstance = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                    odataType = '#microsoft.graph.deviceManagementConfigurationGroupSettingInstance'
                                    SettingDefinitionId = 'groupSettingDefinitionId'
                                    groupSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                            odataType = '#microsoft.graph.deviceManagementConfigurationGroupSettingValue'
                                            children  = [CimInstance[]]@(
                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                                    simpleSettingValue  = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                            StringValue = 'fakeValue'
                                                            odataType   = '#microsoft.graph.deviceManagementConfigurationStringSettingValue'
                                                        } -ClientOnly)
                                                    SettingDefinitionId = 'stringSettingDefinitionId'
                                                    odataType           = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                                } -ClientOnly)
                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                                    simpleSettingValue  = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                            valueState  = 'invalid'
                                                            StringValue = 'fakeValue'
                                                            odataType   = '#microsoft.graph.deviceManagementConfigurationSecretSettingValue'
                                                        } -ClientOnly)
                                                    SettingDefinitionId = 'secretSettingDefinitionId'
                                                    odataType           = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                                } -ClientOnly)
                                            )
                                        } -ClientOnly)
                                } -ClientOnly)
                        } -ClientOnly)
                    )
                    Technologies = 'mdm'
                    Ensure       = 'Present'
                    Credential   = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicy -MockWith {
                    return @{
                        Description  = 'FakeStringValue'
                        Id           = 'FakeStringValue'
                        Name         = 'FakeStringValue'
                        Platforms    = 'windows10'
                        Settings     = @(
                            @{
                                SettingInstance = @{
                                    AdditionalProperties = @{
                                        simpleSettingValue = @{
                                            value         = 'fakeValue'
                                            '@odata.type' = '#microsoft.graph.deviceManagementConfigurationStringSettingValue'
                                        }
                                        '@odata.type'      = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                    }
                                    SettingDefinitionId  = 'stringSettingDefinitionId'
                                }
                            }
                            @{
                                SettingInstance = @{
                                    AdditionalProperties = @{
                                        simpleSettingValue = @{
                                            valueState    = 'invalid'
                                            value         = 'fakeValue'
                                            '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSecretSettingValue'
                                        }
                                        '@odata.type'      = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                    }
                                    SettingDefinitionId  = 'secretSettingDefinitionId'
                                }
                            }
                            @{
                                SettingInstance = @{
                                    AdditionalProperties = @{
                                        simpleSettingValue = @{
                                            value         = 25
                                            '@odata.type' = '#microsoft.graph.deviceManagementConfigurationIntegerSettingValue'
                                        }
                                        '@odata.type'      = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                    }
                                    SettingDefinitionId  = 'integerSettingDefinitionId'
                                }
                            }
                            @{
                                SettingInstance = @{
                                    AdditionalProperties = @{
                                        choiceSettingValue = @{
                                            value    = 'choiceSettingValue'
                                            children = @()
                                        }
                                        '@odata.type'      = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                    }
                                    SettingDefinitionId  = 'choiceSettingDefinitionId'
                                }
                            }
                            @{
                                SettingInstance = @{
                                    SettingDefinitionId  = 'groupSettingDefinitionId'
                                    AdditionalProperties = @{
                                        '@odata.type'     = '#microsoft.graph.deviceManagementConfigurationGroupSettingInstance'
                                        groupSettingValue = @{
                                            '@odata.type'     = '#microsoft.graph.deviceManagementConfigurationGroupSettingValue'
                                            children = @(
                                                @{
                                                    simpleSettingValue  = @{
                                                        value         = 'fakeValueDrift' #Drift
                                                        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationStringSettingValue'
                                                    }
                                                    SettingDefinitionId = 'stringSettingDefinitionId'
                                                    '@odata.type'       = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                                }
                                                @{
                                                    simpleSettingValue  = @{
                                                        valueState    = 'invalid'
                                                        value         = 'fakeValue'
                                                        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSecretSettingValue'
                                                    }
                                                    SettingDefinitionId = 'secretSettingDefinitionId'
                                                    '@odata.type'       = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                                }
                                            )
                                        }
                                    }
                                }
                            }
                        )
                        Technologies = 'mdm'
                    }
                }

                Mock -CommandName Update-IntuneDeviceConfigurationPolicy -MockWith {
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

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicy -MockWith {
                    return @{
                        Description  = 'FakeStringValue'
                        Id           = 'FakeStringValue'
                        Name         = 'FakeStringValue'
                        Platforms    = 'windows10'
                        Settings     = @(
                            @{
                                SettingInstance = @{
                                    AdditionalProperties = @{
                                        simpleSettingValue = @{
                                            value         = 'fakeValue'
                                            '@odata.type' = '#microsoft.graph.deviceManagementConfigurationStringSettingValue'
                                        }
                                        '@odata.type'      = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                    }
                                    SettingDefinitionId  = 'stringSettingDefinitionId'
                                }
                            }
                            @{
                                SettingInstance = @{
                                    AdditionalProperties = @{
                                        simpleSettingValue = @{
                                            valueState    = 'invalid'
                                            value         = 'fakeValue'
                                            '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSecretSettingValue'
                                        }
                                        '@odata.type'      = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                    }
                                    SettingDefinitionId  = 'secretSettingDefinitionId'
                                }
                            }
                            @{
                                SettingInstance = @{
                                    AdditionalProperties = @{
                                        simpleSettingValue = @{
                                            value         = 25
                                            '@odata.type' = '#microsoft.graph.deviceManagementConfigurationIntegerSettingValue'
                                        }
                                        '@odata.type'      = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                    }
                                    SettingDefinitionId  = 'integerSettingDefinitionId'
                                }
                            }
                            @{
                                SettingInstance = @{
                                    AdditionalProperties = @{
                                        choiceSettingValue = @{
                                            value    = 'choiceSettingValue'
                                            children = @()
                                        }
                                        '@odata.type'      = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                    }
                                    SettingDefinitionId  = 'choiceSettingDefinitionId'
                                }
                            }
                            @{
                                SettingInstance = @{
                                    SettingDefinitionId  = 'groupSettingDefinitionId'
                                    AdditionalProperties = @{
                                        '@odata.type'     = '#microsoft.graph.deviceManagementConfigurationGroupSettingInstance'
                                        groupSettingValue = @{
                                            '@odata.type'     = '#microsoft.graph.deviceManagementConfigurationGroupSettingValue'
                                            children = @(
                                                @{
                                                    simpleSettingValue  = @{
                                                        value         = 'fakeValueDrift' #Drift
                                                        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationStringSettingValue'
                                                    }
                                                    SettingDefinitionId = 'stringSettingDefinitionId'
                                                    '@odata.type'       = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                                }
                                                @{
                                                    simpleSettingValue  = @{
                                                        valueState    = 'invalid'
                                                        value         = 'fakeValue'
                                                        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSecretSettingValue'
                                                    }
                                                    SettingDefinitionId = 'secretSettingDefinitionId'
                                                    '@odata.type'       = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                                }
                                            )
                                        }
                                    }
                                }
                            }
                        )
                        Technologies = 'mdm'
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
