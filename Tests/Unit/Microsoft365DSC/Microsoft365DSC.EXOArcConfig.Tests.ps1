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
    -DscResource 'EXOArcConfig' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Get-ArcConfig -MockWith {
            }

            Mock -CommandName Set-ArcConfig -MockWith {
            }

            Mock -CommandName Confirm-ImportedCmdletIsAvailable -MockWith {
                return $true
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances = $null
            $Script:ExportMode = $false
        }
        # Test contexts
        Context -Name 'EXOArcConfig update not required.' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance  = 'Yes'
                    Ensure            = 'Present'
                    Credential        = $Credential
                    ArcTrustedSealers = "test1,test2"
                }

                Mock -CommandName Get-ArcConfig -MockWith {
                    return @{
                        IsSingleInstance  = 'Yes'
                        Ensure            = 'Present'
                        Identity          = 'Default'
                        Credential        = $Credential
                        ArcTrustedSealers = "test1,test2"
                    }
                }
            }
            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'EXOArchConfig update needed' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance  = 'Yes'
                    Ensure            = 'Present'
                    Credential        = $Credential
                    ArcTrustedSealers = "test1,test2"
                }

                Mock -CommandName Get-ArcConfig -MockWith {
                    return @{
                        IsSingleInstance  = 'Yes'
                        Ensure            = 'Present'
                        Identity          = 'Default'
                        Credential        = $Credential
                        ArcTrustedSealers = "test3,test4"
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-ArcConfig -MockWith {
                    return @{
                        ArcTrustedSealers = "test1,test2"
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
