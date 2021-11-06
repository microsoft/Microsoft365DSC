# SCDLPCompliancePolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies the unique name of the DLP policy. If the value contains spaces, enclose the value in quotation marks. ||
| **Comment** | Write | String | The Comment parameter specifies an optional comment. ||
| **ExchangeLocation** | Write | StringArray[] | The ExchangeLocation parameter specifies Exchange Online mailboxes to include in the DLP policy. You can only use the value All for this parameter to include all mailboxes. ||
| **ExchangeSenderMemberOf** | Write | StringArray[] | Exchange members to include. ||
| **ExchangeSenderMemberOfException** | Write | StringArray[] | Exchange members to exclude. ||
| **Mode** | Write | String | The Mode parameter specifies the action and notification level of the DLP policy. Valid values are: Enable, TestWithNotifications, TestWithoutNotifications, Disable and PendingDeletion. |Enable, TestWithNotifications, TestWithoutNotifications, Disable, PendingDeletion|
| **OneDriveLocation** | Write | StringArray[] | The OneDriveLocation parameter specifies the OneDrive for Business sites to include. You identify the site by its URL value, or you can use the value All to include all sites. ||
| **OneDriveLocationException** | Write | StringArray[] | This parameter specifies the OneDrive for Business sites to exclude when you use the value All for the OneDriveLocation parameter. You identify the site by its URL value. ||
| **Priority** | Write | UInt32 | Priority for the Policy. ||
| **SharePointLocation** | Write | StringArray[] | The SharePointLocation parameter specifies the SharePoint Online sites to include. You identify the site by its URL value, or you can use the value All to include all sites. ||
| **SharePointLocationException** | Write | StringArray[] | This parameter specifies the SharePoint Online sites to exclude when you use the value All for the SharePointLocation parameter. You identify the site by its URL value. ||
| **TeamsLocation** | Write | StringArray[] | Teams locations to include ||
| **TeamsLocationException** | Write | StringArray[] | Teams locations to exclude. ||
| **Ensure** | Write | String | Specify if this policy should exist or not. |Present, Absent|
| **Credential** | Required | PSCredential | Credentials of the Exchange Global Admin ||

# SCDLPCompliancePolicy

### Description

This resource configures a Data Loss Prevention Compliance
Policy in Security and Compliance Center.

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
        SCDLPCompliancePolicy 'ConfigureCompliancePolicy'
        {
            Name               = "MyPolicy"
            Comment            = "Test Policy"
            Priority           = 1
            SharePointLocation = "https://contoso.sharepoint.com/sites/demo"
            Ensure             = "Present"
            Credential         = $credsGlobalAdmin
        }
    }
}
```

