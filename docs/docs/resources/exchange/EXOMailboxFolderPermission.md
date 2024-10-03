# EXOMailboxFolderPermission

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the target mailbox and folder. The syntax is MailboxID:\ParentFolder[\SubFolder]. For the MailboxID you can use any value that uniquely identifies the mailbox. | |
| **UserPermissions** | Write | MSFT_EXOMailboxFolderUserPermission[] | Mailbox Folder Permissions for the current user. | |
| **Ensure** | Write | String | Determines wheter or not the permission should exist on the mailbox. | `Present` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

### MSFT_EXOMailboxFolderUserPermission

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **AccessRights** | Write | StringArray[] | The AccessRights parameter specifies the permissions that you want to add for the user on the mailbox folder. | |
| **User** | Write | String | The User parameter specifies who gets the permissions on the mailbox folder. | |
| **SharingPermissionFlags** | Write | String | The SharingPermissionFlags parameter assigns calendar delegate permissions. This parameter only applies to calendar folders and can only be used when the AccessRights parameter value is Editor. Valid values are: None, Delegate, CanViewPrivateItems | |


## Description

Use this resource to add/set/remove mailbox folder permissions for users in your tenant.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Organization Management, Recipient Management

#### Role Groups

- Organization Management, Help Desk

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
        EXOMailboxFolderPermission "EXOMailboxFolderPermission-admin:\Calendar"
        {
            Credential           = $Credscredential;
            Ensure               = "Present";
            Identity             = "amdin:\Calendar";
            UserPermissions      = @(MSFT_EXOMailboxFolderUserPermission {
                User                   = 'Default'
                AccessRights           = 'AvailabilityOnly'
            }
            MSFT_EXOMailboxFolderUserPermission {
                User                   = 'Anonymous'
                AccessRights           = 'AvailabilityOnly'
            }
            MSFT_EXOMailboxFolderUserPermission {
                User                          = 'AlexW'
                AccessRights                  = 'Owner'
                SharingPermissionFlags        = 'Delegate'
            }
            );
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
        EXOMailboxFolderPermission "EXOMailboxFolderPermission-admin:\Calendar"
        {
            Credential           = $Credscredential;
            Ensure               = "Present";
            Identity             = "admin:\Calendar";
            UserPermissions      = @(MSFT_EXOMailboxFolderUserPermission {
                User                   = 'Default'
                AccessRights           = 'AvailabilityOnly'
            }
MSFT_EXOMailboxFolderUserPermission {
                User                   = 'Anonymous'
                AccessRights           = 'AvailabilityOnly'
            }
MSFT_EXOMailboxFolderUserPermission {
                User                   = 'AlexW'
                AccessRights           = 'Editor'
		SharingPermissionFlags = 'Delegate'
            }
            );
        }
    }
}
```

