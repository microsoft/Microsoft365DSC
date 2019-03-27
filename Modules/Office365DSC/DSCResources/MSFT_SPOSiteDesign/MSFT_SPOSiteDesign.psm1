function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Title,

        [Parameter()]
        [System.String[]]
        $SiteScriptNames,

        [Parameter()]
        [ValidateSet("CommunicationSite", "TeamSite")]
        [System.String]
        $WebTemplate,

        [Parameter()]
        [System.Boolean]
        $isDefault,

        [Parameter()]
        [System.String]
        $PreviewImageAltText,

        [Parameter()]
        [System.String]
        $PreviewImageUrl,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.UInt32]
        $Version,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Test-PnPOnlineConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount

    $nullReturn = @{
        Title               = $Title
        SiteScriptNames     = $SiteScriptNames
        WebTemplate         = $WebTemplate
        isDefault           = $isDefault
        Description         = $Description
        PreviewImageAltText = $PreviewImageAltText
        PreviewImageUrl     = $PreviewImageUrl
        Version             = $Version
        Ensure              = "Absent"
        CentralAdminUrl     = $CentralAdminUrl
        GlobalAdminAccount  = $GlobalAdminAccount
    }

    Write-Verbose -Message "Getting Site Design for $Title"

    $siteDesign = Get-PnPSiteDesign -Identity $Title -ErrorAction SilentlyContinue
    if ($null -eq $siteDesign)
    {
        Write-Verbose -Message "No Site Design found for $Title"
        return $nullReturn
    }

    $scriptTitles = @()
    foreach ($scriptId in $siteDesign.SiteScriptIds)
    {
        $siteScript = Get-PnPSiteScript -Identity $scriptId
        $scriptTitles += $siteScript.Title
    }
    ## Todo need to see if we can get this PBP module instead of hard coded in scipt
    $webtemp = $null
    if ($siteDesign.WebTemplate -eq "64")
    {
        $webtemp = "TeamSite"
    }
    else
    {
        $webtemp = "CommunicationSite"
    }

    return @{
        Title               = $siteDesign.Title
        SiteScriptNames     = $scriptTitles
        WebTemplate         = $webtemp
        isDefault           = $siteDesign.isDefault
        Description         = $siteDesign.Description
        PreviewImageAltText = $siteDesign.PreviewImageAltText
        PreviewImageUrl     = $siteDesign.PreviewImageUrl
        Version             = $siteDesign.Version
        Ensure              = "Present"
        CentralAdminUrl     = $CentralAdminUrl
        GlobalAdminAccount  = $GlobalAdminAccount
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Title,

        [Parameter()]
        [ValidateSet("CommunicationSite", "TeamSite")]
        [System.String]
        $WebTemplate,

        [Parameter()]
        [System.String[]]
        $SiteScriptNames,

        [Parameter()]
        [System.Boolean]
        $isDefault,

        [Parameter()]
        [System.String]
        $PreviewImageAltText,

        [Parameter()]
        [System.String]
        $PreviewImageUrl,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.UInt32]
        $Version,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Test-PnPOnlineConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount

    $curSiteDesign = Get-TargetResource @PSBoundParameters

    # Get list of site script names
    $scriptIds = @()
    foreach ($siteScriptName in $SiteScriptNames)
    {
        $siteScript = Get-PnPSiteScript | Where-Object {$_.Title -eq $siteScriptName}
        $scriptIds += $siteScript.Id
    }

    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("CentralAdminUrl")
    $CurrentParameters.Remove("GlobalAdminAccount")
    $CurrentParameters.Remove("SiteScriptNames")
    $CurrentParameters.Remove("Ensure")
    $CurrentParameters.Add("SiteScriptIds", $scriptIds)

    if ($curSiteDesign.Ensure -eq "Absent")
    {
        $CurrentParameters.Remove("Version")
        Write-Verbose -Message "Adding new site design $Title"
        Add-PnPSiteDesign @CurrentParameters
    }
    ## Found current site design needs updated
    if ($curSiteDesign.Ensure -eq "Present" -and "Present" -eq $Ensure)
    {
        $siteDesign = Get-PnPSiteDesign -Identity $Title -ErrorAction SilentlyContinue
        if ($null -ne $siteDesign)
        {
            Write-Verbose -Message "Updating current site design $Title"
            Set-PnPSiteDesign  -Identity $siteDesign.Id  @CurrentParameters
        }
    }

    if ($Ensure -eq "Absent")
    {
        $siteDesign = Get-PnPSiteDesign -Identity $Title -ErrorAction SilentlyContinue
        if ($null -ne $siteDesign)
        {
            Write-Verbose -Message "Removing site design  $Title"
            Remove-PnPSiteDesign -Identity $siteDesign.Id  -Force
        }
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
        $Title,

        [Parameter()]
        [ValidateSet("CommunicationSite", "TeamSite")]
        [System.String]
        $WebTemplate,

        [Parameter()]
        [System.String[]]
        $SiteScriptNames,

        [Parameter()]
        [System.Boolean]
        $isDefault,

        [Parameter()]
        [System.String]
        $PreviewImageAltText,

        [Parameter()]
        [System.String]
        $PreviewImageUrl,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.UInt32]
        $Version,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing SPOSiteDesign for $SiteDesignTitle"
    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('CentralAdminUrl') | out-null
    $ValuesToCheck.Remove('GlobalAdminAccount') | out-null

    return Test-Office365DSCParameterState -CurrentValues $CurrentValues `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck  $ValuesToCheck.Keys
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Title,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    Test-PnPOnlineConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount
    $result = Get-TargetResource @PSBoundParameters
    $result.GlobalAdminAccount = Resolve-Credentials -UserName $GlobalAdminAccount.UserName
    $content = "        SPOSiteDesign " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
