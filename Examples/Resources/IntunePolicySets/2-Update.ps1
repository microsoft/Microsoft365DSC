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
    Import-DscResource -ModuleName 'Microsoft365DSC'
    Node localhost
    {
        IntunePolicySets "Example"
        {
            Assignments          = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.groupAssignmentTarget'
                    groupId = '12345678-1234-1234-1234-1234567890ab'
                }
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.exclusionGroupAssignmentTarget'
                    groupId = '12345678-4321-4321-4321-1234567890ab'
                }
            );
            Description          = "Example";
            DisplayName          = "Example";
            Ensure               = "Present";
            GuidedDeploymentTags = @();
            Items                = @(
                MSFT_DeviceManagementConfigurationPolicyItems{
                    guidedDeploymentTags = @()
                    payloadId = 'T_12345678-90ab-90ab-90ab-1234567890ab'
                    displayName = 'Example-Policy'
                    dataType = '#microsoft.graph.managedAppProtectionPolicySetItem'
                    itemType = '#microsoft.graph.androidManagedAppProtection'
                }
            );
            RoleScopeTags        = @("0","1","2"); # Updated Property
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
   }
}
