Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    $Domain = $Credscredential.Username.Split('@')[1]
    node localhost
    {
        EXOAuthenticationPolicyAssignment 'ConfigureAuthenticationPolicyAssignment'
        {
            UserName                 = "AdeleV@$Domain"
            AuthenticationPolicyName = "Test Policy"
            Ensure                   = "Absent"
            Credential               = $Credscredential
        }
    }
}
