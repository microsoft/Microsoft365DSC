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
    -DscResource "TeamsEmergencyCallingPolicy" -GenericStubModule $GenericStubPath

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

            Mock -CommandName New-CsTeamsEmergencyCallingPolicy -MockWith {
            }

            Mock -CommandName Set-CsTeamsEmergencyCallingPolicy -MockWith {
            }

            Mock -CommandName Remove-CsTeamsEmergencyCallingPolicy -MockWith {
            }
        }

        # Test contexts
        Context -Name "When Meeting Policy doesn't exist but should" -Fixture {
            BeforeAll {
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
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should create the policy in the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-CsTeamsEmergencyCallingPolicy -Exactly 1
            }
        }

        Context -Name "Policy exists but is not in the Desired State" -Fixture {
            BeforeAll {
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
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should update the settings from the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-CsTeamsEmergencyCallingPolicy -Exactly 1
                Should -Invoke -CommandName New-CsTeamsEmergencyCallingPolicy -Exactly 0
            }
        }

        Context -Name "Policy exists and is already in the Desired State" -Fixture {
            BeforeAll {
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
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "Policy exists but it should not" -Fixture {
            BeforeAll {
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
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should remove the policy from the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-CsTeamsEmergencyCallingPolicy -Exactly 1
            }
        }

        Context -Name "When the No Optional Parameters are Specified" -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount              = $GlobalAdminAccount;
                    Identity                        = "TestPolicy";
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

                Mock -CommandName Get-CsTeamsEmergencyCallingPolicy -MockWith {
                    return @{
                        Description               = "Desc";
                        Identity                  = "TestPolicy";
                        NotificationDialOutNumber = "+1234567890";
                        NotificationGroup         = "john.smith@contoso.onmicrosoft.com";
                        NotificationMode          = "NotificationOnly";
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
