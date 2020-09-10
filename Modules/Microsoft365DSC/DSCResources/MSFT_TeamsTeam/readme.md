# TeamsTeam

## Description

This resource configures or creates a new Team.

## Parameters

Ensure

- Required: No (defaults to 'Present')
- Description: `Present` is the only value accepted.
  Configurations using `Ensure = 'Absent'` will throw an Error!

DisplayName

- Required: No
- Description: Name of the Team

Description

- Required: No
- Description: Description of the Team

AllowAddRemoveApps

- Required: No
- Description: Boolean value that determines whether or not members
  (not only owners) are allowed to add apps to the team.

AllowChannelMentions

- Required: No
- Description: Boolean value that determines whether or not channels
  in the team can be @ mentioned so that all users who follow the
  channel are notified.

AllowCreateUpdateChannels

- Required: No
- Description: Setting that determines whether or not members (and not
  just owners) are allowed to create channels.

AllowCreateUpdateRemoveConnectors

- Required: No
- Description: Setting that determines whether or not members (and not
  only owners) can manage connectors in the team.

AllowCreateUpdateRemoveTabs

- Required: No
- Description: Setting that determines whether or not members (and not
  only owners) can manage tabs in channels.

AllowCustomMemes

- Required: No
- Description: Setting that determines whether or not members can
  use the custom memes functionality in teams.

AllowDeleteChannels

- Required: No
- Description: Setting that determines whether or not members (and not
  only owners) can delete channels in the team.

AllowGiphy

- Required: No
- Description: Setting that determines whether or not giphy can be
  used in the team.

AllowGuestCreateUpdateChannels

- Required: No
- Description: Setting that determines whether or not guests can create
  channels in the team.

AllowGuestDeleteChannels

- Required: No
- Description: Setting that determines whether or not guests can delete
  in the team.

AllowOwnerDeleteMessages

- Required: No
- Description: Setting that determines whether or not owners can delete
  messages that they or other members of the team have posted.

AllowStickersAndMemes

- Required: No
- Description: Setting that determines whether stickers and memes usage
  is allowed in the team.

AllowTeamMentions

- Required: No
- Description: Setting that determines whether the entire team can be @
  mentioned (which means that all users will be notified)

AllowUserDeleteMessages

- Required: No
- Description: Setting that determines whether or not members can delete
  messages that they have posted.

AllowUserEditMessages

- Required: No
- Description: Setting that determines whether or not users can edit
  messages that they have posted.

GiphyContentRating

- Required: No
- Description: Setting that determines the level of sensitivity of giphy
  usage that is allowed in the team. Accepted values are "Strict"
  or "Moderate".

MailNickName

- Required: No
- Description: The MailNickName parameter specifies the alias for the
  associated Office 365 Group. This value will be used for the mail
  enabled object and will be used as PrimarySmtpAddress for this
  Office 365 Group. The value of the MailNickName parameter has
  to be unique across your tenant.

Owner

- Required: No
- Description: Owner of the Team.

Visibility

- Required: No
- Description: Set to "Public" to allow all users in your organization to
  join the group by default. Set to "Private" to require that an owner
  approves the join request.

GroupId

- Required: No
- Description: There can be duplicate DisplayName for Teams so if
  if duplicate Teams exist you can pass in GroupID to filter and
  retrieve unique team.

GlobalAdminAccount

- Required: Yes
- Description: Credentials of the Office365 Tenant Admin

## Example

```PowerShell
        TeamsTeam TeamConfig {
            DisplayName                       = "TestTeam"
            Ensure                            = 'Present'
            Descrip                           = "Test team description"
            Visibility                        = "Private"
            MailNickName                      = "testteam"
            AllowUserEditMessages             = $true
            AllowUserDeleteMessages           = $false
            AllowOwnerDeleteMessages          = $false
            AllowTeamMentions                 = $false
            AllowChannelMentions              = $false
            AllowCreateUpdateChannels         = $false
            AllowDeleteChannels               = $false
            AllowAddRemoveApps                = $false
            AllowCreateUpdateRemoveTabs       = $false
            AllowCreateUpdateRemoveConnectors = $false
            AllowGiphy                        = $True
            GiphyContentRating                = "Moderate"
            AllowStickersAndMemes             = $True
            AllowCustomMemes                  = $True
            AllowGuestCreateUpdateChannels    = $false
            AllowGuestDeleteChannels          = $false
            GlobalAdminAccount                = $GlobalAdminAccount
        }
```
