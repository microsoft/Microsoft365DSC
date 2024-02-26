# TeamsCallQueue

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies a unique name for the Call Queue. | |
| **AgentAlertTime** | Write | UInt16 | The Name parameter specifies a unique name for the Call Queue. | |
| **AllowOptOut** | Write | Boolean | The AllowOptOut parameter indicates whether or not agents can opt in or opt out from taking calls from a Call Queue. | |
| **DistributionLists** | Write | StringArray[] | The DistributionLists parameter lets you add all the members of the distribution lists to the Call Queue. This is a list of distribution list GUIDs. A service wide configurable maximum number of DLs per Call Queue are allowed. Only the first N (service wide configurable) agents from all distribution lists combined are considered for accepting the call. Nested DLs are supported. O365 Groups can also be used to add members to the Call Queue. | |
| **UseDefaultMusicOnHold** | Write | Boolean | The UseDefaultMusicOnHold parameter indicates that this Call Queue uses the default music on hold. This parameter cannot be specified together with MusicOnHoldAudioFileId. | |
| **WelcomeMusicAudioFileId** | Write | String | The WelcomeMusicAudioFileId parameter represents the audio file to play when callers are connected with the Call Queue. This is the unique identifier of the audio file. | |
| **MusicOnHoldAudioFileId** | Write | String | The MusicOnHoldFileContent parameter represents music to play when callers are placed on hold. This is the unique identifier of the audio file. This parameter is required if the UseDefaultMusicOnHold parameter is not specified. | |
| **OverflowAction** | Write | String | The OverflowAction parameter designates the action to take if the overflow threshold is reached. The OverflowAction property must be set to one of the following values: DisconnectWithBusy, Forward, Voicemail, and SharedVoicemail. The default value is DisconnectWithBusy. | `DisconnectWithBusy`, `Forward`, `Voicemail`, `SharedVoicemail` |
| **OverflowActionTarget** | Write | String | The OverflowActionTarget parameter represents the target of the overflow action. If the OverFlowAction is set to Forward, this parameter must be set to a Guid or a telephone number with a mandatory 'tel:' prefix. If the OverflowAction is set to SharedVoicemail, this parameter must be set to a group ID (Microsoft 365, Distribution list, or Mail-enabled security). Otherwise, this parameter is optional. | |
| **OverflowThreshold** | Write | UInt16 | The OverflowThreshold parameter defines the number of calls that can be in the queue at any one time before the overflow action is triggered. The OverflowThreshold can be any integer value between 0 and 200, inclusive. A value of 0 causes calls not to reach agents and the overflow action to be taken immediately. | |
| **TimeoutAction** | Write | String | The TimeoutAction parameter defines the action to take if the timeout threshold is reached. The TimeoutAction property must be set to one of the following values: Disconnect, Forward, Voicemail, and SharedVoicemail. The default value is Disconnect. | `Disconnect`, `Forward`, `Voicemail`, `SharedVoicemail` |
| **TimeoutActionTarget** | Write | String | The TimeoutActionTarget represents the target of the timeout action. If the TimeoutAction is set to Forward, this parameter must be set to a Guid or a telephone number with a mandatory 'tel:' prefix. If the TimeoutAction is set to SharedVoicemail, this parameter must be set to an Office 365 Group ID. Otherwise, this field is optional. | |
| **TimeoutThreshold** | Write | UInt16 | The TimeoutThreshold parameter defines the time (in seconds) that a call can be in the queue before that call times out. At that point, the system will take the action specified by the TimeoutAction parameter. The TimeoutThreshold can be any integer value between 0 and 2700 seconds (inclusive), and is rounded to the nearest 15th interval. For example, if set to 47 seconds, then it is rounded down to 45. If set to 0, welcome music is played, and then the timeout action will be taken. | |
| **RoutingMethod** | Write | String | The RoutingMethod defines how agents will be called in a Call Queue. If the routing method is set to Serial, then agents will be called one at a time. If the routing method is set to Attendant, then agents will be called in parallel. If routing method is set to RoundRobin, the agents will be called using Round Robin strategy so that all agents share the call-load equally. If routing method is set to LongestIdle, the agents will be called based on their idle time, i.e., the agent that has been idle for the longest period will be called. | `Attendant`, `Serial`, `RoundRobin`, `LongestIdle` |
| **PresenceBasedRouting** | Write | Boolean | The PresenceBasedRouting parameter indicates whether or not presence based routing will be applied while call being routed to Call Queue agents. When set to False, calls will be routed to agents who have opted in to receive calls, regardless of their presence state. When set to True, opted-in agents will receive calls only when their presence state is Available. | |
| **ConferenceMode** | Write | Boolean | The ConferenceMode parameter indicates whether or not Conference mode will be applied on calls for this Call queue. Conference mode significantly reduces the amount of time it takes for a caller to be connected to an agent, after the agent accepts the call. | |
| **Users** | Write | StringArray[] | The Users parameter lets you add agents to the Call Queue. This parameter expects a list of user unique identifiers (GUID). | |
| **LanguageId** | Write | String | The LanguageId parameter indicates the language that is used to play shared voicemail prompts. This parameter becomes a required parameter If either OverflowAction or TimeoutAction is set to SharedVoicemail. You can query the supported languages using the Get-CsAutoAttendantSupportedLanguage cmdlet. | |
| **OboResourceAccountIds** | Write | StringArray[] | The OboResourceAccountIds parameter lets you add resource account with phone number to the Call Queue. The agents in the Call Queue will be able to make outbound calls using the phone number on the resource accounts. This is a list of resource account GUIDs. Only Call Queue managed by a Teams Channel will be able to use this feature. | |
| **OverflowDisconnectTextToSpeechPrompt** | Write | String | The OverflowDisconnectTextToSpeechPrompt parameter indicates the Text-to-Speech (TTS) prompt which is played to the caller when being disconnected due to overflow. | |
| **OverflowDisconnectAudioFilePrompt** | Write | String | The OverflowDisconnectAudioFilePrompt parameter indicates the unique identifier for the Audio file prompt which is played to the caller when being disconnected due to overflow. | |
| **OverflowRedirectPersonTextToSpeechPrompt** | Write | String | The OverflowRedirectPersonTextToSpeechPrompt parameter indicates the Text-to-Speech (TTS) prompt which is played to the caller when being redirected to a person in the organization due to overflow. | |
| **OverflowRedirectPersonAudioFilePrompt** | Write | String | The OverflowRedirectPersonAudioFilePrompt parameter indicates the unique identifier for the Audio file prompt which is played to the caller when being redirected to a person in the organization due to overflow. | |
| **OverflowRedirectVoiceAppTextToSpeechPrompt** | Write | String | The OverflowRedirectVoiceAppsTextToSpeechPrompt parameter indicates the Text-to-Speech (TTS) prompt which is played to the caller when being redirected to a voice application due to overflow. | |
| **OverflowRedirectVoiceAppAudioFilePrompt** | Write | String | The OverflowRedirectVoiceAppAudioFilePrompt parameter indicates the unique identifier for the Audio file prompt which is played to the caller when being redirected to a voice application due to overflow. | |
| **OverflowRedirectPhoneNumberTextToSpeechPrompt** | Write | String | The OverflowRedirectPhoneNumberTextToSpeechPrompt parameter indicates the Text-to-Speech (TTS) prompt which is played to the caller when being redirected to an external PSTN phone number due to overflow. | |
| **OverflowRedirectPhoneNumberAudioFilePrompt** | Write | String | The OverflowRedirectPhoneNumberAudioFilePrompt parameter indicates the unique identifier for the Audio file prompt which is played to the caller when being redirected to an external PSTN phone number due to overflow. | |
| **OverflowRedirectVoicemailTextToSpeechPrompt** | Write | String | The OverflowRedirectVoicemailTextToSpeechPrompt parameter indicates the Text-to-Speech (TTS) prompt which is played to the caller when being redirected to a person's voicemail due to overflow. | |
| **OverflowRedirectVoicemailAudioFilePrompt** | Write | String | The OverflowRedirectVoiceMailAudioFilePrompt parameter indicates the unique identifier for the Audio file prompt which is played to the caller when being redirected to a person's voicemail due to overflow. | |
| **OverflowSharedVoicemailTextToSpeechPrompt** | Write | String | The OverflowRedirectVoicemailTextToSpeechPrompt parameter indicates the Text-to-Speech (TTS) prompt which is played to the caller when being redirected to a person's voicemail due to overflow. | |
| **OverflowSharedVoicemailAudioFilePrompt** | Write | String | The OverflowSharedVoicemailAudioFilePrompt parameter indicates the unique identifier for the Audio file prompt which is to be played as a greeting to the caller when transferred to shared voicemail on overflow. This parameter becomes a required parameter when OverflowAction is SharedVoicemail and OverflowSharedVoicemailTextToSpeechPrompt is null. | |
| **EnableOverflowSharedVoicemailTranscription** | Write | Boolean | The EnableOverflowSharedVoicemailTranscription parameter is used to turn on transcription for voicemails left by a caller on overflow. This parameter is only applicable when OverflowAction is set to SharedVoicemail. | |
| **TimeoutDisconnectTextToSpeechPrompt** | Write | String | The TimeoutDisconnectTextToSpeechPrompt parameter indicates the Text-to-Speech (TTS) prompt which is played to the caller when being disconnected due to timeout. | |
| **TimeoutDisconnectAudioFilePrompt** | Write | String | The TimeoutDisconnectAudioFilePrompt parameter indicates the unique identifier for the Audio file prompt which is played to the caller when being disconnected due to timeout. | |
| **TimeoutRedirectPersonTextToSpeechPrompt** | Write | String | The TimeoutRedirectPersonTextToSpeechPrompt parameter indicates the Text-to-Speech (TTS) prompt which is played to the caller when being redirected to a person in the organization due to timeout. | |
| **TimeoutRedirectPersonAudioFilePrompt** | Write | String | The TimeoutRedirectPersonAudioFilePrompt parameter indicates the unique identifier for the Audio file prompt which is played to the caller when being redirected to a person in the organization due to timeout. | |
| **TimeoutRedirectVoiceAppTextToSpeechPrompt** | Write | String | The TimeoutRedirectVoiceAppsTextToSpeechPrompt parameter indicates the Text-to-Speech (TTS) prompt which is played to the caller when being redirected to a voice application due to timeout. | |
| **TimeoutRedirectVoiceAppAudioFilePrompt** | Write | String | The TimeoutRedirectVoiceAppAudioFilePrompt parameter indicates the unique identifier for the Audio file prompt which is played to the caller when being redirected to a voice application due to timeout. | |
| **TimeoutRedirectPhoneNumberTextToSpeechPrompt** | Write | String | The TimeoutRedirectPhoneNumberTextToSpeechPrompt parameter indicates the Text-to-Speech (TTS) prompt which is played to the caller when being redirected to an external PSTN phone number due to timeout. | |
| **TimeoutRedirectPhoneNumberAudioFilePrompt** | Write | String | The TimeoutRedirectPhoneNumberAudioFilePrompt parameter indicates the unique identifier for the Audio file prompt which is played to the caller when being redirected to an external PSTN phone number due to timeout. | |
| **TimeoutRedirectVoicemailTextToSpeechPrompt** | Write | String | The TimeoutRedirectVoicemailTextToSpeechPrompt parameter indicates the Text-to-Speech (TTS) prompt which is played to the caller when being redirected to a person's voicemail due to timeout. | |
| **TimeoutRedirectVoicemailAudioFilePrompt** | Write | String | The TimeoutRedirectVoiceMailAudioFilePrompt parameter indicates the unique identifier for the Audio file prompt which is played to the caller when being redirected to a person's voicemail due to timeout. | |
| **TimeoutSharedVoicemailTextToSpeechPrompt** | Write | String | The TimeoutSharedVoicemailTextToSpeechPrompt parameter indicates the Text-to-Speech (TTS) prompt which is to be played as a greeting to the caller when transferred to shared voicemail on timeout. This parameter becomes a required parameter when TimeoutAction is SharedVoicemail and TimeoutSharedVoicemailAudioFilePrompt is null. | |
| **TimeoutSharedVoicemailAudioFilePrompt** | Write | String | The TimeoutSharedVoicemailAudioFilePrompt parameter indicates the unique identifier for the Audio file prompt which is to be played as a greeting to the caller when transferred to shared voicemail on timeout. This parameter becomes a required parameter when TimeoutAction is SharedVoicemail and TimeoutSharedVoicemailTextToSpeechPrompt is null. | |
| **EnableTimeoutSharedVoicemailTranscription** | Write | Boolean | The EnableTimeoutSharedVoicemailTranscription parameter is used to turn on transcription for voicemails left by a caller on timeout. This parameter is only applicable when TimeoutAction is set to SharedVoicemail. | |
| **ChannelId** | Write | String | Id of the channel to connect a call queue to. | |
| **ChannelUserObjectId** | Write | String | Guid should contain 32 digits with 4 dashes (xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx). This is the GUID of one of the owners of the team the channels belongs to. | |
| **AuthorizedUsers** | Write | StringArray[] | This is a list of GUIDs for users who are authorized to make changes to this call queue. The users must also have a TeamsVoiceApplications policy assigned. The GUID should contain 32 digits with 4 dashes (xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx). | |
| **Ensure** | Write | String | Present ensures the Team Message Policy exists, absent ensures it is removed | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Teams Service Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource is used to manage Call Queue in your Skype for Business Online organization.

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

    - Organization.Read.All, User.Read.All, Group.ReadWrite.All, AppCatalog.ReadWrite.All, TeamSettings.ReadWrite.All, Channel.Delete.All, ChannelSettings.ReadWrite.All, ChannelMember.ReadWrite.All

- **Update**

    - Organization.Read.All, User.Read.All, Group.ReadWrite.All, AppCatalog.ReadWrite.All, TeamSettings.ReadWrite.All, Channel.Delete.All, ChannelSettings.ReadWrite.All, ChannelMember.ReadWrite.All

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
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        TeamsCallQueue "TestQueue"
        {
            AgentAlertTime                             = 114;
            AllowOptOut                                = $True;
            AuthorizedUsers                            = @("9abce74d-d108-475f-a2cb-bbb82f484982");
            ChannelId                                  = "19:Y6MG7XdME2Cf9IRmU8PUXNfA1OtqmjyBgCmCGBN2tzY1@thread.tacv2";
            ConferenceMode                             = $True;
            Credential                                 = $Credscredential;
            DistributionLists                          = @("36c88f29-faba-4f4a-89a7-e5af29e7095e");
            EnableOverflowSharedVoicemailTranscription = $False;
            EnableTimeoutSharedVoicemailTranscription  = $False;
            Ensure                                     = "Present";
            LanguageId                                 = "fr-CA";
            Name                                       = "TestQueue";
            OverflowAction                             = "Forward";
            OverflowActionTarget                       = "9abce74d-d108-475f-a2cb-bbb82f484982";
            OverflowThreshold                          = 50;
            PresenceBasedRouting                       = $True;
            RoutingMethod                              = "RoundRobin";
            TimeoutAction                              = "Forward";
            TimeoutActionTarget                        = "9abce74d-d108-475f-a2cb-bbb82f484982";
            TimeoutThreshold                           = 1200;
            UseDefaultMusicOnHold                      = $False;
        }
    }
}
```

