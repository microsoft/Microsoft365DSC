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
        IntuneCustomizationBrandingProfile "IntuneCustomizationBrandingProfile-Company"
        {
            ApplicationId                  = $ApplicationId;
            CertificateThumbprint          = $CertificateThumbprint;
            DisplayName                    = "Company";
            ProfileName                    = "IntuneCustomizationBrandingProfile_1";
            Ensure                         = "Absent";
            TenantId                       = $TenantId;
        }
    }
}
