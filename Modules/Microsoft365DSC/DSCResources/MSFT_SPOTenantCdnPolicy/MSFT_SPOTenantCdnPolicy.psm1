function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Private', 'Public')]
        [System.String]
        $CDNType,

        [Parameter()]
        [System.String[]]
        $ExcludeRestrictedSiteClassifications,

        [Parameter()]
        [System.String[]]
        $IncludeFileExtensions,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration for SPOTenantCdnPolicy {$CDNType}"
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
        $Policies = Get-PnPTenantCdnPolicies -CDNType $CDNType -ErrorAction Stop

        return @{
            CDNType                              = $CDNType
            ExcludeRestrictedSiteClassifications = $Policies["ExcludeRestrictedSiteClassifications"].Split(',')
            IncludeFileExtensions                = $Policies["IncludeFileExtensions"].Split(',')
            GlobalAdminAccount                   = $GlobalAdminAccount
        }
    }
    catch
    {
        return $null
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Private', 'Public')]
        [System.String]
        $CDNType,

        [Parameter()]
        [System.String[]]
        $ExcludeRestrictedSiteClassifications,

        [Parameter()]
        [System.String[]]
        $IncludeFileExtensions,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration for SPOTenantCDNPolicy {$CDNType}"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform PnP

    $curPolicies = Get-TargetResource @PSBoundParameters

    if ($null -ne `
        (Compare-Object -ReferenceObject $curPolicies.IncludeFileExtensions -DifferenceObject $IncludeFileExtensions))
    {
        Write-Verbose "Found difference in IncludeFileExtensions"

        $stringValue = ""
        foreach ($entry in $IncludeFileExtensions.Split(','))
        {
            $stringValue += $entry + ","
        }
        $stringValue = $stringValue.Remove($stringValue.Length - 1, 1)
        Set-PnPTenantCdnPolicy -CDNType $CDNType `
            -PolicyType 'IncludeFileExtensions' `
            -PolicyValue $stringValue
    }

    if ($null -ne (Compare-Object -ReferenceObject $curPolicies.ExcludeRestrictedSiteClassifications `
                -DifferenceObject $ExcludeRestrictedSiteClassifications))
    {
        Write-Verbose "Found difference in ExcludeRestrictedSiteClassifications"


        Set-PnPTenantCdnPolicy -CDNType $CDNType `
            -PolicyType 'ExcludeRestrictedSiteClassifications' `
            -PolicyValue $stringValue
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Private', 'Public')]
        [System.String]
        $CDNType,

        [Parameter()]
        [System.String[]]
        $ExcludeRestrictedSiteClassifications,

        [Parameter()]
        [System.String[]]
        $IncludeFileExtensions,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration for SPO Storage Entity for $Key"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-Microsoft365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @("CDNType", `
            "ExcludeRestrictedSiteClassifications", `
            "IncludeFileExtensions")

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

    $params = @{
        CDNType            = 'Public'
        GlobalAdminAccount = $GlobalAdminAccount
    }
    $result = Get-TargetResource @params
    $content = ""
    if ($null -ne $result)
    {
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content += "        SPOTenantCDNPolicy " + (New-Guid).ToString() + "`r`n"
        $content += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        $content += "        }`r`n"
    }


    $params = @{
        CDNType            = 'Private'
        GlobalAdminAccount = $GlobalAdminAccount
    }
    $result = Get-TargetResource @params
    if ($null -ne $result)
    {
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content += "        SPOTenantCDNPolicy " + (New-Guid).ToString() + "`r`n"
        $content += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        $content += "        }`r`n"
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
