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
        IntuneDeviceConfigurationSecureAssessmentPolicyWindows10 'Example'
        {
            AllowPrinting            = $True;
            AllowScreenCapture       = $True;
            AllowTextSuggestion      = $True;
            AssessmentAppUserModelId = "";
            Assignments              = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allLicensedUsersAssignmentTarget'
                }
            );
            ConfigurationAccount     = "user@domain.com";
            ConfigurationAccountType = "azureADAccount";
            Credential               = $Credscredential;
            DisplayName              = "Secure Assessment";
            Ensure                   = "Present";
            Id                       = "b46822c4-48af-422a-960b-92473bee56e0";
            LaunchUri                = "https://assessment.domain.com";
            LocalGuestAccountName    = "";
        }
    }
}
