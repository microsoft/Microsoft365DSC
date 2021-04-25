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
        IntuneDeviceCompliancePolicyAndroidWorkProfile f7d82525-b7c0-475c-9d5e-16fafdfa487a
        {
            Description                                        = "";
            DeviceThreatProtectionEnabled                      = $False;
            DeviceThreatProtectionRequiredSecurityLevel        = "unavailable";
            DisplayName                                        = "Test Policy";
            Ensure                                             = "Present";
            GlobalAdminAccount                                 = $Credsglobaladmin;
            PasswordExpirationDays                             = 90;
            PasswordMinimumLength                              = 6;
            PasswordMinutesOfInactivityBeforeLock              = 5;
            PasswordRequired                                   = $True;
            PasswordRequiredType                               = "numericComplex";
            SecurityBlockJailbrokenDevices                     = $True;
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
