# SCFilePlanPropertyAuthority

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies the unique name of the Authority. ||
| **Ensure** | Write | String | Specify if this authority should exist or not. |Present, Absent|
| **Credential** | Required | PSCredential | Credentials of the Exchange Global Admin ||

# SCFilePlanPropertyAuthority

### Description

This resource configures an authority entry for Security and
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
        SCFilePlanPropertyAuthority 'FilePlanPropertyAuthority'
        {
            Name               = "My Authority"
            Ensure             = "Present"
            Credential         = $credsGlobalAdmin
        }
    }
}
```

