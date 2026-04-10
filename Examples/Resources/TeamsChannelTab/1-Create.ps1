<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        TeamsChannelTab 'ConfigureChannelTab'
        {
            ChannelName           = "General"
            ContentUrl            = "https://contoso.com"
            DisplayName           = "TestTab"
            SortOrderIndex        = "10100"
            TeamName              = "Contoso Team"
            TeamsApp              = "com.microsoft.teamspace.tab.web"
            WebSiteUrl            = "https://contoso.com"
            Ensure                = "Present"
            ApplicationId         = "12345"
            CertificateThumbprint = "ABCDEF1234567890"
            TenantId              = "contoso.onmicrosoft.com"
        }
    }
}
