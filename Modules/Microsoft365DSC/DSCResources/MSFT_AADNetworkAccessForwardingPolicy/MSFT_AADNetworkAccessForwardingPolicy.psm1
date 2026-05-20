Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADNetworkAccessForwardingPolicy'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $PolicyRules,

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

    Write-Verbose -Message "Getting configuration for the AAD Network Access Forwarding Policy with Name {$Name}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Name -ne $Name)
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

            $instance = Get-MgBetaNetworkAccessForwardingPolicy -Expand * -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq $Name }
        }
        else
        {
            $instance = $Script:exportedInstance
        }

        if ($null -eq $instance)
        {
            throw "Could not retrieve the Forwarding Policy with name: $Name"
        }

        $complexPolicyRules = Get-MicrosoftGraphNetworkAccessForwardingPolicyRules -PolicyRules $instance.PolicyRules

        $results = @{
            Name                  = $instance.Name
            PolicyRules           = $complexPolicyRules
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
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
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $PolicyRules,

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

    Write-Verbose -Message "Setting the AAD Network Access Forwarding Policy with Name {$Name}"

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

    $setParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    $currentPolicy = Get-MgBetaNetworkAccessForwardingPolicy -Expand * -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq $setParameters.Name }
    if ($Name -eq 'Custom Bypass')
    {
        foreach ($rule in $currentPolicy.PolicyRules)
        {
            Remove-MgBetaNetworkAccessForwardingPolicyRule -ForwardingPolicyId $currentPolicy.Id -PolicyRuleId $rule.Id
        }

        foreach ($rule in $setParameters.PolicyRules)
        {
            $complexDestinations = @()
            foreach ($destination in $rule.Destinations)
            {
                $complexDestinations += @{
                    '@odata.type' = '#microsoft.graph.networkaccess.' + $rule.RuleType
                    value         = $destination
                }
            }
            $params = @{
                '@odata.type' = '#microsoft.graph.networkaccess.internetAccessForwardingRule'
                name          = $rule.Name
                action        = $rule.ActionValue
                ruleType      = $rule.RuleType
                ports         = ($rule.Ports | ForEach-Object { $_.ToString() })
                protocol      = $rule.Protocol
                destinations  = $complexDestinations
            }

            New-MgBetaNetworkAccessForwardingPolicyRule -ForwardingPolicyId $currentPolicy.Id -BodyParameter $params
        }
    }
    elseif ($currentPolicy.TrafficForwardingType -eq 'm365')
    {
        $rulesParam = @()
        foreach ($desiredRule in $setParameters.PolicyRules)
        {
            $desiredRuleHashtable = Convert-M365DSCDRGComplexTypeToHashtable $desiredRule
            $desiredRuleHashtable.Remove('actionValue')
            $testResult = $false
            foreach ($currentRule in $currentPolicy.PolicyRules)
            {
                $currentRuleHashtable = Get-MicrosoftGraphNetworkAccessForwardingPolicyRules -PolicyRules @($currentRule)
                $currentRuleHashtable.Remove('ActionValue')
                $testResult = Compare-M365DSCComplexObject `
                    -Source ($currentRuleHashtable) `
                    -Target ($desiredRuleHashtable) `
                    -PropertyName 'PolicyRules'
                if ($testResult)
                {
                    Write-Verbose "Updating: $($currentRule.Name), $($currentRule.Id)"
                    $rulesParam += @{
                        ruleId = $currentRule.Id
                        action = $desiredRule.ActionValue
                    }
                    break
                }
            }
            if ($testResult -eq $false)
            {
                Write-Verbose "Could not find rule with the given specification: $(Convert-M365DscHashtableToString -Hashtable $desiredRuleHashtable), skipping set for this."
            }
        }
        $updateParams = @{
            rules = $rulesParam
        }

        Invoke-MgGraphRequest -Uri ((Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/networkAccess/forwardingPolicies/$($currentPolicy.ID)/updatePolicyRules") -Method Post -Body $updateParams
    }
    else
    {
        Write-Verbose "Can not modify the list of poilicy rules for the forwarding policy with name: $($setParameters.Name)"
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

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $PolicyRules,

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
        [array] $exportedInstances = Get-MgBetaNetworkAccessForwardingPolicy `
            -All `
            -ExpandProperty * `
            -Filter $Filter `
            -ErrorAction Stop

        $i = 1
        $dscContent = [System.Text.StringBuilder]::new()
        if ($exportedInstances.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($config in $exportedInstances)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $displayedKey = $config.Name
            Write-M365DSCHost -Message "    |---[$i/$($exportedInstances.Count)] $displayedKey" -DeferWrite
            $params = @{
                Name                  = $config.Name
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

            if ($null -ne $Results.PolicyRules)
            {
                $complexMapping = @(
                    @{
                        Name            = 'PolicyRules'
                        CimInstanceName = 'MicrosoftGraphNetworkAccessForwardingPolicyRule'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.PolicyRules `
                    -CIMInstanceName 'MicrosoftGraphNetworkAccessForwardingPolicyRule' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.PolicyRules = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('PolicyRules') | Out-Null
                }
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('PolicyRules')

            [void]$dscContent.Append($currentDSCBlock)
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        return $dscContent.ToString()
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

function Get-MicrosoftGraphNetworkAccessForwardingPolicyRules
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable[]])]
    param
    (
        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [System.Collections.ArrayList]
        $PolicyRules
    )

    $newPolicyRules = @()
    foreach ($rule in $PolicyRules)
    {
        [System.String[]]$destinations = @()
        foreach ($destination in $rule.AdditionalProperties.destinations)
        {
            $destinations += $destination.value
        }
        $newPolicyRules += [ordered]@{
            Name         = $rule.Name
            ActionValue  = $rule.AdditionalProperties.action
            RuleType     = $rule.AdditionalProperties.ruleType
            Ports        = [System.Int32[]]$rule.AdditionalProperties.ports
            Protocol     = $rule.AdditionalProperties.protocol
            Destinations = $destinations
        }
    }

    ,$newPolicyRules
}


Export-ModuleMember -Function *-TargetResource
