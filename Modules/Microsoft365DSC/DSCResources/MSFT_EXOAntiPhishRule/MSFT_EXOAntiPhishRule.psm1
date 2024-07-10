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
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
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
    try
    {
        Write-Verbose -Message 'Global ExchangeOnlineSession status:'
        Write-Verbose -Message "$( Get-PSSession -ErrorAction SilentlyContinue | Where-Object -FilterScript { $_.Name -eq 'ExchangeOnline' } | Out-String)"

        try
        {
            $AntiPhishRules = Get-AntiPhishRule -ErrorAction SilentlyContinue
        }
        catch
        {
            New-M365DSCLogEntry -Message "Couldn't get AntiPhishRules" `
                -Exception $_ `
                -Source $MyInvocation.MyCommand.ModuleName
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
                    Managedidentity           = $ManagedIdentity.IsPresent
                    TenantId                  = $TenantId
                    AccessTokens              = $AccessTokens
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
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

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
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Setting configuration of AntiPhishRule for $Identity"

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

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $BoundParameters = ([System.Collections.Hashtable]$PSBoundParameters).Clone()
    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Absent')
    {
        $BoundParameters.Add('Name', $Identity) | Out-Null
        $BoundParameters.Remove('Identity') | Out-Null

        # Make sure that the associated Policy exists;
        $AssociatedPolicy = Get-AntiPhishPolicy -Identity $AntiPhishPolicy -ErrorAction 'SilentlyContinue'
        if ($null -eq $AssociatedPolicy)
        {
            throw "Error attempting to create EXOAntiPhishRule {$Identity}. The specified AntiPhishPolicy {$AntiPhishPolicy} " + `
                "doesn't exist. Make sure you either create it first or specify a valid policy."
        }

        # New-AntiPhishRule has the Enabled parameter, Set-AntiPhishRule does not.
        # There doesn't appear to be any way to change the Enabled state of a rule once created.
        if ($CurrentValues.State -eq 'Disabled')
        {
            Write-Verbose -Message "AntiPhishRule {$Identity} already exists but is disabled, we need to delete it first. Deleting Rule"
            Remove-AntiphishRule -Identity $Identity -Confirm:$false
        }

        Write-Verbose -Message "Creating AntiPhishRule {$Identity}"
        New-AntiPhishRule @BoundParameters
    }
    elseif ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Present')
    {
        $BoundParameters.Remove('Enabled') | Out-Null

        # Make sure that the associated Policy exists;
        $AssociatedPolicy = Get-AntiPhishPolicy -Identity $AntiPhishPolicy -ErrorAction 'SilentlyContinue'
        if ($null -eq $AssociatedPolicy)
        {
            throw "Error attempting to create EXOAntiPhishRule {$Identity}. The specified AntiPhishPolicy {$AntiPhishPolicy} " + `
                "doesn't exist. Make sure you either create it first or specify a valid policy."
        }

        # Check to see if the specified policy already has the rule assigned;
        $existingRule = Get-AntiPhishRule | Where-Object -FilterScript { $_.AntiPhishPolicy -eq $AntiPhishPolicy }

        if ($null -ne $existingRule)
        {
            # The rule is already assigned to the policy, do try to update the AntiPhishPolicy parameter;
            $BoundParameters.Remove('AntiPhishPolicy') | Out-Null
        }

        Write-Verbose -Message "Updating AntiPhishRule {$Identity}."
        Set-AntiPhishRule @BoundParameters
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
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
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

    if ($null -eq $PSBoundParameters.Enabled)
    {
        Write-Verbose 'Removing Enabled from the list of Parameters to Test'
        $ValuesToCheck.Remove('Enabled') | Out-Null
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
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload $true

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
        $AntiPhishRules = Get-AntiphishRule -ErrorAction Stop
        $dscContent = ''
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
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-Host "    |---[$i/$($AntiPhishRules.Length)] $($Rule.Identity)" -NoNewline

            $Params = @{
                Identity              = $Rule.Identity
                AntiPhishPolicy       = $Rule.AntiPhishPolicy
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                Managedidentity       = $ManagedIdentity.IsPresent
                CertificatePath       = $CertificatePath
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
            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $i++
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
