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
        IntuneTermsAndConditions "IntuneTermsAndConditions-IntuneTermsAndConditions_1"
        {
            AcceptanceStatement   = "Summary of Terms and Conditions";
            ApplicationId         = $ConfigurationData.NonNodeData.ApplicationId;
            Assignments           = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    dataType = "#microsoft.graph.groupAssignmentTarget"
                    deviceAndAppManagementAssignmentFilterType = "none"
                    groupDisplayName = "Include"
                    groupId = "56ae142c-f960-4436-a445-6b371fc8338b"
                }
            );
            BodyText              = "Some Terms and Conditions - With new updates"; # Updated property
            CertificateThumbprint = $ConfigurationData.NonNodeData.CertificateThumbprint;
            Description           = "";
            DisplayName           = "IntuneTermsAndConditions_1";
            Ensure                = "Present";
            RoleScopeTagIds       = @("0");
            TenantId              = $OrganizationName;
            Title                 = "IntuneTermsAndConditions_1";
        }
    }
}
