Confirm-M365DSCModuleDependency -ModuleName 'MSFT_TeamsTenantDialPlan'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateLength(1, 49)]
        [System.String]
        $Identity,

        [Parameter()]
        [ValidateLength(1, 512)]
        [System.String]
        $Description,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $NormalizationRules,

        [Parameter()]
        [ValidateLength(1, 49)]
        [System.String]
        $SimpleName,

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

    Write-Verbose -Message 'Getting configuration of Teams Tenant Dial Plan'

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Identity -ne $Identity)
        {
            $null = New-M365DSCConnection -Workload 'MicrosoftTeams' `
                -InboundParameters $PSBoundParameters

            #Ensure the proper dependencies are installed in the current environment.
            Confirm-M365DSCDependencies

            #region Telemetry
            $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
            $CommandName = $MyInvocation.MyCommand
            $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
                -CommandName $CommandName `
                -Parameters $PSBoundParameters
            Add-M365DSCTelemetryEvent -Data $data
            #endregion

            $nullReturn = $PSBoundParameters
            $nullReturn.Ensure = 'Absent'

            $config = Get-CsTenantDialPlan -Identity $Identity -ErrorAction 'SilentlyContinue'
        }
        else
        {
            $config = $Script:exportedInstance
        }

        if ($null -eq $config)
        {
            Write-Verbose -Message "Could not find existing Dial Plan {$Identity}"
            return $nullReturn
        }

        Write-Verbose -Message "Found existing Dial Plan {$Identity}"
        $rules = @()
        if ($config.NormalizationRules.Count -gt 0)
        {
            $rules = Get-M365DSCNormalizationRules -Rules $config.NormalizationRules
        }

        $result = @{
            Identity              = $Identity.Replace('Tag:', '')
            Description           = $config.Description
            NormalizationRules    = $rules
            SimpleName            = $config.SimpleName
            Credential            = $Credential
            Ensure                = 'Present'
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
        }

        return $result
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
        [ValidateLength(1, 49)]
        [System.String]
        $Identity,

        [Parameter()]
        [ValidateLength(1, 512)]
        [System.String]
        $Description,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $NormalizationRules,

        [Parameter()]
        [ValidateLength(1, 49)]
        [System.String]
        $SimpleName,

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

    Write-Verbose -Message 'Setting configuration of Teams Guest Calling'

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $boundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Absent')
    {
        Write-Verbose "Tenant Dial Plan {$Identity} doesn't exist but it should. Creating it."
        #region VoiceNormalizationRules
        $AllRules = @()
        # Ensure the VoiceNormalizationRules all exist
        foreach ($rule in $NormalizationRules)
        {
            # Need to create the rule
            Write-Verbose "Creating VoiceNormalizationRule {$($rule.Identity)}"
            $ruleObject = New-CsVoiceNormalizationRule -Identity "Global/$($rule.Identity.Replace('Tag:', ''))" `
                -Description $rule.Description `
                -Pattern $rule.Pattern `
                -Translation $rule.Translation `
                -InMemory

            $AllRules += $ruleObject
        }

        $boundParameters.NormalizationRules = @{ Add = $AllRules }
        New-CsTenantDialPlan @boundParameters
    }
    elseif ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Tenant Dial Plan {$Identity} already exists. Updating it."

        $desiredRules = @()
        foreach ($rule in $NormalizationRules)
        {
            $desiredRule = @{
                Identity            = $rule.Identity
                Description         = $rule.Description
                Pattern             = $rule.Pattern
                IsExternalExtension = $rule.IsExternalExtension
                Translation         = $rule.Translation
            }
            $desiredRules += $desiredRule
        }

        $boundParameters.Remove('NormalizationRules') | Out-Null
        Set-CsTenantDialPlan @boundParameters

        $differences = Get-M365DSCVoiceNormalizationRulesDifference -CurrentRules $CurrentValues.NormalizationRules -DesiredRules $desiredRules
        foreach ($ruleToAdd in $differences.RulesToAdd)
        {
            Write-Verbose "Adding new VoiceNormalizationRule {$($ruleToAdd.Identity)}"
            $ruleObject = New-CsVoiceNormalizationRule -Identity "Global/$($ruleToAdd.Identity.Replace('Tag:', ''))" `
                -Description $ruleToAdd.Description `
                -Pattern $ruleToAdd.Pattern `
                -Translation $ruleToAdd.Translation `
                -InMemory
            Write-Verbose 'VoiceNormalizationRule created'
            Set-CsTenantDialPlan -Identity $Identity -NormalizationRules @{ Add = $ruleObject }
            Write-Verbose 'Updated the Tenant Dial Plan'
        }
        foreach ($ruleToRemove in $differences.RulesToRemove)
        {
            if ($null -eq $plan)
            {
                $plan = Get-CsTenantDialPlan -Identity $Identity
            }
            $ruleObject = $plan.NormalizationRules | Where-Object -FilterScript { $_.Name -eq $ruleToRemove.Identity }

            if ($null -ne $ruleObject)
            {
                Write-Verbose "Removing VoiceNormalizationRule {$($ruleToRemove.Identity)}"
                Write-Verbose 'VoiceNormalizationRule created'
                Set-CsTenantDialPlan -Identity $Identity -NormalizationRules @{ Remove = $ruleObject }
                Write-Verbose 'Updated the Tenant Dial Plan'
            }
        }
        foreach ($ruleToUpdate in $differences.RulesToUpdate)
        {
            if ($null -eq $plan)
            {
                $plan = Get-CsTenantDialPlan -Identity $Identity
            }
            $ruleObject = $plan.NormalizationRules | Where-Object -FilterScript { $_.Name -eq $ruleToUpdate.Identity }

            if ($null -ne $ruleObject)
            {
                Write-Verbose "Updating VoiceNormalizationRule {$($ruleToUpdate.Identity)}"
                Set-CsTenantDialPlan -Identity $Identity -NormalizationRules @{ Remove = $ruleObject }
                $ruleObject = New-CsVoiceNormalizationRule -Identity "Global/$($ruleToUpdate.Identity.Replace('Tag:', ''))" `
                    -Description $ruleToUpdate.Description `
                    -Pattern $ruleToUpdate.Pattern `
                    -Translation $ruleToUpdate.Translation `
                    -InMemory
                Write-Verbose 'VoiceNormalizationRule Updated'
                Set-CsTenantDialPlan -Identity $Identity -NormalizationRules @{ Add = $ruleObject }
                Write-Verbose 'Updated the Tenant Dial Plan'
            }
        }
    }
    elseif ($Ensure -eq 'Absent' -and $CurrentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Tenant Dial Plan {$Identity} exists and shouldn't. Removing it."
        Remove-CsTenantDialPlan -Identity $Identity
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateLength(1, 49)]
        [System.String]
        $Identity,

        [Parameter()]
        [ValidateLength(1, 512)]
        [System.String]
        $Description,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $NormalizationRules,

        [Parameter()]
        [ValidateLength(1, 49)]
        [System.String]
        $SimpleName,

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
        $Filter = "*",

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

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        [array]$tenantDialPlans = Get-CsTenantDialPlan -Filter $Filter -ErrorAction Stop

        $dscContent = [System.Text.StringBuilder]::new()
        $i = 1
        Write-M365DSCHost -Message "`r`n" -DeferWrite
        foreach ($plan in $tenantDialPlans)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($tenantDialPlans.Count)] $($plan.Identity)" -DeferWrite
            $params = @{
                Identity              = $plan.Identity
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $plan
            $Results = Get-TargetResource @Params

            if ($null -ne $Results.NormalizationRules)
            {
                $complexMapping = @(
                    @{
                        Name            = 'NormalizationRules'
                        CimInstanceName = 'TeamsVoiceNormalizationRule'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.NormalizationRules `
                    -CIMInstanceName 'TeamsVoiceNormalizationRule' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.NormalizationRules = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('NormalizationRules') | Out-Null
                }
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('NormalizationRules')

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

function Get-M365DSCVoiceNormalizationRulesDifference
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter()]
        [System.Object[]]
        $CurrentRules,

        [Parameter(Mandatory = $true)]
        [System.Object[]]
        $DesiredRules
    )

    $differences = @{}
    $rulesToRemove = @()
    $rulesToAdd = @()
    $rulesToUpdate = @()
    foreach ($currentRule in $CurrentRules)
    {
        $equivalentDesiredRule = $DesiredRules | Where-Object -FilterScript { $_.Identity -eq $currentRule.Identity }

        # Case the current rule is not listed in the Desired rules, we need to remove it
        if ($null -eq $equivalentDesiredRule)
        {
            Write-Verbose "Adding Rule {$($currentRule.Identity)} to the RulesToRemove"
            $rulesToRemove += $currentRule
        }
        # Case the rule exists but is not in the desired state
        else
        {
            $differenceFound = $false
            foreach ($key in $currentRule.Keys)
            {
                if (-not [System.String]::IsNullOrEmpty($equivalentDesiredRule.$key) -and $currentRule.$key -ne $equivalentDesiredRule.$key)
                {
                    $differenceFound = $true
                }
            }

            if ($differenceFound)
            {
                Write-Verbose "Adding Rule {$($currentRule.Identity)} to the RulesToUpdate"
                $rulesToUpdate += $equivalentDesiredRule
            }
        }
    }

    foreach ($desiredRule in $DesiredRules)
    {
        $equivalentCurrentRule = $CurrentRules | Where-Object -FilterScript { $_.Identity -eq $desiredRule.Identity }

        # Case the desired rule doesn't exist, we need to create it
        if ($null -eq $equivalentCurrentRule)
        {
            Write-Verbose "Adding Rule {$($desiredRule.Identity)} to the RulesToAdd"
            $rulesToAdd += $desiredRule
        }
    }
    $differences.Add('RulesToAdd', $rulesToAdd)
    $differences.Add('RulesToUpdate', $rulesToUpdate)
    $differences.Add('RulesToRemove', $rulesToRemove)
    return $differences
}

function Get-M365DSCNormalizationRules
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable[]])]
    param
    (
        [Parameter(Mandatory = $true)]
        $Rules
    )

    if ($null -eq $Rules)
    {
        return $null
    }

    $result = @()
    foreach ($rule in $Rules)
    {
        $ruleName = $rule.Name.Replace('Tag:', '')
        $currentRule = @{
            Identity            = $ruleName
            Priority            = $rule.Priority
            Description         = $rule.Description
            Pattern             = $rule.Pattern
            Translation         = $rule.Translation
            IsInternalExtension = $rule.IsInternalExtension
        }
        if ([System.String]::IsNullOrEmpty($rule.Priority))
        {
            $currentRule.Remove('Priority') | Out-Null
        }
        $result += $currentRule
    }

    return ,$result
}

Export-ModuleMember -Function *-TargetResource
