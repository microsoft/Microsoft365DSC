# SCSupervisoryReviewPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies the unique name for the supervisory review policy. The name can't exceed 64 characters. If the value contains spaces, enclose the value in quotation marks. | |
| **Comment** | Write | String | The Comment parameter specifies an optional comment. If you specify a value that contains spaces, enclose the value in quotation marks. | |
| **Reviewers** | Required | StringArray[] | The Reviewers parameter specifies the SMTP addresses of the reviewers for the supervisory review policy. You can specify multiple email addresses separated by commas. | |
| **Ensure** | Write | String | Specify if this rule should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

## Description

This resource configures a Supervision Policy in Security and Compliance.

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

    Node localhost
    {
        SCSupervisoryReviewPolicy 'SupervisoryReviewPolicy'
        {
            Name       = "MyPolicy"
            Comment    = "Test Policy"
            Reviewers  = @("admin@contoso.com")
            Ensure     = "Present"
            Credential = $Credscredential
        }
    }
}
```

