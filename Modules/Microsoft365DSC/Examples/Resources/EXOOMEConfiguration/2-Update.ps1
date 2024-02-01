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
        EXOOMEConfiguration 'ConfigureOMEConfiguration'
        {
            Identity                 = "Contoso Marketing"
            BackgroundColor          = "0x00FFFF00"
            DisclaimerText           = "Encryption security disclaimer."
            EmailText                = "Encrypted message enclosed."
            ExternalMailExpiryInDays = 1 # Updated Property
            IntroductionText         = "You have received an encypted message"
            OTPEnabled               = $True
            PortalText               = "This portal is encrypted."
            SocialIdSignIn           = $True
            Ensure                   = "Present"
            Credential               = $Credscredential
        }
    }
}
