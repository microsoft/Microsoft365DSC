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
        AADAuthenticationMethodPolicySms "AADAuthenticationMethodPolicySms-Sms"
        {
            Credential            = $credsCredential;
            Ensure                = "Present";
            ExcludeTargets        = @(
                MSFT_AADAuthenticationMethodPolicySmsExcludeTarget{
                    Id = 'fakegroup1'
                    TargetType = 'group'
                }
                MSFT_AADAuthenticationMethodPolicySmsExcludeTarget{
                    Id = 'fakegroup2'
                    TargetType = 'group'
                }
            );
            Id                    = "Sms";
            IncludeTargets        = @(
                MSFT_AADAuthenticationMethodPolicySmsIncludeTarget{
                    Id = 'fakegroup3'
                    TargetType = 'group'
                }
                MSFT_AADAuthenticationMethodPolicySmsIncludeTarget{
                    Id = 'fakegroup4'
                    TargetType = 'group'
                }
            );
            State                 = "enabled";
        }
    }
}
