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
    -DscResource "AADAuthenticationMethodPolicyVoice" -GenericStubModule $GenericStubPath
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
        Context -Name "The AADAuthenticationMethodPolicyVoice should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    ExcludeTargets = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyVoiceExcludeTarget -Property @{
                            TargetType = "group"
                            Id = "Fakegroup"
                        } -ClientOnly)
                    )
                    IncludeTargets        = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyVoiceIncludeTarget -Property @{
                            TargetType = 'group'
                            Id         = 'Fakegroup'
                        } -ClientOnly)
                    )
                    Id = "Voice"
                    IsOfficePhoneAllowed = $True
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

        Context -Name "The AADAuthenticationMethodPolicyVoice exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    ExcludeTargets = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFTAADAuthenticationMethodPolicyVoiceExcludeTarget -Property @{
                            TargetType = "group"
                            Id = "FakeStringValue"
                        } -ClientOnly)
                    )
                    IncludeTargets        = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyVoiceIncludeTarget -Property @{
                            TargetType = 'group'
                            Id         = 'Fakegroup'
                        } -ClientOnly)
                    )
                    Id = "Voice"
                    IsOfficePhoneAllowed = $True
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
                            '@odata.type' = "#microsoft.graph.voiceAuthenticationMethodConfiguration"
                            isOfficePhoneAllowed = $True
                        }
                        ExcludeTargets = @(
                            @{
                                TargetType = "group"
                                Id = "00000000-0000-0000-0000-000000000000"
                            }
                        )
                        Id = "Voice"
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
        Context -Name "The AADAuthenticationMethodPolicyVoice Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    ExcludeTargets = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFTAADAuthenticationMethodPolicyVoiceExcludeTarget -Property @{
                            TargetType = "group"
                            Id = "Fakegroup"
                        } -ClientOnly)
                    )
                    IncludeTargets        = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyVoiceIncludeTarget -Property @{
                            TargetType = 'group'
                            Id         = 'Fakegroup'
                        } -ClientOnly)
                    )
                    Id = "Voice"
                    IsOfficePhoneAllowed = $True
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
                                    Id         = '00000000-0000-0000-0000-000000000000'
                                }
                            )
                            '@odata.type' = "#microsoft.graph.voiceAuthenticationMethodConfiguration"
                            isOfficePhoneAllowed = $True
                        }
                        ExcludeTargets = @(
                            @{
                                TargetType = "group"
                                Id = "00000000-0000-0000-0000-000000000000"
                            }
                        )
                        Id = "Voice"
                        State = "enabled"

                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The AADAuthenticationMethodPolicyVoice exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    ExcludeTargets = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFTAADAuthenticationMethodPolicyVoiceExcludeTarget -Property @{
                            TargetType = "group"
                            Id = "Fakegroup"
                        } -ClientOnly)
                    )
                    IncludeTargets        = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_AADAuthenticationMethodPolicyVoiceIncludeTarget -Property @{
                            TargetType = 'group'
                            Id         = 'Fakegroup'
                        } -ClientOnly)
                    )
                    Id = "Voice"
                    IsOfficePhoneAllowed = $True
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
                                    Id         = '00000000-0000-0000-0000-000000000000'
                                }
                            )
                            '@odata.type' = "#microsoft.graph.voiceAuthenticationMethodConfiguration"
                        }
                        ExcludeTargets = @(
                            @{
                                TargetType = "group"
                                Id = "00000000-0000-0000-0000-000000000000"
                            }
                        )
                        Id = "Voice"
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
                            '@odata.type' = "#microsoft.graph.voiceAuthenticationMethodConfiguration"
                            isOfficePhoneAllowed = $True
                        }
                        ExcludeTargets = @(
                            @{
                                TargetType = "group"
                                Id = "00000000-0000-0000-0000-000000000000"
                            }
                        )
                        Id = "Voice"
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
