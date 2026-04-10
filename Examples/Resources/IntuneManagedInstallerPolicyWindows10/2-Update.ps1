<#
This example creates a new Intune Mobile App Configuration Policy for iOs devices
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
        IntuneManagedInstallerPolicyWindows10 "IntuneManagedInstallerPolicyWindows10-SideCar ManagedInstaller Script"
        {
            Assignments              = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    dataType = "#microsoft.graph.allDevicesAssignmentTarget"
                    deviceAndAppManagementAssignmentFilterType = "none"
                    deviceAndAppManagementAssignmentFilterId = "00000000-0000-0000-0000-000000000000"
                    groupDisplayName = "All devices"
                }
            );
            Description              = "This script is used to set SideCar as ManagedInstaller";
            DisplayName              = "SideCar ManagedInstaller Script";
            Ensure                   = "Present";
            IsIntuneManagedInstaller = $False; # Updated property
            RoleScopeTagIds          = @("0");
            ApplicationId            = $ApplicationId;
            CertificateThumbprint    = $CertificateThumbprint;
            TenantId                 = $OrganizationName;
        }
    }
}
