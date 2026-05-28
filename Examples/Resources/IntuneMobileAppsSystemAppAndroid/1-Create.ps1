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
        IntuneMobileAppsSystemAppAndroid "IntuneMobileAppsSystemAppAndroid-Office"
        {
            DisplayName           = "Office";
            Ensure                = "Present";
            AppIdentifier         = "com.microsoft.office";
            Publisher             = "Microsoft";
            RoleScopeTagIds       = @("0")
            Assignments           = @(
                MSFT_DeviceManagementSystemMobileAppAssignment {
                    groupDisplayName = 'All devices'
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allDevicesAssignmentTarget'
                    intent = 'required'
                    assignmentSettings = MSFT_DeviceManagementSystemMobileAppAssignmentSettings{
                        odataType = "#microsoft.graph.androidManagedStoreAppAssignmentSettings"
                        androidManagedStoreAppTrackIds = @()
                        autoUpdateMode = "default"
                    }
                }
            );
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
