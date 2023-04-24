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
                MSFT_MicrosoftGraphexcludeTarget2{
                    Id = 'fakegroup1'
                    TargetType = 'group'
                }
                MSFT_MicrosoftGraphexcludeTarget2{
                    Id = 'fakegroup2'
                    TargetType = 'group'
                }
            );
            IncludeTargets           = @(
                MSFT_MicrosoftGraphincludeTarget2{
                    Id = 'fakegroup3'
                    TargetType = 'group'
                }
                MSFT_MicrosoftGraphincludeTarget2{
                    Id = 'fakegroup4'
                    TargetType = 'group'
                }
            );
            State                 = "disabled";
            TenantId              = $ConfigurationData.NonNodeData.TenantId;
        }
    }
}
