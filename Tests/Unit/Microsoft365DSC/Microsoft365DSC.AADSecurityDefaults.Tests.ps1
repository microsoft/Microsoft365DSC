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
    -DscResource 'AADSecurityDefaults' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'test@password1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-MgBetaPolicyIdentitySecurityDefaultEnforcementPolicy -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }


            Mock -CommandName Invoke-MgGraphRequest -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'The Defaults should be enabled but they are not' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance = 'Yes'
                    DisplayName      = 'Security Defaults'
                    Description      = 'Security Defaults description'
                    IsEnabled        = $True
                    Credential       = $Credscredential
                }

                Mock -CommandName Get-MgBetaPolicyIdentitySecurityDefaultEnforcementPolicy -MockWith {
                    return @{
                        DisplayName = 'Security Defaults'
                        Id          = '000000000000'
                        Description = 'Security Defaults description'
                        IsEnabled   = $false
                    }
                }
            }

            It 'Should return values from the get method' {
                Get-TargetResource @testParams
                Should -Invoke -CommandName 'Get-MgBetaPolicyIdentitySecurityDefaultEnforcementPolicy' -Exactly 1
            }
            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should create the Enable from the set method' {
                Set-TargetResource @testParams |
                Should -Invoke -CommandName 'Update-MgBetaPolicyIdentitySecurityDefaultEnforcementPolicy' -Exactly 1
            }
        }
        Context -Name 'The Security Defaults are already in the desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance = 'Yes'
                    DisplayName      = 'Security Defaults'
                    Description      = 'Security Defaults description'
                    IsEnabled        = $True
                    Credential       = $Credscredential
                }

                Mock -CommandName Get-MgBetaPolicyIdentitySecurityDefaultEnforcementPolicy -MockWith {
                    return @{
                        DisplayName = 'Security Defaults'
                        Id          = '000000000000'
                        Description = 'Security Defaults description'
                        IsEnabled   = $true
                    }
                }
            }

            It 'Should return values from the get method' {
                Get-TargetResource @testParams
                Should -Invoke -CommandName 'Get-MgBetaPolicyIdentitySecurityDefaultEnforcementPolicy' -Exactly 1
            }

            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
