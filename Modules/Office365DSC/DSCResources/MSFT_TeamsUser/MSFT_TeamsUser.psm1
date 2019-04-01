function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $TeamName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $User,

        [Parameter()]
        [System.String]
        [ValidateSet("Member", "Owner")]
        $Role,

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
        User               = $User
        Role               = $Role
        TeamName           = $TeamName
        Ensure             = "Absent"
        GlobalAdminAccount = $GlobalAdminAccount
    }

    Write-Verbose -Message "Checking for existance of Team User $User"
    $team = Get-TeamByName $TeamName

    Write-Verbose -Message "Retrieve team GroupId: $($team.GroupId)"

    if ($null -eq $Role)
    {
        $allMembers = Get-TeamUser -GroupId $team.GroupId -ErrorAction SilentlyContinue
    }
    else
    {
        $allMembers = Get-TeamUser -GroupId $team.GroupId -Role $Role -ErrorAction SilentlyContinue
    }

    if ($null -eq $allMembers)
    {
        Write-Verbose "Failed to get Team's users for Team $TeamName"
        return $nullReturn
    }

    $myUser = $allMembers | Where-Object {$_.User -eq $User}
    Write-Verbose -Message "Found team user $($myUser.User) with role:$($myUser.Role)"
    return @{
        User               = $myUser.User
        Role               = $myUser.Role
        TeamName           = $TeamName
        Ensure             = "Present"
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
        $TeamName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $User,

        [Parameter()]
        [System.String]
        [ValidateSet("Member", "Owner")]
        $Role,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Test-TeamsServiceConnection -GlobalAdminAccount $GlobalAdminAccount

    $team = Get-TeamByName $TeamName

    Write-Verbose -Message "Retrieve team GroupId: $($team.GroupId)"

    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("TeamName")
    $CurrentParameters.Add("GroupId", $team.GroupId)
    $CurrentParameters.Remove("GlobalAdminAccount")
    $CurrentParameters.Remove("Ensure")

    if ($Ensure -eq "Present")
    {
        Write-Verbose -Message "Adding team user $User with role:$Role"
        Add-TeamUser @CurrentParameters
    }
    else
    {
        if ($Role -eq "Member" -and $CurrentParameters.ContainsKey("Role"))
        {
            $CurrentParameters.Remove("Role")
            Write-Verbose -Message "Removed role parameter"
        }
        Remove-TeamUser @CurrentParameters
        Write-Verbose -Message "Removing team user $User"
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
        $TeamName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $User,

        [Parameter()]
        [System.String]
        [ValidateSet("Member", "Owner")]
        $Role,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing addition of team member"
    $CurrentValues = Get-TargetResource @PSBoundParameters
    return Test-Office365DSCParameterState -CurrentValues $CurrentValues `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @("Ensure", `
            "User", `
            "Role"
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
        [System.String]
        $User,

        [Parameter()]
        [System.String]
        [ValidateSet("Member", "Owner")]
        $Role,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    Test-TeamsServiceConnection -GlobalAdminAccount $GlobalAdminAccount
    $result = Get-TargetResource @PSBoundParameters
    $result.GlobalAdminAccount = Resolve-Credentials -UserName $GlobalAdminAccount.UserName
    $content = "        TeamsUser " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
