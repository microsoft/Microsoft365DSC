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
            AuthenticationModeConfiguration = MSFT_MicrosoftGraphx509CertificateAuthenticationModeConfiguration{
                X509CertificateAuthenticationDefaultMode = 'x509CertificateSingleFactor'
                Rules = @()
            };
            CertificateUserBindings         = @(
                MSFT_MicrosoftGraphx509CertificateUserBinding{
                    Priority = 1
                    UserProperty = 'userPrincipalName'
                    X509CertificateField = 'PrincipalName'
                }
                MSFT_MicrosoftGraphx509CertificateUserBinding{
                    Priority = 2
                    UserProperty = 'userPrincipalName'
                    X509CertificateField = 'RFC822Name'
                }
                MSFT_MicrosoftGraphx509CertificateUserBinding{
                    Priority = 3
                    UserProperty = 'certificateUserIds'
                    X509CertificateField = 'SubjectKeyIdentifier'
                }
            );
            Credential                      = $Credscredential;
            Ensure                          = "Present";
            ExcludeTargets                  = @(
                MSFT_AADAuthenticationMethodPolicyX509ExcludeTarget{
                    Id = 'DSCGroup'
                    TargetType = 'group'
                }
            );
            Id                              = "X509Certificate";
            IncludeTargets                  = @(
                MSFT_AADAuthenticationMethodPolicyX509IncludeTarget{
                    Id = 'Finance Team'
                    TargetType = 'group'
                }
            );
            State                           = "enabled";
        }
    }
}
