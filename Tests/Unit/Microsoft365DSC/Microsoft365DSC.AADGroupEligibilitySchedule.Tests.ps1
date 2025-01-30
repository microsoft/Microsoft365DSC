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
    -DscResource "AADGroupEligibilitySchedule" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-MSCloudLoginConnectionProfile -MockWith {
            }

            Mock -CommandName Reset-MSCloudLoginConnectionProfileContext -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            Mock  -CommandName Get-MgBetaPolicyRoleManagementPolicyAssignment -MockWith {
                return @(
                    @{
                        PolicyIdId = 'FakeId'
                    }
                )
            }

            Mock -CommandName Get-MgBetaPolicyRoleManagementPolicyRule -MockWith {
                return @()
            }

            Mock -CommandName Update-MgBetaPolicyRoleManagementPolicyRule -MockWith {
                return @()
            }
            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name "The AADGroupEligibilitySchedule should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    AccessId = "member"
                    GroupDisplayName = "FakeStringValue"
                    MemberType = "direct"
                    PrincipalDisplayName = "FakePrincipal"
                    ScheduleInfo         = (New-CimInstance -ClassName MSFT_MicrosoftGraphRequestSchedule -Property @{
                            startDateTime = '2025-01-23T08:59:00.0000000+00:00'
                            Expiration = (New-CimInstance -ClassName MSFT_MicrosoftGraphExpirationPattern -Property @{
                                    EndDateTime = '23/12/2025 08:59:00 +00:00'
                                    Type = 'afterDateTime'} -ClientOnly)
                            } -ClientOnly)
                    Ensure = "Present"
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilitySchedule -MockWith {
                    return $null
                }

                Mock -CommandName New-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilityScheduleRequest -MockWith {
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
                Should -Invoke -CommandName New-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilityScheduleRequest -Exactly 1
            }
        }

        Context -Name "The AADGroupEligibilitySchedule exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    AccessId = "member"
                    GroupDisplayName = "FakeStringValue"
                    MemberType = "direct"
                    PrincipalDisplayName = "FakePrincipal"
                    ScheduleInfo         = (New-CimInstance -ClassName MSFT_MicrosoftGraphRequestSchedule -Property @{
                            startDateTime = '2025-01-23T08:59:00.0000000+00:00'
                            Expiration = (New-CimInstance -ClassName MSFT_MicrosoftGraphExpirationPattern -Property @{
                                    EndDateTime = '23/12/2025 08:59:00 +00:00'
                                    Type = 'afterDateTime'} -ClientOnly)
                            } -ClientOnly)
                    Ensure = "Absent"
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilitySchedule -MockWith {
                    return $null
                }

                mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        Id = 'FakeId'
                        DisplayName = 'FakeStringValue'
                    }
                }

                Mock -CommandName New-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilityScheduleRequest -MockWith {
                    return $null
                }

                Mock -CommandName Invoke-GraphRequest -MockWith {
                    return @{
                        AccessId             = 'member'
                        GroupDisplayName     = 'FakeStringValue'
                        MemberType           = 'direct'
                        PrincipalDisplayName = 'FakePrincipal'
                        ScheduleInfo         = @{
                            StartDateTime = '2025-01-23T08:59:00.000Z'
                                Expiration = @{
                                    EndDateTime = '2025-12-23T08:59:00.000Z'
                                    type = 'afterDateTime'
                                }
                        }
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
                Should -Invoke -CommandName New-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilityScheduleRequest -Exactly 1
            }
        }

        Context -Name "The AADGroupEligibilitySchedule Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AccessId = "member"
                    GroupDisplayName = "FakeStringValue"
                    MemberType = "direct"
                    PrincipalDisplayName = "FakePrincipal"
                    ScheduleInfo         = (New-CimInstance -ClassName MSFT_MicrosoftGraphRequestSchedule -Property @{
                            Expiration = (New-CimInstance -ClassName MSFT_MicrosoftGraphExpirationPattern -Property @{
                                    Type = 'noExpiration'} -ClientOnly)
                            } -ClientOnly)
                    Ensure = "Present"
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilitySchedule -MockWith {
                    return $null
                }

                mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        Id = 'FakeId'
                        DisplayName = 'FakeStringValue'
                    }
                }

                Mock -CommandName Invoke-GraphRequest -MockWith {
                    return @{
                        AccessId             = 'member'
                        GroupDisplayName     = 'FakeStringValue'
                        MemberType           = 'direct'
                        PrincipalDisplayName = 'FakePrincipal'
                        ScheduleInfo         = @{
                                Expiration = @{
                                    type = 'noExpiration'
                                }
                        }
                    }
                }

                Mock -CommandName New-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilityScheduleRequest -MockWith {
                    return $null
                }

                Mock  -CommandName Get-MgBetaPolicyRoleManagementPolicyAssignment -MockWith {
                    return @(
                        @{
                            PolicyId = 'FakeId'
                        }
                    )
                }

                Mock -CommandName Get-MgBetaPolicyRoleManagementPolicyRule -MockWith {
                    return @{
                        AdditionalProperties = @{
                            isExpirationRequired = $true
                        }
                    }
                }

                Mock -CommandName Update-MgBetaPolicyRoleManagementPolicyRule -MockWith {
                    return @()
                }

            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The AADGroupEligibilitySchedule exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AccessId = "member"
                    GroupDisplayName = "FakeStringValue"
                    MemberType = "direct"
                    PrincipalDisplayName = "FakePrincipal"
                    ScheduleInfo         = (New-CimInstance -ClassName MSFT_MicrosoftGraphRequestSchedule -Property @{
                            startDateTime = '2025-01-23T08:59:00.0000000+00:00'
                            Expiration = (New-CimInstance -ClassName MSFT_MicrosoftGraphExpirationPattern -Property @{
                                    EndDateTime = '23/12/2025 08:59:00 +00:00'
                                    Type = 'afterDateTime'} -ClientOnly)
                            } -ClientOnly)
                    Ensure = "Present"
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilitySchedule -MockWith {
                    return $null
                }

                mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        Id = 'FakeId'
                        DisplayName = 'FakeStringValue'
                    }
                }

                Mock -CommandName Invoke-GraphRequest -MockWith {
                    return @{
                        AccessId             = 'member'
                        GroupDisplayName     = 'FakeStringValue'
                        MemberType           = 'direct'
                        PrincipalDisplayName = 'FakePrincipal'
                        ScheduleInfo         = @{
                            StartDateTime = '2025-01-23T08:59:00.000Z'
                                Expiration = @{
                                    EndDateTime = '2025-12-22T08:59:00.000Z'
                                    type = 'afterDateTime'
                                }
                        }
                    }
                }

                Mock -CommandName New-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilityScheduleRequest -MockWith {
                    return $null
                }

                Mock  -CommandName Get-MgBetaPolicyRoleManagementPolicyAssignment -MockWith {
                    return @(
                        @{
                            PolicyId = 'FakeId'
                        }
                    )
                }

                Mock -CommandName Get-MgBetaPolicyRoleManagementPolicyRule -MockWith {
                    return @{
                        AdditionalProperties = @{
                            isExpirationRequired = $true
                        }
                    }
                }

                Mock -CommandName Update-MgBetaPolicyRoleManagementPolicyRule -MockWith {
                    return @()
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
                Should -Invoke -CommandName New-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilityScheduleRequest -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        Id = 'FakeId'
                        DisplayName = 'FakeStringValue'
                    }
                }

                Mock -CommandName Get-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilitySchedule -MockWith {
                    return @{
                        Id             = 'FakeStringValue'
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
