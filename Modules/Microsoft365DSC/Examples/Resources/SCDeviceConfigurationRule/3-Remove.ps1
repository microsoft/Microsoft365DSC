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
        SCDeviceConfigurationRule "MyDeviceConfigurationRule"
        {
            ApplicationId             = $ApplicationId;
            CertificateThumbprint     = $CertificateThumbprint;
            Ensure                    = "Absent";
            Name                      = "MyDeviceConfigurationPolicy{2b18}";
            Policy                    = "MyDeviceConfigurationPolicy";
            TenantId                  = $TenantId;
        }
    }
}
