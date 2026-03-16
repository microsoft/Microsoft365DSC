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
        IntuneAppProtectionPolicyWindows10 "IntuneAppProtectionPolicyWindows10-IntuneAppProtectionPolicyWindows10_1"
        {
            AllowedInboundDataTransferSources       = "allApps";
            AllowedOutboundClipboardSharingLevel    = "anyDestinationAnySource";
            AllowedOutboundDataTransferDestinations = "allApps";
            AppActionIfUnableToAuthenticateUser     = "wipe";
            ApplicationId                           = $ConfigurationData.NonNodeData.ApplicationId;
            Apps                                    = @("com.microsoft.edge");
            Assignments                             = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    dataType = "#microsoft.graph.groupAssignmentTarget"
                    deviceAndAppManagementAssignmentFilterType = "none"
                    groupDisplayName = "Include"
                    groupId = "56ae142c-f960-4436-a445-6b371fc8338b"
                }
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    dataType = "#microsoft.graph.exclusionGroupAssignmentTarget"
                    deviceAndAppManagementAssignmentFilterType = "none"
                    groupDisplayName = "Exclude"
                    groupId = "258a1749-8408-4dd0-8028-fab6208a28d7"
                }
            );
            CertificateThumbprint                   = $ConfigurationData.NonNodeData.CertificateThumbprint;
            Description                             = "";
            DisplayName                             = "IntuneAppProtectionPolicyWindows10_1";
            Ensure                                  = "Present";
            MaximumAllowedDeviceThreatLevel         = "secured";
            MaximumRequiredOsVersion                = "12.0.0.0";
            MinimumRequiredSdkVersion               = "1.0.0.0";
            MinimumWarningAppVersion                = "0.0.0";
            MinimumWarningOsVersion                 = "10.0.0.0";
            MobileThreatDefenseRemediationAction    = "block";
            PeriodOfflineBeforeAccessCheck          = "P1D";
            PeriodOfflineBeforeWipeIsEnforced       = "P180D"; # Updated property
            PrintBlocked                            = $False;
            RoleScopeTagIds                         = @("0");
            TenantId                                = $OrganizationName;
        }
    }
}
