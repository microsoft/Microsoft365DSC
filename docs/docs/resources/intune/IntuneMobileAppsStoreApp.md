# IntuneMobileAppsStoreApp

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Id** | Write | String | The unique identifier for an entity. Read-only. | |
| **DisplayName** | Key | String | The admin provided or imported title of the app. | |
| **ApplicableDeviceType** | Write | MSFT_MicrosoftGraphiosDeviceType | The architecture for which this app can run on. Only applicable for the 'iOS' TargetPlatform. | |
| **AppStoreUrl** | Write | String | The App Store URL. Cannot be changed after creation. | |
| **BundleId** | Write | String | The Identity Name. Only applicable for the 'iOS' TargetPlatform. | |
| **MinimumSupportedOperatingSystem** | Write | MSFT_MicrosoftGraphMinimumOperatingSystem | The value for the minimum applicable operating system. | |
| **Description** | Write | String | The description of the app. | |
| **Developer** | Write | String | The developer of the app. | |
| **InformationUrl** | Write | String | The more information Url. | |
| **IsFeatured** | Write | Boolean | The value indicating whether the app is marked as featured by the admin. | |
| **LargeIcon** | Write | MSFT_MicrosoftGraphMimeContent | The large icon, to be displayed in the app details and used for upload of the icon. | |
| **Notes** | Write | String | Notes for the app. | |
| **Owner** | Write | String | The owner of the app. | |
| **PrivacyInformationUrl** | Write | String | The privacy statement Url. | |
| **Publisher** | Write | String | The publisher of the app. | |
| **RoleScopeTagIds** | Write | StringArray[] | List of scope tag ids for this mobile app. | |
| **TargetPlatform** | Required | String | The target platform of the mobile app. | `android`, `ios` |
| **Categories** | Write | MSFT_DeviceManagementMobileAppCategory[] | The list of categories for this app. | |
| **Assignments** | Write | MSFT_DeviceManagementMobileAppAssignment[] | Represents the assignment to the Intune policy. | |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

### MSFT_DeviceManagementMobileAppAssignment

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **dataType** | Write | String | The type of the target assignment. | `#microsoft.graph.groupAssignmentTarget`, `#microsoft.graph.allLicensedUsersAssignmentTarget`, `#microsoft.graph.allDevicesAssignmentTarget`, `#microsoft.graph.exclusionGroupAssignmentTarget`, `#microsoft.graph.mobileAppAssignment` |
| **deviceAndAppManagementAssignmentFilterId** | Write | String | The Id of the filter for the target assignment. | |
| **deviceAndAppManagementAssignmentFilterDisplayName** | Write | String | The display name of the filter for the target assignment. | |
| **deviceAndAppManagementAssignmentFilterType** | Write | String | The type of filter of the target assignment i.e. Exclude or Include. Possible values are: none, include, exclude. | `none`, `include`, `exclude` |
| **groupId** | Write | String | The group Id that is the target of the assignment. | |
| **groupDisplayName** | Write | String | The group Display Name that is the target of the assignment. | |
| **intent** | Write | String | Possible values for the install intent chosen by the admin. | `available`, `required`, `uninstall`, `availableWithoutEnrollment` |

### MSFT_MicrosoftGraphIosDeviceType

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IPad** | Write | Boolean | Whether the app should run on iPads. | |
| **IPhoneAndIPod** | Write | Boolean | Whether the app should run on iPhones and iPods. | |

### MSFT_MicrosoftGraphMinimumOperatingSystem

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **V4_0** | Write | Boolean | Indicates the minimum version support required for the managed device. When 'True', OS Version 4.0 or later is required to install the app. If 'False', Version 8.0 is not the minimum version. Applicable only for the 'Android' TargetPlatform. | |
| **V4_0_3** | Write | Boolean | Indicates the minimum version support required for the managed device. When 'True', OS Version 4.0.3 or later is required to install the app. If 'False', Version 8.0 is not the minimum version. Applicable only for the 'Android' TargetPlatform. | |
| **V4_1** | Write | Boolean | Indicates the minimum version support required for the managed device. When 'True', OS Version 4.1 or later is required to install the app. If 'False', Version 8.0 is not the minimum version. Applicable only for the 'Android' TargetPlatform. | |
| **V4_2** | Write | Boolean | Indicates the minimum version support required for the managed device. When 'True', OS Version 4.2 or later is required to install the app. If 'False', Version 8.0 is not the minimum version. Applicable only for the 'Android' TargetPlatform. | |
| **V4_3** | Write | Boolean | Indicates the minimum version support required for the managed device. When 'True', OS Version 4.3 or later is required to install the app. If 'False', Version 8.0 is not the minimum version. Applicable only for the 'Android' TargetPlatform. | |
| **V4_4** | Write | Boolean | Indicates the minimum version support required for the managed device. When 'True', OS Version 4.4 or later is required to install the app. If 'False', Version 8.0 is not the minimum version. Applicable only for the 'Android' TargetPlatform. | |
| **V5_0** | Write | Boolean | Indicates the minimum version support required for the managed device. When 'True', OS Version 5.0 or later is required to install the app. If 'False', Version 8.0 is not the minimum version. Applicable only for the 'Android' TargetPlatform. | |
| **V5_1** | Write | Boolean | Indicates the minimum version support required for the managed device. When 'True', OS Version 5.1 or later is required to install the app. If 'False', Version 8.0 is not the minimum version. Applicable only for the 'Android' TargetPlatform. | |
| **V6_0** | Write | Boolean | Indicates the minimum version support required for the managed device. When 'True', OS Version 6.0 or later is required to install the app. If 'False', Version 8.0 is not the minimum version. Applicable only for the 'Android' TargetPlatform. | |
| **V7_0** | Write | Boolean | Indicates the minimum version support required for the managed device. When 'True', OS Version 7.0 or later is required to install the app. If 'False', Version 8.0 is not the minimum version. Applicable only for the 'Android' TargetPlatform. | |
| **V7_1** | Write | Boolean | Indicates the minimum version support required for the managed device. When 'True', OS Version 7.1 or later is required to install the app. If 'False', Version 8.0 is not the minimum version. Applicable only for the 'Android' TargetPlatform. | |
| **V8_0** | Write | Boolean | Indicates the minimum version support required for the managed device. When 'True', OS Version 8.0 or later is required to install the app. If 'False', Version 8.0 is not the minimum version. | |
| **V8_1** | Write | Boolean | Indicates the minimum version support required for the managed device. When 'True', OS Version 8.1 or later is required to install the app. If 'False', Version 8.0 is not the minimum version. Applicable only for the 'Android' TargetPlatform. | |
| **V9_0** | Write | Boolean | Indicates the minimum version support required for the managed device. When 'True', OS Version 9.0 or later is required to install the app. If 'False', Version 9.0 is not the minimum version. | |
| **V10_0** | Write | Boolean | Indicates the minimum version support required for the managed device. When 'True', OS Version 10.0 or later is required to install the app. If 'False', Version 10.0 is not the minimum version. | |
| **V11_0** | Write | Boolean | Indicates the minimum version support required for the managed device. When 'True', OS Version 11.0 or later is required to install the app. If 'False', Version 11.0 is not the minimum version. | |
| **V12_0** | Write | Boolean | Indicates the minimum version support required for the managed device. When 'True', OS Version 12.0 or later is required to install the app. If 'False', Version 12.0 is not the minimum version. | |
| **V13_0** | Write | Boolean | Indicates the minimum version support required for the managed device. When 'True', OS Version 13.0 or later is required to install the app. If 'False', Version 13.0 is not the minimum version. | |
| **V14_0** | Write | Boolean | Indicates the minimum version support required for the managed device. When 'True', OS Version 14.0 or later is required to install the app. If 'False', Version 14.0 is not the minimum version. | |
| **V15_0** | Write | Boolean | Indicates the minimum version support required for the managed device. When 'True', OS Version 15.0 or later is required to install the app. If 'False', Version 15.0 is not the minimum version. | |
| **V16_0** | Write | Boolean | Indicates the minimum version support required for the managed device. When 'True', OS Version 16.0 or later is required to install the app. If 'False', Version 16.0 is not the minimum version. Applicable only for the 'iOS' TargetPlatform. | |
| **V17_0** | Write | Boolean | Indicates the minimum version support required for the managed device. When 'True', OS Version 17.0 or later is required to install the app. If 'False', Version 17.0 is not the minimum version. Applicable only for the 'iOS' TargetPlatform. | |
| **V18_0** | Write | Boolean | Indicates the minimum version support required for the managed device. When 'True', OS Version 18.0 or later is required to install the app. If 'False', Version 18.0 is not the minimum version. Applicable only for the 'iOS' TargetPlatform. | |

### MSFT_MicrosoftGraphMimeContent

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Type** | Write | String | Indicates the content mime type. | |
| **Value** | Write | String | The Base64 encoded string content. | |

### MSFT_DeviceManagementMobileAppCategory

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | The name of the app category. | |
| **Id** | Write | String | The unique identifier for an entity. Read-only. | |


## Description

Intune Mobile Apps Store App for Android and iOS

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - DeviceManagementApps.Read.All, Group.Read.All

- **Update**

    - DeviceManagementApps.ReadWrite.All, Group.Read.All

#### Application permissions

- **Read**

    - DeviceManagementApps.Read.All, Group.Read.All

- **Update**

    - DeviceManagementApps.ReadWrite.All, Group.Read.All

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
        IntuneMobileAppsStoreApp "IntuneMobileAppsStoreApp-Store App"
        {
            TargetPlatform        = "iOS"
            ApplicableDeviceType  = MSFT_MicrosoftGraphiosDeviceType{
                iPad = $True
                iPhoneAndIPod = $True
            }
            AppStoreUrl           = "https://itunes.apple.com/us/app/store-app/id1087422156?mt=8"
            BundleId              = "com.contoso.storeapp"
            Description           = "Store App Description";
            Developer             = "Contoso";
            DisplayName           = "Store App";
            Ensure                = "Present";
            InformationUrl        = "";
            IsFeatured            = $False;
            MinimumSupportedOperatingSystem = MSFT_MicrosoftGraphMinimumOperatingSystem{
                V4_0 = $False
                V4_0_3 = $False
                V4_1 = $False
                V4_2 = $False
                V4_3 = $False
                V4_4 = $False
                V5_0 = $False
                V5_1 = $False
                V6_0 = $False
                V7_0 = $False
                V7_1 = $False
                V8_0 = $True
                V8_1 = $False
                V9_0 = $False
                V10_0 = $False
                V11_0 = $False
                V12_0 = $False
                V13_0 = $False
                V14_0 = $False
                V15_0 = $False
            };
            Notes                 = "";
            Owner                 = "";
            PrivacyInformationUrl = "";
            Publisher             = "Contoso";
            Assignments          = @(
                MSFT_DeviceManagementMobileAppAssignment {
                    groupDisplayName = 'All devices'
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allDevicesAssignmentTarget'
                    intent = 'required'
                }
            );
            Categories             = @(
                MSFT_DeviceManagementMobileAppCategory{
                    Id = "2185c6bf-1b3d-4daa-a0bc-79cb4fad9c87"
                    DisplayName = "App Category 1"
                }
            );
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
        IntuneMobileAppsStoreApp "IntuneMobileAppsStoreApp-Store App"
        {
            TargetPlatform        = "iOS"
            ApplicableDeviceType  = MSFT_MicrosoftGraphiosDeviceType{
                iPad = $True
                iPhoneAndIPod = $True
            }
            AppStoreUrl           = "https://itunes.apple.com/us/app/store-app/id1087422156?mt=8"
            BundleId              = "com.contoso.storeapp"
            Description           = "Store App Description";
            Developer             = "Contoso";
            DisplayName           = "Store App";
            Ensure                = "Present";
            InformationUrl        = "";
            IsFeatured            = $True; # Drift
            MinimumSupportedOperatingSystem = MSFT_MicrosoftGraphMinimumOperatingSystem{
                V4_0 = $False
                V4_0_3 = $False
                V4_1 = $False
                V4_2 = $False
                V4_3 = $False
                V4_4 = $False
                V5_0 = $False
                V5_1 = $False
                V6_0 = $False
                V7_0 = $False
                V7_1 = $False
                V8_0 = $True
                V8_1 = $False
                V9_0 = $False
                V10_0 = $False
                V11_0 = $False
                V12_0 = $False
                V13_0 = $False
                V14_0 = $False
                V15_0 = $False
            };
            Notes                 = "";
            Owner                 = "";
            PrivacyInformationUrl = "";
            Publisher             = "Contoso";
            Assignments          = @(
                MSFT_DeviceManagementMobileAppAssignment {
                    groupDisplayName = 'All devices'
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allDevicesAssignmentTarget'
                    intent = 'required'
                }
            );
            Categories             = @(
                MSFT_DeviceManagementMobileAppCategory{
                    Id = "2185c6bf-1b3d-4daa-a0bc-79cb4fad9c87"
                    DisplayName = "App Category 1"
                }
            );
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
        IntuneMobileAppsStoreApp "IntuneMobileAppsStoreApp-Store App"
        {
            Id                    = "8d027f94-0682-431e-97c1-827d1879fa79";
            DisplayName           = "Store App";
            TargetPlatform        = "iOS"
            Ensure                = "Absent";
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
```

