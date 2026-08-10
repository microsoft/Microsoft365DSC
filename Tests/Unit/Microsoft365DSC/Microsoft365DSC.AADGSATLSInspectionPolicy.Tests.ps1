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

# Force a fresh import of the stubs so newly added stub functions are available
Remove-Module -Name 'Microsoft365' -Force -ErrorAction SilentlyContinue

$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource $ResourceName -GenericStubModule $GenericStubPath

# Clear the schema cache to ensure the regenerated schema is loaded
[Microsoft365DSC.Cache.CacheManager]::ClearSchema()

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -ModuleName M365DSCUtil -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName New-MgBetaNetworkAccessTlInspectionPolicy -MockWith {}
            Mock -CommandName Update-MgBetaNetworkAccessTlInspectionPolicy -MockWith {}
            Mock -CommandName Remove-MgBetaNetworkAccessTlInspectionPolicy -MockWith {}
            Mock -CommandName Get-MgBetaNetworkAccessTlInspectionPolicy -MockWith {
                return @{
                    Name        = 'Contoso TLS Inspection Policy'
                    Id          = 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee'
                    Description = 'Default TLS inspection policy for Contoso'
                    Settings    = @{
                        DefaultAction = 'bypass'
                    }
                }
            }

            Mock -CommandName Write-M365DSCHost -MockWith {}
            $Script:exportedInstances = $null
            $Script:ExportMode = $false
        }

        Context -Name 'The instance should exist but it DOES NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    Name          = 'Contoso TLS Inspection Policy'
                    Description   = 'Default TLS inspection policy for Contoso'
                    DefaultAction = 'bypass'
                    Ensure        = 'Present'
                    Credential    = $Credential
                }

                Mock -CommandName Get-MgBetaNetworkAccessTlInspectionPolicy -MockWith {
                    return $null
                }
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should create a new instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-MgBetaNetworkAccessTlInspectionPolicy -Exactly 1
            }
        }

        Context -Name 'The instance exists but it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    Name          = 'Contoso TLS Inspection Policy'
                    Description   = 'Default TLS inspection policy for Contoso'
                    DefaultAction = 'bypass'
                    Ensure        = 'Absent'
                    Credential    = $Credential
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should remove the instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgBetaNetworkAccessTlInspectionPolicy -Exactly 1
            }
        }

        Context -Name 'The instance exists and values are in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    Name          = 'Contoso TLS Inspection Policy'
                    Description   = 'Default TLS inspection policy for Contoso'
                    DefaultAction = 'bypass'
                    Ensure        = 'Present'
                    Credential    = $Credential
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'The instance exists and values are NOT in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    Name          = 'Contoso TLS Inspection Policy'
                    Description   = 'Default TLS inspection policy for Contoso'
                    DefaultAction = 'inspect'  # Drift: was 'bypass'
                    Ensure        = 'Present'
                    Credential    = $Credential
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should update the instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgBetaNetworkAccessTlInspectionPolicy -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaNetworkAccessTlInspectionPolicy -MockWith {
                    return @{
                        Name        = 'Contoso TLS Inspection Policy'
                        Id          = 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee'
                        Description = 'Default TLS inspection policy for Contoso'
                        Settings    = @{
                            DefaultAction = 'bypass'
                        }
                    }
                }
            }

            It 'Should reverse engineer resource from the Export method' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}
