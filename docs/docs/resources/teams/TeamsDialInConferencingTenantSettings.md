# TeamsDialInConferencingTenantSettings

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Only accepted value is Yes. |Yes|
| **AllowPSTNOnlyMeetingsByDefault** | Write | Boolean | Specifies the default value that gets assigned to the 'AllowPSTNOnlyMeetings' setting of users when they are enabled for dial-in conferencing, or when a user's dial-in conferencing provider is set to Microsoft. If set to $true, the 'AllowPSTNOnlyMeetings' setting of the user will also be set to true. If $false, the user setting will be false. The default value for AllowPSTNOnlyMeetingsByDefault is $false. ||
| **AutomaticallyMigrateUserMeetings** | Write | Boolean | Automatically Migrate User Meetings. ||
| **AutomaticallyReplaceAcpProvider** | Write | Boolean | Automatically replace ACP Provider. ||
| **AutomaticallySendEmailsToUsers** | Write | Boolean | Specifies whether advisory emails will be sent to users when the events listed below occur. Setting the parameter to $true enables the emails to be sent, $false disables the emails. The default is $true. ||
| **EnableDialOutJoinConfirmation** | Write | Boolean | Enable Dial out join confirmation. ||
| **EnableEntryExitNotifications** | Write | Boolean | Specifies if, by default, announcements are made as users enter and exit a conference call. Set to $true to enable notifications, $false to disable notifications. The default is $true. ||
| **EntryExitAnnouncementsType** | Write | String | Supported entry and exit announcement type. ||
| **MaskPstnNumbersType** | Write | String | This parameter allows tenant administrators to configure masking of PSTN participant phone numbers in the roster view for Microsoft Teams meetings enabled for Audio Conferencing, scheduled within the organization. Possible values are MaskedForExternalUsers, MaskedForAllUsers or NoMasking |MaskedForExternalUsers, MaskedForAllUsers, NoMasking|
| **PinLength** | Write | UInt32 | Specifies the number of digits in the automatically generated PINs. Organizers can enter their PIN to start a meeting they scheduled if they join via phone and are the first person to join. The minimum value is 4, the maximum is 12, and the default is 5. ||
| **Credential** | Required | PSCredential | Credentials of the Teams Global Admin. ||


# TeamsUserCallingSettings

### Description

This resource configures a Teams User's Calling Settings.

More information: https://learn.microsoft.com/en-us/microsoftteams/user-call-settings

## Examples

### Example 1

This example configures the Teams Dial In Conferencing Tenant Settings.

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
        TeamsDialInConferencingTenantSettings 'TenantSettings'
        {
            AllowPSTNOnlyMeetingsByDefault   = $False;
            AutomaticallyMigrateUserMeetings = $True;
            AutomaticallyReplaceAcpProvider  = $False;
            AutomaticallySendEmailsToUsers   = $True;
            Credential                       = $credsCredential;
            EnableDialOutJoinConfirmation    = $False;
            EnableEntryExitNotifications     = $True;
            EntryExitAnnouncementsType       = "ToneOnly";
            IsSingleInstance                 = "Yes";
            MaskPstnNumbersType              = "MaskedForExternalUsers";
            PinLength                        = 8;
        }
    }
}
```

