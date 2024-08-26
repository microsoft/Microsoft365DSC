<#
This example creates a new Device Remediation.
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
        IntuneDeviceRemediation 'ConfigureDeviceRemediation'
        {
            Assignments              = @(
                MSFT_IntuneDeviceRemediationPolicyAssignments{
                    RunSchedule = MSFT_IntuneDeviceRemediationRunSchedule{
                        Date = '2024-01-01'
                        Time = '01:00:00'
                        Interval = 1
                        DataType = '#microsoft.graph.deviceHealthScriptRunOnceSchedule'
                        UseUtc = $False
                    }
                    RunRemediationScript = $False
                    Assignment = MSFT_DeviceManagementConfigurationPolicyAssignments{
                        deviceAndAppManagementAssignmentFilterType = 'none'
                        dataType = '#microsoft.graph.groupAssignmentTarget'
                        groupId = '11111111-1111-1111-1111-111111111111'
                    }
                }
            );
            Description              = 'Description'
            DetectionScriptContent   = "Base64 encoded script content";
            DeviceHealthScriptType   = "deviceHealthScript";
            DisplayName              = "Device remediation";
            EnforceSignatureCheck    = $False;
            Ensure                   = "Present";
            Id                       = '00000000-0000-0000-0000-000000000000'
            Publisher                = "Some Publisher";
            RemediationScriptContent = "Base64 encoded script content";
            RoleScopeTagIds          = @("0");
            RunAs32Bit               = $True;
            RunAsAccount             = "system";
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
