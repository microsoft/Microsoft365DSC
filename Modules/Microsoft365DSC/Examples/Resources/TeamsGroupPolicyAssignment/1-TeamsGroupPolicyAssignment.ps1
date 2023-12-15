<#
This examples configure a TeamsGroupPolicyAssignment.
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
        TeamsGroupPolicyAssignment 'TeamsGroupPolicyAssignment'
        {
            Ensure           = 'Present'
            GroupDisplayname = 'SecGroup'
            GroupId          = ''
            PolicyName       = 'AllowCalling'
            PolicyType       = 'TeamsCallingPolicy'
            Priority         = 1
            Credential       = $Credscredential
        }
    }
}
