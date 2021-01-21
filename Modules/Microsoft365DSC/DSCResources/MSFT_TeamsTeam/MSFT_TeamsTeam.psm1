function Get-TargetResource {
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
        $GroupID,

        [Parameter()]
        [System.String]
        [ValidateLength(1, 1024)]
        $Description,

        [Parameter()]
        [System.String]
        $MailNickName,

        [Parameter()]
        [System.String]
        $Owner,

        [Parameter()]
        [System.String]
        [ValidateSet("Public", "Private", "HiddenMembership")]
        $Visibility,

        [Parameter()]
        [System.Boolean]
        $AllowAddRemoveApps,

        [Parameter()]
        [System.Boolean]
        $AllowGiphy,

        [Parameter()]
        [ValidateSet("Strict", "Moderate")]
        [System.String]
        $GiphyContentRating,

        [Parameter()]
        [System.Boolean]
        $AllowStickersAndMemes,

        [Parameter()]
        [System.Boolean]
        $AllowCustomMemes,

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
        $AllowCreateUpdateRemoveConnectors,

        [Parameter()]
        [System.Boolean]
        $AllowCreateUpdateRemoveTabs,

        [Parameter()]
        [System.Boolean]
        $AllowCreateUpdateChannels,

        [Parameter()]
        [System.Boolean]
        $AllowDeleteChannels,

        [Parameter()]
        [System.Boolean]
        $AllowTeamMentions,

        [Parameter()]
        [System.Boolean]
        $AllowChannelMentions,

        [Parameter()]
        [System.Boolean]
        $AllowGuestCreateUpdateChannels,

        [Parameter()]
        [System.Boolean]
        $AllowGuestDeleteChannels,

        [Parameter()]
        [System.Boolean]
        $Archived,

        [Parameter()]
        [System.Boolean]
        $ShowInTeamsSearchAndSuggestions,

        [Parameter()]
        [System.String]
        $Classification,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of Team $DisplayName"

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = @{
        DisplayName                       = $DisplayName
        GroupId                           = $GroupID
        Description                       = $Description
        Owner                             = $Owner
        MailNickName                      = $MailNickName
        Visibility                        = $Visibility
        Ensure                            = "Absent"
        AllowAddRemoveApps                = $AllowAddRemoveApps
        AllowGiphy                        = $AllowGiphy
        GiphyContentRating                = $GiphyContentRating
        AllowStickersAndMemes             = $AllowStickersAndMemes
        AllowCustomMemes                  = $AllowCustomMemes
        AllowUserEditMessages             = $AllowUserEditMessages
        AllowUserDeleteMessages           = $AllowUserDeleteMessages
        AllowOwnerDeleteMessages          = $AllowOwnerDeleteMessages
        AllowCreateUpdateRemoveConnectors = $AllowCreateUpdateRemoveConnectors
        AllowCreateUpdateRemoveTabs       = $AllowCreateUpdateRemoveTabs
        AllowCreateUpdateChannels         = $AllowCreateUpdateChannels
        AllowDeleteChannels               = $AllowDeleteChannels
        AllowTeamMentions                 = $AllowTeamMentions
        AllowChannelMentions              = $AllowChannelMentions
        AllowGuestCreateUpdateChannels    = $AllowGuestCreateUpdateChannels
        AllowGuestDeleteChannels          = $AllowGuestDeleteChannels
        ShowInTeamsSearchAndSuggestions   = $ShowInTeamsSearchAndSuggestions
        Classification                    = $Classification
        Archived                          = $Archived
        GlobalAdminAccount                = $GlobalAdminAccount
    }

    Write-Verbose -Message "Checking for existance of Team $DisplayName"
    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform MicrosoftTeams

    $CurrentParameters = $PSBoundParameters

    try {
        ## will only return 1 instance
        if ($CurrentParameters.ContainsKey("GroupID")) {
            $team = Get-Team -GroupId $GroupID
            if ($null -eq $team) {
                Write-Verbose -Message "Teams with GroupId $($GroupID) doesn't exist"
                return $nullReturn
            }
        }
        else {
            ## Can retreive multiple Teams since displayname is not unique
            $team = Get-Team -DisplayName $DisplayName
            if ($null -eq $team) {
                Write-Verbose -Message "Teams with displayname $DisplayName doesn't exist"
                return $nullReturn
            }
            if ($team.Length -gt 1) {
                throw "Duplicate Teams name $DisplayName exist in tenant"
            }
        }

        $Owners = Get-TeamUser -GroupId $team.GroupId | Where-Object { $_.Role -eq "owner" }

        if ($null -ne $Owners) {
            foreach ($owner in $Owners.User) {
                $OwnersArray = $owner.ToString()
                break
            }
        }
        Write-Verbose -Message "Found Team $($team.DisplayName)."

        return @{
            DisplayName                       = $team.DisplayName
            GroupID                           = $team.GroupId
            Description                       = $team.Description
            Owner                             = $OwnersArray
            MailNickName                      = $team.MailNickName
            Visibility                        = $team.Visibility
            AllowAddRemoveApps                = $team.AllowAddRemoveApps
            AllowGiphy                        = $team.AllowGiphy
            GiphyContentRating                = $team.GiphyContentRating
            AllowStickersAndMemes             = $team.AllowStickersAndMemes
            AllowCustomMemes                  = $team.AllowCustomMemes
            AllowUserEditMessages             = $team.AllowUserEditMessages
            AllowUserDeleteMessages           = $team.AllowUserDeleteMessages
            AllowOwnerDeleteMessages          = $team.AllowOwnerDeleteMessages
            AllowCreateUpdateRemoveConnectors = $team.AllowCreateUpdateRemoveConnectors
            AllowCreateUpdateRemoveTabs       = $team.AllowCreateUpdateRemoveTabs
            AllowTeamMentions                 = $team.AllowTeamMentions
            AllowChannelMentions              = $team.AllowChannelMentions
            AllowGuestCreateUpdateChannels    = $team.AllowGuestCreateUpdateChannels
            AllowGuestDeleteChannels          = $team.AllowGuestDeleteChannels
            AllowCreateUpdateChannels         = $team.AllowCreateUpdateChannels
            AllowDeleteChannels               = $team.AllowDeleteChannels
            Archived                          = $team.Archived
            ShowInTeamsSearchAndSuggestions   = $team.ShowInTeamsSearchAndSuggestions
            Classification                    = $team.Classification
            Ensure                            = "Present"
            GlobalAdminAccount                = $GlobalAdminAccount
        }
    }
    catch {
        Write-Verbose "Returning empty results due to error: $_"
        return $nullReturn
    }
}

function Set-TargetResource {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateLength(1, 256)]
        $DisplayName,

        [Parameter()]
        [System.String]
        $GroupID,

        [Parameter()]
        [System.String]
        [ValidateLength(1, 1024)]
        $Description,

        [Parameter()]
        [System.String]
        $MailNickName,

        [Parameter()]
        [System.String]
        $Owner,

        [Parameter()]
        [System.String]
        [ValidateSet("Public", "Private", "HiddenMembership")]
        $Visibility,

        [Parameter()]
        [System.Boolean]
        $AllowAddRemoveApps,

        [Parameter()]
        [System.Boolean]
        $AllowGiphy,

        [Parameter()]
        [ValidateSet("Strict", "Moderate")]
        [System.String]
        $GiphyContentRating,

        [Parameter()]
        [System.Boolean]
        $AllowStickersAndMemes,

        [Parameter()]
        [System.Boolean]
        $AllowCustomMemes,

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
        $AllowCreateUpdateRemoveConnectors,

        [Parameter()]
        [System.Boolean]
        $AllowCreateUpdateRemoveTabs,

        [Parameter()]
        [System.Boolean]
        $AllowCreateUpdateChannels,

        [Parameter()]
        [System.Boolean]
        $AllowDeleteChannels,

        [Parameter()]
        [System.Boolean]
        $AllowTeamMentions,

        [Parameter()]
        [System.Boolean]
        $AllowChannelMentions,

        [Parameter()]
        [System.Boolean]
        $AllowGuestCreateUpdateChannels,

        [Parameter()]
        [System.Boolean]
        $AllowGuestDeleteChannels,

        [Parameter()]
        [System.Boolean]
        $Archived,

        [Parameter()]
        [System.Boolean]
        $ShowInTeamsSearchAndSuggestions,

        [Parameter()]
        [System.String]
        $Classification,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of Team $DisplayName"

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform MicrosoftTeams

    $team = Get-TargetResource @PSBoundParameters

    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("GlobalAdminAccount")
    $CurrentParameters.Remove("Ensure")

    $needToUpdate = $false
    if ($Ensure -eq "Present" -and ($team.Ensure -eq "Absent")) {
        Write-Verbose -Message "Creating team $DisplayName"
        Write-Verbose -Message "Creation Params: $(Convert-M365DscHashtableToString -Hashtable $CurrentParameters)"
        New-Team -GroupId $CurrentParameters.GroupId
        $needToUpdate = $true
    }
    elseif ($Ensure -eq "Absent" -and ($team.Ensure -eq "Present")) {
        Write-Verbose -Message "Removing team $DisplayName"
        Remove-team -GroupId $team.GroupId
    }

    if ($Ensure -eq "Present" -and $needToUpdate) {
        ## Can't pass Owner parm into set opertaion
        if ($CurrentParameters.ContainsKey("Owner")) {
            $CurrentParameters.Remove("Owner") | Out-Null
        }
        if ($CurrentParameters.ContainsKey("Archived")) {
            $CurrentParameters.Remove("Archived") | Out-Null
        }
        $CurrentParameters.Remove("Visibility") | Out-Null
        Set-Team @CurrentParameters
        Write-Verbose -Message "Updating team $DisplayName"
    }
}

function Test-TargetResource {
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
        $GroupID,

        [Parameter()]
        [System.String]
        [ValidateLength(1, 1024)]
        $Description,

        [Parameter()]
        [System.String]
        $MailNickName,

        [Parameter()]
        [System.String]
        $Owner,

        [Parameter()]
        [System.String]
        [ValidateSet("Public", "Private", "HiddenMembership")]
        $Visibility,

        [Parameter()]
        [System.Boolean]
        $AllowAddRemoveApps,

        [Parameter()]
        [System.Boolean]
        $AllowGiphy,

        [Parameter()]
        [ValidateSet("Strict", "Moderate")]
        [System.String]
        $GiphyContentRating,

        [Parameter()]
        [System.Boolean]
        $AllowStickersAndMemes,

        [Parameter()]
        [System.Boolean]
        $AllowCustomMemes,

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
        $AllowCreateUpdateRemoveConnectors,

        [Parameter()]
        [System.Boolean]
        $AllowCreateUpdateRemoveTabs,

        [Parameter()]
        [System.Boolean]
        $AllowCreateUpdateChannels,

        [Parameter()]
        [System.Boolean]
        $AllowDeleteChannels,

        [Parameter()]
        [System.Boolean]
        $AllowTeamMentions,

        [Parameter()]
        [System.Boolean]
        $AllowChannelMentions,

        [Parameter()]
        [System.Boolean]
        $AllowGuestCreateUpdateChannels,

        [Parameter()]
        [System.Boolean]
        $AllowGuestDeleteChannels,

        [Parameter()]
        [System.Boolean]
        $Archived,

        [Parameter()]
        [System.Boolean]
        $ShowInTeamsSearchAndSuggestions,

        [Parameter()]
        [System.String]
        $Classification,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of Team $DisplayName"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    If (!$PSBoundParameters.ContainsKey('Ensure')) {
        $PSBoundParameters.Add('Ensure', $Ensure)
    }
    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null
    $ValuesToCheck.Remove('GroupID') | Out-Null

    if ($null -eq $CurrentValues.Owner) {
        $ValuesToCheck.Remove("Owner") | Out-Null
    }

    $TestResult = Test-Microsoft365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $TestResult"

    return $TestResult
}

function Export-TargetResource {
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
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform MicrosoftTeams

    $teams = Get-Team
    $i = 1
    $content = ""
    $organization = $GlobalAdminAccount.UserName.Split('@')[1]
    foreach ($team in $teams) {
        Write-Information "    - [$i/$($teams.Length)] $($team.DisplayName)"
        $params = @{
            DisplayName        = $team.DisplayName
            GlobalAdminAccount = $GlobalAdminAccount
        }
        $result = Get-TargetResource @params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"

        if ("" -eq $result.Owner) {
            $result.Remove("Owner")
        }
        if ($null -eq $result.Classification) {
            $result.Remove("Classification")
        }
        $content += "        TeamsTeam " + (New-GUID).ToString() + "`r`n"
        $content += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $partialContent = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        $partialContent += "        }`r`n"
        if ($partialContent.ToLower().Contains("@" + $organization.ToLower())) {
            $partialContent = $partialContent -ireplace [regex]::Escape("@" + $organization), "@`$OrganizationName"
        }
        $content += $partialContent
        $i++
    }

    return $content
}

Export-ModuleMember -Function *-TargetResource
