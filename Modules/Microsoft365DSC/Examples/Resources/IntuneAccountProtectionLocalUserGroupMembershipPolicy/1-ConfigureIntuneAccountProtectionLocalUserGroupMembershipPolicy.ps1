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
        IntuneAccountProtectionLocalUserGroupMembershipPolicy "My Account Protection Local User Group Membership Policy"
        {
            Identity                 = "cb0a561b-7677-46fb-a7f8-635cf64660e9";
            DisplayName              = "Account Protection LUGM Policy";
            Description              = "My revised description";
            Ensure                   = "Present";
            Credential               = $Credscredential
            Assignments              = @(
                MSFT_IntuneAccountProtectionLocalUserGroupMembershipPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allLicensedUsersAssignmentTarget'
                }
            );
            LocalUserGroupCollection = @(
                MSFT_IntuneAccountProtectionLocalUserGroupCollection{
                    LocalGroups = @('administrators', 'users')
                    Members = @('S-1-12-1-1167842105-1150511762-402702254-1917434032')
                    Action = 'add_update'
                    UserSelectionType = 'users'
                }
            );
        }
    }
}
