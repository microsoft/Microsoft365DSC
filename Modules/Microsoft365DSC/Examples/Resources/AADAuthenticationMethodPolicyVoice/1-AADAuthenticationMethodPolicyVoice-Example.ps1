<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    Import-DscResource -ModuleName Microsoft365DSC

    Node localhost
    {
        AADAuthenticationMethodPolicyVoice "AADAuthenticationMethodPolicyVoice-Voice"
        {
            ApplicationId         = $ConfigurationData.NonNodeData.ApplicationId;
            CertificateThumbprint = $ConfigurationData.NonNodeData.CertificateThumbprint;
            Ensure                = "Present";
            Id                    = "Voice";
            IsOfficePhoneAllowed  = $False;
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
            TenantId              = $ConfigurationData.NonNodeData.TenantId;
        }
    }
}
