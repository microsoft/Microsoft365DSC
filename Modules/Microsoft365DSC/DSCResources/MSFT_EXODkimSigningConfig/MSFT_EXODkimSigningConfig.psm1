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
        [ValidateSet('Simple', 'Relaxed')]
        [System.String]
        $BodyCanonicalization = 'Relaxed',

        [Parameter()]
        [System.Boolean]
        $Enabled = $true,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [ValidateSet('Simple', 'Relaxed')]
        [System.String]
        $HeaderCanonicalization = 'Relaxed',

        [Parameter()]
        [ValidateSet(1024, 2048)]
        [uint16]
        $KeySize,

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

    Write-Verbose -Message "Getting configuration of DkimSigningConfig for $Identity"
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

    Write-Verbose -Message 'Global ExchangeOnlineSession status:'
    Write-Verbose -Message "$( Get-PSSession -ErrorAction SilentlyContinue | Where-Object -FilterScript { $_.Name -eq 'ExchangeOnline' } | Out-String)"

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = 'Absent'
    try
    {
        $DkimSigningConfigs = Get-DkimSigningConfig
    }
    catch
    {
        $Message = 'Error calling {Get-DkimSigningConfig}'
        New-M365DSCLogEntry -Message $Message `
            -Exception $_ `
            -Source $MyInvocation.MyCommand.ModuleName
        return $nullReturn
    }
    $DkimSigningConfig = $DkimSigningConfigs | Where-Object -FilterScript { $_.Identity -eq $Identity }
    if (-not $DkimSigningConfig)
    {
        Write-Verbose -Message "DkimSigningConfig $($Identity) does not exist."
        return $nullReturn
    }
    else
    {
        $result = @{
            Ensure                 = 'Present'
            Identity               = $Identity
            AdminDisplayName       = $DkimSigningConfig.AdminDisplayName
            BodyCanonicalization   = $DkimSigningConfig.BodyCanonicalization
            Enabled                = $DkimSigningConfig.Enabled
            HeaderCanonicalization = $DkimSigningConfig.HeaderCanonicalization
            KeySize                = $DkimSigningConfig.Selector1KeySize
            Credential             = $Credential
            ApplicationId          = $ApplicationId
            CertificateThumbprint  = $CertificateThumbprint
            CertificatePath        = $CertificatePath
            CertificatePassword    = $CertificatePassword
            Managedidentity        = $ManagedIdentity.IsPresent
            TenantId               = $TenantId
            AccessTokens           = $AccessTokens
        }

        Write-Verbose -Message "Found DkimSigningConfig $($Identity)"
        Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
        return $result
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
        [ValidateSet('Simple', 'Relaxed')]
        [System.String]
        $BodyCanonicalization = 'Relaxed',

        [Parameter()]
        [System.Boolean]
        $Enabled = $true,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [ValidateSet('Simple', 'Relaxed')]
        [System.String]
        $HeaderCanonicalization = 'Relaxed',

        [Parameter()]
        [ValidateSet(1024, 2048)]
        [uint16]
        $KeySize,

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

    Write-Verbose -Message "Setting configuration of DkimSigningConfig for $Identity"

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

    $DkimSigningConfig = Get-TargetResource @PSBoundParameters
    $PSBoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if (('Present' -eq $Ensure ) -and ($null -eq $DkimSigningConfig))
    {
        $PSBoundParameters += @{
            DomainName = $PSBoundParameters.Identity
        }
        $PSBoundParameters.Remove('Identity') | Out-Null
        Write-Verbose -Message "Creating DkimSigningConfig $($Identity)."
        New-DkimSigningConfig @PSBoundParameters
    }
    elseif (('Present' -eq $Ensure ) -and ($null -ne $DkimSigningConfig))
    {
        $PSBoundParameters.Remove('KeySize') | Out-Null
        Write-Verbose -Message "Setting DkimSigningConfig $($Identity) with values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"
        Set-DkimSigningConfig @PSBoundParameters -Confirm:$false
    }

    if (('Absent' -eq $Ensure ) -and ($DkimSigningConfig))
    {
        Write-Verbose -Message "Disabling DkimSigningConfig $($Identity) "
        Set-DkimSigningConfig -Identity $Identity -Enabled $false -Confirm:$false
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
        [ValidateSet('Simple', 'Relaxed')]
        [System.String]
        $BodyCanonicalization = 'Relaxed',

        [Parameter()]
        [System.Boolean]
        $Enabled = $true,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [ValidateSet('Simple', 'Relaxed')]
        [System.String]
        $HeaderCanonicalization = 'Relaxed',

        [Parameter()]
        [ValidateSet(1024, 2048)]
        [uint16]
        $KeySize,

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

    Write-Verbose -Message "Testing configuration of DkimSigningConfig for $Identity"

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

    if (Confirm-ImportedCmdletIsAvailable -CmdletName Get-DkimSigningConfig)
    {
        [array]$DkimSigningConfigs = Get-DkimSigningConfig

        $i = 1
        if ($DkimSigningConfigs.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        $dscContent = ''
        foreach ($DkimSigningConfig in $DkimSigningConfigs)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-Host "    |---[$i/$($DkimSigningConfigs.Length)] $($DkimSigningConfig.Identity)" -NoNewline
            $Params = @{
                Identity              = $DkimSigningConfig.Identity
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
    }
    else
    {
        Write-Host "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered to allow for DKIM Signing Config"
        return ''
    }
    return $dscContent
}

Export-ModuleMember -Function *-TargetResource
