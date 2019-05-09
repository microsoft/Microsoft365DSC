# TeamsMessageSettings

## Description

This resource configures team message settings within a Team.

## Parameters

    Ensure
      - Required: No (Defaults to 'Present')
      - Description: `Present` is the only value accepted.
          Configurations using `Ensure = 'Absent'` will throw an Error!

    TeamName
      - Required: Yes
      - Description: Name of the Team

    AllowUserEditMessages
      - Required: No
      - Description: True or false to allow team members to edit messages in
         team channels

    AllowUserDeleteMessages
      - Required: No
      - Description: True or false to allow team members to delete messages
                      in team channels

    AllowOwnerDeleteMessages
      - Required: No
      - Description: True or false to allow team owner to delete messages
                     in team

    AllowTeamMentions
      - Required: No
      - Description: True or false to allow @team or @[team name] mentions.
          This will notify everyone in the team

    AllowChannelMentions
      - Required: No
      - Description: True or false Allow @channel or @[channel name] mentions.
              This will notify members who've favorited that channel

    GlobalAdminAccount
      - Required: Yes
      - Description: Credentials of the Office365 Tenant Admin

## Example

```PowerShell
        TeamsMemberSettings SetTeamMemberSettings {
            TeamName                   = 'TestTeam'
            Ensure                     = 'Present'
            AllowUserEditMessages      = $True
            AllowUserDeleteMessages    = $True
            AllowOwnerDeleteMessages   = $True
            AllowTeamMentions          = $True
            AllowChannelMentions       = $True
            GlobalAdminAccount         = $GlobalAdminAccount
        }
```
