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
    -DscResource "AADAuthenticationMethodPolicyX509" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString "f@kepassword1" -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Update-MgBetaPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration -MockWith {
            }

            Mock -CommandName Remove-MgBetaPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }
        # Test contexts
        Context -Name "The AADAuthenticationMethodPolicyX509 should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    authenticationModeConfiguration = (New-CimInstance -ClassName MSFT_MicrosoftGraphx509CertificateAuthenticationModeConfiguration -Property @{
                        x509CertificateAuthenticationDefaultMode = "x509CertificateSingleFactor"
                        rules = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphx509CertificateRule -Property @{
                                x509CertificateRuleType = "issuerSubject"
                                identifier = "FakeStringValue"
                                x509CertificateAuthenticationMode = "x509CertificateSingleFactor"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    certificateUserBindings = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphx509CertificateUserBinding -Property @{
                            x509CertificateField = "FakeStringValue"
                            userProperty = "FakeStringValue"
                            priority = 25
                        } -ClientOnly)
                    )
                    ExcludeTargets = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyX509ExcludeTarget -Property @{
                            TargetType = "group"
                            Id = "00000000-0000-0000-0000-000000000000"
                        } -ClientOnly)
                    )
                    IncludeTargets        = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyX509IncludeTarget -Property @{
                            TargetType = 'group'
                            Id         = '00000000-0000-0000-0000-000000000000'
                        } -ClientOnly)
                    )
                    Id = "X509Certificate"
                    State = "enabled"
                    Ensure = "Present"
                    Credential = $Credential;
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

        Context -Name "The AADAuthenticationMethodPolicyX509 exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    authenticationModeConfiguration = (New-CimInstance -ClassName MSFT_MicrosoftGraphx509CertificateAuthenticationModeConfiguration -Property @{
                        x509CertificateAuthenticationDefaultMode = "x509CertificateSingleFactor"
                        rules = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphx509CertificateRule -Property @{
                                x509CertificateRuleType = "issuerSubject"
                                identifier = "FakeStringValue"
                                x509CertificateAuthenticationMode = "x509CertificateSingleFactor"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    certificateUserBindings = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphx509CertificateUserBinding -Property @{
                            x509CertificateField = "FakeStringValue"
                            userProperty = "FakeStringValue"
                            priority = 25
                        } -ClientOnly)
                    )
                    ExcludeTargets = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFTAADAuthenticationMethodPolicyX509ExcludeTarget -Property @{
                            TargetType = "group"
                            Id = "00000000-0000-0000-0000-000000000000"
                        } -ClientOnly)
                    )
                    IncludeTargets        = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyX509IncludeTarget -Property @{
                            TargetType = 'group'
                            Id         = 'Fakegroup'
                        } -ClientOnly)
                    )
                    Id = "X509Certificate"
                    State = "enabled"
                    Ensure = 'Absent'
                    Credential = $Credential;
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
                            '@odata.type' = "#microsoft.graph.x509CertificateAuthenticationMethodConfiguration"
                            certificateUserBindings = @(
                                @{
                                    x509CertificateField = "FakeStringValue"
                                    userProperty = "FakeStringValue"
                                    priority = 25
                                }
                            )
                            authenticationModeConfiguration = @{
                                x509CertificateAuthenticationDefaultMode = "x509CertificateSingleFactor"
                                rules = @(
                                    @{
                                        x509CertificateRuleType = "issuerSubject"
                                        identifier = "FakeStringValue"
                                        x509CertificateAuthenticationMode = "x509CertificateSingleFactor"
                                    }
                                )
                            }
                        }
                        ExcludeTargets = @(
                            @{
                                TargetType = "group"
                                Id = "00000000-0000-0000-0000-000000000000"
                            }
                        )
                        Id = "X509Certificate0"
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
                Should -Invoke -CommandName Remove-MgBetaPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration -Exactly 1
            }
        }
        Context -Name "The AADAuthenticationMethodPolicyX509 Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    authenticationModeConfiguration = (New-CimInstance -ClassName MSFT_MicrosoftGraphx509CertificateAuthenticationModeConfiguration -Property @{
                        x509CertificateAuthenticationDefaultMode = "x509CertificateSingleFactor"
                        rules = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphx509CertificateRule -Property @{
                                x509CertificateRuleType = "issuerSubject"
                                identifier = "FakeStringValue"
                                x509CertificateAuthenticationMode = "x509CertificateSingleFactor"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    certificateUserBindings = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphx509CertificateUserBinding -Property @{
                            x509CertificateField = "FakeStringValue"
                            userProperty = "FakeStringValue"
                            priority = 25
                        } -ClientOnly)
                    )
                    ExcludeTargets = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyX509ExcludeTarget -Property @{
                            TargetType = "group"
                            Id = "Fakegroup"
                        } -ClientOnly)
                    )
                    IncludeTargets        = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyX509IncludeTarget -Property @{
                            TargetType = 'group'
                            Id         = 'Fakegroup'
                        } -ClientOnly)
                    )
                    Id = "X509Certificate"
                    State = "enabled"
                    Ensure = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        Id = "00000000-0000-0000-0000-000000000001"
                        DisplayName = "Fakegroup"
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
                            '@odata.type' = "#microsoft.graph.x509CertificateAuthenticationMethodConfiguration"
                            certificateUserBindings = @(
                                @{
                                    x509CertificateField = "FakeStringValue"
                                    userProperty = "FakeStringValue"
                                    priority = 25
                                }
                            )
                            authenticationModeConfiguration = @{
                                x509CertificateAuthenticationDefaultMode = "x509CertificateSingleFactor"
                                rules = @(
                                    @{
                                        x509CertificateRuleType = "issuerSubject"
                                        identifier = "FakeStringValue"
                                        x509CertificateAuthenticationMode = "x509CertificateSingleFactor"
                                    }
                                )
                            }
                        }
                        ExcludeTargets = @(
                            @{
                                TargetType = "group"
                                Id = "00000000-0000-0000-0000-000000000001"
                            }
                        )
                        Id = "X509Certificate"
                        State = "enabled"

                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The AADAuthenticationMethodPolicyX509 exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    authenticationModeConfiguration = (New-CimInstance -ClassName MSFT_MicrosoftGraphx509CertificateAuthenticationModeConfiguration -Property @{
                        x509CertificateAuthenticationDefaultMode = "x509CertificateSingleFactor"
                        rules = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphx509CertificateRule -Property @{
                                x509CertificateRuleType = "issuerSubject"
                                identifier = "FakeStringValue"
                                x509CertificateAuthenticationMode = "x509CertificateSingleFactor"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    certificateUserBindings = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphx509CertificateUserBinding -Property @{
                            x509CertificateField = "FakeStringValue"
                            userProperty = "FakeStringValue"
                            priority = 25
                        } -ClientOnly)
                    )
                    ExcludeTargets = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyX509ExcludeTarget -Property @{
                            TargetType = "group"
                            Id = "Fakegroup2"
                        } -ClientOnly)
                    )
                    IncludeTargets        = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyX509IncludeTarget -Property @{
                            TargetType = 'group'
                            Id         = 'Fakegroup'
                        } -ClientOnly)
                    )
                    Id = "X509Certificate"
                    State = "enabled"
                    Ensure = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        Id = "00000000-0000-0000-0000-000000000001"
                        DisplayName = "Fakegroup"
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
                            '@odata.type' = "#microsoft.graph.x509CertificateAuthenticationMethodConfiguration"
                            certificateUserBindings = @(
                                @{
                                    x509CertificateField = "FakeStringValue"
                                    userProperty = "FakeStringValue"
                                    priority = 7
                                }
                            )
                            authenticationModeConfiguration = @{
                                x509CertificateAuthenticationDefaultMode = "x509CertificateSingleFactor"
                                rules = @(
                                    @{
                                        x509CertificateRuleType = "issuerSubject"
                                        identifier = "FakeStringValue"
                                        x509CertificateAuthenticationMode = "x509CertificateSingleFactor"
                                    }
                                )
                            }
                        }
                        ExcludeTargets = @(
                            @{
                                TargetType = "group"
                                Id = "00000000-0000-0000-0000-000000000000"
                            }
                        )
                        Id = "X509Certificate"
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
                            '@odata.type' = "#microsoft.graph.x509CertificateAuthenticationMethodConfiguration"
                            certificateUserBindings = @(
                                @{
                                    x509CertificateField = "FakeStringValue"
                                    userProperty = "FakeStringValue"
                                    priority = 25
                                }
                            )
                            authenticationModeConfiguration = @{
                                x509CertificateAuthenticationDefaultMode = "x509CertificateSingleFactor"
                                rules = @(
                                    @{
                                        x509CertificateRuleType = "issuerSubject"
                                        identifier = "FakeStringValue"
                                        x509CertificateAuthenticationMode = "x509CertificateSingleFactor"
                                    }
                                )
                            }
                        }
                        ExcludeTargets = @(
                            @{
                                TargetType = "group"
                                Id = "00000000-0000-0000-0000-000000000000"
                            }
                        )
                        Id = "X509Certificate"
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
