function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $LibraryUrl,

        [Parameter()]
        [System.String]
        $ThumbnailUrl,

        [Parameter()]
        [ValidateSet('Public', 'Private')]
        [System.String]
        $CdnType = 'Public',

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
    if ($CdnType -eq 'Public')
    {
        if (Get-PnPTenantCdnEnabled -cdnType $CdnType)
        {
            $cdn = "Public"
        }
    }

    if ($CdnType -eq 'Private')
    {
        if (Get-PnPTenantCdnEnabled -cdnType $CdnType)
        {
            $cdn = "Private"
        }
    }

    if ($null -eq $orgAssets)
    {
        $currentValues = $PSBoundParameters
        $currentValues.Ensure = "Absent"
        return $currentValues
    }
    else
    {
        $tenantName = Get-M365TenantName -GlobalAdminAccount $GlobalAdminAccount

        foreach ($orgAsset in $orgAssets.OrgAssetsLibraries)
        {
            $orgLibraryUrl = "https://$tenantName.sharepoint.com/$($orgAsset.libraryurl.DecodedUrl)"

            if ($orgLibraryUrl -eq $LibraryUrl)
            {
                Write-Verbose -Message "Found existing SharePoint Org Site Assets for $LibraryUrl"
                if ($null -ne $orgAsset.ThumbnailUrl.DecodedUrl)
                {
                    $orgthumbnailUrl = "https://$tenantName.sharepoint.com/$($orgAsset.LibraryUrl.decodedurl.Substring(0,$orgAsset.LibraryUrl.decodedurl.LastIndexOf("/")))/$($orgAsset.ThumbnailUrl.decodedurl)"
                }

                $result = @{
                    LibraryUrl         = $orgLibraryUrl
                    ThumbnailUrl       = $orgthumbnailUrl
                    CdnType            = $cdn
                    Ensure             = "Present"
                    GlobalAdminAccount = $GlobalAdminAccount
                }
                Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
                return $result
            }
        }
        $currentValues = $PSBoundParameters
        $currentValues.Ensure = "Absent"
        return $currentValues
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $LibraryUrl,

        [Parameter()]
        [System.String]
        $ThumbnailUrl,

        [Parameter()]
        [ValidateSet('Public', 'Private')]
        [System.String]
        $CdnType = 'Public',

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
    $currentParameters.Remove("Ensure")
    $currentParameters.Remove("GlobalAdminAccount")

    $cdn = $null
    if ($CdnType -eq 'Public')
    {
        if (Get-PnPTenantCdnEnabled -cdnType $CdnType)
        {
            $cdn = "Public"
        }
    }

    if ($CdnType -eq 'Private')
    {
        if (Get-PnPTenantCdnEnabled -cdnType $CdnType)
        {
            $cdn = "Private"
        }
    }


    if ($null -eq $cdn)
    {
        throw "Tenant $CdnType CDN must be configured before setting site organization Library"
    }


    if ($Ensure -eq 'Present' -and $currentOrgSiteAsset.Ensure -eq 'Present')
    {
        ## No set so remove / add
        Remove-PNPOrgAssetsLibrary -libraryUrl $currentOrgSiteAsset.LibraryUrl
        ### add slight delay fails if you immediately try to add 
        Start-Sleep -Seconds 30
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
        [System.String]
        $LibraryUrl,

        [Parameter()]
        [System.String]
        $ThumbnailUrl,

        [Parameter()]
        [ValidateSet('Public', 'Private')]
        [System.String]
        $CdnType = 'Public',

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

    $orgAssets = Get-PnPOrgAssetsLibrary
    $tenantName = Get-M365TenantName -GlobalAdminAccount $GlobalAdminAccount
    $content = ''

    if ($null -ne $orgAssets)
    {
        foreach ($orgAssetLib in $orgAssets.OrgAssetsLibraries)
        {
            $Params = @{
                GlobalAdminAccount = $GlobalAdminAccount
                LibraryUrl         = "https://$tenantName.sharepoint.com/$($orgAssetLib.libraryurl.DecodedUrl)"
            }
            $result = Get-TargetResource @Params
            $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
            $content += "        SPOOrgAssetsLibrary " + (New-GUID).ToString() + "`r`n"
            $content += "        {`r`n"
            $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
            $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
            $content += "        }`r`n"
        }
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
