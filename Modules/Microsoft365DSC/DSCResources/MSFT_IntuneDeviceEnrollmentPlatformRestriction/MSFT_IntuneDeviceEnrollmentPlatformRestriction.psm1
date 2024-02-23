function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateSet('singlePlatformRestriction', 'platformRestrictions')]
        [System.String]
        $DeviceEnrollmentConfigurationType,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $IosRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WindowsRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WindowsHomeSkuRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WindowsMobileRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AndroidRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AndroidForWorkRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MacRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MacOSRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $PlatformRestriction,

        [Parameter()]
        [ValidateSet('android', 'androidForWork', 'ios', 'mac', 'windows')]
        $PlatformType,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter()]
        [System.Int32]
        $Priority,

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
    Write-Verbose -Message "Checking for the Intune Device Enrollment Restriction {$DisplayName}"
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
        try {
            $config = Get-MgBetaDeviceManagementDeviceEnrollmentConfiguration -DeviceEnrollmentConfigurationId $Identity -ErrorAction Stop
        }
        catch {
            $config = $null
        }

        if ($null -eq $config)
        {
            Write-Verbose -Message "Could not find an Intune Device Enrollment Platform Restriction with Id {$Identity}"
            $config = Get-MgBetaDeviceManagementDeviceEnrollmentConfiguration -Filter "DisplayName eq '$DisplayName'" `
                -ErrorAction SilentlyContinue | Where-Object `
                -FilterScript { `
                    $_.AdditionalProperties.'@odata.type' -like "#microsoft.graph.deviceEnrollmentPlatformRestriction*Configuration" -and `
                    $(if ($null -ne $_.AdditionalProperties.platformType) { $_.AdditionalProperties.platformType -eq $PlatformType } else { $true }) `
                }
        }

        if ($null -eq $config)
        {
            Write-Verbose -Message "Could not find an Intune Device Enrollment Platform Restriction with DisplayName {$DisplayName}"
            return $nullResult
        }

        Write-Verbose -Message "Found Intune Device Enrollment Platform Restriction with Name {$($config.DisplayName)}"
        $results = @{
            Identity                          = $config.Id
            DisplayName                       = $config.DisplayName
            Description                       = $config.Description
            DeviceEnrollmentConfigurationType = $config.DeviceEnrollmentConfigurationType.toString()
            Priority                          = $config.Priority
            Ensure                            = 'Present'
            Credential                        = $Credential
            ApplicationId                     = $ApplicationId
            TenantId                          = $TenantId
            ApplicationSecret                 = $ApplicationSecret
            CertificateThumbprint             = $CertificateThumbprint
            ManagedIdentity                   = $ManagedIdentity.IsPresent
        }

        # Check if it is not a "Default platform restriction"
        if ($config.AdditionalProperties.platformType)
        {
            $results.Add('PlatformType', $config.AdditionalProperties.platformType.ToString())

            $complexPlatformRestriction = @{}
            $complexPlatformRestriction.Add('BlockedManufacturers', $config.AdditionalProperties.platformRestriction.blockedManufacturers)
            $complexPlatformRestriction.Add('BlockedSkus', $config.AdditionalProperties.platformRestriction.blockedSkus)
            $complexPlatformRestriction.Add('OsMaximumVersion', $config.AdditionalProperties.platformRestriction.osMaximumVersion)
            $complexPlatformRestriction.Add('OsMinimumVersion', $config.AdditionalProperties.platformRestriction.osMinimumVersion)
            $complexPlatformRestriction.Add('PersonalDeviceEnrollmentBlocked', $config.AdditionalProperties.platformRestriction.personalDeviceEnrollmentBlocked)
            $complexPlatformRestriction.Add('PlatformBlocked', $config.AdditionalProperties.platformRestriction.platformBlocked)
            if ($complexPlatformRestriction.values.Where({$null -ne $_}).count -eq 0)
            {
                $complexPlatformRestriction = $null
            }

            $results.Add("PlatformRestriction", $complexPlatformRestriction)
        } 
        else
        {
            $complexAndroidForWorkRestriction = @{}
            $complexAndroidForWorkRestriction.Add('BlockedManufacturers', $config.AdditionalProperties.androidForWorkRestriction.blockedManufacturers)
            $complexAndroidForWorkRestriction.Add('BlockedSkus', $config.AdditionalProperties.androidForWorkRestriction.blockedSkus)
            $complexAndroidForWorkRestriction.Add('OsMaximumVersion', $config.AdditionalProperties.androidForWorkRestriction.osMaximumVersion)
            $complexAndroidForWorkRestriction.Add('OsMinimumVersion', $config.AdditionalProperties.androidForWorkRestriction.osMinimumVersion)
            $complexAndroidForWorkRestriction.Add('PersonalDeviceEnrollmentBlocked', $config.AdditionalProperties.androidForWorkRestriction.personalDeviceEnrollmentBlocked)
            $complexAndroidForWorkRestriction.Add('PlatformBlocked', $config.AdditionalProperties.androidForWorkRestriction.platformBlocked)
            if ($complexAndroidForWorkRestriction.values.Where({$null -ne $_}).count -eq 0)
            {
                $complexAndroidForWorkRestriction = $null
            }

            $complexAndroidRestriction = @{}
            $complexAndroidRestriction.Add('BlockedManufacturers', $config.AdditionalProperties.androidRestriction.blockedManufacturers)
            $complexAndroidRestriction.Add('BlockedSkus', $config.AdditionalProperties.androidRestriction.blockedSkus)
            $complexAndroidRestriction.Add('OsMaximumVersion', $config.AdditionalProperties.androidRestriction.osMaximumVersion)
            $complexAndroidRestriction.Add('OsMinimumVersion', $config.AdditionalProperties.androidRestriction.osMinimumVersion)
            $complexAndroidRestriction.Add('PersonalDeviceEnrollmentBlocked', $config.AdditionalProperties.androidRestriction.personalDeviceEnrollmentBlocked)
            $complexAndroidRestriction.Add('PlatformBlocked', $config.AdditionalProperties.androidRestriction.platformBlocked)
            if ($complexAndroidRestriction.values.Where({$null -ne $_}).count -eq 0)
            {
                $complexAndroidRestriction = $null
            }

            $complexIosRestriction = @{}
            $complexIosRestriction.Add('BlockedManufacturers', $config.AdditionalProperties.iosRestriction.blockedManufacturers)
            $complexIosRestriction.Add('BlockedSkus', $config.AdditionalProperties.iosRestriction.blockedSkus)
            $complexIosRestriction.Add('OsMaximumVersion', $config.AdditionalProperties.iosRestriction.osMaximumVersion)
            $complexIosRestriction.Add('OsMinimumVersion', $config.AdditionalProperties.iosRestriction.osMinimumVersion)
            $complexIosRestriction.Add('PersonalDeviceEnrollmentBlocked', $config.AdditionalProperties.iosRestriction.personalDeviceEnrollmentBlocked)
            $complexIosRestriction.Add('PlatformBlocked', $config.AdditionalProperties.iosRestriction.platformBlocked)
            if ($complexIosRestriction.values.Where({$null -ne $_}).count -eq 0)
            {
                $complexIosRestriction = $null
            }

            $complexMacOSRestriction = @{}
            $complexMacOSRestriction.Add('BlockedManufacturers', $config.AdditionalProperties.macOSRestriction.blockedManufacturers)
            $complexMacOSRestriction.Add('BlockedSkus', $config.AdditionalProperties.macOSRestriction.blockedSkus)
            $complexMacOSRestriction.Add('OsMaximumVersion', $config.AdditionalProperties.macOSRestriction.osMaximumVersion)
            $complexMacOSRestriction.Add('OsMinimumVersion', $config.AdditionalProperties.macOSRestriction.osMinimumVersion)
            $complexMacOSRestriction.Add('PersonalDeviceEnrollmentBlocked', $config.AdditionalProperties.macOSRestriction.personalDeviceEnrollmentBlocked)
            $complexMacOSRestriction.Add('PlatformBlocked', $config.AdditionalProperties.macOSRestriction.platformBlocked)
            if ($complexMacOSRestriction.values.Where({$null -ne $_}).count -eq 0)
            {
                $complexMacOSRestriction = $null
            }

            $complexMacRestriction = @{}
            $complexMacRestriction.Add('BlockedManufacturers', $config.AdditionalProperties.macRestriction.blockedManufacturers)
            $complexMacRestriction.Add('BlockedSkus', $config.AdditionalProperties.macRestriction.blockedSkus)
            $complexMacRestriction.Add('OsMaximumVersion', $config.AdditionalProperties.macRestriction.osMaximumVersion)
            $complexMacRestriction.Add('OsMinimumVersion', $config.AdditionalProperties.macRestriction.osMinimumVersion)
            $complexMacRestriction.Add('PersonalDeviceEnrollmentBlocked', $config.AdditionalProperties.macRestriction.personalDeviceEnrollmentBlocked)
            $complexMacRestriction.Add('PlatformBlocked', $config.AdditionalProperties.macRestriction.platformBlocked)
            if ($complexMacRestriction.values.Where({$null -ne $_}).count -eq 0)
            {
                $complexMacRestriction = $null
            }

            $complexWindowsHomeSkuRestriction = @{}
            $complexWindowsHomeSkuRestriction.Add('BlockedManufacturers', $config.AdditionalProperties.windowsHomeSkuRestriction.blockedManufacturers)
            $complexWindowsHomeSkuRestriction.Add('BlockedSkus', $config.AdditionalProperties.windowsHomeSkuRestriction.blockedSkus)
            $complexWindowsHomeSkuRestriction.Add('OsMaximumVersion', $config.AdditionalProperties.windowsHomeSkuRestriction.osMaximumVersion)
            $complexWindowsHomeSkuRestriction.Add('OsMinimumVersion', $config.AdditionalProperties.windowsHomeSkuRestriction.osMinimumVersion)
            $complexWindowsHomeSkuRestriction.Add('PersonalDeviceEnrollmentBlocked', $config.AdditionalProperties.windowsHomeSkuRestriction.personalDeviceEnrollmentBlocked)
            $complexWindowsHomeSkuRestriction.Add('PlatformBlocked', $config.AdditionalProperties.windowsHomeSkuRestriction.platformBlocked)
            if ($complexWindowsHomeSkuRestriction.values.Where({$null -ne $_}).count -eq 0)
            {
                $complexWindowsHomeSkuRestriction = $null
            }

            $complexWindowsMobileRestriction = @{}
            $complexWindowsMobileRestriction.Add('BlockedManufacturers', $config.AdditionalProperties.windowsMobileRestriction.blockedManufacturers)
            $complexWindowsMobileRestriction.Add('BlockedSkus', $config.AdditionalProperties.windowsMobileRestriction.blockedSkus)
            $complexWindowsMobileRestriction.Add('OsMaximumVersion', $config.AdditionalProperties.windowsMobileRestriction.osMaximumVersion)
            $complexWindowsMobileRestriction.Add('OsMinimumVersion', $config.AdditionalProperties.windowsMobileRestriction.osMinimumVersion)
            $complexWindowsMobileRestriction.Add('PersonalDeviceEnrollmentBlocked', $config.AdditionalProperties.windowsMobileRestriction.personalDeviceEnrollmentBlocked)
            $complexWindowsMobileRestriction.Add('PlatformBlocked', $config.AdditionalProperties.windowsMobileRestriction.platformBlocked)
            if ($complexWindowsMobileRestriction.values.Where({$null -ne $_}).count -eq 0)
            {
                $complexWindowsMobileRestriction = $null
            }

            $complexWindowsRestriction = @{}
            $complexWindowsRestriction.Add('BlockedManufacturers', $config.AdditionalProperties.windowsRestriction.blockedManufacturers)
            $complexWindowsRestriction.Add('BlockedSkus', $config.AdditionalProperties.windowsRestriction.blockedSkus)
            $complexWindowsRestriction.Add('OsMaximumVersion', $config.AdditionalProperties.windowsRestriction.osMaximumVersion)
            $complexWindowsRestriction.Add('OsMinimumVersion', $config.AdditionalProperties.windowsRestriction.osMinimumVersion)
            $complexWindowsRestriction.Add('PersonalDeviceEnrollmentBlocked', $config.AdditionalProperties.windowsRestriction.personalDeviceEnrollmentBlocked)
            $complexWindowsRestriction.Add('PlatformBlocked', $config.AdditionalProperties.windowsRestriction.platformBlocked)
            if ($complexWindowsRestriction.values.Where({$null -ne $_}).count -eq 0)
            {
                $complexWindowsRestriction = $null
            }

            $results.Add("AndroidForWorkRestriction", $complexAndroidForWorkRestriction)
            $results.Add("AndroidRestriction", $complexAndroidRestriction)
            $results.Add("IosRestriction", $complexIosRestriction)
            $results.Add("MacOSRestriction", $complexMacOSRestriction)
            $results.Add("MacRestriction", $complexMacRestriction)
            $results.Add("WindowsHomeSkuRestriction", $complexWindowsHomeSkuRestriction)
            $results.Add("WindowsMobileRestriction", $complexWindowsMobileRestriction)
            $results.Add("WindowsRestriction", $complexWindowsRestriction)
        }

        if ($null -ne $results.WindowsMobileRestriction)
        {
            $results.Remove('WindowsMobileRestriction') | Out-Null
        }

        $assignmentsValues = Get-MgBetaDeviceManagementDeviceEnrollmentConfigurationAssignment -DeviceEnrollmentConfigurationId $config.Id
        $assignmentResult = @()
        foreach ($assignmentEntry in $assignmentsValues)
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

        return $results
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
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateSet('singlePlatformRestriction', 'platformRestrictions')]
        [System.String]
        $DeviceEnrollmentConfigurationType,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $IosRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WindowsRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WindowsHomeSkuRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WindowsMobileRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AndroidRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AndroidForWorkRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MacRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MacOSRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $PlatformRestriction,

        [Parameter()]
        [ValidateSet('android', 'androidForWork', 'ios', 'mac', 'windows')]
        $PlatformType,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter()]
        [System.Int32]
        $Priority,

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

    if (-not [System.String]::IsNullOrEmpty($PlatformType) -and $null -eq $PlatformRestriction) {
        throw 'If PlatformType is specified, PlatformRestriction is required.'
    }

    if ([System.String]::IsNullOrEmpty($PlatformType) -and $null -ne $PlatformRestriction) {
        throw 'PlatformRestriction can only be set on policies with a PlatformType.'
    }

    if ($Ensure -eq 'Absent' -and $Identity -like '*_DefaultPlatformRestrictions') {
        throw 'Cannot delete the default platform restriction policy.'
    }

    $PriorityPresent = $false
    if ($PSBoundParameters.Keys.Contains('Priority'))
    {
        $PriorityPresent = $true
        $PSBoundParameters.Remove('Priority') | Out-Null
    }

    $currentInstance = Get-TargetResource @PSBoundParameters
    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    $BoundParameters.Remove('Identity') | Out-Null

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Device Enrollment Platform Restriction with DisplayName {$DisplayName}"

        $BoundParameters.Remove('Assignments') | Out-Null

        $CreateParameters = ([Hashtable]$BoundParameters).Clone()
        $CreateParameters = Rename-M365DSCCimInstanceParameter -Properties $CreateParameters
        $CreateParameters.Remove('Id') | Out-Null

        if ($BoundParameters.Keys.Contains('WindowsMobileRestriction'))
        {
            if ($WindowsMobileRestriction.platformBlocked -eq $false)
            {
                Write-Verbose -Message 'Windows Mobile platform is deprecated and cannot be unblocked, reverting back to blocked'
                $WindowsMobileRestriction.platformBlocked = $true
            }
        }

        $keys = (([Hashtable]$CreateParameters).Clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $CreateParameters.$key -and $CreateParameters.$key.GetType().Name -like '*cimInstance*')
            {
                $CreateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $CreateParameters.$key
            }
        }

        # Check if it is a "Default platform restriction"
        if ([System.String]::IsNullOrEmpty($PlatformType))
        {
            $CreateParameters.Add('@odata.type', '#microsoft.graph.deviceEnrollmentPlatformRestrictionsConfiguration')
        }
        else
        {
            $CreateParameters.Add('@odata.type', '#microsoft.graph.deviceEnrollmentPlatformRestrictionConfiguration')
        }
        
        $policy = New-MgBetaDeviceManagementDeviceEnrollmentConfiguration -BodyParameter $CreateParameters

        $assignmentsHash = @()
        foreach ($assignment in $Assignments)
        {
            $assignmentsHash += Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignment
        }

        # Skip for the default platform restriction
        if ($policy.Id -notlike '*_DefaultPlatformRestrictions')
        {
            if ($null -ne $Assignments -and $Assignments -ne @()) {
                $assignmentsHash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignments

                Update-DeviceConfigurationPolicyAssignment `
                -DeviceConfigurationPolicyId $policy.Id `
                -Targets $assignmentsHash `
                -Repository 'deviceManagement/deviceEnrollmentConfigurations' `
                -RootIdentifier 'enrollmentConfigurationAssignments'
            }
        }

        if ($PriorityPresent -and $Priority -ne $policy.Priority)
        {
            $Uri = "/beta/deviceManagement/deviceEnrollmentConfigurations/{0}/setPriority" -f $policy.Id
            $Body = @{
                priority = $Priority
            }
            Invoke-MgGraphRequest -Method POST -Uri $Uri -Body $($Body | ConvertTo-Json)
        }
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune Device Enrollment Platform Restriction with Id {$($currentInstance.Identity)}"
        $BoundParameters.Remove('Assignments') | Out-Null

        if ($BoundParameters.Keys.Contains('WindowsMobileRestriction'))
        {
            if ($WindowsMobileRestriction.platformBlocked -eq $false)
            {
                Write-Verbose -Message 'Windows Mobile platform is deprecated and cannot be unblocked, reverting back to blocked'
                $WindowsMobileRestriction.platformBlocked = $true
            }
        }

        $UpdateParameters = ([Hashtable]$BoundParameters).clone()
        $UpdateParameters = Rename-M365DSCCimInstanceParameter -Properties $UpdateParameters

        $UpdateParameters.Remove('Id') | Out-Null
        $UpdateParameters.Remove('Priority') | Out-Null

        $keys = (([Hashtable]$UpdateParameters).clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $UpdateParameters.$key -and $UpdateParameters.$key.getType().Name -like '*cimInstance*')
            {
                $UpdateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $UpdateParameters.$key
            }
        }

        # Check if it is a "Default platform restriction"
        if ($currentInstance.Identity -like "*_DefaultPlatformRestrictions")
        {
            $UpdateParameters.Add("@odata.type", "#microsoft.graph.deviceEnrollmentPlatformRestrictionsConfiguration")
        }
        else
        {
            $UpdateParameters.Add("@odata.type", "#microsoft.graph.deviceEnrollmentPlatformRestrictionConfiguration")
            $UpdateParameters.Remove("PlatformType")
        }

        Update-MgBetaDeviceManagementDeviceEnrollmentConfiguration `
            -DeviceEnrollmentConfigurationId $currentInstance.Identity `
            -BodyParameter $UpdateParameters

        # Skip for the default platform restriction
        if ($currentInstance.Identity -notlike "*_DefaultPlatformRestrictions")
        {
            if ($null -ne $Assignments -and $Assignments -ne @())
            {
                $assignmentsHash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignments

                Update-DeviceConfigurationPolicyAssignment `
                    -DeviceConfigurationPolicyId $currentInstance.Identity `
                    -Targets $assignmentsHash `
                    -Repository 'deviceManagement/deviceEnrollmentConfigurations' `
                    -RootIdentifier 'enrollmentConfigurationAssignments'
            }

            if ($PriorityPresent -and $Priority -ne $currentInstance.Priority)
            {
                $Uri = "/beta/deviceManagement/deviceEnrollmentConfigurations/{0}/setPriority" -f $currentInstance.Identity
                $Body = @{
                    priority = $Priority
                }
                Invoke-MgGraphRequest -Method POST -Uri $Uri -Body $($Body | ConvertTo-Json)
            }
        }
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune Device Enrollment Platform Restriction with Name {$DisplayName}"
        Remove-MgBetaDeviceManagementDeviceEnrollmentConfiguration -DeviceEnrollmentConfigurationId $currentInstance.Identity
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateSet('singlePlatformRestriction', 'platformRestrictions')]
        [System.String]
        $DeviceEnrollmentConfigurationType,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $IosRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WindowsRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WindowsHomeSkuRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WindowsMobileRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AndroidRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AndroidForWorkRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MacRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MacOSRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $PlatformRestriction,

        [Parameter()]
        [ValidateSet('android', 'androidForWork', 'ios', 'mac', 'windows')]
        $PlatformType,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter()]
        [System.Int32]
        $Priority,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    Write-Verbose -Message "Testing configuration of the Intune Device Enrollment Platform Restriction with Id {$Identity} and DisplayName {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).Clone()

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
        if ($source.getType().Name -like '*CimInstance*' -and $key -ne 'WindowsMobileRestriction')
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

    $ValuesToCheck = Remove-M365DSCAuthenticationParameter -BoundParameters $ValuesToCheck
    $ValuesToCheck.Remove('Identity') | Out-Null
    $ValuesToCheck.Remove('WindowsMobileRestriction') | Out-Null

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"
    #Compare basic parameters
    if ($testResult)
    {
        $testResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
            -Source $($MyInvocation.MyCommand.Source) `
            -DesiredValues $PSBoundParameters `
            -ValuesToCheck $ValuesToCheck.Keys
    }

    Write-Verbose -Message "Test-TargetResource returned $testResult"

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
        $ManagedIdentity
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
        [array]$configs = Get-MgBetaDeviceManagementDeviceEnrollmentConfiguration `
            -All `
            -Filter "deviceEnrollmentConfigurationType eq 'singlePlatformRestriction'" `
            -ErrorAction Stop

        $i = 1
        $dscContent = ''
        if ($configs.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($config in $configs)
        {
            Write-Host "    |---[$i/$($configs.Count)] $($config.displayName)" -NoNewline
            $params = @{
                Identity              = $config.id
                DisplayName           = $config.displayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
            }
            
            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results

            if ($null -ne $Results.Assignments)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject ([Array]$Results.Assignments) -CIMInstanceName DeviceManagementConfigurationPolicyAssignments
                if ($complexTypeStringResult)
                {
                    $Results.Assignments = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('Assignments') | Out-Null
                }
            }

            if ($null -ne $Results.IosRestriction)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject ($Results.IosRestriction) -CIMInstanceName DeviceEnrollmentPlatformRestriction
                if ($complexTypeStringResult)
                {
                    $Results.IosRestriction = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('IosRestriction') | Out-Null
                }
            }

            if ($null -ne $Results.WindowsRestriction)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject ($Results.WindowsRestriction) -CIMInstanceName DeviceEnrollmentPlatformRestriction
                if ($complexTypeStringResult)
                {
                    $Results.WindowsRestriction = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('WindowsRestriction') | Out-Null
                }
            }

            if ($null -ne $Results.WindowsHomeSkuRestriction)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject ($Results.WindowsHomeSkuRestriction) -CIMInstanceName DeviceEnrollmentPlatformRestriction
                if ($complexTypeStringResult)
                {
                    $Results.WindowsHomeSkuRestriction = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('WindowsHomeSkuRestriction') | Out-Null
                }
            }
            if ($null -ne $Results.WindowsMobileRestriction)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject ($Results.WindowsMobileRestriction) -CIMInstanceName DeviceEnrollmentPlatformRestriction
                if ($complexTypeStringResult)
                {
                    $Results.WindowsMobileRestriction = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('WindowsMobileRestriction') | Out-Null
                }
            }

            if ($null -ne $Results.AndroidRestriction)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject ($Results.AndroidRestriction) -CIMInstanceName DeviceEnrollmentPlatformRestriction
                if ($complexTypeStringResult)
                {
                    $Results.AndroidRestriction = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('AndroidRestriction') | Out-Null
                }
            }

            if ($null -ne $Results.AndroidForWorkRestriction)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject ($Results.AndroidForWorkRestriction) -CIMInstanceName DeviceEnrollmentPlatformRestriction
                if ($complexTypeStringResult)
                {
                    $Results.AndroidForWorkRestriction = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('AndroidForWorkRestriction') | Out-Null
                }
            }

            if ($null -ne $Results.MacRestriction)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject ($Results.MacRestriction) -CIMInstanceName DeviceEnrollmentPlatformRestriction
                if ($complexTypeStringResult)
                {
                    $Results.MacRestriction = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('MacRestriction') | Out-Null
                }
            }

            if ($null -ne $Results.MacOSRestriction)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject ($Results.MacOSRestriction) -CIMInstanceName DeviceEnrollmentPlatformRestriction
                if ($complexTypeStringResult)
                {
                    $Results.MacOSRestriction = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('MacOSRestriction') | Out-Null
                }
            }

            if ($null -ne $Results.PlatformRestriction)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject ($Results.PlatformRestriction) -CIMInstanceName DeviceEnrollmentPlatformRestriction
                if ($complexTypeStringResult)
                {
                    $Results.PlatformRestriction = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('PlatformRestriction') | Out-Null
                }
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential

            if ($null -ne $Results.Assignments)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'Assignments' -IsCIMArray:$true
            }

            if ($null -ne $Results.IosRestriction)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'IosRestriction'
            }

            if ($null -ne $Results.WindowsRestriction)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'WindowsRestriction'
            }

            if ($null -ne $Results.WindowsHomeSkuRestriction)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'WindowsHomeSkuRestriction'
            }

            if ($null -ne $Results.WindowsMobileRestriction)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'WindowsMobileRestriction'
            }

            if ($null -ne $Results.AndroidRestriction)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'AndroidRestriction'
            }

            if ($null -ne $Results.AndroidForWorkRestriction)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'AndroidForWorkRestriction'
            }

            if ($null -ne $Results.MacRestriction)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'MacRestriction'
            }

            if ($null -ne $Results.MacOSRestriction)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'MacOSRestriction'
            }

            if ($null -ne $Results.PlatformRestriction)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'PlatformRestriction'
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
