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
    node localhost
    {
        AADAuthenticationMethodPolicyQRCodeImage "AADAuthenticationMethodPolicyQRCodeImage-QRCodePin"
        {
            ApplicationId                = $ApplicationId;
            CertificateThumbprint        = $CertificateThumbprint;
            Ensure                       = "Absent";
            Id                           = "QRCodePin";
            IncludeTargets               = @(
                MSFT_AADAuthenticationMethodPolicyQRCodeImageIncludeTarget{
                    Id = "all_users"
                    TargetType = "group"
                }
            );
            PinLength                    = 9; # Drift
            StandardQRCodeLifetimeInDays = 365;
            State                        = "disabled";
            TenantId                     = $TenantId;
        }
    }
}
