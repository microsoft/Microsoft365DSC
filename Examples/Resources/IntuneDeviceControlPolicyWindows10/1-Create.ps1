<#
This example creates a new Device Control Policy.
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
        IntuneDeviceControlPolicyWindows10 'ConfigureDeviceControlPolicy'
        {
            AllowStorageCard      = "1";
            Assignments           = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.groupAssignmentTarget'
                    groupId = '11111111-1111-1111-1111-111111111111'
                }
            );
            Description           = 'Description'
            DisplayName           = "Device Control";
            DeviceInstall_IDs_Allow      = "1";
            DeviceInstall_IDs_Allow_List = @("1234");
            PolicyRule                   = @(
                MSFT_MicrosoftGraphIntuneSettingsCatalogPolicyRule{
                    Name = 'asdf'
                    Entry = @(
                        MSFT_MicrosoftGraphIntuneSettingsCatalogPolicyRuleEntry{
                            AccessMask = @(
                                '1'
                                '2'
                            )
                            Sid = '1234'
                            ComputerSid = '1234'
                            Type = 'allow'
                            Options = '4'
                        }
                    )
                }
            );
            Ensure                = "Present";
            Id                    = '00000000-0000-0000-0000-000000000000'
            RoleScopeTagIds       = @("0");
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
