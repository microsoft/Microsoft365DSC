# EXOMailboxPermission

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the mailbox where you want to assign permissions to the user. You can use any value that uniquely identifies the mailbox. | |
| **AccessRights** | Required | StringArray[] | The AccessRights parameter specifies the permission that you want to add for the user on the mailbox. Valid values are: ChangeOwner, ChangePermission, DeleteItem, ExternalAccount, FullAccess and ReadPermission. | |
| **User** | Key | String | The User parameter specifies who gets the permissions on the mailbox. | |
| **InheritanceType** | Key | String | The InheritanceType parameter specifies how permissions are inherited by folders in the mailbox. Valid values are: None, All, Children, Descendents, SelfAndChildren. | `None`, `All`, `Children`, `Descendents`, `SelfAndChildren` |
| **Owner** | Write | String | The Owner parameter specifies the owner of the mailbox object. | |
| **Deny** | Write | Boolean | The Deny switch specifies that the permissions you're adding are Deny permissions. | |
| **Ensure** | Write | String | Determines wheter or not the permission should exist on the mailbox. | `Present` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

## Description

Use this resource to modify the permissions of mailbox.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Unified Messaging, View-Only Recipients, Mail Recipient Creation, Mail Recipients, UM Mailboxes

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
        $credsCredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    $Domain = $Credscredential.Username.Split('@')[1]
    node localhost
    {
        EXOMailboxPermission "TestPermission"
        {
            AccessRights         = @("FullAccess","ReadPermission");
            Credential           = $credsCredential;
            Deny                 = $True; # Updated Property
            Ensure               = "Present";
            Identity             = "AlexW@$Domain";
            InheritanceType      = "All";
            User                 = "NT AUTHORITY\SELF";
        }
    }
}
```

