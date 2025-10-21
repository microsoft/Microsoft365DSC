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
        IntuneCloudProvisioningPolicyWindows365 "IntuneCloudProvisioningPolicyWindows365_1"
        {
            ApplicationId            = $ApplicationId;
            Assignments              = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    dataType = "#microsoft.graph.cloudPcManagementGroupAssignmentTarget"
                    groupId = "42a638ec-2bf2-47a8-8f5f-176ce2124b7b"
                }
            );
            Autopatch                = MSFT_MicrosoftGraphCloudPcProvisioningPolicyAutopatch{
                AutopatchGroupId = "db2d8ac9-0697-4f04-a5cd-b3d230f31dc6"
            };
            CloudPcNamingTemplate    = "CPC-%USERNAME:5%-%RAND:5%";
            Description              = "";
            DisplayName              = "IntuneCloudProvisioningPolicyWindows365_1";
            DomainJoinConfigurations = @(
                MSFT_MicrosoftGraphCloudPcDomainJoinConfiguration{
                    Type = "azureADJoin"
                    RegionName = "automatic"
                    DomainJoinType = "azureADJoin"
                    RegionGroup = "usCentral"
                }
            );
            EnableSingleSignOn       = $True;
            Ensure                   = "Present";
            ImageDisplayName         = "Windows 11 Enterprise 25H2";
            ImageId                  = "microsoftwindowsdesktop_windows-ent-cpc_win11-25h2-ent-cpc";
            ImageType                = "gallery";
            ProvisioningType         = "dedicated";
            RoleScopeTagIds          = @("0");
            WindowsSetting           = MSFT_MicrosoftGraphCloudPcWindowsSetting{
                Locale = "en-US"
            };
            WindowsSettings          = MSFT_MicrosoftGraphCloudPcWindowsSettings{
                Language = "en-US"
            };
            CertificateThumbprint    = $CertificateThumbprint;
            TenantId                 = $TenantId;
        }
    }
}
