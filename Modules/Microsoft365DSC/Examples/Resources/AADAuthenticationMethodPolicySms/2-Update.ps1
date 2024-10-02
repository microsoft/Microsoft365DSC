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
        AADAuthenticationMethodPolicySms "AADAuthenticationMethodPolicySms-Sms"
        {
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            Ensure               = "Present";
            ExcludeTargets       = @(
                MSFT_AADAuthenticationMethodPolicySmsExcludeTarget{
                    Id = 'All Employees'
                    TargetType = 'group'
                }
            );
            Id                   = "Sms";
            IncludeTargets       = @(
                MSFT_AADAuthenticationMethodPolicySmsIncludeTarget{
                    Id = 'all_users'
                    TargetType = 'group'
                }
            );
            State                = "enabled"; # Updated Property
        }
    }
}
