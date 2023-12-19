<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )

    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADAuthorizationPolicy 'AADAuthPol'
        {
            IsSingleInstance                                  = 'Yes'
            DisplayName                                       = 'Authorization Policy'
            Description                                       = 'Used to manage authorization related settings across the company.'
            AllowEmailVerifiedUsersToJoinOrganization         = $true
            AllowInvitesFrom                                  = 'everyone'
            AllowedToSignUpEmailBasedSubscriptions            = $true
            AllowedToUseSspr                                  = $true
            BlockMsolPowerShell                               = $false
            DefaultUserRoleAllowedToCreateApps                = $true
            DefaultUserRoleAllowedToCreateSecurityGroups      = $true
            DefaultUserRoleAllowedToReadOtherUsers            = $true
            GuestUserRole                                     = 'Guest'
            PermissionGrantPolicyIdsAssignedToDefaultUserRole = @()
            Ensure                                            = 'Present'
            Credential                                        = $Credscredential
        }
    }
}
