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
        SPOHubSite 'ConfigureHubSite'
        {
            Url                  = "https://contoso.sharepoint.com/sites/Marketing"
            Title                = "Marketing Hub"
            Description          = "Hub for the Marketing division"
            LogoUrl              = "https://contoso.sharepoint.com/sites/Marketing/SiteAssets/hublogo.png"
            RequiresJoinApproval = $true
            AllowedToJoin        = @("admin@contoso.onmicrosoft.com", "superuser@contoso.onmicrosoft.com")
            SiteDesignId         = "f7eba920-9cca-4de8-b5aa-1da75a2a893c"
            Ensure               = "Present"
            Credential           = $Credscredential
        }
    }
}
