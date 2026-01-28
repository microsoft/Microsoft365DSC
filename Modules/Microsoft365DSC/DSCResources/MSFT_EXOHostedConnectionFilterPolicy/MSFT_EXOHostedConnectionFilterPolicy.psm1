Confirm-M365DSCModuleDependency -ModuleName 'MSFT_EXOHostedConnectionFilterPolicy'

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

            $HostedConnectionFilterPolicy = Get-HostedConnectionFilterPolicy -Identity $Identity -ErrorAction SilentlyContinue
            if (-not $HostedConnectionFilterPolicy)
            {
                Write-Verbose -Message "HostedConnectionFilterPolicy [$($Identity)] does not exist."
                return $nullReturn
            }
        }
        else
        {
            $HostedConnectionFilterPolicy = $Script:exportedInstance
        }

        Write-Verbose -Message "Found HostedConnectionFilterPolicy $($Identity)"

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
            ManagedIdentity       = $ManagedIdentity.IsPresent
            TenantId              = $TenantId
            AccessTokens          = $AccessTokens
        }

        if ($HostedConnectionFilterPolicy.IsDefault)
        {
            $result.MakeDefault = $true
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

    $CurrentInstance = Get-TargetResource @PSBoundParameters

    $HostedConnectionFilterPolicyParams = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    $HostedConnectionFilterPolicyParams.Remove('MakeDefault') | Out-Null

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

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
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
        [array]$HostedConnectionFilterPolicies = Get-HostedConnectionFilterPolicy
        $dscContent = ''

        if ($HostedConnectionFilterPolicies.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        $i = 1
        foreach ($HostedConnectionFilterPolicy in $HostedConnectionFilterPolicies)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $Params = @{
                Credential            = $Credential
                Identity              = $HostedConnectionFilterPolicy.Identity
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                CertificatePath       = $CertificatePath
                AccessTokens          = $AccessTokens
            }
            $Script:exportedInstance = $HostedConnectionFilterPolicy
            Write-M365DSCHost -Message "    |---[$i/$($HostedConnectionFilterPolicies.Length)] $($HostedConnectionFilterPolicy.Identity)" -DeferWrite
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
