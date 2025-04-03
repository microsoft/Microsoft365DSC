# IntuneAppConfigurationPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Id** | Write | String | Key of the entity. Read-Only. | |
| **DisplayName** | Key | String | Display name of the app configuration policy. | |
| **Description** | Write | String | Description of the app configuration policy. | |
| **Assignments** | Write | MSFT_DeviceManagementConfigurationPolicyAssignments[] | Assignments of the Intune Policy. | |
| **CustomSettings** | Write | MSFT_IntuneAppConfigurationPolicyCustomSetting[] | Custom settings for the app cnfiguration policy. | |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Intune Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |
| **roleScopeTagIds** | Write | StringArray[] | List of Scope Tags for this Entity instance. | |
| **targetedAppManagementLevels** | Write | String | The intended app management levels for this policy. | `unspecified`, `unmanaged`, `mdm`, `androidEnterprise`, `androidEnterpriseDedicatedDevicesWithAzureAdSharedMode`, `androidOpenSourceProjectUserAssociated`, `androidOpenSourceProjectUserless`, `unknownFutureValue` |
| **appGroupType** | Write | String | Public Apps selection: group or individual. | `selectedPublicApps`, `allCoreMicrosoftApps`, `allMicrosoftApps`, `allApps` |
| **Apps** | Write | MSFT_managedMobileApp[] | List of apps to which the policy is deployed. | |

### MSFT_DeviceManagementConfigurationPolicyAssignments

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **dataType** | Write | String | The type of the target assignment. | `#microsoft.graph.groupAssignmentTarget`, `#microsoft.graph.allLicensedUsersAssignmentTarget`, `#microsoft.graph.allDevicesAssignmentTarget`, `#microsoft.graph.exclusionGroupAssignmentTarget`, `#microsoft.graph.configurationManagerCollectionAssignmentTarget` |
| **deviceAndAppManagementAssignmentFilterType** | Write | String | The type of filter of the target assignment i.e. Exclude or Include. Possible values are:none, include, exclude. | `none`, `include`, `exclude` |
| **deviceAndAppManagementAssignmentFilterId** | Write | String | The Id of the filter for the target assignment. | |
| **groupId** | Write | String | The group Id that is the target of the assignment. | |
| **groupDisplayName** | Write | String | The group Display Name that is the target of the assignment. | |
| **collectionId** | Write | String | The collection Id that is the target of the assignment.(ConfigMgr) | |

### MSFT_IntuneAppConfigurationPolicyCustomSetting

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **name** | Write | String | Name of the custom setting. | |
| **value** | Write | String | Value of the custom setting. | |

### MSFT_managedMobileApp

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **id** | Write | String | Key of the entity. | |
| **mobileAppIdentifier** | Write | MSFT_AppIdentifier[] | The identifier for an app with it's operating system type. | |

### MSFT_AppIdentifier

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **bundleID** | Write | String | AppId iOS. | |
| **packageID** | Write | String | AppId Android. | |
| **windowsAppId** | Write | String | AppId Windows. | |


## Description

This resource configures the Intune App configuration policies.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Group.Read.All, DeviceManagementApps.Read.All

- **Update**

    - Group.Read.All, DeviceManagementApps.ReadWrite.All

#### Application permissions

- **Read**

    - Group.Read.All, DeviceManagementApps.Read.All

- **Update**

    - Group.Read.All, DeviceManagementApps.ReadWrite.All

## Examples

### Example 1

This example creates a new App Configuration Policy.

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
        IntuneAppConfigurationPolicy 'AddAppConfigPolicy'
        {
            DisplayName          = 'ContosoNew'
            Description          = 'New Contoso Policy'
            CustomSettings       = @(
                MSFT_IntuneAppConfigurationPolicyCustomSetting {
                    name  = 'com.microsoft.intune.mam.managedbrowser.BlockListURLs'
                    value = 'https://www.aol.com'
                }
                MSFT_IntuneAppConfigurationPolicyCustomSetting {
                    name  = 'com.microsoft.intune.mam.managedbrowser.bookmarks'
                    value = 'Outlook Web|https://outlook.office.com||Bing|https://www.bing.com'
                }
                MSFT_IntuneAppConfigurationPolicyCustomSetting {
                    name  = 'Test'
                    value = 'TestValue'
                });
            Ensure      = 'Present'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
```

### Example 2

This example creates a new App Configuration Policy.

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
        IntuneAppConfigurationPolicy 'AddAppConfigPolicy'
        {
            DisplayName          = 'ContosoNew'
            Description          = 'New Contoso Policy'
            CustomSettings       = @(
                MSFT_IntuneAppConfigurationPolicyCustomSetting {
                    name  = 'com.microsoft.intune.mam.managedbrowser.BlockListURLs'
                    value = 'https://www.aol.com'
                }
                MSFT_IntuneAppConfigurationPolicyCustomSetting {
                    name  = 'com.microsoft.intune.mam.managedbrowser.bookmarks'
                    value = 'Outlook Web|https://outlook.office.com||Bing|https://www.bing.com'
                }
                MSFT_IntuneAppConfigurationPolicyCustomSetting { # Updated Property
                    name  = 'Test2'
                    value = 'TestValue2'
                });
            Ensure      = 'Present'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
```

### Example 3

This example creates a new App Configuration Policy.

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
        IntuneAppConfigurationPolicy 'AddAppConfigPolicy'
        {
            DisplayName = 'ContosoNew'
            Description = 'New Contoso Policy'
            Ensure      = 'Absent'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
```

