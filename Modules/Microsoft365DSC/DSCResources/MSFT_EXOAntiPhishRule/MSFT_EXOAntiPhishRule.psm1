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
        $GlobalAdminAccount,

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
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    if ($Global:CurrentModeIsExport)
    {
        $ConnectionMode = New-M365DSCConnection -Platform 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters `
            -SkipModuleReload $true
    }
    else
    {
        $ConnectionMode = New-M365DSCConnection -Platform 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters
    }

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
                    GlobalAdminAccount        = $GlobalAdminAccount
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
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
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
        $GlobalAdminAccount,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'ExchangeOnline' `
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
        $CreationParams = $PSBoundParameters
        $CreationParams.Remove("Ensure") | Out-Null
        $CreationParams.Remove("GlobalAdminAccount") | Out-Null
        $CreationParams.Add("Name", $Identity) | Out-Null
        $CreationParams.Remove("Identity") | Out-Null

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
        $UpdateParams.Remove("GlobalAdminAccount") | Out-Null
        $UpdateParams.Remove("Enabled") | Out-Null

        # Check to see if the specified policy already has the rule assigned;
        $existingRule = Get-AntiPhishRule | Where-Object -FilterScript {$_.AntiPhishPolicy -eq $AntiPhishPolicy}

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
        $GlobalAdminAccount,

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

    Write-Verbose -Message "Testing configuration of AntiPhishRule for $Identity"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

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
        $GlobalAdminAccount,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    $ConnectionMode = New-M365DSCConnection -Platform 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload $true

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
            Write-Host "`r`n" -NoNewLine
        }
        $i = 1
        foreach ($Rule in $AntiPhishRules)
        {
            Write-Host "    |---[$i/$($AntiPhishRules.Length)] $($Rule.Identity)" -NoNewLine

            $Params = @{
                Identity              = $Rule.Identity
                AntiPhishPolicy       = $Rule.AntiPhishPolicy
                GlobalAdminAccount    = $GlobalAdminAccount
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                CertificatePath       = $CertificatePath
            }
            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            $dscContent += Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -GlobalAdminAccount $GlobalAdminAccount
            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $i++
        }
        return $dscContent
    }
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
        return ""
    }
}

Export-ModuleMember -Function *-TargetResource
