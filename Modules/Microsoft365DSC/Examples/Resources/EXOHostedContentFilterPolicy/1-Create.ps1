<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

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
