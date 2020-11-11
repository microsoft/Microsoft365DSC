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
        AADPolicy DSCPolicy1
        {
            DisplayName                   = "PolicyDisplayName"
            Definition                    = @('{"TokenIssuancePolicy":{"Version": 1,"SigningAlgorithm": "http://www.w3.org/2000/09/xmldsig#rsa-sha1","TokenResponseSigningPolicy": "TokenOnly","SamlTokenVersion": "2.0"}}')
            IsOrganizationDefault         = $false
            Type                          = "TokenIssuancePolicy"
            Ensure                        = "Present"
            GlobalAdminAccount            = $credsGlobalAdmin
        }
    }
}
