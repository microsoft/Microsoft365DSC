# TeamsChannelsPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Identity of the Teams Channel Policy. ||
| **Description** | Write | String | Description of the Teams Channel Policy. ||
| **AllowChannelSharingToExternalUser** | Write | Boolean | Determines whether a user is allowed to share a shared channel with an external user. Set this to TRUE to allow. Set this FALSE to prohibit. ||
| **AllowOrgWideTeamCreation** | Write | Boolean | Determines whether a user is allowed to create an org-wide team. Set this to TRUE to allow. Set this FALSE to prohibit. ||
| **AllowPrivateTeamDiscovery** | Write | Boolean | Determines whether a user is allowed to discover private teams in suggestions and search results. Set this to TRUE to allow. Set this FALSE to prohibit. ||
| **AllowPrivateChannelCreation** | Write | Boolean | Determines whether a user is allowed to create a private channel. Set this to TRUE to allow. Set this FALSE to prohibit. ||
| **AllowSharedChannelCreation** | Write | Boolean | Determines whether a user is allowed to create a shared channel. Set this to TRUE to allow. Set this FALSE to prohibit. ||
| **AllowUserToParticipateInExternalSharedChannel** | Write | Boolean | Determines whether a user is allowed to participate in a shared channel that has been shared by an external user. Set this to TRUE to allow. Set this FALSE to prohibit. ||
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. |Present, Absent|
| **Credential** | Required | PSCredential | Credentials of the Teams Global Admin ||


# TeamsChannelsPolicy

This resource configures a Teams Channel Policy.

More information: https://docs.microsoft.com/en-us/microsoftteams/teams-policies

## Examples

### Example 1

This example adds a new Teams Channels Policy.

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
        TeamsChannelsPolicy 'ConfigureChannelsPolicy'
        {
            Identity                    = 'New Channels Policy'
            AllowOrgWideTeamCreation    = $True
            AllowPrivateChannelCreation = $True
            AllowPrivateTeamDiscovery   = $True
            Description                 = 'This is an example'
            Ensure                      = 'Present'
            Credential                  = $credsGlobalAdmin
        }
    }
}
```

