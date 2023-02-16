# AADEntitlementManagementAccessPackageCatalog

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Id** | Write | String | The id of the access package catalog. | |
| **CatalogStatus** | Write | String | Has the value Published if the access packages are available for management. | |
| **CatalogType** | Write | String | One of UserManaged or ServiceDefault. | `UserManaged`, `ServiceDefault` |
| **Description** | Write | String | The description of the access package catalog. | |
| **DisplayName** | Write | String | The display name of the access package catalog. | |
| **IsExternallyVisible** | Write | Boolean | Whether the access packages in this catalog can be requested by users outside of the tenant. | |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Intune Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |


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


