﻿# IntuneWifiConfigurationPolicyAndroidEntrepriseDeviceOwner

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **dataType** | Write | String | The type of the target assignment. |#microsoft.graph.groupAssignmentTarget, #microsoft.graph.allLicensedUsersAssignmentTarget, #microsoft.graph.allDevicesAssignmentTarget, #microsoft.graph.exclusionGroupAssignmentTarget, #microsoft.graph.configurationManagerCollectionAssignmentTarget|
| **deviceAndAppManagementAssignmentFilterType** | Write | String | The type of filter of the target assignment i.e. Exclude or Include. Possible values are:none, include, exclude. |none, include, exclude|
| **deviceAndAppManagementAssignmentFilterId** | Write | String | The Id of the filter for the target assignment. ||
| **groupId** | Write | String | The group Id that is the target of the assignment. ||
| **collectionId** | Write | String | The collection Id that is the target of the assignment.(ConfigMgr) ||
| **Id** | Write | String | Id of the Intune policy ||
| **Description** | Write | String | Description of the Intune policy ||
| **DisplayName** | Write | String | Disaply name of the Intune policy ||
| **ConnectAutomatically** | Write | Boolean | If the network is in range, automatically connect. ||
| **ConnectWhenNetworkNameIsHidden** | Write | Boolean | Don't show this Wi-Fi network on an end-user's device in the list of available networks. The SSID will not be broadcasted. ||
| **NetworkName** | Write | String | Network name. ||
| **PreSharedKey** | Write | String | Pre shared key. ||
| **PreSharedKeyIsSet** | Write | Boolean | Pre shared key is set. ||
| **ProxyAutomaticConfigurationUrl** | Write | String | URL of the automatic proxy. ||
| **ProxyExclusionList** | Write | String | Exclusion list of the proxy. ||
| **ProxyManualAddress** | Write | String | Address of the proxy. ||
| **ProxyManualPort** | Write | UInt32 | Port of the proxy. ||
| **ProxySettings** | Write | String | Proxy setting type. |none, manual, automatic|
| **Ssid** | Write | String | Service Set Identifier. The name of the Wi-Fi connection. ||
| **WiFiSecurityType** | Write | String | Type of Wi-Fi profile. |open, wep, wpaPersonal, wpaEnterprise|
| **Assignments** | Write | InstanceArray[] | Represents the assignment to the Intune policy. ||
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Intune Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **ApplicationSecret** | Write | String | Secret of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||


# IntuneWifiConfigurationPolicyAndroidEntrepriseDeviceOwner

### Description

This resource configures an Intune Wifi Configuration Policy Android Entreprise Device Owner Device.


