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
        IntuneWindowsAutopilotDeploymentProfileAzureADHybridJoined 'Example'
        {
            Assignments                            = @();
            Credential                             = $Credscredential;
            Description                            = "";
            DeviceNameTemplate                     = "";
            DeviceType                             = "windowsPc";
            DisplayName                            = "hybrid";
            EnableWhiteGlove                       = $False; # Updated Property
            Ensure                                 = "Present";
            ExtractHardwareHash                    = $False;
            HybridAzureADJoinSkipConnectivityCheck = $True;
            Language                               = "os-default";
            OutOfBoxExperienceSettings             = MSFT_MicrosoftGraphoutOfBoxExperienceSettings{
                HideEULA = $True
                HideEscapeLink = $True
                HidePrivacySettings = $True
                DeviceUsageType = 'singleUser'
                SkipKeyboardSelectionPage = $False
                UserType = 'standard'
            };
        }
    }
}
