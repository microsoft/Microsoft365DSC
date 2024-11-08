# EXODataAtRestEncryptionPolicyAssignment

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Only valid value is 'Yes'. | `Yes` |
| **DataEncryptionPolicy** | Write | String | The DataEncryptionPolicy parameter specifies the Microsoft 365 data-at-rest encryption policy. | |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

## Description

Use the Set-M365DataAtRestEncryptionPolicyAssignment cmdlet to assign a Microsoft 365 data-at-rest encryption policy at the tenant level.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Compliance Admin

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
        EXODataAtRestEncryptionPolicyAssignment "M365DataAtRestEncryptionPolicyAssignment"
        {
            DataEncryptionPolicy          = "Riyansh_Policy"
            IsSingleInstance              = "Yes";
            ApplicationId                 = $ApplicationId
            TenantId                      = $TenantId
            CertificateThumbprint         = $CertificateThumbprint
        }

    }
}
```

