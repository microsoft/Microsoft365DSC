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

$CurrentScriptPath = $PSCommandPath.Split('\')
$CurrentScriptName = $CurrentScriptPath[$CurrentScriptPath.Length -1]
$ResourceName      = $CurrentScriptName.Split('.')[1]
$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource $ResourceName -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            Mock -CommandName Set-EXOSecOpsOverrideRule -MockWith {
                return $null
            }

            Mock -CommandName Remove-EXOSecOpsOverrideRule -MockWith {
                return $null
            }

            Mock -CommandName New-EXOSecOpsOverrideRule -MockWith {
                return $null
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }
        # Test contexts
        Context -Name "The instance should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity            = "_Exe:SecOpsOverrid:ca3c51ac-925c-49f4-af42-43e26b874245";
                    Comment             = "TestComment";
                    Policy              = "40528418-717d-4368-a1ae-7912918f8a1f";
                    Ensure              = 'Present'
                    Credential          = $Credential;
                }

                Mock -CommandName Get-EXOSecOpsOverrideRule -MockWith {
                    return $null
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should create a new instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-EXOSecOpsOverrideRule -Exactly 1
            }
        }

        Context -Name "The instance exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity            = "_Exe:SecOpsOverrid:ca3c51ac-925c-49f4-af42-43e26b874245";
                    Comment             = "TestComment";
                    Policy              = "40528418-717d-4368-a1ae-7912918f8a1f";
                    Ensure              = 'Absent';
                    Credential          = $Credential;
                }

                Mock -CommandName Get-EXOSecOpsOverrideRule -MockWith {
                    return @{
                        Identity            = "_Exe:SecOpsOverrid:ca3c51ac-925c-49f4-af42-43e26b874245";
                        Comment             = "TestComment";
                        Policy              = "40528418-717d-4368-a1ae-7912918f8a1f";
                        Ensure              = 'Present';
                        Credential          = $Credential;
                    }
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should remove the instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-EXOSecOpsOverrideRule -Exactly 1
            }
        }

        Context -Name "The instance exists and values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity            = "_Exe:SecOpsOverrid:ca3c51ac-925c-49f4-af42-43e26b874245";
                    Comment             = "TestComment";
                    Policy              = "40528418-717d-4368-a1ae-7912918f8a1f";
                    Ensure              = 'Present'
                    Credential          = $Credential;
                }

                Mock -CommandName Get-EXOSecOpsOverrideRule -MockWith {
                    return @{
                        Identity            = "_Exe:SecOpsOverrid:ca3c51ac-925c-49f4-af42-43e26b874245";
                        Comment             = "TestComment";
                        Policy              = "40528418-717d-4368-a1ae-7912918f8a1f";
                        Ensure              = 'Present';
                        Credential          = $Credential;
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The instance exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity            = "_Exe:SecOpsOverrid:ca3c51ac-925c-49f4-af42-43e26b874245";
                    Comment             = "TestComment";
                    Policy              = "40528418-717d-4368-a1ae-7912918f8a1g";
                    Ensure              = 'Present'
                    Credential          = $Credential;
                }

                Mock -CommandName Get-EXOSecOpsOverrideRule -MockWith {
                    return @{
                        Identity            = "_Exe:SecOpsOverrid:ca3c51ac-925c-49f4-af42-43e26b874245";
                        Comment             = "TestComment";
                        Policy              = "40528418-717d-4368-a1ae-7912918f8a1f";
                        Ensure              = 'Present';
                        Credential          = $Credential;
                    }
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-EXOSecOpsOverrideRule -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential  = $Credential;
                }

                Mock -CommandName Get-EXOSecOpsOverrideRule -MockWith {
                    return @{
                        Identity            = "_Exe:SecOpsOverrid:ca3c51ac-925c-49f4-af42-43e26b874245";
                        Comment             = "TestComment";
                        Policy              = "40528418-717d-4368-a1ae-7912918f8a1f";
                        Ensure              = 'Present';
                        Credential          = $Credential;
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
