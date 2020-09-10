function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $AddXHeaderValue,

        [Parameter()]
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [System.String[]]
        $AllowedSenderDomains = @(),

        [Parameter()]
        [System.String[]]
        $AllowedSenders = @(),

        [Parameter()]
        [System.String[]]
        $BlockedSenderDomains = @(),

        [Parameter()]
        [System.String[]]
        $BlockedSenders = @(),

        [Parameter()]
        [ValidateSet('MoveToJmf', 'AddXHeader', 'ModifySubject', 'Redirect', 'Delete', 'Quarantine')]
        [System.String]
        $BulkSpamAction = 'MoveToJmf',

        [Parameter()]
        [ValidateRange(1, 9)]
        [uint32]
        $BulkThreshold = 7,

        [Parameter()]
        [System.Boolean]
        $DownloadLink = $false,

        [Parameter()]
        [System.Boolean]
        $EnableEndUserSpamNotifications = $false,

        [Parameter()]
        [System.Boolean]
        $EnableLanguageBlockList = $false,

        [Parameter()]
        [System.Boolean]
        $EnableRegionBlockList = $false,

        [Parameter()]
        [ValidatePattern("^$|^[a-zA-Z0-9.!£#$%&'^_`{}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$")]
        [System.String]
        $EndUserSpamNotificationCustomFromAddress,

        [Parameter()]
        [System.String]
        $EndUserSpamNotificationCustomFromName,

        [Parameter()]
        [System.String]
        $EndUserSpamNotificationCustomSubject,

        [Parameter()]
        [ValidateRange(1, 15)]
        [uint32]
        $EndUserSpamNotificationFrequency = 3,

        [Parameter()]
        [ValidateSet('Default', 'English', 'French', 'German', 'Italian', 'Japanese', 'Spanish', 'Korean', 'Portuguese', 'Russian', 'ChineseSimplified', 'ChineseTraditional', 'Amharic', 'Arabic', 'Bulgarian', 'BengaliIndia', 'Catalan', 'Czech', 'Cyrillic', 'Danish', 'Greek', 'Estonian', 'Basque', 'Farsi', 'Finnish', 'Filipino', 'Galician', 'Gujarati', 'Hebrew', 'Hindi', 'Croatian', 'Hungarian', 'Indonesian', 'Icelandic', 'Kazakh', 'Kannada', 'Lithuanian', 'Latvian', 'Malayalam', 'Marathi', 'Malay', 'Dutch', 'NorwegianNynorsk', 'Norwegian', 'Oriya', 'Polish', 'PortuguesePortugal', 'Romanian', 'Slovak', 'Slovenian', 'SerbianCyrillic', 'Serbian', 'Swedish', 'Swahili', 'Tamil', 'Telugu', 'Thai', 'Turkish', 'Ukrainian', 'Urdu', 'Vietnamese')]
        [System.String]
        $EndUserSpamNotificationLanguage = 'Default',

        [Parameter()]
        [ValidateSet('MoveToJmf', 'AddXHeader', 'ModifySubject', 'Redirect', 'Delete', 'Quarantine', 'NoAction')]
        [System.String]
        $HighConfidenceSpamAction = 'MoveToJmf',

        [Parameter()]
        [System.Boolean]
        $InlineSafetyTipsEnabled = $true,

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $IncreaseScoreWithBizOrInfoUrls = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $IncreaseScoreWithImageLinks = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $IncreaseScoreWithNumericIps = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $IncreaseScoreWithRedirectToOtherPort = 'Off',

        [Parameter()]
        [System.String[]]
        $LanguageBlockList = @(),

        [Parameter()]
        [System.Boolean]
        $MakeDefault = $false,

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $MarkAsSpamBulkMail = 'On',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $MarkAsSpamEmbedTagsInHtml = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $MarkAsSpamEmptyMessages = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $MarkAsSpamFormTagsInHtml = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $MarkAsSpamFramesInHtml = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $MarkAsSpamFromAddressAuthFail = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $MarkAsSpamJavaScriptInHtml = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $MarkAsSpamNdrBackscatter = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $MarkAsSpamObjectTagsInHtml = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $MarkAsSpamSensitiveWordList = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $MarkAsSpamSpfRecordHardFail = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $MarkAsSpamWebBugsInHtml = 'Off',

        [Parameter()]
        [System.String]
        $ModifySubjectValue,

        [Parameter()]
        [ValidateSet('MoveToJmf', 'AddXHeader', 'ModifySubject', 'Redirect', 'Delete', 'Quarantine', 'NoAction')]
        [System.String]
        $PhishSpamAction = 'MoveToJmf',

        [Parameter()]
        [ValidateRange(1, 15)]
        [uint32]
        $QuarantineRetentionPeriod = 15,

        [Parameter()]
        [System.String[]]
        $RedirectToRecipients = @(),

        [Parameter()]
        [System.String[]]
        $RegionBlockList = @(),

        [Parameter()]
        [ValidateSet('MoveToJmf', 'AddXHeader', 'ModifySubject', 'Redirect', 'Delete', 'Quarantine', 'NoAction')]
        [System.String]
        $SpamAction = 'MoveToJmf',

        [Parameter()]
        [ValidateSet('None', 'AddXHeader', 'BccMessage')]
        [System.String]
        $TestModeAction = 'None',

        [Parameter()]
        [System.String[]]
        $TestModeBccToRecipients = @(),

        [Parameter()]
        [System.Boolean]
        $ZapEnabled = $true,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of HostedContentFilterPolicy for $Identity"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $HostedContentFilterPolicies = Get-HostedContentFilterPolicy

    $HostedContentFilterPolicy = $HostedContentFilterPolicies | Where-Object -FilterScript { $_.Identity -eq $Identity }
    if ($null -eq $HostedContentFilterPolicy)
    {
        Write-Verbose -Message "HostedContentFilterPolicy $($Identity) does not exist."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
    }
    else
    {
        $result = @{
            Ensure                                   = 'Present'
            Identity                                 = $Identity
            AddXHeaderValue                          = $HostedContentFilterPolicy.AddXHeaderValue
            AdminDisplayName                         = $HostedContentFilterPolicy.AdminDisplayName
            AllowedSenderDomains                     = $HostedContentFilterPolicy.AllowedSenderDomains
            AllowedSenders                           = $HostedContentFilterPolicy.AllowedSenders
            BlockedSenderDomains                     = $HostedContentFilterPolicy.BlockedSenderDomains
            BlockedSenders                           = $HostedContentFilterPolicy.BlockedSenders
            BulkSpamAction                           = $HostedContentFilterPolicy.BulkSpamAction
            BulkThreshold                            = $HostedContentFilterPolicy.BulkThreshold
            DownloadLink                             = $HostedContentFilterPolicy.DownloadLink
            EnableEndUserSpamNotifications           = $HostedContentFilterPolicy.EnableEndUserSpamNotifications
            EnableLanguageBlockList                  = $HostedContentFilterPolicy.EnableLanguageBlockList
            EnableRegionBlockList                    = $HostedContentFilterPolicy.EnableRegionBlockList
            EndUserSpamNotificationCustomFromAddress = $HostedContentFilterPolicy.EndUserSpamNotificationCustomFromAddress
            EndUserSpamNotificationCustomFromName    = $HostedContentFilterPolicy.EndUserSpamNotificationCustomFromName
            EndUserSpamNotificationCustomSubject     = $HostedContentFilterPolicy.EndUserSpamNotificationCustomSubject
            EndUserSpamNotificationFrequency         = $HostedContentFilterPolicy.EndUserSpamNotificationFrequency
            EndUserSpamNotificationLanguage          = $HostedContentFilterPolicy.EndUserSpamNotificationLanguage
            HighConfidenceSpamAction                 = $HostedContentFilterPolicy.HighConfidenceSpamAction
            InlineSafetyTipsEnabled                  = $HostedContentFilterPolicy.InlineSafetyTipsEnabled
            IncreaseScoreWithBizOrInfoUrls           = $HostedContentFilterPolicy.IncreaseScoreWithBizOrInfoUrls
            IncreaseScoreWithImageLinks              = $HostedContentFilterPolicy.IncreaseScoreWithImageLinks
            IncreaseScoreWithNumericIps              = $HostedContentFilterPolicy.IncreaseScoreWithNumericIps
            IncreaseScoreWithRedirectToOtherPort     = $HostedContentFilterPolicy.IncreaseScoreWithRedirectToOtherPort
            LanguageBlockList                        = $HostedContentFilterPolicy.LanguageBlockList
            MakeDefault                              = $false
            MarkAsSpamBulkMail                       = $HostedContentFilterPolicy.MarkAsSpamBulkMail
            MarkAsSpamEmbedTagsInHtml                = $HostedContentFilterPolicy.MarkAsSpamEmbedTagsInHtml
            MarkAsSpamEmptyMessages                  = $HostedContentFilterPolicy.MarkAsSpamEmptyMessages
            MarkAsSpamFormTagsInHtml                 = $HostedContentFilterPolicy.MarkAsSpamFormTagsInHtml
            MarkAsSpamFramesInHtml                   = $HostedContentFilterPolicy.MarkAsSpamFramesInHtml
            MarkAsSpamFromAddressAuthFail            = $HostedContentFilterPolicy.MarkAsSpamFromAddressAuthFail
            MarkAsSpamJavaScriptInHtml               = $HostedContentFilterPolicy.MarkAsSpamJavaScriptInHtml
            MarkAsSpamNdrBackscatter                 = $HostedContentFilterPolicy.MarkAsSpamNdrBackscatter
            MarkAsSpamObjectTagsInHtml               = $HostedContentFilterPolicy.MarkAsSpamObjectTagsInHtml
            MarkAsSpamSensitiveWordList              = $HostedContentFilterPolicy.MarkAsSpamSensitiveWordList
            MarkAsSpamSpfRecordHardFail              = $HostedContentFilterPolicy.MarkAsSpamSpfRecordHardFail
            MarkAsSpamWebBugsInHtml                  = $HostedContentFilterPolicy.MarkAsSpamWebBugsInHtml
            ModifySubjectValue                       = $HostedContentFilterPolicy.ModifySubjectValue
            PhishSpamAction                          = $HostedContentFilterPolicy.PhishSpamAction
            QuarantineRetentionPeriod                = $HostedContentFilterPolicy.QuarantineRetentionPeriod
            RedirectToRecipients                     = $HostedContentFilterPolicy.RedirectToRecipients
            RegionBlockList                          = $HostedContentFilterPolicy.RegionBlockList
            SpamAction                               = $HostedContentFilterPolicy.SpamAction
            TestModeAction                           = $HostedContentFilterPolicy.TestModeAction
            TestModeBccToRecipients                  = $HostedContentFilterPolicy.TestModeBccToRecipients
            ZapEnabled                               = $HostedContentFilterPolicy.ZapEnabled
            GlobalAdminAccount                       = $GlobalAdminAccount
        }

        if ($HostedContentFilterPolicy.IsDefault)
        {
            $result.MakeDefault = $true
        }

        Write-Verbose -Message "Found HostedContentFilterPolicy $($Identity)"
        Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
        return $result
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $AddXHeaderValue,

        [Parameter()]
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [System.String[]]
        $AllowedSenderDomains = @(),

        [Parameter()]
        [System.String[]]
        $AllowedSenders = @(),

        [Parameter()]
        [System.String[]]
        $BlockedSenderDomains = @(),

        [Parameter()]
        [System.String[]]
        $BlockedSenders = @(),

        [Parameter()]
        [ValidateSet('MoveToJmf', 'AddXHeader', 'ModifySubject', 'Redirect', 'Delete', 'Quarantine')]
        [System.String]
        $BulkSpamAction = 'MoveToJmf',

        [Parameter()]
        [ValidateRange(1, 9)]
        [uint32]
        $BulkThreshold = 7,

        [Parameter()]
        [System.Boolean]
        $DownloadLink = $false,

        [Parameter()]
        [System.Boolean]
        $EnableEndUserSpamNotifications = $false,

        [Parameter()]
        [System.Boolean]
        $EnableLanguageBlockList = $false,

        [Parameter()]
        [System.Boolean]
        $EnableRegionBlockList = $false,

        [Parameter()]
        [ValidatePattern("^$|^[a-zA-Z0-9.!£#$%&'^_`{}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$")]
        [System.String]
        $EndUserSpamNotificationCustomFromAddress,

        [Parameter()]
        [System.String]
        $EndUserSpamNotificationCustomFromName,

        [Parameter()]
        [System.String]
        $EndUserSpamNotificationCustomSubject,

        [Parameter()]
        [ValidateRange(1, 15)]
        [uint32]
        $EndUserSpamNotificationFrequency = 3,

        [Parameter()]
        [ValidateSet('Default', 'English', 'French', 'German', 'Italian', 'Japanese', 'Spanish', 'Korean', 'Portuguese', 'Russian', 'ChineseSimplified', 'ChineseTraditional', 'Amharic', 'Arabic', 'Bulgarian', 'BengaliIndia', 'Catalan', 'Czech', 'Cyrillic', 'Danish', 'Greek', 'Estonian', 'Basque', 'Farsi', 'Finnish', 'Filipino', 'Galician', 'Gujarati', 'Hebrew', 'Hindi', 'Croatian', 'Hungarian', 'Indonesian', 'Icelandic', 'Kazakh', 'Kannada', 'Lithuanian', 'Latvian', 'Malayalam', 'Marathi', 'Malay', 'Dutch', 'NorwegianNynorsk', 'Norwegian', 'Oriya', 'Polish', 'PortuguesePortugal', 'Romanian', 'Slovak', 'Slovenian', 'SerbianCyrillic', 'Serbian', 'Swedish', 'Swahili', 'Tamil', 'Telugu', 'Thai', 'Turkish', 'Ukrainian', 'Urdu', 'Vietnamese')]
        [System.String]
        $EndUserSpamNotificationLanguage = 'Default',

        [Parameter()]
        [ValidateSet('MoveToJmf', 'AddXHeader', 'ModifySubject', 'Redirect', 'Delete', 'Quarantine', 'NoAction')]
        [System.String]
        $HighConfidenceSpamAction = 'MoveToJmf',

        [Parameter()]
        [System.Boolean]
        $InlineSafetyTipsEnabled = $true,

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $IncreaseScoreWithBizOrInfoUrls = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $IncreaseScoreWithImageLinks = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $IncreaseScoreWithNumericIps = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $IncreaseScoreWithRedirectToOtherPort = 'Off',

        [Parameter()]
        [System.String[]]
        $LanguageBlockList = @(),

        [Parameter()]
        [System.Boolean]
        $MakeDefault = $false,

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $MarkAsSpamBulkMail = 'On',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $MarkAsSpamEmbedTagsInHtml = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $MarkAsSpamEmptyMessages = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $MarkAsSpamFormTagsInHtml = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $MarkAsSpamFramesInHtml = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $MarkAsSpamFromAddressAuthFail = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $MarkAsSpamJavaScriptInHtml = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $MarkAsSpamNdrBackscatter = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $MarkAsSpamObjectTagsInHtml = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $MarkAsSpamSensitiveWordList = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $MarkAsSpamSpfRecordHardFail = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $MarkAsSpamWebBugsInHtml = 'Off',

        [Parameter()]
        [System.String]
        $ModifySubjectValue,

        [Parameter()]
        [ValidateSet('MoveToJmf', 'AddXHeader', 'ModifySubject', 'Redirect', 'Delete', 'Quarantine', 'NoAction')]
        [System.String]
        $PhishSpamAction = 'MoveToJmf',

        [Parameter()]
        [ValidateRange(1, 15)]
        [uint32]
        $QuarantineRetentionPeriod = 15,

        [Parameter()]
        [System.String[]]
        $RedirectToRecipients = @(),

        [Parameter()]
        [System.String[]]
        $RegionBlockList = @(),

        [Parameter()]
        [ValidateSet('MoveToJmf', 'AddXHeader', 'ModifySubject', 'Redirect', 'Delete', 'Quarantine', 'NoAction')]
        [System.String]
        $SpamAction = 'MoveToJmf',

        [Parameter()]
        [ValidateSet('None', 'AddXHeader', 'BccMessage')]
        [System.String]
        $TestModeAction = 'None',

        [Parameter()]
        [System.String[]]
        $TestModeBccToRecipients = @(),

        [Parameter()]
        [System.Boolean]
        $ZapEnabled = $true,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of HostedContentFilterPolicy for $Identity"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $HostedContentFilterPolicies = Get-HostedContentFilterPolicy

    $HostedContentFilterPolicy = $HostedContentFilterPolicies | Where-Object -FilterScript { $_.Identity -eq $Identity }
    $HostedContentFilterPolicyParams = $PSBoundParameters
    $HostedContentFilterPolicyParams.Remove('Ensure') | Out-Null
    $HostedContentFilterPolicyParams.Remove('GlobalAdminAccount') | Out-Null
    $HostedContentFilterPolicyParams.Remove('MakeDefault') | Out-Null

    if (('Present' -eq $Ensure ) -and ($null -eq $HostedContentFilterPolicy))
    {
        $HostedContentFilterPolicyParams += @{
            Name = $HostedContentFilterPolicyParams.Identity
        }
        $HostedContentFilterPolicyParams.Remove('Identity') | Out-Null
        Write-Verbose -Message "Creating HostedContentFilterPolicy $($Identity)."
        New-HostedContentFilterPolicy @HostedContentFilterPolicyParams
    }
    elseif (('Present' -eq $Ensure ) -and ($null -ne $HostedContentFilterPolicy))
    {
        Write-Verbose -Message "Setting HostedContentFilterPolicy $($Identity) with values: $(Convert-M365DscHashtableToString -Hashtable $HostedContentFilterPolicyParams)."
        if ($PSBoundParameters.MakeDefault)
        {
            Set-HostedContentFilterPolicy @HostedContentFilterPolicyParams -MakeDefault -Confirm:$false
        }
        else
        {
            Set-HostedContentFilterPolicy @HostedContentFilterPolicyParams -Confirm:$false
        }
    }
    elseif (('Absent' -eq $Ensure ) -and ($null -ne $HostedContentFilterPolicy))
    {
        Write-Verbose -Message "Removing HostedContentFilterPolicy $($Identity) "
        Remove-HostedContentFilterPolicy -Identity $Identity -Confirm:$false
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $AddXHeaderValue,

        [Parameter()]
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [System.String[]]
        $AllowedSenderDomains = @(),

        [Parameter()]
        [System.String[]]
        $AllowedSenders = @(),

        [Parameter()]
        [System.String[]]
        $BlockedSenderDomains = @(),

        [Parameter()]
        [System.String[]]
        $BlockedSenders = @(),

        [Parameter()]
        [ValidateSet('MoveToJmf', 'AddXHeader', 'ModifySubject', 'Redirect', 'Delete', 'Quarantine')]
        [System.String]
        $BulkSpamAction = 'MoveToJmf',

        [Parameter()]
        [ValidateRange(1, 9)]
        [uint32]
        $BulkThreshold = 7,

        [Parameter()]
        [System.Boolean]
        $DownloadLink = $false,

        [Parameter()]
        [System.Boolean]
        $EnableEndUserSpamNotifications = $false,

        [Parameter()]
        [System.Boolean]
        $EnableLanguageBlockList = $false,

        [Parameter()]
        [System.Boolean]
        $EnableRegionBlockList = $false,

        [Parameter()]
        [ValidatePattern("^$|^[a-zA-Z0-9.!£#$%&'^_`{}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$")]
        [System.String]
        $EndUserSpamNotificationCustomFromAddress,

        [Parameter()]
        [System.String]
        $EndUserSpamNotificationCustomFromName,

        [Parameter()]
        [System.String]
        $EndUserSpamNotificationCustomSubject,

        [Parameter()]
        [ValidateRange(1, 15)]
        [uint32]
        $EndUserSpamNotificationFrequency = 3,

        [Parameter()]
        [ValidateSet('Default', 'English', 'French', 'German', 'Italian', 'Japanese', 'Spanish', 'Korean', 'Portuguese', 'Russian', 'ChineseSimplified', 'ChineseTraditional', 'Amharic', 'Arabic', 'Bulgarian', 'BengaliIndia', 'Catalan', 'Czech', 'Cyrillic', 'Danish', 'Greek', 'Estonian', 'Basque', 'Farsi', 'Finnish', 'Filipino', 'Galician', 'Gujarati', 'Hebrew', 'Hindi', 'Croatian', 'Hungarian', 'Indonesian', 'Icelandic', 'Kazakh', 'Kannada', 'Lithuanian', 'Latvian', 'Malayalam', 'Marathi', 'Malay', 'Dutch', 'NorwegianNynorsk', 'Norwegian', 'Oriya', 'Polish', 'PortuguesePortugal', 'Romanian', 'Slovak', 'Slovenian', 'SerbianCyrillic', 'Serbian', 'Swedish', 'Swahili', 'Tamil', 'Telugu', 'Thai', 'Turkish', 'Ukrainian', 'Urdu', 'Vietnamese')]
        [System.String]
        $EndUserSpamNotificationLanguage = 'Default',

        [Parameter()]
        [ValidateSet('MoveToJmf', 'AddXHeader', 'ModifySubject', 'Redirect', 'Delete', 'Quarantine', 'NoAction')]
        [System.String]
        $HighConfidenceSpamAction = 'MoveToJmf',

        [Parameter()]
        [System.Boolean]
        $InlineSafetyTipsEnabled = $true,

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $IncreaseScoreWithBizOrInfoUrls = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $IncreaseScoreWithImageLinks = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $IncreaseScoreWithNumericIps = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $IncreaseScoreWithRedirectToOtherPort = 'Off',

        [Parameter()]
        [System.String[]]
        $LanguageBlockList = @(),

        [Parameter()]
        [System.Boolean]
        $MakeDefault = $false,

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $MarkAsSpamBulkMail = 'On',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $MarkAsSpamEmbedTagsInHtml = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $MarkAsSpamEmptyMessages = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $MarkAsSpamFormTagsInHtml = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $MarkAsSpamFramesInHtml = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $MarkAsSpamFromAddressAuthFail = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $MarkAsSpamJavaScriptInHtml = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $MarkAsSpamNdrBackscatter = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $MarkAsSpamObjectTagsInHtml = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $MarkAsSpamSensitiveWordList = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $MarkAsSpamSpfRecordHardFail = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On', 'Test')]
        [System.String]
        $MarkAsSpamWebBugsInHtml = 'Off',

        [Parameter()]
        [System.String]
        $ModifySubjectValue,

        [Parameter()]
        [ValidateSet('MoveToJmf', 'AddXHeader', 'ModifySubject', 'Redirect', 'Delete', 'Quarantine', 'NoAction')]
        [System.String]
        $PhishSpamAction = 'MoveToJmf',

        [Parameter()]
        [ValidateRange(1, 15)]
        [uint32]
        $QuarantineRetentionPeriod = 15,

        [Parameter()]
        [System.String[]]
        $RedirectToRecipients = @(),

        [Parameter()]
        [System.String[]]
        $RegionBlockList = @(),

        [Parameter()]
        [ValidateSet('MoveToJmf', 'AddXHeader', 'ModifySubject', 'Redirect', 'Delete', 'Quarantine', 'NoAction')]
        [System.String]
        $SpamAction = 'MoveToJmf',

        [Parameter()]
        [ValidateSet('None', 'AddXHeader', 'BccMessage')]
        [System.String]
        $TestModeAction = 'None',

        [Parameter()]
        [System.String[]]
        $TestModeBccToRecipients = @(),

        [Parameter()]
        [System.Boolean]
        $ZapEnabled = $true,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of HostedContentFilterPolicy for $Identity"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

    $TestResult = Test-Microsoft365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $TestResult"

    return $TestResult
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $HostedContentFilterPolicies = Get-HostedContentFilterPolicy
    $content = ''

    foreach ($HostedContentFilterPolicy in $HostedContentFilterPolicies)
    {
        $params = @{
            GlobalAdminAccount = $GlobalAdminAccount
            Identity           = $HostedContentFilterPolicy.Identity
        }
        $result = Get-TargetResource @params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content += "        EXOHostedContentFilterPolicy " + (New-GUID).ToString() + "`r`n"
        $content += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        $content += "        }`r`n"
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
