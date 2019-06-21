# EXOHostedContentFilterPolicy

## Description

This resource configures the settings of connection filter policies
in your cloud-based organization.

## Parameters

Ensure

- Required: No (Defaults to 'Present')
- Description: `Present` is the only value accepted.
  Configurations using `Ensure = 'Absent'` will throw an Error!

GlobalAdminAccount

- Required: Yes
- Description: Credentials of an Office365 Global Admin

Identity

- Required: Yes
- Description: Name of the HostedContentFilterPolicy

AdminDisplayName

- Required: No
- Description: The AdminDisplayName parameter specifies a
  description for the policy.

## Example

```PowerShell
EXOHostedContentFilterPolicy TestHostedContentFilterPolicy {
  Ensure                                   = 'Present'
  Identity                                 = 'TestPolicy'
  GlobalAdminAccount                       = $GlobalAdminAccount
  AdminDisplayName                         = 'This policiy is a test'
  AddXHeaderValue                          = 'MyCustomSpamHeader'
  ModifySubjectValue                       = 'SPAM!'
  RedirectToRecipients                     = @()
  TestModeBccToRecipients                  = @()
  QuarantineRetentionPeriod                = 15
  EndUserSpamNotificationFrequency         = 1
  TestModeAction                           = 'AddXHeader'
  IncreaseScoreWithImageLinks              = 'Off'
  IncreaseScoreWithNumericIps              = 'On'
  IncreaseScoreWithRedirectToOtherPort     = 'On'
  IncreaseScoreWithBizOrInfoUrls           = 'On'
  MarkAsSpamEmptyMessages                  = 'On'
  MarkAsSpamJavaScriptInHtml               = 'On'
  MarkAsSpamFramesInHtml                   = 'On'
  MarkAsSpamObjectTagsInHtml               = 'On'
  MarkAsSpamEmbedTagsInHtml                = 'Off'
  MarkAsSpamFormTagsInHtml                 = 'Off'
  MarkAsSpamWebBugsInHtml                  = 'On'
  MarkAsSpamSensitiveWordList              = 'Test'
  MarkAsSpamSpfRecordHardFail              = 'On'
  MarkAsSpamFromAddressAuthFail            = 'On'
  MarkAsSpamBulkMail                       = 'On'
  MarkAsSpamNdrBackscatter                 = 'On'
  LanguageBlockList                        = @('AF', 'SQ', 'AR', 'CY', 'YI')
  RegionBlockList                          = @('AF', 'AX', 'AL', 'DZ', 'ZW')
  HighConfidenceSpamAction                 = 'Quarantine'
  SpamAction                               = 'MoveToJmf'
  EnableEndUserSpamNotifications           = $true
  DownloadLink                             = $false
  EnableRegionBlockList                    = $true
  EnableLanguageBlockList                  = $true
  EndUserSpamNotificationCustomFromAddress = 'Spam@contoso.com'
  EndUserSpamNotificationCustomFromName    = 'Spam Notification'
  EndUserSpamNotificationCustomSubject     = 'This is SPAM'
  EndUserSpamNotificationLanguage          = 'Default'
  BulkThreshold                            = 5
  AllowedSenders                           = @('test@contoso.com', 'test@fabrikam.com')
  AllowedSenderDomains                     = @('contoso.com', 'fabrikam.com')
  BlockedSenders                           = @('me@privacy.net', 'thedude@contoso.com')
  BlockedSenderDomains                     = @('privacy.net', 'facebook.com')
  ZapEnabled                               = $true
  InlineSafetyTipsEnabled                  = $true
  BulkSpamAction                           = 'MoveToJmf'
  PhishSpamAction                          = 'Quarantine'
  MakeDefault                              = $false
}
```
