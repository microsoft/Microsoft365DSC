<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example {
    param(
        [System.Management.Automation.PSCredential]
        $credsCredential
    )

    Import-DscResource -ModuleName Microsoft365DSC

    Node Localhost
    {
        AADAuthenticationFlowPolicy "AADAuthenticationFlowPolicy"
        {
            Credential               = $credsCredential;
            Description              = "Authentication flows policy allows modification of settings related to authentication flows in AAD tenant, such as self-service sign up configuration.";
            DisplayName              = "Authentication flows policy";
            Id                       = "authenticationFlowsPolicy";
            IsSingleInstance         = "Yes";
            SelfServiceSignUpEnabled = $True;
        }
    }
}
