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
            UserName                 = "John.Smith"
            AuthenticationPolicyName = "Test Policy"
            Ensure                   = "Present"
            Credential               = $EXOAdmin
        }
    }
}
