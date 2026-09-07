Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADGSAWebContentFilteringPolicy'

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
        [ValidateSet('allow', 'block', 'unknownFutureValue')]
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

    Write-Verbose -Message "Getting configuration of AAD GSA Web Content Filtering Policy {$Name}"

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
                Write-Verbose -Message "Retrieving Web Content Filtering Policy by Id {$Id}"
                $instance = Get-MgBetaNetworkAccessWebFilteringPolicy -WebFilteringPolicyId $Id `
                    -ExpandProperty 'policyRules' `
                    -ErrorAction SilentlyContinue
            }
            if ($null -eq $instance)
            {
                Write-Verbose -Message "Retrieving Web Content Filtering Policy by Name {$Name}"
                $instance = Get-MgBetaNetworkAccessWebFilteringPolicy -All `
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
            Write-Verbose -Message "Could not find AAD GSA Web Content Filtering Policy {$Name}"
            return $nullResult
        }

        $rulesValue = @()
        if ($null -ne $instance.PolicyRules)
        {
            $rulesValue = Get-MicrosoftGraphNetworkAccessWebFilteringPolicyRules -PolicyRules $instance.PolicyRules
        }

        $results = @{
            Name                  = $instance.Name
            Id                    = $instance.Id
            Description           = $instance.Description
            DefaultAction         = Get-M365DSCWebFilteringActionValue -Action $instance.Settings.DefaultAction
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
        [ValidateSet('allow', 'block', 'unknownFutureValue')]
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
            defaultAction = Get-M365DSCWebFilteringActionBody -Action $DefaultAction
        }
    }

    $policyId = $currentInstance.Id

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new AAD GSA Web Content Filtering Policy {$Name}"
        $newInstance = New-MgBetaNetworkAccessWebFilteringPolicy -BodyParameter $instanceParams
        $policyId = $newInstance.Id
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating AAD GSA Web Content Filtering Policy {$Name} with Id {$($currentInstance.Id)}"
        Update-MgBetaNetworkAccessWebFilteringPolicy -WebFilteringPolicyId $currentInstance.Id `
            -BodyParameter $instanceParams
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing AAD GSA Web Content Filtering Policy {$Name} with Id {$($currentInstance.Id)}"
        Remove-MgBetaNetworkAccessWebFilteringPolicy -WebFilteringPolicyId $currentInstance.Id
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
                '@odata.type'      = '#microsoft.graph.networkaccess.webFilteringRule'
                name               = $desiredRule.Name
                priority           = $desiredRule.Priority
                description        = $desiredRule.Description
                action             = Get-M365DSCWebFilteringActionBody -Action $desiredRule.Action
                settings           = @{
                    status = $desiredRule.Status
                }
                matchingConditions = @{
                    destinations = @{
                        targets           = $destinationsBody
                        httpRequestMethod = $desiredRule.HttpRequestMethod
                    }
                    sources      = @{
                        sessionType = $desiredRule.SessionType
                    }
                }
            }

            $matchedRule = $currentRules | Where-Object -FilterScript { $_.Id -notin $matchedCurrentRuleIds -and $_.Name -eq $desiredRule.Name } | Select-Object -First 1

            if ($null -ne $matchedRule)
            {
                $matchedCurrentRuleIds += $matchedRule.Id
                Write-Verbose -Message "Updating Web Content Filtering Rule {$($desiredRule.Name)} with Id {$($matchedRule.Id)}"
                Update-MgBetaNetworkAccessWebFilteringPolicyRule -WebFilteringPolicyId $policyId `
                    -PolicyRuleId $matchedRule.Id `
                    -BodyParameter $ruleBody
            }
            else
            {
                Write-Verbose -Message "Creating new Web Content Filtering Rule {$($desiredRule.Name)}"
                New-MgBetaNetworkAccessWebFilteringPolicyRule -WebFilteringPolicyId $policyId `
                    -BodyParameter $ruleBody
            }
        }

        foreach ($currentRule in $currentRules)
        {
            if ($currentRule.Id -notin $matchedCurrentRuleIds)
            {
                Write-Verbose -Message "Removing Web Content Filtering Rule {$($currentRule.Name)} with Id {$($currentRule.Id)}"
                Remove-MgBetaNetworkAccessWebFilteringPolicyRule -WebFilteringPolicyId $policyId `
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
        [ValidateSet('allow', 'block', 'unknownFutureValue')]
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
        [array] $exportedInstances = Get-MgBetaNetworkAccessWebFilteringPolicy -All -ExpandProperty 'policyRules' -ErrorAction Stop

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
                        CimInstanceName = 'AADGSAWebContentFilteringPolicyRule'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'Destinations'
                        CimInstanceName = 'AADGSAWebContentFilteringPolicyRuleDestination'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.Rules `
                    -CIMInstanceName 'AADGSAWebContentFilteringPolicyRule' `
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

function Get-MicrosoftGraphNetworkAccessWebFilteringPolicyRules
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
        $destinationsValue = @()
        foreach ($destination in $rule.MatchingConditions.Destinations.Targets)
        {
            $destinationsValue += @{
                Type   = $destination.'@odata.type'.Replace('#microsoft.graph.networkaccess.', '')
                Values = [System.String[]]$destination.Values
            }
        }
        $newPolicyRules += [ordered]@{
            Id                = $rule.Id
            Name              = $rule.Name
            Priority          = [System.UInt32]$rule.Priority
            Description       = $rule.Description
            Action            = Get-M365DSCWebFilteringActionValue -Action $rule.Action
            Status            = $rule.Settings.Status
            HttpRequestMethod = $rule.MatchingConditions.Destinations.HttpRequestMethod
            SessionType       = $rule.MatchingConditions.Sources.SessionType
            Destinations      = $destinationsValue
        }
    }

    ,$newPolicyRules
}

function Get-M365DSCWebFilteringActionValue
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
        $Action
    )

    if ($null -eq $Action -or [System.String]::IsNullOrEmpty($Action.'@odata.type'))
    {
        return $null
    }

    $actionTypeName = $Action.'@odata.type'.Replace('#microsoft.graph.networkaccess.webFilteringAction', '')
    return $actionTypeName.Substring(0, 1).ToLower() + $actionTypeName.Substring(1)
}

function Get-M365DSCWebFilteringActionBody
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Action
    )

    $actionTypeName = $Action.Substring(0, 1).ToUpper() + $Action.Substring(1)
    return @{
        '@odata.type' = "#microsoft.graph.networkaccess.webFilteringAction$actionTypeName"
    }
}

Export-ModuleMember -Function *-TargetResource
