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
        SPOSiteGroup 'ConfigureTestSiteGroup1'
        {
            Url              = "https://contoso.sharepoint.com/sites/testsite1"
            Identity         = "TestSiteGroup1"
            Owner            = "admin@contoso.onmicrosoft.com"
            PermissionLevels = @("Edit", "Read")
            Ensure           = "Present"
            Credential       = $Credscredential
        }

        SPOSiteGroup 'ConfigureTestSiteGroup2'
        {
            Url              = "https://contoso.sharepoint.com/sites/testsite1"
            Identity         = "TestSiteGroup2"
            Owner            = "admin@contoso.onmicrosoft.com"
            PermissionLevels = @("Edit", "Read")
            Ensure           = "Present"
            Credential       = $Credscredential
        }
    }
}
