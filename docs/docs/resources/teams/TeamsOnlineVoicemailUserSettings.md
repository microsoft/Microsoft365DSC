# TeamsOnlineVoicemailUserSettings

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter represents the ID of the specific user in your organization; this can be either a SIP URI or an Object ID. | |
| **CallAnswerRule** | Write | String | The CallAnswerRule parameter represents the value of the call answer rule, which can be any of the following: DeclineCall, PromptOnly, PromptOnlyWithTransfer, RegularVoicemail, VoicemailWithTransferOption. | `DeclineCall`, `PromptOnly`, `PromptOnlyWithTransfer`, `RegularVoicemail`, `VoicemailWithTransferOption` |
| **DefaultGreetingPromptOverwrite** | Write | String | The DefaultGreetingPromptOverwrite parameter represents the contents that overwrite the default normal greeting prompt. If the user's normal custom greeting is not set and DefaultGreetingPromptOverwrite is not empty, the voicemail service will play this overwrite greeting instead of the default normal greeting in the voicemail deposit scenario. | |
| **DefaultOofGreetingPromptOverwrite** | Write | String | The DefaultOofGreetingPromptOverwrite parameter represents the contents that overwrite the default out-of-office greeting prompt. If the user's out-of-office custom greeting is not set and DefaultOofGreetingPromptOverwrite is not empty, the voicemail service will play this overwrite greeting instead of the default out-of-office greeting in the voicemail deposit scenario. | |
| **OofGreetingEnabled** | Write | Boolean | The OofGreetingEnabled parameter represents whether to play out-of-office greeting in voicemail deposit scenario. | |
| **OofGreetingFollowAutomaticRepliesEnabled** | Write | Boolean | The OofGreetingFollowAutomaticRepliesEnabled parameter represents whether to play out-of-office greeting in voicemail deposit scenario when user set automatic replies in Outlook. | |
| **OofGreetingFollowCalendarEnabled** | Write | Boolean | The OofGreetingFollowCalendarEnabled parameter represents whether to play out-of-office greeting in voicemail deposit scenario when user set out-of-office in calendar. | |
| **PromptLanguage** | Write | String | The PromptLanguage parameter represents the language that is used to play voicemail prompts. | |
| **ShareData** | Write | Boolean | Specifies whether voicemail and transcription data is shared with the service for training and improving accuracy. | |
| **TransferTarget** | Write | String | The TransferTarget parameter represents the target to transfer the call when call answer rule set to PromptOnlyWithTransfer or VoicemailWithTransferOption. Value of this parameter should be a SIP URI of another user in your organization. For user with Enterprise Voice enabled, a valid telephone number could also be accepted as TransferTarget. | |
| **VoicemailEnabled** | Write | Boolean | The VoicemailEnabled parameter represents whether to enable voicemail service. If set to $false, the user has no voicemail service. | |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Teams Global Admin. | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |


## Description

This resource configures a Teams User's Online Voicemail Settings.

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

    - Organization.Read.All

- **Update**

    - Organization.Read.All

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
        TeamsOnlineVoicemailUserSettings 'AssignOnlineVoicemailUserSettings'
        {
            CallAnswerRule                           = "RegularVoicemail";
            Credential                               = $credsCredential;
            DefaultGreetingPromptOverwrite           = "Hellow World!";
            Ensure                                   = "Present";
            Identity                                 = "John.Smith@contoso.com";
            OofGreetingEnabled                       = $False;
            OofGreetingFollowAutomaticRepliesEnabled = $False;
            OofGreetingFollowCalendarEnabled         = $False;
            PromptLanguage                           = "en-US";
            ShareData                                = $False;
            VoicemailEnabled                         = $True;
        }
    }
}
```

