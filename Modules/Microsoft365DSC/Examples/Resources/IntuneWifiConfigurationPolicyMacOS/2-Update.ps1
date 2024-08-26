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
        IntuneWifiConfigurationPolicyMacOS 'myWifiConfigMacOSPolicy'
        {
            DisplayName                    = 'macos wifi'
            Assignments                    = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments {
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType                                   = '#microsoft.graph.allDevicesAssignmentTarget'
                }
            )
            ConnectAutomatically           = $True
            ConnectWhenNetworkNameIsHidden = $False # Updated Property
            NetworkName                    = 'ea1cf5d7-8d3e-40ca-9cb8-b8c8a4c6170b'
            ProxyAutomaticConfigurationUrl = 'AZ500PrivateEndpoint22'
            ProxySettings                  = 'automatic'
            Ssid                           = 'aaaaaaaaaaaaa'
            WiFiSecurityType               = 'wpaPersonal'
            Ensure                         = 'Present'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
