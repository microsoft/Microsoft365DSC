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
        IntuneDeviceConfigurationDomainJoinPolicyWindows10 'Example'
        {
            ActiveDirectoryDomainName         = "domain.com";
            Assignments                       = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allLicensedUsersAssignmentTarget'
                }
            );
            ComputerNameStaticPrefix          = "WK-";
            ComputerNameSuffixRandomCharCount = 12;
            DisplayName                       = "Domain Join";
            Ensure                            = "Present";
            OrganizationalUnit                = "OU=workstation,CN=domain,CN=com";
            SupportsScopeTags                 = $True;
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
