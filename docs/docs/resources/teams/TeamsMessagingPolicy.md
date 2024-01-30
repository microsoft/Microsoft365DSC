# TeamsMessagingPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Identity for the teams messaging policy you're modifying. To modify the global policy, use this syntax: -Identity global. To modify a per-user policy, use syntax similar to this: -Identity TeamsMessagingPolicy. | |
| **AllowCommunicationComplianceEndUserReporting** | Write | Boolean | Report inappropriate content. | |
| **AllowFluidCollaborate** | Write | Boolean | Determines is Fluid Collaboration should be enabled or not. | |
| **AllowSecurityEndUserReporting** | Write | Boolean | Report a security concern. | |
| **AllowGiphy** | Write | Boolean | Determines whether a user is allowed to access and post Giphys. Set this to TRUE to allow. Set this FALSE to prohibit. | |
| **AllowMemes** | Write | Boolean | Determines whether a user is allowed to access and post memes. Set this to TRUE to allow. Set this FALSE to prohibit. | |
| **AllowOwnerDeleteMessage** | Write | Boolean | Determines whether owners are allowed to delete all the messages in their team. Set this to TRUE to allow. Set this to FALSE to prohibit. | |
| **AllowUserEditMessage** | Write | Boolean | Determines whether a user is allowed to edit their own messages. Set this to TRUE to allow. Set this to FALSE to prohibit. | |
| **AllowSmartCompose** | Write | Boolean | Turn on this setting to let a user get text predictions for chat messages. | |
| **AllowSmartReply** | Write | Boolean | Turn this setting on to enable suggested replies for chat messages. Set this to TRUE to allow. Set this to FALSE to prohibit. | |
| **AllowStickers** | Write | Boolean | Determines whether a user is allowed to access and post stickers. Set this to TRUE to allow. Set this FALSE to prohibit. | |
| **AllowUrlPreviews** | Write | Boolean | Use this setting to turn automatic URL previewing on or off in messages. Set this to TRUE to turn on. Set this to FALSE to turn off. | |
| **AllowUserChat** | Write | Boolean | Determines whether a user is allowed to chat. Set this to TRUE to allow a user to chat across private chat, group chat and in meetings. Set this to FALSE to prohibit all chat. | |
| **AllowUserDeleteMessage** | Write | Boolean | Determines whether a user is allowed to delete their own messages. Set this to TRUE to allow. Set this to FALSE to prohibit. | |
| **AllowUserTranslation** | Write | Boolean | Determines whether a user is allowed to translate messages to their client languages. Set this to TRUE to allow. Set this to FALSE to prohibit. | |
| **AllowImmersiveReader** | Write | Boolean | Determines whether a user is allowed to use Immersive Reader for reading conversation messages. Set this to TRUE to allow. Set this FALSE to prohibit. | |
| **AllowRemoveUser** | Write | Boolean | Determines whether a user is allowed to remove a user from a conversation. Set this to TRUE to allow. Set this FALSE to prohibit. | |
| **AllowPriorityMessages** | Write | Boolean | Determines whether a user is allowed to send priorities messages. Set this to TRUE to allow. Set this FALSE to prohibit. | |
| **AllowUserDeleteChat** | Write | Boolean | Turn this setting on to allow users to permanently delete their 1:1, group chat, and meeting chat as participants (this deletes the chat only for them, not other users in the chat). | |
| **AllowVideoMessages** | Write | Boolean | Determines whether a user is allowed to send video messages in Chat. Set this to TRUE to allow a user to send video messages. Set this to FALSE to prohibit sending video messages. | |
| **Description** | Write | String | Provide a description of your policy to identify purpose of creating it. | |
| **GiphyRatingType** | Write | String | Determines the Giphy content restrictions applicable to a user. Set this to STRICT, MODERATE or NORESTRICTION. | `STRICT`, `MODERATE`, `NORESTRICTION` |
| **ReadReceiptsEnabledType** | Write | String | Use this setting to specify whether read receipts are user controlled, enabled for everyone, or disabled. Set this to UserPreference, Everyone or None. | `UserPreference`, `Everyone`, `None` |
| **ChannelsInChatListEnabledType** | Write | String | Possible values are: DisabledUserOverride,EnabledUserOverride. | `DisabledUserOverride`, `EnabledUserOverride` |
| **AudioMessageEnabledType** | Write | String | Determines whether a user is allowed to send audio messages. Possible values are: ChatsAndChannels,ChatsOnly,Disabled. | `ChatsAndChannels`, `ChatsOnly`, `Disabled` |
| **Tenant** | Write | String | Globally unique identifier (GUID) of the tenant account whose external user communication policy are being created. | |
| **Ensure** | Write | String | Present ensures the Team Message Policy exists, absent ensures it is removed | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Teams Service Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource is used to configure the Teams messaging policy.

More information: https://docs.microsoft.com/en-us/microsoftteams/messaging-policies-in-teams

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

This example adds a new Teams Messaging Policy.

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
        TeamsMessagingPolicy 'ConfigureMessagingPolicy'
        {
            Identity                = "TestPolicy"
            Description             = "My sample policy"
            ReadReceiptsEnabledType = "UserPreference"
            AllowImmersiveReader    = $True
            AllowGiphy              = $True
            AllowStickers           = $True
            AllowUrlPreviews        = $false
            AllowUserChat           = $True
            AllowUserDeleteMessage  = $false
            AllowUserEditMessage    = $false
            AllowUserTranslation    = $True
            AllowRemoveUser         = $false
            AllowPriorityMessages   = $True
            GiphyRatingType         = "MODERATE"
            AllowMemes              = $False
            AudioMessageEnabledType = "ChatsOnly"
            AllowOwnerDeleteMessage = $False
            Ensure                  = "Present"
            Credential              = $Credscredential
        }
    }
}
```

