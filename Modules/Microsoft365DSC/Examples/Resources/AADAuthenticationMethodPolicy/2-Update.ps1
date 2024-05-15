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
        AADAuthenticationMethodPolicy "AADAuthenticationMethodPolicy-Authentication Methods Policy"
        {
            DisplayName             = "Authentication Methods Policy";
            Ensure                  = "Present";
            Id                      = "authenticationMethodsPolicy";
            PolicyMigrationState    = "migrationInProgress";
            PolicyVersion           = "1.5";
            RegistrationEnforcement = MSFT_MicrosoftGraphregistrationEnforcement{
                AuthenticationMethodsRegistrationCampaign = MSFT_MicrosoftGraphAuthenticationMethodsRegistrationCampaign{
                    SnoozeDurationInDays = (Get-Random -Minimum 1 -Maximum 14)
                    IncludeTargets = @(
                        MSFT_MicrosoftGraphAuthenticationMethodsRegistrationCampaignIncludeTarget{
                            TargetedAuthenticationMethod = 'microsoftAuthenticator'
                            TargetType = 'group'
                            Id = 'all_users'
                        }
                    )
                    State = 'default'
                }
            };
            Credential           = $credsCredential;
        }
    }
}
