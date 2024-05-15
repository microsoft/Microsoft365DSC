# AADEntitlementManagementAccessPackageCatalog

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | The display name of the access package catalog. | |
| **Id** | Write | String | The id of the access package catalog. | |
| **CatalogStatus** | Write | String | Has the value Published if the access packages are available for management. | |
| **CatalogType** | Write | String | One of UserManaged or ServiceDefault. | `UserManaged`, `ServiceDefault` |
| **Description** | Write | String | The description of the access package catalog. | |
| **IsExternallyVisible** | Write | Boolean | Whether the access packages in this catalog can be requested by users outside of the tenant. | |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Intune Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

This resource configures an Azure AD Entitlement Management Access Package Catalog.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - EntitlementManagement.Read.All

- **Update**

    - EntitlementManagement.ReadWrite.All

#### Application permissions

- **Read**

    - EntitlementManagement.Read.All

- **Update**

    - EntitlementManagement.ReadWrite.All

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
        AADEntitlementManagementAccessPackageCatalog 'myAccessPackageCatalog'
        {
            DisplayName         = 'My Catalog'
            CatalogStatus       = 'Published'
            CatalogType         = 'UserManaged'
            Description         = 'Built-in catalog.'
            IsExternallyVisible = $True
            Managedidentity     = $False
            Ensure              = 'Present'
            Credential          = $Credscredential
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
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADEntitlementManagementAccessPackageCatalog 'myAccessPackageCatalog'
        {
            DisplayName         = 'My Catalog'
            CatalogStatus       = 'Published'
            CatalogType         = 'UserManaged'
            Description         = 'Built-in catalog.'
            IsExternallyVisible = $False # Updated Property
            Managedidentity     = $False
            Ensure              = 'Present'
            Credential          = $Credscredential
        }
    }
}
```

### Example 3

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
        AADEntitlementManagementAccessPackageCatalog 'myAccessPackageCatalog'
        {
            DisplayName         = 'My Catalog'
            Ensure              = 'Absent'
            Credential          = $Credscredential
        }
    }
}
```

