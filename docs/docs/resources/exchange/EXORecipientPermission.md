# EXORecipientPermission

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The mailbox the permission should be given on. | |
| **Trustee** | Key | String | The account to give the permission to. | |
| **AccessRights** | Write | StringArray[] | The access rights granted to the account. Only 'SendAs' is supported. | |
| **Ensure** | Write | String | Present ensures the group exists, absent ensures it is removed | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

## Description

This resource allows users to retrieve Office 365 Recipient Permissions.

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
        EXORecipientPermission 'AddSendAs'
        {
            Identity     = "AlexW@$TenantId"
            Trustee      = "admin@$TenantId"
            AccessRights = 'SendAs'
            Ensure       = 'Present'
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
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
        EXORecipientPermission 'AddSendAs'
        {

            Identity     = 'AdeleV@$Domain'
            Trustee      = "admin@$TenantId"
            Ensure       = 'Absent'
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
```

