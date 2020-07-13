[CmdletBinding()]
param(
)
$M365DSCTestFolder = Join-Path -Path $PSScriptRoot `
                        -ChildPath "..\..\Unit" `
                        -Resolve
$CmdletModule = (Join-Path -Path $M365DSCTestFolder `
            -ChildPath "\Stubs\Microsoft365.psm1" `
            -Resolve)
$GenericStubPath = (Join-Path -Path $M365DSCTestFolder `
    -ChildPath "\Stubs\Generic.psm1" `
    -Resolve)
Import-Module -Name (Join-Path -Path $M365DSCTestFolder `
        -ChildPath "\UnitTestHelper.psm1" `
        -Resolve)

$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource "TeamsTenantDialPlan" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString "Pass@word1" -AsPlainText -Force
            $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credential"
            }

            Mock -CommandName Set-CsTenantDialPlan -MockWith {
            }

            Mock -CommandName Remove-CsTenantDialPlan -MockWith {
            }

            Mock -CommandName New-CsTenantDialPlan -MockWith {
            }
        }

        # Test contexts
        Context -Name "The dial plan doesn't exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity            = "TestPlan";
                    Ensure              = 'Present'
                    GlobalAdminAccount  = $GlobalAdminAccount;
                }

                Mock -CommandName Get-CsTenantDialPlan -MockWith {
                    return $null
                }
            }

            It "Should return false from the Test method" {
                [boolean] $result = Test-TargetResource @testParams
                $result | Should -Be $false
            }

            It "Should return False for the Ensure property from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It "Create the dial plan Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-CsTenantDialPlan -Exactly 1
            }
        }

        Context -Name "The dial plan exists but is NOT in the Desired State" -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity           = "Test";
                    Description        = "TestDescription";
                    Ensure             = "Present"
                    NormalizationRules = @(New-CimInstance -ClassName MSFT_TeamsVoiceNormalizationRule -Property @{
                        Pattern = '^00(\d+)$'
                        Description = 'None'
                        Identity = 'TestNotExisting'
                        Translation = '+$1'
                        Priority = 0
                        IsInternalExtension = $False
                    } -ClientOnly;
                    New-CimInstance -ClassName MSFT_TeamsVoiceNormalizationRule -Property @{
                        Pattern = '^00(\d+)$'
                        Description = 'None'
                        Identity = 'TestNotExisting2'
                        Translation = '+$1'
                        Priority = 0
                        IsInternalExtension = $False
                    } -ClientOnly;)
                    GlobalAdminAccount = $GlobalAdminAccount;
                }

                Mock -CommandName Get-CsTenantDialPlan -MockWith {
                    return @{
                        Identity           = 'Test'
                        Description        = "TestDescription";
                        NormalizationRules = @{
                            Pattern = '^00(\d+)$'
                            Description = 'None'
                            Name = 'TestNotExisting'
                            Translation = '+$1'
                            Priority = 0
                            IsInternalExtension = $False
                        }
                    }
                }
            }

            It "Should return false from the Test method" {
                [boolean] $result = Test-TargetResource @testParams
                $result | Should -Be $false
            }

            It "Should return True for the Ensure property from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It "Updates in the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-CsTenantDialPlan -Exactly 1
            }
        }

        Context -Name "The dial plan exists and IS in the Desired State" -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity           = "Test";
                    Description        = "TestDescription";
                    Ensure             = "Present"
                    NormalizationRules = @(New-CimInstance -ClassName MSFT_TeamsVoiceNormalizationRule -Property @{
                        Pattern = '^00(\d+)$'
                        Description = 'None'
                        Identity = 'TestNotExisting'
                        Translation = '+$1'
                        Priority = 0
                        IsInternalExtension = $False
                    } -ClientOnly;
                    New-CimInstance -ClassName MSFT_TeamsVoiceNormalizationRule -Property @{
                        Pattern = '^00(\d+)$'
                        Description = 'None'
                        Identity = 'TestNotExisting2'
                        Translation = '+$1'
                        Priority = 0
                        IsInternalExtension = $False
                    } -ClientOnly;)
                    GlobalAdminAccount = $GlobalAdminAccount;
                }

                Mock -CommandName Get-CsTenantDialPlan -MockWith {
                    return @{
                        Identity           = 'Test'
                        Description        = "TestDescription";
                        NormalizationRules = @(@{
                            Pattern = '^00(\d+)$'
                            Description = 'None'
                            Name = 'TestNotExisting'
                            Translation = '+$1'
                            Priority = 0
                            IsInternalExtension = $False
                        },
                        @{
                            Pattern = '^00(\d+)$'
                            Description = 'None'
                            Name = 'TestNotExisting2'
                            Translation = '+$1'
                            Priority = 0
                            IsInternalExtension = $False
                        }
                        )
                    }
                }
            }
            It "Should return true from the Test method" {
                [boolean] $result = Test-TargetResource @testParams
                $result | Should -Be $true
            }

            It "Should return True for the Ensure property from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
        }

        Context -Name "The dial plan exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity           = "Test";
                    Description        = "TestDescription";
                    Ensure             = "Absent"
                    GlobalAdminAccount = $GlobalAdminAccount;
                }

                Mock -CommandName Get-CsTenantDialPlan -MockWith {
                    return @{
                        Identity           = 'Test'
                        Description        = "TestDescription";
                        NormalizationRules = @(@{
                            Pattern = '^00(\d+)$'
                            Description = 'None'
                            Name = 'TestNotExisting'
                            Translation = '+$1'
                            Priority = 0
                            IsInternalExtension = $False
                        },
                        @{
                            Pattern = '^00(\d+)$'
                            Description = 'None'
                            Name = 'TestNotExisting2'
                            Translation = '+$1'
                            Priority = 0
                            IsInternalExtension = $False
                        }
                        )
                    }
                }
            }

            It "Should return false from the Test method" {
                [boolean] $result = Test-TargetResource @testParams
                $result | Should -Be $false
            }

            It "Should return True for the Ensure property from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }


            It "Remove the dial plan in the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-CsTenantDialPlan -Exactly 1
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount = $GlobalAdminAccount
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
