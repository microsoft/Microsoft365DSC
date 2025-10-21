# IntuneDeviceConfigurationDeliveryOptimizationPolicyWindows10V2

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Description** | Write | String | Policy description | |
| **DisplayName** | Key | String | Policy name | |
| **RoleScopeTagIds** | Write | StringArray[] | List of Scope Tags for this Entity instance. | |
| **Id** | Write | String | The unique identifier for an entity. Read-only. | |
| **DODownloadMode** | Write | SInt32 | DO Download Mode (0: HTTP only, no peering, 1: HTTP blended with peering behind the same NAT, 2: HTTP blended with peering across a private group, 3: HTTP blended with Internet peering, 99: HTTP only, no peering, no use of DO cloud service, 100: Bypass mode, deprecated in Windows 11) | `0`, `1`, `2`, `3`, `99`, `100` |
| **DORestrictPeerSelectionBy** | Write | SInt32 | DO Restrict Peer Selection By (0: None, 1: Subnet mask, 2: Local discovery (DNS-SD)) | `0`, `1`, `2` |
| **DOGroupIdSource** | Write | SInt32 | DO Group Id Source (0: Not Set, 1: AD site, 2: Authenticated domain SID, 3: DHCP Option ID, 4: DNS Suffix, 5: Entra ID Tenant ID) | `0`, `1`, `2`, `3`, `4`, `5` |
| **DOGroupId** | Write | String | DO Group Id | |
| **DOMaxForegroundDownloadBandwidth** | Write | SInt32 | DO Max Foreground Download Bandwidth | |
| **DOMaxBackgroundDownloadBandwidth** | Write | SInt32 | DO Max Background Download Bandwidth | |
| **DOPercentageMaxForegroundBandwidth** | Write | SInt32 | DO Percentage Max Foreground Bandwidth | |
| **DOPercentageMaxBackgroundBandwidth** | Write | SInt32 | DO Percentage Max Background Bandwidth | |
| **SetHoursToLimitForegroundDownloadBandwidth** | Write | SInt32 | Set Business Hours to Limit Foreground Download Bandwidth (0: Disabled, 1: Enabled) | `0`, `1` |
| **SetHoursToLimitForegroundDownloadBandwidthTo** | Write | String | To: (Device) - Depends on SetHoursToLimitForegroundDownloadBandwidth (0: 12 AM, 1: 1 AM, 2: 2 AM, 3: 3 AM, 4: 4 AM, 5: 5 AM, 6: 6 AM, 7: 7 AM, 8: 8 AM, 9: 9 AM, 10: 10 AM, 11: 11 AM, 12: 12 PM, 13: 1 PM, 14: 2 PM, 15: 3 PM, 16: 4 PM, 17: 5 PM, 18: 6 PM, 19: 7 PM, 20: 8 PM, 21: 9 PM, 22: 10 PM, 23: 11 PM) | `0`, `1`, `2`, `3`, `4`, `5`, `6`, `7`, `8`, `9`, `10`, `11`, `12`, `13`, `14`, `15`, `16`, `17`, `18`, `19`, `20`, `21`, `22`, `23` |
| **SetHoursToLimitForegroundDownloadBandwidthFrom** | Write | String | From: (Device) - Depends on SetHoursToLimitForegroundDownloadBandwidth (0: 12 AM, 1: 1 AM, 2: 2 AM, 3: 3 AM, 4: 4 AM, 5: 5 AM, 6: 6 AM, 7: 7 AM, 8: 8 AM, 9: 9 AM, 10: 10 AM, 11: 11 AM, 12: 12 PM, 13: 1 PM, 14: 2 PM, 15: 3 PM, 16: 4 PM, 17: 5 PM, 18: 6 PM, 19: 7 PM, 20: 8 PM, 21: 9 PM, 22: 10 PM, 23: 11 PM) | `0`, `1`, `2`, `3`, `4`, `5`, `6`, `7`, `8`, `9`, `10`, `11`, `12`, `13`, `14`, `15`, `16`, `17`, `18`, `19`, `20`, `21`, `22`, `23` |
| **SetHoursToLimitForegroundDownloadBandwidthIn** | Write | SInt32 | Maximum Foreground Download Bandwidth (percentage) during Business Hours: - Depends on SetHoursToLimitForegroundDownloadBandwidth | |
| **SetHoursToLimitForegroundDownloadBandwidthOut** | Write | SInt32 | Maximum Foreground Download Bandwidth (percentage) outside of Business Hours: - Depends on SetHoursToLimitForegroundDownloadBandwidth | |
| **SetHoursToLimitBackgroundDownloadBandwidth** | Write | SInt32 | Set Business Hours to Limit Background Download Bandwidth (0: Disabled, 1: Enabled) | `0`, `1` |
| **SetHoursToLimitBackgroundDownloadBandwidthOut** | Write | SInt32 | Maximum Background Download Bandwidth (percentage) outside of Business Hours: - Depends on SetHoursToLimitBackgroundDownloadBandwidth | |
| **SetHoursToLimitBackgroundDownloadBandwidthFrom** | Write | String | From: (Device) - Depends on SetHoursToLimitBackgroundDownloadBandwidth (0: 12 AM, 1: 1 AM, 2: 2 AM, 3: 3 AM, 4: 4 AM, 5: 5 AM, 6: 6 AM, 7: 7 AM, 8: 8 AM, 9: 9 AM, 10: 10 AM, 11: 11 AM, 12: 12 PM, 13: 1 PM, 14: 2 PM, 15: 3 PM, 16: 4 PM, 17: 5 PM, 18: 6 PM, 19: 7 PM, 20: 8 PM, 21: 9 PM, 22: 10 PM, 23: 11 PM) | `0`, `1`, `2`, `3`, `4`, `5`, `6`, `7`, `8`, `9`, `10`, `11`, `12`, `13`, `14`, `15`, `16`, `17`, `18`, `19`, `20`, `21`, `22`, `23` |
| **SetHoursToLimitBackgroundDownloadBandwidthIn** | Write | SInt32 | Maximum Background Download Bandwidth (percentage) during Business Hours: - Depends on SetHoursToLimitBackgroundDownloadBandwidth | |
| **SetHoursToLimitBackgroundDownloadBandwidthTo** | Write | String | To: (Device) - Depends on SetHoursToLimitBackgroundDownloadBandwidth (0: 12 AM, 1: 1 AM, 2: 2 AM, 3: 3 AM, 4: 4 AM, 5: 5 AM, 6: 6 AM, 7: 7 AM, 8: 8 AM, 9: 9 AM, 10: 10 AM, 11: 11 AM, 12: 12 PM, 13: 1 PM, 14: 2 PM, 15: 3 PM, 16: 4 PM, 17: 5 PM, 18: 6 PM, 19: 7 PM, 20: 8 PM, 21: 9 PM, 22: 10 PM, 23: 11 PM) | `0`, `1`, `2`, `3`, `4`, `5`, `6`, `7`, `8`, `9`, `10`, `11`, `12`, `13`, `14`, `15`, `16`, `17`, `18`, `19`, `20`, `21`, `22`, `23` |
| **DODelayForegroundDownloadFromHttp** | Write | SInt32 | DO Delay Foreground Download From Http | |
| **DODelayBackgroundDownloadFromHttp** | Write | SInt32 | DO Delay Background Download From Http | |
| **DOMinRAMAllowedToPeer** | Write | SInt32 | DO Min RAM Allowed To Peer | |
| **DOMinDiskSizeAllowedToPeer** | Write | SInt32 | DO Min Disk Size Allowed To Peer | |
| **DOMinFileSizeToCache** | Write | SInt32 | DO Min File Size To Cache | |
| **DOMinBatteryPercentageAllowedToUpload** | Write | SInt32 | DO Min Battery Percentage Allowed To Upload | |
| **DOModifyCacheDrive** | Write | String | DO Modify Cache Drive | |
| **DOMaxCacheAge** | Write | SInt32 | DO Max Cache Age | |
| **DOAbsoluteMaxCacheSize** | Write | SInt32 | DO Absolute Max Cache Size | |
| **DOMaxCacheSize** | Write | SInt32 | DO Max Cache Size | |
| **DOAllowVPNPeerCaching** | Write | SInt32 | DO Allow VPN Peer Caching (0: Not allowed, 1: Allowed) | `0`, `1` |
| **DOCacheHost** | Write | StringArray[] | DO Cache Host | |
| **DOCacheHostSource** | Write | SInt32 | DO Cache Host Source | |
| **DODisallowCacheServerDownloadsOnVPN** | Write | SInt32 | DO Disallow Cache Server Downloads On VPN (0: Not Set, 1: Enabled) | `0`, `1` |
| **DODelayCacheServerFallbackForeground** | Write | SInt32 | DO Delay Cache Server Fallback Foreground | |
| **DODelayCacheServerFallbackBackground** | Write | SInt32 | DO Delay Cache Server Fallback Background | |
| **DOMinBackgroundQos** | Write | SInt32 | DO Min Background Qos | |
| **DOMonthlyUploadDataCap** | Write | SInt32 | DO Monthly Upload Data Cap | |
| **DOVpnKeywords** | Write | StringArray[] | DO Vpn Keywords | |
| **Assignments** | Write | MSFT_DeviceManagementConfigurationPolicyAssignments[] | Represents the assignment to the Intune policy. | |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

### MSFT_DeviceManagementConfigurationPolicyAssignments

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **dataType** | Write | String | The type of the target assignment. | `#microsoft.graph.cloudPcManagementGroupAssignmentTarget`, `#microsoft.graph.groupAssignmentTarget`, `#microsoft.graph.allLicensedUsersAssignmentTarget`, `#microsoft.graph.allDevicesAssignmentTarget`, `#microsoft.graph.exclusionGroupAssignmentTarget`, `#microsoft.graph.configurationManagerCollectionAssignmentTarget` |
| **deviceAndAppManagementAssignmentFilterType** | Write | String | The type of filter of the target assignment i.e. Exclude or Include. Possible values are:none, include, exclude. | `none`, `include`, `exclude` |
| **deviceAndAppManagementAssignmentFilterId** | Write | String | The Id of the filter for the target assignment. | |
| **deviceAndAppManagementAssignmentFilterDisplayName** | Write | String | The display name of the filter for the target assignment. | |
| **groupId** | Write | String | The group Id that is the target of the assignment. | |
| **groupDisplayName** | Write | String | The group Display Name that is the target of the assignment. | |
| **collectionId** | Write | String | The collection Id that is the target of the assignment.(ConfigMgr) | |


## Description

Intune Device Configuration Delivery Optimization Policy for Windows10 Setting Catalog

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - DeviceManagementConfiguration.Read.All, Group.Read.All

- **Update**

    - DeviceManagementConfiguration.ReadWrite.All, Group.Read.All

#### Application permissions

- **Read**

    - DeviceManagementConfiguration.Read.All, Group.Read.All

- **Update**

    - DeviceManagementConfiguration.ReadWrite.All, Group.Read.All

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
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
        IntuneDeviceConfigurationDeliveryOptimizationPolicyWindows10V2 'IntuneDeviceConfigurationDeliveryOptimizationPolicyWindows10V2'
        {
            Assignments                                               = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allLicensedUsersAssignmentTarget'
                }
            );
            ApplicationId                                  = $ApplicationId;
            CertificateThumbprint                          = $CertificateThumbprint;
            Description                                    = "";
            DisplayName                                    = "IntuneDeviceConfigurationDeliveryOptimizationPolicyWindows10V2_1";
            DOAbsoluteMaxCacheSize                         = 4;
            DOAllowVPNPeerCaching                          = "1";
            DOCacheHost                                    = @("Cache Host");
            DOCacheHostSource                              = 1;
            DODelayBackgroundDownloadFromHttp              = 500000;
            DODelayCacheServerFallbackBackground           = 120;
            DODelayCacheServerFallbackForeground           = 50;
            DODelayForegroundDownloadFromHttp              = 10;
            DODisallowCacheServerDownloadsOnVPN            = "1";
            DODownloadMode                                 = "0";
            DOGroupId                                      = "00000000-0000-0000-0000-000000000000";
            DOGroupIdSource                                = "2";
            DOMaxBackgroundDownloadBandwidth               = 20;
            DOMaxCacheAge                                  = 3;
            DOMaxCacheSize                                 = 80;
            DOMaxForegroundDownloadBandwidth               = 25;
            DOMinBackgroundQos                             = 1000;
            DOMinBatteryPercentageAllowedToUpload          = 77;
            DOMinDiskSizeAllowedToPeer                     = 20000;
            DOMinFileSizeToCache                           = 33550;
            DOMinRAMAllowedToPeer                          = 15000;
            DOModifyCacheDrive                             = "%SystemDrive%\";
            DOMonthlyUploadDataCap                         = 67890;
            DOPercentageMaxBackgroundBandwidth             = 10; # Updated property
            DOPercentageMaxForegroundBandwidth             = 10;
            DORestrictPeerSelectionBy                      = "1";
            DOVpnKeywords                                  = @("vpn 1","vpn 2");
            Ensure                                         = "Present";
            RoleScopeTagIds                                = @("0");
            SetHoursToLimitBackgroundDownloadBandwidth     = "1";
            SetHoursToLimitBackgroundDownloadBandwidthFrom = "8";
            SetHoursToLimitBackgroundDownloadBandwidthIn   = 50;
            SetHoursToLimitBackgroundDownloadBandwidthOut  = 57;
            SetHoursToLimitBackgroundDownloadBandwidthTo   = "19";
            SetHoursToLimitForegroundDownloadBandwidth     = "1";
            SetHoursToLimitForegroundDownloadBandwidthFrom = "8";
            SetHoursToLimitForegroundDownloadBandwidthIn   = 10;
            SetHoursToLimitForegroundDownloadBandwidthOut  = 31;
            SetHoursToLimitForegroundDownloadBandwidthTo   = "17";
            TenantId                                       = $TenantId;
        }
    }
}
```

### Example 2

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
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
        IntuneDeviceConfigurationDeliveryOptimizationPolicyWindows10V2 'IntuneDeviceConfigurationDeliveryOptimizationPolicyWindows10V2'
        {
            Assignments                                               = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allLicensedUsersAssignmentTarget'
                }
            );
            ApplicationId                                  = $ApplicationId;
            CertificateThumbprint                          = $CertificateThumbprint;
            Description                                    = "";
            DisplayName                                    = "IntuneDeviceConfigurationDeliveryOptimizationPolicyWindows10V2_1";
            DOAbsoluteMaxCacheSize                         = 4;
            DOAllowVPNPeerCaching                          = "1";
            DOCacheHost                                    = @("Cache Host");
            DOCacheHostSource                              = 1;
            DODelayBackgroundDownloadFromHttp              = 500000;
            DODelayCacheServerFallbackBackground           = 120;
            DODelayCacheServerFallbackForeground           = 50;
            DODelayForegroundDownloadFromHttp              = 10;
            DODisallowCacheServerDownloadsOnVPN            = "1";
            DODownloadMode                                 = "0";
            DOGroupId                                      = "00000000-0000-0000-0000-000000000000";
            DOGroupIdSource                                = "2";
            DOMaxBackgroundDownloadBandwidth               = 20;
            DOMaxCacheAge                                  = 3;
            DOMaxCacheSize                                 = 80;
            DOMaxForegroundDownloadBandwidth               = 25;
            DOMinBackgroundQos                             = 1000;
            DOMinBatteryPercentageAllowedToUpload          = 77;
            DOMinDiskSizeAllowedToPeer                     = 20000;
            DOMinFileSizeToCache                           = 33550;
            DOMinRAMAllowedToPeer                          = 15000;
            DOModifyCacheDrive                             = "%SystemDrive%\";
            DOMonthlyUploadDataCap                         = 67890;
            DOPercentageMaxBackgroundBandwidth             = 20; # Updated property
            DOPercentageMaxForegroundBandwidth             = 10;
            DORestrictPeerSelectionBy                      = "1";
            DOVpnKeywords                                  = @("vpn 1","vpn 2");
            Ensure                                         = "Present";
            RoleScopeTagIds                                = @("0");
            SetHoursToLimitBackgroundDownloadBandwidth     = "1";
            SetHoursToLimitBackgroundDownloadBandwidthFrom = "8";
            SetHoursToLimitBackgroundDownloadBandwidthIn   = 50;
            SetHoursToLimitBackgroundDownloadBandwidthOut  = 57;
            SetHoursToLimitBackgroundDownloadBandwidthTo   = "19";
            SetHoursToLimitForegroundDownloadBandwidth     = "1";
            SetHoursToLimitForegroundDownloadBandwidthFrom = "8";
            SetHoursToLimitForegroundDownloadBandwidthIn   = 10;
            SetHoursToLimitForegroundDownloadBandwidthOut  = 31;
            SetHoursToLimitForegroundDownloadBandwidthTo   = "17";
            TenantId                                       = $TenantId;
        }
    }
}
```

### Example 3

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
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
        IntuneDeviceConfigurationDeliveryOptimizationPolicyWindows10V2 'IntuneDeviceConfigurationDeliveryOptimizationPolicyWindows10V2'
        {
            DisplayName           = "IntuneDeviceConfigurationDeliveryOptimizationPolicyWindows10V2_1";
            Ensure                = "Absent";
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
```

