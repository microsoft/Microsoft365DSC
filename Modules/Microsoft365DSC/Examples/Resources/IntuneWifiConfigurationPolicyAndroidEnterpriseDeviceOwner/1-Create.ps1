<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneWifiConfigurationPolicyAndroidEnterpriseDeviceOwner 'myWifiConfigAndroidDeviceOwnerPolicy'
        {
            DisplayName                    = 'Wifi - androidForWork'
            Assignments                    = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments
                {
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType                                   = '#microsoft.graph.allLicensedUsersAssignmentTarget'
                }
            )
            ConnectAutomatically           = $False
            ConnectWhenNetworkNameIsHidden = $False
            NetworkName                    = 'myNetwork'
            PreSharedKeyIsSet              = $True
            ProxySettings                  = 'none'
            Ssid                           = 'MySSID - 3'
            Ensure                         = 'Present'
            Credential                     = $Credscredential
        }
    }
}
