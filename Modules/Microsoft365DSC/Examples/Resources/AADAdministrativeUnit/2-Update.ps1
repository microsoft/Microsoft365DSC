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
        AADAdministrativeUnit 'TestUnit'
        {
            DisplayName                   = 'Test-Unit'
            Description                   = 'Test Description Updated' # Updated Property
            Visibility                    = 'Public'
            MembershipRule                = "(user.country -eq `"US`")" # Updated Property
            MembershipRuleProcessingState = 'On'
            MembershipType                = 'Dynamic'
            ScopedRoleMembers             = @(
                MSFT_MicrosoftGraphScopedRoleMembership
                {
                    RoleName       = 'User Administrator'
                    RoleMemberInfo = MSFT_MicrosoftGraphMember
                    {
                        Identity = "AdeleV@$TenantId" # Updated Property
                        Type     = "User"
                    }
                }
            )
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
