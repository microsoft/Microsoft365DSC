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
        EXOPhishSimOverrideRule "EXOPhishSimOverrideRule-_Exe:PhishSimOverr:d779965e-ab14-4dd8-b3f5-0876a99f988b"
        {
            Comment                                  = "New Comment note";
            Ensure                                   = "Present";
            Identity                                 = "_Exe:PhishSimOverr:d779965e-ab14-4dd8-b3f5-0876a99f988b";
            ApplicationId                            = $ApplicationId
            TenantId                                 = $TenantId
            CertificateThumbprint                    = $CertificateThumbprint
        }
    }
}
