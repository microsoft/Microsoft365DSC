Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneDeviceConfigurationDeliveryOptimizationPolicyWindows10V2'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [ValidateSet(0, 1, 2, 3, 99, 100)]
        [System.Int32]
        $DODownloadMode,

        [Parameter()]
        [ValidateSet(0, 1, 2)]
        [System.Int32]
        $DORestrictPeerSelectionBy,

        [Parameter()]
        [ValidateSet(0, 1, 2, 3, 4, 5)]
        [System.Int32]
        $DOGroupIdSource,

        [Parameter()]
        [System.String]
        $DOGroupId,

        [Parameter()]
        [System.Int32]
        $DOMaxForegroundDownloadBandwidth,

        [Parameter()]
        [System.Int32]
        $DOMaxBackgroundDownloadBandwidth,

        [Parameter()]
        [ValidateRange(0, 100)]
        [System.Int32]
        $DOPercentageMaxForegroundBandwidth,

        [Parameter()]
        [ValidateRange(0, 100)]
        [System.Int32]
        $DOPercentageMaxBackgroundBandwidth,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $SetHoursToLimitForegroundDownloadBandwidth,

        [Parameter()]
        [ValidateSet('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23')]
        [System.String]
        $SetHoursToLimitForegroundDownloadBandwidthTo,

        [Parameter()]
        [ValidateSet('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23')]
        [System.String]
        $SetHoursToLimitForegroundDownloadBandwidthFrom,

        [Parameter()]
        [ValidateRange(0, 100)]
        [System.Int32]
        $SetHoursToLimitForegroundDownloadBandwidthIn,

        [Parameter()]
        [ValidateRange(0, 100)]
        [System.Int32]
        $SetHoursToLimitForegroundDownloadBandwidthOut,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $SetHoursToLimitBackgroundDownloadBandwidth,

        [Parameter()]
        [ValidateRange(0, 100)]
        [System.Int32]
        $SetHoursToLimitBackgroundDownloadBandwidthOut,

        [Parameter()]
        [ValidateSet('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23')]
        [System.String]
        $SetHoursToLimitBackgroundDownloadBandwidthFrom,

        [Parameter()]
        [ValidateRange(0, 100)]
        [System.Int32]
        $SetHoursToLimitBackgroundDownloadBandwidthIn,

        [Parameter()]
        [ValidateSet('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23')]
        [System.String]
        $SetHoursToLimitBackgroundDownloadBandwidthTo,

        [Parameter()]
        [System.Int32]
        $DODelayForegroundDownloadFromHttp,

        [Parameter()]
        [System.Int32]
        $DODelayBackgroundDownloadFromHttp,

        [Parameter()]
        [ValidateRange(1, 100000)]
        [System.Int32]
        $DOMinRAMAllowedToPeer,

        [Parameter()]
        [ValidateRange(1, 100000)]
        [System.Int32]
        $DOMinDiskSizeAllowedToPeer,

        [Parameter()]
        [ValidateRange(1, 100000)]
        [System.Int32]
        $DOMinFileSizeToCache,

        [Parameter()]
        [ValidateRange(0, 100)]
        [System.Int32]
        $DOMinBatteryPercentageAllowedToUpload,

        [Parameter()]
        [System.String]
        $DOModifyCacheDrive,

        [Parameter()]
        [System.Int32]
        $DOMaxCacheAge,

        [Parameter()]
        [System.Int32]
        $DOAbsoluteMaxCacheSize,

        [Parameter()]
        [ValidateRange(1, 100)]
        [System.Int32]
        $DOMaxCacheSize,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DOAllowVPNPeerCaching,

        [Parameter()]
        [System.String[]]
        $DOCacheHost,

        [Parameter()]
        [ValidateRange(1, 2)]
        [System.Int32]
        $DOCacheHostSource,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DODisallowCacheServerDownloadsOnVPN,

        [Parameter()]
        [ValidateRange(0, 2592000)]
        [System.Int32]
        $DODelayCacheServerFallbackForeground,

        [Parameter()]
        [ValidateRange(0, 2592000)]
        [System.Int32]
        $DODelayCacheServerFallbackBackground,

        [Parameter()]
        [System.Int32]
        $DOMinBackgroundQos,

        [Parameter()]
        [System.Int32]
        $DOMonthlyUploadDataCap,

        [Parameter()]
        [System.String[]]
        $DOVpnKeywords,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
        #endregion

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

    Write-Verbose -Message "Getting configuration for the Intune Device Configuration Delivery Optimization Policy for Windows10 Setting Catalog with Id {$Id} and Name {$DisplayName}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.DisplayName -ne $DisplayName)
        {

            $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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

            $nullResult = $PSBoundParameters
            $nullResult.Ensure = 'Absent'

            $getValue = $null

            #region resource generator code
            if (-not [System.String]::IsNullOrEmpty($Id))
            {
                $getValue = Get-MgBetaDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $Id  -ErrorAction SilentlyContinue
            }

            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Device Configuration Delivery Optimization Policy for Windows10 Setting Catalog with Id {$Id}"

                if (-not [System.String]::IsNullOrEmpty($DisplayName))
                {
                    $getValue = Get-MgBetaDeviceManagementConfigurationPolicy `
                        -All `
                        -Filter "Name eq '$DisplayName'" `
                        -ErrorAction SilentlyContinue
                }
            }
            #endregion
            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Device Configuration Delivery Optimization Policy for Windows10 Setting Catalog with Name {$DisplayName}."
                return $nullResult
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Device Configuration Delivery Optimization Policy for Windows10 Setting Catalog with Id {$Id} and Name {$DisplayName} was found"

        # Retrieve policy specific settings
        [array]$settings = Get-MgBetaDeviceManagementConfigurationPolicySetting `
            -DeviceManagementConfigurationPolicyId $Id `
            -ExpandProperty 'settingDefinitions' `
            -All `
            -ErrorAction Stop

        $policySettings = @{}
        $policySettings = Export-IntuneSettingCatalogPolicySettings -Settings $settings -ReturnHashtable $policySettings

        $results = @{
            #region resource generator code
            Description           = $getValue.Description
            DisplayName           = $getValue.Name
            RoleScopeTagIds       = $getValue.RoleScopeTagIds
            Id                    = $getValue.Id
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            #endregion
        }
        $results += $policySettings

        $assignmentsValues = Get-MgBetaDeviceManagementConfigurationPolicyAssignment -DeviceManagementConfigurationPolicyId $Id
        $assignmentResult = @()
        if ($assignmentsValues.Count -gt 0)
        {
            $assignmentResult += ConvertFrom-IntunePolicyAssignment -Assignments $assignmentsValues -IncludeDeviceFilter $true
        }
        $results.Add('Assignments', $assignmentResult)

        return $results
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
        #region resource generator code
        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [ValidateSet(0, 1, 2, 3, 99, 100)]
        [System.Int32]
        $DODownloadMode,

        [Parameter()]
        [ValidateSet(0, 1, 2)]
        [System.Int32]
        $DORestrictPeerSelectionBy,

        [Parameter()]
        [ValidateSet(0, 1, 2, 3, 4, 5)]
        [System.Int32]
        $DOGroupIdSource,

        [Parameter()]
        [System.String]
        $DOGroupId,

        [Parameter()]
        [System.Int32]
        $DOMaxForegroundDownloadBandwidth,

        [Parameter()]
        [System.Int32]
        $DOMaxBackgroundDownloadBandwidth,

        [Parameter()]
        [ValidateRange(0, 100)]
        [System.Int32]
        $DOPercentageMaxForegroundBandwidth,

        [Parameter()]
        [ValidateRange(0, 100)]
        [System.Int32]
        $DOPercentageMaxBackgroundBandwidth,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $SetHoursToLimitForegroundDownloadBandwidth,

        [Parameter()]
        [ValidateSet('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23')]
        [System.String]
        $SetHoursToLimitForegroundDownloadBandwidthTo,

        [Parameter()]
        [ValidateSet('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23')]
        [System.String]
        $SetHoursToLimitForegroundDownloadBandwidthFrom,

        [Parameter()]
        [ValidateRange(0, 100)]
        [System.Int32]
        $SetHoursToLimitForegroundDownloadBandwidthIn,

        [Parameter()]
        [ValidateRange(0, 100)]
        [System.Int32]
        $SetHoursToLimitForegroundDownloadBandwidthOut,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $SetHoursToLimitBackgroundDownloadBandwidth,

        [Parameter()]
        [ValidateRange(0, 100)]
        [System.Int32]
        $SetHoursToLimitBackgroundDownloadBandwidthOut,

        [Parameter()]
        [ValidateSet('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23')]
        [System.String]
        $SetHoursToLimitBackgroundDownloadBandwidthFrom,

        [Parameter()]
        [ValidateRange(0, 100)]
        [System.Int32]
        $SetHoursToLimitBackgroundDownloadBandwidthIn,

        [Parameter()]
        [ValidateSet('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23')]
        [System.String]
        $SetHoursToLimitBackgroundDownloadBandwidthTo,

        [Parameter()]
        [System.Int32]
        $DODelayForegroundDownloadFromHttp,

        [Parameter()]
        [System.Int32]
        $DODelayBackgroundDownloadFromHttp,

        [Parameter()]
        [ValidateRange(1, 100000)]
        [System.Int32]
        $DOMinRAMAllowedToPeer,

        [Parameter()]
        [ValidateRange(1, 100000)]
        [System.Int32]
        $DOMinDiskSizeAllowedToPeer,

        [Parameter()]
        [ValidateRange(1, 100000)]
        [System.Int32]
        $DOMinFileSizeToCache,

        [Parameter()]
        [ValidateRange(0, 100)]
        [System.Int32]
        $DOMinBatteryPercentageAllowedToUpload,

        [Parameter()]
        [System.String]
        $DOModifyCacheDrive,

        [Parameter()]
        [System.Int32]
        $DOMaxCacheAge,

        [Parameter()]
        [System.Int32]
        $DOAbsoluteMaxCacheSize,

        [Parameter()]
        [ValidateRange(1, 100)]
        [System.Int32]
        $DOMaxCacheSize,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DOAllowVPNPeerCaching,

        [Parameter()]
        [System.String[]]
        $DOCacheHost,

        [Parameter()]
        [ValidateRange(1, 2)]
        [System.Int32]
        $DOCacheHostSource,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DODisallowCacheServerDownloadsOnVPN,

        [Parameter()]
        [ValidateRange(0, 2592000)]
        [System.Int32]
        $DODelayCacheServerFallbackForeground,

        [Parameter()]
        [ValidateRange(0, 2592000)]
        [System.Int32]
        $DODelayCacheServerFallbackBackground,

        [Parameter()]
        [System.Int32]
        $DOMinBackgroundQos,

        [Parameter()]
        [System.Int32]
        $DOMonthlyUploadDataCap,

        [Parameter()]
        [System.String[]]
        $DOVpnKeywords,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
        #endregion

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

    Write-Verbose -Message "Setting configuration of the Intune Device Configuration Delivery Optimization Policy for Windows10 Setting Catalog with Id {$Id} and Name {$DisplayName}"

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

    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    $templateReferenceId = '132f1027-0325-45e0-854a-6955cd3c68c0_1'
    $platforms = 'windows10'
    $technologies = 'mdm'

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Device Configuration Delivery Optimization Policy for Windows10 Setting Catalog with Name {$DisplayName}"
        $BoundParameters.Remove("Assignments") | Out-Null

        $settings = Get-IntuneSettingCatalogPolicySetting `
            -DSCParams ([System.Collections.Hashtable]$BoundParameters) `
            -TemplateId $templateReferenceId

        $createParameters = @{
            Name              = $DisplayName
            Description       = $Description
            TemplateReference = @{ templateId = $templateReferenceId }
            Platforms         = $platforms
            Technologies      = $technologies
            Settings          = $settings
            RoleScopeTagIds   = $RoleScopeTagIds
        }

        #region resource generator code
        $policy = New-MgBetaDeviceManagementConfigurationPolicy -BodyParameter $createParameters

        if ($policy.Id)
        {
            $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
            Update-DeviceConfigurationPolicyAssignment `
                -DeviceConfigurationPolicyId $policy.Id `
                -Targets $assignmentsHash `
                -Repository 'deviceManagement/configurationPolicies'
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune Device Configuration Delivery Optimization Policy for Windows10 Setting Catalog with Id {$($currentInstance.Id)}"
        $BoundParameters.Remove("Assignments") | Out-Null

        $settings = Get-IntuneSettingCatalogPolicySetting `
            -DSCParams ([System.Collections.Hashtable]$BoundParameters) `
            -TemplateId $templateReferenceId

        Update-IntuneDeviceConfigurationPolicy `
            -DeviceConfigurationPolicyId $currentInstance.Id `
            -Name $DisplayName `
            -Description $Description `
            -TemplateReferenceId $templateReferenceId `
            -Platforms $platforms `
            -Technologies $technologies `
            -Settings $settings `
            -RoleScopeTagIds $RoleScopeTagIds

        #region resource generator code
        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        Update-DeviceConfigurationPolicyAssignment `
            -DeviceConfigurationPolicyId $currentInstance.Id `
            -Targets $assignmentsHash `
            -Repository 'deviceManagement/configurationPolicies'
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune Device Configuration Delivery Optimization Policy for Windows10 Setting Catalog with Id {$($currentInstance.Id)}"
        #region resource generator code
        Remove-MgBetaDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $currentInstance.Id
        #endregion
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [ValidateSet(0, 1, 2, 3, 99, 100)]
        [System.Int32]
        $DODownloadMode,

        [Parameter()]
        [ValidateSet(0, 1, 2)]
        [System.Int32]
        $DORestrictPeerSelectionBy,

        [Parameter()]
        [ValidateSet(0, 1, 2, 3, 4, 5)]
        [System.Int32]
        $DOGroupIdSource,

        [Parameter()]
        [System.String]
        $DOGroupId,

        [Parameter()]
        [System.Int32]
        $DOMaxForegroundDownloadBandwidth,

        [Parameter()]
        [System.Int32]
        $DOMaxBackgroundDownloadBandwidth,

        [Parameter()]
        [ValidateRange(0, 100)]
        [System.Int32]
        $DOPercentageMaxForegroundBandwidth,

        [Parameter()]
        [ValidateRange(0, 100)]
        [System.Int32]
        $DOPercentageMaxBackgroundBandwidth,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $SetHoursToLimitForegroundDownloadBandwidth,

        [Parameter()]
        [ValidateSet('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23')]
        [System.String]
        $SetHoursToLimitForegroundDownloadBandwidthTo,

        [Parameter()]
        [ValidateSet('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23')]
        [System.String]
        $SetHoursToLimitForegroundDownloadBandwidthFrom,

        [Parameter()]
        [ValidateRange(0, 100)]
        [System.Int32]
        $SetHoursToLimitForegroundDownloadBandwidthIn,

        [Parameter()]
        [ValidateRange(0, 100)]
        [System.Int32]
        $SetHoursToLimitForegroundDownloadBandwidthOut,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $SetHoursToLimitBackgroundDownloadBandwidth,

        [Parameter()]
        [ValidateRange(0, 100)]
        [System.Int32]
        $SetHoursToLimitBackgroundDownloadBandwidthOut,

        [Parameter()]
        [ValidateSet('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23')]
        [System.String]
        $SetHoursToLimitBackgroundDownloadBandwidthFrom,

        [Parameter()]
        [ValidateRange(0, 100)]
        [System.Int32]
        $SetHoursToLimitBackgroundDownloadBandwidthIn,

        [Parameter()]
        [ValidateSet('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23')]
        [System.String]
        $SetHoursToLimitBackgroundDownloadBandwidthTo,

        [Parameter()]
        [System.Int32]
        $DODelayForegroundDownloadFromHttp,

        [Parameter()]
        [System.Int32]
        $DODelayBackgroundDownloadFromHttp,

        [Parameter()]
        [ValidateRange(1, 100000)]
        [System.Int32]
        $DOMinRAMAllowedToPeer,

        [Parameter()]
        [ValidateRange(1, 100000)]
        [System.Int32]
        $DOMinDiskSizeAllowedToPeer,

        [Parameter()]
        [ValidateRange(1, 100000)]
        [System.Int32]
        $DOMinFileSizeToCache,

        [Parameter()]
        [ValidateRange(0, 100)]
        [System.Int32]
        $DOMinBatteryPercentageAllowedToUpload,

        [Parameter()]
        [System.String]
        $DOModifyCacheDrive,

        [Parameter()]
        [System.Int32]
        $DOMaxCacheAge,

        [Parameter()]
        [System.Int32]
        $DOAbsoluteMaxCacheSize,

        [Parameter()]
        [ValidateRange(1, 100)]
        [System.Int32]
        $DOMaxCacheSize,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DOAllowVPNPeerCaching,

        [Parameter()]
        [System.String[]]
        $DOCacheHost,

        [Parameter()]
        [ValidateRange(1, 2)]
        [System.Int32]
        $DOCacheHostSource,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DODisallowCacheServerDownloadsOnVPN,

        [Parameter()]
        [ValidateRange(0, 2592000)]
        [System.Int32]
        $DODelayCacheServerFallbackForeground,

        [Parameter()]
        [ValidateRange(0, 2592000)]
        [System.Int32]
        $DODelayCacheServerFallbackBackground,

        [Parameter()]
        [System.Int32]
        $DOMinBackgroundQos,

        [Parameter()]
        [System.Int32]
        $DOMonthlyUploadDataCap,

        [Parameter()]
        [System.String[]]
        $DOVpnKeywords,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
        #endregion

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

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $postProcessingScript = {
        param($DesiredValues, $CurrentValues, $ValuesToCheck, $PostProcessingArgs)
        $PostProcessingArgs[0] | ForEach-Object {
            if ($_.Key -notlike '*Variable' -or $_.Key -notin @('Verbose', 'Debug', 'ErrorAction', 'WarningAction', 'InformationAction'))
            {
                if ($null -ne $CurrentValues[$_.Key] -or $null -ne $DesiredValues[$_.Key])
                {
                    $ValuesToCheck[$_.Key] = $null
                    if (-not $DesiredValues.ContainsKey($_.Key))
                    {
                        $DesiredValues.Add($_.Key, $null)
                    }
                }
            }
        }

        return [System.Tuple[Hashtable, Hashtable, Hashtable]]::new($DesiredValues, $CurrentValues, $ValuesToCheck)
    }

    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
                                         -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '') `
                                         -PostProcessing $postProcessingScript `
                                         -PostProcessingArgs $MyInvocation.MyCommand.Parameters.GetEnumerator()
    return $result
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
        [System.String]
        $Filter,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        #region resource generator code
        $policyTemplateID = "132f1027-0325-45e0-854a-6955cd3c68c0_1"
        [array]$getValue = Get-MgBetaDeviceManagementConfigurationPolicy `
            -Filter $Filter `
            -All `
            -ErrorAction Stop | Where-Object `
            -FilterScript {
                $_.TemplateReference.TemplateId -eq $policyTemplateID
            }
        #endregion

        $i = 1
        $dscContent = ''
        if ($getValue.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($config in $getValue)
        {
            $displayedKey = $config.Id
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            elseif (-not [string]::IsNullOrEmpty($config.name))
            {
                $displayedKey = $config.name
            }
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
            $params = @{
                Id = $config.Id
                DisplayName = $config.Name
                Ensure = 'Present'
                Credential = $Credential
                ApplicationId = $ApplicationId
                TenantId = $TenantId
                ApplicationSecret = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity = $ManagedIdentity.IsPresent
                AccessTokens = $AccessTokens
            }

            $Script:exportedInstance = $config
            $Results = Get-TargetResource @Params

            if ($Results.Assignments)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.Assignments -CIMInstanceName DeviceManagementConfigurationPolicyAssignments
                if ($complexTypeStringResult)
                {
                    $Results.Assignments = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('Assignments') | Out-Null
                }
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('Assignments')
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
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
