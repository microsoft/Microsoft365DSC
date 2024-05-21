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
        IntuneDeviceConfigurationPlatformScriptMacOS 'Example'
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
            BlockExecutionNotifications = $False;
            Description                 = "";
            ExecutionFrequency          = "00:00:00";
            FileName                    = "shellscript.sh";
            Id                          = "00000000-0000-0000-0000-000000000000";
            RetryCount                  = 1; # Updated property
            RoleScopeTagIds             = @("0");
            RunAsAccount                = "user";
            ScriptContent               = "Base64 encoded script content";
            TenantId                    = $OrganizationName;
        }
    }
}
