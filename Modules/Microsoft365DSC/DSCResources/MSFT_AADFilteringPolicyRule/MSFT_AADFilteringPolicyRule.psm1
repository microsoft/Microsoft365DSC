Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADFilteringPolicyRule'

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
        $Policy,

        [Parameter()]
        [System.String]
        $RuleType,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Destinations,

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration for the Azure AD Filtering Policy Rule with Id {$Id} and Name {$Name}"

    try
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

        $policyInstance = Get-MgBetaNetworkAccessFilteringPolicy | Where-Object -Filter { $_.Name -eq $Policy }
        if ($null -ne $policyInstance)
        {
            Write-Verbose -Message "Found existing Policy {$Policy}"

            $instance = $null
            if (-not [System.String]::IsNullOrEmpty($Id))
            {
                Write-Verbose -Message "Retrieving Filtering Policy Rule by Id {$Id}"
                $instance = Get-MgBetaNetworkAccessFilteringPolicyRule -FilteringPolicyId $policyInstance.Id `
                    -PolicyRuleId $Id -ErrorAction SilentlyContinue
            }
            if ($null -eq $instance)
            {
                Write-Verbose -Message "Retrieving Filtering Policy Rule by Name {$Name}"
                $instance = Get-MgBetaNetworkAccessFilteringPolicyRule -FilteringPolicyId $policyInstance.Id | Where-Object -FilterScript { $_.Name -eq $Name }
            }
        }
        if ($null -eq $instance)
        {
            return $nullResult
        }

        $DestinationsValue = @()
        foreach ($destination in $instance.destinations)
        {
            if ($instance.ruleType -eq 'fqdn')
            {
                $DestinationsValue += @{
                    value = $destination.value
                }
            }
            elseif ($instance.ruleType -eq 'webCategory')
            {
                $DestinationsValue += @{
                    name = $destination.name
                }
            }
        }

        $results = @{
            Name                  = $instance.Name
            Policy                = $Policy
            Id                    = $instance.Id
            RuleType              = $instance.ruleType
            Destinations          = $DestinationsValue
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            CertificatePath       = $CertificatePath
            CertificatePassword   = $CertificatePassword
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $Policy,

        [Parameter()]
        [System.String]
        $RuleType,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Destinations,

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message 'Entering the Set-TargetResource function'

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
    $policyInstance = Get-MgBetaNetworkAccessFilteringPolicy | Where-Object -Filter { $_.Name -eq $Policy }

    if ($RuleType -eq 'webCategory')
    {
        $instanceParams = @{
            '@odata.type' = '#microsoft.graph.networkaccess.webCategoryFilteringRule'
            name          = $Name
            ruleType      = $RuleType
            destinations  = @()
        }

        foreach ($destination in $Destinations)
        {
            $instanceParams.destinations += @{
                '@odata.type' = '#microsoft.graph.networkaccess.webCategory'
                name          = $destination.name
            }
        }
    }
    elseif ($RuleType -eq 'fqdn')
    {
        $instanceParams = @{
            '@odata.type' = '#microsoft.graph.networkaccess.fqdnFilteringRule'
            name          = $Name
            ruleType      = $RuleType
            destinations  = @()
        }

        foreach ($destination in $Destinations)
        {
            $instanceParams.destinations += @{
                '@odata.type' = '#microsoft.graph.networkaccess.fqdn'
                value         = $destination.value
            }
        }
    }

    # CREATE
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Filtering Policy Rule {$Name} with:`r`n$(ConvertTo-Json $instanceParams -Depth 10)"
        New-MgBetaNetworkAccessFilteringPolicyRule -FilteringPolicyId $policyInstance.Id `
            -BodyParameter $instanceParams
    }
    # UPDATE
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        $instanceParams.Remove('ruleType') | Out-Null
        Write-Verbose -Message "Updating Filtering Policy Rule {$Name} with:`r`n$(ConvertTo-Json $instanceParams -Depth 10)"
        Update-MgBetaNetworkAccessFilteringPolicyRule -FilteringPolicyId $policyInstance.Id `
            -PolicyRuleId $currentInstance.Id `
            -BodyParameter $instanceParams
    }
    # REMOVE
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Filtering Policy Rule {$Name}"
        Remove-MgBetaNetworkAccessFilteringPolicyRule -FilteringPolicyId $policyInstance.Id `
            -PolicyRuleId $currentInstance.Id
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
        $Policy,

        [Parameter()]
        [System.String]
        $RuleType,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Destinations,

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

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
        $policies = Get-MgBetaNetworkAccessFilteringPolicy -All -Filter $Filter -ErrorAction Stop

        $i = 1
        $dscContent = [System.Text.StringBuilder]::new()
        if ($policies.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($policy in $policies)
        {
            $displayedKey = $policy.Name
            Write-M365DSCHost -Message "    |---[$i/$($policies.Count)] $displayedKey" -DeferWrite
            $rules = Get-MgBetaNetworkAccessFilteringPolicyRule -FilteringPolicyId $policy.Id `
                -ErrorAction SilentlyContinue
            if ($rules.Length -eq 0)
            {
                Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            }
            else
            {
                Write-M365DSCHost -Message "`r`n" -DeferWrite
            }
            $j = 1
            foreach ($rule in $rules)
            {
                if ($null -ne $Global:M365DSCExportResourceInstancesCount)
                {
                    $Global:M365DSCExportResourceInstancesCount++
                }

                $displayedKey = $rule.Name
                Write-M365DSCHost -Message "        |---[$j/$($rules.Count)] $displayedKey" -DeferWrite
                $params = @{
                    Name                  = $rule.Name
                    Policy                = $policy.Name
                    Id                    = $rule.Id
                    Credential            = $Credential
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    ApplicationSecret     = $ApplicationSecret
                    CertificateThumbprint = $CertificateThumbprint
                    ManagedIdentity       = $ManagedIdentity.IsPresent
                    AccessTokens          = $AccessTokens
                }

                $Results = Get-TargetResource @Params

                if ($Results.Destinations)
                {
                    $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.Destinations -CIMInstanceName 'AADFilteringPolicyRuleDestination'
                    if ($complexTypeStringResult)
                    {
                        $Results.Destinations = $complexTypeStringResult
                    }
                    else
                    {
                        $Results.Remove('Destinations') | Out-Null
                    }
                }
                $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -Credential $Credential `
                    -NoEscape @('Destinations')

                [void]$dscContent.Append($currentDSCBlock)
                Save-M365DSCPartialExport -Content $currentDSCBlock `
                    -FileName $Global:PartialExportFileName
                $j++
                Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            }
            $i++
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

Export-ModuleMember -Function *-TargetResource
