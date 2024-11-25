# IntuneAndroidManagedStoreAppConfiguration

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Id** | Write | String | Id of the Intune policy. | |
| **DisplayName** | Key | String | Display name of the Intune policy. | |
| **Description** | Write | String | Admin provided description of the Device Configuration. Inherited from managedDeviceMobileAppConfiguration | |
| **targetedMobileApps** | Write | StringArray[] | the associated app. Inherited from managedDeviceMobileAppConfiguration | |
| **packageId** | Write | String | Android Enterprise app configuration package id. | |
| **payloadJson** | Write | String | Android Enterprise app configuration JSON payload. | |
| **permissionActions** | Write | MSFT_androidPermissionAction[] | List of Android app permissions and corresponding permission actions. | |
| **appSupportsOemConfig** | Write | Boolean | Whether or not this AppConfig is an OEMConfig policy. This property is read-only. | |
| **profileApplicability** | Write | String | Android Enterprise profile applicability (AndroidWorkProfile, DeviceOwner, or default (applies to both)). Possible values are: default, androidWorkProfile, androidDeviceOwner. | `default`, `androidWorkProfile`, `androidDeviceOwner` |
| **connectedAppsEnabled** | Write | Boolean | Setting to specify whether to allow ConnectedApps experience for this app. | |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **Assignments** | Write | MSFT_DeviceManagementConfigurationPolicyAssignments[] | Represents the assignment to the Intune policy. | |
| **Credential** | Write | PSCredential | Credentials of the Intune Admin | |
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
| **dataType** | Write | String | The type of the target assignment. | `#microsoft.graph.groupAssignmentTarget`, `#microsoft.graph.allLicensedUsersAssignmentTarget`, `#microsoft.graph.allDevicesAssignmentTarget`, `#microsoft.graph.exclusionGroupAssignmentTarget`, `#microsoft.graph.configurationManagerCollectionAssignmentTarget` |
| **deviceAndAppManagementAssignmentFilterType** | Write | String | The type of filter of the target assignment i.e. Exclude or Include. Possible values are:none, include, exclude. | `none`, `include`, `exclude` |
| **deviceAndAppManagementAssignmentFilterId** | Write | String | The Id of the filter for the target assignment. | |
| **groupId** | Write | String | The group Id that is the target of the assignment. | |
| **groupDisplayName** | Write | String | The group Display Name that is the target of the assignment. | |
| **collectionId** | Write | String | The collection Id that is the target of the assignment.(ConfigMgr) | |

### MSFT_androidPermissionAction

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **permission** | Write | String | Android permission string, defined in the official Android documentation. Example 'android.permission.READ_CONTACTS'. | |
| **action** | Write | String | Type of Android permission action. Possible values are: prompt, autoGrant, autoDeny. | `prompt`, `autoGrant`, `autoDeny` |


## Description

This resource configures an Intune Android Managed Store Application Configuration Policy.

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

This example creates a new Intune Mobile App Configuration Policy for iOs devices

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
    Import-DscResource -ModuleName 'Microsoft365DSC'

    Node localhost
    {
        IntuneAndroidManagedStoreAppConfiguration "ConfigureIntuneAndroidManagedStoreAppConfiguration"
        {
            Description           = "IntuneAndroidManagedStoreAppConfiguration Description";
            DisplayName           = "IntuneAndroidManagedStoreAppConfiguration DisplayName";
            Ensure                = "Present";
            appSupportsOemConfig  = $False;
            connectedAppsEnabled  = $False;
            packageId             = "app:org.mozilla.firefox";
            payloadJson           = "";
	    permissionActions     = @(
                MSFT_androidPermissionAction{
                    permission = 'android.permission.RECEIVE_SMS'
                }
                MSFT_androidPermissionAction{
                    permission = 'android.permission.READ_SMS'
                }
                MSFT_androidPermissionAction{
                    permission = 'android.permission.RECEIVE_WAP_PUSH'
                }
            );
            profileApplicability  = "androidDeviceOwner";
            targetedMobileApps    = @("30ab8f7a-14fb-4a05-befa-ea7f51141ad9");
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
```

### Example 2

This example creates a new Intune Mobile App Configuration Policy for iOs devices

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
    Import-DscResource -ModuleName 'Microsoft365DSC'

    Node localhost
    {
        IntuneAndroidManagedStoreAppConfiguration "ConfigureIntuneAndroidManagedStoreAppConfiguration"
        {
            Description           = "IntuneAndroidManagedStoreAppConfiguration Description";
            DisplayName           = "IntuneAndroidManagedStoreAppConfiguration DisplayName";
            Ensure                = "Present";
            appSupportsOemConfig  = $False;
            connectedAppsEnabled  = $True; #updated value
            packageId             = "app:org.mozilla.firefox";
            payloadJson           = "";
			permissionActions     = @(
                MSFT_androidPermissionAction{
                    permission = 'android.permission.RECEIVE_SMS'
                }
                MSFT_androidPermissionAction{
                    permission = 'android.permission.READ_SMS'
                }
                MSFT_androidPermissionAction{
                    permission = 'android.permission.RECEIVE_WAP_PUSH'
                }
            );
            profileApplicability  = "androidDeviceOwner";
            targetedMobileApps    = @("30ab8f7a-14fb-4a05-befa-ea7f51141ad9");
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
```

### Example 3

This example creates a new Intune Mobile App Configuration Policy for iOs devices

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
    Import-DscResource -ModuleName 'Microsoft365DSC'

    Node localhost
    {
        IntuneAndroidManagedStoreAppConfiguration "ConfigureIntuneAndroidManagedStoreAppConfiguration"
        {
            Description           = "IntuneAndroidManagedStoreAppConfiguration Description";
            DisplayName           = "IntuneAndroidManagedStoreAppConfiguration DisplayName";
            Ensure                = "Absent";
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
```

