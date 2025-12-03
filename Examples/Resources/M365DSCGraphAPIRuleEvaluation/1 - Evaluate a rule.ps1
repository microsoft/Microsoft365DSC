<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $CredsCredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        M365DSCGraphAPIRuleEvaluation 'AllowAnonymousUsersToJoinMeetingAllPolicies'
        {
            APIUrl              = 'https://graph.microsoft.com/beta/serviceprincipals'
            InstancesProperty   = 'value'
            InstanceIdentifier  = 'displayName'
            RuleDefinition      = "`$_.appCategory -eq 'mdm'"
            AfterRuleCountQuery = '-eq 4'
            Credential          = $CredsCredential
        }
    }
}
