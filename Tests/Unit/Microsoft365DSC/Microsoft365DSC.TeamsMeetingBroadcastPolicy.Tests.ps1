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
    -DscResource "TeamsMeetingBroadcastPolicy" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString "Pass@word1" -AsPlainText -Force
            $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credential"
            }
            Mock -CommandName Get-CsTeamsMeetingBroadcastPolicy -MockWith {
                return @(@{
                    AllowBroadcastScheduling        = $True;
                    AllowBroadcastTranscription     = $False;
                    BroadcastAttendeeVisibilityMode = "EveryoneInCompany";
                    BroadcastRecordingMode          = "AlwaysEnabled";
                    Identity                        = "MyDemoPolicy";
                })
            }
            Mock -CommandName Set-CsTeamsMeetingBroadcastPolicy -MockWith {
            }

            Mock -CommandName New-CsTeamsMeetingBroadcastPolicy -MockWith {
            }

            Mock -CommandName Remove-CsTeamsMeetingBroadcastPolicy -MockWith {
            }
        }

        # Test contexts
        Context -Name "When settings are correctly set" -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowBroadcastScheduling        = $True;
                    AllowBroadcastTranscription     = $False;
                    BroadcastAttendeeVisibilityMode = "EveryoneInCompany";
                    BroadcastRecordingMode          = "AlwaysEnabled";
                    Ensure                          = "Present";
                    GlobalAdminAccount              = $GlobalAdminAccount;
                    Identity                        = "MyDemoPolicy";
                }
            }

            It "Should return proper value from the Get method" {
                (Get-TargetResource @testParams).BroadcastAttendeeVisibilityMode | Should -Be 'EveryoneInCompany'
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should -Be $true
            }

            It "Should update settings in the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-CsTeamsMeetingBroadcastPolicy -Exactly 1
                Should -Invoke -CommandName New-CsTeamsMeetingBroadcastPolicy -Exactly 0
                Should -Invoke -CommandName Remove-CsTeamsMeetingBroadcastPolicy -Exactly 0
            }
        }

        Context -Name "When settings are NOT correctly set" -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowBroadcastScheduling        = $True;
                    AllowBroadcastTranscription     = $False;
                    BroadcastAttendeeVisibilityMode = "EveryoneInCompany";
                    BroadcastRecordingMode          = "AlwaysDisabled"; #Drifted
                    Ensure                          = "Present";
                    GlobalAdminAccount              = $GlobalAdminAccount;
                    Identity                        = "MyDemoPolicy";
                }
            }

            It "Should return proper value from the Get method" {
                (Get-TargetResource @testParams).BroadcastRecordingMode | Should -Be 'AlwaysEnabled'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Updates the settings in the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-CsTeamsMeetingBroadcastPolicy
            }
        }

        Context -Name "When the Policy Doesn't Already Exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowBroadcastScheduling        = $True;
                    AllowBroadcastTranscription     = $False;
                    BroadcastAttendeeVisibilityMode = "EveryoneInCompany";
                    BroadcastRecordingMode          = "AlwaysDisabled"; #Drifted
                    Ensure                          = "Present";
                    GlobalAdminAccount              = $GlobalAdminAccount;
                    Identity                        = "MyDemoPolicy";
                }

                Mock -CommandName Get-CsTeamsMeetingBroadcastPolicy -MockWith{
                }
            }

            It "Should return Ensure is Absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Create the policy in the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-CsTeamsMeetingBroadcastPolicy
            }
        }

        Context -Name "When the Policy Exists but Shouldn't" -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowBroadcastScheduling        = $True;
                    AllowBroadcastTranscription     = $False;
                    BroadcastAttendeeVisibilityMode = "EveryoneInCompany";
                    BroadcastRecordingMode          = "AlwaysDisabled"; #Drifted
                    Ensure                          = "Absent";
                    GlobalAdminAccount              = $GlobalAdminAccount;
                    Identity                        = "MyDemoPolicy";
                }
            }

            It "Should return Ensure is Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Delete the policy in the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-CsTeamsMeetingBroadcastPolicy
            }
        }

        Context -Name "When the No Optional Parameters are Specified" -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount              = $GlobalAdminAccount;
                    Identity                        = "MyDemoPolicy";
                }
            }

            It "Should throw an error from the Set method" {
                {Set-TargetResource @testParams} | Should -Throw
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount = $GlobalAdminAccount
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
