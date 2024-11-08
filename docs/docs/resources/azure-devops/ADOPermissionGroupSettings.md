# ADOPermissionGroupSettings

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **GroupName** | Key | String | Name of the group. | |
| **OrganizationName** | Write | String | Name of the DevOPS Organization. | |
| **Descriptor** | Write | String | Descriptor for the group. | |
| **AllowPermissions** | Write | MSFT_ADOPermission[] | Allow permissions. | |
| **DenyPermissions** | Write | MSFT_ADOPermission[] | Deny permissions | |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

### MSFT_ADOPermission

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **NamespaceId** | Write | String | Id of the associate security namespace. | |
| **DisplayName** | Write | String | Display name of the permission scope. | |
| **Bit** | Write | UInt32 | Bit mask for the permission | |
| **Token** | Write | String | Token value | |


## Description

Manages permissions in Azure DevOPS.

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

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param(
        [Parameter()]
        [PSCredential]
        $Credential
    )
    Import-DscResource -ModuleName Microsoft365DSC
    node localhost
    {
        ADOPermissionGroupSettings "ADOPermissionGroupSettings-O365DSC-DEV"
        {
            AllowPermissions     = @(
                MSFT_ADOPermission {
                    NamespaceId = '5a27515b-ccd7-42c9-84f1-54c998f03866'
                    DisplayName = 'Edit identity information'
                    Bit         = '2'
                    Token       = 'f6492b10-7ae8-4641-8208-ff5c364a6154\dbe6034e-8fbe-4d6e-a7f3-07a7e70816c9'
                }
            );
            Credential           = $Credential;
            DenyPermissions      = @();
            Descriptor           = "vssgp.Uy0xLTktMTU1MTM3NDI0NS0yNzEyNzI0MzgtMzkwMDMyNjIxNC0yMTgxNjI3NzQwLTkxMDg0NDI0NC0xLTgyODcyNzAzNC0yOTkzNjA0MTcxLTI5MjUwMjk4ODgtNTY0MDg1OTcy";
            GroupName            = "[O365DSC-DEV]\My Test Group";
            OrganizationName     = "O365DSC-DEV";
        }
    }
}
```

