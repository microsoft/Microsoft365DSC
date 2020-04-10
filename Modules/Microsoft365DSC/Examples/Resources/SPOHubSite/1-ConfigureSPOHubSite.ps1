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
        SPOHubSite "ff4a977d-4d7d-4968-9238-2a1702aa699c"
        {
            Url                  = "https://office365dsc.sharepoint.com/sites/Marketing"
            Title                = "Marketing Hub"
            Description          = "Hub for the Marketing division"
            LogoUrl              = "https://office365dsc.sharepoint.com/sites/Marketing/SiteAssets/hublogo.png"
            RequiresJoinApproval = $true
            AllowedToJoin        = @("admin@office365dsc.onmicrosoft.com", "superuser@office365dsc.onmicrosoft.com")
            SiteDesignId         = "f7eba920-9cca-4de8-b5aa-1da75a2a893c"
            Ensure               = "Present"
            GlobalAdminAccount   = $credsGlobalAdmin
        }
    }
}
