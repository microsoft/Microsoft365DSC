function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $GroupID,

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


        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Test-TeamsServiceConnection -GlobalAdminAccount $GlobalAdminAccount

    $nullReturn = @{
        GroupID               = $null
        AllowGiphy            = $null
        GiphyContentRating    = $null
        AllowStickersAndMemes = $null
        AllowCustomMemes      = $null
    }


    Write-Verbose -Message "Getting Team fun settings for $GroupID"

    $teamExists = Get-TeamByGroupID $GroupID
    if ($teamExists -eq $false)
    {
        throw "Team with groupid of  $GroupID doesnt exist in tenant"
    }

    $team = Get-TeamFunSettings -GroupId $GroupID -ErrorAction SilentlyContinue
    if ($null -eq $team)
    {
        Write-Verbose "The specified Team doesn't exist."
        return $nullReturn
    }

    Write-Verbose "Team fun settings for AllowGiphy = $($team.AllowGiphy)"
    Write-Verbose "Team fun settings for GiphyContentRating = $($team.GiphyContentRating)"
    Write-Verbose "Team fun settings for AllowStickersAndMemes = $($team.AllowStickersAndMemes)"
    Write-Verbose "Team fun settings for AllowCustomMemes = $($team.AllowCustomMemes)"

    return @{
        GroupID               = $GroupID
        AllowGiphy            = $team.AllowGiphy
        GiphyContentRating    = $team.GiphyContentRating
        AllowStickersAndMemes = $team.AllowStickersAndMemes
        AllowCustomMemes      = $team.AllowCustomMemes
    }

}

function Set-TargetResource{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $GroupID,

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

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Test-TeamsServiceConnection -GlobalAdminAccount $GlobalAdminAccount

    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("GlobalAdminAccount")
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
        $GroupID,

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

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing Team fun settings for  $GroupID"
    $CurrentValues = Get-TargetResource @PSBoundParameters


    return Test-Office365DSCParameterState -CurrentValues $CurrentValues `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @("GiphyContentRating", `
                        "AllowGiphy", `
                        "AllowStickersAndMemes",`
                        "AllowCustomMemes")
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $GroupID,

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

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    Test-TeamsServiceConnection -GlobalAdminAccount $GlobalAdminAccount
    $result = Get-TargetResource @PSBoundParameters
    $content = "TeamFunSettings " + (New-GUID).ToString() + "`r`n"
    $content += "{`r`n"
    $content += Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += "}`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
