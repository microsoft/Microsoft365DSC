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

            Mock -CommandName New-MgBetaNetworkAccessTlInspectionPolicy -MockWith { return @{ Id = 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee' } }
            Mock -CommandName Update-MgBetaNetworkAccessTlInspectionPolicy -MockWith {}
            Mock -CommandName Remove-MgBetaNetworkAccessTlInspectionPolicy -MockWith {}
            Mock -CommandName Get-MgBetaNetworkAccessTlInspectionPolicyRule -MockWith {}
            Mock -CommandName New-MgBetaNetworkAccessTlInspectionPolicyRule -MockWith {}
            Mock -CommandName Update-MgBetaNetworkAccessTlInspectionPolicyRule -MockWith {}
            Mock -CommandName Remove-MgBetaNetworkAccessTlInspectionPolicyRule -MockWith {}
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

        Context -Name 'The instance exists and Rules are NOT in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    Name          = 'Contoso TLS Inspection Policy'
                    Description   = 'Default TLS inspection policy for Contoso'
                    DefaultAction = 'bypass'
                    Ensure        = 'Present'
                    Credential    = $Credential
                    Rules         = @(
                        (New-CimInstance -ClassName MSFT_AADGSATLSInspectionPolicyRule -Property @{
                                Name         = 'test rule 01'
                                Priority     = [System.UInt32]100
                                Description  = 'test rule 01 description'
                                Action       = 'inspect'
                                Status       = 'enabled'
                                Destinations = [Microsoft.Management.Infrastructure.CimInstance[]](, (New-CimInstance -ClassName MSFT_AADGSATLSInspectionPolicyRuleDestination -Property @{
                                            Type   = 'tlsInspectionFqdnDestination'
                                            Values = [System.String[]]@('contoso.com')
                                        } -ClientOnly))
                            } -ClientOnly),
                        (New-CimInstance -ClassName MSFT_AADGSATLSInspectionPolicyRule -Property @{
                                Name     = 'System Bypass TLS inspection rule'
                                Priority = [System.UInt32]50
                                Action   = 'bypass'
                                Status   = 'enabled'
                            } -ClientOnly)
                    )
                }

                Mock -CommandName Get-MgBetaNetworkAccessTlInspectionPolicy -MockWith {
                    return @{
                        Name        = 'Contoso TLS Inspection Policy'
                        Id          = 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee'
                        Description = 'Default TLS inspection policy for Contoso'
                        Settings    = @{
                            DefaultAction = 'bypass'
                        }
                        PolicyRules = @(
                            @{
                                Id                 = 'existing-rule-id'
                                Name               = 'test rule to remove'
                                Priority           = 200
                                Action             = 'bypass'
                                Settings           = @{ Status = 'enabled' }
                                MatchingConditions = $null
                            }
                        )
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should create the new rules and remove the stale rule from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-MgBetaNetworkAccessTlInspectionPolicyRule -Exactly 2
                Should -Invoke -CommandName Remove-MgBetaNetworkAccessTlInspectionPolicyRule -Exactly 1
            }

            It 'Should always send matchingConditions, even for a rule without destinations' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-MgBetaNetworkAccessTlInspectionPolicyRule -ParameterFilter {
                    $BodyParameter.name -eq 'System Bypass TLS inspection rule' -and
                    $BodyParameter.ContainsKey('matchingConditions') -and
                    $BodyParameter.matchingConditions.destinations.Count -eq 0
                }
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
                        PolicyRules = @(
                            @{
                                Id                 = 'e0cf2cb9-29cf-4e3e-b73f-0f521b2a095c'
                                Name               = 'test rule 01'
                                Priority           = 100
                                Description        = 'test rule 01 description'
                                Action             = 'inspect'
                                Settings           = @{ Status = 'enabled' }
                                MatchingConditions = @{
                                    Destinations = @(
                                        @{
                                            '@odata.type' = '#microsoft.graph.networkaccess.tlsInspectionFqdnDestination'
                                            Values        = @('contoso.com')
                                        }
                                    )
                                }
                            },
                            @{
                                Id                 = '72d8838d-2b8f-4f0a-aba2-ee5302b10457'
                                Name               = 'System Bypass TLS inspection rule'
                                Priority           = 50
                                Description        = 'Auto-created TLS rule for system bypass categories.'
                                Action             = 'bypass'
                                Settings           = @{ Status = 'enabled' }
                                MatchingConditions = $null
                            },
                            @{
                                Id                 = '70c325ce-29f1-4cc5-a821-8e6e6ecd37ec'
                                Name               = 'Recommended TLS inspection bypass categories rule'
                                Priority           = 65000
                                Description        = 'Auto-created TLS rule for recommended bypass categories.'
                                Action             = 'bypass'
                                Settings           = @{ Status = 'enabled' }
                                MatchingConditions = @{
                                    Destinations = @(
                                        @{
                                            '@odata.type' = '#microsoft.graph.networkaccess.tlsInspectionWebCategoryDestination'
                                            Values        = @('Education', 'Finance', 'Government', 'HealthAndMedicine')
                                        }
                                    )
                                }
                            }
                        )
                    }
                }
            }

            It 'Should reverse engineer resource from the Export method' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }

            It 'Should exclude the auto-created system rules from the Get method' {
                $result = Get-TargetResource -Name 'Contoso TLS Inspection Policy' -Credential $Credential
                $result.Rules.Name | Should -Not -Contain 'System Bypass TLS inspection rule'
                $result.Rules.Name | Should -Not -Contain 'Recommended TLS inspection bypass categories rule'
                $result.Rules.Name | Should -Contain 'test rule 01'
            }
        }
    }
}
