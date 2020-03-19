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

        [Parameter(Mandatory = $true)]
        [System.String]
        $TeamMailNickName,

        [Parameter()]
        [System.String]
        [ValidateLength(0, 50)]
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
        $GlobalAdminAccount,

        [Parameter()]
        $RawInputObject
    )

    Write-Verbose -Message "Getting configuration of Teams channel $DisplayName"

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-O365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = @{
        TeamName           = $TeamName
        TeamMailNickName   = $TeamMailNickName
        DisplayName        = $DisplayName
        Description        = $Description
        NewDisplayName     = $NewDisplayName
        Ensure             = "Absent"
        GlobalAdminAccount = $GlobalAdminAccount
    }
    Write-Verbose -Message "Checking for existance of team channels"
    $CurrentParameters = $PSBoundParameters

    try
    {
        if($RawInputObject)
        {
            $team = $RawInputObject.Team
            $channel = $RawInputObject.Channel
        }
        else
        {
            Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
            -Platform MicrosoftTeams
            $team = Get-TeamByName $TeamName

            Write-Verbose -Message "Retrieve team GroupId: $($team.GroupId)"

            $channel = Get-TeamChannel -GroupId $team.GroupId `
                -ErrorAction SilentlyContinue `
            | Where-Object -FilterScript {
                ($_.DisplayName -eq $DisplayName)
            }

            #Current channel doesnt exist and trying to rename throw an error
            if (($null -eq $channel) -and $CurrentParameters.ContainsKey("NewDisplayName"))
            {
                Write-Verbose -Message "Cannot rename channel $DisplayName , doesnt exist in current Team"
                throw "Channel named $DisplayName doesn't exist in current Team"
            }

            if ($null -eq $channel)
            {
                Write-Verbose -Message "Failed to get team channels with ID $($team.GroupId) and display name of $DisplayName"
                return $nullReturn
            }
        }

        return @{
            DisplayName        = $channel.DisplayName
            TeamName           = $team.DisplayName
            TeamMailNickName   = $team.MailNickName
            Description        = $channel.Description
            NewDisplayName     = $NewDisplayName
            Ensure             = "Present"
            GlobalAdminAccount = $GlobalAdminAccount
        }
    }
    catch
    {
        return $nullReturn
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
        [ValidateLength(0, 50)]
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

    Write-Verbose -Message "Setting configuration of Teams channel $DisplayName"

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-O365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
        -Platform MicrosoftTeams

    $channel = Get-TargetResource @PSBoundParameters

    $CurrentParameters = $PSBoundParameters

    $team = Get-TeamByName $TeamName

    if ($team.Length -gt 1)
    {
        throw "Multiple Teams with name {$($TeamName)} were found"
    }
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
                $CurrentParameters.Remove("DisplayName") | Out-Null
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
        [ValidateLength(0, 50)]
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

    Write-Verbose -Message "Testing configuration of Teams channel $DisplayName"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-O365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-O365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @("Ensure")

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
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $InformationPreference = 'Continue'

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-O365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform MicrosoftTeams

    [array]$teams = Get-AllTeamsCached
    $j = 1
    $content = ''
    foreach ($team in $Teams)
    {
        $channels = [System.Collections.ArrayList]:: new()
        Invoke-WithTransientErrorExponentialRetry -ScriptBlock {
            $channels.AddRange([array](Get-TeamChannel -GroupId $team.GroupId))
        }
        $i = 1
        Write-Information "    > [$j/$($Teams.Length)] Team {$($team.DisplayName)}"
        foreach ($channel in $channels)
        {
            Write-Information "        - [$i/$($channels.Count)] $($channel.DisplayName)"
            $params = @{
                TeamName           = $team.DisplayName
                TeamMailNickName   = $team.MailNickName
                DisplayName        = $channel.DisplayName
                GlobalAdminAccount = $GlobalAdminAccount
                RawInputObject     = @{
                    Team = $team
                    Channel = $channel
                }
            }
            $result = Get-TargetResource @params
            $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
            $content += "        TeamsChannel " + (New-GUID).ToString() + "`r`n"
            $content += "        {`r`n"
            $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
            $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
            $content += "        }`r`n"
            $i++
        }
        $j++
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
