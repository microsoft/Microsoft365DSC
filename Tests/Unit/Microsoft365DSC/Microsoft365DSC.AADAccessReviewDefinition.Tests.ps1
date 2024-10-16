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
    -DscResource "AADAccessReviewDefinition" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Set-MgBetaIdentityGovernanceAccessReviewDefinition -MockWith {
            }

            Mock -CommandName New-MgBetaIdentityGovernanceAccessReviewDefinition -MockWith {
            }

            Mock -CommandName Remove-MgBetaIdentityGovernanceAccessReviewDefinition -MockWith {
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
        Context -Name "The AADAccessReviewDefinition should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    DescriptionForAdmins = "FakeStringValue"
                    DescriptionForReviewers = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    Id = "FakeStringValue"
                    Scope = (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                        QueryRoot = "FakeStringValue"
                        odataType = "#microsoft.graph.accessReviewQueryScope"
                        Query = "FakeStringValue"
                        QueryType = "FakeStringValue"
                    } -ClientOnly)
                    Settings = (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScheduleSettings -Property @{
                        Recurrence = (New-CimInstance -ClassName MSFT_MicrosoftGraphpatternedRecurrence -Property @{
                            Pattern = (New-CimInstance -ClassName MSFT_MicrosoftGraphrecurrencePattern -Property @{
                                Index = "first"
                                FirstDayOfWeek = "sunday"
                                DayOfMonth = 25
                                Month = 25
                                DaysOfWeek = @("sunday")
                                Type = "daily"
                                Interval = 25
                            } -ClientOnly)
                            Range = (New-CimInstance -ClassName MSFT_MicrosoftGraphrecurrenceRange -Property @{
                                StartDate = "2023-01-01T00:00:00.0000000"
                                EndDate = "2023-01-01T00:00:00.0000000"
                                RecurrenceTimeZone = "FakeStringValue"
                                NumberOfOccurrences = 25
                                Type = "endDate"
                            } -ClientOnly)
                        } -ClientOnly)
                        InstanceDurationInDays = 25
                        DefaultDecision = "FakeStringValue"
                        RecommendationsEnabled = $True
                        DecisionHistoriesForReviewersEnabled = $True
                        ReminderNotificationsEnabled = $True
                        ApplyActions = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewApplyAction -Property @{
                                odataType = "#microsoft.graph.disableAndDeleteUserApplyAction"
                            } -ClientOnly)
                        )
                        RecommendationInsightSettings = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewRecommendationInsightSetting -Property @{
                                odataType = "#microsoft.graph.groupPeerOutlierRecommendationInsightSettings"
                                SignInScope = "tenant"
                            } -ClientOnly)
                        )
                        DefaultDecisionEnabled = $True
                        MailNotificationsEnabled = $True
                        JustificationRequiredOnApproval = $True
                        AutoApplyDecisionsEnabled = $True
                    } -ClientOnly)
                    StageSettings = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewStageSettings -Property @{
                            Reviewers = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewReviewerScope -Property @{
                                    ResourceScopes = [CimInstance[]]@(
                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                        Name = "ResourceScopes"
                                        isArray = $True
                                        CIMType = "MSFT_MicrosoftGraphaccessReviewScope"
                                        } -ClientOnly)
                                    )
                                    QueryRoot = "FakeStringValue"
                                    odataType = "#microsoft.graph.accessReviewQueryScope"
                                    PrincipalScopes = [CimInstance[]]@(
                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                        Name = "PrincipalScopes"
                                        isArray = $True
                                        CIMType = "MSFT_MicrosoftGraphaccessReviewScope"
                                        } -ClientOnly)
                                    )
                                    Query = "FakeStringValue"
                                    QueryType = "FakeStringValue"
                                } -ClientOnly)
                            )
                            RecommendationsEnabled = $True
                            DurationInDays = 25
                            DependsOn = @("FakeStringValue")
                            DecisionsThatWillMoveToNextStage = @("FakeStringValue")
                            StageId = "FakeStringValue"
                            RecommendationInsightSettings = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewRecommendationInsightSetting -Property @{
                                    odataType = "#microsoft.graph.groupPeerOutlierRecommendationInsightSettings"
                                    SignInScope = "tenant"
                                } -ClientOnly)
                            )
                        } -ClientOnly)
                    )
                    Status = "FakeStringValue"
                    Ensure = "Present"
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaIdentityGovernanceAccessReviewDefinition -MockWith {
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
                Should -Invoke -CommandName New-MgBetaIdentityGovernanceAccessReviewDefinition -Exactly 1
            }
        }

        Context -Name "The AADAccessReviewDefinition exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    DescriptionForAdmins = "FakeStringValue"
                    DescriptionForReviewers = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    Id = "FakeStringValue"
                    Scope = (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                        QueryRoot = "FakeStringValue"
                        odataType = "#microsoft.graph.accessReviewQueryScope"
                        Query = "FakeStringValue"
                        QueryType = "FakeStringValue"
                    } -ClientOnly)
                    Settings = (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScheduleSettings -Property @{
                        Recurrence = (New-CimInstance -ClassName MSFT_MicrosoftGraphpatternedRecurrence -Property @{
                            Pattern = (New-CimInstance -ClassName MSFT_MicrosoftGraphrecurrencePattern -Property @{
                                Index = "first"
                                FirstDayOfWeek = "sunday"
                                DayOfMonth = 25
                                Month = 25
                                DaysOfWeek = @("sunday")
                                Type = "daily"
                                Interval = 25
                            } -ClientOnly)
                            Range = (New-CimInstance -ClassName MSFT_MicrosoftGraphrecurrenceRange -Property @{
                                StartDate = "2023-01-01T00:00:00.0000000"
                                EndDate = "2023-01-01T00:00:00.0000000"
                                RecurrenceTimeZone = "FakeStringValue"
                                NumberOfOccurrences = 25
                                Type = "endDate"
                            } -ClientOnly)
                        } -ClientOnly)
                        InstanceDurationInDays = 25
                        DefaultDecision = "FakeStringValue"
                        RecommendationsEnabled = $True
                        DecisionHistoriesForReviewersEnabled = $True
                        ReminderNotificationsEnabled = $True
                        ApplyActions = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewApplyAction -Property @{
                                odataType = "#microsoft.graph.disableAndDeleteUserApplyAction"
                            } -ClientOnly)
                        )
                        RecommendationInsightSettings = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewRecommendationInsightSetting -Property @{
                                odataType = "#microsoft.graph.groupPeerOutlierRecommendationInsightSettings"
                                SignInScope = "tenant"
                            } -ClientOnly)
                        )
                        DefaultDecisionEnabled = $True
                        MailNotificationsEnabled = $True
                        JustificationRequiredOnApproval = $True
                        AutoApplyDecisionsEnabled = $True
                    } -ClientOnly)
                    StageSettings = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewStageSettings -Property @{
                            Reviewers = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewReviewerScope -Property @{
                                    ResourceScopes = [CimInstance[]]@(
                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                        Name = "ResourceScopes"
                                        isArray = $True
                                        CIMType = "MSFT_MicrosoftGraphaccessReviewScope"
                                        } -ClientOnly)
                                    )
                                    QueryRoot = "FakeStringValue"
                                    odataType = "#microsoft.graph.accessReviewQueryScope"
                                    PrincipalScopes = [CimInstance[]]@(
                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                        Name = "PrincipalScopes"
                                        isArray = $True
                                        CIMType = "MSFT_MicrosoftGraphaccessReviewScope"
                                        } -ClientOnly)
                                    )
                                    Query = "FakeStringValue"
                                    QueryType = "FakeStringValue"
                                } -ClientOnly)
                            )
                            RecommendationsEnabled = $True
                            DurationInDays = 25
                            DependsOn = @("FakeStringValue")
                            DecisionsThatWillMoveToNextStage = @("FakeStringValue")
                            StageId = "FakeStringValue"
                            RecommendationInsightSettings = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewRecommendationInsightSetting -Property @{
                                    odataType = "#microsoft.graph.groupPeerOutlierRecommendationInsightSettings"
                                    SignInScope = "tenant"
                                } -ClientOnly)
                            )
                        } -ClientOnly)
                    )
                    Status = "FakeStringValue"
                    Ensure = 'Absent'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaIdentityGovernanceAccessReviewDefinition -MockWith {
                    return @{
                        DescriptionForAdmins = "FakeStringValue"
                        DescriptionForReviewers = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        Id = "FakeStringValue"
                        Scope = @{
                            QueryType = "FakeStringValue"
                            QueryRoot = "FakeStringValue"
                            '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                            Query = "FakeStringValue"
                        }
                        Settings = @{
                            Recurrence = @{
                                Pattern = @{
                                    Index = "first"
                                    FirstDayOfWeek = "sunday"
                                    DayOfMonth = 25
                                    Month = 25
                                    DaysOfWeek = @("sunday")
                                    Type = "daily"
                                    Interval = 25
                                }
                                Range = @{
                                    StartDate = "2023-01-01T00:00:00.0000000"
                                    EndDate = "2023-01-01T00:00:00.0000000"
                                    RecurrenceTimeZone = "FakeStringValue"
                                    NumberOfOccurrences = 25
                                    Type = "endDate"
                                }
                            }
                            InstanceDurationInDays = 25
                            DefaultDecision = "FakeStringValue"
                            RecommendationsEnabled = $True
                            DecisionHistoriesForReviewersEnabled = $True
                            ReminderNotificationsEnabled = $True
                            ApplyActions = @(
                                @{
                                    '@odata.type' = "#microsoft.graph.disableAndDeleteUserApplyAction"
                                }
                            )
                            RecommendationInsightSettings = @(
                                @{
                                    '@odata.type' = "#microsoft.graph.groupPeerOutlierRecommendationInsightSettings"
                                    SignInScope = "tenant"
                                }
                            )
                            DefaultDecisionEnabled = $True
                            MailNotificationsEnabled = $True
                            JustificationRequiredOnApproval = $True
                            AutoApplyDecisionsEnabled = $True
                        }
                        StageSettings = @(
                            @{
                                Reviewers = @(
                                    @{
                                        QueryType = "FakeStringValue"
                                        ResourceScopes = @(
                                            @{
                                            Name = "ResourceScopes"
                                            isArray = $True
                                            }
                                        )
                                        QueryRoot = "FakeStringValue"
                                        PrincipalScopes = @(
                                            @{
                                            Name = "PrincipalScopes"
                                            isArray = $True
                                            }
                                        )
                                        '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                        Query = "FakeStringValue"
                                    }
                                )
                                RecommendationsEnabled = $True
                                DurationInDays = 25
                                DependsOn = @("FakeStringValue")
                                DecisionsThatWillMoveToNextStage = @("FakeStringValue")
                                StageId = "FakeStringValue"
                                RecommendationInsightSettings = @(
                                    @{
                                        '@odata.type' = "#microsoft.graph.groupPeerOutlierRecommendationInsightSettings"
                                        SignInScope = "tenant"
                                    }
                                )
                            }
                        )
                        Status = "FakeStringValue"

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
                Should -Invoke -CommandName Remove-MgBetaIdentityGovernanceAccessReviewDefinition -Exactly 1
            }
        }
        Context -Name "The AADAccessReviewDefinition Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    DescriptionForAdmins = "FakeStringValue"
                    DescriptionForReviewers = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    Id = "FakeStringValue"
                    Scope = (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                        QueryRoot = "FakeStringValue"
                        odataType = "#microsoft.graph.accessReviewQueryScope"
                        Query = "FakeStringValue"
                        QueryType = "FakeStringValue"
                    } -ClientOnly)
                    Settings = (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScheduleSettings -Property @{
                        Recurrence = (New-CimInstance -ClassName MSFT_MicrosoftGraphpatternedRecurrence -Property @{
                            Pattern = (New-CimInstance -ClassName MSFT_MicrosoftGraphrecurrencePattern -Property @{
                                Index = "first"
                                FirstDayOfWeek = "sunday"
                                DayOfMonth = 25
                                Month = 25
                                DaysOfWeek = @("sunday")
                                Type = "daily"
                                Interval = 25
                            } -ClientOnly)
                            Range = (New-CimInstance -ClassName MSFT_MicrosoftGraphrecurrenceRange -Property @{
                                StartDate = "2023-01-01T00:00:00.0000000"
                                EndDate = "2023-01-01T00:00:00.0000000"
                                RecurrenceTimeZone = "FakeStringValue"
                                NumberOfOccurrences = 25
                                Type = "endDate"
                            } -ClientOnly)
                        } -ClientOnly)
                        InstanceDurationInDays = 25
                        DefaultDecision = "FakeStringValue"
                        RecommendationsEnabled = $True
                        DecisionHistoriesForReviewersEnabled = $True
                        ReminderNotificationsEnabled = $True
                        ApplyActions = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewApplyAction -Property @{
                                odataType = "#microsoft.graph.disableAndDeleteUserApplyAction"
                            } -ClientOnly)
                        )
                        RecommendationInsightSettings = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewRecommendationInsightSetting -Property @{
                                odataType = "#microsoft.graph.groupPeerOutlierRecommendationInsightSettings"
                                SignInScope = "tenant"
                            } -ClientOnly)
                        )
                        DefaultDecisionEnabled = $True
                        MailNotificationsEnabled = $True
                        JustificationRequiredOnApproval = $True
                        AutoApplyDecisionsEnabled = $True
                    } -ClientOnly)
                    StageSettings = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewStageSettings -Property @{
                            Reviewers = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewReviewerScope -Property @{
                                    ResourceScopes = [CimInstance[]]@(
                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                        Name = "ResourceScopes"
                                        isArray = $True
                                        CIMType = "MSFT_MicrosoftGraphaccessReviewScope"
                                        } -ClientOnly)
                                    )
                                    QueryRoot = "FakeStringValue"
                                    odataType = "#microsoft.graph.accessReviewQueryScope"
                                    PrincipalScopes = [CimInstance[]]@(
                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                        Name = "PrincipalScopes"
                                        isArray = $True
                                        CIMType = "MSFT_MicrosoftGraphaccessReviewScope"
                                        } -ClientOnly)
                                    )
                                    Query = "FakeStringValue"
                                    QueryType = "FakeStringValue"
                                } -ClientOnly)
                            )
                            RecommendationsEnabled = $True
                            DurationInDays = 25
                            DependsOn = @("FakeStringValue")
                            DecisionsThatWillMoveToNextStage = @("FakeStringValue")
                            StageId = "FakeStringValue"
                            RecommendationInsightSettings = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewRecommendationInsightSetting -Property @{
                                    odataType = "#microsoft.graph.groupPeerOutlierRecommendationInsightSettings"
                                    SignInScope = "tenant"
                                } -ClientOnly)
                            )
                        } -ClientOnly)
                    )
                    Status = "FakeStringValue"
                    Ensure = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaIdentityGovernanceAccessReviewDefinition -MockWith {
                    return @{
                        AdditionalNotificationRecipients = @(
                            @{
                                NotificationRecipientScope = @{
                                    QueryRoot = "FakeStringValue"
                                    QueryType = "FakeStringValue"
                                    Query = "FakeStringValue"
                                    '@odata.type' = "#microsoft.graph.a"
                                }
                                NotificationTemplateType = "FakeStringValue"
                            }
                        )
                        AdditionalProperties = @{
                            '@odata.type' = "#microsoft.graph.AccessReviewScheduleDefinition"
                        }
                        BackupReviewers = @(
                            @{
                                QueryType = "FakeStringValue"
                                ResourceScopes = @(
                                    @{
                                        QueryType = "FakeStringValue"
                                        ResourceScopes = @(
                                            @{
                                            Name = "ResourceScopes"
                                            isArray = $True
                                            }
                                        )
                                        QueryRoot = "FakeStringValue"
                                        PrincipalScopes = @(
                                            @{
                                            Name = "PrincipalScopes"
                                            isArray = $True
                                            }
                                        )
                                        '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                        Query = "FakeStringValue"
                                    }
                                )
                                QueryRoot = "FakeStringValue"
                                PrincipalScopes = @(
                                    @{
                                        QueryType = "FakeStringValue"
                                        ResourceScopes = @(
                                            @{
                                            Name = "ResourceScopes"
                                            isArray = $True
                                            }
                                        )
                                        QueryRoot = "FakeStringValue"
                                        PrincipalScopes = @(
                                            @{
                                                QueryType = "FakeStringValue"
                                                ResourceScopes = @(
                                                    @{
                                                        QueryType = "FakeStringValue"
                                                        ResourceScopes = @(
                                                            @{
                                                                QueryType = "FakeStringValue"
                                                                ResourceScopes = @(
                                                                    @{
                                                                    Name = "ResourceScopes"
                                                                    isArray = $True
                                                                    }
                                                                )
                                                                QueryRoot = "FakeStringValue"
                                                                PrincipalScopes = @(
                                                                    @{
                                                                    Name = "PrincipalScopes"
                                                                    isArray = $True
                                                                    }
                                                                )
                                                                '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                                                Query = "FakeStringValue"
                                                            }
                                                        )
                                                        QueryRoot = "FakeStringValue"
                                                        PrincipalScopes = @(
                                                            @{
                                                                QueryType = "FakeStringValue"
                                                                ResourceScopes = @(
                                                                    @{
                                                                    Name = "ResourceScopes"
                                                                    isArray = $True
                                                                    }
                                                                )
                                                                QueryRoot = "FakeStringValue"
                                                                PrincipalScopes = @(
                                                                    @{
                                                                    Name = "PrincipalScopes"
                                                                    isArray = $True
                                                                    }
                                                                )
                                                                '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                                                Query = "FakeStringValue"
                                                            }
                                                        )
                                                        '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                                        Query = "FakeStringValue"
                                                    }
                                                )
                                                QueryRoot = "FakeStringValue"
                                                PrincipalScopes = @(
                                                    @{
                                                    Name = "PrincipalScopes"
                                                    isArray = $True
                                                    }
                                                )
                                                '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                                Query = "FakeStringValue"
                                            }
                                        )
                                        '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                        Query = "FakeStringValue"
                                    }
                                )
                                '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                Query = "FakeStringValue"
                            }
                        )
                        CreatedBy = @{
                            IpAddress = "FakeStringValue"
                            '@odata.type' = "#microsoft.graph.a"
                            UserPrincipalName = "FakeStringValue"
                            HomeTenantId = "FakeStringValue"
                            HomeTenantName = "FakeStringValue"
                        }
                        DescriptionForAdmins = "FakeStringValue"
                        DescriptionForReviewers = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        FallbackReviewers = @(
                            @{
                                QueryType = "FakeStringValue"
                                ResourceScopes = @(
                                    @{
                                        QueryType = "FakeStringValue"
                                        ResourceScopes = @(
                                            @{
                                            Name = "ResourceScopes"
                                            isArray = $True
                                            }
                                        )
                                        QueryRoot = "FakeStringValue"
                                        PrincipalScopes = @(
                                            @{
                                            Name = "PrincipalScopes"
                                            isArray = $True
                                            }
                                        )
                                        '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                        Query = "FakeStringValue"
                                    }
                                )
                                QueryRoot = "FakeStringValue"
                                PrincipalScopes = @(
                                    @{
                                        QueryType = "FakeStringValue"
                                        ResourceScopes = @(
                                            @{
                                            Name = "ResourceScopes"
                                            isArray = $True
                                            }
                                        )
                                        QueryRoot = "FakeStringValue"
                                        PrincipalScopes = @(
                                            @{
                                            Name = "PrincipalScopes"
                                            isArray = $True
                                            }
                                        )
                                        '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                        Query = "FakeStringValue"
                                    }
                                )
                                '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                Query = "FakeStringValue"
                            }
                        )
                        Id = "FakeStringValue"
                        InstanceEnumerationScope = @{
                            QueryType = "FakeStringValue"
                            ResourceScopes = @(
                                @{
                                    QueryType = "FakeStringValue"
                                    ResourceScopes = @(
                                        @{
                                        Name = "ResourceScopes"
                                        isArray = $True
                                        }
                                    )
                                    QueryRoot = "FakeStringValue"
                                    PrincipalScopes = @(
                                        @{
                                        Name = "PrincipalScopes"
                                        isArray = $True
                                        }
                                    )
                                    '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                    Query = "FakeStringValue"
                                }
                            )
                            QueryRoot = "FakeStringValue"
                            PrincipalScopes = @(
                                @{
                                    QueryType = "FakeStringValue"
                                    ResourceScopes = @(
                                        @{
                                        Name = "ResourceScopes"
                                        isArray = $True
                                        }
                                    )
                                    QueryRoot = "FakeStringValue"
                                    PrincipalScopes = @(
                                        @{
                                        Name = "PrincipalScopes"
                                        isArray = $True
                                        }
                                    )
                                    '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                    Query = "FakeStringValue"
                                }
                            )
                            '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                            Query = "FakeStringValue"
                        }
                        Reviewers = @(
                            @{
                                QueryType = "FakeStringValue"
                                ResourceScopes = @(
                                    @{
                                        QueryType = "FakeStringValue"
                                        ResourceScopes = @(
                                            @{
                                            Name = "ResourceScopes"
                                            isArray = $True
                                            }
                                        )
                                        QueryRoot = "FakeStringValue"
                                        PrincipalScopes = @(
                                            @{
                                            Name = "PrincipalScopes"
                                            isArray = $True
                                            }
                                        )
                                        '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                        Query = "FakeStringValue"
                                    }
                                )
                                QueryRoot = "FakeStringValue"
                                PrincipalScopes = @(
                                    @{
                                        QueryType = "FakeStringValue"
                                        ResourceScopes = @(
                                            @{
                                            Name = "ResourceScopes"
                                            isArray = $True
                                            }
                                        )
                                        QueryRoot = "FakeStringValue"
                                        PrincipalScopes = @(
                                            @{
                                            Name = "PrincipalScopes"
                                            isArray = $True
                                            }
                                        )
                                        '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                        Query = "FakeStringValue"
                                    }
                                )
                                '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                Query = "FakeStringValue"
                            }
                        )
                        Scope = @{
                            QueryType = "FakeStringValue"
                            ResourceScopes = @(
                                @{
                                    QueryType = "FakeStringValue"
                                    ResourceScopes = @(
                                        @{
                                        Name = "ResourceScopes"
                                        isArray = $True
                                        }
                                    )
                                    QueryRoot = "FakeStringValue"
                                    PrincipalScopes = @(
                                        @{
                                        Name = "PrincipalScopes"
                                        isArray = $True
                                        }
                                    )
                                    '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                    Query = "FakeStringValue"
                                }
                            )
                            QueryRoot = "FakeStringValue"
                            PrincipalScopes = @(
                                @{
                                    QueryType = "FakeStringValue"
                                    ResourceScopes = @(
                                        @{
                                        Name = "ResourceScopes"
                                        isArray = $True
                                        }
                                    )
                                    QueryRoot = "FakeStringValue"
                                    PrincipalScopes = @(
                                        @{
                                        Name = "PrincipalScopes"
                                        isArray = $True
                                        }
                                    )
                                    '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                    Query = "FakeStringValue"
                                }
                            )
                            '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                            Query = "FakeStringValue"
                        }
                        Settings = @{
                            Recurrence = @{
                                Pattern = @{
                                    Index = "first"
                                    FirstDayOfWeek = "sunday"
                                    DayOfMonth = 25
                                    Month = 25
                                    DaysOfWeek = @("sunday")
                                    Type = "daily"
                                    Interval = 25
                                }
                                Range = @{
                                    StartDate = "2023-01-01T00:00:00.0000000"
                                    EndDate = "2023-01-01T00:00:00.0000000"
                                    RecurrenceTimeZone = "FakeStringValue"
                                    NumberOfOccurrences = 25
                                    Type = "endDate"
                                }
                            }
                            InstanceDurationInDays = 25
                            DefaultDecision = "FakeStringValue"
                            RecommendationsEnabled = $True
                            DecisionHistoriesForReviewersEnabled = $True
                            ReminderNotificationsEnabled = $True
                            ApplyActions = @(
                                @{
                                    '@odata.type' = "#microsoft.graph.disableAndDeleteUserApplyAction"
                                }
                            )
                            RecommendationInsightSettings = @(
                                @{
                                    '@odata.type' = "#microsoft.graph.groupPeerOutlierRecommendationInsightSettings"
                                    SignInScope = "tenant"
                                }
                            )
                            DefaultDecisionEnabled = $True
                            MailNotificationsEnabled = $True
                            JustificationRequiredOnApproval = $True
                            AutoApplyDecisionsEnabled = $True
                        }
                        StageSettings = @(
                            @{
                                Reviewers = @(
                                    @{
                                        QueryType = "FakeStringValue"
                                        ResourceScopes = @(
                                            @{
                                            Name = "ResourceScopes"
                                            isArray = $True
                                            }
                                        )
                                        QueryRoot = "FakeStringValue"
                                        PrincipalScopes = @(
                                            @{
                                            Name = "PrincipalScopes"
                                            isArray = $True
                                            }
                                        )
                                        '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                        Query = "FakeStringValue"
                                    }
                                )
                                RecommendationsEnabled = $True
                                DurationInDays = 25
                                DependsOn = @("FakeStringValue")
                                DecisionsThatWillMoveToNextStage = @("FakeStringValue")
                                StageId = "FakeStringValue"
                                FallbackReviewers = @(
                                    @{
                                        QueryType = "FakeStringValue"
                                        ResourceScopes = @(
                                            @{
                                            Name = "ResourceScopes"
                                            isArray = $True
                                            }
                                        )
                                        QueryRoot = "FakeStringValue"
                                        PrincipalScopes = @(
                                            @{
                                            Name = "PrincipalScopes"
                                            isArray = $True
                                            }
                                        )
                                        '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                        Query = "FakeStringValue"
                                    }
                                )
                                RecommendationInsightSettings = @(
                                    @{
                                        '@odata.type' = "#microsoft.graph.groupPeerOutlierRecommendationInsightSettings"
                                        SignInScope = "tenant"
                                    }
                                )
                            }
                        )
                        Status = "FakeStringValue"

                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The AADAccessReviewDefinition exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AdditionalNotificationRecipients = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewNotificationRecipientItem -Property @{
                            NotificationRecipientScope = (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewNotificationRecipientScope -Property @{
                                QueryRoot = "FakeStringValue"
                                QueryType = "FakeStringValue"
                                Query = "FakeStringValue"
                                odataType = "#microsoft.graph.a"
                            } -ClientOnly)
                            NotificationTemplateType = "FakeStringValue"
                        } -ClientOnly)
                    )
                    BackupReviewers = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewReviewerScope -Property @{
                            ResourceScopes = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                    ResourceScopes = [CimInstance[]]@(
                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                        Name = "ResourceScopes"
                                        isArray = $True
                                        CIMType = "MSFT_MicrosoftGraphaccessReviewScope"
                                        } -ClientOnly)
                                    )
                                    QueryRoot = "FakeStringValue"
                                    odataType = "#microsoft.graph.accessReviewQueryScope"
                                    PrincipalScopes = [CimInstance[]]@(
                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                        Name = "PrincipalScopes"
                                        isArray = $True
                                        CIMType = "MSFT_MicrosoftGraphaccessReviewScope"
                                        } -ClientOnly)
                                    )
                                    Query = "FakeStringValue"
                                    QueryType = "FakeStringValue"
                                } -ClientOnly)
                            )
                            QueryRoot = "FakeStringValue"
                            odataType = "#microsoft.graph.accessReviewQueryScope"
                            PrincipalScopes = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                    ResourceScopes = [CimInstance[]]@(
                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                        Name = "ResourceScopes"
                                        isArray = $True
                                        CIMType = "MSFT_MicrosoftGraphaccessReviewScope"
                                        } -ClientOnly)
                                    )
                                    QueryRoot = "FakeStringValue"
                                    odataType = "#microsoft.graph.accessReviewQueryScope"
                                    PrincipalScopes = [CimInstance[]]@(
                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                            ResourceScopes = [CimInstance[]]@(
                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                                    ResourceScopes = [CimInstance[]]@(
                                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                                            ResourceScopes = [CimInstance[]]@(
                                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                                                Name = "ResourceScopes"
                                                                isArray = $True
                                                                CIMType = "MSFT_MicrosoftGraphaccessReviewScope"
                                                                } -ClientOnly)
                                                            )
                                                            QueryRoot = "FakeStringValue"
                                                            odataType = "#microsoft.graph.accessReviewQueryScope"
                                                            PrincipalScopes = [CimInstance[]]@(
                                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                                                Name = "PrincipalScopes"
                                                                isArray = $True
                                                                CIMType = "MSFT_MicrosoftGraphaccessReviewScope"
                                                                } -ClientOnly)
                                                            )
                                                            Query = "FakeStringValue"
                                                            QueryType = "FakeStringValue"
                                                        } -ClientOnly)
                                                    )
                                                    QueryRoot = "FakeStringValue"
                                                    odataType = "#microsoft.graph.accessReviewQueryScope"
                                                    PrincipalScopes = [CimInstance[]]@(
                                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                                            ResourceScopes = [CimInstance[]]@(
                                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                                                Name = "ResourceScopes"
                                                                isArray = $True
                                                                CIMType = "MSFT_MicrosoftGraphaccessReviewScope"
                                                                } -ClientOnly)
                                                            )
                                                            QueryRoot = "FakeStringValue"
                                                            odataType = "#microsoft.graph.accessReviewQueryScope"
                                                            PrincipalScopes = [CimInstance[]]@(
                                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                                                Name = "PrincipalScopes"
                                                                isArray = $True
                                                                CIMType = "MSFT_MicrosoftGraphaccessReviewScope"
                                                                } -ClientOnly)
                                                            )
                                                            Query = "FakeStringValue"
                                                            QueryType = "FakeStringValue"
                                                        } -ClientOnly)
                                                    )
                                                    Query = "FakeStringValue"
                                                    QueryType = "FakeStringValue"
                                                } -ClientOnly)
                                            )
                                            QueryRoot = "FakeStringValue"
                                            odataType = "#microsoft.graph.accessReviewQueryScope"
                                            PrincipalScopes = [CimInstance[]]@(
                                                (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                                Name = "PrincipalScopes"
                                                isArray = $True
                                                CIMType = "MSFT_MicrosoftGraphaccessReviewScope"
                                                } -ClientOnly)
                                            )
                                            Query = "FakeStringValue"
                                            QueryType = "FakeStringValue"
                                        } -ClientOnly)
                                    )
                                    Query = "FakeStringValue"
                                    QueryType = "FakeStringValue"
                                } -ClientOnly)
                            )
                            Query = "FakeStringValue"
                            QueryType = "FakeStringValue"
                        } -ClientOnly)
                    )
                    CreatedBy = (New-CimInstance -ClassName MSFT_MicrosoftGraphuserIdentity -Property @{
                        IpAddress = "FakeStringValue"
                        odataType = "#microsoft.graph.a"
                        UserPrincipalName = "FakeStringValue"
                        HomeTenantId = "FakeStringValue"
                        HomeTenantName = "FakeStringValue"
                    } -ClientOnly)
                    DescriptionForAdmins = "FakeStringValue"
                    DescriptionForReviewers = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    FallbackReviewers = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewReviewerScope -Property @{
                            ResourceScopes = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                    ResourceScopes = [CimInstance[]]@(
                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                        Name = "ResourceScopes"
                                        isArray = $True
                                        CIMType = "MSFT_MicrosoftGraphaccessReviewScope"
                                        } -ClientOnly)
                                    )
                                    QueryRoot = "FakeStringValue"
                                    odataType = "#microsoft.graph.accessReviewQueryScope"
                                    PrincipalScopes = [CimInstance[]]@(
                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                        Name = "PrincipalScopes"
                                        isArray = $True
                                        CIMType = "MSFT_MicrosoftGraphaccessReviewScope"
                                        } -ClientOnly)
                                    )
                                    Query = "FakeStringValue"
                                    QueryType = "FakeStringValue"
                                } -ClientOnly)
                            )
                            QueryRoot = "FakeStringValue"
                            odataType = "#microsoft.graph.accessReviewQueryScope"
                            PrincipalScopes = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                    ResourceScopes = [CimInstance[]]@(
                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                        Name = "ResourceScopes"
                                        isArray = $True
                                        CIMType = "MSFT_MicrosoftGraphaccessReviewScope"
                                        } -ClientOnly)
                                    )
                                    QueryRoot = "FakeStringValue"
                                    odataType = "#microsoft.graph.accessReviewQueryScope"
                                    PrincipalScopes = [CimInstance[]]@(
                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                        Name = "PrincipalScopes"
                                        isArray = $True
                                        CIMType = "MSFT_MicrosoftGraphaccessReviewScope"
                                        } -ClientOnly)
                                    )
                                    Query = "FakeStringValue"
                                    QueryType = "FakeStringValue"
                                } -ClientOnly)
                            )
                            Query = "FakeStringValue"
                            QueryType = "FakeStringValue"
                        } -ClientOnly)
                    )
                    Id = "FakeStringValue"
                    InstanceEnumerationScope = (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                        ResourceScopes = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                ResourceScopes = [CimInstance[]]@(
                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                    Name = "ResourceScopes"
                                    isArray = $True
                                    CIMType = "MSFT_MicrosoftGraphaccessReviewScope"
                                    } -ClientOnly)
                                )
                                QueryRoot = "FakeStringValue"
                                odataType = "#microsoft.graph.accessReviewQueryScope"
                                PrincipalScopes = [CimInstance[]]@(
                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                    Name = "PrincipalScopes"
                                    isArray = $True
                                    CIMType = "MSFT_MicrosoftGraphaccessReviewScope"
                                    } -ClientOnly)
                                )
                                Query = "FakeStringValue"
                                QueryType = "FakeStringValue"
                            } -ClientOnly)
                        )
                        QueryRoot = "FakeStringValue"
                        odataType = "#microsoft.graph.accessReviewQueryScope"
                        PrincipalScopes = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                ResourceScopes = [CimInstance[]]@(
                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                    Name = "ResourceScopes"
                                    isArray = $True
                                    CIMType = "MSFT_MicrosoftGraphaccessReviewScope"
                                    } -ClientOnly)
                                )
                                QueryRoot = "FakeStringValue"
                                odataType = "#microsoft.graph.accessReviewQueryScope"
                                PrincipalScopes = [CimInstance[]]@(
                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                    Name = "PrincipalScopes"
                                    isArray = $True
                                    CIMType = "MSFT_MicrosoftGraphaccessReviewScope"
                                    } -ClientOnly)
                                )
                                Query = "FakeStringValue"
                                QueryType = "FakeStringValue"
                            } -ClientOnly)
                        )
                        Query = "FakeStringValue"
                        QueryType = "FakeStringValue"
                    } -ClientOnly)
                    Reviewers = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewReviewerScope -Property @{
                            ResourceScopes = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                    ResourceScopes = [CimInstance[]]@(
                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                        Name = "ResourceScopes"
                                        isArray = $True
                                        CIMType = "MSFT_MicrosoftGraphaccessReviewScope"
                                        } -ClientOnly)
                                    )
                                    QueryRoot = "FakeStringValue"
                                    odataType = "#microsoft.graph.accessReviewQueryScope"
                                    PrincipalScopes = [CimInstance[]]@(
                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                        Name = "PrincipalScopes"
                                        isArray = $True
                                        CIMType = "MSFT_MicrosoftGraphaccessReviewScope"
                                        } -ClientOnly)
                                    )
                                    Query = "FakeStringValue"
                                    QueryType = "FakeStringValue"
                                } -ClientOnly)
                            )
                            QueryRoot = "FakeStringValue"
                            odataType = "#microsoft.graph.accessReviewQueryScope"
                            PrincipalScopes = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                    ResourceScopes = [CimInstance[]]@(
                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                        Name = "ResourceScopes"
                                        isArray = $True
                                        CIMType = "MSFT_MicrosoftGraphaccessReviewScope"
                                        } -ClientOnly)
                                    )
                                    QueryRoot = "FakeStringValue"
                                    odataType = "#microsoft.graph.accessReviewQueryScope"
                                    PrincipalScopes = [CimInstance[]]@(
                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                        Name = "PrincipalScopes"
                                        isArray = $True
                                        CIMType = "MSFT_MicrosoftGraphaccessReviewScope"
                                        } -ClientOnly)
                                    )
                                    Query = "FakeStringValue"
                                    QueryType = "FakeStringValue"
                                } -ClientOnly)
                            )
                            Query = "FakeStringValue"
                            QueryType = "FakeStringValue"
                        } -ClientOnly)
                    )
                    Scope = (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                        ResourceScopes = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                ResourceScopes = [CimInstance[]]@(
                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                    Name = "ResourceScopes"
                                    isArray = $True
                                    CIMType = "MSFT_MicrosoftGraphaccessReviewScope"
                                    } -ClientOnly)
                                )
                                QueryRoot = "FakeStringValue"
                                odataType = "#microsoft.graph.accessReviewQueryScope"
                                PrincipalScopes = [CimInstance[]]@(
                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                    Name = "PrincipalScopes"
                                    isArray = $True
                                    CIMType = "MSFT_MicrosoftGraphaccessReviewScope"
                                    } -ClientOnly)
                                )
                                Query = "FakeStringValue"
                                QueryType = "FakeStringValue"
                            } -ClientOnly)
                        )
                        QueryRoot = "FakeStringValue"
                        odataType = "#microsoft.graph.accessReviewQueryScope"
                        PrincipalScopes = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                ResourceScopes = [CimInstance[]]@(
                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                    Name = "ResourceScopes"
                                    isArray = $True
                                    CIMType = "MSFT_MicrosoftGraphaccessReviewScope"
                                    } -ClientOnly)
                                )
                                QueryRoot = "FakeStringValue"
                                odataType = "#microsoft.graph.accessReviewQueryScope"
                                PrincipalScopes = [CimInstance[]]@(
                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                    Name = "PrincipalScopes"
                                    isArray = $True
                                    CIMType = "MSFT_MicrosoftGraphaccessReviewScope"
                                    } -ClientOnly)
                                )
                                Query = "FakeStringValue"
                                QueryType = "FakeStringValue"
                            } -ClientOnly)
                        )
                        Query = "FakeStringValue"
                        QueryType = "FakeStringValue"
                    } -ClientOnly)
                    Settings = (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScheduleSettings -Property @{
                        Recurrence = (New-CimInstance -ClassName MSFT_MicrosoftGraphpatternedRecurrence -Property @{
                            Pattern = (New-CimInstance -ClassName MSFT_MicrosoftGraphrecurrencePattern -Property @{
                                Index = "first"
                                FirstDayOfWeek = "sunday"
                                DayOfMonth = 25
                                Month = 25
                                DaysOfWeek = @("sunday")
                                Type = "daily"
                                Interval = 25
                            } -ClientOnly)
                            Range = (New-CimInstance -ClassName MSFT_MicrosoftGraphrecurrenceRange -Property @{
                                StartDate = "2023-01-01T00:00:00.0000000"
                                EndDate = "2023-01-01T00:00:00.0000000"
                                RecurrenceTimeZone = "FakeStringValue"
                                NumberOfOccurrences = 25
                                Type = "endDate"
                            } -ClientOnly)
                        } -ClientOnly)
                        InstanceDurationInDays = 25
                        DefaultDecision = "FakeStringValue"
                        RecommendationsEnabled = $True
                        DecisionHistoriesForReviewersEnabled = $True
                        ReminderNotificationsEnabled = $True
                        ApplyActions = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewApplyAction -Property @{
                                odataType = "#microsoft.graph.disableAndDeleteUserApplyAction"
                            } -ClientOnly)
                        )
                        RecommendationInsightSettings = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewRecommendationInsightSetting -Property @{
                                odataType = "#microsoft.graph.groupPeerOutlierRecommendationInsightSettings"
                                SignInScope = "tenant"
                            } -ClientOnly)
                        )
                        DefaultDecisionEnabled = $True
                        MailNotificationsEnabled = $True
                        JustificationRequiredOnApproval = $True
                        AutoApplyDecisionsEnabled = $True
                    } -ClientOnly)
                    StageSettings = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewStageSettings -Property @{
                            Reviewers = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewReviewerScope -Property @{
                                    ResourceScopes = [CimInstance[]]@(
                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                        Name = "ResourceScopes"
                                        isArray = $True
                                        CIMType = "MSFT_MicrosoftGraphaccessReviewScope"
                                        } -ClientOnly)
                                    )
                                    QueryRoot = "FakeStringValue"
                                    odataType = "#microsoft.graph.accessReviewQueryScope"
                                    PrincipalScopes = [CimInstance[]]@(
                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                        Name = "PrincipalScopes"
                                        isArray = $True
                                        CIMType = "MSFT_MicrosoftGraphaccessReviewScope"
                                        } -ClientOnly)
                                    )
                                    Query = "FakeStringValue"
                                    QueryType = "FakeStringValue"
                                } -ClientOnly)
                            )
                            RecommendationsEnabled = $True
                            DurationInDays = 25
                            DependsOn = @("FakeStringValue")
                            DecisionsThatWillMoveToNextStage = @("FakeStringValue")
                            StageId = "FakeStringValue"
                            FallbackReviewers = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewReviewerScope -Property @{
                                    ResourceScopes = [CimInstance[]]@(
                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                        Name = "ResourceScopes"
                                        isArray = $True
                                        CIMType = "MSFT_MicrosoftGraphaccessReviewScope"
                                        } -ClientOnly)
                                    )
                                    QueryRoot = "FakeStringValue"
                                    odataType = "#microsoft.graph.accessReviewQueryScope"
                                    PrincipalScopes = [CimInstance[]]@(
                                        (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewScope -Property @{
                                        Name = "PrincipalScopes"
                                        isArray = $True
                                        CIMType = "MSFT_MicrosoftGraphaccessReviewScope"
                                        } -ClientOnly)
                                    )
                                    Query = "FakeStringValue"
                                    QueryType = "FakeStringValue"
                                } -ClientOnly)
                            )
                            RecommendationInsightSettings = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessReviewRecommendationInsightSetting -Property @{
                                    odataType = "#microsoft.graph.groupPeerOutlierRecommendationInsightSettings"
                                    SignInScope = "tenant"
                                } -ClientOnly)
                            )
                        } -ClientOnly)
                    )
                    Status = "FakeStringValue"
                    Ensure = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaIdentityGovernanceAccessReviewDefinition -MockWith {
                    return @{
                        AdditionalNotificationRecipients = @(
                            @{
                                NotificationRecipientScope = @{
                                    QueryRoot = "FakeStringValue"
                                    QueryType = "FakeStringValue"
                                    Query = "FakeStringValue"
                                    '@odata.type' = "#microsoft.graph.a"
                                }
                                NotificationTemplateType = "FakeStringValue"
                            }
                        )
                        BackupReviewers = @(
                            @{
                                QueryType = "FakeStringValue"
                                ResourceScopes = @(
                                    @{
                                        QueryType = "FakeStringValue"
                                        ResourceScopes = @(
                                            @{
                                            Name = "ResourceScopes"
                                            isArray = $True
                                            }
                                        )
                                        QueryRoot = "FakeStringValue"
                                        PrincipalScopes = @(
                                            @{
                                            Name = "PrincipalScopes"
                                            isArray = $True
                                            }
                                        )
                                        '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                        Query = "FakeStringValue"
                                    }
                                )
                                QueryRoot = "FakeStringValue"
                                PrincipalScopes = @(
                                    @{
                                        QueryType = "FakeStringValue"
                                        ResourceScopes = @(
                                            @{
                                            Name = "ResourceScopes"
                                            isArray = $True
                                            }
                                        )
                                        QueryRoot = "FakeStringValue"
                                        PrincipalScopes = @(
                                            @{
                                                QueryType = "FakeStringValue"
                                                ResourceScopes = @(
                                                    @{
                                                        QueryType = "FakeStringValue"
                                                        ResourceScopes = @(
                                                            @{
                                                                QueryType = "FakeStringValue"
                                                                ResourceScopes = @(
                                                                    @{
                                                                    Name = "ResourceScopes"
                                                                    isArray = $True
                                                                    }
                                                                )
                                                                QueryRoot = "FakeStringValue"
                                                                PrincipalScopes = @(
                                                                    @{
                                                                    Name = "PrincipalScopes"
                                                                    isArray = $True
                                                                    }
                                                                )
                                                                '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                                                Query = "FakeStringValue"
                                                            }
                                                        )
                                                        QueryRoot = "FakeStringValue"
                                                        PrincipalScopes = @(
                                                            @{
                                                                QueryType = "FakeStringValue"
                                                                ResourceScopes = @(
                                                                    @{
                                                                    Name = "ResourceScopes"
                                                                    isArray = $True
                                                                    }
                                                                )
                                                                QueryRoot = "FakeStringValue"
                                                                PrincipalScopes = @(
                                                                    @{
                                                                    Name = "PrincipalScopes"
                                                                    isArray = $True
                                                                    }
                                                                )
                                                                '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                                                Query = "FakeStringValue"
                                                            }
                                                        )
                                                        '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                                        Query = "FakeStringValue"
                                                    }
                                                )
                                                QueryRoot = "FakeStringValue"
                                                PrincipalScopes = @(
                                                    @{
                                                    Name = "PrincipalScopes"
                                                    isArray = $True
                                                    }
                                                )
                                                '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                                Query = "FakeStringValue"
                                            }
                                        )
                                        '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                        Query = "FakeStringValue"
                                    }
                                )
                                '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                Query = "FakeStringValue"
                            }
                        )
                        CreatedBy = @{
                            IpAddress = "FakeStringValue"
                            '@odata.type' = "#microsoft.graph.a"
                            UserPrincipalName = "FakeStringValue"
                            HomeTenantId = "FakeStringValue"
                            HomeTenantName = "FakeStringValue"
                        }
                        DescriptionForAdmins = "FakeStringValue"
                        DescriptionForReviewers = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        FallbackReviewers = @(
                            @{
                                QueryType = "FakeStringValue"
                                ResourceScopes = @(
                                    @{
                                        QueryType = "FakeStringValue"
                                        ResourceScopes = @(
                                            @{
                                            Name = "ResourceScopes"
                                            isArray = $True
                                            }
                                        )
                                        QueryRoot = "FakeStringValue"
                                        PrincipalScopes = @(
                                            @{
                                            Name = "PrincipalScopes"
                                            isArray = $True
                                            }
                                        )
                                        '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                        Query = "FakeStringValue"
                                    }
                                )
                                QueryRoot = "FakeStringValue"
                                PrincipalScopes = @(
                                    @{
                                        QueryType = "FakeStringValue"
                                        ResourceScopes = @(
                                            @{
                                            Name = "ResourceScopes"
                                            isArray = $True
                                            }
                                        )
                                        QueryRoot = "FakeStringValue"
                                        PrincipalScopes = @(
                                            @{
                                            Name = "PrincipalScopes"
                                            isArray = $True
                                            }
                                        )
                                        '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                        Query = "FakeStringValue"
                                    }
                                )
                                '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                Query = "FakeStringValue"
                            }
                        )
                        Id = "FakeStringValue"
                        InstanceEnumerationScope = @{
                            QueryType = "FakeStringValue"
                            ResourceScopes = @(
                                @{
                                    QueryType = "FakeStringValue"
                                    ResourceScopes = @(
                                        @{
                                        Name = "ResourceScopes"
                                        isArray = $True
                                        }
                                    )
                                    QueryRoot = "FakeStringValue"
                                    PrincipalScopes = @(
                                        @{
                                        Name = "PrincipalScopes"
                                        isArray = $True
                                        }
                                    )
                                    '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                    Query = "FakeStringValue"
                                }
                            )
                            QueryRoot = "FakeStringValue"
                            PrincipalScopes = @(
                                @{
                                    QueryType = "FakeStringValue"
                                    ResourceScopes = @(
                                        @{
                                        Name = "ResourceScopes"
                                        isArray = $True
                                        }
                                    )
                                    QueryRoot = "FakeStringValue"
                                    PrincipalScopes = @(
                                        @{
                                        Name = "PrincipalScopes"
                                        isArray = $True
                                        }
                                    )
                                    '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                    Query = "FakeStringValue"
                                }
                            )
                            '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                            Query = "FakeStringValue"
                        }
                        Reviewers = @(
                            @{
                                QueryType = "FakeStringValue"
                                ResourceScopes = @(
                                    @{
                                        QueryType = "FakeStringValue"
                                        ResourceScopes = @(
                                            @{
                                            Name = "ResourceScopes"
                                            isArray = $True
                                            }
                                        )
                                        QueryRoot = "FakeStringValue"
                                        PrincipalScopes = @(
                                            @{
                                            Name = "PrincipalScopes"
                                            isArray = $True
                                            }
                                        )
                                        '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                        Query = "FakeStringValue"
                                    }
                                )
                                QueryRoot = "FakeStringValue"
                                PrincipalScopes = @(
                                    @{
                                        QueryType = "FakeStringValue"
                                        ResourceScopes = @(
                                            @{
                                            Name = "ResourceScopes"
                                            isArray = $True
                                            }
                                        )
                                        QueryRoot = "FakeStringValue"
                                        PrincipalScopes = @(
                                            @{
                                            Name = "PrincipalScopes"
                                            isArray = $True
                                            }
                                        )
                                        '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                        Query = "FakeStringValue"
                                    }
                                )
                                '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                Query = "FakeStringValue"
                            }
                        )
                        Scope = @{
                            QueryType = "FakeStringValue"
                            ResourceScopes = @(
                                @{
                                    QueryType = "FakeStringValue"
                                    ResourceScopes = @(
                                        @{
                                        Name = "ResourceScopes"
                                        isArray = $True
                                        }
                                    )
                                    QueryRoot = "FakeStringValue"
                                    PrincipalScopes = @(
                                        @{
                                        Name = "PrincipalScopes"
                                        isArray = $True
                                        }
                                    )
                                    '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                    Query = "FakeStringValue"
                                }
                            )
                            QueryRoot = "FakeStringValue"
                            PrincipalScopes = @(
                                @{
                                    QueryType = "FakeStringValue"
                                    ResourceScopes = @(
                                        @{
                                        Name = "ResourceScopes"
                                        isArray = $True
                                        }
                                    )
                                    QueryRoot = "FakeStringValue"
                                    PrincipalScopes = @(
                                        @{
                                        Name = "PrincipalScopes"
                                        isArray = $True
                                        }
                                    )
                                    '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                    Query = "FakeStringValue"
                                }
                            )
                            '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                            Query = "FakeStringValue"
                        }
                        Settings = @{
                            ApplyActions = @(
                                @{
                                    '@odata.type' = "#microsoft.graph.disableAndDeleteUserApplyAction"
                                }
                            )
                            Recurrence = @{
                                Pattern = @{
                                    Index = "first"
                                    FirstDayOfWeek = "sunday"
                                    DayOfMonth = 7
                                    Month = 7
                                    DaysOfWeek = @("sunday")
                                    Type = "daily"
                                    Interval = 7
                                }
                                Range = @{
                                    StartDate = "2023-01-01T00:00:00.0000000"
                                    EndDate = "2023-01-01T00:00:00.0000000"
                                    RecurrenceTimeZone = "FakeStringValue"
                                    NumberOfOccurrences = 7
                                    Type = "endDate"
                                }
                            }
                            RecommendationInsightSettings = @(
                                @{
                                    '@odata.type' = "#microsoft.graph.groupPeerOutlierRecommendationInsightSettings"
                                    SignInScope = "tenant"
                                }
                            )
                            DefaultDecision = "FakeStringValue"
                            InstanceDurationInDays = 7
                        }
                        StageSettings = @(
                            @{
                                Reviewers = @(
                                    @{
                                        QueryType = "FakeStringValue"
                                        ResourceScopes = @(
                                            @{
                                            Name = "ResourceScopes"
                                            isArray = $True
                                            }
                                        )
                                        QueryRoot = "FakeStringValue"
                                        PrincipalScopes = @(
                                            @{
                                            Name = "PrincipalScopes"
                                            isArray = $True
                                            }
                                        )
                                        '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                        Query = "FakeStringValue"
                                    }
                                )
                                DependsOn = @("FakeStringValue")
                                DurationInDays = 7
                                FallbackReviewers = @(
                                    @{
                                        QueryType = "FakeStringValue"
                                        ResourceScopes = @(
                                            @{
                                            Name = "ResourceScopes"
                                            isArray = $True
                                            }
                                        )
                                        QueryRoot = "FakeStringValue"
                                        PrincipalScopes = @(
                                            @{
                                            Name = "PrincipalScopes"
                                            isArray = $True
                                            }
                                        )
                                        '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                        Query = "FakeStringValue"
                                    }
                                )
                                StageId = "FakeStringValue"
                                DecisionsThatWillMoveToNextStage = @("FakeStringValue")
                                RecommendationInsightSettings = @(
                                    @{
                                        '@odata.type' = "#microsoft.graph.groupPeerOutlierRecommendationInsightSettings"
                                        SignInScope = "tenant"
                                    }
                                )
                            }
                        )
                        Status = "FakeStringValue"
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
                Should -Invoke -CommandName Set-MgBetaIdentityGovernanceAccessReviewDefinition -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaIdentityGovernanceAccessReviewDefinition -MockWith {
                    return @{
                        AdditionalNotificationRecipients = @(
                            @{
                                NotificationRecipientScope = @{
                                    QueryRoot = "FakeStringValue"
                                    QueryType = "FakeStringValue"
                                    Query = "FakeStringValue"
                                    '@odata.type' = "#microsoft.graph.a"
                                }
                                NotificationTemplateType = "FakeStringValue"
                            }
                        )
                        AdditionalProperties = @{
                            '@odata.type' = "#microsoft.graph.AccessReviewScheduleDefinition"
                        }
                        BackupReviewers = @(
                            @{
                                QueryType = "FakeStringValue"
                                ResourceScopes = @(
                                    @{
                                        QueryType = "FakeStringValue"
                                        ResourceScopes = @(
                                            @{
                                            Name = "ResourceScopes"
                                            isArray = $True
                                            }
                                        )
                                        QueryRoot = "FakeStringValue"
                                        PrincipalScopes = @(
                                            @{
                                            Name = "PrincipalScopes"
                                            isArray = $True
                                            }
                                        )
                                        '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                        Query = "FakeStringValue"
                                    }
                                )
                                QueryRoot = "FakeStringValue"
                                PrincipalScopes = @(
                                    @{
                                        QueryType = "FakeStringValue"
                                        ResourceScopes = @(
                                            @{
                                            Name = "ResourceScopes"
                                            isArray = $True
                                            }
                                        )
                                        QueryRoot = "FakeStringValue"
                                        PrincipalScopes = @(
                                            @{
                                                QueryType = "FakeStringValue"
                                                ResourceScopes = @(
                                                    @{
                                                        QueryType = "FakeStringValue"
                                                        ResourceScopes = @(
                                                            @{
                                                                QueryType = "FakeStringValue"
                                                                ResourceScopes = @(
                                                                    @{
                                                                    Name = "ResourceScopes"
                                                                    isArray = $True
                                                                    }
                                                                )
                                                                QueryRoot = "FakeStringValue"
                                                                PrincipalScopes = @(
                                                                    @{
                                                                    Name = "PrincipalScopes"
                                                                    isArray = $True
                                                                    }
                                                                )
                                                                '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                                                Query = "FakeStringValue"
                                                            }
                                                        )
                                                        QueryRoot = "FakeStringValue"
                                                        PrincipalScopes = @(
                                                            @{
                                                                QueryType = "FakeStringValue"
                                                                ResourceScopes = @(
                                                                    @{
                                                                    Name = "ResourceScopes"
                                                                    isArray = $True
                                                                    }
                                                                )
                                                                QueryRoot = "FakeStringValue"
                                                                PrincipalScopes = @(
                                                                    @{
                                                                    Name = "PrincipalScopes"
                                                                    isArray = $True
                                                                    }
                                                                )
                                                                '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                                                Query = "FakeStringValue"
                                                            }
                                                        )
                                                        '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                                        Query = "FakeStringValue"
                                                    }
                                                )
                                                QueryRoot = "FakeStringValue"
                                                PrincipalScopes = @(
                                                    @{
                                                    Name = "PrincipalScopes"
                                                    isArray = $True
                                                    }
                                                )
                                                '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                                Query = "FakeStringValue"
                                            }
                                        )
                                        '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                        Query = "FakeStringValue"
                                    }
                                )
                                '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                Query = "FakeStringValue"
                            }
                        )
                        CreatedBy = @{
                            IpAddress = "FakeStringValue"
                            '@odata.type' = "#microsoft.graph.a"
                            UserPrincipalName = "FakeStringValue"
                            HomeTenantId = "FakeStringValue"
                            HomeTenantName = "FakeStringValue"
                        }
                        DescriptionForAdmins = "FakeStringValue"
                        DescriptionForReviewers = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        FallbackReviewers = @(
                            @{
                                QueryType = "FakeStringValue"
                                ResourceScopes = @(
                                    @{
                                        QueryType = "FakeStringValue"
                                        ResourceScopes = @(
                                            @{
                                            Name = "ResourceScopes"
                                            isArray = $True
                                            }
                                        )
                                        QueryRoot = "FakeStringValue"
                                        PrincipalScopes = @(
                                            @{
                                            Name = "PrincipalScopes"
                                            isArray = $True
                                            }
                                        )
                                        '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                        Query = "FakeStringValue"
                                    }
                                )
                                QueryRoot = "FakeStringValue"
                                PrincipalScopes = @(
                                    @{
                                        QueryType = "FakeStringValue"
                                        ResourceScopes = @(
                                            @{
                                            Name = "ResourceScopes"
                                            isArray = $True
                                            }
                                        )
                                        QueryRoot = "FakeStringValue"
                                        PrincipalScopes = @(
                                            @{
                                            Name = "PrincipalScopes"
                                            isArray = $True
                                            }
                                        )
                                        '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                        Query = "FakeStringValue"
                                    }
                                )
                                '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                Query = "FakeStringValue"
                            }
                        )
                        Id = "FakeStringValue"
                        InstanceEnumerationScope = @{
                            QueryType = "FakeStringValue"
                            ResourceScopes = @(
                                @{
                                    QueryType = "FakeStringValue"
                                    ResourceScopes = @(
                                        @{
                                        Name = "ResourceScopes"
                                        isArray = $True
                                        }
                                    )
                                    QueryRoot = "FakeStringValue"
                                    PrincipalScopes = @(
                                        @{
                                        Name = "PrincipalScopes"
                                        isArray = $True
                                        }
                                    )
                                    '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                    Query = "FakeStringValue"
                                }
                            )
                            QueryRoot = "FakeStringValue"
                            PrincipalScopes = @(
                                @{
                                    QueryType = "FakeStringValue"
                                    ResourceScopes = @(
                                        @{
                                        Name = "ResourceScopes"
                                        isArray = $True
                                        }
                                    )
                                    QueryRoot = "FakeStringValue"
                                    PrincipalScopes = @(
                                        @{
                                        Name = "PrincipalScopes"
                                        isArray = $True
                                        }
                                    )
                                    '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                    Query = "FakeStringValue"
                                }
                            )
                            '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                            Query = "FakeStringValue"
                        }
                        Reviewers = @(
                            @{
                                QueryType = "FakeStringValue"
                                ResourceScopes = @(
                                    @{
                                        QueryType = "FakeStringValue"
                                        ResourceScopes = @(
                                            @{
                                            Name = "ResourceScopes"
                                            isArray = $True
                                            }
                                        )
                                        QueryRoot = "FakeStringValue"
                                        PrincipalScopes = @(
                                            @{
                                            Name = "PrincipalScopes"
                                            isArray = $True
                                            }
                                        )
                                        '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                        Query = "FakeStringValue"
                                    }
                                )
                                QueryRoot = "FakeStringValue"
                                PrincipalScopes = @(
                                    @{
                                        QueryType = "FakeStringValue"
                                        ResourceScopes = @(
                                            @{
                                            Name = "ResourceScopes"
                                            isArray = $True
                                            }
                                        )
                                        QueryRoot = "FakeStringValue"
                                        PrincipalScopes = @(
                                            @{
                                            Name = "PrincipalScopes"
                                            isArray = $True
                                            }
                                        )
                                        '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                        Query = "FakeStringValue"
                                    }
                                )
                                '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                Query = "FakeStringValue"
                            }
                        )
                        Scope = @{
                            QueryType = "FakeStringValue"
                            ResourceScopes = @(
                                @{
                                    QueryType = "FakeStringValue"
                                    ResourceScopes = @(
                                        @{
                                        Name = "ResourceScopes"
                                        isArray = $True
                                        }
                                    )
                                    QueryRoot = "FakeStringValue"
                                    PrincipalScopes = @(
                                        @{
                                        Name = "PrincipalScopes"
                                        isArray = $True
                                        }
                                    )
                                    '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                    Query = "FakeStringValue"
                                }
                            )
                            QueryRoot = "FakeStringValue"
                            PrincipalScopes = @(
                                @{
                                    QueryType = "FakeStringValue"
                                    ResourceScopes = @(
                                        @{
                                        Name = "ResourceScopes"
                                        isArray = $True
                                        }
                                    )
                                    QueryRoot = "FakeStringValue"
                                    PrincipalScopes = @(
                                        @{
                                        Name = "PrincipalScopes"
                                        isArray = $True
                                        }
                                    )
                                    '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                    Query = "FakeStringValue"
                                }
                            )
                            '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                            Query = "FakeStringValue"
                        }
                        Settings = @{
                            Recurrence = @{
                                Pattern = @{
                                    Index = "first"
                                    FirstDayOfWeek = "sunday"
                                    DayOfMonth = 25
                                    Month = 25
                                    DaysOfWeek = @("sunday")
                                    Type = "daily"
                                    Interval = 25
                                }
                                Range = @{
                                    StartDate = "2023-01-01T00:00:00.0000000"
                                    EndDate = "2023-01-01T00:00:00.0000000"
                                    RecurrenceTimeZone = "FakeStringValue"
                                    NumberOfOccurrences = 25
                                    Type = "endDate"
                                }
                            }
                            InstanceDurationInDays = 25
                            DefaultDecision = "FakeStringValue"
                            RecommendationsEnabled = $True
                            DecisionHistoriesForReviewersEnabled = $True
                            ReminderNotificationsEnabled = $True
                            ApplyActions = @(
                                @{
                                    '@odata.type' = "#microsoft.graph.disableAndDeleteUserApplyAction"
                                }
                            )
                            RecommendationInsightSettings = @(
                                @{
                                    '@odata.type' = "#microsoft.graph.groupPeerOutlierRecommendationInsightSettings"
                                    SignInScope = "tenant"
                                }
                            )
                            DefaultDecisionEnabled = $True
                            MailNotificationsEnabled = $True
                            JustificationRequiredOnApproval = $True
                            AutoApplyDecisionsEnabled = $True
                        }
                        StageSettings = @(
                            @{
                                Reviewers = @(
                                    @{
                                        QueryType = "FakeStringValue"
                                        ResourceScopes = @(
                                            @{
                                            Name = "ResourceScopes"
                                            isArray = $True
                                            }
                                        )
                                        QueryRoot = "FakeStringValue"
                                        PrincipalScopes = @(
                                            @{
                                            Name = "PrincipalScopes"
                                            isArray = $True
                                            }
                                        )
                                        '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                        Query = "FakeStringValue"
                                    }
                                )
                                RecommendationsEnabled = $True
                                DurationInDays = 25
                                DependsOn = @("FakeStringValue")
                                DecisionsThatWillMoveToNextStage = @("FakeStringValue")
                                StageId = "FakeStringValue"
                                FallbackReviewers = @(
                                    @{
                                        QueryType = "FakeStringValue"
                                        ResourceScopes = @(
                                            @{
                                            Name = "ResourceScopes"
                                            isArray = $True
                                            }
                                        )
                                        QueryRoot = "FakeStringValue"
                                        PrincipalScopes = @(
                                            @{
                                            Name = "PrincipalScopes"
                                            isArray = $True
                                            }
                                        )
                                        '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                        Query = "FakeStringValue"
                                    }
                                )
                                RecommendationInsightSettings = @(
                                    @{
                                        '@odata.type' = "#microsoft.graph.groupPeerOutlierRecommendationInsightSettings"
                                        SignInScope = "tenant"
                                    }
                                )
                            }
                        )
                        Status = "FakeStringValue"

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
