<#
This example creates a new Device Compliance Policy for Android Device Owner devices
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
        IntuneDeviceCompliancePolicyAndroidDeviceOwner f7d82525-b7c0-475c-9d5e-16fafdfa487a
        {
            Description                                        = "";
            DisplayName                                        = "DeviceOwner";
            DeviceThreatProtectionEnabled                      = $False;
            DeviceThreatProtectionRequiredSecurityLevel        = "unavailable";
            AdvancedThreatProtectionRequiredSecurityLevel      = "unavailable";
            SecurityRequireSafetyNetAttestationBasicIntegrity  = $False;
            SecurityRequireSafetyNetAttestationCertifiedDevice = $False;
            OsMinimumVersion                                   = "10"
            OsMaximumVersion                                   = "11"
            MinAndroidSecurityPatchLevel                       = "2020-03-01"
            PasswordRequired                                   = $True;
            PasswordMinimumLength                              = 6;
            PasswordMinimumLetterCharacters                    = 1;
            PasswordMinimumLowerCaseCharacters                 = 1;
            PasswordMinimumNonLetterCharacters                 = 2;
            PasswordMinimumNumericCharacters                   = 1;
            PasswordMinimumSymbolCharacters                    = 1;
            PasswordMinimumUpperCaseCharacters                 = 1;
            PasswordRequiredType                               = "numericComplex";
            PasswordMinutesOfInactivityBeforeLock              = 5;
            PasswordExpirationDays                             = 90;
            PasswordPreviousPasswordCountToBlock               = 13;
            StorageRequireEncryption                           = $True;
            Ensure                                             = "Present";
            GlobalAdminAccount                                 = $Credsglobaladmin;
        }
    }
}
