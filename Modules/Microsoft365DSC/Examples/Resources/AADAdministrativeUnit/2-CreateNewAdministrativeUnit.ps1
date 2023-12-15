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
        AADGroup 'TestGroup'
        {
            Id                            = '4b8bbe0f-2d9c-4a82-9f40-9e1717987102'
            DisplayName                   = 'TestGroup'
            MailNickname                  = 'TestGroup'
            SecurityEnabled               = $true
            MailEnabled                   = $false
            IsAssignableToRole            = $true
            Ensure                        = "Present"
            Credential                    = $Credscredential
        }
        AADAdministrativeUnit 'TestUnit'
        {
            ID                            = 'Test-Unit'
            DisplayName                   = 'Test-Unit'
            ScopedRoleMembers             = @(
                MSFT_MicrosoftGraphScopedRoleMembership
                {
                    RoleName = "User Administrator"
                    RoleMemberInfo = MSFT_MicrosoftGraphMember
                    {
                        Identity = "TestGroup"
                        Type = "Group"
                    }
                }
            )
            Ensure                        = 'Present'
            Credential                    = $Credscredential
            DependsOn                     = "[AADGroup]TestGroup"
        }
    }
}
