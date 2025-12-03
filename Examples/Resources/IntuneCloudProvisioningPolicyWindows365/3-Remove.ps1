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
        IntuneCloudProvisioningPolicyWindows365 "IntuneCloudProvisioningPolicyWindows365_1"
        {
            ApplicationId            = $ApplicationId;
            DisplayName              = "IntuneCloudProvisioningPolicyWindows365_1";
            Ensure                   = "Absent";
            CertificateThumbprint    = $CertificateThumbprint;
            TenantId                 = $TenantId;
        }
    }
}
