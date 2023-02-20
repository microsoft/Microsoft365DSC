# AADAdministrativeUnit

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | DisplayName of the Administrative Unit | |
| **Id** | Write | String | Object-Id of the Administrative Unit | |
| **Description** | Write | String | Description of the Administrative Unit | |
| **Visibility** | Write | String | Visibility of the Administrative Unit. Specify HiddenMembership if members of the AU are hidden | |
| **MembershipType** | Write | String | Specify membership type. Possible values are Assigned and Dynamic if the AU-preview has been activated. Otherwise do not use | |
| **MembershipRule** | Write | String | Specify membership rule. Requires that MembershipType is set to Dynamic AND the AU-preview has been activated. Otherwise, do not use | |
| **MembershipRuleProcessingState** | Write | String | Specify dynamic membership-rule processing-state. Valid values are 'On' and 'Paused'. Requires that MembershipType is set to Dynamic AND the AU-preview has been activated. Otherwise, do not use | |
| **Members** | Write | MSFT_MicrosoftGraphIdentity[] | Specify members. Only specify if MembershipType is set to Static | |
| **ScopedRoleMembers** | Write | MSFT_MicrosoftGraphScopedRoleMembership[] | | |
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
| **Identity** | Write | String | Identity of direcory-object. For users, specify a UserPrincipalName. For Groups and SPNs, specify DisplayName | |
| **Type** | Write | String | Specify User, Group or ServicePrincipal to interpret the Identity | |

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
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsCredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADAdministrativeUnit 'TestUnit'
        {
            Credential                    = $credsCredential;
            DisplayName                   = "Test-Unit";
            Ensure                        = "Present";
            MembershipRule                = "(user.country -eq `"Canada`")";
            MembershipRuleProcessingState = "On";
            MembershipType                = "Dynamic";
        }
    }
}
```

