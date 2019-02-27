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
        [System.Boolean]
        $AllowCreateUpdateChannels,

        [Parameter()]
        [System.Boolean]
        $AllowDeleteChannels,

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
        TeamName                  = $TeamName
        AllowCreateUpdateChannels = $null
        AllowDeleteChannels        = $null
        Ensure                    = "Absent"
        GlobalAdminAccount        = $GlobalAdminAccount
    }

    Write-Verbose -Message "Getting Team guest settings for $TeamName"

    $team = Get-Team |  Where-Object {$_.DisplayName -eq $TeamName}
    if ($null -eq $team)
    {
        throw "Team with Name $TeamName doesn't exist in tenant"
    }

    $teamGuestSettings = Get-TeamGuestSettings -GroupId $team.GroupId -ErrorAction SilentlyContinue
    if ($null -eq $teamGuestSettings)
    {
        Write-Verbose "The specified Team doesn't exist."
        return $nullReturn
    }

    Write-Verbose "Team guest settings for AllowCreateUpdateChannels = $($teamGuestSettings.AllowCreateUpdateChannels)"
    Write-Verbose "Team guest settings for AllowDeleteChannels = $($teamGuestSettings.AllowDeleteChannels)"

    return @{
        TeamName                  = $TeamName
        AllowCreateUpdateChannels = $teamGuestSettings.AllowCreateUpdateChannels
        AllowDeleteChannels       = $teamGuestSettings.AllowDeleteChannels
        Ensure                    = "Present"
        GlobalAdminAccount        = $GlobalAdminAccount
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
        [System.Boolean]
        $AllowCreateUpdateChannels,

        [Parameter()]
        [System.Boolean]
        $AllowDeleteChannels,

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
        throw "This resource doesn't handle Ensure = Absent. Please make sure its Ensure value is set to Present."
    }

    Test-TeamsServiceConnection -GlobalAdminAccount $GlobalAdminAccount

    $team = Get-Team |  Where-Object {$_.DisplayName -eq $TeamName}
    if ($null -eq $team)
    {
        throw "Team with Name $TeamName doesn't exist in tenant"
    }

    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("TeamName")
    $CurrentParameters.Add("GroupId", $team.GroupId)
    $CurrentParameters.Remove("GlobalAdminAccount")
    $CurrentParameters.Remove("Ensure")
    Write-Verbose -Message "Setting TeamGuestSettings on team $TeamName"
    Set-TeamGuestSettings @CurrentParameters
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
        [System.Boolean]
        $AllowCreateUpdateChannels,

        [Parameter()]
        [System.Boolean]
        $AllowDeleteChannels,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing Team guest settings for $TeamName"
    $CurrentValues = Get-TargetResource @PSBoundParameters

    return Test-Office365DSCParameterState -CurrentValues $CurrentValues `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @("AllowCreateUpdateChannels", `
            "AllowDeleteChannels", `
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
    $result.GlobalAdminAccount = Resolve-Credentials -UserName $GlobalAdminAccount.UserName
    $content = "        TeamsGuestSettings " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
