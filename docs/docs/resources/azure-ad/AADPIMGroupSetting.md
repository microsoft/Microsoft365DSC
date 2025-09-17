# AADPIMGroupSetting

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | RuleDefinition DisplayName | |
| **RoleDefinitionId** | Key | String | The identifier of the membership or ownership eligibility to the group that is governed by PIM. Required. The possible values are: owner, member. Supports $filter (eq). | `owner`, `member` |
| **Id** | Write | String | Specifies the Group Policy Id. | |
| **ActivationMaxDuration** | Write | String | Activation maximum duration (hours). | |
| **ActivationReqJustification** | Write | Boolean | Require justification on activation (True/False) | |
| **ActivationReqTicket** | Write | Boolean | Require ticket information on activation (True/False) | |
| **ActivationReqMFA** | Write | Boolean | Require MFA on activation (True/False) | |
| **ApprovaltoActivate** | Write | Boolean | Require approval to activate (True/False) | |
| **ActivateApprover** | Write | StringArray[] | Approver User UPN and/or Group Displayname | |
| **PermanentEligibleAssignmentisExpirationRequired** | Write | Boolean | Allow permanent eligible assignment (True/False) | |
| **ExpireEligibleAssignment** | Write | String | Expire eligible assignments after (Days) | |
| **PermanentActiveAssignmentisExpirationRequired** | Write | Boolean | Allow permanent active assignment (True/False) | |
| **ExpireActiveAssignment** | Write | String | Expire active assignments after (Days) | |
| **AssignmentReqMFA** | Write | Boolean | Require Azure Multi-Factor Authentication on active assignment (True/False) | |
| **AssignmentReqJustification** | Write | Boolean | Require justification on active assignment (True/False) | |
| **ElegibilityAssignmentReqMFA** | Write | Boolean | Require Azure Multi-Factor Authentication on eligible assignment (True/False) | |
| **ElegibilityAssignmentReqJustification** | Write | Boolean | Require justification on eligible assignment (True/False) | |
| **EligibleAlertNotificationDefaultRecipient** | Write | Boolean | Send notifications when members are assigned as eligible to this group: Group assignment alert, default recipient (True/False) | |
| **EligibleAlertNotificationAdditionalRecipient** | Write | StringArray[] | Send notifications when members are assigned as eligible to this group: Group assignment alert, additional recipient (UPN) | |
| **EligibleAlertNotificationOnlyCritical** | Write | Boolean | Send notifications when members are assigned as eligible to this group: Group assignment alert, only critical Email (True/False) | |
| **EligibleAssigneeNotificationDefaultRecipient** | Write | Boolean | Send notifications when members are assigned as eligible to this group: Notification to the assigned user (assignee), default recipient (True/False) | |
| **EligibleAssigneeNotificationAdditionalRecipient** | Write | StringArray[] | Send notifications when members are assigned as eligible to this group: Notification to the assigned user (assignee), additional recipient (UPN) | |
| **EligibleAssigneeNotificationOnlyCritical** | Write | Boolean | Send notifications when members are assigned as eligible to this group: Notification to the assigned user (assignee), only critical Email (True/False) | |
| **EligibleApproveNotificationDefaultRecipient** | Write | Boolean | Send notifications when members are assigned as eligible to this group: Request to approve a group assignment renewal/extension, default recipient (True/False) | |
| **EligibleApproveNotificationAdditionalRecipient** | Write | StringArray[] | Send notifications when members are assigned as eligible to this group: Request to approve a group assignment renewal/extension, additional recipient (UPN) | |
| **EligibleApproveNotificationOnlyCritical** | Write | Boolean | Send notifications when members are assigned as eligible to this group: Request to approve a group assignment renewal/extension, only critical Email (True/False) | |
| **ActiveAlertNotificationDefaultRecipient** | Write | Boolean | Send notifications when members are assigned as active to this group: Group assignment alert, default recipient (True/False) | |
| **ActiveAlertNotificationAdditionalRecipient** | Write | StringArray[] | Send notifications when members are assigned as active to this group: Group assignment alert, additional recipient (UPN) | |
| **ActiveAlertNotificationOnlyCritical** | Write | Boolean | Send notifications when members are assigned as active to this group: Group assignment alert, only critical Email (True/False) | |
| **ActiveAssigneeNotificationDefaultRecipient** | Write | Boolean | Send notifications when members are assigned as active to this group: Notification to the assigned user (assignee), default recipient (True/False) | |
| **ActiveAssigneeNotificationAdditionalRecipient** | Write | StringArray[] | Send notifications when members are assigned as active to this group: Notification to the assigned user (assignee), additional recipient (UPN) | |
| **ActiveAssigneeNotificationOnlyCritical** | Write | Boolean | Send notifications when members are assigned as active to this group: Notification to the assigned user (assignee), only critical Email (True/False) | |
| **ActiveApproveNotificationDefaultRecipient** | Write | Boolean | Send notifications when members are assigned as active to this group: Request to approve a group assignment renewal/extension, default recipient (True/False) | |
| **ActiveApproveNotificationAdditionalRecipient** | Write | StringArray[] | Send notifications when members are assigned as active to this group: Request to approve a group assignment renewal/extension, additional recipient (UPN) | |
| **ActiveApproveNotificationOnlyCritical** | Write | Boolean | Send notifications when members are assigned as active to this group: Request to approve a group assignment renewal/extension, only critical Email (True/False) | |
| **EligibleAssignmentAlertNotificationDefaultRecipient** | Write | Boolean | Send notifications when eligible members activate this group: Group assignment alert, default recipient (True/False) | |
| **EligibleAssignmentAlertNotificationAdditionalRecipient** | Write | StringArray[] | Send notifications when eligible members activate this group: Group assignment alert, additional recipient (UPN) | |
| **EligibleAssignmentAlertNotificationOnlyCritical** | Write | Boolean | Send notifications when eligible members activate this group: Group assignment alert, only critical Email (True/False) | |
| **EligibleAssignmentAssigneeNotificationDefaultRecipient** | Write | Boolean | Send notifications when eligible members activate this group: Notification to activated user (requestor), default recipient (True/False) | |
| **EligibleAssignmentAssigneeNotificationAdditionalRecipient** | Write | StringArray[] | Send notifications when eligible members activate this group: Notification to activated user (requestor), additional recipient (UPN) | |
| **EligibleAssignmentAssigneeNotificationOnlyCritical** | Write | Boolean | Send notifications when eligible members activate this group: Notification to activated user (requestor), only critical Email (True/False) | |
| **AuthenticationContextRequired** | Write | Boolean | Authorization context is required (True/False) | |
| **AuthenticationContextName** | Write | String | Descriptive name of associated authorization context | |
| **AuthenticationContextId** | Write | String | Authorization context id | |
| **Ensure** | Write | String | Specify if the Azure AD group setting should exist or not. | `Present` |
| **Credential** | Write | PSCredential | Credentials for the Microsoft Graph delegated permissions. | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory application to authenticate with. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

## Description

This resource configure existing PIM Groups. All UI parameters can be configured using this resource like:
- Notifications
- require approval / ticket / justification / MFA

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - AuthenticationContext.Read.All, Group.Read.All, RoleManagementPolicy.Read.Directory, User.Read.All

- **Update**

    - Group.Read.All, RoleManagementPolicy.ReadWrite.Directory, User.Read.All

#### Application permissions

- **Read**

    - Group.Read.All, RoleManagementPolicy.Read.Directory, User.Read.All

- **Update**

    - Group.Read.All, RoleManagementPolicy.ReadWrite.Directory, User.Read.All

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param(
         [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADPIMGroupSetting "AADPIMGroupSetting-test-group_owner"
        {
            ActivateApprover                                          = @();
            ActivationMaxDuration                                     = "PT8H";
            ActivationReqJustification                                = $True;
            ActivationReqMFA                                          = $False;
            ActivationReqTicket                                       = $false;
            ActiveAlertNotificationAdditionalRecipient                = @();
            ActiveAlertNotificationDefaultRecipient                   = $True;
            ActiveAlertNotificationOnlyCritical                       = $False;
            ActiveApproveNotificationAdditionalRecipient              = @("testuser@test.com");
            ActiveApproveNotificationDefaultRecipient                 = $True;
            ActiveApproveNotificationOnlyCritical                     = $False;
            ActiveAssigneeNotificationAdditionalRecipient             = @();
            ActiveAssigneeNotificationDefaultRecipient                = $False;
            ActiveAssigneeNotificationOnlyCritical                    = $False;
            ApprovaltoActivate                                        = $True;
            AssignmentReqJustification                                = $True;
            AssignmentReqMFA                                          = $False;
            AuthenticationContextId                                   = "";
            AuthenticationContextRequired                             = $false;
            DisplayName                                               = "test-group";
            ElegibilityAssignmentReqJustification                     = $False;
            ElegibilityAssignmentReqMFA                               = $False;
            EligibleAlertNotificationAdditionalRecipient              = @();
            EligibleAlertNotificationDefaultRecipient                 = $True;
            EligibleAlertNotificationOnlyCritical                     = $False;
            EligibleApproveNotificationAdditionalRecipient            = @();
            EligibleApproveNotificationDefaultRecipient               = $True;
            EligibleApproveNotificationOnlyCritical                   = $False;
            EligibleAssigneeNotificationAdditionalRecipient           = @();
            EligibleAssigneeNotificationDefaultRecipient              = $False;
            EligibleAssigneeNotificationOnlyCritical                  = $False;
            EligibleAssignmentAlertNotificationAdditionalRecipient    = @();
            EligibleAssignmentAlertNotificationDefaultRecipient       = $True;
            EligibleAssignmentAlertNotificationOnlyCritical           = $False;
            EligibleAssignmentAssigneeNotificationAdditionalRecipient = @();
            EligibleAssignmentAssigneeNotificationDefaultRecipient    = $True;
            EligibleAssignmentAssigneeNotificationOnlyCritical        = $False;
            ExpireActiveAssignment                                    = "P180D";
            ExpireEligibleAssignment                                  = "P365D";
            PermanentActiveAssignmentisExpirationRequired             = $True;
            PermanentEligibleAssignmentisExpirationRequired           = $True;
            RoleDefinitionId                                          = "owner";
            ApplicationId                 = $ApplicationId
            TenantId                      = $TenantId
            CertificateThumbprint         = $CertificateThumbprint
            Ensure                                                    = "Present";
        }
    }
}
```

### Example 2

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Import-DscResource -ModuleName Microsoft365DSC

    Node localhost
    {
        AADPIMGroupSetting "AADPIMGroupSetting-test-group_owner"
        {
            ActivateApprover                                          = @();
            ActivationMaxDuration                                     = "PT8H";
            ActivationReqJustification                                = $True;
            ActivationReqMFA                                          = $False;
            ActivationReqTicket                                       = $false;
            ActiveAlertNotificationAdditionalRecipient                = @();
            ActiveAlertNotificationDefaultRecipient                   = $True;
            ActiveAlertNotificationOnlyCritical                       = $False;
            ActiveApproveNotificationAdditionalRecipient              = @("testuser@test.com");
            ActiveApproveNotificationDefaultRecipient                 = $True;
            ActiveApproveNotificationOnlyCritical                     = $False;
            ActiveAssigneeNotificationAdditionalRecipient             = @();
            ActiveAssigneeNotificationDefaultRecipient                = $False;
            ActiveAssigneeNotificationOnlyCritical                    = $False;
            ApprovaltoActivate                                        = $True;
            AssignmentReqJustification                                = $True;
            AssignmentReqMFA                                          = $False;
            AuthenticationContextId                                   = "";
            AuthenticationContextRequired                             = $false;
            DisplayName                                               = "test-group";
            ElegibilityAssignmentReqJustification                     = $False;
            ElegibilityAssignmentReqMFA                               = $False;
            EligibleAlertNotificationAdditionalRecipient              = @();
            EligibleAlertNotificationDefaultRecipient                 = $True;
            EligibleAlertNotificationOnlyCritical                     = $False;
            EligibleApproveNotificationAdditionalRecipient            = @();
            EligibleApproveNotificationDefaultRecipient               = $True;
            EligibleApproveNotificationOnlyCritical                   = $False;
            EligibleAssigneeNotificationAdditionalRecipient           = @();
            EligibleAssigneeNotificationDefaultRecipient              = $False;
            EligibleAssigneeNotificationOnlyCritical                  = $False;
            EligibleAssignmentAlertNotificationAdditionalRecipient    = @();
            EligibleAssignmentAlertNotificationDefaultRecipient       = $True;
            EligibleAssignmentAlertNotificationOnlyCritical           = $False;
            EligibleAssignmentAssigneeNotificationAdditionalRecipient = @();
            EligibleAssignmentAssigneeNotificationDefaultRecipient    = $True;
            EligibleAssignmentAssigneeNotificationOnlyCritical        = $False;
            ExpireActiveAssignment                                    = "P180D";
            ExpireEligibleAssignment                                  = "P365D";
            PermanentActiveAssignmentisExpirationRequired             = $False;
            PermanentEligibleAssignmentisExpirationRequired           = $False;
            RoleDefinitionId                                          = "owner";
            ApplicationId                 = $ApplicationId
            TenantId                      = $TenantId
            CertificateThumbprint         = $CertificateThumbprint
            Ensure                                                    = "Present";
        }
    }
}
```

