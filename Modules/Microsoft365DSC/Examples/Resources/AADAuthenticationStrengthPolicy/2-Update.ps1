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
        $credsCredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    Node localhost
    {
        AADAuthenticationStrengthPolicy "AADAuthenticationStrengthPolicy-Example"
        {
            AllowedCombinations  = @("windowsHelloForBusiness","fido2","deviceBasedPush"); # Updated Property
            Description          = "This is an example";
            DisplayName          = "Example";
            Ensure               = "Present";
            Credential           = $Credscredential;
        }
    }
}
