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
        TeamsAppPermissionPolicy "TeamsAppPermissionPolicy-Test-Policy"
        {
            Credential             = $Credscredential;
            DefaultCatalogApps     = "com.microsoft.teamspace.tab.vsts";
            DefaultCatalogAppsType = "AllowedAppList";
            Description            = "This is a test policy";
            Ensure                 = "Present";
            GlobalCatalogAppsType  = "BlockedAppList";
            Identity               = "TestPolicy";
            PrivateCatalogAppsType = "BlockedAppList";
        }
    }
}
