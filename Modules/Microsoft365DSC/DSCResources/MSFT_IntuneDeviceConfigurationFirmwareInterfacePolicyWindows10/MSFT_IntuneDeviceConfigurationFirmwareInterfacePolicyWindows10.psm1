function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $Bluetooth,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $BootFromBuiltInNetworkAdapters,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $BootFromExternalMedia,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $Cameras,

        [Parameter()]
        [ValidateSet('notConfiguredOnly','none')]
        [System.String]
        $ChangeUefiSettingsPermission,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $FrontCamera,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $InfraredCamera,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $Microphone,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $MicrophonesAndSpeakers,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $NearFieldCommunication,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $Radios,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $RearCamera,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $SdCard,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $SimultaneousMultiThreading,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $UsbTypeAPort,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $VirtualizationOfCpuAndIO,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $WakeOnLAN,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $WakeOnPower,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $WiFi,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $WindowsPlatformBinaryTable,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $WirelessWideAreaNetwork,

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
        $ManagedIdentity
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
            Write-Verbose -Message "Could not find an Intune Device Configuration Firmware Interface Policy for Windows10 with Id {$Id}"

            if (-Not [string]::IsNullOrEmpty($DisplayName))
            {
                $getValue = Get-MgBetaDeviceManagementDeviceConfiguration `
                    -Filter "DisplayName eq '$DisplayName'" `
                    -ErrorAction SilentlyContinue | Where-Object `
                    -FilterScript { `
                        $_.AdditionalProperties.'@odata.type' -eq "#microsoft.graph.windows10DeviceFirmwareConfigurationInterface" `
                    }
            }
        }
        #endregion
        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Intune Device Configuration Firmware Interface Policy for Windows10 with DisplayName {$DisplayName}"
            return $nullResult
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Device Configuration Firmware Interface Policy for Windows10 with Id {$Id} and DisplayName {$DisplayName} was found."

        #region resource generator code
        $enumBluetooth = $null
        if ($null -ne $getValue.AdditionalProperties.bluetooth)
        {
            $enumBluetooth = $getValue.AdditionalProperties.bluetooth.ToString()
        }

        $enumBootFromBuiltInNetworkAdapters = $null
        if ($null -ne $getValue.AdditionalProperties.bootFromBuiltInNetworkAdapters)
        {
            $enumBootFromBuiltInNetworkAdapters = $getValue.AdditionalProperties.bootFromBuiltInNetworkAdapters.ToString()
        }

        $enumBootFromExternalMedia = $null
        if ($null -ne $getValue.AdditionalProperties.bootFromExternalMedia)
        {
            $enumBootFromExternalMedia = $getValue.AdditionalProperties.bootFromExternalMedia.ToString()
        }

        $enumCameras = $null
        if ($null -ne $getValue.AdditionalProperties.cameras)
        {
            $enumCameras = $getValue.AdditionalProperties.cameras.ToString()
        }

        $enumChangeUefiSettingsPermission = $null
        if ($null -ne $getValue.AdditionalProperties.changeUefiSettingsPermission)
        {
            $enumChangeUefiSettingsPermission = $getValue.AdditionalProperties.changeUefiSettingsPermission.ToString()
        }

        $enumFrontCamera = $null
        if ($null -ne $getValue.AdditionalProperties.frontCamera)
        {
            $enumFrontCamera = $getValue.AdditionalProperties.frontCamera.ToString()
        }

        $enumInfraredCamera = $null
        if ($null -ne $getValue.AdditionalProperties.infraredCamera)
        {
            $enumInfraredCamera = $getValue.AdditionalProperties.infraredCamera.ToString()
        }

        $enumMicrophone = $null
        if ($null -ne $getValue.AdditionalProperties.microphone)
        {
            $enumMicrophone = $getValue.AdditionalProperties.microphone.ToString()
        }

        $enumMicrophonesAndSpeakers = $null
        if ($null -ne $getValue.AdditionalProperties.microphonesAndSpeakers)
        {
            $enumMicrophonesAndSpeakers = $getValue.AdditionalProperties.microphonesAndSpeakers.ToString()
        }

        $enumNearFieldCommunication = $null
        if ($null -ne $getValue.AdditionalProperties.nearFieldCommunication)
        {
            $enumNearFieldCommunication = $getValue.AdditionalProperties.nearFieldCommunication.ToString()
        }

        $enumRadios = $null
        if ($null -ne $getValue.AdditionalProperties.radios)
        {
            $enumRadios = $getValue.AdditionalProperties.radios.ToString()
        }

        $enumRearCamera = $null
        if ($null -ne $getValue.AdditionalProperties.rearCamera)
        {
            $enumRearCamera = $getValue.AdditionalProperties.rearCamera.ToString()
        }

        $enumSdCard = $null
        if ($null -ne $getValue.AdditionalProperties.sdCard)
        {
            $enumSdCard = $getValue.AdditionalProperties.sdCard.ToString()
        }

        $enumSimultaneousMultiThreading = $null
        if ($null -ne $getValue.AdditionalProperties.simultaneousMultiThreading)
        {
            $enumSimultaneousMultiThreading = $getValue.AdditionalProperties.simultaneousMultiThreading.ToString()
        }

        $enumUsbTypeAPort = $null
        if ($null -ne $getValue.AdditionalProperties.usbTypeAPort)
        {
            $enumUsbTypeAPort = $getValue.AdditionalProperties.usbTypeAPort.ToString()
        }

        $enumVirtualizationOfCpuAndIO = $null
        if ($null -ne $getValue.AdditionalProperties.virtualizationOfCpuAndIO)
        {
            $enumVirtualizationOfCpuAndIO = $getValue.AdditionalProperties.virtualizationOfCpuAndIO.ToString()
        }

        $enumWakeOnLAN = $null
        if ($null -ne $getValue.AdditionalProperties.wakeOnLAN)
        {
            $enumWakeOnLAN = $getValue.AdditionalProperties.wakeOnLAN.ToString()
        }

        $enumWakeOnPower = $null
        if ($null -ne $getValue.AdditionalProperties.wakeOnPower)
        {
            $enumWakeOnPower = $getValue.AdditionalProperties.wakeOnPower.ToString()
        }

        $enumWiFi = $null
        if ($null -ne $getValue.AdditionalProperties.wiFi)
        {
            $enumWiFi = $getValue.AdditionalProperties.wiFi.ToString()
        }

        $enumWindowsPlatformBinaryTable = $null
        if ($null -ne $getValue.AdditionalProperties.windowsPlatformBinaryTable)
        {
            $enumWindowsPlatformBinaryTable = $getValue.AdditionalProperties.windowsPlatformBinaryTable.ToString()
        }

        $enumWirelessWideAreaNetwork = $null
        if ($null -ne $getValue.AdditionalProperties.wirelessWideAreaNetwork)
        {
            $enumWirelessWideAreaNetwork = $getValue.AdditionalProperties.wirelessWideAreaNetwork.ToString()
        }
        #endregion

        $results = @{
            #region resource generator code
            Bluetooth                      = $enumBluetooth
            BootFromBuiltInNetworkAdapters = $enumBootFromBuiltInNetworkAdapters
            BootFromExternalMedia          = $enumBootFromExternalMedia
            Cameras                        = $enumCameras
            ChangeUefiSettingsPermission   = $enumChangeUefiSettingsPermission
            FrontCamera                    = $enumFrontCamera
            InfraredCamera                 = $enumInfraredCamera
            Microphone                     = $enumMicrophone
            MicrophonesAndSpeakers         = $enumMicrophonesAndSpeakers
            NearFieldCommunication         = $enumNearFieldCommunication
            Radios                         = $enumRadios
            RearCamera                     = $enumRearCamera
            SdCard                         = $enumSdCard
            SimultaneousMultiThreading     = $enumSimultaneousMultiThreading
            UsbTypeAPort                   = $enumUsbTypeAPort
            VirtualizationOfCpuAndIO       = $enumVirtualizationOfCpuAndIO
            WakeOnLAN                      = $enumWakeOnLAN
            WakeOnPower                    = $enumWakeOnPower
            WiFi                           = $enumWiFi
            WindowsPlatformBinaryTable     = $enumWindowsPlatformBinaryTable
            WirelessWideAreaNetwork        = $enumWirelessWideAreaNetwork
            Description                    = $getValue.Description
            DisplayName                    = $getValue.DisplayName
            SupportsScopeTags              = $getValue.SupportsScopeTags
            Id                             = $getValue.Id
            Ensure                         = 'Present'
            Credential                     = $Credential
            ApplicationId                  = $ApplicationId
            TenantId                       = $TenantId
            ApplicationSecret              = $ApplicationSecret
            CertificateThumbprint          = $CertificateThumbprint
            Managedidentity                = $ManagedIdentity.IsPresent
            #endregion
        }
        $assignmentsValues = Get-MgBetaDeviceManagementDeviceConfigurationAssignment -DeviceConfigurationId $Id
        $assignmentResult = @()
        foreach ($assignmentEntry in $AssignmentsValues)
        {
            $assignmentValue = @{
                dataType = $assignmentEntry.Target.AdditionalProperties.'@odata.type'
                deviceAndAppManagementAssignmentFilterType = $(if ($null -ne $assignmentEntry.Target.DeviceAndAppManagementAssignmentFilterType)
                    {$assignmentEntry.Target.DeviceAndAppManagementAssignmentFilterType.ToString()})
                deviceAndAppManagementAssignmentFilterId = $assignmentEntry.Target.DeviceAndAppManagementAssignmentFilterId
                groupId = $assignmentEntry.Target.AdditionalProperties.groupId
            }
            $assignmentResult += $assignmentValue
        }
        $results.Add('Assignments', $assignmentResult)

        return [System.Collections.Hashtable] $results
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
        #region resource generator code
        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $Bluetooth,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $BootFromBuiltInNetworkAdapters,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $BootFromExternalMedia,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $Cameras,

        [Parameter()]
        [ValidateSet('notConfiguredOnly','none')]
        [System.String]
        $ChangeUefiSettingsPermission,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $FrontCamera,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $InfraredCamera,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $Microphone,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $MicrophonesAndSpeakers,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $NearFieldCommunication,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $Radios,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $RearCamera,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $SdCard,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $SimultaneousMultiThreading,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $UsbTypeAPort,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $VirtualizationOfCpuAndIO,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $WakeOnLAN,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $WakeOnPower,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $WiFi,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $WindowsPlatformBinaryTable,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $WirelessWideAreaNetwork,

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
        $ManagedIdentity
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

    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Device Configuration Firmware Interface Policy for Windows10 with DisplayName {$DisplayName}"
        $BoundParameters.Remove("Assignments") | Out-Null

        $CreateParameters = ([Hashtable]$BoundParameters).clone()
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
        $CreateParameters.Add("@odata.type", "#microsoft.graph.windows10DeviceFirmwareConfigurationInterface")
        $policy = New-MgBetaDeviceManagementDeviceConfiguration -BodyParameter $CreateParameters
        $assignmentsHash = @()
        foreach ($assignment in $Assignments)
        {
            $assignmentsHash += Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignment
        }

        if ($policy.id)
        {
            Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId  $policy.id `
                -Targets $assignmentsHash `
                -Repository 'deviceManagement/deviceConfigurations'
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune Device Configuration Firmware Interface Policy for Windows10 with Id {$($currentInstance.Id)}"
        $BoundParameters.Remove("Assignments") | Out-Null

        $UpdateParameters = ([Hashtable]$BoundParameters).clone()
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
        $UpdateParameters.Add("@odata.type", "#microsoft.graph.windows10DeviceFirmwareConfigurationInterface")
        Update-MgBetaDeviceManagementDeviceConfiguration  `
            -DeviceConfigurationId $currentInstance.Id `
            -BodyParameter $UpdateParameters
        $assignmentsHash = @()
        foreach ($assignment in $Assignments)
        {
            $assignmentsHash += Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignment
        }
        Update-DeviceConfigurationPolicyAssignment `
            -DeviceConfigurationPolicyId $currentInstance.id `
            -Targets $assignmentsHash `
            -Repository 'deviceManagement/deviceConfigurations'
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune Device Configuration Firmware Interface Policy for Windows10 with Id {$($currentInstance.Id)}"
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
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $Bluetooth,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $BootFromBuiltInNetworkAdapters,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $BootFromExternalMedia,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $Cameras,

        [Parameter()]
        [ValidateSet('notConfiguredOnly','none')]
        [System.String]
        $ChangeUefiSettingsPermission,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $FrontCamera,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $InfraredCamera,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $Microphone,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $MicrophonesAndSpeakers,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $NearFieldCommunication,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $Radios,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $RearCamera,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $SdCard,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $SimultaneousMultiThreading,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $UsbTypeAPort,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $VirtualizationOfCpuAndIO,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $WakeOnLAN,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $WakeOnPower,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $WiFi,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $WindowsPlatformBinaryTable,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $WirelessWideAreaNetwork,

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
        $ManagedIdentity
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

    Write-Verbose -Message "Testing configuration of the Intune Device Configuration Firmware Interface Policy for Windows10 with Id {$Id} and DisplayName {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()

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

            if (-Not $testResult)
            {
                $testResult = $false
                break
            }

            $ValuesToCheck.Remove($key) | Out-Null
        }
    }

    $ValuesToCheck.remove('Id') | Out-Null
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null

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
        $ManagedIdentity
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
                $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.windows10DeviceFirmwareConfigurationInterface' `
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
                Id = $config.Id
                DisplayName           =  $config.DisplayName
                Ensure = 'Present'
                Credential = $Credential
                ApplicationId = $ApplicationId
                TenantId = $TenantId
                ApplicationSecret = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                Managedidentity = $ManagedIdentity.IsPresent
            }

            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
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
            if ($Results.Assignments)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "Assignments" -isCIMArray:$true
            }

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
