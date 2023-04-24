<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    Node localhost
    {
        AADAuthenticationMethodPolicyX509 "AADAuthenticationMethodPolicyX509-X509Certificate"
        {
            ApplicationId                   = $ConfigurationData.NonNodeData.ApplicationId;
            AuthenticationModeConfiguration = MSFT_MicrosoftGraphx509CertificateAuthenticationModeConfiguration{
                Rules = @(@()
                )
                X509CertificateAuthenticationDefaultMode = 'x509CertificateMultiFactor'
            };
            CertificateThumbprint           = $ConfigurationData.NonNodeData.CertificateThumbprint;
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
                MSFT_MicrosoftGraphexcludeTarget2{
                    Id = 'fakegroup1'
                    TargetType = 'group'
                }
                MSFT_MicrosoftGraphexcludeTarget2{
                    Id = 'fakegroup2'
                    TargetType = 'group'
                }
            );
            Id                              = "X509Certificate";
            IncludeTargets                  = @(
                MSFT_MicrosoftGraphincludeTarget2{
                    Id = 'fakegroup3'
                    TargetType = 'group'
                }
                MSFT_MicrosoftGraphincludeTarget2{
                    Id = 'fakegroup4'
                    TargetType = 'group'
                }
            );
            State                           = "enabled";
            TenantId                        = $ConfigurationData.NonNodeData.TenantId;
        }
    }
}
