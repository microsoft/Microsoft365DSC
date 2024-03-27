# TeamsOnlineVoicemailPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Identity of the Teams Online Voicemail Policy. | |
| **EnableEditingCallAnswerRulesSetting** | Write | Boolean | Controls if editing call answer rule settings are enabled or disabled for a user. Possible values are $true or $false. | |
| **EnableTranscription** | Write | Boolean | Allows you to disable or enable voicemail transcription. Possible values are $true or $false. | |
| **EnableTranscriptionProfanityMasking** | Write | Boolean | Allows you to disable or enable profanity masking for the voicemail transcriptions. Possible values are $true or $false. | |
| **EnableTranscriptionTranslation** | Write | Boolean | Allows you to disable or enable translation for the voicemail transcriptions. Possible values are $true or $false. | |
| **MaximumRecordingLength** | Write | String | A duration of voicemail maximum recording length. The length should be between 30 seconds to 600 seconds. | |
| **PrimarySystemPromptLanguage** | Write | String | The primary (or first) language that voicemail system prompts will be presented in. Must also set SecondarySystemPromptLanguage. When set, this overrides the user language choice. | |
| **SecondarySystemPromptLanguage** | Write | String | The secondary language that voicemail system prompts will be presented in. Must also set PrimarySystemPromptLanguage and may not be the same value as PrimarySystemPromptanguage. When set, this overrides the user language choice.  | |
| **ShareData** | Write | String | Specifies whether voicemail and transcription data are shared with the service for training and improving accuracy. Possible values are Defer and Deny. | |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Teams Global Admin. | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |


# TeamsOnlinceVoicemailPolicy

## Description

This resource configures the Teams Online Voicemail Policies.

More information: https://learn.microsoft.com/en-us/microsoftteams/manage-voicemail-policies

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

