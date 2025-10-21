# IntuneMobileAppsMicrosoftStoreAppWindows10

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Id** | Write | String | The unique identifier for an entity. Read-only. | |
| **DisplayName** | Key | String | The admin provided or imported title of the app. | |
| **InstallExperience** | Write | MSFT_MicrosoftGraphwinGetAppInstallExperience | The install experience settings associated with this application, which are used to ensure the desired install experiences on the target device are taken into account. This includes the account type (System or User) that actions should be run as on target devices. Cannot be changed after creation. | |
| **PackageIdentifier** | Required | String | The PackageIdentifier from the WinGet source repository REST API. This also maps to the Id when using the WinGet client command line application. Required at creation time, cannot be modified on existing objects. | |
| **Description** | Write | String | The description of the app. | |
| **Developer** | Write | String | The developer of the app. | |
| **InformationUrl** | Write | String | The more information Url. | |
| **IsFeatured** | Write | Boolean | The value indicating whether the app is marked as featured by the admin. | |
| **LargeIcon** | Write | MSFT_MicrosoftGraphMimeContent | The large icon, to be displayed in the app details and used for upload of the icon. | |
| **Notes** | Write | String | Notes for the app. | |
| **Owner** | Write | String | The owner of the app. | |
| **PrivacyInformationUrl** | Write | String | The privacy statement Url. | |
| **Publisher** | Write | String | The publisher of the app. | |
| **Categories** | Write | MSFT_DeviceManagementMobileAppCategory[] | The list of categories for this app. | |
| **RoleScopeTagIds** | Write | StringArray[] | List of scope tag ids for this mobile app. | |
| **Assignments** | Write | MSFT_DeviceManagementWingetMobileAppAssignment[] | Represents the assignment to the Intune policy. | |
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

### MSFT_DeviceManagementWinGetMobileAppAssignmentSettingsRestartSettings

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **countdownDisplayBeforeRestartInMinutes** | Write | SInt32 | The number of minutes to wait before restarting the device after an app installation. | |
| **gracePeriodInMinutes** | Write | SInt32 | The number of minutes before the restart time to display the countdown dialog for pending restarts. | |
| **restartNotificationSnoozeDurationInMinutes** | Write | SInt32 | The number of minutes to snooze the restart notification dialog when the snooze button is selected. | |

### MSFT_DeviceManagementWinGetMobileAppAssignmentSettingsInstallTimeSettings

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **useLocalTime** | Write | Boolean | Whether the local device time or UTC time should be used when determining the available and deadline times. | |
| **startDateTime** | Write | String | The time at which the app should be available for installation. | |
| **deadlineDateTime** | Write | String | The time at which the app should be installed. | |

### MSFT_DeviceManagementMobileAppAssignmentSettings

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **odataType** | Required | String | The odata type of the assignment type. | `#microsoft.graph.iosStoreAppAssignmentSettings`, `#microsoft.graph.win32LobAppAssignmentSettings`, `#microsoft.graph.winGetAppAssignmentSettings`, `#microsoft.graph.windowsUniversalAppXAppAssignmentSettings` |

### MSFT_DeviceManagementWingetMobileAppAssignmentSettings

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **odataType** | Required | String | The odata type of the assignment type. | `#microsoft.graph.iosStoreAppAssignmentSettings`, `#microsoft.graph.win32LobAppAssignmentSettings`, `#microsoft.graph.winGetAppAssignmentSettings`, `#microsoft.graph.windowsUniversalAppXAppAssignmentSettings` |
| **installTimeSettings** | Write | MSFT_DeviceManagementWinGetMobileAppAssignmentSettingsInstallTimeSettings | The install time settings to apply for this app assignment. | |
| **notifications** | Write | String | The notification status for this app assignment. Possible values are: showAll, showReboot, hideAll. | `showAll`, `showReboot`, `hideAll` |
| **restartSettings** | Write | MSFT_DeviceManagementWinGetMobileAppAssignmentSettingsRestartSettings | The reboot settings to apply for this app assignment. | |

### MSFT_DeviceManagementWingetMobileAppAssignment

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
| **assignmentSettings** | Write | MSFT_DeviceManagementWingetMobileAppAssignmentSettings | The settings of the assignment. | |

### MSFT_MicrosoftGraphWinGetAppInstallExperience

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **RunAsAccount** | Write | String | Indicates the type of execution context the app setup runs in on target devices. Options include values of the RunAsAccountType enum, which are System and User. Required at creation time, cannot be modified on existing objects. Possible values are: system, user. | `system`, `user` |

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

Intune Mobile Apps Microsoft Store App for Windows10 (new experience)

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
        IntuneMobileAppsMicrosoftStoreAppWindows10 "IntuneMobileAppsMicrosoftStoreAppWindows10-PowerShell"
        {
            Description           = "PowerShell Description";
            Developer             = "";
            DisplayName           = "PowerShell";
            Ensure                = "Present";
            InstallExperience     = MSFT_MicrosoftGraphWinGetAppInstallExperience{
                RunAsAccount = "system"
            };
            IsFeatured            = $False;
            Notes                 = "";
            Owner                 = "";
            PackageIdentifier     = "9MZ1SNWT0N5D";
            PrivacyInformationUrl = "https://github.com/PowerShell/PowerShell#telemetry";
            Publisher             = "Microsoft Corporation";
            Assignments          = @(
                MSFT_DeviceManagementWingetMobileAppAssignment {
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
            RoleScopeTagIds       = @("0");
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
        IntuneMobileAppsMicrosoftStoreAppWindows10 "IntuneMobileAppsMicrosoftStoreAppWindows10-PowerShell"
        {
            Description           = "PowerShell Description";
            Developer             = "";
            DisplayName           = "PowerShell";
            Ensure                = "Present";
            InstallExperience     = MSFT_MicrosoftGraphWinGetAppInstallExperience{
                RunAsAccount = "system"
            };
            IsFeatured            = $True; # Drift
            Notes                 = "";
            Owner                 = "";
            PackageIdentifier     = "9MZ1SNWT0N5D";
            PrivacyInformationUrl = "https://github.com/PowerShell/PowerShell#telemetry";
            Publisher             = "Microsoft Corporation";
            Assignments          = @(
                MSFT_DeviceManagementWingetMobileAppAssignment {
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
            RoleScopeTagIds       = @("0");
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
        IntuneMobileAppsMicrosoftStoreAppWindows10 "IntuneMobileAppsMicrosoftStoreAppWindows10-PowerShell"
        {
            DisplayName           = "PowerShell App";
            PackageIdentifier     = "9MZ1SNWT0N5D";
            Ensure                = "Absent";
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
```

