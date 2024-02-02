# TeamsMeetingBroadcastPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The identifier of the Teams Meeting Broadcast Policy. | |
| **AllowBroadcastScheduling** | Write | Boolean | Specifies whether this user can create broadcast events in Teams. This settng impacts broadcasts that use both self-service and external encoder production methods. | |
| **AllowBroadcastTranscription** | Write | Boolean | Specifies whether real-time transcription and translation can be enabled in the broadcast event. Note: this setting is applicable to broadcast events that use Teams Meeting production only and does not apply when external encoder is used as production method. | |
| **BroadcastAttendeeVisibilityMode** | Write | String | Specifies the attendee visibility mode of the broadcast events created by this user.  This setting controls who can watch the broadcast event - e.g. anyone can watch this event including anonymous users or only authenticated users in my company can watch the event.  Note: this setting is applicable to broadcast events that use Teams Meeting production only and does not apply when external encoder is used as production method. | `Everyone`, `EveryoneInCompany`, `InvitedUsersInCompany`, `EveryoneInCompanyAndExternal`, `InvitedUsersInCompanyAndExternal` |
| **BroadcastRecordingMode** | Write | String | Specifies whether broadcast events created by this user are always recorded, never recorded or user can choose whether to record or not. Note: this setting is applicable to broadcast events that use Teams Meeting production only and does not apply when external encoder is used as production method. | `AlwaysEnabled`, `AlwaysDisabled`, `UserOverride` |
| **Ensure** | Write | String | Present ensures the Policy exists, absent ensures it is removed | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Teams Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource is used to configure the Teams Meeting Broadcast Policies.

More information: https://docs.microsoft.com/en-us/microsoftteams/teams-live-events/set-up-for-teams-live-events

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

This examples create a new Teams Meeting Broadcast Policy.

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
        TeamsMeetingBroadcastPolicy 'ConfigureMeetingBroadcastPolicy'
        {
            Identity                        = "MyDemoPolicy"
            AllowBroadcastScheduling        = $True
            AllowBroadcastTranscription     = $False
            BroadcastAttendeeVisibilityMode = "EveryoneInCompany"
            BroadcastRecordingMode          = "AlwaysEnabled"
            Ensure                          = "Present"
            Credential                      = $Credscredential
        }
    }
}
```

