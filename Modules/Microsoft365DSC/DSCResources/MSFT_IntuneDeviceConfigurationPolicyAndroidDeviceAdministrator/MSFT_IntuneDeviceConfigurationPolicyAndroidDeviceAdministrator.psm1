function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
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
        $ManagedIdentity
    )

    try
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters `
            -ProfileName 'beta'
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
        $getValue = $null

        #region resource generator code
        if (-Not [string]::IsNullOrEmpty($DisplayName))
        {
            $getValue = Get-MgDeviceManagementDeviceConfiguration -Filter "DisplayName eq '$Displayname'" | Where-Object `
            -FilterScript { `
                $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.androidGeneralDeviceConfiguration' `
            }
        }

        if (-not $getValue)
        {
            $getValue = Get-MgDeviceManagementDeviceConfiguration -DeviceConfigurationId $id
        }
        #endregion


        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Nothing with id {$id} was found"
            return $nullResult
        }

        Write-Verbose -Message "Found something with id {$id}"
        $results = @{

            #region resource generator code
            Id                                             = $getValue.Id
            Description                                    = $getValue.Description
            DisplayName                                    = $getValue.DisplayName
            AppsBlockClipboardSharing                      = $getValue.AdditionalProperties.appsBlockClipboardSharing
            AppsBlockCopyPaste                             = $getValue.AdditionalProperties.appsBlockCopyPaste
            AppsBlockYouTube                               = $getValue.AdditionalProperties.appsBlockYouTube
            BluetoothBlocked                               = $getValue.AdditionalProperties.bluetoothBlocked
            CameraBlocked                                  = $getValue.AdditionalProperties.cameraBlocked
            CellularBlockDataRoaming                       = $getValue.AdditionalProperties.cellularBlockDataRoaming
            CellularBlockMessaging                         = $getValue.AdditionalProperties.cellularBlockMessaging
            CellularBlockVoiceRoaming                      = $getValue.AdditionalProperties.cellularBlockVoiceRoaming
            CellularBlockWiFiTethering                     = $getValue.AdditionalProperties.cellularBlockWiFiTethering
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
        }
        if ($getValue.additionalProperties.appsHideList)
        {
            $results.Add('AppsHideList', $getValue.additionalProperties.appsHideList)
        }
        if ($getValue.additionalProperties.appsInstallAllowList)
        {
            $results.Add('AppsInstallAllowList', $getValue.additionalProperties.appsInstallAllowList)
        }
        if ($getValue.additionalProperties.appsLaunchBlockList)
        {
            $results.Add('AppsLaunchBlockList', $getValue.additionalProperties.appsLaunchBlockList)
        }
        if ($getValue.additionalProperties.compliantAppsList)
        {
            $results.Add('CompliantAppsList', $getValue.additionalProperties.compliantAppsList)
        }
        if ($getValue.additionalProperties.kioskModeApps)
        {
            $results.Add('KioskModeApps', $getValue.additionalProperties.kioskModeApps)
        }

        $myAssignments = @()
        $myAssignments += Get-MgDeviceManagementPolicyAssignments -DeviceManagementPolicyId $getValue.Id -Repository 'deviceConfigurations'
        $results.Add('Assignments', $myAssignments)

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
        [Parameter(Mandatory = $true)]
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
        $ManagedIdentity
    )

    try
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters `
            -ProfileName 'beta'
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


    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating {$DisplayName}"
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $CreateParameters = ([Hashtable]$PSBoundParameters).clone()
        $CreateParameters = Rename-M365DSCCimInstanceODataParameter -Properties $CreateParameters

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
        $policy = New-MgDeviceManagementDeviceConfiguration @CreateParameters
        $assignmentsHash = @()
        foreach ($assignment in $Assignments)
        {
            $assignmentsHash += Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignment
        }

        if ($policy.id)
        {
            Update-MgDeviceManagementPolicyAssignments -DeviceManagementPolicyId $policy.id `
                -Targets $assignmentsHash `
                -Repository deviceConfigurations
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating {$DisplayName}"
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $UpdateParameters = ([Hashtable]$PSBoundParameters).clone()
        $UpdateParameters = Rename-M365DSCCimInstanceODataParameter -Properties $UpdateParameters

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
        Update-MgDeviceManagementDeviceConfiguration @UpdateParameters `
            -DeviceConfigurationId $currentInstance.Id
        $assignmentsHash = @()
        foreach ($assignment in $Assignments)
        {
            $assignmentsHash += Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignment
        }
        Update-MgDeviceManagementPolicyAssignments -DeviceManagementPolicyId $currentInstance.id `
            -Targets $assignmentsHash `
            -Repository deviceConfigurations
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing {$DisplayName}"

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
        [Parameter(Mandatory = $true)]
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

    Write-Verbose -Message "Testing configuration of {$id}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()

    if ($CurrentValues.Ensure -ne $PSBoundParameters.Ensure)
    {
        Write-Verbose -Message "Test-TargetResource returned $false"
        return $false
    }
    $testResult = $true

    foreach ($key in $PSBoundParameters.Keys)
    {
        if ($PSBoundParameters[$key].getType().Name -like '*CimInstance*')
        {

            $CIMArraySource = @()
            $CIMArrayTarget = @()
            $CIMArraySource += $PSBoundParameters[$key]
            $CIMArrayTarget += $CurrentValues.$key
            if ($CIMArraySource.count -ne $CIMArrayTarget.count)
            {
                Write-Verbose -Message "Configuration drift:Number of items does not match: Source=$($CIMArraySource.count) Target=$($CIMArrayTarget.count)"
                $testResult = $false
                break
            }
            $i = 0
            foreach ($item in $CIMArraySource )
            {
                $testResult = Compare-M365DSCComplexObject `
                    -Source (Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $CIMArraySource[$i]) `
                    -Target ($CIMArrayTarget[$i])

                $i++
                if (-Not $testResult)
                {
                    $testResult = $false
                    break
                }
            }
            if (-Not $testResult)
            {
                $testResult = $false
                break
            }

            $ValuesToCheck.Remove($key) | Out-Null
        }
    }

    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null
    $ValuesToCheck.Remove('Id') | Out-Null

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

    #Convert any DateTime to String
    foreach ($key in $ValuesToCheck.Keys)
    {
        if (($null -ne $CurrentValues[$key]) `
                -and ($CurrentValues[$key].getType().Name -eq 'DateTime'))
        {
            $CurrentValues[$key] = $CurrentValues[$key].toString()
        }
    }

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
            Write-Host "    |---[$i/$($getValue.Count)] $($config.id)" -NoNewline
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
        Write-Host $Global:M365DSCEmojiRedX

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

function Get-M365DSCDRGComplexTypeToHashtable
{
    [CmdletBinding()]
    param
    (
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
        if ($results.count -eq 0)
        {
            return $null
        }
        return $results
    }

    $results = @{}
    $keys = $ComplexObject | Get-Member | Where-Object -FilterScript { $_.MemberType -eq 'Property' -and $_.Name -ne 'AdditionalProperties' }

    foreach ($key in $keys)
    {
        if ($ComplexObject.$($key.Name))
        {
            $results.Add($key.Name, $ComplexObject.$($key.Name))
        }
    }
    if ($results.count -eq 0)
    {
        return $null
    }
    return $results
}

function Get-M365DSCDRGComplexTypeToString
{
    [CmdletBinding()]
    #[OutputType([System.String])]
    param
    (
        [Parameter()]
        $ComplexObject,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CIMInstanceName,

        [Parameter()]
        [System.String]
        $Whitespace = '',

        [Parameter()]
        [switch]
        $isArray = $false
    )
    if ($null -eq $ComplexObject)
    {
        return $null
    }

    #If ComplexObject  is an Array
    if ($ComplexObject.GetType().FullName -like '*[[\]]')
    {
        $currentProperty = @()
        foreach ($item in $ComplexObject)
        {
            $currentProperty += Get-M365DSCDRGComplexTypeToString `
                -ComplexObject $item `
                -isArray:$true `
                -CIMInstanceName $CIMInstanceName `
                -Whitespace '                '

        }
        if ([string]::IsNullOrEmpty($currentProperty))
        {
            return $null
        }
        return $currentProperty

    }

    #If ComplexObject is a single CIM Instance
    if (-Not (Test-M365DSCComplexObjectHasValues -ComplexObject $ComplexObject))
    {
        return $null
    }
    $currentProperty = ''
    if ($isArray)
    {
        $currentProperty += "`r`n"
    }
    $currentProperty += "$whitespace`MSFT_$CIMInstanceName{`r`n"
    $keyNotNull = 0
    foreach ($key in $ComplexObject.Keys)
    {
        if ($ComplexObject[$key])
        {
            $keyNotNull++

            if ($ComplexObject[$key].GetType().FullName -like 'Microsoft.Graph.PowerShell.Models.*')
            {
                $hashPropertyType = $ComplexObject[$key].GetType().Name.tolower()
                $hashProperty = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject[$key]

                if (Test-M365DSCComplexObjectHasValues -ComplexObject $hashProperty)
                {
                    $Whitespace += '            '
                    if (-not $isArray)
                    {
                        $currentProperty += '                ' + $key + ' = '
                    }
                    $currentProperty += Get-M365DSCDRGComplexTypeToString `
                        -ComplexObject $hashProperty `
                        -CIMInstanceName $hashPropertyType `
                        -Whitespace $Whitespace
                }
            }
            else
            {
                if (-not $isArray)
                {
                    $Whitespace = '            '
                }
                $currentProperty += Get-M365DSCDRGSimpleObjectTypeToString -Key $key -Value $ComplexObject[$key] -Space ($Whitespace + '    ')
            }
        }
    }
    $currentProperty += '            }'

    if ($keyNotNull -eq 0)
    {
        $currentProperty = $null
    }

    return $currentProperty
}

function Test-M365DSCComplexObjectHasValues
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $ComplexObject
    )

    $keys = $ComplexObject.keys
    $hasValue = $false
    foreach ($key in $keys)
    {
        if ($ComplexObject[$key])
        {
            if ($ComplexObject[$key].GetType().FullName -like 'Microsoft.Graph.PowerShell.Models.*')
            {
                $hash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject[$key]
                if (-Not $hash)
                {
                    return $false
                }
                $hasValue = Test-M365DSCComplexObjectHasValues -ComplexObject ($hash)
            }
            else
            {
                $hasValue = $true
                return $hasValue
            }
        }
    }
    return $hasValue
}

function Get-M365DSCDRGSimpleObjectTypeToString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
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
            foreach ($item in $Value)
            {
                switch -Wildcard ($item.GetType().Fullname )
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

function Rename-M365DSCCimInstanceODataParameter
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $Properties
    )

    $CIMparameters = $Properties.getEnumerator() | Where-Object -FilterScript { $_.value.GetType().Fullname -like '*CimInstance*' }
    foreach ($CIMParam in $CIMparameters)
    {
        if ($CIMParam.value.GetType().Fullname -like '*[[\]]')
        {
            $CIMvalues = @()
            foreach ($item in $CIMParam.value)
            {
                $CIMHash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
                $keys = ($CIMHash.clone()).keys
                if ($keys -contains 'odataType')
                {
                    $CIMHash.add('@odata.type', $CIMHash.odataType)
                    $CIMHash.remove('odataType')
                }
                $CIMvalues += $CIMHash
            }
            $Properties.($CIMParam.key) = $CIMvalues
        }
        else
        {
            $CIMHash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $CIMParam.value
            $keys = ($CIMHash.clone()).keys
            if ($keys -contains 'odataType')
            {
                $CIMHash.add('@odata.type', $CIMHash.odataType)
                $CIMHash.remove('odataType')
                $Properties.($CIMParam.key) = $CIMHash
            }
        }
    }
    return $Properties
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

function Compare-M365DSCComplexObject
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter()]
        [System.Collections.Hashtable]
        $Source,

        [Parameter()]
        [System.Collections.Hashtable]
        $Target
    )

    $keys = $Source.Keys | Where-Object -FilterScript { $_ -ne 'PSComputerName' }
    foreach ($key in $keys)
    {
        Write-Verbose -Message "Comparing key: {$key}"
        $skey = $key
        if ($key -eq 'odataType')
        {
            $skey = '@odata.type'
        }

        #Marking Target[key] to null if empty complex object or array
        if ($null -ne $Target[$key])
        {
            switch -Wildcard ($Target[$key].getType().Fullname )
            {
                'Microsoft.Graph.PowerShell.Models.*'
                {
                    $hashProperty = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Target[$key]
                    if (-not (Test-M365DSCComplexObjectHasValues -ComplexObject $hashProperty))
                    {
                        $Target[$key] = $null
                    }
                }
                '*[[\]]'
                {
                    if ($Target[$key].count -eq 0)
                    {
                        $Target[$key] = $null
                    }
                }
            }
        }
        $sourceValue = $Source[$key]
        $targetValue = $Target[$key]
        #One of the item is null
        if (($null -eq $Source[$skey]) -xor ($null -eq $Target[$key]))
        {
            if ($null -eq $Source[$skey])
            {
                $sourceValue = 'null'
            }

            if ($null -eq $Target[$key])
            {
                $targetValue = 'null'
            }
            Write-Verbose -Message "Configuration drift - key: $key Source{$sourceValue} Target{$targetValue}"
            return $false
        }
        #Both source and target aren't null or empty
        if (($null -ne $Source[$skey]) -and ($null -ne $Target[$key]))
        {
            if ($Source[$skey].getType().FullName -like '*CimInstance*')
            {
                #Recursive call for complex object
                $compareResult = Compare-M365DSCComplexObject `
                    -Source (Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Source[$skey]) `
                    -Target (Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Target[$key])

                if (-not $compareResult)
                {
                    Write-Verbose -Message "Configuration drift - key: $key Source{$sourceValue} Target{$targetValue}"
                    return $false
                }
            }
            else
            {
                #Simple object comparison
                $referenceObject = $Target[$key]
                $differenceObject = $Source[$skey]

                $compareResult = Compare-Object `
                    -ReferenceObject ($referenceObject) `
                    -DifferenceObject ($differenceObject)

                if ($null -ne $compareResult)
                {
                    Write-Verbose -Message "Configuration drift - key: $key Source{$sourceValue} Target{$targetValue}"
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
    param
    (
        [Parameter(Mandatory = 'true')]
        $ComplexObject
    )

    if ($ComplexObject.getType().Fullname -like '*[[\]]')
    {
        $results = @()
        foreach ($item in $ComplexObject)
        {
            $hash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
            if (Test-M365DSCComplexObjectHasValues -ComplexObject $hash)
            {
                $results += $hash
            }
        }
        if ($results.count -eq 0)
        {
            return $null
        }
        return $Results
    }
    $hashComplexObject = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject
    if ($hashComplexObject)
    {
        $results = $hashComplexObject.clone()
        $keys = $hashComplexObject.Keys | Where-Object -FilterScript { $_ -ne 'PSComputerName' }
        foreach ($key in $keys)
        {
            if (($null -ne $hashComplexObject[$key]) -and ($hashComplexObject[$key].getType().Fullname -like '*CimInstance*'))
            {
                $results[$key] = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $hashComplexObject[$key]
            }
            if ($null -eq $results[$key])
            {
                $results.remove($key) | Out-Null
            }

        }
    }
    return $results
}

function Get-MgDeviceManagementPolicyAssignments
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = 'true')]
        [System.String]
        $DeviceManagementPolicyId,

        [Parameter()]
        [ValidateSet('deviceCompliancePolicies', 'intents', 'configurationPolicies', 'deviceConfigurations')]
        [System.String]
        $Repository = 'configurationPolicies',

        [Parameter()]
        [ValidateSet('v1.0', 'beta')]
        [System.String]
        $APIVersion = 'beta'
    )
    try
    {
        $deviceManagementPolicyAssignments = @()

        $Uri = "https://graph.microsoft.com/$APIVersion/deviceManagement/$Repository/$DeviceManagementPolicyId/assignments"
        $results = Invoke-MgGraphRequest -Method GET -Uri $Uri -ErrorAction Stop
        foreach ($result in $results.value.target)
        {
            $deviceManagementPolicyAssignments += @{
                dataType                                   = $result.'@odata.type'
                groupId                                    = $result.groupId
                collectionId                               = $result.collectionId
                deviceAndAppManagementAssignmentFilterType = $result.deviceAndAppManagementAssignmentFilterType
                deviceAndAppManagementAssignmentFilterId   = $result.deviceAndAppManagementAssignmentFilterId
            }
        }

        while ($results.'@odata.nextLink')
        {
            $Uri = $results.'@odata.nextLink'
            $results = Invoke-MgGraphRequest -Method GET -Uri $Uri -ErrorAction Stop
            foreach ($result in $results.value.target)
            {
                $deviceManagementPolicyAssignments += @{
                    dataType                                   = $result.'@odata.type'
                    groupId                                    = $result.groupId
                    collectionId                               = $result.collectionId
                    deviceAndAppManagementAssignmentFilterType = $result.deviceAndAppManagementAssignmentFilterType
                    deviceAndAppManagementAssignmentFilterId   = $result.deviceAndAppManagementAssignmentFilterId
                }
            }
        }
        return $deviceManagementPolicyAssignments
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $null
    }
}

function Update-MgDeviceManagementPolicyAssignments
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = 'true')]
        [System.String]
        $DeviceManagementPolicyId,

        [Parameter()]
        [Array]
        $Targets,

        [Parameter()]
        [ValidateSet('deviceCompliancePolicies', 'intents', 'configurationPolicies', 'deviceConfigurations')]
        [System.String]
        $Repository = 'configurationPolicies',

        [Parameter()]
        [ValidateSet('v1.0', 'beta')]
        [System.String]
        $APIVersion = 'beta'
    )

    try
    {
        $deviceManagementPolicyAssignments = @()

        $Uri = "https://graph.microsoft.com/$APIVersion/deviceManagement/$Repository/$DeviceManagementPolicyId/assign"

        foreach ($target in $targets)
        {
            $formattedTarget = @{'@odata.type' = $target.dataType }
            if ($target.groupId)
            {
                $formattedTarget.Add('groupId', $target.groupId)
            }
            if ($target.collectionId)
            {
                $formattedTarget.Add('collectionId', $target.collectionId)
            }
            if ($target.deviceAndAppManagementAssignmentFilterType)
            {
                $formattedTarget.Add('deviceAndAppManagementAssignmentFilterType', $target.deviceAndAppManagementAssignmentFilterType)
            }
            if ($target.deviceAndAppManagementAssignmentFilterId)
            {
                $formattedTarget.Add('deviceAndAppManagementAssignmentFilterId', $target.deviceAndAppManagementAssignmentFilterId)
            }
            $deviceManagementPolicyAssignments += @{'target' = $formattedTarget }
        }
        $body = @{'assignments' = $deviceManagementPolicyAssignments } | ConvertTo-Json -Depth 20
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

Export-ModuleMember -Function *-TargetResource
