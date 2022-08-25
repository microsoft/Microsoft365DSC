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
    -DscResource "SPOBrowserIdleSignout" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {

            }

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            Mock -CommandName Set-PnPBrowserIdleSignout -MockWith {

            }
        }

        # Test contexts
        Context -Name "Settings need to be updated." -Fixture {
            BeforeAll {
                $testParams = @{
                    Credential           = $Credential;
                    Enabled              = $False;
                    IsSingleInstance     = "Yes";
                    SignOutAfter         = "00:00:00";
                    WarnAfter            = "00:00:00";
                }

                Mock -CommandName Get-PnPBrowserIdleSignout -MockWith {
                    return @{
                        Enabled              = $False;
                        IsSingleInstance     = "Yes";
                        SignOutAfter         = "01:00:00"; #Drift
                        WarnAfter            = "00:00:00";
                    }
                }
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should update the settings" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-PnPBrowserIdleSignout -Exactly 1
            }
        }

        Context -Name "Settings are already in the desired state." -Fixture {
            BeforeAll {
                $testParams = @{
                    Credential           = $Credential;
                    Enabled              = $False;
                    IsSingleInstance     = "Yes";
                    SignOutAfter         = "00:00:00";
                    WarnAfter            = "00:00:00";
                }

                Mock -CommandName Get-PnPBrowserIdleSignout -MockWith {
                    return @{
                        Enabled              = $False;
                        IsSingleInstance     = "Yes";
                        SignOutAfter         = "00:00:00";
                        WarnAfter            = "00:00:00";
                    }
                }
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-PnPBrowserIdleSignout -MockWith {
                    return @{
                        Enabled              = $False;
                        IsSingleInstance     = "Yes";
                        SignOutAfter         = "00:00:00";
                        WarnAfter            = "00:00:00";
                    }
                }
            }
            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }#inmodulescope
}#describe

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
