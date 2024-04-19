function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [Boolean]
        $EnableSafeList = $false,

        [Parameter()]
        [System.String[]]
        $IPAllowList = @(),

        [Parameter()]
        [System.String[]]
        $IPBlockList = @(),

        [Parameter()]
        [Boolean]
        $MakeDefault = $false,

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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Setting configuration of HostedConnectionFilterPolicy for $Identity"
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
            $HostedConnectionFilterPolicy = Get-HostedConnectionFilterPolicy -Identity $Identity -ErrorAction Stop
        }
        catch
        {
            $Message = 'Error calling {Get-HostedConnectionFilterPolicy}'
            New-M365DSCLogEntry -Message $Message `
                -Exception $_ `
                -Source $MyInvocation.MyCommand.ModuleName
            return $nullReturn
        }

        if (-not $HostedConnectionFilterPolicy)
        {
            Write-Verbose -Message "HostedConnectionFilterPolicy [$($Identity)] does not exist."
            return $nullReturn
        }
        else
        {
            $result = @{
                Ensure                = 'Present'
                Identity              = $Identity
                AdminDisplayName      = $HostedConnectionFilterPolicy.AdminDisplayName
                EnableSafeList        = $HostedConnectionFilterPolicy.EnableSafeList
                IPAllowList           = $HostedConnectionFilterPolicy.IPAllowList
                IPBlockList           = $HostedConnectionFilterPolicy.IPBlockList
                MakeDefault           = $false
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
                Managedidentity       = $ManagedIdentity.IsPresent
                TenantId              = $TenantId
                AccessTokens          = $AccessTokens
            }

            if ($AntiPhishRule.IsDefault)
            {
                $result.MakeDefault = $true
            }

            Write-Verbose -Message "Found HostedConnectionFilterPolicy $($Identity)"
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

        [Parameter()]
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [Boolean]
        $EnableSafeList = $false,

        [Parameter()]
        [System.String[]]
        $IPAllowList = @(),

        [Parameter()]
        [System.String[]]
        $IPBlockList = @(),

        [Parameter()]
        [Boolean]
        $MakeDefault = $false,

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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Setting configuration of HostedConnectionFilterPolicy for $Identity"

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

    $CurrentInstance = Get-TargetResource @PSBoundParameters

    $HostedConnectionFilterPolicyParams = [System.Collections.Hashtable]($PSBoundParameters)
    $HostedConnectionFilterPolicyParams.Remove('Ensure') | Out-Null
    $HostedConnectionFilterPolicyParams.Remove('Credential') | Out-Null
    $HostedConnectionFilterPolicyParams.Remove('MakeDefault') | Out-Null
    $HostedConnectionFilterPolicyParams.Remove('ApplicationId') | Out-Null
    $HostedConnectionFilterPolicyParams.Remove('TenantId') | Out-Null
    $HostedConnectionFilterPolicyParams.Remove('CertificateThumbprint') | Out-Null
    $HostedConnectionFilterPolicyParams.Remove('CertificatePath') | Out-Null
    $HostedConnectionFilterPolicyParams.Remove('CertificatePassword') | Out-Null
    $HostedConnectionFilterPolicyParams.Remove('ManagedIdentity') | Out-Null
    $HostedConnectionFilterPolicyParams.Remove('AccessTokens') | Out-Null

    if ($HostedConnectionFilterPolicyParams.RuleScope)
    {
        $HostedConnectionFilterPolicyParams += @{
            Scope = $HostedConnectionFilterPolicyParams.RuleScope
        }
        $HostedConnectionFilterPolicyParams.Remove('RuleScope') | Out-Null
    }

    if (('Present' -eq $Ensure ) -and $CurrentInstance.Ensure -eq 'Absent')
    {
        $HostedConnectionFilterPolicyParams += @{
            Name = $HostedConnectionFilterPolicyParams.Identity
        }
        $HostedConnectionFilterPolicyParams.Remove('Identity') | Out-Null
        if ($PSBoundParameters.MakeDefault)
        {
            Write-Verbose -Message "Creating New Default Policy {$Identity}"
            New-HostedConnectionFilterPolicy @HostedConnectionFilterPolicyParams -MakeDefault
        }
        else
        {
            Write-Verbose -Message "Creating New Policy {$Identity}"
            New-HostedConnectionFilterPolicy @HostedConnectionFilterPolicyParams
        }

        Write-Verbose -Message "With Parameters: $(Convert-M365DscHashtableToString -Hashtable $HostedConnectionFilterPolicyParams)"
    }
    elseif (('Present' -eq $Ensure ) -and $CurrentInstance.Ensure -eq 'Present')
    {
        if ($PSBoundParameters.MakeDefault)
        {
            Set-HostedConnectionFilterPolicy @HostedConnectionFilterPolicyParams -MakeDefault -Confirm:$false
        }
        else
        {
            Set-HostedConnectionFilterPolicy @HostedConnectionFilterPolicyParams -Confirm:$false
        }
    }
    elseif (('Absent' -eq $Ensure ) -and $CurrentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing HostedConnectionFilterPolicy $($Identity)"
        Remove-HostedConnectionFilterPolicy -Identity $Identity -Confirm:$false
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

        [Parameter()]
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [Boolean]
        $EnableSafeList = $false,

        [Parameter()]
        [System.String[]]
        $IPAllowList = @(),

        [Parameter()]
        [System.String[]]
        $IPBlockList = @(),

        [Parameter()]
        [Boolean]
        $MakeDefault = $false,

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

    Write-Verbose -Message "Testing configuration of HostedConnectionFilterPolicy for $Identity"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = [System.Collections.Hashtable]($PSBoundParameters)

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
        [array]$HostedConnectionFilterPolicies = Get-HostedConnectionFilterPolicy
        $dscContent = ''

        if ($HostedConnectionFilterPolicies.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        $i = 1
        foreach ($HostedConnectionFilterPolicy in $HostedConnectionFilterPolicies)
        {
            $Params = @{
                Credential            = $Credential
                Identity              = $HostedConnectionFilterPolicy.Identity
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                Managedidentity       = $ManagedIdentity.IsPresent
                CertificatePath       = $CertificatePath
                AccessTokens          = $AccessTokens
            }
            Write-Host "    |---[$i/$($HostedConnectionFilterPolicies.Length)] $($HostedConnectionFilterPolicy.Identity)" -NoNewline
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
