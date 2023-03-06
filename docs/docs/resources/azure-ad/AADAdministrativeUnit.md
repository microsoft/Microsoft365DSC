﻿# AADAdministrativeUnit

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | DisplayName of the Administrative Unit | |
| **Id** | Write | String | Object-Id of the Administrative Unit | |
| **Description** | Write | String | Description of the Administrative Unit | |
| **Visibility** | Write | String | Visibility of the Administrative Unit. Specify HiddenMembership if members of the AU are hidden | |
| **MembershipType** | Write | String | Specify membership type. Possible values are Assigned and Dynamic. Note that the functionality is currently in preview. | |
| **MembershipRule** | Write | String | Specify membership rule. Requires that MembershipType is set to Dynamic. Note that the functionality is currently in preview. | |
| **MembershipRuleProcessingState** | Write | String | Specify dynamic membership-rule processing-state. Valid values are 'On' and 'Paused'. Requires that MembershipType is set to Dynamic. Note that the functionality is currently in preview. | |
| **Members** | Write | MSFT_MicrosoftGraphMember[] | Specify members. Only specify if MembershipType is NOT set to Dynamic | |
| **ScopedRoleMembers** | Write | MSFT_MicrosoftGraphScopedRoleMembership[] | Specify Scoped Role Membership. | |
| **Ensure** | Write | String | Present ensures the Administrative Unit exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Intune Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory application to authenticate with. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

### MSFT_MicrosoftGraphIdentity

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Write | String | Identity of member. For users, specify a UserPrincipalName. For groups and devices, specify DisplayName | |
| **Type** | Write | String | Specify User, Group or Device to interpret the identity. Can be Principal in ScopedRoleMembers | |

### MSFT_MicrosoftGraphScopedRoleMembership

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **RoleName** | Write | String | Name of the Azure AD Role that is assigned | |
| **RoleMemberInfo** | Write | MSFT_MicrosoftGraphIdentity | Member that is assigned the scoped role | |


## Description

This resource configures an Azure AD Administrative Unit.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - AdministrativeUnit.Read.All, RoleManagement.Read.Directory

- **Update**

    - AdministrativeUnit.Read.All, AdministrativeUnit.ReadWrite.All, Application.Read.All, Device.Read.All, Group.Read.All, RoleManagement.Read.Directory, User.Read.All

#### Application permissions

- **Read**

    - AdministrativeUnit.Read.All, RoleManagement.Read.Directory

- **Update**

    - AdministrativeUnit.Read.All, AdministrativeUnit.ReadWrite.All, Application.Read.All, Device.Read.All, Group.Read.All, RoleManagement.Read.Directory, User.Read.All

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

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
        AADAdministrativeUnit 'TestUnit'
        {
            DisplayName                   = 'Test-Unit'
            MembershipRule                = "(user.country -eq `"Canada`")"
            MembershipRuleProcessingState = 'On'
            MembershipType                = 'Dynamic'
            Ensure                        = 'Present'
            Credential                    = $credsGlobalAdmin
        }
    }
}
```

