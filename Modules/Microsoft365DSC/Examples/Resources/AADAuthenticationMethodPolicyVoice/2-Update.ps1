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
        AADAuthenticationMethodPolicyVoice "AADAuthenticationMethodPolicyVoice-Voice"
        {
            Credential           = $Credscredential;
            Ensure               = "Present";
            Id                   = "Voice";
            IncludeTargets       = @(
                MSFT_AADAuthenticationMethodPolicyVoiceIncludeTarget{
                    Id = 'all_users'
                    TargetType = 'group'
                }
            );
            IsOfficePhoneAllowed = $True; # Updated Property
            State                = "disabled";
        }
    }
}
