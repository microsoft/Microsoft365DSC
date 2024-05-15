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
        IntuneDeviceConfigurationWindowsTeamPolicyWindows10 'Example'
        {
            Assignments                            = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allLicensedUsersAssignmentTarget'
                }
            );
            AzureOperationalInsightsBlockTelemetry = $False; # Updated Property
            ConnectAppBlockAutoLaunch              = $True;
            Credential                             = $Credscredential;
            DisplayName                            = "Device restrictions (Windows 10 Team)";
            Ensure                                 = "Present";
            MaintenanceWindowBlocked               = $False;
            MaintenanceWindowDurationInHours       = 1;
            MaintenanceWindowStartTime             = "00:00:00";
            MiracastBlocked                        = $True;
            MiracastChannel                        = "oneHundredFortyNine";
            MiracastRequirePin                     = $True;
            SettingsBlockMyMeetingsAndFiles        = $True;
            SettingsBlockSessionResume             = $True;
            SettingsBlockSigninSuggestions         = $True;
            SupportsScopeTags                      = $True;
            WelcomeScreenBlockAutomaticWakeUp      = $True;
            WelcomeScreenMeetingInformation        = "showOrganizerAndTimeOnly";
        }
    }
}
