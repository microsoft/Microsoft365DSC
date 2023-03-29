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
        $credsGlobalAdmin
    )

    Import-DscResource -ModuleName Microsoft365DSC

    Configuration Example
    {
        param
        (
            [Parameter(Mandatory = $true)]
            [PSCredential]
            $credsGlobalAdmin
        )

        Import-DscResource -ModuleName Microsoft365DSC

        node localhost
        {
            AADGroup 'TestGroup'
            {
                DisplayName                   = 'TestGroup'
                MailNickname                  = 'TestGroup'
                SecurityEnabled               = $true
                MailEnabled                   = $false
                IsAssignableToRole            = $true
                Ensure                        = "Present"
                Credential                    = $credsGlobalAdmin
            }
            AADAdministrativeUnit 'TestUnit'
            {
                DisplayName                   = 'Test-Unit'
                ScopedRoleMembers             = @(
                    MSFT_MicrosoftGraphScopedRoleMembership
                    {
                        RoleName = "User Administrator"
                        RoleMemberInfo = MSFT_MicrosoftGraphIdentity
                        {
                            Identity = "TestGroup"
                            Type = "Group"
                        }
                    }
                )
                Ensure                        = 'Present'
                Credential                    = $credsGlobalAdmin
                DependsOn                     = "[AADGroup]TestGroup"
            }
        }
    }
}
