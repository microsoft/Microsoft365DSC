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
            Credential            = $credsCredential;
            Ensure                = "Present";
            Id                    = "Voice";
            IsOfficePhoneAllowed  = $True; # Updated Property
            ExcludeTargets           = @(
                MSFT_AADAuthenticationMethodPolicyVoiceExcludeTarget{
                    Id = 'fakegroup1'
                    TargetType = 'group'
                }
                MSFT_AADAuthenticationMethodPolicyVoiceExcludeTarget{
                    Id = 'fakegroup2'
                    TargetType = 'group'
                }
            );
            IncludeTargets           = @(
                MSFT_AADAuthenticationMethodPolicyVoiceIncludeTarget{
                    Id = 'fakegroup3'
                    TargetType = 'group'
                }
                MSFT_AADAuthenticationMethodPolicyVoiceIncludeTarget{
                    Id = 'fakegroup4'
                    TargetType = 'group'
                }
            );
            State                 = "disabled";
        }
    }
}
