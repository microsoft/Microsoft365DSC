# TeamsMeetingConfiguration

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The only valid input is Global - the tenant wide configuration | `Global` |
| **LogoURL** | Write | String | URL to a logo image. This would be included in the meeting invite. Please ensure this URL is publicly accessible for invites that go beyond your federation boundaries. | |
| **LegalURL** | Write | String | URL to a website containing legal information and meeting disclaimers. This would be included in the meeting invite. Please ensure this URL is publicly accessible for invites that go beyond your federation boundaries. | |
| **HelpURL** | Write | String | URL to a website where users can obtain assistance on joining the meeting.This would be included in the meeting invite. Please ensure this URL is publicly accessible for invites that go beyond your federation boundaries. | |
| **CustomFooterText** | Write | String | Text to be used on custom meeting invitations. | |
| **DisableAnonymousJoin** | Write | Boolean | Determines whether anonymous users are blocked from joining meetings in the tenant. Set this to TRUE to block anonymous users from joining. Set this to FALSE to allow anonymous users to join meetings. | |
| **EnableQoS** | Write | Boolean | Determines whether Quality of Service Marking for real-time media (audio, video, screen/app sharing) is enabled in the tenant. Set this to TRUE to enable and FALSE to disable. | |
| **ClientAudioPort** | Write | UInt32 | Determines the starting port number for client audio. Minimum allowed value: 1024 Maximum allowed value: 65535 Default value: 50000. | |
| **ClientAudioPortRange** | Write | UInt32 | Determines the total number of ports available for client audio. Default value is 20. | |
| **ClientVideoPort** | Write | UInt32 | Determines the starting port number for client video. Minimum allowed value: 1024 Maximum allowed value: 65535 Default value: 50020. | |
| **ClientVideoPortRange** | Write | UInt32 | Determines the total number of ports available for client video. Default value is 20. | |
| **ClientAppSharingPort** | Write | UInt32 | Determines the starting port number for client screen sharing or application sharing. Minimum allowed value: 1024 Maximum allowed value: 65535 Default value: 50040. | |
| **ClientMediaPortRangeEnabled** | Write | Boolean | Determines whether custom media port and range selections need to be enforced. When set to True, clients will use the specified port range for media traffic. When set to False (the default value) for any available port (from port 1024 through port 65535) will be used to accommodate media traffic. | |
| **ClientAppSharingPortRange** | Write | UInt32 | Determines the total number of ports available for client sharing or application sharing. Default value is 20. | |
| **Credential** | Write | PSCredential | Credentials of the Teams Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |

## Description

This resource is used to configure the Teams Meeting Configuration.

More information: https://docs.microsoft.com/en-us/microsoftteams/meeting-settings-in-teams

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

This examples sets the Teams Meeting Configuration.

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
        TeamsMeetingConfiguration 'MeetingConfiguration'
        {
            Identity                    = "Global"
            ClientAppSharingPort        = 50040
            ClientAppSharingPortRange   = 20
            ClientAudioPort             = 50000
            ClientAudioPortRange        = 20
            ClientMediaPortRangeEnabled = $True
            ClientVideoPort             = 50020
            ClientVideoPortRange        = 20
            CustomFooterText            = "This is some custom footer text"
            DisableAnonymousJoin        = $False
            EnableQoS                   = $False
            HelpURL                     = "https://github.com/Microsoft/Office365DSC/Help"
            LegalURL                    = "https://github.com/Microsoft/Office365DSC/Legal"
            LogoURL                     = "https://github.com/Microsoft/Office365DSC/Logo.png"
            Credential                  = $Credscredential
        }
    }
}
```

