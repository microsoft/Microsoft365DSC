# AADEntitlementManagementSettings

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Only accepted value is 'Yes'. | `Yes` |
| **DaysUntilExternalUserDeletedAfterBlocked** | Write | UInt32 | If externalUserLifecycleAction is blockSignInAndDelete, the duration, typically many days, after an external user is blocked from sign in before their account is deleted. | |
| **ExternalUserLifecycleAction** | Write | String | Automatic action that the service should take when an external user's last access package assignment is removed. The possible values are: none, blockSignIn, blockSignInAndDelete, unknownFutureValue. | |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

Manages Entra Id Entitlement Management settings.

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
        AADEntitlementManagementSettings "AADEntitlementManagementSettings"
        {
            ApplicationId                            = $ApplicationId;
            CertificateThumbprint                    = $CertificateThumbprint;
            DaysUntilExternalUserDeletedAfterBlocked = 30;
            ExternalUserLifecycleAction              = "blockSignInAndDelete";
            IsSingleInstance                         = "Yes";
            TenantId                                 = $TenantId;
        }
    }
}
```

