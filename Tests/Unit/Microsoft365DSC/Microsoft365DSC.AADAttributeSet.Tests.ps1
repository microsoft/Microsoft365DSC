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
    -DscResource "AADAttributeSet" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString "f@kepassword1" -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Update-MgBetaDirectoryAttributeSet -MockWith {
            }

            Mock -CommandName Remove-MgBetaDirectoryAttributeSet -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
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
                    Description         = "This is my super context test";
                    MaxAttributesPerSet = 420;
                    Ensure              = "Present";
                    Id                  = "c3";
                    Credential          = $Credential;
                }

                Mock -CommandName Get-MgBetaDirectoryAttributeSet -MockWith {
                    return $null
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
        }


        Context -Name "The instance exists and values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Description         = "This is my super context test";
                    MaxAttributesPerSet = 420;
                    Ensure              = "Present";
                    Id                  = "c3";
                    Credential          = $Credential;
                }

                Mock -CommandName Get-MgBetaDirectoryAttributeSet -MockWith {
                    return @{
                        Description         = "This is my super context test";
                        MaxAttributesPerSet = 420;
                        Id                  = "c3";
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
                    Description         = "This is my super context test";
                    MaxAttributesPerSet = 420;
                    Ensure              = "Present";
                    Id                  = "c3";
                    Credential          = $Credential;
                }

                Mock -CommandName Get-MgBetaDirectoryAttributeSet -MockWith {
                    return @{
                        Description         = "This is my super context test";
                        MaxAttributesPerSet = 431; #drift
                        Ensure              = "Present";
                        Id                  = "c3";
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
                Should -Invoke -CommandName Update-MgBetaDirectoryAttributeSet -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential  = $Credential;
                }

                Mock -CommandName Get-MgBetaDirectoryAttributeSet -MockWith {
                    return @{
                        Description         = "This is my super context test";
                        MaxAttributesPerSet = 420;
                        Id                  = "c3";
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
