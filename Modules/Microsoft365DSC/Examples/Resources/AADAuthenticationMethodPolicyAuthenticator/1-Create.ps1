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
            Ensure                = "Present";
            ExcludeTargets        = @(
                MSFT_AADAuthenticationMethodPolicyAuthenticatorExcludeTarget{
                    Id = 'fakegroup1'
                    TargetType = 'group'
                }
            );
            FeatureSettings       = MSFT_MicrosoftGraphmicrosoftAuthenticatorFeatureSettings{
                DisplayLocationInformationRequiredState = MSFT_MicrosoftGraphAuthenticationMethodFeatureConfiguration{
                    ExcludeTarget = MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget{
                        Id = '00000000-0000-0000-0000-000000000000'
                        TargetType = 'group'
                    }
                    IncludeTarget = MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget{
                        Id = 'fakegroup2'
                        TargetType = 'group'
                    }
                    State = 'enabled'
                }
                            NumberMatchingRequiredState = MSFT_MicrosoftGraphAuthenticationMethodFeatureConfiguration{
                    ExcludeTarget = MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget{
                        Id = '00000000-0000-0000-0000-000000000000'
                        TargetType = 'group'
                    }
                    IncludeTarget = MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget{
                        Id = 'fakegroup3'
                        TargetType = 'group'
                    }
                    State = 'enabled'
                }
                            CompanionAppAllowedState = MSFT_MicrosoftGraphAuthenticationMethodFeatureConfiguration{
                    ExcludeTarget = MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget{
                        Id = '00000000-0000-0000-0000-000000000000'
                        TargetType = 'group'
                    }
                    IncludeTarget = MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget{
                        Id = 'fakegroup4'
                        TargetType = 'group'
                    }
                    State = 'enabled'
                }
                            DisplayAppInformationRequiredState = MSFT_MicrosoftGraphAuthenticationMethodFeatureConfiguration{
                    ExcludeTarget = MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget{
                        Id = '00000000-0000-0000-0000-000000000000'
                        TargetType = 'group'
                    }
                    IncludeTarget = MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget{
                        Id = 'fakegroup5'
                        TargetType = 'group'
                    }
                    State = 'enabled'
                }
                        };
            Id                    = "MicrosoftAuthenticator";
            IncludeTargets        = @(
                MSFT_AADAuthenticationMethodPolicyAuthenticatorIncludeTarget{
                    Id = 'fakegroup6'
                    TargetType = 'group'
                }
            );
            IsSoftwareOathEnabled = $False;
            State                 = "enabled";
            Credential            = $credsCredential;
        }
    }
}
