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
    -DscResource 'AADPIMGroupSetting' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {
            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            $Global:PartialExportFileName = 'c:\TestPath'

            Mock -CommandName Save-M365DSCPartialExport -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Get-MgPolicyRoleManagementPolicyAssignment -MockWith {
                return @{
                    PolicyId = 'Group_1e1b61e9-1bad-4b5f-aca3-973feb8d36e0_2d3a49e9-4a0b-4456-b381-3311753988a8'
                    RoleDefinitionId = 'member'
                }
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }
            $policyJson = @'
                {
                    "Id":  "Group_1e1b61e9-1bad-4b5f-aca3-973feb8d36e0_2d3a49e9-4a0b-4456-b381-3311753988a8_member",
                    "Policy":  {
                        "Description":  "Group",
                        "DisplayName":  "Group",
                        "EffectiveRules":  null,
                        "Id":  "Group_1e1b61e9-1bad-4b5f-aca3-973feb8d36e0_2d3a49e9-4a0b-4456-b381-3311753988a8",
                        "IsOrganizationDefault":  false,
                        "LastModifiedBy":  {
                                                "DisplayName":  null,
                                                "Id":  null
                                            },
                        "LastModifiedDateTime":  null,
                        "Rules":  [
                            {
                                "Id":  "Enablement_Admin_Eligibility",
                                "Target":  {
                                            "Caller":  "Admin",
                                            "EnforcedSettings":  [

                                                                    ],
                                            "InheritableSettings":  [

                                                                    ],
                                            "Level":  "Eligibility",
                                            "Operations":  [
                                                                "all"
                                                            ],
                                            "TargetObjects":  null
                                        },
                                "AdditionalProperties":  {
                                                            "@odata.type":  "#microsoft.graph.unifiedRoleManagementPolicyEnablementRule",
                                                            "enabledRules":  [

                                                                            ]
                                                        }
                            },
                            {
                                "Id":  "Expiration_Admin_Eligibility",
                                "Target":  {
                                            "Caller":  "Admin",
                                            "EnforcedSettings":  [

                                                                    ],
                                            "InheritableSettings":  [

                                                                    ],
                                            "Level":  "Eligibility",
                                            "Operations":  [
                                                                "all"
                                                            ],
                                            "TargetObjects":  null
                                        },
                                "AdditionalProperties":  {
                                                            "@odata.type":  "#microsoft.graph.unifiedRoleManagementPolicyExpirationRule",
                                                            "isExpirationRequired":  false,
                                                            "maximumDuration":  "P365D"
                                                        }
                            },
                            {
                                "Id":  "Notification_Approver_Admin_Eligibility",
                                "Target":  {
                                            "Caller":  "Admin",
                                            "EnforcedSettings":  [

                                                                    ],
                                            "InheritableSettings":  [

                                                                    ],
                                            "Level":  "Eligibility",
                                            "Operations":  [
                                                                "all"
                                                            ],
                                            "TargetObjects":  null
                                        },
                                "AdditionalProperties":  {
                                                            "@odata.type":  "#microsoft.graph.unifiedRoleManagementPolicyNotificationRule",
                                                            "notificationType":  "Email",
                                                            "recipientType":  "Approver",
                                                            "notificationLevel":  "All",
                                                            "isDefaultRecipientsEnabled":  true,
                                                            "notificationRecipients":  [

                                                                                        ]
                                                        }
                            },
                            {
                                "Id":  "Notification_Admin_Admin_Eligibility",
                                "Target":  {
                                            "Caller":  "Admin",
                                            "EnforcedSettings":  [

                                                                    ],
                                            "InheritableSettings":  [

                                                                    ],
                                            "Level":  "Eligibility",
                                            "Operations":  [
                                                                "all"
                                                            ],
                                            "TargetObjects":  null
                                        },
                                "AdditionalProperties":  {
                                                            "@odata.type":  "#microsoft.graph.unifiedRoleManagementPolicyNotificationRule",
                                                            "notificationType":  "Email",
                                                            "recipientType":  "Admin",
                                                            "notificationLevel":  "All",
                                                            "isDefaultRecipientsEnabled":  true,
                                                            "notificationRecipients":  [

                                                                                        ]
                                                        }
                            },
                            {
                                "Id":  "Notification_Requestor_Admin_Eligibility",
                                "Target":  {
                                            "Caller":  "Admin",
                                            "EnforcedSettings":  [

                                                                    ],
                                            "InheritableSettings":  [

                                                                    ],
                                            "Level":  "Eligibility",
                                            "Operations":  [
                                                                "all"
                                                            ],
                                            "TargetObjects":  null
                                        },
                                "AdditionalProperties":  {
                                                            "@odata.type":  "#microsoft.graph.unifiedRoleManagementPolicyNotificationRule",
                                                            "notificationType":  "Email",
                                                            "recipientType":  "Requestor",
                                                            "notificationLevel":  "All",
                                                            "isDefaultRecipientsEnabled":  true,
                                                            "notificationRecipients":  [

                                                                                        ]
                                                        }
                            },
                            {
                                "Id":  "Enablement_Admin_Assignment",
                                "Target":  {
                                            "Caller":  "Admin",
                                            "EnforcedSettings":  [

                                                                    ],
                                            "InheritableSettings":  [

                                                                    ],
                                            "Level":  "Assignment",
                                            "Operations":  [
                                                                "all"
                                                            ],
                                            "TargetObjects":  null
                                        },
                                "AdditionalProperties":  {
                                                            "@odata.type":  "#microsoft.graph.unifiedRoleManagementPolicyEnablementRule",
                                                            "enabledRules":  [
                                                                                "Justification"
                                                                            ]
                                                        }
                            },
                            {
                                "Id":  "Expiration_Admin_Assignment",
                                "Target":  {
                                            "Caller":  "Admin",
                                            "EnforcedSettings":  [

                                                                    ],
                                            "InheritableSettings":  [

                                                                    ],
                                            "Level":  "Assignment",
                                            "Operations":  [
                                                                "all"
                                                            ],
                                            "TargetObjects":  null
                                        },
                                "AdditionalProperties":  {
                                                            "@odata.type":  "#microsoft.graph.unifiedRoleManagementPolicyExpirationRule",
                                                            "isExpirationRequired":  false,
                                                            "maximumDuration":  "P180D"
                                                        }
                            },
                            {
                                "Id":  "Notification_Admin_Admin_Assignment",
                                "Target":  {
                                            "Caller":  "Admin",
                                            "EnforcedSettings":  [

                                                                    ],
                                            "InheritableSettings":  [

                                                                    ],
                                            "Level":  "Assignment",
                                            "Operations":  [
                                                                "all"
                                                            ],
                                            "TargetObjects":  null
                                        },
                                "AdditionalProperties":  {
                                                            "@odata.type":  "#microsoft.graph.unifiedRoleManagementPolicyNotificationRule",
                                                            "notificationType":  "Email",
                                                            "recipientType":  "Admin",
                                                            "notificationLevel":  "All",
                                                            "isDefaultRecipientsEnabled":  true,
                                                            "notificationRecipients":  [

                                                                                        ]
                                                        }
                            },
                            {
                                "Id":  "Notification_Approver_Admin_Assignment",
                                "Target":  {
                                            "Caller":  "Admin",
                                            "EnforcedSettings":  [

                                                                    ],
                                            "InheritableSettings":  [

                                                                    ],
                                            "Level":  "Assignment",
                                            "Operations":  [
                                                                "all"
                                                            ],
                                            "TargetObjects":  null
                                        },
                                "AdditionalProperties":  {
                                                            "@odata.type":  "#microsoft.graph.unifiedRoleManagementPolicyNotificationRule",
                                                            "notificationType":  "Email",
                                                            "recipientType":  "Approver",
                                                            "notificationLevel":  "All",
                                                            "isDefaultRecipientsEnabled":  true,
                                                            "notificationRecipients":  [

                                                                                        ]
                                                        }
                            },
                            {
                                "Id":  "Notification_Requestor_Admin_Assignment",
                                "Target":  {
                                            "Caller":  "Admin",
                                            "EnforcedSettings":  [

                                                                    ],
                                            "InheritableSettings":  [

                                                                    ],
                                            "Level":  "Assignment",
                                            "Operations":  [
                                                                "all"
                                                            ],
                                            "TargetObjects":  null
                                        },
                                "AdditionalProperties":  {
                                                            "@odata.type":  "#microsoft.graph.unifiedRoleManagementPolicyNotificationRule",
                                                            "notificationType":  "Email",
                                                            "recipientType":  "Requestor",
                                                            "notificationLevel":  "All",
                                                            "isDefaultRecipientsEnabled":  true,
                                                            "notificationRecipients":  [

                                                                                        ]
                                                        }
                            },
                            {
                                "Id":  "Approval_EndUser_Assignment",
                                "Target":  {
                                            "Caller":  "EndUser",
                                            "EnforcedSettings":  [

                                                                    ],
                                            "InheritableSettings":  [

                                                                    ],
                                            "Level":  "Assignment",
                                            "Operations":  [
                                                                "all"
                                                            ],
                                            "TargetObjects":  null
                                        },
                                "AdditionalProperties":  {
                                                            "@odata.type":  "#microsoft.graph.unifiedRoleManagementPolicyApprovalRule",
                                                            "setting":  {
                                                                            "isApprovalRequired":  false,
                                                                            "isApprovalRequiredForExtension":  false,
                                                                            "isRequestorJustificationRequired":  true,
                                                                            "approvalMode":  "SingleStage",
                                                                            "approvalStages":  [
                                                                                                    {
                                                                                                        "approvalStageTimeOutInDays":  1,
                                                                                                        "isApproverJustificationRequired":  true,
                                                                                                        "escalationTimeInMinutes":  0,
                                                                                                        "isEscalationEnabled":  false,
                                                                                                        "primaryApprovers":  [

                                                                                                                            ],
                                                                                                        "escalationApprovers":  [

                                                                                                                                ]
                                                                                                    }
                                                                                                ]
                                                                        }
                                                        }
                            },
                            {
                                "Id":  "AuthenticationContext_EndUser_Assignment",
                                "Target":  {
                                            "Caller":  "EndUser",
                                            "EnforcedSettings":  [

                                                                    ],
                                            "InheritableSettings":  [

                                                                    ],
                                            "Level":  "Assignment",
                                            "Operations":  [
                                                                "all"
                                                            ],
                                            "TargetObjects":  null
                                        },
                                "AdditionalProperties":  {
                                                            "@odata.type":  "#microsoft.graph.unifiedRoleManagementPolicyAuthenticationContextRule",
                                                            "isEnabled":  false,
                                                            "claimValue":  ""
                                                        }
                            },
                            {
                                "Id":  "Enablement_EndUser_Assignment",
                                "Target":  {
                                            "Caller":  "EndUser",
                                            "EnforcedSettings":  [

                                                                    ],
                                            "InheritableSettings":  [

                                                                    ],
                                            "Level":  "Assignment",
                                            "Operations":  [
                                                                "all"
                                                            ],
                                            "TargetObjects":  null
                                        },
                                "AdditionalProperties":  {
                                                            "@odata.type":  "#microsoft.graph.unifiedRoleManagementPolicyEnablementRule",
                                                            "enabledRules":  [
                                                                                "MultiFactorAuthentication",
                                                                                "Justification"
                                                                            ]
                                                        }
                            },
                            {
                                "Id":  "Expiration_EndUser_Assignment",
                                "Target":  {
                                            "Caller":  "EndUser",
                                            "EnforcedSettings":  [

                                                                    ],
                                            "InheritableSettings":  [

                                                                    ],
                                            "Level":  "Assignment",
                                            "Operations":  [
                                                                "all"
                                                            ],
                                            "TargetObjects":  null
                                        },
                                "AdditionalProperties":  {
                                                            "@odata.type":  "#microsoft.graph.unifiedRoleManagementPolicyExpirationRule",
                                                            "isExpirationRequired":  false,
                                                            "maximumDuration":  "PT8H"
                                                        }
                            },
                            {
                                "Id":  "Notification_Approver_EndUser_Assignment",
                                "Target":  {
                                            "Caller":  "EndUser",
                                            "EnforcedSettings":  [

                                                                    ],
                                            "InheritableSettings":  [

                                                                    ],
                                            "Level":  "Assignment",
                                            "Operations":  [
                                                                "all"
                                                            ],
                                            "TargetObjects":  null
                                        },
                                "AdditionalProperties":  {
                                                            "@odata.type":  "#microsoft.graph.unifiedRoleManagementPolicyNotificationRule",
                                                            "notificationType":  "Email",
                                                            "recipientType":  "Approver",
                                                            "notificationLevel":  "All",
                                                            "isDefaultRecipientsEnabled":  true,
                                                            "notificationRecipients":  [

                                                                                        ]
                                                        }
                            },
                            {
                                "Id":  "Notification_Admin_EndUser_Assignment",
                                "Target":  {
                                            "Caller":  "EndUser",
                                            "EnforcedSettings":  [

                                                                    ],
                                            "InheritableSettings":  [

                                                                    ],
                                            "Level":  "Assignment",
                                            "Operations":  [
                                                                "all"
                                                            ],
                                            "TargetObjects":  null
                                        },
                                "AdditionalProperties":  {
                                                            "@odata.type":  "#microsoft.graph.unifiedRoleManagementPolicyNotificationRule",
                                                            "notificationType":  "Email",
                                                            "recipientType":  "Admin",
                                                            "notificationLevel":  "All",
                                                            "isDefaultRecipientsEnabled":  true,
                                                            "notificationRecipients":  [

                                                                                        ]
                                                        }
                            },
                            {
                                "Id":  "Notification_Requestor_EndUser_Assignment",
                                "Target":  {
                                            "Caller":  "EndUser",
                                            "EnforcedSettings":  [

                                                                    ],
                                            "InheritableSettings":  [

                                                                    ],
                                            "Level":  "Assignment",
                                            "Operations":  [
                                                                "all"
                                                            ],
                                            "TargetObjects":  null
                                        },
                                "AdditionalProperties":  {
                                                            "@odata.type":  "#microsoft.graph.unifiedRoleManagementPolicyNotificationRule",
                                                            "notificationType":  "Email",
                                                            "recipientType":  "Requestor",
                                                            "notificationLevel":  "All",
                                                            "isDefaultRecipientsEnabled":  true,
                                                            "notificationRecipients":  [

                                                                                        ]
                                                        }
                            }
                        ],
                        "ScopeId":  "7cf1e453-3f07-440a-9b80-856c190de62c",
                        "ScopeType":  "Group"
                    },
                    "PolicyId":  "Group_1e1b61e9-1bad-4b5f-aca3-973feb8d36e0_2d3a49e9-4a0b-4456-b381-3311753988a8",
                    "RoleDefinitionId":  "member",
                    "ScopeId":  "7cf1e453-3f07-440a-9b80-856c190de62c",
                    "ScopeType":  "Group",
                    "AdditionalProperties": {
                                                "@odata.context":  "https://graph.microsoft.us/v1.0/$metadata#policies/roleManagementPolicyAssignments(policy(rules()))/$entity"
                                            }
                }
'@
            $mockPolicy = $policyJson | ConvertFrom-Json
            Mock -CommandName Get-MgPolicyRoleManagementPolicyAssignment -MockWith {
                return $mockPolicy
            }

            # Mock Write-M365DSCHost to hide output during the tests
            Mock -CommandName Write-M365DSCHost -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts

        Context -Name 'The role definition exists and values are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    ActivateApprover                                          = @()
                    ActivationMaxDuration                                     = 'PT8H'
                    ActivationReqJustification                                = $True
                    ActivationReqMFA                                          = $True
                    ActivationReqTicket                                       = $False
                    ActiveAlertNotificationAdditionalRecipient                = @()
                    ActiveAlertNotificationDefaultRecipient                   = $True
                    ActiveAlertNotificationOnlyCritical                       = $False
                    ActiveApproveNotificationAdditionalRecipient              = @()
                    ActiveApproveNotificationDefaultRecipient                 = $True
                    ActiveApproveNotificationOnlyCritical                     = $False
                    ActiveAssigneeNotificationAdditionalRecipient             = @()
                    ActiveAssigneeNotificationDefaultRecipient                = $True
                    ActiveAssigneeNotificationOnlyCritical                    = $False
                    ApplicationId                                             = $ConfigurationData.NonNodeData.ApplicationId
                    ApprovaltoActivate                                        = $False
                    AssignmentReqJustification                                = $True
                    AssignmentReqMFA                                          = $False
                    CertificateThumbprint                                     = $ConfigurationData.NonNodeData.CertificateThumbprint
                    Displayname                                               = 'FakeGroup'
                    ElegibilityAssignmentReqJustification                     = $False
                    ElegibilityAssignmentReqMFA                               = $False
                    EligibleAlertNotificationAdditionalRecipient              = @()
                    EligibleAlertNotificationDefaultRecipient                 = $True
                    EligibleAlertNotificationOnlyCritical                     = $False
                    EligibleApproveNotificationAdditionalRecipient            = @()
                    EligibleApproveNotificationDefaultRecipient               = $True
                    EligibleApproveNotificationOnlyCritical                   = $False
                    EligibleAssigneeNotificationAdditionalRecipient           = @()
                    EligibleAssigneeNotificationDefaultRecipient              = $True
                    EligibleAssigneeNotificationOnlyCritical                  = $False
                    EligibleAssignmentAlertNotificationAdditionalRecipient    = @()
                    EligibleAssignmentAlertNotificationDefaultRecipient       = $True
                    EligibleAssignmentAlertNotificationOnlyCritical           = $False
                    EligibleAssignmentAssigneeNotificationAdditionalRecipient = @()
                    EligibleAssignmentAssigneeNotificationDefaultRecipient    = $True
                    EligibleAssignmentAssigneeNotificationOnlyCritical        = $False
                    ExpireActiveAssignment                                    = 'P180D'
                    ExpireEligibleAssignment                                  = 'P365D'
                    Id                                                        = 'Group_81c3d8db-c61c-4dd7-bf63-a9a184f04e50_7aa8de6e-dc91-434d-a18b-b67ce4d9bc45_owner'
                    PermanentActiveAssignmentisExpirationRequired             = $False
                    PermanentEligibleAssignmentisExpirationRequired           = $False
                    RoleDefinitionId                                          = "owner"
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        Id = '81c3d8db-c61c-4dd7-bf63-a9a184f04e50'
                        DisplayName = 'FakeGroup'
                    }
                } -ParameterFilter {$Filter -eq "DisplayName eq 'FakeGroup'"}

            }

            It 'Should return Values from the get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
                Assert-MockCalled Get-MgGroup -Exactly 1 -Scope It
                Assert-MockCalled Get-MgPolicyRoleManagementPolicyAssignment -Exactly 1 -Scope It
            }

            It 'Should return true from the test method' {
                Test-TargetResource @testParams | Should -Be $true
                Assert-MockCalled Get-MgGroup -Exactly 1 -Scope It
                Assert-MockCalled Get-MgPolicyRoleManagementPolicyAssignment -Exactly 1 -Scope It
            }
        }

        Context -Name 'Values are not in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    ActivateApprover                                          = @()
                    ActivationMaxDuration                                     = 'PT8H'
                    ActivationReqJustification                                = $False
                    ActivationReqMFA                                          = $True
                    ActivationReqTicket                                       = $False
                    ActiveAlertNotificationAdditionalRecipient                = @()
                    ActiveAlertNotificationDefaultRecipient                   = $True
                    ActiveAlertNotificationOnlyCritical                       = $False
                    ActiveApproveNotificationAdditionalRecipient              = @()
                    ActiveApproveNotificationDefaultRecipient                 = $True
                    ActiveApproveNotificationOnlyCritical                     = $False
                    ActiveAssigneeNotificationAdditionalRecipient             = @()
                    ActiveAssigneeNotificationDefaultRecipient                = $True
                    ActiveAssigneeNotificationOnlyCritical                    = $False
                    ApplicationId                                             = $ConfigurationData.NonNodeData.ApplicationId
                    ApprovaltoActivate                                        = $False
                    AssignmentReqJustification                                = $True
                    AssignmentReqMFA                                          = $False
                    CertificateThumbprint                                     = $ConfigurationData.NonNodeData.CertificateThumbprint
                    Displayname                                               = 'FakeGroup'
                    ElegibilityAssignmentReqJustification                     = $False
                    ElegibilityAssignmentReqMFA                               = $False
                    EligibleAlertNotificationAdditionalRecipient              = @()
                    EligibleAlertNotificationDefaultRecipient                 = $True
                    EligibleAlertNotificationOnlyCritical                     = $False
                    EligibleApproveNotificationAdditionalRecipient            = @()
                    EligibleApproveNotificationDefaultRecipient               = $True
                    EligibleApproveNotificationOnlyCritical                   = $False
                    EligibleAssigneeNotificationAdditionalRecipient           = @()
                    EligibleAssigneeNotificationDefaultRecipient              = $True
                    EligibleAssigneeNotificationOnlyCritical                  = $False
                    EligibleAssignmentAlertNotificationAdditionalRecipient    = @()
                    EligibleAssignmentAlertNotificationDefaultRecipient       = $True
                    EligibleAssignmentAlertNotificationOnlyCritical           = $False
                    EligibleAssignmentAssigneeNotificationAdditionalRecipient = @()
                    EligibleAssignmentAssigneeNotificationDefaultRecipient    = $True
                    EligibleAssignmentAssigneeNotificationOnlyCritical        = $False
                    ExpireActiveAssignment                                    = 'P180D'
                    ExpireEligibleAssignment                                  = 'P365D'
                    Id                                                        = 'Group_81c3d8db-c61c-4dd7-bf63-a9a184f04e50_7aa8de6e-dc91-434d-a18b-b67ce4d9bc45_owner'
                    PermanentActiveAssignmentisExpirationRequired             = $False
                    PermanentEligibleAssignmentisExpirationRequired           = $False
                    RoleDefinitionId                                          = "owner"
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Update-MgBetaPolicyRoleManagementPolicyRule -MockWith {
                }

                mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        Id = '81c3d8db-c61c-4dd7-bf63-a9a184f04e50'
                        DisplayName = 'FakeGroup'
                    }
                } -ParameterFilter {$Filter -eq "DisplayName eq 'FakeGroup'"}
            }

            It 'Should return values from the get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
                Assert-MockCalled Get-MgGroup -Exactly 1 -Scope It
                Assert-MockCalled Get-MgPolicyRoleManagementPolicyAssignment -Exactly 1 -Scope It
            }

            It 'Should call the set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Update-MgBetaPolicyRoleManagementPolicyRule' -Exactly 15
                Assert-MockCalled Get-MgGroup -Exactly 1 -Scope It
                Assert-MockCalled Get-MgPolicyRoleManagementPolicyAssignment -Exactly 1 -Scope It
            }
        }

        Context -Name 'ReverseDSC tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        Id = '81c3d8db-c61c-4dd7-bf63-a9a184f04e50'
                        DisplayName = 'FakeGroup'
                    }
                }
            }

            It 'Should reverse engineer resource from the export method' {
                $result = Export-TargetResource @testParams
                Assert-MockCalled Get-MgGroup -Exactly 1 -Scope It
                Assert-MockCalled Get-MgPolicyRoleManagementPolicyAssignment -Exactly 1 -Scope It
                $result | Should -Not -BeNullOrEmpty
            }

            It 'Should reverse engineer resource from the export method with a filter' {
                $testParams.Filter = "displayName eq 'FakeGroup'"

                $result = Export-TargetResource @testParams
                Assert-MockCalled Get-MgGroup -Exactly 1 -Scope It
                Assert-MockCalled Get-MgPolicyRoleManagementPolicyAssignment -Exactly 1 -Scope It
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
