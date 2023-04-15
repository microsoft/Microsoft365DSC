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
        IntuneDeviceConfigurationEditionUpgradePolicyWindows10 'Example'
        {
            Assignments          = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allDevicesAssignmentTarget'
                }
            );
            Credential           = $Credscredential;
            DisplayName          = "Edition upgrade and mode switch";
            Ensure               = "Present";
            Id                   = "3e4222e0-c172-4081-bf9a-2e17ddfc34ca";
            License              = "";
            LicenseType          = "productKey";
            ProductKey           = "#####-#####-#####-#####-#xxxx";
            SupportsScopeTags    = $True;
            TargetEdition        = "windows10Professional";
            WindowsSMode         = "block";
        }
    }
}
