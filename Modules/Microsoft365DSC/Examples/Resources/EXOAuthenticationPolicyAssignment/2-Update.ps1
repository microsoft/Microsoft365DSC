Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOAuthenticationPolicyAssignment 'ConfigureAuthenticationPolicyAssignment'
        {
            UserName                 = "AdeleV"
            AuthenticationPolicyName = "Test Policy" # Updaqted Property
            Ensure                   = "Present"
            Credential               = $Credscredential
        }
    }
}
