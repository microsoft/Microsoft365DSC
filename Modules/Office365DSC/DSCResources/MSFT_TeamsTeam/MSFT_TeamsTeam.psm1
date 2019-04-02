function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateLength(1, 256)]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Group,

        [Parameter()]
        [System.String]
        $GroupID,

        [Parameter()]
        [System.String]
        [ValidateLength(1, 1024)]
        $Description,

        [Parameter()]
        [System.String]
        $Alias,

        [Parameter()]
        [System.String]
        $Owner,

        [Parameter()]
        [System.String]
        $Classification,

        [Parameter()]
        [System.String]
        [ValidateSet("Public", "Private")]
        $AccessType,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    $CurrentParameters = $PSBoundParameters
    if ($CurrentParameters.ContainsKey("Group"))
    {
        Write-Verbose -Message "When Group is passed all other parameters will be ignored."
    }

    Test-TeamsServiceConnection -GlobalAdminAccount $GlobalAdminAccount

    $nullReturn = @{
        DisplayName        = $DisplayName
        Group              = $Group
        GroupId            = $GroupID
        Description        = $Description
        Owner              = $Owner
        Classification     = $null
        Alias              = $Alias
        AccessType         = $AccessType
        Ensure             = "Absent"
        GlobalAdminAccount = $GlobalAdminAccount
    }

    Write-Verbose -Message "Checking for existance of Team $DisplayName"

    $CurrentParameters = $PSBoundParameters
    if ($CurrentParameters.ContainsKey("GroupID"))
    {
        $team = Get-Team  |  Where-Object {($_.GroupId -eq $GroupID)}
        if ($null -eq $team)
        {
            Write-Verbose "Teams with GroupId $($GroupID) doesn't exist"
            return $nullReturn
        }
    }
    else
    {
        $team = Get-Team |  Where-Object {($_.DisplayName -eq $DisplayName)}
        if ($null -eq $team)
        {
            Write-Verbose "Teams with displayname $DisplayName doesn't exist"
            return $nullReturn
        }
        if ($team.Count -gt 1)
        {
            throw "Duplicate Teams name $DisplayName exist in tenant"
        }
    }
    Write-Verbose -Message "Found Team $($team.DisplayName) and groupid of $($team.GroupID)"

    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount

    $allGroups = Get-UnifiedGroup

    if ($CurrentParameters.ContainsKey("GroupID"))
    {
        $teamGroup = $allGroups | Where-Object {$_.ExternalDirectoryObjectId -eq $GroupID}
    }  ##### Else using display name for lookup for set operation
    else
    {
        $teamGroup = $allGroups | Where-Object {$_.DisplayName -eq $DisplayName}
    }

    Write-Verbose -Message "Found O365 group $teamGroup"
    Write-Verbose -Message "Alias = $($teamGroup.Alias) and team accesstype = $($teamGroup.AccessType)"

    return @{
        DisplayName        = $team.DisplayName
        Group              = $Group
        GroupID            = $team.GroupId
        Description        = $team.Description
        Owner              = $null
        Classification     = $null
        Alias              = $teamGroup.Alias
        AccessType         = $teamGroup.AccessType
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
        [ValidateLength(1, 256)]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Group,

        [Parameter()]
        [System.String]
        $GroupID,

        [Parameter()]
        [System.String]
        [ValidateLength(1, 1024)]
        $Description,

        [Parameter()]
        [System.String]
        $Alias,

        [Parameter()]
        [System.String]
        $Owner,

        [Parameter()]
        [System.String]
        $Classification,

        [Parameter()]
        [System.String]
        [ValidateSet("Public", "Private")]
        $AccessType,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Test-TeamsServiceConnection -GlobalAdminAccount $GlobalAdminAccount
    Write-Verbose  -Message "Entering Set-TargetResource"
    Write-Verbose  -Message "Retrieving information about team $($DisplayName) to see if it already exists"
    $team = Get-TargetResource @PSBoundParameters

    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("GlobalAdminAccount")
    $CurrentParameters.Remove("Ensure")

    if ($Ensure -eq "Present")
    {
        if ($team.GroupID)
        {
            ## Can't pass Owner parm into set opertaion and accesstype is called visibility on set
            if ($CurrentParameters.ContainsKey("Owner"))
            {
                $CurrentParameters.Remove("Owner")
            }
            if ($CurrentParameters.ContainsKey("AccessType"))
            {
                ### Parameter name is different from New-Team vs Set-Team
                $CurrentParameters.Remove("AccessType")
                Set-Team @CurrentParameters -Visibility $AccessType
            }
            else
            {
                Set-Team @CurrentParameters
            }

            Write-Verbose -Message "Updating team group id $($GroupID)"
        }
        else
        {
            ## Remove GroupId for New-Team cmdlet creation
            if ($CurrentParameters.ContainsKey("GroupID"))
            {
                $CurrentParameters.Remove("GroupID")
            }
            #IF Group passed as parameter the New_team cmdlet only accepts this parameter
            if ($CurrentParameters.ContainsKey("Group"))
            {
                Write-Verbose -Message "Discarding all parameters since group $Group was passed to resources"
                New-Team  -Group $Group
            }
            #Create new team with parameters
            else
            {
                Write-Verbose -Message "Creating team $DisplayName"
                New-Team @CurrentParameters
            }
        }
    }
    else
    {
        if ($team.GroupId)
        {
            Write-Verbose -Message "Removing team $DisplayName"
            Remove-team -GroupId $team.GroupId
        }
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
        [ValidateLength(1, 256)]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Group,

        [Parameter()]
        [System.String]
        $GroupID,

        [Parameter()]
        [System.String]
        [ValidateLength(1, 1024)]
        $Description,

        [Parameter()]
        [System.String]
        $Alias,

        [Parameter()]
        [System.String]
        $Owner,

        [Parameter()]
        [System.String]
        $Classification,

        [Parameter()]
        [System.String]
        [ValidateSet("Public", "Private")]
        $AccessType,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing creation of new Team"
    $CurrentValues = Get-TargetResource @PSBoundParameters
    $result = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @("Ensure")
    if (!$result)
    {
        Write-Verbose "Team $DisplayName is not in its Desired State"
    }
    return $result
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateLength(1, 256)]
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    Test-TeamsServiceConnection -GlobalAdminAccount $GlobalAdminAccount
    $result = Get-TargetResource @PSBoundParameters
    $result.GlobalAdminAccount = Resolve-Credentials -UserName $GlobalAdminAccount.UserName
    $content = "        TeamsTeam " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
