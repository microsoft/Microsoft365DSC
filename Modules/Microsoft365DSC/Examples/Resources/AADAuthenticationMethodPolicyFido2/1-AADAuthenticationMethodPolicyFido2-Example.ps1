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
        AADAuthenticationMethodPolicyFido2 "AADAuthenticationMethodPolicyFido2-Fido2"
        {
            ApplicationId                    = $ConfigurationData.NonNodeData.ApplicationId;
            CertificateThumbprint            = $ConfigurationData.NonNodeData.CertificateThumbprint;
            Ensure                           = "Present";
            ExcludeTargets                   = @(
                MSFT_MicrosoftGraphexcludeTarget2{
                    Id = 'fakegroup1'
                    TargetType = 'group'
                }
                MSFT_MicrosoftGraphexcludeTarget2{
                    Id = 'fakegroup2'
                    TargetType = 'group'
                }
            );
            Id                               = "Fido2";
            IncludeTargets                   = @(
                MSFT_MicrosoftGraphincludeTarget2{
                    Id = 'fakegroup3'
                    TargetType = 'group'
                }
                MSFT_MicrosoftGraphincludeTarget2{
                    Id = 'fakegroup4'
                    TargetType = 'group'
                }
            );
            IsAttestationEnforced            = $True;
            IsSelfServiceRegistrationAllowed = $True;
            KeyRestrictions                  = MSFT_MicrosoftGraphfido2KeyRestrictions{
                IsEnforced = $False
                EnforcementType = 'block'
                AaGuids = @()
            };
            State                            = "enabled";
            TenantId                         = $ConfigurationData.NonNodeData.TenantId;
        }
    }
}
