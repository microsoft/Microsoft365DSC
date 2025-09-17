# IntuneMobileAppsBundleMacOS

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Id** | Write | String | The unique identifier for an entity. Read-only. | |
| **DisplayName** | Key | String | The admin provided or imported title of the app. | |
| **PackageFileType** | Write | String | The bundle type. To change the app type, you have to first delete and then recreate it. Possible values are: Dmg, Pkg | `Dmg`, `Pkg` |
| **Description** | Write | String | The description of the app. | |
| **Developer** | Write | String | The developer of the app. | |
| **FileName** | Write | String | The file name of the app. | |
| **InformationUrl** | Write | String | The more information Url. | |
| **IsFeatured** | Write | Boolean | The value indicating whether the app is marked as featured by the admin. | |
| **LargeIcon** | Write | MSFT_MicrosoftGraphMimeContent | The large icon, to be displayed in the app details and used for upload of the icon. | |
| **Notes** | Write | String | Notes for the app. | |
| **Owner** | Write | String | The owner of the app. | |
| **PrivacyInformationUrl** | Write | String | The privacy statement Url. | |
| **Publisher** | Write | String | The publisher of the app. | |
| **Categories** | Write | MSFT_DeviceManagementMobileAppCategory[] | The list of categories for this app. | |
| **IncludedApps** | Write | MSFT_MicrosoftGraphMacOSIncludedApp[] | The list of apps expected to be installed by the bundle. | |
| **IgnoreVersionDetection** | Write | Boolean | When TRUE, indicates that the app's version will NOT be used to detect if the app is installed on a device. When FALSE, indicates that the app's version will be used to detect if the app is installed on a device. Set this to true for apps that use a self update feature. | |
| **MinimumSupportedOperatingSystem** | Write | MSFT_MicrosoftGraphMacOSMinimumOperatingSystem | Indicates the minimum operating system applicable for the application. | |
| **PreInstallScript** | Write | String | Contains the pre-install script for the app. This will execute on the macOS device before the app is installed. | |
| **PostInstallScript** | Write | String | Contains the post-install script for the app. This will execute on the macOS device after the app is installed. | |
| **RoleScopeTagIds** | Write | StringArray[] | List of scope tag ids for this mobile app. | |
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

### MSFT_MicrosoftGraphMacOSIncludedApp

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **BundleId** | Write | String | The bundleId of the app. This maps to the CFBundleIdentifier in the app's bundle configuration. | |
| **BundleVersion** | Write | String | The version of the app. This maps to the CFBundleShortVersion in the app's bundle configuration. | |

### MSFT_MicrosoftGraphMacOSMinimumOperatingSystem

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **V10_7** | Write | Boolean | Indicates the minimum version support required for the managed device. When 'True', OS Version 10.7 or later is required to install the app. If 'False', Version 10.7 is not the minimum version. | |
| **V10_8** | Write | Boolean | Indicates the minimum version support required for the managed device. When 'True', OS Version 10.8 or later is required to install the app. If 'False', Version 10.8 is not the minimum version. | |
| **V10_9** | Write | Boolean | Indicates the minimum version support required for the managed device. When 'True', OS Version 10.9 or later is required to install the app. If 'False', Version 10.9 is not the minimum version. | |
| **V10_10** | Write | Boolean | Indicates the minimum version support required for the managed device. When 'True', OS Version 10.10 or later is required to install the app. If 'False', Version 10.10 is not the minimum version. | |
| **V10_11** | Write | Boolean | Indicates the minimum version support required for the managed device. When 'True', OS Version 10.11 or later is required to install the app. If 'False', Version 10.11 is not the minimum version. | |
| **V10_12** | Write | Boolean | Indicates the minimum version support required for the managed device. When 'True', OS Version 10.12 or later is required to install the app. If 'False', Version 10.12 is not the minimum version. | |
| **V10_13** | Write | Boolean | Indicates the minimum version support required for the managed device. When 'True', OS Version 10.13 or later is required to install the app. If 'False', Version 10.13 is not the minimum version. | |
| **V10_14** | Write | Boolean | Indicates the minimum version support required for the managed device. When 'True', OS Version 10.14 or later is required to install the app. If 'False', Version 10.14 is not the minimum version. | |
| **V10_15** | Write | Boolean | Indicates the minimum version support required for the managed device. When 'True', OS Version 10.15 or later is required to install the app. If 'False', Version 10.15 is not the minimum version. | |
| **V11_0** | Write | Boolean | Indicates the minimum version support required for the managed device. When 'True', OS Version 11.0 or later is required to install the app. If 'False', Version 11.0 is not the minimum version. | |
| **V12_0** | Write | Boolean | Indicates the minimum version support required for the managed device. When 'True', OS Version 12.0 or later is required to install the app. If 'False', Version 12.0 is not the minimum version. | |
| **V13_0** | Write | Boolean | Indicates the minimum version support required for the managed device. When 'True', OS Version 13.0 or later is required to install the app. If 'False', Version 13.0 is not the minimum version. | |
| **V14_0** | Write | Boolean | Indicates the minimum version support required for the managed device. When 'True', OS Version 14.0 or later is required to install the app. If 'False', Version 14.0 is not the minimum version. | |
| **V15_0** | Write | Boolean | Indicates the minimum version support required for the managed device. When 'True', OS Version 15.0 or later is required to install the app. If 'False', Version 15.0 is not the minimum version. | |


## Description

Intune Mobile Apps Bundle types Dmg and Pkg for macOS.

**ATTENTION**

**After creating an app, the content must be manually uploaded via the Intune portal.**

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
        IntuneMobileAppsBundleMacOS "IntuneMobileAppsBundleMacOS-Pkg App"
        {
            Description           = "macOS Pkg App Description";
            Developer             = "Contoso";
            DisplayName           = "macOS Pkg App";
            Ensure                = "Present";
            InformationUrl        = "";
            IsFeatured            = $False;
            MinimumSupportedOperatingSystem = MSFT_MicrosoftGraphMacOSMinimumOperatingSystem{
                V10_7 = $False
                V10_8 = $False
                V10_9 = $False
                V10_10 = $False
                V10_11 = $False
                V10_12 = $False
                V10_13 = $True
                V10_14 = $False
                V10_15 = $False
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
            PackageFileType       = "Pkg";
            PostInstallScript     = "#! Post-install script";
            PreInstallScript      = "#! Pre-install script";
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
        IntuneMobileAppsBundleMacOS "IntuneMobileAppsBundleMacOS-Pkg App"
        {
            Description           = "macOS Pkg App Description";
            Developer             = "Contoso";
            DisplayName           = "macOS Pkg App";
            Ensure                = "Present";
            InformationUrl        = "";
            IsFeatured            = $False;
            MinimumSupportedOperatingSystem = MSFT_MicrosoftGraphMacOSMinimumOperatingSystem{
                V10_7 = $False
                V10_8 = $False
                V10_9 = $False
                V10_10 = $False
                V10_11 = $False
                V10_12 = $False
                V10_13 = $False # Drift
                V10_14 = $True # Drift
                V10_15 = $False
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
            PackageFileType       = "Pkg";
            PostInstallScript     = "#! Post-install script";
            PreInstallScript      = "#! Pre-install script";
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
        IntuneMobileAppsBundleMacOS "IntuneMobileAppsBundleMacOS-Pkg App"
        {
            DisplayName           = "macOS Pkg App";
            PackageFileType       = "Pkg";
            Ensure                = "Absent";
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
```

