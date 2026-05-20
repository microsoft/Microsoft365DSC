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
        IntuneAppControlForBusinessPolicyWindows10V2 'Example'
        {
            ApplicationId                                             = $ApplicationId;
            Assignments                                               = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    dataType = "#microsoft.graph.exclusionGroupAssignmentTarget"
                    deviceAndAppManagementAssignmentFilterType = "none"
                    groupDisplayName = "Exclude"
                }
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    dataType = "#microsoft.graph.groupAssignmentTarget"
                    deviceAndAppManagementAssignmentFilterType = "none"
                    groupDisplayName = "Include"
                }
            );
            CertificateThumbprint                                     = $CertificateThumbprint;
            ConfigureApplicationControlOptions                        = "0"; # Updated property
            ConfigureApplicationControlsAuditMode                     = "1";
            ConfigureApplicationControlsTrustAppsFromManagedInstaller = "1";
            ConfigureApplicationControlsTrustAppsWithGoodReputation   = "1";
            Description                                               = "";
            DisplayName                                               = "Example";
            Ensure                                                    = "Present";
            RoleScopeTagIds                                           = @("0");
            TenantId                                                  = $TenantId;
        }
    }
}
