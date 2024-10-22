function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

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
        $Description,

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
        if ([System.String]::IsNullOrEmpty($TenantId) -and -not $null -eq $Credential)
        {
            $TenantId = $Credential.UserName.Split('@')[1]
        }

        if (-not [System.String]::IsNullOrEmpty($Id))
        {
            $instance = Get-M365DSCSentinelAlertRule -SubscriptionId $SubscriptionId `
                                                     -ResourceGroupName $ResourceGroupName `
                                                     -WorkspaceName $WorkspaceName `
                                                     -TenantId $TenantId `
                                                     -Id $Id
        }
        if ($null -eq $instance)
        {
            $instances = Get-M365DSCSentinelAlertRule -SubscriptionId $SubscriptionId `
                                                     -ResourceGroupName $ResourceGroupName `
                                                     -WorkspaceName $WorkspaceName `
                                                     -TenantId $TenantId
            $instance = $instances | Where-Object -FilterScript {$_.properties.displayName -eq $DisplayName}
        }
        if ($null -eq $instance)
        {
            return $nullResult
        }

        $results = @{
            ProductFilter              = $instance.properties.ProductFilter
            Enabled                    = $instance.properties.Enabled
            Severity                   = $instance.properties.Severity
            Tactics                    = $instance.properties.Tactics
            Techniques                 = $instance.properties.Techniques
            Query                      = $instance.properties.Query
            QueryFrequency             = $instance.properties.QueryFrequency
            QueryPeriod                = $instance.properties.QueryPeriod
            TriggerOperator            = $instance.properties.TriggerOperator
            TriggerThreshold           = $instance.properties.TriggerThreshold
            SuppressionDuration        = $instance.properties.SuppressionDuration
            SuppresionEnabled          = $instance.properties.SuppresionEnabled
            AlertRuleTemplateName      = $instance.properties.AlertRuleTemplateName
            DisplayNamesExcludeFilter  = $instance.properties.DisplayNamesExcludeFilter
            DisplayNamesFilter         = $instance.properties.DisplayNamesFilter
            SeveritiesFilter           = $instance.properties.SeveritiesFilter
            DisplayName                = $instance.properties.displayName
            SubscriptionId             = $SubscriptionId
            ResourceGroupName          = $ResourceGroupName
            WorkspaceName              = $WorkspaceName
            Id                         = $instance.name
            Description                = $instance.properties.description
            Ensure                     = 'Present'
            Credential                 = $Credential
            ApplicationId              = $ApplicationId
            TenantId                   = $TenantId
            CertificateThumbprint      = $CertificateThumbprint
            ManagedIdentity            = $ManagedIdentity.IsPresent
            AccessTokens               = $AccessTokens
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
        ##TODO - Replace the PrimaryKey
        [Parameter(Mandatory = $true)]
        [System.String]
        $PrimaryKey,

        ##TODO - Add the list of Parameters

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

    $currentInstance = Get-TargetResource @PSBoundParameters

    $setParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    # CREATE
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        ##TODO - Replace by the New cmdlet for the resource
        New-Cmdlet @SetParameters
    }
    # UPDATE
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        ##TODO - Replace by the Update/Set cmdlet for the resource
        Set-cmdlet @SetParameters
    }
    # REMOVE
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        ##TODO - Replace by the Remove cmdlet for the resource
        Remove-cmdlet @SetParameters
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        ##TODO - Replace the PrimaryKey
        [Parameter(Mandatory = $true)]
        [System.String]
        $PrimaryKey,

        ##TODO - Add the list of Parameters

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
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-Host "    |---[$i/$($workspaces.Length)] $($workspace.Name)" -NoNewline
            $subscriptionId    = $workspace.ResourceId.Split('/')[2]
            $resourceGroupName = $workspace.ResourceGroupName
            $workspaceName     = $workspace.Name

            $rules = Get-M365DSCSentinelAlertRule -SubscriptionId $subscriptionId `
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

            foreach ($rule in $rules)
            {
                $displayedKey = $rule.properties.DisplayName
                Write-Host "        |---[$j/$($rules.Count)] $displayedKey" -NoNewline
                $params = @{
                    DisplayName           = $indruleicator.properties.displayName
                    Id                    = $rule.name
                    SubscriptionId        = $subscriptionId
                    ResourceGroupName     = $resourceGroupName
                    WorkspaceName         = $workspaceName
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

function Get-M365DSCSentinelAlertRule
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
        $TenantId,

        [Parameter()]
        [System.String]
        $Id
    )

    try
    {
        $hostUrl = Get-M365DSCAPIEndpoint -TenantId $TenantId
        $uri = $hostUrl.AzureManagement + "/subscriptions/$($SubscriptionId)/resourceGroups/$($ResourceGroupName)/"
        if (-not [System.String]::IsNullOrEmpty($Id))
        {
            $uri += "providers/Microsoft.OperationalInsights/workspaces/$($WorkspaceName)/providers/Microsoft.SecurityInsights/alertrules/$($Id)?api-version=2023-12-01-preview"
            $response = Invoke-AzRest -Uri $uri -Method 'GET'
            $result = ConvertFrom-Json $response.Content
            return $result
        }
        else
        {
            $uri += "providers/Microsoft.OperationalInsights/workspaces/$($WorkspaceName)/providers/Microsoft.SecurityInsights/alertrules?api-version=2023-12-01-preview"
            $response = Invoke-AzRest -Uri $uri -Method 'GET'
            $result = ConvertFrom-Json $response.Content
            return $result.value
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

function New-M365DSCSentinelThreatIntelligenceIndicator
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Collections.Hashtable]
        $Body
    )

    try
    {
        $hostUrl = Get-M365DSCAPIEndpoint -TenantId $TenantId
        $uri = $hostUrl.AzureManagement + "/subscriptions/$($SubscriptionId)/resourceGroups/$($ResourceGroupName)/"

        $uri += "providers/Microsoft.OperationalInsights/workspaces/$($WorkspaceName)/providers/Microsoft.SecurityInsights/alertrules/$((New-GUID).ToString())?api-version=2023-12-01-preview"
        $payload = ConvertTo-Json $Body -Depth 10 -Compress
        $response = Invoke-AzRest -Uri $uri -Method 'PUT' -Payload $payload
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

function Set-M365DSCSentinelThreatIntelligenceIndicator
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $TenantId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

        [Parameter()]
        [System.Collections.Hashtable]
        $Body
    )

    try
    {
        $hostUrl = Get-M365DSCAPIEndpoint -TenantId $TenantId
        $uri = $hostUrl.AzureManagement + "/subscriptions/$($SubscriptionId)/resourceGroups/$($ResourceGroupName)/"

        $uri += "providers/Microsoft.OperationalInsights/workspaces/$($WorkspaceName)/providers/Microsoft.SecurityInsights/threatIntelligence/main/indicators/$($Id)?api-version=2024-03-01"
        $payload = ConvertTo-Json $Body -Depth 10 -Compress
        $response = Invoke-AzRest -Uri $uri -Method 'PUT' -Payload $payload
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

function Remove-M365DSCSentinelThreatIntelligenceIndicator
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $TenantId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Id
    )

    try
    {
        $hostUrl = Get-M365DSCAPIEndpoint -TenantId $TenantId
        $uri = $hostUrl.AzureManagement + "/subscriptions/$($SubscriptionId)/resourceGroups/$($ResourceGroupName)/"

        $uri += "providers/Microsoft.OperationalInsights/workspaces/$($WorkspaceName)/providers/Microsoft.SecurityInsights/threatIntelligence/main/indicators/$($Id)?api-version=2024-03-01"
        $response = Invoke-AzRest -Uri $uri -Method 'DELETE'
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
