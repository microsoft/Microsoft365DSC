<#
This examples sets the Teams Meeting Configuration.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        TeamsMeetingConfiguration DemoMeetingConfiguration
        {
            ClientAppSharingPort        = 50040;
            ClientAppSharingPortRange   = 20;
            ClientAudioPort             = 50000;
            ClientAudioPortRange        = 20;
            ClientMediaPortRangeEnabled = $True;
            ClientVideoPort             = 50020;
            ClientVideoPortRange        = 20;
            CustomFooterText            = "This is some custom footer text";
            DisableAnonymousJoin        = $False;
            EnableQoS                   = $False;
            GlobalAdminAccount          = $credsglobaladmin;
            HelpURL                     = "https://github.com/Microsoft/Microsoft365DSC/Help";
            Identity                    = "Global";
            LegalURL                    = "https://github.com/Microsoft/Microsoft365DSC/Legal";
            LogoURL                     = "https://github.com/Microsoft/Microsoft365DSC/Logo.png";
        }
    }
}
