Confirm-M365DSCModuleDependency -ModuleName 'MSFT_EXOHostedOutboundSpamFilterRule'

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

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Identity -ne $Identity)
        {
            $null = New-M365DSCConnection -Workload 'ExchangeOnline' `
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

            $HostedOutboundSpamFilterRule = Get-HostedOutboundSpamFilterRule -Identity $Identity -ErrorAction SilentlyContinue
            if (-not $HostedOutboundSpamFilterRule)
            {
                Write-Verbose -Message "HostedOutboundSpamFilterRule $($Identity) does not exist."
                return $nullReturn
            }
        }
        else
        {
            $HostedOutboundSpamFilterRule = $Script:exportedInstance
        }

        Write-Verbose -Message "Found HostedOutboundSpamFilterRule $($Identity)"

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
            ManagedIdentity                = $ManagedIdentity.IsPresent
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

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $BoundParameters = ([System.Collections.Hashtable]$PSBoundParameters).Clone()
    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $BoundParameters

    if ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Absent')
    {
        # Make sure that the associated Policy exists;
        $AssociatedPolicy = Get-HostedOutboundSpamFilterPolicy -Identity $HostedOutboundSpamFilterPolicy -ErrorAction 'SilentlyContinue'
        if ($null -eq $AssociatedPolicy)
        {
            throw "Error attempting to create EXOHostedOutboundSpamFilterRule {$Identity}. The specified HostedOutboundSpamFilterPolicy " + `
                "{$HostedOutboundSpamFilterPolicy} doesn't exist. Make sure you either create it first or specify a valid policy."
        }

        if ($Enabled -and ('Disabled' -eq $CurrentValues.State))
        {
            # New-HostedOutboundSpamFilterRule has the Enabled parameter, Set-HostedOutboundSpamFilterRule does not.
            # There doesn't appear to be any way to change the Enabled state of a rule once created.
            Write-Verbose -Message "Removing HostedOutboundSpamFilterRule {$Identity} in order to change Enabled state."
            Remove-HostedOutboundSpamFilterRule -Identity $Identity -Confirm:$false
        }
        Write-Verbose -Message "Creating new HostedOutboundSpamFilterRule {$Identity}"
        $BoundParameters.Add('Name', $Identity)
        $BoundParameters.Remove('Identity') | Out-Null
        New-HostedOutboundSpamFilterRule @BoundParameters
    }
    elseif ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Present')
    {
        $BoundParameters.Remove('Enabled') | Out-Null

        # Make sure that the associated Policy exists;
        $AssociatedPolicy = Get-HostedOutboundSpamFilterPolicy -Identity $HostedOutboundSpamFilterPolicy -ErrorAction 'SilentlyContinue'
        if ($null -eq $AssociatedPolicy)
        {
            throw "Error attempting to create EXOHostedOutboundSpamFilterRule {$Identity}. The specified HostedOutboundSpamFilterPolicy " + `
                "{$HostedOutboundSpamFilterPolicy} doesn't exist. Make sure you either create it first or specify a valid policy."
        }

        if ($CurrentValues.HostedOutboundSpamFilterPolicy -eq $BoundParameters.HostedOutboundSpamFilterPolicy)
        {
            $BoundParameters.Remove('HostedOutboundSpamFilterPolicy') | Out-Null
        }
        Write-Verbose -Message "Updating HostedOutboundSpamFilterRule {$Identity}"
        Set-HostedOutboundSpamFilterRule @BoundParameters
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
        -InboundParameters $PSBoundParameters

    try
    {
        [array] $HostedOutboundSpamFilterRules = Get-HostedOutboundSpamFilterRule -ErrorAction Stop
        $dscContent = [System.Text.StringBuilder]::new()

        $i = 1
        if ($HostedOutboundSpamFilterRules.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($HostedOutboundSpamFilterRule in $HostedOutboundSpamFilterRules)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($HostedOutboundSpamFilterRules.Count)] $($HostedOutboundSpamFilterRule.Identity)" -DeferWrite
            $Params = @{
                Credential                     = $Credential
                Identity                       = $HostedOutboundSpamFilterRule.Identity
                HostedOutboundSpamFilterPolicy = $HostedOutboundSpamFilterRule.HostedOutboundSpamFilterPolicy
                ApplicationId                  = $ApplicationId
                TenantId                       = $TenantId
                CertificateThumbprint          = $CertificateThumbprint
                CertificatePassword            = $CertificatePassword
                ManagedIdentity                = $ManagedIdentity.IsPresent
                CertificatePath                = $CertificatePath
                AccessTokens                   = $AccessTokens
            }
            $Script:exportedInstance = $HostedOutboundSpamFilterRule
            $Results = Get-TargetResource @Params
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            [void]$dscContent.Append($currentDSCBlock)
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            $i++
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

Export-ModuleMember -Function *-TargetResource
