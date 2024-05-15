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
    -DscResource 'SCSupervisoryReviewRule' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Import-PSSession -MockWith {
            }

            Mock -CommandName New-PSSession -MockWith {
            }

            Mock -CommandName Set-SupervisoryReviewRule -MockWith {
            }

            Mock -CommandName New-SupervisoryReviewRule -MockWith {
                return @{

                }
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name "Rule doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure       = 'Present'
                    Credential   = $Credential
                    Name         = 'MyRule'
                    Condition    = '(NOT(Reviewee:US Compliance))'
                    SamplingRate = 100
                    Policy       = 'TestPolicy'
                }

                Mock -CommandName Get-SupervisoryReviewRule -MockWith {
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

        Context -Name 'Rule already exists' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure       = 'Present'
                    Credential   = $Credential
                    Name         = 'MyRule'
                    Condition    = '(NOT(Reviewee:US Compliance))'
                    SamplingRate = 100
                    Policy       = 'TestPolicy'
                }

                Mock -CommandName Get-SupervisoryReviewRule -MockWith {
                    return @{
                        Name         = 'MyRule'
                        Condition    = '(NOT(Reviewee:US Compliance))'
                        SamplingRate = 100
                        Policy       = 'TestPolicy'
                    }
                }

                Mock -CommandName Get-SupervisoryReviewPolicyV2 -MockWith {
                    return @{
                        Name = 'TestPolicy'
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }

            It 'Should update from the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
        }

        Context -Name 'Rule is set to Absent' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure       = 'Absent'
                    Credential   = $Credential
                    Name         = 'MyRule'
                    Condition    = '(NOT(Reviewee:US Compliance))'
                    SamplingRate = 100
                    Policy       = 'TestPolicy'
                }

                Mock -CommandName Get-SupervisoryReviewPolicyV2 -MockWith {
                    return @{
                        Name = 'TestPolicy'
                    }
                }

                Mock -CommandName Get-SupervisoryReviewRule -MockWith {
                    return @{
                        Name         = 'MyRule'
                        Condition    = '(NOT(Reviewee:US Compliance))'
                        SamplingRate = 100
                        Policy       = 'TestPolicy'
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should throw error from the Set method' {
                { Set-TargetResource @testParams } | Should -Throw ("The SCSupervisoryReviewRule resource doesn't not support deleting Rules. " + `
                        'Instead try removing the associated policy, or modifying the existing rule.')
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-SupervisoryReviewPolicyV2 -MockWith {
                    return @{
                        Name = 'TestPolicy'
                    }
                }

                Mock -CommandName Get-SupervisoryReviewRule -MockWith {
                    return @{
                        Name         = 'MyRule'
                        Condition    = '(NOT(Reviewee:US Compliance))'
                        SamplingRate = 100
                        Policy       = 'TestPolicy'
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
