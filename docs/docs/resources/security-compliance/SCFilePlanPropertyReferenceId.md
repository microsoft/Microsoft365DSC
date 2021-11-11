# SCFilePlanPropertyReferenceId

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies the unique name of the reference id. ||
| **Ensure** | Write | String | Specify if this reference id should exist or not. |Present, Absent|
| **Credential** | Required | PSCredential | Credentials of the Exchange Global Admin ||

# SCFilePlanPropertyReferenceId

### Description

This resource configures a reference ID entry for Security and
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
        SCFilePlanPropertyReferenceId 'FilePlanPropertyReferenceId'
        {
            Name               = "My Reference ID"
            Ensure             = "Present"
            Credential         = $credsGlobalAdmin
        }
    }
}
```

