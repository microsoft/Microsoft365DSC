# EXOReportSubmissionRule

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Specifies the resource is a single instance, the value must be 'Yes'. | `Yes` |
| **Identity** | Write | String | The Identity parameter specifies the report submission rule that you want to modify. | |
| **Comments** | Write | String | The Comments parameter specifies informative comments for the rule, such as what the rule is used for or how it has changed over time. | |
| **SentTo** | Write | StringArray[] | The SentTo parameter specifies the email address of the reporting mailbox in Exchange Online where user reported messages are sent. | |
| **Ensure** | Write | String | Specifies if this report submission rule should exist. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

Create or modify an EXOReportSubmissionRule in your cloud-based organization.

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
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOReportSubmissionRule 'ConfigureReportSubmissionRule'
        {
            IsSingleInstance    = 'Yes'
            Identity            = "DefaultReportSubmissionRule"
            Comments            = "This is my default rule"
            SentTo              = "submission@contoso.com"
            Ensure              = "Present"
            Credential          = $Credscredential
        }
    }
}
```

