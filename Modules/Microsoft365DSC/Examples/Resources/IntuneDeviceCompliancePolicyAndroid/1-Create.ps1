<#
This example creates a new Device Compliance Policy for Android devices
#>

Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneDeviceCompliancePolicyAndroid 'AddDeviceCompliancePolicy'
        {
            DisplayName                                        = 'Test Policy'
            Description                                        = ''
            DeviceThreatProtectionEnabled                      = $False
            DeviceThreatProtectionRequiredSecurityLevel        = 'unavailable'
            osMinimumVersion                                   = '7'
            PasswordExpirationDays                             = 90
            PasswordMinimumLength                              = 6
            PasswordMinutesOfInactivityBeforeLock              = 5
            PasswordPreviousPasswordBlockCount                 = 10
            PasswordRequired                                   = $True
            PasswordRequiredType                               = 'deviceDefault'
            SecurityBlockJailbrokenDevices                     = $False
            SecurityDisableUsbDebugging                        = $False
            SecurityPreventInstallAppsFromUnknownSources       = $False
            SecurityRequireCompanyPortalAppIntegrity           = $False
            SecurityRequireGooglePlayServices                  = $False
            SecurityRequireSafetyNetAttestationBasicIntegrity  = $False
            SecurityRequireSafetyNetAttestationCertifiedDevice = $False
            SecurityRequireUpToDateSecurityProviders           = $False
            SecurityRequireVerifyApps                          = $False
            StorageRequireEncryption                           = $True
            Ensure                                             = 'Present'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
