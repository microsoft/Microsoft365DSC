# AADMultiTenantOrganizationIdentitySyncPolicyTemplate

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Only valid value is 'Yes'. | `Yes` |
| **TemplateApplicationLevel** | Write | String | Specifies whether the template will be applied to user synchronization settings of certain tenants. The possible values are: none, newPartners, existingPartners, unknownFutureValue. You can also specify multiple values like newPartners,existingPartners (default). none indicates the template is not applied to any new or existing partner tenants. newPartners indicates the template is applied to new partner tenants. existingPartners indicates the template is applied to existing partner tenants, those who already had partner-specific user synchronization settings in place. | |
| **UserSyncInbound** | Write | MSFT_AADMultiTenantOrganizationIdentitySyncPolicyTemplateUserSyncInbound | Determines whether users can be synchronized from the partner tenant. false causes any current user synchronization from the source tenant to the target tenant to stop. This property has no impact on existing users who have already been synchronized. | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Absent`, `Present` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

### MSFT_AADMultiTenantOrganizationIdentitySyncPolicyTemplateUserSyncInbound

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **isSyncAllowed** | Write | Boolean | Defines whether user objects should be synchronized from the partner tenant. false causes any current user synchronization from the source tenant to the target tenant to stop. This property has no impact on existing users who have already been synchronized. | |


## Description

Defines an optional cross-tenant access policy template with user synchronization settings for multitenant organization tenants.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Policy.Read.All

- **Update**

    - Policy.ReadWrite.CrossTenantAccess

#### Application permissions

- **Read**

    - Policy.Read.All

- **Update**

    - Policy.ReadWrite.CrossTenantAccess

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
        AADMultiTenantOrganizationIdentitySyncPolicyTemplate "AADMultiTenantOrganizationIdentitySyncPolicyTemplate"
        {
            ApplicationId            = $ApplicationId;
            CertificateThumbprint    = $CertificateThumbprint;
            Ensure                   = "Present";
            IsSingleInstance         = "Yes";
            TemplateApplicationLevel = "newPartners,existingPartners";
            TenantId                 = $TenantId;
            UserSyncInbound          = MSFT_AADMultiTenantOrganizationIdentitySyncPolicyTemplateUserSyncInbound{
                isSyncAllowed = $True
            };
        }
    }
}
```

