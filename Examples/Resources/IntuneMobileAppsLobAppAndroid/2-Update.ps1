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
        IntuneMobileAppsLobAppAndroid "IntuneMobileAppsLobAppAndroid-Apk App"
        {
            ApplicationId                   = $ApplicationId;
            Assignments          = @(
                MSFT_DeviceManagementMobileAppAssignment{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.groupAssignmentTarget'
                    groupId = '57b5e81c-85bb-4644-a4fd-33b03e451c89'
                    intent = 'required'
                }
            );
            Categories                      = @(
                MSFT_DeviceManagementMobileAppCategory{
                    Id = "2185c6bf-1b3d-4daa-a0bc-79cb4fad9c87"
                    DisplayName = "App Category 1"
                }
            );
            CertificateThumbprint           = $CertificateThumbprint;
            Description                     = "App.Example.apk";
            Developer                       = "";
            DisplayName                     = "Apk App";
            MinimumSupportedOperatingSystem = MSFT_MicrosoftGraphAndroidMinimumOperatingSystem{
                V10_0 = $True
            };
            PackageId                       = "com.app.example";
            TargetedPlatforms               = "androidDeviceAdministrator";
            InformationUrl                  = "";
            PrivacyInformationUrl           = "";
            Ensure                          = "Present";
            FileName                        = "App.Example.apk";
            Id                              = "63271b78-0fa4-46b8-9ac0-d4b777555dde";
            IsFeatured                      = $False;
            Notes                           = "";
            Owner                           = "";
            Publisher                       = "Microsoft";
            RoleScopeTagIds                 = @("0");
            TenantId                        = $TenantId;
        }
    }
}
