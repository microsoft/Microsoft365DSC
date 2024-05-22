<#
This example updates a new Device Remediation.
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
        IntuneDeviceRemediation 'ConfigureDeviceRemediation'
        {
            Assignments              = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allDevicesAssignmentTarget'
                }
            );
            Credential               = $Credscredential
            Description              = 'Description'
            DetectionScriptContent   = "Base64 encoded script content 2"; # Updated property
            DeviceHealthScriptType   = "deviceHealthScript";
            DisplayName              = "Device remediation";
            EnforceSignatureCheck    = $False;
            Ensure                   = "Present";
            Id                       = '00000000-0000-0000-0000-000000000000'
            Publisher                = "Some Publisher";
            RemediationScriptContent = "Base64 encoded script content 2"; # Updated property
            RoleScopeTagIds          = @("0");
            RunAs32Bit               = $True;
            RunAsAccount             = "system";
            TenantId                 = $OrganizationName;
        }
    }
}
