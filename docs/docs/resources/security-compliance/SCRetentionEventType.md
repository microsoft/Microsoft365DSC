# SCRetentionEventType

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies the unique name of the retention event type. ||
| **Ensure** | Write | String | Specify if this rule should exist or not. |Present, Absent|
| **Comment** | Write | String | The Comment parameter specifies an optional comment. ||
| **Credential** | Required | PSCredential | Credentials of the Exchange Global Admin ||

# SCRetentionEventType

### Description

This resource configures a Retention Event Type in Security and Compliance.

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    Node localhost
    {
        SCRetentionEventType 'RetentionEventType'
        {
            Name       = "DemoEventType"
            Comment    = "Demo event comment"
            Ensure     = "Present"
            Credential = $credsGlobalAdmin
        }
    }
}
```

