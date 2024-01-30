<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

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
            ConfiguredAttributes = @('OfficeLocation, ANR','ProxyAddresses, ANR','PhoneticGivenName, ANR','GivenName, ANR','PhoneticSurname, ANR','Surname, ANR','Account, ANR','PhoneticDisplayName, ANR','DisplayName, ANR','ExternalDirectoryObjectId, Value','ExternalMemberCount, Value','TotalMemberCount, Value','ModerationEnabled, Value','MailboxGuid, Value','DelivContLength, Value','MailTipTranslations, Value','ObjectGuid, Value','DisplayTypeEx, Value','DisplayNamePrintableAnsi, Value','HomeMdbA, Value','Certificate, Value','UserSMimeCertificate, Value','UserCertificate, Value','Comment, Value','PagerTelephoneNumber, Value','AssistantTelephoneNumber, Value','MobileTelephoneNumber, Value','PrimaryFaxNumber, Value','Home2TelephoneNumberMv, Value','Business2TelephoneNumberMv, Value','HomeTelephoneNumber, Value','TargetAddress, Value','PhoneticDepartmentName, Value','DepartmentName, Value','Assistant, Value','PhoneticCompanyName, Value','CompanyName, Value','Title, Value','Country, Value','PostalCode, Value','StateOrProvince, Value','Locality, Value','StreetAddress, Value','Initials, Value','BusinessTelephoneNumber, Value','SendRichInfo, Value','ObjectType, Value','DisplayType, Value','RejectMessagesFromDLMembers, Indicator','AcceptMessagesOnlyFromDLMembers, Indicator','RejectMessagesFrom, Indicator','AcceptMessagesOnlyFrom, Indicator','UmSpokenName, Indicator','ThumbnailPhoto, Indicator')
            DiffRetentionPeriod  = "30"
            IsDefault            = $false # Updated Property
            Ensure               = "Present"
            Credential           = $Credscredential
        }
    }
}
