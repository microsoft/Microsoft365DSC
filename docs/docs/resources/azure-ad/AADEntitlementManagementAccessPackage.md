# AADEntitlementManagementAccessPackage

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Id** | Write | String | The Id of the resource roleScope. ||
| **AccessPackageResourceOriginId** | Write | String | The origine Id of the resource. ||
| **AccessPackageResourceRoleDisplayName** | Write | String | The display name of the resource role. ||
| **Id** | Write | String | The Id of the access package. ||
| **CatalogId** | Write | String | Identifier of the access package catalog referencing this access package. ||
| **Description** | Write | String | The description of the access package. ||
| **DisplayName** | Write | String | The display name of the access package. ||
| **IsHidden** | Write | Boolean | Whether the access package is hidden from the requestor. ||
| **IsRoleScopesVisible** | Write | Boolean | Indicates whether role scopes are visible. ||
| **AccessPackageResourceRoleScopes** | Write | InstanceArray[] | The resources and roles included in the access package. ||
| **IncompatibleAccessPackages** | Write | StringArray[] | The access packages whose assigned users are ineligible to be assigned this access package. ||
| **AccessPackagesIncompatibleWith** | Write | StringArray[] | The access packages that are incompatible with this package. ||
| **IncompatibleGroups** | Write | StringArray[] | The groups whose members are ineligible to be assigned this access package. ||
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Intune Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. ||


# AADEntitlementManagementAccessPackage

### Description

This resource configures an A A D Entitlement Management Access Package.


