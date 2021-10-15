<#
This example creates a new Device Comliance Policy for MacOS.
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
        IntuneDeviceCompliancePolicyWindows10 MyCustomWindows10Policy
        {
            DisplayName                                 = "Windows 10 DSC Policy";
            Description                                 = "Test policy";
            PasswordRequired                            = $False;
            PasswordBlockSimple                         = $False;
            PasswordRequiredToUnlockFromIdle            = $True;
            PasswordMinutesOfInactivityBeforeLock       = 15;
            PasswordExpirationDays                      = 365;
            PasswordMinimumLength                       = 6;
            PasswordMinutesOfInactivityBeforeLock       = 5;
            PasswordPreviousPasswordBlockCount          = 13;
            PasswordMinimumCharacterSetCount            = 1;
            PasswordRequiredType                        = "Devicedefault";
            RequireHealthyDeviceReport                  = $True;
            OsMinimumVersion                            = 10;
            OsMaximumVersion                            = 10.19;
            MobileOsMinimumVersion                      = 10;
            MobileOsMaximumVersion                      = 10.19;
            EarlyLaunchAntiMalwareDriverEnabled         = $False;
            BitLockerEnabled                            = $False;
            SecureBootEnabled                           = $True;
            CodeIntegrityEnabled                        = $True;
            StorageRequireEncryption                    = $True;
            ActiveFirewallRequired                      = $True;
            DefenderEnabled                             = $True;
            DefenderVersion                             = "";
            SignatureOutOfDate                          = $True;
            RtpEnabled                                  = $True;
            AntivirusRequired                           = $True;
            AntiSpywareRequired                         = $True;
            DeviceThreatProtectionEnabled               = $True;
            DeviceThreatProtectionRequiredSecurityLevel = "Medium";
            ConfigurationManagerComplianceRequired      = $False;
            TPMRequired                                 = $False;
            deviceCompliancePolicyScript                = $null;
            ValidOperatingSystemBuildRanges             = @();
            Ensure                                      = 'Present';
            Credential                                  = $Credential;
        }
    }
}
