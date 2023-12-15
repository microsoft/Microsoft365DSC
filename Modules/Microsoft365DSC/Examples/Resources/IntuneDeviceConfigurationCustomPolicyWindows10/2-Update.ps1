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
        IntuneDeviceConfigurationCustomPolicyWindows10 'Example'
        {
            Assignments          = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allDevicesAssignmentTarget'
                }
            );
            Credential           = $Credscredential;
            DisplayName          = "custom";
            Ensure               = "Present";
            OmaSettings          = @(
                MSFT_MicrosoftGraphomaSetting{
                    Description = 'custom'
                    OmaUri = '/oma/custom'
                    odataType = '#microsoft.graph.omaSettingString'
                    SecretReferenceValueId = '5b0e1dba-4523-455e-9fdd-e36c833b57bf_e072d616-12bc-4ea3-9171-ab080e4c120d_1f958162-15d4-42ba-92c4-17c2544b2179'
                    Value = '****'
                    IsEncrypted = $True
                    DisplayName = 'oma'
                }
                MSFT_MicrosoftGraphomaSetting{ # Updated Property
                    Description = 'custom 3'
                    OmaUri = '/oma/custom3'
                    odataType = '#microsoft.graph.omaSettingInteger'
                    Value = 2
                    IsReadOnly = $False
                    IsEncrypted = $False
                    DisplayName = 'custom 3'
                }
            );
            SupportsScopeTags    = $True;
        }
    }
}
