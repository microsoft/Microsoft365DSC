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
    -DscResource 'TeamsTenantDialPlan' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString ((New-Guid).ToString()) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            $Global:PartialExportFileName = 'c:\TestPath'

            Mock -CommandName Save-M365DSCPartialExport -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Set-CsTenantDialPlan -MockWith {
            }

            Mock -CommandName Remove-CsTenantDialPlan -MockWith {
            }

            Mock -CommandName New-CsTenantDialPlan -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name "The dial plan doesn't exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity   = 'TestPlan'
                    Ensure     = 'Present'
                    Credential = $Credential
                }

                Mock -CommandName Get-CsTenantDialPlan -MockWith {
                    return $null
                }
            }

            It 'Should return false from the Test method' {
                [boolean] $result = Test-TargetResource @testParams
                $result | Should -Be $false
            }

            It 'Should return False for the Ensure property from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Create the dial plan Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-CsTenantDialPlan -Exactly 1
            }
        }

        Context -Name 'The dial plan exists but is NOT in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity           = 'Test'
                    Description        = 'TestDescription'
                    Ensure             = 'Present'
                    NormalizationRules = @(New-CimInstance -ClassName MSFT_TeamsVoiceNormalizationRule -Property @{
                            Pattern             = '^00(\d+)$'
                            Description         = 'None'
                            Identity            = 'TestNotExisting'
                            Translation         = '+$1'
                            Priority            = 0
                            IsInternalExtension = $False
                        } -ClientOnly;
                        New-CimInstance -ClassName MSFT_TeamsVoiceNormalizationRule -Property @{
                            Pattern             = '^00(\d+)$'
                            Description         = 'None'
                            Identity            = 'TestNotExisting2'
                            Translation         = '+$1'
                            Priority            = 0
                            IsInternalExtension = $False
                        } -ClientOnly)
                    Credential         = $Credential
                }

                Mock -CommandName Get-CsTenantDialPlan -MockWith {
                    return @{
                        Identity           = 'Test'
                        Description        = 'TestDescription'
                        NormalizationRules = @{
                            Pattern             = '^00(\d+)$'
                            Description         = 'None'
                            Name                = 'TestNotExisting'
                            Translation         = '+$1'
                            Priority            = 0
                            IsInternalExtension = $False
                        }
                    }
                }
            }

            It 'Should return false from the Test method' {
                [boolean] $result = Test-TargetResource @testParams
                $result | Should -Be $false
            }

            It 'Should return True for the Ensure property from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Updates in the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-CsTenantDialPlan -Exactly 1
            }
        }

        Context -Name 'The dial plan exists and IS in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity           = 'Test'
                    Description        = 'TestDescription'
                    Ensure             = 'Present'
                    NormalizationRules = @(New-CimInstance -ClassName MSFT_TeamsVoiceNormalizationRule -Property @{
                            Pattern             = '^00(\d+)$'
                            Description         = 'None'
                            Identity            = 'TestNotExisting'
                            Translation         = '+$1'
                            Priority            = 0
                            IsInternalExtension = $False
                        } -ClientOnly;
                        New-CimInstance -ClassName MSFT_TeamsVoiceNormalizationRule -Property @{
                            Pattern             = '^00(\d+)$'
                            Description         = 'None'
                            Identity            = 'TestNotExisting2'
                            Translation         = '+$1'
                            Priority            = 0
                            IsInternalExtension = $False
                        } -ClientOnly)
                    Credential         = $Credential
                }

                Mock -CommandName Get-CsTenantDialPlan -MockWith {
                    return @{
                        Identity           = 'Test'
                        Description        = 'TestDescription'
                        NormalizationRules = @(@{
                                Pattern             = '^00(\d+)$'
                                Description         = 'None'
                                Name                = 'TestNotExisting'
                                Translation         = '+$1'
                                Priority            = 0
                                IsInternalExtension = $False
                            },
                            @{
                                Pattern             = '^00(\d+)$'
                                Description         = 'None'
                                Name                = 'TestNotExisting2'
                                Translation         = '+$1'
                                Priority            = 0
                                IsInternalExtension = $False
                            }
                        )
                    }
                }
            }

            It 'Should return true from the Test method' {
                [boolean] $result = Test-TargetResource @testParams
                $result | Should -Be $true
            }

            It 'Should return True for the Ensure property from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
        }

        Context -Name 'The dial plan exists but it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity    = 'Test'
                    Description = 'TestDescription'
                    Ensure      = 'Absent'
                    Credential  = $Credential
                }

                Mock -CommandName Get-CsTenantDialPlan -MockWith {
                    return @{
                        Identity           = 'Test'
                        Description        = 'TestDescription'
                        NormalizationRules = @(@{
                                Pattern             = '^00(\d+)$'
                                Description         = 'None'
                                Name                = 'TestNotExisting'
                                Translation         = '+$1'
                                Priority            = 0
                                IsInternalExtension = $False
                            },
                            @{
                                Pattern             = '^00(\d+)$'
                                Description         = 'None'
                                Name                = 'TestNotExisting2'
                                Translation         = '+$1'
                                Priority            = 0
                                IsInternalExtension = $False
                            }
                        )
                    }
                }
            }

            It 'Should return false from the Test method' {
                [boolean] $result = Test-TargetResource @testParams
                $result | Should -Be $false
            }

            It 'Should return True for the Ensure property from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }


            It 'Remove the dial plan in the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-CsTenantDialPlan -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-CsTenantDialPlan -MockWith {
                    return @{
                        Identity           = 'Test'
                        Description        = 'TestDescription'
                        NormalizationRules = @(@{
                                Pattern             = '^00(\d+)$'
                                Description         = 'None'
                                Name                = 'TestNotExisting'
                                Translation         = '+$1'
                                Priority            = 0
                                IsInternalExtension = $False
                            },
                            @{
                                Pattern             = '^00(\d+)$'
                                Description         = 'None'
                                Name                = 'TestNotExisting2'
                                Translation         = '+$1'
                                Priority            = 0
                                IsInternalExtension = $False
                            }
                        )
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
