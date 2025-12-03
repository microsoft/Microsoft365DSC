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
        IntuneWifiConfigurationPolicyWindows10 'myWifiConfigWindows10Policy'
        {
            DisplayName                    = 'win10 wifi - revised'
            Assignments                    = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments {
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType                                   = '#microsoft.graph.allDevicesAssignmentTarget'
                }
            )
            ConnectAutomatically           = $True
            ConnectToPreferredNetwork      = $False # Updated Property
            ConnectWhenNetworkNameIsHidden = $True
            ForceFIPSCompliance            = $True
            MeteredConnectionLimit         = 'fixed'
            NetworkName                    = 'MyWifi'
            ProxyAutomaticConfigurationUrl = 'https://proxy.contoso.com'
            ProxySetting                   = 'automatic'
            Ssid                           = 'ssid'
            WifiSecurityType               = 'wpa2Personal'
            Ensure                         = 'Present'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
