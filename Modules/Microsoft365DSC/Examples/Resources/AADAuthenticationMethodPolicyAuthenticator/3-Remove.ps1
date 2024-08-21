<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    Import-DscResource -ModuleName Microsoft365DSC

    Node localhost
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
        AADAuthenticationMethodPolicyAuthenticator "AADAuthenticationMethodPolicyAuthenticator-MicrosoftAuthenticator"
        {
            Ensure                = "Absent";
            Id                    = "MicrosoftAuthenticator";
            IncludeTargets        = @(
                MSFT_AADAuthenticationMethodPolicyAuthenticatorIncludeTarget{
                    Id = 'fakegroup6'
                    TargetType = 'group'
                }
            );
            IsSoftwareOathEnabled = $True; # Updated Property
            State                 = "enabled";
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
