Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneAppProtectionPolicyiOS'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter()]
        [System.String]
        $Identity,

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
        $AllowedDataIngestionLocations,

        [Parameter()]
        [System.Boolean]
        $AllowWidgetContentSync,

        [Parameter()]
        [ValidateSet('block', 'wipe', 'warn', 'blockWhenSettingIsSupported')]
        [System.String]
        $AppActionIfAccountIsClockedOut,

        [Parameter()]
        [ValidateSet('block', 'wipe', 'warn', 'blockWhenSettingIsSupported')]
        [System.String]
        $AppActionIfUnableToAuthenticateUser,

        [Parameter()]
        [ValidateSet('selectedPublicApps', 'allCoreMicrosoftApps', 'allMicrosoftApps', 'allApps')]
        [System.String]
        $AppGroupType,

        [Parameter()]
        [System.Boolean]
        $BlockDataIngestionIntoOrganizationDocuments,

        [Parameter()]
        [System.String]
        $CustomDialerAppProtocol,

        [Parameter()]
        [System.UInt32]
        $DeployedAppCount,

        [Parameter()]
        [ValidateSet('allApps', 'managedApps', 'customApp', 'blocked')]
        [System.String]
        $DialerRestrictionLevel,

        [Parameter()]
        [System.String[]]
        $ExemptedUniversalLinks,

        [Parameter()]
        [System.String]
        $GracePeriodToBlockAppsDuringOffClockHours,

        [Parameter()]
        [System.String[]]
        $ManagedUniversalLinks,

        [Parameter()]
        [ValidateSet('notConfigured', 'secured', 'low', 'medium', 'high')]
        [System.String]
        $MaximumAllowedDeviceThreatLevel,

        [Parameter()]
        [System.String]
        $MaximumRequiredOsVersion,

        [Parameter()]
        [System.String]
        $MaximumWarningOsVersion,

        [Parameter()]
        [System.String]
        $MaximumWipeOsVersion,

        [Parameter()]
        [System.String]
        $MessagingRedirectAppUrlScheme,

        [Parameter()]
        [System.String]
        $MinimumWarningSdkVersion,

        [Parameter()]
        [ValidateSet('defenderOverThirdPartyPartner', 'thirdPartyPartnerOverDefender', 'unknownFutureValue')]
        [System.String]
        $MobileThreatDefensePartnerPriority,

        [Parameter()]
        [ValidateSet('block', 'wipe', 'warn', 'blockWhenSettingIsSupported')]
        [System.String]
        $MobileThreatDefenseRemediationAction,

        [Parameter()]
        [System.UInt32]
        $PreviousPinBlockCount,

        [Parameter()]
        [ValidateSet('anyApp', 'anyManagedApp', 'specificApps', 'blocked')]
        [System.String]
        $ProtectedMessagingRedirectAppType,

        [Parameter()]
        [System.Boolean]
        $ThirdPartyKeyboardsBlocked,

        [Parameter()]
        [System.String]
        $PeriodOfflineBeforeAccessCheck,

        [Parameter()]
        [System.String]
        $PeriodOnlineBeforeAccessCheck,

        [Parameter()]
        [ValidateSet('allApps', 'managedApps', 'none')]
        [System.String]
        $AllowedInboundDataTransferSources,

        [Parameter()]
        [ValidateSet('allApps', 'managedApps', 'none')]
        [System.String]
        $AllowedOutboundDataTransferDestinations,

        [Parameter()]
        [System.Boolean]
        $OrganizationalCredentialsRequired,

        [Parameter()]
        [ValidateSet('allApps', 'managedAppsWithPasteIn', 'managedApps', 'blocked')]
        [System.String]
        $AllowedOutboundClipboardSharingLevel,

        [Parameter()]
        [System.Boolean]
        $DataBackupBlocked,

        [Parameter()]
        [System.Boolean]
        $DeviceComplianceRequired,

        [Parameter()]
        [ValidateSet('notConfigured', 'microsoftEdge')]
        [System.String]
        $ManagedBrowser,

        [Parameter()]
        [System.String]
        $MinimumRequiredAppVersion,

        [Parameter()]
        [System.String]
        $MinimumWarningAppVersion,

        [Parameter()]
        [System.String]
        $MinimumRequiredOsVersion,

        [Parameter()]
        [System.String]
        $MinimumWarningOSVersion,

        [Parameter()]
        [System.String]
        $MinimumRequiredSdkVersion,

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
        [ValidateSet('numeric', 'alphanumericAndSymbol')]
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
        $FingerprintBlocked,

        [Parameter()]
        [System.Boolean]
        $FaceIdBlocked,

        [Parameter()]
        [ValidateSet('useDeviceSettings', 'afterDeviceRestart', 'whenDeviceLockedExceptOpenFiles', 'whenDeviceLocked')]
        [System.String]
        $AppDataEncryptionType,

        [Parameter()]
        [System.String]
        $MinimumWipeOSVersion,

        [Parameter()]
        [System.String]
        $MinimumWipeAppVersion,

        [Parameter()]
        [ValidateSet('block', 'wipe', 'warn')]
        [System.String]
        $AppActionIfDeviceComplianceRequired,

        [Parameter()]
        [ValidateSet('block', 'wipe', 'warn')]
        [System.String]
        $AppActionIfMaximumPinRetriesExceeded,

        [Parameter()]
        [System.String]
        $PinRequiredInsteadOfBiometricTimeout,

        [Parameter()]
        [System.Uint32]
        $AllowedOutboundClipboardSharingExceptionLength,

        [Parameter()]
        [ValidateSet('allow', 'blockOrganizationalData', 'block')]
        [System.String]
        $NotificationRestriction,

        [Parameter()]
        [ValidateSet('unspecified', 'unmanaged', 'mdm', 'androidEnterprise')]
        [System.String[]]
        $TargetedAppManagementLevels,

        [Parameter()]
        [System.String[]]
        $ExemptedAppProtocols,

        [Parameter()]
        [System.String]
        $MinimumWipeSdkVersion,

        [Parameter()]
        [System.String[]]
        $AllowedIosDeviceModels,

        [Parameter()]
        [ValidateSet('block', 'wipe', 'warn')]
        [System.String]
        $AppActionIfIosDeviceModelNotAllowed,

        [Parameter()]
        [System.Boolean]
        $FilterOpenInToOnlyManagedApps,

        [Parameter()]
        [System.Boolean]
        $DisableProtectionOfManagedOutboundOpenInData,

        [Parameter()]
        [System.Boolean]
        $ProtectInboundDataFromUnknownSources,

        [Parameter()]
        [System.String[]]
        $Apps,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter()]
        [System.String]
        $CustomBrowserProtocol,

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration of the Intune iOS App Protection Policy with Id {$Identity} and DisplayName {$DisplayName}"

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

            if (-not [System.String]::IsNullOrEmpty($Identity))
            {
                [Array]$policy = Get-MgBetaDeviceAppManagementiOSManagedAppProtection -IosManagedAppProtectionId $Identity -ErrorAction SilentlyContinue
            }
            if ($policy.Length -eq 0)
            {
                Write-Verbose -Message "No iOS App Protection Policy {$Identity} was found by Identity. Trying to retrieve by DisplayName"
                [Array]$policy = Get-MgBetaDeviceAppManagementiOSManagedAppProtection -All -Filter "DisplayName eq '$($DisplayName -replace "'", "''")'" -ErrorAction SilentlyContinue
            }

            if ($policy.Length -gt 1)
            {
                throw "Multiple policies with display name {$DisplayName} were found. Please ensure only one instance exists."
            }

            if ($null -eq $policy)
            {
                Write-Verbose -Message "No iOS App Protection Policy {$DisplayName} was found by Display Name. Instance doesn't exist."
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
            throw 'Multiple Policies with same displayname identified - Module currently only functions with unique names'
        }
        else
        {
            $Id = $policy.Id
        }

        Write-Verbose -Message "An Intune iOS App Protection Policy with Id {$Id} and DisplayName {$DisplayName} was found."

        $policyApps = Get-MgBetaDeviceAppManagementiOSManagedAppProtectionApp -IosManagedAppProtectionId $Id

        $appsArray = @()
        if ($policy.AppGroupType -eq 'selectedPublicApps')
        {
            foreach ($app in $policyApps)
            {
                $appsArray += $app.mobileAppIdentifier.bundleId
            }
        }

        $assignmentsValues = Get-MgBetaDeviceAppManagementiOSManagedAppProtectionAssignment -IosManagedAppProtectionId $Id
        $assignmentResult = @()
        if ($assignmentsValues.Count -gt 0)
        {
            $assignmentResult += ConvertFrom-IntunePolicyAssignment -Assignments $assignmentsValues -IncludeDeviceFilter $true
        }

        $exemptedAppProtocolsArray = @()
        foreach ($exemptedAppProtocol in [Array]$policy.exemptedAppProtocols)
        {
            $exemptedAppProtocolsArray += ($exemptedAppProtocol.Name + ':' + $exemptedAppProtocol.Value)
        }

        $AllowedDataIngestionLocationsValue = @()
        if ($null -ne $policy.AllowedDataIngestionLocations)
        {
            $AllowedDataIngestionLocationsValue = [String[]]($policy.AllowedDataIngestionLocations)
        }

        $exemptedUniversalLinks = @()
        if ($null -ne $policy.exemptedUniversalLinks)
        {
            $exemptedUniversalLinks = [String[]]($policy.exemptedUniversalLinks)
        }

        $managedUniversalLinks = @()
        if ($null -ne $policy.managedUniversalLinks)
        {
            $managedUniversalLinks = [String[]]($policy.managedUniversalLinks)
        }

        $AllowedDataStorageLocations = @()
        if ($null -ne $policy.AllowedDataStorageLocations)
        {
            $AllowedDataStorageLocations = [String[]]($policy.AllowedDataStorageLocations)
        }

        $gracePeriodToBlockAppsDuringOffClockHoursString = $null
        if (-not [System.String]::IsNullOrEmpty($policy.GracePeriodToBlockAppsDuringOffClockHours))
        {
            $gracePeriodToBlockAppsDuringOffClockHoursString = [System.Xml.XmlConvert]::ToString($policy.GracePeriodToBlockAppsDuringOffClockHours)
        }

        return @{
            Identity                                       = $policy.Id
            DisplayName                                    = $policy.DisplayName
            Description                                    = $policy.Description
            RoleScopeTagIds                                = $policy.RoleScopeTagIds
            AllowedDataIngestionLocations                  = $AllowedDataIngestionLocationsValue
            AllowWidgetContentSync                         = $policy.AllowWidgetContentSync
            AppActionIfAccountIsClockedOut                 = $policy.appActionIfAccountIsClockedOut
            AppActionIfUnableToAuthenticateUser            = $policy.appActionIfUnableToAuthenticateUser
            AppGroupType                                   = $policy.appGroupType
            BlockDataIngestionIntoOrganizationDocuments    = $policy.blockDataIngestionIntoOrganizationDocuments
            CustomDialerAppProtocol                        = $policy.customDialerAppProtocol
            # TODO: Remove during next breaking change
            #DeployedAppCount                               = $policy.deployedAppCount
            DialerRestrictionLevel                         = $policy.dialerRestrictionLevel
            ExemptedUniversalLinks                         = $exemptedUniversalLinks
            GracePeriodToBlockAppsDuringOffClockHours      = $gracePeriodToBlockAppsDuringOffClockHoursString
            ManagedUniversalLinks                          = $managedUniversalLinks
            MaximumAllowedDeviceThreatLevel                = $policy.maximumAllowedDeviceThreatLevel
            MaximumRequiredOsVersion                       = $policy.maximumRequiredOsVersion
            MaximumWarningOsVersion                        = $policy.maximumWarningOsVersion
            MaximumWipeOsVersion                           = $policy.maximumWipeOsVersion
            MessagingRedirectAppUrlScheme                  = $policy.messagingRedirectAppUrlScheme
            MinimumWarningSdkVersion                       = $policy.minimumWarningSdkVersion
            MobileThreatDefensePartnerPriority             = $policy.mobileThreatDefensePartnerPriority
            MobileThreatDefenseRemediationAction           = $policy.mobileThreatDefenseRemediationAction
            PreviousPinBlockCount                          = $policy.previousPinBlockCount
            ProtectedMessagingRedirectAppType              = $policy.protectedMessagingRedirectAppType
            thirdPartyKeyboardsBlocked                     = $policy.thirdPartyKeyboardsBlocked
            PeriodOfflineBeforeAccessCheck                 = $policy.PeriodOfflineBeforeAccessCheck
            PeriodOnlineBeforeAccessCheck                  = $policy.PeriodOnlineBeforeAccessCheck
            AllowedInboundDataTransferSources              = $policy.AllowedInboundDataTransferSources
            AllowedOutboundDataTransferDestinations        = $policy.AllowedOutboundDataTransferDestinations
            OrganizationalCredentialsRequired              = $policy.OrganizationalCredentialsRequired
            AllowedOutboundClipboardSharingLevel           = $policy.AllowedOutboundClipboardSharingLevel
            DataBackupBlocked                              = $policy.DataBackupBlocked
            DeviceComplianceRequired                       = $policy.DeviceComplianceRequired
            ManagedBrowser                                 = $policy.ManagedBrowser
            MinimumRequiredAppVersion                      = $policy.MinimumRequiredAppVersion
            MinimumRequiredOsVersion                       = $policy.MinimumRequiredOsVersion
            MinimumRequiredSdkVersion                      = $policy.MinimumRequiredSDKVersion
            MinimumWarningAppVersion                       = $policy.MinimumWarningAppVersion
            MinimumWarningOSVersion                        = $policy.MinimumWarningOSVersion
            ManagedBrowserToOpenLinksRequired              = $policy.ManagedBrowserToOpenLinksRequired
            SaveAsBlocked                                  = $policy.SaveAsBlocked
            PeriodOfflineBeforeWipeIsEnforced              = $policy.PeriodOfflineBeforeWipeIsEnforced
            PinRequired                                    = $policy.PinRequired
            DisableAppPinIfDevicePinIsSet                  = $policy.disableAppPinIfDevicePinIsSet
            MaximumPinRetries                              = $policy.MaximumPinRetries
            SimplePinBlocked                               = $policy.SimplePinBlocked
            MinimumPinLength                               = $policy.MinimumPinLength
            PinCharacterSet                                = $policy.PinCharacterSet
            AllowedDataStorageLocations                    = $AllowedDataStorageLocations
            ContactSyncBlocked                             = $policy.ContactSyncBlocked
            PeriodBeforePinReset                           = $policy.PeriodBeforePinReset
            FaceIdBlocked                                  = $policy.FaceIdBlocked
            PrintBlocked                                   = $policy.PrintBlocked
            FingerprintBlocked                             = $policy.FingerprintBlocked
            AppDataEncryptionType                          = $policy.AppDataEncryptionType
            Assignments                                    = $assignmentResult
            CustomBrowserProtocol                          = $policy.CustomBrowserProtocol
            Apps                                           = $appsArray
            MinimumWipeOSVersion                           = $policy.minimumWipeOSVersion
            MinimumWipeAppVersion                          = $policy.MinimumWipeAppVersion
            AppActionIfDeviceComplianceRequired            = $policy.AppActionIfDeviceComplianceRequired
            AppActionIfMaximumPinRetriesExceeded           = $policy.AppActionIfMaximumPinRetriesExceeded
            PinRequiredInsteadOfBiometricTimeout           = $policy.PinRequiredInsteadOfBiometricTimeout
            AllowedOutboundClipboardSharingExceptionLength = $policy.AllowedOutboundClipboardSharingExceptionLength
            NotificationRestriction                        = $policy.NotificationRestriction
            TargetedAppManagementLevels                    = [string[]]$policy.TargetedAppManagementLevels.ToString().Split(',')
            ExemptedAppProtocols                           = $exemptedAppProtocolsArray
            MinimumWipeSdkVersion                          = $policy.MinimumWipeSdkVersion
            AllowedIosDeviceModels                         = $policy.AllowedIosDeviceModels
            AppActionIfIosDeviceModelNotAllowed            = $policy.AppActionIfIosDeviceModelNotAllowed
            FilterOpenInToOnlyManagedApps                  = $policy.FilterOpenInToOnlyManagedApps
            DisableProtectionOfManagedOutboundOpenInData   = $policy.DisableProtectionOfManagedOutboundOpenInData
            ProtectInboundDataFromUnknownSources           = $policy.ProtectInboundDataFromUnknownSources
            Ensure                                         = 'Present'
            Credential                                     = $Credential
            ApplicationId                                  = $ApplicationId
            ApplicationSecret                              = $ApplicationSecret
            TenantId                                       = $TenantId
            CertificateThumbprint                          = $CertificateThumbprint
            CertificatePath                                = $CertificatePath
            CertificatePassword                            = $CertificatePassword
            ManagedIdentity                                = $ManagedIdentity.IsPresent
            AccessTokens                                   = $AccessTokens
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
        [Parameter()]
        [System.String]
        $Identity,

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
        $AllowedDataIngestionLocations,

        [Parameter()]
        [System.Boolean]
        $AllowWidgetContentSync,

        [Parameter()]
        [ValidateSet('block', 'wipe', 'warn', 'blockWhenSettingIsSupported')]
        [System.String]
        $AppActionIfAccountIsClockedOut,

        [Parameter()]
        [ValidateSet('block', 'wipe', 'warn', 'blockWhenSettingIsSupported')]
        [System.String]
        $AppActionIfUnableToAuthenticateUser,

        [Parameter()]
        [ValidateSet('selectedPublicApps', 'allCoreMicrosoftApps', 'allMicrosoftApps', 'allApps')]
        [System.String]
        $AppGroupType,

        [Parameter()]
        [System.Boolean]
        $BlockDataIngestionIntoOrganizationDocuments,

        [Parameter()]
        [System.String]
        $CustomDialerAppProtocol,

        [Parameter()]
        [System.UInt32]
        $DeployedAppCount,

        [Parameter()]
        [ValidateSet('allApps', 'managedApps', 'customApp', 'blocked')]
        [System.String]
        $DialerRestrictionLevel,

        [Parameter()]
        [System.String[]]
        $ExemptedUniversalLinks,

        [Parameter()]
        [System.String]
        $GracePeriodToBlockAppsDuringOffClockHours,

        [Parameter()]
        [System.String[]]
        $ManagedUniversalLinks,

        [Parameter()]
        [ValidateSet('notConfigured', 'secured', 'low', 'medium', 'high')]
        [System.String]
        $MaximumAllowedDeviceThreatLevel,

        [Parameter()]
        [System.String]
        $MaximumRequiredOsVersion,

        [Parameter()]
        [System.String]
        $MaximumWarningOsVersion,

        [Parameter()]
        [System.String]
        $MaximumWipeOsVersion,

        [Parameter()]
        [System.String]
        $MessagingRedirectAppUrlScheme,

        [Parameter()]
        [System.String]
        $MinimumWarningSdkVersion,

        [Parameter()]
        [ValidateSet('defenderOverThirdPartyPartner', 'thirdPartyPartnerOverDefender', 'unknownFutureValue')]
        [System.String]
        $MobileThreatDefensePartnerPriority,

        [Parameter()]
        [ValidateSet('block', 'wipe', 'warn', 'blockWhenSettingIsSupported')]
        [System.String]
        $MobileThreatDefenseRemediationAction,

        [Parameter()]
        [System.UInt32]
        $PreviousPinBlockCount,

        [Parameter()]
        [ValidateSet('anyApp', 'anyManagedApp', 'specificApps', 'blocked')]
        [System.String]
        $ProtectedMessagingRedirectAppType,

        [Parameter()]
        [System.Boolean]
        $ThirdPartyKeyboardsBlocked,

        [Parameter()]
        [System.String]
        $PeriodOfflineBeforeAccessCheck,

        [Parameter()]
        [System.String]
        $PeriodOnlineBeforeAccessCheck,

        [Parameter()]
        [ValidateSet('allApps', 'managedApps', 'none')]
        [System.String]
        $AllowedInboundDataTransferSources,

        [Parameter()]
        [ValidateSet('allApps', 'managedApps', 'none')]
        [System.String]
        $AllowedOutboundDataTransferDestinations,

        [Parameter()]
        [System.Boolean]
        $OrganizationalCredentialsRequired,

        [Parameter()]
        [ValidateSet('allApps', 'managedAppsWithPasteIn', 'managedApps', 'blocked')]
        [System.String]
        $AllowedOutboundClipboardSharingLevel,

        [Parameter()]
        [System.Boolean]
        $DataBackupBlocked,

        [Parameter()]
        [System.Boolean]
        $DeviceComplianceRequired,

        [Parameter()]
        [ValidateSet('notConfigured', 'microsoftEdge')]
        [System.String]
        $ManagedBrowser,

        [Parameter()]
        [System.String]
        $MinimumRequiredAppVersion,

        [Parameter()]
        [System.String]
        $MinimumWarningAppVersion,

        [Parameter()]
        [System.String]
        $MinimumRequiredOsVersion,

        [Parameter()]
        [System.String]
        $MinimumWarningOSVersion,

        [Parameter()]
        [System.String]
        $MinimumRequiredSdkVersion,

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
        [ValidateSet('numeric', 'alphanumericAndSymbol')]
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
        $FingerprintBlocked,

        [Parameter()]
        [System.Boolean]
        $FaceIdBlocked,

        [Parameter()]
        [ValidateSet('useDeviceSettings', 'afterDeviceRestart', 'whenDeviceLockedExceptOpenFiles', 'whenDeviceLocked')]
        [System.String]
        $AppDataEncryptionType,

        [Parameter()]
        [System.String]
        $MinimumWipeOSVersion,

        [Parameter()]
        [System.String]
        $MinimumWipeAppVersion,

        [Parameter()]
        [ValidateSet('block', 'wipe', 'warn')]
        [System.String]
        $AppActionIfDeviceComplianceRequired,

        [Parameter()]
        [ValidateSet('block', 'wipe', 'warn')]
        [System.String]
        $AppActionIfMaximumPinRetriesExceeded,

        [Parameter()]
        [System.String]
        $PinRequiredInsteadOfBiometricTimeout,

        [Parameter()]
        [System.Uint32]
        $AllowedOutboundClipboardSharingExceptionLength,

        [Parameter()]
        [ValidateSet('allow', 'blockOrganizationalData', 'block')]
        [System.String]
        $NotificationRestriction,

        [Parameter()]
        [ValidateSet('unspecified', 'unmanaged', 'mdm', 'androidEnterprise')]
        [System.String[]]
        $TargetedAppManagementLevels,

        [Parameter()]
        [System.String[]]
        $ExemptedAppProtocols,

        [Parameter()]
        [System.String]
        $MinimumWipeSdkVersion,

        [Parameter()]
        [System.String[]]
        $AllowedIosDeviceModels,

        [Parameter()]
        [ValidateSet('block', 'wipe', 'warn')]
        [System.String]
        $AppActionIfIosDeviceModelNotAllowed,

        [Parameter()]
        [System.Boolean]
        $FilterOpenInToOnlyManagedApps,

        [Parameter()]
        [System.Boolean]
        $DisableProtectionOfManagedOutboundOpenInData,

        [Parameter()]
        [System.Boolean]
        $ProtectInboundDataFromUnknownSources,

        [Parameter()]
        [System.String[]]
        $Apps,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter()]
        [System.String]
        $CustomBrowserProtocol,

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Setting configuration of the Intune App Protection Policy for iOS with DisplayName {$DisplayName}"

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
    $Identity = $currentPolicy.Identity
    $boundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new iOS App Protection Policy {$DisplayName}"
        $createParameters = Rename-M365DSCCimInstanceParameter -Properties $boundParameters
        $createParameters.Remove('Identity')
        $createParameters.Remove('Assignments')
        $createParameters.Remove('Apps')
        $createParameters.Remove('DeployedAppCount')
        $createParameters.TargetedAppManagementLevels = $createParameters.TargetedAppManagementLevels -join ','

        $myExemptedAppProtocols = @()
        foreach ($exemptedAppProtocol in $ExemptedAppProtocols)
        {
            $myExemptedAppProtocols += @{
                name  = $exemptedAppProtocol.Split(':')[0]
                value = $exemptedAppProtocol.Split(':')[1]
            }
        }
        $createParameters.ExemptedAppProtocols = $myExemptedAppProtocols

        # Remove empty string parameters that the cmdlet can't handle
        $arrayTemp = @('MinimumWarningSdkVersion', 'MaximumRequiredOsVersion', 'MaximumWarningOsVersion', 'MaximumWipeOsVersion')
        foreach ($item in $arrayTemp)
        {
            if ([System.String]::IsNullOrEmpty($createParameters.$item))
            {
                $createParameters.Remove($item)
            }
        }

        $policy = New-MgBetaDeviceAppManagementiOSManagedAppProtection -BodyParameter $createParameters
        if ($policy.Id)
        {
            Write-Verbose -Message "Update targetApps for iOS App Protection Policy with Id {$($policy.Id)} and DisplayName {$DisplayName}"
            $targetApps = Get-IntuneAppProtectionPolicyiOSAppsToHashtable -Apps $Apps -AppGroupType $AppGroupType
            $Url = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/deviceAppManagement/iosManagedAppProtections('$($policy.Id)')/targetApps"
            Invoke-MgGraphRequest -Method POST -Uri $Url -Body $targetApps

            $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
            Update-DeviceConfigurationPolicyAssignment `
                -DeviceConfigurationPolicyId $policy.Id `
                -Targets $assignmentsHash `
                -Repository 'deviceAppManagement/iosManagedAppProtections'
        }
    }
    elseif ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating existing iOS App Protection Policy {$DisplayName}"
        $updateParameters = Rename-M365DSCCimInstanceParameter -Properties $boundParameters
        $updateParameters.Remove('Identity')
        $updateParameters.Remove('Assignments')
        $updateParameters.Remove('Apps')
        $updateParameters.Remove('DeployedAppCount')
        $updateParameters.TargetedAppManagementLevels = $updateParameters.TargetedAppManagementLevels -join ','

        # Remove empty string parameters that the cmdlet can't handle
        $arrayTemp = @('MinimumWarningSdkVersion', 'MaximumRequiredOsVersion', 'MaximumWarningOsVersion', 'MaximumWipeOsVersion')
        foreach ($item in $arrayTemp)
        {
            if ([System.String]::IsNullOrEmpty($updateParameters.$item))
            {
                $updateParameters.Remove($item)
            }
        }

        $myExemptedAppProtocols = @()
        foreach ($exemptedAppProtocol in $ExemptedAppProtocols)
        {
            $myExemptedAppProtocols += @{
                name  = $exemptedAppProtocol.Split(':')[0]
                value = $exemptedAppProtocol.Split(':')[1]
            }
        }
        $updateParameters.ExemptedAppProtocols = $myExemptedAppProtocols
        Update-MgBetaDeviceAppManagementiOSManagedAppProtection -IosManagedAppProtectionId $currentPolicy.Identity -BodyParameter $updateParameters

        Write-Verbose -Message "Updating targetApps for iOS App Protection Policy with Id {$($currentPolicy.Identity)} and DisplayName {$DisplayName}"
        $targetApps = Get-IntuneAppProtectionPolicyiOSAppsToHashtable -Apps $Apps -AppGroupType $AppGroupType
        $Url = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/deviceAppManagement/iosManagedAppProtections('$($currentPolicy.Identity)')/targetApps"
        Invoke-MgGraphRequest -Method POST -Uri $Url -Body $targetApps

        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        Update-DeviceConfigurationPolicyAssignment `
            -DeviceConfigurationPolicyId $currentPolicy.Identity `
            -Targets $assignmentsHash `
            -Repository 'deviceAppManagement/iosManagedAppProtections'
    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing iOS App Protection Policy {$DisplayName}"
        Remove-MgBetaDeviceAppManagementiOSManagedAppProtection -IosManagedAppProtectionId $Identity
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter()]
        [System.String]
        $Identity,

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
        $AllowedDataIngestionLocations,

        [Parameter()]
        [System.Boolean]
        $AllowWidgetContentSync,

        [Parameter()]
        [ValidateSet('block', 'wipe', 'warn', 'blockWhenSettingIsSupported')]
        [System.String]
        $AppActionIfAccountIsClockedOut,

        [Parameter()]
        [ValidateSet('block', 'wipe', 'warn', 'blockWhenSettingIsSupported')]
        [System.String]
        $AppActionIfUnableToAuthenticateUser,

        [Parameter()]
        [ValidateSet('selectedPublicApps', 'allCoreMicrosoftApps', 'allMicrosoftApps', 'allApps')]
        [System.String]
        $AppGroupType,

        [Parameter()]
        [System.Boolean]
        $BlockDataIngestionIntoOrganizationDocuments,

        [Parameter()]
        [System.String]
        $CustomDialerAppProtocol,

        [Parameter()]
        [System.UInt32]
        $DeployedAppCount,

        [Parameter()]
        [ValidateSet('allApps', 'managedApps', 'customApp', 'blocked')]
        [System.String]
        $DialerRestrictionLevel,

        [Parameter()]
        [System.String[]]
        $ExemptedUniversalLinks,

        [Parameter()]
        [System.String]
        $GracePeriodToBlockAppsDuringOffClockHours,

        [Parameter()]
        [System.String[]]
        $ManagedUniversalLinks,

        [Parameter()]
        [ValidateSet('notConfigured', 'secured', 'low', 'medium', 'high')]
        [System.String]
        $MaximumAllowedDeviceThreatLevel,

        [Parameter()]
        [System.String]
        $MaximumRequiredOsVersion,

        [Parameter()]
        [System.String]
        $MaximumWarningOsVersion,

        [Parameter()]
        [System.String]
        $MaximumWipeOsVersion,

        [Parameter()]
        [System.String]
        $MessagingRedirectAppUrlScheme,

        [Parameter()]
        [System.String]
        $MinimumWarningSdkVersion,

        [Parameter()]
        [ValidateSet('defenderOverThirdPartyPartner', 'thirdPartyPartnerOverDefender', 'unknownFutureValue')]
        [System.String]
        $MobileThreatDefensePartnerPriority,

        [Parameter()]
        [ValidateSet('block', 'wipe', 'warn', 'blockWhenSettingIsSupported')]
        [System.String]
        $MobileThreatDefenseRemediationAction,

        [Parameter()]
        [System.UInt32]
        $PreviousPinBlockCount,

        [Parameter()]
        [ValidateSet('anyApp', 'anyManagedApp', 'specificApps', 'blocked')]
        [System.String]
        $ProtectedMessagingRedirectAppType,

        [Parameter()]
        [System.Boolean]
        $ThirdPartyKeyboardsBlocked,

        [Parameter()]
        [System.String]
        $PeriodOfflineBeforeAccessCheck,

        [Parameter()]
        [System.String]
        $PeriodOnlineBeforeAccessCheck,

        [Parameter()]
        [ValidateSet('allApps', 'managedApps', 'none')]
        [System.String]
        $AllowedInboundDataTransferSources,

        [Parameter()]
        [ValidateSet('allApps', 'managedApps', 'none')]
        [System.String]
        $AllowedOutboundDataTransferDestinations,

        [Parameter()]
        [System.Boolean]
        $OrganizationalCredentialsRequired,

        [Parameter()]
        [ValidateSet('allApps', 'managedAppsWithPasteIn', 'managedApps', 'blocked')]
        [System.String]
        $AllowedOutboundClipboardSharingLevel,

        [Parameter()]
        [System.Boolean]
        $DataBackupBlocked,

        [Parameter()]
        [System.Boolean]
        $DeviceComplianceRequired,

        [Parameter()]
        [ValidateSet('notConfigured', 'microsoftEdge')]
        [System.String]
        $ManagedBrowser,

        [Parameter()]
        [System.String]
        $MinimumRequiredAppVersion,

        [Parameter()]
        [System.String]
        $MinimumWarningAppVersion,

        [Parameter()]
        [System.String]
        $MinimumRequiredOsVersion,

        [Parameter()]
        [System.String]
        $MinimumWarningOSVersion,

        [Parameter()]
        [System.String]
        $MinimumRequiredSdkVersion,

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
        [ValidateSet('numeric', 'alphanumericAndSymbol')]
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
        $FingerprintBlocked,

        [Parameter()]
        [System.Boolean]
        $FaceIdBlocked,

        [Parameter()]
        [ValidateSet('useDeviceSettings', 'afterDeviceRestart', 'whenDeviceLockedExceptOpenFiles', 'whenDeviceLocked')]
        [System.String]
        $AppDataEncryptionType,

        [Parameter()]
        [System.String]
        $MinimumWipeOSVersion,

        [Parameter()]
        [System.String]
        $MinimumWipeAppVersion,

        [Parameter()]
        [ValidateSet('block', 'wipe', 'warn')]
        [System.String]
        $AppActionIfDeviceComplianceRequired,

        [Parameter()]
        [ValidateSet('block', 'wipe', 'warn')]
        [System.String]
        $AppActionIfMaximumPinRetriesExceeded,

        [Parameter()]
        [System.String]
        $PinRequiredInsteadOfBiometricTimeout,

        [Parameter()]
        [System.Uint32]
        $AllowedOutboundClipboardSharingExceptionLength,

        [Parameter()]
        [ValidateSet('allow', 'blockOrganizationalData', 'block')]
        [System.String]
        $NotificationRestriction,

        [Parameter()]
        [ValidateSet('unspecified', 'unmanaged', 'mdm', 'androidEnterprise')]
        [System.String[]]
        $TargetedAppManagementLevels,

        [Parameter()]
        [System.String[]]
        $ExemptedAppProtocols,

        [Parameter()]
        [System.String]
        $MinimumWipeSdkVersion,

        [Parameter()]
        [System.String[]]
        $AllowedIosDeviceModels,

        [Parameter()]
        [ValidateSet('block', 'wipe', 'warn')]
        [System.String]
        $AppActionIfIosDeviceModelNotAllowed,

        [Parameter()]
        [System.Boolean]
        $FilterOpenInToOnlyManagedApps,

        [Parameter()]
        [System.Boolean]
        $DisableProtectionOfManagedOutboundOpenInData,

        [Parameter()]
        [System.Boolean]
        $ProtectInboundDataFromUnknownSources,

        [Parameter()]
        [System.String[]]
        $Apps,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter()]
        [System.String]
        $CustomBrowserProtocol,

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

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
        param($DesiredValues, $CurrentValues, $ValuesToCheck, $ignore)
        if ($DesiredValues.AppGroupType -ne 'SelectedPublicApps')
        {
            $ValuesToCheck.Remove('Apps')
        }
        return [System.Tuple[Hashtable, Hashtable, Hashtable]]::new($DesiredValues, $CurrentValues, $ValuesToCheck)
    }
    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '') `
        -ExcludedProperties @('DeployedAppCount') `
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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment
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
        [array]$policies = Get-MgBetaDeviceAppManagementiOSManagedAppProtection -All -Filter $Filter -ErrorAction Stop
        $policies = Find-GraphDataUsingComplexFunctions -ComplexFunctions $complexFunctions -Policies $policies

        $i = 1
        $dscContent = [System.Text.StringBuilder]::new()
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
                Identity              = $policy.id
                DisplayName           = $policy.DisplayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationID         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $policy
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
            [void]$dscContent.Append($currentDSCBlock)
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        return $dscContent.ToString()
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

function Get-IntuneAppProtectionPolicyiOSAppsToHashtable
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
        [ValidateSet('selectedPublicApps', 'allCoreMicrosoftApps', 'allMicrosoftApps', 'allApps')]
        [System.String]
        $AppGroupType
    )

    $formattedApps = @()
    $allApps = (Get-MgBetaDeviceAppManagementManagedAppStatus -ManagedAppStatusId managedAppList).content.appList | Where-Object {
        $_.appIdentifier.'@odata.type' -eq '#microsoft.graph.iosMobileAppIdentifier'
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
            id                  = $app + '.ios'
            mobileAppIdentifier = @{
                '@odata.type' = '#microsoft.graph.iosMobileAppIdentifier'
                bundleId      = $app
            }
        }
    }

    return @{
        apps         = $formattedApps
        appGroupType = $AppGroupType
    }
}

Export-ModuleMember -Function *-TargetResource
