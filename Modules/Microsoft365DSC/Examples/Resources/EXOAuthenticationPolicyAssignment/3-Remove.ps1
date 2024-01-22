Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $EXOAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOAuthenticationPolicyAssignment 'ConfigureAuthenticationPolicyAssignment'
        {
            UserName                 = "AdeleV"
            AuthenticationPolicyName = "Test Policy"
            Ensure                   = "Absent"
            Credential               = $EXOAdmin
        }
    }
}
