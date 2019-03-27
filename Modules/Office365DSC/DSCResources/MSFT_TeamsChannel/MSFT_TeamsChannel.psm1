function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateLength(1, 50)]
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $TeamName,

        [Parameter()]
        [System.String]
        [ValidateLength(1, 50)]
        $NewDisplayName,

        [Parameter()]
        [System.String]
        [ValidateLength(1, 1024)]
        $Description,

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
        TeamName           = $TeamName
        DisplayName        = $DisplayName
        Description        = $Description
        NewDisplayName     = $NewDisplayName
        Ensure             = "Absent"
        GlobalAdminAccount = $GlobalAdminAccount
    }

    Write-Verbose -Message "Checking for existance of team channels"
    $CurrentParameters = $PSBoundParameters

    $team = Get-TeamByName $TeamName

    Write-Verbose -Message "Retrieve team GroupId: $($team.GroupId)"

    $channel = Get-TeamChannel -GroupId $team.GroupId -ErrorAction SilentlyContinue | Where-Object {($_.DisplayName -eq $DisplayName)}

    #Current channel doesnt exist and trying to rename throw an error
    if (($null -eq $channel) -and $CurrentParameters.ContainsKey("NewDisplayName"))
    {
        Write-Verbose "Cannot rename channel $DisplayName , doesnt exist in current Team"
        throw "Channel named $DisplayName doesn't exist in current Team"
    }

    if ($null -eq $channel)
    {
        Write-Verbose "Failed to get team channels with ID $($team.GroupId) and display name of $DisplayName"
        return $nullReturn
    }

    return @{
        DisplayName        = $channel.DisplayName
        TeamName           = $team.DisplayName
        Description        = $channel.Description
        NewDisplayName     = $NewDisplayName
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
        [ValidateLength(1, 50)]
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $TeamName,

        [Parameter()]
        [System.String]
        [ValidateLength(1, 50)]
        $NewDisplayName,

        [Parameter()]
        [System.String]
        [ValidateLength(1, 1024)]
        $Description,

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
    Write-Verbose  -Message "Retrieving information about team channel $($DisplayName) to see if it already exists"
    $channel = Get-TargetResource @PSBoundParameters

    $CurrentParameters = $PSBoundParameters

    $team = Get-TeamByName $TeamName

    Write-Verbose -Message "Retrieve team GroupId: $($team.GroupId)"

    $CurrentParameters.Remove("TeamName")
    $CurrentParameters.Add("GroupId", $team.GroupId)
    $CurrentParameters.Remove("GlobalAdminAccount")
    $CurrentParameters.Remove("Ensure")

    if ($Ensure -eq "Present")
    {
        # Remap attribute from DisplayName to current display name for Set-TeamChannel cmdlet
        if ($channel.Ensure -eq "Present")
        {
            if ($CurrentParameters.ContainsKey("NewDisplayName"))
            {
                Write-Verbose -Message "Updating team channel to new channel name $NewDisplayName"
                Set-TeamChannel @CurrentParameters -CurrentDisplayName $DisplayName
            }
        }
        else
        {
            if ($CurrentParameters.ContainsKey("NewDisplayName"))
            {
                $CurrentParameters.Remove("NewDisplayName")
            }
            Write-Verbose -Message "Creating team channel  $DislayName"
            New-TeamChannel @CurrentParameters
        }
    }
    else
    {
        if ($channel.DisplayName)
        {
            Write-Verbose -Message "Removing team channel $DislayName"
            Remove-TeamChannel -GroupId $team.GroupId -DisplayName $DisplayName
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
        [ValidateLength(1, 50)]
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $TeamName,

        [Parameter()]
        [System.String]
        [ValidateLength(1, 50)]
        $NewDisplayName,

        [Parameter()]
        [System.String]
        [ValidateLength(1, 1024)]
        $Description,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing creation of new Team's channel"
    $CurrentValues = Get-TargetResource @PSBoundParameters
    return Test-Office365DSCParameterState -CurrentValues $CurrentValues `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @("Ensure")
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateLength(1, 50)]
        $DisplayName,

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
    $content = "        TeamsChannel " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
