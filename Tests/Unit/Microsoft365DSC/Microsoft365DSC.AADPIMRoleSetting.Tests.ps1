[CmdletBinding()]
param(
)
$M365DSCTestFolder = Join-Path -Path $PSScriptRoot `
    -ChildPath "..\..\Unit" `
    -Resolve
$CmdletModule = (Join-Path -Path $M365DSCTestFolder `
        -ChildPath "\Stubs\Microsoft365.psm1" `
        -Resolve)
$GenericStubPath = (Join-Path -Path $M365DSCTestFolder `
        -ChildPath "\Stubs\Generic.psm1" `
        -Resolve)
Import-Module -Name (Join-Path -Path $M365DSCTestFolder `
        -ChildPath "\UnitTestHelper.psm1" `
        -Resolve)

$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource "AADPIMRoleSetting" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {
            $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

            $Global:PartialExportFileName = "c:\TestPath"
            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {
                return "FakeDSCContent"
            }
            Mock -CommandName Save-M365DSCPartialExport -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {

            }

            Mock -CommandName Remove-PSSession -MockWith {

            }

            Mock -CommandName Get-MgPolicyRoleManagementPolicyAssignment -MockWith {
                return $Policy = @{
                    PolicyId = "DirectoryRole_1e1b61e9-1bad-4b5f-aca3-973feb8d36e0_2d3a49e9-4a0b-4456-b381-3311753988a8"
                }
            }

            Mock -CommandName Get-MgRoleManagementDirectoryRoleDefinition -MockWith {
                return $RoleDefinition = @{
                    DisplayName = "User administrator"
                }
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            $json = @'
[
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
]
'@
                $role = $json | ConvertFrom-Json
                Mock -CommandName Get-MgPolicyRoleManagementPolicyRule -MockWith {
                    return $role
                }
        }

        # Test contexts

        Context -Name "The role definition exists and values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    ActivateApprover                                          = @();
                    ActivationMaxDuration                                     = "PT8H";
                    ActivationReqJustification                                = $True;
                    ActivationReqMFA                                          = $True;
                    ActivationReqTicket                                       = $False;
                    ActiveAlertNotificationAdditionalRecipient                = @();
                    ActiveAlertNotificationDefaultRecipient                   = $True;
                    ActiveAlertNotificationOnlyCritical                       = $False;
                    ActiveApproveNotificationAdditionalRecipient              = @();
                    ActiveApproveNotificationDefaultRecipient                 = $True;
                    ActiveApproveNotificationOnlyCritical                     = $False;
                    ActiveAssigneeNotificationAdditionalRecipient             = @();
                    ActiveAssigneeNotificationDefaultRecipient                = $True;
                    ActiveAssigneeNotificationOnlyCritical                    = $False;
                    ApplicationId                                             = $ConfigurationData.NonNodeData.ApplicationId;
                    ApprovaltoActivate                                        = $False;
                    AssignmentReqJustification                                = $True;
                    AssignmentReqMFA                                          = $False;
                    CertificateThumbprint                                     = $ConfigurationData.NonNodeData.CertificateThumbprint;
                    Displayname                                               = "User administrator";
                    ElegibilityAssignmentReqJustification                     = $False;
                    ElegibilityAssignmentReqMFA                               = $False;
                    EligibleAlertNotificationAdditionalRecipient              = @();
                    EligibleAlertNotificationDefaultRecipient                 = $True;
                    EligibleAlertNotificationOnlyCritical                     = $False;
                    EligibleApproveNotificationAdditionalRecipient            = @();
                    EligibleApproveNotificationDefaultRecipient               = $True;
                    EligibleApproveNotificationOnlyCritical                   = $False;
                    EligibleAssigneeNotificationAdditionalRecipient           = @();
                    EligibleAssigneeNotificationDefaultRecipient              = $True;
                    EligibleAssigneeNotificationOnlyCritical                  = $False;
                    EligibleAssignmentAlertNotificationAdditionalRecipient    = @();
                    EligibleAssignmentAlertNotificationDefaultRecipient       = $True;
                    EligibleAssignmentAlertNotificationOnlyCritical           = $False;
                    EligibleAssignmentAssigneeNotificationAdditionalRecipient = @();
                    EligibleAssignmentAssigneeNotificationDefaultRecipient    = $True;
                    EligibleAssignmentAssigneeNotificationOnlyCritical        = $False;
                    ExpireActiveAssignment                                    = "P180D";
                    ExpireEligibleAssignment                                  = "P365D";
                    Id                                                        = "fe930be7-5e62-47db-91af-98c3a49a38b1";
                    PermanentActiveAssignmentisExpirationRequired             = $False;
                    PermanentEligibleAssignmentisExpirationRequired           = $False;
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }

            }

            It "Should return Values from the get method" {
                Get-TargetResource @testParams
                Should -Invoke -CommandName "Get-MgPolicyRoleManagementPolicyRule" -Exactly 1
            }

            It 'Should return true from the test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "Values are not in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    ActivateApprover                                          = @();
                    ActivationMaxDuration                                     = "PT8H";
                    ActivationReqJustification                                = $False;
                    ActivationReqMFA                                          = $True;
                    ActivationReqTicket                                       = $False;
                    ActiveAlertNotificationAdditionalRecipient                = @();
                    ActiveAlertNotificationDefaultRecipient                   = $True;
                    ActiveAlertNotificationOnlyCritical                       = $False;
                    ActiveApproveNotificationAdditionalRecipient              = @();
                    ActiveApproveNotificationDefaultRecipient                 = $True;
                    ActiveApproveNotificationOnlyCritical                     = $False;
                    ActiveAssigneeNotificationAdditionalRecipient             = @();
                    ActiveAssigneeNotificationDefaultRecipient                = $True;
                    ActiveAssigneeNotificationOnlyCritical                    = $False;
                    ApplicationId                                             = $ConfigurationData.NonNodeData.ApplicationId;
                    ApprovaltoActivate                                        = $False;
                    AssignmentReqJustification                                = $True;
                    AssignmentReqMFA                                          = $False;
                    CertificateThumbprint                                     = $ConfigurationData.NonNodeData.CertificateThumbprint;
                    Displayname                                               = "User administrator";
                    ElegibilityAssignmentReqJustification                     = $False;
                    ElegibilityAssignmentReqMFA                               = $False;
                    EligibleAlertNotificationAdditionalRecipient              = @();
                    EligibleAlertNotificationDefaultRecipient                 = $True;
                    EligibleAlertNotificationOnlyCritical                     = $False;
                    EligibleApproveNotificationAdditionalRecipient            = @();
                    EligibleApproveNotificationDefaultRecipient               = $True;
                    EligibleApproveNotificationOnlyCritical                   = $False;
                    EligibleAssigneeNotificationAdditionalRecipient           = @();
                    EligibleAssigneeNotificationDefaultRecipient              = $True;
                    EligibleAssigneeNotificationOnlyCritical                  = $False;
                    EligibleAssignmentAlertNotificationAdditionalRecipient    = @();
                    EligibleAssignmentAlertNotificationDefaultRecipient       = $True;
                    EligibleAssignmentAlertNotificationOnlyCritical           = $False;
                    EligibleAssignmentAssigneeNotificationAdditionalRecipient = @();
                    EligibleAssignmentAssigneeNotificationDefaultRecipient    = $True;
                    EligibleAssignmentAssigneeNotificationOnlyCritical        = $False;
                    ExpireActiveAssignment                                    = "P180D";
                    ExpireEligibleAssignment                                  = "P365D";
                    Id                                                        = "fe930be7-5e62-47db-91af-98c3a49a38b1";
                    PermanentActiveAssignmentisExpirationRequired             = $False;
                    PermanentEligibleAssignmentisExpirationRequired           = $False;
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }

                Mock -CommandName Update-MgPolicyRoleManagementPolicyRule -MockWith {
                }
            }

            It "Should return values from the get method" {
                Get-TargetResource @testParams
                Should -Invoke -CommandName "Get-MgRoleManagementDirectoryRoleDefinition" -Exactly 1
            }

            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should call the set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Update-MgPolicyRoleManagementPolicyRule' -Exactly 15
            }
        }

        Context -Name "ReverseDSC tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }

                Mock -CommandName Get-MgRoleManagementDirectoryRoleDefinition -MockWith {
                    $AADRoleDef = New-Object PSCustomObject
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name DisplayName -Value "Role1"
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name Description -Value "This is a custom role"
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name ResourceScopes -Value "/"
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name IsEnabled -Value "True"
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name RolePermissions -Value @{AllowedResourceActions = "microsoft.directory/applicationPolicies/allProperties/read", "microsoft.directory/applicationPolicies/allProperties/update", "microsoft.directory/applicationPolicies/basic/update" }
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name Version -Value "1.0"
                    return $AADRoleDef
                }
            }

            It "Should reverse engineer resource from the export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
