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
    -DscResource 'IntuneDeviceCategory' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString ((New-Guid).ToString()) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Update-MgBetaDeviceManagementDeviceCategory -MockWith {
            }

            Mock -CommandName New-MgBetaDeviceManagementDeviceCategory -MockWith {
            }

            Mock -CommandName Remove-MgBetaDeviceManagementDeviceCategory -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name "When the category doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName = 'Test Category'
                    Description = 'Test Definition'
                    Ensure      = 'Present'
                    Credential  = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceCategory -MockWith {
                    return $null
                }
            }

            It 'Should return absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should create the category from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'New-MgBetaDeviceManagementDeviceCategory' -Exactly 1
            }
        }

        Context -Name 'When the policy exists and it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName = 'Test Category'
                    Description = 'Test Definition'
                    Ensure      = 'Absent'
                    Credential  = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceCategory -MockWith {
                    return @{
                        DisplayName = 'Test Category'
                        Description = 'Test Definition'
                        Id          = '12345-12345-12345-12345-12345'
                    }
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should remove the category from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgBetaDeviceManagementDeviceCategory -Exactly 1
            }
        }

        Context -Name 'When the policy already exists and IS in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName = 'Test Category'
                    Description = 'Test Definition'
                    Ensure      = 'Present'
                    Credential  = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceCategory -MockWith {
                    return @{
                        DisplayName = 'Test Category'
                        Description = 'Test Definition'
                        Id          = '12345-12345-12345-12345-12345'
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'When the policy already exists and is NOT in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName = 'Test Category'
                    Description = 'Test Definition'
                    Ensure      = 'Present'
                    Credential  = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceCategory -MockWith {
                    return @{
                        DisplayName = 'Test Category'
                        Description = 'Different Value'
                        Id          = '12345-12345-12345-12345-12345'
                    }
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should update the category from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgBetaDeviceManagementDeviceCategory -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceCategory -MockWith {
                    return @{
                        DisplayName = 'Test Category'
                        Description = 'Test Definition'
                        Id          = '12345-12345-12345-12345-12345'
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
