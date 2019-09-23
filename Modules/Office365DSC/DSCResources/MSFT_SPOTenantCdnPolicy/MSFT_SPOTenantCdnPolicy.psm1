function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Private','Public')]
        [System.String]
        $CdnType,

        [Parameter()]
        [System.Boolean]
        $ExcludeIfNoScriptDisabled = $false,

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

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                      -Platform PnP

    $Policies = Get-PnPTenantCdnPolicies -CDNType $CDNType

    return @{
        CDNType                              = $CDNType
        ExcludeIfNoScriptDisabled            = [System.Boolean]$Policies["ExcludeIfNoScriptDisabled"]
        ExcludeRestrictedSiteClassifications = $Policies["ExcludeRestrictedSiteClassifications"].Split(',')
        IncludeFileExtensions                = $Policies["IncludeFileExtensions"].Split(',')
        GlobalAdminAccount                   = $GlobalAdminAccount
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Private','Public')]
        [System.String]
        $CdnType,

        [Parameter()]
        [System.Boolean]
        $ExcludeIfNoScriptDisabled = $false,

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

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                      -Platform PnP

    $curPolicies = Get-TargetResource @PSBoundParameters

    $setParams = @{
        CDNType = $CDNType
    }

    if ($null -ne  `
        (Compare-Object -ReferenceObject $curPolicies.IncludeFileExtensions -DifferenceObject $IncludeFileExtensions))
    {
        Write-Verbose "Found difference in IncludeFileExtensions"

        $stringValue = ""
        foreach ($entry in $IncludeFileExtensions.Split(','))
        {
            $stringValue += $entry + ","
        }
        $stringValue = $stringValue.Remove($stringValue.Length -1, 1)
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

    if ($ExcludeIfNoScriptDisabled -ne $curPolicies["ExcludeIfNoScriptDisabled"])
    {
        Write-Verbose "Found difference in ExcludeIfNoScriptDisabled"
        Set-PnPTenantCdnPolicy -CDNType $CDNType `
                               -PolicyType 'ExcludeIfNoScriptDisabled' `
                               -PolicyValue $ExcludeIfNoScriptDisabled.ToString()
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Private','Public')]
        [System.String]
        $CdnType,

        [Parameter()]
        [System.Boolean]
        $ExcludeIfNoScriptDisabled = $false,

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

    Write-Verbose -Message "Current Values: $(Convert-O365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-O365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
                                                  -DesiredValues $PSBoundParameters `
                                                  -ValuesToCheck @("CDNType", `
                                                                   "ExcludeIfNoScriptDisabled", `
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
    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                      -Platform PnP

    $params = @{
        CDNType            = 'Public'
        GlobalAdminAccount = $GlobalAdminAccount
    }
    $result = Get-TargetResource @params
    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
    $content = "        SPOTenantCDNPolicy " + (New-Guid).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"


    $params = @{
        CDNType            = 'Private'
        GlobalAdminAccount = $GlobalAdminAccount
    }
    $result = Get-TargetResource @params
    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
    $content += "        SPOTenantCDNPolicy " + (New-Guid).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
