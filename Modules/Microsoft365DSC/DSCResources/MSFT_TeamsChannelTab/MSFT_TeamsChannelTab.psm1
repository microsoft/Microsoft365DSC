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

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateLength(1, 256)]
        $ChannelName,

        [Parameter()]
        [System.String]
        $TeamId,

        [Parameter()]
        [System.String]
        $TeamsApp,

        [Parameter()]
        [System.UInt32]
        $SortOrderIndex,

        [Parameter()]
        [System.String]
        $WebSiteUrl,

        [Parameter()]
        [System.String]
        $EntityId,

        [Parameter()]
        [System.String]
        $ContentUrl,

        [Parameter()]
        [System.String]
        $RemoveUrl,

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
        $CertificateThumbprint,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    Write-Verbose -Message "Getting configuration of Tab $DisplayName"

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

    $ConnectionMode = New-M365DSCConnection -Platform 'MicrosoftTeams' `
        -InboundParameters @{GlobalAdminAccount = $GlobalAdminAccount}

    $ConnectionMode = New-M365DSCConnection -Platform 'MicrosoftGraph' `
        -InboundParameters @{
            ApplicationId = $ApplicationId;
            TenantId = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
    }

    try
    {
        # Get the Team ID
        try
        {
            if ([System.String]::IsNullOrEmpty($TeamId))
            {
                Write-Verbose -Message "Getting team by Name {$TeamName}"
                [array]$teamInstance = Get-Team | Where-Object -FilterScript { $_.DisplayName -eq $TeamName }
                if ($teamInstance.Length -gt 1)
                {
                    throw "Multiple Teams with name {$TeamName} were found. Please specify TeamId in your configuration instead."
                }
            }
            else
            {
                Write-Verbose -Message "Getting team by Id {$TeamId}"
                $teamInstance = Get-Team -GroupId $TeamId -ErrorAction Stop
            }
        }
        catch
        {
            Write-Verbose -Message $_
            Write-Verbose "The specified Service Principal doesn't have access to read Group information. Permission Required: Group.Read.All & Team.ReadBasic.All"
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId
        }

        if ($null -eq $teamInstance)
        {
            $Message = "Team {$TeamName} was not found."
            Add-M365DSCEvent -Message $Message -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantID
            throw $Message
        }

        $nullReturn.TeamId = $teamInstance.GroupId


        $ConnectionMode = New-M365DSCConnection -Platform 'MicrosoftGraph' `
            -InboundParameters @{
                ApplicationId = $ApplicationId;
                TenantId = $TenantId;
                CertificateThumbprint = $CertificateThumbprint;
        }
        # Get the Channel ID
        Write-Verbose -Message "Getting Channels for Team {$TeamName} with ID {$($teamInstance.GroupId)}"
        $channelInstance = Get-MgTeamChannel -TeamId $teamInstance.GroupId | Where-Object -FilterScript { $_.DisplayName -eq $ChannelName }

        if ($null -eq $channelInstance)
        {
            Add-M365DSCEvent -Message "Could not find Channels for Team {$($teamInstance.GroupId)}" -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantID
            throw "Channel {$ChannelName} was not found."
        }

        # Get the Channel Tab
        Write-Verbose -Message "Getting Tabs for Channel {$ChannelName}"
        [array]$tabInstance = Get-M365DSCTeamChannelTab -TeamId $teamInstance.GroupId `
            -ChannelId $channelInstance.Id `
            -DisplayName $DisplayName

        if ($tabInstance.Length -gt 1)
        {
            Write-warning "More than one instance of a tab with name {$DisplayName} was found."
            $tabInstance = $tabInstance[0]
        }

        if ($null -eq $tabInstance)
        {
            $nullResult = $PSBoundParameters
            $nullResult.Ensure = "Absent"
            return $nullResult
        }

        return @{
            DisplayName           = $tabInstance.DisplayName
            TeamName              = $TeamName
            TeamId                = $teamInstance.GroupId
            ChannelName           = $channelInstance.DisplayName
            SortOrderIndex        = $tabInstance.SortOrderIndex
            WebSiteUrl            = $tabInstance.configuration.websiteUrl
            ContentUrl            = $tabInstance.configuration.contentUrl
            RemoveUrl             = $tabInstance.configuration.removeUrl
            EntityId              = $tabInstance.configuration.entityId
            TeamsApp              = $tabInstance.teamsApp.id
            ApplicationId         = $ApplicationId
            TenantId              = $TenantID
            CertificateThumbprint = $CertificateThumbprint
            Ensure                = "Present"
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

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateLength(1, 256)]
        $TeamName,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateLength(1, 256)]
        $ChannelName,

        [Parameter()]
        [System.String]
        $TeamId,

        [Parameter()]
        [System.String]
        $TeamsApp,

        [Parameter()]
        [System.UInt32]
        $SortOrderIndex,

        [Parameter()]
        [System.String]
        $WebSiteUrl,

        [Parameter()]
        [System.String]
        $EntityId,

        [Parameter()]
        [System.String]
        $ContentUrl,

        [Parameter()]
        [System.String]
        $RemoveUrl,

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
        $CertificateThumbprint,

        [Parameter(Mandatory = $true)]
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

    $ConnectionMode = New-M365DSCConnection -Platform 'MicrosoftTeams' `
        -InboundParameters @{GlobalAdminAccount = $GlobalAdminAccount}

    $ConnectionMode = New-M365DSCConnection -Platform 'MicrosoftGraph' `
        -InboundParameters @{
            ApplicationId = $ApplicationId;
            TenantId = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
    }

    $tab = Get-TargetResource @PSBoundParameters

    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("Ensure") | Out-Null
    $CurrentParameters.Remove("ApplicationId") | Out-Null
    $CurrentParameters.Remove("TenantId") | Out-Null
    $CurrentParameters.Remove("CertificateThumbprint") | Out-Null
    $CurrentParameters.Remove("GlobalAdminAccount") | Out-Null

    Write-Verbose -Message "Retrieving Team Channel {$ChannelName} from Team {$($tab.TeamId)}"
    $ChannelInstance = Get-MgTeamChannel -TeamId $tab.TeamId `
        -Filter "DisplayName eq '$ChannelName'"

    if ($Ensure -eq "Present" -and ($tab.Ensure -eq "Present"))
    {
        Write-Verbose -Message "Retrieving Tab {$DisplayName} from Channel {$($ChannelInstance.Id))} from Team {$($tab.TeamId)}"
        $tabInstance = Get-M365DSCTeamChannelTab -TeamId $tab.TeamId `
            -ChannelId $ChannelInstance.Id `
            -DisplayName $DisplayName

        Set-M365DSCTeamsChannelTab -Parameters $CurrentParameters `
            -TabId $tabInstance.Id | Out-Null
    }
    elseif ($Ensure -eq "Present" -and ($tab.Ensure -eq "Absent"))
    {
        Write-Verbose -Message "Creating new tab {$DisplayName}"
        Write-Verbose -Message "Params: $($CurrentParameters | Out-String)"
        $CurrentParameters.Add("TeamsId", $tab.TeamId)
        $CurrentParameters.Add("ChannelId", $ChannelInstance.Id)
        $CurrentParameters.Remove("TeamName") | Out-Null
        $CurrentParameters.Remove("ChannelName") | Out-Null
        New-M365DSCTeamsChannelTab -Parameters $CurrentParameters
    }
    elseif ($Ensure -eq "Absent" -and ($tab.Ensure -eq "Present"))
    {
        Write-Verbose -Message "Retrieving Tab {$DisplayName} from Channel {$($ChannelInstance.Id))} from Team {$($tab.TeamId)}"
        $tabInstance = Get-M365DSCTeamChannelTab -TeamId $tab.TeamId `
            -ChannelId $ChannelInstance.Id `
            -DisplayName $DisplayName
        Write-Verbose -Message "Removing existing tab {$DisplayName}"
        $RemoveParams = @{
            ChannelId  = $ChannelInstance.Id
            TeamId     = $tab.TeamId
            TeamsTabId = $tabInstance.Id
        }
        Remove-MgTeamChannelTab @RemoveParams | Out-Null
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

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateLength(1, 256)]
        $TeamName,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateLength(1, 256)]
        $ChannelName,

        [Parameter()]
        [System.String]
        $TeamId,

        [Parameter()]
        [System.String]
        $TeamsApp,

        [Parameter()]
        [System.UInt32]
        $SortOrderIndex,

        [Parameter()]
        [System.String]
        $WebSiteUrl,

        [Parameter()]
        [System.String]
        $EntityId,

        [Parameter()]
        [System.String]
        $ContentUrl,

        [Parameter()]
        [System.String]
        $RemoveUrl,

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
        $CertificateThumbprint,

        [Parameter(Mandatory = $true)]
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

    Write-Verbose -Message "Testing configuration of Tab $DisplayName"
    Write-Verbose -Message "Parameters: $($PSBoundParameters | Out-String)"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('CertificateThumbprint') | Out-Null
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

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
        $ConnectionMode = New-M365DSCConnection -Platform 'MicrosoftTeams' `
        -InboundParameters @{GlobalAdminAccount = $GlobalAdminAccount}

        $ConnectionMode = New-M365DSCConnection -Platform 'MicrosoftGraph' `
            -InboundParameters @{
                ApplicationId = $ApplicationId;
                TenantId = $TenantId;
                CertificateThumbprint = $CertificateThumbprint;
        }

        [array]$teams = Get-Team
        $i = 1
        $dscContent = ""
        Write-Host "`r`n" -NoNewline
        foreach ($team in $teams)
        {
            Write-Host "    |---[$i/$($teams.Length)] $($team.DisplayName)"

            $channels = $null
            try
            {
                [array]$channels = Get-MgTeamChannel -TeamId $team.GroupId -ErrorAction Stop
            }
            catch
            {
		Write-Host $_
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
                    [array]$tabs = Get-MgTeamChannelTab -TeamId $team.GroupId `
                        -ChannelId $channel.Id -ErrorAction Stop
                }
                catch
                {
                    Write-Host "            $($Global:M365DSCEmojiRedX) The specified Service Principal doesn't have access to read Tab information. Permission Required: TeamsTab.Read.All"
                    Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                        -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                        -TenantId $TenantId
                }

                $k = 1
                foreach ($tab in $tabs)
                {
                    Write-Host "            |---[$k/$($tabs.Length)] $($tab.DisplayName)" -NoNewline
                    $params = @{
                        TeamName              = $team.DisplayName
                        TeamId                = $team.GroupId
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

function New-M365DSCTeamsChannelTab
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.Collections.HashTable]
        $Parameters
    )

    $jsonContent = @"
    {
        "displayName": "$($Parameters.DisplayName)",
        "teamsApp@odata.bind": "https://graph.microsoft.com/v1.0/appCatalogs/teamsApps/$($Parameters.TeamsApp)",
        "sortOrderIndex": "$($Parameters.SortOrderIndex)",
        "configuration": {
            "websiteUrl": "$($Parameters.WebSiteUrl)",
            "contentUrl": "$($Parameters.ContentUrl)",
            "removeURL": "$($Parameters.RemoveUrl)",
            "entityId": "$($Parameters.EntityId)"
        }
    }
"@
    $Url = "https://graph.microsoft.com/beta/teams/$($Parameters.TeamId)/channels/$($Parameters.ChannelId)/tabs"
    Write-Verbose -Message "Creating new Teams Tab with JSON payload: `r`n$JSONContent"
    Write-Verbose -Message "POST to {$Url}"
    Invoke-MgGraphRequest -Method POST `
        -Uri $Url `
        -Body $JSONContent `
        -Headers @{"Content-Type" = "application/json" } | Out-Null
}

function Set-M365DSCTeamsChannelTab
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.Collections.HashTable]
        $Parameters,

        [Parameter(Mandatory = $true)]
        [System.String]
        $TabID
    )

    $jsonContent = @"
    {
        "displayName": "$($Parameters.DisplayName)",
        "sortOrderIndex": "$($Parameters.SortOrderIndex)",
        "configuration": {
            "websiteUrl": "$($Parameters.WebSiteUrl)",
            "contentUrl": "$($Parameters.ContentUrl)",
            "removeURL": "$($Parameters.RemoveUrl)",
            "entityId": "$($Parameters.EntityId)"
        }
    }
"@
    $Url = "https://graph.microsoft.com/beta/teams/$($Parameters.TeamId)/channels/$($Parameters.ChannelId)/tabs/$tabId"
    Write-Verbose -Message "Updating Teams Tab with JSON payload: `r`n$JSONContent"
    Write-Verbose -Message "PATCH to {$Url}"
    Invoke-MgGraphRequest -Method PATCH `
        -Uri $Url `
        -Body $JSONContent `
        -Headers @{"Content-Type" = "application/json" } | Out-Null
}

function Get-M365DSCTeamChannelTab
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $TeamID,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ChannelId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName
    )

    $Url = "https://graph.microsoft.com/beta/teams/$TeamID/channels/$ChannelId/tabs?Expand=teamsApp&Filter=displayName eq '$($DisplayName.Replace("'","''"))'"
    Write-Verbose -Message "Retrieving tab with TeamsID {$TeamID} ChannelID {$ChannelID} DisplayName {$DisplayName}"
    Write-Verbose -Message "GET request to {$Url}"
    $response = Invoke-MgGraphRequest -Method GET `
        -Uri $Url `
        -Headers @{"Content-Type" = "application/json" }
    return $response.value
}

Export-ModuleMember -Function *-TargetResource
