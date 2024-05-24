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
        IntuneDeviceConfigurationPlatformScriptWindows 'Example'
        {
            Assignments          = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allDevicesAssignmentTarget'
                }
            );
            Credential            = $Credscredential;
            DisplayName           = "custom";
            Ensure                = "Present";
            EnforceSignatureCheck = $False;
            FileName              = "script.ps1";
            Id                    = "00000000-0000-0000-0000-000000000000";
            RunAs32Bit            = $False; # Updated property
            RunAsAccount          = "system";
            ScriptContent         = "Base64 encoded script content";
            TenantId              = $OrganizationName;
        }
    }
}
