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
    $Domain = $Credscredential.Username.Split('@')[1]
    node localhost
    {
        AADAdministrativeUnit 'TestUnit'
        {
            DisplayName                   = 'Test-Unit'
            Description                   = 'Test Description Updated' # Updated Property
            Visibility                    = 'HiddenMembership' # Updated Property
            MembershipRule                = "(user.country -eq `"US`")" # Updated Property
            MembershipRuleProcessingState = 'On'
            MembershipType                = 'Dynamic'
            ScopedRoleMembers             = @(
                MSFT_MicrosoftGraphScopedRoleMembership
                {
                    RoleName       = 'User Administrator'
                    RoleMemberInfo = MSFT_MicrosoftGraphMember
                    {
                        Identity = "AdeleV@$Domain" # Updated Property
                        Type     = "User"
                    }
                }
            )
            Credential                    = $Credscredential
        }
    }
}
