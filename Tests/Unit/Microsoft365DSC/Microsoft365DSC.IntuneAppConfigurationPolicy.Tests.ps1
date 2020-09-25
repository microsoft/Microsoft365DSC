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
    -DscResource "IntuneAppConfigurationPolicy" -GenericStubModule $GenericStubPath

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

            Mock -CommandName Update-DeviceAppManagement_TargetedManagedAppConfigurations -MockWith {
            }
            Mock -CommandName New-DeviceAppManagement_TargetedManagedAppConfigurations -MockWith {
            }
            Mock -CommandName Remove-DeviceAppManagement_TargetedManagedAppConfigurations -MockWith {
            }
        }

        # Test contexts
        Context -Name "When the App Configuration Policy doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName        = 'Test App Configuration Policy'
                    Description        = 'Test Definition'
                    Ensure             = 'Present'
                    GlobalAdminAccount = $GlobalAdminAccount;
                }

                Mock -CommandName Get-DeviceAppManagement_TargetedManagedAppConfigurations -MockWith {
                    return $null
                }
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should create the App Configuration Policy from the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName "New-DeviceAppManagement_TargetedManagedAppConfigurations" -Exactly 1
            }
        }

        Context -Name "When the policy already exists and is NOT in the Desired State" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName        = 'Test App Configuration Policy'
                    Description        = 'Test Definition'
                    Ensure             = 'Present'
                    GlobalAdminAccount = $GlobalAdminAccount;
                }

                Mock -CommandName Get-DeviceAppManagement_TargetedManagedAppConfigurations -MockWith {
                    return @{
                        DisplayName = 'Test App Configuration Policy'
                        Description = 'Different Value'
                        Id          = 'A_19dbaff5-9aff-48b0-a60d-d0471ddaf141'
                    }
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should update the App Configuration Policy from the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-DeviceAppManagement_TargetedManagedAppConfigurations -Exactly 1
            }
        }

        Context -Name "When the policy already exists and IS in the Desired State" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName        = 'Test App Configuration Policy'
                    Description        = 'Test Definition'
                    Ensure             = 'Present'
                    GlobalAdminAccount = $GlobalAdminAccount;
                }

                Mock -CommandName Get-DeviceAppManagement_TargetedManagedAppConfigurations -MockWith {
                    return @{
                        DisplayName = 'Test App Configuration Policy'
                        Description = 'Test Definition'
                    }
                }
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "When the policy exists and it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName        = 'Test App Configuration Policy'
                    Description        = 'Test Definition'
                    Ensure             = 'Absent'
                    GlobalAdminAccount = $GlobalAdminAccount;
                }

                Mock -CommandName Get-DeviceAppManagement_TargetedManagedAppConfigurations -MockWith {
                    return @{
                        DisplayName = 'Test App Configuration Policy'
                        Description = 'Test Definition'
                        Id          = 'A_19dbaff5-9aff-48b0-a60d-d0471ddaf141'
                    }
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should remove the App Configuration Policy from the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-DeviceAppManagement_TargetedManagedAppConfigurations -Exactly 1
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount     = $GlobalAdminAccount;
                }

                Mock -CommandName Get-DeviceAppManagement_TargetedManagedAppConfigurations -MockWith {
                    return @{
                        DisplayName = 'Test App Configuration Policy'
                        Description = 'Test Definition'
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
