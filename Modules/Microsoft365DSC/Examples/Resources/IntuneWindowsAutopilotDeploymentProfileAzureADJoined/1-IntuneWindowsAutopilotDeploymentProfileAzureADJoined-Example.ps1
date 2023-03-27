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
        IntuneWindowsAutopilotDeploymentProfileAzureADJoined 'Example'
        {
            Assignments                = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allDevicesAssignmentTarget'
                }
            );
            Credential                 = $Credscredential;
            Description                = "";
            DeviceNameTemplate         = "test";
            DeviceType                 = "windowsPc";
            DisplayName                = "AAD";
            EnableWhiteGlove           = $True;
            Ensure                     = "Present";
            ExtractHardwareHash        = $True;
            Id                         = "30914319-d49b-46da-b054-625d933c5769";
            Language                   = "";
            OutOfBoxExperienceSettings = MSFT_MicrosoftGraphoutOfBoxExperienceSettings1{
                HideEULA = $False
                HideEscapeLink = $True
                HidePrivacySettings = $True
                DeviceUsageType = 'singleUser'
                SkipKeyboardSelectionPage = $True
                UserType = 'administrator'
            };
        }
    }
}
