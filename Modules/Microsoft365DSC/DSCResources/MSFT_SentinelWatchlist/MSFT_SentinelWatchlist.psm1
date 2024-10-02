function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $SubscriptionId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ResourceGroupName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $WorkspaceName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $SourceType,

        [Parameter()]
        [System.String]
        $ItemsSearchKey,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DefaultDuration,

        [Parameter()]
        [System.String]
        $Alias,

        [Parameter()]
        [System.Uint32]
        $NumberOfLinesToSkip,

        [Parameter()]
        [System.String]
        $RawContent,

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

    New-M365DSCConnection -Workload 'Azure' `
        -InboundParameters $PSBoundParameters | Out-Null

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullResult = $PSBoundParameters
    $nullResult.Ensure = 'Absent'
    try
    {
        if ([System.String]::IsNullOrEmpty($TenantId) -and $null -ne $Credential)
        {
            $TenantId = $Credential.UserName.Split('@')[1]
        }

        Write-Verbose -Message "Retrieving watchlist {$Name}"
        if ($null -ne $Script:exportedInstances -and $Script:ExportMode)
        {
            if (-not [System.String]::IsNullOrEmpty($Id))
            {
                $instance = $Script:exportedInstances | Where-Object -FilterScript {$_.properties.watchListId -eq $Id}
            }

            if ($null -eq $instance)
            {
                $instance = $Script:exportedInstances | Where-Object -FilterScript {$_.name -eq $Name}
            }
        }
        else
        {
            $watchLists = Get-M365DSCSentinelWatchlist -SubscriptionId $SubscriptionId `
                                                       -ResourceGroupName $ResourceName `
                                                       -WorkspaceName $workspaceName `
                                                       -TenantId $TenantId

            if (-not [System.String]::IsNullOrEmpty($Id))
            {
                $instance = $watchLists | Where-Object -FilterScript {$_.properties.watchListId -eq $Id}
            }

            if ($null -eq $instance)
            {
                $instance = $watchLists | Where-Object -FilterScript {$_.name -eq $Name}
            }
        }
        if ($null -eq $instance)
        {
            Write-Verbose -Message "Watchlist {$Name} was not found"
            return $nullResult
        }

        Write-Verbose -Message "Found watchlist {$Name}"
        $results = @{
            SubscriptionId        = $SubscriptionId
            ResourceGroupName     = $ResourceGroupName
            WorkspaceName         = $WorkspaceName
            Name                  = $instance.Name
            Id                    = $instance.properties.watchlistId
            DisplayName           = $instance.properties.displayName
            SourceType            = $instance.properties.sourceType
            ItemsSearchKey        = $instance.properties.itemsSearchKey
            Description           = $instance.properties.description
            DefaultDuration       = $instance.properties.defaultDuration
            Alias                 = $instance.properties.watchListAlias
            NumberOfLinesToSkip   = $instance.properties.numberOfLinesToSkip
            RawContent            = $RawContent
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
        }
        return [System.Collections.Hashtable] $results
    }
    catch
    {
        Write-Verbose -Message $_
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $nullResult
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $SubscriptionId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ResourceGroupName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $WorkspaceName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $SourceType,

        [Parameter()]
        [System.String]
        $ItemsSearchKey,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DefaultDuration,

        [Parameter()]
        [System.String]
        $Alias,

        [Parameter()]
        [System.Uint32]
        $NumberOfLinesToSkip,

        [Parameter()]
        [System.String]
        $RawContent,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    if ([System.String]::IsNullOrEmpty($TenantId) -and $null -ne $Credential)
    {
        $TenantId = $Credential.UserName.Split('@')[1]
    }

    $body = @{
        properties = @{
            displayName         = $DisplayName
            provider            = "Microsoft"
            itemsSearchKey      = $ItemsSearchKey
            sourceType          = $SourceType
            description         = $Description
            defaultDuration     = $defaultDuration
            numberOfLinesToSkip = $NumberOfLinesToSkip
            watchListAlias      = $Alias
        }
    }

    if ($null -ne $RawContent)
    {
        Write-Verbose -Message "Adding rawContent and contentType to the payload"
        $body.properties.Add('rawContent', $RawContent)
        $body.properties.Add('contentType', 'text/csv')
    }

    # CREATE & UPDATE
    if ($Ensure -eq 'Present')
    {
        Write-Verbose -Message "Configuring watchlist {$Name}"
        Set-M365DSCSentinelWatchlist -SubscriptionId $SubscriptionId `
                                     -ResourceGroupName $ResourceGroupName `
                                     -WorkspaceName $WorkspaceName `
                                     -WatchListAlias $Alias `
                                     -Body $body `
                                     -TenantId $TenantId
    }
    # REMOVE
    elseif ($Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Removing watchlist {$Name}"
        Remove-M365DSCSentinelWatchlist -SubscriptionId $SubscriptionId `
                                        -ResourceGroupName $ResourceGroupName `
                                        -WorkspaceName $WorkspaceName `
                                        -WatchListAlias $Alias `
                                        -TenantId $TenantId
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
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $SubscriptionId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ResourceGroupName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $WorkspaceName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $SourceType,

        [Parameter()]
        [System.String]
        $ItemsSearchKey,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DefaultDuration,

        [Parameter()]
        [System.String]
        $Alias,

        [Parameter()]
        [System.Uint32]
        $NumberOfLinesToSkip,

        [Parameter()]
        [System.String]
        $RawContent,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).Clone()

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

    $testResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $testResult"

    return $testResult
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

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

    $ConnectionMode = New-M365DSCConnection -Workload 'Azure' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        $Script:ExportMode = $true
        $workspaces = Get-AzResource -ResourceType 'Microsoft.OperationalInsights/workspaces'
        $Script:exportedInstances = @()
        $i = 1
        $dscContent = ''
        if ($Script:exportedInstances.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }

        if ([System.String]::IsNullOrEmpty($TenantId) -and $null -ne $Credential)
        {
            $TenantId = $Credential.UserName.Split('@')[1]
        }
        foreach ($workspace in $workspaces)
        {
            Write-Host "    |---[$i/$($workspaces.Length)] $($workspace.Name)" -NoNewline
            $subscriptionId    = $workspace.ResourceId.Split('/')[2]
            $resourceGroupName = $workspace.ResourceGroupName
            $workspaceName     = $workspace.Name

            $currentWatchLists = Get-M365DSCSentinelWatchlist -SubscriptionId $subscriptionId `
                                                              -ResourceGroupName $resourceGroupName `
                                                              -WorkspaceName $workspaceName `
                                                              -TenantId $TenantId

            $j = 1
            if ($currentWatchLists.Length -eq 0 )
            {
                Write-Host $Global:M365DSCEmojiGreenCheckMark
            }
            else
            {
                Write-Host "`r`n" -NoNewline
            }

            foreach ($watchList in $currentWatchLists)
            {
                $Script:exportedInstances += $watchList
                if ($null -ne $Global:M365DSCExportResourceInstancesCount)
                {
                    $Global:M365DSCExportResourceInstancesCount++
                }

                $displayedKey = $watchList.Name
                Write-Host "        |---[$j/$($currentWatchLists.Length)] $displayedKey" -NoNewline
                $params = @{
                    SubscriptionId        = $subscriptionId
                    ResourceGroupName     = $resourceGroupName
                    WorkspaceName         = $workspaceName
                    Name                  = $watchList.Name
                    Id                    = $watchlist.properties.watchlistId
                    Credential            = $Credential
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                    ManagedIdentity       = $ManagedIdentity.IsPresent
                    AccessTokens          = $AccessTokens
                }

                $Results = Get-TargetResource @Params
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
                $j++
                Write-Host $Global:M365DSCEmojiGreenCheckMark
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

function Get-M365DSCSentinelWatchlist
{
    [CmdletBinding()]
    [OutputType([Array])]
    param(
        [Parameter()]
        [System.String]
        $SubscriptionId,

        [Parameter()]
        [System.String]
        $ResourceGroupName,

        [Parameter()]
        [System.String]
        $WorkspaceName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $TenantId
    )

    try
    {
        $hostUrl = Get-M365DSCAPIEndpoint -TenantId $TenantId
        $uri = $hostUrl.AzureManagement + "/subscriptions/$($SubscriptionId)/resourceGroups/$($ResourceGroupName)/"
        $uri += "providers/Microsoft.OperationalInsights/workspaces/$($WorkspaceName)/providers/Microsoft.SecurityInsights/watchlists?api-version=2022-06-01-preview"
        $response = Invoke-AzRest -Uri $uri -Method 'GET'
        $result = ConvertFrom-Json $response.Content
        return $result.value
    }
    catch
    {
        Write-Verbose -Message $_
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId
        throw $_
    }
}

function Set-M365DSCSentinelWatchlist
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $SubscriptionId,

        [Parameter()]
        [System.String]
        $ResourceGroupName,

        [Parameter()]
        [System.String]
        $WorkspaceName,

        [Parameter()]
        [System.String]
        $WatchListAlias,

        [Parameter()]
        [System.Collections.Hashtable]
        $Body,

        [Parameter(Mandatory = $true)]
        [System.String]
        $TenantId
    )

    try
    {
        $hostUrl = Get-M365DSCAPIEndpoint -TenantId $TenantId
        $uri = $hostUrl.AzureManagement + "/subscriptions/$($SubscriptionId)/resourceGroups/$($ResourceGroupName)/"
        $uri += "providers/Microsoft.OperationalInsights/workspaces/$($WorkspaceName)/providers/Microsoft.SecurityInsights/watchlists/$($WatchListAlias)?api-version=2022-06-01-preview"
        $payload = ConvertTo-Json $Body -Depth 10 -Compress

        Write-Verbose -Message "Calling Url: {$($uri)}"
        Write-Verbose -Message "Payload: {$payload}"
        $response = Invoke-AzRest -Uri $uri -Method 'PUT' -Payload $payload
        if ($response.StatusCode -ne 200 -and $response.StatusCode -ne 201)
        {
            Write-Verbose -Message $($response | Out-String)
            $content = ConvertFrom-Json $response.Content
            throw $content.error.message
        }
    }
    catch
    {
        Write-Verbose -Message $_
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId
        throw $_
    }
}

function Remove-M365DSCSentinelWatchlist
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $SubscriptionId,

        [Parameter()]
        [System.String]
        $ResourceGroupName,

        [Parameter()]
        [System.String]
        $WorkspaceName,

        [Parameter()]
        [System.String]
        $WatchListAlias,

        [Parameter(Mandatory = $true)]
        [System.String]
        $TenantId
    )

    try
    {
        $hostUrl = Get-M365DSCAPIEndpoint -TenantId $TenantId
        $uri = $hostUrl.AzureManagement + "/subscriptions/$($SubscriptionId)/resourceGroups/$($ResourceGroupName)/"
        $uri += "providers/Microsoft.OperationalInsights/workspaces/$($WorkspaceName)/providers/Microsoft.SecurityInsights/watchlists/$($WatchListAlias)?api-version=2022-06-01-preview"
        Invoke-AzRest -Uri $uri -Method 'DELETE'
    }
    catch
    {
        Write-Verbose -Message $_
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId
        throw $_
    }
}

Export-ModuleMember -Function *-TargetResource
