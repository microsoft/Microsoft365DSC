Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneAppProtectionPolicyAndroid'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String[]]
        $AllowedAndroidDeviceModels,

        [Parameter()]
        [System.Int32]
        $AllowedOutboundClipboardSharingExceptionLength,

        [Parameter()]
        [System.Boolean]
        $BiometricAuthenticationBlocked,

        [Parameter()]
        [System.Int32]
        $BlockAfterCompanyPortalUpdateDeferralInDays,

        [Parameter()]
        [System.Boolean]
        $BlockDataIngestionIntoOrganizationDocuments,

        [Parameter()]
        [System.Boolean]
        $ConnectToVpnOnLaunch,

        [Parameter()]
        [System.String]
        $CustomDialerAppDisplayName,

        [Parameter()]
        [System.String]
        $CustomDialerAppPackageId,

        [Parameter()]
        [System.Boolean]
        $DeviceLockRequired,

        [Parameter()]
        [System.Boolean]
        $FingerprintAndBiometricEnabled,

        [Parameter()]
        [System.Boolean]
        $KeyboardsRestricted,

        [Parameter()]
        [System.String]
        $MessagingRedirectAppDisplayName,

        [Parameter()]
        [System.String]
        $MessagingRedirectAppPackageId,

        [Parameter()]
        [System.String]
        $MinimumWipePatchVersion,

        [Parameter()]
        [System.Int32]
        $PreviousPinBlockCount,

        [Parameter()]
        [System.Int32]
        $WarnAfterCompanyPortalUpdateDeferralInDays,

        [Parameter()]
        [System.Int32]
        $WipeAfterCompanyPortalUpdateDeferralInDays,

        [Parameter()]
        [System.String[]]
        $Alloweddataingestionlocations,

        [Parameter()]
        [System.String]
        [ValidateSet("block", "wipe", "warn", "blockWhenSettingIsSupported")]
        $AppActionIfAndroidDeviceManufacturerNotAllowed,

        [Parameter()]
        [System.String]
        [ValidateSet("block", "wipe", "warn", "blockWhenSettingIsSupported")]
        $AppActionIfAndroidDeviceModelNotAllowed,

        [Parameter()]
        [System.String]
        [ValidateSet("block", "wipe", "warn", "blockWhenSettingIsSupported")]
        $AppActionIfAndroidSafetyNetAppsVerificationFailed,

        [Parameter()]
        [System.String]
        [ValidateSet("block", "wipe", "warn", "blockWhenSettingIsSupported")]
        $AppActionIfAndroidSafetyNetDeviceAttestationFailed,

        [Parameter()]
        [System.String]
        [ValidateSet("block", "wipe", "warn", "blockWhenSettingIsSupported")]
        $AppActionIfDeviceComplianceRequired,

        [Parameter()]
        [System.String]
        [ValidateSet("block", "wipe", "warn", "blockWhenSettingIsSupported")]
        $AppActionIfDeviceLockNotSet,

        [Parameter()]
        [System.String]
        [ValidateSet("block", "wipe", "warn", "blockWhenSettingIsSupported")]
        $AppActionIfMaximumPinRetriesExceeded,

        [Parameter()]
        [System.String]
        [ValidateSet("block", "wipe", "warn", "blockWhenSettingIsSupported")]
        $AppActionIfUnableToAuthenticateUser,

        [Parameter()]
        [System.String]
        [ValidateSet("block", "wipe", "warn", "blockWhenSettingIsSupported")]
        $MobileThreatDefenseRemediationAction,

        [Parameter()]
        [ValidateSet("allApps", "managedApps", "customApp", "blocked")]
        [System.String]
        $DialerRestrictionLevel,

        [Parameter()]
        [ValidateSet("notConfigured", "secured", "low", "medium", "high")]
        [System.String]
        $MaximumAllowedDeviceThreatLevel,

        [Parameter()]
        [ValidateSet("allow", "blockOrganizationalData", "block")]
        [System.String]
        $NotificationRestriction,

        [Parameter()]
        [ValidateSet("anyApp", "anyManagedApp", "specificApps", "blocked")]
        [System.String]
        $ProtectedMessagingRedirectAppType,

        [Parameter()]
        [ValidateSet("none", "enabled")]
        [System.String]
        $RequiredAndroidSafetyNetAppsVerificationType,

        [Parameter()]
        [ValidateSet("none", "basicIntegrity", "basicIntegrityAndDeviceCertification")]
        [System.String]
        $RequiredAndroidSafetyNetDeviceAttestationType,

        [Parameter()]
        [ValidateSet("basic", "hardwareBacked")]
        [System.String]
        $RequiredAndroidSafetyNetEvaluationType,

        [Parameter()]
        [ValidateSet("unspecified", "unmanaged", "mdm", "androidEnterprise", "androidEnterpriseDedicatedDevicesWithAzureAdSharedMode", "androidOpenSourceProjectUserAssociated", "androidOpenSourceProjectUserless", "unknownFutureValue")]
        [System.String]
        $TargetedAppManagementLevels,

        [Parameter()]
        [System.String[]]
        $ApprovedKeyboards,

        [Parameter()]
        [System.String[]]
        $ExemptedAppPackages,

        [Parameter()]
        [System.String]
        $PeriodOfflineBeforeAccessCheck,

        [Parameter()]
        [System.String]
        $PeriodOnlineBeforeAccessCheck,

        [Parameter()]
        [System.String]
        $AllowedInboundDataTransferSources,

        [Parameter()]
        [System.String]
        $AllowedOutboundDataTransferDestinations,

        [Parameter()]
        [System.Boolean]
        $OrganizationalCredentialsRequired,

        [Parameter()]
        [System.String]
        $AllowedOutboundClipboardSharingLevel,

        [Parameter()]
        [System.Boolean]
        $DataBackupBlocked,

        [Parameter()]
        [System.Boolean]
        $DeviceComplianceRequired,

        [Parameter()]
        [System.Boolean]
        $ManagedBrowserToOpenLinksRequired,

        [Parameter()]
        [System.Boolean]
        $SaveAsBlocked,

        [Parameter()]
        [System.String]
        $PeriodOfflineBeforeWipeIsEnforced,

        [Parameter()]
        [System.Boolean]
        $PinRequired,

        [Parameter()]
        [System.Boolean]
        $DisableAppPinIfDevicePinIsSet,

        [Parameter()]
        [System.UInt32]
        $MaximumPinRetries,

        [Parameter()]
        [System.Boolean]
        $SimplePinBlocked,

        [Parameter()]
        [System.UInt32]
        $MinimumPinLength,

        [Parameter()]
        [System.String]
        $PinCharacterSet,

        [Parameter()]
        [System.String[]]
        $AllowedDataStorageLocations,

        [Parameter()]
        [System.Boolean]
        $ContactSyncBlocked,

        [Parameter()]
        [System.String]
        $PeriodBeforePinReset,

        [Parameter()]
        [System.Boolean]
        $PrintBlocked,

        [Parameter()]
        [System.Boolean]
        $RequireClass3Biometrics,

        [Parameter()]
        [System.Boolean]
        $RequirePinAfterBiometricChange,

        [Parameter()]
        [System.Boolean]
        $FingerprintBlocked,

        [Parameter()]
        [System.Boolean]
        $DisableAppEncryptionIfDeviceEncryptionIsEnabled,

        [Parameter()]
        [System.String]
        $CustomBrowserDisplayName,

        [Parameter()]
        [System.String]
        $CustomBrowserPackageId,

        [Parameter()]
        [System.String[]]
        $Apps,

        [Parameter()]
        [ValidateSet('allApps', 'allMicrosoftApps', 'allCoreMicrosoftApps', 'selectedPublicApps' )]
        [System.String]
        $AppGroupType,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter()]
        [System.String]
        [ValidateSet('notConfigured', 'microsoftEdge')]
        $ManagedBrowser,

        [Parameter()]
        [System.String]
        $MinimumRequiredAppVersion,

        [Parameter()]
        [System.String]
        $MinimumRequiredOSVersion,

        [Parameter()]
        [System.String]
        $MinimumRequiredPatchVersion,

        [Parameter()]
        [System.String]
        $MinimumWarningAppVersion,

        [Parameter()]
        [System.String]
        $MinimumWarningOSVersion,

        [Parameter()]
        [System.String]
        $MinimumWarningPatchVersion,

        [Parameter()]
        [System.Boolean]
        $ScreenCaptureBlocked,

        [Parameter()]
        [System.Boolean]
        $EncryptAppData,

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
        [System.String]
        $Id,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration of the Intune Android App Protection Policy with Id {$Id} and DisplayName {$DisplayName}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.DisplayName -ne $DisplayName)
        {
            $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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

            $policy = $null
            if (-not [string]::IsNullOrEmpty($Id))
            {
                Write-Verbose -Message "Could not find an Intune App Protection Policy for Android with Id {$Id}"
                $policy = Get-MgBetaDeviceAppManagementAndroidManagedAppProtection -AndroidManagedAppProtectionId $Id -ErrorAction SilentlyContinue
            }

            if ($null -eq $policy)
            {
                if (-not [string]::IsNullOrEmpty($DisplayName))
                {
                    Write-Verbose -Message "Searching for Policy using DisplayName {$DisplayName}"
                    $policy = Get-MgBetaDeviceAppManagementAndroidManagedAppProtection `
                        -All `
                        -Filter "displayName eq '$DisplayName'" `
                        -ErrorAction SilentlyContinue
                }
            }

            if ($null -eq $policy)
            {
                Write-Verbose -Message "Could not find an Intune App Protection Policy for Android with Name {$DisplayName}"
                return $nullResult
            }
        }
        else
        {
            $policy = $Script:exportedInstance
        }
        $IdArray = [Array]($policy.Id)
        if ($IdArray.Length -gt 1)
        {
            throw "Multiple Policies with same displayname identified - Module currently only functions with unique names"
        }
        else
        {
            $Id = $policy.Id
        }

        $policyApps = Get-MgBetaDeviceAppManagementAndroidManagedAppProtectionApp -AndroidManagedAppProtectionId $Id

        $appsArray = @()
        if ($policy.AppGroupType -eq 'selectedPublicApps')
        {
            foreach ($app in $policyApps)
            {
                $appsArray += $app.MobileAppIdentifier.AdditionalProperties.packageId
            }
        }

        $assignmentsValues = Get-MgBetaDeviceAppManagementAndroidManagedAppProtectionAssignment -AndroidManagedAppProtectionId $policy.Id
        $assignmentResult = @()
        if ($assignmentsValues.Count -gt 0)
        {
            $assignmentResult += ConvertFrom-IntunePolicyAssignment -Assignments $assignmentsValues -IncludeDeviceFilter $true
        }

        $approvedKeyboardArray = @()
        foreach ($keyboard in $policy.approvedKeyboards)
        {
            $approvedKeyboardArray += $keyboard.Name + '|' + $keyboard.Value
        }

        $exemptedAppPackagesArray = @()
        foreach ($exemptedapppackage in $policy.exemptedAppPackages)
        {
            $exemptedAppPackagesArray += $exemptedapppackage.Name + '|' + $exemptedapppackage.Value
        }

        return @{
            AllowedAndroidDeviceModels                          = $policy.AllowedAndroidDeviceModels
            AllowedDataIngestionLocations                       = [string[]]$policy.AllowedDataIngestionLocations
            AllowedDataStorageLocations                         = [string[]]$policy.AllowedDataStorageLocations
            AllowedInboundDataTransferSources                   = [string]$policy.AllowedInboundDataTransferSources
            AllowedOutboundClipboardSharingExceptionLength      = $policy.AllowedOutboundClipboardSharingExceptionLength
            AllowedOutboundClipboardSharingLevel                = [string]$policy.AllowedOutboundClipboardSharingLevel
            AllowedOutboundDataTransferDestinations             = [string]$policy.AllowedOutboundDataTransferDestinations
            AppActionIfAndroidDeviceManufacturerNotAllowed      = [string]$policy.AppActionIfAndroidDeviceManufacturerNotAllowed
            AppActionIfAndroidDeviceModelNotAllowed             = [string]$policy.AppActionIfAndroidDeviceModelNotAllowed
            AppActionIfAndroidSafetyNetAppsVerificationFailed   = [string]$policy.AppActionIfAndroidSafetyNetAppsVerificationFailed
            AppActionIfAndroidSafetyNetDeviceAttestationFailed  = [string]$policy.AppActionIfAndroidSafetyNetDeviceAttestationFailed
            AppActionIfDeviceComplianceRequired                 = [string]$policy.AppActionIfDeviceComplianceRequired
            AppActionIfDeviceLockNotSet                         = [string]$policy.AppActionIfDeviceLockNotSet
            AppActionIfMaximumPinRetriesExceeded                = [string]$policy.AppActionIfMaximumPinRetriesExceeded
            AppActionIfUnableToAuthenticateUser                 = [string]$policy.AppActionIfUnableToAuthenticateUser
            AppGroupType                                        = $policy.AppGroupType.ToString()
            ApprovedKeyboards                                   = $approvedKeyboardArray
            Apps                                                = $appsArray
            Assignments                                         = $assignmentResult
            BiometricAuthenticationBlocked                      = $policy.BiometricAuthenticationBlocked
            BlockAfterCompanyPortalUpdateDeferralInDays         = $policy.BlockAfterCompanyPortalUpdateDeferralInDays
            BlockDataIngestionIntoOrganizationDocuments         = $policy.BlockDataIngestionIntoOrganizationDocuments
            ConnectToVpnOnLaunch                                = $policy.ConnectToVpnOnLaunch
            ContactSyncBlocked                                  = $policy.ContactSyncBlocked
            CustomBrowserDisplayName                            = $policy.CustomBrowserDisplayName
            CustomBrowserPackageId                              = $policy.CustomBrowserPackageId
            CustomDialerAppDisplayName                          = $policy.CustomDialerAppDisplayName
            CustomDialerAppPackageId                            = $policy.CustomDialerAppPackageId
            DataBackupBlocked                                   = $policy.DataBackupBlocked
            Description                                         = $policy.Description
            DeviceComplianceRequired                            = $policy.DeviceComplianceRequired
            DeviceLockRequired                                  = $policy.DeviceLockRequired
            DialerRestrictionLevel                              = [string]$policy.DialerRestrictionLevel
            DisableAppEncryptionIfDeviceEncryptionIsEnabled     = $policy.DisableAppEncryptionIfDeviceEncryptionIsEnabled
            DisableAppPinIfDevicePinIsSet                       = $policy.DisableAppPinIfDevicePinIsSet
            DisplayName                                         = $policy.DisplayName
            EncryptAppData                                      = $policy.EncryptAppData
            ExemptedAppPackages                                 = $exemptedAppPackagesArray
            FingerprintAndBiometricEnabled                      = $policy.FingerprintAndBiometricEnabled
            FingerprintBlocked                                  = $policy.FingerprintBlocked
            Id                                                  = $policy.Id
            KeyboardsRestricted                                 = $policy.KeyboardsRestricted
            ManagedBrowser                                      = $policy.ManagedBrowser.ToString()
            ManagedBrowserToOpenLinksRequired                   = $policy.ManagedBrowserToOpenLinksRequired
            MaximumAllowedDeviceThreatLevel                     = [string]$policy.MaximumAllowedDeviceThreatLevel
            MaximumPinRetries                                   = $policy.MaximumPinRetries
            MessagingRedirectAppDisplayName                     = $policy.MessagingRedirectAppDisplayName
            MessagingRedirectAppPackageId                       = $policy.MessagingRedirectAppPackageId
            MinimumPinLength                                    = $policy.MinimumPinLength
            MinimumRequiredAppVersion                           = $policy.MinimumRequiredAppVersion
            MinimumRequiredOSVersion                            = $policy.MinimumRequiredOSVersion
            MinimumRequiredPatchVersion                         = $policy.MinimumRequiredPatchVersion
            MinimumWarningAppVersion                            = $policy.MinimumWarningAppVersion
            MinimumWarningOSVersion                             = $policy.MinimumWarningOSVersion
            MinimumWarningPatchVersion                          = $policy.MinimumWarningPatchVersion
            MinimumWipePatchVersion                             = $policy.MinimumWipePatchVersion
            MobileThreatDefenseRemediationAction                = [string]$policy.MobileThreatDefenseRemediationAction
            NotificationRestriction                             = [string]$policy.NotificationRestriction
            OrganizationalCredentialsRequired                   = $policy.OrganizationalCredentialsRequired
            PeriodBeforePinReset                                = [System.Xml.XmlConvert]::ToString($policy.PeriodBeforePinReset)
            PeriodOfflineBeforeAccessCheck                      = [System.Xml.XmlConvert]::ToString($policy.PeriodOfflineBeforeAccessCheck)
            PeriodOfflineBeforeWipeIsEnforced                   = [System.Xml.XmlConvert]::ToString($policy.PeriodOfflineBeforeWipeIsEnforced)
            PeriodOnlineBeforeAccessCheck                       = [System.Xml.XmlConvert]::ToString($policy.PeriodOnlineBeforeAccessCheck)
            PinCharacterSet                                     = [string]$policy.PinCharacterSet
            PinRequired                                         = $policy.PinRequired
            PreviousPinBlockCount                               = $policy.PreviousPinBlockCount
            PrintBlocked                                        = $policy.PrintBlocked
            ProtectedMessagingRedirectAppType                   = [string]$policy.ProtectedMessagingRedirectAppType
            RequireClass3Biometrics                             = $policy.RequireClass3Biometrics
            RequiredAndroidSafetyNetAppsVerificationType        = [string]$policy.RequiredAndroidSafetyNetAppsVerificationType
            RequiredAndroidSafetyNetDeviceAttestationType       = [string]$policy.RequiredAndroidSafetyNetDeviceAttestationType
            RequiredAndroidSafetyNetEvaluationType              = [string]$policy.RequiredAndroidSafetyNetEvaluationType
            RequirePinAfterBiometricChange                      = $policy.RequirePinAfterBiometricChange
            RoleScopeTagIds                                     = $policy.RoleScopeTagIds
            SaveAsBlocked                                       = $policy.SaveAsBlocked
            ScreenCaptureBlocked                                = $policy.ScreenCaptureBlocked
            SimplePinBlocked                                    = $policy.SimplePinBlocked
            TargetedAppManagementLevels                         = [string]$policy.TargetedAppManagementLevels
            WarnAfterCompanyPortalUpdateDeferralInDays          = $policy.WarnAfterCompanyPortalUpdateDeferralInDays
            WipeAfterCompanyPortalUpdateDeferralInDays          = $policy.WipeAfterCompanyPortalUpdateDeferralInDays
            Ensure                                              = 'Present'
            Credential                                          = $Credential
            ApplicationId                                       = $ApplicationId
            ApplicationSecret                                   = $ApplicationSecret
            TenantId                                            = $TenantId
            CertificateThumbprint                               = $CertificateThumbprint
            ManagedIdentity                                     = $ManagedIdentity.IsPresent
            AccessTokens                                        = $AccessTokens
        }
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
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String[]]
        $AllowedAndroidDeviceModels,

        [Parameter()]
        [System.Int32]
        $AllowedOutboundClipboardSharingExceptionLength,

        [Parameter()]
        [System.Boolean]
        $BiometricAuthenticationBlocked,

        [Parameter()]
        [System.Int32]
        $BlockAfterCompanyPortalUpdateDeferralInDays,

        [Parameter()]
        [System.Boolean]
        $BlockDataIngestionIntoOrganizationDocuments,

        [Parameter()]
        [System.Boolean]
        $ConnectToVpnOnLaunch,

        [Parameter()]
        [System.String]
        $CustomDialerAppDisplayName,

        [Parameter()]
        [System.String]
        $CustomDialerAppPackageId,

        [Parameter()]
        [System.Boolean]
        $DeviceLockRequired,

        [Parameter()]
        [System.Boolean]
        $FingerprintAndBiometricEnabled,

        [Parameter()]
        [System.Boolean]
        $KeyboardsRestricted,

        [Parameter()]
        [System.String]
        $MessagingRedirectAppDisplayName,

        [Parameter()]
        [System.String]
        $MessagingRedirectAppPackageId,

        [Parameter()]
        [System.String]
        $MinimumWipePatchVersion,

        [Parameter()]
        [System.Int32]
        $PreviousPinBlockCount,

        [Parameter()]
        [System.Int32]
        $WarnAfterCompanyPortalUpdateDeferralInDays,

        [Parameter()]
        [System.Int32]
        $WipeAfterCompanyPortalUpdateDeferralInDays,

        [Parameter()]
        [System.String[]]
        $Alloweddataingestionlocations,

        [Parameter()]
        [System.String]
        [ValidateSet("block", "wipe", "warn", "blockWhenSettingIsSupported")]
        $AppActionIfAndroidDeviceManufacturerNotAllowed,

        [Parameter()]
        [System.String]
        [ValidateSet("block", "wipe", "warn", "blockWhenSettingIsSupported")]
        $AppActionIfAndroidDeviceModelNotAllowed,

        [Parameter()]
        [System.String]
        [ValidateSet("block", "wipe", "warn", "blockWhenSettingIsSupported")]
        $AppActionIfAndroidSafetyNetAppsVerificationFailed,

        [Parameter()]
        [System.String]
        [ValidateSet("block", "wipe", "warn", "blockWhenSettingIsSupported")]
        $AppActionIfAndroidSafetyNetDeviceAttestationFailed,

        [Parameter()]
        [System.String]
        [ValidateSet("block", "wipe", "warn", "blockWhenSettingIsSupported")]
        $AppActionIfDeviceComplianceRequired,

        [Parameter()]
        [System.String]
        [ValidateSet("block", "wipe", "warn", "blockWhenSettingIsSupported")]
        $AppActionIfDeviceLockNotSet,

        [Parameter()]
        [System.String]
        [ValidateSet("block", "wipe", "warn", "blockWhenSettingIsSupported")]
        $AppActionIfMaximumPinRetriesExceeded,

        [Parameter()]
        [System.String]
        [ValidateSet("block", "wipe", "warn", "blockWhenSettingIsSupported")]
        $AppActionIfUnableToAuthenticateUser,

        [Parameter()]
        [System.String]
        [ValidateSet("block", "wipe", "warn", "blockWhenSettingIsSupported")]
        $MobileThreatDefenseRemediationAction,

        [Parameter()]
        [ValidateSet("allApps", "managedApps", "customApp", "blocked")]
        [System.String]
        $DialerRestrictionLevel,

        [Parameter()]
        [ValidateSet("notConfigured", "secured", "low", "medium", "high")]
        [System.String]
        $MaximumAllowedDeviceThreatLevel,

        [Parameter()]
        [ValidateSet("allow", "blockOrganizationalData", "block")]
        [System.String]
        $NotificationRestriction,

        [Parameter()]
        [ValidateSet("anyApp", "anyManagedApp", "specificApps", "blocked")]
        [System.String]
        $ProtectedMessagingRedirectAppType,

        [Parameter()]
        [ValidateSet("none", "enabled")]
        [System.String]
        $RequiredAndroidSafetyNetAppsVerificationType,

        [Parameter()]
        [ValidateSet("none", "basicIntegrity", "basicIntegrityAndDeviceCertification")]
        [System.String]
        $RequiredAndroidSafetyNetDeviceAttestationType,

        [Parameter()]
        [ValidateSet("basic", "hardwareBacked")]
        [System.String]
        $RequiredAndroidSafetyNetEvaluationType,

        [Parameter()]
        [ValidateSet("unspecified", "unmanaged", "mdm", "androidEnterprise", "androidEnterpriseDedicatedDevicesWithAzureAdSharedMode", "androidOpenSourceProjectUserAssociated", "androidOpenSourceProjectUserless", "unknownFutureValue")]
        [System.String]
        $TargetedAppManagementLevels,

        [Parameter()]
        [System.String[]]
        $ApprovedKeyboards,

        [Parameter()]
        [System.String[]]
        $ExemptedAppPackages,

        [Parameter()]
        [System.String]
        $PeriodOfflineBeforeAccessCheck,

        [Parameter()]
        [System.String]
        $PeriodOnlineBeforeAccessCheck,

        [Parameter()]
        [System.String]
        $AllowedInboundDataTransferSources,

        [Parameter()]
        [System.String]
        $AllowedOutboundDataTransferDestinations,

        [Parameter()]
        [System.Boolean]
        $OrganizationalCredentialsRequired,

        [Parameter()]
        [System.String]
        $AllowedOutboundClipboardSharingLevel,

        [Parameter()]
        [System.Boolean]
        $DataBackupBlocked,

        [Parameter()]
        [System.Boolean]
        $DeviceComplianceRequired,

        [Parameter()]
        [System.Boolean]
        $ManagedBrowserToOpenLinksRequired,

        [Parameter()]
        [System.Boolean]
        $SaveAsBlocked,

        [Parameter()]
        [System.String]
        $PeriodOfflineBeforeWipeIsEnforced,

        [Parameter()]
        [System.Boolean]
        $PinRequired,

        [Parameter()]
        [System.Boolean]
        $DisableAppPinIfDevicePinIsSet,

        [Parameter()]
        [System.UInt32]
        $MaximumPinRetries,

        [Parameter()]
        [System.Boolean]
        $SimplePinBlocked,

        [Parameter()]
        [System.UInt32]
        $MinimumPinLength,

        [Parameter()]
        [System.String]
        $PinCharacterSet,

        [Parameter()]
        [System.String[]]
        $AllowedDataStorageLocations,

        [Parameter()]
        [System.Boolean]
        $ContactSyncBlocked,

        [Parameter()]
        [System.String]
        $PeriodBeforePinReset,

        [Parameter()]
        [System.Boolean]
        $PrintBlocked,

        [Parameter()]
        [System.Boolean]
        $RequireClass3Biometrics,

        [Parameter()]
        [System.Boolean]
        $RequirePinAfterBiometricChange,

        [Parameter()]
        [System.Boolean]
        $FingerprintBlocked,

        [Parameter()]
        [System.Boolean]
        $DisableAppEncryptionIfDeviceEncryptionIsEnabled,

        [Parameter()]
        [System.String]
        $CustomBrowserDisplayName,

        [Parameter()]
        [System.String]
        $CustomBrowserPackageId,

        [Parameter()]
        [System.String[]]
        $Apps,

        [Parameter()]
        [ValidateSet('allApps', 'allMicrosoftApps', 'allCoreMicrosoftApps', 'selectedPublicApps' )]
        [System.String]
        $AppGroupType,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter()]
        [System.String]
        [ValidateSet('notConfigured', 'microsoftEdge')]
        $ManagedBrowser,

        [Parameter()]
        [System.String]
        $MinimumRequiredAppVersion,

        [Parameter()]
        [System.String]
        $MinimumRequiredOSVersion,

        [Parameter()]
        [System.String]
        $MinimumRequiredPatchVersion,

        [Parameter()]
        [System.String]
        $MinimumWarningAppVersion,

        [Parameter()]
        [System.String]
        $MinimumWarningOSVersion,

        [Parameter()]
        [System.String]
        $MinimumWarningPatchVersion,

        [Parameter()]
        [System.Boolean]
        $ScreenCaptureBlocked,

        [Parameter()]
        [System.Boolean]
        $EncryptAppData,

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
        [System.String]
        $Id,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Setting configuration of the Intune App Protection Policy for Android with Id {$Id} and DisplayName {$DisplayName}"

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

    $currentPolicy = Get-TargetResource @PSBoundParameters

    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    #rebuild array as a MicrosoftGraphKeyValuePair hash table for ApprovedKeyboards
    $myApprovedKeyboards = @()
    foreach ($keyboard in $ApprovedKeyboards)
    {
        $myApprovedKeyboards += @{
            name = $keyboard.Split('|')[0]
            value = $keyboard.Split('|')[1]
        }
    }
    $BoundParameters.ApprovedKeyboards = $myApprovedKeyboards

    $myExemptedAppPackages = @()
    foreach ($exemptedAppPackage in $ExemptedAppPackages)
    {
        $myExemptedAppPackages += @{
            name = $exemptedAppPackage.Split('|')[0]
            value = $exemptedAppPackage.Split('|')[1]
        }
    }

    $durationParameters = @(
        'PeriodOfflineBeforeAccessCheck',
        'PeriodOnlineBeforeAccessCheck',
        'PeriodOfflineBeforeWipeIsEnforced',
        'PeriodBeforePinReset'
    )
    foreach ($duration in $durationParameters)
    {
        if (-not [String]::IsNullOrEmpty($BoundParameters.$duration))
        {
            if ($BoundParameters.$duration.Startswith('P'))
            {
                $timespan = [System.Xml.XmlConvert]::ToTimeSpan($BoundParameters.$duration)
            }
            else
            {
                $timespan = [TimeSpan]$BoundParameters.$duration
            }
            $BoundParameters.$duration = $timespan
        }
    }

    # Set the managedbrowser values
    $ManagedBrowserValuesHash = Set-ManagedBrowserValues @BoundParameters
    $BoundParameters.ManagedBrowser = $ManagedBrowserValuesHash.ManagedBrowser
    $BoundParameters.ManagedBrowserToOpenLinksRequired = $ManagedBrowserValuesHash.ManagedBrowserToOpenLinksRequired
    $BoundParameters.CustomBrowserDisplayName = $ManagedBrowserValuesHash.CustomBrowserDisplayName
    $BoundParameters.CustomBrowserPackageId = $ManagedBrowserValuesHash.CustomBrowserPackageId

    if ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Absent')
    {
        $createParameters = ([Hashtable]$BoundParameters).Clone()
        $createParameters.Remove('Id') | Out-Null
        $createParameters.Remove('Assignments') | Out-Null
        $createParameters.Remove('Apps') | Out-Null

        Write-Verbose -Message "Creating new Android App Protection Policy {$DisplayName}"
        $newpolicy = New-MgBetaDeviceAppManagementAndroidManagedAppProtection @createParameters

        if ($newPolicy.Id)
        {
            Write-Verbose -Message "Update targetApps for Android App Protection Policy with Id {$($newPolicy.Id)} and DisplayName {$DisplayName}"
            $targetApps = Get-IntuneAppProtectionPolicyAndroidAppsToHashtable -Apps $Apps -AppGroupType $AppGroupType
            $Url = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/deviceAppManagement/androidManagedAppProtections('$($newPolicy.Id)')/targetApps"
            Invoke-MgGraphRequest -Method POST -Uri $Url -Body $targetApps

            $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
            Update-DeviceConfigurationPolicyAssignment `
                -DeviceConfigurationPolicyId $newPolicy.Id `
                -Targets $assignmentsHash `
                -Repository 'deviceAppManagement/androidManagedAppProtections'
        }
    }
    elseif ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
    {
        $updateParameters = ([Hashtable]$BoundParameters).Clone()
        $updateParameters.Remove('Id') | Out-Null
        $updateParameters.Remove('Assignments') | Out-Null
        $updateParameters.Remove('Apps') | Out-Null

        Write-Verbose -Message "Updating existing Android App Protection Policy {$DisplayName}"
        Update-MgBetaDeviceAppManagementAndroidManagedAppProtection -AndroidManagedAppProtectionId $currentPolicy.Id -BodyParameter $updateParameters

        Write-Verbose -Message "Update targetApps for Android App Protection Policy with Id {$($currentPolicy.Id)} and DisplayName {$DisplayName}"
        $targetApps = Get-IntuneAppProtectionPolicyAndroidAppsToHashtable -Apps $Apps -AppGroupType $AppGroupType
        $Url = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/deviceAppManagement/androidManagedAppProtections('$($currentPolicy.Id)')/targetApps"
        Invoke-MgGraphRequest -Method POST -Uri $Url -Body $targetApps

        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        Update-DeviceConfigurationPolicyAssignment `
            -DeviceConfigurationPolicyId $currentPolicy.Id `
            -Targets $assignmentsHash `
            -Repository 'deviceAppManagement/androidManagedAppProtections'
    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Android App Protection Policy {$DisplayName}"
        Remove-MgBetaDeviceAppManagementAndroidManagedAppProtection -AndroidManagedAppProtectionId $currentPolicy.id
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
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String[]]
        $AllowedAndroidDeviceModels,

        [Parameter()]
        [System.Int32]
        $AllowedOutboundClipboardSharingExceptionLength,

        [Parameter()]
        [System.Boolean]
        $BiometricAuthenticationBlocked,

        [Parameter()]
        [System.Int32]
        $BlockAfterCompanyPortalUpdateDeferralInDays,

        [Parameter()]
        [System.Boolean]
        $BlockDataIngestionIntoOrganizationDocuments,

        [Parameter()]
        [System.Boolean]
        $ConnectToVpnOnLaunch,

        [Parameter()]
        [System.String]
        $CustomDialerAppDisplayName,

        [Parameter()]
        [System.String]
        $CustomDialerAppPackageId,

        [Parameter()]
        [System.Boolean]
        $DeviceLockRequired,

        [Parameter()]
        [System.Boolean]
        $FingerprintAndBiometricEnabled,

        [Parameter()]
        [System.Boolean]
        $KeyboardsRestricted,

        [Parameter()]
        [System.String]
        $MessagingRedirectAppDisplayName,

        [Parameter()]
        [System.String]
        $MessagingRedirectAppPackageId,

        [Parameter()]
        [System.String]
        $MinimumWipePatchVersion,

        [Parameter()]
        [System.Int32]
        $PreviousPinBlockCount,

        [Parameter()]
        [System.Int32]
        $WarnAfterCompanyPortalUpdateDeferralInDays,

        [Parameter()]
        [System.Int32]
        $WipeAfterCompanyPortalUpdateDeferralInDays,

        [Parameter()]
        [System.String[]]
        $Alloweddataingestionlocations,

        [Parameter()]
        [System.String]
        [ValidateSet("block", "wipe", "warn", "blockWhenSettingIsSupported")]
        $AppActionIfAndroidDeviceManufacturerNotAllowed,

        [Parameter()]
        [System.String]
        [ValidateSet("block", "wipe", "warn", "blockWhenSettingIsSupported")]
        $AppActionIfAndroidDeviceModelNotAllowed,

        [Parameter()]
        [System.String]
        [ValidateSet("block", "wipe", "warn", "blockWhenSettingIsSupported")]
        $AppActionIfAndroidSafetyNetAppsVerificationFailed,

        [Parameter()]
        [System.String]
        [ValidateSet("block", "wipe", "warn", "blockWhenSettingIsSupported")]
        $AppActionIfAndroidSafetyNetDeviceAttestationFailed,

        [Parameter()]
        [System.String]
        [ValidateSet("block", "wipe", "warn", "blockWhenSettingIsSupported")]
        $AppActionIfDeviceComplianceRequired,

        [Parameter()]
        [System.String]
        [ValidateSet("block", "wipe", "warn", "blockWhenSettingIsSupported")]
        $AppActionIfDeviceLockNotSet,

        [Parameter()]
        [System.String]
        [ValidateSet("block", "wipe", "warn", "blockWhenSettingIsSupported")]
        $AppActionIfMaximumPinRetriesExceeded,

        [Parameter()]
        [System.String]
        [ValidateSet("block", "wipe", "warn", "blockWhenSettingIsSupported")]
        $AppActionIfUnableToAuthenticateUser,

        [Parameter()]
        [System.String]
        [ValidateSet("block", "wipe", "warn", "blockWhenSettingIsSupported")]
        $MobileThreatDefenseRemediationAction,

        [Parameter()]
        [ValidateSet("allApps", "managedApps", "customApp", "blocked")]
        [System.String]
        $DialerRestrictionLevel,

        [Parameter()]
        [ValidateSet("notConfigured", "secured", "low", "medium", "high")]
        [System.String]
        $MaximumAllowedDeviceThreatLevel,

        [Parameter()]
        [ValidateSet("allow", "blockOrganizationalData", "block")]
        [System.String]
        $NotificationRestriction,

        [Parameter()]
        [ValidateSet("anyApp", "anyManagedApp", "specificApps", "blocked")]
        [System.String]
        $ProtectedMessagingRedirectAppType,

        [Parameter()]
        [ValidateSet("none", "enabled")]
        [System.String]
        $RequiredAndroidSafetyNetAppsVerificationType,

        [Parameter()]
        [ValidateSet("none", "basicIntegrity", "basicIntegrityAndDeviceCertification")]
        [System.String]
        $RequiredAndroidSafetyNetDeviceAttestationType,

        [Parameter()]
        [ValidateSet("basic", "hardwareBacked")]
        [System.String]
        $RequiredAndroidSafetyNetEvaluationType,

        [Parameter()]
        [ValidateSet("unspecified", "unmanaged", "mdm", "androidEnterprise", "androidEnterpriseDedicatedDevicesWithAzureAdSharedMode", "androidOpenSourceProjectUserAssociated", "androidOpenSourceProjectUserless", "unknownFutureValue")]
        [System.String]
        $TargetedAppManagementLevels,

        [Parameter()]
        [System.String[]]
        $ApprovedKeyboards,

        [Parameter()]
        [System.String[]]
        $ExemptedAppPackages,

        [Parameter()]
        [System.String]
        $PeriodOfflineBeforeAccessCheck,

        [Parameter()]
        [System.String]
        $PeriodOnlineBeforeAccessCheck,

        [Parameter()]
        [System.String]
        $AllowedInboundDataTransferSources,

        [Parameter()]
        [System.String]
        $AllowedOutboundDataTransferDestinations,

        [Parameter()]
        [System.Boolean]
        $OrganizationalCredentialsRequired,

        [Parameter()]
        [System.String]
        $AllowedOutboundClipboardSharingLevel,

        [Parameter()]
        [System.Boolean]
        $DataBackupBlocked,

        [Parameter()]
        [System.Boolean]
        $DeviceComplianceRequired,

        [Parameter()]
        [System.Boolean]
        $ManagedBrowserToOpenLinksRequired,

        [Parameter()]
        [System.Boolean]
        $SaveAsBlocked,

        [Parameter()]
        [System.String]
        $PeriodOfflineBeforeWipeIsEnforced,

        [Parameter()]
        [System.Boolean]
        $PinRequired,

        [Parameter()]
        [System.Boolean]
        $DisableAppPinIfDevicePinIsSet,

        [Parameter()]
        [System.UInt32]
        $MaximumPinRetries,

        [Parameter()]
        [System.Boolean]
        $SimplePinBlocked,

        [Parameter()]
        [System.UInt32]
        $MinimumPinLength,

        [Parameter()]
        [System.String]
        $PinCharacterSet,

        [Parameter()]
        [System.String[]]
        $AllowedDataStorageLocations,

        [Parameter()]
        [System.Boolean]
        $ContactSyncBlocked,

        [Parameter()]
        [System.String]
        $PeriodBeforePinReset,

        [Parameter()]
        [System.Boolean]
        $PrintBlocked,

        [Parameter()]
        [System.Boolean]
        $RequireClass3Biometrics,

        [Parameter()]
        [System.Boolean]
        $RequirePinAfterBiometricChange,

        [Parameter()]
        [System.Boolean]
        $FingerprintBlocked,

        [Parameter()]
        [System.Boolean]
        $DisableAppEncryptionIfDeviceEncryptionIsEnabled,

        [Parameter()]
        [System.String]
        $CustomBrowserDisplayName,

        [Parameter()]
        [System.String]
        $CustomBrowserPackageId,

        [Parameter()]
        [System.String[]]
        $Apps,

        [Parameter()]
        [ValidateSet('allApps', 'allMicrosoftApps', 'allCoreMicrosoftApps', 'selectedPublicApps' )]
        [System.String]
        $AppGroupType,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter()]
        [System.String]
        [ValidateSet('notConfigured', 'microsoftEdge')]
        $ManagedBrowser,

        [Parameter()]
        [System.String]
        $MinimumRequiredAppVersion,

        [Parameter()]
        [System.String]
        $MinimumRequiredOSVersion,

        [Parameter()]
        [System.String]
        $MinimumRequiredPatchVersion,

        [Parameter()]
        [System.String]
        $MinimumWarningAppVersion,

        [Parameter()]
        [System.String]
        $MinimumWarningOSVersion,

        [Parameter()]
        [System.String]
        $MinimumWarningPatchVersion,

        [Parameter()]
        [System.Boolean]
        $ScreenCaptureBlocked,

        [Parameter()]
        [System.Boolean]
        $EncryptAppData,

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
        [System.String]
        $Id,

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
        param($DesiredValues, $CurrentValues, $ValuesToCheck, $ignore)
        if ($DesiredValues.AppGroupType -ne 'SelectedPublicApps')
        {
            $ValuesToCheck.Remove('Apps')
        }
        return [System.Tuple[Hashtable, Hashtable, Hashtable]]::new($DesiredValues, $CurrentValues, $ValuesToCheck)
    }
    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
                                         -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '') `
                                         -PostProcessing $postProcessingScript
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
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        if (-not [string]::IsNullOrEmpty($Filter))
        {
            $complexFunctions = Get-ComplexFunctionsFromFilterQuery -FilterQuery $Filter
            $Filter = Remove-ComplexFunctionsFromFilterQuery -FilterQuery $Filter
        }
        [array]$policies = Get-MgBetaDeviceAppManagementAndroidManagedAppProtection -All:$true -Filter $Filter -ErrorAction Stop
        $policies = Find-GraphDataUsingComplexFunctions -ComplexFunctions $complexFunctions -Policies $policies

        $i = 1
        $dscContent = ''
        if ($policies.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($policy in $policies)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($policies.Count)] $($policy.displayName)" -DeferWrite
            $params = @{
                Id                    = $policy.Id
                DisplayName           = $policy.DisplayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationID         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $policy
            $Results = Get-TargetResource @params

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
        if ($_.Exception -like '*401*' -or $_.ErrorDetails.Message -like "*`"ErrorCode`":`"Forbidden`"*" -or `
                $_.Exception -like '*Request not applicable to target tenant*')
        {
            Write-M365DSCHost -Message "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered for Intune."
        }
        else
        {
            New-M365DSCLogEntry -Message 'Error during Export:' `
                -Exception $_ `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential

            throw
        }
    }
}

function Get-IntuneAppProtectionPolicyAndroidAppsToHashtable
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [System.String[]]
        $Apps,

        [Parameter(Mandatory = $true)]
        [ValidateSet('selectedPublicApps', 'allCoreMicrosoftApps', 'allMicrosoftApps','allApps')]
        [System.String]
        $AppGroupType
    )

    $formattedApps = @()
    $allApps = (Get-MgBetaDeviceAppManagementManagedAppStatus -ManagedAppStatusId managedAppList).AdditionalProperties.content.appList | Where-Object {
        $_.appIdentifier.'@odata.type' -eq '#microsoft.graph.androidMobileAppIdentifier'
    }

    switch ($AppGroupType)
    {
        'selectedPublicApps'
        {
            if ($Apps.Count -eq 0)
            {
                throw "AppGroupType is set to 'selectedPublicApps' but no Apps were provided."
            }
        }
        'allCoreMicrosoftApps'
        {
            $Apps = $allApps | Where-Object appGroups -EQ 'coreMicrosoft' | ForEach-Object {
                $_.appIdentifier.bundleId
            }
        }
        'allMicrosoftApps'
        {
            $Apps = $allApps | Where-Object appGroups -EQ 'microsoft' | ForEach-Object {
                $_.appIdentifier.bundleId
            }
        }
        'allApps'
        {
            $Apps = $allApps | ForEach-Object {
                $_.appIdentifier.bundleId
            }
        }
    }

    foreach ($app in $Apps)
    {
        $formattedApps += @{
            id                  = $app + '.android'
            mobileAppIdentifier = @{
                '@odata.type' = '#microsoft.graph.androidMobileAppIdentifier'
                packageId     = $app
            }
        }
    }

    return @{
        apps = $formattedApps
        appGroupType = $AppGroupType
    }
}

function Set-ManagedBrowserValues
{
    param
    (
        [string]$ManagedBrowser,
        [switch]$ManagedBrowserToOpenLinksRequired,
        [string]$CustomBrowserDisplayName,
        [string]$CustomBrowserPackageId
    )

    # via the gui there are only 3 possible configs:
    # edge - edge, true, empty id strings
    # any app - not configured, false, empty strings
    # unmanaged browser not configured, true, strings must not be empty
    if (!$ManagedBrowserToOpenLinksRequired)
    {
        $ManagedBrowser = 'notConfigured'
        $ManagedBrowserToOpenLinksRequired = $false
        $CustomBrowserDisplayName = ''
        $CustomBrowserPackageId = ''

    }
    else
    {
        if (($CustomBrowserDisplayName -ne '') -and ($CustomBrowserPackageId -ne ''))
        {
            $ManagedBrowser = 'notConfigured'
            $ManagedBrowserToOpenLinksRequired = $true
            $CustomBrowserDisplayName = $CustomBrowserDisplayName
            $CustomBrowserPackageId = $CustomBrowserPackageId
        }
        else
        {
            $ManagedBrowser = 'microsoftEdge'
            $ManagedBrowserToOpenLinksRequired = $true
            $CustomBrowserDisplayName = ''
            $CustomBrowserPackageId = ''
        }

    }

    $ManagedBrowserHash = @{
        'ManagedBrowser'                    = $ManagedBrowser
        'ManagedBrowserToOpenLinksRequired' = $ManagedBrowserToOpenLinksRequired
        'CustomBrowserDisplayName'          = $CustomBrowserDisplayName
        'CustomBrowserPackageId'            = $CustomBrowserPackageId
    }

    return $ManagedBrowserHash
}

Export-ModuleMember -Function *-TargetResource
