<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADUser 'ConfigureJohnSMith'
        {
            UserPrincipalName  = "John.Smith@$TenantId"
            FirstName          = "John"
            LastName           = "Smith"
            DisplayName        = "John J. Smith"
            City               = "Gatineau"
            Country            = "Canada"
            Office             = "Ottawa - Queen"
            UsageLocation      = "US"
            Ensure             = "Present"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
