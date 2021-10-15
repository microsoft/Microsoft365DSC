# EXOOfflineAddressBook

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies the unique name of the Offline Address Book. The maximum length is 64 characters. ||
| **AddressLists** | Write | StringArray[] | The AddressLists parameter specifies the address lists or global address lists that are included in the OAB. You can use any value that uniquely identifies the address list. ||
| **ConfiguredAttributes** | Write | StringArray[] | The ConfiguredAttributes parameter specifies the recipient MAPI properties that are available in the OAB. ||
| **DiffRetentionPeriod** | Write | String | The DiffRetentionPeriod parameter specifies the number of days that the OAB difference files are stored on the server. ||
| **IsDefault** | Write | Boolean | The IsDefault parameter specifies whether the OAB is used by all mailboxes and mailbox databases that don't have an OAB specified. ||
| **Ensure** | Write | String | Specify if the Offline Address Book should exist or not. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword ||
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. ||

# EXOOfflineAddressBook

### Description

This resource configures Offline Address Books in Exchange Online.


