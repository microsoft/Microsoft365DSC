<#
This example creates a new Device Comliance Policy for MacOS.
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
        IntuneDeviceCompliancePolicyMacOS 'ConfigureDeviceCompliancePolicyMacOS'
        {
            DisplayName                                 = 'MacOS DSC Policy'
            Description                                 = 'Test policy'
            PasswordRequired                            = $False
            PasswordBlockSimple                         = $False
            PasswordExpirationDays                      = 365
            PasswordMinimumLength                       = 6
            PasswordMinutesOfInactivityBeforeLock       = 5
            PasswordPreviousPasswordBlockCount          = 13
            PasswordMinimumCharacterSetCount            = 1
            PasswordRequiredType                        = 'DeviceDefault'
            OsMinimumVersion                            = 10
            OsMaximumVersion                            = 13
            SystemIntegrityProtectionEnabled            = $False
            DeviceThreatProtectionEnabled               = $False
            DeviceThreatProtectionRequiredSecurityLevel = 'Unavailable'
            StorageRequireEncryption                    = $False
            FirewallEnabled                             = $False
            FirewallBlockAllIncoming                    = $False
            FirewallEnableStealthMode                   = $False
            Ensure                                      = 'Present'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
