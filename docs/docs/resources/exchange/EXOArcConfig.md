# EXOArcConfig

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Only valid value is 'Yes'. | `Yes` |
| **Identity** | Write | String | Identity which indicates the organization. | |
| **ArcTrustedSealers** | Write | StringArray[] | The domain names of the ARC sealers. | |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

This resource manages the list of trusted Authenticated Received Chain (ARC) sealers that are configured in the organization.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Security Admin, Security Reader, Tenant AllowBlockList Manager, Transport Hygiene, View-Only Configuration

#### Role Groups

- Organization Management

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
        EXOArcConfig "EXOArcConfig-Test"
        {
            ArcTrustedSealers                        = "contoso.com";
            IsSingleInstance                         = "Yes";
            TenantId                                 = $TenantId;
            CertificateThumbprint                    = $CertificateThumbprint;
            ApplicationId                            = $ApplicationId;
        }
    }
}
```

