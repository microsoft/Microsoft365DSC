Confirm-M365DSCModuleDependency -ModuleName 'MSFT_EXOHostedContentFilterPolicy'

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
        $EnableLanguageBlockList = $false,

        [Parameter()]
        [System.Boolean]
        $EnableRegionBlockList = $false,

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

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Identity -ne $Identity)
        {
            $null = New-M365DSCConnection -Workload 'ExchangeOnline' `
                -InboundParameters $PSBoundParameters

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

            $HostedContentFilterPolicy = Get-HostedContentFilterPolicy -Identity $Identity -ErrorAction SilentlyContinue
            if ($null -eq $HostedContentFilterPolicy)
            {
                Write-Verbose -Message "HostedContentFilterPolicy $($Identity) does not exist."
                return $nullReturn
            }
        }
        else
        {
            $HostedContentFilterPolicy = $Script:exportedInstance
        }

        [System.String[]]$AllowedSendersValues = $HostedContentFilterPolicy.AllowedSenders.Sender | Select-Object Address -ExpandProperty Address
        [System.String[]]$BlockedSendersValues = $HostedContentFilterPolicy.BlockedSenders.Sender | Select-Object Address -ExpandProperty Address
        # Check if the values are null and assign them an empty string array if they are
        if ($null -eq $AllowedSendersValues)
        {
            $AllowedSendersValues = @()
        }
        if ($null -eq $BlockedSendersValues)
        {
            $BlockedSendersValues = @()
        }

        [System.String[]]$AllowedSenderDomains = $HostedContentFilterPolicy.AllowedSenderDomains.Domain
        [System.String[]]$BlockedSenderDomains = $HostedContentFilterPolicy.BlockedSenderDomains.Domain
        # Check if the values are null and assign them an empty string array if they are
        if ($null -eq $AllowedSenderDomains)
        {
            $AllowedSenderDomains = @()
        }
        if ($null -eq $BlockedSenderDomains)
        {
            $BlockedSenderDomains = @()
        }

        Write-Verbose -Message "Found HostedContentFilterPolicy $($Identity)"

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
            EnableLanguageBlockList              = $HostedContentFilterPolicy.EnableLanguageBlockList
            EnableRegionBlockList                = $HostedContentFilterPolicy.EnableRegionBlockList
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
            ManagedIdentity                      = $ManagedIdentity.IsPresent
            TenantId                             = $TenantId
            AccessTokens                         = $AccessTokens
        }

        if ($HostedContentFilterPolicy.IsDefault)
        {
            $result.MakeDefault = $true
        }

        return $result
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
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
        $EnableLanguageBlockList = $false,

        [Parameter()]
        [System.Boolean]
        $EnableRegionBlockList = $false,

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

    $null = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    Write-Verbose (Get-HostedContentFilterPolicy | Out-String)
    $HostedContentFilterPolicy = Get-HostedContentFilterPolicy -Identity $Identity -ErrorAction SilentlyContinue
    $HostedContentFilterPolicyParams = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ($IntraOrgFilterState -eq 'Default')
    {
        $HostedContentFilterPolicyParams.IntraOrgFilterState = 'HighConfidencePhish'
    }

    if ($Ensure -eq 'Present' -and $null -eq $HostedContentFilterPolicy)
    {
        $HostedContentFilterPolicyParams += @{
            Name = $HostedContentFilterPolicyParams.Identity
        }
        $HostedContentFilterPolicyParams.Remove('Identity') | Out-Null
        $HostedContentFilterPolicyParams.Remove('MakeDefault') | Out-Null
        Write-Verbose -Message "Creating HostedContentFilterPolicy $($Identity) with values: $(Convert-M365DscHashtableToString -Hashtable $HostedContentFilterPolicyParams)"
        New-HostedContentFilterPolicy @HostedContentFilterPolicyParams
        if ($PSBoundParameters.MakeDefault)
        {
            Write-Verbose -Message 'Updating Policy as default'
            Set-HostedContentFilterPolicy @HostedContentFilterPolicyParams -MakeDefault -Confirm:$false
        }
    }
    elseif ($Ensure -eq 'Present' -and $null -ne $HostedContentFilterPolicy)
    {
        Write-Verbose -Message "Setting HostedContentFilterPolicy $($Identity) with values: $(Convert-M365DscHashtableToString -Hashtable $HostedContentFilterPolicyParams)."
        if ($PSBoundParameters.MakeDefault)
        {
            Write-Verbose -Message 'Updating Policy as default'
            $HostedContentFilterPolicyParams.Remove('MakeDefault') | Out-Null
            Set-HostedContentFilterPolicy @HostedContentFilterPolicyParams -MakeDefault -Confirm:$false
        }
        else
        {
            Set-HostedContentFilterPolicy @HostedContentFilterPolicyParams -Confirm:$false
        }
    }
    elseif ($Ensure -eq 'Absent' -and $null -ne $HostedContentFilterPolicy)
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
        $EnableLanguageBlockList = $false,

        [Parameter()]
        [System.Boolean]
        $EnableRegionBlockList = $false,

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

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $compareParameters = Get-CompareParameters
    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '') `
        @compareParameters
    return $result
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
        -InboundParameters $PSBoundParameters

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
        $dscContent = [System.Text.StringBuilder]::new()

        if ($HostedContentFilterPolicies.Count -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        $i = 1
        foreach ($HostedContentFilterPolicy in $HostedContentFilterPolicies)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $Params = @{
                Credential            = $Credential
                Identity              = $HostedContentFilterPolicy.Identity
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                CertificatePath       = $CertificatePath
                AccessTokens          = $AccessTokens
            }
            $Script:exportedInstance = $HostedContentFilterPolicy
            Write-M365DSCHost -Message "    |---[$i/$($HostedContentFilterPolicies.Length)] $($HostedContentFilterPolicy.Identity)" -DeferWrite
            $Results = Get-TargetResource @Params
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            [void]$dscContent.Append($currentDSCBlock)
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            $i++
        }
        return $dscContent.ToString()
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

function Get-CompareParameters
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()

    return @{
        PostProcessing = {
            param($DesiredValues, $CurrentValues, $ValuesToCheck, $ignore)
            if ($CurrentValues.IntraOrgFilterState -ne $DesiredValues.IntraOrgFilterState -and $DesiredValues.IntraOrgFilterState -eq 'Default')
            {
                $ValuesToCheck.IntraOrgFilterState = 'HighConfidencePhish'
            }
            return [System.Tuple[Hashtable, Hashtable, Hashtable]]::new($DesiredValues, $CurrentValues, $ValuesToCheck)
        }
    }
}

Export-ModuleMember -Function @('*-TargetResource', 'Get-CompareParameters')
