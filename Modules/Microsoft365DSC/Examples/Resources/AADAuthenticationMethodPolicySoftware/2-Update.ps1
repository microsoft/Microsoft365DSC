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
        AADAuthenticationMethodPolicySoftware "AADAuthenticationMethodPolicySoftware-SoftwareOath"
        {
            Credential           = $Credscredential;
            Ensure               = "Present";
            ExcludeTargets       = @(
                MSFT_AADAuthenticationMethodPolicySoftwareExcludeTarget{
                    Id = 'Executives'
                    TargetType = 'group'
                }
                MSFT_AADAuthenticationMethodPolicySoftwareExcludeTarget{
                    Id = 'Paralegals'
                    TargetType = 'group'
                }
            );
            Id                   = "SoftwareOath";
            IncludeTargets       = @(
                MSFT_AADAuthenticationMethodPolicySoftwareIncludeTarget{
                    Id = 'Legal Team'
                    TargetType = 'group'
                }
            );
            State                = "disabled"; # Updated Property
        }
    }
}
