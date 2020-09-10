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

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of SharePoint Online Access Control Settings"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform PnP
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
        GlobalAdminAccount           = $null
    }

    try
    {
        $SPOAccessControlSettings = Get-PNPTenant

        return @{
            IsSingleInstance             = 'Yes'
            DisplayStartASiteOption      = $SPOAccessControlSettings.DisplayStartASiteOption
            StartASiteFormUrl            = $SPOAccessControlSettings.StartASiteFormUrl
            IPAddressEnforcement         = $SPOAccessControlSettings.IPAddressEnforcement
            IPAddressAllowList           = $SPOAccessControlSettings.IPAddressAllowList
            IPAddressWACTokenLifetime    = $SPOAccessControlSettings.IPAddressWACTokenLifetime
            CommentsOnSitePagesDisabled  = $SPOAccessControlSettings.CommentsOnSitePagesDisabled
            SocialBarOnSitePagesDisabled = $SPOAccessControlSettings.SocialBarOnSitePagesDisabled
            DisallowInfectedFileDownload = $SPOAccessControlSettings.DisallowInfectedFileDownload
            ExternalServicesEnabled      = $SPOAccessControlSettings.ExternalServicesEnabled
            EmailAttestationRequired     = $SPOAccessControlSettings.EmailAttestationRequired
            EmailAttestationReAuthDays   = $SPOAccessControlSettings.EmailAttestationReAuthDays
            GlobalAdminAccount           = $GlobalAdminAccount
        }
    }
    catch
    {
        if ($error[0].Exception.Message -like "No connection available")
        {
            Write-Verbose -Message "Make sure that you are connected to your SPOService"
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

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of SharePoint Online Access Control Settings"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform PnP

    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("GlobalAdminAccount")
    $CurrentParameters.Remove("IsSingleInstance")

    if ($IPAddressAllowList -eq "")
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

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of SharePoint Online Access Control Settings"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-Microsoft365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @("IsSingleInstance", `
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
            "EmailAttestationReAuthDays")

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

    $params = @{
        IsSingleInstance   = 'Yes'
        GlobalAdminAccount = $GlobalAdminAccount
    }
    $result = Get-TargetResource @params
    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
    $content = "        SPOAccessControlSettings " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
