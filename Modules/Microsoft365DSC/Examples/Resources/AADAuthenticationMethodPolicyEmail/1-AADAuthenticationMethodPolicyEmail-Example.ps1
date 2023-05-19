<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    Import-DscResource -ModuleName Microsoft365DSC

    Node localhost
    {
        AADAuthenticationMethodPolicyEmail "AADAuthenticationMethodPolicyEmail-Email"
        {
            AllowExternalIdToUseEmailOtp = "default";
            ApplicationId                = $ConfigurationData.NonNodeData.ApplicationId;
            CertificateThumbprint        = $ConfigurationData.NonNodeData.CertificateThumbprint;
            Ensure                       = "Present";
            ExcludeTargets               = @(
                MSFT_AADAuthenticationMethodPolicyEmailExcludeTarget{
                    Id = 'fakegroup1'
                    TargetType = 'group'
                }
                MSFT_AADAuthenticationMethodPolicyEmailExcludeTarget{
                    Id = 'fakegroup2'
                    TargetType = 'group'
                }
            );
            Id                           = "Email";
            IncludeTargets               = @(
                MSFT_AADAuthenticationMethodPolicyEmailIncludeTarget{
                    Id = 'fakegroup3'
                    TargetType = 'group'
                }
                MSFT_AADAuthenticationMethodPolicyEmailIncludeTarget{
                    Id = 'fakegroup4'
                    TargetType = 'group'
                }
            );
            State                        = "enabled";
            TenantId                     = $ConfigurationData.NonNodeData.TenantId;
        }
    }
}
