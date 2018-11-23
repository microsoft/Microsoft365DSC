function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Url,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Owner,

	    [Parameter(Mandatory = $true)]
        [System.UInt32]
        $StorageQuota,

        [Parameter()]
        [System.String]
        $Title,

        [Parameter()]
        [System.UInt32]
        $CompatibilityLevel,

        [Parameter()]
        [System.UInt32]
        $LocaleId,

        [Parameter()]
        [System.Double]
        $ResourceQuota,

        [Parameter()]
        [System.String]
        $Template,

        [Parameter()]
        [System.UInt32]
        $TimeZoneId,

	    [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )

    Test-SPOServiceConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount
    
    $nullReturn = @{
	    Url = $null
        Owner = $null
        #TimeZoneId = $null
        LocaleId = $null
        Template = $null
        ResourceQuota = $null
        StorageQuota = $null
        CompatibilityLevel = $null
        Title = $null
    }

    try {        
        Write-Verbose -Message "Getting site collection $Url"
        $site = Get-SPOSite $Url
        return @{
            Url = $site.Url
            Owner = $site.Owner
            #TimeZoneId = $site.TimeZoneId
            LocaleId = $site.LocaleId
            Template = $site.Template
            ResourceQuota = $site.ResourceQuota
            StorageQuota = $site.StorageQuota
            CompatibilityLevel = $site.CompatibilityLevel
            Title = $site.Title
        }
    }
    catch {
        Write-Verbose "The specified Site Collection doesn't already exist."
        return $nullReturn        
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Url,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Owner,

	    [Parameter(Mandatory = $true)]
        [System.UInt32]
        $StorageQuota,

        [Parameter()]
        [System.String]
        $Title,

        [Parameter()]
        [System.UInt32]
        $CompatibilityLevel,

        [Parameter()]
        [System.UInt32]
        $LocaleId,

        [Parameter()]
        [System.Double]
        $ResourceQuota,

        [Parameter()]
        [System.String]
        $Template,

        [Parameter()]
        [System.UInt32]
        $TimeZoneId,

	    [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )

    Test-SPOServiceConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount

    Write-Verbose -Message "Setting site collection $Url"
    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("CentralAdminUrl")
    $CurrentParameters.Remove("GlobalAdminAccount")

    $site = New-SPOSite @CurrentParameters
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Url,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Owner,

	    [Parameter(Mandatory = $true)]
        [System.UInt32]
        $StorageQuota,

        [Parameter()]
        [System.String]
        $Title,

        [Parameter()]
        [System.UInt32]
        $CompatibilityLevel,

        [Parameter()]
        [System.UInt32]
        $LocaleId,

        [Parameter()]
        [System.Double]
        $ResourceQuota,

        [Parameter()]
        [System.String]
        $Template,

        [Parameter()]
        [System.UInt32]
        $TimeZoneId,

	    [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing site collection $Url"
    $CurrentValues = Get-TargetResource @PSBoundParameters
    return Test-Office365DSCParameterState -CurrentValues $CurrentValues `
                                           -DesiredValues $PSBoundParameters `
                                           -ValuesToCheck @("Url")
}

Export-ModuleMember -Function *-TargetResource
