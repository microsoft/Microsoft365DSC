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
    -DscResource "TeamsMeetingBroadcastPolicy" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "Pass@word1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-MSCloudLogin -MockWith {
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

        # Test contexts
        Context -Name "When settings are correctly set" -Fixture {
            $testParams = @{
                AllowBroadcastScheduling        = $True;
                AllowBroadcastTranscription     = $False;
                BroadcastAttendeeVisibilityMode = "EveryoneInCompany";
                BroadcastRecordingMode          = "AlwaysEnabled";
                Ensure                          = "Present";
                GlobalAdminAccount              = $GlobalAdminAccount;
                Identity                        = "MyDemoPolicy";
            }

            It "Should return proper value from the Get method" {
                (Get-TargetResource @testParams).BroadcastAttendeeVisibilityMode | Should Be 'EveryoneInCompany'
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should Be $true
            }

            It "Should update settings in the Set method" {
                Set-TargetResource @testParams
                Assert-MockCalled Set-CsTeamsMeetingBroadcastPolicy -Exactly 1
                Assert-MockCalled New-CsTeamsMeetingBroadcastPolicy -Exactly 0
                Assert-MockCalled Remove-CsTeamsMeetingBroadcastPolicy -Exactly 0
            }
        }

        Context -Name "When settings are NOT correctly set" -Fixture {
            $testParams = @{
                AllowBroadcastScheduling        = $True;
                AllowBroadcastTranscription     = $False;
                BroadcastAttendeeVisibilityMode = "EveryoneInCompany";
                BroadcastRecordingMode          = "AlwaysDisabled"; #Drifted
                Ensure                          = "Present";
                GlobalAdminAccount              = $GlobalAdminAccount;
                Identity                        = "MyDemoPolicy";
            }

            It "Should return proper value from the Get method" {
                (Get-TargetResource @testParams).BroadcastRecordingMode | Should Be 'AlwaysEnabled'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Updates the settings in the Set method" {
                Set-TargetResource @testParams
                Assert-MockCalled Set-CsTeamsMeetingBroadcastPolicy
            }
        }

        Context -Name "When the Policy Doesn't Already Exist" -Fixture {
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

            It "Should return Ensure is Absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be 'Absent'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Create the policy in the Set method" {
                Set-TargetResource @testParams
                Assert-MockCalled New-CsTeamsMeetingBroadcastPolicy
            }
        }

        Context -Name "When the Policy Exists but Shouldn't" -Fixture {
            $testParams = @{
                AllowBroadcastScheduling        = $True;
                AllowBroadcastTranscription     = $False;
                BroadcastAttendeeVisibilityMode = "EveryoneInCompany";
                BroadcastRecordingMode          = "AlwaysDisabled"; #Drifted
                Ensure                          = "Absent";
                GlobalAdminAccount              = $GlobalAdminAccount;
                Identity                        = "MyDemoPolicy";
            }

            It "Should return Ensure is Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be 'Present'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Delete the policy in the Set method" {
                Set-TargetResource @testParams
                Assert-MockCalled Remove-CsTeamsMeetingBroadcastPolicy
            }
        }

        Context -Name "When the No Optional Parameters are Specified" -Fixture {
            $testParams = @{
                GlobalAdminAccount              = $GlobalAdminAccount;
                Identity                        = "MyDemoPolicy";
            }

            It "Should throw an error from the Set method" {
                {Set-TargetResource @testParams} | Should throw `
                ("You need to specify at least one optional parameter for the Set-TargetResource function" + `
                " of the [TeamsMeetingBroadcastPolicy] instance {MyDemoPolicy}")
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                GlobalAdminAccount = $GlobalAdminAccount
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
