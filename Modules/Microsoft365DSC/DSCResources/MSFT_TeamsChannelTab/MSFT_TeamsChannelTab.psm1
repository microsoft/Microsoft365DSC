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
        -InboundParameters $PSBoundParameters

    try
    {
        # Get the Team ID
        try
        {
            if ([System.String]::IsNullOrEmpty($TeamId))
            {
                Write-Verbose -Message "Getting team by Name {$TeamName}"
                $teamInstance = Get-Team | Where-Object -FilterScript { $_.DisplayName -eq $TeamName }
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

        $ConnectionMode = New-M365DSCConnection -Platform 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters
        # Get the Channel ID
        Write-Verbose -Message "Getting Channels for Team {$TeamName} with ID {$($teamInstance.GroupId)}"
        $channelInstance = Get-MgTeamChannel -TeamId $teamInstance.GroupId | Where-Object -FilterScript { $_.DisplayName -eq $ChannelName }

        if ($null -eq $channelInstance)
        {
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantID
            throw "Channel {$ChannelName} was not found."
        }

        # Get the Channel Tab
        Write-Verbose -Message "Getting Tabs for Channel {$ChannelName}"
        $tabInstance = Get-MgTeamChannelTab -TeamId $teamInstance.GroupId `
            -ChannelId $channelInstance.Id | Where-Object -FilterScript { $_.DisplayName -eq $DisplayName }

        if ($null -eq $tabInstance)
        {
            $nullResult = $PSBoundParameters
            $nullResult.Ensure = "Absent"
            return $nullResult
        }

        return @{
            DisplayName           = $tabInstance.DisplayName
            TeamName              = $TeamName
            TeamId                = $Team.GroupId
            ChannelName           = $channelInstance.DisplayName
            SortOrderIndex        = $tabInstance.SortOrderIndex
            WebSiteUrl            = $tabInstance.WebUrl
            TeamsApp              = $tabInstance.teamApp.id
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

    $ConnectionMode = New-M365DSCConnection -Platform 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    $tab = Get-TargetResource @PSBoundParameters

    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("Ensure") | Out-Null
    $CurrentParameters.Remove("ApplicationId") | Out-Null
    $CurrentParameters.Remove("TenantId") | Out-Null
    $CurrentParameters.Remove("CertificateThumbprint") | Out-Null

    $ChannelInstance = Get-MgTeamChannel -TeamId $tab.TeamId `
        -Filter "DisplayName eq '$ChannelName'"
    $tabInstance = Get-MgTeamChannelTab -TeamId $tab.TeamId `
        -ChannelId $ChannelInstance.Id `
        -Filter "DisplayName eq '$DisplayName'"
    if ($Ensure -eq "Present" -and ($tab.Ensure -eq "Present"))
    {
        Write-Verbose -Message "Updating current instance of tab {$($tabInstance.DisplayName)}"
        $CurrentParameters.Add("ChannelId", $ChannelInstance.Id)
        $CurrentParameters.Add("TeamsTabId", $tabInstance.Id)
        $CurrentParameters.Remove("TeamName") | Out-Null
        $CurrentParameters.Remove("ChannelName") | Out-Null
        Update-MgTeamChannelTab @CurrentParameters | Out-Null
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
        $ConnectionMode = New-M365DSCConnection -Platform 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters

        $ConnectionMode = New-M365DSCConnection -Platform 'MicrosoftTeams' `
            -InboundParameters $PSBoundParameters

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
        "teamsApp@odata.bind": "$($Parameters.TeamsApp)",
        "configuration": "{
            "websiteUrl": "$($Parameters.WebSiteUrl)",
            "contentUrl": "$($Parameters.WebSiteUrl)"
        }
    }
"@
    $Url = "https://graph.microsoft.com/v1.0/teams/$($Parameters.TeamId)/channel/$($Parameters.ChannelId)/tabs"
    Write-Verbose -Message "Creating new Teams Tab with JSON payload: `r`n$JSONContent"
    Write-Verbose -Message "POST to {$Url}"
    Invoke-MgGraphRequest -Method POST `
        -Uri $Url `
        -Body $JSONContent `
        -Headers @{"Content-Type" = "application/json" } | Out-Null
}

Export-ModuleMember -Function *-TargetResource
