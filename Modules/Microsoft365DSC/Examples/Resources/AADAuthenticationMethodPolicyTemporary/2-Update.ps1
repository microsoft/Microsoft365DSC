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
        AADAuthenticationMethodPolicyTemporary "AADAuthenticationMethodPolicyTemporary-TemporaryAccessPass"
        {
            Credential               = $credsCredential;
            DefaultLength            = 9; # Updated Property
            DefaultLifetimeInMinutes = 60;
            Ensure                   = "Present";
            ExcludeTargets           = @(
                MSFT_AADAuthenticationMethodPolicyTemporaryExcludeTarget{
                    Id = 'fakegroup1'
                    TargetType = 'group'
                }
                MSFT_AADAuthenticationMethodPolicyTemporaryExcludeTarget{
                    Id = 'fakegroup2'
                    TargetType = 'group'
                }
            );
            Id                       = "TemporaryAccessPass";
            IncludeTargets           = @(
                MSFT_AADAuthenticationMethodPolicyTemporaryIncludeTarget{
                    Id = 'fakegroup3'
                    TargetType = 'group'
                }
                MSFT_AADAuthenticationMethodPolicyTemporaryIncludeTarget{
                    Id = 'fakegroup4'
                    TargetType = 'group'
                }
            );
            IsUsableOnce             = $False;
            MaximumLifetimeInMinutes = 480;
            MinimumLifetimeInMinutes = 60;
            State                    = "enabled";
        }
    }
}
