function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.String]
        $AntiPhishPolicy,

        [Parameter()]
        [System.String]
        $Comments,

        [Parameter()]
        [System.Boolean]
        $Enabled = $true,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.String[]]
        $ExceptIfRecipientDomainIs = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfSentTo = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfSentToMemberOf = @(),

        [Parameter()]
        [uint32]
        $Priority,

        [Parameter()]
        [System.String[]]
        $RecipientDomainIs = @(),

        [Parameter()]
        [System.String[]]
        $SentTo = @(),

        [Parameter()]
        [System.String[]]
        $SentToMemberOf = @(),

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
        $CertificatePassword
    )

    Write-Verbose -Message "Getting configuration of AntiPhishRule for $Identity"

    if ($Global:CurrentModeIsExport)
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters `
            -SkipModuleReload $true
    }
    else
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters
    }

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"
    try
    {
        Write-Verbose -Message "Global ExchangeOnlineSession status:"
        Write-Verbose -Message "$( Get-PSSession -ErrorAction SilentlyContinue | Where-Object -FilterScript { $_.Name -eq 'ExchangeOnline' } | Out-String)"

        try
        {
            $AntiPhishRules = Get-AntiPhishRule -ErrorAction SilentlyContinue
        }
        catch
        {
            New-M365DSCLogEntry -Error $_ -Message "Couldn't get AntiPhishRules" -Source $MyInvocation.MyCommand.ModuleName
        }

        if ($null -ne $AntiPhishRules)
        {
            $AntiPhishRule = $AntiPhishRules | Where-Object -FilterScript { $_.Identity -eq $Identity }
            if ($null -eq $AntiPhishRule)
            {
                Write-Verbose -Message "AntiPhishRule $Identity does not exist."
                return $nullReturn
            }
            else
            {
                $result = @{
                    Identity                  = $Identity
                    AntiPhishPolicy           = $AntiPhishRule.AntiPhishPolicy
                    Comments                  = $AntiPhishRule.Comments
                    Enabled                   = $AntiPhishRule.RuleEnabled
                    ExceptIfRecipientDomainIs = $AntiPhishRule.ExceptIfRecipientDomainIs
                    ExceptIfSentTo            = $AntiPhishRule.ExceptIfSentTo
                    ExceptIfSentToMemberOf    = $AntiPhishRule.ExceptIfSentToMemberOf
                    Priority                  = $AntiPhishRule.Priority
                    RecipientDomainIs         = $AntiPhishRule.RecipientDomainIs
                    SentTo                    = $AntiPhishRule.SentTo
                    SentToMemberOf            = $AntiPhishRule.SentToMemberOf
                    Ensure                    = 'Present'
                    Credential                = $Credential
                    ApplicationId             = $ApplicationId
                    CertificateThumbprint     = $CertificateThumbprint
                    CertificatePath           = $CertificatePath
                    CertificatePassword       = $CertificatePassword
                    TenantId                  = $TenantId
                }
                if ('Enabled' -eq $AntiPhishRule.State)
                {
                    # Accounts for Get-AntiPhishRule returning 'State' instead of 'Enabled' used by New/Set
                    $result.Enabled = $true
                }

                Write-Verbose -Message "Found AntiPhishRule $Identity"
                Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
                return $result
            }
        }
        else
        {
            Write-Verbose -Message "AntiPhishRule $Identity does not exist."
            return $nullReturn
        }
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return $nullReturn
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.String]
        $AntiPhishPolicy,

        [Parameter()]
        [System.String]
        $Comments,

        [Parameter()]
        [System.Boolean]
        $Enabled = $true,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.String[]]
        $ExceptIfRecipientDomainIs = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfSentTo = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfSentToMemberOf = @(),

        [Parameter()]
        [uint32]
        $Priority,

        [Parameter()]
        [System.String[]]
        $RecipientDomainIs = @(),

        [Parameter()]
        [System.String[]]
        $SentTo = @(),

        [Parameter()]
        [System.String[]]
        $SentToMemberOf = @(),

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
        $CertificatePassword
    )

    Write-Verbose -Message "Setting configuration of AntiPhishRule for $Identity"

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    # Make sure that the associated Policy exists;
    $AssociatedPolicy = Get-AntiPhishPolicy -Identity $AntiPhishPolicy -ErrorAction 'SilentlyContinue'
    if ($null -eq $AssociatedPolicy)
    {
        throw "Error attempting to create EXOAntiPhishRule {$Identity}. The specified AntiPhishPolicy {$AntiPhishPolicy} " + `
            "doesn't exist. Make sure you either create it first or specify a valid policy."
    }

    $CurrentValues = Get-TargetResource @PSBoundParameters

    if ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Absent')
    {
        $CreationParams = [System.Collections.Hashtable]($PSBoundParameters)
        $CreationParams.Remove("Ensure") | Out-Null
        $CreationParams.Remove("Credential") | Out-Null
        $CreationParams.Add("Name", $Identity) | Out-Null
        $CreationParams.Remove("Identity") | Out-Null
        $CreationParams.Remove('ApplicationId') | Out-Null
        $CreationParams.Remove('TenantId') | Out-Null
        $CreationParams.Remove('CertificateThumbprint') | Out-Null
        $CreationParams.Remove('CertificatePath') | Out-Null
        $CreationParams.Remove('CertificatePassword') | Out-Null

        # New-AntiPhishRule has the Enabled parameter, Set-AntiPhishRule does not.
        # There doesn't appear to be any way to change the Enabled state of a rule once created.
        if ($CurrentValues.State -eq 'Disabled')
        {
            Write-Verbose -Message "AntiPhishRule {$Identity} already exists but is disabled, we need to delete it first. Deleting Rule"
            Remove-AntiphishRule -Identity $Identity -Confirm:$false
        }

        Write-Verbose -Message "Creating AntiPhishRule {$Identity}"
        New-AntiPhishRule @CreationParams
    }
    elseif ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Present')
    {
        $UpdateParams = $PSBoundParameters
        $UpdateParams.Remove("Ensure") | Out-Null
        $UpdateParams.Remove("Credential") | Out-Null
        $UpdateParams.Remove("Enabled") | Out-Null
        $UpdateParams.Remove('ApplicationId') | Out-Null
        $UpdateParams.Remove('TenantId') | Out-Null
        $UpdateParams.Remove('CertificateThumbprint') | Out-Null
        $UpdateParams.Remove('CertificatePath') | Out-Null
        $UpdateParams.Remove('CertificatePassword') | Out-Null

        # Check to see if the specified policy already has the rule assigned;
        $existingRule = Get-AntiPhishRule | Where-Object -FilterScript { $_.AntiPhishPolicy -eq $AntiPhishPolicy }

        if ($null -ne $existingRule)
        {
            # The rule is already assigned to the policy, do try to update the AntiPhishPolicy parameter;
            $UpdateParams.Remove("AntiPhishPolicy") | Out-Null
        }

        Write-Verbose -Message "Updating AntiPhishRule {$Identity}."
        Set-AntiPhishRule @UpdateParams
    }
    if ($Ensure -eq 'Absent' -and $CurrentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing AntiPhishRule [$Identity]"
        Remove-AntiPhishRule -Identity $Identity -Confirm:$false
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
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.String]
        $AntiPhishPolicy,

        [Parameter()]
        [System.String]
        $Comments,

        [Parameter()]
        [System.Boolean]
        $Enabled = $true,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.String[]]
        $ExceptIfRecipientDomainIs = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfSentTo = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfSentToMemberOf = @(),

        [Parameter()]
        [uint32]
        $Priority,

        [Parameter()]
        [System.String[]]
        $RecipientDomainIs = @(),

        [Parameter()]
        [System.String[]]
        $SentTo = @(),

        [Parameter()]
        [System.String[]]
        $SentToMemberOf = @(),

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
        $CertificatePassword
    )
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of AntiPhishRule for $Identity"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('CertificateThumbprint') | Out-Null
    $ValuesToCheck.Remove('CertificatePath') | Out-Null
    $ValuesToCheck.Remove('CertificatePassword') | Out-Null

    if ($null -eq $PSBoundParameters.Enabled)
    {
        Write-Verbose "Removing Enabled from the list of Parameters to Test"
        $ValuesToCheck.Remove("Enabled") | Out-Null
    }

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $TestResult"

    return $TestResult
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
        $CertificatePassword
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload $true

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        $AntiPhishRules = Get-AntiphishRule -ErrorAction Stop
        $dscContent = ""
        if ($AntiPhishRules.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        $i = 1
        foreach ($Rule in $AntiPhishRules)
        {
            Write-Host "    |---[$i/$($AntiPhishRules.Length)] $($Rule.Identity)" -NoNewline

            $Params = @{
                Identity              = $Rule.Identity
                AntiPhishPolicy       = $Rule.AntiPhishPolicy
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                CertificatePath       = $CertificatePath
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
            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $i++
        }
        return $dscContent
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return ""
    }
}

Export-ModuleMember -Function *-TargetResource
