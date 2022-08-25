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
    -DscResource "IntuneDeviceCategory" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString "Pass@word1" -AsPlainText -Force
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

            Mock -CommandName Update-MGDeviceManagementDeviceCategory -MockWith {
            }
            Mock -CommandName New-MGDeviceManagementDeviceCategory -MockWith {
            }
            Mock -CommandName Remove-MGDeviceManagementDeviceCategory -MockWith {
            }
        }

        # Test contexts
        Context -Name "When the category doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName        = 'Test Category'
                    Description        = 'Test Definition'
                    Ensure             = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgDeviceManagementDeviceCategory -MockWith {
                    return $null
                }
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should create the category from the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName "New-MgDeviceManagementDeviceCategory" -Exactly 1
            }
        }

        Context -Name "When the policy already exists and is NOT in the Desired State" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName        = 'Test Category'
                    Description        = 'Test Definition'
                    Ensure             = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgDeviceManagementDeviceCategory -MockWith {
                    return @{
                        DisplayName = 'Test Category'
                        Description = "Different Value"
                        Id          = "12345-12345-12345-12345-12345"
                    }
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should update the category from the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgDeviceManagementDeviceCategory -Exactly 1
            }
        }

        Context -Name "When the policy already exists and IS in the Desired State" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName        = 'Test Category'
                    Description        = 'Test Definition'
                    Ensure             = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgDeviceManagementDeviceCategory -MockWith {
                    return @{
                        DisplayName = 'Test Category'
                        Description = "Test Definition"
                        Id          = "12345-12345-12345-12345-12345"
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
                    DisplayName        = 'Test Category'
                    Description        = 'Test Definition'
                    Ensure             = 'Absent'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgDeviceManagementDeviceCategory -MockWith {
                    return @{
                        DisplayName = 'Test Category'
                        Description = "Test Definition"
                        Id          = "12345-12345-12345-12345-12345"
                    }
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should remove the category from the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgDeviceManagementDeviceCategory -Exactly 1
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $testParams = @{
                    Credential     = $Credential;
                }

                Mock -CommandName Get-MgDeviceManagementDeviceCategory -MockWith {
                    return @{
                        DisplayName = 'Test Category'
                        Description = "Test Definition"
                        Id          = "12345-12345-12345-12345-12345"
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
