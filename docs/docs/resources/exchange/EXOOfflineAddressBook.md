# EXOOfflineAddressBook

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies the unique name of the Offline Address Book. The maximum length is 64 characters. | |
| **AddressLists** | Write | StringArray[] | The AddressLists parameter specifies the address lists or global address lists that are included in the OAB. You can use any value that uniquely identifies the address list. | |
| **ConfiguredAttributes** | Write | StringArray[] | The ConfiguredAttributes parameter specifies the recipient MAPI properties that are available in the OAB. | |
| **DiffRetentionPeriod** | Write | String | The DiffRetentionPeriod parameter specifies the number of days that the OAB difference files are stored on the server. | |
| **IsDefault** | Write | Boolean | The IsDefault parameter specifies whether the OAB is used by all mailboxes and mailbox databases that don't have an OAB specified. | |
| **Ensure** | Write | String | Specify if the Offline Address Book should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource configures Offline Address Books in Exchange Online.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Address Lists

#### Role Groups

- None

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
        EXOOfflineAddressBook 'ConfigureOfflineAddressBook'
        {
            Name                 = "Integration Address Book"
            AddressLists         = @('\Offline Global Address List')
            DiffRetentionPeriod  = "30"
            IsDefault            = $true
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
        EXOOfflineAddressBook 'ConfigureOfflineAddressBook'
        {
            Name                 = "Integration Address Book"
            AddressLists         = @('\Offline Global Address List')
            ConfiguredAttributes = @('OfficeLocation, ANR','ProxyAddresses, ANR','PhoneticGivenName, ANR','GivenName, ANR','PhoneticSurname, ANR','Surname, ANR','Account, ANR','PhoneticDisplayName, ANR','ExternalDirectoryObjectId, Value','ExternalMemberCount, Value','TotalMemberCount, Value','ModerationEnabled, Value','MailboxGuid, Value','DelivContLength, Value','MailTipTranslations, Value','ObjectGuid, Value','DisplayTypeEx, Value','DisplayNamePrintableAnsi, Value','HomeMdbA, Value','Certificate, Value','UserSMimeCertificate, Value','UserCertificate, Value','Comment, Value','PagerTelephoneNumber, Value','AssistantTelephoneNumber, Value','MobileTelephoneNumber, Value','PrimaryFaxNumber, Value','Home2TelephoneNumberMv, Value','Business2TelephoneNumberMv, Value','HomeTelephoneNumber, Value','TargetAddress, Value','PhoneticDepartmentName, Value','DepartmentName, Value','Assistant, Value','PhoneticCompanyName, Value','CompanyName, Value','Title, Value','Country, Value','PostalCode, Value','StateOrProvince, Value','Locality, Value','StreetAddress, Value','Initials, Value','BusinessTelephoneNumber, Value','SendRichInfo, Value','ObjectType, Value','DisplayType, Value','RejectMessagesFromDLMembers, Indicator','AcceptMessagesOnlyFromDLMembers, Indicator','RejectMessagesFrom, Indicator','AcceptMessagesOnlyFrom, Indicator','UmSpokenName, Indicator','ThumbnailPhoto, Indicator')
            DiffRetentionPeriod  = "30"
            IsDefault            = $false # Updated Property
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
        EXOOfflineAddressBook 'ConfigureOfflineAddressBook'
        {
            Name                 = "Integration Address Book"
            AddressLists         = @('\Offline Global Address List')
            ConfiguredAttributes = @('OfficeLocation, ANR', 'ProxyAddresses, ANR', 'PhoneticGivenName, ANR', 'GivenName, ANR', 'PhoneticSurname, ANR', 'Surname, ANR', 'Account, ANR', 'PhoneticDisplayName, ANR', 'UserInformationDisplayName, ANR', 'ExternalMemberCount, Value', 'TotalMemberCount, Value', 'ModerationEnabled, Value', 'DelivContLength, Value', 'MailTipTranslations, Value', 'ObjectGuid, Value', 'IsOrganizational, Value', 'HabSeniorityIndex, Value', 'DisplayTypeEx, Value', 'SimpleDisplayNameAnsi, Value', 'HomeMdbA, Value', 'Certificate, Value', 'UserSMimeCertificate, Value', 'UserCertificate, Value', 'Comment, Value', 'PagerTelephoneNumber, Value', 'AssistantTelephoneNumber, Value', 'MobileTelephoneNumber, Value', 'PrimaryFaxNumber, Value', 'Home2TelephoneNumberMv, Value', 'Business2TelephoneNumberMv, Value', 'HomeTelephoneNumber, Value', 'TargetAddress, Value', 'PhoneticDepartmentName, Value', 'DepartmentName, Value', 'Assistant, Value', 'PhoneticCompanyName, Value', 'CompanyName, Value', 'Title, Value', 'Country, Value', 'PostalCode, Value', 'StateOrProvince, Value', 'Locality, Value', 'StreetAddress, Value', 'Initials, Value', 'BusinessTelephoneNumber, Value', 'SendRichInfo, Value', 'ObjectType, Value', 'DisplayType, Value', 'RejectMessagesFromDLMembers, Indicator', 'AcceptMessagesOnlyFromDLMembers, Indicator', 'RejectMessagesFrom, Indicator', 'AcceptMessagesOnlyFrom, Indicator', 'UmSpokenName, Indicator', 'ThumbnailPhoto, Indicator')
            DiffRetentionPeriod  = "30"
            IsDefault            = $true
            Ensure               = "Absent"
            Credential           = $Credscredential
        }
    }
}
```

