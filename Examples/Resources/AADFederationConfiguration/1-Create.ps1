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
        AADFederationConfiguration "MyFederation"
        {
            IssuerUri                       = 'https://contoso.com/issuerUri'
            DisplayName                     = 'contoso display name'
            PassiveSignInUri                = 'https://contoso.com/signin'
            PreferredAuthenticationProtocol = 'wsFed'
            Domains                         = @('contoso.com')
            Ensure                          = 'Present'
            ApplicationId                   = $ApplicationId
            TenantId                        = $TenantId
            CertificateThumbprint           = $CertificateThumbprint
        }
    }
}
