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
        IntuneMobileAppsBuiltInStoreApp "IntuneMobileAppsBuiltInStoreApp-Store App"
        {
            AppStoreUrl           = "https://play.google.com/store/apps/details?id=com.contoso.app";
            BundleId              = "com.contoso.app";
            TargetPlatform        = "Android";
            Description           = "Store App Description";
            Developer             = "Contoso";
            DisplayName           = "Builtin Store App";
            Ensure                = "Present";
            InformationUrl        = "";
            IsFeatured            = $False;
            Notes                 = "";
            Owner                 = "";
            PrivacyInformationUrl = "";
            Publisher             = "Contoso";
            MinimumSupportedOperatingSystem = MSFT_MicrosoftGraphMinimumOperatingSystem{
                V4_0 = $False
                V4_0_3 = $False
                V4_1 = $False
                V4_2 = $False
                V4_3 = $False
                V4_4 = $False
                V5_0 = $False
                V5_1 = $False
                V6_0 = $False
                V7_0 = $False
                V7_1 = $False
                V8_0 = $True
                V8_1 = $False
                V9_0 = $False
                V10_0 = $False
                V11_0 = $False
                V12_0 = $False
                V13_0 = $False
                V14_0 = $False
                V15_0 = $False
            };
            Assignments          = @(
                MSFT_DeviceManagementMobileAppAssignment {
                    groupDisplayName = 'All devices'
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allDevicesAssignmentTarget'
                    intent = 'required'
                }
            );
            Categories             = @(
                MSFT_DeviceManagementMobileAppCategory{
                    Id = "2185c6bf-1b3d-4daa-a0bc-79cb4fad9c87"
                    DisplayName = "App Category 1"
                }
            );
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
