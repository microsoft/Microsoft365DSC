# EXOJournalRule

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | Name of the Journal Rule | |
| **JournalEmailAddress** | Key | String | The JournalEmailAddress parameter specifies a recipient object to which journal reports are sent. You can use any value that uniquely identifies the recipient. | |
| **Recipient** | Write | String | The Recipient parameter specifies the SMTP address of a mailbox, contact, or distribution group to journal. If you specify a distribution group, all recipients in that distribution group are journaled. All messages sent to or from a recipient are journaled. | |
| **Enabled** | Write | Boolean | Specifies whether the Journal Rule is enabled or not. | |
| **RuleScope** | Write | String | The Scope parameter specifies the scope of email messages to which the journal rule is applied | `Global`, `Internal`, `External` |
| **Ensure** | Write | String | Present ensures the rule exists, Absent that it does not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource allows to configure Journal Rules in Exchange Online.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Compliance Admin, View-Only Configuration, Journaling

#### Role Groups

- Organization Management, Compliance Management

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
        EXOJournalRule 'CreateJournalRule'
        {
            Enabled              = $True
            JournalEmailAddress  = "John.Smith@contoso.com"
            Name                 = "Send to John"
            RuleScope            = "Global"
            Ensure               = "Present"
            Credential           = $Credscredential
        }
    }
}
```

