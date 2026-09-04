Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADGSATLSInspectionPolicy'

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
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateSet('bypass', 'inspect', 'unknownFutureValue')]
        [System.String]
        $DefaultAction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Rules,

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

    Write-Verbose -Message "Getting configuration of AAD GSA TLS Inspection Policy {$Name}"

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

            $nullResult = $PSBoundParameters
            $nullResult.Ensure = 'Absent'

            $instance = $null
            if (-not [System.String]::IsNullOrEmpty($Id))
            {
                Write-Verbose -Message "Retrieving TLS Inspection Policy by Id {$Id}"
                $instance = Get-MgBetaNetworkAccessTlInspectionPolicy -TlsInspectionPolicyId $Id `
                    -ExpandProperty 'policyRules' `
                    -ErrorAction SilentlyContinue
            }
            if ($null -eq $instance)
            {
                Write-Verbose -Message "Retrieving TLS Inspection Policy by Name {$Name}"
                $instance = Get-MgBetaNetworkAccessTlInspectionPolicy -All `
                    -ExpandProperty 'policyRules' `
                    -ErrorAction SilentlyContinue | Where-Object -FilterScript { $_.Name -eq $Name }
            }
        }
        else
        {
            $instance = $Script:exportedInstance
        }

        if ($null -eq $instance)
        {
            Write-Verbose -Message "Could not find AAD GSA TLS Inspection Policy {$Name}"
            return $nullResult
        }

        $rulesValue = @()
        if ($null -ne $instance.PolicyRules)
        {
            $rulesValue = Get-MicrosoftGraphNetworkAccessTlsInspectionPolicyRules -PolicyRules $instance.PolicyRules
        }

        $results = @{
            Name                  = $instance.Name
            Id                    = $instance.Id
            Description           = $instance.Description
            DefaultAction         = $instance.Settings.DefaultAction
            Rules                 = $rulesValue
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

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateSet('bypass', 'inspect', 'unknownFutureValue')]
        [System.String]
        $DefaultAction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Rules,

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

    $instanceParams = @{
        name        = $Name
        description = $Description
        settings    = @{
            defaultAction = $DefaultAction
        }
    }

    $policyId = $currentInstance.Id

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new AAD GSA TLS Inspection Policy {$Name}"
        $newInstance = New-MgBetaNetworkAccessTlInspectionPolicy -BodyParameter $instanceParams
        $policyId = $newInstance.Id
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating AAD GSA TLS Inspection Policy {$Name} with Id {$($currentInstance.Id)}"
        Update-MgBetaNetworkAccessTlInspectionPolicy -TlsInspectionPolicyId $currentInstance.Id `
            -BodyParameter $instanceParams
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing AAD GSA TLS Inspection Policy {$Name} with Id {$($currentInstance.Id)}"
        Remove-MgBetaNetworkAccessTlInspectionPolicy -TlsInspectionPolicyId $currentInstance.Id
    }

    if ($Ensure -eq 'Present' -and $null -ne $Rules)
    {
        $currentRules = @()
        if ($currentInstance.Ensure -eq 'Present' -and $null -ne $currentInstance.Rules)
        {
            $currentRules = $currentInstance.Rules
        }

        $matchedCurrentRuleIds = @()
        foreach ($desiredRule in $Rules)
        {
            $destinationsBody = @()
            foreach ($destination in $desiredRule.Destinations)
            {
                $destinationsBody += @{
                    '@odata.type' = "#microsoft.graph.networkaccess.$($destination.Type)"
                    values        = $destination.Values
                }
            }
            $ruleBody = @{
                '@odata.type'      = '#microsoft.graph.networkaccess.tlsInspectionRule'
                name               = $desiredRule.Name
                priority           = $desiredRule.Priority
                description        = $desiredRule.Description
                action             = $desiredRule.Action
                settings           = @{
                    status = $desiredRule.Status
                }
                matchingConditions = @{
                    destinations = $destinationsBody
                }
            }

            $matchedRule = $currentRules | Where-Object -FilterScript { $_.Id -notin $matchedCurrentRuleIds -and $_.Name -eq $desiredRule.Name } | Select-Object -First 1

            if ($null -ne $matchedRule)
            {
                $matchedCurrentRuleIds += $matchedRule.Id
                Write-Verbose -Message "Updating TLS Inspection Rule {$($desiredRule.Name)} with Id {$($matchedRule.Id)}"
                Update-MgBetaNetworkAccessTlInspectionPolicyRule -TlsInspectionPolicyId $policyId `
                    -PolicyRuleId $matchedRule.Id `
                    -BodyParameter $ruleBody
            }
            else
            {
                Write-Verbose -Message "Creating new TLS Inspection Rule {$($desiredRule.Name)}"
                New-MgBetaNetworkAccessTlInspectionPolicyRule -TlsInspectionPolicyId $policyId `
                    -BodyParameter $ruleBody
            }
        }

        foreach ($currentRule in $currentRules)
        {
            if ($currentRule.Id -notin $matchedCurrentRuleIds)
            {
                Write-Verbose -Message "Removing TLS Inspection Rule {$($currentRule.Name)} with Id {$($currentRule.Id)}"
                Remove-MgBetaNetworkAccessTlInspectionPolicyRule -TlsInspectionPolicyId $policyId `
                    -PolicyRuleId $currentRule.Id
            }
        }
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
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateSet('bypass', 'inspect', 'unknownFutureValue')]
        [System.String]
        $DefaultAction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Rules,

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
        [array] $exportedInstances = Get-MgBetaNetworkAccessTlInspectionPolicy -All -ExpandProperty 'policyRules' -ErrorAction Stop

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
                Id                    = $config.Id
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

            $Script:exportedInstance = $config
            $Results = Get-TargetResource @params

            if ($null -ne $Results.Rules -and $Results.Rules.Count -gt 0)
            {
                $complexMapping = @(
                    @{
                        Name            = 'Rules'
                        CimInstanceName = 'AADGSATLSInspectionPolicyRule'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'Destinations'
                        CimInstanceName = 'AADGSATLSInspectionPolicyRuleDestination'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.Rules `
                    -CIMInstanceName 'AADGSATLSInspectionPolicyRule' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.Rules = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('Rules') | Out-Null
                }
            }
            else
            {
                $Results.Remove('Rules') | Out-Null
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('Rules')
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

function Get-MicrosoftGraphNetworkAccessTlsInspectionPolicyRules
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable[]])]
    param
    (
        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [System.Object[]]
        $PolicyRules
    )

    $newPolicyRules = @()
    foreach ($rule in $PolicyRules)
    {
        # GSA auto-creates these two system rules on every policy; they are not user-managed.
        if ($rule.Description -like 'Auto-created*' -and ($rule.Priority -eq 50 -or $rule.Priority -eq 65000))
        {
            continue
        }

        $destinationsValue = @()
        foreach ($destination in $rule.MatchingConditions.Destinations)
        {
            $destinationsValue += @{
                Type   = $destination.'@odata.type'.Replace('#microsoft.graph.networkaccess.', '')
                Values = [System.String[]]$destination.Values
            }
        }
        $newPolicyRules += [ordered]@{
            Id           = $rule.Id
            Name         = $rule.Name
            Priority     = [System.UInt32]$rule.Priority
            Description  = $rule.Description
            Action       = $rule.Action
            Status       = $rule.Settings.Status
            Destinations = $destinationsValue
        }
    }

    ,$newPolicyRules
}

Export-ModuleMember -Function *-TargetResource
