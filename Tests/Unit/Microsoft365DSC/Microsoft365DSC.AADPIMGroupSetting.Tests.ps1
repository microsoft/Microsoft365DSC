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
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@onmicrosoft.com', $secpasswd)

            $Global:PartialExportFileName = 'c:\TestPath'

            Mock -CommandName Save-M365DSCPartialExport -MockWith {
            }

            Mock -ModuleName M365DSCUtil -CommandName Confirm-M365DSCDependencies -MockWith {
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

            Mock -CommandName Get-MgGroup -MockWith {
                return @{
                    Id = '81c3d8db-c61c-4dd7-bf63-a9a184f04e50'
                    DisplayName = 'FakeGroup'
                }
            }

            Mock -CommandName New-M365DSCConnection -ModuleName '_Shared' -MockWith {
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
                                "@odata.type":  "#microsoft.graph.unifiedRoleManagementPolicyEnablementRule",
                                "enabledRules":  [

                                                ]
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
                                "@odata.type":  "#microsoft.graph.unifiedRoleManagementPolicyExpirationRule",
                                "isExpirationRequired":  false,
                                "maximumDuration":  "P365D"
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
                                "@odata.type":  "#microsoft.graph.unifiedRoleManagementPolicyNotificationRule",
                                "notificationType":  "Email",
                                "recipientType":  "Approver",
                                "notificationLevel":  "All",
                                "isDefaultRecipientsEnabled":  true,
                                "notificationRecipients":  [

                                                            ]
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
                                "@odata.type":  "#microsoft.graph.unifiedRoleManagementPolicyNotificationRule",
                                "notificationType":  "Email",
                                "recipientType":  "Admin",
                                "notificationLevel":  "All",
                                "isDefaultRecipientsEnabled":  true,
                                "notificationRecipients":  [

                                                            ]
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
                                "@odata.type":  "#microsoft.graph.unifiedRoleManagementPolicyNotificationRule",
                                "notificationType":  "Email",
                                "recipientType":  "Requestor",
                                "notificationLevel":  "All",
                                "isDefaultRecipientsEnabled":  true,
                                "notificationRecipients":  [

                                                            ]
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
                                "@odata.type":  "#microsoft.graph.unifiedRoleManagementPolicyEnablementRule",
                                "enabledRules":  [
                                                    "Justification"
                                                ]
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
                                "@odata.type":  "#microsoft.graph.unifiedRoleManagementPolicyExpirationRule",
                                "isExpirationRequired":  false,
                                "maximumDuration":  "P180D"
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
                                "@odata.type":  "#microsoft.graph.unifiedRoleManagementPolicyNotificationRule",
                                "notificationType":  "Email",
                                "recipientType":  "Admin",
                                "notificationLevel":  "All",
                                "isDefaultRecipientsEnabled":  true,
                                "notificationRecipients":  [

                                                            ]
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
                                "@odata.type":  "#microsoft.graph.unifiedRoleManagementPolicyNotificationRule",
                                "notificationType":  "Email",
                                "recipientType":  "Approver",
                                "notificationLevel":  "All",
                                "isDefaultRecipientsEnabled":  true,
                                "notificationRecipients":  [

                                                            ]
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
                                "@odata.type":  "#microsoft.graph.unifiedRoleManagementPolicyNotificationRule",
                                "notificationType":  "Email",
                                "recipientType":  "Requestor",
                                "notificationLevel":  "All",
                                "isDefaultRecipientsEnabled":  true,
                                "notificationRecipients":  [

                                                            ]
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
                                "@odata.type":  "#microsoft.graph.unifiedRoleManagementPolicyAuthenticationContextRule",
                                "isEnabled":  false,
                                "claimValue":  ""
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
                                "@odata.type":  "#microsoft.graph.unifiedRoleManagementPolicyEnablementRule",
                                "enabledRules":  [
                                                    "MultiFactorAuthentication",
                                                    "Justification"
                                                ]
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
                                "@odata.type":  "#microsoft.graph.unifiedRoleManagementPolicyExpirationRule",
                                "isExpirationRequired":  false,
                                "maximumDuration":  "PT8H"
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
                                "@odata.type":  "#microsoft.graph.unifiedRoleManagementPolicyNotificationRule",
                                "notificationType":  "Email",
                                "recipientType":  "Approver",
                                "notificationLevel":  "All",
                                "isDefaultRecipientsEnabled":  true,
                                "notificationRecipients":  [

                                                            ]
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
                                "@odata.type":  "#microsoft.graph.unifiedRoleManagementPolicyNotificationRule",
                                "notificationType":  "Email",
                                "recipientType":  "Admin",
                                "notificationLevel":  "All",
                                "isDefaultRecipientsEnabled":  true,
                                "notificationRecipients":  [

                                                            ]
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
                                "@odata.type":  "#microsoft.graph.unifiedRoleManagementPolicyNotificationRule",
                                "notificationType":  "Email",
                                "recipientType":  "Requestor",
                                "notificationLevel":  "All",
                                "isDefaultRecipientsEnabled":  true,
                                "notificationRecipients":  [

                                                            ]
                            }
                        ],
                        "ScopeId":  "7cf1e453-3f07-440a-9b80-856c190de62c",
                        "ScopeType":  "Group"
                    },
                    "PolicyId":  "Group_1e1b61e9-1bad-4b5f-aca3-973feb8d36e0_2d3a49e9-4a0b-4456-b381-3311753988a8",
                    "RoleDefinitionId":  "member",
                    "ScopeId":  "7cf1e453-3f07-440a-9b80-856c190de62c",
                    "ScopeType":  "Group",
                    "@odata.context":  "https://graph.microsoft.us/v1.0/$metadata#policies/roleManagementPolicyAssignments(policy(rules()))/$entity"
                }
'@
            $mockPolicy = $policyJson | ConvertFrom-Json
            Mock -CommandName Get-MgPolicyRoleManagementPolicyAssignment -MockWith {
                return $mockPolicy
            }

            Mock -CommandName Update-MgBetaPolicyRoleManagementPolicyRule -MockWith {
            }

            Mock -CommandName Invoke-M365DSCGraphBatchRequest -MockWith {
                return @(
                    @{
                        id = '81c3d8db-c61c-4dd7-bf63-a9a184f04e50'
                        body = @{
                            value = @($mockPolicy)
                        }
                    }
                )
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
                    EligibilityAssignmentReqJustification                     = $False
                    EligibilityAssignmentReqMFA                               = $False
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
            }

            It 'Should return Values from the get method' {
                ((New-M365DSCResourceInstance -ResourceName 'AADPIMGroupSetting' -Property $testParams).Get().ToHashtable()).Ensure | Should -Be "Present"
                Should -Invoke -CommandName Get-MgGroup -Exactly 1
                Should -Invoke -CommandName Invoke-M365DSCGraphBatchRequest -Exactly 1
            }

            It 'Should return true from the test method' {
                (New-M365DSCResourceInstance -ResourceName 'AADPIMGroupSetting' -Property $testParams).Test() | Should -Be $true
                Should -Invoke -CommandName Get-MgGroup -Exactly 1
                Should -Invoke -CommandName Invoke-M365DSCGraphBatchRequest -Exactly 1
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
                    EligibilityAssignmentReqJustification                     = $False
                    EligibilityAssignmentReqMFA                               = $False
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
            }

            It 'Should return values from the get method' {
                ((New-M365DSCResourceInstance -ResourceName 'AADPIMGroupSetting' -Property $testParams).Get().ToHashtable()).Ensure | Should -Be "Present"
                Should -Invoke -CommandName Get-MgGroup -Exactly 1
                Should -Invoke -CommandName Invoke-M365DSCGraphBatchRequest -Exactly 1
            }

            It 'Should call the set method' {
                (New-M365DSCResourceInstance -ResourceName 'AADPIMGroupSetting' -Property $testParams).Set()
                Should -Invoke -CommandName 'Update-MgBetaPolicyRoleManagementPolicyRule' -Exactly 15
                Should -Invoke -CommandName Get-MgGroup -Exactly 1
                Should -Invoke -CommandName Invoke-M365DSCGraphBatchRequest -Exactly 1
            }
        }

        Context 'Activation approver mapping' {
            BeforeAll {
                Mock -CommandName Get-MgUser -MockWith {
                    return @{ UserPrincipalName = "$UserId@contoso.com" }
                }

                Mock -CommandName Get-MgGroup -ParameterFilter { -not [string]::IsNullOrEmpty($GroupId) } -MockWith {
                    return @{ DisplayName = "Approvers $GroupId" }
                }

                Mock -CommandName New-M365DSCLogEntry -ModuleName '_Shared' -MockWith {
                }

                Mock -CommandName Get-M365DSCExportCachedCollection -MockWith {
                    return @(@{ Id = '81c3d8db-c61c-4dd7-bf63-a9a184f04e50' })
                }
            }

            BeforeEach {
                $fixture = $policyJson | ConvertFrom-Json -AsHashtable
                $mockPolicy = @{
                    Id               = $fixture.Id
                    RoleDefinitionId = $fixture.RoleDefinitionId
                    policy           = @{ rules = $fixture.Policy.Rules }
                }
                $approvalRule = $mockPolicy.Policy.Rules | Where-Object -FilterScript { $_.Id -eq 'Approval_EndUser_Assignment' }
                $approvalRule.setting.isApprovalRequired = $true
                Mock -CommandName Invoke-M365DSCGraphBatchRequest -MockWith {
                    return @(@{
                        id   = '81c3d8db-c61c-4dd7-bf63-a9a184f04e50'
                        body = @{ value = @($mockPolicy) }
                    })
                }
                $testParams = @{
                    DisplayName      = 'FakeGroup'
                    RoleDefinitionId = 'member'
                    Ensure           = 'Present'
                }
            }

            Context '<Scenario>' -ForEach @(
                @{
                    Scenario = 'One user'
                    Stages   = @(@{ primaryApprovers = @(@{ '@odata.type' = '#microsoft.graph.singleUser'; userId = 'user1'; id = 'wrong-id' }) })
                    Expected = @('user1@contoso.com')
                }
                @{
                    Scenario = 'One group'
                    Stages   = @(@{ primaryApprovers = @(@{ '@odata.type' = '#microsoft.graph.groupMembers'; groupId = 'group1'; id = 'wrong-id' }) })
                    Expected = @('Approvers group1')
                }
                @{
                    Scenario = 'Multiple users'
                    Stages   = @(@{ primaryApprovers = @(
                        @{ '@odata.type' = '#microsoft.graph.singleUser'; userId = 'user2' }
                        @{ '@odata.type' = '#microsoft.graph.singleUser'; userId = 'user1' }
                    ) })
                    Expected = @('user2@contoso.com', 'user1@contoso.com')
                }
                @{
                    Scenario = 'Multiple groups'
                    Stages   = @(@{ primaryApprovers = @(
                        @{ '@odata.type' = '#microsoft.graph.groupMembers'; groupId = 'group2' }
                        @{ '@odata.type' = '#microsoft.graph.groupMembers'; groupId = 'group1' }
                    ) })
                    Expected = @('Approvers group2', 'Approvers group1')
                }
                @{
                    Scenario = 'Mixed approvers and multiple stages preserve order and duplicates'
                    Stages   = @(
                        @{ primaryApprovers = @(
                            @{ '@odata.type' = '#microsoft.graph.groupMembers'; groupId = 'group2' }
                            @{ '@odata.type' = '#microsoft.graph.singleUser'; userId = 'user2' }
                        ) }
                        @{ primaryApprovers = @() }
                        @{ primaryApprovers = @(
                            @{ '@odata.type' = '#microsoft.graph.singleUser'; userId = 'user1' }
                            @{ '@odata.type' = '#microsoft.graph.groupMembers'; groupId = 'group2' }
                        ) }
                    )
                    Expected = @('Approvers group2', 'user2@contoso.com', 'user1@contoso.com', 'Approvers group2')
                }
                @{
                    Scenario = 'Empty approvers'
                    Stages   = @(@{ primaryApprovers = @() })
                    Expected = @()
                }
                @{
                    Scenario = 'Missing approvers'
                    Stages   = @(@{})
                    Expected = @()
                }
                @{
                    Scenario = 'No stages'
                    Stages   = @()
                    Expected = @()
                }
            ) {
                Context '<Representation>' -ForEach @(
                    @{ Representation = 'Hashtable' }
                    @{ Representation = 'PSObject' }
                    @{ Representation = 'AdditionalProperties' }
                    @{ Representation = 'OdataType' }
                ) {
                    BeforeEach {
                        $caseStages = ConvertTo-Json -InputObject $Stages -Depth 20 | ConvertFrom-Json -AsHashtable -NoEnumerate
                        $approvalRule.setting.approvalStages = $caseStages
                        if ($Representation -eq 'PSObject') {
                            $mockPolicy = $mockPolicy | ConvertTo-Json -Depth 30 | ConvertFrom-Json
                        }
                        elseif ($Representation -in @('AdditionalProperties', 'OdataType')) {
                            foreach ($stage in $caseStages) {
                                $stage.primaryApprovers = @(foreach ($approver in $stage.primaryApprovers) {
                                    if ($Representation -eq 'OdataType') {
                                        [PSCustomObject]@{
                                            OdataType            = $approver.'@odata.type'
                                            AdditionalProperties = @{
                                                userId  = $approver.userId
                                                groupId = $approver.groupId
                                            }
                                        }
                                    }
                                    else {
                                        [PSCustomObject]@{ AdditionalProperties = $approver }
                                    }
                                })
                            }
                            if ($Representation -eq 'AdditionalProperties') {
                                $approvalRule.AdditionalProperties = @{
                                    setting = [PSCustomObject]@{
                                        IsApprovalRequired   = $null
                                        AdditionalProperties = @{
                                            isApprovalRequired = $true
                                            approvalStages     = @(foreach ($stage in $caseStages) {
                                                [PSCustomObject]@{ AdditionalProperties = $stage }
                                            })
                                        }
                                    }
                                }
                                $approvalRule.setting = $null
                            }
                        }
                        $testParams.ApprovaltoActivate = $true
                        $testParams.ActivateApprover = $Expected
                    }

                    It 'Returns the resolved values through Get' {
                        $result = (New-M365DSCResourceInstance -ResourceName 'AADPIMGroupSetting' -Property $testParams).Get()
                        $result.Ensure | Should -Be 'Present'
                        $result.Id | Should -Be $mockPolicy.Id
                        $result.ApprovaltoActivate | Should -BeTrue
                        $result.ActivateApprover | Should -HaveCount $Expected.Count
                        ($result.ActivateApprover -join '|') | Should -BeExactly ($Expected -join '|')
                        Should -Invoke -CommandName Get-MgGroup -Exactly 0 -ParameterFilter { $GroupId -eq 'wrong-id' }
                        Should -Invoke -CommandName Get-MgUser -Exactly 0 -ParameterFilter { $UserId -eq 'wrong-id' }
                    }

                    It 'Reports no drift through Test' {
                        (New-M365DSCResourceInstance -ResourceName 'AADPIMGroupSetting' -Property $testParams).Test() | Should -BeTrue
                    }

                    It 'Uses the same values in exported output without fetching the policy again' {
                        Mock -CommandName Get-M365DSCExportContentForResource -MockWith {
                            return "ActivateApprover=$($Results.ActivateApprover -join '|')"
                        }

                        $result = (New-M365DSCResourceInstance -ResourceName 'AADPIMGroupSetting').Export()
                        $result | Should -BeExactly "ActivateApprover=$($Expected -join '|')"
                        Should -Invoke -CommandName Invoke-M365DSCGraphBatchRequest -Exactly 1
                        Should -Invoke -CommandName Get-MgGroup -Exactly 0 -ParameterFilter { -not [string]::IsNullOrEmpty($Filter) -and $Filter -like 'DisplayName eq*' }
                    }
                }
            }

            It 'Detects approver drift through Test' {
                $approvalRule.setting.approvalStages = @(@{ primaryApprovers = @(
                    @{ '@odata.type' = '#microsoft.graph.singleUser'; userId = 'user1' }
                ) })
                $testParams.ActivateApprover = @('different@contoso.com')
                (New-M365DSCResourceInstance -ResourceName 'AADPIMGroupSetting' -Property $testParams).Test() | Should -BeFalse
            }

            It 'Skips resolution when approval is disabled even with populated approvers' {
                $approvalRule.setting.isApprovalRequired = $false
                $approvalRule.setting.approvalStages = @(@{ primaryApprovers = @(
                    @{ '@odata.type' = '#microsoft.graph.singleUser'; userId = 'user1' }
                    @{ '@odata.type' = '#microsoft.graph.groupMembers'; groupId = 'group1' }
                    @{ '@odata.type' = '#microsoft.graph.requestorManager' }
                ) })
                $result = (New-M365DSCResourceInstance -ResourceName 'AADPIMGroupSetting' -Property $testParams).Get()
                $result.ApprovaltoActivate | Should -BeFalse
                $result.ActivateApprover | Should -HaveCount 0
                $testParams.ApprovaltoActivate = $false
                $testParams.ActivateApprover = @()
                (New-M365DSCResourceInstance -ResourceName 'AADPIMGroupSetting' -Property $testParams).Test() | Should -BeTrue
                Mock -CommandName Get-M365DSCExportContentForResource -MockWith {
                    return "ApprovaltoActivate=$($Results.ApprovaltoActivate);ActivateApproverCount=$($Results.ActivateApprover.Count)"
                }
                (New-M365DSCResourceInstance -ResourceName 'AADPIMGroupSetting').Export() |
                    Should -BeExactly 'ApprovaltoActivate=False;ActivateApproverCount=0'
                Should -Invoke -CommandName Get-MgUser -Exactly 0
                Should -Invoke -CommandName Get-MgGroup -Exactly 0 -ParameterFilter { -not [string]::IsNullOrEmpty($GroupId) }
            }

            It 'Exports populated approvers using the real serializer in Graph order' {
                $approvalRule.setting.approvalStages = @(@{ primaryApprovers = @(
                    @{ '@odata.type' = '#microsoft.graph.groupMembers'; groupId = 'group1' }
                    @{ '@odata.type' = '#microsoft.graph.singleUser'; userId = 'user1' }
                ) })
                $result = (New-M365DSCResourceInstance -ResourceName 'AADPIMGroupSetting').Export()
                $result | Should -Match 'ApprovaltoActivate\s*=\s*\$True'
                $result | Should -Match 'ActivateApprover\s*='
                $result | Should -Match 'Approvers group1'
                $result | Should -Match 'user1@contoso.com'
                $result.IndexOf('Approvers group1') | Should -BeLessThan $result.IndexOf('user1@contoso.com')
                Should -Invoke -CommandName Save-M365DSCPartialExport -Exactly 1 -ParameterFilter {
                    $Content -like '*Approvers group1*user1@contoso.com*'
                }
            }

            It 'Rejects <Scenario> rather than silently omitting it' -ForEach @(
                @{ Scenario = 'missing type'; Approver = @{ userId = 'user1' }; Message = '*unsupported*type*' }
                @{ Scenario = 'unsupported type'; Approver = @{ '@odata.type' = '#microsoft.graph.requestorManager' }; Message = '*unsupported*type*' }
                @{ Scenario = 'multiple types'; Approver = @{ '@odata.type' = @('#microsoft.graph.singleUser', '#microsoft.graph.groupMembers'); userId = 'user1' }; Message = '*unsupported*type*' }
                @{ Scenario = 'null approver'; Approver = $null; Message = '*unsupported*type*' }
                @{ Scenario = 'missing userId'; Approver = @{ '@odata.type' = '#microsoft.graph.singleUser'; id = 'not-userId' }; Message = '*userId*' }
                @{ Scenario = 'blank userId'; Approver = @{ '@odata.type' = '#microsoft.graph.singleUser'; userId = ' ' }; Message = '*userId*' }
                @{ Scenario = 'non-string userId'; Approver = @{ '@odata.type' = '#microsoft.graph.singleUser'; userId = 123 }; Message = '*userId*' }
                @{ Scenario = 'missing groupId'; Approver = @{ '@odata.type' = '#microsoft.graph.groupMembers'; id = 'not-groupId' }; Message = '*groupId*' }
                @{ Scenario = 'blank groupId'; Approver = @{ '@odata.type' = '#microsoft.graph.groupMembers'; groupId = ' ' }; Message = '*groupId*' }
                @{ Scenario = 'multiple groupIds'; Approver = @{ '@odata.type' = '#microsoft.graph.groupMembers'; groupId = @('group1', 'group2') }; Message = '*groupId*' }
            ) {
                $approvalRule.setting.approvalStages = @(@{ primaryApprovers = @($Approver) })
                { (New-M365DSCResourceInstance -ResourceName 'AADPIMGroupSetting' -Property $testParams).Get() } | Should -Throw -ExpectedMessage $Message
                Should -Invoke -CommandName New-M365DSCLogEntry -ModuleName '_Shared' -Exactly 1 -ParameterFilter {
                    $Source -eq 'AADPIMGroupSetting' -and $Message -like '*FakeGroup*member*stage 1*approver 1*'
                }
                Should -Invoke -CommandName Get-MgUser -Exactly 0
                Should -Invoke -CommandName Get-MgGroup -Exactly 0 -ParameterFilter { -not [string]::IsNullOrEmpty($GroupId) }
            }

            Context '<Lookup> resolution fails' -ForEach @(
                @{ Lookup = 'User' }
                @{ Lookup = 'Group' }
            ) {
                BeforeEach {
                    $approver = if ($Lookup -eq 'User') {
                        @{ '@odata.type' = '#microsoft.graph.singleUser'; userId = 'user1' }
                    }
                    else {
                        @{ '@odata.type' = '#microsoft.graph.groupMembers'; groupId = 'group1' }
                    }
                    $approvalRule.setting.approvalStages = @(@{ primaryApprovers = @($approver) })
                }

                It 'Propagates lookup exceptions and logs actionable context without trying the other type' {
                    Mock -CommandName "Get-Mg$Lookup" -ParameterFilter { -not [string]::IsNullOrEmpty($UserId) -or -not [string]::IsNullOrEmpty($GroupId) } -MockWith {
                        throw 'Directory read denied'
                    }
                    { (New-M365DSCResourceInstance -ResourceName 'AADPIMGroupSetting' -Property $testParams).Get() } | Should -Throw -ExpectedMessage '*Directory read denied*'
                    Should -Invoke -CommandName New-M365DSCLogEntry -ModuleName '_Shared' -Exactly 1 -ParameterFilter {
                        $Message -like '*FakeGroup*member*stage 1*approver 1*'
                    }
                    if ($Lookup -eq 'User') {
                        Should -Invoke -CommandName Get-MgGroup -Exactly 0 -ParameterFilter { -not [string]::IsNullOrEmpty($GroupId) }
                    }
                    else {
                        Should -Invoke -CommandName Get-MgUser -Exactly 0
                    }
                }

                It 'Rejects a missing directory object' {
                    Mock -CommandName "Get-Mg$Lookup" -ParameterFilter { -not [string]::IsNullOrEmpty($UserId) -or -not [string]::IsNullOrEmpty($GroupId) } -MockWith {
                        return $null
                    }
                    { (New-M365DSCResourceInstance -ResourceName 'AADPIMGroupSetting' -Property $testParams).Get() } | Should -Throw -ExpectedMessage '*could not resolve*'
                }

                It 'Rejects a directory object with an empty resolved name' {
                    Mock -CommandName "Get-Mg$Lookup" -ParameterFilter { -not [string]::IsNullOrEmpty($UserId) -or -not [string]::IsNullOrEmpty($GroupId) } -MockWith {
                        return @{ UserPrincipalName = ' '; DisplayName = '' }
                    }
                    { (New-M365DSCResourceInstance -ResourceName 'AADPIMGroupSetting' -Property $testParams).Get() } | Should -Throw -ExpectedMessage '*could not resolve*'
                }

                It 'Stops export rather than emitting an incomplete approval configuration' {
                    Mock -CommandName "Get-Mg$Lookup" -ParameterFilter { -not [string]::IsNullOrEmpty($UserId) -or -not [string]::IsNullOrEmpty($GroupId) } -MockWith {
                        throw 'Directory read denied'
                    }
                    Mock -CommandName Get-M365DSCExportContentForResource -MockWith { return 'incomplete configuration' }
                    { (New-M365DSCResourceInstance -ResourceName 'AADPIMGroupSetting').Export() } | Should -Throw -ExpectedMessage '*Directory read denied*'
                    Should -Invoke -CommandName Get-M365DSCExportContentForResource -Exactly 0
                    Should -Invoke -CommandName Save-M365DSCPartialExport -Exactly 0
                }
            }
        }

        Context -Name 'ReverseDSC tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                $isM365DSCAvailable = $null -ne (Get-Module -ListAvailable -Name Microsoft365DSC)

                Mock -CommandName Get-M365DSCExportCachedCollection -ParameterFilter { $Collection -eq 'pimGroups' } -MockWith {
                    return @(
                        [PSCustomObject]@{
                            Id          = '81c3d8db-c61c-4dd7-bf63-a9a184f04e50'
                            DisplayName = 'FakeGroup'
                        }
                    )
                }
            }

            It 'Should reverse engineer resource from the export method' {
                $result = Invoke-M365DSCResourceMethod -ResourceName 'AADPIMGroupSetting' -MethodName 'Export' -Parameters $testParams
                Should -Invoke -CommandName Get-MgGroup -Exactly 1
                if ($isM365DSCAvailable)
                {
                    Should -Invoke -CommandName Invoke-M365DSCGraphBatchRequest -Exactly 1
                }
                $result | Should -Not -BeNullOrEmpty
            }

            It 'Should reverse engineer resource from the export method with a filter' {
                $testParams.Filter = "displayName eq 'FakeGroup'"
                $result = Invoke-M365DSCResourceMethod -ResourceName 'AADPIMGroupSetting' -MethodName 'Export' -Parameters $testParams
                Should -Invoke -CommandName Get-MgGroup -Exactly 1
                if ($isM365DSCAvailable)
                {
                    Should -Invoke -CommandName Invoke-M365DSCGraphBatchRequest -Exactly 1
                }
                $result | Should -Not -BeNullOrEmpty
            }

            It 'Should skip groups that are not enabled in PIM' {
                Mock -CommandName Get-M365DSCExportCachedCollection -ParameterFilter { $Collection -eq 'pimGroups' } -MockWith {
                    return @()
                }

                $result = Invoke-M365DSCResourceMethod -ResourceName 'AADPIMGroupSetting' -MethodName 'Export' -Parameters $testParams
                $result | Should -BeNullOrEmpty
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
