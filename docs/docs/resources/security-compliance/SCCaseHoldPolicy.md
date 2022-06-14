# SCCaseHoldPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies the unique name of the case hold policy. ||
| **Case** | Key | String | The Case parameter specifies the eDiscovery case that you want to associate with the case hold policy. ||
| **Comment** | Write | String | The Comment parameter specifies an optional comment. ||
| **Enabled** | Write | Boolean | The Enabled parameter specifies whether the policy is enabled or disabled. ||
| **ExchangeLocation** | Write | StringArray[] | The ExchangeLocation parameter specifies the mailboxes to include in the policy. ||
| **PublicFolderLocation** | Write | StringArray[] | The PublicFolderLocation parameter specifies that you want to include all public folders in the case hold policy. You use the value All for this parameter. ||
| **SharePointLocation** | Write | StringArray[] | The SharePointLocation parameter specifies the SharePoint Online and OneDrive for Business sites to include. You identify a site by its URL value. ||
| **Ensure** | Write | String | Specify if this policy should exist or not. |Present, Absent|
| **Credential** | Required | PSCredential | Credentials of the Global Admin ||

# SCCaseHoldPolicy

### Description

This resource configures a eDiscovery Case Policy
in Security and Compliance Center.

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
        SCCaseHoldPolicy 'CaseHoldPolicy'
        {
            Case                 = "Test Case"
            ExchangeLocation     = "DemoGroup@contoso.onmicrosoft.com"
            Name                 = "Demo Hold"
            PublicFolderLocation = "All"
            Comment              = "This is a demo"
            Enabled              = $True
            Ensure               = "Present"
            Credential           = $credsGlobalAdmin
        }
    }
}
```

