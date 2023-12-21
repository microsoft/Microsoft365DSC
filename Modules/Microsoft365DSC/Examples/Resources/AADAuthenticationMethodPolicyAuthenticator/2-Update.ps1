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
        AADAuthenticationMethodPolicyAuthenticator "AADAuthenticationMethodPolicyAuthenticator-MicrosoftAuthenticator"
        {
            Credential            = $Credscredential;
            Ensure                = "Present";
            ExcludeTargets        = @(
                MSFT_AADAuthenticationMethodPolicyAuthenticatorExcludeTarget{
                    Id = 'Legal Team'
                    TargetType = 'group'
                }
                MSFT_AADAuthenticationMethodPolicyAuthenticatorExcludeTarget{
                    Id = 'Paralegals'
                    TargetType = 'group'
                }
            );
            FeatureSettings       = MSFT_MicrosoftGraphmicrosoftAuthenticatorFeatureSettings{
                DisplayLocationInformationRequiredState = MSFT_MicrosoftGraphAuthenticationMethodFeatureConfiguration{
                    ExcludeTarget = MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget{
                        Id = 'all_users'
                        TargetType = 'group'
                    }
                    IncludeTarget = MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget{
                        Id = 'all_users'
                        TargetType = 'group'
                    }
                    State = 'default'
                }
                CompanionAppAllowedState = MSFT_MicrosoftGraphAuthenticationMethodFeatureConfiguration{
                    ExcludeTarget = MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget{
                        Id = 'all_users'
                        TargetType = 'group'
                    }
                    IncludeTarget = MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget{
                        Id = 'all_users'
                        TargetType = 'group'
                    }
                    State = 'default'
                }
                DisplayAppInformationRequiredState = MSFT_MicrosoftGraphAuthenticationMethodFeatureConfiguration{
                    ExcludeTarget = MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget{
                        Id = 'all_users'
                        TargetType = 'group'
                    }
                    IncludeTarget = MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget{
                        Id = 'all_users'
                        TargetType = 'group'
                    }
                    State = 'default'
                }
            };
            Id                    = "MicrosoftAuthenticator";
            IncludeTargets        = @(
                MSFT_AADAuthenticationMethodPolicyAuthenticatorIncludeTarget{
                    Id = 'Finance Team'
                    TargetType = 'group'
                }
                MSFT_AADAuthenticationMethodPolicyAuthenticatorIncludeTarget{
                    Id = 'Northwind Traders'
                    TargetType = 'group'
                }
            );
            IsSoftwareOathEnabled = $True; # Updated Property
            State                 = "enabled";
        }
    }
}
