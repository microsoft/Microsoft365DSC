function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet("Yes")]
        [String]
        $IsSingleInstance,

        [Parameter()]
        [System.String]
        $LibraryUrl,

        [Parameter()]
        [System.String]
        $ThumbnailUrl,

        [Parameter()]
        [ValidateSet('Public', 'Private')]
        [System.String]
        $CdnType,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount

    )

    Write-Verbose -Message "Getting configuration of SPO Org Assets Library"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform PnP

    try
    {
        $orgAssets = Get-PnPOrgAssetsLibrary -ErrorAction SilentlyContinue
    }
    catch
    {
        Write-Verbose -Message $_
    }

    $cdn = $null
    if ((Get-PnPTenantCdnEnabled -cdnType $CdnType) -and $CdnType -eq 'Public')
    {
        $cdn = "Public"
    }

    if ((Get-PnPTenantCdnEnabled -cdnType $CdnType) -and $CdnType -eq 'Private')
    {
        $cdn = "Private"
    }

    if ($null -eq $orgAssets)
    {
        $currentValues = $PSBoundParameters
        $currentValues.Ensure = "Absent"
        return $currentValues
    }
    else
    {
        Write-Verbose -Message "Found existing SharePoint Org Site Assets"
        Get-SPOAdministrationUrl -GlobalAdminAccount $GlobalAdminAccount | out-null

        $result = @{
            IsSingleInstance   = $IsSingleInstance
            LibraryUrl         = "https://$global:tenantName.sharepoint.com/$($orgAssets.OrgAssetsLibraries.libraryurl.DecodedUrl)"
            ThumbnailUrl       = "https://$global:tenantName.sharepoint.com/$($orgAssets.OrgAssetsLibraries.ThumbnailUrl.DecodedUrl)"
            CdnType            = $cdn
            Ensure             = "Present"
            GlobalAdminAccount = $GlobalAdminAccount
        }
        Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
        return $result
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet("Yes")]
        [String]
        $IsSingleInstance,

        [Parameter()]
        [System.String]
        $LibraryUrl,

        [Parameter()]
        [System.String]
        $ThumbnailUrl,

        [Parameter()]
        [ValidateSet('Public', 'Private')]
        [System.String]
        $CdnType,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount

    )

    Write-Verbose -Message "Setting configuration of SharePoint Org Site Assets"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentOrgSiteAsset = Get-TargetResource @PSBoundParameters
    $currentParameters = $PSBoundParameters
    $currentParameters.Remove("IsSingleInstance")
    $currentParameters.Remove("Ensure")
    $currentParameters.Remove("GlobalAdminAccount")

    if ($Ensure -eq 'Present' -and $currentOrgSiteAsset.Ensure -eq 'Present')
    {
        Remove-PNPOrgAssetsLibrary -libraryUrl $currentOrgSiteAsset.LibraryUrl
        Add-PnPOrgAssetsLibrary @currentParameters
    }
    elseif ($Ensure -eq 'Present' -and $currentOrgSiteAsset.Ensure -eq 'Absent')
    {
        Add-PnPOrgAssetsLibrary @currentParameters
    }
    elseif ($Ensure -eq 'Absent' -and $currentOrgSiteAsset.Ensure -eq 'Present')
    {
        Remove-PNPOrgAssetsLibrary -libraryUrl $currentOrgSiteAsset.LibraryUrl
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet("Yes")]
        [String]
        $IsSingleInstance,

        [Parameter()]
        [System.String]
        $LibraryUrl,

        [Parameter()]
        [System.String]
        $ThumbnailUrl,

        [Parameter()]
        [ValidateSet('Public', 'Private')]
        [System.String]
        $CdnType,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount

    )

    Write-Verbose -Message "Testing configuration of SharePoint Org Site Assets"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    Write-Verbose -Message "Starting the test to compare"
    Write-Verbose -Message "Target Values: `n $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

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

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
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

    $Params = @{
        IsSingleInstance   = 'Yes'
        GlobalAdminAccount = $GlobalAdminAccount
    }
    $result = Get-TargetResource @Params
    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
    $content = "        SPOOrgAssetsLibrary " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
