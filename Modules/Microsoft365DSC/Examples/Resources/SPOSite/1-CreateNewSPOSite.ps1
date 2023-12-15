<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        SPOSite 'ConfigureTestSite'
        {
            Url                            = "https://contoso.sharepoint.com/sites/testsite1"
            StorageMaximumLevel            = 26214400
            LocaleId                       = 1033
            Template                       = "STS#3"
            Owner                          = "admin@contoso.onmicrosoft.com"
            Title                          = "TestSite"
            TimeZoneId                     = 13
            StorageWarningLevel            = 25574400
            SharingCapability              = "Disabled"
            CommentsOnSitePagesDisabled    = $false
            DisableAppViews                = "NotDisabled"
            DisableCompanyWideSharingLinks = "NotDisabled"
            DisableFlows                   = $false
            DefaultSharingLinkType         = "None"
            DefaultLinkPermission          = "None"
            Ensure                         = "Present"
            Credential                     = $Credscredential
        }
    }
}
