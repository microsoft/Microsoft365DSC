# SCDeviceConditionalAccessPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The name of the Device Conditional Access Policy. ||
| **Ensure** | Write | String | Specify if this policy should exist or not. |Present, Absent|
| **Comment** | Write | String | The Comment parameter specifies an optional comment. ||
| **Enabled** | Write | Boolean | The Enabled parameter specifies whether the policy is enabled. ||
| **Credential** | Required | PSCredential | Credentials of Security and Compliance Center Admin ||

# SCDeviceConditionalAccessPolicy

### Description

This resource configures a Device Conditional Access Policy in Security and Compliance.


