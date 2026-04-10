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
        AADAuthenticationMethodPolicyEmail "AADAuthenticationMethodPolicyEmail-Email"
        {
            AllowExternalIdToUseEmailOtp = "enabled";
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            Ensure                       = "Present";
            ExcludeTargets               = @(
                MSFT_AADAuthenticationMethodPolicyEmailExcludeTarget{
                    Id = 'Paralegals'
                    TargetType = 'group'
                }
            );
            Id                           = "Email";
            IncludeTargets               = @(
                MSFT_AADAuthenticationMethodPolicyEmailIncludeTarget{
                    Id = 'Finance Team'
                    TargetType = 'group'
                }
                MSFT_AADAuthenticationMethodPolicyEmailIncludeTarget{
                    Id = 'Legal Team'
                    TargetType = 'group'
                }
            );
            State                        = "enabled"; # Updated Property
        }
    }
}
