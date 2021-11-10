# EXOCASMailboxPlan

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the CAS Mailbox Plan that you want to modify. ||
| **Ensure** | Write | String | CASMailboxPlans cannot be created/removed in O365.  This must be set to 'Present' |Present|
| **ActiveSyncEnabled** | Write | Boolean | The ActiveSyncEnabled parameter enables or disables access to the mailbox by using Exchange Active Sync. Default is $true. ||
| **ImapEnabled** | Write | Boolean | The ImapEnabled parameter enables or disables access to the mailbox by using IMAP4 clients. The default value is $true for all CAS mailbox plans except ExchangeOnlineDeskless which is $false by default. ||
| **OwaMailboxPolicy** | Write | String | The OwaMailboxPolicy parameter specifies the Outlook on the web (formerly known as Outlook Web App) mailbox policy for the mailbox plan. The default value is OwaMailboxPolicy-Default. You can use the Get-OwaMailboxPolicy cmdlet to view the available Outlook on the web mailbox policies. ||
| **PopEnabled** | Write | Boolean | The PopEnabled parameter enables or disables access to the mailbox by using POP3 clients. Default is $true. ||
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword ||
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. ||

# EXOCASMailboxPlan

### Description

This resource configures Client Access services (CAS) mailbox plans
in cloud-based organizations.

## Parameters

Ensure

- Required: No (Defaults to 'Present')
- Description: `Present` is the only value accepted.
  Configurations using `Ensure = 'Absent'` will throw an Error!

Credential

- Required: Yes
- Description: Credentials of the Office 365 Global Admin

Identity

- Required: Yes
- Description: The Identity parameter specifies the CAS mailbox plan that
  you want to modify.

ActiveSyncEnabled

- Required: No
- Description: The ActiveSyncEnabled parameter enables or disables access
  to the mailbox by using Exchange Active Sync. The default is $true.

ImapEnabled

- Required: No
- Description: The ImapEnabled parameter enables or disables access to
  the mailbox by using IMAP4 clients. The default value is $true for all
  CAS mailbox plans except ExchangeOnlineDeskless which is $false by default.

OwaMailboxPolicy

- Required: No
- Description: The OwaMailboxPolicy parameter specifies the Outlook on
  the web (formerly known as Outlook Web App) mailbox policy for the
  mailbox plan. The default value is OwaMailboxPolicy-Default.
  You can use the Get-OwaMailboxPolicy cmdlet to view the available
  Outlook on the web mailbox policies.

PopEnabled

- Required: No
- Description: The PopEnabled parameter enables or disables access to
  the mailbox by using POP3 clients. The default value is $true.

## Example

```PowerShell
        EXOCASMailboxPlan CASMBPExampleConfig {
            Ensure              = 'Present'
            Identity            = 'ExchangeOnlineEnterprise-6f6c267b-f8db-4020-b441-f7bd966a0ca0'
            Credential          = $Credential
            ActiveSyncEnabled   = $true
            ImapEnabled         = $true
            OwaMailboxPolicy    = 'OwaMailboxPolicy-Default'
            PopEnabled          = $true
        }
```

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
        $credsGlobalAdmin
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
            Credential        = $credsGlobalAdmin
        }
    }
}
```

