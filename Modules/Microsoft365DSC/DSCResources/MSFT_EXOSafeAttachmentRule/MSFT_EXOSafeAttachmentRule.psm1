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
        $SafeAttachmentPolicy,

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

    Write-Verbose -Message "Getting configuration of SafeAttachmentRule for $Identity"
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
            $SafeAttachmentRules = Get-SafeAttachmentRule -ErrorAction Stop
        }
        catch
        {
            Close-SessionsAndReturnError -ExceptionMessage $_.Exception
            $Message = "Error calling {Get-SafeAttachmentRule}"
            New-M365DSCLogEntry -Error $_ -Message $Message -Source $MyInvocation.MyCommand.ModuleName
        }
        $SafeAttachmentRule = $SafeAttachmentRules | Where-Object -FilterScript { $_.Identity -eq $Identity }
        if (-not $SafeAttachmentRule)
        {
            Write-Verbose -Message "SafeAttachmentRule $($Identity) does not exist."
            return $nullReturn
        }
        else
        {
            $result = @{
                Ensure                    = 'Present'
                Identity                  = $SafeAttachmentRule.Identity
                SafeAttachmentPolicy      = $SafeAttachmentRule.SafeAttachmentPolicy
                Comments                  = $SafeAttachmentRule.Comments
                Enabled                   = $true
                ExceptIfRecipientDomainIs = $SafeAttachmentRule.ExceptIfRecipientDomainIs
                ExceptIfSentTo            = $SafeAttachmentRule.ExceptIfSentTo
                ExceptIfSentToMemberOf    = $SafeAttachmentRule.ExceptIfSentToMemberOf
                Priority                  = $SafeAttachmentRule.Priority
                RecipientDomainIs         = $SafeAttachmentRule.RecipientDomainIs
                SentTo                    = $SafeAttachmentRule.SentTo
                SentToMemberOf            = $SafeAttachmentRule.SentToMemberOf
                Credential        = $Credential
                ApplicationId             = $ApplicationId
                CertificateThumbprint     = $CertificateThumbprint
                CertificatePath           = $CertificatePath
                CertificatePassword       = $CertificatePassword
                TenantId                  = $TenantId
            }
            if ('Enabled' -eq $SafeAttachmentRule.State)
            {
                # Accounts for Get-SafeAttachmentRule returning 'State' instead of 'Enabled' used by New/Set
                $result.Enabled = $true
            }
            else
            {
                $result.Enabled = $false
            }

            Write-Verbose -Message "Found SafeAttachmentRule $($Identity)"
            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
            return $result
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
        $SafeAttachmentPolicy,

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

    Write-Verbose -Message "Setting configuration of SafeAttachmentRule for $Identity"
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

    $SafeAttachmentRules = Get-SafeAttachmentRule
    $SafeAttachmentRule = $SafeAttachmentRules | Where-Object -FilterScript { $_.Identity -eq $Identity }
    $SafeAttachmentRuleParams = [System.Collections.Hashtable]($PSBoundParameters)
    $SafeAttachmentRuleParams.Remove('Ensure') | Out-Null
    $SafeAttachmentRuleParams.Remove('Credential') | Out-Null
    $SafeAttachmentRuleParams.Remove('ApplicationId') | Out-Null
    $SafeAttachmentRuleParams.Remove('TenantId') | Out-Null
    $SafeAttachmentRuleParams.Remove('CertificateThumbprint') | Out-Null
    $SafeAttachmentRuleParams.Remove('CertificatePath') | Out-Null
    $SafeAttachmentRuleParams.Remove('CertificatePassword') | Out-Null

    if (('Present' -eq $Ensure ) -and (-not $SafeAttachmentRule))
    {
        New-EXOSafeAttachmentRule -SafeAttachmentRuleParams $PSBoundParameters
    }

    elseif (('Present' -eq $Ensure ) -and ($SafeAttachmentRule))
    {
         if ($SafeAttachmentRuleParams.Enabled -and ('Disabled' -eq $SafeAttachmentRule.State))
        {
            # New-SafeAttachmentRule has the Enabled parameter, Set-SafeAttachmentRule does not.
            # There doesn't appear to be any way to change the Enabled state of a rule once created.
            Write-Verbose -Message "Removing SafeAttachmentRule $($Identity) in order to change Enabled state."
            Remove-SafeAttachmentRule -Identity $Identity -Confirm:$false
            New-EXOSafeAttachmentRule -SafeAttachmentRuleParams $SafeAttachmentRuleParams
        }
        else
        {
            if ($SafeAttachmentRuleParams.SafeAttachmentPolicy -ne $SafeAttachmentRule.SafeAttachmentPolicy)
            {
                Set-EXOSafeAttachmentRule -SafeAttachmentRuleParams $SafeAttachmentRuleParams
            }
            else
            {
                $SafeAttachmentRuleParams.Remove('SafeAttachmentPolicy')
                Set-EXOSafeAttachmentRule -SafeAttachmentRuleParams $SafeAttachmentRuleParams
            }
        }
    }

    elseif (('Absent' -eq $Ensure ) -and ($SafeAttachmentRule))
    {
        Write-Verbose -Message "Removing SafeAttachmentRule $($Identity)"
        Remove-SafeAttachmentRule -Identity $Identity -Confirm:$false
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
        $SafeAttachmentPolicy,

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

    Write-Verbose -Message "Testing configuration of SafeAttachmentRule for $Identity"

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

    $dscContent = ''
    try
    {
        if (Confirm-ImportedCmdletIsAvailable -CmdletName Get-SafeAttachmentRule)
        {
            [array]$SafeAttachmentRules = Get-SafeAttachmentRule
            $i = 1

            if ($SafeAttachmentRules.Length -eq 0)
            {
                Write-Host $Global:M365DSCEmojiGreenCheckMark
            }
            else
            {
                Write-Host "`r`n" -NoNewline
            }

            foreach ($SafeAttachmentRule in $SafeAttachmentRules)
            {
                Write-Host "    |---[$i/$($SafeAttachmentRules.Length)] $($SafeAttachmentRule.Identity)" -NoNewline
                $Params = @{
                    Identity              = $SafeAttachmentRule.Identity
                    SafeAttachmentPolicy  = $SafeAttachmentRule.SafeAttachmentPolicy
                    Credential    = $Credential
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
        }
        else
        {
            Write-Host "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant doesn't have access to the Safe Attachment Rule API."
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
