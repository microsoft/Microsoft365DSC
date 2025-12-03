<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        SPOSiteScript 'ConfigureSiteScript'
        {
            Identity             = "5c73382d-9643-4aa0-9160-d0cba35e40fd"
            Title                = "My Site Script"
            Content              = '{
                "$schema": "schema.json",
                "actions": [
                    {
                      "verb": "setSiteLogo",
                      "url": "https://contoso.sharepoint.com/SiteAssets/company-logo.png"
                    }
                ]
            }'
            Description          = "My custom site script"
            Ensure               = "Present"
            Credential           = $Credscredential
        }
    }
}
