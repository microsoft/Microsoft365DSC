# TeamsUpgradePolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Identity of the Teams Upgrade Policy. ||
| **Users** | Write | StringArray[] | List of users that will be granted the Upgrade Policy to. ||
| **MigrateMeetingsToTeams** | Write | Boolean | Specifies whether to move existing Skype for Business meetings organized by the user to Teams. This parameter can only be true if the mode of the specified policy instance is either TeamsOnly or SfBWithTeamsCollabAndMeetings, and if the policy instance is being granted to a specific user. It not possible to trigger meeting migration when granting TeamsUpgradePolicy to the entire tenant. ||
| **Credential** | Required | PSCredential | Credentials of the Teams Admin ||


# TeamsUpgradePolicy

This resource configures the Teams Upgrade policies.

## Examples

### Example 1

This example demonstrates how to assign users to a Teams Upgrade Policy.

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
        TeamsUpgradePolicy 'ConfigureIslandsPolicy'
        {
            Identity               = 'Islands'
            Users                  = @("John.Smith@contoso.com", "Nik.Charlebois@contoso.com")
            MigrateMeetingsToTeams = $true
            Credential             = $credsGlobalAdmin
        }
    }
}
```

