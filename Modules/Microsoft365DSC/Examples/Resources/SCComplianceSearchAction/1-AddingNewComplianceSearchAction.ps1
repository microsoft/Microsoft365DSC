<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

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
