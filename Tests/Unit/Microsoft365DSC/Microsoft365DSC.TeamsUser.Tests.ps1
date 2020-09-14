[CmdletBinding()]
param(
)
$M365DSCTestFolder = Join-Path -Path $PSScriptRoot `
                        -ChildPath "..\..\Unit" `
                        -Resolve
$CmdletModule = (Join-Path -Path $M365DSCTestFolder `
            -ChildPath "\Stubs\Microsoft365.psm1" `
            -Resolve)
$GenericStubPath = (Join-Path -Path $M365DSCTestFolder `
    -ChildPath "\Stubs\Generic.psm1" `
    -Resolve)
Import-Module -Name (Join-Path -Path $M365DSCTestFolder `
        -ChildPath "\UnitTestHelper.psm1" `
        -Resolve)
$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource "TeamsUser" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString "Pass@word1)" -AsPlainText -Force
            $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credential"
            }
        }

        # Test contexts
        Context -Name "When the Team user doesnt exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    TeamName           = "TestTeam"
                    Role               = "Member"
                    User               = "JohnSmith@contoso.onmicrosoft.com"
                    Ensure             = "Present"
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }

                Mock -CommandName Get-TeamByName -MockWith {
                    return @{
                        DisplayName = "TestTeam"
                        GroupID     = "12345-12345-12345-12345-12345"
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

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be "Absent"
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Adds user to MS Team in the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "The user already exists" -Fixture {
            BeforeAll {
                $testParams = @{
                    TeamName           = "TestTeam"
                    User               = "JohnSmith@contoso.onmicrosoft.com"
                    Role               = "Owner"
                    Ensure             = "Present"
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }

                Mock -CommandName Get-TeamUser -MockWith {
                    return @{
                        GroupID = "12345-12345-12345-12345-12345"
                        Role    = "Member"
                        User    = "JohnSmith@contoso.onmicrosoft.com"
                    }
                }

                Mock -CommandName Get-TeamByName -MockWith {
                    return @{
                        DisplayName = "TestTeam"
                        GroupID     = "12345-12345-12345-12345-12345"
                    }
                }

                Mock -CommandName Add-TeamUser -MockWith {

                }
            }

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }
            it "Should set role to owner in set method" {
                Set-TargetResource @testParams
            }
            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }
        }

        Context -Name "The user already exists" -Fixture {
            BeforeAll {
                $testParams = @{
                    TeamName           = "TestTeam"
                    User               = "JohnSmith@contoso.onmicrosoft.com"
                    Role               = "Owner"
                    Ensure             = "Present"
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }

                Mock -CommandName Get-TeamUser -MockWith {
                    return @{
                        GroupID = "12345-12345-12345-12345-12345"
                        Role    = "Member"
                        User    = "JohnSmith@contoso.onmicrosoft.com"
                    }
                }

                Mock -CommandName Get-TeamByName -MockWith {
                    return @{
                        DisplayName = "TestTeam"
                        GroupID     = "12345-12345-12345-12345-12345"
                    }
                }

                Mock -CommandName Add-TeamUser -MockWith {

                }
            }

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }
            it "Should set role to owner in set method" {
                Set-TargetResource @testParams
            }
            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }
        }

        Context -Name "Failed to get team" -Fixture {
            BeforeAll {
                $testParams = @{
                    TeamName           = "TestTeam"
                    User               = "JohnSmith@contoso.onmicrosoft.com"
                    Role               = "Owner"
                    Ensure             = "Present"
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }

                Mock -CommandName Get-TeamByName -MockWith {
                    return @{
                        DisplayName = "TestTeam"
                        GroupID     = "12345-12345-12345-12345-12345"
                    }
                }

                Mock -CommandName Get-TeamUser -MockWith {
                    return $null
                }
            }

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be "Absent"
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }
        }

        Context -Name "Remove existing user from team" -Fixture {
            BeforeAll {
                $testParams = @{
                    TeamName           = "TestTeam"
                    User               = "JohnSmith@contoso.onmicrosoft.com"
                    Role               = "Member"
                    Ensure             = "Absent"
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }

                Mock -CommandName Get-TeamUser -MockWith {
                    return @{
                        GroupID = "12345-12345-12345-12345-12345"
                        Role    = "Member"
                        User    = "JohnSmith@contoso.onmicrosoft.com"
                    }
                }

                Mock -CommandName Get-TeamByName -MockWith {
                    return @{
                        DisplayName = "TestTeam"
                        GroupID     = "12345-12345-12345-12345-12345"
                    }
                }

                Mock -CommandName Remove-TeamUser -MockWith {
                    return $null
                }
            }

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }

            It "Should remove user from Team in set method" {
                Set-TargetResource @testParams
            }

        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount = $GlobalAdminAccount
                    MaxProcesses       = 16
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }

                Mock -CommandName Get-Team -MockWith {
                    return @(@{
                            DisplayName = "TestTeam"
                            GroupID     = "12345-12345-12345-12345-12345"
                        })
                }

                Mock -CommandName Get-TeamUser -MockWith {
                    return @{
                        User = "JohnSmith@contoso.onmicrosoft.com"
                    }
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
