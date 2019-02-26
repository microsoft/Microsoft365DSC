# TeamsMemberSettings

## Description

This resource configures team members settings within a Team.

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
      - Description: True or false to allow team members to delete team channels

    AllowAddRemoveApps
      - Required: No
      - Description: True or false to allow team members to add or remove
                     team apps

    AllowCreateUpdateRemoveTabs
      - Required: No
      - Description: True or false to allow team members to create, update,
                     and delete team tabs

    AllowCreateUpdateRemoveConnectors
      - Required: No
      - Description: True or false to allow team members to create, update,
                    and delete team connectors

    GlobalAdminAccount
      - Required: Yes
      - Description: Credentials of the SharePoint Global Admin

## Example

```PowerShell
        TeamsMemberSettings SetTeamMemberSettings {
            TeamName                             = 'TestTeam'
            Ensure                               = 'Present'
            AllowCreateUpdateChannels            = '$True'
            AllowDeleteChannels                  = '$True'
            AllowAddRemoveApps                   = '$True'
            AllowCreateUpdateRemoveTabs          = '$True'
            AllowCreateUpdateRemoveConnectors    = '$True'
            GlobalAdminAccount              = $GlobalAdminAccount
        }
```
