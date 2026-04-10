<#
This example updates an existing certificate-based application configuration.
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
            Description           = "Updated: Trusted certificate authorities from Contoso";
            DisplayName           = "Contoso Root CA Configuration";
            Ensure                = "Present";
            TenantId              = $TenantId;
            TrustedCertificateAuthorities = @(
                MSFT_AADCertificateBasedApplicationConfigurationTrustedCertificateAuthority{
                    Certificate = "MIIDPzCCAiegAwIBAgIQPbcHn..."
                    IsRootAuthority = $true
                    Issuer = "CN=Contoso Root CA, O=Contoso, C=US"
                    IssuerSubjectKeyIdentifier = "1234567890ABCDEF"
                }
                MSFT_AADCertificateBasedApplicationConfigurationTrustedCertificateAuthority{
                    Certificate = "MIIDQzCCAiugAwIBAgIRAJkLm..."
                    IsRootAuthority = $false
                    Issuer = "CN=Contoso Intermediate CA, O=Contoso, C=US"
                    IssuerSubjectKeyIdentifier = "ABCDEF1234567890"
                }
            );
        }
    }
}
