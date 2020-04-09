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
        O365User JohnSMith
        {
            UserPrincipalName  = "John.Smith@O365DSC1.onmicrosoft.com"
            FirstName          = "John"
            LastName           = "Smith"
            DisplayName        = "John J. Smith"
            City               = "Gatineau"
            Country            = "Canada"
            Office             = "Ottawa - Queen"
            LicenseAssignment  = @("O365dsc1:ENTERPRISEPREMIUM")
            UsageLocation      = "US"
            Ensure             = "Present"
            GlobalAdminAccount = $credsGlobalAdmin
        }
    }
}
