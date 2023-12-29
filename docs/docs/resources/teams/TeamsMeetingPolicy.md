# TeamsMeetingPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Identity of the Teams Meeting Policy. | |
| **Description** | Write | String | Description of the Teams Meeting Policy. | |
| **AllowChannelMeetingScheduling** | Write | Boolean | Determines whether a user can schedule channel meetings. Set this to TRUE to allow a user to schedule channel meetings. Set this to FALSE to prohibit the user from scheduling channel meetings. Note this only restricts from scheduling and not from joining a meeting scheduled by another user. | |
| **AllowMeetNow** | Write | Boolean | Determines whether a user can start ad-hoc meetings. Set this to TRUE to allow a user to start ad-hoc meetings. Set this to FALSE to prohibit the user from starting ad-hoc meetings. | |
| **AllowPrivateMeetNow** | Write | Boolean | Determines whether a user can start private ad-hoc meetings. Set this to TRUE to allow a user to start private ad-hoc meetings. Set this to FALSE to prohibit the user from starting private ad-hoc meetings. | |
| **MeetingChatEnabledType** | Write | String | Determines whether or not Chat will be enabled or disabled for meetings. | `Disabled`, `Enabled` |
| **LiveCaptionsEnabledType** | Write | String | Determines whether a user should have the option to view live captions or not in a meeting. | `Disabled`, `DisabledUserOverride` |
| **AllowIPAudio** | Write | Boolean | Determines whether audio is enabled in a user's meetings or calls. Set this to TRUE to allow the user to share their audioo. Set this to FALSE to prohibit the user from sharing their audio. | |
| **AllowIPVideo** | Write | Boolean | Determines whether video is enabled in a user's meetings or calls. Set this to TRUE to allow the user to share their video. Set this to FALSE to prohibit the user from sharing their video. | |
| **AllowEngagementReport** | Write | String | Determines whether or not a meeting Organizer can track join and leave times for all users within their meetings as well as download a roster. | `Enabled`, `Disabled` |
| **IPAudioMode** | Write | String | Determines whether or not a user can use audio in a meeting that supports it. | `EnabledOutgoingIncoming`, `Disabled` |
| **IPVideoMode** | Write | String | Determines whether or not a user can use video in a meeting that supports it.  Can only be enabled if IPAudioMode is enabled | `EnabledOutgoingIncoming`, `Disabled` |
| **AllowAnonymousUsersToDialOut** | Write | Boolean | CURRENTLY DISABLED: Determines whether anonymous users can use the Call Me At feature for meeting audio. | |
| **AllowAnonymousUsersToStartMeeting** | Write | Boolean | Determines whether anonymous users can initiate a meeting. Set this to TRUE to allow anonymous users to initiate a meeting. Set this to FALSE to prohibit them from initiating a meeting. | |
| **AllowPrivateMeetingScheduling** | Write | Boolean | Determines whether a user can schedule private meetings. Set this to TRUE to allow a user to schedule private meetings. Set this to FALSE to prohibit the user from scheduling private meetings. Note this only restricts from scheduling and not from joining a meeting scheduled by another user. | |
| **AutoAdmittedUsers** | Write | String | Determines what types of participants will automatically be added to meetings organized by this user. Set this to EveryoneInCompany if you would like meetings to place every external user in the lobby but allow all users in the company to join the meeting immediately. Set this to Everyone if you'd like to admit anonymous users by default. Set this to EveryoneInSameAndFederatedCompany if you would like meetings to allow federated users to join like your company's users, but place all other external users in a lobby. Set this to InvitedUsers if you would like meetings to allow only the invited users. | `EveryoneInCompany`, `Everyone`, `EveryoneInSameAndFederatedCompany`, `OrganizerOnly`, `InvitedUsers`, `EveryoneInCompanyExcludingGuests` |
| **AllowPSTNUsersToBypassLobby** | Write | Boolean | Determines whether PSTN users should be automatically admitted to the meetings. Set this to TRUE to allow the PSTN user to be able bypass the meetinglobby. Set this to FALSE to prohibit the PSTN user from bypassing the meetinglobby. | |
| **AllowCloudRecording** | Write | Boolean | Determines whether cloud recording is allowed in a user's meetings. Set this to TRUE to allow the user to be able to record meetings. Set this to FALSE to prohibit the user from recording meetings. | |
| **AllowRecordingStorageOutsideRegion** | Write | Boolean | Determines whether cloud recording can be stored out of region for go-local tenants where recording is not yet enabled. | |
| **DesignatedPresenterRoleMode** | Write | String | Determines if users can change the default value of the Who can present? setting in Meeting options in the Teams client. This policy setting affects all meetings, including Meet Now meetings. | `OrganizerOnlyUserOverride`, `EveryoneInCompanyUserOverride`, `EveryoneUserOverride` |
| **AllowOutlookAddIn** | Write | Boolean | Determines whether a user can schedule Teams Meetings in Outlook desktop client. Set this to TRUE to allow the user to be able to schedule Teams meetings in Outlook client. Set this to FALSE to prohibit a user from scheduling Teams meeting in Outlook client. | |
| **AllowPowerPointSharing** | Write | Boolean | Determines whether Powerpoint sharing is allowed in a user's meetings. Set this to TRUE to allow. Set this to FALSE to prohibit. | |
| **AllowParticipantGiveRequestControl** | Write | Boolean | Determines whether participants can request or give control of screen sharing during meetings scheduled by this user. Set this to TRUE to allow the user to be able to give or request control. Set this to FALSE to prohibit the user from giving, requesting control in a meeting. | |
| **AllowExternalParticipantGiveRequestControl** | Write | Boolean | Determines whether external participants can request or give control of screen sharing during meetings scheduled by this user. Set this to TRUE to allow the user to be able to give or request control. Set this to FALSE to prohibit an external user from giving or requesting control in a meeting. | |
| **AllowSharedNotes** | Write | Boolean | Determines whether users are allowed to take shared notes. Set this to TRUE to allow. Set this to FALSE to prohibit. | |
| **AllowWhiteboard** | Write | Boolean | Determines whether whiteboard is allowed in a user's meetings. Set this to TRUE to allow. Set this to FALSE to prohibit. | |
| **AllowTranscription** | Write | Boolean | Determines whether real-time and/or post-meeting captions and transcriptions are allowed in a user's meetings. Set this to TRUE to allow. Set this to FALSE to prohibit. | |
| **MediaBitRateKb** | Write | UInt32 | Determines the media bit rate for audio/video/app sharing transmissions in meetings. | |
| **ScreenSharingMode** | Write | String | Determines the mode in which a user can share a screen in calls or meetings. Set this to SingleApplication to allow the user to share an application at a given point in time. Set this to EntireScreen to allow the user to share anything on their screens. Set this to Disabled to prohibit the user from sharing their screens. | `SingleApplication`, `EntireScreen`, `Disabled` |
| **VideoFiltersMode** | Write | String | Determines which background filters are available to meeting attendees. | `NoFilters`, `BlurOnly`, `BlurAndDefaultBackgrounds`, `AllFilters` |
| **AllowOrganizersToOverrideLobbySettings** | Write | Boolean | Determines whether organizers can override lobby settings for both VOIP and PSTN. Set this to TRUE to allow. Set this to FALSE to prohibit. | |
| **PreferredMeetingProviderForIslandsMode** | Write | String | Determines which Outlook Add-in the user will get as preferred Meeting provider(TeamsAndSfb or Teams). | `TeamsAndSfb`, `Teams` |
| **AllowNDIStreaming** | Write | Boolean | Determines whether a user is able to use NDI (Network Device Interface) in meetings - both for output and input streams. | |
| **AllowUserToJoinExternalMeeting** | Write | String | Determines what types of external meetings users can join. Enabled is able join all external meetings. | `Enabled`, `FederatedOnly`, `Disabled` |
| **EnrollUserOverride** | Write | String | Determines whether or not users will be able to enroll/capture their Biometric data: Face & Voice. | `Disabled`, `Enabled` |
| **RoomAttributeUserOverride** | Write | String | Determines whether or not biometric data will be used to distinguish and or attribute in the transcript. | `Off`, `Distinguish`, `Attribute` |
| **StreamingAttendeeMode** | Write | String | Determines whether or not meetings created by users with this policy are able to utilize the meeting overflow capability. | `Disabled`, `Enabled` |
| **AllowBreakoutRooms** | Write | Boolean | Determines whether or not meetings created by users with this policy are able to utilize the Breakout Rooms feature. | |
| **TeamsCameraFarEndPTZMode** | Write | String | Determines whether or not meetings created by users with this policy are able to utilize the Camera Far-End PTZ Mode. | `Disabled`, `Enabled` |
| **AllowMeetingReactions** | Write | Boolean | Determines whether or not meetings created by users with this policy are able to utilize the Meeting Reactions feature. | |
| **WhoCanRegister** | Write | String | Specifies who can attend and register for webinars. | `Everyone`, `EveryoneInCompany` |
| **AllowAnnotations** | Write | Boolean | N/A | |
| **AllowAnonymousUsersToJoinMeeting** | Write | Boolean | Determines whether anonymous users can join the meetings that impacted users organize. Set this to TRUE to allow anonymous users to join a meeting. Set this to FALSE to prohibit them from joining a meeting. | |
| **AllowMeetingCoach** | Write | Boolean | N/A | |
| **AllowMeetingRegistration** | Write | Boolean | Controls if a user can create a webinar meeting. The default value is True. | |
| **AllowNetworkConfigurationSettingsLookup** | Write | Boolean | Determines whether network configuration setting lookups can be made by users who are not Enterprise Voice enabled. It is used to enable Network Roaming policies. | |
| **AllowWatermarkForCameraVideo** | Write | Boolean | N/A | |
| **AllowWatermarkForScreenSharing** | Write | Boolean | N/A | |
| **NewMeetingRecordingExpirationDays** | Write | SInt32 | Specifies the number of days before meeting recordings will expire and move to the recycle bin. Value can be from 1 to 99,999 days. NOTE: You may opt to set Meeting Recordings to never expire by entering the value -1. | |
| **AllowCartCaptionsScheduling** | Write | String | Determines whether a user can add a URL for captions from a Communications Access Real-Time Translation (CART) captioner for providing real-time captions in meetings. | `EnabledUserOverride`, `DisabledUserOverride`, `Disabled` |
| **AllowDocumentCollaboration** | Write | String | N/A | |
| **AllowedStreamingMediaInput** | Write | String | N/A | |
| **BlockedAnonymousJoinClientTypes** | Write | String | A user can join a Teams meeting anonymously using a Teams client or using a custom application built using Azure Communication Services. When anonymous meeting join is enabled, both types of clients may be used by default. This optional parameter can be used to block one of the client types that can be used. The allowed values are ACS (to block the use of Azure Communication Services clients) or Teams (to block the use of Teams clients). Both can also be specified, separated by a comma, but this is equivalent to disabling anonymous join completely. | |
| **ChannelRecordingDownload** | Write | String | Determines how channel meeting recordings are saved, permissioned, and who can download them. | |
| **ExplicitRecordingConsent** | Write | String | N/A | |
| **ForceStreamingAttendeeMode** | Write | String | N/A | |
| **InfoShownInReportMode** | Write | String | N/A | |
| **LiveInterpretationEnabledType** | Write | String | Determines how meeting organizers can configure a meeting for language interpretation, select attendees of the meeting to become interpreters that other attendees can select and listen to the real-time translation they provide. | |
| **LiveStreamingMode** | Write | String | Determines whether you provide support for your users to stream their Teams meetings to large audiences through Real-Time Messaging Protocol (RTMP). | `Disabled`, `Enabled` |
| **MeetingInviteLanguages** | Write | String | Controls how the join information in meeting invitations is displayed by enforcing a common language or enabling up to two languages to be displayed. Note: All Teams supported languages can be specified using language codes. | |
| **QnAEngagementMode** | Write | String | N/A | |
| **RoomPeopleNameUserOverride** | Write | String | N/A | |
| **SpeakerAttributionMode** | Write | String | Possible values: EnabledUserOverride or Disabled. | `Disabled`, `EnabledUserOverride` |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Teams Global Admin. | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |


## Description

This resource configures the Teams Meeting Policies.

More information: https://docs.microsoft.com/en-us/microsoftteams/meeting-policies-overview

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

This example adds a new Teams Meeting Policy.

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
        TeamsMeetingPolicy 'ConfigureMeetingPolicy'
        {
            Identity                                   = "Demo Policy"
            AllowAnonymousUsersToStartMeeting          = $False
            AllowChannelMeetingScheduling              = $True
            AllowCloudRecording                        = $True
            AllowExternalParticipantGiveRequestControl = $False
            AllowIPVideo                               = $True
            AllowMeetNow                               = $True
            AllowOutlookAddIn                          = $True
            AllowParticipantGiveRequestControl         = $True
            AllowPowerPointSharing                     = $True
            AllowPrivateMeetingScheduling              = $True
            AllowSharedNotes                           = $True
            AllowTranscription                         = $False
            AllowWhiteboard                            = $True
            AutoAdmittedUsers                          = "Everyone"
            Description                                = "My Demo Meeting Policy"
            MediaBitRateKb                             = 50000
            ScreenSharingMode                          = "EntireScreen"
            Ensure                                     = "Present"
            Credential                                 = $Credscredential
        }
    }
}
```

