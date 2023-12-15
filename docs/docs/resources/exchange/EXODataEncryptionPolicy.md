# EXODataEncryptionPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the data encryption policy that you want to modify. | |
| **AzureKeyIDs** | Write | StringArray[] | The AzureKeyIDs parameter specifies the URI values of the Azure Key Vault keys to associate with the data encryption policy. | |
| **Description** | Write | String | The Description parameter specifies an optional description for the data encryption policy | |
| **Enabled** | Write | Boolean | The Enabled parameter enables or disable the data encryption policy. | |
| **Name** | Write | String | The Name parameter specifies the unique name for the data encryption policy. | |
| **PermanentDataPurgeContact** | Write | String | The PermanentDataPurgeContact parameter specifies a contact for the purge of all data that's encrypted by the data encryption policy. | |
| **PermanentDataPurgeReason** | Write | String | The PermanentDataPurgeReason parameter specifies a descriptive reason for the purge of all data that's encrypted by the data encryption policy | |
| **Ensure** | Write | String | Specifies if this policy should exist. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

Create a new Data Encryption policy in your cloud-based organization.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Recipient Policies, Mail Recipient Creation, View-Only Configuration

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
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXODataEncryptionPolicy 'ConfigureDataEncryptionPolicy'
        {
            Identity    = 'US Mailboxes'
            Name        = 'All US Mailboxes'
            Description = 'All Mailboxes of users in the US'
            Enabled     = $true
            Ensure      = "Present"
            Credential  = $Credscredential
        }
    }
}
```

