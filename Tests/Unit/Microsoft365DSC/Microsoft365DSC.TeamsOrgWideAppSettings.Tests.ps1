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
    -DscResource 'TeamsOrgWideAppSettings' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'Pass@word1)' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            $Global:PartialExportFileName = 'c:\TestPath'


            Mock -CommandName Save-M365DSCPartialExport -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Set-CsTeamsSettingsCustomApp -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }

        # Test contexts
        Context -Name 'When Settings are already in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    Credential                         = $Credential;
                    IsSideloadedAppsInteractionEnabled = $False;
                    IsSingleInstance                   = "Yes";
                }

                Mock -CommandName Get-CsTeamsSettingsCustomApp -MockWith {
                    return @{
                        IsSideloadedAppsInteractionEnabled= $False
                    }
                }
            }

            It 'Should return False from the Get method' {
                (Get-TargetResource @testParams).IsSideloadedAppsInteractionEnabled | Should -Be $false
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'When Settings are NOT in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    Credential                         = $Credential;
                    IsSideloadedAppsInteractionEnabled = $True; #drift
                    IsSingleInstance                   = "Yes";
                }

                Mock -CommandName Get-CsTeamsSettingsCustomApp -MockWith {
                    return @{
                        IsSideloadedAppsInteractionEnabled= $False
                    }
                }
            }

            It 'Should return False from the Get method' {
                (Get-TargetResource @testParams).IsSideloadedAppsInteractionEnabled | Should -Be $false
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should update from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-CsTeamsSettingsCustomApp -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $testParams = @{
                    Credential                         = $Credential;
                    IsSideloadedAppsInteractionEnabled = $False
                    IsSingleInstance                   = "Yes";
                }

                Mock -CommandName Get-CsTeamsSettingsCustomApp -MockWith {
                    return @{
                        IsSideloadedAppsInteractionEnabled= $False
                    }
                }
            }

            It 'Should Reverse Engineer resource from the Export method' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
