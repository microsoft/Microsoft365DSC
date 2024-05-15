# SCCaseHoldRule

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies a unique name for the case hold rule. | |
| **Policy** | Key | String | The Policy parameter specifies the case hold policy that contains the rule. You can use any value that uniquely identifies the policy. | |
| **Comment** | Write | String | The Comment parameter specifies an optional comment. | |
| **ContentMatchQuery** | Write | String | The ContentMatchQuery parameter specifies a content search filter. Use this parameter to create a query-based hold so only the content that matches the specified search query is placed on hold. This parameter uses a text search string or a query that's formatted by using the Keyword Query Language (KQL). | |
| **Disabled** | Write | Boolean | The Disabled parameter specifies whether the case hold rule is enabled or disabled. | |
| **Ensure** | Write | String | Present ensures the rule exists, absent ensures it is removed | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Global Admin Account | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

## Description

This resource configures an eDiscovery Case Hold Rule
in Security and Compliance.

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
        SCCaseHoldRule 'ConfigureCaseHoldRule'
        {
            Name               = "My Rule"
            Policy             = "My Policy"
            Comment            = "This is a demo rule"
            Disabled           = $false
            ContentMatchQuery  = "filename:2016 budget filetype:xlsx"
            Ensure             = "Present"
            Credential         = $Credscredential
        }
    }
}
```

