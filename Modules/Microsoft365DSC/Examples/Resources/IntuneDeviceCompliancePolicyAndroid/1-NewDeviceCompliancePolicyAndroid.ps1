<#
This example creates a new Device Compliance Policy for Android devices
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneDeviceCompliancePolicyAndroid AddDeviceCompliancePolicyAndroid
        {
            DisplayName                                        = 'Test Android Device Compliance Policy'
            Description                                        = 'Test Android Device Compliance Policy Description'
            PasswordRequired                                   = $True
            PasswordMinimumLength                              = 6
            PasswordRequiredType                               = "DeviceDefault"
            RequiredPasswordComplexity                         = None
            PasswordMinutesOfInactivityBeforeLock              = 5
            PasswordExpirationDays                             = 365
            PasswordPreviousPasswordBlockCount                 = 3
            PasswordSignInFailureCountBeforeFactoryReset       = 11
            SecurityPreventInstallAppsFromUnknownSources       = $True
            SecurityDisableUsbDebugging                        = $True
            SecurityRequireVerifyApps                          = $True
            DeviceThreatProtectionEnabled                      = $True
            DeviceThreatProtectionRequiredSecurityLevel        = "Unavailable"
            AdvancedThreatProtectionRequiredSecurityLevel      = "Unavailable"
            SecurityBlockJailbrokenDevices                     = $True
            SecurityBlockDeviceAdministratorManagedDevices     = $True
            OsMinimumVersion                                   = 7
            OsMaximumVersion                                   = 11
            MinAndroidSecurityPatchLevel                       = Null
            StorageRequireEncryption                           = $True
            SecurityRequireSafetyNetAttestationBasicIntegrity  = $True
            SecurityRequireSafetyNetAttestationCertifiedDevice = $True
            SecurityRequireGooglePlayServices                  = $True
            SecurityRequireUpToDateSecurityProviders           = $True
            SecurityRequireCompanyPortalAppIntegrity           = $True
            ConditionStatementId                               = Null
            RestrictedApps                                     = "[]"
            RoleScopeTagIds                                    = 0
            Ensure                                             = 'Present'
            GlobalAdminAccount                                 = $GlobalAdminAccount
        }
    }
}
