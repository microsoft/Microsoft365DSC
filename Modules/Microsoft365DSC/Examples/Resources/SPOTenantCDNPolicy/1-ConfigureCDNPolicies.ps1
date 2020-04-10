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
        SPOTenantCDNPolicy PublicCDNPolicy
        {
            IncludeFileExtensions                = @('.jpg', '.png');
            GlobalAdminAccount                   = $credsGlobalAdmin
            CDNType                              = "Public";
            ExcludeRestrictedSiteClassifications = @();
        }
        SPOTenantCDNPolicy PrivateCDNPolicy
        {
            IncludeFileExtensions                = @('.gif');
            GlobalAdminAccount                   = $credsGlobalAdmin
            CDNType                              = "Private";
            ExcludeRestrictedSiteClassifications = @();
        }
    }
}
