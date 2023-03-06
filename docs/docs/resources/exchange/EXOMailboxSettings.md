﻿# EXOMailboxSettings

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | The display name of the Shared Mailbox | |
| **TimeZone** | Write | String | The name of the Time Zone to assign to the mailbox | |
| **Locale** | Write | String | The code of the Locale to assign to the mailbox | |
| **Ensure** | Write | String | Present ensures the Mailbox Settings are applied | `Present` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

# EXO MailboxSettings

## Description

This resource configures settings on Mailboxes
such as the Regional settings and its timezone.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- User Options, View-Only Recipients, Mail Recipients

#### Role Groups

- Organization Management

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )

    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOMailboxSettings 'OttawaTeamMailboxSettings'
        {
            DisplayName = 'Ottawa Employees'
            TimeZone    = 'Eastern Standard Time'
            Locale      = 'fr-CA'
            Ensure      = 'Present'
            Credential  = $credsGlobalAdmin
        }
    }
}
```

