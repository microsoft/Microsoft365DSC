# SCFilePlanPropertySubCategory

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies the unique name of the sub-category. ||
| **Category** | Required | String | The Category parameter specifies the name of the parent category associated with the sub-category. ||
| **Ensure** | Write | String | Specify if this category should exist or not. |Present, Absent|
| **Credential** | Required | PSCredential | Credentials of the Exchange Global Admin ||

# SCFilePlanPropertySubCategory

### Description

This resource configures a sub-category entry for Security and
Compliance File Plans.

## Examples

### Example 1

This example shows how to create a new File Plan Property Sub-Category.

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
        SCFilePlanPropertySubCategory 'FilePlanPropertySubCategory'
        {
            Name       = "My Sub-Category"
            Category   = "My Category"
            Ensure     = "Present"
            Credential = $credsGlobalAdmin
        }
    }
}
```

