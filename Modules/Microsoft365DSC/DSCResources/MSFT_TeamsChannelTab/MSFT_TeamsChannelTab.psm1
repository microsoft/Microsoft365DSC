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

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateLength(1, 256)]
        $TeamName,

        [Parameter()]
        [System.String]
        [ValidateLength(1, 256)]
        $ChannelName,

        [Parameter()]
        [System.String]
        $TeamId,

        [Parameter()]
        [System.String]
        $ContentUrl,

        [Parameter()]
        [System.String]
        $WebSiteUrl,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.String]
        $ApplicationId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $TenantId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CertificateThumbprint
    )
    Write-Verbose -Message "Getting configuration of Team $DisplayName"

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"

    Write-Verbose -Message "Checking for existence of Team $DisplayName"

    $ConnectionMode = New-M365DSCConnection -Platform 'MicrosoftGraphBeta' `
        -InboundParameters $PSBoundParameters

    try
    {
        # Get the Team ID
        try
        {
            if ($null -eq $TeamId)
            {
                $teamInstance = get-MgGroup -filter "displayName eq '$TeamName' and resourceProvisioningOptions/Any(x:x eq 'Team')" -ErrorAction Stop | %{ @{ TeamId=$_.Id } } | get-MgTeam -ErrorAction Stop
            }
            else
            {
                $teamInstance = get-MgTeam -TeamId $TeamId -ErrorAction Stop
            }
        }
        catch
        {
            Write-Host "            $($Global:M365DSCEmojiRedX) The specified Service Principal doesn't have access to read Group information. Permission Required: Group.Read.All & Team.ReadBasic.All"
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId
        }

        if ($null -eq $teamInstance)
        {
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantID
            throw "Team {$TeamName} was not found."
        }

        # Get the Channel ID
        $channelInstance = Get-MgTeamChannel -TeamId $teamInstance.Id | Where-Object -FilterScript {$_.DisplayName -eq $ChannelName}

        if ($null -eq $channelInstance)
        {
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantID
            throw "Channel {$ChannelName} was not found."
        }

        # Get the Channel Tab
        $tabInstance = Get-MgTeamChannelTab -TeamId $teamInstance.Id `
            -ChannelId $channelInstance.Id | Where-Object -FilterScript {$_.DisplayName -eq $DisplayName}

        if ($null -eq $tabInstance)
        {
            $nullResult = $PSBoundParameters
            $nullResult.Ensure = "Present"
            return $nullResult
        }

        return @{
            DisplayName           = $DisplayName
            TeamName              = $TeamName
            ChannelName           = $ChannelName
            ContentUrl            = $ContentUrl
            WebSiteUrl            = $WebSiteUrl
            ApplicationId         = $ApplicationId
            TenantId              = $TenantID
            CertificateThumbprint = $CertificateThumbprint
        }
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $GlobalAdminAccount)
            {
                $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        throw $_
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
        $GroupID,

        [Parameter()]
        [System.String]
        [ValidateLength(1, 1024)]
        $Description,

        [Parameter()]
        [System.String]
        $MailNickName,

        [Parameter()]
        [System.String[]]
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
        $ShowInTeamsSearchAndSuggestions,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of Team $DisplayName"

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'MicrosoftTeams' -InboundParameters $PSBoundParameters

    $team = Get-TargetResource @PSBoundParameters

    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("Ensure")

    if ($Ensure -eq "Present" -and ($team.Ensure -eq "Present"))
    {
        ## Can't pass Owner parm into set opertaion
        if ($CurrentParameters.ContainsKey("Owner"))
        {
            $CurrentParameters.Remove("Owner")
        }
        if (-not $CurrentParameters.ContainsKey("GroupID"))
        {
            $CurrentParameters.Add("GroupID", $team.GroupID)
        }
        if ($ConnectionMode -eq 'Credential')
        {
            $CurrentParameters.Remove("GlobalAdminAccount")
        }
        else
        {
            $CurrentParameters.Remove("ApplicationId")
            $CurrentParameters.Remove("TenantId")
            $CurrentParameters.Remove("CertificateThumbprint")
        }
        Set-Team @CurrentParameters
        Write-Verbose -Message "Updating team $DisplayName"
    }
    elseif ($Ensure -eq "Present" -and ($team.Ensure -eq "Absent"))
    {
        ## GroupID not used on New-Team cmdlet
        if ($CurrentParameters.ContainsKey("GroupID"))
        {
            $CurrentParameters.Remove("GroupID")
        }
        Write-Verbose -Message "Creating team $DisplayName"
        if ($null -ne $Owner)
        {
            $CurrentParameters.Owner = ([array]$Owner[0]).ToString()
        }

        if ($ConnectionMode -eq "ServicePrincipal")
        {
            $ConnectionMode = New-M365DSCConnection -Platform 'AzureAD' `
                -InboundParameters $PSBoundParameters
            $group = New-AzureADMSGroup -DisplayName $DisplayName -GroupTypes "Unified" -MailEnabled $true -SecurityEnabled $true -MailNickname $MailNickName
            $currentOwner = (($CurrentParameters.Owner)[0])

            Write-Verbose -Message "Retrieving Group Owner {$currentOwner}"
            $ownerUser = Get-AzureADUser -SearchString $currentOwner

            Write-Verbose -Message "Adding Owner {$($ownerUser.ObjectId)} to Group {$($group.Id)}"
            try
            {
                Add-AzureADGroupOwner -ObjectId $group.Id -RefObjectId $ownerUser.ObjectId -ErrorAction Stop
            }
            catch
            {
                Write-Verbose -Message "Adding Owner - Sleeping for 15 seconds"
                Start-Sleep -Seconds 15
                Add-AzureADGroupOwner -ObjectId $group.Id -RefObjectId $ownerUser.ObjectId
            }

            try
            {
                New-Team -GroupId $group.Id -ErrorAction Stop
            }
            catch
            {
                Write-Verbose -Message "Creating Team - Sleeping for 15 seconds"
                Start-Sleep -Seconds 15
                New-Team -GroupId $group.Id
            }
        }
        else
        {
            $CurrentParameters.Remove("GlobalAdminAccount")
            New-Team @CurrentParameters
        }
    }
    elseif ($Ensure -eq "Absent" -and ($team.Ensure -eq "Present"))
    {
        Write-Verbose -Message "Removing team $DisplayName"
        Remove-Team -GroupId $team.GroupId
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
        $GroupID,

        [Parameter()]
        [System.String]
        [ValidateLength(1, 1024)]
        $Description,

        [Parameter()]
        [System.String]
        $MailNickName,

        [Parameter()]
        [System.String[]]
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
        $ShowInTeamsSearchAndSuggestions,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of Team $DisplayName"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    If (!$PSBoundParameters.ContainsKey('Ensure'))
    {
        $PSBoundParameters.Add('Ensure', $Ensure)
    }
    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null
    $ValuesToCheck.Remove('GroupID') | Out-Null

    if ($null -eq $CurrentValues.Owner)
    {
        $ValuesToCheck.Remove("Owner") | Out-Null
    }

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $TestResult"

    return $TestResult
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        $ConnectionMode = New-M365DSCConnection -Platform 'MicrosoftGraphBeta' `
            -InboundParameters $PSBoundParameters
            
        [array]$teams = get-mggroup -filter "resourceProvisioningOptions/Any(x:x eq 'Team')"
        $i = 1
        $dscContent = ""
        Write-Host "`r`n" -NoNewline
        foreach ($team in $teams)
        {
            Write-Host "    |---[$i/$($teams.Length)] $($team.DisplayName)"

            $channels = $null
            try
            {
                [array]$channels = Get-MgTeamChannel -TeamId $team.Id -ErrorAction Stop
            }
            catch
            {
                Write-Host "        $($Global:M365DSCEmojiRedX) The specified Service Principal doesn't have access to read Channel information. Permission Required: Channel.ReadBasic.All"
                Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                    -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                    -TenantId $TenantId
            }

            $j = 1
            foreach ($channel in $channels)
            {
                Write-Host "        |---[$j/$($channels.Length)] $($channel.DisplayName)"

                $tabs = $null
                try
                {
                    [array]$tabs = Get-MgTeamChannelTab -TeamId $team.Id `
                        -ChannelId $channel.Id -ErrorAction Stop
                }
                catch
                {
                    Write-Host "            $($Global:M365DSCEmojiRedX) The specified Service Principal doesn't have access to read Tab information. Permission Required: TeamsTab.Read.All"
                    Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                        -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                        -TenantId $TenantId
                }

                $k =1
                foreach ($tab in $tabs)
                {
                    Write-Host "            |---[$k/$($tabs.Length)] $($tab.DisplayName)" -NoNewline
                    $params = @{
                        TeamName              = $team.DisplayName
                        TeamId                = $team.Id
                        ChannelName           = $channel.DisplayName
                        DisplayName           = $tab.DisplayName
                        ApplicationId         = $ApplicationId
                        TenantId              = $TenantId
                        CertificateThumbprint = $CertificateThumbprint
                    }
                    $Results = Get-TargetResource @params

                    if ($null -ne $Results)
                    {
                        $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                            -Results $Results
                        $dscContent += Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                            -ConnectionMode $ConnectionMode `
                            -ModulePath $PSScriptRoot `
                            -Results $Results
                    }
                    Write-Host $Global:M365DSCEmojiGreenCheckmark
                    $k++
                }
                $j++
            }
            $i++
        }

        return $dscContent
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return ""
    }
}

Export-ModuleMember -Function *-TargetResource
