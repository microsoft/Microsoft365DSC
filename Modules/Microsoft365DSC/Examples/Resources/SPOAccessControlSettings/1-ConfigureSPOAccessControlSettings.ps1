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
        SPOAccessControlSettings MyTenantAccessControlSettings
        {
            IsSingleInstance             = "Yes"
            GlobalAdminAccount           = $credsGlobalAdmin
            DisplayStartASiteOption      = $false
            StartASiteFormUrl            = "https://o365dsc1.sharepoint.com"
            IPAddressEnforcement         = $false
            IPAddressWACTokenLifetime    = 15
            CommentsOnSitePagesDisabled  = $false
            SocialBarOnSitePagesDisabled = $false
            DisallowInfectedFileDownload = $false
            ExternalServicesEnabled      = $true
            EmailAttestationRequired     = $false
            EmailAttestationReAuthDays   = 30
            Ensure                       = "Present"
        }
    }
}
