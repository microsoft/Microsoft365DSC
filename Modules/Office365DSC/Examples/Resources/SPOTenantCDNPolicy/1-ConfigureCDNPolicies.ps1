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
        SPOTenantCDNPolicy PublicCDNPolicy
        {
            IncludeFileExtensions                = @('.jpg', '.png');
            ExcludeIfNoScriptDisabled            = "False";
            GlobalAdminAccount                   = $credsGlobalAdmin
            CDNType                              = "Public";
            ExcludeRestrictedSiteClassifications = @();
        }
        SPOTenantCDNPolicy PrivateCDNPolicy
        {
            IncludeFileExtensions                = @('.gif');
            ExcludeIfNoScriptDisabled            = "False";
            GlobalAdminAccount                   = $credsGlobalAdmin
            CDNType                              = "Private";
            ExcludeRestrictedSiteClassifications = @();
        }
    }
}
