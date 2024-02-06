    param
    (
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    Configuration Master
    {
        param
        (
            [Parameter(Mandatory = $true)]
            [System.Management.Automation.PSCredential]
            $Credscredential
        )

        Import-DscResource -ModuleName Microsoft365DSC
        $Domain = $Credscredential.Username.Split('@')[1]
        Node Localhost
        {
                AADAdministrativeUnit 'TestUnit'
                {
                    DisplayName                   = 'Test-Unit'
                    Ensure                        = 'Absent'
                    Credential                    = $Credscredential
                }
                AADApplication 'AADApp1'
                {
                    DisplayName               = "AppDisplayName"
                    Ensure                    = "Absent"
                    Credential                = $Credscredential
                }
                AADAuthenticationContextClassReference 'AADAuthenticationContextClassReference-Test'
                {
                    Credential           = $credsCredential;
                    Description          = "Context test Updated"; # Updated Property
                    DisplayName          = "My Context";
                    Ensure               = "Absent";
                    Id                   = "c3";
                    IsAvailable          = $True;
                }
                AADAuthenticationMethodPolicyAuthenticator 'AADAuthenticationMethodPolicyAuthenticator-MicrosoftAuthenticator'
                {
                    Ensure                = "Absent";
                    Id                    = "MicrosoftAuthenticator";
                    IncludeTargets        = @(
                        MSFT_AADAuthenticationMethodPolicyAuthenticatorIncludeTarget{
                            Id = 'fakegroup6'
                            TargetType = 'group'
                        }
                    );
                    IsSoftwareOathEnabled = $True; # Updated Property
                    State                 = "enabled";
                    Credential            = $credsCredential;
                }
                AADAuthenticationMethodPolicyFido2 'AADAuthenticationMethodPolicyFido2-Fido2'
                {
                    Ensure                           = "Absent";
                    Id                               = "Fido2";
                    Credential                       = $credsCredential;
                }
                AADAuthenticationMethodPolicySms 'AADAuthenticationMethodPolicySms-Sms'
                {
                    Credential            = $credsCredential;
                    Ensure                = "Absent";
                    Id                    = "Sms";
                }
                AADAuthenticationMethodPolicySoftware 'AADAuthenticationMethodPolicySoftware-SoftwareOath'
                {
                    Credential            = $credsCredential;
                    Ensure                = "Absent";
                    Id                    = "SoftwareOath";
                }
                AADAuthenticationMethodPolicyTemporary 'AADAuthenticationMethodPolicyTemporary-TemporaryAccessPass'
                {
                    Credential               = $credsCredential;
                    Ensure                   = "Absent";
                    Id                       = "TemporaryAccessPass";
                }
                AADAuthenticationMethodPolicyVoice 'AADAuthenticationMethodPolicyVoice-Voice'
                {
                    Credential            = $credsCredential;
                    Ensure                = "Absent";
                    Id                    = "Voice";
                }
                AADAuthenticationMethodPolicyX509 'AADAuthenticationMethodPolicyX509-X509Certificate'
                {
                    Credential                      = $credsCredential;
                    Ensure                          = "Absent";
                    Id                              = "X509Certificate";
                }
                AADAuthenticationStrengthPolicy 'AADAuthenticationStrengthPolicy-Example'
                {
                    DisplayName          = "Example";
                    Ensure               = "Absent";
                    Credential           = $Credscredential;
                }
                AADConditionalAccessPolicy 'ConditionalAccessPolicy'
                {
                    DisplayName                          = 'Example CAP'
                    Ensure                               = 'Absent'
                    Credential                           = $Credscredential
                }
                AADCrossTenantAccessPolicyConfigurationPartner 'AADCrossTenantAccessPolicyConfigurationPartner'
                {
                    Credential               = $Credscredential;
                    Ensure                   = "Absent";
                    PartnerTenantId          = "12345-12345-12345-12345-12345";
                }
                AADEntitlementManagementAccessPackage 'myAccessPackage'
                {
                    DisplayName                     = 'Integration Package'
                    Ensure                          = 'Absent'
                    Credential                      = $Credscredential
                }
                AADEntitlementManagementAccessPackageAssignmentPolicy 'myAssignmentPolicyWithAccessReviewsSettings'
                {
                    DisplayName                = "External tenant";
                    Ensure                     = "Absent"
                    Credential                 = $Credscredential
                }
                AADEntitlementManagementAccessPackageCatalog 'myAccessPackageCatalog'
                {
                    DisplayName         = 'My Catalog'
                    Ensure              = 'Absent'
                    Credential          = $Credscredential
                }
                AADEntitlementManagementAccessPackageCatalogResource 'myAccessPackageCatalogResource'
                {
                    DisplayName         = 'Communication site'
                    Ensure              = 'Absent'
                    Credential          = $Credscredential
                }
                AADEntitlementManagementConnectedOrganization 'MyConnectedOrganization'
                {
                    DisplayName           = "Test Tenant - DSC";
                    Ensure                = "Absent"
                    Credential            = $Credscredential
                }
                AADGroup 'MyGroups'
                {
                    MailNickname    = "M365DSC"
                    SecurityEnabled = $True
                    MailEnabled     = $True
                    DisplayName     = "DSCGroup"
                    Ensure          = "Absent"
                    Credential      = $Credscredential
                }
                AADGroupLifecyclePolicy 'GroupLifecyclePolicy'
                {
                    IsSingleInstance            = "Yes"
                    AlternateNotificationEmails = @("john.smith@contoso.com")
                    GroupLifetimeInDays         = 99
                    ManagedGroupTypes           = "Selected"
                    Ensure                      = "Absent"
                    Credential                  = $Credscredential
                }
                AADGroupsNamingPolicy 'GroupsNamingPolicy'
                {
                    IsSingleInstance              = "Yes"
                    Ensure                        = "Absent"
                    Credential                    = $Credscredential
                }
                AADGroupsSettings 'GeneralGroupsSettings'
                {
                    IsSingleInstance              = "Yes"
                    Ensure                        = "Absent"
                    Credential                    = $Credscredential
                }
                AADNamedLocationPolicy 'CompanyNetwork'
                {
                    DisplayName = "Company Network"
                    Ensure      = "Absent"
                    Credential  = $Credscredential
                }
                AADRoleDefinition 'AADRoleDefinition1'
                {
                    IsEnabled                     = $true
                    RolePermissions               = "microsoft.directory/applicationPolicies/allProperties/read"
                    DisplayName                   = "DSCRole1"
                    Ensure                        = "Absent"
                    Credential                    = $Credscredential
                }
                AADRoleEligibilityScheduleRequest 'MyRequest'
                {
                    Action               = "AdminAssign";
                    Credential           = $Credscredential;
                    DirectoryScopeId     = "/";
                    Ensure               = "Absent";
                    IsValidationOnly     = $True; # Updated Property
                    Principal            = "John.Smith@$OrganizationName";
                    RoleDefinition       = "Teams Communications Administrator";
                    ScheduleInfo         = MSFT_AADRoleEligibilityScheduleRequestSchedule {
                        startDateTime             = '2023-09-01T02:40:44Z'
                        expiration                = MSFT_AADRoleEligibilityScheduleRequestScheduleExpiration
                            {
                                endDateTime = '2025-10-31T02:40:09Z'
                                type        = 'afterDateTime'
                            }
                    };
                }
                AADServicePrincipal 'AADServicePrincipal'
                {
                    AppId                         = "AppDisplayName"
                    DisplayName                   = "AppDisplayName"
                    Ensure                        = "Absent"
                    Credential                    = $Credscredential
                }
                AADSocialIdentityProvider 'AADSocialIdentityProvider-Google'
                {
                    ClientId             = "Google-OAUTH";
                    ClientSecret         = "FakeSecret-Updated"; # Updated Property
                    Credential           = $credsCredential;
                    DisplayName          = "My Google Provider";
                    Ensure               = "Absent";
                    IdentityProviderType = "Google";
                }
                AADTokenLifetimePolicy 'CreateTokenLifetimePolicy'
                {
                    DisplayName           = "PolicyDisplayName"
                    Ensure                = "Absent"
                    Credential            = $Credscredential
                }
                AADUser 'ConfigureJohnSMith'
                {
                    UserPrincipalName  = "John.Smith@$Domain"
                    DisplayName        = "John J. Smith"
                    Ensure             = "Absent"
                    Credential         = $Credscredential
                }
        }
    }

    $ConfigurationData = @{
        AllNodes = @(
            @{
                NodeName                    = "Localhost"
                PSDSCAllowPlaintextPassword = $true
            }
        )
    }

    # Compile and deploy configuration
    try
    {
        Master -ConfigurationData $ConfigurationData -Credscredential $Credential
        Start-DscConfiguration Master -Wait -Force -Verbose -ErrorAction Stop
    }
    catch
    {
        throw $_
    }
