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
        IntuneMobileAppsMacOSLobApp "IntuneMobileAppsMacOSLobApp-TeamsForBusinessInstaller"
        {
            Id                    = "8d027f94-0682-431e-97c1-827d1879fa79";
            Description           = "TeamsForBusinessInstaller";
            Developer             = "Contoso";
            DisplayName           = "TeamsForBusinessInstaller";
            Ensure                = "Absent";
            InformationUrl        = "";
            IsFeatured            = $False;
            Notes                 = "";
            Owner                 = "";
            PrivacyInformationUrl = "";
            Publisher             = "Contoso";
            PublishingState       = "published";
        }
    }
}
