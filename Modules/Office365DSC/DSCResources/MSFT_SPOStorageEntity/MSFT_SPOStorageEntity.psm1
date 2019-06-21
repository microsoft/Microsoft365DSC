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

    Write-Verbose -Message "Getting configuration for SPO Storage Entity for $Key"

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

    $entityStorageParms = @{}
    $entityStorageParms.Add("Key", $Key)
    $entityStorageParms.Add("Scope", $EntityScope)

    $Entity = Get-PnPStorageEntity @entityStorageParms -ErrorAction SilentlyContinue
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

    Write-Verbose -Message "Setting configuration for SPO Storage Entity for $Key"

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
    elseif ($Ensure -eq "Present")
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

    Write-Verbose -Message "Testing configuration for SPO Storage Entity for $Key"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-O365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-O365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
                                                  -DesiredValues $PSBoundParameters `
                                                  -ValuesToCheck @("Key", `
                                                                   "Value", `
                                                                   "Key", `
                                                                   "Comment", `
                                                                   "Description", `
                                                                   "EntityScope", `
                                                                   "Ensure")

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
    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
    $content = "        SPOStorageEntity " + (New-Guid).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
