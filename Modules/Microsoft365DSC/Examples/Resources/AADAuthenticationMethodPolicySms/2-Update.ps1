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
            Credential           = $Credscredential;
            Ensure               = "Present";
            ExcludeTargets       = @(
                MSFT_AADAuthenticationMethodPolicySmsExcludeTarget{
                    Id = 'All Employees'
                    TargetType = 'group'
                }
            );
            Id                   = "Sms";
            IncludeTargets       = @(
                MSFT_AADAuthenticationMethodPolicySmsIncludeTarget{
                    Id = 'all_users'
                    TargetType = 'group'
                }
            );
            State                = "enabled"; # Updated Property
        }
    }
}
