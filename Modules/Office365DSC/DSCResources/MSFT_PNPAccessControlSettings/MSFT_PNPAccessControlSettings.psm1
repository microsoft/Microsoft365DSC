function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (

        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $DisplayStartASiteOption,

        [Parameter()]
        [System.String]
        $StartASiteFormUrl,

        [Parameter()]
        [System.Boolean]
        $IPAddressEnforcement,

        [Parameter()]
        [System.String]
        $IPAddressAllowList,

        [Parameter()]
        [System.UInt32]
        $IPAddressWACTokenLifetime,

        [Parameter()]
        [System.Boolean]
        $CommentsOnSitePagesDisabled,

        [Parameter()]
        [System.Boolean]
        $SocialBarOnSitePagesDisabled,

        [Parameter()]
        [System.Boolean]
        $DisallowInfectedFileDownload,

        [Parameter()]
        [System.boolean]
        $ExternalServicesEnabled,

        [Parameter()]
        [System.Boolean]
        $EmailAttestationRequired,

        [Parameter()]
        [System.UInt32]
        $EmailAttestationReAuthDays,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    
    Test-PnPOnlineConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount

    $nullReturn = @{
        IsSingleInstance             = 'Yes'
        DisplayStartASiteOption      = $null
        StartASiteFormUrl            = $null
        IPAddressEnforcement         = $null
        IPAddressAllowList           = $null
        IPAddressWACTokenLifetime    = $null
        CommentsOnSitePagesDisabled  = $null
        SocialBarOnSitePagesDisabled = $null
        DisallowInfectedFileDownload = $null
        ExternalServicesEnabled      = $null
        EmailAttestationRequired     = $null
        EmailAttestationReAuthDays   = $null
    }

    try
    {
        $PNPAccessControlSettings = Get-PNPTenant

        return @{
            IsSingleInstance             = 'Yes'
            DisplayStartASiteOption      = $PNPAccessControlSettings.DisplayStartASiteOption
            StartASiteFormUrl            = $PNPAccessControlSettings.StartASiteFormUrl
            IPAddressEnforcement         = $PNPAccessControlSettings.IPAddressEnforcement
            IPAddressAllowList           = $PNPAccessControlSettings.IPAddressAllowList
            IPAddressWACTokenLifetime    = $PNPAccessControlSettings.IPAddressWACTokenLifetime
            CommentsOnSitePagesDisabled  = $PNPAccessControlSettings.CommentsOnSitePagesDisabled
            SocialBarOnSitePagesDisabled = $PNPAccessControlSettings.SocialBarOnSitePagesDisabled
            DisallowInfectedFileDownload = $PNPAccessControlSettings.DisallowInfectedFileDownload
            ExternalServicesEnabled      = $PNPAccessControlSettings.ExternalServicesEnabled
            EmailAttestationRequired     = $PNPAccessControlSettings.EmailAttestationRequired
            EmailAttestationReAuthDays   = $PNPAccessControlSettings.EmailAttestationReAuthDays
        }
    }
    catch
    {
        if ($error[0].Exception.Message -like "No connection available")
        {
            Write-Verbose "Make sure that you are connected to your PNPService"
        }
        return $nullReturn
    }

}
function Set-TargetResource
{
    [CmdletBinding()]
    param (

        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $DisplayStartASiteOption,

        [Parameter()]
        [System.String]
        $StartASiteFormUrl,

        [Parameter()]
        [System.Boolean]
        $IPAddressEnforcement,

        [Parameter()]
        [System.String]
        $IPAddressAllowList,

        [Parameter()]
        [System.UInt32]
        $IPAddressWACTokenLifetime,

        [Parameter()]
        [System.Boolean]
        $CommentsOnSitePagesDisabled,

        [Parameter()]
        [System.Boolean]
        $SocialBarOnSitePagesDisabled,

        [Parameter()]
        [System.Boolean]
        $DisallowInfectedFileDownload,

        [Parameter()]
        [System.boolean]
        $ExternalServicesEnabled,

        [Parameter()]
        [System.Boolean]
        $EmailAttestationRequired,

        [Parameter()]
        [System.UInt32]
        $EmailAttestationReAuthDays,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Test-PnPOnlineConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount

    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("CentralAdminUrl")
    $CurrentParameters.Remove("GlobalAdminAccount")
    $CurrentParameters.Remove("Verbose")
    $CurrentParameters.Remove("IsSingleInstance")

    if($IPAddressAllowList -eq "")
    {
        Write-Verbose -Message "The IPAddressAllowList is not configured, for that the IPAddressEnforcement parameter can not be set and will be removed"
        $CurrentParameters.Remove("IPAddressEnforcement")
        $CurrentParameters.Remove("IPAddressAllowList")
    }
    $tenant = Set-PnPTenant @CurrentParameters
}
function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param (

        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $DisplayStartASiteOption,

        [Parameter()]
        [System.String]
        $StartASiteFormUrl,

        [Parameter()]
        [System.Boolean]
        $IPAddressEnforcement,

        [Parameter()]
        [System.String]
        $IPAddressAllowList,

        [Parameter()]
        [System.UInt32]
        $IPAddressWACTokenLifetime,

        [Parameter()]
        [System.Boolean]
        $CommentsOnSitePagesDisabled,

        [Parameter()]
        [System.Boolean]
        $SocialBarOnSitePagesDisabled,

        [Parameter()]
        [System.Boolean]
        $DisallowInfectedFileDownload,

        [Parameter()]
        [System.boolean]
        $ExternalServicesEnabled,

        [Parameter()]
        [System.Boolean]
        $EmailAttestationRequired,

        [Parameter()]
        [System.UInt32]
        $EmailAttestationReAuthDays,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    Test-PnPOnlineConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount

    Write-Verbose -Message "Testing PnP Tenant"
    $CurrentValues = Get-TargetResource @PSBoundParameters
    return Test-Office365DSCParameterState -CurrentValues $CurrentValues `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @("IsSingleInstance", `
            "CentralAdminUrl", `
            "GlobalAdminAccount", `
            "DisplayStartASiteOption", `
            "StartASiteFormUrl", `
            "IPAddressEnforcement", `
            "IPAddressAllowList", `
            "IPAddressWACTokenLifetime", `
            "CommentsOnSitePagesDisabled", `
            "SocialBarOnSitePagesDisabled", `
            "DisallowInfectedFileDownload", `
            "ExternalServicesEnabled", `
            "EmailAttestationRequired", `
            "EmailAttestationReAuthDays"
    )
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $DisplayStartASiteOption,

        [Parameter()]
        [System.String]
        $StartASiteFormUrl,

        [Parameter()]
        [System.Boolean]
        $IPAddressEnforcement,

        [Parameter()]
        [System.String]
        $IPAddressAllowList,

        [Parameter()]
        [System.UInt32]
        $IPAddressWACTokenLifetime,

        [Parameter()]
        [System.Boolean]
        $CommentsOnSitePagesDisabled,

        [Parameter()]
        [System.Boolean]
        $SocialBarOnSitePagesDisabled,

        [Parameter()]
        [System.Boolean]
        $DisallowInfectedFileDownload,

        [Parameter()]
        [System.boolean]
        $ExternalServicesEnabled,

        [Parameter()]
        [System.Boolean]
        $EmailAttestationRequired,

        [Parameter()]
        [System.UInt32]
        $EmailAttestationReAuthDays,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    Test-PnPOnlineConnection -GlobalAdminAccount $GlobalAdminAccount -SPOCentralAdminUrl $CentralAdminUrl

    $result = Get-TargetResource @PSBoundParameters
    $content = "PNPAccessControlSettings " + (New-GUID).ToString() + "`r`n"
    $content += "{`r`n"
    $content += Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += "}`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
