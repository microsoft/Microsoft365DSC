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
        IntuneDeviceCompliancePolicyAndroid 'AddDeviceCompliancePolicy'
        {
            Description                                        = ""
            DeviceThreatProtectionEnabled                      = $False
            DeviceThreatProtectionRequiredSecurityLevel        = "unavailable"
            DisplayName                                        = "Test Policy"
            osMinimumVersion                                   = "7"
            PasswordExpirationDays                             = 90
            PasswordMinimumLength                              = 6
            PasswordMinutesOfInactivityBeforeLock              = 5
            PasswordPreviousPasswordBlockCount                 = 10
            PasswordRequired                                   = $True
            PasswordRequiredType                               = "deviceDefault"
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
            Ensure                                             = "Present"
            Credential                                         = $credsglobaladmin
        }
    }
}
