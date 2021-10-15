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
            AdvancedThreatProtectionRequiredSecurityLevel      = "low";
            ApplicationId                                      = $ConfigurationData.NonNodeData.ApplicationId;
            ApplicationSecret                                  = $ConfigurationData.NonNodeData.ApplicationSecret;
            DeviceThreatProtectionEnabled                      = $True;
            DeviceThreatProtectionRequiredSecurityLevel        = "secured";
            DisplayName                                        = "AE - COPE";
            Ensure                                             = "Present";
            OsMaximumVersion                                   = "13";
            OsMinimumVersion                                   = "10";
            PasswordExpirationDays                             = 90;
            PasswordMinimumLength                              = 6;
            PasswordMinutesOfInactivityBeforeLock              = 5;
            PasswordPreviousPasswordCountToBlock               = 13;
            PasswordRequired                                   = $True;
            PasswordRequiredType                               = "numericComplex";
            RoleScopeTagIds                                    = @("0");
            SecurityRequireIntuneAppIntegrity                  = $True;
            SecurityRequireSafetyNetAttestationBasicIntegrity  = $True;
            SecurityRequireSafetyNetAttestationCertifiedDevice = $True;
            StorageRequireEncryption                           = $True;
            TenantId                                           = $ConfigurationData.NonNodeData.TenantId;
        }
    }
}
