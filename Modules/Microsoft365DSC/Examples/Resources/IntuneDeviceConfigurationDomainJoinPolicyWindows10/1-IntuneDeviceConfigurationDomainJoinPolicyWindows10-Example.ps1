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
            Credential                        = $Credscredential;
            DisplayName                       = "Domain Join";
            Ensure                            = "Present";
            Id                                = "1ab2945b-36b5-4b34-bbf5-717885c15654";
            OrganizationalUnit                = "OU=workstation,CN=domain,CN=com";
            SupportsScopeTags                 = $True;
        }
    }
}
