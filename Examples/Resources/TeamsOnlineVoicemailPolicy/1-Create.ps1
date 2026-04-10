<#
This example adds a new Teams Meeting Policy.
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
        TeamsOnlineVoicemailPolicy 'NewOnlineVoicemailPolicy'
        {
            Credential                          = $credsCredential;
            EnableEditingCallAnswerRulesSetting = $True;
            EnableTranscription                 = $True;
            EnableTranscriptionProfanityMasking = $False;
            EnableTranscriptionTranslation      = $True;
            Ensure                              = "Present";
            Identity                            = "MyPolicy";
            MaximumRecordingLength              = 600;
            ShareData                           = "Defer";
        }
    }
}
