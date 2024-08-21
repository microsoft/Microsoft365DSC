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
        IntuneDeviceConfigurationDeliveryOptimizationPolicyWindows10 'Example'
        {
            Assignments                                               = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allLicensedUsersAssignmentTarget'
                }
            );
            BackgroundDownloadFromHttpDelayInSeconds                  = 4;
            BandwidthMode                                             = MSFT_MicrosoftGraphdeliveryOptimizationBandwidth{
                MaximumDownloadBandwidthInKilobytesPerSecond = 22
                MaximumUploadBandwidthInKilobytesPerSecond = 33
                odataType = '#microsoft.graph.deliveryOptimizationBandwidthAbsolute'
            };
            CacheServerBackgroundDownloadFallbackToHttpDelayInSeconds = 3;
            CacheServerForegroundDownloadFallbackToHttpDelayInSeconds = 3;
            CacheServerHostNames                                      = @("domain.com");
            DeliveryOptimizationMode                                  = "httpWithPeeringPrivateGroup";
            DisplayName                                               = "delivery optimisation";
            Ensure                                                    = "Present";
            ForegroundDownloadFromHttpDelayInSeconds                  = 234;
            GroupIdSource                                             = MSFT_MicrosoftGraphdeliveryOptimizationGroupIdSource{
                GroupIdSourceOption = 'adSite'
                odataType = '#microsoft.graph.deliveryOptimizationGroupIdSourceOptions'
            };
            MaximumCacheAgeInDays                                     = 3;
            MaximumCacheSize                                          = MSFT_MicrosoftGraphdeliveryOptimizationMaxCacheSize{
                MaximumCacheSizeInGigabytes = 4
                odataType = '#microsoft.graph.deliveryOptimizationMaxCacheSizeAbsolute'
            };
            MinimumBatteryPercentageAllowedToUpload                   = 4;
            MinimumDiskSizeAllowedToPeerInGigabytes                   = 3;
            MinimumFileSizeToCacheInMegabytes                         = 3;
            MinimumRamAllowedToPeerInGigabytes                        = 3;
            ModifyCacheLocation                                       = "%systemdrive%";
            RestrictPeerSelectionBy                                   = "subnetMask";
            SupportsScopeTags                                         = $True;
            VpnPeerCaching                                            = "enabled";
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
