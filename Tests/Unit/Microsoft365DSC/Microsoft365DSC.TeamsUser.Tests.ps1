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
    -DscResource 'TeamsUser' -GenericStubModule $GenericStubPath

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

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }

        # Test contexts
        Context -Name 'When the Team user doesnt exist' -Fixture {
            BeforeAll {
                $testParams = @{
                    TeamName   = 'TestTeam'
                    Role       = 'Member'
                    User       = 'JohnSmith@contoso.onmicrosoft.com'
                    Ensure     = 'Present'
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

                Mock -CommandName Add-TeamUser -MockWith {
                    return @{
                        User = $null
                    }
                }

                Mock -CommandName Get-TeamUser -MockWith {
                    return $null
                }
            }

            It 'Should return absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Adds user to MS Team in the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'The user already exists' -Fixture {
            BeforeAll {
                $testParams = @{
                    TeamName   = 'TestTeam'
                    User       = 'JohnSmith@contoso.onmicrosoft.com'
                    Role       = 'Owner'
                    Ensure     = 'Present'
                    Credential = $Credential
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Get-TeamUser -MockWith {
                    return @{
                        GroupID = '12345-12345-12345-12345-12345'
                        Role    = 'Member'
                        User    = 'JohnSmith@contoso.onmicrosoft.com'
                    }
                }

                Mock -CommandName Get-TeamByName -MockWith {
                    return @{
                        DisplayName = 'TestTeam'
                        GroupID     = '12345-12345-12345-12345-12345'
                    }
                }

                Mock -CommandName Add-TeamUser -MockWith {

                }
            }

            It 'Should return present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
            It 'Should set role to owner in set method' {
                Set-TargetResource @testParams
            }
            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
        }

        Context -Name 'The user already exists' -Fixture {
            BeforeAll {
                $testParams = @{
                    TeamName   = 'TestTeam'
                    User       = 'JohnSmith@contoso.onmicrosoft.com'
                    Role       = 'Owner'
                    Ensure     = 'Present'
                    Credential = $Credential
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Get-TeamUser -MockWith {
                    return @{
                        GroupID = '12345-12345-12345-12345-12345'
                        Role    = 'Member'
                        User    = 'JohnSmith@contoso.onmicrosoft.com'
                    }
                }

                Mock -CommandName Get-TeamByName -MockWith {
                    return @{
                        DisplayName = 'TestTeam'
                        GroupID     = '12345-12345-12345-12345-12345'
                    }
                }

                Mock -CommandName Add-TeamUser -MockWith {

                }
            }

            It 'Should return present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
            It 'Should set role to owner in set method' {
                Set-TargetResource @testParams
            }
            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
        }

        Context -Name 'Failed to get team' -Fixture {
            BeforeAll {
                $testParams = @{
                    TeamName   = 'TestTeam'
                    User       = 'JohnSmith@contoso.onmicrosoft.com'
                    Role       = 'Owner'
                    Ensure     = 'Present'
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

                Mock -CommandName Get-TeamUser -MockWith {
                    return $null
                }
            }

            It 'Should return present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
        }

        Context -Name 'Remove existing user from team' -Fixture {
            BeforeAll {
                $testParams = @{
                    TeamName   = 'TestTeam'
                    User       = 'JohnSmith@contoso.onmicrosoft.com'
                    Role       = 'Member'
                    Ensure     = 'Absent'
                    Credential = $Credential
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Get-TeamUser -MockWith {
                    return @{
                        GroupID = '12345-12345-12345-12345-12345'
                        Role    = 'Member'
                        User    = 'JohnSmith@contoso.onmicrosoft.com'
                    }
                }

                Mock -CommandName Get-TeamByName -MockWith {
                    return @{
                        DisplayName = 'TestTeam'
                        GroupID     = '12345-12345-12345-12345-12345'
                    }
                }

                Mock -CommandName Remove-TeamUser -MockWith {
                    return $null
                }
            }

            It 'Should return present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should remove user from Team in set method' {
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

                Mock -CommandName Get-Team -MockWith {
                    return @(@{
                            DisplayName = 'TestTeam'
                            GroupID     = '12345-12345-12345-12345-12345'
                        })
                }

                Mock -CommandName Get-TeamUser -MockWith {
                    return @{
                        User = 'JohnSmith@contoso.onmicrosoft.com'
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
