<#
This example removes a Intune Firewall Rules Policy for Windows10 Configuration Manager.
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
            Id          = '00000000-0000-0000-0000-000000000000'
            DisplayName = 'Intune Firewall Rules Policy Windows10 ConfigMgr'
            Ensure      = 'Absent'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
