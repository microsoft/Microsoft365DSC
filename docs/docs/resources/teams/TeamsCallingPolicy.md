﻿# TeamsCallingPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Identity of the Teams Calling Policy. ||
| **Description** | Write | String | Description of the Teams Calling Policy. ||
| **AllowPrivateCalling** | Write | Boolean | Controls all calling capabilities in Teams. Turning this off will turn off all calling functionality in Teams. If you use Skype for Business for calling, this policy will not affect calling functionality in Skype for Business. ||
| **AllowVoicemail** | Write | String | Enables inbound calls to be routed to voice mail. Valid options are: AlwaysEnabled, AlwaysDisabled, UserOverride. |AlwaysEnabled, AlwaysDisabled, UserOverride|
| **AllowCallGroups** | Write | Boolean | Enables inbound calls to be routed to call groups. ||
| **AllowDelegation** | Write | Boolean | Enables inbound calls to be routed to delegates; allows delegates to make outbound calls on behalf of the users for whom they have delegated permissions. ||
| **AllowCallForwardingToUser** | Write | Boolean | Enables call forwarding or simultaneous ringing of inbound calls to other users in your tenant. ||
| **AllowCallForwardingToPhone** | Write | Boolean | Enables call forwarding or simultaneous ringing of inbound calls to any phone number. ||
| **AllowWebPSTNCalling** | Write | Boolean | Allows PSTN calling from the Team web client ||
| **PreventTollBypass** | Write | Boolean | Setting this parameter to True will send calls through PSTN and incur charges rather than going through the network and bypassing the tolls. ||
| **BusyOnBusyEnabledType** | Write | String | Setting this parameter lets you configure how incoming calls are handled when a user is already in a call or conference or has a call placed on hold. New or incoming calls will be rejected with a busy signal. Valid options are: Enabled, Disabled and Unanswered. |Enabled, Disabled, Unanswered|
| **MusicOnHoldEnabledType** | Write | String | Setting this parameter allows you to turn on or turn off music on hold when a PSTN caller is placed on hold. It is turned on by default. Valid options are: Enabled, Disabled, UserOverride. For now setting the value to UserOverride is the same as Enabled. This setting does not apply to call park and SLA boss delegate features. Valid options are: Enabled, Disabled, UserOverride. |Enabled, Disabled, UserOverride|
| **SafeTransferEnabled** | Write | String | This parameter is not available for use. Valid options are: Enabled, Disabled, UserOverride. |Enabled, Disabled, UserOverride|
| **AllowCloudRecordingForCalls** | Write | Boolean | Setting this parameter to True will allows 1:1 Calls to be recorded. ||
| **AllowTranscriptionforCalling** | Write | Boolean | Determines whether post-meeting captions and transcriptions are allowed in a user's meetings. Set this to TRUE to allow. Set this to FALSE to prohibit. ||
| **LiveCaptionsEnabledTypeForCalling** | Write | String | Determines whether real-time captions are available for the user in Teams meetings. Set this to DisabledUserOverride to allow user to turn on live captions. Set this to Disabled to prohibit. |DisabledUserOverride, Disabled|
| **AutoAnswerEnabledType** | Write | String | This setting allows the tenant admin to enable or disable the Auto-Answer setting. Valid options are: Enabled, Disabled. |Enabled, Disabled|
| **SpamFilteringEnabledType** | Write | String | Setting this parameter determines whether calls identified as Spam will be rejected or not (probably). Valid options are: Enabled, Disabled. |Enabled, Disabled|
| **Ensure** | Write | String | Present ensures the policyexists, absent ensures it is removed. |Present, Absent|
| **Credential** | Required | PSCredential | Credentials of the Teams Global Admin. ||


# TeamsCallingPolicy

### Description

This resource configures a Teams Calling Policy.

More information: https://docs.microsoft.com/en-us/microsoftteams/teams-calling-policy

## Examples

### Example 1

This example adds a new Teams Calling Policy.

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
        TeamsCallingPolicy 'ConfigureCallingPolicy'
        {
            Identity                   = 'New Calling Policy'
            AllowPrivateCalling        = $false
            AllowVoicemail             = 'UserOverride'
            AllowCallGroups            = $true
            AllowDelegation            = $true
            AllowCallForwardingToUser  = $false
            AllowCallForwardingToPhone = $true
            PreventTollBypass          = $true
            BusyOnBusyEnabledType      = 'Enabled'
            Ensure                     = 'Present'
            Credential                 = $credsGlobalAdmin
        }
    }
}
```

