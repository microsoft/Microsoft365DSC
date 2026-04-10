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

            Mock -ModuleName M365DSCUtil -CommandName Confirm-M365DSCDependencies -MockWith {
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

            Mock -CommandName Get-MgBetaPolicyRoleManagementPolicyRule -MockWith {
                return @{
                    AdditionalProperties = @{
                        isExpirationRequired = $true
                    }
                }
            }

            Mock  -CommandName Get-MgBetaPolicyRoleManagementPolicyAssignment -MockWith {
                return @(
                    @{
                        PolicyIdId = 'FakeId'
                    }
                )
            }

            Mock -CommandName New-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilityScheduleRequest -MockWith {
                return $null
            }

            Mock -CommandName Update-MgBetaPolicyRoleManagementPolicyRule -MockWith {
                return @()
            }

            Mock -CommandName Get-MgGroup -MockWith {
                return @{
                    Id = 'FakeId'
                    DisplayName = 'FakeStringValue'
                }
            }

            Mock -CommandName Get-MgBetaDirectoryObjectById -MockWith {
                return @{
                    AdditionalProperties = @{
                        '@odata.type' = '#microsoft.graph.group'
                        displayName = 'FakePrincipal'
                    }
                }
            }

            Mock -CommandName Get-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilitySchedule -MockWith {
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
            # Mock Write-M365DSCHost to hide output during the tests
            Mock -CommandName Write-M365DSCHost -MockWith {
            }
            $Script:exportedInstance = $null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name "The AADGroupEligibilitySchedule should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Id                   = 'FakeId'
                    AccessId             = "member"
                    MemberType           = "direct"
                    GroupDisplayName     = "FakeStringValue"
                    Principal            = "FakeGroup"
                    PrincipalType        = "group"
                    ScheduleInfo         = (New-CimInstance -ClassName MSFT_MicrosoftGraphRequestSchedule -Property @{

                            startDateTime = '2025-01-23T08:59:00.0000000+00:00'
                            Expiration = (New-CimInstance -ClassName MSFT_MicrosoftGraphExpirationPattern -Property @{
                                    EndDateTime = '2025-12-23T08:59:00.00000000+00:00'
                                    Type = 'afterDateTime'} -ClientOnly)
                            } -ClientOnly)
                    Ensure               = "Present"
                    Credential           = $Credential;
                }

                Mock -CommandName Get-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilitySchedule -MockWith {
                    return $null
                }

                Mock -CommandName New-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilityScheduleRequest -MockWith {
                    return $null
                }

                Mock -CommandName Get-MgBetaPolicyRoleManagementPolicyRule -MockWith {
                    return @{
                        AdditionalProperties = @{
                            isExpirationRequired = $false
                        }
                    }
                }

                mock -CommandName Get-MgUser -MockWith {
                    return @{
                        Id = 'FakeId'
                        UserPrincipalName = 'John.Smith@contoso.com'
                    }
                }

                mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        Id = 'FakeId'
                        DisplayName = 'FakeStringValue'
                    }
                } -ParameterFilter {$Filter -eq "DisplayName eq 'FakeStringValue'"}

                mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        Id = 'FakeId'
                        DisplayName = 'FakeGroup'
                    }
                } -ParameterFilter {$Filter -eq "DisplayName eq 'FakeGroup'"}

                Mock -CommandName Get-MgBetaDirectoryObjectById -MockWith {
                    return @{
                        Id                   = "FakeId"
                        AdditionalProperties = @{
                            '@odata.type' = '#microsoft.graph.user'
                            userPrincipalName = 'John.Smith@contoso.com'
                        }
                    }
                }

                Mock -CommandName Get-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilitySchedule -MockWith {
                    return @{
                        Id                   = 'WrongId_member_WrongId'
                        AccessId             = 'member'
                        MemberType           = 'direct'
                        GroupDisplayName     = "FakeStringValue"
                        Principal            = "John.Smith@contoso.com";
                        PrincipalType        = "User"
                        ScheduleInfo         = @{
                            StartDateTime = '2025-01-23T08:59:00.000Z'
                                Expiration = @{
                                    EndDateTime = $null
                                    type = 'noExpiration'
                                    duration = $null
                                }
                        }
                    }
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
                Assert-MockCalled Get-MgGroup -Exactly 2 -Scope It
                Assert-MockCalled Get-MgBetaDirectoryObjectById -Exactly 0 -Scope It
                Assert-MockCalled Get-MgUser -Exactly 0 -Scope It
                Assert-MockCalled Get-MgBetaPolicyRoleManagementPolicyAssignment -Exactly 0 -Scope It
                Assert-MockCalled Get-MgBetaPolicyRoleManagementPolicyRule -Exactly 0 -Scope It
                Assert-MockCalled Update-MgBetaPolicyRoleManagementPolicyRule -Exactly 0 -Scope It
                Assert-MockCalled Get-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilitySchedule -Exactly 1 -Scope It
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
                Assert-MockCalled Get-MgGroup -Exactly 2 -Scope It
                Assert-MockCalled Get-MgBetaDirectoryObjectById -Exactly 0 -Scope It
                Assert-MockCalled Get-MgUser -Exactly 0 -Scope It
                Assert-MockCalled Get-MgBetaPolicyRoleManagementPolicyAssignment -Exactly 0 -Scope It
                Assert-MockCalled Get-MgBetaPolicyRoleManagementPolicyRule -Exactly 0 -Scope It
                Assert-MockCalled Update-MgBetaPolicyRoleManagementPolicyRule -Exactly 0 -Scope It
                Assert-MockCalled Get-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilitySchedule -Exactly 1 -Scope It
            }

            It 'Should Create the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilityScheduleRequest -Exactly 1
                Assert-MockCalled Get-MgGroup -Exactly 4 -Scope It
                Assert-MockCalled Get-MgBetaDirectoryObjectById -Exactly 0 -Scope It
                Assert-MockCalled Get-MgUser -Exactly 0 -Scope It
                Assert-MockCalled Get-MgBetaPolicyRoleManagementPolicyAssignment -Exactly 1 -Scope It
                Assert-MockCalled Get-MgBetaPolicyRoleManagementPolicyRule -Exactly 1 -Scope It
                Assert-MockCalled Update-MgBetaPolicyRoleManagementPolicyRule -Exactly 1 -Scope It
                Assert-MockCalled Get-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilitySchedule -Exactly 1 -Scope It
                Assert-MockCalled New-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilityScheduleRequest -Exactly 1 -Scope It
            }
        }

        Context -Name "The AADGroupEligibilitySchedule exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    AccessId = "member"
                    MemberType = "direct"
                    GroupDisplayName = "FakeStringValue"
                    Principal = "John.Smith@contoso.com"
                    PrincipalType = "User"
                    ScheduleInfo         = (New-CimInstance -ClassName MSFT_MicrosoftGraphRequestSchedule -Property @{
                        startDateTime = '2025-01-23T08:59:00.0000000+00:00'
                        Expiration = (New-CimInstance -ClassName MSFT_MicrosoftGraphExpirationPattern -Property @{
                                EndDateTime = '2025-12-23T08:59:00.00000000+00:00'
                                Type = 'afterDateTime'} -ClientOnly)
                        } -ClientOnly)
                    Ensure = "Absent"
                    Credential = $Credential;
                }

                mock -CommandName Get-MgUser -MockWith {
                    return @{
                        Id = 'UserFakeId'
                        UserPrincipalName = 'John.Smith@contoso.com'
                    }
                }

                mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        Id = 'GroupFakeId'
                        DisplayName = 'FakeStringValue'
                    }
                }

                Mock -CommandName Get-MgBetaDirectoryObjectById -MockWith {
                    return @{
                        AdditionalProperties = @{
                            '@odata.type' = '#microsoft.graph.user'
                            userPrincipalName = 'John.Smith@contoso.com'
                        }
                    }
                }

                Mock -CommandName New-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilityScheduleRequest -MockWith {
                    return $null
                }

                Mock -CommandName Get-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilitySchedule -MockWith {
                    return @{
                        Id                   = 'GroupFakeId_member_FakeId'
                        AccessId             = 'member'
                        MemberType           = 'direct'
                        PrincipalId          = 'UserFakeId'
                        PrincipalType        = "User"
                        GroupId              = "GroupFakeId"
                        Status               = "Provisioned"
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
                Assert-MockCalled Get-MgGroup -Exactly 1 -Scope It
                Assert-MockCalled Get-MgBetaDirectoryObjectById -Exactly 1 -Scope It
                Assert-MockCalled Get-MgUser -Exactly 1 -Scope It
                Assert-MockCalled Get-MgBetaPolicyRoleManagementPolicyAssignment -Exactly 0 -Scope It
                Assert-MockCalled Get-MgBetaPolicyRoleManagementPolicyRule -Exactly 0 -Scope It
                Assert-MockCalled Update-MgBetaPolicyRoleManagementPolicyRule -Exactly 0 -Scope It
                Assert-MockCalled Get-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilitySchedule -Exactly 1 -Scope It
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
                Assert-MockCalled Get-MgGroup -Exactly 1 -Scope It
                Assert-MockCalled Get-MgBetaDirectoryObjectById -Exactly 1 -Scope It
                Assert-MockCalled Get-MgUser -Exactly 1 -Scope It
                Assert-MockCalled Get-MgBetaPolicyRoleManagementPolicyAssignment -Exactly 0 -Scope It
                Assert-MockCalled Get-MgBetaPolicyRoleManagementPolicyRule -Exactly 0 -Scope It
                Assert-MockCalled Update-MgBetaPolicyRoleManagementPolicyRule -Exactly 0 -Scope It
                Assert-MockCalled Get-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilitySchedule -Exactly 1 -Scope It
            }

            It 'Should Remove the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilityScheduleRequest -Exactly 1
                Assert-MockCalled Get-MgGroup -Exactly 2 -Scope It
                Assert-MockCalled Get-MgBetaDirectoryObjectById -Exactly 1 -Scope It
                Assert-MockCalled Get-MgUser -Exactly 2 -Scope It
                Assert-MockCalled Get-MgBetaPolicyRoleManagementPolicyAssignment -Exactly 0 -Scope It
                Assert-MockCalled Get-MgBetaPolicyRoleManagementPolicyRule -Exactly 0 -Scope It
                Assert-MockCalled Update-MgBetaPolicyRoleManagementPolicyRule -Exactly 0 -Scope It
                Assert-MockCalled Get-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilitySchedule -Exactly 1 -Scope It
                Assert-MockCalled New-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilityScheduleRequest -Exactly 1 -Scope It
            }
        }

        Context -Name "The AADGroupEligibilitySchedule Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AccessId = "member"
                    MemberType = "direct"
                    GroupDisplayName     = "FakeStringValue"
                    Principal            = "John.Smith@contoso.com";
                    PrincipalType        = "User"
                    ScheduleInfo         = (New-CimInstance -ClassName MSFT_MicrosoftGraphRequestSchedule -Property @{
                        startDateTime = '2025-01-23T08:59:00.0000000+00:00'
                        Expiration = (New-CimInstance -ClassName MSFT_MicrosoftGraphExpirationPattern -Property @{
                                EndDateTime = '2025-12-23T08:59:00.0000000+00:00'
                                Type = 'afterDateTime'} -ClientOnly)
                        } -ClientOnly)
                    Ensure = "Present"
                    Credential = $Credential;
                }
                Mock -CommandName Get-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilitySchedule -MockWith {
                    return @{
                        Id                   = 'GroupFakeId_member_FakeId'
                        AccessId             = 'member'
                        MemberType           = 'direct'
                        PrincipalId          = 'UserFakeId'
                        PrincipalType        = "User"
                        GroupId              = "GroupFakeId"
                        Status               = "Provisioned"
                        ScheduleInfo         = @{
                            StartDateTime = '2025-01-23T08:59:00.000Z'
                                Expiration = @{
                                    EndDateTime = '2025-12-23T08:59:00.000Z'
                                    type = 'afterDateTime'
                                }
                        }
                    }
                }
                mock -CommandName Get-MgUser -MockWith {
                    return @{
                        Id = 'UserFakeId'
                        UserPrincipalName = 'John.Smith@contoso.com'
                    }
                }

                mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        Id = 'GroupFakeId'
                        DisplayName = 'FakeStringValue'
                    }
                } -ParameterFilter {$Filter -eq "DisplayName eq 'FakeStringValue'"}

                Mock -CommandName Get-MgBetaDirectoryObjectById -MockWith {
                    return @{
                        AdditionalProperties = @{
                            '@odata.type' = '#microsoft.graph.user'
                            userPrincipalName = 'John.Smith@contoso.com'
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

                Assert-MockCalled Get-MgGroup -Exactly 1 -Scope It
                Assert-MockCalled Get-MgBetaDirectoryObjectById -Exactly 1 -Scope It
                Assert-MockCalled Get-MgUser -Exactly 1 -Scope It
                Assert-MockCalled Get-MgBetaPolicyRoleManagementPolicyAssignment -Exactly 0 -Scope It
                Assert-MockCalled Get-MgBetaPolicyRoleManagementPolicyRule -Exactly 0 -Scope It
                Assert-MockCalled Update-MgBetaPolicyRoleManagementPolicyRule -Exactly 0 -Scope It
                Assert-MockCalled Get-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilitySchedule -Exactly 1 -Scope It
            }
        }

        Context -Name "The AADGroupEligibilitySchedule exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AccessId                 = "member"
                    MemberType               = "direct"
                    GroupDisplayName         = "FakeStringValue"
                    Principal                = "John.Smith@contoso.com";
                    PrincipalType            = "User"
                    ScheduleInfo             = (New-CimInstance -ClassName MSFT_MicrosoftGraphRequestSchedule -Property @{
                        startDateTime = '2025-01-23T08:59:00.0000000+00:00'
                        Expiration = (New-CimInstance -ClassName MSFT_MicrosoftGraphExpirationPattern -Property @{
                                EndDateTime = '2025-12-24T08:59:00.00000000+00:00' # Drift
                                Type = 'afterDateTime'} -ClientOnly)
                        } -ClientOnly)
                    Ensure                    = "Present"
                    Credential                = $Credential;
                }

                mock -CommandName Get-MgUser -MockWith {
                    return @{
                        Id = 'UserFakeId'
                        UserPrincipalName = 'John.Smith@contoso.com'
                    }
                }
                mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        Id = 'GroupFakeId'
                        DisplayName = 'FakeStringValue'
                    }
                }

                Mock -CommandName Get-MgBetaDirectoryObjectById -MockWith {
                    return @{
                        AdditionalProperties = @{
                            '@odata.type' = '#microsoft.graph.user'
                            userPrincipalName = 'John.Smith@contoso.com'
                        }
                    }
                }

                Mock -CommandName Get-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilitySchedule -MockWith {
                    return @{
                        Id                   = 'GroupFakeId_member_FakeId'
                        AccessId             = 'member'
                        MemberType           = 'direct'
                        PrincipalId          = 'UserFakeId'
                        PrincipalType        = "User"
                        GroupId              = "GroupFakeId"
                        Status               = "Provisioned"
                        ScheduleInfo         = @{
                            StartDateTime = '2025-01-23T08:59:00.000Z'
                                Expiration = @{
                                    EndDateTime = '2025-12-23T08:59:00.000Z'
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
                Assert-MockCalled Get-MgGroup -Exactly 1 -Scope It
                Assert-MockCalled Get-MgBetaDirectoryObjectById -Exactly 1 -Scope It
                Assert-MockCalled Get-MgUser -Exactly 1 -Scope It
                Assert-MockCalled Get-MgBetaPolicyRoleManagementPolicyAssignment -Exactly 0 -Scope It
                Assert-MockCalled Get-MgBetaPolicyRoleManagementPolicyRule -Exactly 0 -Scope It
                Assert-MockCalled Update-MgBetaPolicyRoleManagementPolicyRule -Exactly 0 -Scope It
                Assert-MockCalled Get-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilitySchedule -Exactly 1 -Scope It
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
                Assert-MockCalled Get-MgGroup -Exactly 1 -Scope It
                Assert-MockCalled Get-MgBetaDirectoryObjectById -Exactly 1 -Scope It
                Assert-MockCalled Get-MgUser -Exactly 1 -Scope It
                Assert-MockCalled Get-MgBetaPolicyRoleManagementPolicyAssignment -Exactly 0 -Scope It
                Assert-MockCalled Get-MgBetaPolicyRoleManagementPolicyRule -Exactly 0 -Scope It
                Assert-MockCalled Update-MgBetaPolicyRoleManagementPolicyRule -Exactly 0 -Scope It
                Assert-MockCalled Get-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilitySchedule -Exactly 1 -Scope It
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilityScheduleRequest -Exactly 1
                Assert-MockCalled Get-MgGroup -Exactly 2 -Scope It
                Assert-MockCalled Get-MgBetaDirectoryObjectById -Exactly 1 -Scope It
                Assert-MockCalled Get-MgUser -Exactly 2 -Scope It
                Assert-MockCalled Get-MgBetaPolicyRoleManagementPolicyAssignment -Exactly 1 -Scope It
                Assert-MockCalled Get-MgBetaPolicyRoleManagementPolicyRule -Exactly 1 -Scope It
                Assert-MockCalled Update-MgBetaPolicyRoleManagementPolicyRule -Exactly 0 -Scope It
                Assert-MockCalled Get-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilitySchedule -Exactly 1 -Scope It
                Assert-MockCalled New-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilityScheduleRequest -Exactly 1 -Scope It
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Invoke-M365DSCGraphBatchRequest -MockWith {
                    return @(
                        @{
                            id = 'GroupFakeId'
                            body = @{
                                value = @{
                                    Id                   = "GroupFakeId_member_FakeId"
                                    accessId             = 'member'
                                    groupDisplayName     = 'FakeStringValue'
                                    memberType           = 'direct'
                                    principalDisplayName = 'FakePrincipal'
                                    scheduleInfo         = @{
                                        startDateTime = '2025-01-23T08:59:00.000Z'
                                        expiration = @{
                                            endDateTime = '2025-12-22T08:59:00.000Z'
                                            type = 'afterDateTime'
                                        }
                                    }
                                }
                            }
                        }
                    )
                }

                mock -CommandName Get-MgUser -MockWith {
                    return @{
                        Id = 'UserFakeId'
                        UserPrincipalName = 'John.Smith@contoso.com'
                    }
                }

                mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        Id = 'GroupFakeId'
                        DisplayName = 'FakeStringValue'
                    }
                }

                Mock -CommandName Get-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilitySchedule -MockWith {
                    return @{
                        Id                   = 'GroupFakeId_member_FakeId'
                        AccessId             = 'member'
                        MemberType           = 'direct'
                        PrincipalId          = 'UserFakeId'
                        PrincipalType        = "User"
                        GroupId              = "GroupFakeId"
                        Status               = "Provisioned"
                        ScheduleInfo         = @{
                            StartDateTime = '2025-01-23T08:59:00.000Z'
                                Expiration = @{
                                    EndDateTime = '2025-12-23T08:59:00.000Z'
                                    type = 'afterDateTime'
                                }
                        }
                    }
                }

                Mock -CommandName Get-MgBetaDirectoryObjectById -MockWith {
                    return @{
                        AdditionalProperties = @{
                            '@odata.type' = '#microsoft.graph.user'
                            userPrincipalName = 'John.Smith@contoso.com'
                        }
                    }
                }
            }

            It 'Should Reverse Engineer resource from the Export method' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
                Assert-MockCalled Get-MgGroup -Exactly 1 -Scope It
                Assert-MockCalled Get-MgBetaDirectoryObjectById -Exactly 2 -Scope It
                Assert-MockCalled Get-MgUser -Exactly 0 -Scope It
                Assert-MockCalled Get-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilitySchedule -Exactly 0 -Scope It
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
