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
        IntuneUserSettingsPolicyWindows365 "My User Settings Policy for Windows 365"
        {
            DisplayName              = "User Settings Policy W365";
            Ensure                   = "Present";
            Assignments                        = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    dataType = "#microsoft.graph.cloudPcManagementGroupAssignmentTarget"
                    groupId = "42a638ec-2bf2-47a8-8f5f-176ce2124b7b"
                    groupDisplayName = "COGPASS-PROD-CA_AADP2"
                }
            );
            CrossRegionDisasterRecoverySetting = MSFT_MicrosoftGraphcloudPcCrossRegionDisasterRecoverySetting{
                MaintainCrossRegionRestorePointEnabled = $True
                DisasterRecoveryNetworkSetting = MSFT_MicrosoftGraphCloudPcDisasterRecoveryNetworkSetting{
                    RegionName = "automatic"
                    RegionGroup = "switzerland"
                    odataType = "#microsoft.graph.cloudPcDisasterRecoveryMicrosoftHostedNetworkSetting"
                }
                UserInitiatedDisasterRecoveryAllowed = $false
                DisasterRecoveryType = "crossRegion"
            };
            LocalAdminEnabled                  = $True;
            NotificationSetting                = MSFT_MicrosoftGraphcloudPcNotificationSetting{
                RestartPromptsDisabled = $False
            };
            ResetEnabled                       = $True;
            RestorePointSetting                = MSFT_MicrosoftGraphcloudPcRestorePointSetting{
                FrequencyType = "twelveHours"
                UserRestoreEnabled = $True
            };
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
