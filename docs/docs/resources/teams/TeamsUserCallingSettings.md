# TeamsUserCallingSettings

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity of the user to set call forwarding, simultaneous ringing and call group settings for. Can be specified using the ObjectId or the SIP address. | |
| **GroupNotificationOverride** | Write | String | The group notification override that will be set on the specified user. The supported values are Ring, Mute and Banner. | `Ring`, `Mute`, `Banner` |
| **CallGroupOrder** | Write | String | The order in which to call members of the Call Group. The supported values are Simultaneous and InOrder. | |
| **CallGroupTargets** | Write | StringArray[] | The members of the Call Group. You need to always specify the full set of members as the parameter value. What you set here will overwrite the current call group membership. | |
| **IsUnansweredEnabled** | Write | Boolean | This parameter controls whether forwarding for unasnwered calls is enabled or not. | |
| **UnansweredDelay** | Write | String | The time the call will ring the user before it is forwarded to the unanswered target. The supported format is hh:mm:ss and the delay range needs to be between 10 and 60 seconds in 10 seconds increments, i.e. 00:00:10, 00:00:20, 00:00:30, 00:00:40, 00:00:50 and 00:01:00. The default value is 20 seconds. | |
| **UnansweredTarget** | Write | String | The unanswered target. Supported type of values are ObjectId, SIP address and phone number. For phone numbers we support the following types of formats: E.164 (+12065551234 or +1206555000;ext=1234) or non-E.164 like 1234. | |
| **UnansweredTargetType** | Write | String | The unanswered target type. Supported values are Voicemail, SingleTarget, MyDelegates and Group. | `Group`, `MyDelegates`, `SingleTarget`, `Voicemail` |
| **IsForwardingEnabled** | Write | Boolean | This parameter controls whether forwarding is enabled or not. | |
| **ForwardingType** | Write | String | The type of forwarding to set. Supported values are Immediate and Simultaneous | `Immediate`, `Simultaneous` |
| **ForwardingTargetType** | Write | String | The forwarding target type. Supported values are Voicemail, SingleTarget, MyDelegates and Group. Voicemail is only supported for Immediate forwarding. | `Group`, `MyDelegates`, `SingleTarget`, `Voicemail` |
| **ForwardingTarget** | Write | String | The forwarding target. Supported types of values are ObjectId's, SIP addresses and phone numbers. For phone numbers we support the following types of formats: E.164 (+12065551234 or +1206555000;ext=1234) or non-E.164 like 1234. | |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Teams Global Admin. | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |


## Description

This resource configures a Teams User's Calling Settings.

More information: https://learn.microsoft.com/en-us/microsoftteams/user-call-settings

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - None

- **Update**

    - None

#### Application permissions

- **Read**

    - None

- **Update**

    - None

## Examples

### Example 1

This example adds a new Teams Channels Policy.

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
        TeamsUserCallingSettings 'AssignCallingSettings'
        {
            CallGroupOrder       = "Simultaneous";
            Credential           = $credsCredential;
            Ensure               = "Present";
            Identity             = "John.Smith@contoso.com";
            UnansweredDelay      = "00:00:20";
        }
    }
}
```

