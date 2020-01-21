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
        SPOHomeSite "ff4a977d-4d7d-4968-9238-2a1702aa699c"
        {
            IsSingleInstance     = "Yes"
            Url                  = "https://office365dsc.sharepoint.com/sites/Marketing"
            Ensure               = "Present"
            GlobalAdminAccount   = $credsGlobalAdmin
        }
    }
}
