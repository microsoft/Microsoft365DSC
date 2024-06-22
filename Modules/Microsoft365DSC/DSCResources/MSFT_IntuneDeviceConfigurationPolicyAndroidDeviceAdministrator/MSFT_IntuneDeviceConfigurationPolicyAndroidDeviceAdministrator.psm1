function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $AppsBlockClipboardSharing,

        [Parameter()]
        [System.Boolean]
        $AppsBlockCopyPaste,

        [Parameter()]
        [System.Boolean]
        $AppsBlockYouTube,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AppsHideList,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AppsInstallAllowList,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AppsLaunchBlockList,

        [Parameter()]
        [System.Boolean]
        $BluetoothBlocked,

        [Parameter()]
        [System.Boolean]
        $CameraBlocked,

        [Parameter()]
        [System.Boolean]
        $CellularBlockDataRoaming,

        [Parameter()]
        [System.Boolean]
        $CellularBlockMessaging,

        [Parameter()]
        [System.Boolean]
        $CellularBlockVoiceRoaming,

        [Parameter()]
        [System.Boolean]
        $CellularBlockWiFiTethering,

        [Parameter()]
        [ValidateSet('none', 'appsInListCompliant', 'appsNotInListCompliant')]
        [System.String]
        $CompliantAppListType,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CompliantAppsList,

        [Parameter()]
        [System.Boolean]
        $DateAndTimeBlockChanges,

        [Parameter()]
        [System.Boolean]
        $DeviceSharingAllowed,

        [Parameter()]
        [System.Boolean]
        $DiagnosticDataBlockSubmission,

        [Parameter()]
        [System.Boolean]
        $FactoryResetBlocked,

        [Parameter()]
        [System.Boolean]
        $GoogleAccountBlockAutoSync,

        [Parameter()]
        [System.Boolean]
        $GooglePlayStoreBlocked,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $KioskModeApps,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockSleepButton,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockVolumeButtons,

        [Parameter()]
        [System.Boolean]
        $LocationServicesBlocked,

        [Parameter()]
        [System.Boolean]
        $NfcBlocked,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockFingerprintUnlock,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockTrustAgents,

        [Parameter()]
        [System.Int32]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeScreenTimeout,

        [Parameter()]
        [System.Int32]
        $PasswordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Boolean]
        $PasswordRequired,

        [Parameter()]
        [ValidateSet('deviceDefault', 'alphabetic', 'alphanumeric', 'alphanumericWithSymbols', 'lowSecurityBiometric', 'numeric', 'numericComplex', 'any')]
        [System.String]
        $PasswordRequiredType,

        [Parameter()]
        [System.Int32]
        $PasswordSignInFailureCountBeforeFactoryReset,

        [Parameter()]
        [System.Boolean]
        $PowerOffBlocked,

        [Parameter()]
        [ValidateSet('none', 'low', 'medium', 'high')]
        [System.String]
        $RequiredPasswordComplexity,

        [Parameter()]
        [System.Boolean]
        $ScreenCaptureBlocked,

        [Parameter()]
        [System.Boolean]
        $SecurityRequireVerifyApps,

        [Parameter()]
        [System.Boolean]
        $StorageBlockGoogleBackup,

        [Parameter()]
        [System.Boolean]
        $StorageBlockRemovableStorage,

        [Parameter()]
        [System.Boolean]
        $StorageRequireDeviceEncryption,

        [Parameter()]
        [System.Boolean]
        $StorageRequireRemovableStorageEncryption,

        [Parameter()]
        [System.Boolean]
        $VoiceAssistantBlocked,

        [Parameter()]
        [System.Boolean]
        $VoiceDialingBlocked,

        [Parameter()]
        [System.Boolean]
        $WebBrowserBlockAutofill,

        [Parameter()]
        [System.Boolean]
        $WebBrowserBlocked,

        [Parameter()]
        [System.Boolean]
        $WebBrowserBlockJavaScript,

        [Parameter()]
        [System.Boolean]
        $WebBrowserBlockPopups,

        [Parameter()]
        [ValidateSet('browserDefault', 'blockAlways', 'allowCurrentWebSite', 'allowFromWebsitesVisited', 'allowAlways')]
        [System.String]
        $WebBrowserCookieSettings,

        [Parameter()]
        [System.Boolean]
        $WiFiBlocked,


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
    }
    catch
    {
        Write-Verbose -Message 'Connection to the workload failed.'
    }

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
        if (-not [System.String]::IsNullOrEmpty($Id))
        {
            $getValue = Get-MgBetaDeviceManagementDeviceConfiguration -DeviceConfigurationId $id -ErrorAction SilentlyContinue
        }
        else
        {
            $getValue = $null
        }

        if ($null -eq $getValue)
        {
            $getValue = Get-MgBetaDeviceManagementDeviceConfiguration -Filter "DisplayName eq '$Displayname'" -ErrorAction SilentlyContinue | Where-Object `
            -FilterScript { `
                $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.androidGeneralDeviceConfiguration' `
            }
        }
        #endregion
        $complexAppsHideList = @()
        $currentValueArray = $getValue.AdditionalProperties.appsHideList
        if ($null -ne $currentValueArray -and $currentValueArray.count -gt 0 )
        {
            foreach($currentValue in $currentValueArray)
            {
                $currentHash = @{}
                $currentHash.add('AppId',$currentValue.appid)
                $currentHash.add('Publisher',$currentValue.publisher)
                $currentHash.add('AppStoreUrl',$currentValue.appStoreUrl)
                $currentHash.add('Name',$currentValue.name)
                $currentHash.add('oDataType',$currentValue.'@odata.type')
                $complexAppsHideList += $currentHash
            }
        }
        $complexAppsLaunchBlockList = @()
        $currentValueArray = $getValue.AdditionalProperties.appsLaunchBlockList
        if ($null -ne $currentValueArray -and $currentValueArray.count -gt 0 )
        {
            foreach($currentValue in $currentValueArray)
            {
                $currentHash = @{}
                $currentHash.add('AppId',$currentValue.appid)
                $currentHash.add('Publisher',$currentValue.publisher)
                $currentHash.add('AppStoreUrl',$currentValue.appStoreUrl)
                $currentHash.add('Name',$currentValue.name)
                $currentHash.add('oDataType',$currentValue.'@odata.type')
                $complexAppsLaunchBlockList += $currentHash
            }
        }
        $complexAppsInstallAllowList = @()
        $currentValueArray = $getValue.AdditionalProperties.appsInstallAllowList
        if ($null -ne $currentValueArray -and $currentValueArray.count -gt 0 )
        {
            foreach($currentValue in $currentValueArray)
            {
                $currentHash = @{}
                $currentHash.add('AppId',$currentValue.appid)
                $currentHash.add('Publisher',$currentValue.publisher)
                $currentHash.add('AppStoreUrl',$currentValue.appStoreUrl)
                $currentHash.add('Name',$currentValue.name)
                $currentHash.add('oDataType',$currentValue.'@odata.type')
                $complexAppsInstallAllowList += $currentHash
            }
        }
        $complexCompliantAppsList = @()
        $currentValueArray = $getValue.AdditionalProperties.compliantAppsList
        if ($null -ne $currentValueArray -and $currentValueArray.count -gt 0 )
        {
            foreach($currentValue in $currentValueArray)
            {
                $currentHash = @{}
                $currentHash.add('AppId',$currentValue.appid)
                $currentHash.add('Publisher',$currentValue.publisher)
                $currentHash.add('AppStoreUrl',$currentValue.appStoreUrl)
                $currentHash.add('Name',$currentValue.name)
                $currentHash.add('oDataType',$currentValue.'@odata.type')
                $complexCompliantAppsList += $currentHash
            }
        }
        $complexKioskModeApps = @()
        $currentValueArray = $getValue.AdditionalProperties.kioskModeApps
        if ($null -ne $currentValueArray -and $currentValueArray.count -gt 0 )
        {
            foreach($currentValue in $currentValueArray)
            {
                $currentHash = @{}
                $currentHash.add('AppId',$currentValue.appid)
                $currentHash.add('Publisher',$currentValue.publisher)
                $currentHash.add('AppStoreUrl',$currentValue.appStoreUrl)
                $currentHash.add('Name',$currentValue.name)
                $currentHash.add('oDataType',$currentValue.'@odata.type')
                $complexKioskModeApps += $currentHash
            }
        }
        if ($null -eq $getValue)
        {
            if (-not [String]::IsNullOrEmpty($Id))
            {
                Write-Verbose -Message "Nothing with id {$Id} was found"
            }
            else
            {
                Write-Verbose -Message "Nothing with display name {$DisplayName} was found"
            }
            return $nullResult
        }

        Write-Verbose -Message "Found something with id {$($getValue.Id)}"
        $results = @{

            #region resource generator code
            Id                                             = $getValue.Id
            Description                                    = $getValue.Description
            DisplayName                                    = $getValue.DisplayName
            AppsHideList                                   = $complexAppsHideList
            AppsInstallAllowList                           = $complexAppsInstallAllowList
            AppsLaunchBlockList                            = $complexAppsLaunchBlockList
            KioskModeApps                                  = $complexKioskModeApps
            AppsBlockClipboardSharing                      = $getValue.AdditionalProperties.appsBlockClipboardSharing
            AppsBlockCopyPaste                             = $getValue.AdditionalProperties.appsBlockCopyPaste
            AppsBlockYouTube                               = $getValue.AdditionalProperties.appsBlockYouTube
            BluetoothBlocked                               = $getValue.AdditionalProperties.bluetoothBlocked
            CameraBlocked                                  = $getValue.AdditionalProperties.cameraBlocked
            CellularBlockDataRoaming                       = $getValue.AdditionalProperties.cellularBlockDataRoaming
            CellularBlockMessaging                         = $getValue.AdditionalProperties.cellularBlockMessaging
            CellularBlockVoiceRoaming                      = $getValue.AdditionalProperties.cellularBlockVoiceRoaming
            CellularBlockWiFiTethering                     = $getValue.AdditionalProperties.cellularBlockWiFiTethering
            CompliantAppsList                              = $complexCompliantAppsList
            CompliantAppListType                           = $getValue.AdditionalProperties.compliantAppListType
            DateAndTimeBlockChanges                        = $getValue.AdditionalProperties.dateAndTimeBlockChanges
            DeviceSharingAllowed                           = $getValue.AdditionalProperties.deviceSharingAllowed
            DiagnosticDataBlockSubmission                  = $getValue.AdditionalProperties.diagnosticDataBlockSubmission
            FactoryResetBlocked                            = $getValue.AdditionalProperties.factoryResetBlocked
            GoogleAccountBlockAutoSync                     = $getValue.AdditionalProperties.googleAccountBlockAutoSync
            GooglePlayStoreBlocked                         = $getValue.AdditionalProperties.googlePlayStoreBlocked
            KioskModeBlockSleepButton                      = $getValue.AdditionalProperties.kioskModeBlockSleepButton
            KioskModeBlockVolumeButtons                    = $getValue.AdditionalProperties.kioskModeBlockVolumeButtons
            LocationServicesBlocked                        = $getValue.AdditionalProperties.locationServicesBlocked
            NfcBlocked                                     = $getValue.AdditionalProperties.nfcBlocked
            PasswordBlockFingerprintUnlock                 = $getValue.AdditionalProperties.passwordBlockFingerprintUnlock
            PasswordBlockTrustAgents                       = $getValue.AdditionalProperties.passwordBlockTrustAgents
            PasswordExpirationDays                         = $getValue.AdditionalProperties.passwordExpirationDays
            PasswordMinimumLength                          = $getValue.AdditionalProperties.passwordMinimumLength
            PasswordMinutesOfInactivityBeforeScreenTimeout = $getValue.AdditionalProperties.passwordMinutesOfInactivityBeforeScreenTimeout
            PasswordPreviousPasswordBlockCount             = $getValue.AdditionalProperties.passwordPreviousPasswordBlockCount
            PasswordRequired                               = $getValue.AdditionalProperties.passwordRequired
            PasswordRequiredType                           = $getValue.AdditionalProperties.passwordRequiredType
            PasswordSignInFailureCountBeforeFactoryReset   = $getValue.AdditionalProperties.passwordSignInFailureCountBeforeFactoryReset
            PowerOffBlocked                                = $getValue.AdditionalProperties.powerOffBlocked
            RequiredPasswordComplexity                     = $getValue.AdditionalProperties.requiredPasswordComplexity
            ScreenCaptureBlocked                           = $getValue.AdditionalProperties.screenCaptureBlocked
            SecurityRequireVerifyApps                      = $getValue.AdditionalProperties.securityRequireVerifyApps
            StorageBlockGoogleBackup                       = $getValue.AdditionalProperties.storageBlockGoogleBackup
            StorageBlockRemovableStorage                   = $getValue.AdditionalProperties.storageBlockRemovableStorage
            StorageRequireDeviceEncryption                 = $getValue.AdditionalProperties.storageRequireDeviceEncryption
            StorageRequireRemovableStorageEncryption       = $getValue.AdditionalProperties.storageRequireRemovableStorageEncryption
            VoiceAssistantBlocked                          = $getValue.AdditionalProperties.voiceAssistantBlocked
            VoiceDialingBlocked                            = $getValue.AdditionalProperties.voiceDialingBlocked
            WebBrowserBlockAutofill                        = $getValue.AdditionalProperties.webBrowserBlockAutofill
            WebBrowserBlocked                              = $getValue.AdditionalProperties.webBrowserBlocked
            WebBrowserBlockJavaScript                      = $getValue.AdditionalProperties.webBrowserBlockJavaScript
            WebBrowserBlockPopups                          = $getValue.AdditionalProperties.webBrowserBlockPopups
            WebBrowserCookieSettings                       = $getValue.AdditionalProperties.webBrowserCookieSettings
            WiFiBlocked                                    = $getValue.AdditionalProperties.wiFiBlocked
            Ensure                                         = 'Present'
            Credential                                     = $Credential
            ApplicationId                                  = $ApplicationId
            TenantId                                       = $TenantId
            ApplicationSecret                              = $ApplicationSecret
            CertificateThumbprint                          = $CertificateThumbprint
            Managedidentity                                = $ManagedIdentity.IsPresent
            AccessTokens                                   = $AccessTokens
        }

        $assignmentsValues = Get-MgBetaDeviceManagementDeviceConfigurationAssignment -DeviceConfigurationId $getValue.Id
        $assignmentResult = @()
        if ($assignmentsValues.Count -gt 0)
        {
            $assignmentResult += ConvertFrom-IntunePolicyAssignment `
                                -IncludeDeviceFilter:$true `
                                -Assignments ($assignmentsValues)
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
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $AppsBlockClipboardSharing,

        [Parameter()]
        [System.Boolean]
        $AppsBlockCopyPaste,

        [Parameter()]
        [System.Boolean]
        $AppsBlockYouTube,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AppsHideList,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AppsInstallAllowList,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AppsLaunchBlockList,

        [Parameter()]
        [System.Boolean]
        $BluetoothBlocked,

        [Parameter()]
        [System.Boolean]
        $CameraBlocked,

        [Parameter()]
        [System.Boolean]
        $CellularBlockDataRoaming,

        [Parameter()]
        [System.Boolean]
        $CellularBlockMessaging,

        [Parameter()]
        [System.Boolean]
        $CellularBlockVoiceRoaming,

        [Parameter()]
        [System.Boolean]
        $CellularBlockWiFiTethering,

        [Parameter()]
        [ValidateSet('none', 'appsInListCompliant', 'appsNotInListCompliant')]
        [System.String]
        $CompliantAppListType,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CompliantAppsList,

        [Parameter()]
        [System.Boolean]
        $DateAndTimeBlockChanges,

        [Parameter()]
        [System.Boolean]
        $DeviceSharingAllowed,

        [Parameter()]
        [System.Boolean]
        $DiagnosticDataBlockSubmission,

        [Parameter()]
        [System.Boolean]
        $FactoryResetBlocked,

        [Parameter()]
        [System.Boolean]
        $GoogleAccountBlockAutoSync,

        [Parameter()]
        [System.Boolean]
        $GooglePlayStoreBlocked,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $KioskModeApps,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockSleepButton,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockVolumeButtons,

        [Parameter()]
        [System.Boolean]
        $LocationServicesBlocked,

        [Parameter()]
        [System.Boolean]
        $NfcBlocked,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockFingerprintUnlock,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockTrustAgents,

        [Parameter()]
        [System.Int32]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeScreenTimeout,

        [Parameter()]
        [System.Int32]
        $PasswordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Boolean]
        $PasswordRequired,

        [Parameter()]
        [ValidateSet('deviceDefault', 'alphabetic', 'alphanumeric', 'alphanumericWithSymbols', 'lowSecurityBiometric', 'numeric', 'numericComplex', 'any')]
        [System.String]
        $PasswordRequiredType,

        [Parameter()]
        [System.Int32]
        $PasswordSignInFailureCountBeforeFactoryReset,

        [Parameter()]
        [System.Boolean]
        $PowerOffBlocked,

        [Parameter()]
        [ValidateSet('none', 'low', 'medium', 'high')]
        [System.String]
        $RequiredPasswordComplexity,

        [Parameter()]
        [System.Boolean]
        $ScreenCaptureBlocked,

        [Parameter()]
        [System.Boolean]
        $SecurityRequireVerifyApps,

        [Parameter()]
        [System.Boolean]
        $StorageBlockGoogleBackup,

        [Parameter()]
        [System.Boolean]
        $StorageBlockRemovableStorage,

        [Parameter()]
        [System.Boolean]
        $StorageRequireDeviceEncryption,

        [Parameter()]
        [System.Boolean]
        $StorageRequireRemovableStorageEncryption,

        [Parameter()]
        [System.Boolean]
        $VoiceAssistantBlocked,

        [Parameter()]
        [System.Boolean]
        $VoiceDialingBlocked,

        [Parameter()]
        [System.Boolean]
        $WebBrowserBlockAutofill,

        [Parameter()]
        [System.Boolean]
        $WebBrowserBlocked,

        [Parameter()]
        [System.Boolean]
        $WebBrowserBlockJavaScript,

        [Parameter()]
        [System.Boolean]
        $WebBrowserBlockPopups,

        [Parameter()]
        [ValidateSet('browserDefault', 'blockAlways', 'allowCurrentWebSite', 'allowFromWebsitesVisited', 'allowAlways')]
        [System.String]
        $WebBrowserCookieSettings,

        [Parameter()]
        [System.Boolean]
        $WiFiBlocked,

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
    }
    catch
    {
        Write-Verbose -Message $_
    }

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

    $PSBoundParameters.Remove('Ensure') | Out-Null
    $PSBoundParameters.Remove('Credential') | Out-Null
    $PSBoundParameters.Remove('ApplicationId') | Out-Null
    $PSBoundParameters.Remove('ApplicationSecret') | Out-Null
    $PSBoundParameters.Remove('TenantId') | Out-Null
    $PSBoundParameters.Remove('CertificateThumbprint') | Out-Null
    $PSBoundParameters.Remove('ManagedIdentity') | Out-Null
    $PSBoundParameters.Remove('AccessTokens') | Out-Null

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating {$DisplayName}"
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $CreateParameters = ([Hashtable]$PSBoundParameters).clone()
        $CreateParameters = Rename-M365DSCCimInstanceParameter -Properties $CreateParameters

        $AdditionalProperties = Get-M365DSCAdditionalProperties -Properties ($CreateParameters)
        foreach ($key in $AdditionalProperties.keys)
        {
            if ($key -ne '@odata.type')
            {
                $keyName = $key.substring(0, 1).ToUpper() + $key.substring(1, $key.length - 1)
                $CreateParameters.remove($keyName)
            }
        }

        $CreateParameters.Remove('Id') | Out-Null
        $CreateParameters.Remove('Verbose') | Out-Null

        foreach ($key in ($CreateParameters.clone()).Keys)
        {
            if ($CreateParameters[$key].getType().Fullname -like '*CimInstance*')
            {
                $CreateParameters[$key] = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $CreateParameters[$key]
            }
        }

        if ($AdditionalProperties)
        {
            $CreateParameters.add('AdditionalProperties', $AdditionalProperties)
        }

        #region resource generator code
        $policy = New-MgBetaDeviceManagementDeviceConfiguration @CreateParameters
        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments

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
        Write-Verbose -Message "Updating {$DisplayName}"
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $UpdateParameters = ([Hashtable]$PSBoundParameters).clone()
        $UpdateParameters = Rename-M365DSCCimInstanceParameter -Properties $UpdateParameters

        $AdditionalProperties = Get-M365DSCAdditionalProperties -Properties ($UpdateParameters)
        foreach ($key in $AdditionalProperties.keys)
        {
            if ($key -ne '@odata.type')
            {
                $keyName = $key.substring(0, 1).ToUpper() + $key.substring(1, $key.length - 1)
                $UpdateParameters.remove($keyName)
            }
        }

        $UpdateParameters.Remove('Id') | Out-Null
        $UpdateParameters.Remove('Verbose') | Out-Null

        foreach ($key in ($UpdateParameters.clone()).Keys)
        {
            if ($UpdateParameters[$key].getType().Fullname -like '*CimInstance*')
            {
                $UpdateParameters[$key] = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $UpdateParameters[$key]
            }
        }

        if ($AdditionalProperties)
        {
            $UpdateParameters.add('AdditionalProperties', $AdditionalProperties)
        }

        #region resource generator code
        Update-MgBetaDeviceManagementDeviceConfiguration @UpdateParameters `
            -DeviceConfigurationId $currentInstance.Id
        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        Update-DeviceConfigurationPolicyAssignment `
            -DeviceConfigurationPolicyId $currentInstance.id `
            -Targets $assignmentsHash `
            -Repository 'deviceManagement/deviceConfigurations'
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing {$DisplayName}"
        Remove-MgBetaDeviceManagementDeviceConfiguration -DeviceConfigurationId $currentInstance.Id
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
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $AppsBlockClipboardSharing,

        [Parameter()]
        [System.Boolean]
        $AppsBlockCopyPaste,

        [Parameter()]
        [System.Boolean]
        $AppsBlockYouTube,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AppsHideList,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AppsInstallAllowList,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AppsLaunchBlockList,

        [Parameter()]
        [System.Boolean]
        $BluetoothBlocked,

        [Parameter()]
        [System.Boolean]
        $CameraBlocked,

        [Parameter()]
        [System.Boolean]
        $CellularBlockDataRoaming,

        [Parameter()]
        [System.Boolean]
        $CellularBlockMessaging,

        [Parameter()]
        [System.Boolean]
        $CellularBlockVoiceRoaming,

        [Parameter()]
        [System.Boolean]
        $CellularBlockWiFiTethering,

        [Parameter()]
        [ValidateSet('none', 'appsInListCompliant', 'appsNotInListCompliant')]
        [System.String]
        $CompliantAppListType,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CompliantAppsList,

        [Parameter()]
        [System.Boolean]
        $DateAndTimeBlockChanges,

        [Parameter()]
        [System.Boolean]
        $DeviceSharingAllowed,

        [Parameter()]
        [System.Boolean]
        $DiagnosticDataBlockSubmission,

        [Parameter()]
        [System.Boolean]
        $FactoryResetBlocked,

        [Parameter()]
        [System.Boolean]
        $GoogleAccountBlockAutoSync,

        [Parameter()]
        [System.Boolean]
        $GooglePlayStoreBlocked,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $KioskModeApps,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockSleepButton,

        [Parameter()]
        [System.Boolean]
        $KioskModeBlockVolumeButtons,

        [Parameter()]
        [System.Boolean]
        $LocationServicesBlocked,

        [Parameter()]
        [System.Boolean]
        $NfcBlocked,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockFingerprintUnlock,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockTrustAgents,

        [Parameter()]
        [System.Int32]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeScreenTimeout,

        [Parameter()]
        [System.Int32]
        $PasswordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Boolean]
        $PasswordRequired,

        [Parameter()]
        [ValidateSet('deviceDefault', 'alphabetic', 'alphanumeric', 'alphanumericWithSymbols', 'lowSecurityBiometric', 'numeric', 'numericComplex', 'any')]
        [System.String]
        $PasswordRequiredType,

        [Parameter()]
        [System.Int32]
        $PasswordSignInFailureCountBeforeFactoryReset,

        [Parameter()]
        [System.Boolean]
        $PowerOffBlocked,

        [Parameter()]
        [ValidateSet('none', 'low', 'medium', 'high')]
        [System.String]
        $RequiredPasswordComplexity,

        [Parameter()]
        [System.Boolean]
        $ScreenCaptureBlocked,

        [Parameter()]
        [System.Boolean]
        $SecurityRequireVerifyApps,

        [Parameter()]
        [System.Boolean]
        $StorageBlockGoogleBackup,

        [Parameter()]
        [System.Boolean]
        $StorageBlockRemovableStorage,

        [Parameter()]
        [System.Boolean]
        $StorageRequireDeviceEncryption,

        [Parameter()]
        [System.Boolean]
        $StorageRequireRemovableStorageEncryption,

        [Parameter()]
        [System.Boolean]
        $VoiceAssistantBlocked,

        [Parameter()]
        [System.Boolean]
        $VoiceDialingBlocked,

        [Parameter()]
        [System.Boolean]
        $WebBrowserBlockAutofill,

        [Parameter()]
        [System.Boolean]
        $WebBrowserBlocked,

        [Parameter()]
        [System.Boolean]
        $WebBrowserBlockJavaScript,

        [Parameter()]
        [System.Boolean]
        $WebBrowserBlockPopups,

        [Parameter()]
        [ValidateSet('browserDefault', 'blockAlways', 'allowCurrentWebSite', 'allowFromWebsitesVisited', 'allowAlways')]
        [System.String]
        $WebBrowserCookieSettings,

        [Parameter()]
        [System.Boolean]
        $WiFiBlocked,

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

    Write-Verbose -Message "Testing configuration of {$id}"

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
            $testResult = Compare-M365DSCComplexObject `
                -Source ($source) `
                -Target ($target) -verbose

            if (-Not $testResult)
            {
                $testResult = $false
                break
            }

            $ValuesToCheck.Remove($key) | Out-Null
        }
    }

    if ($testResult)
    {
        $ValuesToCheck = Remove-M365DSCAuthenticationParameter -BoundParameters $ValuesToCheck
        $ValuesToCheck.Remove('Id') | Out-Null

        Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
        Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

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
                $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.androidGeneralDeviceConfiguration'  `
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

            Write-Host "    |---[$i/$($getValue.Count)] $($config.DisplayName)" -NoNewline
            $params = @{
                Id                    = $config.id
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

            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results

            if ($Results.AppsHideList)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.AppsHideList -CIMInstanceName MicrosoftGraphapplistitem
                if ($complexTypeStringResult)
                {
                    $Results.AppsHideList = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('AppsHideList') | Out-Null
                }
            }
            if ($Results.AppsInstallAllowList)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.AppsInstallAllowList -CIMInstanceName MicrosoftGraphapplistitem
                if ($complexTypeStringResult)
                {
                    $Results.AppsInstallAllowList = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('AppsInstallAllowList') | Out-Null
                }
            }
            if ($Results.AppsLaunchBlockList)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.AppsLaunchBlockList -CIMInstanceName MicrosoftGraphapplistitem
                if ($complexTypeStringResult)
                {
                    $Results.AppsLaunchBlockList = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('AppsLaunchBlockList') | Out-Null
                }
            }
            if ($Results.CompliantAppsList)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.CompliantAppsList -CIMInstanceName MicrosoftGraphapplistitem
                if ($complexTypeStringResult)
                {
                    $Results.CompliantAppsList = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('CompliantAppsList') | Out-Null
                }
            }
            if ($Results.KioskModeApps)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.KioskModeApps -CIMInstanceName MicrosoftGraphapplistitem
                if ($complexTypeStringResult)
                {
                    $Results.KioskModeApps = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('KioskModeApps') | Out-Null
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

            if ($Results.AppsHideList)
            {
                $isCIMArray = $false
                if ($Results.AppsHideList.getType().Fullname -like '*[[\]]')
                {
                    $isCIMArray = $true
                }
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'AppsHideList' -IsCIMArray:$isCIMArray
            }
            if ($Results.AppsInstallAllowList)
            {
                $isCIMArray = $false
                if ($Results.AppsInstallAllowList.getType().Fullname -like '*[[\]]')
                {
                    $isCIMArray = $true
                }
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'AppsInstallAllowList' -IsCIMArray:$isCIMArray
            }
            if ($Results.AppsLaunchBlockList)
            {
                $isCIMArray = $false
                if ($Results.AppsLaunchBlockList.getType().Fullname -like '*[[\]]')
                {
                    $isCIMArray = $true
                }
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'AppsLaunchBlockList' -IsCIMArray:$isCIMArray
            }
            if ($Results.CompliantAppsList)
            {
                $isCIMArray = $false
                if ($Results.CompliantAppsList.getType().Fullname -like '*[[\]]')
                {
                    $isCIMArray = $true
                }
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'CompliantAppsList' -IsCIMArray:$isCIMArray
            }
            if ($Results.KioskModeApps)
            {
                $isCIMArray = $false
                if ($Results.KioskModeApps.getType().Fullname -like '*[[\]]')
                {
                    $isCIMArray = $true
                }
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'KioskModeApps' -IsCIMArray:$isCIMArray
            }

            if ($Results.Assignments)
            {
                $isCIMArray = $false
                if ($Results.Assignments.getType().Fullname -like '*[[\]]')
                {
                    $isCIMArray = $true
                }
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'Assignments' -IsCIMArray:$isCIMArray
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

function Get-M365DSCAdditionalProperties
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $Properties
    )

    $additionalProperties = @(
        'AppsBlockClipboardSharing'
        'AppsBlockCopyPaste'
        'AppsBlockYouTube'
        'AppsHideList'
        'AppsInstallAllowList'
        'AppsLaunchBlockList'
        'BluetoothBlocked'
        'CameraBlocked'
        'CellularBlockDataRoaming'
        'CellularBlockMessaging'
        'CellularBlockVoiceRoaming'
        'CellularBlockWiFiTethering'
        'CompliantAppListType'
        'CompliantAppsList'
        'DateAndTimeBlockChanges'
        'DeviceSharingAllowed'
        'DiagnosticDataBlockSubmission'
        'FactoryResetBlocked'
        'GoogleAccountBlockAutoSync'
        'GooglePlayStoreBlocked'
        'KioskModeApps'
        'KioskModeBlockSleepButton'
        'KioskModeBlockVolumeButtons'
        'LocationServicesBlocked'
        'NfcBlocked'
        'PasswordBlockFingerprintUnlock'
        'PasswordBlockTrustAgents'
        'PasswordExpirationDays'
        'PasswordMinimumLength'
        'PasswordMinutesOfInactivityBeforeScreenTimeout'
        'PasswordPreviousPasswordBlockCount'
        'PasswordRequired'
        'PasswordRequiredType'
        'PasswordSignInFailureCountBeforeFactoryReset'
        'PowerOffBlocked'
        'RequiredPasswordComplexity'
        'ScreenCaptureBlocked'
        'SecurityRequireVerifyApps'
        'StorageBlockGoogleBackup'
        'StorageBlockRemovableStorage'
        'StorageRequireDeviceEncryption'
        'StorageRequireRemovableStorageEncryption'
        'VoiceAssistantBlocked'
        'VoiceDialingBlocked'
        'WebBrowserBlockAutofill'
        'WebBrowserBlocked'
        'WebBrowserBlockJavaScript'
        'WebBrowserBlockPopups'
        'WebBrowserCookieSettings'
        'WiFiBlocked'

    )
    $results = @{'@odata.type' = '#microsoft.graph.androidGeneralDeviceConfiguration' }
    $cloneProperties = $Properties.clone()
    foreach ($property in $cloneProperties.Keys)
    {
        if ($property -in ($additionalProperties) )
        {
            $propertyName = $property[0].ToString().ToLower() + $property.Substring(1, $property.Length - 1)
            if ($properties.$property -and $properties.$property.getType().FullName -like '*CIMInstance*')
            {
                if ($properties.$property.getType().FullName -like '*[[\]]')
                {
                    $array = @()
                    foreach ($item in $properties.$property)
                    {
                        $array += Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $item

                    }
                    $propertyValue = $array
                }
                else
                {
                    $propertyValue = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $properties.$property
                }

            }
            else
            {
                $propertyValue = $properties.$property
            }


            $results.Add($propertyName, $propertyValue)

        }
    }
    if ($results.Count -eq 1)
    {
        return $null
    }
    return $results
}

Export-ModuleMember -Function *-TargetResource
