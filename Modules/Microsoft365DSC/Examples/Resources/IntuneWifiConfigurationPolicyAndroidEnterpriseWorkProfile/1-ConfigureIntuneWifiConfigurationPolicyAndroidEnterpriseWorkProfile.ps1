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
        IntuneWifiConfigurationPolicyAndroidEnterpriseWorkProfile 'myWifiConfigAndroidWorkProfilePolicy'
        {
            Id                             = 'b6c59816-7f9b-4f7a-a2a2-13a29c8bc315'
            DisplayName                    = 'wifi - android BYOD'
            Assignments                    = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments
                {
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType                                   = '#microsoft.graph.allLicensedUsersAssignmentTarget'
                }
            )
            ConnectAutomatically           = $False
            ConnectWhenNetworkNameIsHidden = $False
            NetworkName                    = 'f8b79489-84fc-4434-b964-2a18dfe08f88'
            Ssid                           = 'MySSID'
            WiFiSecurityType               = 'open'
            Ensure                         = 'Present'
            Credential                     = $Credscredential
        }
    }
}
