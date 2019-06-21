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
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of Mailtips for $Organization"

    $nullReturn = @{
        Organization = $Organization
        MailTipsAllTipsEnabled = $null
        MailTipsGroupMetricsEnabled = $null
        MailTipsLargeAudienceThreshold = $null
        MailTipsMailboxSourcedTipsEnabled = $null
        MailTipsExternalRecipientsTipsEnabled = $null
        Ensure = "Absent"
        GlobalAdminAccount = $null
    }

    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount

    $OrgConfig = Get-OrganizationConfig

    if ($null -eq $OrgConfig)
    {
        Write-Verbose -Message "Can't find the information about the Organization Configuration."
        return $nullReturn
    }

    $result = @{
        Organization = $Organization
        MailTipsAllTipsEnabled = $OrgConfig.MailTipsAllTipsEnabled
        MailTipsGroupMetricsEnabled = $OrgConfig.MailTipsGroupMetricsEnabled
        MailTipsLargeAudienceThreshold = $OrgConfig.MailTipsLargeAudienceThreshold
        MailTipsMailboxSourcedTipsEnabled = $OrgConfig.MailTipsMailboxSourcedTipsEnabled
        MailTipsExternalRecipientsTipsEnabled = $OrgConfig.MailTipsExternalRecipientsTipsEnabled
        Ensure = "Present"
        GlobalAdminAccount = $GlobalAdminAccount
    }

    Write-Verbose -Message "Found configuration of the Mailtips for $($Organization)"
    return $result
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
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of Mailtips for $Organization"

    $OrgConfig = Get-TargetResource @PSBoundParameters

    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount

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
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of Mailtips for $Organization"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-O365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-O365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
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
        [Parameter(Mandatory = $true)]
        [System.String]
        $Organization,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $result = Get-TargetResource @PSBoundParameters
    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
    $content = "        EXOMailTips " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource

