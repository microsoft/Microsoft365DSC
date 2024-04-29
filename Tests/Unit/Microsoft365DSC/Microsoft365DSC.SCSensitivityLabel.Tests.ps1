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

        Context -Name 'Label already exists' -Fixture {
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
                        Settings       = '{"Key": "LabelStatus",
                                            "Value": "Enabled"}'
                        LocaleSettings = '{"LocaleKey":"DisplayName",
                                            "LabelSettings":[
                                            {"Key":"en-us","Value":"English Display Names"}]}'
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
