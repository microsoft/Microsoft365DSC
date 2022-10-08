<#
This example adds a new Teams Channels Policy.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsCredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        TeamsOnlineVoicemailUserSettings 'AssignOnlineVoicemailUserSettings'
        {
            CallAnswerRule                           = "RegularVoicemail";
            Credential                               = $credsCredential;
            DefaultGreetingPromptOverwrite           = "Hellow World!";
            Ensure                                   = "Present";
            Identity                                 = "John.Smith@contoso.com";
            OofGreetingEnabled                       = $False;
            OofGreetingFollowAutomaticRepliesEnabled = $False;
            OofGreetingFollowCalendarEnabled         = $False;
            PromptLanguage                           = "en-US";
            ShareData                                = $False;
            VoicemailEnabled                         = $True;
        }
    }
}
