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
        [System.Boolean]
        $AllowAddRemoveApps,

        [Parameter()]
        [System.Boolean]
        $AllowCreateUpdateRemoveTabs,

        [Parameter()]
        [System.Boolean]
        $AllowCreateUpdateRemoveConnectors,

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
        TeamName                          = $TeamName
        AllowCreateUpdateChannels         = $null
        AllowDeleteChannels               = $null
        AllowAddRemoveApps                = $null
        AllowCreateUpdateRemoveTabs       = $null
        AllowCreateUpdateRemoveConnectors = $null
        Ensure                            = "Absent"
        GlobalAdminAccount                = $GlobalAdminAccount
    }

    Write-Verbose -Message "Getting Team member settings for $TeamName"

    $team = Get-Team |  Where-Object {$_.DisplayName -eq $TeamName}
    if ($null -eq $team)
    {
        throw "Team with Name $TeamName doesn't exist in tenant"
    }

    $teamMemberSettings = Get-TeamMemberSettings -GroupId $team.GroupId -ErrorAction SilentlyContinue
    if ($null -eq $teamMemberSettings)
    {
        Write-Verbose "The specified Team doesn't exist."
        return $nullReturn
    }

    Write-Verbose "Team member settings for AllowCreateUpdateChannels = $($teamMemberSettings.AllowCreateUpdateChannels)"
    Write-Verbose "Team member settings for AllowDeleteChannels = $($teamMemberSettings.AllowDeleteChannels)"
    Write-Verbose "Team member settings for AllowAddRemoveApps = $($teamMemberSettings.AllowAddRemoveApps)"
    Write-Verbose "Team member settings for AllowCreateUpdateRemoveTabs = $($teamMemberSettings.AllowCreateUpdateRemoveTabs)"
    Write-Verbose "Team member settings for AllowCreateUpdateRemoveConnectors = $($teamMemberSettings.AllowCreateUpdateRemoveConnectors)"

    return @{
        TeamName                          = $TeamName
        AllowCreateUpdateChannels         = $teamMemberSettings.AllowCreateUpdateChannels
        AllowDeleteChannels               = $teamMemberSettings.AllowDeleteChannels
        AllowAddRemoveApps                = $teamMemberSettings.AllowAddRemoveApps
        AllowCreateUpdateRemoveTabs       = $teamMemberSettings.AllowCreateUpdateRemoveTabs
        AllowCreateUpdateRemoveConnectors = $teamMemberSettings.AllowCreateUpdateRemoveConnectors
        Ensure                            = "Present"
        GlobalAdminAccount                = $GlobalAdminAccount
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
        [System.Boolean]
        $AllowAddRemoveApps,

        [Parameter()]
        [System.Boolean]
        $AllowCreateUpdateRemoveTabs,

        [Parameter()]
        [System.Boolean]
        $AllowCreateUpdateRemoveConnectors,

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
    Write-Verbose -Message "Setting TeamMemberSettings on team $TeamName"
    Set-TeamMemberSettings @CurrentParameters
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
        [System.Boolean]
        $AllowAddRemoveApps,

        [Parameter()]
        [System.Boolean]
        $AllowCreateUpdateRemoveTabs,

        [Parameter()]
        [System.Boolean]
        $AllowCreateUpdateRemoveConnectors,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing Team member settings for $TeamName"
    $CurrentValues = Get-TargetResource @PSBoundParameters

    return Test-Office365DSCParameterState -CurrentValues $CurrentValues `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @("AllowCreateUpdateChannels", `
            "AllowDeleteChannels", `
            "AllowAddRemoveApps", `
            "AllowCreateUpdateRemoveTabs", `
            "AllowCreateUpdateRemoveConnectors", `
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
    $content = "        TeamsMemberSettings " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
