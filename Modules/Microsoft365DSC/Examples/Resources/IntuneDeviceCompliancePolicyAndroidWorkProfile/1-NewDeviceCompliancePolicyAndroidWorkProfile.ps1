<#
This example creates a new Device Compliance Policy for iOs devices
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
        IntuneDeviceCompliancePolicyAndroidWorkProfile AddDeviceCompliancePolicyAndroidWorkProfile
        {
            DisplayName                                        = 'Test Android Work Profile Device Compliance Policy'
            Description                                        = 'Test Android Work Profile Device Compliance Policy Description'
            PasswordRequired                                   = $True
            PasswordMinimumLength                              = 6
            PasswordRequiredType                               = "DeviceDefault"
            RequiredPasswordComplexity                         = None
            PasswordMinutesOfInactivityBeforeLock              = 5
            PasswordExpirationDays                             = 365
            PasswordPreviousPasswordBlockCount                 = 10
            PasswordSignInFailureCountBeforeFactoryReset       = 11
            SecurityPreventInstallAppsFromUnknownSources       = $True
            SecurityDisableUsbDebugging                        = $True
            SecurityRequireVerifyApps                          = $True
            DeviceThreatProtectionEnabled                      = $True
            DeviceThreatProtectionRequiredSecurityLevel        = "Unavailable"
            AdvancedThreatProtectionRequiredSecurityLevel      = "Unavailable"
            SecurityBlockJailbrokenDevices                     = $True
            OsMinimumVersion                                   = 7
            OsMaximumVersion                                   = 11
            StorageRequireEncryption                           = $True
            SecurityRequireSafetyNetAttestationBasicIntegrity  = $True
            SecurityRequireSafetyNetAttestationCertifiedDevice = $True
            SecurityRequireGooglePlayServices                  = $True
            SecurityRequireUpToDateSecurityProviders           = $True
            SecurityRequireCompanyPortalAppIntegrity           = $True
            RoleScopeTagIds                                    = "0"
            Ensure                                             = 'Present'
            GlobalAdminAccount                                 = $GlobalAdminAccount
        }
    }
}
