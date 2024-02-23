# TeamsOnlineVoiceUser

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Specifies the identity of the target user. | |
| **LocationID** | Write | String | Specifies the unique identifier of the emergency location to assign to the user. Location identities can be discovered by using the Get-CsOnlineLisLocation cmdlet. | |
| **TelephoneNumber** | Write | String | Specifies the telephone number to be assigned to the user. The value must be in E.164 format: +14255043920. Setting the value to $Null clears the user's telephone number. | |
| **Ensure** | Write | String | Present ensures the online voice user exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Teams Global Admin. | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |


## Description

This resource configures the Teams Online Voice User.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - None

- **Update**

    - None

#### Application permissions

- **Read**

    - Organization.Read.All, User.Read.All, Group.ReadWrite.All, AppCatalog.ReadWrite.All, TeamSettings.ReadWrite.All, Channel.Delete.All, ChannelSettings.ReadWrite.All, ChannelMember.ReadWrite.All

- **Update**

    - Organization.Read.All, User.Read.All, Group.ReadWrite.All, AppCatalog.ReadWrite.All, TeamSettings.ReadWrite.All, Channel.Delete.All, ChannelSettings.ReadWrite.All, ChannelMember.ReadWrite.All

## Examples

### Example 1

This example adds a new Teams Voice Route.

```powershell
Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsCredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        TeamsOnlineVOiceUser 'AssignVoiceUser'
        {
            Identity        = 'John.Smith@Contoso.com'
            TelephoneNumber = "1800-555-1234"
            LocationId      = "c7c5a17f-00d7-47c0-9ddb-3383229d606"
            Ensure          = "Present"
            Credential      = $credsCredential
        }
    }
}
```

