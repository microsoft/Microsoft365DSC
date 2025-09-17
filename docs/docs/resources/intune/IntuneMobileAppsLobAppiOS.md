# IntuneMobileAppsLobAppiOS

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Id** | Write | String | The unique identifier for an entity. Read-only. | |
| **DisplayName** | Key | String | The admin provided or imported title of the app. | |
| **ApplicableDeviceType** | Write | MSFT_MicrosoftGraphIosDeviceType | The iOS architecture for which this app can run on. | |
| **BuildNumber** | Write | String | The build number of iOS Line of Business (LoB) app. | |
| **BundleId** | Write | String | The Identity Name. | |
| **Categories** | Write | MSFT_DeviceManagementMobileAppCategory[] | The list of categories for this app. | |
| **MinimumSupportedOperatingSystem** | Write | MSFT_MicrosoftGraphIosMinimumOperatingSystem | The value for the minimum applicable operating system. | |
| **VersionNumber** | Write | String | The version number of iOS Line of Business (LoB) app. | |
| **FileName** | Write | String | The name of the main Lob application file. | |
| **Description** | Write | String | The description of the app. | |
| **Developer** | Write | String | The developer of the app. | |
| **InformationUrl** | Write | String | The more information Url. | |
| **IsFeatured** | Write | Boolean | The value indicating whether the app is marked as featured by the admin. | |
| **LargeIcon** | Write | MSFT_DeviceManagementMimeContent | The large icon, to be displayed in the app details and used for upload of the icon. | |
| **Notes** | Write | String | Notes for the app. | |
| **Owner** | Write | String | The owner of the app. | |
| **PrivacyInformationUrl** | Write | String | The privacy statement Url. | |
| **Publisher** | Write | String | The publisher of the app. | |
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

### MSFT_MicrosoftGraphIosDeviceType

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IPad** | Write | Boolean | Whether the app should run on iPads. | |
| **IPhoneAndIPod** | Write | Boolean | Whether the app should run on iPhones and iPods. | |

### MSFT_MicrosoftGraphIosMinimumOperatingSystem

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **V10_0** | Write | Boolean | Indicates the minimum iOS version support required for the managed device. When 'True', iOS with OS Version 10.0 or later is required to install the app. If 'False', iOS Version 10.0 is not the minimum version. Default value is False. Exactly one of the minimum operating system boolean values will be TRUE. | |
| **V11_0** | Write | Boolean | Indicates the minimum iOS version support required for the managed device. When 'True', iOS with OS Version 11.0 or later is required to install the app. If 'False', iOS Version 11.0 is not the minimum version. Default value is False. Exactly one of the minimum operating system boolean values will be TRUE. | |
| **V12_0** | Write | Boolean | Indicates the minimum iOS version support required for the managed device. When 'True', iOS with OS Version 12.0 or later is required to install the app. If 'False', iOS Version 12.0 is not the minimum version. Default value is False. Exactly one of the minimum operating system boolean values will be TRUE. | |
| **V13_0** | Write | Boolean | Indicates the minimum iOS version support required for the managed device. When 'True', iOS with OS Version 13.0 or later is required to install the app. If 'False', iOS Version 13.0 is not the minimum version. Default value is False. Exactly one of the minimum operating system boolean values will be TRUE. | |
| **V14_0** | Write | Boolean | Indicates the minimum iOS version support required for the managed device. When 'True', iOS with OS Version 14.0 or later is required to install the app. If 'False', iOS Version 14.0 is not the minimum version. Default value is False. Exactly one of the minimum operating system boolean values will be TRUE. | |
| **V15_0** | Write | Boolean | Indicates the minimum iOS version support required for the managed device. When 'True', iOS with OS Version 15.0 or later is required to install the app. If 'False', iOS Version 15.0 is not the minimum version. Default value is False. Exactly one of the minimum operating system boolean values will be TRUE. | |
| **V16_0** | Write | Boolean | Indicates the minimum iOS version support required for the managed device. When 'True', iOS with OS Version 16.0 or later is required to install the app. If 'False', iOS Version 16.0 is not the minimum version. Default value is False. Exactly one of the minimum operating system boolean values will be TRUE. | |
| **V17_0** | Write | Boolean | Indicates the minimum iOS version support required for the managed device. When 'True', iOS with OS Version 17.0 or later is required to install the app. If 'False', iOS Version 17.0 is not the minimum version. Default value is False. Exactly one of the minimum operating system boolean values will be TRUE. | |
| **V18_0** | Write | Boolean | Indicates the minimum iOS version support required for the managed device. When 'True', iOS with OS Version 18.0 or later is required to install the app. If 'False', iOS Version 18.0 is not the minimum version. Default value is False. Exactly one of the minimum operating system boolean values will be TRUE. | |
| **V8_0** | Write | Boolean | Indicates the minimum iOS version support required for the managed device. When 'True', iOS with OS Version 8.0 or later is required to install the app. If 'False', iOS Version 8.0  is not the minimum version. Default value is False. Exactly one of the minimum operating system boolean values will be TRUE. | |
| **V9_0** | Write | Boolean | Indicates the minimum iOS version support required for the managed device. When 'True', iOS with OS Version 9.0 or later is required to install the app. If 'False', iOS Version 9.0 is not the minimum version. Default value is False. Exactly one of the minimum operating system boolean values will be TRUE. | |

### MSFT_DeviceManagementMimeContent

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Type** | Write | String | Indicates the type of content mime. | |
| **Value** | Write | String | The Base64 encoded string content. | |

### MSFT_DeviceManagementMobileAppCategory

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | The name of the app category. | |
| **Id** | Write | String | The unique identifier for an entity. Read-only. | |


## Description

Intune Mobile Apps Lob App for iOS

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
        IntuneMobileAppsLobAppiOS "IntuneMobileAppsLobAppiOS-IPA iOS App"
        {
            ApplicableDeviceType            = MSFT_MicrosoftGraphIosDeviceType{
                IPad = $True
                IPhoneAndIPod = $True
            };
            ApplicationId                   = $ApplicationId;
            Assignments                     = @(
                MSFT_DeviceManagementMobileAppAssignment {
                    groupDisplayName = 'All devices'
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allDevicesAssignmentTarget'
                    intent = 'required'
                }
            );
            BuildNumber                     = "1";
            BundleId                        = "com.microsoft.azureauthenticator";
            Categories                      = @(
                MSFT_DeviceManagementMobileAppCategory{
                    Id = "2185c6bf-1b3d-4daa-a0bc-79cb4fad9c87"
                    DisplayName = "App Category 1"
                }
            );
            CertificateThumbprint           = $CertificateThumbprint;
            Description                     = "Example IPA iOS App";
            Developer                       = "";
            DisplayName                     = "Example IPA iOS App";
            Ensure                          = "Present";
            FileName                        = "Example.ipa";
            Id                              = "63271b78-0fa4-46b8-9ac0-d4b777555dde";
            IsFeatured                      = $False;
            MinimumSupportedOperatingSystem = MSFT_MicrosoftGraphIosMinimumOperatingSystem{
                V8_0 = $False
                V9_0 = $False
                V10_0 = $False
                V11_0 = $False
                V12_0 = $False
                V13_0 = $False
                V14_0 = $False
                V15_0 = $False
                V16_0 = $True
                V17_0 = $False
                V18_0 = $False
            };
            Notes                           = "";
            Owner                           = "";
            Publisher                       = "Microsoft";
            RoleScopeTagIds                 = @("0");
            TenantId                        = $TenantId;
            VersionNumber                   = "6.8.26";
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
        IntuneMobileAppsLobAppiOS "IntuneMobileAppsLobAppiOS-IPA iOS App"
        {
            ApplicableDeviceType            = MSFT_MicrosoftGraphIosDeviceType{
                IPad = $True
                IPhoneAndIPod = $True
            };
            ApplicationId                   = $ApplicationId;
            Assignments                     = @(
                MSFT_DeviceManagementMobileAppAssignment {
                    groupDisplayName = 'All devices'
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allDevicesAssignmentTarget'
                    intent = 'required'
                }
            );
            BuildNumber                     = "1";
            BundleId                        = "com.microsoft.azureauthenticator";
            Categories                      = @(
                MSFT_DeviceManagementMobileAppCategory{
                    Id = "2185c6bf-1b3d-4daa-a0bc-79cb4fad9c87"
                    DisplayName = "App Category 1"
                }
            );
            CertificateThumbprint           = $CertificateThumbprint;
            Description                     = "Example IPA iOS App";
            Developer                       = "";
            DisplayName                     = "Example IPA iOS App";
            Ensure                          = "Present";
            FileName                        = "Example.ipa";
            Id                              = "63271b78-0fa4-46b8-9ac0-d4b777555dde";
            IsFeatured                      = $False;
            MinimumSupportedOperatingSystem = MSFT_MicrosoftGraphIosMinimumOperatingSystem{
                V8_0 = $False
                V9_0 = $False
                V10_0 = $False
                V11_0 = $False
                V12_0 = $False
                V13_0 = $False
                V14_0 = $False
                V15_0 = $False
                V16_0 = $False
                V17_0 = $True # Updated property
                V18_0 = $False
            };
            Notes                           = "";
            Owner                           = "";
            Publisher                       = "Microsoft";
            RoleScopeTagIds                 = @("0");
            TenantId                        = $TenantId;
            VersionNumber                   = "6.8.26";
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
        IntuneMobileAppsLobAppiOS "IntuneMobileAppsLobAppiOS-IPA iOS App"
        {
            DisplayName           = "Example IPA iOS App";
            Ensure                = "Absent";
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
```

