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
        IntuneWiFiConfigurationPolicyAndroidDeviceAdministrator 'myWifiConfigAndroidDevicePolicy'
        {
            Id                             = '41869a42-3217-4bfa-9929-92668fc674c5'
            Assignments                    = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments {
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType                                   = '#microsoft.graph.allDevicesAssignmentTarget'
                }
            )
            ConnectAutomatically           = $False
            ConnectWhenNetworkNameIsHidden = $True
            DisplayName                    = 'Wifi Configuration Androind Device'
            NetworkName                    = 'b71f8c63-8140-4c7e-b818-f9b4aa98b79b'
            Ssid                           = 'sf'
            WiFiSecurityType               = 'wpaEnterprise'
            Ensure                         = 'Present'
            Credential                     = $Credscredential
        }
    }
}
