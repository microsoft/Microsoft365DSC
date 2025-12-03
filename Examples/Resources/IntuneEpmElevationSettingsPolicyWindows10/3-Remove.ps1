<#
This example removes a Device Control Policy.
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
        IntuneEpmElevationSettingsPolicyWindows10 'Example'
        {
            DisplayName                 = "IntuneEpmElevationSettingsPolicyWindows10_1";
            Ensure                      = "Absent";
            Id                          = '00000000-0000-0000-0000-000000000000'
            ApplicationId               = $ApplicationId;
            TenantId                    = $TenantId;
            CertificateThumbprint       = $CertificateThumbprint;
        }
    }
}
