function Get-TargetResource {
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
        [ValidateLength(0, 50)]
        $NewDisplayName,

        [Parameter()]
        [System.String]
        [ValidateLength(1, 1024)]
        $Description,

        [Parameter()]
        [System.String]
        [ValidateSet('Standard', 'Private')]
        $MembershipType = 'Standard',

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of Teams channel $DisplayName"

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform MicrosoftTeams

    $nullReturn = @{
        TeamName           = $TeamName
        DisplayName        = $DisplayName
        Description        = $Description
        NewDisplayName     = $NewDisplayName
        MembershipType     = $MembershipType
        Ensure             = "Absent"
        GlobalAdminAccount = $GlobalAdminAccount
    }
    Write-Verbose -Message "Checking for existance of team channels"
    $CurrentParameters = $PSBoundParameters

    try {
        $team = Get-TeamByName $TeamName

        Write-Verbose -Message "Retrieve team GroupId: $($team.GroupId)"

        $channel = Get-TeamChannel -GroupId $team.GroupId `
            -ErrorAction SilentlyContinue `
        | Where-Object -FilterScript {
            ($_.DisplayName -eq $DisplayName)
        }

        #Current channel doesnt exist and trying to rename throw an error
        if (($null -eq $channel) -and $CurrentParameters.ContainsKey("NewDisplayName")) {
            Write-Verbose -Message "Cannot rename channel $DisplayName , doesnt exist in current Team"
            throw "Channel named $DisplayName doesn't exist in current Team"
        }

        if ($null -eq $channel) {
            Write-Verbose -Message "Failed to get team channels with ID $($team.GroupId) and display name of $DisplayName"
            return $nullReturn
        }

        return @{
            DisplayName        = $channel.DisplayName
            TeamName           = $team.DisplayName
            MembershipType     = $channel.MembershipType
            Description        = $channel.Description
            NewDisplayName     = $NewDisplayName
            Ensure             = "Present"
            GlobalAdminAccount = $GlobalAdminAccount
        }
    }
    catch {
        return $nullReturn
    }
}

function Set-TargetResource {
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
        [System.String]
        [ValidateSet('Standard', 'Private')]
        $MembershipType = 'Standard',

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
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform MicrosoftTeams

    $channel = Get-TargetResource @PSBoundParameters

    $CurrentParameters = $PSBoundParameters

    $team = Get-TeamByName $TeamName

    if ($team.Length -gt 1) {
        throw "Multiple Teams with name {$($TeamName)} were found"
    }
    Write-Verbose -Message "Retrieve team GroupId: $($team.GroupId)"

    $CurrentParameters.Remove("TeamName")
    $CurrentParameters.Add("GroupId", $team.GroupId)
    $CurrentParameters.Remove("GlobalAdminAccount")
    $CurrentParameters.Remove("Ensure")

    if ($Ensure -eq "Present") {
        # Remap attribute from DisplayName to current display name for Set-TeamChannel cmdlet
        if ($channel.Ensure -eq "Present") {
            if ($CurrentParameters.ContainsKey("NewDisplayName")) {
                Write-Verbose -Message "Updating team channel to new channel name $NewDisplayName"
                $CurrentParameters.Remove("DisplayName") | Out-Null
                Set-TeamChannel @CurrentParameters -CurrentDisplayName $DisplayName
            }
        }
        else {
            if ($CurrentParameters.ContainsKey("NewDisplayName")) {
                $CurrentParameters.Remove("NewDisplayName")
            }
            Write-Verbose -Message "Creating team channel  $DislayName"
            New-TeamChannel @CurrentParameters

            if ($MembershipType -eq 'Private') {
                Write-Verbose "The newly created channel is a private one. Waiting 2 minutes to ensure everything gets created before moving forward."
                Start-Sleep 120
            }
        }
    }
    else {
        if ($channel.DisplayName) {
            Write-Verbose -Message "Removing team channel $DislayName"
            Remove-TeamChannel -GroupId $team.GroupId -DisplayName $DisplayName
        }
    }
}

function Test-TargetResource {
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
        [System.String]
        [ValidateSet('Standard', 'Private')]
        $MembershipType = 'Standard',

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

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-Microsoft365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @("Ensure")

    Write-Verbose -Message "Test-TargetResource returned $TestResult"

    return $TestResult
}

function Export-TargetResource {
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
        [System.Uint32]
        $Start,

        [Parameter()]
        [System.Uint32]
        $End,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $InformationPreference = 'Continue'
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform MicrosoftTeams

    $teams = Get-Team
    $j = 1
    $content = ''

    $TeamsModulePath = Join-Path -Path $PSScriptRoot -ChildPath '..\MSFT_TeamsTeam\MSFT_TeamsTeam.psm1' #Custom
    $ChannelModulePath = Join-Path $PSScriptRoot -ChildPath 'MSFT_TeamsChannel.psm1' #Custom
    $UserModulePath = Join-Path $PSScriptRoot -ChildPath '..\MSFT_TeamsUser\MSFT_TeamsUser.psm1' #Custom

    $organization = $GlobalAdminAccount.UserName.Split('@')[1]
    for ($j = $start; $j -le $Teams.Length -and $j -le $end; $j++) {
        $team = $Teams[$j - 1]
        $channels = Get-TeamChannel -GroupId $team.GroupId
        $i = 1
        $Total = $end
        if ($end -gt $Teams.Length) {
            $total = $Teams.Length
        }
        Write-Information "    > [$j/$($total)] Team {$($team.DisplayName)}"
        #region TeamsTeam - Section copied over from TeamsTeam
        $params = @{
            DisplayName        = $team.DisplayName
            GlobalAdminAccount = $GlobalAdminAccount
        }
        Import-Module $TeamsModulePath -Force #Custom
        $result = Get-TargetResource @params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        if ("" -eq $result.Owner) {
            $result.Remove("Owner")
        }
        if ([System.String]::IsNullOrEmpty($result.NewDisplayName)) {
            $result.Remove("NewDisplayName")
        }
        $content += "        TeamsTeam " + (New-GUID).ToString() + "`r`n"
        $content += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath ($TeamsModulePath.Replace("\MSFT_TeamsTeam.psm1", "")) #Custom
        $partialContent = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        $partialContent += "        }`r`n"
        if ($partialContent.ToLower().Contains("@" + $organization.ToLower())) {
            $partialContent = $partialContent -ireplace [regex]::Escape("@" + $organization), "@`$OrganizationName"
        }
        $content += $partialContent
        #endregion
        foreach ($channel in $channels) {
            $channelType = '-'
            if ($channel.MembershipType -eq 'Private') {
                $channelType = '!'
            }
            Write-Information "        $channelType [$i/$($channels.Length)] $($channel.DisplayName)"
            $params = @{
                TeamName           = $team.DisplayName
                DisplayName        = $channel.DisplayName
                GlobalAdminAccount = $GlobalAdminAccount
            }
            Import-Module $ChannelModulePath -Force #Custom
            $result = Get-TargetResource @params
            if ([System.String]::IsNullOrEmpty($result.NewDisplayName)) {
                $result.Remove("NewDisplayName")
            }
            $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
            $content += "        TeamsChannel " + (New-GUID).ToString() + "`r`n"
            $content += "        {`r`n"
            $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
            $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
            $content += "        }`r`n"

            if ($channel.MembershipType -eq 'Private') {
                Import-Module $UserModulePath -Force
                try {
                    $users = Get-TeamChannelUser -GroupId $team.GroupId -DisplayName $channel.DisplayName
                    $k = 1
                    foreach ($user in $users) {
                        Write-Information "            + [$k/$($users.Length)] $($user.User)"
                        $getParams = @{
                            GroupId            = $team.GroupId
                            DisplayName        = $channel.DisplayName
                            User               = $user.User
                            GlobalAdminAccount = $params.GlobalAdminAccount
                        }
                        $result = Get-TargetResource @getParams
                        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
                        $content += "        TeamsUser " + (New-GUID).ToString() + "`r`n"
                        $content += "        {`r`n"
                        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath ($UserModulePath.Replace("\MSFT_TeamsUser.psm1", ""))
                        $partialContent = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
                        $partialContent += "        }`r`n"
                        if ($partialContent.ToLower().Contains($organization.ToLower())) {
                            $partialContent = $partialContent -ireplace [regex]::Escape($organization), "`$OrganizationName"
                        }
                        $content += $partialContent
                        $k++
                    }
                }
                catch {
                    Write-Error "Could not retrieve users for private channel {$($channel.DisplayName)} with GroupID {$($team.GroupId)}"
                }
            }
            $i++
        }
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
