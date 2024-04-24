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
        [ValidateSet('Block', 'Replace', 'Allow', 'DynamicDelivery')]
        [System.String]
        $Action = 'Block',

        [Parameter()]
        [Boolean]
        $ActionOnError = $false,

        [Parameter()]
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [Boolean]
        $Enable = $false,

        [Parameter()]
        [System.String]
        $QuarantineTag,

        [Parameter()]
        [Boolean]
        $Redirect = $false,

        [Parameter()]
        [System.String]
        $RedirectAddress,

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

    Write-Verbose -Message "Getting configuration of SafeAttachmentPolicy for $Identity"
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
        $SafeAttachmentPolicies = Get-SafeAttachmentPolicy -ErrorAction Stop

        $SafeAttachmentPolicy = $SafeAttachmentPolicies | Where-Object -FilterScript { $_.Identity -eq $Identity }
        if (-not $SafeAttachmentPolicy)
        {
            Write-Verbose -Message "SafeAttachmentPolicy $($Identity) does not exist."
            return $nullReturn
        }
        else
        {
            $result = @{
                Ensure                = 'Present'
                Identity              = $Identity
                Action                = $SafeAttachmentPolicy.Action
                ActionOnError         = $SafeAttachmentPolicy.ActionOnError
                AdminDisplayName      = $SafeAttachmentPolicy.AdminDisplayName
                Enable                = $SafeAttachmentPolicy.Enable
                QuarantineTag         = $SafeAttachmentPolicy.QuarantineTag
                Redirect              = $SafeAttachmentPolicy.Redirect
                RedirectAddress       = $SafeAttachmentPolicy.RedirectAddress
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
                Managedidentity       = $ManagedIdentity.IsPresent
                TenantId              = $TenantId
                AccessTokens          = $AccessTokens
            }

            Write-Verbose -Message "Found SafeAttachmentPolicy $($Identity)"
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
        [ValidateSet('Block', 'Replace', 'Allow', 'DynamicDelivery')]
        [System.String]
        $Action = 'Block',

        [Parameter()]
        [Boolean]
        $ActionOnError = $false,

        [Parameter()]
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [Boolean]
        $Enable = $false,

        [Parameter()]
        [System.String]
        $QuarantineTag,

        [Parameter()]
        [Boolean]
        $Redirect = $false,

        [Parameter()]
        [System.String]
        $RedirectAddress,

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

    Write-Verbose -Message "Setting configuration of SafeAttachmentPolicy for $Identity"
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

    $SafeAttachmentPolicyParams = [System.Collections.Hashtable]($PSBoundParameters)
    $SafeAttachmentPolicyParams.Remove('Ensure') | Out-Null
    $SafeAttachmentPolicyParams.Remove('Credential') | Out-Null
    $SafeAttachmentPolicyParams.Remove('ApplicationId') | Out-Null
    $tenantIdValue = $TenantId
    $SafeAttachmentPolicyParams.Remove('TenantId') | Out-Null
    $SafeAttachmentPolicyParams.Remove('CertificateThumbprint') | Out-Null
    $SafeAttachmentPolicyParams.Remove('CertificatePath') | Out-Null
    $SafeAttachmentPolicyParams.Remove('CertificatePassword') | Out-Null
    $SafeAttachmentPolicyParams.Remove('ManagedIdentity') | Out-Null
    $SafeAttachmentPolicyParams.Remove('AccessTokens') | Out-Null

    $SafeAttachmentPolicies = Get-SafeAttachmentPolicy

    $SafeAttachmentPolicy = $SafeAttachmentPolicies | Where-Object -FilterScript { $_.Identity -eq $Identity }
    if ('Present' -eq $Ensure )
    {
        $StopProcessingPolicy = $false
        if ($Redirect -eq $true)
        {
            if ($ActionOnError -eq $true){
                Write-Verbose -Message "The ActionOnError parameter is deprecated"
                $SafeAttachmentPolicyParams.Remove('ActionOnError') | Out-Null
            }
            $Message = 'Cannot proceed with processing of SafeAttachmentPolicy because Redirect is set to true '
            if ([String]::IsNullOrEmpty($RedirectAddress))
            {
                $Message += 'and RedirectAddress is null'
                $StopProcessingPolicy = $true
            }
            if ($StopProcessingPolicy -eq $true)
            {
                Write-Verbose -Message $Message
                try
                {
                    $Message = 'Please ensure that if Redirect is set to true ' + `
                        'and RedirectAddress is not null'
                    New-M365DSCLogEntry -Message $Message `
                        -Source $($MyInvocation.MyCommand.Source) `
                        -TenantId $TenantId `
                        -Credential $Credential
                }
                catch
                {
                    Write-Verbose -Message $_
                }
                break
            }
        }
        else
        {
            $SafeAttachmentPolicyParams.Remove('RedirectAddress') | Out-Null
        }

        if (-not $SafeAttachmentPolicy)
        {
            Write-Verbose -Message "Creating SafeAttachmentPolicy $($Identity)."
            $SafeAttachmentPolicyParams += @{
                Name = $SafeAttachmentPolicyParams.Identity
            }

            $SafeAttachmentPolicyParams.Remove('Identity') | Out-Null
            try
            {
                New-SafeAttachmentPolicy @SafeAttachmentPolicyParams
            }
            catch
            {
                try
                {
                    New-M365DSCLogEntry -Message 'Error updating data:' `
                        -Exception $_ `
                        -Source $($MyInvocation.MyCommand.Source) `
                        -TenantId $TenantId `
                        -Credential $Credential
                }
                catch
                {
                    Write-Verbose -Message $_
                }
            }
        }
        else
        {
            Write-Verbose -Message "Setting SafeAttachmentPolicy $Identity with values: $(Convert-M365DscHashtableToString -Hashtable $SafeAttachmentPolicyParams)"
            try
            {
                Set-SafeAttachmentPolicy @SafeAttachmentPolicyParams
            }
            catch
            {
                try
                {
                    New-M365DSCLogEntry -Message 'Error updating data:' `
                        -Exception $_ `
                        -Source $($MyInvocation.MyCommand.Source) `
                        -TenantId $TenantId `
                        -Credential $Credential
                }
                catch
                {
                    Write-Verbose -Message $_
                }
            }
        }
    }
    elseif (('Absent' -eq $Ensure) -and ($SafeAttachmentPolicy))
    {
        Write-Verbose -Message "Removing SafeAttachmentPolicy $($Identity) "
        Remove-SafeAttachmentPolicy -Identity $Identity -Confirm:$false -Force
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
        [ValidateSet('Block', 'Replace', 'Allow', 'DynamicDelivery')]
        [System.String]
        $Action = 'Block',

        [Parameter()]
        [Boolean]
        $ActionOnError = $false,

        [Parameter()]
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [Boolean]
        $Enable = $false,

        [Parameter()]
        [System.String]
        $QuarantineTag,

        [Parameter()]
        [Boolean]
        $Redirect = $false,

        [Parameter()]
        [System.String]
        $RedirectAddress,

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

    Write-Verbose -Message "Testing configuration of SafeAttachmentPolicy for $Identity"

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
        if (Confirm-ImportedCmdletIsAvailable -CmdletName 'Get-SafeAttachmentPolicy')
        {
            [array]$SafeAttachmentPolicies = Get-SafeAttachmentPolicy -ErrorAction Stop
            if ($SafeAttachmentPolicies.Length -eq 0)
            {
                Write-Host $Global:M365DSCEmojiGreenCheckMark
            }
            else
            {
                Write-Host "`r`n" -NoNewline
            }
            $i = 1
            foreach ($SafeAttachmentPolicy in $SafeAttachmentPolicies)
            {
                Write-Host "    |---[$i/$($SafeAttachmentPolicies.Length)] $($SafeAttachmentPolicy.Identity)" -NoNewline
                $Params = @{
                    Credential            = $Credential
                    Identity              = $SafeAttachmentPolicy.Identity
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
            Write-Host "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant doesn't have access to Safe Attachment Policy APIs."
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
