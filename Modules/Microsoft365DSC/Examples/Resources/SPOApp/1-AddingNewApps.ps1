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
        SPOApp ee4a977d-4d7d-4968-9238-2a1702aa699c
        {
            Identity           = "DemoApp"
            Path               = "C:\Demo\DemoApp.sppkg"
            Publish            = $true
            GlobalAdminAccount = $credsGlobalAdmin
            Ensure             = "Present"
        }

        SPOApp ee4a977d-4eee-4968-9238-2a1702aa1234
        {
            Identity           = "DemoApp2"
            Path               = "C:\Demo\DemoApp2.app"
            Publish            = $true
            GlobalAdminAccount = $credsGlobalAdmin
            Ensure             = "Present"
        }
    }
}
