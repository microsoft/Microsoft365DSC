# TeamsMeetingBroadcastPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The identifier of the Teams Meeting Broadcast Policy. ||
| **AllowBroadcastScheduling** | Write | Boolean | Specifies whether this user can create broadcast events in Teams. This settng impacts broadcasts that use both self-service and external encoder production methods. ||
| **AllowBroadcastTranscription** | Write | Boolean | Specifies whether real-time transcription and translation can be enabled in the broadcast event. Note: this setting is applicable to broadcast events that use Teams Meeting production only and does not apply when external encoder is used as production method. ||
| **BroadcastAttendeeVisibilityMode** | Write | String | Specifies the attendee visibility mode of the broadcast events created by this user.  This setting controls who can watch the broadcast event - e.g. anyone can watch this event including anonymous users or only authenticated users in my company can watch the event.  Note: this setting is applicable to broadcast events that use Teams Meeting production only and does not apply when external encoder is used as production method. |Everyone, EveryoneInCompany, InvitedUsersInCompany, EveryoneInCompanyAndExternal, InvitedUsersInCompanyAndExternal|
| **BroadcastRecordingMode** | Write | String | Specifies whether broadcast events created by this user are always recorded, never recorded or user can choose whether to record or not. Note: this setting is applicable to broadcast events that use Teams Meeting production only and does not apply when external encoder is used as production method. |AlwaysEnabled, AlwaysDisabled, UserOverride|
| **Ensure** | Write | String | Present ensures the Policy exists, absent ensures it is removed |Present, Absent|
| **Credential** | Required | PSCredential | Credentials of the Teams Admin ||

## Description

This resource is used to configure the Teams Meeting Broadcast Policies.

## Examples

### Example 1

This examples create a new Teams Meeting Broadcast Policy.

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
        TeamsMeetingBroadcastPolicy 'ConfigureMeetingBroadcastPolicy'
        {
            Identity                        = "MyDemoPolicy"
            AllowBroadcastScheduling        = $True
            AllowBroadcastTranscription     = $False
            BroadcastAttendeeVisibilityMode = "EveryoneInCompany"
            BroadcastRecordingMode          = "AlwaysEnabled"
            Ensure                          = "Present"
            Credential                      = $credsGlobalAdmin
        }
    }
}
```

