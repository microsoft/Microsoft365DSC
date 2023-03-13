<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

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
        TeamsIPPhonePolicy 'Example'
        {
            AllowBetterTogether            = "Enabled";
            AllowHomeScreen                = "EnabledUserOverride";
            AllowHotDesking                = $True;
            Credential                     = $Credscredential;
            Ensure                         = "Present";
            HotDeskingIdleTimeoutInMinutes = 120;
            Identity                       = "Global";
            SearchOnCommonAreaPhoneMode    = "Enabled";
            SignInMode                     = "UserSignIn";
        }
    }
}
