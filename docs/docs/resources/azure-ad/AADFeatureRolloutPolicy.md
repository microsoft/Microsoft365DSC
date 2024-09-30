# AADFeatureRolloutPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Description** | Write | String | A description for this feature rollout policy. | |
| **DisplayName** | Key | String | The display name for this  feature rollout policy. | |
| **Feature** | Write | String | Possible values are: passthroughAuthentication, seamlessSso, passwordHashSync, emailAsAlternateId, unknownFutureValue, certificateBasedAuthentication. You must use the Prefer: include-unknown-enum-members request header to get the following value or values in this evolvable enum: certificateBasedAuthentication. For more information about the prerequisites for the enabled features, see Prerequisites for enabled features. | `passthroughAuthentication`, `seamlessSso`, `passwordHashSync`, `emailAsAlternateId`, `unknownFutureValue`, `certificateBasedAuthentication` |
| **IsAppliedToOrganization** | Write | Boolean | Indicates whether this feature rollout policy should be applied to the entire organization. | |
| **IsEnabled** | Write | Boolean | Indicates whether the feature rollout is enabled. | |
| **Id** | Write | String | The unique identifier for an entity. Read-only. | |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

Azure AD Policy Feature Rollout Policy

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Directory.Read.All

- **Update**

    - Directory.ReadWrite.All

#### Application permissions

- **Read**

    - Directory.Read.All

- **Update**

    - Directory.ReadWrite.All

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
        AADFeatureRolloutPolicy "AADFeatureRolloutPolicy-CertificateBasedAuthentication rollout policy"
        {
            ApplicationId           = $ApplicationId
            TenantId                = $TenantId
            CertificateThumbprint   = $CertificateThumbprint
            Description             = "CertificateBasedAuthentication rollout policy";
            DisplayName             = "CertificateBasedAuthentication rollout policy";
            Ensure                  = "Present";
            Feature                 = "certificateBasedAuthentication";
            IsAppliedToOrganization = $False;
            IsEnabled               = $True;
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
        AADFeatureRolloutPolicy "AADFeatureRolloutPolicy-CertificateBasedAuthentication rollout policy"
        {
            ApplicationId           = $ApplicationId
            TenantId                = $TenantId
            CertificateThumbprint   = $CertificateThumbprint
            Description             = "CertificateBasedAuthentication rollout policy";
            DisplayName             = "CertificateBasedAuthentication rollout policy";
            Ensure                  = "Present";
            IsAppliedToOrganization = $False;
            IsEnabled               = $False;
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
        AADFeatureRolloutPolicy "AADFeatureRolloutPolicy-CertificateBasedAuthentication rollout policy"
        {
            ApplicationId           = $ApplicationId
            TenantId                = $TenantId
            CertificateThumbprint   = $CertificateThumbprint
            DisplayName             = "CertificateBasedAuthentication rollout policy";
            Ensure                  = "Absent";
        }
    }
}
```

