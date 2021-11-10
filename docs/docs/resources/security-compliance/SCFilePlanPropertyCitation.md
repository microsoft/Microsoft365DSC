# SCFilePlanPropertyCitation

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies the unique name of the citation. ||
| **CitationUrl** | Write | String | URL of the citation. ||
| **CitationJurisdiction** | Write | String | Jurisdiction of the citation. ||
| **Ensure** | Write | String | Specify if this citation should exist or not. |Present, Absent|
| **Credential** | Required | PSCredential | Credentials of the Exchange Global Admin ||

# SCFilePlanPropertyCitation

### Description

This resource configures a citation entry for Security and
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
        SCFilePlanPropertyCitation 'FilePlanPropertyCitation'
        {
            Name                 = "Demo Citation"
            CitationURL          = "https://contoso.com"
            CitationJurisdiction = "Federal"
            Ensure               = "Present"
            Credential           = $credsGlobalAdmin
        }
    }
}
```

