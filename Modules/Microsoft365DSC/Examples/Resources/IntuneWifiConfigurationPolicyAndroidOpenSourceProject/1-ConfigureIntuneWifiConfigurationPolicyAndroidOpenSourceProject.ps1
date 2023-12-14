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
        IntuneWifiConfigurationPolicyAndroidOpenSourceProject 'myWifiConfigAndroidOpensourcePolicy'
        {
            Id                             = 'fe0a93dc-e9cc-4d4b-8dd6-361c51c70f77'
            DisplayName                    = 'wifi aosp'
            Assignments                    = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments {
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType                                   = '#microsoft.graph.allDevicesAssignmentTarget'
                }
            )
            ConnectAutomatically           = $False
            ConnectWhenNetworkNameIsHidden = $True
            NetworkName                    = 'aaaa'
            PreSharedKeyIsSet              = $True
            Ssid                           = 'aaaaa'
            WiFiSecurityType               = 'wpaPersonal'
            Ensure                         = 'Present'
            Credential                     = $Credscredential
        }
    }
}
