# EXOAddressBookPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies the name that you want this address book policy to be called. | |
| **AddressLists** | Write | StringArray[] | The AddressLists parameter specifies the address lists that will be used by mailbox users who are assigned this address book policy. This parameter accepts multiple values. | |
| **GlobalAddressList** | Write | String | The GlobalAddressList parameter specifies the identity of the global address list (GAL) that will be used by mailbox users who are assigned this address book policy. You can specify only one GAL for each address book policy. | |
| **OfflineAddressBook** | Write | String | The OfflineAddressBook parameter specifies the identity of the offline address book (OAB) that will be used by mailbox users who are assigned this address book policy. You can specify only one OAB for each address book policy. | |
| **RoomList** | Write | String | The RoomList parameter specifies the name of the room address list. | |
| **Ensure** | Write | String | Specify if the Address Book Policy should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource configures Address Book Policies in Exchange Online.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- View-Only Recipients, Mail Recipient Creation, View-Only Configuration, Mail Recipients, Address Lists

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
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOAddressBookPolicy 'ConfigureAddressBookPolicy'
        {
            Name                 = "All Fabrikam ABP"
            AddressLists         = "\All Distribution Lists"
            RoomList             = "\All Rooms"
            OfflineAddressBook   = "\Default Offline Address Book"
            GlobalAddressList    = "\Default Global Address List"
            Ensure               = "Present"
            Credential           = $Credscredential
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
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOAddressBookPolicy 'ConfigureAddressBookPolicy'
        {
            Name                 = "All Fabrikam ABP"
            AddressLists         = "\All Users"
            RoomList             = "\All Rooms"
            OfflineAddressBook   = "\Default Offline Address Book"
            GlobalAddressList    = "\Default Global Address List"
            Ensure               = "Present"
            Credential           = $Credscredential
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
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOAddressBookPolicy 'ConfigureAddressBookPolicy'
        {
            Name                 = "All Fabrikam ABP"
            Ensure               = "Absent"
            Credential           = $Credscredential
        }
    }
}
```

