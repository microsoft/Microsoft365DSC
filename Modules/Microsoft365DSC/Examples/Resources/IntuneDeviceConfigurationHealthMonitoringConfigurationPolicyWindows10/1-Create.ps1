<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneDeviceConfigurationHealthMonitoringConfigurationPolicyWindows10 'Example'
        {
            AllowDeviceHealthMonitoring       = "enabled";
            Assignments                       = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allLicensedUsersAssignmentTarget'
                }
            );
            ConfigDeviceHealthMonitoringScope = @("bootPerformance","windowsUpdates");
            Credential                        = $Credscredential;
            DisplayName                       = "Health Monitoring Configuration";
            Ensure                            = "Present";
            SupportsScopeTags                 = $True;
        }
    }
}
