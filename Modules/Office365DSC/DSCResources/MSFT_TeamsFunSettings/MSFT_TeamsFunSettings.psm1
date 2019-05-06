function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $TeamName,

        [Parameter()]
        [System.String]
        $AllowGiphy,

        [Parameter()]
        [ValidateSet("Strict", "Moderate")]
        [System.String]
        $GiphyContentRating,

        [Parameter()]
        [System.String]
        $AllowStickersAndMemes,

        [Parameter()]
        [System.String]
        $AllowCustomMemes,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Test-TeamsServiceConnection -GlobalAdminAccount $GlobalAdminAccount

    $nullReturn = @{
        TeamName              = $TeamName
        AllowGiphy            = $null
        GiphyContentRating    = $null
        AllowStickersAndMemes = $null
        AllowCustomMemes      = $null
        Ensure                = "Absent"
        GlobalAdminAccount    = $GlobalAdminAccount
    }

    Write-Verbose -Message "Getting Team fun settings for $TeamName"

    $team = Get-TeamByName $TeamName

    Write-Verbose -Message "Retrieve team GroupId: $($team.GroupId)"

    $teamFunSettings = Get-TeamFunSettings -GroupId $team.GroupId -ErrorAction SilentlyContinue
    if ($null -eq $teamFunSettings)
    {
        Write-Verbose "The specified Team doesn't exist."
        return $nullReturn
    }

    Write-Verbose "Team fun settings for AllowGiphy = $($teamFunSettings.AllowGiphy)"
    Write-Verbose "Team fun settings for GiphyContentRating = $($teamFunSettings.GiphyContentRating)"
    Write-Verbose "Team fun settings for AllowStickersAndMemes = $($teamFunSettings.AllowStickersAndMemes)"
    Write-Verbose "Team fun settings for AllowCustomMemes = $($teamFunSettings.AllowCustomMemes)"

    return @{
        TeamName              = $TeamName
        AllowGiphy            = $teamFunSettings.AllowGiphy
        GiphyContentRating    = $teamFunSettings.GiphyContentRating
        AllowStickersAndMemes = $teamFunSettings.AllowStickersAndMemes
        AllowCustomMemes      = $teamFunSettings.AllowCustomMemes
        Ensure                = "Present"
        GlobalAdminAccount    = $GlobalAdminAccount
    }

}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $TeamName,

        [Parameter()]
        [System.String]
        $AllowGiphy,

        [Parameter()]
        [ValidateSet("Strict", "Moderate")]
        [System.String]
        $GiphyContentRating,

        [Parameter()]
        [System.String]
        $AllowStickersAndMemes,

        [Parameter()]
        [System.String]
        $AllowCustomMemes,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    if ('Absent' -eq $Ensure)
    {
        throw "This resource cannot delete Managed Properties. Please make sure you set its Ensure value to Present."
    }

    Test-TeamsServiceConnection -GlobalAdminAccount $GlobalAdminAccount

    $team = Get-TeamByName $TeamName

    Write-Verbose -Message "Retrieve team GroupId: $($team.GroupId)"

    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("TeamName")
    $CurrentParameters.Add("GroupId", $team.GroupId)
    $CurrentParameters.Remove("GlobalAdminAccount")
    $CurrentParameters.Remove("Ensure")
    Set-TeamFunSettings @CurrentParameters
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $TeamName,

        [Parameter()]
        [System.String]
        $AllowGiphy,

        [Parameter()]
        [ValidateSet("Strict", "Moderate")]
        [System.String]
        $GiphyContentRating,

        [Parameter()]
        [System.String]
        $AllowStickersAndMemes,

        [Parameter()]
        [System.String]
        $AllowCustomMemes,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing Team fun settings for $TeamName"
    $CurrentValues = Get-TargetResource @PSBoundParameters

    return Test-Office365DSCParameterState -CurrentValues $CurrentValues `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @("GiphyContentRating", `
            "AllowGiphy", `
            "AllowStickersAndMemes", `
            "AllowCustomMemes", `
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
        $TeamName,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    Test-TeamsServiceConnection -GlobalAdminAccount $GlobalAdminAccount
    $result = Get-TargetResource @PSBoundParameters
    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
    $content = "        TeamsFunSettings " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
