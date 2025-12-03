<#
This example updates a Intune Firewall Policy for Windows10.
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
        IntuneFirewallPolicyWindows10 'ConfigureIntuneFirewallPolicyWindows10'
        {
            Assignments           = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.groupAssignmentTarget'
                    groupId = '11111111-1111-1111-1111-111111111111'
                }
            );
            Description           = 'Description'
            DisplayName           = "Intune Firewall Policy Windows10";
            DisableStatefulFtp    = "false";
            DomainProfile_AllowLocalIpsecPolicyMerge      = "true"; # Updated property
            DomainProfile_EnableFirewall                  = "true";
            DomainProfile_LogFilePath                     = "%systemroot%\system32\LogFiles\Firewall\pfirewall.log";
            DomainProfile_LogMaxFileSize                  = 1024;
            ObjectAccess_AuditFilteringPlatformPacketDrop = "1";
            PrivateProfile_EnableFirewall                 = "true";
            PublicProfile_EnableFirewall                  = "true";
            Target                                        = "wsl";
            AllowHostPolicyMerge                          = "false";
            Ensure                = "Present";
            Id                    = '00000000-0000-0000-0000-000000000000'
            RoleScopeTagIds       = @("0");
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
