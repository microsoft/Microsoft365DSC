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
        AADCrossTenantIdentitySyncPolicyPartner "AADCrossTenantIdentitySyncPolicyPartner-Fabrikam"
        {
            ApplicationId                                       = $ApplicationId;
            CertificateThumbprint                               = $CertificateThumbprint;
            CrossTenantAccessPolicyConfigurationPartnerTenantId = "e7a80bcf-696e-40ca-8775-a7f85fbb3ebc";
            DisplayName                                         = "IdentitySync";
            Ensure                                              = "Absent";
            IsSyncAllowed                                       = $True;
            TenantId                                            = $TenantId;
        }
    }
}
