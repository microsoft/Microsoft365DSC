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
        $HostedOutboundSpamFilterPolicy,

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
        $ExceptIfSenderDomainIs = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfFrom = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfFromMemberOf = @(),

        [Parameter()]
        [uint32]
        $Priority,

        [Parameter()]
        [System.String[]]
        $SenderDomainIs = @(),

        [Parameter()]
        [System.String[]]
        $From = @(),

        [Parameter()]
        [System.String[]]
        $FromMemberOf = @(),

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

    Write-Verbose -Message "Getting configuration of HostedOutboundSpamFilterRule for $Identity"

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

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = 'Absent'
    try
    {
        try
        {
            $HostedOutboundSpamFilterRules = Get-HostedOutboundSpamFilterRule -ErrorAction Stop
        }
        catch
        {
            $Message = 'Error calling {Get-HostedOutboundSpamFilterRule}'
            New-M365DSCLogEntry -Message $Message `
                -Exception $_ `
                -Source $MyInvocation.MyCommand.ModuleName
        }

        $HostedOutboundSpamFilterRule = $HostedOutboundSpamFilterRules | Where-Object -FilterScript { $_.Identity -eq $Identity }
        if (-not $HostedOutboundSpamFilterRule)
        {
            Write-Verbose -Message "HostedOutboundSpamFilterRule $($Identity) does not exist."
            return $nullReturn
        }
        else
        {
            $result = @{
                Ensure                         = 'Present'
                Identity                       = $Identity
                HostedOutboundSpamFilterPolicy = $HostedOutboundSpamFilterRule.HostedOutboundSpamFilterPolicy
                Comments                       = $HostedOutboundSpamFilterRule.Comments
                Enabled                        = $false
                ExceptIfSenderDomainIs         = $HostedOutboundSpamFilterRule.ExceptIfSenderDomainIs
                ExceptIfFrom                   = $HostedOutboundSpamFilterRule.ExceptIfFrom
                ExceptIfFromMemberOf           = $HostedOutboundSpamFilterRule.ExceptIfFromMemberOf
                Priority                       = $HostedOutboundSpamFilterRule.Priority
                SenderDomainIs                 = $HostedOutboundSpamFilterRule.SenderDomainIs
                From                           = $HostedOutboundSpamFilterRule.From
                FromMemberOf                   = $HostedOutboundSpamFilterRule.FromMemberOf
                Credential                     = $Credential
                ApplicationId                  = $ApplicationId
                CertificateThumbprint          = $CertificateThumbprint
                CertificatePath                = $CertificatePath
                CertificatePassword            = $CertificatePassword
                Managedidentity                = $ManagedIdentity.IsPresent
                TenantId                       = $TenantId
                AccessTokens                   = $AccessTokens
            }

            if ('Enabled' -eq $HostedOutboundSpamFilterRule.State)
            {
                # Accounts for Get-HostedOutboundSpamFilterRule returning 'State' instead of 'Enabled' used by New/Set
                $result.Enabled = $true
            }
            else
            {
                $result.Enabled = $false
            }

            Write-Verbose -Message "Found HostedOutboundSpamFilterRule $($Identity)"
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
        $HostedOutboundSpamFilterPolicy,

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
        $ExceptIfSenderDomainIs = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfFrom = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfFromMemberOf = @(),

        [Parameter()]
        [uint32]
        $Priority,

        [Parameter()]
        [System.String[]]
        $SenderDomainIs = @(),

        [Parameter()]
        [System.String[]]
        $From = @(),

        [Parameter()]
        [System.String[]]
        $FromMemberOf = @(),

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

    Write-Verbose -Message "Setting configuration of HostedOutboundSpamFilterRule for $Identity"

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

    # Make sure that the associated Policy exists;
    $AssociatedPolicy = Get-HostedOutboundSpamFilterPolicy -Identity $HostedOutboundSpamFilterPolicy -ErrorAction 'SilentlyContinue'
    if ($null -eq $AssociatedPolicy)
    {
        throw "Error attempting to create EXOHostedOutboundSpamFilterRule {$Identity}. The specified HostedOutboundSpamFilterPolicy " + `
            "{$HostedOutboundSpamFilterPolicy} doesn't exist. Make sure you either create it first or specify a valid policy."
    }

    $CurrentValues = Get-TargetResource @PSBoundParameters

    if ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Absent')
    {
        $CreationParams = $PSBoundParameters
        $CreationParams.Remove('Ensure') | Out-Null
        $CreationParams.Remove('Credential') | Out-Null
        $CreationParams.Remove('ApplicationId') | Out-Null
        $CreationParams.Remove('TenantId') | Out-Null
        $CreationParams.Remove('CertificateThumbprint') | Out-Null
        $CreationParams.Remove('CertificatePath') | Out-Null
        $CreationParams.Remove('CertificatePassword') | Out-Null
        $CreationParams.Remove('ManagedIdentity') | Out-Null
        $CreationParams.Remove('AccessTokens') | Out-Null
        if ($Enabled -and ('Disabled' -eq $CurrentValues.State))
        {
            # New-HostedOutboundSpamFilterRule has the Enabled parameter, Set-HostedOutboundSpamFilterRule does not.
            # There doesn't appear to be any way to change the Enabled state of a rule once created.
            Write-Verbose -Message "Removing HostedOutboundSpamFilterRule {$Identity} in order to change Enabled state."
            Remove-HostedOutboundSpamFilterRule -Identity $Identity -Confirm:$false
        }
        Write-Verbose -Message "Creating new HostedOutboundSpamFilterRule {$Identity}"
        $CreationParams.Add('Name', $Identity)
        $CreationParams.Remove('Identity') | Out-Null
        New-HostedOutboundSpamFilterRule @CreationParams
    }
    elseif ($Ensure -eq 'Present' -and $CurrentValues -eq 'Present')
    {
        $UpdateParams = [System.Collections.Hashtable]($PSBoundParameters)
        $UpdateParams.Remove('Ensure') | Out-Null
        $UpdateParams.Remove('Credential') | Out-Null
        $UpdateParams.Remove('ApplicationId') | Out-Null
        $UpdateParams.Remove('TenantId') | Out-Null
        $UpdateParams.Remove('CertificateThumbprint') | Out-Null
        $UpdateParams.Remove('CertificatePath') | Out-Null
        $UpdateParams.Remove('CertificatePassword') | Out-Null
        $UpdateParams.Remove('ManagedIdentity') | Out-Null
        $UpdateParams.Remove('AccessTokens') | Out-Null
        Write-Verbose -Message "Updating HostedOutboundSpamFilterRule {$Identity}"
        Set-HostedOutboundSpamFilterRule @UpdateParams
    }
    elseif ($Ensure -eq 'Absent' -and $CurrentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing existing HostedOutboundSpamFilterRule {$Identity}."
        Remove-HostedOutboundSpamFilterRule -Identity $Identity -Confirm:$false
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
        $HostedOutboundSpamFilterPolicy,

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
        $ExceptIfSenderDomainIs = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfFrom = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfFromMemberOf = @(),

        [Parameter()]
        [uint32]
        $Priority,

        [Parameter()]
        [System.String[]]
        $SenderDomainIs = @(),

        [Parameter()]
        [System.String[]]
        $From = @(),

        [Parameter()]
        [System.String[]]
        $FromMemberOf = @(),

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

    Write-Verbose -Message "Testing configuration of HostedOutboundSpamFilterRule for $Identity"

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
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload $true

    try
    {
        [array] $HostedOutboundSpamFilterRules = Get-HostedOutboundSpamFilterRule -ErrorAction Stop
        $dscContent = ''

        $i = 1
        if ($HostedOutboundSpamFilterRules.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($HostedOutboundSpamFilterRule in $HostedOutboundSpamFilterRules)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-Host "    |---[$i/$($HostedOutboundSpamFilterRules.Count)] $($HostedOutboundSpamFilterRule.Identity)" -NoNewline
            $Params = @{
                Credential                     = $Credential
                Identity                       = $HostedOutboundSpamFilterRule.Identity
                HostedOutboundSpamFilterPolicy = $HostedOutboundSpamFilterRule.HostedOutboundSpamFilterPolicy
                ApplicationId                  = $ApplicationId
                TenantId                       = $TenantId
                CertificateThumbprint          = $CertificateThumbprint
                CertificatePassword            = $CertificatePassword
                Managedidentity                = $ManagedIdentity.IsPresent
                CertificatePath                = $CertificatePath
                AccessTokens                   = $AccessTokens
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
