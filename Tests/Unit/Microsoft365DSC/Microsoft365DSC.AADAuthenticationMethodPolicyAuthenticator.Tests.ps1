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
    -DscResource 'AADAuthenticationMethodPolicyAuthenticator' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString 'f@kepassword1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Update-MgBetaPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration -MockWith {
            }

            Mock -CommandName Remove-MgBetaPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }
        # Test contexts
        Context -Name 'The AADAuthenticationMethodPolicyAuthenticator should exist but it DOES NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    ExcludeTargets        = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyAuthenticatorExcludeTarget -Property @{
                            TargetType = 'group'
                            Id         = 'Fakegroup'
                        } -ClientOnly)
                    )
                    IncludeTargets        = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyAuthenticatorIncludeTarget -Property @{
                            TargetType = 'group'
                            Id         = 'Fakegroup'
                        } -ClientOnly)
                    )
                    featureSettings       = (New-CimInstance -ClassName MSFT_MicrosoftGraphmicrosoftAuthenticatorFeatureSettings -Property @{
                            companionAppAllowedState                = (New-CimInstance -ClassName MSFT_MicrosoftGraphauthenticationMethodFeatureConfiguration -Property @{
                                    state         = 'default'
                                    includeTarget = (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget -Property @{
                                            targetType = 'group'
                                            id         = 'Fakegroup'
                                        } -ClientOnly)
                                    excludeTarget = (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget -Property @{
                                            targetType = 'group'
                                            id         = 'Fakegroup'
                                        } -ClientOnly)
                                } -ClientOnly)
                            displayAppInformationRequiredState      = (New-CimInstance -ClassName MSFT_MicrosoftGraphauthenticationMethodFeatureConfiguration -Property @{
                                    state         = 'default'
                                    includeTarget = (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget -Property @{
                                            targetType = 'group'
                                            id         = 'Fakegroup'
                                        } -ClientOnly)
                                    excludeTarget = (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget -Property @{
                                            targetType = 'group'
                                            id         = 'Fakegroup'
                                        } -ClientOnly)
                                } -ClientOnly)
                            displayLocationInformationRequiredState = (New-CimInstance -ClassName MSFT_MicrosoftGraphauthenticationMethodFeatureConfiguration -Property @{
                                    state         = 'default'
                                    includeTarget = (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget -Property @{
                                            targetType = 'group'
                                            id         = 'Fakegroup'
                                        } -ClientOnly)
                                    excludeTarget = (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget -Property @{
                                            targetType = 'group'
                                            id         = 'Fakegroup'
                                        } -ClientOnly)
                                } -ClientOnly)
                        } -ClientOnly)
                    Id                    = 'MicrosoftAuthenticator'
                    isSoftwareOathEnabled = $True
                    State                 = 'enabled'
                    Ensure                = 'Present'
                    Credential            = $Credential
                }

                Mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        Id          = '00000000-0000-0000-0000-000000000000'
                        DisplayName = 'Fakegroup'
                    }
                }

                Mock -CommandName Get-MgBetaPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration -MockWith {
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
                Should -Invoke -CommandName Update-MgBetaPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration -Exactly 1
            }
        }

        Context -Name 'The AADAuthenticationMethodPolicyAuthenticator exists but it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    ExcludeTargets        = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyAuthenticatorExcludeTarget -Property @{
                            TargetType = 'group'
                            Id         = 'Fakegroup'
                        } -ClientOnly)
                    )
                    IncludeTargets        = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyAuthenticatorIncludeTarget -Property @{
                            TargetType = 'group'
                            Id         = 'Fakegroup'
                        } -ClientOnly)
                    )
                    featureSettings       = (New-CimInstance -ClassName MSFT_MicrosoftGraphmicrosoftAuthenticatorFeatureSettings -Property @{
                            companionAppAllowedState                = (New-CimInstance -ClassName MSFT_MicrosoftGraphauthenticationMethodFeatureConfiguration -Property @{
                                    state         = 'default'
                                    includeTarget = (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget -Property @{
                                            targetType = 'group'
                                            id         = 'Fakegroup'
                                        } -ClientOnly)
                                    excludeTarget = (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget -Property @{
                                            targetType = 'group'
                                            id         = 'Fakegroup'
                                        } -ClientOnly)
                                } -ClientOnly)
                            displayAppInformationRequiredState      = (New-CimInstance -ClassName MSFT_MicrosoftGraphauthenticationMethodFeatureConfiguration -Property @{
                                    state         = 'default'
                                    includeTarget = (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget -Property @{
                                            targetType = 'group'
                                            id         = 'Fakegroup'
                                        } -ClientOnly)
                                    excludeTarget = (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget -Property @{
                                            targetType = 'group'
                                            id         = 'Fakegroup'
                                        } -ClientOnly)
                                } -ClientOnly)
                            displayLocationInformationRequiredState = (New-CimInstance -ClassName MSFT_MicrosoftGraphauthenticationMethodFeatureConfiguration -Property @{
                                    state         = 'default'
                                    includeTarget = (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget -Property @{
                                            targetType = 'group'
                                            id         = 'Fakegroup'
                                        } -ClientOnly)
                                    excludeTarget = (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget -Property @{
                                            targetType = 'group'
                                            id         = 'Fakegroup'
                                        } -ClientOnly)
                                } -ClientOnly)
                        } -ClientOnly)
                    Id                    = 'MicrosoftAuthenticator'
                    isSoftwareOathEnabled = $True
                    State                 = 'enabled'
                    Ensure                = 'Absent'
                    Credential            = $Credential
                }

                Mock -CommandName Get-MgBetaPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            IncludeTargets        = @(
                                @{
                                    TargetType = 'group'
                                    Id         = '00000000-0000-0000-0000-000000000000'
                                }
                            )
                            featureSettings       = @{
                                companionAppAllowedState                = @{
                                    state         = 'default'
                                    includeTarget = @{
                                        targetType = 'group'
                                        id         = '00000000-0000-0000-0000-000000000000'
                                    }
                                    excludeTarget = @{
                                        targetType = 'group'
                                        id         = '00000000-0000-0000-0000-000000000000'
                                    }
                                }
                                displayAppInformationRequiredState      = @{
                                    state         = 'default'
                                    includeTarget = @{
                                        targetType = 'group'
                                        id         = '00000000-0000-0000-0000-000000000000'
                                    }
                                    excludeTarget = @{
                                        targetType = 'group'
                                        id         = '00000000-0000-0000-0000-000000000000'
                                    }
                                }
                                displayLocationInformationRequiredState = @{
                                    state         = 'default'
                                    includeTarget = @{
                                        targetType = 'group'
                                        id         = '00000000-0000-0000-0000-000000000000'
                                    }
                                    excludeTarget = @{
                                        targetType = 'group'
                                        id         = '00000000-0000-0000-0000-000000000000'
                                    }
                                }
                                numberMatchingRequiredState             = @{
                                    state         = 'default'
                                    includeTarget = @{
                                        targetType = 'group'
                                        id         = '00000000-0000-0000-0000-000000000000'
                                    }
                                    excludeTarget = @{
                                        targetType = 'group'
                                        id         = '00000000-0000-0000-0000-000000000000'
                                    }
                                }
                            }
                            '@odata.type'         = '#microsoft.graph.microsoftAuthenticatorAuthenticationMethodConfiguration'
                            isSoftwareOathEnabled = $True
                        }
                        ExcludeTargets       = @(
                            @{
                                TargetType = 'group'
                                Id         = '00000000-0000-0000-0000-000000000000'
                            }
                        )
                        Id                   = 'MicrosoftAuthenticator'
                        State                = 'enabled'

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
                Should -Invoke -CommandName Remove-MgBetaPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration -Exactly 1
            }
        }
        Context -Name 'The AADAuthenticationMethodPolicyAuthenticator Exists and Values are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    ExcludeTargets        = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyAuthenticatorExcludeTarget -Property @{
                            TargetType = 'group'
                            Id         = 'Fakegroup'
                        } -ClientOnly)
                    )
                    IncludeTargets        = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyAuthenticatorIncludeTarget -Property @{
                            TargetType = 'group'
                            Id         = 'Fakegroup'
                        } -ClientOnly)
                    )
                    featureSettings       = (New-CimInstance -ClassName MSFT_MicrosoftGraphmicrosoftAuthenticatorFeatureSettings -Property @{
                            companionAppAllowedState                = (New-CimInstance -ClassName MSFT_MicrosoftGraphauthenticationMethodFeatureConfiguration -Property @{
                                    state         = 'default'
                                    includeTarget = (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget -Property @{
                                            targetType = 'group'
                                            id         = 'Fakegroup'
                                        } -ClientOnly)
                                    excludeTarget = (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget -Property @{
                                            targetType = 'group'
                                            id         = 'Fakegroup'
                                        } -ClientOnly)
                                } -ClientOnly)
                            displayAppInformationRequiredState      = (New-CimInstance -ClassName MSFT_MicrosoftGraphauthenticationMethodFeatureConfiguration -Property @{
                                    state         = 'default'
                                    includeTarget = (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget -Property @{
                                            targetType = 'group'
                                            id         = 'Fakegroup'
                                        } -ClientOnly)
                                    excludeTarget = (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget -Property @{
                                            targetType = 'group'
                                            id         = 'Fakegroup'
                                        } -ClientOnly)
                                } -ClientOnly)
                            displayLocationInformationRequiredState = (New-CimInstance -ClassName MSFT_MicrosoftGraphauthenticationMethodFeatureConfiguration -Property @{
                                    state         = 'default'
                                    includeTarget = (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget -Property @{
                                            targetType = 'group'
                                            id         = 'Fakegroup'
                                        } -ClientOnly)
                                    excludeTarget = (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget -Property @{
                                            targetType = 'group'
                                            id         = 'Fakegroup'
                                        } -ClientOnly)
                                } -ClientOnly)
                        } -ClientOnly)
                    Id                    = 'MicrosoftAuthenticator'
                    isSoftwareOathEnabled = $True
                    State                 = 'enabled'
                    Ensure                = 'Present'
                    Credential            = $Credential
                }

                Mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        Id          = '00000000-0000-0000-0000-000000000000'
                        DisplayName = 'Fakegroup'
                    }
                }

                Mock -CommandName Get-MgBetaPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            IncludeTargets        = @(
                                @{
                                    TargetType = 'group'
                                    Id         = 'Fakegroup'
                                }
                            )
                            featureSettings       = @{
                                companionAppAllowedState                = @{
                                    state         = 'default'
                                    includeTarget = @{
                                        targetType = 'group'
                                        id         = 'Fakegroup'
                                    }
                                    excludeTarget = @{
                                        targetType = 'group'
                                        id         = 'Fakegroup'
                                    }
                                }
                                displayAppInformationRequiredState      = @{
                                    state         = 'default'
                                    includeTarget = @{
                                        targetType = 'group'
                                        id         = 'Fakegroup'
                                    }
                                    excludeTarget = @{
                                        targetType = 'group'
                                        id         = 'Fakegroup'
                                    }
                                }
                                displayLocationInformationRequiredState = @{
                                    state         = 'default'
                                    includeTarget = @{
                                        targetType = 'group'
                                        id         = 'Fakegroup'
                                    }
                                    excludeTarget = @{
                                        targetType = 'group'
                                        id         = 'Fakegroup'
                                    }
                                }
                            }
                            '@odata.type'         = '#microsoft.graph.microsoftAuthenticatorAuthenticationMethodConfiguration'
                            isSoftwareOathEnabled = $True
                        }
                        ExcludeTargets       = @(
                            @{
                                TargetType = 'group'
                                Id         = '00000000-0000-0000-0000-000000000000'
                            }
                        )
                        Id                   = 'MicrosoftAuthenticator'
                        State                = 'enabled'

                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'The AADAuthenticationMethodPolicyAuthenticator exists and values are NOT in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    ExcludeTargets        = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyAuthenticatorExcludeTarget -Property @{
                            TargetType = 'group'
                            Id         = 'Fakegroup'
                        } -ClientOnly)
                    )
                    IncludeTargets        = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyAuthenticatorIncludeTarget -Property @{
                            TargetType = 'group'
                            Id         = 'Fakegroup'
                        } -ClientOnly)
                    )
                    featureSettings       = (New-CimInstance -ClassName MSFT_MicrosoftGraphmicrosoftAuthenticatorFeatureSettings -Property @{
                            companionAppAllowedState                = (New-CimInstance -ClassName MSFT_MicrosoftGraphauthenticationMethodFeatureConfiguration -Property @{
                                    state         = 'default'
                                    includeTarget = (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget -Property @{
                                            targetType = 'group'
                                            id         = 'Fakegroup'
                                        } -ClientOnly)
                                    excludeTarget = (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget -Property @{
                                            targetType = 'group'
                                            id         = 'Fakegroup'
                                        } -ClientOnly)
                                } -ClientOnly)
                            displayAppInformationRequiredState      = (New-CimInstance -ClassName MSFT_MicrosoftGraphauthenticationMethodFeatureConfiguration -Property @{
                                    state         = 'default'
                                    includeTarget = (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget -Property @{
                                            targetType = 'group'
                                            id         = 'Fakegroup'
                                        } -ClientOnly)
                                    excludeTarget = (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget -Property @{
                                            targetType = 'group'
                                            id         = 'Fakegroup'
                                        } -ClientOnly)
                                } -ClientOnly)
                            displayLocationInformationRequiredState = (New-CimInstance -ClassName MSFT_MicrosoftGraphauthenticationMethodFeatureConfiguration -Property @{
                                    state         = 'default'
                                    includeTarget = (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget -Property @{
                                            targetType = 'group'
                                            id         = 'Fakegroup'
                                        } -ClientOnly)
                                    excludeTarget = (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget -Property @{
                                            targetType = 'group'
                                            id         = 'Fakegroup'
                                        } -ClientOnly)
                                } -ClientOnly)
                        } -ClientOnly)
                    Id                    = 'MicrosoftAuthenticator'
                    isSoftwareOathEnabled = $True
                    State                 = 'enabled'
                    Ensure                = 'Present'
                    Credential            = $Credential
                }

                Mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        Id          = '00000000-0000-0000-0000-000000000000'
                        DisplayName = 'Fakegroup'
                    }
                }

                Mock -CommandName Get-MgBetaPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            IncludeTargets        = @(
                                @{
                                    TargetType = 'group'
                                    Id         = '00000000-0000-0000-0000-000000000000'
                                }
                            )
                            '@odata.type'   = '#microsoft.graph.microsoftAuthenticatorAuthenticationMethodConfiguration'
                            featureSettings = @{
                                companionAppAllowedState                = @{
                                    state         = 'default'
                                    includeTarget = @{
                                        targetType = 'group'
                                        id         = 'Fakegroup'
                                    }
                                    excludeTarget = @{
                                        targetType = 'group'
                                        id         = 'Fakegroup'
                                    }
                                }
                                displayAppInformationRequiredState      = @{
                                    state         = 'default'
                                    includeTarget = @{
                                        targetType = 'group'
                                        id         = 'Fakegroup'
                                    }
                                    excludeTarget = @{
                                        targetType = 'group'
                                        id         = 'Fakegroup'
                                    }
                                }
                                displayLocationInformationRequiredState = @{
                                    state         = 'default'
                                    includeTarget = @{
                                        targetType = 'group'
                                        id         = 'Fakegroup'
                                    }
                                    excludeTarget = @{
                                        targetType = 'group'
                                        id         = 'Fakegroup'
                                    }
                                }
                            }
                        }
                        ExcludeTargets       = @(
                            @{
                                TargetType = 'group'
                                Id         = '00000000-0000-0000-0000-000000000000'
                            }
                        )
                        Id                   = 'MicrosoftAuthenticator'
                        State                = 'enabled'
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
                Should -Invoke -CommandName Update-MgBetaPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            IncludeTargets        = @(
                                @{
                                    TargetType = 'group'
                                    Id         = '00000000-0000-0000-0000-000000000000'
                                }
                            )
                            featureSettings       = @{
                                companionAppAllowedState                = @{
                                    state         = 'default'
                                    includeTarget = @{
                                        targetType = 'group'
                                        id         = 'Fakegroup'
                                    }
                                    excludeTarget = @{
                                        targetType = 'group'
                                        id         = 'Fakegroup'
                                    }
                                }
                                displayAppInformationRequiredState      = @{
                                    state         = 'default'
                                    includeTarget = @{
                                        targetType = 'group'
                                        id         = 'Fakegroup'
                                    }
                                    excludeTarget = @{
                                        targetType = 'group'
                                        id         = 'Fakegroup'
                                    }
                                }
                                displayLocationInformationRequiredState = @{
                                    state         = 'default'
                                    includeTarget = @{
                                        targetType = 'group'
                                        id         = 'Fakegroup'
                                    }
                                    excludeTarget = @{
                                        targetType = 'group'
                                        id         = 'Fakegroup'
                                    }
                                }
                            }
                            '@odata.type'         = '#microsoft.graph.microsoftAuthenticatorAuthenticationMethodConfiguration'
                            isSoftwareOathEnabled = $True
                        }
                        ExcludeTargets       = @(
                            @{
                                TargetType = 'group'
                                Id         = '00000000-0000-0000-0000-000000000000'
                            }
                        )
                        Id                   = 'MicrosoftAuthenticator'
                        State                = 'enabled'

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
