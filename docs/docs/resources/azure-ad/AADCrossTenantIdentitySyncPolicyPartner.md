# AADCrossTenantIdentitySyncPolicyPartner

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **CrossTenantAccessPolicyConfigurationPartnerTenantId** | Key | String | Id of the associated partner tenant ID. | |
| **DisplayName** | Write | String | Display name for the cross-tenant user synchronization policy. Use the name of the partner Microsoft Entra tenant to easily identify the policy. | |
| **IsSyncAllowed** | Write | Boolean | Defines whether user objects should be synchronized from the partner tenant. False causes any current user synchronization from the source tenant to the target tenant to stop. This property has no impact on existing users who have already been synchronized. | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Absent`, `Present` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

Create a cross-tenant user synchronization policy for a partner-specific configuration.

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
        AADCrossTenantIdentitySyncPolicyPartner "AADCrossTenantIdentitySyncPolicyPartner-Fabrikam"
        {
            ApplicationId                                       = $ApplicationId;
            CertificateThumbprint                               = $CertificateThumbprint;
            CrossTenantAccessPolicyConfigurationPartnerTenantId = "e7a80bcf-696e-40ca-8775-a7f85fbb3ebc";
            DisplayName                                         = "IdentitySync";
            Ensure                                              = "Present";
            IsSyncAllowed                                       = $True;
            TenantId                                            = $TenantId;
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
        AADCrossTenantIdentitySyncPolicyPartner "AADCrossTenantIdentitySyncPolicyPartner-Fabrikam"
        {
            ApplicationId                                       = $ApplicationId;
            CertificateThumbprint                               = $CertificateThumbprint;
            CrossTenantAccessPolicyConfigurationPartnerTenantId = "e7a80bcf-696e-40ca-8775-a7f85fbb3ebc";
            DisplayName                                         = "IdentitySync";
            Ensure                                              = "Present";
            IsSyncAllowed                                       = $False;
            TenantId                                            = $TenantId;
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
        AADCrossTenantIdentitySyncPolicyPartner "AADCrossTenantIdentitySyncPolicyPartner-Fabrikam"
        {
            ApplicationId                                       = $ApplicationId;
            CertificateThumbprint                               = $CertificateThumbprint;
            CrossTenantAccessPolicyConfigurationPartnerTenantId = "e7a80bcf-696e-40ca-8775-a7f85fbb3ebc";
            DisplayName                                         = "IdentitySync";
            Ensure                                              = "Absent";
            IsSyncAllowed                                       = $True;
            TenantId                                            = $TenantId;
        }
    }
}
```

