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
        SCComplianceSearchAction DemoPurge
        {
            Action             = "Purge";
            GlobalAdminAccount = $credsGlobalAdmin;
            PurgeType          = "SoftDelete";
            IncludeCredential  = $True;
            Ensure             = "Present";
            RetryOnError       = $False;
            SearchName         = "Demo Search";
        }
        SCComplianceSearchAction DemoExport
        {
            IncludeSharePointDocumentVersions   = $False;
            Action                              = "Export";
            SearchName                          = "Demo Search";
            GlobalAdminAccount                  = $credsGlobalAdmin;
            FileTypeExclusionsForUnindexedItems = $null;
            IncludeCredential                   = $False;
            RetryOnError                        = $False;
            ActionScope                         = "IndexedItemsOnly";
            Ensure                              = "Present";
            EnableDedupe                        = $False;
        }
        SCComplianceSearchAction DemoRetention
        {
            IncludeSharePointDocumentVersions   = $False;
            Action                              = "Retention";
            SearchName                          = "Demo Search";
            GlobalAdminAccount                  = $credsGlobalAdmin;
            FileTypeExclusionsForUnindexedItems = $null;
            IncludeCredential                   = $False;
            RetryOnError                        = $False;
            ActionScope                         = "IndexedItemsOnly";
            Ensure                              = "Present";
            EnableDedupe                        = $False;
        }
    }
}
