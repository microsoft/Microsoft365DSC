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
        IntuneDiskEncryptionFileVaultPolicyMacOS "IntuneDiskEncryptionFileVaultPolicyMacOS-IntuneDiskEncryptionFileVaultPolicyMacOS_1"
        {
            ApplicationId                          = $ApplicationId;
            Assignments                            = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = "none"
                    groupDisplayName = "Exclude"
                    dataType = "#microsoft.graph.exclusionGroupAssignmentTarget"
                }
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = "none"
                    groupDisplayName = "Include"
                    dataType = "#microsoft.graph.groupAssignmentTarget"
                }
            );
            CertificateThumbprint                  = $CertificateThumbprint;
            Defer                                  = "true";
            DeferDontAskAtUserLogout               = "false";
            DeferForceAtUserLoginMaxBypassAttempts = 5;
            Description                            = "";
            Enable                                 = "Off"; # Updated property
            Ensure                                 = "Present";
            Location                               = "Sample Location";
            DisplayName                            = "IntuneDiskEncryptionFileVaultPolicyMacOS_1";
            RecoveryKeyRotationInMonths            = 12; # Updated property
            RoleScopeTagIds                        = @("0");
            TenantId                               = $TenantId;
            UseRecoveryKey                         = "true";
        }
    }
}
