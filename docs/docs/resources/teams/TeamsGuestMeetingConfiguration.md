# TeamsGuestMeetingConfiguration

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The only valid input is Global - the tenant wide configuration | `Global` |
| **AllowIPVideo** | Write | Boolean | Determines whether video is enabled in a user's meetings or calls. Set this to TRUE to allow guests to share their video. Set this to FALSE to prohibit guests from sharing their video. | |
| **LiveCaptionsEnabledType** | Write | String | Determines whether real-time captions are available for guests in Teams meetings. | `Disabled`, `DisabledUserOverride` |
| **ScreenSharingMode** | Write | String | Determines the mode in which guests can share a screen in calls or meetings. Set this to SingleApplication to allow the user to share an application at a given point in time. Set this to EntireScreen to allow the user to share anything on their screens. Set this to Disabled to prohibit the user from sharing their screens. | `Disabled`, `EntireScreen`, `SingleApplication` |
| **AllowMeetNow** | Write | Boolean | Determines whether guests can start ad-hoc meetings. Set this to TRUE to allow guests to start ad-hoc meetings. Set this to FALSE to prohibit guests from starting ad-hoc meetings. | |
| **Credential** | Write | PSCredential | Credentials of the Teams Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |

## Description

This resource is used to configure the Teams Guest Meetings Configuration.

More information: https://docs.microsoft.com/en-us/microsoftteams/set-up-guests

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

    node localhost
    {
        TeamsGuestMeetingConfiguration 'TeamsGuestMeetingConfiguration'
        {
            Identity           = "Global"
            AllowIPVideo       = $True
            AllowMeetNow       = $True
            ScreenSharingMode  = "EntireScreen"
            Credential         = $Credscredential
        }
    }
}
```

