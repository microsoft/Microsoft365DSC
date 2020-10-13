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
    -DscResource "TeamsUpgradeConfiguration" -GenericStubModule $GenericStubPath

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

            Mock -CommandName Get-CsTeamsUpgradeConfiguration -MockWith {
            }
        }

        # Test contexts
        Context -Name "When Settings are already in the Desired State" -Fixture {
            BeforeAll {
                $testParams = @{
                    DownloadTeams      = $True;
                    GlobalAdminAccount = $GlobalAdminAccount;
                    IsSingleInstance   = "Yes";
                    SfBMeetingJoinUx   = "NativeLimitedClient";
                }

                Mock -CommandName Get-CsTeamsUpgradeConfiguration -MockWith {
                    return @{
                        DownloadTeams    = $True;
                        SfBMeetingJoinUx = "NativeLimitedClient";
                    }
                }
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).DownloadTeams | Should -Be $true
                (Get-TargetResource @testParams).SfbMeetingJoinUx | Should -Be "NativeLimitedClient"
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "When Settings are NOT in the Desired State" -Fixture {
            BeforeAll {
                $testParams = @{
                    DownloadTeams      = $False;
                    GlobalAdminAccount = $GlobalAdminAccount;
                    IsSingleInstance   = "Yes";
                    SfBMeetingJoinUx   = "NativeLimitedClient";
                }

                Mock -CommandName Get-CsTeamsUpgradeConfiguration -MockWith {
                    return @{
                        DownloadTeams    = $True;
                        SfBMeetingJoinUx = "NativeLimitedClient";
                    }
                }
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).DownloadTeams | Should -Be $true
                (Get-TargetResource @testParams).SfbMeetingJoinUx | Should -Be "NativeLimitedClient"
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should update the settings from the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName Get-CsTeamsUpgradeConfiguration -MockWith {
                    return @{
                        DownloadTeams    = $True;
                        SfBMeetingJoinUx = "NativeLimitedClient";
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
