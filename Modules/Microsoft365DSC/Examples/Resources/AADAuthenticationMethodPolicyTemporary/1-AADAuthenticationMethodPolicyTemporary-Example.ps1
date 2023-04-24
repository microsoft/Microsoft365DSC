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
        AADAuthenticationMethodPolicyTemporary "AADAuthenticationMethodPolicyTemporary-TemporaryAccessPass"
        {
            ApplicationId            = $ConfigurationData.NonNodeData.ApplicationId;
            CertificateThumbprint    = $ConfigurationData.NonNodeData.CertificateThumbprint;
            DefaultLength            = 8;
            DefaultLifetimeInMinutes = 60;
            Ensure                   = "Present";
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
            Id                       = "TemporaryAccessPass";
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
            IsUsableOnce             = $False;
            MaximumLifetimeInMinutes = 480;
            MinimumLifetimeInMinutes = 60;
            State                    = "enabled";
            TenantId                 = $ConfigurationData.NonNodeData.TenantId;
        }
    }
}
