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
    -DscResource "TeamsUser"

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "Pass@word1)" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-TeamsServiceConnection -MockWith {
        }

        # Test contexts
        Context -Name "When the Team user doesnt exist" -Fixture {
            $testParams = @{
                TeamName           = "TestTeam"
                Role               = "Member"
                User               = "JohnSmith@contoso.onmicrosoft.com"
                Ensure             = "Present"
                GlobalAdminAccount = $GlobalAdminAccount
            }


            Mock -CommandName Get-TeamByName -MockWith {
                return @{
                    DisplayName = "TestTeam"
                    GroupID     = "12345-12345-12345-12345-12345"
                }
            }

            Mock -CommandName Add-TeamUser -MockWith {
                return @{User = $null}
            }

            Mock -CommandName Get-TeamUser -MockWith {
                return $null
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent"
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Adds user to MS Team in the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "The user already exists" -Fixture {
            $testParams = @{
                TeamName           = "TestTeam"
                User               = "JohnSmith@contoso.onmicrosoft.com"
                Role               = "Owner"
                Ensure             = "Present"
                GlobalAdminAccount = $GlobalAdminAccount
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

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }
            it "Should set role to owner in set method" {
                Set-TargetResource @testParams
            }
            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }
        }

        Context -Name "The user already exists" -Fixture {
            $testParams = @{
                TeamName           = "TestTeam"
                User               = "JohnSmith@contoso.onmicrosoft.com"
                Role               = "Owner"
                Ensure             = "Present"
                GlobalAdminAccount = $GlobalAdminAccount
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

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }
            it "Should set role to owner in set method" {
                Set-TargetResource @testParams
            }
            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }
        }

        Context -Name "Failed to get team" -Fixture {
            $testParams = @{
                TeamName           = "TestTeam"
                User               = "JohnSmith@contoso.onmicrosoft.com"
                Role               = "Owner"
                Ensure             = "Present"
                GlobalAdminAccount = $GlobalAdminAccount
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

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent"
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }
        }

        Context -Name "Remove existing user from team" -Fixture {
            $testParams = @{
                TeamName           = "TestTeam"
                User               = "JohnSmith@contoso.onmicrosoft.com"
                Role               = "Member"
                Ensure             = "Absent"
                GlobalAdminAccount = $GlobalAdminAccount
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

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }
            it "Should remove user from Team in set method" {
                Set-TargetResource @testParams
            }

        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                TeamName           = "TestTeam"
                User               = "JohnSmith@contoso.onmicrosoft.com"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-TeamByName -MockWith {
                return @{
                    DisplayName = "TestTeam"
                    GroupID     = "12345-12345-12345-12345-12345"
                }
            }

            Mock -CommandName Get-TeamUser -MockWith {
                return @{
                    User = "JohnSmith@contoso.onmicrosoft.com"
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
