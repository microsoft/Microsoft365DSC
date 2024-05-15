function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.Int64]
        $BackgroundDownloadFromHttpDelayInSeconds,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $BandwidthMode,

        [Parameter()]
        [System.Int32]
        $CacheServerBackgroundDownloadFallbackToHttpDelayInSeconds,

        [Parameter()]
        [System.Int32]
        $CacheServerForegroundDownloadFallbackToHttpDelayInSeconds,

        [Parameter()]
        [System.String[]]
        $CacheServerHostNames,

        [Parameter()]
        [ValidateSet('userDefined', 'httpOnly', 'httpWithPeeringNat', 'httpWithPeeringPrivateGroup', 'httpWithInternetPeering', 'simpleDownload', 'bypassMode')]
        [System.String]
        $DeliveryOptimizationMode,

        [Parameter()]
        [System.Int64]
        $ForegroundDownloadFromHttpDelayInSeconds,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $GroupIdSource,

        [Parameter()]
        [System.Int32]
        $MaximumCacheAgeInDays,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MaximumCacheSize,

        [Parameter()]
        [System.Int32]
        $MinimumBatteryPercentageAllowedToUpload,

        [Parameter()]
        [System.Int32]
        $MinimumDiskSizeAllowedToPeerInGigabytes,

        [Parameter()]
        [System.Int32]
        $MinimumFileSizeToCacheInMegabytes,

        [Parameter()]
        [System.Int32]
        $MinimumRamAllowedToPeerInGigabytes,

        [Parameter()]
        [System.String]
        $ModifyCacheLocation,

        [Parameter()]
        [ValidateSet('notConfigured', 'subnetMask')]
        [System.String]
        $RestrictPeerSelectionBy,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $VpnPeerCaching,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $SupportsScopeTags,

        [Parameter()]
        [System.String]
        $Id,

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

    try
    {
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

        $nullResult = $PSBoundParameters
        $nullResult.Ensure = 'Absent'

        $getValue = $null
        #region resource generator code
        $getValue = Get-MgBetaDeviceManagementDeviceConfiguration -DeviceConfigurationId $Id  -ErrorAction SilentlyContinue

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Intune Device Configuration Delivery Optimization Policy for Windows10 with Id {$Id}"

            if (-not [string]::IsNullOrEmpty($DisplayName))
            {
                $getValue = Get-MgBetaDeviceManagementDeviceConfiguration `
                    -Filter "DisplayName eq '$DisplayName'" `
                    -ErrorAction SilentlyContinue

                if ($null -eq $getValue)
                {
                    Write-Verbose -Message "Could not find an Intune Device Configuration Delivery Optimization Policy for Windows10 with DisplayName {$DisplayName}"
                    return $nullResult
                }
                if(([array]$getValue).count -gt 1)
                {
                    throw "A policy with a duplicated displayName {'$DisplayName'} was found - Ensure displayName is unique"
                }
            }
        }
        #endregion

        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Device Configuration Delivery Optimization Policy for Windows10 with Id {$Id} and DisplayName {$DisplayName} was found."

        #region resource generator code
        $complexBandwidthMode = @{}
        $complexBandwidthMode.Add('MaximumDownloadBandwidthInKilobytesPerSecond', $getValue.AdditionalProperties.bandwidthMode.maximumDownloadBandwidthInKilobytesPerSecond)
        $complexBandwidthMode.Add('MaximumUploadBandwidthInKilobytesPerSecond', $getValue.AdditionalProperties.bandwidthMode.maximumUploadBandwidthInKilobytesPerSecond)
        $complexBandwidthBackgroundPercentageHours = @{}
        $complexBandwidthBackgroundPercentageHours.Add('BandwidthBeginBusinessHours', $getValue.AdditionalProperties.bandwidthMode.bandwidthBackgroundPercentageHours.bandwidthBeginBusinessHours)
        $complexBandwidthBackgroundPercentageHours.Add('BandwidthEndBusinessHours', $getValue.AdditionalProperties.bandwidthMode.bandwidthBackgroundPercentageHours.bandwidthEndBusinessHours)
        $complexBandwidthBackgroundPercentageHours.Add('BandwidthPercentageDuringBusinessHours', $getValue.AdditionalProperties.bandwidthMode.bandwidthBackgroundPercentageHours.bandwidthPercentageDuringBusinessHours)
        $complexBandwidthBackgroundPercentageHours.Add('BandwidthPercentageOutsideBusinessHours', $getValue.AdditionalProperties.bandwidthMode.bandwidthBackgroundPercentageHours.bandwidthPercentageOutsideBusinessHours)
        if ($complexBandwidthBackgroundPercentageHours.values.Where({ $null -ne $_ }).count -eq 0)
        {
            $complexBandwidthBackgroundPercentageHours = $null
        }
        $complexBandwidthMode.Add('BandwidthBackgroundPercentageHours', $complexBandwidthBackgroundPercentageHours)
        $complexBandwidthForegroundPercentageHours = @{}
        $complexBandwidthForegroundPercentageHours.Add('BandwidthBeginBusinessHours', $getValue.AdditionalProperties.bandwidthMode.bandwidthForegroundPercentageHours.bandwidthBeginBusinessHours)
        $complexBandwidthForegroundPercentageHours.Add('BandwidthEndBusinessHours', $getValue.AdditionalProperties.bandwidthMode.bandwidthForegroundPercentageHours.bandwidthEndBusinessHours)
        $complexBandwidthForegroundPercentageHours.Add('BandwidthPercentageDuringBusinessHours', $getValue.AdditionalProperties.bandwidthMode.bandwidthForegroundPercentageHours.bandwidthPercentageDuringBusinessHours)
        $complexBandwidthForegroundPercentageHours.Add('BandwidthPercentageOutsideBusinessHours', $getValue.AdditionalProperties.bandwidthMode.bandwidthForegroundPercentageHours.bandwidthPercentageOutsideBusinessHours)
        if ($complexBandwidthForegroundPercentageHours.values.Where({ $null -ne $_ }).count -eq 0)
        {
            $complexBandwidthForegroundPercentageHours = $null
        }
        $complexBandwidthMode.Add('BandwidthForegroundPercentageHours', $complexBandwidthForegroundPercentageHours)
        $complexBandwidthMode.Add('MaximumBackgroundBandwidthPercentage', $getValue.AdditionalProperties.bandwidthMode.maximumBackgroundBandwidthPercentage)
        $complexBandwidthMode.Add('MaximumForegroundBandwidthPercentage', $getValue.AdditionalProperties.bandwidthMode.maximumForegroundBandwidthPercentage)
        if ($null -ne $getValue.AdditionalProperties.bandwidthMode.'@odata.type')
        {
            $complexBandwidthMode.Add('odataType', $getValue.AdditionalProperties.bandwidthMode.'@odata.type'.toString())
        }
        if ($complexBandwidthMode.values.Where({ $null -ne $_ }).count -eq 0)
        {
            $complexBandwidthMode = $null
        }

        $complexGroupIdSource = @{}
        $complexGroupIdSource.Add('GroupIdCustom', $getValue.AdditionalProperties.groupIdSource.groupIdCustom)
        if ($null -ne $getValue.AdditionalProperties.groupIdSource.groupIdSourceOption)
        {
            $complexGroupIdSource.Add('GroupIdSourceOption', $getValue.AdditionalProperties.groupIdSource.groupIdSourceOption.toString())
        }
        if ($null -ne $getValue.AdditionalProperties.groupIdSource.'@odata.type')
        {
            $complexGroupIdSource.Add('odataType', $getValue.AdditionalProperties.groupIdSource.'@odata.type'.toString())
        }
        if ($complexGroupIdSource.values.Where({ $null -ne $_ }).count -eq 0)
        {
            $complexGroupIdSource = $null
        }

        $complexMaximumCacheSize = @{}
        $complexMaximumCacheSize.Add('MaximumCacheSizeInGigabytes', $getValue.AdditionalProperties.maximumCacheSize.maximumCacheSizeInGigabytes)
        $complexMaximumCacheSize.Add('MaximumCacheSizePercentage', $getValue.AdditionalProperties.maximumCacheSize.maximumCacheSizePercentage)
        if ($null -ne $getValue.AdditionalProperties.maximumCacheSize.'@odata.type')
        {
            $complexMaximumCacheSize.Add('odataType', $getValue.AdditionalProperties.maximumCacheSize.'@odata.type'.toString())
        }
        if ($complexMaximumCacheSize.values.Where({ $null -ne $_ }).count -eq 0)
        {
            $complexMaximumCacheSize = $null
        }

        #endregion

        #region resource generator code
        $enumDeliveryOptimizationMode = $null
        if ($null -ne $getValue.AdditionalProperties.deliveryOptimizationMode)
        {
            $enumDeliveryOptimizationMode = $getValue.AdditionalProperties.deliveryOptimizationMode.ToString()
        }

        $enumRestrictPeerSelectionBy = $null
        if ($null -ne $getValue.AdditionalProperties.restrictPeerSelectionBy)
        {
            $enumRestrictPeerSelectionBy = $getValue.AdditionalProperties.restrictPeerSelectionBy.ToString()
        }

        $enumVpnPeerCaching = $null
        if ($null -ne $getValue.AdditionalProperties.vpnPeerCaching)
        {
            $enumVpnPeerCaching = $getValue.AdditionalProperties.vpnPeerCaching.ToString()
        }

        #endregion

        $results = @{
            #region resource generator code
            BackgroundDownloadFromHttpDelayInSeconds                  = $getValue.AdditionalProperties.backgroundDownloadFromHttpDelayInSeconds
            BandwidthMode                                             = $complexBandwidthMode
            CacheServerBackgroundDownloadFallbackToHttpDelayInSeconds = $getValue.AdditionalProperties.cacheServerBackgroundDownloadFallbackToHttpDelayInSeconds
            CacheServerForegroundDownloadFallbackToHttpDelayInSeconds = $getValue.AdditionalProperties.cacheServerForegroundDownloadFallbackToHttpDelayInSeconds
            CacheServerHostNames                                      = $getValue.AdditionalProperties.cacheServerHostNames
            DeliveryOptimizationMode                                  = $enumDeliveryOptimizationMode
            ForegroundDownloadFromHttpDelayInSeconds                  = $getValue.AdditionalProperties.foregroundDownloadFromHttpDelayInSeconds
            GroupIdSource                                             = $complexGroupIdSource
            MaximumCacheAgeInDays                                     = $getValue.AdditionalProperties.maximumCacheAgeInDays
            MaximumCacheSize                                          = $complexMaximumCacheSize
            MinimumBatteryPercentageAllowedToUpload                   = $getValue.AdditionalProperties.minimumBatteryPercentageAllowedToUpload
            MinimumDiskSizeAllowedToPeerInGigabytes                   = $getValue.AdditionalProperties.minimumDiskSizeAllowedToPeerInGigabytes
            MinimumFileSizeToCacheInMegabytes                         = $getValue.AdditionalProperties.minimumFileSizeToCacheInMegabytes
            MinimumRamAllowedToPeerInGigabytes                        = $getValue.AdditionalProperties.minimumRamAllowedToPeerInGigabytes
            ModifyCacheLocation                                       = $getValue.AdditionalProperties.modifyCacheLocation
            RestrictPeerSelectionBy                                   = $enumRestrictPeerSelectionBy
            VpnPeerCaching                                            = $enumVpnPeerCaching
            Description                                               = $getValue.Description
            DisplayName                                               = $getValue.DisplayName
            SupportsScopeTags                                         = $getValue.SupportsScopeTags
            Id                                                        = $getValue.Id
            Ensure                                                    = 'Present'
            Credential                                                = $Credential
            ApplicationId                                             = $ApplicationId
            TenantId                                                  = $TenantId
            ApplicationSecret                                         = $ApplicationSecret
            CertificateThumbprint                                     = $CertificateThumbprint
            Managedidentity                                           = $ManagedIdentity.IsPresent
            AccessTokens                                              = $AccessTokens
            #endregion
        }
        $returnAssignments = @()
        $graphAssignments = Get-MgBetaDeviceManagementDeviceConfigurationAssignment -DeviceConfigurationId $Id
        if ($graphAssignments.count -gt 0)
        {
            $returnAssignments += ConvertFrom-IntunePolicyAssignment `
                                -IncludeDeviceFilter:$true `
                                -Assignments ($graphAssignments)
        }
        $results.Add('Assignments', $returnAssignments)
        return [System.Collections.Hashtable] $results
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        $nullResult = Clear-M365DSCAuthenticationParameter -BoundParameters $nullResult
        return $nullResult
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.Int64]
        $BackgroundDownloadFromHttpDelayInSeconds,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $BandwidthMode,

        [Parameter()]
        [System.Int32]
        $CacheServerBackgroundDownloadFallbackToHttpDelayInSeconds,

        [Parameter()]
        [System.Int32]
        $CacheServerForegroundDownloadFallbackToHttpDelayInSeconds,

        [Parameter()]
        [System.String[]]
        $CacheServerHostNames,

        [Parameter()]
        [ValidateSet('userDefined', 'httpOnly', 'httpWithPeeringNat', 'httpWithPeeringPrivateGroup', 'httpWithInternetPeering', 'simpleDownload', 'bypassMode')]
        [System.String]
        $DeliveryOptimizationMode,

        [Parameter()]
        [System.Int64]
        $ForegroundDownloadFromHttpDelayInSeconds,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $GroupIdSource,

        [Parameter()]
        [System.Int32]
        $MaximumCacheAgeInDays,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MaximumCacheSize,

        [Parameter()]
        [System.Int32]
        $MinimumBatteryPercentageAllowedToUpload,

        [Parameter()]
        [System.Int32]
        $MinimumDiskSizeAllowedToPeerInGigabytes,

        [Parameter()]
        [System.Int32]
        $MinimumFileSizeToCacheInMegabytes,

        [Parameter()]
        [System.Int32]
        $MinimumRamAllowedToPeerInGigabytes,

        [Parameter()]
        [System.String]
        $ModifyCacheLocation,

        [Parameter()]
        [ValidateSet('notConfigured', 'subnetMask')]
        [System.String]
        $RestrictPeerSelectionBy,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $VpnPeerCaching,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $SupportsScopeTags,

        [Parameter()]
        [System.String]
        $Id,

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
    $PSBoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Device Configuration Delivery Optimization Policy for Windows10 with DisplayName {$DisplayName}"
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $CreateParameters = ([Hashtable]$PSBoundParameters).clone()
        $CreateParameters = Rename-M365DSCCimInstanceParameter -Properties $CreateParameters
        $CreateParameters.Remove('Id') | Out-Null

        $keys = (([Hashtable]$CreateParameters).clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $CreateParameters.$key -and $CreateParameters.$key.getType().Name -like '*cimInstance*')
            {
                $CreateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $CreateParameters.$key
            }
        }
        #region resource generator code
        $CreateParameters.Add("@odata.type", "#microsoft.graph.windowsDeliveryOptimizationConfiguration")
        $policy = New-MgBetaDeviceManagementDeviceConfiguration -BodyParameter $CreateParameters
        $assignmentsHash=@()
        foreach($assignment in $Assignments)
        {
            $assignmentsHash += Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignment
        }

        if ($policy.id)
        {
            Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $policy.id `
                -Targets $assignmentsHash `
                -Repository 'deviceManagement/deviceConfigurations'
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune Device Configuration Delivery Optimization Policy for Windows10 with Id {$($currentInstance.Id)}"
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $UpdateParameters = ([Hashtable]$PSBoundParameters).clone()
        $UpdateParameters = Rename-M365DSCCimInstanceParameter -Properties $UpdateParameters

        $UpdateParameters.Remove('Id') | Out-Null

        $keys = (([Hashtable]$UpdateParameters).clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $UpdateParameters.$key -and $UpdateParameters.$key.getType().Name -like '*cimInstance*')
            {
                $UpdateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $UpdateParameters.$key
            }
        }
        #region resource generator code
        $UpdateParameters.Add("@odata.type", "#microsoft.graph.windowsDeliveryOptimizationConfiguration")
        Update-MgBetaDeviceManagementDeviceConfiguration  `
            -DeviceConfigurationId $currentInstance.Id `
            -BodyParameter $UpdateParameters
        $assignmentsHash = @()
        foreach ($assignment in $Assignments)
        {
            $assignmentsHash += Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignment
        }
        Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $currentInstance.id `
            -Targets $assignmentsHash `
            -Repository 'deviceManagement/deviceConfigurations'
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune Device Configuration Delivery Optimization Policy for Windows10 with Id {$($currentInstance.Id)}"
        #region resource generator code
        Remove-MgBetaDeviceManagementDeviceConfiguration -DeviceConfigurationId $currentInstance.Id
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
        [System.Int64]
        $BackgroundDownloadFromHttpDelayInSeconds,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $BandwidthMode,

        [Parameter()]
        [System.Int32]
        $CacheServerBackgroundDownloadFallbackToHttpDelayInSeconds,

        [Parameter()]
        [System.Int32]
        $CacheServerForegroundDownloadFallbackToHttpDelayInSeconds,

        [Parameter()]
        [System.String[]]
        $CacheServerHostNames,

        [Parameter()]
        [ValidateSet('userDefined', 'httpOnly', 'httpWithPeeringNat', 'httpWithPeeringPrivateGroup', 'httpWithInternetPeering', 'simpleDownload', 'bypassMode')]
        [System.String]
        $DeliveryOptimizationMode,

        [Parameter()]
        [System.Int64]
        $ForegroundDownloadFromHttpDelayInSeconds,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $GroupIdSource,

        [Parameter()]
        [System.Int32]
        $MaximumCacheAgeInDays,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MaximumCacheSize,

        [Parameter()]
        [System.Int32]
        $MinimumBatteryPercentageAllowedToUpload,

        [Parameter()]
        [System.Int32]
        $MinimumDiskSizeAllowedToPeerInGigabytes,

        [Parameter()]
        [System.Int32]
        $MinimumFileSizeToCacheInMegabytes,

        [Parameter()]
        [System.Int32]
        $MinimumRamAllowedToPeerInGigabytes,

        [Parameter()]
        [System.String]
        $ModifyCacheLocation,

        [Parameter()]
        [ValidateSet('notConfigured', 'subnetMask')]
        [System.String]
        $RestrictPeerSelectionBy,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $VpnPeerCaching,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $SupportsScopeTags,

        [Parameter()]
        [System.String]
        $Id,

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

    Write-Verbose -Message "Testing configuration of the Intune Device Configuration Delivery Optimization Policy for Windows10 with Id {$Id} and DisplayName {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    if (-not (Test-M365DSCAuthenticationParameter -BoundParameters $CurrentValues))
    {
        Write-Verbose "An error occured in Get-TargetResource, the policy {$displayName} will not be processed"
        throw "An error occured in Get-TargetResource, the policy {$displayName} will not be processed. Refer to the event viewer logs for more information."
    }
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()
    $ValuesToCheck = Remove-M365DSCAuthenticationParameter -BoundParameters $ValuesToCheck
    $ValuesToCheck.Remove('Id') | Out-Null

    if ($CurrentValues.Ensure -ne $Ensure)
    {
        Write-Verbose -Message "Test-TargetResource returned $false"
        return $false
    }
    $testResult = $true

    #Compare Cim instances
    foreach ($key in $PSBoundParameters.Keys)
    {
        $source = $PSBoundParameters.$key
        $target = $CurrentValues.$key
        if ($source.getType().Name -like '*CimInstance*')
        {
            $source = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $source

            $testResult = Compare-M365DSCComplexObject `
                -Source ($source) `
                -Target ($target)

            if ($key -eq 'Assignments')
            {
                $testResult = Compare-M365DSCIntunePolicyAssignment -Source $source -Target $target
            }

            if (-Not $testResult)
            {
                $testResult = $false
                break
            }

            $ValuesToCheck.Remove($key) | Out-Null

        }
    }

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

    if ($testResult)
    {
        $testResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
            -Source $($MyInvocation.MyCommand.Source) `
            -DesiredValues $PSBoundParameters `
            -ValuesToCheck $ValuesToCheck.Keys
    }

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
        [array]$getValue = Get-MgBetaDeviceManagementDeviceConfiguration -Filter $Filter -All `
            -ErrorAction Stop | Where-Object `
            -FilterScript { `
                $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.windowsDeliveryOptimizationConfiguration' `
        }
        #endregion

        $i = 1
        $dscContent = ''
        if ($getValue.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($config in $getValue)
        {
            $displayedKey = $config.Id
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            Write-Host "    |---[$i/$($getValue.Count)] $displayedKey" -NoNewline
            $params = @{
                Id                    = $config.Id
                DisplayName           = $config.DisplayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                Managedidentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Results = Get-TargetResource @params
            if (-not (Test-M365DSCAuthenticationParameter -BoundParameters $Results))
            {
                Write-Verbose "An error occured in Get-TargetResource, the policy {$($params.displayName)} will not be processed"
                throw "An error occured in Get-TargetResource, the policy {$($params.displayName)} will not be processed. Refer to the event viewer logs for more information."
            }
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            if ( $null -ne $Results.BandwidthMode)
            {
                $complexMapping = @(
                    @{
                        Name            = 'BandwidthMode'
                        CimInstanceName = 'MicrosoftGraphDeliveryOptimizationBandwidth'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'BandwidthBackgroundPercentageHours'
                        CimInstanceName = 'MicrosoftGraphDeliveryOptimizationBandwidthBusinessHoursLimit'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'BandwidthForegroundPercentageHours'
                        CimInstanceName = 'MicrosoftGraphDeliveryOptimizationBandwidthBusinessHoursLimit'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.BandwidthMode `
                    -CIMInstanceName 'MicrosoftGraphdeliveryOptimizationBandwidth' `
                    -ComplexTypeMapping $complexMapping

                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.BandwidthMode = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('BandwidthMode') | Out-Null
                }
            }
            if ( $null -ne $Results.GroupIdSource)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.GroupIdSource `
                    -CIMInstanceName 'MicrosoftGraphdeliveryOptimizationGroupIdSource'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.GroupIdSource = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('GroupIdSource') | Out-Null
                }
            }
            if ( $null -ne $Results.MaximumCacheSize)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.MaximumCacheSize `
                    -CIMInstanceName 'MicrosoftGraphdeliveryOptimizationMaxCacheSize'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.MaximumCacheSize = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('MaximumCacheSize') | Out-Null
                }
            }
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
                -Credential $Credential
            if ($Results.BandwidthMode)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'BandwidthMode' -IsCIMArray:$False
            }
            if ($Results.GroupIdSource)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'GroupIdSource' -IsCIMArray:$False
            }
            if ($Results.MaximumCacheSize)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'MaximumCacheSize' -IsCIMArray:$False
            }
            if ($Results.Assignments)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'Assignments' -IsCIMArray:$true
            }
            #removing trailing commas and semi colons between items of an array of cim instances added by Convert-DSCStringParamToVariable
            $currentDSCBlock = $currentDSCBlock.replace( "    ,`r`n" , "    `r`n" )
            $currentDSCBlock = $currentDSCBlock.replace( "`r`n;`r`n" , "`r`n" )
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
        if ($_.Exception -like '*401*' -or $_.ErrorDetails.Message -like "*`"ErrorCode`":`"Forbidden`"*" -or `
        $_.Exception -like "*Request not applicable to target tenant*")
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
