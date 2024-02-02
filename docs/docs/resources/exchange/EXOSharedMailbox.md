# EXOSharedMailbox

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | The display name of the Shared Mailbox | |
| **PrimarySMTPAddress** | Write | String | The primary email address of the Shared Mailbox | |
| **Alias** | Write | String | The alias of the Shared Mailbox | |
| **EmailAddresses** | Write | StringArray[] | The EmailAddresses parameter specifies all the email addresses (proxy addresses) for the Shared Mailbox | |
| **Ensure** | Write | String | Present ensures the group exists, absent ensures it is removed | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource allows users to create Office 365 Shared Mailboxes.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Mail Enabled Public Folders, MyName, Public Folders, Compliance Admin, User Options, Message Tracking, View-Only Recipients, Role Management, Legal Hold, Audit Logs, Retention Management, Distribution Groups, Move Mailboxes, Information Rights Management, Mail Recipient Creation, Reset Password, View-Only Audit Logs, Mail Recipients, Mailbox Search, UM Mailboxes, Security Group Creation and Membership, Mailbox Import Export, MyMailboxDelegation, MyDisplayName

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
        EXOSharedMailbox 'SharedMailbox'
        {
            DisplayName        = "Integration"
            PrimarySMTPAddress = "Integration@$Domain"
            EmailAddresses     = @("IntegrationSM@$Domain")
            Alias              = "IntegrationSM"
            Ensure             = "Present"
            Credential         = $Credscredential
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
        EXOSharedMailbox 'SharedMailbox'
        {
            DisplayName        = "Integration"
            PrimarySMTPAddress = "Integration@$Domain"
            EmailAddresses     = @("IntegrationSM@$Domain", "IntegrationSM2@$Domain")
            Alias              = "IntegrationSM"
            Ensure             = "Present"
            Credential         = $Credscredential
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
        EXOSharedMailbox 'SharedMailbox'
        {
            DisplayName        = "Integration"
            PrimarySMTPAddress = "Integration@$Domain"
            EmailAddresses     = @("IntegrationSM@$Domain", "IntegrationSM2@$Domain")
            Alias              = "IntegrationSM"
            Ensure             = "Absent"
            Credential         = $Credscredential
        }
    }
}
```

