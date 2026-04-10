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
$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource $ResourceName -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -ModuleName M365DSCUtil -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            Mock -CommandName Get-MgBetaPolicyAppManagementPolicy -MockWith {
                return @{
                    DisplayName = "MyPolicy"
                    Description = "MyDescription"
                    Id          = "12345-12345-12345-12345-12345"
                    IsEnabled   = $true
                    Restrictions = @{
                        passwordCredentials = @(
                            @{
                                restrictForAppsCreatedAfterDateTime = [DateTime]::Parse("1/1/0001 12:00:00 AM")
                                restrictionType = "passwordAddition"
                                state = "enabled"
                            },
                            @{
                                maxLifetime = @{
                                    Days = 90
                                    Hours = 0
                                    Minutes = 0
                                    Seconds = 0
                                }
                                restrictForAppsCreatedAfterDateTime = [DateTime]::Parse("1/1/0001 12:00:00 AM")
                                restrictionType = "passwordLifetime"
                                state = "enabled"
                            },
                            @{
                                restrictForAppsCreatedAfterDateTime = [DateTime]::Parse("1/1/0001 12:00:00 AM")
                                restrictionType = "symmetricKeyAddition"
                                state = "enabled"
                            },
                            @{
                                maxLifetime = @{
                                    Days = 90
                                    Hours = 0
                                    Minutes = 0
                                    Seconds = 0
                                }
                                restrictForAppsCreatedAfterDateTime = [DateTime]::Parse("1/1/0001 12:00:00 AM")
                                restrictionType = "symmetricKeyLifetime"
                                state = "enabled"
                            }
                        )
                    }
                }
            }

            Mock -Command New-MgBetaPolicyAppManagementPolicy -MockWith {
            }

            Mock -Command Update-MgBetaPolicyAppManagementPolicy -MockWith {
            }

            Mock -Command Remove-MgBetaPolicyAppManagementPolicy -MockWith {
            }

            # Mock Write-M365DSCHost to hide output during the tests
            Mock -CommandName Write-M365DSCHost -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }
        # Test contexts
        Context -Name "The instance should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName         = "MyPolicy"
                    Description         = "MyDescription"
                    IsEnabled           = $true
                    Restrictions          = (New-CimInstance -ClassName MSFT_AADAppManagementPolicyRestrictions -Property @{
                        passwordCredentials = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_AADAppManagementPolicyRestrictionsCredential -Property @{
                                restrictForAppsCreatedAfterDateTime = "0001-01-01T00:00:00.0000000"
                                restrictionType = "passwordAddition"
                                state = "enabled"
                            } -ClientOnly);
                            (New-CimInstance -ClassName MSFT_AADAppManagementPolicyRestrictionsCredential -Property @{
                                maxLifetime = "P90DT0H0M0S"
                                restrictForAppsCreatedAfterDateTime = "0001-01-01T00:00:00.0000000"
                                restrictionType = "passwordLifetime"
                                state = "enabled"
                            } -ClientOnly);
                            (New-CimInstance -ClassName MSFT_AADAppManagementPolicyRestrictionsCredential -Property @{
                                restrictForAppsCreatedAfterDateTime = "0001-01-01T00:00:00.0000000"
                                restrictionType = "symmetricKeyAddition"
                                state = "enabled"
                            } -ClientOnly);
                            (New-CimInstance -ClassName MSFT_AADAppManagementPolicyRestrictionsCredential -Property @{
                                maxLifetime = "P90DT0H0M0S"
                                restrictForAppsCreatedAfterDateTime = "0001-01-01T00:00:00.0000000"
                                restrictionType = "symmetricKeyLifetime"
                                state = "enabled"
                            } -ClientOnly);
                        )
                    } -ClientOnly);
                    Ensure              = 'Present'
                    Credential          = $Credential;
                }

                Mock -CommandName Get-MgBetaPolicyAppManagementPolicy -MockWith {
                    return $null
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should create a new instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-MgBetaPolicyAppManagementPolicy -Exactly 1
            }
        }

        Context -Name "The instance exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName         = "MyPolicy"
                    Description         = "MyDescription"
                    IsEnabled           = $true
                    Restrictions          = (New-CimInstance -ClassName MSFT_AADAppManagementPolicyRestrictions -Property @{
                        passwordCredentials = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_AADAppManagementPolicyRestrictionsCredential -Property @{
                                restrictForAppsCreatedAfterDateTime = "0001-01-01T00:00:00.0000000"
                                restrictionType = "passwordAddition"
                                state = "enabled"
                            } -ClientOnly);
                            (New-CimInstance -ClassName MSFT_AADAppManagementPolicyRestrictionsCredential -Property @{
                                maxLifetime = "P90DT0H0M0S"
                                restrictForAppsCreatedAfterDateTime = "0001-01-01T00:00:00.0000000"
                                restrictionType = "passwordLifetime"
                                state = "enabled"
                            } -ClientOnly);
                            (New-CimInstance -ClassName MSFT_AADAppManagementPolicyRestrictionsCredential -Property @{
                                restrictForAppsCreatedAfterDateTime = "0001-01-01T00:00:00.0000000"
                                restrictionType = "symmetricKeyAddition"
                                state = "enabled"
                            } -ClientOnly);
                            (New-CimInstance -ClassName MSFT_AADAppManagementPolicyRestrictionsCredential -Property @{
                                maxLifetime = "P90DT0H0M0S"
                                restrictForAppsCreatedAfterDateTime = "0001-01-01T00:00:00.0000000"
                                restrictionType = "symmetricKeyLifetime"
                                state = "enabled"
                            } -ClientOnly);
                        )
                    } -ClientOnly);
                    Ensure              = 'Absent'
                    Credential          = $Credential;
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should remove the instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgBetaPolicyAppManagementPolicy -Exactly 1
            }
        }

        Context -Name "The instance exists and values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName         = "MyPolicy"
                    Description         = "MyDescription"
                    IsEnabled           = $true
                    Restrictions          = (New-CimInstance -ClassName MSFT_AADAppManagementPolicyRestrictions -Property @{
                        passwordCredentials = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_AADAppManagementPolicyRestrictionsCredential -Property @{
                                restrictForAppsCreatedAfterDateTime = "0001-01-01T00:00:00.0000000"
                                restrictionType = "passwordAddition"
                                state = "enabled"
                            } -ClientOnly);
                            (New-CimInstance -ClassName MSFT_AADAppManagementPolicyRestrictionsCredential -Property @{
                                maxLifetime = "P90DT0H0M0S"
                                restrictForAppsCreatedAfterDateTime = "0001-01-01T00:00:00.0000000"
                                restrictionType = "passwordLifetime"
                                state = "enabled"
                            } -ClientOnly);
                            (New-CimInstance -ClassName MSFT_AADAppManagementPolicyRestrictionsCredential -Property @{
                                restrictForAppsCreatedAfterDateTime = "0001-01-01T00:00:00.0000000"
                                restrictionType = "symmetricKeyAddition"
                                state = "enabled"
                            } -ClientOnly);
                            (New-CimInstance -ClassName MSFT_AADAppManagementPolicyRestrictionsCredential -Property @{
                                maxLifetime = "P90DT0H0M0S"
                                restrictForAppsCreatedAfterDateTime = "0001-01-01T00:00:00.0000000"
                                restrictionType = "symmetricKeyLifetime"
                                state = "enabled"
                            } -ClientOnly);
                        )
                    } -ClientOnly);
                    Ensure              = 'Present'
                    Credential          = $Credential;
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The instance exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName         = "MyPolicy"
                    Description         = "MyDescription"
                    IsEnabled           = $true
                    Restrictions          = (New-CimInstance -ClassName MSFT_AADAppManagementPolicyRestrictions -Property @{
                        passwordCredentials = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_AADAppManagementPolicyRestrictionsCredential -Property @{
                                restrictForAppsCreatedAfterDateTime = "0001-01-01T00:00:00.0000000"
                                restrictionType = "passwordAddition"
                                state = "enabled"
                            } -ClientOnly);
                            (New-CimInstance -ClassName MSFT_AADAppManagementPolicyRestrictionsCredential -Property @{
                                maxLifetime = "P90DT0H0M0S"
                                restrictForAppsCreatedAfterDateTime = "0001-01-01T00:00:00.0000000"
                                restrictionType = "passwordLifetime"
                                state = "enabled"
                            } -ClientOnly);
                            (New-CimInstance -ClassName MSFT_AADAppManagementPolicyRestrictionsCredential -Property @{
                                restrictForAppsCreatedAfterDateTime = "0001-01-01T00:00:00.0000000"
                                restrictionType = "symmetricKeyAddition"
                                state = "enabled"
                            } -ClientOnly);
                            (New-CimInstance -ClassName MSFT_AADAppManagementPolicyRestrictionsCredential -Property @{
                                maxLifetime = "P90DT0H0M0S"
                                restrictForAppsCreatedAfterDateTime = "1/1/0001 5:00:00 AM" # Drift
                                restrictionType = "symmetricKeyLifetime"
                                state = "enabled"
                            } -ClientOnly);
                        )
                    } -ClientOnly);
                    Ensure              = 'Present'
                    Credential          = $Credential;
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
                Should -Invoke -CommandName Update-MgBetaPolicyAppManagementPolicy -Exactly 1
            }
        }

        Context -Name "The instance exists with keyCredentials including trustedCertificateAuthority and values are in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName         = "MyPolicy"
                    Description         = "MyDescription"
                    IsEnabled           = $true
                    Restrictions          = (New-CimInstance -ClassName MSFT_AADAppManagementPolicyRestrictions -Property @{
                        keyCredentials = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_AADAppManagementPolicyRestrictionsCredential -Property @{
                                maxLifetime = "P30DT0H0M0S"
                                restrictForAppsCreatedAfterDateTime = "0001-01-01T00:00:00.0000000"
                                restrictionType = "asymmetricKeyLifetime"
                                state = "enabled"
                            } -ClientOnly);
                            (New-CimInstance -ClassName MSFT_AADAppManagementPolicyRestrictionsCredential -Property @{
                                certificateBasedApplicationConfigurationIds = [System.String[]]@("aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee")
                                restrictForAppsCreatedAfterDateTime = "0001-01-01T00:00:00.0000000"
                                restrictionType = "trustedCertificateAuthority"
                                state = "enabled"
                            } -ClientOnly);
                        )
                    } -ClientOnly);
                    Ensure              = 'Present'
                    Credential          = $Credential;
                }

                Mock -CommandName Get-MgBetaPolicyAppManagementPolicy -MockWith {
                    return @{
                        DisplayName  = "MyPolicy"
                        Description  = "MyDescription"
                        Id           = "12345-12345-12345-12345-12345"
                        IsEnabled    = $true
                        Restrictions = @{
                            keyCredentials = @(
                                @{
                                    maxLifetime = @{
                                        Days    = 30
                                        Hours   = 0
                                        Minutes = 0
                                        Seconds = 0
                                    }
                                    restrictForAppsCreatedAfterDateTime = [DateTime]::Parse("1/1/0001 12:00:00 AM")
                                    restrictionType = "asymmetricKeyLifetime"
                                    state = "enabled"
                                },
                                @{
                                    certificateBasedApplicationConfigurationIds = @("aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee")
                                    restrictForAppsCreatedAfterDateTime = [DateTime]::Parse("1/1/0001 12:00:00 AM")
                                    restrictionType = "trustedCertificateAuthority"
                                    state = "enabled"
                                }
                            )
                        }
                    }
                }
            }

            It 'Should return Values from the Get method' {
                $result = Get-TargetResource @testParams
                $result.Ensure | Should -Be 'Present'
                $result.Restrictions.keyCredentials | Should -HaveCount 2
                $trustedCACred = $result.Restrictions.keyCredentials | Where-Object { $_.restrictionType -eq 'trustedCertificateAuthority' }
                $trustedCACred | Should -Not -BeNullOrEmpty
                $trustedCACred.certificateBasedApplicationConfigurationIds | Should -Contain 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The instance exists with keyCredentials including trustedCertificateAuthority and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName         = "MyPolicy"
                    Description         = "MyDescription"
                    IsEnabled           = $true
                    Restrictions          = (New-CimInstance -ClassName MSFT_AADAppManagementPolicyRestrictions -Property @{
                        keyCredentials = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_AADAppManagementPolicyRestrictionsCredential -Property @{
                                certificateBasedApplicationConfigurationIds = [System.String[]]@("aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee", "11111111-2222-3333-4444-555555555555")
                                restrictForAppsCreatedAfterDateTime = "0001-01-01T00:00:00.0000000"
                                restrictionType = "trustedCertificateAuthority"
                                state = "enabled"
                            } -ClientOnly);
                        )
                    } -ClientOnly);
                    Ensure              = 'Present'
                    Credential          = $Credential;
                }

                Mock -CommandName Get-MgBetaPolicyAppManagementPolicy -MockWith {
                    return @{
                        DisplayName  = "MyPolicy"
                        Description  = "MyDescription"
                        Id           = "12345-12345-12345-12345-12345"
                        IsEnabled    = $true
                        Restrictions = @{
                            keyCredentials = @(
                                @{
                                    certificateBasedApplicationConfigurationIds = @("aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee")
                                    restrictForAppsCreatedAfterDateTime = [DateTime]::Parse("1/1/0001 12:00:00 AM")
                                    restrictionType = "trustedCertificateAuthority"
                                    state = "enabled"
                                }
                            )
                        }
                    }
                }
            }

            It 'Should return Values from the Get method' {
                $result = Get-TargetResource @testParams
                $result.Ensure | Should -Be 'Present'
                $trustedCACred = $result.Restrictions.keyCredentials | Where-Object { $_.restrictionType -eq 'trustedCertificateAuthority' }
                $trustedCACred.certificateBasedApplicationConfigurationIds | Should -HaveCount 1
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgBetaPolicyAppManagementPolicy -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential  = $Credential;
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
