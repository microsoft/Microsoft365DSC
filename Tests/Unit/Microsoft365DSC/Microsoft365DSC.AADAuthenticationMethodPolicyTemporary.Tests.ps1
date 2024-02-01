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
    -DscResource "AADAuthenticationMethodPolicyTemporary" -GenericStubModule $GenericStubPath
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
        Context -Name "The AADAuthenticationMethodPolicyTemporary should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    DefaultLength = 25
                    DefaultLifetimeInMinutes = 25
                    ExcludeTargets = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFTAADAuthenticationMethodPolicyTemporaryExcludeTarget -Property @{
                            TargetType = "group"
                            Id = "Fakegroup"
                        } -ClientOnly)
                    )
                    IncludeTargets        = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyTemporaryIncludeTarget -Property @{
                            TargetType = 'group'
                            Id         = 'Fakegroup'
                        } -ClientOnly)
                    )
                    Id = "TemporaryAccessPass"
                    IsUsableOnce = $True
                    MaximumLifetimeInMinutes = 25
                    MinimumLifetimeInMinutes = 25
                    State = "enabled"
                    Ensure = "Present"
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        Id = "00000000-0000-0000-0000-000000000000"
                        DisplayName = "Fakegroup"
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

        Context -Name "The AADAuthenticationMethodPolicyTemporary exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    DefaultLength = 25
                    DefaultLifetimeInMinutes = 25
                    ExcludeTargets = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFTAADAuthenticationMethodPolicyTemporaryExcludeTarget -Property @{
                            TargetType = "group"
                            Id = "Fakegroup"
                        } -ClientOnly)
                    )
                    IncludeTargets        = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyTemporaryIncludeTarget -Property @{
                            TargetType = 'group'
                            Id         = 'Fakegroup'
                        } -ClientOnly)
                    )
                    Id = "TemporaryAccessPass"
                    IsUsableOnce = $True
                    MaximumLifetimeInMinutes = 25
                    MinimumLifetimeInMinutes = 25
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
                                    Id         = 'Fakegroup'
                                }
                            )
                            minimumLifetimeInMinutes = 25
                            defaultLifetimeInMinutes = 25
                            isUsableOnce = $True
                            '@odata.type' = "#microsoft.graph.temporaryAccessPassAuthenticationMethodConfiguration"
                            maximumLifetimeInMinutes = 25
                            defaultLength = 25
                        }
                        ExcludeTargets = @(
                            @{
                                TargetType = "group"
                                Id = "00000000-0000-0000-0000-000000000000"
                            }
                        )
                        Id = "TemporaryAccessPass"
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
        Context -Name "The AADAuthenticationMethodPolicyTemporary Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    DefaultLength = 25
                    DefaultLifetimeInMinutes = 25
                    ExcludeTargets = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFTAADAuthenticationMethodPolicyTemporaryExcludeTarget -Property @{
                            TargetType = "group"
                            Id = "Fakegroup"
                        } -ClientOnly)
                    )
                    IncludeTargets        = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyTemporaryIncludeTarget -Property @{
                            TargetType = 'group'
                            Id         = 'Fakegroup'
                        } -ClientOnly)
                    )
                    Id = "TemporaryAccessPass"
                    IsUsableOnce = $True
                    MaximumLifetimeInMinutes = 25
                    MinimumLifetimeInMinutes = 25
                    State = "enabled"
                    Ensure = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        Id = "00000000-0000-0000-0000-000000000000"
                        DisplayName = "Fakegroup"
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
                            minimumLifetimeInMinutes = 25
                            defaultLifetimeInMinutes = 25
                            isUsableOnce = $True
                            '@odata.type' = "#microsoft.graph.temporaryAccessPassAuthenticationMethodConfiguration"
                            maximumLifetimeInMinutes = 25
                            defaultLength = 25
                        }
                        ExcludeTargets = @(
                            @{
                                TargetType = "group"
                                Id = "00000000-0000-0000-0000-000000000000"
                            }
                        )
                        Id = "TemporaryAccessPass"
                        State = "enabled"

                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The AADAuthenticationMethodPolicyTemporary exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    DefaultLength = 25
                    DefaultLifetimeInMinutes = 25
                    ExcludeTargets = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFTAADAuthenticationMethodPolicyTemporaryExcludeTarget -Property @{
                            TargetType = "group"
                            Id = "Fakegroup"
                        } -ClientOnly)
                    )
                    IncludeTargets        = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyTemporaryIncludeTarget -Property @{
                            TargetType = 'group'
                            Id         = 'Fakegroup'
                        } -ClientOnly)
                    )
                    Id = "TemporaryAccessPass"
                    IsUsableOnce = $True
                    MaximumLifetimeInMinutes = 25
                    MinimumLifetimeInMinutes = 25
                    State = "enabled"
                    Ensure = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        Id = "00000000-0000-0000-0000-000000000000"
                        DisplayName = "Fakegroup2"
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
                            defaultLifetimeInMinutes = 7
                            '@odata.type' = "#microsoft.graph.temporaryAccessPassAuthenticationMethodConfiguration"
                            minimumLifetimeInMinutes = 7
                            defaultLength = 7
                            maximumLifetimeInMinutes = 7
                        }
                        ExcludeTargets = @(
                            @{
                                TargetType = "group"
                                Id = "00000000-0000-0000-0000-000000000000"
                            }
                        )
                        Id = "TemporaryAccessPass"
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
                                    Id         = 'Fakegroup'
                                }
                            )
                            minimumLifetimeInMinutes = 25
                            defaultLifetimeInMinutes = 25
                            isUsableOnce = $True
                            '@odata.type' = "#microsoft.graph.temporaryAccessPassAuthenticationMethodConfiguration"
                            maximumLifetimeInMinutes = 25
                            defaultLength = 25
                        }
                        ExcludeTargets = @(
                            @{
                                TargetType = "group"
                                Id = "FakeStringValue"
                            }
                        )
                        Id = "TemporaryAccessPass"
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
