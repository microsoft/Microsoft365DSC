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
        IntuneMobileAppsLobAppWindows10 "IntuneMobileAppsLobAppWindows10-Appx App"
        {
            Description           = "Appx App Description";
            Developer             = "Contoso";
            DisplayName           = "Appx App";
            Ensure                = "Present";
            FileName              = "Contoso.Appx_1.0.0.0_x64__contoso.appx";
            InformationUrl        = "";
            IsFeatured            = $False;
            Notes                 = "";
            Owner                 = "";
            PrivacyInformationUrl = "";
            Publisher             = "Contoso";
            Assignments          = @(
                MSFT_DeviceManagementAppxMobileAppAssignment {
                    groupDisplayName = 'All devices'
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allDevicesAssignmentTarget'
                    intent = 'required'
                    assignmentSettings = MSFT_DeviceManagementAppxMobileAppAssignmentSettings{
                        useDeviceContext = $true
                        odataType = "#microsoft.graph.windowsUniversalAppXAppAssignmentSettings"
                    }
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
