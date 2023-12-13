# EXOCASMailboxPlan

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the CAS Mailbox Plan that you want to modify. | |
| **Ensure** | Write | String | CASMailboxPlans cannot be created/removed in O365.  This must be set to 'Present' | `Present` |
| **ActiveSyncEnabled** | Write | Boolean | The ActiveSyncEnabled parameter enables or disables access to the mailbox by using Exchange Active Sync. Default is $true. | |
| **ImapEnabled** | Write | Boolean | The ImapEnabled parameter enables or disables access to the mailbox by using IMAP4 clients. The default value is $true for all CAS mailbox plans except ExchangeOnlineDeskless which is $false by default. | |
| **OwaMailboxPolicy** | Write | String | The OwaMailboxPolicy parameter specifies the Outlook on the web (formerly known as Outlook Web App) mailbox policy for the mailbox plan. The default value is OwaMailboxPolicy-Default. You can use the Get-OwaMailboxPolicy cmdlet to view the available Outlook on the web mailbox policies. | |
| **PopEnabled** | Write | Boolean | The PopEnabled parameter enables or disables access to the mailbox by using POP3 clients. Default is $true. | |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource configures Client Access services (CAS) mailbox plans
in cloud-based organizations.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Organization Client Access, View-Only Recipients, View-Only Configuration, Mail Recipients

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
        EXOCASMailboxPlan 'ConfigureCASMailboxPlan'
        {
            ActiveSyncEnabled = $True
            OwaMailboxPolicy  = "OwaMailboxPolicy-Default"
            PopEnabled        = $True
            Identity          = $CASIdentity
            ImapEnabled       = $True
            Ensure            = "Present"
            Credential        = $Credscredential
        }
    }
}
```

