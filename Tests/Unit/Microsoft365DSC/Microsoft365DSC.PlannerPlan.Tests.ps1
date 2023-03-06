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
    -DscResource 'PlannerPlan' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'Pass@word1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@contoso.onmicrosoft.com', $secpasswd)

            Mock -CommandName Save-M365DSCPartialExport -MockWith {
            }
            Mock -CommandName Connect-Graph -MockWith {
            }

            Mock -CommandName New-MGPlannerPlan -MockWith {
            }

            Mock -CommandName Update-MGPlannerPlan -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }

        # Test contexts
        Context -Name "When the Plan doesn't exist but it should" -Fixture {
            BeforeAll {
                $testParams = @{
                    Title      = 'Contoso Plan'
                    OwnerGroup = 'Contoso Group'
                    Credential = $Credential
                    Ensure     = 'Present'
                }

                Mock -CommandName Get-MgGroup -MockWith {
                    return @(
                        @{
                            DisplayName = 'Contoso Group'
                            Id          = '12345-12345-12345-12345-12345'
                        }
                    )
                }

                Mock -CommandName Get-MgGroupPlannerPlan -MockWith {
                    return $null
                }
            }

            It 'Should return absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should create the Plan in the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-MGPlannerPlan -Exactly 1
            }
        }

        Context -Name 'Plan exists and is NOT in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    Title      = 'Contoso Plan'
                    OwnerGroup = 'Contoso Group'
                    Credential = $Credential
                    Ensure     = 'Present'
                }

                Mock -CommandName Get-MgGroup -MockWith {
                    return @(
                        @{
                            DisplayName = 'Contoso Group'
                            Id          = '12345-12345-12345-12345-12345'
                        }
                    )
                }

                Mock -CommandName Get-MgGroupPlannerPlan -MockWith {
                    return @{
                        Title = 'Contoso Plan'
                        Id    = '1234567890'
                        Owner = '12345-12345-12345-12345-12345'
                    }
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should update the settings from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MGPlannerPlan -Exactly 1
            }
        }

        Context -Name 'Plan exists and is IN the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    Title      = 'Contoso Plan'
                    OwnerGroup = '12345-12345-12345-12345-12345'
                    Credential = $Credential
                    Ensure     = 'Present'
                }

                Mock -CommandName Get-MgGroup -MockWith {
                    return @(
                        @{
                            DisplayName = 'Contoso Group'
                            Id          = '12345-12345-12345-12345-12345'
                        }
                    )
                }

                Mock -CommandName Get-MgGroupPlannerPlan -MockWith {
                    return @{
                        Title = 'Contoso Plan'
                        Id    = '1234567890'
                        Owner = '12345-12345-12345-12345-12345'
                    }
                }
            }
            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Set method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'Plan exists but it should not' -Fixture {
            BeforeAll {
                $testParams = @{
                    Title      = 'Contoso Plan'
                    OwnerGroup = 'Contoso Group'
                    Credential = $Credential
                    Ensure     = 'Absent'
                }

                Mock -CommandName Get-MgGroup -MockWith {
                    return @(
                        @{
                            DisplayName = 'Contoso Group'
                            Id          = '12345-12345-12345-12345-12345'
                        }
                    )
                }

                Mock -CommandName Get-MgGroupPlannerPlan -MockWith {
                    return @{
                        Title = 'Contoso Plan'
                        Id    = '1234567890'
                        Owner = '12345-12345-12345-12345-12345'
                    }
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Set method' {
                Test-TargetResource @testParams | Should -Be $false
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgGroup -MockWith {
                    return @(
                        @{
                            DisplayName = 'Contoso Group'
                            Id          = '12345-12345-12345-12345-12345'
                        }
                    )
                }

                Mock -CommandName Get-MgGroupPlannerPlan -MockWith {
                    return @{
                        Title = 'Contoso Plan'
                        Id    = '1234567890'
                        Owner = '12345-12345-12345-12345-12345'
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
