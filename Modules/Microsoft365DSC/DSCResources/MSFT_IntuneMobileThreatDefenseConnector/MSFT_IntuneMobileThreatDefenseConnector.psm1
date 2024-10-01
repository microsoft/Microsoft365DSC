function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region Intune parameters

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.Boolean]
        $AllowPartnerToCollectIosApplicationMetadata,

        [Parameter()]
        [System.Boolean]
        $AllowPartnerToCollectIosPersonalApplicationMetadata,

        [Parameter()]
        [System.Boolean]
        $AndroidDeviceBlockedOnMissingPartnerData,

        [Parameter()]
        [System.Boolean]
        $AndroidEnabled,

        [Parameter()]
        [System.Boolean]
        $AndroidMobileApplicationManagementEnabled,

        [Parameter()]
        [System.Boolean]
        $IosDeviceBlockedOnMissingPartnerData,

        [Parameter()]
        [System.Boolean]
        $IosEnabled,

        [Parameter()]
        [System.Boolean]
        $IosMobileApplicationManagementEnabled,

        [Parameter()]
        [System.DateTime]
        $LastHeartbeatDateTime,

        [Parameter()]
        [System.Boolean]
        $MicrosoftDefenderForEndpointAttachEnabled,

        [Parameter()]
        [System.String]
        $PartnerState,

        [Parameter()]
        [System.Int32]
        $PartnerUnresponsivenessThresholdInDays,

        [Parameter()]
        [System.Boolean]
        $PartnerUnsupportedOSVersionBlocked,

        [Parameter()]
        [System.Boolean]
        $WindowsDeviceBlockedOnMissingPartnerData,

        [Parameter()]
        [System.Boolean]
        $WindowsEnabled,

        #endregion Intune parameters

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters | Out-Null

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
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
        if ($null -ne $Script:exportedInstances -and $Script:ExportMode)
        {
            $instance = $Script:exportedInstances | Where-Object -FilterScript {$_.Id -eq $Id}
        }
        else
        {
            $instance = Get-MgDeviceManagementMobileThreatDefenseConnector -PrimaryKey $Id -ErrorAction Stop
        }
        if ($null -eq $instance)
        {
            return $nullResult
        }

        $results = @{
            Id                                             = $Id
            ResponseHeadersVariable                        = $ResponseHeadersVariable
            AdditionalProperties                           = $AdditionalProperties
            AllowPartnerToCollectIosApplicationMetadata    = $AllowPartnerToCollectIosApplicationMetadata
            AllowPartnerToCollectIosPersonalApplicationMetadata = $AllowPartnerToCollectIosPersonalApplicationMetadata
            AndroidDeviceBlockedOnMissingPartnerData       = $AndroidDeviceBlockedOnMissingPartnerData
            AndroidEnabled                                 = $AndroidEnabled
            AndroidMobileApplicationManagementEnabled      = $AndroidMobileApplicationManagementEnabled
            IosDeviceBlockedOnMissingPartnerData           = $IosDeviceBlockedOnMissingPartnerData
            IosEnabled                                     = $IosEnabled
            IosMobileApplicationManagementEnabled          = $IosMobileApplicationManagementEnabled
            LastHeartbeatDateTime                          = $LastHeartbeatDateTime
            MicrosoftDefenderForEndpointAttachEnabled      = $MicrosoftDefenderForEndpointAttachEnabled
            PartnerState                                   = $PartnerState
            PartnerUnresponsivenessThresholdInDays         = $PartnerUnresponsivenessThresholdInDays
            PartnerUnsupportedOSVersionBlocked             = $PartnerUnsupportedOSVersionBlocked
            WindowsDeviceBlockedOnMissingPartnerData       = $WindowsDeviceBlockedOnMissingPartnerData
            WindowsEnabled                                 = $WindowsEnabled

            Ensure                                         = 'Present'
            Credential                                     = $Credential
            ApplicationId                                  = $ApplicationId
            TenantId                                       = $TenantId
            CertificateThumbprint                          = $CertificateThumbprint
            ApplicationSecret                              = $ApplicationSecret
            ManagedIdentity                                = $ManagedIdentity.IsPresent
            AccessTokens                                   = $AccessTokens
        }

        return [System.Collections.Hashtable] $results
    }
    catch
    {
        Write-Verbose -Message $_
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
        #region Intune parameters

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.Boolean]
        $AllowPartnerToCollectIosApplicationMetadata,

        [Parameter()]
        [System.Boolean]
        $AllowPartnerToCollectIosPersonalApplicationMetadata,

        [Parameter()]
        [System.Boolean]
        $AndroidDeviceBlockedOnMissingPartnerData,

        [Parameter()]
        [System.Boolean]
        $AndroidEnabled,

        [Parameter()]
        [System.Boolean]
        $AndroidMobileApplicationManagementEnabled,

        [Parameter()]
        [System.Boolean]
        $IosDeviceBlockedOnMissingPartnerData,

        [Parameter()]
        [System.Boolean]
        $IosEnabled,

        [Parameter()]
        [System.Boolean]
        $IosMobileApplicationManagementEnabled,

        [Parameter()]
        [System.DateTime]
        $LastHeartbeatDateTime,

        [Parameter()]
        [System.Boolean]
        $MicrosoftDefenderForEndpointAttachEnabled,

        [Parameter()]
        [System.String]
        $PartnerState,

        [Parameter()]
        [System.Int32]
        $PartnerUnresponsivenessThresholdInDays,

        [Parameter()]
        [System.Boolean]
        $PartnerUnsupportedOSVersionBlocked,

        [Parameter()]
        [System.Boolean]
        $WindowsDeviceBlockedOnMissingPartnerData,

        [Parameter()]
        [System.Boolean]
        $WindowsEnabled,

        #endregion Intune parameters

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentInstance = Get-TargetResource @PSBoundParameters

    $setParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    # CREATE
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        New-MgDeviceManagementMobileThreatDefenseConnector @SetParameters
    }
    # UPDATE
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Update-MgDeviceManagementMobileThreatDefenseConnector @SetParameters
    }
    # REMOVE
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Remove-MgDeviceManagementMobileThreatDefenseConnector @SetParameters
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        #region Intune parameters

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.Boolean]
        $AllowPartnerToCollectIosApplicationMetadata,

        [Parameter()]
        [System.Boolean]
        $AllowPartnerToCollectIosPersonalApplicationMetadata,

        [Parameter()]
        [System.Boolean]
        $AndroidDeviceBlockedOnMissingPartnerData,

        [Parameter()]
        [System.Boolean]
        $AndroidEnabled,

        [Parameter()]
        [System.Boolean]
        $AndroidMobileApplicationManagementEnabled,

        [Parameter()]
        [System.Boolean]
        $IosDeviceBlockedOnMissingPartnerData,

        [Parameter()]
        [System.Boolean]
        $IosEnabled,

        [Parameter()]
        [System.Boolean]
        $IosMobileApplicationManagementEnabled,

        [Parameter()]
        [System.DateTime]
        $LastHeartbeatDateTime,

        [Parameter()]
        [System.Boolean]
        $MicrosoftDefenderForEndpointAttachEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet('unavailable', 'available', 'enabled', 'unresponsive')]
        $PartnerState,

        [Parameter()]
        [System.Int32]
        $PartnerUnresponsivenessThresholdInDays,

        [Parameter()]
        [System.Boolean]
        $PartnerUnsupportedOSVersionBlocked,

        [Parameter()]
        [System.Boolean]
        $WindowsDeviceBlockedOnMissingPartnerData,

        [Parameter()]
        [System.Boolean]
        $WindowsEnabled,

        #endregion Intune parameters

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).Clone()

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

    $testResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $testResult"

    return $testResult
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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        $Script:ExportMode = $true
        [array] $Script:exportedInstances = Get-MgDeviceManagementMobileThreatDefenseConnector -ErrorAction Stop

        $i = 1
        $dscContent = ''
        if ($Script:exportedInstances.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($config in $Script:exportedInstances)
        {
            $displayedKey = $config.Id
            Write-Host "    |---[$i/$($Script:exportedInstances.Count)] $displayedKey" -NoNewline
            $params = @{
                Id                    = $config.Id
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ApplicationSecret     = $ApplicationSecret
                ManagedIdentity       = $ManagedIdentity.IsPresent
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
            $i++
            Write-Host $Global:M365DSCEmojiGreenCheckMark
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
