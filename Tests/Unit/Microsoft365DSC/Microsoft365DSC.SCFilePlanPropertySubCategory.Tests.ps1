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
    -DscResource 'SCFilePlanPropertySubCategory' -GenericStubModule $GenericStubPath
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

            Mock -CommandName Remove-FilePlanPropertySubCategory -MockWith {
                return @{

                }
            }

            Mock -CommandName New-FilePlanPropertySubCategory -MockWith {
                return @{

                }
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }

        # Test contexts
        Context -Name "Sub-Category doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    Name       = 'Demo Sub-Category'
                    Category   = 'Parent'
                    Credential = $Credential
                    Ensure     = 'Present'
                }

                Mock -CommandName Get-FilePlanPropertyCategory -MockWith {
                    return @(@{
                            DisplayName = 'Parent'
                            GUID        = '11111-22222-33333-44444-55555'
                        })
                }

                Mock -CommandName Get-FilePlanPropertySubCategory -MockWith {
                    return $null
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'Category already exists' -Fixture {
            BeforeAll {
                $testParams = @{
                    Name       = 'Demo Sub-Category'
                    Category   = 'Parent'
                    Credential = $Credential
                    Ensure     = 'Present'
                }

                Mock -CommandName Get-FilePlanPropertyCategory -MockWith {
                    return @(@{
                            DisplayName = 'Parent'
                            GUID        = '11111-22222-33333-44444-55555'
                        })
                }

                Mock -CommandName Get-FilePlanPropertySubCategory -MockWith {
                    return @(@{
                            DisplayName = 'Demo Sub-Category'
                            ParentId    = '11111-22222-33333-44444-55555'
                        })
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }

            It 'Should do nothing from the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
        }

        Context -Name 'Category should not exist' -Fixture {
            BeforeAll {
                $testParams = @{
                    Name       = 'Demo Sub-Category'
                    Category   = 'Parent'
                    Credential = $Credential
                    Ensure     = 'Absent'
                }

                Mock -CommandName Get-FilePlanPropertyCategory -MockWith {
                    return @(@{
                            DisplayName = 'Parent'
                            GUID        = '11111-22222-33333-44444-55555'
                        })
                }

                Mock -CommandName Get-FilePlanPropertySubCategory -MockWith {
                    return @(@{
                            DisplayName = 'Demo Sub-Category'
                            ParentId    = '11111-22222-33333-44444-55555'
                        })
                }
            }

            It 'Should return False from the Test method' {
                Test-TargetResource @testParams | Should -Be $False
            }

            It 'Should delete from the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-FilePlanPropertyCategory -MockWith {
                    return @(@{
                            DisplayName = 'Parent'
                            Guid        = '11111-22222-33333-44444-55555'
                        })
                }

                Mock -CommandName Get-FilePlanPropertySubCategory -MockWith {
                    return @(@{
                            DisplayName = 'Demo Sub-Category'
                            ParentId    = '11111-22222-33333-44444-55555'
                        })
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
