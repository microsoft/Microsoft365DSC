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
        IntuneAntivirusPolicyWindows10SettingCatalog 'myAVWindows10Policy'
        {
            DisplayName        = 'av exclusions'
            Assignments        = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments {
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType                                   = '#microsoft.graph.allDevicesAssignmentTarget'
                })
            Description        = ''
            excludedextensions = @('.exe')
            excludedpaths      = @('c:\folders\', 'c:\folders2\')
            excludedprocesses  = @('processes.exe', 'process3.exe') # Updated Property
            templateId         = '45fea5e9-280d-4da1-9792-fb5736da0ca9_1'
            Ensure             = 'Present'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
