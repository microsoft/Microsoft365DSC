Confirm-M365DSCModuleDependency -ModuleName 'M365DSCGraphAPIRuleEvaluation'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $APIUrl,

        [Parameter(Mandatory = $true)]
        [System.String]
        $RuleDefinition,

        [Parameter()]
        [System.String]
        $InstancesProperty = 'value',

        [Parameter()]
        [System.String]
        $InstanceIdentifier,

        [Parameter()]
        [System.String]
        $RuleName,

        [Parameter()]
        [System.String]
        $AfterRuleCountQuery,

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
    return $null
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $APIUrl,

        [Parameter(Mandatory = $true)]
        [System.String]
        $RuleDefinition,

        [Parameter()]
        [System.String]
        $InstancesProperty = 'value',

        [Parameter()]
        [System.String]
        $InstanceIdentifier,

        [Parameter()]
        [System.String]
        $RuleName,

        [Parameter()]
        [System.String]
        $AfterRuleCountQuery,

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
    # Not Implemented
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $APIUrl,

        [Parameter(Mandatory = $true)]
        [System.String]
        $RuleDefinition,

        [Parameter()]
        [System.String]
        $InstancesProperty = 'value',

        [Parameter()]
        [System.String]
        $InstanceIdentifier,

        [Parameter()]
        [System.String]
        $RuleName,

        [Parameter()]
        [System.String]
        $AfterRuleCountQuery,

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
    $CurrentResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $CurrentResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    Write-Verbose -Message "Invoking GET {$($APIUrl)}"
    $uri = $APIUrl
    $DSCConvertedInstances = @()
    do
    {
        # Make the API request
        $response = Invoke-MgGraphRequest -Uri $uri -Method GET

        # Add the current page of results to the array
        $DSCConvertedInstances += $response.$InstancesProperty

        # Check if there's a next page
        $uri = $response.'@odata.nextLink'
    } while ($uri)

    Write-Verbose -Message 'Querying DSC Objects for invalid instances based on the specified Rule Definition.'
    if ($RuleDefinition -eq '*')
    {
        [Array]$instances = $DSCConvertedInstances
        Write-Verbose -Message "Identified {$($instances.Length)} instances matching rule."
    }
    else
    {
        $queryBlock = [Scriptblock]::Create($RuleDefinition)
        [Array]$instances = $DSCConvertedInstances | Where-Object -FilterScript $queryBlock
        Write-Verbose -Message "Identified {$($instances.Length)} instances matching rule."
    }

    $result = ($instances.Length - $DSCConvertedInstances.Length) -eq 0

    $message = [System.Text.StringBuilder]::New()
    [void]$message.AppendLine('<M365DSCGraphAPIRuleEvaluation>')
    [void]$message.AppendLine("  <RuleName>$RuleName</RuleName>")
    [void]$message.AppendLine("  <ResourceName>$ResourceTypeName</ResourceName>")
    [void]$message.AppendLine("  <RuleDefinition>$RuleDefinition</RuleDefinition>")

    if (-not [System.String]::IsNullOrEmpty($AfterRuleCountQuery))
    {
        [void]$message.AppendLine('  <AfterRuleCount>')
        [void]$message.AppendLine("    <Query>$AfterRuleCountQuery</Query>")

        Write-Verbose -Message 'Checking the After Rule Count Query'
        $afterRuleCountQueryString = "`$instances.Length $AfterRuleCountQuery"
        $afterRuleCountQueryBlock = [Scriptblock]::Create($afterRuleCountQueryString)
        $result = [Boolean](Invoke-Command -ScriptBlock $afterRuleCountQueryBlock)

        if ($InstanceIdentifier)
        {
            [array]$validInstances = $instances.$InstanceIdentifier
            [array]$invalidInstances = $DSCConvertedInstances.$InstanceIdentifier | Where-Object -FilterScript { $_ -notin $validInstances }
        }

        if (-not $result)
        {
            [void]$message.AppendLine('    <MetQuery>False</MetQuery>')
            [void]$message.AppendLine('  </AfterRuleCount>')

            if ($validInstances.Count -gt 0)
            {
                [void]$message.AppendLine('  <Match>')
                foreach ($validInstance in $validInstances)
                {
                    [void]$message.AppendLine("    <$InstanceIdentifier>$validInstance</$InstanceIdentifier>")
                }
                [void]$message.AppendLine('  </Match>')
            }
            else
            {
                [void]$message.AppendLine('  <Match></Match>')
            }
        }
        else
        {
            [void]$message.AppendLine('    <MetQuery>True</MetQuery>')
            [void]$message.AppendLine('  </AfterRuleCount>')
            [void]$message.AppendLine('  <Match>')
            foreach ($validInstance in $validInstances)
            {
                [void]$message.AppendLine("    <InstanceIdentifier>[$ResourceTypeName]$validInstance</InstanceIdentifier>")
            }
            [void]$message.AppendLine('  </Match>')
        }
    }
    else
    {
        [void]$message.AppendLine('  <AfterRuleCount></AfterRuleCount>')

        $compareInstances = @()
        if ($compareInstances.Count -gt 0)
        {
            [array]$validInstances = $($compareInstances | Where-Object -FilterScript { $_.SideIndicator -eq '==' }).InputObject
            [array]$invalidInstances = $($compareInstances | Where-Object -FilterScript { $_.SideIndicator -eq '<=' }).InputObject
        }
        else
        {
            [array]$validInstances = @()
            [array]$invalidInstances = [array]$DSCConvertedInstances.$InstanceIdentifier
        }

        if ($validInstances.Count -gt 0)
        {
            [void]$message.AppendLine('  <Match>')
            foreach ($validInstance in $validInstances)
            {
                [void]$message.AppendLine("    <$InstanceIdentifier>$validInstance</$InstanceIdentifier>")
            }
            [void]$message.AppendLine('  </Match>')
        }
        else
        {
            [void]$message.AppendLine('  <Match></Match>')
        }
    }

    # Log drifts for each invalid instances found.
    if ($invalidInstances.Count -gt 0)
    {
        [void]$message.AppendLine('  <NotMatch>')
        foreach ($invalidInstance in $invalidInstances)
        {
            [void]$message.AppendLine("    <$InstanceIdentifier>$invalidInstance</$InstanceIdentifier>")
        }
        [void]$message.AppendLine('  </NotMatch>')
    }
    else
    {
        [void]$message.AppendLine('  <NotMatch></NotMatch>')
    }
    [void]$message.AppendLine('</M365DSCGraphAPIRuleEvaluation>')

    $Parameters = @{
        Message   = $message.ToString()
        EventType = 'RuleEvaluation'
        EventID   = 1
        Source    = $CurrentResourceName
    }
    if (-not $result)
    {
        $Parameters.Add('EntryType', 'Warning')
    }
    else
    {
        $Parameters.Add('EntryType', 'Information')
    }
    Add-M365DSCEvent @Parameters

    Write-Verbose -Message "Test-TargetResource returned $result"

    $Script:exportedInstance = $null
    return $result
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
    Write-M365DSCHost -Message "`r`n" -DeferWrite
    return $null
}

Export-ModuleMember -Function *-TargetResource

