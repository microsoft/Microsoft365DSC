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
        Context -Name " 1. When the category doesn't already exist" -Fixture {
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

            It ' 1.1 Should return absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It ' 1.2 Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It ' 1.3 Should create the category from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'New-MgBetaDeviceManagementDeviceCategory' -Exactly 1
            }
        }

        Context -Name ' 2. When the policy exists and it SHOULD NOT' -Fixture {
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

            It ' 2.1 Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It '2.2 Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It ' 2.3 Should remove the category from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgBetaDeviceManagementDeviceCategory -Exactly 1
            }
        }

        Context -Name ' 3. When the policy already exists and IS in the Desired State' -Fixture {
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

            It ' 3.0 Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name ' 4. When the policy already exists and is NOT in the Desired State' -Fixture {
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

            It ' 4.1 Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It '4.2 Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It '4.3 Should update the category from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgBetaDeviceManagementDeviceCategory -Exactly 1
            }
        }

        Context -Name ' 5. ReverseDSC Tests' -Fixture {
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

            It '5.0 Should Reverse Engineer resource from the Export method' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
