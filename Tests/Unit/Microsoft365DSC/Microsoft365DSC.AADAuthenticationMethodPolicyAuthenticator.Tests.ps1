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
    -DscResource "AADAuthenticationMethodPolicyAuthenticator" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString "f@kepassword1" -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-MgPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration -MockWith {
            }

            Mock -CommandName New-MgPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration -MockWith {
            }

            Mock -CommandName Remove-MgPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }
        # Test contexts
        Context -Name "The AADAuthenticationMethodPolicyAuthenticator should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    ExcludeTargets = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphexcludeTarget2 -Property @{
                            TargetType = "user"
                            Id = "FakeStringValue"
                        } -ClientOnly)
                    )
                    featureSettings = (New-CimInstance -ClassName MSFT_MicrosoftGraphmicrosoftAuthenticatorFeatureSettings -Property @{
                        companionAppAllowedState = (New-CimInstance -ClassName MSFT_MicrosoftGraphauthenticationMethodFeatureConfiguration -Property @{
                            state = "default"
                            includeTarget = (New-CimInstance -ClassName MSFT_MicrosoftGraphfeatureTarget -Property @{
                                targetType = "group"
                                id = "FakeStringValue"
                            } -ClientOnly)
                            excludeTarget = (New-CimInstance -ClassName MSFT_MicrosoftGraphfeatureTarget -Property @{
                                targetType = "group"
                                id = "FakeStringValue"
                            } -ClientOnly)
                        } -ClientOnly)
                        displayAppInformationRequiredState = (New-CimInstance -ClassName MSFT_MicrosoftGraphauthenticationMethodFeatureConfiguration -Property @{
                            state = "default"
                            includeTarget = (New-CimInstance -ClassName MSFT_MicrosoftGraphfeatureTarget -Property @{
                                targetType = "group"
                                id = "FakeStringValue"
                            } -ClientOnly)
                            excludeTarget = (New-CimInstance -ClassName MSFT_MicrosoftGraphfeatureTarget -Property @{
                                targetType = "group"
                                id = "FakeStringValue"
                            } -ClientOnly)
                        } -ClientOnly)
                        displayLocationInformationRequiredState = (New-CimInstance -ClassName MSFT_MicrosoftGraphauthenticationMethodFeatureConfiguration -Property @{
                            state = "default"
                            includeTarget = (New-CimInstance -ClassName MSFT_MicrosoftGraphfeatureTarget -Property @{
                                targetType = "group"
                                id = "FakeStringValue"
                            } -ClientOnly)
                            excludeTarget = (New-CimInstance -ClassName MSFT_MicrosoftGraphfeatureTarget -Property @{
                                targetType = "group"
                                id = "FakeStringValue"
                            } -ClientOnly)
                        } -ClientOnly)
                        numberMatchingRequiredState = (New-CimInstance -ClassName MSFT_MicrosoftGraphauthenticationMethodFeatureConfiguration -Property @{
                            state = "default"
                            includeTarget = (New-CimInstance -ClassName MSFT_MicrosoftGraphfeatureTarget -Property @{
                                targetType = "group"
                                id = "FakeStringValue"
                            } -ClientOnly)
                            excludeTarget = (New-CimInstance -ClassName MSFT_MicrosoftGraphfeatureTarget -Property @{
                                targetType = "group"
                                id = "FakeStringValue"
                            } -ClientOnly)
                        } -ClientOnly)
                    } -ClientOnly)
                    Id = "FakeStringValue"
                    isSoftwareOathEnabled = $True
                    State = "enabled"
                    Ensure = "Present"
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration -MockWith {
                    return $null
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should Create the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-MgPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration -Exactly 1
            }
        }

        Context -Name "The AADAuthenticationMethodPolicyAuthenticator exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    ExcludeTargets = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphexcludeTarget2 -Property @{
                            TargetType = "user"
                            Id = "FakeStringValue"
                        } -ClientOnly)
                    )
                    featureSettings = (New-CimInstance -ClassName MSFT_MicrosoftGraphmicrosoftAuthenticatorFeatureSettings -Property @{
                        companionAppAllowedState = (New-CimInstance -ClassName MSFT_MicrosoftGraphauthenticationMethodFeatureConfiguration -Property @{
                            state = "default"
                            includeTarget = (New-CimInstance -ClassName MSFT_MicrosoftGraphfeatureTarget -Property @{
                                targetType = "group"
                                id = "FakeStringValue"
                            } -ClientOnly)
                            excludeTarget = (New-CimInstance -ClassName MSFT_MicrosoftGraphfeatureTarget -Property @{
                                targetType = "group"
                                id = "FakeStringValue"
                            } -ClientOnly)
                        } -ClientOnly)
                        displayAppInformationRequiredState = (New-CimInstance -ClassName MSFT_MicrosoftGraphauthenticationMethodFeatureConfiguration -Property @{
                            state = "default"
                            includeTarget = (New-CimInstance -ClassName MSFT_MicrosoftGraphfeatureTarget -Property @{
                                targetType = "group"
                                id = "FakeStringValue"
                            } -ClientOnly)
                            excludeTarget = (New-CimInstance -ClassName MSFT_MicrosoftGraphfeatureTarget -Property @{
                                targetType = "group"
                                id = "FakeStringValue"
                            } -ClientOnly)
                        } -ClientOnly)
                        displayLocationInformationRequiredState = (New-CimInstance -ClassName MSFT_MicrosoftGraphauthenticationMethodFeatureConfiguration -Property @{
                            state = "default"
                            includeTarget = (New-CimInstance -ClassName MSFT_MicrosoftGraphfeatureTarget -Property @{
                                targetType = "group"
                                id = "FakeStringValue"
                            } -ClientOnly)
                            excludeTarget = (New-CimInstance -ClassName MSFT_MicrosoftGraphfeatureTarget -Property @{
                                targetType = "group"
                                id = "FakeStringValue"
                            } -ClientOnly)
                        } -ClientOnly)
                        numberMatchingRequiredState = (New-CimInstance -ClassName MSFT_MicrosoftGraphauthenticationMethodFeatureConfiguration -Property @{
                            state = "default"
                            includeTarget = (New-CimInstance -ClassName MSFT_MicrosoftGraphfeatureTarget -Property @{
                                targetType = "group"
                                id = "FakeStringValue"
                            } -ClientOnly)
                            excludeTarget = (New-CimInstance -ClassName MSFT_MicrosoftGraphfeatureTarget -Property @{
                                targetType = "group"
                                id = "FakeStringValue"
                            } -ClientOnly)
                        } -ClientOnly)
                    } -ClientOnly)
                    Id = "FakeStringValue"
                    isSoftwareOathEnabled = $True
                    State = "enabled"
                    Ensure = 'Absent'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            featureSettings = @{
                                companionAppAllowedState = @{
                                    state = "default"
                                    includeTarget = @{
                                        targetType = "group"
                                        id = "FakeStringValue"
                                    }
                                    excludeTarget = @{
                                        targetType = "group"
                                        id = "FakeStringValue"
                                    }
                                }
                                displayAppInformationRequiredState = @{
                                    state = "default"
                                    includeTarget = @{
                                        targetType = "group"
                                        id = "FakeStringValue"
                                    }
                                    excludeTarget = @{
                                        targetType = "group"
                                        id = "FakeStringValue"
                                    }
                                }
                                displayLocationInformationRequiredState = @{
                                    state = "default"
                                    includeTarget = @{
                                        targetType = "group"
                                        id = "FakeStringValue"
                                    }
                                    excludeTarget = @{
                                        targetType = "group"
                                        id = "FakeStringValue"
                                    }
                                }
                                numberMatchingRequiredState = @{
                                    state = "default"
                                    includeTarget = @{
                                        targetType = "group"
                                        id = "FakeStringValue"
                                    }
                                    excludeTarget = @{
                                        targetType = "group"
                                        id = "FakeStringValue"
                                    }
                                }
                            }
                            '@odata.type' = "#microsoft.graph.microsoftAuthenticatorAuthenticationMethodConfiguration"
                            isSoftwareOathEnabled = $True
                        }
                        ExcludeTargets = @(
                            @{
                                TargetType = "user"
                                Id = "FakeStringValue"
                            }
                        )
                        Id = "FakeStringValue"
                        State = "enabled"

                    }
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration -Exactly 1
            }
        }
        Context -Name "The AADAuthenticationMethodPolicyAuthenticator Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    ExcludeTargets = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphexcludeTarget2 -Property @{
                            TargetType = "user"
                            Id = "FakeStringValue"
                        } -ClientOnly)
                    )
                    featureSettings = (New-CimInstance -ClassName MSFT_MicrosoftGraphmicrosoftAuthenticatorFeatureSettings -Property @{
                        companionAppAllowedState = (New-CimInstance -ClassName MSFT_MicrosoftGraphauthenticationMethodFeatureConfiguration -Property @{
                            state = "default"
                            includeTarget = (New-CimInstance -ClassName MSFT_MicrosoftGraphfeatureTarget -Property @{
                                targetType = "group"
                                id = "FakeStringValue"
                            } -ClientOnly)
                            excludeTarget = (New-CimInstance -ClassName MSFT_MicrosoftGraphfeatureTarget -Property @{
                                targetType = "group"
                                id = "FakeStringValue"
                            } -ClientOnly)
                        } -ClientOnly)
                        displayAppInformationRequiredState = (New-CimInstance -ClassName MSFT_MicrosoftGraphauthenticationMethodFeatureConfiguration -Property @{
                            state = "default"
                            includeTarget = (New-CimInstance -ClassName MSFT_MicrosoftGraphfeatureTarget -Property @{
                                targetType = "group"
                                id = "FakeStringValue"
                            } -ClientOnly)
                            excludeTarget = (New-CimInstance -ClassName MSFT_MicrosoftGraphfeatureTarget -Property @{
                                targetType = "group"
                                id = "FakeStringValue"
                            } -ClientOnly)
                        } -ClientOnly)
                        displayLocationInformationRequiredState = (New-CimInstance -ClassName MSFT_MicrosoftGraphauthenticationMethodFeatureConfiguration -Property @{
                            state = "default"
                            includeTarget = (New-CimInstance -ClassName MSFT_MicrosoftGraphfeatureTarget -Property @{
                                targetType = "group"
                                id = "FakeStringValue"
                            } -ClientOnly)
                            excludeTarget = (New-CimInstance -ClassName MSFT_MicrosoftGraphfeatureTarget -Property @{
                                targetType = "group"
                                id = "FakeStringValue"
                            } -ClientOnly)
                        } -ClientOnly)
                        numberMatchingRequiredState = (New-CimInstance -ClassName MSFT_MicrosoftGraphauthenticationMethodFeatureConfiguration -Property @{
                            state = "default"
                            includeTarget = (New-CimInstance -ClassName MSFT_MicrosoftGraphfeatureTarget -Property @{
                                targetType = "group"
                                id = "FakeStringValue"
                            } -ClientOnly)
                            excludeTarget = (New-CimInstance -ClassName MSFT_MicrosoftGraphfeatureTarget -Property @{
                                targetType = "group"
                                id = "FakeStringValue"
                            } -ClientOnly)
                        } -ClientOnly)
                    } -ClientOnly)
                    Id = "FakeStringValue"
                    isSoftwareOathEnabled = $True
                    State = "enabled"
                    Ensure = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            featureSettings = @{
                                companionAppAllowedState = @{
                                    state = "default"
                                    includeTarget = @{
                                        targetType = "group"
                                        id = "FakeStringValue"
                                    }
                                    excludeTarget = @{
                                        targetType = "group"
                                        id = "FakeStringValue"
                                    }
                                }
                                displayAppInformationRequiredState = @{
                                    state = "default"
                                    includeTarget = @{
                                        targetType = "group"
                                        id = "FakeStringValue"
                                    }
                                    excludeTarget = @{
                                        targetType = "group"
                                        id = "FakeStringValue"
                                    }
                                }
                                displayLocationInformationRequiredState = @{
                                    state = "default"
                                    includeTarget = @{
                                        targetType = "group"
                                        id = "FakeStringValue"
                                    }
                                    excludeTarget = @{
                                        targetType = "group"
                                        id = "FakeStringValue"
                                    }
                                }
                                numberMatchingRequiredState = @{
                                    state = "default"
                                    includeTarget = @{
                                        targetType = "group"
                                        id = "FakeStringValue"
                                    }
                                    excludeTarget = @{
                                        targetType = "group"
                                        id = "FakeStringValue"
                                    }
                                }
                            }
                            '@odata.type' = "#microsoft.graph.microsoftAuthenticatorAuthenticationMethodConfiguration"
                            isSoftwareOathEnabled = $True
                        }
                        ExcludeTargets = @(
                            @{
                                TargetType = "user"
                                Id = "FakeStringValue"
                            }
                        )
                        Id = "FakeStringValue"
                        State = "enabled"

                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The AADAuthenticationMethodPolicyAuthenticator exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    ExcludeTargets = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphexcludeTarget2 -Property @{
                            TargetType = "user"
                            Id = "FakeStringValue"
                        } -ClientOnly)
                    )
                    featureSettings = (New-CimInstance -ClassName MSFT_MicrosoftGraphmicrosoftAuthenticatorFeatureSettings -Property @{
                        companionAppAllowedState = (New-CimInstance -ClassName MSFT_MicrosoftGraphauthenticationMethodFeatureConfiguration -Property @{
                            state = "default"
                            includeTarget = (New-CimInstance -ClassName MSFT_MicrosoftGraphfeatureTarget -Property @{
                                targetType = "group"
                                id = "FakeStringValue"
                            } -ClientOnly)
                            excludeTarget = (New-CimInstance -ClassName MSFT_MicrosoftGraphfeatureTarget -Property @{
                                targetType = "group"
                                id = "FakeStringValue"
                            } -ClientOnly)
                        } -ClientOnly)
                        displayAppInformationRequiredState = (New-CimInstance -ClassName MSFT_MicrosoftGraphauthenticationMethodFeatureConfiguration -Property @{
                            state = "default"
                            includeTarget = (New-CimInstance -ClassName MSFT_MicrosoftGraphfeatureTarget -Property @{
                                targetType = "group"
                                id = "FakeStringValue"
                            } -ClientOnly)
                            excludeTarget = (New-CimInstance -ClassName MSFT_MicrosoftGraphfeatureTarget -Property @{
                                targetType = "group"
                                id = "FakeStringValue"
                            } -ClientOnly)
                        } -ClientOnly)
                        displayLocationInformationRequiredState = (New-CimInstance -ClassName MSFT_MicrosoftGraphauthenticationMethodFeatureConfiguration -Property @{
                            state = "default"
                            includeTarget = (New-CimInstance -ClassName MSFT_MicrosoftGraphfeatureTarget -Property @{
                                targetType = "group"
                                id = "FakeStringValue"
                            } -ClientOnly)
                            excludeTarget = (New-CimInstance -ClassName MSFT_MicrosoftGraphfeatureTarget -Property @{
                                targetType = "group"
                                id = "FakeStringValue"
                            } -ClientOnly)
                        } -ClientOnly)
                        numberMatchingRequiredState = (New-CimInstance -ClassName MSFT_MicrosoftGraphauthenticationMethodFeatureConfiguration -Property @{
                            state = "default"
                            includeTarget = (New-CimInstance -ClassName MSFT_MicrosoftGraphfeatureTarget -Property @{
                                targetType = "group"
                                id = "FakeStringValue"
                            } -ClientOnly)
                            excludeTarget = (New-CimInstance -ClassName MSFT_MicrosoftGraphfeatureTarget -Property @{
                                targetType = "group"
                                id = "FakeStringValue"
                            } -ClientOnly)
                        } -ClientOnly)
                    } -ClientOnly)
                    Id = "FakeStringValue"
                    isSoftwareOathEnabled = $True
                    State = "enabled"
                    Ensure = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            '@odata.type' = "#microsoft.graph.microsoftAuthenticatorAuthenticationMethodConfiguration"
                            featureSettings = @{
                                companionAppAllowedState = @{
                                    state = "default"
                                    includeTarget = @{
                                        targetType = "group"
                                        id = "FakeStringValue"
                                    }
                                    excludeTarget = @{
                                        targetType = "group"
                                        id = "FakeStringValue"
                                    }
                                }
                                displayAppInformationRequiredState = @{
                                    state = "default"
                                    includeTarget = @{
                                        targetType = "group"
                                        id = "FakeStringValue"
                                    }
                                    excludeTarget = @{
                                        targetType = "group"
                                        id = "FakeStringValue"
                                    }
                                }
                                displayLocationInformationRequiredState = @{
                                    state = "default"
                                    includeTarget = @{
                                        targetType = "group"
                                        id = "FakeStringValue"
                                    }
                                    excludeTarget = @{
                                        targetType = "group"
                                        id = "FakeStringValue"
                                    }
                                }
                                numberMatchingRequiredState = @{
                                    state = "default"
                                    includeTarget = @{
                                        targetType = "group"
                                        id = "FakeStringValue"
                                    }
                                    excludeTarget = @{
                                        targetType = "group"
                                        id = "FakeStringValue"
                                    }
                                }
                            }
                        }
                        ExcludeTargets = @(
                            @{
                                TargetType = "user"
                                Id = "FakeStringValue"
                            }
                        )
                        Id = "FakeStringValue"
                        State = "enabled"
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
                Should -Invoke -CommandName Update-MgPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            featureSettings = @{
                                companionAppAllowedState = @{
                                    state = "default"
                                    includeTarget = @{
                                        targetType = "group"
                                        id = "FakeStringValue"
                                    }
                                    excludeTarget = @{
                                        targetType = "group"
                                        id = "FakeStringValue"
                                    }
                                }
                                displayAppInformationRequiredState = @{
                                    state = "default"
                                    includeTarget = @{
                                        targetType = "group"
                                        id = "FakeStringValue"
                                    }
                                    excludeTarget = @{
                                        targetType = "group"
                                        id = "FakeStringValue"
                                    }
                                }
                                displayLocationInformationRequiredState = @{
                                    state = "default"
                                    includeTarget = @{
                                        targetType = "group"
                                        id = "FakeStringValue"
                                    }
                                    excludeTarget = @{
                                        targetType = "group"
                                        id = "FakeStringValue"
                                    }
                                }
                                numberMatchingRequiredState = @{
                                    state = "default"
                                    includeTarget = @{
                                        targetType = "group"
                                        id = "FakeStringValue"
                                    }
                                    excludeTarget = @{
                                        targetType = "group"
                                        id = "FakeStringValue"
                                    }
                                }
                            }
                            '@odata.type' = "#microsoft.graph.microsoftAuthenticatorAuthenticationMethodConfiguration"
                            isSoftwareOathEnabled = $True
                        }
                        ExcludeTargets = @(
                            @{
                                TargetType = "user"
                                Id = "FakeStringValue"
                            }
                        )
                        Id = "FakeStringValue"
                        State = "enabled"

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
