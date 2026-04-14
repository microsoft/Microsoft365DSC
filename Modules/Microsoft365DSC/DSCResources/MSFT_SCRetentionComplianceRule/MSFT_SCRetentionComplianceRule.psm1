Confirm-M365DSCModuleDependency -ModuleName 'MSFT_SCRetentionComplianceRule'

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
        $Comment,

        [Parameter()]
        [System.String[]]
        $ExcludedItemClasses,

        [Parameter()]
        [System.String]
        $RetentionDuration,

        [Parameter()]
        [ValidateSet('Days', 'Months', 'Years')]
        [System.String]
        $RetentionDurationDisplayHint = 'Days',

        [Parameter()]
        [System.String]
        $ContentMatchQuery,

        [Parameter()]
        [ValidateSet('CreationAgeInDays', 'ModificationAgeInDays')]
        [System.String]
        $ExpirationDateOption,

        [Parameter()]
        [ValidateSet('Delete', 'Keep', 'KeepAndDelete')]
        [System.String]
        $RetentionComplianceAction,

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration of RetentionComplianceRule for $Name"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Name -ne $Name)
        {
            $null = New-M365DSCConnection -Workload 'SecurityComplianceCenter' `
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

            $RuleObject = Invoke-M365DSCCommand -ScriptBlock { Get-RetentionComplianceRule -Identity $Name -ErrorAction Stop } -SuppressNotFoundError

            if ($null -eq $RuleObject)
            {
                Write-Verbose -Message "RetentionComplianceRule $($Name) does not exist."
                return $nullReturn
            }
        }
        else
        {
            $RuleObject = $Script:exportedInstance
        }

        Write-Verbose "Found existing RetentionComplianceRule $($Name)"
        $AssociatedPolicy = Invoke-M365DSCCommand -ScriptBlock { Get-RetentionCompliancePolicy -Identity $RuleObject.Policy -ErrorAction Stop }
        $RetentionComplianceActionValue = $null
        if (-not [System.String]::IsNullOrEmpty($ruleObject.RetentionComplianceAction))
        {
            $RetentionComplianceActionValue = $RuleObject.RetentionComplianceAction
        }
        $result = @{
            Name                         = $RuleObject.Name
            Comment                      = $RuleObject.Comment
            Policy                       = $AssociatedPolicy.Name
            RetentionDuration            = $RuleObject.RetentionDuration
            RetentionComplianceAction    = $RetentionComplianceActionValue
            RetentionDurationDisplayHint = $RuleObject.RetentionDurationDisplayHint
            ExpirationDateOption         = $RuleObject.ExpirationDateOption
            Credential                   = $Credential
            ApplicationId                = $ApplicationId
            TenantId                     = $TenantId
            CertificateThumbprint        = $CertificateThumbprint
            CertificatePath              = $CertificatePath
            CertificatePassword          = $CertificatePassword
            Ensure                       = 'Present'
            AccessTokens                 = $AccessTokens
        }
        if (-not $associatedPolicy.TeamsPolicy)
        {
            $result.Add('ExcludedItemClasses', $RuleObject.ExcludedItemClasses)
            $result.Add('ContentMatchQuery', $RuleObject.ContentMatchQuery)
        }

        Write-Verbose -Message "Found RetentionComplianceRule $($Name)"
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
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Policy,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [System.String[]]
        $ExcludedItemClasses,

        [Parameter()]
        [System.String]
        $RetentionDuration,

        [Parameter()]
        [ValidateSet('Days', 'Months', 'Years')]
        [System.String]
        $RetentionDurationDisplayHint = 'Days',

        [Parameter()]
        [System.String]
        $ContentMatchQuery,

        [Parameter()]
        [ValidateSet('CreationAgeInDays', 'ModificationAgeInDays')]
        [System.String]
        $ExpirationDateOption,

        [Parameter()]
        [ValidateSet('Delete', 'Keep', 'KeepAndDelete')]
        [System.String]
        $RetentionComplianceAction,

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Setting configuration of RetentionComplianceRule for $Name"

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

    $CurrentRule = Get-TargetResource @PSBoundParameters

    if ($Ensure -eq 'Present' -and $CurrentRule.Ensure -eq 'Absent')
    {
        $CreationParams = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

        Write-Verbose -Message 'Checking to see if the policy is a Teams based one.'
        $RuleObject = Get-RetentionComplianceRule -Identity $Name `
            -ErrorAction SilentlyContinue
        $AssociatedPolicy = Get-RetentionCompliancePolicy $Policy

        if ($AssociatedPolicy.TeamsPolicy)
        {
            Write-Verbose -Message 'The current policy is a Teams based one, removing invalid parameters for Creation.'
            if ($CreationParams.ContainsKey('ApplyComplianceTag'))
            {
                $CreationParams.Remove('ApplyComplianceTag') | Out-Null
            }
            if ($CreationParams.ContainsKey('ContentContainsSensitiveInformation'))
            {
                $CreationParams.Remove('ContentContainsSensitiveInformation') | Out-Null
            }
            if ($CreationParams.ContainsKey('ContentMatchQuery'))
            {
                $CreationParams.Remove('ContentMatchQuery') | Out-Null
            }
            if ($CreationParams.ContainsKey('ExcludedItemClasses'))
            {
                $CreationParams.Remove('ExcludedItemClasses') | Out-Null
            }
            if ($CreationParams.ContainsKey('ExpirationDateOption'))
            {
                $CreationParams.Remove('ExpirationDateOption') | Out-Null
            }
            if ($CreationParams.ContainsKey('PublishComplianceTag'))
            {
                $CreationParams.Remove('PublishComplianceTag') | Out-Null
            }
            if ($CreationParams.ContainsKey('RetentionDurationDisplayHint'))
            {
                $CreationParams.Remove('RetentionDurationDisplayHint') | Out-Null
            }
        }

        Write-Verbose -Message "Creating new RetentionComplianceRule with values:`r`n$(Convert-M365DscHashtableToString -Hashtable $CreationParams)"
        New-RetentionComplianceRule @CreationParams
    }
    elseif ($Ensure -eq 'Present' -and $CurrentRule.Ensure -eq 'Present')
    {
        $CreationParams = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
        $CreationParams.Remove('Name')
        $CreationParams.Add('Identity', $Name)
        $CreationParams.Remove('Policy')

        Write-Verbose -Message 'Checking to see if the policy is a Teams based one.'
        $RuleObject = Get-RetentionComplianceRule -Identity $Name `
            -ErrorAction SilentlyContinue
        $AssociatedPolicy = Get-RetentionCompliancePolicy $RuleObject.Policy

        if ($AssociatedPolicy.TeamsPolicy)
        {
            Write-Verbose -Message 'The current policy is a Teams based one, removing invalid parameters for Update.'

            if ($CreationParams.ContainsKey('ApplyComplianceTag'))
            {
                $CreationParams.Remove('ApplyComplianceTag') | Out-Null
            }
            if ($CreationParams.ContainsKey('ContentContainsSensitiveInformation'))
            {
                $CreationParams.Remove('ContentContainsSensitiveInformation') | Out-Null
            }
            if ($CreationParams.ContainsKey('ContentMatchQuery'))
            {
                $CreationParams.Remove('ContentMatchQuery') | Out-Null
            }
            if ($CreationParams.ContainsKey('ExcludedItemClasses'))
            {
                $CreationParams.Remove('ExcludedItemClasses') | Out-Null
            }
            if ($CreationParams.ContainsKey('ExpirationDateOption'))
            {
                $CreationParams.Remove('ExpirationDateOption') | Out-Null
            }
            if ($CreationParams.ContainsKey('PublishComplianceTag'))
            {
                $CreationParams.Remove('PublishComplianceTag') | Out-Null
            }
            if ($CreationParams.ContainsKey('RetentionDurationDisplayHint'))
            {
                $CreationParams.Remove('RetentionDurationDisplayHint') | Out-Null
            }
        }

        Write-Verbose -Message "Updating RetentionComplianceRule with values:`r`n$(Convert-M365DscHashtableToString -Hashtable $CreationParams)"

        $success = $false
        $retries = 1
        while (!$success -and $retries -le 10)
        {
            try
            {
                Set-RetentionComplianceRule @CreationParams -ErrorAction Stop
                $success = $true
            }
            catch
            {
                if ($_.Exception.Message -like '*are being deployed. Once deployed, additional actions can be performed*')
                {
                    Write-Verbose -Message "The associated policy has pending changes being deployed. Waiting 30 seconds for a maximum of 300 seconds (5 minutes). Total time waited so far {$($retries * 30) seconds}"
                    Start-Sleep -Seconds 30
                }
                else
                {
                    $success = $true
                }
            }
            $retries++
        }
    }
    elseif ($Ensure -eq 'Absent' -and $CurrentPolicy.Ensure -eq 'Present')
    {
        # If the Rule exists and it shouldn't, simply remove it;
        Remove-RetentionComplianceRule -Identity $Name
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
        $Comment,

        [Parameter()]
        [System.String[]]
        $ExcludedItemClasses,

        [Parameter()]
        [System.String]
        $RetentionDuration,

        [Parameter()]
        [ValidateSet('Days', 'Months', 'Years')]
        [System.String]
        $RetentionDurationDisplayHint = 'Days',

        [Parameter()]
        [System.String]
        $ContentMatchQuery,

        [Parameter()]
        [ValidateSet('CreationAgeInDays', 'ModificationAgeInDays')]
        [System.String]
        $ExpirationDateOption,

        [Parameter()]
        [ValidateSet('Delete', 'Keep', 'KeepAndDelete')]
        [System.String]
        $RetentionComplianceAction,

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'SecurityComplianceCenter' `
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
        [array]$policies = Get-RetentionCompliancePolicy -ErrorAction Stop

        $j = 1
        $dscContent = ''
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
            [array]$rules = Get-RetentionComplianceRule -Policy $policy.Name
            Write-M365DSCHost -Message "    Policy [$j/$($policies.Length)] $($policy.Name)"
            $i = 1

            foreach ($rule in $rules)
            {
                if ($null -ne $Global:M365DSCExportResourceInstancesCount)
                {
                    $Global:M365DSCExportResourceInstancesCount++
                }

                Write-M365DSCHost -Message "        |---[$i/$($rules.Length)] $($rule.Name)" -DeferWrite

                $Script:exportedInstance = $rule
                $Results = Get-TargetResource @PSBoundParameters `
                    -Name $rule.Name `
                    -Policy $rule.Policy

                if ([System.String]::IsNullOrEmpty($Results.ExpirationDateOption))
                {
                    $Results.Remove('ExpirationDateOption') | Out-Null
                }
                $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -Credential $Credential
                $dscContent += $currentDSCBlock
                Save-M365DSCPartialExport -Content $currentDSCBlock `
                    -FileName $Global:PartialExportFileName
                Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
                $i++
            }
            $j++
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
