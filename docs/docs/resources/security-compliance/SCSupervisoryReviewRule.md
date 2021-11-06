# SCSupervisoryReviewRule

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies the unique name for the supervisory review policy. The name can't exceed 64 characters. If the value contains spaces, enclose the value in quotation marks. ||
| **Policy** | Key | String | The Policy parameter specifies the supervisory review policy that's assigned to the rule. You can use any value that uniquely identifies the policy. ||
| **Condition** | Write | String | The Condition parameter specifies the conditions and exceptions for the rule. ||
| **SamplingRate** | Write | UInt32 | The SamplingRate parameter specifies the percentage of communications for review. If you want reviewers to review all detected items, use the value 100. ||
| **Ensure** | Write | String | Specify if this rule should exist or not. |Present, Absent|
| **Credential** | Required | PSCredential | Credentials of the Exchange Global Admin ||

# SCSupervisoryReviewRule

### Description

This resource configures a Supervision Review Rule in Security and Compliance.

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
        SCSupervisoryReviewRule 'SupervisoryReviewRule'
        {
            Name         = "DemoRule"
            Condition    = "(NOT(Reviewee:US Compliance))"
            SamplingRate = 100
            Policy       = 'TestPolicy'
            Ensure       = "Present"
            Credential   = $credsGlobalAdmin
        }
    }
}
```

