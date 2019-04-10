function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Key,

        [Parameter()]
        [System.String]
        $Value,

        [Parameter()]
        [ValidateSet("Tenant", "Site")]
        [System.String]
        $EntityScope,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.String]
        $SiteUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Test-PnPOnlineConnection -SiteUrl $SiteUrl -GlobalAdminAccount $GlobalAdminAccount

    $nullReturn = @{
        Key                = $Key
        Value              = $Value
        EntityScope        = $null
        Description        = $Description
        Comment            = $Comment
        Ensure             = "Absent"
        SiteUrl            = $SiteUrl
        GlobalAdminAccount = $GlobalAdminAccount
    }

    Write-Verbose -Message "Getting storage entity $Key"

    $Entity = Get-PnPStorageEntity -Key $Key -ErrorAction SilentlyContinue
    ## Get-PnPStorageEntity seems to not return $null when not found
    ## so checking key
    if ($null -eq $Entity.Key)
    {
        Write-Verbose -Message "No storage entity found for $Key"
        return $nullReturn
    }

    Write-Verbose -Message "Found storage entity $($Entity.Key)"

    return @{
        Key                = $Entity.Key
        Value              = $Entity.Value
        EntityScope        = $EntityScope
        Description        = $Entity.Description
        Comment            = $Entity.Comment
        Ensure             = "Present"
        SiteUrl            = $SiteUrl
        GlobalAdminAccount = $GlobalAdminAccount
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Key,

        [Parameter()]
        [System.String]
        $Value,

        [Parameter()]
        [ValidateSet("Tenant", "Site")]
        [System.String]
        $EntityScope,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.String]
        $SiteUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Test-PnPOnlineConnection -SiteUrl $SiteUrl -GlobalAdminAccount $GlobalAdminAccount
    $curStorageEntry = Get-TargetResource @PSBoundParameters

    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("SiteUrl")
    $CurrentParameters.Remove("GlobalAdminAccount")
    $CurrentParameters.Remove("Ensure")
    $CurrentParameters.Remove("EntityScope")
    $CurrentParameters.Add("Scope", $EntityScope)

    if (($Ensure -eq "Absent" -and $curStorageEntry.Ensure -eq "Present"))
    {
        Write-Verbose -Message "Removing storage entity $Key"
        Remove-PnPStorageEntity -Key $Key
    }
    else
    {
        Write-Verbose -Message "Adding new storage entity $Key"
        Set-PnPStorageEntity @CurrentParameters
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
        $Key,

        [Parameter()]
        [System.String]
        $Value,

        [Parameter()]
        [ValidateSet("Tenant", "Site")]
        [System.String]
        $EntityScope,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.String]
        $SiteUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing SPOStorageEntity for $Key"
    $CurrentValues = Get-TargetResource @PSBoundParameters

    return Test-Office365DSCParameterState -CurrentValues $CurrentValues `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @("Key", `
            "Value", `
            "Key", `
            "Comment", `
            "Description", `
            "Ensure"
    )
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Key,

        [Parameter(Mandatory = $true)]
        [System.String]
        $SiteUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    Test-PnPOnlineConnection -SiteUrl $SiteUrl -GlobalAdminAccount $GlobalAdminAccount
    $result = Get-TargetResource @PSBoundParameters
    $result.GlobalAdminAccount = Resolve-Credentials -UserName $GlobalAdminAccount.UserName
    $content = "        SPOStorageEntity " + (New-Guid).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
