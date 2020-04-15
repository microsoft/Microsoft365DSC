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
    -DscResource "TeamsUpgradePolicy" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "Pass@word1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-MSCloudLogin -MockWith {
        }

        Mock -CommandName Grant-CsTeamsUpgradePolicy -MockWith {
        }

        # Test contexts
        Context -Name "When the policy doesn't already exist" -Fixture {
            $testParams = @{
                Identity               = 'Test Policy'
                Users                  = @("john.smith@contoso.onmicrosoft.com")
                MigrateMeetingsToTeams = $false
                GlobalAdminAccount     = $GlobalAdminAccount;
            }

            Mock -CommandName Get-CsTeamsUpgradePolicy -MockWith {
                return $null
            }

            It "Should return absent from the Get method" {
                { Get-TargetResource @testParams } | Should throw "No Teams Upgrade Policy with Identity {Test Policy} was found"
            }
        }

        Context -Name "When the policy already exists and is NOT in the Desired State" -Fixture {
            $testParams = @{
                Identity               = 'Test Policy'
                Users                  = @("john.smith@contoso.onmicrosoft.com")
                MigrateMeetingsToTeams = $false
                GlobalAdminAccount     = $GlobalAdminAccount;
            }

            Mock -CommandName Get-CsTeamsUpgradePolicy -MockWith {
                return @{
                    Identity       = 'Islands'
                    Description    = 'This is a configuration drift'
                    NotifySfBUsers = $false
                }
            }

            Mock -CommandName Get-CsOnlineUser -MockWith {
                return @{
                    UserPrincipalName  = 'John.Smith@contoso.onmicrosoft.com'
                    TeamsUpgradePolicy = "Global"
                }
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Should update the policy from the Set method" {
                Set-TargetResource @testParams
                Assert-MockCalled Grant-CsTeamsUpgradePolicy -Exactly 1
            }
        }

        Context -Name "When the policy already exsits and IS in the Desired State" -Fixture {
            $testParams = @{
                Identity               = 'Islands'
                Users                  = @("john.smith@contoso.onmicrosoft.com")
                MigrateMeetingsToTeams = $false
                GlobalAdminAccount     = $GlobalAdminAccount;
            }

            Mock -CommandName Get-CsTeamsUpgradePolicy -MockWith {
                return @{
                    Identity       = 'Islands'
                    Description    = 'This is a test policy'
                    NotifySfBUsers = $false
                }
            }

            Mock -CommandName Get-CsOnlineUser -MockWith {
                return @{
                    UserPrincipalName  = 'John.Smith@contoso.onmicrosoft.com'
                    TeamsUpgradePolicy = "Islands"
                }
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should Be $true
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                GlobalAdminAccount     = $GlobalAdminAccount;
            }

            Mock -CommandName Get-CsTeamsUpgradePolicy -MockWith {
                return @{
                    Identity       = 'Islands'
                    Description    = 'Test Description'
                    NotifySfBUsers = $false
                }
            }

            Mock -CommandName Get-CsOnlineUser -MockWith {
                return @{
                    UserPrincipalName  = 'John.Smith@contoso.onmicrosoft.com'
                    TeamsUpgradePolicy = "Islands"
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
