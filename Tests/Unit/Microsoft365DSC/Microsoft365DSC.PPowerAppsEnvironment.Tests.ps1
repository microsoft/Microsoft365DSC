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
    -DscResource "PPPowerAppsEnvironment" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
            $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credential"
            }

            Mock -CommandName Remove-AdminPowerAppEnvironment -MockWith {
                return @{

                }
            }

            Mock -CommandName New-AdminPowerAppEnvironment -MockWith {
                return @{

                }
            }
        }

        # Test contexts
        Context -Name "Environment doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName        = "Test Environment"
                    Location           = 'canada'
                    EnvironmentSKU     = 'production'
                    GlobalAdminAccount = $GlobalAdminAccount
                    Ensure             = "Present"
                }

                Mock -CommandName Get-AdminPowerAppEnvironment -MockWith {
                    return $null
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be "Absent"
            }

            It "Should create the environment in the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-AdminPowerAppEnvironment -Exactly 1
            }
        }

        Context -Name "Environment already exists but is NOT in the Desired State" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName        = "Test Environment"
                    Location           = 'canada'
                    EnvironmentSKU     = 'production'
                    GlobalAdminAccount = $GlobalAdminAccount
                    Ensure             = "Present"
                }

                Mock -CommandName Get-AdminPowerAppEnvironment -MockWith {
                    return @{
                        DisplayName     = "Test Environment"
                        Location        = 'unitedstates'
                        EnvironmentType = 'production'
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }

            It "Should not do anything in the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-AdminPowerAppEnvironment -Exactly 0
                Should -Invoke -CommandName New-AdminPowerAppEnvironment -Exactly 0
            }
        }

        Context -Name "Environment already exists but IS ALREADY in the Desired State" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName        = "Test Environment"
                    Location           = 'canada'
                    EnvironmentSKU     = 'production'
                    GlobalAdminAccount = $GlobalAdminAccount
                    Ensure             = "Present"
                }

                Mock -CommandName Get-AdminPowerAppEnvironment -MockWith {
                    return @{
                        DisplayName     = "Test Environment"
                        Location        = 'canada'
                        EnvironmentType = 'production'
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }
        }

        Context -Name "Environment already exists but SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName        = "Test Environment"
                    Location           = 'canada'
                    EnvironmentSKU     = 'production'
                    GlobalAdminAccount = $GlobalAdminAccount
                    Ensure             = "Absent"
                }

                Mock -CommandName Get-AdminPowerAppEnvironment -MockWith {
                    return @{
                        DisplayName     = "Test Environment"
                        Location        = 'canada'
                        EnvironmentType = 'production'
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }

            It "Should delete the environment in the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-AdminPowerAppEnvironment -Exactly 1
                Should -Invoke -CommandName New-AdminPowerAppEnvironment -Exactly 0
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName Get-AdminPowerAppEnvironment -MockWith {
                    return @{
                        DisplayName     = "Test Environment"
                        Location        = 'canada'
                        EnvironmentType = 'production'
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
