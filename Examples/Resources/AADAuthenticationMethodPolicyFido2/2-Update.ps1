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

    Node localhost
    {
        AADAuthenticationMethodPolicyFido2 "AADAuthenticationMethodPolicyFido2-Fido2"
        {
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            Ensure                           = "Present";
            ExcludeTargets                   = @(
                MSFT_AADAuthenticationMethodPolicyFido2ExcludeTarget{
                    Id = 'Paralegals'
                    TargetType = 'group'
                }
                MSFT_AADAuthenticationMethodPolicyFido2ExcludeTarget{
                    Id = 'Executives'
                    TargetType = 'group'
                }
            );
            Id                               = "Fido2";
            IncludeTargets                   = @(
                MSFT_AADAuthenticationMethodPolicyFido2IncludeTarget{
                    Id = 'all_users'
                    TargetType = 'group'
                }
            );
            IsAttestationEnforced            = $False;
            IsSelfServiceRegistrationAllowed = $True;
            KeyRestrictions                  = MSFT_MicrosoftGraphfido2KeyRestrictions{
                IsEnforced = $False
                EnforcementType = 'block'
                AaGuids = @()
            };
            State                            = "enabled"; # Updated Property
        }
    }
}
