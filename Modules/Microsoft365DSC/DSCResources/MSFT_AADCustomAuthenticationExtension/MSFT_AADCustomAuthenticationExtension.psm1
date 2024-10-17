function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        [ValidateSet(
            '#microsoft.graph.onTokenIssuanceStartCustomExtension',
            '#microsoft.graph.onAttributeCollectionStartCustomExtension',
            '#microsoft.graph.onAttributeCollectionStartCustomExtension'
        )]
        $CustomAuthenticationExtensionType,

        [Parameter()]
        [System.String]
        [ValidateSet(
            '#microsoft.graph.azureAdTokenAuthentication',
            '#microsoft.graph.azureAdPopTokenAuthentication'
        )]
        $AuthenticationConfigurationType,

        [Parameter()]
        [System.String]
        $AuthenticationConfigurationResourceId,

        [Parameter()]
        [System.Int32]
        $ClientConfigurationTimeoutMillisesonds,

        [Parameter()]
        [System.Int32]
        $ClientConfigurationMaximumRetries,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EndPointConfiguration,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ClaimsForTokenConfguration,

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
        $AccessTokens,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',
    )

    New-M365DSCConnection -Workload 'MicrosoftGraph' `
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
        # check for export.
        if ($null -ne $Script:exportedInstances -and $Script:ExportMode)
        {
            # check with Id first
            if (-not [System.String]::IsNullOrEmpty($Id))
            {
                $instance = $Script:exportedInstances | Where-Object -FilterScript {$_.Id -eq $Id}
            }

            # check with display name next.
            if ($null -eq $instance)
            {
                $instance = $Script:exportedInstances | Where-Object -FilterScript {$_.DisplayName -eq $DisplayName}
            }
        }
        else
        {
            if (-not [System.String]::IsNullOrEmpty($Id))
            {
                $instance = Get-MgBetaIdentityCustomAuthenticationExtension --CustomAuthenticationExtensionId $Id `
                                                                                 -ErrorAction SilentlyContinue
            }
            if ($null -eq $instance)
            {
                $instance = Get-MgBetaIdentityCustomAuthenticationExtension -Filter "DisplayName eq '$DisplayName'" `
                                                                                 -ErrorAction SilentlyContinue
            }
        }
        if ($null -eq $instance)
        {
            return $nullResult
        }

        $results = @{
            DisplayName = $instance.DisplayName
            Id          = $instance.Id
            Description = $instance.Description
        }

        if ($instance.AdditionalProperties -ne $null)
        {
            $results.Add('CustomAuthenticationExtensionType', $instance.AdditionalProperties["@odata.type"])
        }

        if ($instance.AuthenticationConfiguration -ne $null)
        {
            $results.Add('AuthenticationConfigurationType', $instance.AuthenticationConfiguration["@odata.type"])
            $results.Add('AuthenticationConfigurationResourceId', $instance.AuthenticationConfiguration["resourceId"])
        }

        if ($instance.ClientConfiguration -ne $null)
        {
            $results.Add('ClientConfigurationTimeoutMilliseconds', $instance.ClientConfiguration.TimeoutInMilliseconds)
            $results.Add('ClientConfigurationMaximumRetries', $instance.ClientConfiguration.MaximumRetries)
        }

        $endpointConfiguration = @{}
        if ($instance.EndPointConfiguration -ne $null -and $instance.EndPointConfiguration.AdditionalProperties -ne $null)
        {
            $endpointConfiguration.Add("EndpointType", $instance.EndPointConfiguration.AdditionalProperties["@odata.type"])

            if ($endpointConfiguration["EndpointType"] -eq '#microsoft.graph.httpRequestEndpoint')
            {
                $endpointConfiguration.Add("TargetUrl", $instance.EndPointConfiguration.AdditionalProperties["targetUrl"])
            }

            if ($endpointConfiguration["EndpointType"] -eq '#microsoft.graph.logicAppTriggerEndpointConfiguration')
            {
                $endpointConfiguration.Add("SubscriptionId", $instance.EndPointConfiguration.AdditionalProperties["subscriptionId"])
                $endpointConfiguration.Add("ResourceGroupName", $instance.EndPointConfiguration.AdditionalProperties["resourceGroupName"])
                $endpointConfiguration.Add("LogicAppWorkflowName", $instance.EndPointConfiguration.AdditionalProperties["logicAppWorkflowName"])
            }
        }

        $claimsForTokenConfguration = @()
        if ($instance.AdditionalProperties -ne $null -and $instance.AdditionalProperties["claimsForTokenConfiguration"] -ne $null)
        {
            foreach ($claim in $instance.AdditionalProperties["claimsForTokenConfiguration"])
            {
                $c = @{
                    ClaimIdInApiResponse = $claim.claimIdInApiResponse
                }

                $claimsForTokenConfguration += $c
            }
        }

        $results.Add('EndPointConfiguration', $endpointConfiguration)
        $results.Add('ClaimsForTokenConfguration', $claimsForTokenConfguration)

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
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        [ValidateSet(
            '#microsoft.graph.onTokenIssuanceStartCustomExtension',
            '#microsoft.graph.onAttributeCollectionStartCustomExtension',
            '#microsoft.graph.onAttributeCollectionStartCustomExtension'
        )]
        $CustomAuthenticationExtensionType,

        [Parameter()]
        [System.String]
        [ValidateSet(
            '#microsoft.graph.azureAdTokenAuthentication',
            '#microsoft.graph.azureAdPopTokenAuthentication'
        )]
        $AuthenticationConfigurationType,

        [Parameter()]
        [System.String]
        $AuthenticationConfigurationResourceId,

        [Parameter()]
        [System.Int32]
        $ClientConfigurationTimeoutMillisesonds,

        [Parameter()]
        [System.Int32]
        $ClientConfigurationMaximumRetries,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EndPointConfiguration,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ClaimsForTokenConfguration,

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
        $AccessTokens,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present'
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

    $params = @{
        "@odata.type" = $setParameters["CustomAuthenticationExtensionType"]
        displayName = $setParameters["DisplayName"]
        description = $setParameters["Description"]
        endpointConfiguration = @{
            "@odata.type" = $setParameters["EndpointType"]
            targetUrl = $setParameters["TargetUrl"]
            subscriptionId = $setParameters["SubscriptionId"]
            resourceGroupName = $setParameters["ResourceGroupName"]
            logicAppWorkflowName = $setParameters["LogicAppWorkflowName"]
        }
        authenticationConfiguration = @{
            "@odata.type" = $setParameters["AuthenticationConfigurationType"]
            resourceId = $setParameters["AuthenticationConfigurationResourceId"]
        }
        clientConfiguration = @{
            timeoutInMilliseconds = $setParameters["ClientConfigurationTimeoutMilliseconds"]
            maximumRetries = $setParameters["ClientConfigurationMaximumRetries"]
        }
        claimsForTokenConfguration = @()
    }

    foreach ($claim in $setParameters["ClaimsForTokenConfguration"])
    {
        $c = @{
            "claimIdInApiResponse" = $claim["ClaimIdInApiResponse"]
        }

        $params["claimsForTokenConfiguration"] += $c
    }

    # CREATE
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        $params.Remove('Id') | Out-Null
        Write-Verbose -Message "Creating new Custom authentication extension with display name {$DisplayName}"
        New-MgBetaIdentityCustomAuthenticationExtension @params
    }

    # UPDATE
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating custom authentication extension {$DisplayName}"
        $params.Add('CustomAuthenticationExtensionId', $currentInstance.Id)
        $params.Remove('Id') | Out-Null
        Update-MgBetaIdentityCustomAuthenticationExtension @SetParameters
    }
    # REMOVE
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing custom authentication extension {$DisplayName}."
        Remove-MgBetaIdentityCustomAuthenticationExtension -CustomAuthenticationExtensionId $currentInstance.Id
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        [ValidateSet(
            '#microsoft.graph.onTokenIssuanceStartCustomExtension',
            '#microsoft.graph.onAttributeCollectionStartCustomExtension',
            '#microsoft.graph.onAttributeCollectionStartCustomExtension'
        )]
        $CustomAuthenticationExtensionType,

        [Parameter()]
        [System.String]
        [ValidateSet(
            '#microsoft.graph.azureAdTokenAuthentication',
            '#microsoft.graph.azureAdPopTokenAuthentication'
        )]
        $AuthenticationConfigurationType,

        [Parameter()]
        [System.String]
        $AuthenticationConfigurationResourceId,

        [Parameter()]
        [System.Int32]
        $ClientConfigurationTimeoutMillisesonds,

        [Parameter()]
        [System.Int32]
        $ClientConfigurationMaximumRetries,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EndPointConfiguration,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ClaimsForTokenConfguration,

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
        $AccessTokens,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present'
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
        $Script:ExportMode = $true
        [array] $Script:exportedInstances = Get-MgBetaIdentityCustomAuthenticationExtension -ErrorAction Stop

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
        foreach ($config in $Script:exportedInstances)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $displayedKey = $config.Id
            Write-Host "    |---[$i/$($Script:exportedInstances.Count)] $displayedKey" -NoNewline
            $params = @{
                Id                    = $config.Id
                DisplayNames          = $config.DisplayName
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
