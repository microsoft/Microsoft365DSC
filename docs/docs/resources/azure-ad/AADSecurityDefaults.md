# AADSecurityDefaults

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Only valid value is 'Yes'. | `Yes` |
| **DisplayName** | Write | String | Display name of the security defaults. | |
| **Description** | Write | String | Description of the security defaults. | |
| **IsEnabled** | Write | Boolean | Represents whether or not security defaults are enabled. | |
| **Ensure** | Write | String | Specify if the Azure AD App should exist or not. | `Present`, `Absent` |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory application to authenticate with. | |
| **Credential** | Write | PSCredential | Credentials of the Azure AD Admin | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource configures the Security Defaults in Azure Active Directory.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Policy.Read.All

- **Update**

    - Policy.ReadWrite.ConditionalAccess

#### Application permissions

- **Read**

    - Policy.Read.All

- **Update**

    - Policy.ReadWrite.ConditionalAccess

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
        AADSecurityDefaults 'Defaults'
        {
            Credential           = $Credscredential;
            Description          = "Security defaults is a set of basic identity security mechanisms recommended by Microsoft. When enabled, these recommendations will be automatically enforced in your organization. Administrators and users will be better protected from common identity related attacks.";
            DisplayName          = "Security Defaults";
            IsEnabled            = $False;
            IsSingleInstance     = "Yes";
        }
    }
}
```

