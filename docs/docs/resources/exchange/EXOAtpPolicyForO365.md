# EXOAtpPolicyForO365

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Specifies the resource is a single instance, the value must be 'Yes' | `Yes` |
| **Identity** | Write | String | The Identity parameter specifies the ATP policy that you want to modify. There's only one policy named Default. | |
| **Ensure** | Write | String | Since there is only one policy, the default policy, this must be set to 'Present' | `Present` |
| **AllowSafeDocsOpen** | Write | Boolean | The AllowSafeDocsOpen parameter specifies whether users can click through and bypass the Protected View container even when Safe Documents identifies a file as malicious. | |
| **EnableATPForSPOTeamsODB** | Write | Boolean | The EnableATPForSPOTeamsODB parameter specifies whether ATP is enabled for SharePoint Online, OneDrive for Business and Microsoft Teams. Default is $false. | |
| **EnableSafeDocs** | Write | Boolean | The EnableSafeDocs parameter specifies whether to enable the Safe Documents feature in the organization. Default is $false. | |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

## Description

This resource configures the Advanced Threat Protection (ATP) policy
in Office 365.  Tenant must be subscribed to ATP.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Transport Hygiene, Security Admin, View-Only Configuration, Security Reader

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
        EXOAtpPolicyForO365 'ConfigureAntiPhishPolicy'
        {
            IsSingleInstance        = "Yes"
            EnableATPForSPOTeamsODB = $true
            Ensure                  = "Present"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
```

