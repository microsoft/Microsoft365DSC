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
        AADDomainFederation "AADDomainFederation-contoso.com"
        {
            ActiveSignInUri                         = "https://adfs.contoso.com/adfs/services/trust/2005/usernamemixed";
            ApplicationId                           = $ApplicationId;
            CertificateThumbprint                   = $CertificateThumbprint;
            DisplayName                             = "Contoso Federation - Updated";
            DomainId                                = "contoso.com";
            Ensure                                  = "Present";
            FederatedIdpMfaBehavior                 = "enforceMfaByFederatedIdp"; # Changed from acceptIfMfaDoneByFederatedIdp
            IssuerUri                               = "http://contoso.com/adfs/services/trust";
            IsSignedAuthenticationRequestRequired   = $False; # Changed from True
            MetadataExchangeUri                     = "https://adfs.contoso.com/FederationMetadata/2007-06/FederationMetadata.xml";
            NextSigningCertificate                  = "MIIDdzCCAl+gAwIBAgIQYZZkFRHsCgAAAABBAgAAYDANBgkqhkiG9w0BAQsFADA3MTUwMwYDVQQDEyxBREZTIFNpZ25pbmcgLSBhZGZzLmNvbnRvc28uY29tIDIwMjUwMTAxMDAwMDAwMB4XDTI1MDEwMTAwMDAwMFoXDTI2MTIzMTIzNTk1OVowNzE1MDMGA1UEAxMsQURGUyBTaWduaW5nIC0gYWRmcy5jb250b3NvLmNvbSAyMDI1MDEwMTAwMDAwMDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALi6tLmfJLCBPKPONMQChLO5z7hLBUCCdHIWP8MdPshEAL+Wq/N0bH8o8Y4Ct5f3QkS1HvqVpFJVxmT8j+KeqgYM3Cj2gYAhBjKKEQEWWLJOVxqmHVxqTQqGfCBJLOENMQChLO5z7hLBUCCdHIWP8MdPshEAL+Wq"; # New certificate being staged for rollover
            PasswordResetUri                        = "https://adfs.contoso.com/adfs/portal/updatepassword/";
            PassiveSignInUri                        = "https://adfs.contoso.com/adfs/ls/";
            PreferredAuthenticationProtocol         = "saml"; # Changed from wsFed
            SigningCertificate                      = "MIIDdzCCAl+gAwIBAgIQXWWjEQHsCgAAAABBAgAAYDANBgkqhkiG9w0BAQsFADA3MTUwMwYDVQQDEyxBREZTIFNpZ25pbmcgLSBhZGZzLmNvbnRvc28uY29tIDIwMjQwMTAxMDAwMDAwMB4XDTI0MDEwMTAwMDAwMFoXDTI1MTIzMTIzNTk1OVowNzE1MDMGA1UEAxMsQURGUyBTaWduaW5nIC0gYWRmcy5jb250b3NvLmNvbSAyMDI0MDEwMTAwMDAwMDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKh5sLmfJLCBPKPONMQChLO5z7hLBUCCdHIWP8MdPshEAL+Wq/N0bH8o8Y4Ct5f3QkS1HvqVpFJVxmT8j+KeqgYM3Cj2gYAhBjKKEQEWWLJOVxqmHVxqTQqGfCBJLOENMQChLO5z7hLBUCCdHIWP8MdPshEAL+Wq";
            SignOutUri                              = "https://adfs.contoso.com/adfs/ls/?wa=wsignout1.0";
            TenantId                                = $TenantId;
        }
    }
}
