# SCDeviceConfigurationPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The name of the Device Configuration Policy. ||
| **Ensure** | Write | String | Specify if this policy should exist or not. |Present, Absent|
| **Comment** | Write | String | The Comment parameter specifies an optional comment. ||
| **Enabled** | Write | Boolean | The Enabled parameter specifies whether the policy is enabled. ||
| **Credential** | Required | PSCredential | Credentials of Security and Compliance Center Admin ||

# SCDeviceConfigurationPolicy

### Description

This resource configures a Device Configuration Policy in Security and Compliance.


