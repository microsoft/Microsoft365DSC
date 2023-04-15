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
    -DscResource "IntuneSettingCatalogCustomPolicyWindows10" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString "f@kepassword1" -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-MgDeviceManagementConfigurationPolicy -MockWith {
            }

            Mock -CommandName New-MgDeviceManagementConfigurationPolicy -MockWith {
            }

            Mock -CommandName Remove-MgDeviceManagementConfigurationPolicy -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }

            Mock -CommandName Get-MgDeviceManagementConfigurationPolicyAssignment -MockWith {
            }

        }
        # Test contexts
        Context -Name "The IntuneSettingCatalogCustomPolicyWindows10 should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    CreationSource = "FakeStringValue"
                    Description = "FakeStringValue"
                    Id = "FakeStringValue"
                    IsAssigned = $True
                    Name = "FakeStringValue"
                    Platforms = "none"
                    PriorityMetaData = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementPriorityMetaData -Property @{
                        Priority = 25
                    } -ClientOnly)
                    SettingCount = 25
                    Settings = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSetting -Property @{
                            Id = "FakeStringValue"
                            SettingInstance = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                simpleSettingCollectionValue = [CimInstance[]]@(
                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                        valueState = "invalid"
                                        value = 25
                                        SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference"
                                            Name = "SettingValueTemplateReference"
                                            isArray = $False
                                        } -ClientOnly)
                                        children = [CimInstance[]]@(
                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance"
                                            Name = "Children"
                                            isArray = $True
                                            } -ClientOnly)
                                        )
                                        odataType = "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue"
                                    } -ClientOnly)
                                )
                                SettingDefinitionId = "FakeStringValue"
                                odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                choiceSettingCollectionValue = [CimInstance[]]@(
                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                        SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference"
                                            Name = "SettingValueTemplateReference"
                                            isArray = $False
                                        } -ClientOnly)
                                        odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                        value = "FakeStringValue"
                                        children = [CimInstance[]]@(
                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                                simpleSettingCollectionValue = [CimInstance[]]@(
                                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                    CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                    Name = "SimpleSettingCollectionValue"
                                                    isArray = $True
                                                    } -ClientOnly)
                                                )
                                                settingDefinitionId = "FakeStringValue"
                                                odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                choiceSettingCollectionValue = [CimInstance[]]@(
                                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                        SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                                            UseTemplateDefault = $True
                                                            SettingValueTemplateId = "FakeStringValue"
                                                        } -ClientOnly)
                                                        odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                                        value = "FakeStringValue"
                                                        children = [CimInstance[]]@(
                                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance"
                                                            Name = "Children"
                                                            isArray = $True
                                                            } -ClientOnly)
                                                        )
                                                    } -ClientOnly)
                                                )
                                                groupSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                    CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                    Name = "GroupSettingValue"
                                                    isArray = $False
                                                } -ClientOnly)
                                                SettingInstanceTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference -Property @{
                                                    SettingInstanceTemplateId = "FakeStringValue"
                                                } -ClientOnly)
                                                simpleSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                    CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                    Name = "SimpleSettingValue"
                                                    isArray = $False
                                                } -ClientOnly)
                                                choiceSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                    SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                                        UseTemplateDefault = $True
                                                        SettingValueTemplateId = "FakeStringValue"
                                                    } -ClientOnly)
                                                    odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                                    value = "FakeStringValue"
                                                    children = [CimInstance[]]@(
                                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                                            simpleSettingCollectionValue = [CimInstance[]]@(
                                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                                Name = "SimpleSettingCollectionValue"
                                                                isArray = $True
                                                                } -ClientOnly)
                                                            )
                                                            settingDefinitionId = "FakeStringValue"
                                                            odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                            choiceSettingCollectionValue = [CimInstance[]]@(
                                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                Name = "ChoiceSettingCollectionValue"
                                                                isArray = $True
                                                                } -ClientOnly)
                                                            )
                                                            groupSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                                Name = "GroupSettingValue"
                                                                isArray = $False
                                                            } -ClientOnly)
                                                            SettingInstanceTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference -Property @{
                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference"
                                                                Name = "SettingInstanceTemplateReference"
                                                                isArray = $False
                                                            } -ClientOnly)
                                                            simpleSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                                Name = "SimpleSettingValue"
                                                                isArray = $False
                                                            } -ClientOnly)
                                                            choiceSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                Name = "ChoiceSettingValue"
                                                                isArray = $False
                                                            } -ClientOnly)
                                                            groupSettingCollectionValue = [CimInstance[]]@(
                                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                    odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                                                    Value = "FakeStringValue"
                                                                    SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                                                        UseTemplateDefault = $True
                                                                        SettingValueTemplateId = "FakeStringValue"
                                                                    } -ClientOnly)
                                                                    children = [CimInstance[]]@(
                                                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                                                            simpleSettingCollectionValue = [CimInstance[]]@(
                                                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                                                Name = "SimpleSettingCollectionValue"
                                                                                isArray = $True
                                                                                } -ClientOnly)
                                                                            )
                                                                            settingDefinitionId = "FakeStringValue"
                                                                            odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                                            choiceSettingCollectionValue = [CimInstance[]]@(
                                                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                                Name = "ChoiceSettingCollectionValue"
                                                                                isArray = $True
                                                                                } -ClientOnly)
                                                                            )
                                                                            groupSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                                odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                                                                Value = "FakeStringValue"
                                                                                SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                                                                    UseTemplateDefault = $True
                                                                                    SettingValueTemplateId = "FakeStringValue"
                                                                                } -ClientOnly)
                                                                                children = [CimInstance[]]@(
                                                                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                                                                        simpleSettingCollectionValue = [CimInstance[]]@(
                                                                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                                                valueState = "invalid"
                                                                                                value = 25
                                                                                                SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                                                                                    UseTemplateDefault = $True
                                                                                                    SettingValueTemplateId = "FakeStringValue"
                                                                                                } -ClientOnly)
                                                                                                children = [CimInstance[]]@(
                                                                                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                                                                                        simpleSettingCollectionValue = [CimInstance[]]@(
                                                                                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                                                                            Name = "SimpleSettingCollectionValue"
                                                                                                            isArray = $True
                                                                                                            } -ClientOnly)
                                                                                                        )
                                                                                                        settingDefinitionId = "FakeStringValue"
                                                                                                        odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                                                                        choiceSettingCollectionValue = [CimInstance[]]@(
                                                                                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                                                            Name = "ChoiceSettingCollectionValue"
                                                                                                            isArray = $True
                                                                                                            } -ClientOnly)
                                                                                                        )
                                                                                                        groupSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                                                                            Name = "GroupSettingValue"
                                                                                                            isArray = $False
                                                                                                        } -ClientOnly)
                                                                                                        SettingInstanceTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference -Property @{
                                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference"
                                                                                                            Name = "SettingInstanceTemplateReference"
                                                                                                            isArray = $False
                                                                                                        } -ClientOnly)
                                                                                                        simpleSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                                                            valueState = "invalid"
                                                                                                            value = 25
                                                                                                            SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                                                                                                UseTemplateDefault = $True
                                                                                                                SettingValueTemplateId = "FakeStringValue"
                                                                                                            } -ClientOnly)
                                                                                                            children = [CimInstance[]]@(
                                                                                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                                                                                                    simpleSettingCollectionValue = [CimInstance[]]@(
                                                                                                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                                                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                                                                                        Name = "SimpleSettingCollectionValue"
                                                                                                                        isArray = $True
                                                                                                                        } -ClientOnly)
                                                                                                                    )
                                                                                                                    settingDefinitionId = "FakeStringValue"
                                                                                                                    odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                                                                                    choiceSettingCollectionValue = [CimInstance[]]@(
                                                                                                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                                                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                                                                        Name = "ChoiceSettingCollectionValue"
                                                                                                                        isArray = $True
                                                                                                                        } -ClientOnly)
                                                                                                                    )
                                                                                                                    groupSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                                                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                                                                                        Name = "GroupSettingValue"
                                                                                                                        isArray = $False
                                                                                                                    } -ClientOnly)
                                                                                                                    SettingInstanceTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference -Property @{
                                                                                                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference"
                                                                                                                        Name = "SettingInstanceTemplateReference"
                                                                                                                        isArray = $False
                                                                                                                    } -ClientOnly)
                                                                                                                    simpleSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                                                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                                                                                        Name = "SimpleSettingValue"
                                                                                                                        isArray = $False
                                                                                                                    } -ClientOnly)
                                                                                                                    choiceSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                                                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                                                                        Name = "ChoiceSettingValue"
                                                                                                                        isArray = $False
                                                                                                                    } -ClientOnly)
                                                                                                                    groupSettingCollectionValue = [CimInstance[]]@(
                                                                                                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                                                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                                                                                        Name = "GroupSettingCollectionValue"
                                                                                                                        isArray = $True
                                                                                                                        } -ClientOnly)
                                                                                                                    )
                                                                                                                } -ClientOnly)
                                                                                                            )
                                                                                                            odataType = "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue"
                                                                                                        } -ClientOnly)
                                                                                                        choiceSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                                                            Name = "ChoiceSettingValue"
                                                                                                            isArray = $False
                                                                                                        } -ClientOnly)
                                                                                                        groupSettingCollectionValue = [CimInstance[]]@(
                                                                                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                                                                            Name = "GroupSettingCollectionValue"
                                                                                                            isArray = $True
                                                                                                            } -ClientOnly)
                                                                                                        )
                                                                                                    } -ClientOnly)
                                                                                                )
                                                                                                odataType = "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue"
                                                                                            } -ClientOnly)
                                                                                        )
                                                                                        settingDefinitionId = "FakeStringValue"
                                                                                        odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                                                        choiceSettingCollectionValue = [CimInstance[]]@(
                                                                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                                            Name = "ChoiceSettingCollectionValue"
                                                                                            isArray = $True
                                                                                            } -ClientOnly)
                                                                                        )
                                                                                        groupSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                                                            Name = "GroupSettingValue"
                                                                                            isArray = $False
                                                                                        } -ClientOnly)
                                                                                        SettingInstanceTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference -Property @{
                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference"
                                                                                            Name = "SettingInstanceTemplateReference"
                                                                                            isArray = $False
                                                                                        } -ClientOnly)
                                                                                        simpleSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                                                            Name = "SimpleSettingValue"
                                                                                            isArray = $False
                                                                                        } -ClientOnly)
                                                                                        choiceSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                                            Name = "ChoiceSettingValue"
                                                                                            isArray = $False
                                                                                        } -ClientOnly)
                                                                                        groupSettingCollectionValue = [CimInstance[]]@(
                                                                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                                                            Name = "GroupSettingCollectionValue"
                                                                                            isArray = $True
                                                                                            } -ClientOnly)
                                                                                        )
                                                                                    } -ClientOnly)
                                                                                )
                                                                            } -ClientOnly)
                                                                            SettingInstanceTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference -Property @{
                                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference"
                                                                                Name = "SettingInstanceTemplateReference"
                                                                                isArray = $False
                                                                            } -ClientOnly)
                                                                            simpleSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                                                Name = "SimpleSettingValue"
                                                                                isArray = $False
                                                                            } -ClientOnly)
                                                                            choiceSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                                Name = "ChoiceSettingValue"
                                                                                isArray = $False
                                                                            } -ClientOnly)
                                                                            groupSettingCollectionValue = [CimInstance[]]@(
                                                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                                                Name = "GroupSettingCollectionValue"
                                                                                isArray = $True
                                                                                } -ClientOnly)
                                                                            )
                                                                        } -ClientOnly)
                                                                    )
                                                                } -ClientOnly)
                                                            )
                                                        } -ClientOnly)
                                                    )
                                                } -ClientOnly)
                                                groupSettingCollectionValue = [CimInstance[]]@(
                                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                    CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                    Name = "GroupSettingCollectionValue"
                                                    isArray = $True
                                                    } -ClientOnly)
                                                )
                                            } -ClientOnly)
                                        )
                                    } -ClientOnly)
                                )
                                groupSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                    odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                    Value = "FakeStringValue"
                                    SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference"
                                        Name = "SettingValueTemplateReference"
                                        isArray = $False
                                    } -ClientOnly)
                                    children = [CimInstance[]]@(
                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance"
                                        Name = "Children"
                                        isArray = $True
                                        } -ClientOnly)
                                    )
                                } -ClientOnly)
                                SettingInstanceTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference -Property @{
                                    SettingInstanceTemplateId = "FakeStringValue"
                                } -ClientOnly)
                                simpleSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                    valueState = "invalid"
                                    value = 25
                                    SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference"
                                        Name = "SettingValueTemplateReference"
                                        isArray = $False
                                    } -ClientOnly)
                                    children = [CimInstance[]]@(
                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance"
                                        Name = "Children"
                                        isArray = $True
                                        } -ClientOnly)
                                    )
                                    odataType = "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue"
                                } -ClientOnly)
                                choiceSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                    SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference"
                                        Name = "SettingValueTemplateReference"
                                        isArray = $False
                                    } -ClientOnly)
                                    odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                    value = "FakeStringValue"
                                    children = [CimInstance[]]@(
                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance"
                                        Name = "Children"
                                        isArray = $True
                                        } -ClientOnly)
                                    )
                                } -ClientOnly)
                                groupSettingCollectionValue = [CimInstance[]]@(
                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                        odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                        Value = "FakeStringValue"
                                        SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference"
                                            Name = "SettingValueTemplateReference"
                                            isArray = $False
                                        } -ClientOnly)
                                        children = [CimInstance[]]@(
                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance"
                                            Name = "Children"
                                            isArray = $True
                                            } -ClientOnly)
                                        )
                                    } -ClientOnly)
                                )
                            } -ClientOnly)
                        } -ClientOnly)
                    )
                    Technologies = "none"
                    TemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationPolicyTemplateReference -Property @{
                        TemplateId = "FakeStringValue"
                        TemplateDisplayVersion = "FakeStringValue"
                        TemplateDisplayName = "FakeStringValue"
                        TemplateFamily = "none"
                    } -ClientOnly)
                    Ensure = "Present"
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgDeviceManagementConfigurationPolicy -MockWith {
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
                Should -Invoke -CommandName New-MgDeviceManagementConfigurationPolicy -Exactly 1
            }
        }

        Context -Name "The IntuneSettingCatalogCustomPolicyWindows10 exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    CreationSource = "FakeStringValue"
                    Description = "FakeStringValue"
                    Id = "FakeStringValue"
                    IsAssigned = $True
                    Name = "FakeStringValue"
                    Platforms = "none"
                    PriorityMetaData = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementPriorityMetaData -Property @{
                        Priority = 25
                    } -ClientOnly)
                    SettingCount = 25
                    Settings = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSetting -Property @{
                            Id = "FakeStringValue"
                            SettingInstance = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                simpleSettingCollectionValue = [CimInstance[]]@(
                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                        valueState = "invalid"
                                        value = 25
                                        SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference"
                                            Name = "SettingValueTemplateReference"
                                            isArray = $False
                                        } -ClientOnly)
                                        children = [CimInstance[]]@(
                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance"
                                            Name = "Children"
                                            isArray = $True
                                            } -ClientOnly)
                                        )
                                        odataType = "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue"
                                    } -ClientOnly)
                                )
                                SettingDefinitionId = "FakeStringValue"
                                odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                choiceSettingCollectionValue = [CimInstance[]]@(
                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                        SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference"
                                            Name = "SettingValueTemplateReference"
                                            isArray = $False
                                        } -ClientOnly)
                                        odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                        value = "FakeStringValue"
                                        children = [CimInstance[]]@(
                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                                simpleSettingCollectionValue = [CimInstance[]]@(
                                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                    CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                    Name = "SimpleSettingCollectionValue"
                                                    isArray = $True
                                                    } -ClientOnly)
                                                )
                                                settingDefinitionId = "FakeStringValue"
                                                odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                choiceSettingCollectionValue = [CimInstance[]]@(
                                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                        SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                                            UseTemplateDefault = $True
                                                            SettingValueTemplateId = "FakeStringValue"
                                                        } -ClientOnly)
                                                        odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                                        value = "FakeStringValue"
                                                        children = [CimInstance[]]@(
                                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance"
                                                            Name = "Children"
                                                            isArray = $True
                                                            } -ClientOnly)
                                                        )
                                                    } -ClientOnly)
                                                )
                                                groupSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                    CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                    Name = "GroupSettingValue"
                                                    isArray = $False
                                                } -ClientOnly)
                                                SettingInstanceTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference -Property @{
                                                    SettingInstanceTemplateId = "FakeStringValue"
                                                } -ClientOnly)
                                                simpleSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                    CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                    Name = "SimpleSettingValue"
                                                    isArray = $False
                                                } -ClientOnly)
                                                choiceSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                    SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                                        UseTemplateDefault = $True
                                                        SettingValueTemplateId = "FakeStringValue"
                                                    } -ClientOnly)
                                                    odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                                    value = "FakeStringValue"
                                                    children = [CimInstance[]]@(
                                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                                            simpleSettingCollectionValue = [CimInstance[]]@(
                                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                                Name = "SimpleSettingCollectionValue"
                                                                isArray = $True
                                                                } -ClientOnly)
                                                            )
                                                            settingDefinitionId = "FakeStringValue"
                                                            odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                            choiceSettingCollectionValue = [CimInstance[]]@(
                                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                Name = "ChoiceSettingCollectionValue"
                                                                isArray = $True
                                                                } -ClientOnly)
                                                            )
                                                            groupSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                                Name = "GroupSettingValue"
                                                                isArray = $False
                                                            } -ClientOnly)
                                                            SettingInstanceTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference -Property @{
                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference"
                                                                Name = "SettingInstanceTemplateReference"
                                                                isArray = $False
                                                            } -ClientOnly)
                                                            simpleSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                                Name = "SimpleSettingValue"
                                                                isArray = $False
                                                            } -ClientOnly)
                                                            choiceSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                Name = "ChoiceSettingValue"
                                                                isArray = $False
                                                            } -ClientOnly)
                                                            groupSettingCollectionValue = [CimInstance[]]@(
                                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                    odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                                                    Value = "FakeStringValue"
                                                                    SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                                                        UseTemplateDefault = $True
                                                                        SettingValueTemplateId = "FakeStringValue"
                                                                    } -ClientOnly)
                                                                    children = [CimInstance[]]@(
                                                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                                                            simpleSettingCollectionValue = [CimInstance[]]@(
                                                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                                                Name = "SimpleSettingCollectionValue"
                                                                                isArray = $True
                                                                                } -ClientOnly)
                                                                            )
                                                                            settingDefinitionId = "FakeStringValue"
                                                                            odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                                            choiceSettingCollectionValue = [CimInstance[]]@(
                                                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                                Name = "ChoiceSettingCollectionValue"
                                                                                isArray = $True
                                                                                } -ClientOnly)
                                                                            )
                                                                            groupSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                                odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                                                                Value = "FakeStringValue"
                                                                                SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                                                                    UseTemplateDefault = $True
                                                                                    SettingValueTemplateId = "FakeStringValue"
                                                                                } -ClientOnly)
                                                                                children = [CimInstance[]]@(
                                                                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                                                                        simpleSettingCollectionValue = [CimInstance[]]@(
                                                                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                                                valueState = "invalid"
                                                                                                value = 25
                                                                                                SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                                                                                    UseTemplateDefault = $True
                                                                                                    SettingValueTemplateId = "FakeStringValue"
                                                                                                } -ClientOnly)
                                                                                                children = [CimInstance[]]@(
                                                                                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                                                                                        simpleSettingCollectionValue = [CimInstance[]]@(
                                                                                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                                                                            Name = "SimpleSettingCollectionValue"
                                                                                                            isArray = $True
                                                                                                            } -ClientOnly)
                                                                                                        )
                                                                                                        settingDefinitionId = "FakeStringValue"
                                                                                                        odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                                                                        choiceSettingCollectionValue = [CimInstance[]]@(
                                                                                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                                                            Name = "ChoiceSettingCollectionValue"
                                                                                                            isArray = $True
                                                                                                            } -ClientOnly)
                                                                                                        )
                                                                                                        groupSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                                                                            Name = "GroupSettingValue"
                                                                                                            isArray = $False
                                                                                                        } -ClientOnly)
                                                                                                        SettingInstanceTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference -Property @{
                                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference"
                                                                                                            Name = "SettingInstanceTemplateReference"
                                                                                                            isArray = $False
                                                                                                        } -ClientOnly)
                                                                                                        simpleSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                                                            valueState = "invalid"
                                                                                                            value = 25
                                                                                                            SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                                                                                                UseTemplateDefault = $True
                                                                                                                SettingValueTemplateId = "FakeStringValue"
                                                                                                            } -ClientOnly)
                                                                                                            children = [CimInstance[]]@(
                                                                                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                                                                                                    simpleSettingCollectionValue = [CimInstance[]]@(
                                                                                                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                                                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                                                                                        Name = "SimpleSettingCollectionValue"
                                                                                                                        isArray = $True
                                                                                                                        } -ClientOnly)
                                                                                                                    )
                                                                                                                    settingDefinitionId = "FakeStringValue"
                                                                                                                    odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                                                                                    choiceSettingCollectionValue = [CimInstance[]]@(
                                                                                                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                                                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                                                                        Name = "ChoiceSettingCollectionValue"
                                                                                                                        isArray = $True
                                                                                                                        } -ClientOnly)
                                                                                                                    )
                                                                                                                    groupSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                                                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                                                                                        Name = "GroupSettingValue"
                                                                                                                        isArray = $False
                                                                                                                    } -ClientOnly)
                                                                                                                    SettingInstanceTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference -Property @{
                                                                                                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference"
                                                                                                                        Name = "SettingInstanceTemplateReference"
                                                                                                                        isArray = $False
                                                                                                                    } -ClientOnly)
                                                                                                                    simpleSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                                                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                                                                                        Name = "SimpleSettingValue"
                                                                                                                        isArray = $False
                                                                                                                    } -ClientOnly)
                                                                                                                    choiceSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                                                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                                                                        Name = "ChoiceSettingValue"
                                                                                                                        isArray = $False
                                                                                                                    } -ClientOnly)
                                                                                                                    groupSettingCollectionValue = [CimInstance[]]@(
                                                                                                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                                                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                                                                                        Name = "GroupSettingCollectionValue"
                                                                                                                        isArray = $True
                                                                                                                        } -ClientOnly)
                                                                                                                    )
                                                                                                                } -ClientOnly)
                                                                                                            )
                                                                                                            odataType = "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue"
                                                                                                        } -ClientOnly)
                                                                                                        choiceSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                                                            Name = "ChoiceSettingValue"
                                                                                                            isArray = $False
                                                                                                        } -ClientOnly)
                                                                                                        groupSettingCollectionValue = [CimInstance[]]@(
                                                                                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                                                                            Name = "GroupSettingCollectionValue"
                                                                                                            isArray = $True
                                                                                                            } -ClientOnly)
                                                                                                        )
                                                                                                    } -ClientOnly)
                                                                                                )
                                                                                                odataType = "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue"
                                                                                            } -ClientOnly)
                                                                                        )
                                                                                        settingDefinitionId = "FakeStringValue"
                                                                                        odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                                                        choiceSettingCollectionValue = [CimInstance[]]@(
                                                                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                                            Name = "ChoiceSettingCollectionValue"
                                                                                            isArray = $True
                                                                                            } -ClientOnly)
                                                                                        )
                                                                                        groupSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                                                            Name = "GroupSettingValue"
                                                                                            isArray = $False
                                                                                        } -ClientOnly)
                                                                                        SettingInstanceTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference -Property @{
                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference"
                                                                                            Name = "SettingInstanceTemplateReference"
                                                                                            isArray = $False
                                                                                        } -ClientOnly)
                                                                                        simpleSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                                                            Name = "SimpleSettingValue"
                                                                                            isArray = $False
                                                                                        } -ClientOnly)
                                                                                        choiceSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                                            Name = "ChoiceSettingValue"
                                                                                            isArray = $False
                                                                                        } -ClientOnly)
                                                                                        groupSettingCollectionValue = [CimInstance[]]@(
                                                                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                                                            Name = "GroupSettingCollectionValue"
                                                                                            isArray = $True
                                                                                            } -ClientOnly)
                                                                                        )
                                                                                    } -ClientOnly)
                                                                                )
                                                                            } -ClientOnly)
                                                                            SettingInstanceTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference -Property @{
                                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference"
                                                                                Name = "SettingInstanceTemplateReference"
                                                                                isArray = $False
                                                                            } -ClientOnly)
                                                                            simpleSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                                                Name = "SimpleSettingValue"
                                                                                isArray = $False
                                                                            } -ClientOnly)
                                                                            choiceSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                                Name = "ChoiceSettingValue"
                                                                                isArray = $False
                                                                            } -ClientOnly)
                                                                            groupSettingCollectionValue = [CimInstance[]]@(
                                                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                                                Name = "GroupSettingCollectionValue"
                                                                                isArray = $True
                                                                                } -ClientOnly)
                                                                            )
                                                                        } -ClientOnly)
                                                                    )
                                                                } -ClientOnly)
                                                            )
                                                        } -ClientOnly)
                                                    )
                                                } -ClientOnly)
                                                groupSettingCollectionValue = [CimInstance[]]@(
                                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                    CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                    Name = "GroupSettingCollectionValue"
                                                    isArray = $True
                                                    } -ClientOnly)
                                                )
                                            } -ClientOnly)
                                        )
                                    } -ClientOnly)
                                )
                                groupSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                    odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                    Value = "FakeStringValue"
                                    SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference"
                                        Name = "SettingValueTemplateReference"
                                        isArray = $False
                                    } -ClientOnly)
                                    children = [CimInstance[]]@(
                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance"
                                        Name = "Children"
                                        isArray = $True
                                        } -ClientOnly)
                                    )
                                } -ClientOnly)
                                SettingInstanceTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference -Property @{
                                    SettingInstanceTemplateId = "FakeStringValue"
                                } -ClientOnly)
                                simpleSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                    valueState = "invalid"
                                    value = 25
                                    SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference"
                                        Name = "SettingValueTemplateReference"
                                        isArray = $False
                                    } -ClientOnly)
                                    children = [CimInstance[]]@(
                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance"
                                        Name = "Children"
                                        isArray = $True
                                        } -ClientOnly)
                                    )
                                    odataType = "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue"
                                } -ClientOnly)
                                choiceSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                    SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference"
                                        Name = "SettingValueTemplateReference"
                                        isArray = $False
                                    } -ClientOnly)
                                    odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                    value = "FakeStringValue"
                                    children = [CimInstance[]]@(
                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance"
                                        Name = "Children"
                                        isArray = $True
                                        } -ClientOnly)
                                    )
                                } -ClientOnly)
                                groupSettingCollectionValue = [CimInstance[]]@(
                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                        odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                        Value = "FakeStringValue"
                                        SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference"
                                            Name = "SettingValueTemplateReference"
                                            isArray = $False
                                        } -ClientOnly)
                                        children = [CimInstance[]]@(
                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance"
                                            Name = "Children"
                                            isArray = $True
                                            } -ClientOnly)
                                        )
                                    } -ClientOnly)
                                )
                            } -ClientOnly)
                        } -ClientOnly)
                    )
                    Technologies = "none"
                    TemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationPolicyTemplateReference -Property @{
                        TemplateId = "FakeStringValue"
                        TemplateDisplayVersion = "FakeStringValue"
                        TemplateDisplayName = "FakeStringValue"
                        TemplateFamily = "none"
                    } -ClientOnly)
                    Ensure = 'Absent'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgDeviceManagementConfigurationPolicy -MockWith {
                    return @{
                        AdditionalProperties = @{
                            '@odata.type' = "#microsoft.graph.DeviceManagementConfigurationPolicy"
                        }
                        CreationSource = "FakeStringValue"
                        Description = "FakeStringValue"
                        Id = "FakeStringValue"
                        IsAssigned = $True
                        Name = "FakeStringValue"
                        Platforms = "none"
                        PriorityMetaData = @{
                            Priority = 25
                        }
                        SettingCount = 25
                        Settings = @(
                            @{
                                Id = "FakeStringValue"
                                SettingInstance = @{
                                    simpleSettingCollectionValue = @(
                                        @{
                                            '@odata.type' = "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue"
                                            valueState = "invalid"
                                            value = 25
                                            SettingValueTemplateReference = @{
                                                isArray = $False
                                                Name = "SettingValueTemplateReference"
                                            }
                                            children = @(
                                                @{
                                                isArray = $True
                                                Name = "Children"
                                                }
                                            )
                                        }
                                    )
                                    SettingDefinitionId = "FakeStringValue"
                                    '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                    choiceSettingCollectionValue = @(
                                        @{
                                            SettingValueTemplateReference = @{
                                                isArray = $False
                                                Name = "SettingValueTemplateReference"
                                            }
                                            '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                            value = "FakeStringValue"
                                            children = @(
                                                @{
                                                    simpleSettingCollectionValue = @(
                                                        @{
                                                        isArray = $True
                                                        Name = "SimpleSettingCollectionValue"
                                                        }
                                                    )
                                                    settingDefinitionId = "FakeStringValue"
                                                    '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                    choiceSettingCollectionValue = @(
                                                        @{
                                                            SettingValueTemplateReference = @{
                                                                UseTemplateDefault = $True
                                                                SettingValueTemplateId = "FakeStringValue"
                                                            }
                                                            '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                                            value = "FakeStringValue"
                                                            children = @(
                                                                @{
                                                                isArray = $True
                                                                Name = "Children"
                                                                }
                                                            )
                                                        }
                                                    )
                                                    groupSettingValue = @{
                                                        isArray = $False
                                                        Name = "GroupSettingValue"
                                                    }
                                                    SettingInstanceTemplateReference = @{
                                                        SettingInstanceTemplateId = "FakeStringValue"
                                                    }
                                                    simpleSettingValue = @{
                                                        isArray = $False
                                                        Name = "SimpleSettingValue"
                                                    }
                                                    choiceSettingValue = @{
                                                        SettingValueTemplateReference = @{
                                                            UseTemplateDefault = $True
                                                            SettingValueTemplateId = "FakeStringValue"
                                                        }
                                                        '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                                        value = "FakeStringValue"
                                                        children = @(
                                                            @{
                                                                simpleSettingCollectionValue = @(
                                                                    @{
                                                                    isArray = $True
                                                                    Name = "SimpleSettingCollectionValue"
                                                                    }
                                                                )
                                                                settingDefinitionId = "FakeStringValue"
                                                                '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                                choiceSettingCollectionValue = @(
                                                                    @{
                                                                    isArray = $True
                                                                    Name = "ChoiceSettingCollectionValue"
                                                                    }
                                                                )
                                                                groupSettingValue = @{
                                                                    isArray = $False
                                                                    Name = "GroupSettingValue"
                                                                }
                                                                SettingInstanceTemplateReference = @{
                                                                    isArray = $False
                                                                    Name = "SettingInstanceTemplateReference"
                                                                }
                                                                simpleSettingValue = @{
                                                                    isArray = $False
                                                                    Name = "SimpleSettingValue"
                                                                }
                                                                choiceSettingValue = @{
                                                                    isArray = $False
                                                                    Name = "ChoiceSettingValue"
                                                                }
                                                                groupSettingCollectionValue = @(
                                                                    @{
                                                                        '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                                                        Value = "FakeStringValue"
                                                                        SettingValueTemplateReference = @{
                                                                            UseTemplateDefault = $True
                                                                            SettingValueTemplateId = "FakeStringValue"
                                                                        }
                                                                        children = @(
                                                                            @{
                                                                                simpleSettingCollectionValue = @(
                                                                                    @{
                                                                                    isArray = $True
                                                                                    Name = "SimpleSettingCollectionValue"
                                                                                    }
                                                                                )
                                                                                settingDefinitionId = "FakeStringValue"
                                                                                '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                                                choiceSettingCollectionValue = @(
                                                                                    @{
                                                                                    isArray = $True
                                                                                    Name = "ChoiceSettingCollectionValue"
                                                                                    }
                                                                                )
                                                                                groupSettingValue = @{
                                                                                    '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                                                                    Value = "FakeStringValue"
                                                                                    SettingValueTemplateReference = @{
                                                                                        UseTemplateDefault = $True
                                                                                        SettingValueTemplateId = "FakeStringValue"
                                                                                    }
                                                                                    children = @(
                                                                                        @{
                                                                                            simpleSettingCollectionValue = @(
                                                                                                @{
                                                                                                    '@odata.type' = "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue"
                                                                                                    valueState = "invalid"
                                                                                                    value = 25
                                                                                                    SettingValueTemplateReference = @{
                                                                                                        UseTemplateDefault = $True
                                                                                                        SettingValueTemplateId = "FakeStringValue"
                                                                                                    }
                                                                                                    children = @(
                                                                                                        @{
                                                                                                            simpleSettingCollectionValue = @(
                                                                                                                @{
                                                                                                                isArray = $True
                                                                                                                Name = "SimpleSettingCollectionValue"
                                                                                                                }
                                                                                                            )
                                                                                                            settingDefinitionId = "FakeStringValue"
                                                                                                            '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                                                                            choiceSettingCollectionValue = @(
                                                                                                                @{
                                                                                                                isArray = $True
                                                                                                                Name = "ChoiceSettingCollectionValue"
                                                                                                                }
                                                                                                            )
                                                                                                            groupSettingValue = @{
                                                                                                                isArray = $False
                                                                                                                Name = "GroupSettingValue"
                                                                                                            }
                                                                                                            SettingInstanceTemplateReference = @{
                                                                                                                isArray = $False
                                                                                                                Name = "SettingInstanceTemplateReference"
                                                                                                            }
                                                                                                            simpleSettingValue = @{
                                                                                                                '@odata.type' = "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue"
                                                                                                                valueState = "invalid"
                                                                                                                value = 25
                                                                                                                SettingValueTemplateReference = @{
                                                                                                                    UseTemplateDefault = $True
                                                                                                                    SettingValueTemplateId = "FakeStringValue"
                                                                                                                }
                                                                                                                children = @(
                                                                                                                    @{
                                                                                                                        simpleSettingCollectionValue = @(
                                                                                                                            @{
                                                                                                                            isArray = $True
                                                                                                                            Name = "SimpleSettingCollectionValue"
                                                                                                                            }
                                                                                                                        )
                                                                                                                        settingDefinitionId = "FakeStringValue"
                                                                                                                        '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                                                                                        choiceSettingCollectionValue = @(
                                                                                                                            @{
                                                                                                                            isArray = $True
                                                                                                                            Name = "ChoiceSettingCollectionValue"
                                                                                                                            }
                                                                                                                        )
                                                                                                                        groupSettingValue = @{
                                                                                                                            isArray = $False
                                                                                                                            Name = "GroupSettingValue"
                                                                                                                        }
                                                                                                                        SettingInstanceTemplateReference = @{
                                                                                                                            isArray = $False
                                                                                                                            Name = "SettingInstanceTemplateReference"
                                                                                                                        }
                                                                                                                        simpleSettingValue = @{
                                                                                                                            isArray = $False
                                                                                                                            Name = "SimpleSettingValue"
                                                                                                                        }
                                                                                                                        choiceSettingValue = @{
                                                                                                                            isArray = $False
                                                                                                                            Name = "ChoiceSettingValue"
                                                                                                                        }
                                                                                                                        groupSettingCollectionValue = @(
                                                                                                                            @{
                                                                                                                            isArray = $True
                                                                                                                            Name = "GroupSettingCollectionValue"
                                                                                                                            }
                                                                                                                        )
                                                                                                                    }
                                                                                                                )
                                                                                                            }
                                                                                                            choiceSettingValue = @{
                                                                                                                isArray = $False
                                                                                                                Name = "ChoiceSettingValue"
                                                                                                            }
                                                                                                            groupSettingCollectionValue = @(
                                                                                                                @{
                                                                                                                isArray = $True
                                                                                                                Name = "GroupSettingCollectionValue"
                                                                                                                }
                                                                                                            )
                                                                                                        }
                                                                                                    )
                                                                                                }
                                                                                            )
                                                                                            settingDefinitionId = "FakeStringValue"
                                                                                            '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                                                            choiceSettingCollectionValue = @(
                                                                                                @{
                                                                                                isArray = $True
                                                                                                Name = "ChoiceSettingCollectionValue"
                                                                                                }
                                                                                            )
                                                                                            groupSettingValue = @{
                                                                                                isArray = $False
                                                                                                Name = "GroupSettingValue"
                                                                                            }
                                                                                            SettingInstanceTemplateReference = @{
                                                                                                isArray = $False
                                                                                                Name = "SettingInstanceTemplateReference"
                                                                                            }
                                                                                            simpleSettingValue = @{
                                                                                                isArray = $False
                                                                                                Name = "SimpleSettingValue"
                                                                                            }
                                                                                            choiceSettingValue = @{
                                                                                                isArray = $False
                                                                                                Name = "ChoiceSettingValue"
                                                                                            }
                                                                                            groupSettingCollectionValue = @(
                                                                                                @{
                                                                                                isArray = $True
                                                                                                Name = "GroupSettingCollectionValue"
                                                                                                }
                                                                                            )
                                                                                        }
                                                                                    )
                                                                                }
                                                                                SettingInstanceTemplateReference = @{
                                                                                    isArray = $False
                                                                                    Name = "SettingInstanceTemplateReference"
                                                                                }
                                                                                simpleSettingValue = @{
                                                                                    isArray = $False
                                                                                    Name = "SimpleSettingValue"
                                                                                }
                                                                                choiceSettingValue = @{
                                                                                    isArray = $False
                                                                                    Name = "ChoiceSettingValue"
                                                                                }
                                                                                groupSettingCollectionValue = @(
                                                                                    @{
                                                                                    isArray = $True
                                                                                    Name = "GroupSettingCollectionValue"
                                                                                    }
                                                                                )
                                                                            }
                                                                        )
                                                                    }
                                                                )
                                                            }
                                                        )
                                                    }
                                                    groupSettingCollectionValue = @(
                                                        @{
                                                        isArray = $True
                                                        Name = "GroupSettingCollectionValue"
                                                        }
                                                    )
                                                }
                                            )
                                        }
                                    )
                                    groupSettingValue = @{
                                        '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                        Value = "FakeStringValue"
                                        SettingValueTemplateReference = @{
                                            isArray = $False
                                            Name = "SettingValueTemplateReference"
                                        }
                                        children = @(
                                            @{
                                            isArray = $True
                                            Name = "Children"
                                            }
                                        )
                                    }
                                    SettingInstanceTemplateReference = @{
                                        SettingInstanceTemplateId = "FakeStringValue"
                                    }
                                    simpleSettingValue = @{
                                        '@odata.type' = "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue"
                                        valueState = "invalid"
                                        value = 25
                                        SettingValueTemplateReference = @{
                                            isArray = $False
                                            Name = "SettingValueTemplateReference"
                                        }
                                        children = @(
                                            @{
                                            isArray = $True
                                            Name = "Children"
                                            }
                                        )
                                    }
                                    choiceSettingValue = @{
                                        SettingValueTemplateReference = @{
                                            isArray = $False
                                            Name = "SettingValueTemplateReference"
                                        }
                                        '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                        value = "FakeStringValue"
                                        children = @(
                                            @{
                                            isArray = $True
                                            Name = "Children"
                                            }
                                        )
                                    }
                                    groupSettingCollectionValue = @(
                                        @{
                                            '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                            Value = "FakeStringValue"
                                            SettingValueTemplateReference = @{
                                                isArray = $False
                                                Name = "SettingValueTemplateReference"
                                            }
                                            children = @(
                                                @{
                                                isArray = $True
                                                Name = "Children"
                                                }
                                            )
                                        }
                                    )
                                }
                            }
                        )
                        Technologies = "none"
                        TemplateReference = @{
                            TemplateId = "FakeStringValue"
                            TemplateDisplayVersion = "FakeStringValue"
                            TemplateDisplayName = "FakeStringValue"
                            TemplateFamily = "none"
                        }

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
                Should -Invoke -CommandName Remove-MgDeviceManagementConfigurationPolicy -Exactly 1
            }
        }
        Context -Name "The IntuneSettingCatalogCustomPolicyWindows10 Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    CreationSource = "FakeStringValue"
                    Description = "FakeStringValue"
                    Id = "FakeStringValue"
                    IsAssigned = $True
                    Name = "FakeStringValue"
                    Platforms = "none"
                    PriorityMetaData = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementPriorityMetaData -Property @{
                        Priority = 25
                    } -ClientOnly)
                    SettingCount = 25
                    Settings = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSetting -Property @{
                            Id = "FakeStringValue"
                            SettingInstance = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                simpleSettingCollectionValue = [CimInstance[]]@(
                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                        valueState = "invalid"
                                        value = 25
                                        SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference"
                                            Name = "SettingValueTemplateReference"
                                            isArray = $False
                                        } -ClientOnly)
                                        children = [CimInstance[]]@(
                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance"
                                            Name = "Children"
                                            isArray = $True
                                            } -ClientOnly)
                                        )
                                        odataType = "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue"
                                    } -ClientOnly)
                                )
                                SettingDefinitionId = "FakeStringValue"
                                odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                choiceSettingCollectionValue = [CimInstance[]]@(
                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                        SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference"
                                            Name = "SettingValueTemplateReference"
                                            isArray = $False
                                        } -ClientOnly)
                                        odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                        value = "FakeStringValue"
                                        children = [CimInstance[]]@(
                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                                simpleSettingCollectionValue = [CimInstance[]]@(
                                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                    CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                    Name = "SimpleSettingCollectionValue"
                                                    isArray = $True
                                                    } -ClientOnly)
                                                )
                                                settingDefinitionId = "FakeStringValue"
                                                odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                choiceSettingCollectionValue = [CimInstance[]]@(
                                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                        SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                                            UseTemplateDefault = $True
                                                            SettingValueTemplateId = "FakeStringValue"
                                                        } -ClientOnly)
                                                        odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                                        value = "FakeStringValue"
                                                        children = [CimInstance[]]@(
                                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance"
                                                            Name = "Children"
                                                            isArray = $True
                                                            } -ClientOnly)
                                                        )
                                                    } -ClientOnly)
                                                )
                                                groupSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                    CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                    Name = "GroupSettingValue"
                                                    isArray = $False
                                                } -ClientOnly)
                                                SettingInstanceTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference -Property @{
                                                    SettingInstanceTemplateId = "FakeStringValue"
                                                } -ClientOnly)
                                                simpleSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                    CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                    Name = "SimpleSettingValue"
                                                    isArray = $False
                                                } -ClientOnly)
                                                choiceSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                    SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                                        UseTemplateDefault = $True
                                                        SettingValueTemplateId = "FakeStringValue"
                                                    } -ClientOnly)
                                                    odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                                    value = "FakeStringValue"
                                                    children = [CimInstance[]]@(
                                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                                            simpleSettingCollectionValue = [CimInstance[]]@(
                                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                                Name = "SimpleSettingCollectionValue"
                                                                isArray = $True
                                                                } -ClientOnly)
                                                            )
                                                            settingDefinitionId = "FakeStringValue"
                                                            odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                            choiceSettingCollectionValue = [CimInstance[]]@(
                                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                Name = "ChoiceSettingCollectionValue"
                                                                isArray = $True
                                                                } -ClientOnly)
                                                            )
                                                            groupSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                                Name = "GroupSettingValue"
                                                                isArray = $False
                                                            } -ClientOnly)
                                                            SettingInstanceTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference -Property @{
                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference"
                                                                Name = "SettingInstanceTemplateReference"
                                                                isArray = $False
                                                            } -ClientOnly)
                                                            simpleSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                                Name = "SimpleSettingValue"
                                                                isArray = $False
                                                            } -ClientOnly)
                                                            choiceSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                Name = "ChoiceSettingValue"
                                                                isArray = $False
                                                            } -ClientOnly)
                                                            groupSettingCollectionValue = [CimInstance[]]@(
                                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                    odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                                                    Value = "FakeStringValue"
                                                                    SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                                                        UseTemplateDefault = $True
                                                                        SettingValueTemplateId = "FakeStringValue"
                                                                    } -ClientOnly)
                                                                    children = [CimInstance[]]@(
                                                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                                                            simpleSettingCollectionValue = [CimInstance[]]@(
                                                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                                                Name = "SimpleSettingCollectionValue"
                                                                                isArray = $True
                                                                                } -ClientOnly)
                                                                            )
                                                                            settingDefinitionId = "FakeStringValue"
                                                                            odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                                            choiceSettingCollectionValue = [CimInstance[]]@(
                                                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                                Name = "ChoiceSettingCollectionValue"
                                                                                isArray = $True
                                                                                } -ClientOnly)
                                                                            )
                                                                            groupSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                                odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                                                                Value = "FakeStringValue"
                                                                                SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                                                                    UseTemplateDefault = $True
                                                                                    SettingValueTemplateId = "FakeStringValue"
                                                                                } -ClientOnly)
                                                                                children = [CimInstance[]]@(
                                                                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                                                                        simpleSettingCollectionValue = [CimInstance[]]@(
                                                                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                                                valueState = "invalid"
                                                                                                value = 25
                                                                                                SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                                                                                    UseTemplateDefault = $True
                                                                                                    SettingValueTemplateId = "FakeStringValue"
                                                                                                } -ClientOnly)
                                                                                                children = [CimInstance[]]@(
                                                                                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                                                                                        simpleSettingCollectionValue = [CimInstance[]]@(
                                                                                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                                                                            Name = "SimpleSettingCollectionValue"
                                                                                                            isArray = $True
                                                                                                            } -ClientOnly)
                                                                                                        )
                                                                                                        settingDefinitionId = "FakeStringValue"
                                                                                                        odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                                                                        choiceSettingCollectionValue = [CimInstance[]]@(
                                                                                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                                                            Name = "ChoiceSettingCollectionValue"
                                                                                                            isArray = $True
                                                                                                            } -ClientOnly)
                                                                                                        )
                                                                                                        groupSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                                                                            Name = "GroupSettingValue"
                                                                                                            isArray = $False
                                                                                                        } -ClientOnly)
                                                                                                        SettingInstanceTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference -Property @{
                                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference"
                                                                                                            Name = "SettingInstanceTemplateReference"
                                                                                                            isArray = $False
                                                                                                        } -ClientOnly)
                                                                                                        simpleSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                                                            valueState = "invalid"
                                                                                                            value = 25
                                                                                                            SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                                                                                                UseTemplateDefault = $True
                                                                                                                SettingValueTemplateId = "FakeStringValue"
                                                                                                            } -ClientOnly)
                                                                                                            children = [CimInstance[]]@(
                                                                                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                                                                                                    simpleSettingCollectionValue = [CimInstance[]]@(
                                                                                                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                                                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                                                                                        Name = "SimpleSettingCollectionValue"
                                                                                                                        isArray = $True
                                                                                                                        } -ClientOnly)
                                                                                                                    )
                                                                                                                    settingDefinitionId = "FakeStringValue"
                                                                                                                    odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                                                                                    choiceSettingCollectionValue = [CimInstance[]]@(
                                                                                                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                                                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                                                                        Name = "ChoiceSettingCollectionValue"
                                                                                                                        isArray = $True
                                                                                                                        } -ClientOnly)
                                                                                                                    )
                                                                                                                    groupSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                                                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                                                                                        Name = "GroupSettingValue"
                                                                                                                        isArray = $False
                                                                                                                    } -ClientOnly)
                                                                                                                    SettingInstanceTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference -Property @{
                                                                                                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference"
                                                                                                                        Name = "SettingInstanceTemplateReference"
                                                                                                                        isArray = $False
                                                                                                                    } -ClientOnly)
                                                                                                                    simpleSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                                                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                                                                                        Name = "SimpleSettingValue"
                                                                                                                        isArray = $False
                                                                                                                    } -ClientOnly)
                                                                                                                    choiceSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                                                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                                                                        Name = "ChoiceSettingValue"
                                                                                                                        isArray = $False
                                                                                                                    } -ClientOnly)
                                                                                                                    groupSettingCollectionValue = [CimInstance[]]@(
                                                                                                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                                                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                                                                                        Name = "GroupSettingCollectionValue"
                                                                                                                        isArray = $True
                                                                                                                        } -ClientOnly)
                                                                                                                    )
                                                                                                                } -ClientOnly)
                                                                                                            )
                                                                                                            odataType = "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue"
                                                                                                        } -ClientOnly)
                                                                                                        choiceSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                                                            Name = "ChoiceSettingValue"
                                                                                                            isArray = $False
                                                                                                        } -ClientOnly)
                                                                                                        groupSettingCollectionValue = [CimInstance[]]@(
                                                                                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                                                                            Name = "GroupSettingCollectionValue"
                                                                                                            isArray = $True
                                                                                                            } -ClientOnly)
                                                                                                        )
                                                                                                    } -ClientOnly)
                                                                                                )
                                                                                                odataType = "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue"
                                                                                            } -ClientOnly)
                                                                                        )
                                                                                        settingDefinitionId = "FakeStringValue"
                                                                                        odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                                                        choiceSettingCollectionValue = [CimInstance[]]@(
                                                                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                                            Name = "ChoiceSettingCollectionValue"
                                                                                            isArray = $True
                                                                                            } -ClientOnly)
                                                                                        )
                                                                                        groupSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                                                            Name = "GroupSettingValue"
                                                                                            isArray = $False
                                                                                        } -ClientOnly)
                                                                                        SettingInstanceTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference -Property @{
                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference"
                                                                                            Name = "SettingInstanceTemplateReference"
                                                                                            isArray = $False
                                                                                        } -ClientOnly)
                                                                                        simpleSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                                                            Name = "SimpleSettingValue"
                                                                                            isArray = $False
                                                                                        } -ClientOnly)
                                                                                        choiceSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                                            Name = "ChoiceSettingValue"
                                                                                            isArray = $False
                                                                                        } -ClientOnly)
                                                                                        groupSettingCollectionValue = [CimInstance[]]@(
                                                                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                                                            Name = "GroupSettingCollectionValue"
                                                                                            isArray = $True
                                                                                            } -ClientOnly)
                                                                                        )
                                                                                    } -ClientOnly)
                                                                                )
                                                                            } -ClientOnly)
                                                                            SettingInstanceTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference -Property @{
                                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference"
                                                                                Name = "SettingInstanceTemplateReference"
                                                                                isArray = $False
                                                                            } -ClientOnly)
                                                                            simpleSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                                                Name = "SimpleSettingValue"
                                                                                isArray = $False
                                                                            } -ClientOnly)
                                                                            choiceSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                                Name = "ChoiceSettingValue"
                                                                                isArray = $False
                                                                            } -ClientOnly)
                                                                            groupSettingCollectionValue = [CimInstance[]]@(
                                                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                                                Name = "GroupSettingCollectionValue"
                                                                                isArray = $True
                                                                                } -ClientOnly)
                                                                            )
                                                                        } -ClientOnly)
                                                                    )
                                                                } -ClientOnly)
                                                            )
                                                        } -ClientOnly)
                                                    )
                                                } -ClientOnly)
                                                groupSettingCollectionValue = [CimInstance[]]@(
                                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                    CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                    Name = "GroupSettingCollectionValue"
                                                    isArray = $True
                                                    } -ClientOnly)
                                                )
                                            } -ClientOnly)
                                        )
                                    } -ClientOnly)
                                )
                                groupSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                    odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                    Value = "FakeStringValue"
                                    SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference"
                                        Name = "SettingValueTemplateReference"
                                        isArray = $False
                                    } -ClientOnly)
                                    children = [CimInstance[]]@(
                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance"
                                        Name = "Children"
                                        isArray = $True
                                        } -ClientOnly)
                                    )
                                } -ClientOnly)
                                SettingInstanceTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference -Property @{
                                    SettingInstanceTemplateId = "FakeStringValue"
                                } -ClientOnly)
                                simpleSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                    valueState = "invalid"
                                    value = 25
                                    SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference"
                                        Name = "SettingValueTemplateReference"
                                        isArray = $False
                                    } -ClientOnly)
                                    children = [CimInstance[]]@(
                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance"
                                        Name = "Children"
                                        isArray = $True
                                        } -ClientOnly)
                                    )
                                    odataType = "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue"
                                } -ClientOnly)
                                choiceSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                    SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference"
                                        Name = "SettingValueTemplateReference"
                                        isArray = $False
                                    } -ClientOnly)
                                    odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                    value = "FakeStringValue"
                                    children = [CimInstance[]]@(
                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance"
                                        Name = "Children"
                                        isArray = $True
                                        } -ClientOnly)
                                    )
                                } -ClientOnly)
                                groupSettingCollectionValue = [CimInstance[]]@(
                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                        odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                        Value = "FakeStringValue"
                                        SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference"
                                            Name = "SettingValueTemplateReference"
                                            isArray = $False
                                        } -ClientOnly)
                                        children = [CimInstance[]]@(
                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance"
                                            Name = "Children"
                                            isArray = $True
                                            } -ClientOnly)
                                        )
                                    } -ClientOnly)
                                )
                            } -ClientOnly)
                        } -ClientOnly)
                    )
                    Technologies = "none"
                    TemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationPolicyTemplateReference -Property @{
                        TemplateId = "FakeStringValue"
                        TemplateDisplayVersion = "FakeStringValue"
                        TemplateDisplayName = "FakeStringValue"
                        TemplateFamily = "none"
                    } -ClientOnly)
                    Ensure = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgDeviceManagementConfigurationPolicy -MockWith {
                    return @{
                        AdditionalProperties = @{
                            '@odata.type' = "#microsoft.graph.DeviceManagementConfigurationPolicy"
                        }
                        CreationSource = "FakeStringValue"
                        Description = "FakeStringValue"
                        Id = "FakeStringValue"
                        IsAssigned = $True
                        Name = "FakeStringValue"
                        Platforms = "none"
                        PriorityMetaData = @{
                            Priority = 25
                        }
                        SettingCount = 25
                        Settings = @(
                            @{
                                Id = "FakeStringValue"
                                SettingInstance = @{
                                    simpleSettingCollectionValue = @(
                                        @{
                                            '@odata.type' = "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue"
                                            valueState = "invalid"
                                            value = 25
                                            SettingValueTemplateReference = @{
                                                isArray = $False
                                                Name = "SettingValueTemplateReference"
                                            }
                                            children = @(
                                                @{
                                                isArray = $True
                                                Name = "Children"
                                                }
                                            )
                                        }
                                    )
                                    SettingDefinitionId = "FakeStringValue"
                                    '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                    choiceSettingCollectionValue = @(
                                        @{
                                            SettingValueTemplateReference = @{
                                                isArray = $False
                                                Name = "SettingValueTemplateReference"
                                            }
                                            '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                            value = "FakeStringValue"
                                            children = @(
                                                @{
                                                    simpleSettingCollectionValue = @(
                                                        @{
                                                        isArray = $True
                                                        Name = "SimpleSettingCollectionValue"
                                                        }
                                                    )
                                                    settingDefinitionId = "FakeStringValue"
                                                    '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                    choiceSettingCollectionValue = @(
                                                        @{
                                                            SettingValueTemplateReference = @{
                                                                UseTemplateDefault = $True
                                                                SettingValueTemplateId = "FakeStringValue"
                                                            }
                                                            '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                                            value = "FakeStringValue"
                                                            children = @(
                                                                @{
                                                                isArray = $True
                                                                Name = "Children"
                                                                }
                                                            )
                                                        }
                                                    )
                                                    groupSettingValue = @{
                                                        isArray = $False
                                                        Name = "GroupSettingValue"
                                                    }
                                                    SettingInstanceTemplateReference = @{
                                                        SettingInstanceTemplateId = "FakeStringValue"
                                                    }
                                                    simpleSettingValue = @{
                                                        isArray = $False
                                                        Name = "SimpleSettingValue"
                                                    }
                                                    choiceSettingValue = @{
                                                        SettingValueTemplateReference = @{
                                                            UseTemplateDefault = $True
                                                            SettingValueTemplateId = "FakeStringValue"
                                                        }
                                                        '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                                        value = "FakeStringValue"
                                                        children = @(
                                                            @{
                                                                simpleSettingCollectionValue = @(
                                                                    @{
                                                                    isArray = $True
                                                                    Name = "SimpleSettingCollectionValue"
                                                                    }
                                                                )
                                                                settingDefinitionId = "FakeStringValue"
                                                                '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                                choiceSettingCollectionValue = @(
                                                                    @{
                                                                    isArray = $True
                                                                    Name = "ChoiceSettingCollectionValue"
                                                                    }
                                                                )
                                                                groupSettingValue = @{
                                                                    isArray = $False
                                                                    Name = "GroupSettingValue"
                                                                }
                                                                SettingInstanceTemplateReference = @{
                                                                    isArray = $False
                                                                    Name = "SettingInstanceTemplateReference"
                                                                }
                                                                simpleSettingValue = @{
                                                                    isArray = $False
                                                                    Name = "SimpleSettingValue"
                                                                }
                                                                choiceSettingValue = @{
                                                                    isArray = $False
                                                                    Name = "ChoiceSettingValue"
                                                                }
                                                                groupSettingCollectionValue = @(
                                                                    @{
                                                                        '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                                                        Value = "FakeStringValue"
                                                                        SettingValueTemplateReference = @{
                                                                            UseTemplateDefault = $True
                                                                            SettingValueTemplateId = "FakeStringValue"
                                                                        }
                                                                        children = @(
                                                                            @{
                                                                                simpleSettingCollectionValue = @(
                                                                                    @{
                                                                                    isArray = $True
                                                                                    Name = "SimpleSettingCollectionValue"
                                                                                    }
                                                                                )
                                                                                settingDefinitionId = "FakeStringValue"
                                                                                '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                                                choiceSettingCollectionValue = @(
                                                                                    @{
                                                                                    isArray = $True
                                                                                    Name = "ChoiceSettingCollectionValue"
                                                                                    }
                                                                                )
                                                                                groupSettingValue = @{
                                                                                    '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                                                                    Value = "FakeStringValue"
                                                                                    SettingValueTemplateReference = @{
                                                                                        UseTemplateDefault = $True
                                                                                        SettingValueTemplateId = "FakeStringValue"
                                                                                    }
                                                                                    children = @(
                                                                                        @{
                                                                                            simpleSettingCollectionValue = @(
                                                                                                @{
                                                                                                    '@odata.type' = "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue"
                                                                                                    valueState = "invalid"
                                                                                                    value = 25
                                                                                                    SettingValueTemplateReference = @{
                                                                                                        UseTemplateDefault = $True
                                                                                                        SettingValueTemplateId = "FakeStringValue"
                                                                                                    }
                                                                                                    children = @(
                                                                                                        @{
                                                                                                            simpleSettingCollectionValue = @(
                                                                                                                @{
                                                                                                                isArray = $True
                                                                                                                Name = "SimpleSettingCollectionValue"
                                                                                                                }
                                                                                                            )
                                                                                                            settingDefinitionId = "FakeStringValue"
                                                                                                            '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                                                                            choiceSettingCollectionValue = @(
                                                                                                                @{
                                                                                                                isArray = $True
                                                                                                                Name = "ChoiceSettingCollectionValue"
                                                                                                                }
                                                                                                            )
                                                                                                            groupSettingValue = @{
                                                                                                                isArray = $False
                                                                                                                Name = "GroupSettingValue"
                                                                                                            }
                                                                                                            SettingInstanceTemplateReference = @{
                                                                                                                isArray = $False
                                                                                                                Name = "SettingInstanceTemplateReference"
                                                                                                            }
                                                                                                            simpleSettingValue = @{
                                                                                                                '@odata.type' = "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue"
                                                                                                                valueState = "invalid"
                                                                                                                value = 25
                                                                                                                SettingValueTemplateReference = @{
                                                                                                                    UseTemplateDefault = $True
                                                                                                                    SettingValueTemplateId = "FakeStringValue"
                                                                                                                }
                                                                                                                children = @(
                                                                                                                    @{
                                                                                                                        simpleSettingCollectionValue = @(
                                                                                                                            @{
                                                                                                                            isArray = $True
                                                                                                                            Name = "SimpleSettingCollectionValue"
                                                                                                                            }
                                                                                                                        )
                                                                                                                        settingDefinitionId = "FakeStringValue"
                                                                                                                        '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                                                                                        choiceSettingCollectionValue = @(
                                                                                                                            @{
                                                                                                                            isArray = $True
                                                                                                                            Name = "ChoiceSettingCollectionValue"
                                                                                                                            }
                                                                                                                        )
                                                                                                                        groupSettingValue = @{
                                                                                                                            isArray = $False
                                                                                                                            Name = "GroupSettingValue"
                                                                                                                        }
                                                                                                                        SettingInstanceTemplateReference = @{
                                                                                                                            isArray = $False
                                                                                                                            Name = "SettingInstanceTemplateReference"
                                                                                                                        }
                                                                                                                        simpleSettingValue = @{
                                                                                                                            isArray = $False
                                                                                                                            Name = "SimpleSettingValue"
                                                                                                                        }
                                                                                                                        choiceSettingValue = @{
                                                                                                                            isArray = $False
                                                                                                                            Name = "ChoiceSettingValue"
                                                                                                                        }
                                                                                                                        groupSettingCollectionValue = @(
                                                                                                                            @{
                                                                                                                            isArray = $True
                                                                                                                            Name = "GroupSettingCollectionValue"
                                                                                                                            }
                                                                                                                        )
                                                                                                                    }
                                                                                                                )
                                                                                                            }
                                                                                                            choiceSettingValue = @{
                                                                                                                isArray = $False
                                                                                                                Name = "ChoiceSettingValue"
                                                                                                            }
                                                                                                            groupSettingCollectionValue = @(
                                                                                                                @{
                                                                                                                isArray = $True
                                                                                                                Name = "GroupSettingCollectionValue"
                                                                                                                }
                                                                                                            )
                                                                                                        }
                                                                                                    )
                                                                                                }
                                                                                            )
                                                                                            settingDefinitionId = "FakeStringValue"
                                                                                            '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                                                            choiceSettingCollectionValue = @(
                                                                                                @{
                                                                                                isArray = $True
                                                                                                Name = "ChoiceSettingCollectionValue"
                                                                                                }
                                                                                            )
                                                                                            groupSettingValue = @{
                                                                                                isArray = $False
                                                                                                Name = "GroupSettingValue"
                                                                                            }
                                                                                            SettingInstanceTemplateReference = @{
                                                                                                isArray = $False
                                                                                                Name = "SettingInstanceTemplateReference"
                                                                                            }
                                                                                            simpleSettingValue = @{
                                                                                                isArray = $False
                                                                                                Name = "SimpleSettingValue"
                                                                                            }
                                                                                            choiceSettingValue = @{
                                                                                                isArray = $False
                                                                                                Name = "ChoiceSettingValue"
                                                                                            }
                                                                                            groupSettingCollectionValue = @(
                                                                                                @{
                                                                                                isArray = $True
                                                                                                Name = "GroupSettingCollectionValue"
                                                                                                }
                                                                                            )
                                                                                        }
                                                                                    )
                                                                                }
                                                                                SettingInstanceTemplateReference = @{
                                                                                    isArray = $False
                                                                                    Name = "SettingInstanceTemplateReference"
                                                                                }
                                                                                simpleSettingValue = @{
                                                                                    isArray = $False
                                                                                    Name = "SimpleSettingValue"
                                                                                }
                                                                                choiceSettingValue = @{
                                                                                    isArray = $False
                                                                                    Name = "ChoiceSettingValue"
                                                                                }
                                                                                groupSettingCollectionValue = @(
                                                                                    @{
                                                                                    isArray = $True
                                                                                    Name = "GroupSettingCollectionValue"
                                                                                    }
                                                                                )
                                                                            }
                                                                        )
                                                                    }
                                                                )
                                                            }
                                                        )
                                                    }
                                                    groupSettingCollectionValue = @(
                                                        @{
                                                        isArray = $True
                                                        Name = "GroupSettingCollectionValue"
                                                        }
                                                    )
                                                }
                                            )
                                        }
                                    )
                                    groupSettingValue = @{
                                        '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                        Value = "FakeStringValue"
                                        SettingValueTemplateReference = @{
                                            isArray = $False
                                            Name = "SettingValueTemplateReference"
                                        }
                                        children = @(
                                            @{
                                            isArray = $True
                                            Name = "Children"
                                            }
                                        )
                                    }
                                    SettingInstanceTemplateReference = @{
                                        SettingInstanceTemplateId = "FakeStringValue"
                                    }
                                    simpleSettingValue = @{
                                        '@odata.type' = "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue"
                                        valueState = "invalid"
                                        value = 25
                                        SettingValueTemplateReference = @{
                                            isArray = $False
                                            Name = "SettingValueTemplateReference"
                                        }
                                        children = @(
                                            @{
                                            isArray = $True
                                            Name = "Children"
                                            }
                                        )
                                    }
                                    choiceSettingValue = @{
                                        SettingValueTemplateReference = @{
                                            isArray = $False
                                            Name = "SettingValueTemplateReference"
                                        }
                                        '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                        value = "FakeStringValue"
                                        children = @(
                                            @{
                                            isArray = $True
                                            Name = "Children"
                                            }
                                        )
                                    }
                                    groupSettingCollectionValue = @(
                                        @{
                                            '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                            Value = "FakeStringValue"
                                            SettingValueTemplateReference = @{
                                                isArray = $False
                                                Name = "SettingValueTemplateReference"
                                            }
                                            children = @(
                                                @{
                                                isArray = $True
                                                Name = "Children"
                                                }
                                            )
                                        }
                                    )
                                }
                            }
                        )
                        Technologies = "none"
                        TemplateReference = @{
                            TemplateId = "FakeStringValue"
                            TemplateDisplayVersion = "FakeStringValue"
                            TemplateDisplayName = "FakeStringValue"
                            TemplateFamily = "none"
                        }

                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The IntuneSettingCatalogCustomPolicyWindows10 exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    CreationSource = "FakeStringValue"
                    Description = "FakeStringValue"
                    Id = "FakeStringValue"
                    IsAssigned = $True
                    Name = "FakeStringValue"
                    Platforms = "none"
                    PriorityMetaData = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementPriorityMetaData -Property @{
                        Priority = 25
                    } -ClientOnly)
                    SettingCount = 25
                    Settings = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSetting -Property @{
                            Id = "FakeStringValue"
                            SettingInstance = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                simpleSettingCollectionValue = [CimInstance[]]@(
                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                        valueState = "invalid"
                                        value = 25
                                        SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference"
                                            Name = "SettingValueTemplateReference"
                                            isArray = $False
                                        } -ClientOnly)
                                        children = [CimInstance[]]@(
                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance"
                                            Name = "Children"
                                            isArray = $True
                                            } -ClientOnly)
                                        )
                                        odataType = "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue"
                                    } -ClientOnly)
                                )
                                SettingDefinitionId = "FakeStringValue"
                                odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                choiceSettingCollectionValue = [CimInstance[]]@(
                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                        SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference"
                                            Name = "SettingValueTemplateReference"
                                            isArray = $False
                                        } -ClientOnly)
                                        odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                        value = "FakeStringValue"
                                        children = [CimInstance[]]@(
                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                                simpleSettingCollectionValue = [CimInstance[]]@(
                                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                    CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                    Name = "SimpleSettingCollectionValue"
                                                    isArray = $True
                                                    } -ClientOnly)
                                                )
                                                settingDefinitionId = "FakeStringValue"
                                                odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                choiceSettingCollectionValue = [CimInstance[]]@(
                                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                        SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                                            UseTemplateDefault = $True
                                                            SettingValueTemplateId = "FakeStringValue"
                                                        } -ClientOnly)
                                                        odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                                        value = "FakeStringValue"
                                                        children = [CimInstance[]]@(
                                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance"
                                                            Name = "Children"
                                                            isArray = $True
                                                            } -ClientOnly)
                                                        )
                                                    } -ClientOnly)
                                                )
                                                groupSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                    CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                    Name = "GroupSettingValue"
                                                    isArray = $False
                                                } -ClientOnly)
                                                SettingInstanceTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference -Property @{
                                                    SettingInstanceTemplateId = "FakeStringValue"
                                                } -ClientOnly)
                                                simpleSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                    CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                    Name = "SimpleSettingValue"
                                                    isArray = $False
                                                } -ClientOnly)
                                                choiceSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                    SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                                        UseTemplateDefault = $True
                                                        SettingValueTemplateId = "FakeStringValue"
                                                    } -ClientOnly)
                                                    odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                                    value = "FakeStringValue"
                                                    children = [CimInstance[]]@(
                                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                                            simpleSettingCollectionValue = [CimInstance[]]@(
                                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                                Name = "SimpleSettingCollectionValue"
                                                                isArray = $True
                                                                } -ClientOnly)
                                                            )
                                                            settingDefinitionId = "FakeStringValue"
                                                            odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                            choiceSettingCollectionValue = [CimInstance[]]@(
                                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                Name = "ChoiceSettingCollectionValue"
                                                                isArray = $True
                                                                } -ClientOnly)
                                                            )
                                                            groupSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                                Name = "GroupSettingValue"
                                                                isArray = $False
                                                            } -ClientOnly)
                                                            SettingInstanceTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference -Property @{
                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference"
                                                                Name = "SettingInstanceTemplateReference"
                                                                isArray = $False
                                                            } -ClientOnly)
                                                            simpleSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                                Name = "SimpleSettingValue"
                                                                isArray = $False
                                                            } -ClientOnly)
                                                            choiceSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                Name = "ChoiceSettingValue"
                                                                isArray = $False
                                                            } -ClientOnly)
                                                            groupSettingCollectionValue = [CimInstance[]]@(
                                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                    odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                                                    Value = "FakeStringValue"
                                                                    SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                                                        UseTemplateDefault = $True
                                                                        SettingValueTemplateId = "FakeStringValue"
                                                                    } -ClientOnly)
                                                                    children = [CimInstance[]]@(
                                                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                                                            simpleSettingCollectionValue = [CimInstance[]]@(
                                                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                                                Name = "SimpleSettingCollectionValue"
                                                                                isArray = $True
                                                                                } -ClientOnly)
                                                                            )
                                                                            settingDefinitionId = "FakeStringValue"
                                                                            odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                                            choiceSettingCollectionValue = [CimInstance[]]@(
                                                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                                Name = "ChoiceSettingCollectionValue"
                                                                                isArray = $True
                                                                                } -ClientOnly)
                                                                            )
                                                                            groupSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                                odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                                                                Value = "FakeStringValue"
                                                                                SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                                                                    UseTemplateDefault = $True
                                                                                    SettingValueTemplateId = "FakeStringValue"
                                                                                } -ClientOnly)
                                                                                children = [CimInstance[]]@(
                                                                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                                                                        simpleSettingCollectionValue = [CimInstance[]]@(
                                                                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                                                valueState = "invalid"
                                                                                                value = 25
                                                                                                SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                                                                                    UseTemplateDefault = $True
                                                                                                    SettingValueTemplateId = "FakeStringValue"
                                                                                                } -ClientOnly)
                                                                                                children = [CimInstance[]]@(
                                                                                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                                                                                        simpleSettingCollectionValue = [CimInstance[]]@(
                                                                                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                                                                            Name = "SimpleSettingCollectionValue"
                                                                                                            isArray = $True
                                                                                                            } -ClientOnly)
                                                                                                        )
                                                                                                        settingDefinitionId = "FakeStringValue"
                                                                                                        odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                                                                        choiceSettingCollectionValue = [CimInstance[]]@(
                                                                                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                                                            Name = "ChoiceSettingCollectionValue"
                                                                                                            isArray = $True
                                                                                                            } -ClientOnly)
                                                                                                        )
                                                                                                        groupSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                                                                            Name = "GroupSettingValue"
                                                                                                            isArray = $False
                                                                                                        } -ClientOnly)
                                                                                                        SettingInstanceTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference -Property @{
                                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference"
                                                                                                            Name = "SettingInstanceTemplateReference"
                                                                                                            isArray = $False
                                                                                                        } -ClientOnly)
                                                                                                        simpleSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                                                            valueState = "invalid"
                                                                                                            value = 25
                                                                                                            SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                                                                                                UseTemplateDefault = $True
                                                                                                                SettingValueTemplateId = "FakeStringValue"
                                                                                                            } -ClientOnly)
                                                                                                            children = [CimInstance[]]@(
                                                                                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                                                                                                    simpleSettingCollectionValue = [CimInstance[]]@(
                                                                                                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                                                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                                                                                        Name = "SimpleSettingCollectionValue"
                                                                                                                        isArray = $True
                                                                                                                        } -ClientOnly)
                                                                                                                    )
                                                                                                                    settingDefinitionId = "FakeStringValue"
                                                                                                                    odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                                                                                    choiceSettingCollectionValue = [CimInstance[]]@(
                                                                                                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                                                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                                                                        Name = "ChoiceSettingCollectionValue"
                                                                                                                        isArray = $True
                                                                                                                        } -ClientOnly)
                                                                                                                    )
                                                                                                                    groupSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                                                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                                                                                        Name = "GroupSettingValue"
                                                                                                                        isArray = $False
                                                                                                                    } -ClientOnly)
                                                                                                                    SettingInstanceTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference -Property @{
                                                                                                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference"
                                                                                                                        Name = "SettingInstanceTemplateReference"
                                                                                                                        isArray = $False
                                                                                                                    } -ClientOnly)
                                                                                                                    simpleSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                                                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                                                                                        Name = "SimpleSettingValue"
                                                                                                                        isArray = $False
                                                                                                                    } -ClientOnly)
                                                                                                                    choiceSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                                                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                                                                        Name = "ChoiceSettingValue"
                                                                                                                        isArray = $False
                                                                                                                    } -ClientOnly)
                                                                                                                    groupSettingCollectionValue = [CimInstance[]]@(
                                                                                                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                                                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                                                                                        Name = "GroupSettingCollectionValue"
                                                                                                                        isArray = $True
                                                                                                                        } -ClientOnly)
                                                                                                                    )
                                                                                                                } -ClientOnly)
                                                                                                            )
                                                                                                            odataType = "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue"
                                                                                                        } -ClientOnly)
                                                                                                        choiceSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                                                            Name = "ChoiceSettingValue"
                                                                                                            isArray = $False
                                                                                                        } -ClientOnly)
                                                                                                        groupSettingCollectionValue = [CimInstance[]]@(
                                                                                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                                                                            Name = "GroupSettingCollectionValue"
                                                                                                            isArray = $True
                                                                                                            } -ClientOnly)
                                                                                                        )
                                                                                                    } -ClientOnly)
                                                                                                )
                                                                                                odataType = "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue"
                                                                                            } -ClientOnly)
                                                                                        )
                                                                                        settingDefinitionId = "FakeStringValue"
                                                                                        odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                                                        choiceSettingCollectionValue = [CimInstance[]]@(
                                                                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                                            Name = "ChoiceSettingCollectionValue"
                                                                                            isArray = $True
                                                                                            } -ClientOnly)
                                                                                        )
                                                                                        groupSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                                                            Name = "GroupSettingValue"
                                                                                            isArray = $False
                                                                                        } -ClientOnly)
                                                                                        SettingInstanceTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference -Property @{
                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference"
                                                                                            Name = "SettingInstanceTemplateReference"
                                                                                            isArray = $False
                                                                                        } -ClientOnly)
                                                                                        simpleSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                                                            Name = "SimpleSettingValue"
                                                                                            isArray = $False
                                                                                        } -ClientOnly)
                                                                                        choiceSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                                            Name = "ChoiceSettingValue"
                                                                                            isArray = $False
                                                                                        } -ClientOnly)
                                                                                        groupSettingCollectionValue = [CimInstance[]]@(
                                                                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                                                            Name = "GroupSettingCollectionValue"
                                                                                            isArray = $True
                                                                                            } -ClientOnly)
                                                                                        )
                                                                                    } -ClientOnly)
                                                                                )
                                                                            } -ClientOnly)
                                                                            SettingInstanceTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference -Property @{
                                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference"
                                                                                Name = "SettingInstanceTemplateReference"
                                                                                isArray = $False
                                                                            } -ClientOnly)
                                                                            simpleSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue"
                                                                                Name = "SimpleSettingValue"
                                                                                isArray = $False
                                                                            } -ClientOnly)
                                                                            choiceSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue"
                                                                                Name = "ChoiceSettingValue"
                                                                                isArray = $False
                                                                            } -ClientOnly)
                                                                            groupSettingCollectionValue = [CimInstance[]]@(
                                                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                                                CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                                                Name = "GroupSettingCollectionValue"
                                                                                isArray = $True
                                                                                } -ClientOnly)
                                                                            )
                                                                        } -ClientOnly)
                                                                    )
                                                                } -ClientOnly)
                                                            )
                                                        } -ClientOnly)
                                                    )
                                                } -ClientOnly)
                                                groupSettingCollectionValue = [CimInstance[]]@(
                                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                                    CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue"
                                                    Name = "GroupSettingCollectionValue"
                                                    isArray = $True
                                                    } -ClientOnly)
                                                )
                                            } -ClientOnly)
                                        )
                                    } -ClientOnly)
                                )
                                groupSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                    odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                    Value = "FakeStringValue"
                                    SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference"
                                        Name = "SettingValueTemplateReference"
                                        isArray = $False
                                    } -ClientOnly)
                                    children = [CimInstance[]]@(
                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance"
                                        Name = "Children"
                                        isArray = $True
                                        } -ClientOnly)
                                    )
                                } -ClientOnly)
                                SettingInstanceTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstanceTemplateReference -Property @{
                                    SettingInstanceTemplateId = "FakeStringValue"
                                } -ClientOnly)
                                simpleSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSimpleSettingValue -Property @{
                                    valueState = "invalid"
                                    value = 25
                                    SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference"
                                        Name = "SettingValueTemplateReference"
                                        isArray = $False
                                    } -ClientOnly)
                                    children = [CimInstance[]]@(
                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance"
                                        Name = "Children"
                                        isArray = $True
                                        } -ClientOnly)
                                    )
                                    odataType = "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue"
                                } -ClientOnly)
                                choiceSettingValue = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationChoiceSettingValue -Property @{
                                    SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference"
                                        Name = "SettingValueTemplateReference"
                                        isArray = $False
                                    } -ClientOnly)
                                    odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                    value = "FakeStringValue"
                                    children = [CimInstance[]]@(
                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                        CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance"
                                        Name = "Children"
                                        isArray = $True
                                        } -ClientOnly)
                                    )
                                } -ClientOnly)
                                groupSettingCollectionValue = [CimInstance[]]@(
                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationGroupSettingValue -Property @{
                                        odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                        Value = "FakeStringValue"
                                        SettingValueTemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference -Property @{
                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingValueTemplateReference"
                                            Name = "SettingValueTemplateReference"
                                            isArray = $False
                                        } -ClientOnly)
                                        children = [CimInstance[]]@(
                                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance -Property @{
                                            CIMType = "MSFT_MicrosoftGraphdeviceManagementConfigurationSettingInstance"
                                            Name = "Children"
                                            isArray = $True
                                            } -ClientOnly)
                                        )
                                    } -ClientOnly)
                                )
                            } -ClientOnly)
                        } -ClientOnly)
                    )
                    Technologies = "none"
                    TemplateReference = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementConfigurationPolicyTemplateReference -Property @{
                        TemplateId = "FakeStringValue"
                        TemplateDisplayVersion = "FakeStringValue"
                        TemplateDisplayName = "FakeStringValue"
                        TemplateFamily = "none"
                    } -ClientOnly)
                    Ensure = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgDeviceManagementConfigurationPolicy -MockWith {
                    return @{
                        CreationSource = "FakeStringValue"
                        Description = "FakeStringValue"
                        Id = "FakeStringValue"
                        Name = "FakeStringValue"
                        Platforms = "none"
                        PriorityMetaData = @{
                            Priority = 7
                        }
                        SettingCount = 7
                        Settings = @(
                            @{
                                Id = "FakeStringValue"
                                SettingInstance = @{
                                    simpleSettingCollectionValue = @(
                                        @{
                                            '@odata.type' = "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue"
                                            valueState = "invalid"
                                            value = 7
                                            SettingValueTemplateReference = @{
                                                isArray = $False
                                                Name = "SettingValueTemplateReference"
                                            }
                                            children = @(
                                                @{
                                                isArray = $True
                                                Name = "Children"
                                                }
                                            )
                                        }
                                    )
                                    SettingDefinitionId = "FakeStringValue"
                                    '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                    choiceSettingCollectionValue = @(
                                        @{
                                            SettingValueTemplateReference = @{
                                                isArray = $False
                                                Name = "SettingValueTemplateReference"
                                            }
                                            '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                            value = "FakeStringValue"
                                            children = @(
                                                @{
                                                    simpleSettingCollectionValue = @(
                                                        @{
                                                        isArray = $True
                                                        Name = "SimpleSettingCollectionValue"
                                                        }
                                                    )
                                                    settingDefinitionId = "FakeStringValue"
                                                    '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                    choiceSettingCollectionValue = @(
                                                        @{
                                                            SettingValueTemplateReference = @{
                                                                SettingValueTemplateId = "FakeStringValue"
                                                            }
                                                            '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                                            value = "FakeStringValue"
                                                            children = @(
                                                                @{
                                                                isArray = $True
                                                                Name = "Children"
                                                                }
                                                            )
                                                        }
                                                    )
                                                    groupSettingValue = @{
                                                        isArray = $False
                                                        Name = "GroupSettingValue"
                                                    }
                                                    SettingInstanceTemplateReference = @{
                                                        SettingInstanceTemplateId = "FakeStringValue"
                                                    }
                                                    simpleSettingValue = @{
                                                        isArray = $False
                                                        Name = "SimpleSettingValue"
                                                    }
                                                    choiceSettingValue = @{
                                                        SettingValueTemplateReference = @{
                                                            SettingValueTemplateId = "FakeStringValue"
                                                        }
                                                        '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                                        value = "FakeStringValue"
                                                        children = @(
                                                            @{
                                                                simpleSettingCollectionValue = @(
                                                                    @{
                                                                    isArray = $True
                                                                    Name = "SimpleSettingCollectionValue"
                                                                    }
                                                                )
                                                                settingDefinitionId = "FakeStringValue"
                                                                '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                                choiceSettingCollectionValue = @(
                                                                    @{
                                                                    isArray = $True
                                                                    Name = "ChoiceSettingCollectionValue"
                                                                    }
                                                                )
                                                                groupSettingValue = @{
                                                                    isArray = $False
                                                                    Name = "GroupSettingValue"
                                                                }
                                                                SettingInstanceTemplateReference = @{
                                                                    isArray = $False
                                                                    Name = "SettingInstanceTemplateReference"
                                                                }
                                                                simpleSettingValue = @{
                                                                    isArray = $False
                                                                    Name = "SimpleSettingValue"
                                                                }
                                                                choiceSettingValue = @{
                                                                    isArray = $False
                                                                    Name = "ChoiceSettingValue"
                                                                }
                                                                groupSettingCollectionValue = @(
                                                                    @{
                                                                        '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                                                        Value = "FakeStringValue"
                                                                        SettingValueTemplateReference = @{
                                                                            SettingValueTemplateId = "FakeStringValue"
                                                                        }
                                                                        children = @(
                                                                            @{
                                                                                simpleSettingCollectionValue = @(
                                                                                    @{
                                                                                    isArray = $True
                                                                                    Name = "SimpleSettingCollectionValue"
                                                                                    }
                                                                                )
                                                                                settingDefinitionId = "FakeStringValue"
                                                                                '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                                                choiceSettingCollectionValue = @(
                                                                                    @{
                                                                                    isArray = $True
                                                                                    Name = "ChoiceSettingCollectionValue"
                                                                                    }
                                                                                )
                                                                                groupSettingValue = @{
                                                                                    '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                                                                    Value = "FakeStringValue"
                                                                                    SettingValueTemplateReference = @{
                                                                                        SettingValueTemplateId = "FakeStringValue"
                                                                                    }
                                                                                    children = @(
                                                                                        @{
                                                                                            simpleSettingCollectionValue = @(
                                                                                                @{
                                                                                                    '@odata.type' = "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue"
                                                                                                    valueState = "invalid"
                                                                                                    value = 7
                                                                                                    SettingValueTemplateReference = @{
                                                                                                        SettingValueTemplateId = "FakeStringValue"
                                                                                                    }
                                                                                                    children = @(
                                                                                                        @{
                                                                                                            simpleSettingCollectionValue = @(
                                                                                                                @{
                                                                                                                isArray = $True
                                                                                                                Name = "SimpleSettingCollectionValue"
                                                                                                                }
                                                                                                            )
                                                                                                            settingDefinitionId = "FakeStringValue"
                                                                                                            '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                                                                            choiceSettingCollectionValue = @(
                                                                                                                @{
                                                                                                                isArray = $True
                                                                                                                Name = "ChoiceSettingCollectionValue"
                                                                                                                }
                                                                                                            )
                                                                                                            groupSettingValue = @{
                                                                                                                isArray = $False
                                                                                                                Name = "GroupSettingValue"
                                                                                                            }
                                                                                                            SettingInstanceTemplateReference = @{
                                                                                                                isArray = $False
                                                                                                                Name = "SettingInstanceTemplateReference"
                                                                                                            }
                                                                                                            simpleSettingValue = @{
                                                                                                                '@odata.type' = "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue"
                                                                                                                valueState = "invalid"
                                                                                                                value = 7
                                                                                                                SettingValueTemplateReference = @{
                                                                                                                    SettingValueTemplateId = "FakeStringValue"
                                                                                                                }
                                                                                                                children = @(
                                                                                                                    @{
                                                                                                                        simpleSettingCollectionValue = @(
                                                                                                                            @{
                                                                                                                            isArray = $True
                                                                                                                            Name = "SimpleSettingCollectionValue"
                                                                                                                            }
                                                                                                                        )
                                                                                                                        settingDefinitionId = "FakeStringValue"
                                                                                                                        '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                                                                                        choiceSettingCollectionValue = @(
                                                                                                                            @{
                                                                                                                            isArray = $True
                                                                                                                            Name = "ChoiceSettingCollectionValue"
                                                                                                                            }
                                                                                                                        )
                                                                                                                        groupSettingValue = @{
                                                                                                                            isArray = $False
                                                                                                                            Name = "GroupSettingValue"
                                                                                                                        }
                                                                                                                        SettingInstanceTemplateReference = @{
                                                                                                                            isArray = $False
                                                                                                                            Name = "SettingInstanceTemplateReference"
                                                                                                                        }
                                                                                                                        simpleSettingValue = @{
                                                                                                                            isArray = $False
                                                                                                                            Name = "SimpleSettingValue"
                                                                                                                        }
                                                                                                                        choiceSettingValue = @{
                                                                                                                            isArray = $False
                                                                                                                            Name = "ChoiceSettingValue"
                                                                                                                        }
                                                                                                                        groupSettingCollectionValue = @(
                                                                                                                            @{
                                                                                                                            isArray = $True
                                                                                                                            Name = "GroupSettingCollectionValue"
                                                                                                                            }
                                                                                                                        )
                                                                                                                    }
                                                                                                                )
                                                                                                            }
                                                                                                            choiceSettingValue = @{
                                                                                                                isArray = $False
                                                                                                                Name = "ChoiceSettingValue"
                                                                                                            }
                                                                                                            groupSettingCollectionValue = @(
                                                                                                                @{
                                                                                                                isArray = $True
                                                                                                                Name = "GroupSettingCollectionValue"
                                                                                                                }
                                                                                                            )
                                                                                                        }
                                                                                                    )
                                                                                                }
                                                                                            )
                                                                                            settingDefinitionId = "FakeStringValue"
                                                                                            '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                                                            choiceSettingCollectionValue = @(
                                                                                                @{
                                                                                                isArray = $True
                                                                                                Name = "ChoiceSettingCollectionValue"
                                                                                                }
                                                                                            )
                                                                                            groupSettingValue = @{
                                                                                                isArray = $False
                                                                                                Name = "GroupSettingValue"
                                                                                            }
                                                                                            SettingInstanceTemplateReference = @{
                                                                                                isArray = $False
                                                                                                Name = "SettingInstanceTemplateReference"
                                                                                            }
                                                                                            simpleSettingValue = @{
                                                                                                isArray = $False
                                                                                                Name = "SimpleSettingValue"
                                                                                            }
                                                                                            choiceSettingValue = @{
                                                                                                isArray = $False
                                                                                                Name = "ChoiceSettingValue"
                                                                                            }
                                                                                            groupSettingCollectionValue = @(
                                                                                                @{
                                                                                                isArray = $True
                                                                                                Name = "GroupSettingCollectionValue"
                                                                                                }
                                                                                            )
                                                                                        }
                                                                                    )
                                                                                }
                                                                                SettingInstanceTemplateReference = @{
                                                                                    isArray = $False
                                                                                    Name = "SettingInstanceTemplateReference"
                                                                                }
                                                                                simpleSettingValue = @{
                                                                                    isArray = $False
                                                                                    Name = "SimpleSettingValue"
                                                                                }
                                                                                choiceSettingValue = @{
                                                                                    isArray = $False
                                                                                    Name = "ChoiceSettingValue"
                                                                                }
                                                                                groupSettingCollectionValue = @(
                                                                                    @{
                                                                                    isArray = $True
                                                                                    Name = "GroupSettingCollectionValue"
                                                                                    }
                                                                                )
                                                                            }
                                                                        )
                                                                    }
                                                                )
                                                            }
                                                        )
                                                    }
                                                    groupSettingCollectionValue = @(
                                                        @{
                                                        isArray = $True
                                                        Name = "GroupSettingCollectionValue"
                                                        }
                                                    )
                                                }
                                            )
                                        }
                                    )
                                    groupSettingValue = @{
                                        '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                        Value = "FakeStringValue"
                                        SettingValueTemplateReference = @{
                                            isArray = $False
                                            Name = "SettingValueTemplateReference"
                                        }
                                        children = @(
                                            @{
                                            isArray = $True
                                            Name = "Children"
                                            }
                                        )
                                    }
                                    SettingInstanceTemplateReference = @{
                                        SettingInstanceTemplateId = "FakeStringValue"
                                    }
                                    simpleSettingValue = @{
                                        '@odata.type' = "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue"
                                        valueState = "invalid"
                                        value = 7
                                        SettingValueTemplateReference = @{
                                            isArray = $False
                                            Name = "SettingValueTemplateReference"
                                        }
                                        children = @(
                                            @{
                                            isArray = $True
                                            Name = "Children"
                                            }
                                        )
                                    }
                                    choiceSettingValue = @{
                                        SettingValueTemplateReference = @{
                                            isArray = $False
                                            Name = "SettingValueTemplateReference"
                                        }
                                        '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                        value = "FakeStringValue"
                                        children = @(
                                            @{
                                            isArray = $True
                                            Name = "Children"
                                            }
                                        )
                                    }
                                    groupSettingCollectionValue = @(
                                        @{
                                            '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                            Value = "FakeStringValue"
                                            SettingValueTemplateReference = @{
                                                isArray = $False
                                                Name = "SettingValueTemplateReference"
                                            }
                                            children = @(
                                                @{
                                                isArray = $True
                                                Name = "Children"
                                                }
                                            )
                                        }
                                    )
                                }
                            }
                        )
                        Technologies = "none"
                        TemplateReference = @{
                            TemplateId = "FakeStringValue"
                            TemplateDisplayVersion = "FakeStringValue"
                            TemplateDisplayName = "FakeStringValue"
                            TemplateFamily = "none"
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
                Should -Invoke -CommandName Update-MgDeviceManagementConfigurationPolicy -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgDeviceManagementConfigurationPolicy -MockWith {
                    return @{
                        AdditionalProperties = @{
                            '@odata.type' = "#microsoft.graph.DeviceManagementConfigurationPolicy"
                        }
                        CreationSource = "FakeStringValue"
                        Description = "FakeStringValue"
                        Id = "FakeStringValue"
                        IsAssigned = $True
                        Name = "FakeStringValue"
                        Platforms = "none"
                        PriorityMetaData = @{
                            Priority = 25
                        }
                        SettingCount = 25
                        Settings = @(
                            @{
                                Id = "FakeStringValue"
                                SettingInstance = @{
                                    simpleSettingCollectionValue = @(
                                        @{
                                            '@odata.type' = "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue"
                                            valueState = "invalid"
                                            value = 25
                                            SettingValueTemplateReference = @{
                                                isArray = $False
                                                Name = "SettingValueTemplateReference"
                                            }
                                            children = @(
                                                @{
                                                isArray = $True
                                                Name = "Children"
                                                }
                                            )
                                        }
                                    )
                                    SettingDefinitionId = "FakeStringValue"
                                    '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                    choiceSettingCollectionValue = @(
                                        @{
                                            SettingValueTemplateReference = @{
                                                isArray = $False
                                                Name = "SettingValueTemplateReference"
                                            }
                                            '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                            value = "FakeStringValue"
                                            children = @(
                                                @{
                                                    simpleSettingCollectionValue = @(
                                                        @{
                                                        isArray = $True
                                                        Name = "SimpleSettingCollectionValue"
                                                        }
                                                    )
                                                    settingDefinitionId = "FakeStringValue"
                                                    '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                    choiceSettingCollectionValue = @(
                                                        @{
                                                            SettingValueTemplateReference = @{
                                                                UseTemplateDefault = $True
                                                                SettingValueTemplateId = "FakeStringValue"
                                                            }
                                                            '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                                            value = "FakeStringValue"
                                                            children = @(
                                                                @{
                                                                isArray = $True
                                                                Name = "Children"
                                                                }
                                                            )
                                                        }
                                                    )
                                                    groupSettingValue = @{
                                                        isArray = $False
                                                        Name = "GroupSettingValue"
                                                    }
                                                    SettingInstanceTemplateReference = @{
                                                        SettingInstanceTemplateId = "FakeStringValue"
                                                    }
                                                    simpleSettingValue = @{
                                                        isArray = $False
                                                        Name = "SimpleSettingValue"
                                                    }
                                                    choiceSettingValue = @{
                                                        SettingValueTemplateReference = @{
                                                            UseTemplateDefault = $True
                                                            SettingValueTemplateId = "FakeStringValue"
                                                        }
                                                        '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                                        value = "FakeStringValue"
                                                        children = @(
                                                            @{
                                                                simpleSettingCollectionValue = @(
                                                                    @{
                                                                    isArray = $True
                                                                    Name = "SimpleSettingCollectionValue"
                                                                    }
                                                                )
                                                                settingDefinitionId = "FakeStringValue"
                                                                '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                                choiceSettingCollectionValue = @(
                                                                    @{
                                                                    isArray = $True
                                                                    Name = "ChoiceSettingCollectionValue"
                                                                    }
                                                                )
                                                                groupSettingValue = @{
                                                                    isArray = $False
                                                                    Name = "GroupSettingValue"
                                                                }
                                                                SettingInstanceTemplateReference = @{
                                                                    isArray = $False
                                                                    Name = "SettingInstanceTemplateReference"
                                                                }
                                                                simpleSettingValue = @{
                                                                    isArray = $False
                                                                    Name = "SimpleSettingValue"
                                                                }
                                                                choiceSettingValue = @{
                                                                    isArray = $False
                                                                    Name = "ChoiceSettingValue"
                                                                }
                                                                groupSettingCollectionValue = @(
                                                                    @{
                                                                        '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                                                        Value = "FakeStringValue"
                                                                        SettingValueTemplateReference = @{
                                                                            UseTemplateDefault = $True
                                                                            SettingValueTemplateId = "FakeStringValue"
                                                                        }
                                                                        children = @(
                                                                            @{
                                                                                simpleSettingCollectionValue = @(
                                                                                    @{
                                                                                    isArray = $True
                                                                                    Name = "SimpleSettingCollectionValue"
                                                                                    }
                                                                                )
                                                                                settingDefinitionId = "FakeStringValue"
                                                                                '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                                                choiceSettingCollectionValue = @(
                                                                                    @{
                                                                                    isArray = $True
                                                                                    Name = "ChoiceSettingCollectionValue"
                                                                                    }
                                                                                )
                                                                                groupSettingValue = @{
                                                                                    '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                                                                    Value = "FakeStringValue"
                                                                                    SettingValueTemplateReference = @{
                                                                                        UseTemplateDefault = $True
                                                                                        SettingValueTemplateId = "FakeStringValue"
                                                                                    }
                                                                                    children = @(
                                                                                        @{
                                                                                            simpleSettingCollectionValue = @(
                                                                                                @{
                                                                                                    '@odata.type' = "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue"
                                                                                                    valueState = "invalid"
                                                                                                    value = 25
                                                                                                    SettingValueTemplateReference = @{
                                                                                                        UseTemplateDefault = $True
                                                                                                        SettingValueTemplateId = "FakeStringValue"
                                                                                                    }
                                                                                                    children = @(
                                                                                                        @{
                                                                                                            simpleSettingCollectionValue = @(
                                                                                                                @{
                                                                                                                isArray = $True
                                                                                                                Name = "SimpleSettingCollectionValue"
                                                                                                                }
                                                                                                            )
                                                                                                            settingDefinitionId = "FakeStringValue"
                                                                                                            '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                                                                            choiceSettingCollectionValue = @(
                                                                                                                @{
                                                                                                                isArray = $True
                                                                                                                Name = "ChoiceSettingCollectionValue"
                                                                                                                }
                                                                                                            )
                                                                                                            groupSettingValue = @{
                                                                                                                isArray = $False
                                                                                                                Name = "GroupSettingValue"
                                                                                                            }
                                                                                                            SettingInstanceTemplateReference = @{
                                                                                                                isArray = $False
                                                                                                                Name = "SettingInstanceTemplateReference"
                                                                                                            }
                                                                                                            simpleSettingValue = @{
                                                                                                                '@odata.type' = "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue"
                                                                                                                valueState = "invalid"
                                                                                                                value = 25
                                                                                                                SettingValueTemplateReference = @{
                                                                                                                    UseTemplateDefault = $True
                                                                                                                    SettingValueTemplateId = "FakeStringValue"
                                                                                                                }
                                                                                                                children = @(
                                                                                                                    @{
                                                                                                                        simpleSettingCollectionValue = @(
                                                                                                                            @{
                                                                                                                            isArray = $True
                                                                                                                            Name = "SimpleSettingCollectionValue"
                                                                                                                            }
                                                                                                                        )
                                                                                                                        settingDefinitionId = "FakeStringValue"
                                                                                                                        '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                                                                                        choiceSettingCollectionValue = @(
                                                                                                                            @{
                                                                                                                            isArray = $True
                                                                                                                            Name = "ChoiceSettingCollectionValue"
                                                                                                                            }
                                                                                                                        )
                                                                                                                        groupSettingValue = @{
                                                                                                                            isArray = $False
                                                                                                                            Name = "GroupSettingValue"
                                                                                                                        }
                                                                                                                        SettingInstanceTemplateReference = @{
                                                                                                                            isArray = $False
                                                                                                                            Name = "SettingInstanceTemplateReference"
                                                                                                                        }
                                                                                                                        simpleSettingValue = @{
                                                                                                                            isArray = $False
                                                                                                                            Name = "SimpleSettingValue"
                                                                                                                        }
                                                                                                                        choiceSettingValue = @{
                                                                                                                            isArray = $False
                                                                                                                            Name = "ChoiceSettingValue"
                                                                                                                        }
                                                                                                                        groupSettingCollectionValue = @(
                                                                                                                            @{
                                                                                                                            isArray = $True
                                                                                                                            Name = "GroupSettingCollectionValue"
                                                                                                                            }
                                                                                                                        )
                                                                                                                    }
                                                                                                                )
                                                                                                            }
                                                                                                            choiceSettingValue = @{
                                                                                                                isArray = $False
                                                                                                                Name = "ChoiceSettingValue"
                                                                                                            }
                                                                                                            groupSettingCollectionValue = @(
                                                                                                                @{
                                                                                                                isArray = $True
                                                                                                                Name = "GroupSettingCollectionValue"
                                                                                                                }
                                                                                                            )
                                                                                                        }
                                                                                                    )
                                                                                                }
                                                                                            )
                                                                                            settingDefinitionId = "FakeStringValue"
                                                                                            '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance"
                                                                                            choiceSettingCollectionValue = @(
                                                                                                @{
                                                                                                isArray = $True
                                                                                                Name = "ChoiceSettingCollectionValue"
                                                                                                }
                                                                                            )
                                                                                            groupSettingValue = @{
                                                                                                isArray = $False
                                                                                                Name = "GroupSettingValue"
                                                                                            }
                                                                                            SettingInstanceTemplateReference = @{
                                                                                                isArray = $False
                                                                                                Name = "SettingInstanceTemplateReference"
                                                                                            }
                                                                                            simpleSettingValue = @{
                                                                                                isArray = $False
                                                                                                Name = "SimpleSettingValue"
                                                                                            }
                                                                                            choiceSettingValue = @{
                                                                                                isArray = $False
                                                                                                Name = "ChoiceSettingValue"
                                                                                            }
                                                                                            groupSettingCollectionValue = @(
                                                                                                @{
                                                                                                isArray = $True
                                                                                                Name = "GroupSettingCollectionValue"
                                                                                                }
                                                                                            )
                                                                                        }
                                                                                    )
                                                                                }
                                                                                SettingInstanceTemplateReference = @{
                                                                                    isArray = $False
                                                                                    Name = "SettingInstanceTemplateReference"
                                                                                }
                                                                                simpleSettingValue = @{
                                                                                    isArray = $False
                                                                                    Name = "SimpleSettingValue"
                                                                                }
                                                                                choiceSettingValue = @{
                                                                                    isArray = $False
                                                                                    Name = "ChoiceSettingValue"
                                                                                }
                                                                                groupSettingCollectionValue = @(
                                                                                    @{
                                                                                    isArray = $True
                                                                                    Name = "GroupSettingCollectionValue"
                                                                                    }
                                                                                )
                                                                            }
                                                                        )
                                                                    }
                                                                )
                                                            }
                                                        )
                                                    }
                                                    groupSettingCollectionValue = @(
                                                        @{
                                                        isArray = $True
                                                        Name = "GroupSettingCollectionValue"
                                                        }
                                                    )
                                                }
                                            )
                                        }
                                    )
                                    groupSettingValue = @{
                                        '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                        Value = "FakeStringValue"
                                        SettingValueTemplateReference = @{
                                            isArray = $False
                                            Name = "SettingValueTemplateReference"
                                        }
                                        children = @(
                                            @{
                                            isArray = $True
                                            Name = "Children"
                                            }
                                        )
                                    }
                                    SettingInstanceTemplateReference = @{
                                        SettingInstanceTemplateId = "FakeStringValue"
                                    }
                                    simpleSettingValue = @{
                                        '@odata.type' = "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue"
                                        valueState = "invalid"
                                        value = 25
                                        SettingValueTemplateReference = @{
                                            isArray = $False
                                            Name = "SettingValueTemplateReference"
                                        }
                                        children = @(
                                            @{
                                            isArray = $True
                                            Name = "Children"
                                            }
                                        )
                                    }
                                    choiceSettingValue = @{
                                        SettingValueTemplateReference = @{
                                            isArray = $False
                                            Name = "SettingValueTemplateReference"
                                        }
                                        '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                        value = "FakeStringValue"
                                        children = @(
                                            @{
                                            isArray = $True
                                            Name = "Children"
                                            }
                                        )
                                    }
                                    groupSettingCollectionValue = @(
                                        @{
                                            '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                            Value = "FakeStringValue"
                                            SettingValueTemplateReference = @{
                                                isArray = $False
                                                Name = "SettingValueTemplateReference"
                                            }
                                            children = @(
                                                @{
                                                isArray = $True
                                                Name = "Children"
                                                }
                                            )
                                        }
                                    )
                                }
                            }
                        )
                        Technologies = "none"
                        TemplateReference = @{
                            TemplateId = "FakeStringValue"
                            TemplateDisplayVersion = "FakeStringValue"
                            TemplateDisplayName = "FakeStringValue"
                            TemplateFamily = "none"
                        }

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
