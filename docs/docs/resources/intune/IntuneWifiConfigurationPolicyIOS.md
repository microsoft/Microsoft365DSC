# IntuneWifiConfigurationPolicyIOS

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
| **ConnectAutomatically** | Write | Boolean | Connect automatically ||
| **ConnectWhenNetworkNameIsHidden** | Write | Boolean | Connect when network name is hidden ||
| **DisableMacAddressRandomization** | Write | Boolean | Disable the MAC address randomization. ||
| **NetworkName** | Write | String | Network name ||
| **PreSharedKey** | Write | String | Pre shared key ||
| **ProxyAutomaticConfigurationUrl** | Write | String | Proxy automatic configuration url ||
| **ProxyManualAddress** | Write | String | Proxy manual address ||
| **ProxyManualPort** | Write | UInt32 | Proxy manual port ||
| **ProxySettings** | Write | String | Proxy settings |none, manual, automatic|
| **Ssid** | Write | String | SSID ||
| **WiFiSecurityType** | Write | String | Wi-Fi security |open, wpaPersonal, wpaEnterprise, wep, wpa2Personal, wpa2Enterprise|
| **Assignments** | Write | InstanceArray[] | Represents the assignment to the Intune policy. ||
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Intune Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **ApplicationSecret** | Write | String | Secret of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. ||


# IntuneWifiConfigurationPolicyIOS

### Description

This resource configures an Intune Wifi Configuration Policy for iOS Device.


