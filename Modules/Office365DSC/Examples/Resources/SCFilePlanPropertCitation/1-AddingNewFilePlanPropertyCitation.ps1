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
        SCFilePlanPropertyCitation FilePlanPropertyCitation
        {
            Name                 = "My Citation"
            CitationUrl          = "https://contoso.com/MyCitation"
            CitationJurisdiction = "Federal"
            Ensure               = "Present"
            GlobalAdminAccount   = $credsGlobalAdmin
        }
    }
}
