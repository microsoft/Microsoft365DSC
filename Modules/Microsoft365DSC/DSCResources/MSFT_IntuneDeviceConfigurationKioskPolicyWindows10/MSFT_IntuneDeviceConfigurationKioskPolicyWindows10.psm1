function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.Boolean]
        $EdgeKioskEnablePublicBrowsing,

        [Parameter()]
        [System.String[]]
        $KioskBrowserBlockedUrlExceptions,

        [Parameter()]
        [System.String[]]
        $KioskBrowserBlockedURLs,

        [Parameter()]
        [System.String]
        $KioskBrowserDefaultUrl,

        [Parameter()]
        [System.Boolean]
        $KioskBrowserEnableEndSessionButton,

        [Parameter()]
        [System.Boolean]
        $KioskBrowserEnableHomeButton,

        [Parameter()]
        [System.Boolean]
        $KioskBrowserEnableNavigationButtons,

        [Parameter()]
        [System.Int32]
        $KioskBrowserRestartOnIdleTimeInMinutes,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $KioskProfiles,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WindowsKioskForceUpdateSchedule,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter(Mandatory = $true)]
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
            -InboundParameters $PSBoundParameters `
            -ProfileName 'beta'

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
        $getValue = Get-MgDeviceManagementDeviceConfiguration -DeviceConfigurationId $Id  -ErrorAction SilentlyContinue

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Intune Device Configuration Kiosk Policy for Windows10 with Id {$Id}"

            if (-Not [string]::IsNullOrEmpty($DisplayName))
            {
                $getValue = Get-MgDeviceManagementDeviceConfiguration `
                    -Filter "DisplayName eq '$DisplayName'" `
                    -ErrorAction SilentlyContinue | Where-Object `
                    -FilterScript { `
                        $_.AdditionalProperties.'@odata.type' -eq "#microsoft.graph.windowsKioskConfiguration" `
                    }
            }
        }
        #endregion
        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Intune Device Configuration Kiosk Policy for Windows10 with DisplayName {$DisplayName}"
            return $nullResult
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Device Configuration Kiosk Policy for Windows10 with Id {$Id} and DisplayName {$DisplayName} was found."

        #region resource generator code
        $complexKioskProfiles = @()
        foreach ($currentkioskProfiles in $getValue.AdditionalProperties.kioskProfiles)
        {
            $mykioskProfiles = @{}
            $complexAppConfiguration = @{}
            $complexAppConfiguration.Add('AllowAccessToDownloadsFolder', $currentkioskProfiles.appConfiguration.allowAccessToDownloadsFolder)
            $complexApps = @()
            foreach ($currentApps in $currentkioskProfiles.appConfiguration.apps)
            {
                $myApps = @{}
                if ($null -ne $currentApps.appType)
                {
                    $myApps.Add('AppType', $currentApps.appType.toString())
                }
                $myApps.Add('AutoLaunch', $currentApps.autoLaunch)
                $myApps.Add('Name', $currentApps.name)
                if ($null -ne $currentApps.startLayoutTileSize)
                {
                    $myApps.Add('StartLayoutTileSize', $currentApps.startLayoutTileSize.toString())
                }
                $myApps.Add('DesktopApplicationId', $currentApps.desktopApplicationId)
                $myApps.Add('DesktopApplicationLinkPath', $currentApps.desktopApplicationLinkPath)
                $myApps.Add('Path', $currentApps.path)
                $myApps.Add('AppId', $currentApps.appId)
                $myApps.Add('AppUserModelId', $currentApps.appUserModelId)
                $myApps.Add('ContainedAppId', $currentApps.containedAppId)
                $myApps.Add('ClassicAppPath', $currentApps.classicAppPath)
                $myApps.Add('EdgeKiosk', $currentApps.edgeKiosk)
                $myApps.Add('EdgeKioskIdleTimeoutMinutes', $currentApps.edgeKioskIdleTimeoutMinutes)
                if ($null -ne $currentApps.edgeKioskType)
                {
                    $myApps.Add('EdgeKioskType', $currentApps.edgeKioskType.toString())
                }
                $myApps.Add('EdgeNoFirstRun', $currentApps.edgeNoFirstRun)
                if ($null -ne $currentApps.'@odata.type')
                {
                    $myApps.Add('odataType', $currentApps.'@odata.type'.toString())
                }
                if ($myApps.values.Where({$null -ne $_}).count -gt 0)
                {
                    $complexApps += $myApps
                }
            }
            $complexAppConfiguration.Add('Apps',$complexApps)
            $complexAppConfiguration.Add('DisallowDesktopApps', $currentkioskProfiles.appConfiguration.disallowDesktopApps)
            $complexAppConfiguration.Add('ShowTaskBar', $currentkioskProfiles.appConfiguration.showTaskBar)
            $complexAppConfiguration.Add('StartMenuLayoutXml', $currentkioskProfiles.appConfiguration.startMenuLayoutXml)
            $complexUwpApp = @{}
            $complexUwpApp.Add('AppId', $currentkioskProfiles.appConfiguration.uwpApp.appId)
            $complexUwpApp.Add('AppUserModelId', $currentkioskProfiles.appConfiguration.uwpApp.appUserModelId)
            $complexUwpApp.Add('ContainedAppId', $currentkioskProfiles.appConfiguration.uwpApp.containedAppId)
            if ($null -ne $currentkioskProfiles.appConfiguration.uwpApp.appType)
            {
                $complexUwpApp.Add('AppType', $currentkioskProfiles.appConfiguration.uwpApp.appType.toString())
            }
            $complexUwpApp.Add('AutoLaunch', $currentkioskProfiles.appConfiguration.uwpApp.autoLaunch)
            $complexUwpApp.Add('Name', $currentkioskProfiles.appConfiguration.uwpApp.name)
            if ($null -ne $currentkioskProfiles.appConfiguration.uwpApp.startLayoutTileSize)
            {
                $complexUwpApp.Add('StartLayoutTileSize', $currentkioskProfiles.appConfiguration.uwpApp.startLayoutTileSize.toString())
            }
            $complexUwpApp.Add('DesktopApplicationId', $currentkioskProfiles.appConfiguration.uwpApp.desktopApplicationId)
            $complexUwpApp.Add('DesktopApplicationLinkPath', $currentkioskProfiles.appConfiguration.uwpApp.desktopApplicationLinkPath)
            $complexUwpApp.Add('Path', $currentkioskProfiles.appConfiguration.uwpApp.path)
            $complexUwpApp.Add('ClassicAppPath', $currentkioskProfiles.appConfiguration.uwpApp.classicAppPath)
            $complexUwpApp.Add('EdgeKiosk', $currentkioskProfiles.appConfiguration.uwpApp.edgeKiosk)
            $complexUwpApp.Add('EdgeKioskIdleTimeoutMinutes', $currentkioskProfiles.appConfiguration.uwpApp.edgeKioskIdleTimeoutMinutes)
            if ($null -ne $currentkioskProfiles.appConfiguration.uwpApp.edgeKioskType)
            {
                $complexUwpApp.Add('EdgeKioskType', $currentkioskProfiles.appConfiguration.uwpApp.edgeKioskType.toString())
            }
            $complexUwpApp.Add('EdgeNoFirstRun', $currentkioskProfiles.appConfiguration.uwpApp.edgeNoFirstRun)
            if ($null -ne $currentkioskProfiles.appConfiguration.uwpApp.'@odata.type')
            {
                $complexUwpApp.Add('odataType', $currentkioskProfiles.appConfiguration.uwpApp.'@odata.type'.toString())
            }
            if ($complexUwpApp.values.Where({$null -ne $_}).count -eq 0)
            {
                $complexUwpApp = $null
            }
            $complexAppConfiguration.Add('UwpApp',$complexUwpApp)
            $complexWin32App = @{}
            $complexWin32App.Add('ClassicAppPath', $currentkioskProfiles.appConfiguration.win32App.classicAppPath)
            $complexWin32App.Add('EdgeKiosk', $currentkioskProfiles.appConfiguration.win32App.edgeKiosk)
            $complexWin32App.Add('EdgeKioskIdleTimeoutMinutes', $currentkioskProfiles.appConfiguration.win32App.edgeKioskIdleTimeoutMinutes)
            if ($null -ne $currentkioskProfiles.appConfiguration.win32App.edgeKioskType)
            {
                $complexWin32App.Add('EdgeKioskType', $currentkioskProfiles.appConfiguration.win32App.edgeKioskType.toString())
            }
            $complexWin32App.Add('EdgeNoFirstRun', $currentkioskProfiles.appConfiguration.win32App.edgeNoFirstRun)
            if ($null -ne $currentkioskProfiles.appConfiguration.win32App.appType)
            {
                $complexWin32App.Add('AppType', $currentkioskProfiles.appConfiguration.win32App.appType.toString())
            }
            $complexWin32App.Add('AutoLaunch', $currentkioskProfiles.appConfiguration.win32App.autoLaunch)
            $complexWin32App.Add('Name', $currentkioskProfiles.appConfiguration.win32App.name)
            if ($null -ne $currentkioskProfiles.appConfiguration.win32App.startLayoutTileSize)
            {
                $complexWin32App.Add('StartLayoutTileSize', $currentkioskProfiles.appConfiguration.win32App.startLayoutTileSize.toString())
            }
            $complexWin32App.Add('DesktopApplicationId', $currentkioskProfiles.appConfiguration.win32App.desktopApplicationId)
            $complexWin32App.Add('DesktopApplicationLinkPath', $currentkioskProfiles.appConfiguration.win32App.desktopApplicationLinkPath)
            $complexWin32App.Add('Path', $currentkioskProfiles.appConfiguration.win32App.path)
            $complexWin32App.Add('AppId', $currentkioskProfiles.appConfiguration.win32App.appId)
            $complexWin32App.Add('AppUserModelId', $currentkioskProfiles.appConfiguration.win32App.appUserModelId)
            $complexWin32App.Add('ContainedAppId', $currentkioskProfiles.appConfiguration.win32App.containedAppId)
            if ($null -ne $currentkioskProfiles.appConfiguration.win32App.'@odata.type')
            {
                $complexWin32App.Add('odataType', $currentkioskProfiles.appConfiguration.win32App.'@odata.type'.toString())
            }
            if ($complexWin32App.values.Where({$null -ne $_}).count -eq 0)
            {
                $complexWin32App = $null
            }
            $complexAppConfiguration.Add('Win32App',$complexWin32App)
            if ($null -ne $currentkioskProfiles.appConfiguration.'@odata.type')
            {
                $complexAppConfiguration.Add('odataType', $currentkioskProfiles.appConfiguration.'@odata.type'.toString())
            }
            if ($complexAppConfiguration.values.Where({$null -ne $_}).count -eq 0)
            {
                $complexAppConfiguration = $null
            }
            $mykioskProfiles.Add('AppConfiguration',$complexAppConfiguration)
            $mykioskProfiles.Add('ProfileId', $currentkioskProfiles.profileId)
            $mykioskProfiles.Add('ProfileName', $currentkioskProfiles.profileName)
            $complexUserAccountsConfiguration = @()
            foreach ($currentUserAccountsConfiguration in $currentkioskProfiles.userAccountsConfiguration)
            {
                $myUserAccountsConfiguration = @{}
                $myUserAccountsConfiguration.Add('GroupName', $currentUserAccountsConfiguration.groupName)
                $myUserAccountsConfiguration.Add('DisplayName', $currentUserAccountsConfiguration.displayName)
                $myUserAccountsConfiguration.Add('GroupId', $currentUserAccountsConfiguration.groupId)
                $myUserAccountsConfiguration.Add('UserId', $currentUserAccountsConfiguration.userId)
                $myUserAccountsConfiguration.Add('UserPrincipalName', $currentUserAccountsConfiguration.userPrincipalName)
                $myUserAccountsConfiguration.Add('UserName', $currentUserAccountsConfiguration.userName)
                if ($null -ne $currentUserAccountsConfiguration.'@odata.type')
                {
                    $myUserAccountsConfiguration.Add('odataType', $currentUserAccountsConfiguration.'@odata.type'.toString())
                }
                if ($myUserAccountsConfiguration.values.Where({$null -ne $_}).count -gt 0)
                {
                    $complexUserAccountsConfiguration += $myUserAccountsConfiguration
                }
            }
            $mykioskProfiles.Add('UserAccountsConfiguration',$complexUserAccountsConfiguration)
            if ($mykioskProfiles.values.Where({$null -ne $_}).count -gt 0)
            {
                $complexKioskProfiles += $mykioskProfiles
            }
        }

        $complexWindowsKioskForceUpdateSchedule = @{}
        $complexWindowsKioskForceUpdateSchedule.Add('DayofMonth', $getValue.AdditionalProperties.windowsKioskForceUpdateSchedule.dayofMonth)
        if ($null -ne $getValue.AdditionalProperties.windowsKioskForceUpdateSchedule.dayofWeek)
        {
            $complexWindowsKioskForceUpdateSchedule.Add('DayofWeek', $getValue.AdditionalProperties.windowsKioskForceUpdateSchedule.dayofWeek.toString())
        }
        if ($null -ne $getValue.AdditionalProperties.windowsKioskForceUpdateSchedule.recurrence)
        {
            $complexWindowsKioskForceUpdateSchedule.Add('Recurrence', $getValue.AdditionalProperties.windowsKioskForceUpdateSchedule.recurrence.toString())
        }
        $complexWindowsKioskForceUpdateSchedule.Add('RunImmediatelyIfAfterStartDateTime', $getValue.AdditionalProperties.windowsKioskForceUpdateSchedule.runImmediatelyIfAfterStartDateTime)
        if ($null -ne $getValue.AdditionalProperties.windowsKioskForceUpdateSchedule.startDateTime)
        {
            $complexWindowsKioskForceUpdateSchedule.Add('StartDateTime', ([DateTimeOffset]$getValue.AdditionalProperties.windowsKioskForceUpdateSchedule.startDateTime).ToString('o'))
        }
        if ($complexWindowsKioskForceUpdateSchedule.values.Where({$null -ne $_}).count -eq 0)
        {
            $complexWindowsKioskForceUpdateSchedule = $null
        }
        #endregion

        $results = @{
            #region resource generator code
            EdgeKioskEnablePublicBrowsing          = $getValue.AdditionalProperties.edgeKioskEnablePublicBrowsing
            KioskBrowserBlockedUrlExceptions       = $getValue.AdditionalProperties.kioskBrowserBlockedUrlExceptions
            KioskBrowserBlockedURLs                = $getValue.AdditionalProperties.kioskBrowserBlockedURLs
            KioskBrowserDefaultUrl                 = $getValue.AdditionalProperties.kioskBrowserDefaultUrl
            KioskBrowserEnableEndSessionButton     = $getValue.AdditionalProperties.kioskBrowserEnableEndSessionButton
            KioskBrowserEnableHomeButton           = $getValue.AdditionalProperties.kioskBrowserEnableHomeButton
            KioskBrowserEnableNavigationButtons    = $getValue.AdditionalProperties.kioskBrowserEnableNavigationButtons
            KioskBrowserRestartOnIdleTimeInMinutes = $getValue.AdditionalProperties.kioskBrowserRestartOnIdleTimeInMinutes
            KioskProfiles                          = $complexKioskProfiles
            WindowsKioskForceUpdateSchedule        = $complexWindowsKioskForceUpdateSchedule
            Description                            = $getValue.Description
            DisplayName                            = $getValue.DisplayName
            Id                                     = $getValue.Id
            Ensure                                 = 'Present'
            Credential                             = $Credential
            ApplicationId                          = $ApplicationId
            TenantId                               = $TenantId
            ApplicationSecret                      = $ApplicationSecret
            CertificateThumbprint                  = $CertificateThumbprint
            Managedidentity                        = $ManagedIdentity.IsPresent
            #endregion
        }
        $assignmentsValues = Get-MgDeviceManagementDeviceConfigurationAssignment -DeviceConfigurationId $Id
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
        [System.Boolean]
        $EdgeKioskEnablePublicBrowsing,

        [Parameter()]
        [System.String[]]
        $KioskBrowserBlockedUrlExceptions,

        [Parameter()]
        [System.String[]]
        $KioskBrowserBlockedURLs,

        [Parameter()]
        [System.String]
        $KioskBrowserDefaultUrl,

        [Parameter()]
        [System.Boolean]
        $KioskBrowserEnableEndSessionButton,

        [Parameter()]
        [System.Boolean]
        $KioskBrowserEnableHomeButton,

        [Parameter()]
        [System.Boolean]
        $KioskBrowserEnableNavigationButtons,

        [Parameter()]
        [System.Int32]
        $KioskBrowserRestartOnIdleTimeInMinutes,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $KioskProfiles,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WindowsKioskForceUpdateSchedule,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter(Mandatory = $true)]
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
        Write-Verbose -Message "Creating an Intune Device Configuration Kiosk Policy for Windows10 with DisplayName {$DisplayName}"
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
        $CreateParameters.Add("@odata.type", "#microsoft.graph.windowsKioskConfiguration")
        $policy = New-MgDeviceManagementDeviceConfiguration -BodyParameter $CreateParameters
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
        Write-Verbose -Message "Updating the Intune Device Configuration Kiosk Policy for Windows10 with Id {$($currentInstance.Id)}"
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
        $UpdateParameters.Add("@odata.type", "#microsoft.graph.windowsKioskConfiguration")
        Update-MgDeviceManagementDeviceConfiguration  `
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
        Write-Verbose -Message "Removing the Intune Device Configuration Kiosk Policy for Windows10 with Id {$($currentInstance.Id)}"
        #region resource generator code
Remove-MgDeviceManagementDeviceConfiguration -DeviceConfigurationId $currentInstance.Id
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
        [System.Boolean]
        $EdgeKioskEnablePublicBrowsing,

        [Parameter()]
        [System.String[]]
        $KioskBrowserBlockedUrlExceptions,

        [Parameter()]
        [System.String[]]
        $KioskBrowserBlockedURLs,

        [Parameter()]
        [System.String]
        $KioskBrowserDefaultUrl,

        [Parameter()]
        [System.Boolean]
        $KioskBrowserEnableEndSessionButton,

        [Parameter()]
        [System.Boolean]
        $KioskBrowserEnableHomeButton,

        [Parameter()]
        [System.Boolean]
        $KioskBrowserEnableNavigationButtons,

        [Parameter()]
        [System.Int32]
        $KioskBrowserRestartOnIdleTimeInMinutes,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $KioskProfiles,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WindowsKioskForceUpdateSchedule,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter(Mandatory = $true)]
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

    Write-Verbose -Message "Testing configuration of the Intune Device Configuration Kiosk Policy for Windows10 with Id {$Id} and DisplayName {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()

    if ($CurrentValues.Ensure -ne $PSBoundParameters.Ensure)
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
        -InboundParameters $PSBoundParameters `
        -ProfileName 'beta'

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
        [array]$getValue = Get-MgDeviceManagementDeviceConfiguration `
            -All `
            -ErrorAction Stop | Where-Object `
            -FilterScript { `
                $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.windowsKioskConfiguration' `
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
            if ($null -ne $Results.KioskProfiles)
            {
                $complexMapping = @(
                    @{
                        Name = 'KioskProfiles'
                        CimInstanceName = 'MicrosoftGraphWindowsKioskProfile'
                        IsRequired = $False
                    }
                    @{
                        Name = 'AppConfiguration'
                        CimInstanceName = 'MicrosoftGraphWindowsKioskAppConfiguration'
                        IsRequired = $False
                    }
                    @{
                        Name = 'Apps'
                        CimInstanceName = 'MicrosoftGraphWindowsKioskAppBase'
                        IsRequired = $False
                    }
                    @{
                        Name = 'UwpApp'
                        CimInstanceName = 'MicrosoftGraphWindowsKioskUWPApp'
                        IsRequired = $False
                    }
                    @{
                        Name = 'Win32App'
                        CimInstanceName = 'MicrosoftGraphWindowsKioskWin32App'
                        IsRequired = $False
                    }
                    @{
                        Name = 'UserAccountsConfiguration'
                        CimInstanceName = 'MicrosoftGraphWindowsKioskUser'
                        IsRequired = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.KioskProfiles `
                    -CIMInstanceName 'MicrosoftGraphwindowsKioskProfile' `
                    -ComplexTypeMapping $complexMapping

                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.KioskProfiles = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('KioskProfiles') | Out-Null
                }
            }
            if ($null -ne $Results.WindowsKioskForceUpdateSchedule)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.WindowsKioskForceUpdateSchedule `
                    -CIMInstanceName 'MicrosoftGraphwindowsKioskForceUpdateSchedule'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.WindowsKioskForceUpdateSchedule = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('WindowsKioskForceUpdateSchedule') | Out-Null
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
            if ($Results.KioskProfiles)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "KioskProfiles" -isCIMArray:$True
            }
            if ($Results.WindowsKioskForceUpdateSchedule)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "WindowsKioskForceUpdateSchedule" -isCIMArray:$False
            }
            if ($Results.Assignments)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "Assignments" -isCIMArray:$true
            }
            #removing trailing commas and semi colons between items of an array of cim instances added by Convert-DSCStringParamToVariable
            $currentDSCBlock = $currentDSCBlock.replace("    ,`r`n" , "    `r`n")
            $currentDSCBlock = $currentDSCBlock.replace("`r`n;`r`n" , "`r`n")
            $currentDSCBlock = $currentDSCBlock.replace("`r`n,`r`n" , "`r`n")
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
        if ($_.Exception -like '*401*' -or $_.ErrorDetails.Message -like "*`"ErrorCode`":`"Forbidden`"*")
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

function Update-DeviceConfigurationPolicyAssignment
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [Parameter(Mandatory = 'true')]
        [System.String]
        $DeviceConfigurationPolicyId,

        [Parameter()]
        [Array]
        $Targets,

        [Parameter()]
        [System.String]
        $Repository = 'deviceManagement/configurationPolicies',

        [Parameter()]
        [ValidateSet('v1.0','beta')]
        [System.String]
        $APIVersion = 'beta'
    )
    try
    {
        $deviceManagementPolicyAssignments = @()
        $Uri = "https://graph.microsoft.com/$APIVersion/$Repository/$DeviceConfigurationPolicyId/assign"

        foreach ($target in $targets)
        {
            $formattedTarget = @{"@odata.type" = $target.dataType}
            if ($target.groupId)
            {
                $formattedTarget.Add('groupId',$target.groupId)
            }
            if ($target.collectionId)
            {
                $formattedTarget.Add('collectionId',$target.collectionId)
            }
            if ($target.deviceAndAppManagementAssignmentFilterType)
            {
                $formattedTarget.Add('deviceAndAppManagementAssignmentFilterType',$target.deviceAndAppManagementAssignmentFilterType)
            }
            if ($target.deviceAndAppManagementAssignmentFilterId)
            {
                $formattedTarget.Add('deviceAndAppManagementAssignmentFilterId',$target.deviceAndAppManagementAssignmentFilterId)
            }
            $deviceManagementPolicyAssignments += @{'target' = $formattedTarget}
        }
        $body = @{'assignments' = $deviceManagementPolicyAssignments} | ConvertTo-Json -Depth 20
        #write-verbose -Message $body
        Invoke-MgGraphRequest -Method POST -Uri $Uri -Body $body -ErrorAction Stop
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error updating data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $null
    }
}
function Rename-M365DSCCimInstanceParameter
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable], [System.Collections.Hashtable[]])]
    param(
        [Parameter(Mandatory = 'true')]
        $Properties
    )

    $keyToRename = @{
        'odataType' = '@odata.type'
    }

    $result = $Properties

    $type = $Properties.getType().FullName

    #region Array
    if ($type -like '*[[\]]')
    {
        $values = @()
        foreach ($item in $Properties)
        {
            $values += Rename-M365DSCCimInstanceParameter $item
        }
        $result = $values

        return , $result
    }
    #endregion

    #region Single
    if ($type -like '*Hashtable')
    {
        $result = ([Hashtable]$Properties).clone()
    }
    if ($type -like '*CimInstance*' -or $type -like '*Hashtable*' -or $type -like '*Object*')
    {
        $hashProperties = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $result
        $keys = ($hashProperties.clone()).keys
        foreach ($key in $keys)
        {
            $keyName = $key.substring(0, 1).tolower() + $key.substring(1, $key.length - 1)
            if ($key -in $keyToRename.Keys)
            {
                $keyName = $keyToRename.$key
            }

            $property = $hashProperties.$key
            if ($null -ne $property)
            {
                $hashProperties.Remove($key)
                $hashProperties.add($keyName, (Rename-M365DSCCimInstanceParameter $property))
            }
        }
        $result = $hashProperties
    }
    return $result
    #endregion
}

function Get-M365DSCDRGComplexTypeToHashtable
{
    [CmdletBinding()]
    [OutputType([hashtable], [hashtable[]])]
    param(
        [Parameter()]
        $ComplexObject
    )

    if ($null -eq $ComplexObject)
    {
        return $null
    }

    if ($ComplexObject.gettype().fullname -like '*[[\]]')
    {
        $results = @()

        foreach ($item in $ComplexObject)
        {
            if ($item)
            {
                $hash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
                $results += $hash
            }
        }

        # PowerShell returns all non-captured stream output, not just the argument of the return statement.
        #An empty array is mangled into $null in the process.
        #However, an array can be preserved on return by prepending it with the array construction operator (,)
        return , [hashtable[]]$results
    }

    if ($ComplexObject.getType().fullname -like '*Dictionary*')
    {
        $results = @{}

        $ComplexObject = [hashtable]::new($ComplexObject)
        $keys = $ComplexObject.Keys
        foreach ($key in $keys)
        {
            if ($null -ne $ComplexObject.$key)
            {
                $keyName = $key

                $keyType = $ComplexObject.$key.gettype().fullname

                if ($keyType -like '*CimInstance*' -or $keyType -like '*Dictionary*' -or $keyType -like 'Microsoft.Graph.PowerShell.Models.*' -or $keyType -like '*[[\]]')
                {
                    $hash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject.$key

                    $results.Add($keyName, $hash)
                }
                else
                {
                    $results.Add($keyName, $ComplexObject.$key)
                }
            }
        }
        return [hashtable]$results
    }

    $results = @{}

    if ($ComplexObject.getType().Fullname -like '*hashtable')
    {
        $keys = $ComplexObject.keys
    }
    else
    {
        $keys = $ComplexObject | Get-Member | Where-Object -FilterScript { $_.MemberType -eq 'Property' }
    }

    foreach ($key in $keys)
    {
        $keyName = $key
        if ($ComplexObject.getType().Fullname -notlike '*hashtable')
        {
            $keyName = $key.Name
        }

        if ($null -ne $ComplexObject.$keyName)
        {
            $keyType = $ComplexObject.$keyName.gettype().fullname
            if ($keyType -like '*CimInstance*' -or $keyType -like '*Dictionary*' -or $keyType -like 'Microsoft.Graph.PowerShell.Models.*')
            {
                $hash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject.$keyName

                $results.Add($keyName, $hash)
            }
            else
            {
                $results.Add($keyName, $ComplexObject.$keyName)
            }
        }
    }
    return [hashtable]$results
}

<#
    Use ComplexTypeMapping to overwrite the type of nested CIM
    Example
    $complexMapping=@(
                    @{
                        Name="ApprovalStages"
                        CimInstanceName="MSFT_MicrosoftGraphapprovalstage1"
                        IsRequired=$false
                    }
                    @{
                        Name="PrimaryApprovers"
                        CimInstanceName="MicrosoftGraphuserset"
                        IsRequired=$false
                    }
                    @{
                        Name="EscalationApprovers"
                        CimInstanceName="MicrosoftGraphuserset"
                        IsRequired=$false
                    }
                )
    With
    Name: the name of the parameter to be overwritten
    CimInstanceName: The type of the CIM instance (can include or not the prefix MSFT_)
    IsRequired: If isRequired equals true, an empty hashtable or array will be returned. Some of the Graph parameters are required even though they are empty
#>
function Get-M365DSCDRGComplexTypeToString
{
    [CmdletBinding()]
    param(
        [Parameter()]
        $ComplexObject,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CIMInstanceName,

        [Parameter()]
        [Array]
        $ComplexTypeMapping,

        [Parameter()]
        [System.String]
        $Whitespace = '',

        [Parameter()]
        [System.uint32]
        $IndentLevel = 3,

        [Parameter()]
        [switch]
        $isArray = $false
    )

    if ($null -eq $ComplexObject)
    {
        return $null
    }

    $indent = ''
    for ($i = 0; $i -lt $IndentLevel ; $i++)
    {
        $indent += '    '
    }
    #If ComplexObject  is an Array
    if ($ComplexObject.GetType().FullName -like '*[[\]]')
    {
        $currentProperty = @()
        $IndentLevel++
        foreach ($item in $ComplexObject)
        {
            $splat = @{
                'ComplexObject'   = $item
                'CIMInstanceName' = $CIMInstanceName
                'IndentLevel'     = $IndentLevel
            }
            if ($ComplexTypeMapping)
            {
                $splat.add('ComplexTypeMapping', $ComplexTypeMapping)
            }

            $currentProperty += Get-M365DSCDRGComplexTypeToString -isArray:$true @splat
        }

        # PowerShell returns all non-captured stream output, not just the argument of the return statement.
        #An empty array is mangled into $null in the process.
        #However, an array can be preserved on return by prepending it with the array construction operator (,)
        return , $currentProperty
    }

    $currentProperty = ''
    if ($isArray)
    {
        $currentProperty += "`r`n"
        $currentProperty += $indent
    }

    $CIMInstanceName = $CIMInstanceName.replace('MSFT_', '')
    $currentProperty += "MSFT_$CIMInstanceName{`r`n"
    $IndentLevel++
    $indent = ''
    for ($i = 0; $i -lt $IndentLevel ; $i++)
    {
        $indent += '    '
    }
    $keyNotNull = 0

    if ($ComplexObject.Keys.count -eq 0)
    {
        return $null
    }

    foreach ($key in $ComplexObject.Keys)
    {
        if ($null -ne $ComplexObject.$key)
        {
            $keyNotNull++
            if ($ComplexObject.$key.GetType().FullName -like 'Microsoft.Graph.PowerShell.Models.*' -or $key -in $ComplexTypeMapping.Name)
            {
                $hashPropertyType = $ComplexObject[$key].GetType().Name.tolower()

                $isArray = $false
                if ($ComplexObject[$key].GetType().FullName -like '*[[\]]')
                {
                    $isArray = $true
                }
                #overwrite type if object defined in mapping complextypemapping
                if ($key -in $ComplexTypeMapping.Name)
                {
                    $hashPropertyType = ([Array]($ComplexTypeMapping | Where-Object -FilterScript { $_.Name -eq $key }).CimInstanceName)[0]
                    $hashProperty = $ComplexObject[$key]
                }
                else
                {
                    $hashProperty = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject[$key]
                }

                if (-not $isArray)
                {
                    $currentProperty += $indent + $key + ' = '
                }

                if ($isArray -and $key -in $ComplexTypeMapping.Name)
                {
                    if ($ComplexObject.$key.count -gt 0)
                    {
                        $currentProperty += $indent + $key + ' = '
                        $currentProperty += '@('
                    }
                }

                if ($isArray)
                {
                    $IndentLevel++
                    foreach ($item in $ComplexObject[$key])
                    {
                        if ($ComplexObject.$key.GetType().FullName -like 'Microsoft.Graph.PowerShell.Models.*')
                        {
                            $item = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
                        }
                        $nestedPropertyString = Get-M365DSCDRGComplexTypeToString `
                            -ComplexObject $item `
                            -CIMInstanceName $hashPropertyType `
                            -IndentLevel $IndentLevel `
                            -ComplexTypeMapping $ComplexTypeMapping `
                            -IsArray:$true
                        if ([string]::IsNullOrWhiteSpace($nestedPropertyString))
                        {
                            $nestedPropertyString = "@()`r`n"
                        }
                        $currentProperty += $nestedPropertyString
                    }
                    $IndentLevel--
                }
                else
                {
                    $nestedPropertyString = Get-M365DSCDRGComplexTypeToString `
                        -ComplexObject $hashProperty `
                        -CIMInstanceName $hashPropertyType `
                        -IndentLevel $IndentLevel `
                        -ComplexTypeMapping $ComplexTypeMapping
                    if ([string]::IsNullOrWhiteSpace($nestedPropertyString))
                    {
                        $nestedPropertyString = "`$null`r`n"
                    }
                    $currentProperty += $nestedPropertyString
                }
                if ($isArray)
                {
                    if ($ComplexObject.$key.count -gt 0)
                    {
                        $currentProperty += $indent
                        $currentProperty += ')'
                        $currentProperty += "`r`n"
                    }
                }
                $isArray = $PSBoundParameters.IsArray
            }
            else
            {
                $currentProperty += Get-M365DSCDRGSimpleObjectTypeToString -Key $key -Value $ComplexObject[$key] -Space ($indent)
            }
        }
        else
        {
            $mappedKey = $ComplexTypeMapping | Where-Object -FilterScript { $_.name -eq $key }

            if ($mappedKey -and $mappedKey.isRequired)
            {
                if ($mappedKey.isArray)
                {
                    $currentProperty += "$indent$key = @()`r`n"
                }
                else
                {
                    $currentProperty += "$indent$key = `$null`r`n"
                }
            }
        }
    }
    $indent = ''
    for ($i = 0; $i -lt $IndentLevel - 1 ; $i++)
    {
        $indent += '    '
    }
    $currentProperty += "$indent}"
    if ($isArray -or $IndentLevel -gt 4)
    {
        $currentProperty += "`r`n"
    }

    #Indenting last parenthese when the cim instance is an array
    if ($IndentLevel -eq 5)
    {
        $indent = ''
        for ($i = 0; $i -lt $IndentLevel - 2 ; $i++)
        {
            $indent += '    '
        }
        $currentProperty += $indent
    }

    $emptyCIM = $currentProperty.replace(' ', '').replace("`r`n", '')
    if ($emptyCIM -eq "MSFT_$CIMInstanceName{}")
    {
        $currentProperty = $null
    }
    return $currentProperty
}

Function Get-M365DSCDRGSimpleObjectTypeToString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.String]
        $Key,

        [Parameter(Mandatory = 'true')]
        $Value,

        [Parameter()]
        [System.String]
        $Space = '                '

    )

    $returnValue = ''
    switch -Wildcard ($Value.GetType().Fullname )
    {
        '*.Boolean'
        {
            $returnValue = $Space + $Key + " = `$" + $Value.ToString() + "`r`n"
        }
        '*.String'
        {
            if ($key -eq '@odata.type')
            {
                $key = 'odataType'
            }
            $returnValue = $Space + $Key + " = '" + $Value + "'`r`n"
        }
        '*.DateTime'
        {
            $returnValue = $Space + $Key + " = '" + $Value + "'`r`n"
        }
        '*[[\]]'
        {
            $returnValue = $Space + $key + ' = @('
            $whitespace = ''
            $newline = ''
            if ($Value.count -gt 1)
            {
                $returnValue += "`r`n"
                $whitespace = $Space + '    '
                $newline = "`r`n"
            }
            foreach ($item in ($Value | Where-Object -FilterScript { $null -ne $_ }))
            {
                switch -Wildcard ($item.GetType().Fullname)
                {
                    '*.String'
                    {
                        $returnValue += "$whitespace'$item'$newline"
                    }
                    '*.DateTime'
                    {
                        $returnValue += "$whitespace'$item'$newline"
                    }
                    Default
                    {
                        $returnValue += "$whitespace$item$newline"
                    }
                }
            }
            if ($Value.count -gt 1)
            {
                $returnValue += "$Space)`r`n"
            }
            else
            {
                $returnValue += ")`r`n"

            }
        }
        Default
        {
            $returnValue = $Space + $Key + ' = ' + $Value + "`r`n"
        }
    }
    return $returnValue
}

function Compare-M365DSCComplexObject
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param(
        [Parameter()]
        $Source,
        [Parameter()]
        $Target
    )

    #Comparing full objects
    if ($null -eq $Source -and $null -eq $Target)
    {
        return $true
    }

    $sourceValue = ''
    $targetValue = ''
    if (($null -eq $Source) -xor ($null -eq $Target))
    {
        if ($null -eq $Source)
        {
            $sourceValue = 'Source is null'
        }

        if ($null -eq $Target)
        {
            $targetValue = 'Target is null'
        }
        Write-Verbose -Message "Configuration drift - Complex object: {$sourceValue$targetValue}"
        return $false
    }

    if ($Source.getType().FullName -like '*CimInstance[[\]]' -or $Source.getType().FullName -like '*Hashtable[[\]]')
    {
        if ($source.count -ne $target.count)
        {
            Write-Verbose -Message "Configuration drift - The complex array have different number of items: Source {$($source.count)} Target {$($target.count)}"
            return $false
        }
        if ($source.count -eq 0)
        {
            return $true
        }

        foreach ($item in $Source)
        {
            $hashSource = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
            foreach ($targetItem in $Target)
            {
                $compareResult = Compare-M365DSCComplexObject `
                    -Source $hashSource `
                    -Target $targetItem

                if ($compareResult)
                {
                    break
                }
            }

            if (-not $compareResult)
            {
                Write-Verbose -Message 'Configuration drift - The complex array items are not identical'
                return $false
            }
        }
        return $true
    }

    $keys = $Source.Keys | Where-Object -FilterScript { $_ -ne 'PSComputerName' }
    foreach ($key in $keys)
    {
        #Matching possible key names between Source and Target
        $skey = $key
        $tkey = $key

        $sourceValue = $Source.$key
        $targetValue = $Target.$tkey
        #One of the item is null and not the other
        if (($null -eq $Source.$key) -xor ($null -eq $Target.$tkey))
        {

            if ($null -eq $Source.$key)
            {
                $sourceValue = 'null'
            }

            if ($null -eq $Target.$tkey)
            {
                $targetValue = 'null'
            }

            #Write-Verbose -Message "Configuration drift - key: $key Source {$sourceValue} Target {$targetValue}"
            return $false
        }

        #Both keys aren't null or empty
        if (($null -ne $Source.$key) -and ($null -ne $Target.$tkey))
        {
            if ($Source.$key.getType().FullName -like '*CimInstance*' -or $Source.$key.getType().FullName -like '*hashtable*')
            {
                #Recursive call for complex object
                $compareResult = Compare-M365DSCComplexObject `
                    -Source (Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Source.$key) `
                    -Target $Target.$tkey

                if (-not $compareResult)
                {
                    #Write-Verbose -Message "Configuration drift - complex object key: $key Source {$sourceValue} Target {$targetValue}"
                    return $false
                }
            }
            else
            {
                #Simple object comparison
                $referenceObject = $Target.$tkey
                $differenceObject = $Source.$key

                #Identifying date from the current values
                $targetType = ($Target.$tkey.getType()).Name
                if ($targetType -like '*Date*')
                {
                    $compareResult = $true
                    $sourceDate = [DateTime]$Source.$key
                    if ($sourceDate -ne $targetType)
                    {
                        $compareResult = $null
                    }
                }
                else
                {
                    $compareResult = Compare-Object `
                        -ReferenceObject ($referenceObject) `
                        -DifferenceObject ($differenceObject)
                }

                if ($null -ne $compareResult)
                {
                    #Write-Verbose -Message "Configuration drift - simple object key: $key Source {$sourceValue} Target {$targetValue}"
                    return $false
                }
            }
        }
    }
    return $true
}

function Convert-M365DSCDRGComplexTypeToHashtable
{
    [CmdletBinding()]
    [OutputType([hashtable], [hashtable[]])]
    param(
        [Parameter(Mandatory = 'true')]
        $ComplexObject
    )

    if ($ComplexObject.getType().Fullname -like '*[[\]]')
    {
        $results = @()
        foreach ($item in $ComplexObject)
        {
            $hash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
            $results += $hash
        }

        #Write-Verbose -Message ("Convert-M365DSCDRGComplexTypeToHashtable >>> results: "+(convertTo-JSON $results -Depth 20))
        # PowerShell returns all non-captured stream output, not just the argument of the return statement.
        #An empty array is mangled into $null in the process.
        #However, an array can be preserved on return by prepending it with the array construction operator (,)
        return , [hashtable[]]$results
    }
    $hashComplexObject = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject

    if ($null -ne $hashComplexObject)
    {
        $results = $hashComplexObject.clone()
        $keys = $hashComplexObject.Keys | Where-Object -FilterScript { $_ -ne 'PSComputerName' }
        foreach ($key in $keys)
        {
            if ($hashComplexObject[$key] -and $hashComplexObject[$key].getType().Fullname -like '*CimInstance*')
            {
                $results[$key] = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $hashComplexObject[$key]
            }
            else
            {
                $propertyName = $key[0].ToString().ToLower() + $key.Substring(1, $key.Length - 1)
                $propertyValue = $results[$key]
                $results.remove($key) | Out-Null
                $results.add($propertyName, $propertyValue)
            }
        }
    }
    return [hashtable]$results
}

Export-ModuleMember -Function *-TargetResource
