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
    -DscResource 'TeamsChannel' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'Pass@word1)' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            $Global:PartialExportFileName = 'c:\TestPath'

            Mock -CommandName Save-M365DSCPartialExport -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Set-TeamChannel -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name "When a channel doesn't exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    TeamName    = 'TestTeam'
                    DisplayName = 'Test Channel'
                    Description = 'Test description'
                    Credential  = $Credential
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Get-TeamByName -MockWith {
                    return @{
                        DisplayName = 'TestTeam'
                        GroupID     = '12345-12345-12345-12345-12345'
                    }
                }

                Mock -CommandName Get-TeamChannel -MockWith {
                    return @{
                        DisplayName = 'TestTeam'
                        GroupID     = '12345-12345-12345-12345-12345'
                    }
                }

                Mock -CommandName Get-Team -MockWith {
                    return @{
                        DisplayName = 'TestTeam'
                        GroupID     = '12345-12345-12345-12345-12345'
                    }
                }

                Mock -CommandName New-TeamChannel -MockWith {
                    return @{GroupID = $null
                    }
                }
            }

            It 'Should return absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Creates the MS Team channel in the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'Channel already exists' -Fixture {
            BeforeAll {
                $testParams = @{
                    TeamName    = 'TestTeam'
                    DisplayName = 'Test Channel'
                    Ensure      = 'Present'
                    Credential  = $Credential
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Get-TeamByName -MockWith {
                    return @{
                        DisplayName = 'TestTeam'
                        GroupID     = '12345-12345-12345-12345-12345'
                    }
                }

                Mock -CommandName Get-TeamChannel -MockWith {
                    return @{
                        GroupID     = '12345-12345-12345-12345-12345'
                        DisplayName = 'Test Channel'
                    }
                }

                Mock -CommandName Get-Team -MockWith {
                    return @{
                        DisplayName = 'TestTeam'
                        GroupID     = '12345-12345-12345-12345-12345'
                    }
                }
            }

            It 'Should return present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'Rename existing channel' -Fixture {
            BeforeAll {
                $testParams = @{
                    TeamName       = 'TestTeam'
                    DisplayName    = 'Test Channel'
                    Ensure         = 'Present'
                    NewDisplayName = 'Test Channel Updated'
                    Credential     = $Credential
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Get-TeamByName -MockWith {
                    return @{
                        DisplayName = 'TestTeam'
                        GroupID     = '12345-12345-12345-12345-12345'
                    }
                }

                Mock -CommandName Get-TeamChannel -MockWith {
                    return @{
                        GroupID     = '12345-12345-12345-12345-12345'
                        DisplayName = 'Test Channel'
                    }
                }

                Mock -CommandName Get-Team -MockWith {
                    return @{
                        DisplayName = 'TestTeam'
                        GroupID     = '12345-12345-12345-12345-12345'
                    }
                }
            }

            It 'Should return present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Renames existing channel in the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'Remove existing channel' -Fixture {
            BeforeAll {
                $testParams = @{
                    TeamName    = 'TestTeam'
                    DisplayName = 'Test Channel'
                    Ensure      = 'Absent'
                    Credential  = $Credential
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Get-TeamByName -MockWith {
                    return @{
                        DisplayName = 'TestTeam'
                        GroupID     = '12345-12345-12345-12345-12345'
                    }
                }

                Mock -CommandName Remove-TeamChannel -MockWith {
                    return $null
                }

                Mock -CommandName Get-Team -MockWith {
                    return @{
                        DisplayName = 'TestTeam'
                        GroupID     = '12345-12345-12345-12345-12345'
                    }
                }

                Mock -CommandName Get-TeamChannel -MockWith {
                    return @{
                        TeamName    = 'TestTeam'
                        DisplayName = 'Test Channel'
                    }
                }
            }

            It 'Should return present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Remove channel in the Set method' {
                Set-TargetResource @testParams
            }

        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Get-TeamByName -MockWith {
                    return @{
                        DisplayName = 'TestTeam'
                        GroupID     = '12345-12345-12345-12345-12345'
                    }
                }

                Mock -CommandName Get-Team -MockWith {
                    return @{
                        DisplayName = 'TestTeam'
                        GroupID     = '12345-12345-12345-12345-12345'
                    }
                }

                Mock -CommandName Get-TeamChannel -MockWith {
                    return @{
                        DisplayName = 'Test Channel'
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
