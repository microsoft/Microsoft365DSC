# TeamsGroupPolicyAssignment

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **GroupDisplayName** | Key | String | Group Displayname of the group the policys are assigned to | |
| **GroupId** | Key | String | GroupId, alternatively to Group Displayname | |
| **PolicyType** | Key | String | Teams PolicyType. The type of the policy to be assigned. Possible values: | `CallingLineIdentity`, `TeamsAppSetupPolicy`, `TeamsAudioConferencingPolicy`, `TeamsCallingPolicy`, `TeamsCallParkPolicy`, `TeamsChannelsPolicy`, `TeamsComplianceRecordingPolicy`, `TenantDialPlan`, `TeamsMeetingBroadcastPolicy`, `TeamsMeetingPolicy`, `TeamsMessagingPolicy`, `TeamsShiftsPolicy`, `TeamsUpdateManagementPolicy`, `TeamsVerticalPackagePolicy` |
| **PolicyName** | Write | String | Teams PolicyName. The name of the policy to be assigned. | |
| **Priority** | Write | String | Teams Priority. The rank of the policy assignment, relative to other group policy assignments for the same policy type | |
| **Ensure** | Write | String | Present ensures the group policy assignment exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Teams Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |

## Description

This resource is used to assign Teams policy to a specified group

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - None

- **Update**

    - None

#### Application permissions

- **Read**

    - None

- **Update**

    - None

## Examples

### Example 1

This examples configure a TeamsGroupPolicyAssignment.

```powershell
Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )

    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        TeamsGroupPolicyAssignment 'TeamsGroupPolicyAssignment'
        {
            Ensure           = 'Present'
            GroupDisplayname = 'SecGroup'
            GroupId          = ''
            PolicyName       = 'AllowCalling'
            PolicyType       = 'TeamsCallingPolicy'
            Priority         = 1
            Credential       = $credsGlobalAdmin
        }
    }
}
```

