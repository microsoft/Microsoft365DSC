[CmdletBinding()]
param(
)
$M365DSCTestFolder = Join-Path -Path $PSScriptRoot `
    -ChildPath '..\..\Unit' `
    -Resolve
$CmdletModule = (Join-Path -Path $M365DSCTestFolder `
        -ChildPath '\Stubs\Microsoft365.psm1' `
        -Resolve)
$GenericStubPath = (Join-Path -Path $M365DSCTestFolder `
        -ChildPath '\Stubs\Generic.psm1' `
        -Resolve)
Import-Module -Name (Join-Path -Path $M365DSCTestFolder `
        -ChildPath '\UnitTestHelper.psm1' `
        -Resolve)

$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource 'AADAuthenticationFlowPolicy' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {
            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@contoso.onmicrosoft.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Update-MgBetaPolicyAuthenticationFlowPolicy -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'Value is already in the desired state.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Credential               = $Credential;
                    Description              = "Description Text.";
                    DisplayName              = "Authentication flows policy";
                    Id                       = "authenticationFlowsPolicy";
                    IsSingleInstance         = "Yes";
                    SelfServiceSignUpEnabled = $True;
                }

                Mock -CommandName Get-MgBetaPolicyAuthenticationFlowPolicy -MockWith {
                    $result = @{
                        Id          = 'authenticationFlowsPolicy'
                        DisplayName  = 'Authentication flows policy'
                        Description = 'Description Text.'
                        SelfServiceSignUp = @{
                            IsEnabled = $true
                        }
                    }
                    return $result
                }
            }

            It 'Should return true from the test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'Value is already in the desired state.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Credential               = $Credential;
                    Description              = "Description Text.";
                    DisplayName              = "Authentication flows policy";
                    Id                       = "authenticationFlowsPolicy";
                    IsSingleInstance         = "Yes";
                    SelfServiceSignUpEnabled = $True;
                }

                Mock -CommandName Get-MgBetaPolicyAuthenticationFlowPolicy -MockWith {
                    $result = @{
                        Id          = 'authenticationFlowsPolicy'
                        DisplayName  = 'Authentication flows policy'
                        Description = 'Description Text.'
                        SelfServiceSignUp = @{
                            IsEnabled = $false #drift
                        }
                    }
                    return $result
                }
            }

            It 'Should return true from the test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should update from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgBetaPolicyAuthenticationFlowPolicy -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaPolicyAuthenticationFlowPolicy -MockWith {
                    $result = @{
                        Id          = 'authenticationFlowsPolicy'
                        DisplayName  = 'Authentication flows policy'
                        Description = 'Description Text.'
                        SelfServiceSignUp = @{
                            IsEnabled = $true
                        }
                    }
                    return $result
                }
            }

            It 'Should reverse engineer resource from the export method' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
