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

            Mock -ModuleName M365DSCUtil -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Update-MgBetaPolicyAuthenticationMethodPolicy -MockWith {
            }

            Mock -CommandName Remove-MgBetaPolicyAuthenticationMethodPolicy -MockWith {
            }

            Mock -CommandName Get-MgBetaPolicyAuthenticationMethodPolicy -MockWith {
                return @{
                    '@odata.type' = "#microsoft.graph.AuthenticationMethodsPolicy"
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
                    ReportSuspiciousActivitySettings  = @{
                        State = 'default'
                        IncludeTarget = @{
                            TargetType = 'group'
                            Id = "a8ab05ba-6680-4f93-88ae-71099eedfda1"
                        }
                        VoiceReportingCode  = 0
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

            Mock -CommandName Get-MgGroup -ModuleName M365DSCUtil -MockWith {
                return @{
                    DisplayName = "FakeStringValue2"
                    Id = "a8ab05ba-6680-4f93-88ae-71099eedfda1"
                }
            }

            Mock -CommandName Get-MgUser -ModuleName M365DSCUtil -MockWith {
                return @{
                    Id = "FakeStringValue"
                    UserPrincipalName = "FakeStringValue"
                }
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            # Mock Write-M365DSCHost to hide output during the tests
            Mock -CommandName Write-M365DSCHost -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }
        # Test contexts
        Context -Name "The AADAuthenticationMethodPolicy should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
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
                    ReportSuspiciousActivitySettings = (New-CimInstance -ClassName MSFT_MicrosoftGraphreportSuspiciousActivitySettings -Property @{
                        VoiceReportingCode = 0
                        State = 'default'
                        IncludeTarget = (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyIncludeTarget -Property @{
                                Id = 'FakeStringValue2'
                                TargetType = 'group'
                        } -ClientOnly)
                    } -ClientOnly);
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
                    IsSingleInstance = 'Yes'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaPolicyAuthenticationMethodPolicy -MockWith {
                    return $null
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).IsSingleInstance | Should -Be 'Yes'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
        }

        Context -Name "The AADAuthenticationMethodPolicy Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
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
                    ReportSuspiciousActivitySettings = (New-CimInstance -ClassName MSFT_MicrosoftGraphreportSuspiciousActivitySettings -Property @{
                        VoiceReportingCode = 0
                        State = 'default'
                        IncludeTarget = (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyIncludeTarget -Property @{
                                Id = 'FakeStringValue2'
                                TargetType = 'group'
                        } -ClientOnly)
                    } -ClientOnly);
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
                    IsSingleInstance = 'Yes'
                    Credential = $Credential;
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The AADAuthenticationMethodPolicy exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
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
                    ReportSuspiciousActivitySettings = (New-CimInstance -ClassName MSFT_MicrosoftGraphreportSuspiciousActivitySettings -Property @{
                        VoiceReportingCode = 1 # Drift
                        State = 'default'
                        IncludeTarget = (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyIncludeTarget -Property @{
                                Id = 'FakeStringValue2'
                                TargetType = 'group'
                        } -ClientOnly)
                    } -ClientOnly);
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
                    IsSingleInstance = 'Yes'
                    Credential = $Credential;
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).IsSingleInstance | Should -Be 'Yes'
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
            }
            It 'Should Reverse Engineer resource from the Export method' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
