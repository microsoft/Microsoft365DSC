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
    -DscResource 'SCSensitivityLabel' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Import-PSSession -MockWith {
            }

            Mock -CommandName New-PSSession -MockWith {
            }

            Mock -CommandName Remove-Label -MockWith {
            }

            Mock -CommandName New-Label -MockWith {
                return @{

                }
            }

            Mock -CommandName Set-Label -MockWith {
                return @{

                }
            }

            Mock -CommandName Start-Sleep -MockWith {
            }

            Mock -CommandName Get-DlpSensitiveInformationType -MockWith {
                return @(
                    [PSCustomObject]@{Name = 'ABA Routing Number'; Id = 'cb353f78-2b72-4c3c-8827-92ebe4f69fdf'; RulePackId = '00000000-0000-0000-0000-000000000000' },
                    [PSCustomObject]@{Name = 'All Full Names'; Id = '50b8b56b-4ef8-44c2-a924-03374f5831ce'; RulePackId = '00000000-0000-0000-0000-000000000004' }
                )
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name "Label doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    Name             = 'TestLabel'
                    Comment          = 'This is a test label'
                    Tooltip          = 'Test tool tip'
                    DisplayName      = 'Test label'
                    ParentId         = 'TestLabel'
                    AdvancedSettings = (New-CimInstance -ClassName MSFT_SCLabelSetting -Property @{
                            Key   = 'LabelStatus'
                            Value = 'Enabled'
                        } -ClientOnly)
                    LocaleSettings   = (New-CimInstance -ClassName MSFT_SCLabelLocaleSettings -Property @{
                            LocaleKey     = 'DisplayName'
                            LabelSettings = (New-CimInstance -ClassName MSFT_SCLabelSetting -Property @{
                                    Key   = 'en-us'
                                    Value = 'English DisplayName'
                                } -ClientOnly)
                        } -ClientOnly)
                    AutoLabelingSettings = New-CimInstance -ClassName MSFT_SCSLAutoLabelingSettings -Property @{
                        Operator      = 'And'
                        AutoApplyType = 'Recommend'
                        PolicyTip     = 'My Perfect Test Tip!'
                        Groups        = [CimInstance[]]@(
                            New-CimInstance -ClassName MSFT_SCSLSensitiveInformationGroup -Property @{
                                Name = 'Group1'
                                Operator = 'Or'
                                SensitiveInformationType = [CimInstance[]]@(
                                    New-CimInstance -ClassName MSFT_SCSLSensitiveInformationType -Property @{
                                        name = 'ABA Routing Number'
                                        confidencelevel = 'High'
                                        mincount = 1
                                        maxcount = -1
                                    } -ClientOnly
                                )
                                TrainableClassifier = [CimInstance[]]@(
                                    New-CimInstance -ClassName MSFT_SCSLTrainableClassifiers -Property @{
                                        name = 'Legal Affairs'
                                    } -ClientOnly
                                )
                            } -ClientOnly
                            New-CimInstance -ClassName MSFT_SCSLSensitiveInformationGroup -Property @{
                                Name = 'Group2'
                                Operator = 'And'
                                SensitiveInformationType = [CimInstance[]]@(
                                    New-CimInstance -ClassName MSFT_SCSLSensitiveInformationType -Property @{
                                        name = 'All Full Names'
                                        confidencelevel = 'High'
                                        mincount = 10
                                        maxcount = 100
                                    } -ClientOnly
                                )
                                TrainableClassifier = [CimInstance[]]@(
                                    New-CimInstance -ClassName MSFT_SCSLTrainableClassifiers -Property @{
                                        name = 'Legal Affairs'
                                    } -ClientOnly
                                )
                            } -ClientOnly
                        )
                    } -ClientOnly
                    Credential       = $Credential
                    Ensure           = 'Present'
                }

                Mock -CommandName Get-Label -MockWith {
                    return $null
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'Label already exists, but is incorrectly configured' -Fixture {
            BeforeAll {
                $testParams = @{
                    Name             = 'TestLabel'
                    Comment          = 'This is a test label'
                    ToolTip          = 'Test tool tip'
                    DisplayName      = 'Test label'
                    ParentId         = 'MyLabel'

                    AdvancedSettings = (New-CimInstance -ClassName MSFT_SCLabelSetting -Property @{
                            Key   = 'LabelStatus'
                            Value = 'Enabled'
                        } -ClientOnly)

                    LocaleSettings   = (New-CimInstance -ClassName MSFT_SCLabelLocaleSettings -Property @{
                            LocaleKey     = 'DisplayName'
                            LabelSettings = (New-CimInstance -ClassName MSFT_SCLabelSetting -Property @{
                                    Key   = 'en-us'
                                    Value = 'English DisplayName'
                                } -ClientOnly)
                        } -ClientOnly)

                    AutoLabelingSettings = New-CimInstance -ClassName MSFT_SCSLAutoLabelingSettings -Property @{
                            Operator      = 'And'
                            AutoApplyType = 'Recommend'
                            PolicyTip     = 'My Perfect Test Tip!'
                            Groups        = [CimInstance[]]@(
                                New-CimInstance -ClassName MSFT_SCSLSensitiveInformationGroup -Property @{
                                    Name = 'Group1'
                                    Operator = 'Or'
                                    SensitiveInformationType = [CimInstance[]]@(
                                        New-CimInstance -ClassName MSFT_SCSLSensitiveInformationType -Property @{
                                            name = 'ABA Routing Number'
                                            confidencelevel = 'High'
                                            mincount = 1
                                            maxcount = -1
                                        } -ClientOnly
                                    )
                                    TrainableClassifier = [CimInstance[]]@(
                                        New-CimInstance -ClassName MSFT_SCSLTrainableClassifiers -Property @{
                                            name = 'Legal Affairs'
                                        } -ClientOnly
                                    )
                                } -ClientOnly
                                New-CimInstance -ClassName MSFT_SCSLSensitiveInformationGroup -Property @{
                                    Name = 'Group2'
                                    Operator = 'And'
                                    SensitiveInformationType = [CimInstance[]]@(
                                        New-CimInstance -ClassName MSFT_SCSLSensitiveInformationType -Property @{
                                            name = 'All Full Names'
                                            confidencelevel = 'High'
                                            mincount = 1
                                            maxcount = 100
                                        } -ClientOnly
                                    )
                                    TrainableClassifier = [CimInstance[]]@(
                                        New-CimInstance -ClassName MSFT_SCSLTrainableClassifiers -Property @{
                                            name = 'Legal Affairs'
                                        } -ClientOnly
                                    )
                                } -ClientOnly
                            )
                        } -ClientOnly

                    Credential       = $Credential
                    Ensure           = 'Present'
                }

                Mock -CommandName Get-Label -MockWith {
                    return @{
                        Name           = 'TestLabel'
                        Comment        = 'Updated comment'
                        ToolTip        = 'Test tool tip'
                        DisplayName    = 'Test label'
                        ParentId       = 'MyLabel'
                        Priority       = '2'
                        Settings       = '[LabelStatus, Enabled]'
                        LocaleSettings = '{"LocaleKey":"DisplayName","Settings":[{"Key":"en-us","Value":"English Display Names"}]}'
                        Conditions     = '{"And":[{"Or":[{"Key":"CCSI","Value":"cb353f78-2b72-4c3c-8827-92ebe4f69fdf","Properties":null,"Settings":[{"Key":"mincount","Value":"1"},{"Key":"maxconfidence","Value":"100"},{"Key":"rulepackage","Value":"00000000-0000-0000-0000-000000000000"},{"Key":"name","Value":"ABA Routing Number"},{"Key":"groupname","Value":"Group1"},{"Key":"minconfidence","Value":"85"},{"Key":"maxcount","Value":"-1"},{"Key":"policytip","Value":"My Perfect Test Tip!"},{"Key":"confidencelevel","Value":"High"},{"Key":"autoapplytype","Value":"Recommend"}]},{"Key":"ContentMatchesModule","Value":"ba38aa0f-8c86-4c73-87db-95147a0f4420","Properties":null,"Settings":[{"Key":"name","Value":"Legal Affairs"},{"Key":"groupname","Value":"Group1"},{"Key":"policytip","Value":"My Perfect Test Tip!"},{"Key":"autoapplytype","Value":"Recommend"}]}]},{"And":[{"Key":"CCSI","Value":"50b8b56b-4ef8-44c2-a924-03374f5831ce","Properties":null,"Settings":[{"Key":"mincount","Value":"10"},{"Key":"maxconfidence","Value":"100"},{"Key":"rulepackage","Value":"00000000-0000-0000-0000-000000000004"},{"Key":"name","Value":"All Full Names"},{"Key":"groupname","Value":"Group2"},{"Key":"minconfidence","Value":"85"},{"Key":"maxcount","Value":"100"},{"Key":"policytip","Value":"My Perfect Test Tip!"},{"Key":"confidencelevel","Value":"High"},{"Key":"autoapplytype","Value":"Recommend"}]},{"Key":"ContentMatchesModule","Value":"ba38aa0f-8c86-4c73-87db-95147a0f4420","Properties":null,"Settings":[{"Key":"name","Value":"Legal Affairs"},{"Key":"groupname","Value":"Group2"},{"Key":"policytip","Value":"My Perfect Test Tip!"},{"Key":"autoapplytype","Value":"Recommend"}]}]}]}'
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should update from the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
        }

        Context -Name 'Label already exists and is correctly configured' -Fixture {
            BeforeAll {
                $testParams = @{
                    Name             = 'TestLabel'
                    Comment          = 'This is a test label'
                    ToolTip          = 'Test tool tip'
                    DisplayName      = 'Test label'
                    ParentId         = 'MyLabel'

                    AdvancedSettings = (New-CimInstance -ClassName MSFT_SCLabelSetting -Property @{
                            Key   = 'LabelStatus'
                            Value = 'Enabled'
                        } -ClientOnly)

                    LocaleSettings   = (New-CimInstance -ClassName MSFT_SCLabelLocaleSettings -Property @{
                            LocaleKey     = 'DisplayName'
                            LabelSettings = (New-CimInstance -ClassName MSFT_SCLabelSetting -Property @{
                                    Key   = 'en-us'
                                    Value = 'English Display Names'
                                } -ClientOnly)
                        } -ClientOnly)

                    AutoLabelingSettings = New-CimInstance -ClassName MSFT_SCSLAutoLabelingSettings -Property @{
                            Operator      = 'And'
                            AutoApplyType = 'Recommend'
                            PolicyTip     = 'My Perfect Test Tip!'
                            Groups        = [CimInstance[]]@(
                                New-CimInstance -ClassName MSFT_SCSLSensitiveInformationGroup -Property @{
                                    Name = 'Group1'
                                    Operator = 'Or'
                                    SensitiveInformationType = [CimInstance[]]@(
                                        New-CimInstance -ClassName MSFT_SCSLSensitiveInformationType -Property @{
                                            name = 'ABA Routing Number'
                                            confidencelevel = 'High'
                                            mincount = 1
                                            maxcount = -1
                                        } -ClientOnly
                                    )
                                    TrainableClassifier = [CimInstance[]]@(
                                        New-CimInstance -ClassName MSFT_SCSLTrainableClassifiers -Property @{
                                            name = 'Legal Affairs'
                                        } -ClientOnly
                                    )
                                } -ClientOnly
                                New-CimInstance -ClassName MSFT_SCSLSensitiveInformationGroup -Property @{
                                    Name = 'Group2'
                                    Operator = 'And'
                                    SensitiveInformationType = [CimInstance[]]@(
                                        New-CimInstance -ClassName MSFT_SCSLSensitiveInformationType -Property @{
                                            name = 'All Full Names'
                                            confidencelevel = 'High'
                                            mincount = 10
                                            maxcount = 100
                                        } -ClientOnly
                                    )
                                    TrainableClassifier = [CimInstance[]]@(
                                        New-CimInstance -ClassName MSFT_SCSLTrainableClassifiers -Property @{
                                            name = 'Legal Affairs'
                                        } -ClientOnly
                                    )
                                } -ClientOnly
                            )
                        } -ClientOnly

                    Credential       = $Credential
                    Ensure           = 'Present'
                }

                Mock -CommandName Get-Label -MockWith {
                    return @{
                        Name           = 'TestLabel'
                        Comment        = 'This is a test label'
                        ToolTip        = 'Test tool tip'
                        DisplayName    = 'Test label'
                        ParentId       = 'MyLabel'
                        Priority       = '2'
                        Settings       = '[LabelStatus, Enabled]'
                        LocaleSettings = '{"LocaleKey":"DisplayName","Settings":[{"Key":"en-us","Value":"English Display Names"}]}'
                        Conditions     = '{"And":[{"Or":[{"Key":"CCSI","Value":"cb353f78-2b72-4c3c-8827-92ebe4f69fdf","Properties":null,"Settings":[{"Key":"mincount","Value":"1"},{"Key":"maxconfidence","Value":"100"},{"Key":"rulepackage","Value":"00000000-0000-0000-0000-000000000000"},{"Key":"name","Value":"ABA Routing Number"},{"Key":"groupname","Value":"Group1"},{"Key":"minconfidence","Value":"85"},{"Key":"maxcount","Value":"-1"},{"Key":"policytip","Value":"My Perfect Test Tip!"},{"Key":"confidencelevel","Value":"High"},{"Key":"autoapplytype","Value":"Recommend"}]},{"Key":"ContentMatchesModule","Value":"ba38aa0f-8c86-4c73-87db-95147a0f4420","Properties":null,"Settings":[{"Key":"name","Value":"Legal Affairs"},{"Key":"groupname","Value":"Group1"},{"Key":"policytip","Value":"My Perfect Test Tip!"},{"Key":"autoapplytype","Value":"Recommend"}]}]},{"And":[{"Key":"CCSI","Value":"50b8b56b-4ef8-44c2-a924-03374f5831ce","Properties":null,"Settings":[{"Key":"mincount","Value":"10"},{"Key":"maxconfidence","Value":"100"},{"Key":"rulepackage","Value":"00000000-0000-0000-0000-000000000004"},{"Key":"name","Value":"All Full Names"},{"Key":"groupname","Value":"Group2"},{"Key":"minconfidence","Value":"85"},{"Key":"maxcount","Value":"100"},{"Key":"policytip","Value":"My Perfect Test Tip!"},{"Key":"confidencelevel","Value":"High"},{"Key":"autoapplytype","Value":"Recommend"}]},{"Key":"ContentMatchesModule","Value":"ba38aa0f-8c86-4c73-87db-95147a0f4420","Properties":null,"Settings":[{"Key":"name","Value":"Legal Affairs"},{"Key":"groupname","Value":"Group2"},{"Key":"policytip","Value":"My Perfect Test Tip!"},{"Key":"autoapplytype","Value":"Recommend"}]}]}]}'
                    }
                } -ParameterFilter { $Identity -eq 'TestLabel' }

                Mock -CommandName Get-Label -MockWith {
                    return @{
                        Name           = 'MyLabel'
                    }
                } -ParameterFilter { $Identity -eq 'MyLabel' }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'Label should not exist' -Fixture {
            BeforeAll {
                $testParams = @{
                    Name       = 'TestLabel'
                    ParentId   = 'MyLabel'
                    Credential = $Credential
                    Ensure     = 'Absent'
                }
            }

            It 'Should return false from the Test method' {

                Mock -CommandName Get-Label -MockWith {
                    return @{
                        Name     = 'TestLabel'
                        ParentId = 'MyLabel'
                    }
                }
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should delete from the Set method' {
                Mock -CommandName Get-Label -MockWith {
                    $null
                }
                Set-TargetResource @testParams
            }

            It 'Should return Absent from the Get method' {
                Mock -CommandName Get-Label -MockWith {
                    $null
                }
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }
                Mock -CommandName Get-Label -MockWith {
                    return @{
                        Name           = 'TestRule'
                        Settings       = '{"Key": "LabelStatus",
                                            "Value": "Enabled"}'
                        LocaleSettings = '{"LocaleKey":"DisplayName",
                                            "LabelSettings":[
                                            {"Key":"en-us","Value":"English Display Names"}]}'
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
