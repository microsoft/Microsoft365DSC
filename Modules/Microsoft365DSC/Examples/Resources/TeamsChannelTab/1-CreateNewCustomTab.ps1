<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        TeamsChannelTab MyWebTab
        {
            ApplicationId         = "12345";
            CertificateThumbprint = "ABCDEF1234567890";
            ChannelName           = "General";
            ContentUrl            = "https://contoso.com";
            DisplayName           = "TestTab"
            Ensure                = "Present"
            SortOrderIndex        = "10100";
            TeamName              = "Contoso Team";
            TeamsApp              = "com.microsoft.teamspace.tab.web";
            TenantId              = "contoso.onmicrosoft.com";
            WebSiteUrl            = "https://contoso.com";
        }
    }
}
