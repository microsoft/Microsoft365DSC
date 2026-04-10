Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneAlertRuleWindows365'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter(Mandatory = $true)]
        [ValidateSet('cloudPcProvisionScenario', 'cloudPcImageUploadScenario', 'cloudPcOnPremiseNetworkConnectionCheckScenario', 'cloudPcInGracePeriodScenario', 'cloudPcFrontlineInsufficientLicensesScenario', 'cloudPcInaccessibleScenario', 'cloudPcFrontlineConcurrencyScenario', 'cloudPcUserSettingsPersistenceScenario', 'cloudPcDeprovisionFailedScenario')]
        [System.String]
        $AlertRuleTemplate,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Conditions,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $NotificationChannels,

        [Parameter()]
        [ValidateSet('Critical', 'Warning', 'Informational')]
        [System.String]
        $Severity,
        #endregion

        [Parameter()]
        [System.String]
        [ValidateSet('Present')]
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

    Write-Verbose -Message "Getting configuration for the Intune Alert Rule for Windows365 with AlertRuleTemplate {$AlertRuleTemplate}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.AlertRuleTemplate -ne $AlertRuleTemplate)
        {
            $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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

            $nullResult = $PSBoundParameters
            $nullResult.Ensure = 'Absent'

            #region resource generator code
            $getValue = Get-MgBetaDeviceManagementMonitoringAlertRule `
                -Filter "alertRuleTemplate eq '$($AlertRuleTemplate -replace "'", "''")'" `
                -All `
                -ErrorAction SilentlyContinue | Where-Object {
                    $_.alertRuleTemplate -eq $AlertRuleTemplate
                }
            $Script:currentAlertRule = $getValue
            #endregion
            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Alert Rule for Windows365 with AlertRuleTemplate {$AlertRuleTemplate}."
                return $nullResult
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }

        Write-Verbose -Message "An Intune Alert Rule for Windows365 with AlertRuleTemplate {$AlertRuleTemplate} was found."

        $complexConditions = @()
        foreach ($condition in $getValue.Conditions)
        {
            $complexConditions += [ordered]@{
                Aggregation       = $condition.aggregation
                ConditionCategory = $condition.conditionCategory
                Operator          = $condition.operator
                RelationshipType  = $condition.relationshipType
                ThresholdValue    = $condition.thresholdValue
            }
        }

        $complexNotificationChannels = @()
        foreach ($channel in $getValue.NotificationChannels)
        {
            $complexNotificationChannels += [ordered]@{
                NotificationChannelType = $channel.notificationChannelType
                NotificationReceivers   = @($channel.notificationReceivers | ForEach-Object {
                    [ordered]@{
                        ContactInformation = $_.ContactInformation
                        Locale             = $_.locale
                    }
                })
            }
        }

        $results = @{
            #region resource generator code
            AlertRuleTemplate     = $getValue.AlertRuleTemplate
            Conditions            = $complexConditions
            Enabled               = $getValue.Enabled
            NotificationChannels  = $complexNotificationChannels
            Severity              = $getValue.Severity
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            #endregion
        }

        return $results
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        #region resource generator code
        [Parameter(Mandatory = $true)]
        [ValidateSet('cloudPcProvisionScenario', 'cloudPcImageUploadScenario', 'cloudPcOnPremiseNetworkConnectionCheckScenario', 'cloudPcInGracePeriodScenario', 'cloudPcFrontlineInsufficientLicensesScenario', 'cloudPcInaccessibleScenario', 'cloudPcFrontlineConcurrencyScenario', 'cloudPcUserSettingsPersistenceScenario', 'cloudPcDeprovisionFailedScenario')]
        [System.String]
        $AlertRuleTemplate,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Conditions,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $NotificationChannels,

        [Parameter()]
        [ValidateSet('Critical', 'Warning', 'Informational')]
        [System.String]
        $Severity,
        #endregion

        [Parameter()]
        [System.String]
        [ValidateSet('Present')]
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

    Write-Verbose -Message "Setting configuration of the Intune Alert Rule for Windows365 with AlertRuleTemplate {$AlertRuleTemplate}"

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
    $boundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    $boundParameters.Add('isSystemRule', $true)
    $boundParameters.Add('id', $Script:currentAlertRule.Id)
    $boundParameters.Add('description', $Script:currentAlertRule.Description)
    $boundParameters.Add('displayName', $Script:currentAlertRule.DisplayName)

    $requiresThreshold = $false
    if ($AlertRuleTemplate -in @('cloudPcImageUploadScenario', 'cloudPcOnPremiseNetworkConnectionCheckScenario'))
    {
        $requiresThreshold = $true
        $aggregation = 'count'
    }
    elseif ($AlertRuleTemplate -eq 'cloudPcFrontlineInsufficientLicensesScenario')
    {
        $requiresThreshold = $true
        $aggregation = 'percentage'
    }

    if ($requiresThreshold)
    {
        $boundParameters.Add('threshold', @{
            aggregation = $aggregation
            operator    = 'greaterOrEqual'
            target      = 1
        })
    }

    $updateParameters = ([Hashtable]$boundParameters).Clone()
    $updateParameters = Rename-M365DSCCimInstanceParameter -Properties $updateParameters

    #region resource generator code
    if ($Script:currentAlertRule.Id -eq '00000000-0000-0000-0000-000000000000')
    {
        Write-Verbose -Message "Updating the Intune Alert Rule for Windows365 with AlertRuleTemplate {$($currentInstance.AlertRuleTemplate)} from default instance."
        $null = New-MgBetaDeviceManagementMonitoringAlertRule -BodyParameter $updateParameters
    }
    else
    {
        Write-Verbose -Message "Updating the Intune Alert Rule for Windows365 with AlertRuleTemplate {$($currentInstance.AlertRuleTemplate)} and Id {$($Script:currentAlertRule.Id)}."
        Update-MgBetaDeviceManagementMonitoringAlertRule `
            -AlertRuleId $Script:currentAlertRule.Id `
            -BodyParameter $updateParameters
    }
    #endregion
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        #region resource generator code
        [Parameter(Mandatory = $true)]
        [ValidateSet('cloudPcProvisionScenario', 'cloudPcImageUploadScenario', 'cloudPcOnPremiseNetworkConnectionCheckScenario', 'cloudPcInGracePeriodScenario', 'cloudPcFrontlineInsufficientLicensesScenario', 'cloudPcInaccessibleScenario', 'cloudPcFrontlineConcurrencyScenario', 'cloudPcUserSettingsPersistenceScenario', 'cloudPcDeprovisionFailedScenario')]
        [System.String]
        $AlertRuleTemplate,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Conditions,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $NotificationChannels,

        [Parameter()]
        [ValidateSet('Critical', 'Warning', 'Informational')]
        [System.String]
        $Severity,
        #endregion

        [Parameter()]
        [System.String]
        [ValidateSet('Present')]
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

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '')
    return $result
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
        [System.String]
        $Filter,

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

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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
        #region resource generator code
        [array]$getValue = Get-MgBetaDeviceManagementMonitoringAlertRule `
            -Filter $Filter `
            -All `
            -ErrorAction Stop
        #endregion

        $i = 1
        $dscContent = ''
        if ($getValue.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($config in $getValue)
        {
            $displayedKey = $config.alertRuleTemplate
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
            $params = @{
                AlertRuleTemplate     = $config.alertRuleTemplate
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $config
            $Results = Get-TargetResource @Params
            if ($Results.Conditions)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.Conditions `
                    -CIMInstanceName 'IntuneAlertRuleCondition'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.Conditions = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('Conditions') | Out-Null
                }
            }
            if ($Results.NotificationChannels)
            {
                $complexMapping = @(
                    @{
                        Name            = 'NotificationChannels'
                        CimInstanceName = 'IntuneAlertRuleNotificationChannel'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'NotificationReceivers'
                        CimInstanceName = 'IntuneAlertRuleNotificationChannelReceiver'
                        IsRequired      = $false
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.NotificationChannels `
                    -CIMInstanceName 'IntuneAlertRuleNotificationChannel' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.NotificationChannels = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('NotificationChannels') | Out-Null
                }
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('Conditions', 'NotificationChannels')
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        return $dscContent
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

Export-ModuleMember -Function *-TargetResource
