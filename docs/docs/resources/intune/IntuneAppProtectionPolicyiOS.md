# IntuneAppProtectionPolicyiOS

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | Display name of the iOS App Protection Policy ||
| **Description** | Write | String | Description of the iOS App Protection Policy ||
| **PeriodOfflineBeforeAccessCheck** | Write | String | N/A ||
| **PeriodOnlineBeforeAccessCheck** | Write | String | N/A ||
| **AllowedInboundDataTransferSources** | Write | String | N/A ||
| **AllowedOutboundDataTransferDestinations** | Write | String | N/A ||
| **OrganizationalCredentialsRequired** | Write | Boolean | N/A ||
| **AllowedOutboundClipboardSharingLevel** | Write | String | N/A ||
| **DataBackupBlocked** | Write | Boolean | N/A ||
| **DeviceComplianceRequired** | Write | Boolean | N/A ||
| **ManagedBrowserToOpenLinksRequired** | Write | Boolean | N/A ||
| **SaveAsBlocked** | Write | Boolean | N/A ||
| **PeriodOfflineBeforeWipeIsEnforced** | Write | String | N/A ||
| **PinRequired** | Write | Boolean | N/A ||
| **MaximumPinRetries** | Write | UInt32 | N/A ||
| **SimplePinBlocked** | Write | Boolean | N/A ||
| **MinimumPinLength** | Write | UInt32 | N/A ||
| **PinCharacterSet** | Write | String | N/A ||
| **AllowedDataStorageLocations** | Write | StringArray[] | N/A ||
| **ContactSyncBlocked** | Write | Boolean | N/A ||
| **PrintBlocked** | Write | Boolean | N/A ||
| **FingerprintBlocked** | Write | Boolean | N/A ||
| **AppDataEncryptionType** | Write | String | N/A ||
| **Apps** | Write | StringArray[] | List of Ids representing the iOS apps controlled by this protection policy. ||
| **Assignments** | Write | StringArray[] | List of IDs of the groups assigned to this iOS Protection Policy. ||
| **ExcludedGroups** | Write | StringArray[] | List of IDs of the groups that are excluded from this iOS Protection Policy. ||
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Intune Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **ApplicationSecret** | Write | String | Secret of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||


# IntuneDeviceConfigurationPolicyiOS

This resource configures an Intune device configuration profile for an iOS Device.

## Examples

### Example 1

This example creates a new App ProtectionPolicy for iOS.

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
        IntuneAppProtectionPolicyiOS 'MyCustomiOSPolicy'
        {
            AllowedDataStorageLocations             = @("sharePoint")
            AllowedInboundDataTransferSources       = "managedApps"
            AllowedOutboundClipboardSharingLevel    = "managedAppsWithPasteIn"
            AllowedOutboundDataTransferDestinations = "managedApps"
            AppDataEncryptionType                   = "whenDeviceLocked"
            Apps                                    = @("com.cisco.jabberimintune.ios","com.pervasent.boardpapers.ios","com.sharefile.mobile.intune.ios")
            Assignments                             = @("6ee86c9f-2b3c-471d-ad38-ff4673ed723e")
            ContactSyncBlocked                      = $False
            DataBackupBlocked                       = $False
            Description                             = ""
            DeviceComplianceRequired                = $True
            DisplayName                             = "My DSC iOS App Protection Policy"
            ExcludedGroups                          = @("3eacc231-d77b-4efb-bb5f-310f68bd6198")
            FingerprintBlocked                      = $False
            ManagedBrowserToOpenLinksRequired       = $True
            MaximumPinRetries                       = 5
            MinimumPinLength                        = 4
            OrganizationalCredentialsRequired       = $False
            PeriodOfflineBeforeAccessCheck          = "PT12H"
            PeriodOfflineBeforeWipeIsEnforced       = "P90D"
            PeriodOnlineBeforeAccessCheck           = "PT30M"
            PinCharacterSet                         = "alphanumericAndSymbol"
            PinRequired                             = $True
            PrintBlocked                            = $False
            SaveAsBlocked                           = $True
            SimplePinBlocked                        = $False
            Ensure                                  = 'Present'
            Credential                              = $credsGlobalAdmin
        }
    }
}
```

