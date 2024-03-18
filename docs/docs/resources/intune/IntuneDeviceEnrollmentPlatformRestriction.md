# IntuneDeviceEnrollmentPlatformRestriction

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Write | String | Identity of the device enrollment platform restriction. | |
| **DisplayName** | Key | String | Display name of the device enrollment platform restriction. | |
| **Description** | Write | String | Description of the device enrollment platform restriction. | |
| **DeviceEnrollmentConfigurationType** | Write | String | Support for Enrollment Configuration Type Inherited from deviceEnrollmentConfiguration. | `singlePlatformRestriction`, `platformRestrictions` |
| **IosRestriction** | Write | MSFT_DeviceEnrollmentPlatformRestriction | Ios restrictions based on platform, platform operating system version, and device ownership. | |
| **WindowsRestriction** | Write | MSFT_DeviceEnrollmentPlatformRestriction | Windows restrictions based on platform, platform operating system version, and device ownership. | |
| **WindowsHomeSkuRestriction** | Write | MSFT_DeviceEnrollmentPlatformRestriction | Windows home Sku restrictions based on platform, platform operating system version, and device ownership. | |
| **WindowsMobileRestriction** | Write | MSFT_DeviceEnrollmentPlatformRestriction | Windows Mobile restrictions based on platform, platform operating system version, and device ownership. | |
| **AndroidRestriction** | Write | MSFT_DeviceEnrollmentPlatformRestriction | Android Device Administrator restrictions based on platform, platform operating system version, and device ownership. | |
| **AndroidForWorkRestriction** | Write | MSFT_DeviceEnrollmentPlatformRestriction | Android Enterprise restrictions based on platform, platform operating system version, and device ownership. | |
| **MacRestriction** | Write | MSFT_DeviceEnrollmentPlatformRestriction | Mac restrictions based on platform, platform operating system version, and device ownership. | |
| **MacOSRestriction** | Write | MSFT_DeviceEnrollmentPlatformRestriction | Mac OS restrictions based on platform, platform operating system version, and device ownership. | |
| **Assignments** | Write | MSFT_DeviceManagementConfigurationPolicyAssignments[] | Assignments of the policy. | |
| **Priority** | Write | UInt32 | Priority is used when a user exists in multiple groups that are assigned enrollment configuration. Users are subject only to the configuration with the lowest priority value. Inherited from deviceEnrollmentConfiguration. | |
| **Ensure** | Write | String | Present ensures the restriction exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Intune Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

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

### MSFT_DeviceEnrollmentPlatformRestriction

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **PlatformBlocked** | Write | Boolean | Block the platform from enrolling. | |
| **PersonalDeviceEnrollmentBlocked** | Write | Boolean | Block personally owned devices from enrolling. | |
| **OsMinimumVersion** | Write | String | Min OS version supported. | |
| **OsMaximumVersion** | Write | String | Max OS version supported. | |
| **BlockedManufacturers** | Write | StringArray[] | Collection of blocked Manufacturers. | |
| **BlockedSkus** | Write | StringArray[] | Collection of blocked Skus. | |


## Description

This resource configures the Intune device platform enrollment restrictions.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - DeviceManagementServiceConfig.Read.All

- **Update**

    - DeviceManagementServiceConfig.ReadWrite.All

#### Application permissions

- **Read**

    - DeviceManagementServiceConfig.Read.All

- **Update**

    - DeviceManagementServiceConfig.ReadWrite.All

## Examples

### Example 1

This example creates a new Device Enrollment Platform Restriction.

```powershell
Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneDeviceEnrollmentPlatformRestriction 'DeviceEnrollmentPlatformRestriction'
        {
            AndroidForWorkRestriction         = MSFT_DeviceEnrollmentPlatformRestriction{
                platformBlocked = $False
                personalDeviceEnrollmentBlocked = $False
            };
            AndroidRestriction                = MSFT_DeviceEnrollmentPlatformRestriction{
                platformBlocked = $False
                personalDeviceEnrollmentBlocked = $False
            };
            Assignments                       = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allDevicesAssignmentTarget'
                });
            Credential                        = $Credscredential
            Description                       = "This is the default Device Type Restriction applied with the lowest priority to all users regardless of group membership.";
            DeviceEnrollmentConfigurationType = "platformRestrictions";
            DisplayName                       = "All users and all devices";
            Ensure                            = "Present";
            IosRestriction                    = MSFT_DeviceEnrollmentPlatformRestriction{
                platformBlocked = $False
                personalDeviceEnrollmentBlocked = $False
            };
            MacOSRestriction                  = MSFT_DeviceEnrollmentPlatformRestriction{
                platformBlocked = $False
                personalDeviceEnrollmentBlocked = $False
            };
            MacRestriction                    = MSFT_DeviceEnrollmentPlatformRestriction{
                platformBlocked = $False
                personalDeviceEnrollmentBlocked = $False
            };
            WindowsHomeSkuRestriction         = MSFT_DeviceEnrollmentPlatformRestriction{
                platformBlocked = $False
                personalDeviceEnrollmentBlocked = $False
            };
            WindowsMobileRestriction          = MSFT_DeviceEnrollmentPlatformRestriction{
                platformBlocked = $True
                personalDeviceEnrollmentBlocked = $False
            };
            WindowsRestriction                = MSFT_DeviceEnrollmentPlatformRestriction{
                platformBlocked = $False
                personalDeviceEnrollmentBlocked = $False
            };
        }
    }
}
```

### Example 2

This example creates a new Device Enrollment Platform Restriction.

```powershell
Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneDeviceEnrollmentPlatformRestriction 'DeviceEnrollmentPlatformRestriction'
        {
            AndroidForWorkRestriction         = MSFT_DeviceEnrollmentPlatformRestriction{
                platformBlocked = $False
                personalDeviceEnrollmentBlocked = $False
            };
            AndroidRestriction                = MSFT_DeviceEnrollmentPlatformRestriction{
                platformBlocked = $False
                personalDeviceEnrollmentBlocked = $False
            };
            Assignments                       = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allDevicesAssignmentTarget'
                });
            Credential                        = $Credscredential
            Description                       = "This is the default Device Type Restriction applied with the lowest priority to all users regardless of group membership.";
            DeviceEnrollmentConfigurationType = "platformRestrictions";
            DisplayName                       = "All users and all devices";
            Ensure                            = "Present";
            IosRestriction                    = MSFT_DeviceEnrollmentPlatformRestriction{
                platformBlocked = $True # Updated Property
                personalDeviceEnrollmentBlocked = $False
            };
            MacOSRestriction                  = MSFT_DeviceEnrollmentPlatformRestriction{
                platformBlocked = $False
                personalDeviceEnrollmentBlocked = $False
            };
            MacRestriction                    = MSFT_DeviceEnrollmentPlatformRestriction{
                platformBlocked = $False
                personalDeviceEnrollmentBlocked = $False
            };
            WindowsHomeSkuRestriction         = MSFT_DeviceEnrollmentPlatformRestriction{
                platformBlocked = $False
                personalDeviceEnrollmentBlocked = $False
            };
            WindowsMobileRestriction          = MSFT_DeviceEnrollmentPlatformRestriction{
                platformBlocked = $True
                personalDeviceEnrollmentBlocked = $False
            };
            WindowsRestriction                = MSFT_DeviceEnrollmentPlatformRestriction{
                platformBlocked = $False
                personalDeviceEnrollmentBlocked = $False
            };
        }
    }
}
```

### Example 3

This example creates a new Device Enrollment Platform Restriction.

```powershell
Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneDeviceEnrollmentPlatformRestriction 'DeviceEnrollmentPlatformRestriction'
        {
            Credential                        = $Credscredential
            DisplayName                       = "All users and all devices";
            Ensure                            = "Absent";
        }
    }
}
```

