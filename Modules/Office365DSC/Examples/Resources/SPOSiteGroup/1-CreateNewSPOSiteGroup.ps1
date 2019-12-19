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
        SPOSiteGroup ee4a977d-4d7d-4968-9238-2a1702aa699c
        {
            Url                                         = "https://office365dsc.sharepoint.com/sites/testsite1"
            Identity                                    = "TestSiteGroup"
            Owner                                       = "admin@Office365DSC.onmicrosoft.com"
            PermissionLevels                            = @("Edit", "Read")
            Ensure                                      = "Present"
            GlobalAdminAccount                          = $credsGlobalAdmin
            
        }
    }
}
