# IntuneMobileAppsLobAppMsiWindows10

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Id** | Write | String | The unique identifier for an entity. Read-only. | |
| **DisplayName** | Key | String | The admin provided or imported title of the app. | |
| **FileName** | Write | String | The name of the main Lob application file. Required for creating the app. | |
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
| **Categories** | Write | MSFT_DeviceManagementMobileAppCategory[] | The list of categories for this app. | |
| **CommandLine** | Write | String | The command line. | |
| **IgnoreVersionDetection** | Write | Boolean | A boolean to control whether the app's version will be used to detect the app after it is installed on a device. Set this to true for Windows Mobile MSI Line of Business (LoB) apps that use a self update feature. | |
| **UseDeviceContext** | Write | Boolean | Indicates whether to install a dual-mode MSI in the device context. If true, app will be installed for all users. If false, app will be installed per-user. If null, service will use the MSI package's default install context. In case of dual-mode MSI, this default will be per-user. Cannot be set for non-dual-mode apps. Cannot be changed after initial creation of the application. | |
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


## Description

Intune Mobile Apps Lob App MSI for Windows10

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
        IntuneMobileAppsLobAppMsiWindows10 "IntuneMobileAppsLobAppMsiWindows10-MSI App"
        {
            ApplicationId                   = $ApplicationId;
            Assignments                     = @(
                MSFT_DeviceManagementMobileAppAssignment {
                    groupDisplayName = 'All devices'
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allDevicesAssignmentTarget'
                    intent = 'required'
                }
            );
            Categories                      = @(
                MSFT_DeviceManagementMobileAppCategory{
                    Id = "2185c6bf-1b3d-4daa-a0bc-79cb4fad9c87"
                    DisplayName = "App Category 1"
                }
            );
            CertificateThumbprint           = $CertificateThumbprint;
            Description                     = "MSI App Description";
            Developer                       = "";
            DisplayName                     = "MSI App";
            Ensure                          = "Present";
            FileName                        = "MSIApp.msi";
            CommandLine                     = "-arg1 -arg2";
            IgnoreVersionDetection = $True;
            IsFeatured                      = $False;
            Notes                           = "";
            Owner                           = "";
            Publisher                       = "Microsoft";
            RoleScopeTagIds                 = @("0");
            TenantId                        = $TenantId;
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
        IntuneMobileAppsLobAppMsiWindows10 "IntuneMobileAppsLobAppMsiWindows10-MSI App"
        {
            ApplicationId                   = $ApplicationId;
            Assignments                     = @(
                MSFT_DeviceManagementMobileAppAssignment {
                    groupDisplayName = 'All devices'
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allDevicesAssignmentTarget'
                    intent = 'required'
                }
            );
            Categories                      = @(
                MSFT_DeviceManagementMobileAppCategory{
                    Id = "2185c6bf-1b3d-4daa-a0bc-79cb4fad9c87"
                    DisplayName = "App Category 1"
                }
            );
            CertificateThumbprint           = $CertificateThumbprint;
            Description                     = "MSI App Description";
            Developer                       = "";
            DisplayName                     = "MSI App";
            Ensure                          = "Present";
            FileName                        = "MSIApp.msi";
            CommandLine                     = "-arg1 -arg2";
            IgnoreVersionDetection = $True;
            IsFeatured                      = $True; # Updated property
            Notes                           = "";
            Owner                           = "";
            Publisher                       = "Microsoft";
            RoleScopeTagIds                 = @("0");
            TenantId                        = $TenantId;
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
        IntuneMobileAppsLobAppMsiWindows10 "IntuneMobileAppsLobAppMsiWindows10-MSI App"
        {
            DisplayName           = "MSI App";
            Ensure                = "Absent";
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
```

