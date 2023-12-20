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
            Description             = "The tenant-wide policy that controls which authentication methods are allowed in the tenant, authentication method registration requirements, and self-service password reset settings";
            DisplayName             = "Authentication Methods Policy";
            Ensure                  = "Present";
            Id                      = "authenticationMethodsPolicy";
            PolicyMigrationState    = "preMigration";
            PolicyVersion           = "1.4";
            RegistrationEnforcement = MSFT_MicrosoftGraphregistrationEnforcement{
                AuthenticationMethodsRegistrationCampaign = MSFT_MicrosoftGraphAuthenticationMethodsRegistrationCampaign{
                    SnoozeDurationInDays = 1
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
