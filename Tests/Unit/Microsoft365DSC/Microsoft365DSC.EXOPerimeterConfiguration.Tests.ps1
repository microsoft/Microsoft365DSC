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
    -DscResource 'EXOPerimeterConfiguration' -GenericStubModule $GenericStubPath
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

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Set-PerimeterConfig -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }

        # Test contexts
        Context -Name 'Config is not in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    Credential         = $Credential
                    Ensure             = 'Present'
                    GatewayIPAddresses = @('127.0.0.1')
                    Identity           = 'Tenant Perimeter Settings'
                }

                Mock -CommandName Get-PerimeterConfig -MockWith {
                    return @{
                        Credential         = $Credential
                        Ensure             = 'Present'
                        GatewayIPAddresses = @('127.0.0.2'); #Drift
                        Identity           = 'Tenant Perimeter Settings'
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-PerimeterConfig -Exactly 1
            }
        }

        Context -Name 'Config is already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    Credential         = $Credential
                    Ensure             = 'Present'
                    GatewayIPAddresses = @('127.0.0.1')
                    Identity           = 'Tenant Perimeter Settings'
                }

                Mock -CommandName Get-PerimeterConfig -MockWith {
                    return @{
                        Credential         = $Credential
                        Ensure             = 'Present'
                        GatewayIPAddresses = @('127.0.0.1')
                        Identity           = 'Tenant Perimeter Settings'
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-PerimeterConfig -MockWith {
                    return @{
                        Credential         = $Credential
                        Ensure             = 'Present'
                        GatewayIPAddresses = @('127.0.0.1')
                        Identity           = 'Tenant Perimeter Settings'
                    }
                }
            }

            It 'Should Reverse Engineer resource from the Export' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
