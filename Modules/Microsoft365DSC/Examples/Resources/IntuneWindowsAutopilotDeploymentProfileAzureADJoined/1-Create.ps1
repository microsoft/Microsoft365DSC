<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
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
        IntuneWindowsAutopilotDeploymentProfileAzureADJoined 'Example'
        {
            Assignments                = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allDevicesAssignmentTarget'
                }
            );
            Description                = "";
            DeviceNameTemplate         = "test";
            DeviceType                 = "windowsPc";
            DisplayName                = "AAD";
            EnableWhiteGlove           = $True;
            Ensure                     = "Present";
            ExtractHardwareHash        = $True;
            Language                   = "";
            OutOfBoxExperienceSettings = MSFT_MicrosoftGraphoutOfBoxExperienceSettings1{
                HideEULA = $False
                HideEscapeLink = $True
                HidePrivacySettings = $True
                DeviceUsageType = 'singleUser'
                SkipKeyboardSelectionPage = $True
                UserType = 'administrator'
            };
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
