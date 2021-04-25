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
        IntuneDeviceCompliancePolicyAndroid a58cdba9-c410-4ba4-b7d2-3a09593b5d84
        {
            Description                                        = "";
            DeviceThreatProtectionEnabled                      = $False;
            DeviceThreatProtectionRequiredSecurityLevel        = "unavailable";
            DisplayName                                        = "Test Policy";
            Ensure                                             = "Present";
            GlobalAdminAccount                                 = $Credsglobaladmin;
            osMinimumVersion                                   = "7";
            PasswordExpirationDays                             = 90;
            PasswordMinimumLength                              = 6;
            PasswordMinutesOfInactivityBeforeLock              = 5;
            PasswordPreviousPasswordBlockCount                 = 10;
            PasswordRequired                                   = $True;
            PasswordRequiredType                               = "deviceDefault";
            SecurityBlockJailbrokenDevices                     = $False;
            SecurityDisableUsbDebugging                        = $False;
            SecurityPreventInstallAppsFromUnknownSources       = $False;
            SecurityRequireCompanyPortalAppIntegrity           = $False;
            SecurityRequireGooglePlayServices                  = $False;
            SecurityRequireSafetyNetAttestationBasicIntegrity  = $False;
            SecurityRequireSafetyNetAttestationCertifiedDevice = $False;
            SecurityRequireUpToDateSecurityProviders           = $False;
            SecurityRequireVerifyApps                          = $False;
            StorageRequireEncryption                           = $True;
        }
    }
}
