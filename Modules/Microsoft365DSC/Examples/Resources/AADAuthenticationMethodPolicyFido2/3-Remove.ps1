<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    Import-DscResource -ModuleName Microsoft365DSC

    Node localhost
    {
        param
        (
            [Parameter(Mandatory = $true)]
            [PSCredential]
            $credsCredential
        )
        AADAuthenticationMethodPolicyFido2 "AADAuthenticationMethodPolicyFido2-Fido2"
        {
            Ensure                           = "Absent";
            Id                               = "Fido2";
            Credential                       = $credsCredential;
        }
    }
}
