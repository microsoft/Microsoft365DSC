function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [System.String]
        $MarketingNotificationEmails,

        [Parameter()]
        [System.String]
        $SecurityComplianceNotificationMails,

        [Parameter()]
        [System.String]
        $SecurityComplianceNotificationPhones,

        [Parameter()]
        [System.String]
        $TechnicalNotificationMails,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Getting configuration of AzureAD Tenant Details"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = @{
        GlobalAdminAccount = $GlobalAdminAccount
    }

    $ConnectionMode = New-M365DSCConnection -Platform 'AzureAD' -InboundParameters $PSBoundParameters

    $CurrentParameters = $PSBoundParameters


    $AADTenantDetails = Get-AzureADTenantDetail -ErrorAction 'SilentlyContinue'

    if ($null -eq $AADTenantDetails)
    {
        throw "Could not retrieve AzureAD Tenant Details"
    }
    else
    {
        Write-Verbose -Message "Found existing AzureAD Tenant Details"
        $result = @{
            MarketingNotificationEmails             = $AADTenantDetails.MarketingNotificationEmails
            SecurityComplianceNotificationMails     = $AADTenantDetails.SecurityComplianceNotificationMails
            SecurityComplianceNotificationPhones    = $AADTenantDetails.SecurityComplianceNotificationPhones
            TechnicalNotificationMails              = $AADTenantDetails.TechnicalNotificationMails
        }
        Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DSCHashTabletoString -Hashtable $result)"
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
        $IsSingleInstance,

        [Parameter()]
        [System.String]
        $MarketingNotificationEmails,

        [Parameter()]
        [System.String]
        $SecurityComplianceNotificationMails,

        [Parameter()]
        [System.String]
        $SecurityComplianceNotificationPhones,

        [Parameter()]
        [System.String]
        $TechnicalNotificationMails,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Setting configuration of AzureAD Tenant Details"

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    #$data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion


    $currentParameters = $PSBoundParameters
    $currentParameters
    $currentParameters.Remove("GlobalAdminAccount") | Out-Null
    $currentParameters.Remove("isSingleInstance") | Out-Null
    try {
        Set-AzureADTenantDetail @currentParameters
    }
    catch {
        Write-Verbose -Message "Cannot Set AzureAD Tenant Details"
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
        $IsSingleInstance,

        [Parameter()]
        [System.String]
        $MarketingNotificationEmails,

        [Parameter()]
        [System.String]
        $SecurityComplianceNotificationMails,

        [Parameter()]
        [System.String]
        $SecurityComplianceNotificationPhones,

        [Parameter()]
        [System.String]
        $TechnicalNotificationMails,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of AzureAD Tenant Details"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Target-Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null
    $ValuesToCheck.Remove('IsSingleInstance') | Out-Null

    $TestResult = Test-Microsoft365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $TestResult"

    return $TestResult

}

function Export-TargetResource {
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $dscContent = ''
    $ConnectionMode = New-M365DSCConnection -Platform 'AzureAD' -InboundParameters $PSBoundParameters

    $AADTenantDetails = Get-AzureADTenantDetail

    $Params = @{
        MarketingNotificationEmails             = $AADTenantDetails.MarketingNotificationEmails
        SecurityComplianceNotificationMails     = $AADTenantDetails.SecurityComplianceNotificationMails
        SecurityComplianceNotificationPhones    = $AADTenantDetails.SecurityComplianceNotificationPhones
        TechnicalNotificationMails              = $AADTenantDetails.TechnicalNotificationMails
        GlobalAdminAccount                      = $GlobalAdminAccount
        IsSingleInstance                       = 'Yes'
    }
    $Results = Get-TargetResource @Params
    $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode -Results $Results
    $dscContent += Get-M365DSCExportContentForResource -ResourceName $ResourceName -ConnectionMode $ConnectionMode `
        -ModulePath $PSScriptRoot `
        -Results $Results `
        -GlobalAdminAccount $GlobalAdminAccount
    Write-Host $Global:M365DSCEmojiGreenCheckMark
    return $dscContent
}

Export-ModuleMember -function *-TargetResource
