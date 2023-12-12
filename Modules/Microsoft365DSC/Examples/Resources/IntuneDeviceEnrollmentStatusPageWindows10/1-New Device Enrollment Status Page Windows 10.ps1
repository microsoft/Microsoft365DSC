<#
This example creates a new Device Enrollment Status Page.
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
        IntuneDeviceEnrollmentStatusPageWindows10 '6b43c039-c1d0-4a9f-aab9-48c5531acbd6'
        {
            AllowDeviceResetOnInstallFailure        = $True;
            AllowDeviceUseOnInstallFailure          = $True;
            AllowLogCollectionOnInstallFailure      = $True;
            AllowNonBlockingAppInstallation         = $False;
            Assignments                             = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allDevicesAssignmentTarget'
                }
            );
            BlockDeviceSetupRetryByUser             = $False;
            CustomErrorMessage                      = "Setup could not be completed. Please try again or contact your support person for help.";
            Description                             = "This is the default enrollment status screen configuration applied with the lowest priority to all users and all devices regardless of group membership.";
            DisableUserStatusTrackingAfterFirstUser = $True;
            DisplayName                             = "All users and all devices";
            Ensure                                  = "Present";
            Id                                      = "5b0e1dba-4523-455e-9fdd-e36c833b57bf_DefaultWindows10EnrollmentCompletionPageConfiguration";
            InstallProgressTimeoutInMinutes         = 60;
            InstallQualityUpdates                   = $False;
            Priority                                = 0;
            SelectedMobileAppIds                    = @();
            ShowInstallationProgress                = $True;
            TrackInstallProgressForAutopilotOnly    = $True;
            Credential                              = $Credscredential
        }
    }
}
