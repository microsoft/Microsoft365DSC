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
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
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
        try
        {
            $SafeAttachmentRules = Get-SafeAttachmentRule -ErrorAction Stop
        }
        catch
        {
            $Message = 'Error calling {Get-SafeAttachmentRule}'
            New-M365DSCLogEntry -Message $Message `
                -Exception $_ `
                -Source $MyInvocation.MyCommand.ModuleName
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
                Credential                = $Credential
                ApplicationId             = $ApplicationId
                CertificateThumbprint     = $CertificateThumbprint
                CertificatePath           = $CertificatePath
                CertificatePassword       = $CertificatePassword
                Managedidentity           = $ManagedIdentity.IsPresent
                TenantId                  = $TenantId
                AccessTokens              = $AccessTokens
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
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Setting configuration of SafeAttachmentRule for $Identity"
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

    $SafeAttachmentRules = Get-SafeAttachmentRule
    $SafeAttachmentRule = $SafeAttachmentRules | Where-Object -FilterScript { $_.Identity -eq $Identity }
    $SafeAttachmentRuleParams = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if (('Present' -eq $Ensure ) -and (-not $SafeAttachmentRule))
    {
        $SafeAttachmentRuleParams.Add('Name', $SafeAttachmentRuleParams.Identity)
        $SafeAttachmentRuleParams.Remove('Identity') | Out-Null
        $SafeAttachmentRuleParams.Remove('MakeDefault') | Out-Null
        New-SafeAttachmentRule @SafeAttachmentRuleParams -Confirm:$false
    }
    elseif (('Present' -eq $Ensure ) -and ($SafeAttachmentRule))
    {
        if ($SafeAttachmentRuleParams.Enabled -and ('Disabled' -eq $SafeAttachmentRule.State))
        {
            # New-SafeAttachmentRule has the Enabled parameter, Set-SafeAttachmentRule does not.
            # There doesn't appear to be any way to change the Enabled state of a rule once created.
            Write-Verbose -Message "Removing SafeAttachmentRule $($Identity) in order to change Enabled state."
            Remove-SafeAttachmentRule -Identity $Identity -Confirm:$false
            $SafeAttachmentRuleParams.Add('Name', $SafeAttachmentRuleParams.Identity)
            $SafeAttachmentRuleParams.Remove('Identity') | Out-Null
            $SafeAttachmentRuleParams.Remove('MakeDefault') | Out-Null
            New-SafeAttachmentRule @SafeAttachmentRuleParams -Confirm:$false
        }
        else
        {
            $SafeAttachmentRuleParams.Remove('Enabled') | Out-Null
            if ($SafeAttachmentRuleParams.SafeAttachmentPolicy -eq $SafeAttachmentRule.SafeAttachmentPolicy)
            {
                $SafeAttachmentRuleParams.Remove('SafeAttachmentPolicy')
            }
            Write-Verbose -Message "Setting SafeAttachmentRule $($Identity)"
            Set-SafeAttachmentRule @SafeAttachmentRuleParams -Confirm:$false
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

    Write-Verbose -Message "Testing configuration of SafeAttachmentRule for $Identity"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters

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

    $dscContent = ''
    try
    {
        if (Confirm-ImportedCmdletIsAvailable -CmdletName Get-SafeAttachmentRule)
        {
            [array]$SafeAttachmentRules = Get-SafeAttachmentRule
            $i = 1

            if ($SafeAttachmentRules.Length -eq 0)
            {
                Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            }
            else
            {
                Write-M365DSCHost -Message "`r`n" -DeferWrite
            }

            foreach ($SafeAttachmentRule in $SafeAttachmentRules)
            {
                if ($null -ne $Global:M365DSCExportResourceInstancesCount)
                {
                    $Global:M365DSCExportResourceInstancesCount++
                }

                Write-M365DSCHost -Message "    |---[$i/$($SafeAttachmentRules.Length)] $($SafeAttachmentRule.Identity)" -DeferWrite
                $Params = @{
                    Identity              = $SafeAttachmentRule.Identity
                    SafeAttachmentPolicy  = $SafeAttachmentRule.SafeAttachmentPolicy
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
        }
        else
        {
            Write-M365DSCHost -Message "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant doesn't have access to the Safe Attachment Rule API."
        }
        return $dscContent
    }
    catch
    {
        Write-M365DSCHost -Message $Global:M365DSCEmojiRedX -CommitWrite

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
