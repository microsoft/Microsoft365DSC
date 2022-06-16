﻿# TeamsUpgradeConfiguration

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Specifies the resource is a single instance, the value must be 'Yes' |Yes|
| **DownloadTeams** | Write | Boolean | The DownloadTeams property allows admins to control whether the Skype for Business client should automatically download Teams in the background. This Boolean setting is only honored on Windows clients, and only for certain values of the user's TeamsUpgradePolicy. If NotifySfbUser=true or if Mode=TeamsOnly in TeamsUpgradePolicy, this setting is honored. Otherwise it is ignored. ||
| **SfBMeetingJoinUx** | Write | String | The SfBMeetingJoinUx property allows admins to specify which app is used to join Skype for Business meetings, even after the user has been upgraded to Teams. Allowed values are: 'SkypeMeetingsApp' and 'NativeLimitedClient'. 'NativeLimitedClient' means the existing Skype for Business rich client will be used, but since the user is upgraded, only meeting functionality is available. Calling and Messaging are done via Teams. 'SkypeMeetingsApp' means use the web-downloadable app. This setting can be useful for organizations that have upgraded to Teams and no longer want to install Skype for Business on their users' computers. |SkypeMeetingsApp, NativeLimitedClient|
| **Credential** | Required | PSCredential | Credentials of the Teams Admin ||


# TeamsUpgradeConfiguration

### Description

This resource configures the Teams Upgrade settings.

More information: https://docs.microsoft.com/en-us/MicrosoftTeams/migration-interop-guidance-for-teams-with-skype

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
        TeamsUpgradeConfiguration 'ConfigureUpgradeConfig'
        {
            IsSingleInstance = "Yes"
            DownloadTeams    = $True
            SfBMeetingJoinUx = "NativeLimitedClient"
            Credential       = $credsGlobalAdmin
        }
    }
}
```

