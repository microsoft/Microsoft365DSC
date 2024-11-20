<#
This example creates a new Intune Firewall Rules Policy for Windows10 Configuration Manager.
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
        IntuneFirewallRulesPolicyWindows10ConfigMgr 'myIntuneFirewallRulesPolicyWindows10ConfigMgr'
        {
            Assignments           = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.groupAssignmentTarget'
                    groupId = '11111111-1111-1111-1111-111111111111'
                }
            );
            FirewallRuleName = @(
                MSFT_MicrosoftGraphIntuneSettingsCatalogFirewallRuleName_IntuneFirewallRulesPolicyWindows10ConfigMgr{
                    Direction = 'out'
                    InterfaceTypes = @('lan')
                    RemotePortRanges = @('0-100')
                    Name = 'Rule1'
                    FilePath = 'C:\Temp'
                    Protocol = 80
                    ServiceName = 'mysvc'
                    Enabled = '1'
                    Type = '1'
                }
            )
            Description           = 'Description'
            DisplayName           = "Intune Firewall Rules Policy Windows10 ConfigMgr";
            Ensure                = "Present";
            Id                    = '00000000-0000-0000-0000-000000000000'
            RoleScopeTagIds       = @("0");
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
