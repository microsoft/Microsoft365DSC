<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Import-DscResource -ModuleName Microsoft365DSC
    node localhost
    {
        SentinelWatchlist "SentinelWatchlist-TestWatch"
        {
            Alias                 = "MyAlias";
            ApplicationId         = $ApplicationId;
            CertificateThumbprint = $CertificateThumbprint;
            DefaultDuration       = "P1DT3H";
            Description           = "My description";
            DisplayName           = "My Display Name";
            Ensure                = "Absent";
            ItemsSearchKey        = "Test";
            Name                  = "MyWatchList";
            NumberOfLinesToSkip   = 1;
            RawContent            = 'MyContent'
            ResourceGroupName     = "MyResourceGroup";
            SourceType            = "Local";
            SubscriptionId        = "20f41296-9edc-4374-b5e0-b1c1aa07e7d3";
            TenantId              = $TenantId;
            WorkspaceName         = "MyWorkspace";
        }
    }
}
