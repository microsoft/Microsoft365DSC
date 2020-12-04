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
        IntuneDeviceCompliancePolicyiOs AddDeviceCompliancePolicyiOs
        {
            DisplayName                                 = 'Test iOS Device Compliance Policy'
            Description                                 = 'Test iOS Device Compliance Policy Description'
            PasscodeBlockSimple                         = $True
            PasscodeExpirationDays                      = 365
            PasscodeMinimumLength                       = 6
            PasscodeMinutesOfInactivityBeforeLock       = 5
            PasscodePreviousPasscodeBlockCount          = 3
            PasscodeMinimumCharacterSetCount            = 2
            PasscodeRequiredType                        = 'numeric'
            PasscodeRequired                            = $True
            OsMinimumVersion                            = 10
            OsMaximumVersion                            = 12
            SecurityBlockJailbrokenDevices              = $True
            DeviceThreatProtectionEnabled               = $True
            DeviceThreatProtectionRequiredSecurityLevel = 'medium'
            ManagedEmailProfileRequired                 = $True
            Ensure                                      = 'Present'
            GlobalAdminAccount                          = $GlobalAdminAccount

        }
    }
}
