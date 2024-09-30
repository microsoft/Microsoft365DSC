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
        SCInsiderRiskPolicy "SCInsiderRiskPolicy-IRM_Tenant_Setting"
        {
            ApplicationId                                 = $ApplicationId;
            CertificateThumbprint                         = $CertificateThumbprint;
            Ensure                                        = "Absent";
            InsiderRiskScenario                           = "TenantSetting";
            Name                                          = "IRM_Tenant_Setting";
            TenantId                                      = $TenantId;
        }
    }
}
