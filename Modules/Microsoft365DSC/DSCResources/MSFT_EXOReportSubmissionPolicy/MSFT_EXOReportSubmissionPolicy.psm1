function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $DisableQuarantineReportingOption,

        [Parameter()]
        [System.Boolean]
        $EnableCustomNotificationSender,

        [Parameter()]
        [System.Boolean]
        $EnableOrganizationBranding,

        [Parameter()]
        [System.Boolean]
        $EnableReportToMicrosoft,

        [Parameter()]
        [System.Boolean]
        $EnableThirdPartyAddress,

        [Parameter()]
        [System.Boolean]
        $EnableUserEmailNotification,

        [Parameter()]
        [System.String]
        $JunkReviewResultMessage,

        [Parameter()]
        [System.String]
        $NotJunkReviewResultMessage,

        [Parameter()]
        [System.String]
        $NotificationFooterMessage,

        [Parameter()]
        [System.String]
        $NotificationSenderAddress,

        [Parameter()]
        [System.String]
        $PhishingReviewResultMessage,

        [Parameter()]
        [System.String]
        $PostSubmitMessage,

        [Parameter()]
        [System.Boolean]
        $PostSubmitMessageEnabled,

        [Parameter()]
        [System.String]
        $PostSubmitMessageTitle,

        [Parameter()]
        [System.String]
        $PreSubmitMessage,

        [Parameter()]
        [System.Boolean]
        $PreSubmitMessageEnabled,

        [Parameter()]
        [System.String]
        $PreSubmitMessageTitle,

        [Parameter()]
        [System.String[]]
        $ReportJunkAddresses = @(),

        [Parameter()]
        [System.Boolean]
        $ReportJunkToCustomizedAddress,

        [Parameter()]
        [System.String[]]
        $ReportNotJunkAddresses = @(),

        [Parameter()]
        [System.Boolean]
        $ReportNotJunkToCustomizedAddress,

        [Parameter()]
        [System.String[]]
        $ReportPhishAddresses = @(),

        [Parameter()]
        [System.Boolean]
        $ReportPhishToCustomizedAddress,

        [Parameter()]
        [System.String[]]
        $ThirdPartyReportAddresses = @(),

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

    Write-Verbose -Message "Getting configuration of ReportSubmissionPolicy"
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
    $nullReturn.IsSingleInstance = 'Yes'

    try
    {
        $ReportSubmissionPolicy = Get-ReportSubmissionPolicy -ErrorAction Stop

        if ($null -eq $ReportSubmissionPolicy)
        {
            Write-Verbose -Message "ReportSubmissionPolicy does not exist."
            return $nullReturn
        }
        else
        {
            $result = @{
                IsSingleInstance                       = 'Yes'
                DisableQuarantineReportingOption       = $ReportSubmissionPolicy.DisableQuarantineReportingOption
                EnableCustomNotificationSender         = $ReportSubmissionPolicy.EnableCustomNotificationSender
                EnableOrganizationBranding             = $ReportSubmissionPolicy.EnableOrganizationBranding
                EnableReportToMicrosoft                = $ReportSubmissionPolicy.EnableReportToMicrosoft
                EnableThirdPartyAddress                = $ReportSubmissionPolicy.EnableThirdPartyAddress
                EnableUserEmailNotification            = $ReportSubmissionPolicy.EnableUserEmailNotification
                JunkReviewResultMessage                = $ReportSubmissionPolicy.JunkReviewResultMessage
                NotJunkReviewResultMessage             = $ReportSubmissionPolicy.NotJunkReviewResultMessage
                NotificationFooterMessage              = $ReportSubmissionPolicy.NotificationFooterMessage
                NotificationSenderAddress              = $ReportSubmissionPolicy.NotificationSenderAddress
                PhishingReviewResultMessage            = $ReportSubmissionPolicy.PhishingReviewResultMessage
                PostSubmitMessage                      = $ReportSubmissionPolicy.PostSubmitMessage
                PostSubmitMessageEnabled               = $ReportSubmissionPolicy.PostSubmitMessageEnabled
                PostSubmitMessageTitle                 = $ReportSubmissionPolicy.PostSubmitMessageTitle
                PreSubmitMessage                       = $ReportSubmissionPolicy.PreSubmitMessage
                PreSubmitMessageEnabled                = $ReportSubmissionPolicy.PreSubmitMessageEnabled
                PreSubmitMessageTitle                  = $ReportSubmissionPolicy.PreSubmitMessageTitle
                ReportJunkAddresses                    = $ReportSubmissionPolicy.ReportJunkAddresses
                ReportJunkToCustomizedAddress          = $ReportSubmissionPolicy.ReportJunkToCustomizedAddress
                ReportNotJunkAddresses                 = $ReportSubmissionPolicy.ReportNotJunkAddresses
                ReportNotJunkToCustomizedAddress       = $ReportSubmissionPolicy.ReportNotJunkToCustomizedAddress
                ReportPhishAddresses                   = $ReportSubmissionPolicy.ReportPhishAddresses
                ReportPhishToCustomizedAddress         = $ReportSubmissionPolicy.ReportPhishToCustomizedAddress
                ThirdPartyReportAddresses              = $ReportSubmissionPolicy.ThirdPartyReportAddresses
                Credential                             = $Credential
                Ensure                                 = 'Present'
                ApplicationId                          = $ApplicationId
                CertificateThumbprint                  = $CertificateThumbprint
                CertificatePath                        = $CertificatePath
                CertificatePassword                    = $CertificatePassword
                Managedidentity                        = $ManagedIdentity.IsPresent
                TenantId                               = $TenantId
                AccessTokens                           = $AccessTokens
            }

            Write-Verbose -Message "Found ReportSubmissionPolicy"
            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
            return $result
        }
    }
    catch
    {
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
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $DisableQuarantineReportingOption,

        [Parameter()]
        [System.Boolean]
        $EnableCustomNotificationSender,

        [Parameter()]
        [System.Boolean]
        $EnableOrganizationBranding,

        [Parameter()]
        [System.Boolean]
        $EnableReportToMicrosoft,

        [Parameter()]
        [System.Boolean]
        $EnableThirdPartyAddress,

        [Parameter()]
        [System.Boolean]
        $EnableUserEmailNotification,

        [Parameter()]
        [System.String]
        $JunkReviewResultMessage,

        [Parameter()]
        [System.String]
        $NotJunkReviewResultMessage,

        [Parameter()]
        [System.String]
        $NotificationFooterMessage,

        [Parameter()]
        [System.String]
        $NotificationSenderAddress,

        [Parameter()]
        [System.String]
        $PhishingReviewResultMessage,

        [Parameter()]
        [System.String]
        $PostSubmitMessage,

        [Parameter()]
        [System.Boolean]
        $PostSubmitMessageEnabled,

        [Parameter()]
        [System.String]
        $PostSubmitMessageTitle,

        [Parameter()]
        [System.String]
        $PreSubmitMessage,

        [Parameter()]
        [System.Boolean]
        $PreSubmitMessageEnabled,

        [Parameter()]
        [System.String]
        $PreSubmitMessageTitle,

        [Parameter()]
        [System.String[]]
        $ReportJunkAddresses = @(),

        [Parameter()]
        [System.Boolean]
        $ReportJunkToCustomizedAddress,

        [Parameter()]
        [System.String[]]
        $ReportNotJunkAddresses = @(),

        [Parameter()]
        [System.Boolean]
        $ReportNotJunkToCustomizedAddress,

        [Parameter()]
        [System.String[]]
        $ReportPhishAddresses = @(),

        [Parameter()]
        [System.Boolean]
        $ReportPhishToCustomizedAddress,

        [Parameter()]
        [System.String[]]
        $ThirdPartyReportAddresses = @(),

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
    Write-Verbose -Message "Setting configuration of ReportSubmissionPolicy"

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $currentReportSubmissionPolicy = Get-TargetResource @PSBoundParameters

    $ReportSubmissionPolicyParams = [System.Collections.Hashtable]($PSBoundParameters)
    $ReportSubmissionPolicyParams.Remove('Ensure') | Out-Null
    $ReportSubmissionPolicyParams.Remove('IsSingleInstance') | Out-Null
    $ReportSubmissionPolicyParams.Remove('Credential') | Out-Null
    $ReportSubmissionPolicyParams.Remove('ApplicationId') | Out-Null
    $ReportSubmissionPolicyParams.Remove('TenantId') | Out-Null
    $ReportSubmissionPolicyParams.Remove('CertificateThumbprint') | Out-Null
    $ReportSubmissionPolicyParams.Remove('CertificatePath') | Out-Null
    $ReportSubmissionPolicyParams.Remove('CertificatePassword') | Out-Null
    $ReportSubmissionPolicyParams.Remove('ManagedIdentity') | Out-Null
    $ReportSubmissionPolicyParams.Add('Identity', 'DefaultReportSubmissionPolicy') | Out-Null
    $ReportSubmissionPolicyParams.Remove('AccessTokens') | Out-Null

    if ($Ensure -eq 'Present' -and $currentReportSubmissionPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating ReportSubmissionPolicy"

        New-ReportSubmissionPolicy
        Set-ReportSubmissionPolicy @ReportSubmissionPolicyParams -Confirm:$false
    }
    elseif ($Ensure -eq 'Present' -and $currentReportSubmissionPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Setting ReportSubmissionPolicy with values: $(Convert-M365DscHashtableToString -Hashtable $ReportSubmissionPolicyParams)"
        Set-ReportSubmissionPolicy @ReportSubmissionPolicyParams -Confirm:$false
    }
    elseif ($Ensure -eq 'Absent' -and $currentReportSubmissionPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing ReportSubmissionPolicy"
        Remove-ReportSubmissionPolicy -Identity "DefaultReportSubmissionPolicy"
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $DisableQuarantineReportingOption,

        [Parameter()]
        [System.Boolean]
        $EnableCustomNotificationSender,

        [Parameter()]
        [System.Boolean]
        $EnableOrganizationBranding,

        [Parameter()]
        [System.Boolean]
        $EnableReportToMicrosoft,

        [Parameter()]
        [System.Boolean]
        $EnableThirdPartyAddress,

        [Parameter()]
        [System.Boolean]
        $EnableUserEmailNotification,

        [Parameter()]
        [System.String]
        $JunkReviewResultMessage,

        [Parameter()]
        [System.String]
        $NotJunkReviewResultMessage,

        [Parameter()]
        [System.String]
        $NotificationFooterMessage,

        [Parameter()]
        [System.String]
        $NotificationSenderAddress,

        [Parameter()]
        [System.String]
        $PhishingReviewResultMessage,

        [Parameter()]
        [System.String]
        $PostSubmitMessage,

        [Parameter()]
        [System.Boolean]
        $PostSubmitMessageEnabled,

        [Parameter()]
        [System.String]
        $PostSubmitMessageTitle,

        [Parameter()]
        [System.String]
        $PreSubmitMessage,

        [Parameter()]
        [System.Boolean]
        $PreSubmitMessageEnabled,

        [Parameter()]
        [System.String]
        $PreSubmitMessageTitle,

        [Parameter()]
        [System.String[]]
        $ReportJunkAddresses = @(),

        [Parameter()]
        [System.Boolean]
        $ReportJunkToCustomizedAddress,

        [Parameter()]
        [System.String[]]
        $ReportNotJunkAddresses = @(),

        [Parameter()]
        [System.Boolean]
        $ReportNotJunkToCustomizedAddress,

        [Parameter()]
        [System.String[]]
        $ReportPhishAddresses = @(),

        [Parameter()]
        [System.Boolean]
        $ReportPhishToCustomizedAddress,

        [Parameter()]
        [System.String[]]
        $ThirdPartyReportAddresses = @(),

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

    Write-Verbose -Message "Testing configuration of ReportSubmissionPolicy"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $($TestResult)"

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
        $ReportSubmissionPolicy = Get-ReportSubmissionPolicy -ErrorAction Stop
        if ($ReportSubmissionPolicy.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        $dscContent = ''

        Write-Host "    |---Export Default ReportSubmissionPolicy" -NoNewline

        $Params = @{
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            CertificatePassword   = $CertificatePassword
            Managedidentity       = $ManagedIdentity.IsPresent
            CertificatePath       = $CertificatePath
            IsSingleInstance      = 'Yes'
            AccessTokens          = $AccessTokens
        }

        $Results = Get-TargetResource @Params

        $keysToRemove = @()
        foreach ($key in $Results.Keys)
        {
            if ([System.String]::IsNullOrEmpty($Results.$key))
            {
                $keysToRemove += $key
            }
        }
        foreach ($key in $keysToRemove)
        {
            $Results.Remove($key) | Out-Null
        }
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
