<#
This example creates a new Device Enrollment Limit Restriction.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneDeviceEnrollmentConfigurationWindows10 '6b43c039-c1d0-4a9f-aab9-48c5531acbd6'
        {
            Id                                      = 'b8258075-8457-4ecf-9aed-82754ec868bf_DefaultWindows10EnrollmentCompletionPageConfiguration'
            DisplayName                             = 'All users and all devices'
            AllowDeviceResetOnInstallFailure        = $false
            AllowDeviceUseOnInstallFailure          = $false
            AllowLogCollectionOnInstallFailure      = $false
            AllowNonBlockingAppInstallation         = $false
            BlockDeviceSetupRetryByUser             = $true
            CustomErrorMessage                      = ''
            Description                             = 'This is the default enrollment status screen configuration applied with the lowest priority to all users and all devices regardless of group membership.'
            DisableUserStatusTrackingAfterFirstUser = $false
            InstallProgressTimeoutInMinutes         = 0
            InstallQualityUpdates                   = $false
            SelectedMobileAppIds                    = @()
            ShowInstallationProgress                = $false
            TrackInstallProgressForAutopilotOnly    = $false
            Ensure                                  = 'Present'
            Credential                              = $Credscredential
        }
    }
}
