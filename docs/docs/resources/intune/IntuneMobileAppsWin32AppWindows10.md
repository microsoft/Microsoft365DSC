# IntuneMobileAppsWin32AppWindows10

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Id** | Write | String | The unique identifier for an entity. Read-only. | |
| **DisplayName** | Key | String | The admin provided or imported title of the app. | |
| **Description** | Write | String | The description of the app. | |
| **Developer** | Write | String | The developer of the app. | |
| **InformationUrl** | Write | String | The more information Url. | |
| **IsFeatured** | Write | Boolean | The value indicating whether the app is marked as featured by the admin. | |
| **LargeIcon** | Write | MSFT_DeviceManagementMimeContent | The large icon, to be displayed in the app details and used for upload of the icon. | |
| **Notes** | Write | String | Notes for the app. | |
| **Owner** | Write | String | The owner of the app. | |
| **PrivacyInformationUrl** | Write | String | The privacy statement Url. | |
| **Publisher** | Write | String | The publisher of the app. | |
| **FileName** | Write | String | The file name of the app. Required for creating the resource. | |
| **RoleScopeTagIds** | Write | StringArray[] | List of scope tag ids for this mobile app. | |
| **Categories** | Write | MSFT_DeviceManagementMobileAppCategory[] | The list of categories for this app. | |
| **InstallCommandLine** | Write | String | Indicates the command line to install this app. Used to install the Win32 app. Example: msiexec /i 'Orca.Msi' /qn. | |
| **UninstallCommandLine** | Write | String | Indicates the command line to uninstall this app. Used to uninstall the app. Example: msiexec /x '{85F4CBCB-9BBC-4B50-A7D8-E1106771498D}' /qn. | |
| **AllowedArchitectures** | Write | StringArray[] | Indicates the Windows architecture(s) this app should be installed on. The app will be treated as not applicable for devices with architectures not matching the selected value. The value 'none' cannot be combined with other values. | `none`, `x86`, `x64`, `arm64` |
| **MinimumFreeDiskSpaceInMB** | Write | SInt32 | Indicates the value for the minimum free disk space which is required to install this app. | |
| **MinimumMemoryInMB** | Write | SInt32 | Indicates the value for the minimum physical memory which is required to install this app. | |
| **MinimumNumberOfProcessors** | Write | SInt32 | Indicates the value for the minimum number of processors which is required to install this app. | |
| **MinimumCpuSpeedInMHz** | Write | SInt32 | Indicates the value for the minimum CPU speed which is required to install this app. | |
| **Rules** | Write | MSFT_MicrosoftGraphWin32LobAppRule[] | Indicates the detection and requirement rules for this app. | |
| **InstallExperience** | Write | MSFT_MicrosoftGraphWin32LobAppInstallExperience | Indicates the install experience for this app. | |
| **ReturnCodes** | Write | MSFT_MicrosoftGraphWin32LobAppReturnCode[] | Indicates the return codes for post installation behavior. | |
| **MsiInformation** | Write | MSFT_MicrosoftGraphWin32LobAppMsiInformation | Indicates the MSI details if this Win32 app is an MSI app. | |
| **SetupFilePath** | Write | String | Indicates the relative path of the setup file in the encrypted Win32LobApp package. | |
| **MinimumSupportedWindowsRelease** | Write | String | Indicates the value for the minimum supported windows release. Format for Windows 10: &lt;VersionNumber&gt;, e.g. '1709' or '20H2'. For Windows 11: 'Windows11_&lt;VersionNumber&gt;', e.g. 'Windows11_21H2' | |
| **DisplayVersion** | Write | String | Indicates the version displayed in the UX for this app. Used to set the version of the app. Example: 1.0.3.215. | |
| **AllowAvailableUninstall** | Write | Boolean | Indicates whether the uninstall is supported from the company portal for the Win32 app with an available assignment. When TRUE, indicates that uninstall is supported from the company portal for the Windows app (Win32) with an available assignment. When FALSE, indicates that uninstall is not supported for the Windows app (Win32) with an Available assignment. | |
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

### MSFT_DeviceManagementWin32MobileAppAssignmentSettingsRestartSettings

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **countdownDisplayBeforeRestartInMinutes** | Write | SInt32 | The number of minutes to wait before restarting the device after an app installation. | |
| **gracePeriodInMinutes** | Write | SInt32 | The number of minutes before the restart time to display the countdown dialog for pending restarts. | |
| **restartNotificationSnoozeDurationInMinutes** | Write | SInt32 | The number of minutes to snooze the restart notification dialog when the snooze button is selected. | |

### MSFT_DeviceManagementWin32MobileAppAssignmentSettingsAutoUpdateSettings

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **autoUpdateSupersededAppsState** | Write | String | The auto-update superseded apps setting for the app assignment. Possible values are notConfigured and enabled. Default value is notConfigured. | `enabled`, `notConfigured` |

### MSFT_DeviceManagementWin32MobileAppAssignmentSettingsInstallTimeSettings

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
| **odataType** | Write | String | The odata type of the assignment type. | `#microsoft.graph.win32LobAppAssignmentSettings` |

### MSFT_DeviceManagementWin32MobileAppAssignmentSettings

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **odataType** | Write | String | The odata type of the assignment type. | `#microsoft.graph.win32LobAppAssignmentSettings` |
| **autoUpdateSettings** | Write | MSFT_DeviceManagementWin32MobileAppAssignmentSettingsAutoUpdateSettings | The auto-update settings to apply for this app assignment. | |
| **deliveryOptimizationPriority** | Write | String | The delivery optimization priority for this app assignment. This setting is not supported in National Cloud environments. Possible values are: notConfigured, foreground. | `foreground`, `notConfigured` |
| **installTimeSettings** | Write | MSFT_DeviceManagementWin32MobileAppAssignmentSettingsInstallTimeSettings | The install time settings to apply for this app assignment. | |
| **notifications** | Write | String | The notification status for this app assignment. Possible values are: showAll, showReboot, hideAll. | `showAll`, `showReboot`, `hideAll` |
| **restartSettings** | Write | MSFT_DeviceManagementWin32MobileAppAssignmentSettingsRestartSettings | The reboot settings to apply for this app assignment. | |

### MSFT_DeviceManagementWin32MobileAppAssignment

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
| **assignmentSettings** | Write | MSFT_DeviceManagementWin32MobileAppAssignmentSettings | The settings of the assignment. | |

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

### MSFT_MicrosoftGraphWin32LobAppRule

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **OdataType** | Required | String | The provider rule type. Possible values are: FileSystem, PowerShellScript, Registry | `FileSystem`, `PowerShellScript`, `ProductCode`, `Registry` |
| **RuleType** | Required | String | The type of rule. Possible values are: Detection, Requirement | `Detection`, `Requirement` |
| **Operator** | Write | String | The operator of the rule. Not applicable for the 'ProductCode' odata type. Possible values are: notConfigured, equal, notEqual, greaterThan, greaterThanOrEqual, lessThan, lessThanOrEqual. | `notConfigured`, `equal`, `notEqual`, `greaterThan`, `greaterThanOrEqual`, `lessThan`, `lessThanOrEqual` |
| **ComparisonValue** | Write | String | The value to compare. Not applicable for the 'ProductCode' odata type. | |
| **Check32BitOn64System** | Write | Boolean | A value indicating whether to checking 32-bit on 64-bit system. Only applicable for the 'FileSystem' and 'Registry' odata type. | |
| **Path** | Write | String | The file or folder path to detect Win32 Line of Business (LoB) app. Only applicable for the 'FileSystem' odata type. | |
| **FileOrFolderName** | Write | String | The file or folder name to detect Win32 Line of Business (LoB) app. Only applicable for the 'FileSystem' odata type. | |
| **FileSystemOperationType** | Write | String | The file system comparison operator type. Only applicable for the 'FileSystem' odata type. Possible values are: notConfigured, exists, modifiedDate, createdDate, version, sizeInMB, doesNotExist, sizeInBytes, appVersion. | `notConfigured`, `exists`, `modifiedDate`, `createdDate`, `version`, `sizeInMB`, `doesNotExist`, `sizeInBytes`, `appVersion` |
| **DisplayName** | Write | String | The display name for the rule. Do not specify this value if the rule is used for detection. | |
| **EnforceSignatureCheck** | Write | Boolean | A value indicating whether signature check is enforced. Only Applicable for the 'PowerShellScript' odata type. | |
| **RunAs32Bit** | Write | Boolean | A value indicating whether this script should run as 32-bit. Only Applicable for the 'PowerShellScript' odata type. | |
| **RunAsAccount** | Write | String | Indicates the type of execution context the script runs in. Only Applicable for the 'PowerShellScript' odata type. Possible values are: system, user. | `system`, `user` |
| **Script** | Write | String | The PowerShell script. Only Applicable for the 'PowerShellScript' odata type. | |
| **PowerShellScriptOperationType** | Write | String | The comparison operator type for script output. Only Applicable for the 'PowerShellScript' odata type. Possible values are: notConfigured, string, dateTime, integer, float, version, boolean. | `notConfigured`, `string`, `dateTime`, `integer`, `float`, `version`, `boolean` |
| **ProductCode** | Write | String | The product code of Win32 Line of Business (LoB) app. | |
| **ProductVersionOperator** | Write | String | The operator for detection. Only applicable for the 'ProductCode' odata typ. Possible values are: notConfigured, equal, notEqual, greaterThan, greaterThanOrEqual, lessThan, lessThanOrEqual. | `notConfigured`, `equal`, `notEqual`, `greaterThan`, `greaterThanOrEqual`, `lessThan`, `lessThanOrEqual` |
| **ProductVersion** | Write | String | The product version of Win32 Line of Business (LoB) app. | |
| **KeyPath** | Write | String | The registry key path to detect Win32 Line of Business (LoB) app. | |
| **ValueName** | Write | String | The registry value name. | |
| **RegistryOperationType** | Write | String | The registry data comparison operator type. Only applicable for the 'Registry' odata type. Possible values are: notConfigured, exists, doesNotExist, string, integer, version. | `notConfigured`, `exists`, `doesNotExist`, `string`, `integer`, `version` |

### MSFT_MicrosoftGraphWin32LobAppInstallExperience

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **RunAsAccount** | Write | String | Indicates the type of execution context the app runs in. Possible values are: system, user. | `system`, `user` |
| **MaxRunTimeInMinutes** | Write | SInt32 | The number of minutes the system will wait for install program to finish. Default value is 60 minutes. | |
| **DeviceRestartBehavior** | Write | String | Device restart behavior. Possible values are: basedOnReturnCode, allow, suppress, force. | `basedOnReturnCode`, `allow`, `suppress`, `force` |

### MSFT_MicrosoftGraphWin32LobAppReturnCode

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **ReturnCode** | Write | SInt32 | Return code. | |
| **Type** | Write | String | The type of return code. Possible values are: failed, success, softReboot, hardReboot, retry. | `failed`, `success`, `softReboot`, `hardReboot`, `retry` |

### MSFT_MicrosoftGraphWin32LobAppMsiInformation

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **ProductCode** | Write | String | The MSI product code. | |
| **ProductVersion** | Write | String | The MSI product version. | |
| **UpgradeCode** | Write | String | The MSI upgrade code. | |
| **RequiresReboot** | Write | Boolean | Whether the MSI app requires the machine to reboot to complete installation. | |
| **PackageType** | Write | String | The MSI package type. Possible values are: perMachine, perUser, dualPurpose. | `perMachine`, `perUser`, `dualPurpose` |
| **ProductName** | Write | String | The MSI product name. | |
| **Publisher** | Write | String | The MSI publisher | |


## Description

Intune Mobile Apps Win32 App for Windows10

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
        IntuneMobileAppsWin32AppWindows10 "IntuneMobileAppsWin32AppWindows10-Win32 App - IntuneWinAppUtil.exe"
        {
            AllowAvailableUninstall         = $True;
            AllowedArchitectures            = @("x86","x64","arm64");
            ApplicationId                   = $ApplicationId;
            Assignments                     = @();
            Categories                      = @(
                MSFT_DeviceManagementMobileAppCategory{
                    Id = "2185c6bf-1b3d-4daa-a0bc-79cb4fad9c87"
                    DisplayName = "App Category 1"
                }
            );
            CertificateThumbprint           = $CertificateThumbprint;
            Description                     = "IntuneWinAppUtil.exe";
            Rules                           = @(
                MSFT_MicrosoftGraphWin32LobAppRule{
                    Check32BitOn64System = $False
                    ComparisonValue = "1.0.0.0"
                    FileOrFolderName = "asdf.exe"
                    FileSystemOperationType = "version"
                    Operator = "equal"
                    Path = "C:\temp\Dev"
                    RuleType = "detection"
                    OdataType = "FileSystem"
                }
                MSFT_MicrosoftGraphWin32LobAppRule{
                    Check32BitOn64System = $False
                    RegistryOperationType = "integer"
                    ComparisonValue = "100"
                    Operator = "greaterThanOrEqual"
                    OdataType = "Registry"
                    RuleType = "detection"
                    KeyPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion"
                }
                MSFT_MicrosoftGraphWin32LobAppRule{
                    ProductVersionOperator = "lessThan"
                    ProductVersion = "2.0.0.0"
                    ProductCode = "{00000000-0000-0000-0000-000000000000}"
                    OdataType = "ProductCode"
                    RuleType = "requirement"
                }
                MSFT_MicrosoftGraphWin32LobAppRule{
                    Script = "Write-Output 'Hello World'"
                    DisplayName = "PowerShell Script Rule.ps1"
                    Operator = "equals"
                    RunAs32Bit = $False
                    EnforceSignatureCheck = $False
                    RunAsAccount = "system"
                    OdataType = "PowerShellScript"
                    RuleType = "requirement"
                    PowerShellScriptOperationType = "string"
                    ComparisonValue = "Hello World"
                }
            );
            Developer                       = "";
            DisplayName                     = "Win32 App - IntuneWinAppUtil.exe";
            DisplayVersion                  = "1.0.0.0";
            Ensure                          = "Present";
            FileName                        = "IntuneWinAppUtil.intunewin";
            Id                              = "63271b78-0fa4-46b8-9ac0-d4b777555dde";
            InstallCommandLine              = "IntuneWinAppUtil.exe -s -t 0";
            InstallExperience               = MSFT_MicrosoftGraphWin32LobAppInstallExperience{
                DeviceRestartBehavior = "suppress"
                RunAsAccount = "system"
                MaxRunTimeInMinutes = 60
            };
            IsFeatured                      = $False;
            MinimumCpuSpeedInMHz            = 2500;
            MinimumFreeDiskSpaceInMB        = 1;
            MinimumMemoryInMB               = 200;
            MinimumNumberOfProcessors       = 1;
            MinimumSupportedWindowsRelease  = "1607";
            Notes                           = "";
            Owner                           = "";
            Publisher                       = "Microsoft";
            ReturnCodes                     = @(
                MSFT_MicrosoftGraphWin32LobAppReturnCode{
                    ReturnCode = 0
                    Type = "success"
                }
                MSFT_MicrosoftGraphWin32LobAppReturnCode{
                    ReturnCode = 1707
                    Type = "success"
                }
                MSFT_MicrosoftGraphWin32LobAppReturnCode{
                    ReturnCode = 3010
                    Type = "softReboot"
                }
                MSFT_MicrosoftGraphWin32LobAppReturnCode{
                    ReturnCode = 1641
                    Type = "hardReboot"
                }
                MSFT_MicrosoftGraphWin32LobAppReturnCode{
                    ReturnCode = 1618
                    Type = "retry"
                }
            );
            RoleScopeTagIds                 = @("0");
            SetupFilePath                   = "IntuneWinAppUtil.exe";
            TenantId                        = $TenantId;
            UninstallCommandLine            = "IntuneWinAppUtil.exe -t -s 0";
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
        IntuneMobileAppsWin32AppWindows10 "IntuneMobileAppsWin32AppWindows10-Win32 App - IntuneWinAppUtil.exe"
        {
            AllowAvailableUninstall         = $True;
            AllowedArchitectures            = @("x86","x64","arm64");
            ApplicationId                   = $ApplicationId;
            Assignments                     = @();
            Categories                      = @(
                MSFT_DeviceManagementMobileAppCategory{
                    Id = "2185c6bf-1b3d-4daa-a0bc-79cb4fad9c87"
                    DisplayName = "App Category 1"
                }
            );
            CertificateThumbprint           = $CertificateThumbprint;
            Description                     = "IntuneWinAppUtil.exe";
            Rules                           = @(
                MSFT_MicrosoftGraphWin32LobAppRule{
                    Check32BitOn64System = $False
                    ComparisonValue = "1.0.0.0"
                    FileOrFolderName = "asdf.exe"
                    FileSystemOperationType = "version"
                    Operator = "equal"
                    Path = "C:\temp\Dev"
                    RuleType = "detection"
                    OdataType = "FileSystem"
                }
                MSFT_MicrosoftGraphWin32LobAppRule{
                    Check32BitOn64System = $False
                    RegistryOperationType = "integer"
                    ComparisonValue = "100"
                    Operator = "greaterThanOrEqual"
                    OdataType = "Registry"
                    RuleType = "detection"
                    KeyPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion"
                }
                MSFT_MicrosoftGraphWin32LobAppRule{
                    ProductVersionOperator = "lessThan"
                    ProductVersion = "2.0.0.0"
                    ProductCode = "{00000000-0000-0000-0000-000000000000}"
                    OdataType = "ProductCode"
                    RuleType = "requirement"
                }
                MSFT_MicrosoftGraphWin32LobAppRule{
                    Script = "Write-Output 'Hello World'"
                    DisplayName = "PowerShell Script Rule.ps1"
                    Operator = "equals"
                    RunAs32Bit = $False
                    EnforceSignatureCheck = $False
                    RunAsAccount = "system"
                    OdataType = "PowerShellScript"
                    RuleType = "requirement"
                    PowerShellScriptOperationType = "string"
                    ComparisonValue = "Hello World"
                }
            );
            Developer                       = "";
            DisplayName                     = "Win32 App - IntuneWinAppUtil.exe";
            DisplayVersion                  = "1.0.0.0";
            Ensure                          = "Present";
            FileName                        = "IntuneWinAppUtil.intunewin";
            Id                              = "63271b78-0fa4-46b8-9ac0-d4b777555dde";
            InstallCommandLine              = "IntuneWinAppUtil.exe -s -t 0";
            InstallExperience               = MSFT_MicrosoftGraphWin32LobAppInstallExperience{
                DeviceRestartBehavior = "suppress"
                RunAsAccount = "system"
                MaxRunTimeInMinutes = 120 # Drift
            };
            IsFeatured                      = $False;
            MinimumCpuSpeedInMHz            = 2500;
            MinimumFreeDiskSpaceInMB        = 1;
            MinimumMemoryInMB               = 200;
            MinimumNumberOfProcessors       = 1;
            MinimumSupportedWindowsRelease  = "1607";
            Notes                           = "";
            Owner                           = "";
            Publisher                       = "Microsoft";
            ReturnCodes                     = @(
                MSFT_MicrosoftGraphWin32LobAppReturnCode{
                    ReturnCode = 0
                    Type = "success"
                }
                MSFT_MicrosoftGraphWin32LobAppReturnCode{
                    ReturnCode = 1707
                    Type = "success"
                }
                MSFT_MicrosoftGraphWin32LobAppReturnCode{
                    ReturnCode = 3010
                    Type = "softReboot"
                }
                MSFT_MicrosoftGraphWin32LobAppReturnCode{
                    ReturnCode = 1641
                    Type = "hardReboot"
                }
                MSFT_MicrosoftGraphWin32LobAppReturnCode{
                    ReturnCode = 1618
                    Type = "retry"
                }
            );
            RoleScopeTagIds                 = @("0");
            SetupFilePath                   = "IntuneWinAppUtil.exe";
            TenantId                        = $TenantId;
            UninstallCommandLine            = "IntuneWinAppUtil.exe -t -s 0";
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
        IntuneMobileAppsWin32AppWindows10 "IntuneMobileAppsWin32AppWindows10-Win32 App - IntuneWinAppUtil.exe"
        {
            DisplayName           = "Store App";
            Ensure                = "Absent";
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
```

