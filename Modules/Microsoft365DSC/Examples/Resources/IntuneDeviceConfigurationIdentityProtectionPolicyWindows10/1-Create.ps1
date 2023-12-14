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
        IntuneDeviceConfigurationIdentityProtectionPolicyWindows10 'Example'
        {
            Assignments                                  = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allLicensedUsersAssignmentTarget'
                }
            );
            Credential                                   = $Credscredential;
            DisplayName                                  = "identity protection";
            EnhancedAntiSpoofingForFacialFeaturesEnabled = $True;
            Ensure                                       = "Present";
            PinExpirationInDays                          = 5;
            PinLowercaseCharactersUsage                  = "allowed";
            PinMaximumLength                             = 4;
            PinMinimumLength                             = 4;
            PinPreviousBlockCount                        = 3;
            PinRecoveryEnabled                           = $True;
            PinSpecialCharactersUsage                    = "allowed";
            PinUppercaseCharactersUsage                  = "allowed";
            SecurityDeviceRequired                       = $True;
            SupportsScopeTags                            = $True;
            UnlockWithBiometricsEnabled                  = $True;
            UseCertificatesForOnPremisesAuthEnabled      = $True;
            UseSecurityKeyForSignin                      = $True;
            WindowsHelloForBusinessBlocked               = $False;
        }
    }
}
