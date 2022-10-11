﻿# TeamsOnlineVoicemailPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Identity of the Teams Online Voicemail Policy. ||
| **EnableEditingCallAnswerRulesSetting** | Write | Boolean | Controls if editing call answer rule settings are enabled or disabled for a user. Possible values are $true or $false. ||
| **EnableTranscription** | Write | Boolean | Allows you to disable or enable voicemail transcription. Possible values are $true or $false. ||
| **EnableTranscriptionProfanityMasking** | Write | Boolean | Allows you to disable or enable profanity masking for the voicemail transcriptions. Possible values are $true or $false. ||
| **EnableTranscriptionTranslation** | Write | Boolean | Allows you to disable or enable translation for the voicemail transcriptions. Possible values are $true or $false. ||
| **MaximumRecordingLength** | Write | String | A duration of voicemail maximum recording length. The length should be between 30 seconds to 600 seconds. ||
| **PrimarySystemPromptLanguage** | Write | String | The primary (or first) language that voicemail system prompts will be presented in. Must also set SecondarySystemPromptLanguage. When set, this overrides the user language choice. ||
| **SecondarySystemPromptLanguage** | Write | String | The secondary language that voicemail system prompts will be presented in. Must also set PrimarySystemPromptLanguage and may not be the same value as PrimarySystemPromptanguage. When set, this overrides the user language choice.  ||
| **ShareData** | Write | String | Specifies whether voicemail and transcription data are shared with the service for training and improving accuracy. Possible values are Defer and Deny. ||
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. |Present, Absent|
| **Credential** | Required | PSCredential | Credentials of the Teams Global Admin. ||


# TeamsOnlinceVoicemailPolicy

### Description

This resource configures the Teams Online Voicemail Policies.

More information: https://learn.microsoft.com/en-us/microsoftteams/manage-voicemail-policies

## Examples

### Example 1

This example adds a new Teams Meeting Policy.

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
        TeamsOnlineVoicemailPolicy 'NewOnlineVoicemailPolicy'
        {
            Credential                          = $credsCredential;
            EnableEditingCallAnswerRulesSetting = $True;
            EnableTranscription                 = $True;
            EnableTranscriptionProfanityMasking = $False;
            EnableTranscriptionTranslation      = $True;
            Ensure                              = "Present";
            Identity                            = "MyPolicy";
            MaximumRecordingLength              = "00:10:00";
            ShareData                           = "Defer";
        }
    }
}
```

