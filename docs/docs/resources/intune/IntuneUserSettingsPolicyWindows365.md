# IntuneUserSettingsPolicyWindows365

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **CrossRegionDisasterRecoverySetting** | Write | MSFT_MicrosoftGraphcloudPcCrossRegionDisasterRecoverySetting | Defines whether the user's Cloud PC enables cross-region disaster recovery and specifies the network for the disaster recovery. | |
| **DisplayName** | Key | String | The setting name displayed in the user interface. | |
| **LocalAdminEnabled** | Write | Boolean | Indicates whether the local admin option is enabled. Default value is false. To enable the local admin option, change the setting to true. If the local admin option is enabled, the end user can be an admin of the Cloud PC device. | |
| **NotificationSetting** | Write | MSFT_MicrosoftGraphcloudPcNotificationSetting | Defines the setting of the Cloud PC notification prompts for the Cloud PC user. | |
| **ResetEnabled** | Write | Boolean | Indicates whether an end user is allowed to reset their Cloud PC. When true, the user is allowed to reset their Cloud PC. When false, end-user initiated reset isn't allowed. The default value is false. | |
| **RestorePointSetting** | Write | MSFT_MicrosoftGraphcloudPcRestorePointSetting | Defines how frequently a restore point is created (that is, a snapshot is taken) for users' provisioned Cloud PCs (default is 12 hours), and whether the user is allowed to restore their own Cloud PCs to a backup made at a specific point in time. | |
| **Id** | Write | String | The unique identifier for an entity. Read-only. | |
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

### MSFT_MicrosoftGraphCloudPcCrossRegionDisasterRecoverySetting

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisasterRecoveryNetworkSetting** | Write | MSFT_MicrosoftGraphCloudPcDisasterRecoveryNetworkSetting | Indicates the network settings of the Cloud PC during a cross-region disaster recovery operation. | |
| **DisasterRecoveryType** | Write | String | Indicates the type of disaster recovery to perform when a disaster occurs on the user's Cloud PC. The possible values are: notConfigured, crossRegion, premium, unknownFutureValue. The default value is notConfigured. | `notConfigured`, `crossRegion`, `premium`, `unknownFutureValue` |
| **MaintainCrossRegionRestorePointEnabled** | Write | Boolean | Indicates whether Windows 365 maintain the cross-region disaster recovery function generated restore points. If true, the Windows 365 stored restore points false indicates that Windows 365 doesn't generate or keep the restore point from the original Cloud PC. If a disaster occurs, the new Cloud PC can only be provisioned using the initial image. This limitation can result in the loss of some user data on the original Cloud PC. The default value is false. | |
| **UserInitiatedDisasterRecoveryAllowed** | Write | Boolean | Indicates whether the client allows the end user to initiate a disaster recovery activation. True indicates that the client includes the option for the end user to activate Backup Cloud PC. When false, the end user doesn't have the option to activate disaster recovery. The default value is false. Currently, only premium disaster recovery is supported. | |

### MSFT_MicrosoftGraphCloudPcDisasterRecoveryNetworkSetting

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **OnPremisesConnectionId** | Write | String | Indicates the display name of the virtual network that the new Cloud PC joins.  Only applicable for the '#microsoft.graph.cloudPcDisasterRecoveryAzureConnectionSetting' odata type. | |
| **RegionGroup** | Write | String | Indicates the logic geographic group this region belongs to. Multiple regions can belong to one region group. When a region group is configured for disaster recovery, the new Cloud PC is assigned to one of the regions within the group based on resource availability. For example, the europeUnion region group contains the North Europe and West Europe regions.  Only applicable for the '#microsoft.graph.cloudPcDisasterRecoveryMicrosoftHostedNetworkSetting' odata type. Possible values are: default, australia, canada, usCentral, usEast, usWest, france, germany, europeUnion, unitedKingdom, japan, asia, india, southAmerica, euap, usGovernment, usGovernmentDOD, unknownFutureValue, norway, switzerland, southKorea, middleEast, mexico, australasia, europe. Use the Prefer: include-unknown-enum-members request header to get the following values in this evolvable enum: norway, switzerland, southKorea, middleEast, mexico, australasia, europe. | `default`, `australia`, `canada`, `usCentral`, `usEast`, `usWest`, `france`, `germany`, `europeUnion`, `unitedKingdom`, `japan`, `asia`, `india`, `southAmerica`, `euap`, `usGovernment`, `usGovernmentDOD`, `unknownFutureValue`, `norway`, `switzerland`, `southKorea`, `middleEast`, `mexico`, `australasia`, `europe` |
| **RegionName** | Write | String | Indicates the Azure region that the new Cloud PC is assigned to. The Windows 365 service creates and manages the underlying virtual network. Only applicable for the '#microsoft.graph.cloudPcDisasterRecoveryMicrosoftHostedNetworkSetting' odata type. | |
| **odataType** | Write | String | The type of the entity. | `#microsoft.graph.cloudPcDisasterRecoveryAzureConnectionSetting`, `#microsoft.graph.cloudPcDisasterRecoveryMicrosoftHostedNetworkSetting` |

### MSFT_MicrosoftGraphCloudPcNotificationSetting

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **RestartPromptsDisabled** | Write | Boolean | If true, doesn't prompt the user to restart the Cloud PC. If false, prompts the user to restart Cloud PC. The default value is false. | |

### MSFT_MicrosoftGraphCloudPcRestorePointSetting

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **FrequencyType** | Write | String | The time interval in hours to take snapshots (restore points) of a Cloud PC automatically. Possible values are: default, fourHours, sixHours, twelveHours, sixteenHours, twentyFourHours. The default value is default that indicates that the time interval for automatic capturing of restore point snapshots is set to 12 hours. | `default`, `fourHours`, `sixHours`, `twelveHours`, `sixteenHours`, `twentyFourHours` |
| **UserRestoreEnabled** | Write | Boolean | If true, the user has the ability to use snapshots to restore Cloud PCs. If false, non-admin users can't use snapshots to restore the Cloud PC. | |


## Description

Intune User Settings Policy for Windows365

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - CloudPC.Read.All, Group.Read.All

- **Update**

    - CloudPC.ReadWrite.All, Group.Read.All

#### Application permissions

- **Read**

    - CloudPC.Read.All, Group.Read.All

- **Update**

    - CloudPC.ReadWrite.All, Group.Read.All

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
        IntuneUserSettingsPolicyWindows365 "My User Settings Policy for Windows 365"
        {
            DisplayName              = "User Settings Policy W365";
            Ensure                   = "Present";
            Assignments                        = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    dataType = "#microsoft.graph.cloudPcManagementGroupAssignmentTarget"
                    groupId = "42a638ec-2bf2-47a8-8f5f-176ce2124b7b"
                    groupDisplayName = "COGPASS-PROD-CA_AADP2"
                }
            );
            CrossRegionDisasterRecoverySetting = MSFT_MicrosoftGraphcloudPcCrossRegionDisasterRecoverySetting{
                MaintainCrossRegionRestorePointEnabled = $True
                DisasterRecoveryNetworkSetting = MSFT_MicrosoftGraphCloudPcDisasterRecoveryNetworkSetting{
                    RegionName = "automatic"
                    RegionGroup = "switzerland"
                    odataType = "#microsoft.graph.cloudPcDisasterRecoveryMicrosoftHostedNetworkSetting"
                }
                UserInitiatedDisasterRecoveryAllowed = $false
                DisasterRecoveryType = "crossRegion"
            };
            LocalAdminEnabled                  = $True;
            NotificationSetting                = MSFT_MicrosoftGraphcloudPcNotificationSetting{
                RestartPromptsDisabled = $False
            };
            ResetEnabled                       = $True;
            RestorePointSetting                = MSFT_MicrosoftGraphcloudPcRestorePointSetting{
                FrequencyType = "twelveHours"
                UserRestoreEnabled = $True
            };
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
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
        IntuneUserSettingsPolicyWindows365 "My User Settings Policy for Windows 365"
        {
            DisplayName              = "User Settings Policy W365";
            Ensure                   = "Present";
            Assignments                        = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    dataType = "#microsoft.graph.cloudPcManagementGroupAssignmentTarget"
                    groupId = "42a638ec-2bf2-47a8-8f5f-176ce2124b7b"
                    groupDisplayName = "COGPASS-PROD-CA_AADP2"
                }
            );
            CrossRegionDisasterRecoverySetting = MSFT_MicrosoftGraphcloudPcCrossRegionDisasterRecoverySetting{
                MaintainCrossRegionRestorePointEnabled = $True
                DisasterRecoveryNetworkSetting = MSFT_MicrosoftGraphCloudPcDisasterRecoveryNetworkSetting{
                    RegionName = "switzerlandnorth" # Updated property
                    RegionGroup = "switzerland"
                    odataType = "#microsoft.graph.cloudPcDisasterRecoveryMicrosoftHostedNetworkSetting"
                }
                UserInitiatedDisasterRecoveryAllowed = $false
                DisasterRecoveryType = "crossRegion"
            };
            LocalAdminEnabled                  = $True;
            NotificationSetting                = MSFT_MicrosoftGraphcloudPcNotificationSetting{
                RestartPromptsDisabled = $False
            };
            ResetEnabled                       = $True;
            RestorePointSetting                = MSFT_MicrosoftGraphcloudPcRestorePointSetting{
                FrequencyType = "twelveHours"
                UserRestoreEnabled = $True
            };
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
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
        IntuneUserSettingsPolicyWindows365 "My User Settings Policy for Windows 365"
        {
            DisplayName           = "User Settings Policy W365";
            Ensure                = "Absent";
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
```

