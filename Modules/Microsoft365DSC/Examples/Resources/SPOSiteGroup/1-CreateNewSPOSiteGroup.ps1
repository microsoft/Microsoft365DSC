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
        SPOSiteGroup ee4a977d-4d7d-4968-9238-2a1702aa699c
        {
            Url                                         = "https://office365dsc.sharepoint.com/sites/testsite1"
            Identity                                    = "TestSiteGroup1"
            Owner                                       = "admin@Office365DSC.onmicrosoft.com"
            PermissionLevels                            = @("Edit", "Read")
            Ensure                                      = "Present"
            GlobalAdminAccount                          = $credsGlobalAdmin
        }

        SPOSiteGroup adfd6217-29de-4297-95d4-7004455d3daa
        {
            Url                                         = "https://office365dsc.sharepoint.com/sites/testsite1"
            Identity                                    = "TestSiteGroup2"
            Owner                                       = "admin@Office365DSC.onmicrosoft.com"
            PermissionLevels                            = @("Edit", "Read")
            Ensure                                      = "Present"
            GlobalAdminAccount                          = $credsGlobalAdmin
        }
    }
}
