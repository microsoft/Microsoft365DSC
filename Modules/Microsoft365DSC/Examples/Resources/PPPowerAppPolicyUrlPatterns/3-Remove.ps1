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
        PPPowerAppPolicyUrlPatterns "PPPowerAppPolicyUrlPatterns"
        {
            ApplicationId         = $ApplicationId;
            CertificateThumbprint = $CertificateThumbprint;
            Ensure                = "Absent";
            PolicyName            = "DSCPolicy";
            PPTenantId            = "e91d4e0e-d5a5-4e3a-be14-2192592a59af";
            TenantId              = $TenantId;
        }
    }
}
