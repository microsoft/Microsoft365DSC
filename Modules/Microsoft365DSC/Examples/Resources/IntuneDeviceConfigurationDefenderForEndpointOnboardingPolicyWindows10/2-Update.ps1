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
        IntuneDeviceConfigurationDefenderForEndpointOnboardingPolicyWindows10 'Example'
        {
            AdvancedThreatProtectionAutoPopulateOnboardingBlob = $True; # Updated Property
            AdvancedThreatProtectionOnboardingFilename         = "WindowsDefenderATP.onboarding";
            AllowSampleSharing                                 = $True;
            Assignments                                        = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allDevicesAssignmentTarget'
                }
            );
            Credential                                         = $Credscredential;
            DisplayName                                        = "MDE onboarding Legacy";
            EnableExpeditedTelemetryReporting                  = $True;
            Ensure                                             = "Present";
        }
    }
}
