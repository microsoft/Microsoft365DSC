<#
This example creates a new Device Compliance Policy for Android Device Owner devices
#>

Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )

    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneDeviceCompliancePolicyAndroidDeviceOwner 'ConfigureAndroidDeviceCompliancePolicyOwner'
        {
            DisplayName                                        = 'DeviceOwner'
            Description                                        = ''
            DeviceThreatProtectionEnabled                      = $False
            DeviceThreatProtectionRequiredSecurityLevel        = 'unavailable'
            AdvancedThreatProtectionRequiredSecurityLevel      = 'unavailable'
            SecurityRequireSafetyNetAttestationBasicIntegrity  = $False
            SecurityRequireSafetyNetAttestationCertifiedDevice = $False
            OsMinimumVersion                                   = '10'
            OsMaximumVersion                                   = '11'
            PasswordRequired                                   = $True
            PasswordMinimumLength                              = 6
            PasswordRequiredType                               = 'numericComplex'
            PasswordMinutesOfInactivityBeforeLock              = 5
            PasswordExpirationDays                             = 90
            PasswordPreviousPasswordCountToBlock               = 13
            StorageRequireEncryption                           = $True
            Ensure                                             = 'Present'
            Credential                                         = $Credscredential
        }
    }
}
