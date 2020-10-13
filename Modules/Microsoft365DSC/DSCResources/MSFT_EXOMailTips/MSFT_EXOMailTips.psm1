function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Organization,

        [Parameter()]
        [System.Boolean]
        $MailTipsAllTipsEnabled,

        [Parameter()]
        [System.Boolean]
        $MailTipsGroupMetricsEnabled,

        [Parameter()]
        [System.UInt32]
        $MailTipsLargeAudienceThreshold,

        [Parameter()]
        [System.Boolean]
        $MailTipsMailboxSourcedTipsEnabled,

        [Parameter()]
        [System.Boolean]
        $MailTipsExternalRecipientsTipsEnabled,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

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
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword
    )

    Write-Verbose -Message "Getting configuration of Mailtips for $Organization"
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
        Organization                          = $Organization
        MailTipsAllTipsEnabled                = $null
        MailTipsGroupMetricsEnabled           = $null
        MailTipsLargeAudienceThreshold        = $null
        MailTipsMailboxSourcedTipsEnabled     = $null
        MailTipsExternalRecipientsTipsEnabled = $null
        Ensure                                = "Absent"
        GlobalAdminAccount                    = $null
    }

    if ($Global:CurrentModeIsExport)
    {
        $ConnectionMode = New-M365DSCConnection -Platform 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters `
            -SkipModuleReload $true
    }
    else
    {
        $ConnectionMode = New-M365DSCConnection -Platform 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters
    }

    try
    {
        $OrgConfig = Get-OrganizationConfig -ErrorAction Stop

        if ($null -eq $OrgConfig)
        {
            Write-Verbose -Message "Can't find the information about the Organization Configuration."
            return $nullReturn
        }

        $result = @{
            Organization                          = $Organization
            MailTipsAllTipsEnabled                = $OrgConfig.MailTipsAllTipsEnabled
            MailTipsGroupMetricsEnabled           = $OrgConfig.MailTipsGroupMetricsEnabled
            MailTipsLargeAudienceThreshold        = $OrgConfig.MailTipsLargeAudienceThreshold
            MailTipsMailboxSourcedTipsEnabled     = $OrgConfig.MailTipsMailboxSourcedTipsEnabled
            MailTipsExternalRecipientsTipsEnabled = $OrgConfig.MailTipsExternalRecipientsTipsEnabled
            Ensure                                = "Present"
            GlobalAdminAccount                    = $GlobalAdminAccount
        }

        Write-Verbose -Message "Found configuration of the Mailtips for $($Organization)"
        return $result
    }
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
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
        $Organization,

        [Parameter()]
        [System.Boolean]
        $MailTipsAllTipsEnabled,

        [Parameter()]
        [System.Boolean]
        $MailTipsGroupMetricsEnabled,

        [Parameter()]
        [System.UInt32]
        $MailTipsLargeAudienceThreshold,

        [Parameter()]
        [System.Boolean]
        $MailTipsMailboxSourcedTipsEnabled,

        [Parameter()]
        [System.Boolean]
        $MailTipsExternalRecipientsTipsEnabled,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure,

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
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword
    )

    Write-Verbose -Message "Setting configuration of Mailtips for $Organization"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $OrgConfig = Get-TargetResource @PSBoundParameters

    $ConnectionMode = New-M365DSCConnection -Platform 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    # CASE : MailTipsAllTipsEnabled is used

    if ($PSBoundParameters.ContainsKey('MailTipsAllTipsEnabled'))
    {
        Write-Verbose -Message "Setting Mailtips for $($Organization) to $($MailTipsAllTipsEnabled)"
        Set-OrganizationConfig -MailTipsAllTipsEnabled $MailTipsAllTipsEnabled
    }
    # CASE : MailTipsGroupMetricsEnabled is used
    if ($PSBoundParameters.ContainsKey('MailTipsGroupMetricsEnabled'))
    {
        Write-Verbose -Message "Setting Mailtips for Group Metrics of $($Organization) to $($MailTipsGroupMetricsEnabled)"
        Set-OrganizationConfig -MailTipsGroupMetricsEnabled $MailTipsGroupMetricsEnabled
    }
    # CASE : MailTipsLargeAudienceThreshold is used
    if ($PSBoundParameters.ContainsKey('MailTipsLargeAudienceThreshold'))
    {
        Write-Verbose -Message "Setting Mailtips for Large Audience of $($Organization) to $($MailTipsLargeAudienceThreshold)"
        Set-OrganizationConfig -MailTipsLargeAudienceThreshold $MailTipsLargeAudienceThreshold
    }
    # CASE : MailTipsMailboxSourcedTipsEnabled is used
    if ($PSBoundParameters.ContainsKey('MailTipsMailboxSourcedTipsEnabled'))
    {
        Write-Verbose -Message "Setting Mailtips for Mailbox Data (OOF/Mailbox Full) of $($Organization) to $($MailTipsMailboxSourcedTipsEnabled)"
        Set-OrganizationConfig -MailTipsMailboxSourcedTipsEnabled $MailTipsMailboxSourcedTipsEnabled
    }
    # CASE : MailTipsExternalRecipientsTipsEnabled is used
    if ($PSBoundParameters.ContainsKey('MailTipsExternalRecipientsTipsEnabled'))
    {
        Write-Verbose -Message "Setting Mailtips for External Users of $($Organization) to $($MailTipsExternalRecipientsTipsEnabled)"
        Set-OrganizationConfig -MailTipsExternalRecipientsTipsEnabled $MailTipsExternalRecipientsTipsEnabled
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
        $Organization,

        [Parameter()]
        [System.Boolean]
        $MailTipsAllTipsEnabled,

        [Parameter()]
        [System.Boolean]
        $MailTipsGroupMetricsEnabled,

        [Parameter()]
        [System.UInt32]
        $MailTipsLargeAudienceThreshold,

        [Parameter()]
        [System.Boolean]
        $MailTipsMailboxSourcedTipsEnabled,

        [Parameter()]
        [System.Boolean]
        $MailTipsExternalRecipientsTipsEnabled,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure,

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
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword
    )

    Write-Verbose -Message "Testing configuration of Mailtips for $Organization"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @("MailTipsAllTipsEnabled",
        "MailTipsGroupMetricsEnabled",
        "MailTipsLargeAudienceThreshold",
        "MailTipsMailboxSourcedTipsEnabled",
        "MailTipsExternalRecipientsTipsEnabled",
        "Ensure")

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
        $GlobalAdminAccount,

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
        $CertificatePassword
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

    $ConnectionMode = New-M365DSCConnection -Platform 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload $true
    try
    {
        $OrganizationName = ""
        if ($ConnectionMode -eq 'ServicePrincipal')
        {
            $OrganizationName = Get-M365DSCTenantDomain -ApplicationId $ApplicationId `
                -TenantId $TenantId `
                -CertificateThumbprint $CertificateThumbprint
        }
        else
        {
            $OrganizationName = $GlobalAdminAccount.UserName.Split('@')[1]
        }
        $Params = @{
            GlobalAdminAccount    = $GlobalAdminAccount
            Organization          = $OrganizationName
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            CertificatePassword   = $CertificatePassword
            CertificatePath       = $CertificatePath
        }
        $Results = Get-TargetResource @Params
        $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
        $dscContent = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -GlobalAdminAccount $GlobalAdminAccount
        Write-Host $Global:M365DSCEmojiGreenCheckMark
        return $dscContent
    }
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
        return ""
    }
}

Export-ModuleMember -Function *-TargetResource

