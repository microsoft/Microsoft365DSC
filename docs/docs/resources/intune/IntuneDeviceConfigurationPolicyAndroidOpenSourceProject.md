﻿# IntuneDeviceConfigurationPolicyAndroidOpenSourceProject

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **dataType** | Write | String | The type of the target assignment. |#microsoft.graph.groupAssignmentTarget, #microsoft.graph.allLicensedUsersAssignmentTarget, #microsoft.graph.allDevicesAssignmentTarget, #microsoft.graph.exclusionGroupAssignmentTarget, #microsoft.graph.configurationManagerCollectionAssignmentTarget|
| **deviceAndAppManagementAssignmentFilterType** | Write | String | The type of filter of the target assignment i.e. Exclude or Include. Possible values are:none, include, exclude. |none, include, exclude|
| **deviceAndAppManagementAssignmentFilterId** | Write | String | The Id of the filter for the target assignment. ||
| **groupId** | Write | String | The group Id that is the target of the assignment. ||
| **collectionId** | Write | String | The collection Id that is the target of the assignment.(ConfigMgr) ||
| **Id** | Write | String | Id of the Intune policy. ||
| **Description** | Write | String | Description of the Intune policy. ||
| **DisplayName** | Write | String | Display name of the Intune policy. ||
| **AppsBlockInstallFromUnknownSources** | Write | Boolean | Prevent applications from unknown sources. ||
| **BluetoothBlockConfiguration** | Write | Boolean | Prevent bluetooth configuration. ||
| **BluetoothBlocked** | Write | Boolean | Prevents using Bluetooth on devices. ||
| **CameraBlocked** | Write | Boolean | Prevents access to the device camera. ||
| **FactoryResetBlocked** | Write | Boolean | Prevent factory reset. ||
| **PasswordMinimumLength** | Write | UInt32 | Minimum number of characters required for the password. ||
| **PasswordMinutesOfInactivityBeforeScreenTimeout** | Write | UInt32 | Maximum minutes of inactivity until screen locks. ||
| **PasswordRequiredType** | Write | String | Set password complexity. |deviceDefault, required, numeric, numericComplex, alphabetic, alphanumeric, alphanumericWithSymbols, lowSecurityBiometric, customPassword|
| **PasswordSignInFailureCountBeforeFactoryReset** | Write | UInt32 | Number of sign-in failures before wiping device. ||
| **ScreenCaptureBlocked** | Write | Boolean | Prevent screen capture. ||
| **SecurityAllowDebuggingFeatures** | Write | Boolean | Enable debugging features. ||
| **StorageBlockExternalMedia** | Write | Boolean | Prevent external media. ||
| **StorageBlockUsbFileTransfer** | Write | Boolean | Prevent USB file transfer. ||
| **WifiBlockEditConfigurations** | Write | Boolean | Prevent Wifi configuration edit. ||
| **Assignments** | Write | InstanceArray[] | Represents the assignment to the Intune policy. ||
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Intune Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **ApplicationSecret** | Write | String | Secret of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||

# IntuneDeviceConfigurationPolicyAndroidOpenSourceProject

### Description

This resource configures an Intune device configuration profile for an Android Open Source Project Device.


