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
    -DscResource 'EXOQuarantinePolicy' -GenericStubModule $GenericStubPath
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

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName New-MalwareFilterPolicy -MockWith {
            }

            Mock -CommandName Set-MalwareFilterPolicy -MockWith {
            }

            Mock -CommandName Remove-MalwareFilterPolicy -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'QuarantinePolicy creation.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                      = 'Present'
                    Credential                  = $Credential
                    Identity                    = 'DefaultFullAccessPolicy'
                    OrganizationBrandingEnabled = $False
                    ESNEnabled                  = $False
                }


                Mock -CommandName Get-QuarantinePolicy -MockWith {
                    return @{
                        Identity = 'SomeOtherQuarantinePolicy'
                    }
                }

                Mock -CommandName Get-QuarantinePolicy -ParameterFilter { $QuarantinePolicyType -eq 'GlobalQuarantinePolicy' } -MockWith {
                    return @{
                        Identity = 'DefaultGlobalPolicy'
                    }
                }
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'QuarantinePolicy update not required.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                      = 'Present'
                    Credential                  = $Credential
                    Identity                    = 'DefaultFullAccessPolicy'
                    OrganizationBrandingEnabled = $True
                    ESNEnabled                  = $False
                }

                Mock -CommandName Get-QuarantinePolicy -MockWith {
                    return @{
                        Ensure                      = 'Present'
                        Credential                  = $Credential
                        Identity                    = 'DefaultFullAccessPolicy'
                        OrganizationBrandingEnabled = $True
                        ESNEnabled                  = $False
                    }
                }

                Mock -CommandName Get-QuarantinePolicy -ParameterFilter { $QuarantinePolicyType -eq 'GlobalQuarantinePolicy' } -MockWith {
                    return @{
                        Identity = 'DefaultGlobalPolicy'
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'QuarantinePolicy update needed.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                      = 'Present'
                    Credential                  = $Credential
                    Identity                    = 'DefaultFullAccessPolicy'
                    OrganizationBrandingEnabled = $True
                    ESNEnabled                  = $True
                }

                Mock -CommandName Get-QuarantinePolicy -MockWith {
                    return @{
                        Ensure                      = 'Present'
                        Credential                  = $Credential
                        Identity                    = 'DefaultFullAccessPolicy'
                        OrganizationBrandingEnabled = $False
                        ESNEnabled                  = $False
                    }
                }

                Mock -CommandName Get-QuarantinePolicy -ParameterFilter { $QuarantinePolicyType -eq 'GlobalQuarantinePolicy' } -MockWith {
                    return @{
                        Ensure                      = 'Present'
                        Credential                  = $Credential
                        Identity                    = 'DefaultGlobalPolicy'
                        OrganizationBrandingEnabled = $False
                        ESNEnabled                  = $False
                    }
                }

                Mock -CommandName Set-QuarantinePolicy -MockWith {
                    return @{

                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Successfully call the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'QuarantinePolicy removal.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure     = 'Absent'
                    Credential = $Credential
                    Identity   = 'TestQuarantinePolicy'
                }

                Mock -CommandName Get-QuarantinePolicy -MockWith {
                    return @{
                        Identity = 'TestQuarantinePolicy'
                    }
                }

                Mock -CommandName Get-QuarantinePolicy -ParameterFilter { $QuarantinePolicyType -eq 'GlobalQuarantinePolicy' } -MockWith {
                    return @{
                        Identity                    = 'DefaultGlobalPolicy'
                    }
                }

                Mock -CommandName Remove-QuarantinePolicy -MockWith {
                    return @{

                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the Policy in the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

               Mock -CommandName Get-QuarantinePolicy -MockWith {
                    return @{
                        Identity                    = 'DefaultFullAccessPolicy'
                        OrganizationBrandingEnabled = $False
                        ESNEnabled                  = $False
                    }
                }

                Mock -CommandName Get-QuarantinePolicy -ParameterFilter { $QuarantinePolicyType -eq 'GlobalQuarantinePolicy' } -MockWith {
                    return @{
                        Identity                    = 'DefaultGlobalPolicy'
                        OrganizationBrandingEnabled = $False
                        ESNEnabled                  = $False
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
