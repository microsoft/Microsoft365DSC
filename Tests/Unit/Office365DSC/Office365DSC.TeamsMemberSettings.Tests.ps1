[CmdletBinding()]
param(
    [Parameter()]
    [string]
    $CmdletModule = (Join-Path -Path $PSScriptRoot `
            -ChildPath "..\Stubs\Office365.psm1" `
            -Resolve)
)

Import-Module -Name (Join-Path -Path $PSScriptRoot `
        -ChildPath "..\UnitTestHelper.psm1" `
        -Resolve)

$Global:DscHelper = New-O365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource "TeamsMemberSettings"

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "Pass@word1)" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-TeamsServiceConnection -MockWith {
        }

        # Test contexts
        Context -Name "Check Team Member settings" -Fixture {
            $testParams = @{
                TeamName                          = "TestTeam"
                AllowCreateUpdateChannels         = $true
                AllowDeleteChannels               = $true
                AllowAddRemoveApps                = $true
                AllowCreateUpdateRemoveTabs       = $true
                AllowCreateUpdateRemoveConnectors = $true
                Ensure                            = "Present"
                GlobalAdminAccount                = $GlobalAdminAccount
            }

            Mock -CommandName Set-TeamMemberSettings -MockWith {
                return @{AllowCreateUpdateChannels    = $null
                    AllowDeleteChannels               = $null
                    AllowAddRemoveApps                = $null
                    AllowCreateUpdateRemoveTabs       = $null
                    AllowCreateUpdateRemoveConnectors = $null
                }
            }

            Mock -CommandName Get-Team -MockWith {
                return @{
                    DisplayName = "TestTeam"
                    GroupID     = "12345-12345-12345-12345-12345"
                }
            }

            Mock -CommandName Get-TeamMemberSettings -MockWith {
                return $null
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent"
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Updates the Team fun settings in the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "Check Team Member settings" -Fixture {
            $testParams = @{
                TeamName                          = "TestTeam"
                AllowCreateUpdateChannels         = $false
                AllowDeleteChannels               = $false
                AllowAddRemoveApps                = $false
                AllowCreateUpdateRemoveTabs       = $false
                AllowCreateUpdateRemoveConnectors = $false
                Ensure                            = "Present"
                GlobalAdminAccount                = $GlobalAdminAccount
            }

            Mock -CommandName Set-TeamMemberSettings -MockWith {
                return @{AllowCreateUpdateChannels    = $true
                    AllowDeleteChannels               = $true
                    AllowAddRemoveApps                = $true
                    AllowCreateUpdateRemoveTabs       = $true
                    AllowCreateUpdateRemoveConnectors = $true
                }
            }

            Mock -CommandName Get-Team -MockWith {
                return @{
                    DisplayName = "TestTeam"
                    GroupID     = "12345-12345-12345-12345-12345"
                }
            }

            Mock -CommandName Get-TeamMemberSettings -MockWith {
                return @{AllowCreateUpdateChannels    = $true
                    AllowDeleteChannels               = $true
                    AllowAddRemoveApps                = $true
                    AllowCreateUpdateRemoveTabs       = $true
                    AllowCreateUpdateRemoveConnectors = $true
                }
            }

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Updates the Team fun settings in the Set method" {
                Set-TargetResource @testParams
            }
        }


        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                TeamName           = "TestTeam"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-Team -MockWith {
                return @{
                    DisplayName = "TestTeam"
                    GroupID     = "12345-12345-12345-12345-12345"
                }
            }

            Mock -CommandName Get-TeamMemberSettings -MockWith {
                return @{
                    DisplayName = "TestTeam"
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }

        }
    }


Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
