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
        AADAuthenticationMethodPolicyFido2 "AADAuthenticationMethodPolicyFido2-Fido2"
        {
            Ensure                           = "Present";
            ExcludeTargets                   = @(
                MSFT_AADAuthenticationMethodPolicyFido2ExcludeTarget{
                    Id = 'fakegroup1'
                    TargetType = 'group'
                }
                MSFT_AADAuthenticationMethodPolicyFido2ExcludeTarget{
                    Id = 'fakegroup2'
                    TargetType = 'group'
                }
            );
            Id                               = "Fido2";
            IncludeTargets                   = @(
                MSFT_AADAuthenticationMethodPolicyFido2IncludeTarget{
                    Id = 'fakegroup3'
                    TargetType = 'group'
                }
                MSFT_AADAuthenticationMethodPolicyFido2IncludeTarget{
                    Id = 'fakegroup4'
                    TargetType = 'group'
                }
            );
            IsAttestationEnforced            = $False; # Updated Property
            IsSelfServiceRegistrationAllowed = $True;
            KeyRestrictions                  = MSFT_MicrosoftGraphfido2KeyRestrictions{
                IsEnforced = $False
                EnforcementType = 'block'
                AaGuids = @()
            };
            State                            = "enabled";
            Credential                       = $credsCredential;
        }
    }
}
