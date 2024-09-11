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
            Comment                                  = "Comment note";
            Domains                                  = @("fabrikam.com","wingtiptoys.com");
            Ensure                                   = "Present";
            Identity                                 = "_Exe:PhishSimOverr:d779965e-ab14-4dd8-b3f5-0876a99f988b";
            Policy                                   = "fc55717b-28bb-4cf3-98ee-9ba57903c978";
            SenderIpRanges                           = @("192.168.1.55");
            ApplicationId                            = $ApplicationId
            TenantId                                 = $TenantId
            CertificateThumbprint                    = $CertificateThumbprint
        }
    }
}
