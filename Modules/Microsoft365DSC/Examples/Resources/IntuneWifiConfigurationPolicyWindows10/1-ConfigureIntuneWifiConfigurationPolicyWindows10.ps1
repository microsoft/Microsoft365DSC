<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneWifiConfigurationPolicyWindows10 'myWifiConfigWindows10Policy'
        {
            Id                             = '2273c683-7590-4c56-81d3-14adb6b3d19c'
            DisplayName                    = 'win10 wifi - revised'
            Assignments                    = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments {
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType                                   = '#microsoft.graph.allDevicesAssignmentTarget'
                }
            )
            ConnectAutomatically           = $True
            ConnectToPreferredNetwork      = $True
            ConnectWhenNetworkNameIsHidden = $True
            ForceFIPSCompliance            = $True
            MeteredConnectionLimit         = 'fixed'
            NetworkName                    = 'MyWifi'
            ProxyAutomaticConfigurationUrl = 'https://proxy.contoso.com'
            ProxySetting                   = 'automatic'
            Ssid                           = 'ssid'
            WifiSecurityType               = 'wpa2Personal'
            Ensure                         = 'Present'
            Credential                     = $Credscredential
        }
    }
}
