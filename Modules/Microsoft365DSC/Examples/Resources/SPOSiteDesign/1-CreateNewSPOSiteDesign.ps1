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
        SPOSiteDesign SiteDesign
        {
            Title               = "DSC Site Design"
            SiteScriptNames     = @("Cust List", "List_Views")
            WebTemplate         = "TeamSite"
            IsDefault           = $false
            Description         = "Created by DSC"
            PreviewImageAltText = "Office 365"
            Ensure              = "Present"
            GlobalAdminAccount  = $credsGlobalAdmin
        }
    }
}
