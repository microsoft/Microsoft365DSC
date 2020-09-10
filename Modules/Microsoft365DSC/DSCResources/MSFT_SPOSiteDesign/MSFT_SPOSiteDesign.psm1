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
        $IsDefault,

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
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration for SPO SiteDesign for $Title"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform PnP
    $nullReturn = @{
        Title               = $Title
        SiteScriptNames     = $SiteScriptNames
        WebTemplate         = $WebTemplate
        IsDefault           = $IsDefault
        Description         = $Description
        PreviewImageAltText = $PreviewImageAltText
        PreviewImageUrl     = $PreviewImageUrl
        Version             = $Version
        Ensure              = "Absent"
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
        $siteScript = Get-PnPSiteScript -Identity $scriptId -ErrorAction SilentlyContinue

        if ($null -ne $siteScript)
        {
            $scriptTitles += $siteScript.Title
        }
    }
    ## Todo need to see if we can get this somehow from PNP module instead of hard coded in script
    ## https://github.com/SharePoint/PnP-PowerShell/blob/master/Commands/Enums/SiteWebTemplate.cs
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
        IsDefault           = $siteDesign.IsDefault
        Description         = $siteDesign.Description
        PreviewImageAltText = $siteDesign.PreviewImageAltText
        PreviewImageUrl     = $siteDesign.PreviewImageUrl
        Version             = $siteDesign.Version
        Ensure              = "Present"
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
        $IsDefault,

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
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration for SPO SiteDesign for $Title"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform PnP

    $curSiteDesign = Get-TargetResource @PSBoundParameters

    # Get list of site script names
    $scriptIds = @()
    foreach ($siteScriptName in $SiteScriptNames)
    {
        $siteScript = Get-PnPSiteScript | Where-Object -FilterScript { $_.Title -eq $siteScriptName }
        $scriptIds += $siteScript.Id
    }

    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("GlobalAdminAccount")
    $CurrentParameters.Remove("SiteScriptNames")
    $CurrentParameters.Remove("Ensure")
    $CurrentParameters.Add("SiteScriptIds", $scriptIds)

    if ($curSiteDesign.Ensure -eq "Absent" -and "Present" -eq $Ensure )
    {
        $CurrentParameters.Remove("Version")
        Write-Verbose -Message "Adding new site design $Title"
        Add-PnPSiteDesign @CurrentParameters
    }
    elseif (($curSiteDesign.Ensure -eq "Present" -and "Present" -eq $Ensure))
    {
        $siteDesign = Get-PnPSiteDesign -Identity $Title -ErrorAction SilentlyContinue
        if ($null -ne $siteDesign)
        {
            Write-Verbose -Message "Updating current site design $Title"
            Set-PnPSiteDesign -Identity $siteDesign.Id  @CurrentParameters
        }
    }
    elseif (($Ensure -eq "Absent" -and $curSiteDesign.Ensure -eq "Present"))
    {
        $siteDesign = Get-PnPSiteDesign -Identity $Title -ErrorAction SilentlyContinue
        if ($null -ne $siteDesign)
        {
            Write-Verbose -Message "Removing site design $Title"
            Remove-PnPSiteDesign -Identity $siteDesign.Id -Force
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
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration for SPO SiteDesign for $Title"

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
    $InformationPreference = 'Continue'
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform PnP

    $content = ''
    $i = 1

    [array]$designs = Get-PnPSiteDesign

    foreach ($design in $designs)
    {
        Write-Information "    [$i/$($designs.Length)] $($design.Title)"
        $params = @{
            Title              = $design.Title
            GlobalAdminAccount = $GlobalAdminAccount
        }
        $result = Get-TargetResource @params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content += "        SPOSiteDesign " + (New-GUID).ToString() + "`r`n"
        $content += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        $content += "        }`r`n"
        $i++
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
