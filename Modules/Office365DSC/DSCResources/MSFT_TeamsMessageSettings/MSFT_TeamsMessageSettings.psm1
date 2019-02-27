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
        $AllowUserEditMessages,

        [Parameter()]
        [System.Boolean]
        $AllowUserDeleteMessages,

        [Parameter()]
        [System.Boolean]
        $AllowOwnerDeleteMessages,

        [Parameter()]
        [System.Boolean]
        $AllowTeamMentions,

        [Parameter()]
        [System.Boolean]
        $AllowChannelMentions,

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
        TeamName                 = $TeamName
        AllowUserEditMessages    = $null
        AllowUserDeleteMessages  = $null
        AllowOwnerDeleteMessages = $null
        AllowTeamMentions        = $null
        AllowChannelMentions     = $null
        Ensure                   = "Absent"
        GlobalAdminAccount       = $GlobalAdminAccount
    }

    Write-Verbose -Message "Getting Team message settings for $TeamName"

    $team = Get-Team |  Where-Object {$_.DisplayName -eq $TeamName}
    if ($null -eq $team)
    {
        throw "Team with Name $TeamName doesn't exist in tenant"
    }

    $teamMessageSettings = Get-TeamMessagingSettings -GroupId $team.GroupId -ErrorAction SilentlyContinue
    if ($null -eq $teamMessageSettings)
    {
        Write-Verbose "The specified Team doesn't exist."
        return $nullReturn
    }

    Write-Verbose "Team message settings for AllowUserEditMessages = $($teamMessageSettings.AllowUserEditMessages)"
    Write-Verbose "Team messgae settings for AllowUserDeleteMessages = $($teamMessageSettings.AllowUserDeleteMessages)"
    Write-Verbose "Team message settings for AllowOwnerDeleteMessages = $($teamMessageSettings.AllowOwnerDeleteMessages)"
    Write-Verbose "Team message settings for AllowTeamMentions = $($teamMessageSettings.AllowTeamMentions)"
    Write-Verbose "Team message settings for AllowChannelMentions = $($teamMessageSettings.AllowChannelMentions)"

    return @{
        TeamName                 = $TeamName
        AllowUserEditMessages    = $teamMessageSettings.AllowUserEditMessages
        AllowUserDeleteMessages  = $teamMessageSettings.AllowUserDeleteMessages
        AllowOwnerDeleteMessages = $teamMessageSettings.AllowOwnerDeleteMessages
        AllowTeamMentions        = $teamMessageSettings.AllowTeamMentions
        AllowChannelMentions     = $teamMessageSettings.AllowChannelMentions
        Ensure                   = "Present"
        GlobalAdminAccount       = $GlobalAdminAccount
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
        $AllowUserEditMessages,

        [Parameter()]
        [System.Boolean]
        $AllowUserDeleteMessages,

        [Parameter()]
        [System.Boolean]
        $AllowOwnerDeleteMessages,

        [Parameter()]
        [System.Boolean]
        $AllowTeamMentions,

        [Parameter()]
        [System.Boolean]
        $AllowChannelMentions,

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
    Write-Verbose -Message "Setting TeamMessageSettings on team $TeamName"
    Set-TeamMessagingSettings @CurrentParameters
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
        $AllowUserEditMessages,

        [Parameter()]
        [System.Boolean]
        $AllowUserDeleteMessages,

        [Parameter()]
        [System.Boolean]
        $AllowOwnerDeleteMessages,

        [Parameter()]
        [System.Boolean]
        $AllowTeamMentions,

        [Parameter()]
        [System.Boolean]
        $AllowChannelMentions,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing Team message settings for $TeamName"
    $CurrentValues = Get-TargetResource @PSBoundParameters

    return Test-Office365DSCParameterState -CurrentValues $CurrentValues `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @("AllowUserEditMessages", `
            "AllowUserDeleteMessages", `
            "AllowOwnerDeleteMessages", `
            "AllowTeamMentions", `
            "AllowChannelMentions", `
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
    $content = "        TeamsMessageSettings " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
