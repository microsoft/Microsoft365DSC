# EXOHostedContentFilterPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the name of the Hosted Content Filter Policy that you want to modify. | |
| **AddXHeaderValue** | Write | String | The AddXHeaderValue parameter specifies the X-header value to add to spam messages when an action parameter is set to the value AddXHeader. | |
| **AdminDisplayName** | Write | String | The AdminDisplayName parameter specifies a description for the policy. | |
| **AllowedSenderDomains** | Write | StringArray[] | The AllowedSenderDomains parameter specifies trusted domains that aren't processed by the spam filter. | |
| **AllowedSenders** | Write | StringArray[] | The AllowedSenders parameter specifies a list of trusted senders that aren't processed by the spam filter. | |
| **BlockedSenderDomains** | Write | StringArray[] | The BlockedSenderDomains parameter specifies domains that are always marked as spam sources. | |
| **BlockedSenders** | Write | StringArray[] | The BlockedSenders parameter specifies senders that are always marked as spam sources. | |
| **BulkQuarantineTag** | Write | String | The BulkQuarantineTag parameter specifies the quarantine policy that's used on messages that are quarantined as bulk email. | |
| **BulkSpamAction** | Write | String | The BulkSpamAction parameter specifies the action to take on messages that are classified as bulk email. | `MoveToJmf`, `AddXHeader`, `ModifySubject`, `Redirect`, `Delete`, `Quarantine`, `NoAction` |
| **BulkThreshold** | Write | UInt32 | The BulkThreshold parameter specifies the Bulk Complaint Level (BCL) threshold setting. Valid values are from 1 - 9, where 1 marks most bulk email as spam, and 9 allows the most bulk email to be delivered. The default value is 7. | |
| **DownloadLink** | Write | Boolean | The DownloadLink parameter shows or hides a link in end-user spam notification messages to download the Junk Email Reporting Tool plugin for Outlook. Valid input for this parameter is $true or $false. The default value is $false. | |
| **EnableEndUserSpamNotifications** | Write | Boolean | The EnableEndUserSpamNotification parameter enables for disables sending end-user spam quarantine notification messages. Valid input for this parameter is $true or $false. The default value is $false. | |
| **EnableLanguageBlockList** | Write | Boolean | The EnableLanguageBlockList parameter enables or disables blocking email messages that are written in specific languages, regardless of the message contents. Valid input for this parameter is $true or $false. The default value is $false. | |
| **EnableRegionBlockList** | Write | Boolean | The EnableRegionBlockList parameter enables or disables blocking email messages that are sent from specific countries or regions, regardless of the message contents. Valid input for this parameter is $true or $false. The default value is $false. | |
| **EndUserSpamNotificationCustomSubject** | Write | String | The EndUserSpamNotificationCustomSubject parameter specifies a custom subject for end-user spam notification messages. | |
| **EndUserSpamNotificationFrequency** | Write | UInt32 | The EndUserSpamNotificationFrequency parameter specifies the repeat interval in days that end-user spam notification messages are sent. Valid input for this parameter is an integer between 1 and 15. The default value is 3. | |
| **EndUserSpamNotificationLanguage** | Write | String | The EndUserSpamNotificationLanguage parameter specifies the language of end-user spam notification messages. The default value is Default. This means the default language of end-user spam notification messages is the default language of the cloud-based organization. | `Default`, `English`, `French`, `German`, `Italian`, `Japanese`, `Spanish`, `Korean`, `Portuguese`, `Russian`, `ChineseSimplified`, `ChineseTraditional`, `Amharic`, `Arabic`, `Bulgarian`, `BengaliIndia`, `Catalan`, `Czech`, `Cyrillic`, `Danish`, `Greek`, `Estonian`, `Basque`, `Farsi`, `Finnish`, `Filipino`, `Galician`, `Gujarati`, `Hebrew`, `Hindi`, `Croatian`, `Hungarian`, `Indonesian`, `Icelandic`, `Kazakh`, `Kannada`, `Lithuanian`, `Latvian`, `Malayalam`, `Marathi`, `Malay`, `Dutch`, `NorwegianNynorsk`, `Norwegian`, `Oriya`, `Polish`, `PortuguesePortugal`, `Romanian`, `Slovak`, `Slovenian`, `SerbianCyrillic`, `Serbian`, `Swedish`, `Swahili`, `Tamil`, `Telugu`, `Thai`, `Turkish`, `Ukrainian`, `Urdu`, `Vietnamese` |
| **HighConfidencePhishAction** | Write | String | The HighConfidencePhishAction parameter specifies the action to take on messages that are marked as high confidence phishing | `MoveToJmf`, `Redirect`, `Quarantine` |
| **HighConfidencePhishQuarantineTag** | Write | String | The HighConfidencePhishQuarantineTag parameter specifies the quarantine policy that's used on messages that are quarantined as high confidence phishing. | |
| **HighConfidenceSpamAction** | Write | String | The HighConfidenceSpamAction parameter specifies the action to take on messages that are classified as high confidence spam. | `MoveToJmf`, `AddXHeader`, `ModifySubject`, `Redirect`, `Delete`, `Quarantine`, `NoAction` |
| **HighConfidenceSpamQuarantineTag** | Write | String | The HighConfidenceSpamQuarantineTag parameter specifies the quarantine policy that's used on messages that are quarantined as high confidence spam. | |
| **IncreaseScoreWithBizOrInfoUrls** | Write | String | The IncreaseScoreWithBizOrInfoUrls parameter increases the spam score of messages that contain links to .biz or .info domains. Valid values for this parameter are Off, On or Test. The default value is Off. | `Off`, `On`, `Test` |
| **IncreaseScoreWithImageLinks** | Write | String | The IncreaseScoreWithImageLinks parameter increases the spam score of messages that contain image links to remote websites. Valid values for this parameter are Off, On or Test. The default value is Off. | `Off`, `On`, `Test` |
| **IncreaseScoreWithNumericIps** | Write | String | The IncreaseScoreWithNumericIps parameter increases the spam score of messages that contain links to IP addresses. Valid values for this parameter are Off, On or Test. The default value is Off. | `Off`, `On`, `Test` |
| **IncreaseScoreWithRedirectToOtherPort** | Write | String | The IncreaseScoreWithRedirectToOtherPort parameter increases the spam score of messages that contain links that redirect to other TCP ports. Valid values for this parameter are Off, On or Test. The default value is Off. | `Off`, `On`, `Test` |
| **InlineSafetyTipsEnabled** | Write | Boolean | The InlineSafetyTipsEnabled parameter specifies whether to enable or disable safety tips that are shown to recipients in messages. The default is $true | |
| **LanguageBlockList** | Write | StringArray[] | The LanguageBlockList parameter specifies the languages to block when messages are blocked based on their language. Valid input for this parameter is a supported ISO 639-1 lowercase two-letter language code. You can specify multiple values separated by commas. This parameter is only use when the EnableRegionBlockList parameter is set to $true. | |
| **MakeDefault** | Write | Boolean | The MakeDefault parameter makes the specified content filter policy the default content filter policy. The default value is $false | |
| **MarkAsSpamBulkMail** | Write | String | The MarkAsSpamBulkMail parameter classifies the message as spam when the message is identified as a bulk email message. Valid values for this parameter are Off, On or Test. The default value is On. | `Off`, `On`, `Test` |
| **MarkAsSpamEmbedTagsInHtml** | Write | String | The MarkAsSpamEmbedTagsInHtml parameter classifies the message as spam when the message contains HTML <embed> tags. Valid values for this parameter are Off, On or Test. The default value is Off. | `Off`, `On`, `Test` |
| **MarkAsSpamEmptyMessages** | Write | String | The MarkAsSpamEmptyMessages parameter classifies the message as spam when the message is empty. Valid values for this parameter are Off, On or Test. The default value is Off. | `Off`, `On`, `Test` |
| **MarkAsSpamFormTagsInHtml** | Write | String | The MarkAsSpamFormTagsInHtml parameter classifies the message as spam when the message contains HTML <form> tags. Valid values for this parameter are Off, On or Test. The default value is Off. | `Off`, `On`, `Test` |
| **MarkAsSpamFramesInHtml** | Write | String | The MarkAsSpamFramesInHtml parameter classifies the message as spam when the message contains HTML <frame> or <iframe> tags. Valid values for this parameter are Off, On or Test. The default value is Off. | `Off`, `On`, `Test` |
| **MarkAsSpamFromAddressAuthFail** | Write | String | The MarkAsSpamFromAddressAuthFail parameter classifies the message as spam when Sender ID filtering encounters a hard fail. Valid values for this parameter are Off or On. The default value is Off. | `Off`, `On`, `Test` |
| **MarkAsSpamJavaScriptInHtml** | Write | String | The MarkAsSpamJavaScriptInHtml parameter classifies the message as spam when the message contains JavaScript or VBScript. Valid values for this parameter are Off, On or Test. The default value is Off. | `Off`, `On`, `Test` |
| **MarkAsSpamNdrBackscatter** | Write | String | The MarkAsSpamNdrBackscatter parameter classifies the message as spam when the message is a non-delivery report (NDR) to a forged sender. Valid values for this parameter are Off or On. The default value is Off. | `Off`, `On`, `Test` |
| **MarkAsSpamObjectTagsInHtml** | Write | String | The MarkAsSpamObjectTagsInHtml parameter classifies the message as spam when the message contains HTML <object> tags. Valid values for this parameter are Off, On or Test. The default value is Off. | `Off`, `On`, `Test` |
| **MarkAsSpamSensitiveWordList** | Write | String | The MarkAsSpamSensitiveWordList parameter classifies the message as spam when the message contains words from the sensitive words list. Valid values for this parameter are Off, On or Test. The default value is Off. | `Off`, `On`, `Test` |
| **MarkAsSpamSpfRecordHardFail** | Write | String | The MarkAsSpamSpfRecordHardFail parameter classifies the message as spam when Sender Policy Framework (SPF) record checking encounters a hard fail. Valid values for this parameter are Off or On. The default value is Off. | `Off`, `On`, `Test` |
| **MarkAsSpamWebBugsInHtml** | Write | String | The MarkAsSpamWebBugsInHtml parameter classifies the message as spam when the message contains web bugs. Valid values for this parameter are Off, On or Test. The default value is Off. | `Off`, `On`, `Test` |
| **ModifySubjectValue** | Write | String | The ModifySubjectValue parameter specifies the text to prepend to the existing subject of spam messages when an action parameter is set to the value ModifySubject. | |
| **PhishSpamAction** | Write | String | The PhishSpamAction parameter specifies the action to take on messages that are classified as phishing | `MoveToJmf`, `AddXHeader`, `ModifySubject`, `Redirect`, `Delete`, `Quarantine`, `NoAction` |
| **PhishQuarantineTag** | Write | String | The PhishQuarantineTag parameter specifies the quarantine policy that's used on messages that are quarantined as phishing. | |
| **SpamQuarantineTag** | Write | String | The SpamQuarantineTag parameter specifies the quarantine policy that's used on messages that are quarantined as spam. | |
| **QuarantineRetentionPeriod** | Write | UInt32 | The QuarantineRetentionPeriod parameter specifies the length of time in days that spam messages remain in the quarantine. Valid input for this parameter is an integer between 1 and 30. The default value is 15. | |
| **RedirectToRecipients** | Write | StringArray[] | The RedirectToRecipients parameter specifies the replacement recipients in spam messages when an action parameter is set to the value Redirect. The action parameters that use the value of RedirectToRecipients are BulkSpamAction, HighConfidencePhishAction, HighConfidenceSpamAction, PhishSpamAction and SpamAction. | |
| **RegionBlockList** | Write | StringArray[] | The RegionBlockList parameter specifies the region to block when messages are blocked based on their source region. Valid input for this parameter is a supported ISO 3166-1 uppercase two-letter country code. You can specify multiple values separated by commas. This parameter is only used when the EnableRegionBlockList parameter is set to $true. | |
| **SpamAction** | Write | String | The SpamAction parameter specifies the action to take on messages that are classified as spam (not high confidence spam, bulk email, or phishing).  | `MoveToJmf`, `AddXHeader`, `ModifySubject`, `Redirect`, `Delete`, `Quarantine`, `NoAction` |
| **TestModeAction** | Write | String | The TestModeAction parameter specifies the additional action to take on messages that match any of the IncreaseScoreWith or MarkAsSpam parameters that are set to the value Test.  | `None`, `AddXHeader`, `BccMessage` |
| **TestModeBccToRecipients** | Write | StringArray[] | The TestModeBccToRecipients parameter specifies the blind carbon copy recipients to add to spam messages when the TestModeAction action parameter is set to the value BccMessage. | |
| **PhishZapEnabled** | Write | Boolean | The PhishZapEnabled parameter enables or disables zero-hour auto purge (ZAP) to detect phishing messages in delivered messages in Exchange Online mailboxes. | |
| **SpamZapEnabled** | Write | Boolean | The SpamZapEnabled parameter enables or disables zero-hour auto purge (ZAP) to detect spam in delivered messages in Exchange Online mailboxes. | |
| **Ensure** | Write | String | Specify if this policy should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource configures the settings of connection filter policies
in your cloud-based organization.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Transport Hygiene, Security Admin, View-Only Configuration, Security Reader

#### Role Groups

- Organization Management

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
        EXOHostedContentFilterPolicy 'ConfigureHostedContentFilterPolicy'
        {
            Identity                             = "Integration CFP"
            AddXHeaderValue                      = ""
            AdminDisplayName                     = ""
            BulkSpamAction                       = "MoveToJmf"
            BulkThreshold                        = 7
            DownloadLink                         = $False
            EnableEndUserSpamNotifications       = $False
            EnableLanguageBlockList              = $False
            EnableRegionBlockList                = $False
            EndUserSpamNotificationCustomSubject = ""
            EndUserSpamNotificationFrequency     = 3
            EndUserSpamNotificationLanguage      = "Default"
            HighConfidencePhishAction            = "Quarantine"
            HighConfidenceSpamAction             = "MoveToJmf"
            IncreaseScoreWithBizOrInfoUrls       = "Off"
            IncreaseScoreWithImageLinks          = "Off"
            IncreaseScoreWithNumericIps          = "Off"
            IncreaseScoreWithRedirectToOtherPort = "Off"
            InlineSafetyTipsEnabled              = $True
            LanguageBlockList                    = @()
            MakeDefault                          = $True
            MarkAsSpamBulkMail                   = "On"
            MarkAsSpamEmbedTagsInHtml            = "Off"
            MarkAsSpamEmptyMessages              = "Off"
            MarkAsSpamFormTagsInHtml             = "Off"
            MarkAsSpamFramesInHtml               = "Off"
            MarkAsSpamFromAddressAuthFail        = "Off"
            MarkAsSpamJavaScriptInHtml           = "Off"
            MarkAsSpamNdrBackscatter             = "Off"
            MarkAsSpamObjectTagsInHtml           = "Off"
            MarkAsSpamSensitiveWordList          = "Off"
            MarkAsSpamSpfRecordHardFail          = "Off"
            MarkAsSpamWebBugsInHtml              = "Off"
            ModifySubjectValue                   = ""
            PhishSpamAction                      = "MoveToJmf"
            PhishZapEnabled                      = $True
            QuarantineRetentionPeriod            = 15
            RedirectToRecipients                 = @()
            RegionBlockList                      = @()
            SpamAction                           = "MoveToJmf"
            SpamZapEnabled                       = $True
            TestModeAction                       = "None"
            TestModeBccToRecipients              = @()
            Ensure                               = "Present"
            Credential                           = $Credscredential
        }
    }
}
```

### Example 2

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
        EXOHostedContentFilterPolicy 'ConfigureHostedContentFilterPolicy'
        {
            Identity                             = "Integration CFP"
            AddXHeaderValue                      = ""
            AdminDisplayName                     = ""
            BulkSpamAction                       = "MoveToJmf"
            BulkThreshold                        = 7
            DownloadLink                         = $True # Updated Property
            EnableEndUserSpamNotifications       = $False
            EnableLanguageBlockList              = $False
            EnableRegionBlockList                = $False
            EndUserSpamNotificationCustomSubject = ""
            EndUserSpamNotificationFrequency     = 3
            EndUserSpamNotificationLanguage      = "Default"
            HighConfidencePhishAction            = "Quarantine"
            HighConfidenceSpamAction             = "MoveToJmf"
            IncreaseScoreWithBizOrInfoUrls       = "Off"
            IncreaseScoreWithImageLinks          = "Off"
            IncreaseScoreWithNumericIps          = "Off"
            IncreaseScoreWithRedirectToOtherPort = "Off"
            InlineSafetyTipsEnabled              = $True
            LanguageBlockList                    = @()
            MakeDefault                          = $True
            MarkAsSpamBulkMail                   = "On"
            MarkAsSpamEmbedTagsInHtml            = "Off"
            MarkAsSpamEmptyMessages              = "Off"
            MarkAsSpamFormTagsInHtml             = "Off"
            MarkAsSpamFramesInHtml               = "Off"
            MarkAsSpamFromAddressAuthFail        = "Off"
            MarkAsSpamJavaScriptInHtml           = "Off"
            MarkAsSpamNdrBackscatter             = "Off"
            MarkAsSpamObjectTagsInHtml           = "Off"
            MarkAsSpamSensitiveWordList          = "Off"
            MarkAsSpamSpfRecordHardFail          = "Off"
            MarkAsSpamWebBugsInHtml              = "Off"
            ModifySubjectValue                   = ""
            PhishSpamAction                      = "MoveToJmf"
            PhishZapEnabled                      = $True
            QuarantineRetentionPeriod            = 15
            RedirectToRecipients                 = @()
            RegionBlockList                      = @()
            SpamAction                           = "MoveToJmf"
            SpamZapEnabled                       = $True
            TestModeAction                       = "None"
            TestModeBccToRecipients              = @()
            Ensure                               = "Present"
            Credential                           = $Credscredential
        }
    }
}
```

### Example 3

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
        EXOHostedContentFilterPolicy 'ConfigureHostedContentFilterPolicy'
        {
            Identity                             = "Integration CFP"
            Ensure                               = "Absent"
            Credential                           = $Credscredential
        }
    }
}
```

