# AADRoleDefinition

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | Specifies a display name for the role definition. | |
| **Id** | Write | String | Specifies Id for the role definition. | |
| **Description** | Write | String | Specifies a description for the role definition. | |
| **ResourceScopes** | Write | StringArray[] | Specifies the resource scopes for the role definition. | |
| **IsEnabled** | Required | Boolean | Specifies whether the role definition is enabled. | |
| **RolePermissions** | Required | StringArray[] | Specifies permissions for the role definition. | |
| **TemplateId** | Write | String | Specifies template id for the role definition. | |
| **Version** | Write | String | Specifies version for the role definition. | |
| **Ensure** | Write | String | Specify if the Azure AD Role definition should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Azure AD Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory application to authenticate with. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource configures an Azure Active Directory role definition.
To configure custom roles you require an Azure AD Premium P1 license.
The account used to configure role definitions based on this resource needs either to be a
"Global Administrator" or a "Privileged role administrator".

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - RoleManagement.Read.Directory

- **Update**

    - RoleManagement.ReadWrite.Directory

#### Application permissions

- **Read**

    - RoleManagement.Read.Directory

- **Update**

    - RoleManagement.ReadWrite.Directory

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

    node localhost
    {
        AADRoleDefinition 'AADRoleDefinition1'
        {
            DisplayName                   = "DSCRole1"
            Description                   = "DSC created role definition"
            ResourceScopes                = "/"
            IsEnabled                     = $true
            RolePermissions               = "microsoft.directory/applicationPolicies/allProperties/read","microsoft.directory/applicationPolicies/allProperties/update","microsoft.directory/applicationPolicies/basic/update"
            Version                       = "1.0"
            Ensure                        = "Present"
            Credential                    = $Credscredential
        }
    }
}
```

