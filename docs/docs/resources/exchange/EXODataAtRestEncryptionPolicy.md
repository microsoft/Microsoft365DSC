# EXODataAtRestEncryptionPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the data-at-rest encryption policy that you want to modify. | |
| **Name** | Write | String | The Name parameter specifies a unique name for the Microsoft 365 data-at-rest encryption policy. | |
| **Description** | Write | String | The Description parameter specifies an optional description for the policy. | |
| **Enabled** | Write | Boolean | The Enabled parameter specifies whether the policy is enabled or disabled.  | |
| **AzureKeyIDs** | Write | StringArray[] | The AzureKeyIDs parameter specifies the URL of the encryption key in the Azure Key Vault that's used for encryption. | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Absent`, `Present` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

## Description

Microsoft 365 data-at-rest encryption policy for multi-workload usage.

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
        EXODataAtRestEncryptionPolicy "M365DataAtRestEncryptionPolicy-Riyansh_Policy"
        {
            AzureKeyIDs          = @("https://m365dataatrestencryption.vault.azure.net/keys/EncryptionKey","https://m365datariyansh.vault.azure.net/keys/EncryptionRiyansh");
            Description          = "Tenant default policy 1";
            Enabled              = $True;
            Ensure               = "Present";
            Identity             = "Riyansh_Policy";
            Name                 = "Riyansh_Policy";
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
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
        EXODataAtRestEncryptionPolicy "M365DataAtRestEncryptionPolicy-Riyansh_Policy"
        {
            AzureKeyIDs          = @("https://m365dataatrestencryption.vault.azure.net/keys/EncryptionKey","https://m365datariyansh.vault.azure.net/keys/EncryptionRiyansh");
            Description          = "Tenant default policy 2"; # drift
            Enabled              = $True;
            Ensure               = "Present";
            Identity             = "Riyansh_Policy";
            Name                 = "Riyansh_Policy";
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
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
        EXODataAtRestEncryptionPolicy "M365DataAtRestEncryptionPolicy-Riyansh_Policy"
        {
            AzureKeyIDs          = @("https://m365dataatrestencryption.vault.azure.net/keys/EncryptionKey","https://m365datariyansh.vault.azure.net/keys/EncryptionRiyansh");
            Description          = "Tenant default policy 1";
            Enabled              = $True;
            Ensure               = "Absent";
            Identity             = "Riyansh_Policy";
            Name                 = "Riyansh_Policy";
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
```

