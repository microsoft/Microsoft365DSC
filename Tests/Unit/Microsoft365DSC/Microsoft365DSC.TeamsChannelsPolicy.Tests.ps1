[CmdletBinding()]
param(
    [Parameter()]
    [string]
    $CmdletModule = (Join-Path -Path $PSScriptRoot `
            -ChildPath "..\Stubs\Microsoft365.psm1" `
            -Resolve)
)
$GenericStubPath = (Join-Path -Path $PSScriptRoot `
    -ChildPath "..\Stubs\Generic.psm1" `
    -Resolve)
Import-Module -Name (Join-Path -Path $PSScriptRoot `
        -ChildPath "..\UnitTestHelper.psm1" `
        -Resolve)

$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource "TeamsChannelsPolicy" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "Pass@word1)" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-MSCloudLogin -MockWith {
        }

        Mock -CommandName New-CsTeamsChannelsPolicy -MockWith {
        }

        Mock -CommandName Set-CsTeamsChannelsPolicy -MockWith {
        }

        Mock -CommandName Remove-CsTeamsChannelsPolicy -MockWith {
        }

        # Test contexts
        Context -Name "When Channel Policy doesn't exist but should" -Fixture {
            $testParams = @{
                Identity                    = 'Test Channels Policy'
                Description                 = 'Test Description'
                AllowOrgWideTeamCreation    = $True;
                AllowPrivateChannelCreation = $True;
                AllowPrivateTeamDiscovery   = $True;
                Ensure                      = 'Present'
                GlobalAdminAccount          = $GlobalAdminAccount
            }

            Mock -CommandName Get-CsTeamsChannelsPolicy -MockWith {
                return $null
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be 'Absent'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Should create the policy in the Set method" {
                Set-TargetResource @testParams
                Assert-MockCalled -CommandName New-CsTeamsChannelsPolicy -Exactly 1
            }
        }

        Context -Name "Policy exists but is not in the Desired State" -Fixture {
            $testParams = @{
                Identity                    = 'Test Channels Policy'
                Description                 = 'Test Description'
                AllowOrgWideTeamCreation    = $True;
                AllowPrivateChannelCreation = $True;
                AllowPrivateTeamDiscovery   = $True;
                Ensure                      = 'Present'
                GlobalAdminAccount          = $GlobalAdminAccount
            }

            Mock -CommandName Get-CsTeamsChannelsPolicy -MockWith {
                return @{
                    Identity                    = 'Test Channels Policy'
                    Description                 = 'Test Description'
                    AllowOrgWideTeamCreation    = $False;
                    AllowPrivateChannelCreation = $True;
                    AllowPrivateTeamDiscovery   = $True;
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be 'Present'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Should update the settings from the Set method" {
                Set-TargetResource @testParams
                Assert-MockCalled -CommandName Set-CsTeamsChannelsPolicy -Exactly 1
                Assert-MockCalled -CommandName New-CSTeamsChannelsPolicy -Exactly 0
            }
        }

        Context -Name "Policy exists and is already in the Desired State" -Fixture {
            $testParams = @{
                Identity                    = 'Test Channels Policy'
                Description                 = 'Test Description'
                AllowOrgWideTeamCreation    = $True;
                AllowPrivateChannelCreation = $True;
                AllowPrivateTeamDiscovery   = $True;
                Ensure                      = 'Present'
                GlobalAdminAccount          = $GlobalAdminAccount
            }

            Mock -CommandName Get-CsTeamsChannelsPolicy -MockWith {
                return @{
                    Identity                    = 'Test Channels Policy'
                    Description                 = 'Test Description'
                    AllowOrgWideTeamCreation    = $True;
                    AllowPrivateChannelCreation = $True;
                    AllowPrivateTeamDiscovery   = $True;
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be 'Present'
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should Be $true
            }
        }

        Context -Name "Policy exists but it should not" -Fixture {
            $testParams = @{
                Identity                    = 'Test Channels Policy'
                Description                 = 'Test Description'
                AllowOrgWideTeamCreation    = $True;
                AllowPrivateChannelCreation = $True;
                AllowPrivateTeamDiscovery   = $True;
                Ensure                      = 'Absent'
                GlobalAdminAccount          = $GlobalAdminAccount
            }

            Mock -CommandName Get-CsTeamsChannelsPolicy -MockWith {
                return @{
                    Identity                    = 'Test Channels Policy'
                    Description                 = 'Test Description'
                    AllowOrgWideTeamCreation    = $True;
                    AllowPrivateChannelCreation = $True;
                    AllowPrivateTeamDiscovery   = $True;
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be 'Present'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Should remove the policy from the Set method" {
                Set-TargetResource @testParams
                Assert-MockCalled -CommandName Remove-CsTeamsChannelsPolicy -Exactly 1
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-CsTeamsChannelsPolicy -MockWith {
                return @{
                    Identity                    = 'Test Channels Policy'
                    Description                 = 'Test Description'
                    AllowOrgWideTeamCreation    = $True;
                    AllowPrivateChannelCreation = $True;
                    AllowPrivateTeamDiscovery   = $True;
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
