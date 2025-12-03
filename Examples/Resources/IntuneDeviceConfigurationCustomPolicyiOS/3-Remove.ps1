<#
This example removes a new Intune Custom Configuration Policy for iOs devices
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
    Import-DscResource -ModuleName 'Microsoft365DSC'

    Node localhost
    {
        IntuneDeviceConfigurationCustomPolicyiOS "ConfigureIntuneDeviceConfigurationCustomPolicyiOS"
        {
            Description            = "IntuneDeviceConfigurationCustomPolicyiOS Description";
            DisplayName            = "IntuneDeviceConfigurationCustomPolicyiOS DisplayName";
            Ensure                 = "Absent";
            ApplicationId          = $ApplicationId;
            TenantId               = $TenantId;
            CertificateThumbprint  = $CertificateThumbprint;
        }
    }
}
