function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Yes')]
        $IsSingleInstance,

        [Parameter(Mandatory = $true)]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.Int32]
        [ValidateRange(30, 270)]
        $DeviceInactivityBeforeRetirementInDays,

        [Parameter()]
        [System.String]
        [ValidateSet('Absent', 'Present')]
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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    if ($Enabled -and $DeviceInactivityBeforeRetirementInDays -eq 0)
    {
        throw [System.ArgumentException]::new('DeviceInactivityBeforeRetirementInDays must be greater than 30 and less than 270 when Enabled is set to true.')
    }

    Write-Verbose -Message "Checking for the Intune Device Cleanup Rule"
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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

    $nullResult = $PSBoundParameters
    $nullResult.Ensure = 'Absent'

    try
    {
        $url = $Global:MSCloudLoginConnectionProfile.MicrosoftGraph.ResourceUrl + "beta/deviceManagement/managedDeviceCleanupSettings"
        $cleanupRule = Invoke-MgGraphRequest -Method GET -Uri $url -ErrorAction Stop

        $return = @{
            Enabled                                = $cleanupRule.deviceInactivityBeforeRetirementInDays -gt 0
            IsSingleInstance                       = 'Yes'
            Ensure                                 = 'Present'
            Credential                             = $Credential
            ApplicationId                          = $ApplicationId
            TenantId                               = $TenantId
            ApplicationSecret                      = $ApplicationSecret
            CertificateThumbprint                  = $CertificateThumbprint
            Managedidentity                        = $ManagedIdentity.IsPresent
            AccessTokens                           = $AccessTokens
        }

        if ($return.Enabled)
        {
            $return.Add('DeviceInactivityBeforeRetirementInDays', $cleanupRule.deviceInactivityBeforeRetirementInDays)
        }

        return $return
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $nullResult
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Yes')]
        $IsSingleInstance,

        [Parameter(Mandatory = $true)]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.Int32]
        [ValidateRange(30, 270)]
        $DeviceInactivityBeforeRetirementInDays,

        [Parameter()]
        [System.String]
        [ValidateSet('Absent', 'Present')]
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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    if ($Enabled -and $DeviceInactivityBeforeRetirementInDays -eq 0)
    {
        throw [System.ArgumentException]::new('DeviceInactivityBeforeRetirementInDays must be greater than 30 and less than 270 when Enabled is set to true.')
    }

    Write-Verbose -Message "Updating Device Cleanup Rule"

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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

    $url = $Global:MSCloudLoginConnectionProfile.MicrosoftGraph.ResourceUrl + "beta/deviceManagement/managedDeviceCleanupSettings"
    $body = @{
        DeviceInactivityBeforeRetirementInDays = "$(if ($Enabled) { $DeviceInactivityBeforeRetirementInDays } else { 0 })"
    }
    Invoke-MgGraphRequest -Method PATCH -Uri $url -Body ($body | ConvertTo-Json)
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Yes')]
        $IsSingleInstance,

        [Parameter(Mandatory = $true)]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.Int32]
        [ValidateRange(30, 270)]
        $DeviceInactivityBeforeRetirementInDays,

        [Parameter()]
        [System.String]
        [ValidateSet('Absent', 'Present')]
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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    if ($Enabled -and $DeviceInactivityBeforeRetirementInDays -eq 0)
    {
        throw [System.ArgumentException]::new('DeviceInactivityBeforeRetirementInDays must be greater than 30 and less than 270 when Enabled is set to true.')
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
    Write-Verbose -Message "Testing configuration of Device Cleanup Rule"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters

    if ($CurrentValues.Enabled -eq $false) {
        $ValuesToCheck.Remove('DeviceInactivityBeforeRetirementInDays') | Out-Null
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
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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
        $url = $Global:MSCloudLoginConnectionProfile.MicrosoftGraph.ResourceUrl + "beta/deviceManagement/managedDeviceCleanupSettings"
        [array]$cleanupRules = Invoke-MgGraphRequest -Method GET -Uri $url -ErrorAction Stop
        $i = 1
        $dscContent = ''
        if ($categories.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }

        foreach ($cleanupRule in $cleanupRules)
        {
            Write-Host "    |---[$i/$($cleanupRules.Count)] Cleanup Rule" -NoNewline
            $params = @{
                Enabled                                = $cleanupRule.deviceInactivityBeforeRetirementInDays -gt 0
                Ensure                                 = 'Present'
                IsSingleInstance                       = 'Yes'
                Credential                             = $Credential
                ApplicationId                          = $ApplicationId
                ApplicationSecret                      = $ApplicationSecret
                TenantId                               = $TenantId
                CertificateThumbprint                  = $CertificateThumbprint
                Managedidentity                        = $ManagedIdentity.IsPresent
                AccessTokens                           = $AccessTokens
            }

            if ($params.Enabled) {
                $params.Add('DeviceInactivityBeforeRetirementInDays', $cleanupRule.deviceInactivityBeforeRetirementInDays)
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
            $i++
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        return $dscContent
    }
    catch
    {
        if ($_.Exception -like "*401*" -or $_.ErrorDetails.Message -like "*`"ErrorCode`":`"Forbidden`"*" -or
            $_.Exception -like "* Unauthorized*" -or `
            $_.Exception -like "*Request not applicable to target tenant*" -or `
            $_.Exception -like "*BadRequest*")
        {
            Write-Host "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered for Intune."
        }
        else
        {
            Write-Host $Global:M365DSCEmojiRedX

            New-M365DSCLogEntry -Message 'Error during Export:' `
                -Exception $_ `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential
        }

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
