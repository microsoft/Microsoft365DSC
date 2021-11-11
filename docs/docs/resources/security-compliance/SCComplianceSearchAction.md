# SCComplianceSearchAction

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Action** | Key | String | The Action parameter specifies what type of action to define. Accepted values are Export, Retention and Purge. |Export, Preview, Purge, Retention|
| **SearchName** | Key | String | The SearchName parameter specifies the name of the existing content search to associate with the content search action. You can specify multiple content searches separated by commas. ||
| **FileTypeExclusionsForUnindexedItems** | Write | StringArray[] | The FileTypeExclusionsForUnindexedItems specifies the file types to exclude because they can't be indexed. You can specify multiple values separated by commas. ||
| **EnableDedupe** | Write | Boolean | The EnableDedupe parameter eliminates duplication of messages when you export content search results. ||
| **IncludeCredential** | Write | Boolean | The IncludeCredential switch specifies whether to include the credential in the results. ||
| **IncludeSharePointDocumentVersions** | Write | Boolean | The IncludeSharePointDocumentVersions parameter specifies whether to export previous versions of the document when you use the Export switch. ||
| **PurgeType** | Write | String | The PurgeType parameter specifies how to remove items when the action is Purge. |SoftDelete, HardDelete|
| **RetryOnError** | Write | Boolean | The RetryOnError switch specifies whether to retry the action on any items that failed without re-running the entire action all over again. ||
| **ActionScope** | Write | String | The ActionScope parameter specifies the items to include when the action is Export. |IndexedItemsOnly, UnindexedItemsOnly, BothIndexedAndUnindexedItems|
| **Ensure** | Write | String | Specify if this action should exist or not. |Present, Absent|
| **Credential** | Required | PSCredential | Credentials of the Exchange Global Admin ||

# SCComplianceSearchAction

### Description

This resource configures a Compliance Search Action in Security and Compliance.

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
        SCComplianceSearchAction 'ComplianceSearchActionPurge'
        {
            Action            = "Purge"
            PurgeType         = "SoftDelete"
            IncludeCredential = $True
            RetryOnError      = $False
            SearchName        = "Demo Search"
            Ensure            = "Present"
            Credential        = $credsGlobalAdmin
        }

        SCComplianceSearchAction 'ComplianceSearchActionExport'
        {
            IncludeSharePointDocumentVersions   = $False
            Action                              = "Export"
            SearchName                          = "Demo Search"
            FileTypeExclusionsForUnindexedItems = $null
            IncludeCredential                   = $False
            RetryOnError                        = $False
            ActionScope                         = "IndexedItemsOnly"
            EnableDedupe                        = $False
            Ensure                              = "Present"
            Credential                          = $credsGlobalAdmin
        }

        SCComplianceSearchAction 'ComplianceSearchActionRetention'
        {
            IncludeSharePointDocumentVersions   = $False
            Action                              = "Retention"
            SearchName                          = "Demo Search"
            FileTypeExclusionsForUnindexedItems = $null
            IncludeCredential                   = $False
            RetryOnError                        = $False
            ActionScope                         = "IndexedItemsOnly"
            EnableDedupe                        = $False
            Ensure                              = "Present"
            Credential                          = $credsGlobalAdmin
        }
    }
}
```

