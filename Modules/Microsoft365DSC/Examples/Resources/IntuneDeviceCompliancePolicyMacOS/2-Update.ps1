<#
This example creates a new Device Comliance Policy for MacOS.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
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
            PasswordMinimumLength                       = 8 # Updated Property
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
            Credential                                  = $Credscredential
        }
    }
}
