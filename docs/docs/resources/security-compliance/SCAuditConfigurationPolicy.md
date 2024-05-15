# SCAuditConfigurationPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Workload** | Key | String | Workload associated with the policy. | `Exchange`, `SharePoint`, `OneDriveForBusiness` |
| **Ensure** | Write | String | Specify if this policy should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

## Description

This resource configures an Audit ConfigurationPolicy
in Security and Compliance Center.

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

    - None

- **Update**

    - None

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
        SCAuditConfigurationPolicy 'ExchangeAuditPolicy'
        {
            Workload           = "Exchange"
            Ensure             = "Present"
            Credential         = $Credscredential
        }

        SCAuditConfigurationPolicy 'OneDriveAuditPolicy'
        {
            Workload           = "OneDriveForBusiness"
            Ensure             = "Present"
            Credential         = $Credscredential
        }

        SCAuditConfigurationPolicy 'SharePointAuditPolicy'
        {
            Workload           = "SharePoint"
            Ensure             = "Present"
            Credential         = $Credscredential
        }
    }
}
```

