# SCFilePlanPropertyCategory

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies the unique name of the category. ||
| **Ensure** | Write | String | Specify if this category should exist or not. |Present, Absent|
| **Credential** | Required | PSCredential | Credentials of the Exchange Global Admin ||

# SCFilePlanPropertyCategory

### Description

This resource configures a category entry for Security and
Compliance File Plans.

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

    node localhost
    {
        SCFilePlanPropertyCategory 'FilePlanPropertyCategory'
        {
            Name               = "My Category"
            Ensure             = "Present"
            Credential         = $credsGlobalAdmin
        }
    }
}
```

