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
        AADDomain "AADDomain-Contoso"
        {
            ApplicationId                    = $ApplicationId;
            CertificateThumbprint            = $CertificateThumbprint;
            Ensure                           = "Absent";
            Id                               = "contoso.com";
            TenantId                         = $TenantId;
        }
    }
}
