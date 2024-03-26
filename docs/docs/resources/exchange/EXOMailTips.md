# EXOMailTips

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Only valid value is 'Yes'. | `Yes` |
| **MailTipsAllTipsEnabled** | Write | Boolean | Specifies whether MailTips are enabled. | |
| **MailTipsGroupMetricsEnabled** | Write | Boolean | Specifies whether MailTips that rely on group metrics data are enabled. | |
| **MailTipsLargeAudienceThreshold** | Write | UInt32 | Specifies what a large audience is. | |
| **MailTipsMailboxSourcedTipsEnabled** | Write | Boolean | Specifies whether MailTips that rely on mailbox data (out-of-office or full mailbox) are enabled. | |
| **MailTipsExternalRecipientsTipsEnabled** | Write | Boolean | Specifies whether MailTips for external recipients are enabled. | |
| **Ensure** | Write | String | Specifies if this MailTip should exist. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource allows to configure Mailtips behaviors in Exchange Online.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Mail Tips, View-Only Configuration, Organization Configuration, Federated Sharing, Public Folders, Team Mailboxes, Compliance Admin, Recipient Policies, Remote and Accepted Domains, Distribution Groups, Mail Recipients

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

    $Domain = $Credscredential.Username.Split('@')[1]
    node localhost
    {
        EXOMailTips 'OrgWideMailTips'
        {
            IsSingleInstance                      = 'Yes'
            MailTipsAllTipsEnabled                = $True
            MailTipsGroupMetricsEnabled           = $True
            MailTipsLargeAudienceThreshold        = 100
            MailTipsMailboxSourcedTipsEnabled     = $True
            MailTipsExternalRecipientsTipsEnabled = $True
            Ensure                                = "Present"
            Credential                            = $Credscredential
        }
    }
}
```

### Example 2

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

    $Domain = $Credscredential.Username.Split('@')[1]
    node localhost
    {
        EXOMailTips 'OrgWideMailTips'
        {
            IsSingleInstance                      = 'Yes'
            MailTipsAllTipsEnabled                = $True
            MailTipsGroupMetricsEnabled           = $False # Updated Property
            MailTipsLargeAudienceThreshold        = 100
            MailTipsMailboxSourcedTipsEnabled     = $True
            MailTipsExternalRecipientsTipsEnabled = $True
            Ensure                                = "Present"
            Credential                            = $Credscredential
        }
    }
}
```

### Example 3

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

    $Domain = $Credscredential.Username.Split('@')[1]
    node localhost
    {
        EXOMailTips 'OrgWideMailTips'
        {
            IsSingleInstance = 'Yes'
            Ensure           = "Absent"
            Credential       = $Credscredential
        }
    }
}
```

