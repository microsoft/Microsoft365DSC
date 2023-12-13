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
        IntuneWifiConfigurationPolicyIOS 'myWifiConfigIOSPolicy'
        {
            Id                             = '8e809b9e-0032-40b7-b263-e6029daf8e9c'
            DisplayName                    = 'ios wifi'
            Assignments                    = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments {
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType                                   = '#microsoft.graph.allDevicesAssignmentTarget'
                }
            )
            ConnectAutomatically           = $True
            ConnectWhenNetworkNameIsHidden = $True
            DisableMacAddressRandomization = $True
            NetworkName                    = 'aaaaa'
            ProxyAutomaticConfigurationUrl = 'THSCP.local'
            ProxySettings                  = 'automatic'
            Ssid                           = 'aaaaa'
            WiFiSecurityType               = 'wpaPersonal'
            Ensure                         = 'Present'
            Credential                     = $Credscredential
        }
    }
}
