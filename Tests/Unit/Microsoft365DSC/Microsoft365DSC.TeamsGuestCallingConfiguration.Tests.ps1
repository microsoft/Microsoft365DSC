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
    -DscResource "TeamsGuestCallingConfiguration" -GenericStubModule $GenericStubPath

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
            Mock -CommandName Get-CsTeamsGuestCallingConfiguration -MockWith {
                return @{
                    Identity            = "Global";
                    AllowPrivateCalling = $False;
                }
            }
            Mock -CommandName Set-CsTeamsGuestCallingConfiguration -MockWith {
            }
        }

        # Test contexts
        Context -Name "When settings are correctly set" -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity            = "Global";
                    AllowPrivateCalling = $False;
                    GlobalAdminAccount  = $GlobalAdminAccount;
                }
            }

            It "Should return False for the AllowPrivateCalling property from the Get method" {
                (Get-TargetResource @testParams).AllowPrivateCalling | Should -Be $False
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should -Be $true
            }

            It "Updates the settings in the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-CsTeamsGuestCallingConfiguration -Exactly 0
            }
        }

        Context -Name "When settings are NOT correctly set" -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity            = "Global";
                    AllowPrivateCalling = $True;
                    GlobalAdminAccount  = $GlobalAdminAccount;
                }
            }

            It "Should return False for the AllowBox property from the Get method" {
                (Get-TargetResource @testParams).AllowPrivateCalling | Should -Be $False
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Updates the Teams Client settings in the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-CsTeamsGuestCallingConfiguration -Exactly 1
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
