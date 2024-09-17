function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ResourceGroupName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $WorkspaceName,

        [Parameter()]
        [System.String]
        $SubscriptionId,

        [Parameter()]
        [System.Boolean]
        $AnomaliesIsEnabled,

        [Parameter()]
        [System.Boolean]
        $EntityAnalyticsIsEnabled,

        [Parameter()]
        [System.Boolean]
        $EyesOnIsEnabled,

        [Parameter()]
        [System.String[]]
        $UebaDataSource,

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
    try
    {
        $ResourceGroupNameValue = $ResourceGroupName
        $WorkspaceNameValue = $WorkspaceName
        if ($null -ne $Script:exportedInstances -and $Script:ExportMode)
        {
            $entry = $Script:exportedInstances | Where-Object -FilterScript {$_.Name -eq $WorkspaceName}
            $instance = Get-AzSentinelSetting -ResourceGroupName $entry.ResourceGroupName `
                                              -WorkspaceName $entry.Name `
                                              -SubscriptionId $SubscriptionId `
                                              -ErrorAction SilentlyContinue
            $ResourceGroupNameValue = $entry.ResourceGroupName
            $WorkspaceNameValue = $entry.Name
        }
        else
        {
            Write-Verbose -Message "Retrieving Sentinel Settings for {$WorkspaceName}"
            $instance = Get-AzSentinelSetting -ResourceGroupName $ResourceGroupName `
                                              -WorkspaceName $WorkspaceName `
                                              -ErrorAction SilentlyContinue `
                                              -SubscriptionId $SubscriptionId
        }
        if ($null -eq $instance)
        {
            throw "Could not find Sentinel Workspace {$WorkspaceName} in Resource Group {$ResourceGroupName}"
        }

        Write-Verbose -Message "Found an instance of Sentinel Workspace {$Workspace}"
        $Anomalies = $instance | Where-Object -FilterScript {$_.Name -eq 'Anomalies'}
        $AnomaliesIsEnabledValue = $false
        if ($null -ne $Anomalies)
        {
            Write-Verbose -Message "Anomalies instance found."
            $AnomaliesIsEnabledValue = $Anomalies.IsEnabled
        }

        $EntityAnalytics = $instance | Where-Object -FilterScript {$_.Name -eq 'EntityAnalytics'}
        $EntityAnalyticsIsEnabledValue = $false
        if ($null -ne $EntityAnalytics)
        {
            Write-Verbose -Message "EntityAnalytics instance found."
            $EntityAnalyticsIsEnabledValue = $EntityAnalytics.IsEnabled
        }

        $EyesOn = $instance | Where-Object -FilterScript {$_.Name -eq 'EyesOn'}
        $EyesOnIsEnabledValue = $false
        if ($null -ne $EyesOn)
        {
            Write-Verbose -Message "EyesOn instance found."
            $EyesOnIsEnabledValue = $EyesOn.IsEnabled
        }

        $Ueba = $instance | Where-Object -FilterScript {$_.Name -eq 'Ueba'}
        $UebaDataSourceValue = $null
        if ($null -ne $Ueba)
        {
            Write-Verbose -Message "UEBA Data source instance found."
            $UebaDataSourceValue = $Ueba.DataSource
        }

        $results = @{
            AnomaliesIsEnabled       = [Boolean]$AnomaliesIsEnabledValue
            EntityAnalyticsIsEnabled = [Boolean]$EntityAnalyticsIsEnabledValue
            EyesOnIsEnabled          = [Boolean]$EyesOnIsEnabledValue
            UebaDataSource           = $UebaDataSourceValue
            ResourceGroupName        = $ResourceGroupNameValue
            WorkspaceName            = $WorkspaceNameValue
            SubscriptionId           = $SubscriptionId
            Credential               = $Credential
            ApplicationId            = $ApplicationId
            TenantId                 = $TenantId
            CertificateThumbprint    = $CertificateThumbprint
            ManagedIdentity          = $ManagedIdentity.IsPresent
            AccessTokens             = $AccessTokens
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
        $ResourceGroupName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $WorkspaceName,

        [Parameter()]
        [System.String]
        $SubscriptionId,

        [Parameter()]
        [System.Boolean]
        $AnomaliesIsEnabled,

        [Parameter()]
        [System.Boolean]
        $EntityAnalyticsIsEnabled,

        [Parameter()]
        [System.Boolean]
        $EyesOnIsEnabled,

        [Parameter()]
        [System.String[]]
        $UebaDataSource,

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

    if ($PSBoundParameters.ContainsKey('AnomaliesIsEnabled'))
    {
        Write-Verbose -Message "Updating Anomalies IsEnabled value to {$AnomaliesIsEnabled}"
        Update-AzSentinelSetting -ResourceGroupName $ResourceGroupName `
                                    -WorkspaceName $WorkspaceName `
                                     -SettingsName "Anomalies" `
                                     -Enabled $AnomaliesIsEnabled | Out-Null
    }
    if ($PSBoundParameters.ContainsKey('EntityAnalyticsIsEnabled'))
    {
        Write-Verbose -Message "Updating Entity Analytics IsEnabled value to {$EntityAnalyticsIsEnabled}"
        Update-AzSentinelSetting -ResourceGroupName $ResourceGroupName `
                                     -WorkspaceName $WorkspaceName `
                                     -SettingsName "EntityAnalytics" `
                                     -Enabled $EntityAnalyticsIsEnabled | Out-Null
    }
    if ($PSBoundParameters.ContainsKey('EyesOnIsEnabled'))
    {
        Write-Verbose -Message "Updating Eyes On IsEnabled value to {$EyesOnIsEnabled}"
        Update-AzSentinelSetting -ResourceGroupName $ResourceGroupName `
                                     -WorkspaceName $WorkspaceName `
                                     -SettingsName "EyesOn" `
                                     -Enabled $EyesOnIsEnabled | Out-Null
    }
    if ($PSBoundParameters.ContainsKey('UebaDataSource'))
    {
        Write-Verbose -Message "Updating UEBA Data Source value to {$UebaDataSource}"
        Update-AzSentinelSetting -ResourceGroupName $ResourceGroupName `
                                     -WorkspaceName $WorkspaceName `
                                     -SettingsName "Ueba" `
                                     -DataSource $UebaDataSource | Out-Null
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
        $ResourceGroupName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $WorkspaceName,

        [Parameter()]
        [System.String]
        $SubscriptionId,

        [Parameter()]
        [System.Boolean]
        $AnomaliesIsEnabled,

        [Parameter()]
        [System.Boolean]
        $EntityAnalyticsIsEnabled,

        [Parameter()]
        [System.Boolean]
        $EyesOnIsEnabled,

        [Parameter()]
        [System.String[]]
        $UebaDataSource,

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

        [array] $Script:exportedInstances = Get-AzResource -ResourceType 'Microsoft.OperationalInsights/workspaces'

        $dscContent = ''
        $i = 1
        if ($Script:exportedInstances.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($config in $Script:exportedInstances)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }
            $displayedKey = $config.Name
            Write-Host "    |---[$i/$($Script:exportedInstances.Count)] $displayedKey" -NoNewline
            $params = @{
                ResourceGroupName     = $config.ResourceGroupName
                WorkspaceName         = $config.Name
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
            $i++
            Write-Host $Global:M365DSCEmojiGreenCheckMark
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
