<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param
    (
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
        IntuneWifiConfigurationPolicyAndroidEnterpriseWorkProfile 'myWifiConfigAndroidWorkProfilePolicy'
        {
            DisplayName                    = 'wifi - android BYOD'
            Assignments                    = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments
                {
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType                                   = '#microsoft.graph.allLicensedUsersAssignmentTarget'
                }
            )
            ConnectAutomatically           = $True # Updated Property
            ConnectWhenNetworkNameIsHidden = $False
            NetworkName                    = 'f8b79489-84fc-4434-b964-2a18dfe08f88'
            Ssid                           = 'MySSID'
            WiFiSecurityType               = 'open'
            Ensure                         = 'Present'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
