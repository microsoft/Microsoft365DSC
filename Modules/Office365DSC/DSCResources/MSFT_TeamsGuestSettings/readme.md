# TeamsGuestSettings

## Description

This resource configures team guest settings within a Team

## Parameters

    Ensure
      - Required: No (Defaults to 'Present')
      - Description: `Present` is the only value accepted.
          Configurations using `Ensure = 'Absent'` will throw an Error!
    TeamName
      - Required: Yes
      - Description: Name of the Team

    AllowCreateUpdateChannels
      - Required: No
      - Description: True or false to allow team members to create or update
                     team channels

    AllowDeleteChannels
      - Required: No
      - Description:True or false to allow team members to delete team channels

    GlobalAdminAccount
      - Required: Yes
      - Description: Credentials of the SharePoint Global Admin

## Example

```PowerShell
        TeamsGuestSettings SetGuestMemberSettings {
            TeamName                             = 'TestTeam'
            Ensure                               = 'Present'
            AllowCreateUpdateChannels            = '$True'
            AllowDeleteChannels                  = '$True'
            GlobalAdminAccount              = $GlobalAdminAccount
        }
```
