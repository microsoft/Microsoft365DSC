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
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )
    Write-Verbose -Message "Getting configuration of Tab $DisplayName"

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = @{
        DisplayName = $DisplayName
        TeamName    = $TeamName
        ChannelName = $ChannelName
        Ensure      = "Absent"
    }

    try
    {
        # Get the Team ID
        try
        {
            if ([System.String]::IsNullOrEmpty($TeamId))
            {
                Write-Verbose -Message "Getting team by Name {$TeamName}"
                [array]$teamInstance = Get-MgGroup -Filter "resourceProvisioningOptions/Any(x:x eq 'Team') and DisplayName eq '$TeamName'" -All
                if ($teamInstance.Length -gt 1)
                {
                    throw "Multiple Teams with name {$TeamName} were found. Please specify TeamId in your configuration instead."
                }
            }
            else
            {
                Write-Verbose -Message "Getting team by Id {$TeamId}"
                $teamInstance = Get-MgBetaTeam -TeamId $TeamId -ErrorAction Stop
            }
        }
        catch
        {
            New-M365DSCLogEntry -Message 'Error retrieving data:' `
                -Exception $_ `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential

            Write-Verbose "The specified Service Principal doesn't have access to read Group information. Permission Required: Group.Read.All & Team.ReadBasic.All"
        }

        if ($null -eq $teamInstance)
        {
            $Message = "Team {$TeamName} was not found."
            New-M365DSCLogEntry -Message $Message `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential

            throw $Message
        }

        # Get the Channel ID
        Write-Verbose -Message "Getting Channels for Team {$TeamName} with ID {$($teamInstance.Id)}"
        $channelInstance = Get-MgBetaTeamChannel -TeamId $teamInstance.Id | Where-Object -FilterScript { $_.DisplayName -eq $ChannelName }

        if ($null -eq $channelInstance)
        {
            $message = "Could not find Channel {$ChannelName} for Team {$($teamInstance.Id)}"
            New-M365DSCLogEntry -Message $Message `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential

            throw $message
        }

        # Get the Channel Tab
        Write-Verbose -Message "Getting Tabs for Channel {$ChannelName}"
        [array]$tabInstance = Get-MgBetaTeamChannelTab -TeamId $teamInstance.Id `
            -ChannelId $channelInstance.Id `
            -Filter "DisplayName eq '$DisplayName'" `
            -ExpandProperty 'TeamsApp'

        if ($tabInstance.Length -gt 1)
        {
            throw "More than one instance of a tab with name {$DisplayName} was found."
        }

        if ($null -eq $tabInstance)
        {
            $nullReturn.Ensure = 'Absent'
            $nullReturn.TeamId = $teamInstance.Id
            return $nullReturn
        }

        return @{
            DisplayName           = $tabInstance.DisplayName
            TeamName              = $TeamName
            TeamId                = $teamInstance.Id
            ChannelName           = $channelInstance.DisplayName
            SortOrderIndex        = $tabInstance.SortOrderIndex
            WebSiteUrl            = $tabInstance.configuration.websiteUrl
            ContentUrl            = $tabInstance.configuration.contentUrl
            RemoveUrl             = $tabInstance.configuration.removeUrl
            EntityId              = $tabInstance.configuration.entityId
            TeamsApp              = $tabInstance.teamsApp.id
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantID
            CertificateThumbprint = $CertificateThumbprint
            Ensure                = 'Present'
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
        }
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

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
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Setting configuration of Team $DisplayName"

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    $tab = Get-TargetResource @PSBoundParameters

    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove('Ensure') | Out-Null
    $CurrentParameters.Remove('ApplicationId') | Out-Null
    $CurrentParameters.Remove('TenantId') | Out-Null
    $CurrentParameters.Remove('CertificateThumbprint') | Out-Null
    $CurrentParameters.Remove('Credential') | Out-Null
    $CurrentParameters.Remove('ManagedIdentity') | Out-Null
    $CurrentParameters.Remove('AccessTokens') | Out-Null

    Write-Verbose -Message "Retrieving Team Channel {$ChannelName} from Team {$($tab.TeamId)}"
    $ChannelInstance = Get-MgBetaTeamChannel -TeamId $tab.TeamId `
        -Filter "DisplayName eq '$ChannelName'"

    $configuration = @{}

    if (-not [System.String]::IsNullOrEmpty($ContentUrl))
    {
        $configuration.Add('ContentUrl', $ContentUrl)
    }
    if (-not [System.String]::IsNullOrEmpty($EntityId))
    {
        $configuration.Add('EntityId', $EntityId)
    }
    if (-not [System.String]::IsNullOrEmpty($RemoveUrl))
    {
        $configuration.Add('RemoveUrl', $RemoveUrl)
    }
    if (-not [System.String]::IsNullOrEmpty($WebSiteUrl))
    {
        $configuration.Add('WebSiteUrl', $WebSiteUrl)
    }
    $CurrentParameters.Add('Configuration', $configuration)
    $CurrentParameters.Remove('ContentUrl') | Out-Null
    $CurrentParameters.Remove('EntityId') | Out-Null
    $CurrentParameters.Remove('RemoveUrl') | Out-Null
    $CurrentParameters.Remove('WebSiteUrl') | Out-Null
    $CurrentParameters.Remove('TeamsApp') | Out-Null

    if ($Ensure -eq 'Present' -and ($tab.Ensure -eq 'Present'))
    {
        Write-Verbose -Message "Retrieving Tab {$DisplayName} from Channel {$($ChannelInstance.Id))} from Team {$($tab.TeamId)}"
        $tabInstance = Get-MgBetaTeamChannelTab -TeamId $tab.TeamId `
            -ChannelId $ChannelInstance.Id `
            -Filter "DisplayName eq '$DisplayName'"

        $CurrentParameters.TeamId = $tab.TeamId
        $CurrentParameters.Add('ChannelId', $ChannelInstance.Id)
        $CurrentParameters.Remove('TeamName') | Out-Null
        $CurrentParameters.Remove('ChannelName') | Out-Null
        $CurrentParameters.Add('TeamsTabId', $tabInstance.Id)
        Write-Verbose -Message "Params: $($CurrentParameters | Out-String)"
        Update-MgBetaTeamChannelTab  @CurrentParameters | Out-Null
    }
    elseif ($Ensure -eq 'Present' -and ($tab.Ensure -eq 'Absent'))
    {
        Write-Verbose -Message "Creating new tab {$DisplayName}"
        $CurrentParameters.TeamId = $tab.TeamId
        $CurrentParameters.Add('ChannelId', $ChannelInstance.Id)
        $CurrentParameters.Remove('TeamName') | Out-Null
        $CurrentParameters.Remove('ChannelName') | Out-Null
        Write-Verbose -Message "Params: $($CurrentParameters | Out-String)"

        $additionalProperties = @{
            'teamsApp@odata.bind' = "https://graph.microsoft.com/v1.0/appCatalogs/teamsApps/$TeamsApp"
        }
        $CurrentParameters.Add('AdditionalProperties', $additionalProperties)

        New-MgBetaTeamChannelTab @CurrentParameters
    }
    elseif ($Ensure -eq 'Absent' -and ($tab.Ensure -eq 'Present'))
    {
        Write-Verbose -Message "Retrieving Tab {$DisplayName} from Channel {$($ChannelInstance.Id))} from Team {$($tab.TeamId)}"
        $tabInstance = Get-MgBetaTeamChannelTab -TeamId $tab.TeamId `
            -ChannelId $ChannelInstance.Id `
            -Filter "DisplayName eq '$DisplayName'"
        Write-Verbose -Message "Removing existing tab {$DisplayName}"
        $RemoveParams = @{
            ChannelId  = $ChannelInstance.Id
            TeamId     = $tab.TeamId
            TeamsTabId = $tabInstance.Id
        }
        Remove-MgBetaTeamChannelTab @RemoveParams | Out-Null
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
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of Tab $DisplayName"
    Write-Verbose -Message "Parameters: $($PSBoundParameters | Out-String)"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters

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
        $Credential,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        [array]$teams = Get-MgGroup -Filter "resourceProvisioningOptions/Any(x:x eq 'Team')" -All
        $i = 1
        $dscContent = ''
        Write-Host "`r`n" -NoNewline
        foreach ($team in $teams)
        {
            Write-Host "    |---[$i/$($teams.Length)] $($team.DisplayName)"

            $channels = $null
            try
            {
                [array]$channels = Get-MgBetaTeamChannel -TeamId $team.Id -ErrorAction Stop
            }
            catch
            {
                $message = "        $($Global:M365DSCEmojiRedX) The specified Service Principal doesn't have access to read Channel information. Permission Required: Channel.ReadBasic.All"
                New-M365DSCLogEntry -Message $Message `
                    -Source $($MyInvocation.MyCommand.Source) `
                    -TenantId $TenantId `
                    -Credential $Credential
            }

            $j = 1
            foreach ($channel in $channels)
            {
                Write-Host "        |---[$j/$($channels.Length)] $($channel.DisplayName)"

                $tabs = $null
                try
                {
                    [array]$tabs = Get-MgBetaTeamChannelTab -TeamId $team.Id `
                        -ChannelId $channel.Id -ErrorAction Stop
                }
                catch
                {
                    $message = "            $($Global:M365DSCEmojiRedX) The specified Service Principal doesn't have access to read Tab information. Permission Required: TeamsTab.Read.All"
                    New-M365DSCLogEntry -Message $Message `
                        -Source $($MyInvocation.MyCommand.Source) `
                        -TenantId $TenantId `
                        -Credential $Credential
                }

                $k = 1
                foreach ($tab in $tabs)
                {
                    if ($null -ne $Global:M365DSCExportResourceInstancesCount)
                    {
                        $Global:M365DSCExportResourceInstancesCount++
                    }

                    Write-Host "            |---[$k/$($tabs.Length)] $($tab.DisplayName)" -NoNewline
                    $params = @{
                        TeamName              = $team.DisplayName
                        TeamId                = $team.Id
                        ChannelName           = $channel.DisplayName
                        DisplayName           = $tab.DisplayName
                        Credential            = $Credential
                        ApplicationId         = $ApplicationId
                        TenantId              = $TenantId
                        CertificateThumbprint = $CertificateThumbprint
                        ManagedIdentity       = $ManagedIdentity.IsPresent
                        AccessTokens          = $AccessTokens
                    }
                    $Results = Get-TargetResource @params

                    if ($Results -is [System.Collections.Hashtable] -and $Results.Count -gt 3)
                    {
                        $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                            -Results $Results
                        $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                            -ConnectionMode $ConnectionMode `
                            -ModulePath $PSScriptRoot `
                            -Results $Results `
                            -Credential $Credential

                        $dscContent += $currentDSCBlock
                        Save-M365DSCPartialExport -Content $currentDSCBlock `
                            -FileName $Global:PartialExportFileName

                        Write-Host $Global:M365DSCEmojiGreenCheckmark
                    }
                    else
                    {
                        Write-Host $Global:M365DSCEmojiRedX
                    }
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
        Write-Host $Global:M365DSCEmojiRedX

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
