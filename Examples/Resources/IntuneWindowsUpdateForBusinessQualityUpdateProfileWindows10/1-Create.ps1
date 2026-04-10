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
        IntuneWindowsUpdateForBusinessQualityUpdateProfileWindows10 'Example'
        {
            Assignments             = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    groupDisplayName = 'Exclude'
                    dataType         = '#microsoft.graph.exclusionGroupAssignmentTarget'
                    groupId          = '258a1749-8408-4dd0-8028-fab6208a28d7'
                }
            );
            DisplayName              = 'Windows Quality Update'
            Description              = ''
            ExpeditedUpdateSettings = MSFT_MicrosoftGraphexpeditedWindowsQualityUpdateSettings{
                QualityUpdateRelease  = '2024-06-11T00:00:00Z'
                DaysUntilForcedReboot = 0
            }
            RoleScopeTagIds           = @("0")
            Ensure                    = 'Present'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
