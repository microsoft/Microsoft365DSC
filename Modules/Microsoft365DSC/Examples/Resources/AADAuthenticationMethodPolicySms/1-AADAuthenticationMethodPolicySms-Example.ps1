<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter()]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    Node localhost
    {
        AADAuthenticationMethodPolicySms "AADAuthenticationMethodPolicySms-Sms"
        {
            ApplicationId         = $ConfigurationData.NonNodeData.ApplicationId;
            CertificateThumbprint = $ConfigurationData.NonNodeData.CertificateThumbprint;
            Ensure                = "Present";
            ExcludeTargets        = @(
                MSFT_MicrosoftGraphexcludeTarget2{
                    Id = 'fakegroup1'
                    TargetType = 'group'
                }
                MSFT_MicrosoftGraphexcludeTarget2{
                    Id = 'fakegroup2'
                    TargetType = 'group'
                }
            );
            Id                    = "Sms";
            IncludeTargets        = @(
                MSFT_MicrosoftGraphincludeTarget2{
                    Id = 'fakegroup3'
                    TargetType = 'group'
                }
                MSFT_MicrosoftGraphincludeTarget2{
                    Id = 'fakegroup4'
                    TargetType = 'group'
                }
            );
            State                 = "enabled";
            TenantId              = $ConfigurationData.NonNodeData.TenantId;
        }
    }
}
