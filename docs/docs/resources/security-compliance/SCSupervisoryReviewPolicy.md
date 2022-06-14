# SCSupervisoryReviewPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies the unique name for the supervisory review policy. The name can't exceed 64 characters. If the value contains spaces, enclose the value in quotation marks. ||
| **Comment** | Write | String | The Comment parameter specifies an optional comment. If you specify a value that contains spaces, enclose the value in quotation marks. ||
| **Reviewers** | Required | StringArray[] | The Reviewers parameter specifies the SMTP addresses of the reviewers for the supervisory review policy. You can specify multiple email addresses separated by commas. ||
| **Ensure** | Write | String | Specify if this rule should exist or not. |Present, Absent|
| **Credential** | Required | PSCredential | Credentials of the Exchange Global Admin ||

# SCSupervisoryReviewPolicy

### Description

This resource configures a Supervision Policy in Security and Compliance.

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
        SCSupervisoryReviewPolicy 'SupervisoryReviewPolicy'
        {
            Name       = "MyPolicy"
            Comment    = "Test Policy"
            Reviewers  = @("admin@contoso.com")
            Ensure     = "Present"
            Credential = $credsGlobalAdmin
        }
    }
}
```

