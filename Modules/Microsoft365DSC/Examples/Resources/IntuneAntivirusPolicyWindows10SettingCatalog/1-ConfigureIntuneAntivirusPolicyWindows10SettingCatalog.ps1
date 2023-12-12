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
        IntuneAntivirusPolicyWindows10SettingCatalog 'myAVWindows10Policy'
        {
            Identity           = 'd64d4ab7-d0ac-4157-8823-a9db57b47cf1'
            DisplayName        = 'av exclusions'
            Assignments        = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments {
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType                                   = '#microsoft.graph.allDevicesAssignmentTarget'
                })
            Description        = ''
            excludedextensions = @('.exe')
            excludedpaths      = @('c:\folders\', 'c:\folders2\')
            excludedprocesses  = @('processes.exe', 'process2.exe')
            templateId         = '45fea5e9-280d-4da1-9792-fb5736da0ca9_1'
            Ensure             = 'Present'
            Credential         = $Credscredential
        }
    }
}
