function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,

        [Parameter()]
        [System.String]
        $Identity = 'Default',

        [Parameter()]
        [Boolean]
        $AllowSafeDocsOpen = $false,

        [Parameter()]
        [Boolean]
        $EnableATPForSPOTeamsODB = $false,

        [Parameter()]
        [Boolean]
        $EnableSafeDocs = $false,

        [Parameter()]
        [ValidateSet('Present')]
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

    Write-Verbose -Message "Getting configuration of AtpPolicyForO365 for $Identity"

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

    $nullReturn = @{
        IsSingleInstance = 'Yes'
    }

    try
    {
        $AtpPolicies = Get-AtpPolicyForO365 -ErrorAction Stop

        $AtpPolicyForO365 = $AtpPolicies | Where-Object -FilterScript { $_.Identity -eq $Identity }
        if (-not $AtpPolicyForO365)
        {
            Write-Verbose -Message "AtpPolicyForO365 $($Identity) does not exist."
            return $nullReturn
        }
        else
        {
            $result = @{
                IsSingleInstance        = 'Yes'
                Identity                = $AtpPolicyForO365.Identity
                AllowSafeDocsOpen       = $AtpPolicyForO365.AllowSafeDocsOpen
                EnableATPForSPOTeamsODB = $AtpPolicyForO365.EnableATPForSPOTeamsODB
                EnableSafeDocs          = $AtpPolicyForO365.EnableSafeDocs
                ApplicationId           = $ApplicationId
                CertificateThumbprint   = $CertificateThumbprint
                CertificatePath         = $CertificatePath
                CertificatePassword     = $CertificatePassword
                Managedidentity         = $ManagedIdentity.IsPresent
                TenantId                = $TenantId
                AccessTokens            = $AccessTokens
            }

            Write-Verbose -Message "Found AtpPolicyForO365 $($Identity)"
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
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,

        [Parameter()]
        [System.String]
        $Identity = 'Default',

        [Parameter()]
        [Boolean]
        $AllowSafeDocsOpen = $false,

        [Parameter()]
        [Boolean]
        $EnableATPForSPOTeamsODB = $false,

        [Parameter()]
        [Boolean]
        $EnableSafeDocs = $false,

        [Parameter()]
        [ValidateSet('Present')]
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

    Write-Verbose -Message "Setting configuration of AtpPolicyForO365 for $Identity"

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

    if ('Default' -ne $Identity)
    {
        throw "EXOAtpPolicyForO365 configurations MUST specify Identity value of 'Default'"
    }

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $AtpPolicyParams = [System.Collections.Hashtable]($PSBoundParameters)
    $AtpPolicyParams.Remove('Ensure') | Out-Null
    $AtpPolicyParams.Remove('Credential') | Out-Null
    $AtpPolicyParams.Remove('IsSingleInstance') | Out-Null
    $AtpPolicyParams.Remove('ApplicationId') | Out-Null
    $AtpPolicyParams.Remove('TenantId') | Out-Null
    $AtpPolicyParams.Remove('CertificateThumbprint') | Out-Null
    $AtpPolicyParams.Remove('CertificatePath') | Out-Null
    $AtpPolicyParams.Remove('CertificatePassword') | Out-Null
    $AtpPolicyParams.Remove('ManagedIdentity') | Out-Null
    $AtpPolicyParams.Remove('AccessTokens') | Out-Null
    Write-Verbose -Message "Setting AtpPolicyForO365 $Identity with values: $(Convert-M365DscHashtableToString -Hashtable $AtpPolicyParams)"

    Set-AtpPolicyForO365 @AtpPolicyParams
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,

        [Parameter()]
        [System.String]
        $Identity = 'Default',

        [Parameter()]
        [Boolean]
        $AllowSafeDocsOpen = $false,

        [Parameter()]
        [Boolean]
        $EnableATPForSPOTeamsODB = $false,

        [Parameter()]
        [Boolean]
        $EnableSafeDocs = $false,

        [Parameter()]
        [ValidateSet('Present')]
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

    Write-Verbose -Message "Testing configuration of AtpPolicyForO365 for $Identity"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Ensure') | Out-Null

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
        if (Confirm-ImportedCmdletIsAvailable -CmdletName Get-AtpPolicyForO365)
        {
            [array]$ATPPolicies = Get-AtpPolicyForO365 -ErrorAction Stop
            $dscContent = ''

            if ($ATPPolicies.Length -eq 0)
            {
                Write-Host $Global:M365DSCEmojiGreenCheckMark
            }
            else
            {
                Write-Host "`r`n" -NoNewline
            }
            $i = 1
            foreach ($atpPolicy in $ATPPolicies)
            {
                if ($null -ne $Global:M365DSCExportResourceInstancesCount)
                {
                    $Global:M365DSCExportResourceInstancesCount++
                }

                Write-Host "    |---[$i/$($ATPPolicies.Length)] $($atpPolicy.Identity)" -NoNewline

                $Params = @{
                    IsSingleInstance      = 'Yes'
                    Identity              = $atpPolicy.Identity
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

                if ($Results -is [System.Collections.Hashtable] -and $Results.Count -gt 1)
                {
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
                }
                else
                {
                    Write-Host $Global:M365DSCEmojiRedX
                }

                $i++
            }
        }
        else
        {
            Write-Host "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered to allow for ATP Policies"
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
