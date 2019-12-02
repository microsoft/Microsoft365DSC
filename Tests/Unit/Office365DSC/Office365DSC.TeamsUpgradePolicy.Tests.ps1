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
    -DscResource "TeamsUpgradePolicy"

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "Pass@word1)" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-MSCloudLogin -MockWith {
        }

        Mock -CommandName Set-CsTeamsUpgradePolicy -MockWith {
        }

        Mock -CommandName Remove-CsTeamsUpgradePolicy -MockWith {
        }

        # Test contexts
        Context -Name "When the policy doesn't already exist" -Fixture {
            $testParams = @{
                Identity           = 'Test Policy'
                Description        = 'Test Description'
                NotifySfBUsers     = $false
                GlobalAdminAccount = $GlobalAdminAccount;
            }

            Mock -CommandName Get-CsTeamsUpgradePolicy -MockWith {
                return $null
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be 'Absent'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Should create the policy from the Set method" {
                Set-TargetResource @testParams
                Assert-MockCalled New-CsTeamsUpgradePolicy -Exactly 1
            }
        }

        Context -Name "When the policy already exsits and is NOT in the Desired State" -Fixture {
            $testParams = @{
                Identity           = 'Test Policy'
                Description        = 'Test Description'
                NotifySfBUsers     = $false
                GlobalAdminAccount = $GlobalAdminAccount;
            }

            Mock -CommandName Get-CsTeamsUpgradePolicy -MockWith {
                return @{
                    Identity       = 'Test Policy'
                    Description    = 'This is a configuration drift'
                    NotifySfBUsers = $false
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be 'Present'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Should update the policy from the Set method" {
                Set-TargetResource @testParams
                Assert-MockCalled Set-CsTeamsUpgradePolicy -Exactly 1
            }
        }

        Context -Name "When the policy already exsits and is IS in the Desired State" -Fixture {
            $testParams = @{
                Identity           = 'Test Policy'
                Description        = 'Test Description'
                NotifySfBUsers     = $false
                GlobalAdminAccount = $GlobalAdminAccount;
            }

            Mock -CommandName Get-CsTeamsUpgradePolicy -MockWith {
                return @{
                    Identity       = 'Test Policy'
                    Description    = 'Test Description'
                    NotifySfBUsers = $false
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be 'Present'
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should Be $true
            }
        }

        Context -Name "When the policy already exsits and should NOT" -Fixture {
            $testParams = @{
                Identity           = 'Test Policy'
                Description        = 'Test Description'
                NotifySfBUsers     = $false
                Ensure             = 'Absent'
                GlobalAdminAccount = $GlobalAdminAccount;
            }

            Mock -CommandName Get-CsTeamsUpgradePolicy -MockWith {
                return @{
                    Identity       = 'Test Policy'
                    Description    = 'Test Description'
                    NotifySfBUsers = $false
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be 'Present'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Should delete the policy from the Set method" {
                Set-TargetResource @testParams
                Assert-MockCalled Remove-CsTeamsUpgradePolicy -Exactly 1
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-CsTeamsUpgradePolicy -MockWith {
                return @{
                    Identity       = 'Test Policy'
                    Description    = 'Test Description'
                    NotifySfBUsers = $false
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
