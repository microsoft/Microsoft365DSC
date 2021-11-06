# TeamsGuestMeetingConfiguration

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The only valid input is Global - the tenant wide configuration |Global|
| **AllowIPVideo** | Write | Boolean | Determines whether video is enabled in a user's meetings or calls. Set this to TRUE to allow guests to share their video. Set this to FALSE to prohibit guests from sharing their video. ||
| **ScreenSharingMode** | Write | String | Determines the mode in which guests can share a screen in calls or meetings. Set this to SingleApplication to allow the user to share an application at a given point in time. Set this to EntireScreen to allow the user to share anything on their screens. Set this to Disabled to prohibit the user from sharing their screens. |Disabled, EntireScreen, SingleApplication|
| **AllowMeetNow** | Write | Boolean | Determines whether guests can start ad-hoc meetings. Set this to TRUE to allow guests to start ad-hoc meetings. Set this to FALSE to prohibit guests from starting ad-hoc meetings. ||
| **Credential** | Required | PSCredential | Credentials of the Teams Admin ||

## Description

This resource is used to configure the Teams Guest Meetings Configuration.

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
        $credsGlobalAdmin
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
            Credential         = $credsGlobalAdmin
        }
    }
}
```

