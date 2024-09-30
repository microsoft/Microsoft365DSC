# AADEntitlementManagementRoleAssignment

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Id** | Write | String | Unique Id of the role assignment. | |
| **Principal** | Key | String | Identifier of the principal to which the assignment is granted. | |
| **RoleDefinition** | Key | String | Identifier of the unifiedRoleDefinition the assignment is for. | |
| **AppScopeId** | Write | String | Identifier of the app specific scope when the assignment scope is app specific. The scope of an assignment determines the set of resources for which the principal has been granted access. App scopes are scopes that are defined and understood by a resource application only. | |
| **DirectoryScopeId** | Write | String | Identifier of the directory object representing the scope of the assignment. The scope of an assignment determines the set of resources for which the principal has been granted access. Directory scopes are shared scopes stored in the directory that are understood by multiple applications, unlike app scopes that are defined and understood by a resource application only. | |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Intune Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

This resource configures an Azure AD Entitlement Management Role assignments.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - EntitlementManagement.Read.All

- **Update**

    - EntitlementManagement.Read.All, EntitlementManagement.ReadWrite.All

#### Application permissions

- **Read**

    - EntitlementManagement.Read.All

- **Update**

    - EntitlementManagement.Read.All, EntitlementManagement.ReadWrite.All, RoleManagement.ReadWrite.Directory

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
        AADEntitlementManagementRoleAssignment "AADEntitlementManagementRoleAssignment-Create"
        {
            AppScopeId      = "/";
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            Ensure          = "Present";
            Principal       = "AdeleV@$TenantId";
            RoleDefinition  = "Catalog creator";
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

    node localhost
    {
        AADEntitlementManagementRoleAssignment "AADEntitlementManagementRoleAssignment-Remove"
        {
            AppScopeId      = "/";
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            Ensure          = "Absent";
            Principal       = "AdeleV@$TenantId";
            RoleDefinition  = "Catalog creator";
        }
    }
}
```

