# TeamsMeetingPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Identity of the Teams Meeting Policy. ||
| **Description** | Write | String | Description of the Teams Meeting Policy. ||
| **AllowChannelMeetingScheduling** | Write | Boolean | Determines whether a user can schedule channel meetings. Set this to TRUE to allow a user to schedule channel meetings. Set this to FALSE to prohibit the user from scheduling channel meetings. Note this only restricts from scheduling and not from joining a meeting scheduled by another user. ||
| **AllowMeetNow** | Write | Boolean | Determines whether a user can start ad-hoc meetings. Set this to TRUE to allow a user to start ad-hoc meetings. Set this to FALSE to prohibit the user from starting ad-hoc meetings. ||
| **AllowPrivateMeetNow** | Write | Boolean | Determines whether a user can start private ad-hoc meetings. Set this to TRUE to allow a user to start private ad-hoc meetings. Set this to FALSE to prohibit the user from starting private ad-hoc meetings. ||
| **MeetingChatEnabledType** | Write | String | Determines whether or not Chat will be enabled or disabled for meetings. |Disabled, Enabled|
| **LiveCaptionsEnabledType** | Write | String | Determines whether a user should have the option to view live captions or not in a meeting. |Disabled, DisabledUserOverride|
| **AllowIPAudio** | Write | Boolean | Determines whether audio is enabled in a user's meetings or calls. Set this to TRUE to allow the user to share their audioo. Set this to FALSE to prohibit the user from sharing their audio. ||
| **AllowIPVideo** | Write | Boolean | Determines whether video is enabled in a user's meetings or calls. Set this to TRUE to allow the user to share their video. Set this to FALSE to prohibit the user from sharing their video. ||
| **AllowEngagementReport** | Write | String | Determines whether or not a meeting Organizer can track join and leave times for all users within their meetings as well as download a roster. |Enabled, Disabled|
| **IPAudioMode** | Write | String | Determines whether or not a user can use audio in a meeting that supports it. |EnabledOutgoingIncoming, Disabled|
| **IPVideoMode** | Write | String | Determines whether or not a user can use video in a meeting that supports it.  Can only be enabled if IPAudioMode is enabled |EnabledOutgoingIncoming, Disabled|
| **AllowAnonymousUsersToDialOut** | Write | Boolean | CURRENTLY DISABLED: Determines whether anonymous users can use the Call Me At feature for meeting audio. ||
| **AllowAnonymousUsersToStartMeeting** | Write | Boolean | Determines whether anonymous users can initiate a meeting. Set this to TRUE to allow anonymous users to initiate a meeting. Set this to FALSE to prohibit them from initiating a meeting. ||
| **AllowPrivateMeetingScheduling** | Write | Boolean | Determines whether a user can schedule private meetings. Set this to TRUE to allow a user to schedule private meetings. Set this to FALSE to prohibit the user from scheduling private meetings. Note this only restricts from scheduling and not from joining a meeting scheduled by another user. ||
| **AutoAdmittedUsers** | Write | String | Determines what types of participants will automatically be added to meetings organized by this user. Set this to EveryoneInCompany if you would like meetings to place every external user in the lobby but allow all users in the company to join the meeting immediately. Set this to Everyone if you'd like to admit anonymous users by default. Set this to EveryoneInSameAndFederatedCompany if you would like meetings to allow federated users to join like your company's users, but place all other external users in a lobby. Set this to InvitedUsers if you would like meetings to allow only the invited users. |EveryoneInCompany, Everyone, EveryoneInSameAndFederatedCompany, OrganizerOnly, InvitedUsers|
| **AllowPSTNUsersToBypassLobby** | Write | Boolean | Determines whether PSTN users should be automatically admitted to the meetings. Set this to TRUE to allow the PSTN user to be able bypass the meetinglobby. Set this to FALSE to prohibit the PSTN user from bypassing the meetinglobby. ||
| **AllowCloudRecording** | Write | Boolean | Determines whether cloud recording is allowed in a user's meetings. Set this to TRUE to allow the user to be able to record meetings. Set this to FALSE to prohibit the user from recording meetings. ||
| **AllowRecordingStorageOutsideRegion** | Write | Boolean | Determines whether cloud recording can be stored out of region for go-local tenants where recording is not yet enabled. ||
| **DesignatedPresenterRoleMode** | Write | String | Determines if users can change the default value of the Who can present? setting in Meeting options in the Teams client. This policy setting affects all meetings, including Meet Now meetings. |OrganizerOnlyUserOverride, EveryoneInCompanyUserOverride, EveryoneUserOverride|
| **RecordingStorageMode** | Write | String | Determines whether recordings will be stored in Stream or OneDrive for Business. |Stream, OneDriveForBusiness|
| **AllowOutlookAddIn** | Write | Boolean | Determines whether a user can schedule Teams Meetings in Outlook desktop client. Set this to TRUE to allow the user to be able to schedule Teams meetings in Outlook client. Set this to FALSE to prohibit a user from scheduling Teams meeting in Outlook client. ||
| **AllowPowerPointSharing** | Write | Boolean | Determines whether Powerpoint sharing is allowed in a user's meetings. Set this to TRUE to allow. Set this to FALSE to prohibit. ||
| **AllowParticipantGiveRequestControl** | Write | Boolean | Determines whether participants can request or give control of screen sharing during meetings scheduled by this user. Set this to TRUE to allow the user to be able to give or request control. Set this to FALSE to prohibit the user from giving, requesting control in a meeting. ||
| **AllowExternalParticipantGiveRequestControl** | Write | Boolean | Determines whether external participants can request or give control of screen sharing during meetings scheduled by this user. Set this to TRUE to allow the user to be able to give or request control. Set this to FALSE to prohibit an external user from giving or requesting control in a meeting. ||
| **AllowSharedNotes** | Write | Boolean | Determines whether users are allowed to take shared notes. Set this to TRUE to allow. Set this to FALSE to prohibit. ||
| **AllowWhiteboard** | Write | Boolean | Determines whether whiteboard is allowed in a user's meetings. Set this to TRUE to allow. Set this to FALSE to prohibit. ||
| **AllowTranscription** | Write | Boolean | Determines whether real-time and/or post-meeting captions and transcriptions are allowed in a user's meetings. Set this to TRUE to allow. Set this to FALSE to prohibit. ||
| **MediaBitRateKb** | Write | UInt32 | Determines the media bit rate for audio/video/app sharing transmissions in meetings. ||
| **ScreenSharingMode** | Write | String | Determines the mode in which a user can share a screen in calls or meetings. Set this to SingleApplication to allow the user to share an application at a given point in time. Set this to EntireScreen to allow the user to share anything on their screens. Set this to Disabled to prohibit the user from sharing their screens. |SingleApplication, EntireScreen, Disabled|
| **VideoFiltersMode** | Write | String | Determines which background filters are available to meeting attendees. |NoFilters, BlurOnly, BlurAndDefaultBackgrounds, AllFilters|
| **AllowOrganizersToOverrideLobbySettings** | Write | Boolean | Determines whether organizers can override lobby settings for both VOIP and PSTN. Set this to TRUE to allow. Set this to FALSE to prohibit. ||
| **PreferredMeetingProviderForIslandsMode** | Write | String | Determines which Outlook Add-in the user will get as preferred Meeting provider(TeamsAndSfb or Teams). |TeamsAndSfb, Teams|
| **AllowNDIStreaming** | Write | Boolean | Determines whether a user is able to use NDI (Network Device Interface) in meetings - both for output and input streams. ||
| **AllowUserToJoinExternalMeeting** | Write | String | Determines what types of external meetings users can join. Enabled is able join all external meetings. |Enabled, FederatedOnly, Disabled|
| **EnrollUserOverride** | Write | String | Determines whether or not users will be able to enroll/capture their Biometric data: Face & Voice. |Disabled, Enabled|
| **RoomAttributeUserOverride** | Write | String | Determines whether or not biometric data will be used to distinguish and or attribute in the transcript. |Off, Distinguish, Attribute|
| **StreamingAttendeeMode** | Write | String | Determines whether or not meetings created by users with this policy are able to utilize the meeting overflow capability. |Disabled, Enabled|
| **AllowBreakoutRooms** | Write | Boolean | Determines whether or not meetings created by users with this policy are able to utilize the Breakout Rooms feature. ||
| **TeamsCameraFarEndPTZMode** | Write | String | Determines whether or not meetings created by users with this policy are able to utilize the Camera Far-End PTZ Mode. |Disabled, Enabled|
| **AllowMeetingReactions** | Write | Boolean | Determines whether or not meetings created by users with this policy are able to utilize the Meeting Reactions feature. ||
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. |Present, Absent|
| **Credential** | Required | PSCredential | Credentials of the Teams Global Admin. ||


# TeamsMeetingPolicy

This resource configures the Teams Meeting Policies.

## Examples

### Example 1

This example adds a new Teams Meeting Policy.

```powershell
Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
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
            Credential                                 = $credsglobaladmin
        }
    }
}
```

