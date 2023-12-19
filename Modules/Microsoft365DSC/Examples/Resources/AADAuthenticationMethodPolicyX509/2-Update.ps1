<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsCredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    Node localhost
    {
        AADAuthenticationMethodPolicyX509 "AADAuthenticationMethodPolicyX509-X509Certificate"
        {
            Credential                      = $credsCredential;
            AuthenticationModeConfiguration = MSFT_MicrosoftGraphx509CertificateAuthenticationModeConfiguration{
                Rules = @(@()
                )
                X509CertificateAuthenticationDefaultMode = 'x509CertificateMultiFactor'
            };
            CertificateUserBindings         = @(
                MSFT_MicrosoftGraphx509CertificateUserBinding{
                    Priority = 1
                    UserProperty = 'onPremisesUserPrincipalName'
                    X509CertificateField = 'PrincipalName'
                }
                MSFT_MicrosoftGraphx509CertificateUserBinding{
                    Priority = 2
                    UserProperty = 'onPremisesUserPrincipalName'
                    X509CertificateField = 'RFC822Name'
                }
                MSFT_MicrosoftGraphx509CertificateUserBinding{
                    Priority = 3
                    UserProperty = 'certificateUserIds'
                    X509CertificateField = 'SubjectKeyIdentifier'
                }
            );
            Ensure                          = "Present";
            ExcludeTargets                  = @(
                MSFT_AADAuthenticationMethodPolicyX509ExcludeTarget{
                    Id = 'fakegroup1'
                    TargetType = 'group'
                }
                MSFT_AADAuthenticationMethodPolicyX509ExcludeTarget{
                    Id = 'fakegroup2'
                    TargetType = 'group'
                }
            );
            Id                              = "X509Certificate";
            IncludeTargets                  = @(
                MSFT_AADAuthenticationMethodPolicyX509IncludeTarget{
                    Id = 'fakegroup3'
                    TargetType = 'group'
                }
                MSFT_AADAuthenticationMethodPolicyX509IncludeTarget{
                    Id = 'fakegroup4'
                    TargetType = 'group'
                }
            );
            State                           = "disabled"; # Updated Property
        }
    }
}
