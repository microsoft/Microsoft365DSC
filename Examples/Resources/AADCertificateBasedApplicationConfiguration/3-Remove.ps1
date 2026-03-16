<#
This example removes a certificate-based application configuration.
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
        AADCertificateBasedApplicationConfiguration "ContosoRootCA"
        {
            ApplicationId         = $ApplicationId;
            CertificateThumbprint = $CertificateThumbprint;
            DisplayName           = "Contoso Root CA Configuration";
            Ensure                = "Absent";
            TenantId              = $TenantId;
        }
    }
}
