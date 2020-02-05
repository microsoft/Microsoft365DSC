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
    Import-DscResource -ModuleName Office365DSC

    node localhost
    {
        SPOSite DemoSite
        {
            Url                                         = "https://contoso.sharepoint.com/sites/testsite1"
            StorageQuota                                = 26214400
            LocaleId                                    = 1033
            Template                                    = "STS#3"
            GlobalAdminAccount                          = $credsGlobalAdmin
            Owner                                       = "admin@contoso.onmicrosoft.com"
            Title                                       = "TestSite"
            Ensure                                      = "Present"
            StorageQuotaWarningLevel                    = 25574400
            SharingCapability                           = "Disabled"
            CommentsOnSitePagesDisabled                 = $false
            DisableAppViews                             = "NotDisabled"
            DisableCompanyWideSharingLinks              = "NotDisabled"
            DisableFlows                                = $false
            SharingDomainRestrictionMode                = "None"
            SharingAllowedDomainList                    = ""
            SharingBlockedDomainList                    = ""
            DefaultSharingLinkType                      = "None"
            DefaultLinkPermission                       = "None"
        }
    }
}
