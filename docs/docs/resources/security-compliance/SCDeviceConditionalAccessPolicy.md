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

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        SCDeviceConditionalAccessPolicy 'ConfigureDeviceConditionalAccessPolicy'
        {
            Name                 = "Human Resources"
            Comment              = "Device Conditional Access Policy for Human Resources department"
            Enabled              = $True
            Ensure               = "Present"
            Credential           = $credsGlobalAdmin
        }
    }
}
```

