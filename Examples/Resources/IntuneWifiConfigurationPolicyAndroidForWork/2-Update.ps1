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
        IntuneWifiConfigurationPolicyAndroidForWork 'Example'
        {
            DisplayName                    = 'AndroindForWork'
            Description                    = 'DSC'
            Assignments                    = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments {
                    dataType                                   = '#microsoft.graph.allLicensedUsersAssignmentTarget'
                    deviceAndAppManagementAssignmentFilterType = 'include'
                    deviceAndAppManagementAssignmentFilterId   = '17cb2318-cd4f-4a66-b742-6b79d4966ac7'
                    groupId                                    = 'b9b732df-9f18-4c5f-99d1-682e151ec62b'
                    collectionId                               = '2a8ea71f-039a-4ec8-8e41-5fba3ef9efba'
                }
            )
            ConnectAutomatically           = $true # Updated Property
            ConnectWhenNetworkNameIsHidden = $true
            NetworkName                    = 'CorpNet'
            Ssid                           = 'WiFi'
            WiFiSecurityType               = 'wpa2Enterprise'
            Ensure                         = 'Present'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
