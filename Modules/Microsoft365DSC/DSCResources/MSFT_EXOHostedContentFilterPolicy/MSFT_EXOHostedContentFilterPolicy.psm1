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
        [System.String]
        $BulkQuarantineTag,

        [Parameter()]
        [ValidateSet('MoveToJmf', 'AddXHeader', 'ModifySubject', 'Redirect', 'Delete', 'Quarantine', 'NoAction')]
        [System.String]
        $BulkSpamAction = 'MoveToJmf',

        [Parameter()]
        [ValidateRange(1, 9)]
        [uint32]
        $BulkThreshold = 7,

        [Parameter()]
        [System.Boolean]
        $DownloadLink = $false,

        #DEPRECATED
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
        [ValidateSet('MoveToJmf', 'Redirect', 'Quarantine')]
        [System.String]
        $HighConfidencePhishAction = 'Quarantine',

        [Parameter()]
        [System.String]
        $HighConfidencePhishQuarantineTag,

        [Parameter()]
        [ValidateSet('MoveToJmf', 'AddXHeader', 'ModifySubject', 'Redirect', 'Delete', 'Quarantine', 'NoAction')]
        [System.String]
        $HighConfidenceSpamAction = 'MoveToJmf',

        [Parameter()]
        [System.String]
        $HighConfidenceSpamQuarantineTag,

        [Parameter()]
        [System.Boolean]
        $InlineSafetyTipsEnabled = $true,

        [Parameter()]
        [ValidateSet('Default', 'HighConfidencePhish', 'Phish', 'HighConfidenceSpam', 'Spam', 'Disabled')]
        [System.String]
        $IntraOrgFilterState = 'Default',

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
        [System.String]
        $PhishQuarantineTag,

        [Parameter()]
        [System.String]
        $SpamQuarantineTag,

        [Parameter()]
        [ValidateSet('MoveToJmf', 'AddXHeader', 'ModifySubject', 'Redirect', 'Delete', 'Quarantine', 'NoAction')]
        [System.String]
        $PhishSpamAction = 'MoveToJmf',

        [Parameter()]
        [ValidateRange(1, 30)]
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
        $PhishZapEnabled = $true,

        [Parameter()]
        [System.Boolean]
        $SpamZapEnabled = $true,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration of HostedContentFilterPolicy for $Identity"

    if ($Global:CurrentModeIsExport)
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters `
            -SkipModuleReload $true
    }
    else
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters
    }

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = 'Absent'
    try
    {
        $HostedContentFilterPolicy = Get-HostedContentFilterPolicy -Identity $Identity -ErrorAction Stop
        if ($null -eq $HostedContentFilterPolicy)
        {
            Write-Verbose -Message "HostedContentFilterPolicy $($Identity) does not exist."
            return $nullReturn
        }
        else
        {
            [System.String[]]$AllowedSendersValues = $HostedContentFilterPolicy.AllowedSenders.Sender | Select-Object Address -ExpandProperty Address
            [System.String[]]$BlockedSendersValues = $HostedContentFilterPolicy.BlockedSenders.Sender | Select-Object Address -ExpandProperty Address
            # Check if the values are null and assign them an empty string array if they are
            if ($null -eq $AllowedSendersValues) {
                $AllowedSendersValues = @()
            }
            if ($null -eq $BlockedSendersValues) {
                $BlockedSendersValues = @()
            }

            [System.String[]]$AllowedSenderDomains = $HostedContentFilterPolicy.AllowedSenderDomains.Domain
            [System.String[]]$BlockedSenderDomains = $HostedContentFilterPolicy.BlockedSenderDomains.Domain
            # Check if the values are null and assign them an empty string array if they are
            if ($null -eq $AllowedSenderDomains) {
                $AllowedSenderDomains = @()
            }
            if ($null -eq $BlockedSenderDomains) {
                $BlockedSenderDomains = @()
            }
            $result = @{
                Ensure                               = 'Present'
                Identity                             = $Identity
                AddXHeaderValue                      = $HostedContentFilterPolicy.AddXHeaderValue
                AdminDisplayName                     = $HostedContentFilterPolicy.AdminDisplayName
                AllowedSenderDomains                 = $AllowedSenderDomains
                AllowedSenders                       = $AllowedSendersValues
                BlockedSenderDomains                 = $BlockedSenderDomains
                BlockedSenders                       = $BlockedSendersValues
                BulkQuarantineTag                    = $HostedContentFilterPolicy.BulkQuarantineTag
                BulkSpamAction                       = $HostedContentFilterPolicy.BulkSpamAction
                BulkThreshold                        = $HostedContentFilterPolicy.BulkThreshold
                DownloadLink                         = $HostedContentFilterPolicy.DownloadLink
                #Deprecated
                #EnableEndUserSpamNotifications       = $HostedContentFilterPolicy.EnableEndUserSpamNotifications
                EnableLanguageBlockList              = $HostedContentFilterPolicy.EnableLanguageBlockList
                EnableRegionBlockList                = $HostedContentFilterPolicy.EnableRegionBlockList
                #Deprecated
                #EndUserSpamNotificationCustomSubject = $HostedContentFilterPolicy.EndUserSpamNotificationCustomSubject
                #EndUserSpamNotificationFrequency     = $HostedContentFilterPolicy.EndUserSpamNotificationFrequency
                #EndUserSpamNotificationLanguage      = $HostedContentFilterPolicy.EndUserSpamNotificationLanguage
                HighConfidencePhishAction            = $HostedContentFilterPolicy.HighConfidencePhishAction
                HighConfidencePhishQuarantineTag     = $HostedContentFilterPolicy.HighConfidencePhishQuarantineTag
                HighConfidenceSpamAction             = $HostedContentFilterPolicy.HighConfidenceSpamAction
                HighConfidenceSpamQuarantineTag      = $HostedContentFilterPolicy.HighConfidenceSpamQuarantineTag
                InlineSafetyTipsEnabled              = $HostedContentFilterPolicy.InlineSafetyTipsEnabled
                IntraOrgFilterState                  = $HostedContentFilterPolicy.IntraOrgFilterState
                IncreaseScoreWithBizOrInfoUrls       = $HostedContentFilterPolicy.IncreaseScoreWithBizOrInfoUrls
                IncreaseScoreWithImageLinks          = $HostedContentFilterPolicy.IncreaseScoreWithImageLinks
                IncreaseScoreWithNumericIps          = $HostedContentFilterPolicy.IncreaseScoreWithNumericIps
                IncreaseScoreWithRedirectToOtherPort = $HostedContentFilterPolicy.IncreaseScoreWithRedirectToOtherPort
                LanguageBlockList                    = $HostedContentFilterPolicy.LanguageBlockList
                MakeDefault                          = $HostedContentFilterPolicy.IsDefault
                MarkAsSpamBulkMail                   = $HostedContentFilterPolicy.MarkAsSpamBulkMail
                MarkAsSpamEmbedTagsInHtml            = $HostedContentFilterPolicy.MarkAsSpamEmbedTagsInHtml
                MarkAsSpamEmptyMessages              = $HostedContentFilterPolicy.MarkAsSpamEmptyMessages
                MarkAsSpamFormTagsInHtml             = $HostedContentFilterPolicy.MarkAsSpamFormTagsInHtml
                MarkAsSpamFramesInHtml               = $HostedContentFilterPolicy.MarkAsSpamFramesInHtml
                MarkAsSpamFromAddressAuthFail        = $HostedContentFilterPolicy.MarkAsSpamFromAddressAuthFail
                MarkAsSpamJavaScriptInHtml           = $HostedContentFilterPolicy.MarkAsSpamJavaScriptInHtml
                MarkAsSpamNdrBackscatter             = $HostedContentFilterPolicy.MarkAsSpamNdrBackscatter
                MarkAsSpamObjectTagsInHtml           = $HostedContentFilterPolicy.MarkAsSpamObjectTagsInHtml
                MarkAsSpamSensitiveWordList          = $HostedContentFilterPolicy.MarkAsSpamSensitiveWordList
                MarkAsSpamSpfRecordHardFail          = $HostedContentFilterPolicy.MarkAsSpamSpfRecordHardFail
                MarkAsSpamWebBugsInHtml              = $HostedContentFilterPolicy.MarkAsSpamWebBugsInHtml
                ModifySubjectValue                   = $HostedContentFilterPolicy.ModifySubjectValue
                PhishSpamAction                      = $HostedContentFilterPolicy.PhishSpamAction
                PhishQuarantineTag                   = $HostedContentFilterPolicy.PhishQuarantineTag
                SpamQuarantineTag                    = $HostedContentFilterPolicy.SpamQuarantineTag
                QuarantineRetentionPeriod            = $HostedContentFilterPolicy.QuarantineRetentionPeriod
                RedirectToRecipients                 = $HostedContentFilterPolicy.RedirectToRecipients
                RegionBlockList                      = $HostedContentFilterPolicy.RegionBlockList
                SpamAction                           = $HostedContentFilterPolicy.SpamAction
                TestModeAction                       = $HostedContentFilterPolicy.TestModeAction
                TestModeBccToRecipients              = $HostedContentFilterPolicy.TestModeBccToRecipients
                PhishZapEnabled                      = $HostedContentFilterPolicy.PhishZapEnabled
                SpamZapEnabled                       = $HostedContentFilterPolicy.SpamZapEnabled
                Credential                           = $Credential
                ApplicationId                        = $ApplicationId
                CertificateThumbprint                = $CertificateThumbprint
                CertificatePath                      = $CertificatePath
                CertificatePassword                  = $CertificatePassword
                Managedidentity                      = $ManagedIdentity.IsPresent
                TenantId                             = $TenantId
                AccessTokens                         = $AccessTokens
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
    catch
    {
        Write-Verbose -Message $_
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $nullReturn
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
        [System.String]
        $BulkQuarantineTag,

        [Parameter()]
        [ValidateSet('MoveToJmf', 'AddXHeader', 'ModifySubject', 'Redirect', 'Delete', 'Quarantine', 'NoAction')]
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
        [ValidateSet('MoveToJmf', 'Redirect', 'Quarantine')]
        [System.String]
        $HighConfidencePhishAction = 'Quarantine',

        [Parameter()]
        [System.String]
        $HighConfidencePhishQuarantineTag,

        [Parameter()]
        [ValidateSet('MoveToJmf', 'AddXHeader', 'ModifySubject', 'Redirect', 'Delete', 'Quarantine', 'NoAction')]
        [System.String]
        $HighConfidenceSpamAction = 'MoveToJmf',

        [Parameter()]
        [System.String]
        $HighConfidenceSpamQuarantineTag,

        [Parameter()]
        [System.Boolean]
        $InlineSafetyTipsEnabled = $true,

        [Parameter()]
        [ValidateSet('Default', 'HighConfidencePhish', 'Phish', 'HighConfidenceSpam', 'Spam', 'Disabled')]
        [System.String]
        $IntraOrgFilterState = 'Default',

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
        [System.String]
        $PhishQuarantineTag,

        [Parameter()]
        [System.String]
        $SpamQuarantineTag,

        [Parameter()]
        [ValidateSet('MoveToJmf', 'AddXHeader', 'ModifySubject', 'Redirect', 'Delete', 'Quarantine', 'NoAction')]
        [System.String]
        $PhishSpamAction = 'MoveToJmf',

        [Parameter()]
        [ValidateRange(1, 30)]
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
        $PhishZapEnabled = $true,

        [Parameter()]
        [System.Boolean]
        $SpamZapEnabled = $true,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Setting configuration of HostedContentFilterPolicy for $Identity"

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    Write-Verbose (Get-HostedContentFilterPolicy | Out-String)
    $HostedContentFilterPolicies = Get-HostedContentFilterPolicy

    $HostedContentFilterPolicy = $HostedContentFilterPolicies | Where-Object -FilterScript { $_.Identity -eq $Identity }
    $HostedContentFilterPolicyParams = [System.Collections.Hashtable]($PSBoundParameters)
    $HostedContentFilterPolicyParams.Remove('Ensure') | Out-Null
    $HostedContentFilterPolicyParams.Remove('Credential') | Out-Null
    $HostedContentFilterPolicyParams.Remove('MakeDefault') | Out-Null
    $HostedContentFilterPolicyParams.Remove('ApplicationId') | Out-Null
    $HostedContentFilterPolicyParams.Remove('TenantId') | Out-Null
    $HostedContentFilterPolicyParams.Remove('CertificateThumbprint') | Out-Null
    $HostedContentFilterPolicyParams.Remove('CertificatePath') | Out-Null
    $HostedContentFilterPolicyParams.Remove('CertificatePassword') | Out-Null
    $HostedContentFilterPolicyParams.Remove('ManagedIdentity') | Out-Null
    $HostedContentFilterPolicyParams.Remove('AccessTokens') | Out-Null

    if (('Present' -eq $Ensure ) -and ($null -eq $HostedContentFilterPolicy))
    {
        $HostedContentFilterPolicyParams += @{
            Name = $HostedContentFilterPolicyParams.Identity
        }
        $HostedContentFilterPolicyParams.Remove('Identity') | Out-Null
        Write-Verbose -Message "Creating HostedContentFilterPolicy $($Identity) with values: $(Convert-M365DscHashtableToString -Hashtable $HostedContentFilterPolicyParams)"
        New-HostedContentFilterPolicy @HostedContentFilterPolicyParams
        if ($PSBoundParameters.MakeDefault)
        {
            Write-Verbose -Message 'Updating Policy as default'
            Set-HostedContentFilterPolicy @HostedContentFilterPolicyParams -MakeDefault -Confirm:$false
        }
    }
    elseif (('Present' -eq $Ensure ) -and ($null -ne $HostedContentFilterPolicy))
    {
        Write-Verbose -Message "Setting HostedContentFilterPolicy $($Identity) with values: $(Convert-M365DscHashtableToString -Hashtable $HostedContentFilterPolicyParams)."
        if ($PSBoundParameters.MakeDefault)
        {
            Write-Verbose -Message 'Updating Policy as default'
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
        [System.String]
        $BulkQuarantineTag,

        [Parameter()]
        [ValidateSet('MoveToJmf', 'AddXHeader', 'ModifySubject', 'Redirect', 'Delete', 'Quarantine', 'NoAction')]
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
        [ValidateSet('MoveToJmf', 'Redirect', 'Quarantine')]
        [System.String]
        $HighConfidencePhishAction = 'Quarantine',

        [Parameter()]
        [System.String]
        $HighConfidencePhishQuarantineTag,

        [Parameter()]
        [ValidateSet('MoveToJmf', 'AddXHeader', 'ModifySubject', 'Redirect', 'Delete', 'Quarantine', 'NoAction')]
        [System.String]
        $HighConfidenceSpamAction = 'MoveToJmf',

        [Parameter()]
        [System.String]
        $HighConfidenceSpamQuarantineTag,

        [Parameter()]
        [System.Boolean]
        $InlineSafetyTipsEnabled = $true,

        [Parameter()]
        [ValidateSet('Default', 'HighConfidencePhish', 'Phish', 'HighConfidenceSpam', 'Spam', 'Disabled')]
        [System.String]
        $IntraOrgFilterState = 'Default',

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
        [System.String]
        $PhishQuarantineTag,

        [Parameter()]
        [System.String]
        $SpamQuarantineTag,

        [Parameter()]
        [ValidateSet('MoveToJmf', 'AddXHeader', 'ModifySubject', 'Redirect', 'Delete', 'Quarantine', 'NoAction')]
        [System.String]
        $PhishSpamAction = 'MoveToJmf',

        [Parameter()]
        [ValidateRange(1, 30)]
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
        $PhishZapEnabled = $true,

        [Parameter()]
        [System.Boolean]
        $SpamZapEnabled = $true,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of HostedContentFilterPolicy for $Identity"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('EnableEndUserSpamNotifications') | Out-Null
    $ValuesToCheck.Remove('EndUserSpamNotificationLanguage') | Out-Null
    $ValuesToCheck.Remove('EndUserSpamNotificationFrequency') | Out-Null
    $ValuesToCheck.Remove('EndUserSpamNotificationCustomSubject') | Out-Null

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $ValuesToCheck `
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
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload $true

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        [array]$HostedContentFilterPolicies = Get-HostedContentFilterPolicy -ErrorAction Stop
        $dscContent = ''

        if ($HostedContentFilterPolicies.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        $i = 1
        foreach ($HostedContentFilterPolicy in $HostedContentFilterPolicies)
        {
            $Params = @{
                Credential            = $Credential
                Identity              = $HostedContentFilterPolicy.Identity
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                Managedidentity       = $ManagedIdentity.IsPresent
                CertificatePath       = $CertificatePath
                AccessTokens          = $AccessTokens
            }
            Write-Host "    |---[$i/$($HostedContentFilterPolicies.Length)] $($HostedContentFilterPolicy.Identity)" -NoNewline
            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $i++
        }
        return $dscContent
    }
    catch
    {
        Write-Host $Global:M365DSCEmojiRedX

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
