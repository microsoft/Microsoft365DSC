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
    -DscResource 'PPPowerAppsEnvironment' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'test@password1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Remove-AdminPowerAppEnvironment -MockWith {
                return @{

                }
            }

            Mock -CommandName New-AdminPowerAppEnvironment -MockWith {
                return @{

                }
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false

            Mock -CommandName Write-Warning -MockWith {
            }
        }

        # Test contexts
        Context -Name "Environment doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName    = 'Test Environment'
                    Location       = 'canada'
                    EnvironmentSKU = 'production'
                    Credential     = $Credential
                    Ensure         = 'Present'
                }

                Mock -CommandName Get-AdminPowerAppEnvironment -MockWith {
                    return $null
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should create the environment in the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-AdminPowerAppEnvironment -Exactly 1
            }
        }

        Context -Name 'Environment already exists but IS ALREADY in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName    = 'Test Environment'
                    Location       = 'canada'
                    EnvironmentSKU = 'production'
                    Credential     = $Credential
                    Ensure         = 'Present'
                }

                Mock -CommandName Get-AdminPowerAppEnvironment -MockWith {
                    return @{
                        DisplayName     = 'Test Environment'
                        Location        = 'canada'
                        EnvironmentType = 'production'
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
        }

        Context -Name 'Environment already exists but SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName    = 'Test Environment'
                    Location       = 'canada'
                    EnvironmentSKU = 'production'
                    Credential     = $Credential
                    Ensure         = 'Absent'
                }

                Mock -CommandName Get-AdminPowerAppEnvironment -MockWith {
                    return @{
                        DisplayName     = 'Test Environment'
                        Location        = 'canada'
                        EnvironmentType = 'production'
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should delete the environment in the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-AdminPowerAppEnvironment -Exactly 1
                Should -Invoke -CommandName New-AdminPowerAppEnvironment -Exactly 0
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-AdminPowerAppEnvironment -MockWith {
                    return @{
                        DisplayName     = 'Test Environment'
                        Location        = 'canada'
                        EnvironmentType = 'production'
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
