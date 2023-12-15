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
        IntuneDeviceConfigurationNetworkBoundaryPolicyWindows10 'Example'
        {
            Assignments                   = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allDevicesAssignmentTarget'
                }
            );
            Credential                    = $Credscredential;
            DisplayName                   = "network boundary";
            Ensure                        = "Present";
            SupportsScopeTags             = $True;
            WindowsNetworkIsolationPolicy = MSFT_MicrosoftGraphwindowsNetworkIsolationPolicy{
                EnterpriseProxyServers = @()
                EnterpriseInternalProxyServers = @()
                EnterpriseIPRangesAreAuthoritative = $True
                EnterpriseProxyServersAreAuthoritative = $True
                EnterpriseNetworkDomainNames = @('domain.com')
                EnterpriseIPRanges = @(
                    MSFT_MicrosoftGraphIpRange1{
                        UpperAddress = '1.1.1.255'
                        LowerAddress = '1.1.1.0'
                        odataType = '#microsoft.graph.iPv4Range'
                    }
                )
                NeutralDomainResources = @()
            };
        }
    }
}
