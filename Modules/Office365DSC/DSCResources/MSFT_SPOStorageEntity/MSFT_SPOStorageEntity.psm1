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
        EntityScope        = $EntityScope
        Description        = $Description
        Comment            = $Comment
        Ensure             = "Absent"
        SiteUrl            = $SiteUrl
        GlobalAdminAccount = $GlobalAdminAccount
    }

    Write-Verbose -Message "Getting storage entity $Key"

    $storageEntity = Get-PnPStorageEntity -Key $Key -ErrorAction SilentlyContinue
    if ($null -eq $storageEntity)
    {
        Write-Verbose -Message "No storage entity found for $Key"
        return $nullReturn
    }

    return @{
        Key                = $storageEntity.Key
        Value              = $storageEntity.Value
        EntityScope        = $EntityScope
        Description        = $storageEntity.Description
        Comment            = $storageEntity.Comment
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
    $CurrentParameters.Add("Scope",$EntityScope)

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
