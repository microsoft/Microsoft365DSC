# AADRoleSetting

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Displayname** | Key | String | RuleDefinition Displayname | |
| **Id** | Write | String | Specifies the RoleId. | |
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
| **EligibleAlertNotificationDefaultRecipient** | Write | Boolean | Send notifications when members are assigned as eligible to this role: Role assignment alert, default recipient (True/False) | |
| **EligibleAlertNotificationAdditionalRecipient** | Write | StringArray[] | Send notifications when members are assigned as eligible to this role: Role assignment alert, additional recipient (UPN) | |
| **EligibleAlertNotificationOnlyCritical** | Write | Boolean | Send notifications when members are assigned as eligible to this role: Role assignment alert, only critical Email (True/False) | |
| **EligibleAssigneeNotificationDefaultRecipient** | Write | Boolean | Send notifications when members are assigned as eligible to this role: Notification to the assigned user (assignee), default recipient (True/False) | |
| **EligibleAssigneeNotificationAdditionalRecipient** | Write | StringArray[] | Send notifications when members are assigned as eligible to this role: Notification to the assigned user (assignee), additional recipient (UPN) | |
| **EligibleAssigneeNotificationOnlyCritical** | Write | Boolean | Send notifications when members are assigned as eligible to this role: Notification to the assigned user (assignee), only critical Email (True/False) | |
| **EligibleApproveNotificationDefaultRecipient** | Write | Boolean | Send notifications when members are assigned as eligible to this role: Request to approve a role assignment renewal/extension, default recipient (True/False) | |
| **EligibleApproveNotificationAdditionalRecipient** | Write | StringArray[] | Send notifications when members are assigned as eligible to this role: Request to approve a role assignment renewal/extension, additional recipient (UPN) | |
| **EligibleApproveNotificationOnlyCritical** | Write | Boolean | Send notifications when members are assigned as eligible to this role: Request to approve a role assignment renewal/extension, only critical Email (True/False) | |
| **ActiveAlertNotificationDefaultRecipient** | Write | Boolean | Send notifications when members are assigned as active to this role: Role assignment alert, default recipient (True/False) | |
| **ActiveAlertNotificationAdditionalRecipient** | Write | StringArray[] | Send notifications when members are assigned as active to this role: Role assignment alert, additional recipient (UPN) | |
| **ActiveAlertNotificationOnlyCritical** | Write | Boolean | Send notifications when members are assigned as active to this role: Role assignment alert, only critical Email (True/False) | |
| **ActiveAssigneeNotificationDefaultRecipient** | Write | Boolean | Send notifications when members are assigned as active to this role: Notification to the assigned user (assignee), default recipient (True/False) | |
| **ActiveAssigneeNotificationAdditionalRecipient** | Write | StringArray[] | Send notifications when members are assigned as active to this role: Notification to the assigned user (assignee), additional recipient (UPN) | |
| **ActiveAssigneeNotificationOnlyCritical** | Write | Boolean | Send notifications when members are assigned as active to this role: Notification to the assigned user (assignee), only critical Email (True/False) | |
| **ActiveApproveNotificationDefaultRecipient** | Write | Boolean | Send notifications when members are assigned as active to this role: Request to approve a role assignment renewal/extension, default recipient (True/False) | |
| **ActiveApproveNotificationAdditionalRecipient** | Write | StringArray[] | Send notifications when members are assigned as active to this role: Request to approve a role assignment renewal/extension, additional recipient (UPN) | |
| **ActiveApproveNotificationOnlyCritical** | Write | Boolean | Send notifications when members are assigned as active to this role: Request to approve a role assignment renewal/extension, only critical Email (True/False) | |
| **EligibleAssignmentAlertNotificationDefaultRecipient** | Write | Boolean | Send notifications when eligible members activate this role: Role assignment alert, default recipient (True/False) | |
| **EligibleAssignmentAlertNotificationAdditionalRecipient** | Write | StringArray[] | Send notifications when eligible members activate this role: Role assignment alert, additional recipient (UPN) | |
| **EligibleAssignmentAlertNotificationOnlyCritical** | Write | Boolean | Send notifications when eligible members activate this role: Role assignment alert, only critical Email (True/False) | |
| **EligibleAssignmentAssigneeNotificationDefaultRecipient** | Write | Boolean | Send notifications when eligible members activate this role: Notification to activated user (requestor), default recipient (True/False) | |
| **EligibleAssignmentAssigneeNotificationAdditionalRecipient** | Write | StringArray[] | Send notifications when eligible members activate this role: Notification to activated user (requestor), additional recipient (UPN) | |
| **EligibleAssignmentAssigneeNotificationOnlyCritical** | Write | Boolean | Send notifications when eligible members activate this role: Notification to activated user (requestor), only critical Email (True/False) | |
| **Ensure** | Write | String | Specify if the Azure AD role setting should exist or not. | `Present` |
| **Credential** | Write | PSCredential | Credentials for the Microsoft Graph delegated permissions. | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory application to authenticate with. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource configure existing Azure roles. All UI parameters can be configured using this resource like:
- Notifications
- require approval / ticket / justification / MFA

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Group.Read.All, RoleManagement.Read.Directory, RoleManagementPolicy.Read.Directory, User.Read.All

- **Update**

    - Group.Read.All, RoleManagementPolicy.Read.Directory, User.Read.All

#### Application permissions

- **Read**

    - Group.Read.All, RoleManagement.Read.Directory, RoleManagementPolicy.Read.Directory, User.Read.All

- **Update**

    - Group.Read.All, RoleManagementPolicy.Read.Directory, User.Read.All

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    Node localhost
    {
        AADRoleSetting 28b253d8-cde5-471f-a331-fe7320023cdd
        {
            ActivateApprover                                          = @();
            ActivationMaxDuration                                     = "PT8H";
            ActivationReqJustification                                = $False; # Updated Property
            ActivationReqMFA                                          = $False;
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
            ApprovaltoActivate                                        = $False;
            AssignmentReqJustification                                = $True;
            AssignmentReqMFA                                          = $False;
            Displayname                                               = "Application Administrator";
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
            PermanentActiveAssignmentisExpirationRequired             = $False;
            PermanentEligibleAssignmentisExpirationRequired           = $False;
            Credential                                                = $Credscredential
            Ensure                                                    = 'Present'
        }
    }
}
```

