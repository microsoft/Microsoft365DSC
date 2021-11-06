# IntuneDeviceCompliancePolicyiOs

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | Display name of the iOS device compliance policy. ||
| **Description** | Write | String | Description of the iOS device compliance policy. ||
| **PasscodeBlockSimple** | Write | Boolean | PasscodeBlockSimple of the iOS device compliance policy. ||
| **PasscodeExpirationDays** | Write | UInt64 | PasscodeExpirationDays of the iOS device compliance policy. ||
| **PasscodeMinimumLength** | Write | UInt64 | PasscodeMinimumLength of the iOS device compliance policy. ||
| **PasscodeMinutesOfInactivityBeforeLock** | Write | UInt64 | PasscodeMinutesOfInactivityBeforeLock of the iOS device compliance policy. ||
| **PasscodePreviousPasscodeBlockCount** | Write | UInt64 | PasscodePreviousPasscodeBlockCount of the iOS device compliance policy. ||
| **PasscodeMinimumCharacterSetCount** | Write | UInt64 | PasscodeMinimumCharacterSetCount of the iOS device compliance policy. ||
| **PasscodeRequiredType** | Write | String | PasscodeRequiredType of the iOS device compliance policy. ||
| **PasscodeRequired** | Write | Boolean | PasscodeRequired of the iOS device compliance policy. ||
| **OsMinimumVersion** | Write | String | OsMinimumVersion of the iOS device compliance policy. ||
| **OsMaximumVersion** | Write | String | OsMaximumVersion of the iOS device compliance policy. ||
| **SecurityBlockJailbrokenDevices** | Write | Boolean | SecurityBlockJailbrokenDevices of the iOS device compliance policy. ||
| **DeviceThreatProtectionEnabled** | Write | Boolean | DeviceThreatProtectionEnabled of the iOS device compliance policy. ||
| **DeviceThreatProtectionRequiredSecurityLevel** | Write | String | DeviceThreatProtectionRequiredSecurityLevel of the iOS device compliance policy. ||
| **ManagedEmailProfileRequired** | Write | Boolean | ManagedEmailProfileRequired of the iOS device compliance policy. ||
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Intune Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **ApplicationSecret** | Write | String | Secret of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||


# IntuneDeviceCompliancePolicyiOs

This resource configures the Intune compliance policies for iOs devices.

## Examples

### Example 1

This example creates a new Device Compliance Policy for iOs devices

```powershell
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
        IntuneDeviceCompliancePolicyiOs 'ConfigureDeviceCompliancePolicyiOS'
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
            Credential                                  = $credsGlobalAdmin

        }
    }
}
```

### Example 2

This example removes an existing Device Compliance Policy for iOs devices

```powershell
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
        IntuneDeviceCompliancePolicyiOs 'RemoveDeviceCompliancePolicyiOS'
        {
            DisplayName          = 'Demo iOS Device Compliance Policy'
            Ensure               = 'Absent'
            Credential           = $credsGlobalAdmin
        }
    }
}
```

