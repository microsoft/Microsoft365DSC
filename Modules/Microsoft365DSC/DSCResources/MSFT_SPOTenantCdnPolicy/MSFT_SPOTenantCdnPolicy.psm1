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
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Getting configuration for SPOTenantCdnPolicy {$CDNType}"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'PNP' -InboundParameters $PSBoundParameters

    try
    {
        $Policies = Get-PnPTenantCdnPolicies -CDNType $CDNType -ErrorAction Stop

        return @{
            CDNType                              = $CDNType
            ExcludeRestrictedSiteClassifications = $Policies["ExcludeRestrictedSiteClassifications"].Split(',')
            IncludeFileExtensions                = $Policies["IncludeFileExtensions"].Split(',')
            GlobalAdminAccount                   = $GlobalAdminAccount
            ApplicationId                        = $ApplicationId
            TenantId                             = $TenantId
            CertificatePassword                  = $CertificatePassword
            CertificatePath                      = $CertificatePath
            CertificateThumbprint                = $CertificateThumbprint
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
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Setting configuration for SPOTenantCDNPolicy {$CDNType}"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion


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
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
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
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    $InformationPreference = 'Continue'
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    $ConnectionMode = New-M365DSCConnection -Platform 'PNP' -InboundParameters $PSBoundParameters
    if ($null -ne $TenantId)
    {
        $organization = Get-M365DSCTenantDomain -ApplicationId $ApplicationId -TenantId $TenantId `
        -CertificateThumbprint $CertificateThumbprint -CertificatePath $CertificatePath
        $principal = $organization.Split(".")[0]
    }

    $params = @{
        CdnType               = 'Public'
        ApplicationId         = $ApplicationId
        TenantId              = $TenantId
        CertificatePassword   = $CertificatePassword
        CertificatePath       = $CertificatePath
        CertificateThumbprint = $CertificateThumbprint
        GlobalAdminAccount    = $GlobalAdminAccount
    }

    $result = Get-TargetResource @params
    $content = ""
    if ($null -ne $result)
    {
        if ($ConnectionMode -eq 'Credential')
        {
            $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        }
        else
        {
            if ($null -ne $CertificatePassword)
            {
                $result.CertificatePassword = Resolve-Credentials -UserName "CertificatePassword"
            }
        }

        $result = Remove-NullEntriesFromHashTable -Hash $result
        $content += "        SPOTenantCDNPolicy " + (New-Guid).ToString() + "`r`n"
        $content += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        if ($ConnectionMode -eq 'Credential')
        {
            $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        }
        else
        {
            if ($null -ne $CertificatePassword)
            {
                $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "CertificatePassword"
            }
            else
            {
                $content += $currentDSCBlock
            }
            $content = Format-M365ServicePrincipalData -configContent $content -applicationid $ApplicationId `
                -principal $principal -CertificateThumbprint $CertificateThumbprint
        }
        $content += "        }`r`n"
    }

    $params = @{
        CdnType               = 'Private'
        ApplicationId         = $ApplicationId
        TenantId              = $TenantId
        CertificatePassword   = $CertificatePassword
        CertificatePath       = $CertificatePath
        CertificateThumbprint = $CertificateThumbprint
        GlobalAdminAccount    = $GlobalAdminAccount
    }
    $result = Get-TargetResource @params
    if ($null -ne $result)
    {
        if ($ConnectionMode -eq 'Credential')
        {
            $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        }
        else
        {
            if ($null -ne $CertificatePassword)
            {
                $result.CertificatePassword = Resolve-Credentials -UserName "CertificatePassword"
            }
        }

        $content += "        SPOTenantCDNPolicy " + (New-Guid).ToString() + "`r`n"
        $content += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        if ($ConnectionMode -eq 'Credential')
        {
            $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        }
        else
        {
            if ($null -ne $CertificatePassword)
            {
                $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "CertificatePassword"
            }
            else
            {
                $content += $currentDSCBlock
            }
            $content = Format-M365ServicePrincipalData -configContent $content -applicationid $ApplicationId `
                -principal $principal -CertificateThumbprint $CertificateThumbprint
        }
        $content += "        }`r`n"
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
