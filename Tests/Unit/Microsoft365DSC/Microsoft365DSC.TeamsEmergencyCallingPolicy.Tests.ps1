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
    -DscResource "TeamsEmergencyCallingPolicy" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "Pass@word1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-MSCloudLogin -MockWith {
        }

        Mock -CommandName New-CsTeamsEmergencyCallingPolicy -MockWith {
        }

        Mock -CommandName Set-CsTeamsEmergencyCallingPolicy -MockWith {
        }

        Mock -CommandName Remove-CsTeamsEmergencyCallingPolicy -MockWith {
        }

        # Test contexts
        Context -Name "When Meeting Policy doesn't exist but should" -Fixture {
            $testParams = @{
                Description               = "Desc";
                Ensure                    = "Present";
                GlobalAdminAccount        = $GlobalAdminAccount;
                Identity                  = "TestPolicy";
                NotificationDialOutNumber = "+1234567890";
                NotificationGroup         = "john.smith@contoso.onmicrosoft.com";
                NotificationMode          = "NotificationOnly";
            }

            Mock -CommandName Get-CsTeamsEmergencyCallingPolicy -MockWith {
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
                Assert-MockCalled -CommandName New-CsTeamsEmergencyCallingPolicy -Exactly 1
            }
        }

        Context -Name "Policy exists but is not in the Desired State" -Fixture {
            $testParams = @{
                Description               = "Desc";
                Ensure                    = "Present";
                GlobalAdminAccount        = $GlobalAdminAccount;
                Identity                  = "TestPolicy";
                NotificationDialOutNumber = "+34565432345"; #drift
                NotificationGroup         = "john.smith@contoso.onmicrosoft.com";
                NotificationMode          = "NotificationOnly";
            }

            Mock -CommandName Get-CsTeamsEmergencyCallingPolicy -MockWith {
                return @{
                    Description               = "Desc";
                    Identity                  = "TestPolicy";
                    NotificationDialOutNumber = "12312345678";
                    NotificationGroup         = "john.smith@contoso.onmicrosoft.com";
                    NotificationMode          = "NotificationOnly";
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
                Assert-MockCalled -CommandName Set-CsTeamsEmergencyCallingPolicy -Exactly 1
                Assert-MockCalled -CommandName New-CsTeamsEmergencyCallingPolicy -Exactly 0
            }
        }

        Context -Name "Policy exists and is already in the Desired State" -Fixture {
            $testParams = @{
                Description               = "Desc";
                Ensure                    = "Present";
                GlobalAdminAccount        = $GlobalAdminAccount;
                Identity                  = "TestPolicy";
                NotificationDialOutNumber = "+1234567890";
                NotificationGroup         = "john.smith@contoso.onmicrosoft.com";
                NotificationMode          = "NotificationOnly";
            }

            Mock -CommandName Get-CsTeamsEmergencyCallingPolicy -MockWith {
                return @{
                    Description               = "Desc";
                    Identity                  = "TestPolicy";
                    NotificationDialOutNumber = "+1234567890";
                    NotificationGroup         = "john.smith@contoso.onmicrosoft.com";
                    NotificationMode          = "NotificationOnly";
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
                Description               = "Desc";
                Ensure                    = "Absent";
                GlobalAdminAccount        = $GlobalAdminAccount;
                Identity                  = "TestPolicy";
                NotificationDialOutNumber = "+1234567890";
                NotificationGroup         = "john.smith@contoso.onmicrosoft.com";
                NotificationMode          = "NotificationOnly";
            }

            Mock -CommandName Get-CsTeamsEmergencyCallingPolicy -MockWith {
                return @{
                    Description               = "Desc";
                    Identity                  = "TestPolicy";
                    NotificationDialOutNumber = "+1234567890";
                    NotificationGroup         = "john.smith@contoso.onmicrosoft.com";
                    NotificationMode          = "NotificationOnly";
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
                Assert-MockCalled -CommandName Remove-CsTeamsEmergencyCallingPolicy -Exactly 1
            }
        }

        Context -Name "When the No Optional Parameters are Specified" -Fixture {
            $testParams = @{
                GlobalAdminAccount              = $GlobalAdminAccount;
                Identity                        = "TestPolicy";
            }

            It "Should throw an error from the Set method" {
                {Set-TargetResource @testParams} | Should throw `
                ("You need to specify at least one optional parameter for the Set-TargetResource function" + `
                " of the [TeamsEmergencyCallingPolicy] instance {TestPolicy}")
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-CsTeamsEmergencyCallingPolicy -MockWith {
                return @{
                    Description               = "Desc";
                    Identity                  = "TestPolicy";
                    NotificationDialOutNumber = "+1234567890";
                    NotificationGroup         = "john.smith@contoso.onmicrosoft.com";
                    NotificationMode          = "NotificationOnly";
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
