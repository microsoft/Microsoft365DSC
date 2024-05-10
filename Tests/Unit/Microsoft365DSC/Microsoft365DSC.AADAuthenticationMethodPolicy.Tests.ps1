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
    -DscResource "AADAuthenticationMethodPolicy" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Update-MgBetaPolicyAuthenticationMethodPolicy -MockWith {
            }

            Mock -CommandName Remove-MgBetaPolicyAuthenticationMethodPolicy -MockWith {
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
        Context -Name "The AADAuthenticationMethodPolicy should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Description = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    Id = "FakeStringValue"
                    PolicyMigrationState = "preMigration"
                    PolicyVersion = "FakeStringValue"
                    ReconfirmationInDays = 25
                    RegistrationEnforcement = (New-CimInstance -ClassName MSFT_MicrosoftGraphregistrationEnforcement -Property @{
                        AuthenticationMethodsRegistrationCampaign = (New-CimInstance -ClassName MSFT_MicrosoftGraphauthenticationMethodsRegistrationCampaign -Property @{
                            IncludeTargets = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphauthenticationMethodsRegistrationCampaignIncludeTarget -Property @{
                                    Id = "FakeStringValue"
                                    TargetType = "user"
                                    TargetedAuthenticationMethod = "FakeStringValue"
                                } -ClientOnly)
                            )
                            State = "default"
                            SnoozeDurationInDays = 25
                            ExcludeTargets = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyExcludeTarget -Property @{
                                    TargetType = "user"
                                    Id = "FakeStringValue"
                                } -ClientOnly)
                            )
                        } -ClientOnly)
                    } -ClientOnly)
                    SystemCredentialPreferences = (New-CimInstance -ClassName MSFT_MicrosoftGraphsystemCredentialPreferences -Property @{
                        State = "default"
                        IncludeTargets = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyIncludeTarget -Property @{
                                TargetType = "user"
                                Id = "FakeStringValue"
                            } -ClientOnly)
                        )
                        ExcludeTargets = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyExcludeTarget -Property @{
                                TargetType = "user"
                                Id = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    Ensure = "Present"
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaPolicyAuthenticationMethodPolicy -MockWith {
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

        Context -Name "The AADAuthenticationMethodPolicy Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Description = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    Id = "FakeStringValue"
                    PolicyMigrationState = "preMigration"
                    PolicyVersion = "FakeStringValue"
                    ReconfirmationInDays = 25
                    RegistrationEnforcement = (New-CimInstance -ClassName MSFT_MicrosoftGraphregistrationEnforcement -Property @{
                        AuthenticationMethodsRegistrationCampaign = (New-CimInstance -ClassName MSFT_MicrosoftGraphauthenticationMethodsRegistrationCampaign -Property @{
                            IncludeTargets = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphauthenticationMethodsRegistrationCampaignIncludeTarget -Property @{
                                    Id = "FakeStringValue"
                                    TargetType = "user"
                                    TargetedAuthenticationMethod = "FakeStringValue"
                                } -ClientOnly)
                            )
                            State = "default"
                            SnoozeDurationInDays = 25
                            ExcludeTargets = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyExcludeTarget -Property @{
                                    TargetType = "user"
                                    Id = "FakeStringValue"
                                } -ClientOnly)
                            )
                        } -ClientOnly)
                    } -ClientOnly)
                    SystemCredentialPreferences = (New-CimInstance -ClassName MSFT_MicrosoftGraphsystemCredentialPreferences -Property @{
                        State = "default"
                        IncludeTargets = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyIncludeTarget -Property @{
                                TargetType = "user"
                                Id = "FakeStringValue"
                            } -ClientOnly)
                        )
                        ExcludeTargets = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyExcludeTarget -Property @{
                                TargetType = "user"
                                Id = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    Ensure = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaPolicyAuthenticationMethodPolicy -MockWith {
                    return @{
                        AdditionalProperties = @{
                            '@odata.type' = "#microsoft.graph.AuthenticationMethodsPolicy"
                        }
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        Id = "FakeStringValue"
                        PolicyMigrationState = "preMigration"
                        PolicyVersion = "FakeStringValue"
                        ReconfirmationInDays = 25
                        RegistrationEnforcement = @{
                            AuthenticationMethodsRegistrationCampaign = @{
                                IncludeTargets = @(
                                    @{
                                        Id = "FakeStringValue"
                                        TargetType = "user"
                                        TargetedAuthenticationMethod = "FakeStringValue"
                                    }
                                )
                                State = "default"
                                SnoozeDurationInDays = 25
                                ExcludeTargets = @(
                                    @{
                                        TargetType = "user"
                                        Id = "FakeStringValue"
                                    }
                                )
                            }
                        }
                        SystemCredentialPreferences = @{
                            State = "default"
                            IncludeTargets = @(
                                @{
                                    TargetType = "user"
                                    Id = "FakeStringValue"
                                }
                            )
                            ExcludeTargets = @(
                                @{
                                    TargetType = "user"
                                    Id = "FakeStringValue"
                                }
                            )
                        }

                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The AADAuthenticationMethodPolicy exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Description = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    Id = "FakeStringValue"
                    PolicyMigrationState = "preMigration"
                    PolicyVersion = "FakeStringValue"
                    ReconfirmationInDays = 25
                    RegistrationEnforcement = (New-CimInstance -ClassName MSFT_MicrosoftGraphregistrationEnforcement -Property @{
                        AuthenticationMethodsRegistrationCampaign = (New-CimInstance -ClassName MSFT_MicrosoftGraphauthenticationMethodsRegistrationCampaign -Property @{
                            IncludeTargets = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphauthenticationMethodsRegistrationCampaignIncludeTarget -Property @{
                                    Id = "FakeStringValue"
                                    TargetType = "user"
                                    TargetedAuthenticationMethod = "FakeStringValue"
                                } -ClientOnly)
                            )
                            State = "default"
                            SnoozeDurationInDays = 25
                            ExcludeTargets = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyExcludeTarget -Property @{
                                    TargetType = "user"
                                    Id = "FakeStringValue"
                                } -ClientOnly)
                            )
                        } -ClientOnly)
                    } -ClientOnly)
                    SystemCredentialPreferences = (New-CimInstance -ClassName MSFT_MicrosoftGraphsystemCredentialPreferences -Property @{
                        State = "default"
                        IncludeTargets = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyIncludeTarget -Property @{
                                TargetType = "user"
                                Id = "FakeStringValue"
                            } -ClientOnly)
                        )
                        ExcludeTargets = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyExcludeTarget -Property @{
                                TargetType = "user"
                                Id = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    Ensure = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaPolicyAuthenticationMethodPolicy -MockWith {
                    return @{
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        Id = "FakeStringValue"
                        PolicyMigrationState = "preMigration"
                        PolicyVersion = "FakeStringValue"
                        ReconfirmationInDays = 7
                        RegistrationEnforcement = @{
                            AuthenticationMethodsRegistrationCampaign = @{
                                IncludeTargets = @(
                                    @{
                                        Id = "FakeStringValue"
                                        TargetType = "user"
                                        TargetedAuthenticationMethod = "FakeStringValue"
                                    }
                                )
                                State = "default"
                                SnoozeDurationInDays = 7
                                ExcludeTargets = @(
                                    @{
                                        TargetType = "user"
                                        Id = "FakeStringValue"
                                    }
                                )
                            }
                        }
                        SystemCredentialPreferences = @{
                            State = "default"
                            IncludeTargets = @(
                                @{
                                    TargetType = "user"
                                    Id = "FakeStringValue"
                                }
                            )
                            ExcludeTargets = @(
                                @{
                                    TargetType = "user"
                                    Id = "FakeStringValue"
                                }
                            )
                        }
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
                Should -Invoke -CommandName Update-MgBetaPolicyAuthenticationMethodPolicy -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaPolicyAuthenticationMethodPolicy -MockWith {
                    return @{
                        AdditionalProperties = @{
                            '@odata.type' = "#microsoft.graph.AuthenticationMethodsPolicy"
                        }
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        Id = "FakeStringValue"
                        PolicyMigrationState = "preMigration"
                        PolicyVersion = "FakeStringValue"
                        ReconfirmationInDays = 25
                        RegistrationEnforcement = @{
                            AuthenticationMethodsRegistrationCampaign = @{
                                IncludeTargets = @(
                                    @{
                                        Id = "FakeStringValue"
                                        TargetType = "user"
                                        TargetedAuthenticationMethod = "FakeStringValue"
                                    }
                                )
                                State = "default"
                                SnoozeDurationInDays = 25
                                ExcludeTargets = @(
                                    @{
                                        TargetType = "user"
                                        Id = "FakeStringValue"
                                    }
                                )
                            }
                        }
                        SystemCredentialPreferences = @{
                            State = "default"
                            IncludeTargets = @(
                                @{
                                    TargetType = "user"
                                    Id = "FakeStringValue"
                                }
                            )
                            ExcludeTargets = @(
                                @{
                                    TargetType = "user"
                                    Id = "FakeStringValue"
                                }
                            )
                        }

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
