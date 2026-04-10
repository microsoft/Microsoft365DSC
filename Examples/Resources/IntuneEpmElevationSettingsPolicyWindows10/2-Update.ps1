<#
This example updates a Intune Firewall Policy for Windows10.
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
        IntuneEpmElevationSettingsPolicyWindows10 'Example'
        {
            Assignments           = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.groupAssignmentTarget'
                    groupId = '11111111-1111-1111-1111-111111111111'
                }
            );
            Description                 = 'Description'
            DefaultElevationResponse    = "0";
            DisplayName                 = "IntuneEpmElevationSettingsPolicyWindows10_1";
            EndpointPrivilegeManagement = "1";
            ReportingScope              = "1";
            SendDataToMicrosoft         = "1";
            Ensure                      = "Present";
            Id                          = '00000000-0000-0000-0000-000000000000'
            RoleScopeTagIds             = @("0");
            ApplicationId               = $ApplicationId;
            TenantId                    = $TenantId;
            CertificateThumbprint       = $CertificateThumbprint;
        }
    }
}
