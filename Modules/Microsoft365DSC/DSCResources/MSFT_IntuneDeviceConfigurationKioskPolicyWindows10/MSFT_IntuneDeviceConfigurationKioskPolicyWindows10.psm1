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
            Write-Verbose -Message "Could not find an Intune Device Configuration Kiosk Policy for Windows10 with Id {$Id}"

            if (-Not [string]::IsNullOrEmpty($DisplayName))
            {
                $getValue = Get-MgBetaDeviceManagementDeviceConfiguration `
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
            AccessTokens                           = $AccessTokens
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
        Write-Verbose -Message "Removing the Intune Device Configuration Kiosk Policy for Windows10 with Id {$($currentInstance.Id)}"
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

    Write-Verbose -Message "Testing configuration of the Intune Device Configuration Kiosk Policy for Windows10 with Id {$Id} and DisplayName {$DisplayName}"

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
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

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
                AccessTokens    = $AccessTokens
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
