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
                    Description                   = 'Test Description'
                    MembershipRule                = "(user.country -eq `"Canada`")"
                    MembershipRuleProcessingState = 'On'
                    MembershipType                = 'Dynamic'
                    Ensure                        = 'Present'
                    Credential                    = $Credscredential
                }
                AADApplication 'AADApp1'
                {
                    DisplayName               = "AppDisplayName"
                    AvailableToOtherTenants   = $false
                    GroupMembershipClaims     = "0"
                    Homepage                  = "https://app.contoso.com"
                    IdentifierUris            = "https://app.contoso.com"
                    KnownClientApplications   = ""
                    LogoutURL                 = "https://app.contoso.com/logout"
                    PublicClient              = $false
                    ReplyURLs                 = "https://app.contoso.com"
                    Permissions               = @(
                        MSFT_AADApplicationPermission
                        {
                            Name                = 'User.Read'
                            Type                = 'Delegated'
                            SourceAPI           = 'Microsoft Graph'
                            AdminConsentGranted = $false
                        }
                        MSFT_AADApplicationPermission
                        {
                            Name                = 'User.ReadWrite.All'
                            Type                = 'Delegated'
                            SourceAPI           = 'Microsoft Graph'
                            AdminConsentGranted = $True
                        }
                        MSFT_AADApplicationPermission
                        {
                            Name                = 'User.Read.All'
                            Type                = 'AppOnly'
                            SourceAPI           = 'Microsoft Graph'
                            AdminConsentGranted = $True
                        }
                    )
                    Ensure                    = "Present"
                    Credential                = $Credscredential
                }
                AADAttributeSet 'AADAttributeSetTest'
                {
                    Credential           = $credsCredential;
                    Description          = "Attribute set with 420 attributes";
                    Ensure               = "Present";
                    Id                   = "TestAttributeSet";
                    MaxAttributesPerSet  = 420;
                }
                AADAuthenticationContextClassReference 'AADAuthenticationContextClassReference-Test'
                {
                    Credential           = $credsCredential;
                    Description          = "Context test";
                    DisplayName          = "My Context";
                    Ensure               = "Present";
                    Id                   = "c3";
                    IsAvailable          = $True;
                }
                AADAuthenticationMethodPolicy 'AADAuthenticationMethodPolicy-Authentication Methods Policy'
                {
                    Description             = "The tenant-wide policy that controls which authentication methods are allowed in the tenant, authentication method registration requirements, and self-service password reset settings";
                    DisplayName             = "Authentication Methods Policy";
                    Ensure                  = "Present";
                    Id                      = "authenticationMethodsPolicy";
                    PolicyMigrationState    = "migrationInProgress";
                    PolicyVersion           = "1.5";
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
                AADAuthenticationMethodPolicyAuthenticator 'AADAuthenticationMethodPolicyAuthenticator-MicrosoftAuthenticator'
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
                    IsSoftwareOathEnabled = $False;
                    State                 = "enabled";
                }
                AADAuthenticationMethodPolicyEmail 'AADAuthenticationMethodPolicyEmail-Email'
                {
                    AllowExternalIdToUseEmailOtp = "enabled";
                    Credential                   = $Credscredential;
                    Ensure                       = "Present";
                    ExcludeTargets               = @(
                        MSFT_AADAuthenticationMethodPolicyEmailExcludeTarget{
                            Id = 'Paralegals'
                            TargetType = 'group'
                        }
                    );
                    Id                           = "Email";
                    IncludeTargets               = @(
                        MSFT_AADAuthenticationMethodPolicyEmailIncludeTarget{
                            Id = 'Finance Team'
                            TargetType = 'group'
                        }
                        MSFT_AADAuthenticationMethodPolicyEmailIncludeTarget{
                            Id = 'Legal Team'
                            TargetType = 'group'
                        }
                    );
                    State                        = "enabled";
                }
                AADAuthenticationMethodPolicyFido2 'AADAuthenticationMethodPolicyFido2-Fido2'
                {
                    Credential                       = $Credscredential;
                    Ensure                           = "Present";
                    ExcludeTargets                   = @(
                        MSFT_AADAuthenticationMethodPolicyFido2ExcludeTarget{
                            Id = 'Paralegals'
                            TargetType = 'group'
                        }
                        MSFT_AADAuthenticationMethodPolicyFido2ExcludeTarget{
                            Id = 'Executives'
                            TargetType = 'group'
                        }
                    );
                    Id                               = "Fido2";
                    IncludeTargets                   = @(
                        MSFT_AADAuthenticationMethodPolicyFido2IncludeTarget{
                            Id = 'all_users'
                            TargetType = 'group'
                        }
                    );
                    IsAttestationEnforced            = $False;
                    IsSelfServiceRegistrationAllowed = $True;
                    KeyRestrictions                  = MSFT_MicrosoftGraphfido2KeyRestrictions{
                        IsEnforced = $False
                        EnforcementType = 'block'
                        AaGuids = @()
                    };
                    State                            = "enabled";
                }
                AADAuthenticationMethodPolicySms 'AADAuthenticationMethodPolicySms-Sms'
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
                    State                = "enabled";
                }
                AADAuthenticationMethodPolicySoftware 'AADAuthenticationMethodPolicySoftware-SoftwareOath'
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
                    State                = "enabled";
                }
                AADAuthenticationMethodPolicyTemporary 'AADAuthenticationMethodPolicyTemporary-TemporaryAccessPass'
                {
                    Credential               = $Credscredential;
                    DefaultLength            = 8;
                    DefaultLifetimeInMinutes = 60;
                    Ensure                   = "Present";
                    ExcludeTargets           = @(
                        MSFT_AADAuthenticationMethodPolicyTemporaryExcludeTarget{
                            Id = 'All Company'
                            TargetType = 'group'
                        }
                    );
                    Id                       = "TemporaryAccessPass";
                    IncludeTargets           = @(
                        MSFT_AADAuthenticationMethodPolicyTemporaryIncludeTarget{
                            Id = 'DSCGroup'
                            TargetType = 'group'
                        }
                    );
                    IsUsableOnce             = $False;
                    MaximumLifetimeInMinutes = 480;
                    MinimumLifetimeInMinutes = 60;
                    State                    = "enabled";
                }
                AADAuthenticationMethodPolicyVoice 'AADAuthenticationMethodPolicyVoice-Voice'
                {
                    Credential           = $Credscredential;
                    Ensure               = "Present";
                    Id                   = "Voice";
                    IncludeTargets       = @(
                        MSFT_AADAuthenticationMethodPolicyVoiceIncludeTarget{
                            Id = 'all_users'
                            TargetType = 'group'
                        }
                    );
                    IsOfficePhoneAllowed = $False;
                    State                = "disabled";
                }
                AADAuthenticationMethodPolicyX509 'AADAuthenticationMethodPolicyX509-X509Certificate'
                {
                    AuthenticationModeConfiguration = MSFT_MicrosoftGraphx509CertificateAuthenticationModeConfiguration{
        
                        Rules = @(@()
                        )
                        X509CertificateAuthenticationDefaultMode = 'x509CertificateSingleFactor'
                    };
                    CertificateUserBindings         = @(
                        MSFT_MicrosoftGraphx509CertificateUserBinding{
                            Priority = 1
                            UserProperty = 'userPrincipalName'
                            X509CertificateField = 'PrincipalName'
                        }
                        MSFT_MicrosoftGraphx509CertificateUserBinding{
                            Priority = 2
                            UserProperty = 'userPrincipalName'
                            X509CertificateField = 'RFC822Name'
                        }
                        MSFT_MicrosoftGraphx509CertificateUserBinding{
                            Priority = 3
                            UserProperty = 'certificateUserIds'
                            X509CertificateField = 'SubjectKeyIdentifier'
                        }
                    );
                    Credential                      = $Credscredential;
                    Ensure                          = "Present";
                    ExcludeTargets                  = @(
                        MSFT_AADAuthenticationMethodPolicyX509ExcludeTarget{
                            Id = 'DSCGroup'
                            TargetType = 'group'
                        }
                    );
                    Id                              = "X509Certificate";
                    IncludeTargets                  = @(
                        MSFT_AADAuthenticationMethodPolicyX509IncludeTarget{
                            Id = 'Finance Team'
                            TargetType = 'group'
                        }
                    );
                    State                           = "enabled";
                }
                AADAuthenticationStrengthPolicy 'AADAuthenticationStrengthPolicy-Example'
                {
                    AllowedCombinations  = @("windowsHelloForBusiness","fido2","x509CertificateMultiFactor","deviceBasedPush");
                    Description          = "This is an example";
                    DisplayName          = "Example";
                    Ensure               = "Present";
                    Credential           = $Credscredential;
                }
                AADConditionalAccessPolicy 'Allin-example'
                {
                    ApplicationEnforcedRestrictionsIsEnabled = $False;
                    BuiltInControls                          = @("mfa");
                    ClientAppTypes                           = @("all");
                    CloudAppSecurityIsEnabled                = $False;
                    Credential                               = $Credscredential;
                    DeviceFilterMode                         = "exclude";
                    DeviceFilterRule                         = "device.trustType -eq `"AzureAD`" -or device.trustType -eq `"ServerAD`" -or device.trustType -eq `"Workplace`"";
                    DisplayName                              = "Example CAP";
                    Ensure                                   = "Present";
                    ExcludeUsers                             = @("admin@$Domain");
                    GrantControlOperator                     = "OR";
                    IncludeApplications                      = @("All");
                    IncludeRoles                             = @("Attack Payload Author");
                    PersistentBrowserIsEnabled               = $False;
                    SignInFrequencyInterval                  = "timeBased";
                    SignInFrequencyIsEnabled                 = $True;
                    SignInFrequencyType                      = "hours";
                    SignInFrequencyValue                     = 1;
                    State                                    = "disabled";
                }
                AADCrossTenantAccessPolicyConfigurationPartner 'AADCrossTenantAccessPolicyConfigurationPartner'
                {
                    PartnerTenantId              = "e7a80bcf-696e-40ca-8775-a7f85fbb3ebc"; # O365DSC.onmicrosoft.com
                    AutomaticUserConsentSettings = MSFT_AADCrossTenantAccessPolicyAutomaticUserConsentSettings {
                        InboundAllowed           = $True
                        OutboundAllowed          = $True
                    };
                    B2BCollaborationOutbound     = MSFT_AADCrossTenantAccessPolicyB2BSetting {
                        Applications = MSFT_AADCrossTenantAccessPolicyTargetConfiguration{
                            AccessType = 'allowed'
                            Targets    = @(
                                MSFT_AADCrossTenantAccessPolicyTarget{
                                    Target     = 'AllApplications'
                                    TargetType = 'application'
                                }
                            )
                        }
                        UsersAndGroups = MSFT_AADCrossTenantAccessPolicyTargetConfiguration{
                            AccessType = 'allowed'
                            Targets    = @(
                                MSFT_AADCrossTenantAccessPolicyTarget{
                                    Target     = '68bafe64-f86b-4c4e-b33b-9d3eaa11544b' # Office 365
                                    TargetType = 'user'
                                }
                            )
                        }
                    };
                    ApplicationId                = 'c6957111-b1a6-479c-a15c-73e01ceb3b99'
                    CertificateThumbprint        = 'ACD01315A4EBA42CD2E18EEE443AA280CC0BAB8B'
                    TenantId                     = 'M365x35070558.onmicrosoft.com'
                    Ensure                       = "Present";
                }
                AADEntitlementManagementAccessPackage 'myAccessPackage'
                {
                    AccessPackagesIncompatibleWith = @();
                    CatalogId                      = "General";
                    Credential                     = $Credscredential;
                    Description                    = "Integration Tests";
                    DisplayName                    = "Integration Package";
                    Ensure                         = "Present";
                    IsHidden                       = $False;
                    IsRoleScopesVisible            = $True;
                }
                AADEntitlementManagementAccessPackageAssignmentPolicy 'myAssignmentPolicyWithAccessReviewsSettings'
                {
                    AccessPackageId         = "5d05114c-b4d9-4ae7-bda6-4bade48e60f2";
                    AccessReviewSettings    = MSFT_MicrosoftGraphassignmentreviewsettings{
                        IsEnabled = $True
                        StartDateTime = '12/17/2022 23:59:59'
                        IsAccessRecommendationEnabled = $True
                        AccessReviewTimeoutBehavior = 'keepAccess'
                        IsApprovalJustificationRequired = $True
                        ReviewerType = 'Self'
                        RecurrenceType = 'quarterly'
                        Reviewers = @()
                        DurationInDays = 25
                    };
                    CanExtend               = $False;
                    Description             = "";
                    DisplayName             = "External tenant";
                    DurationInDays          = 365;
                    RequestApprovalSettings = MSFT_MicrosoftGraphapprovalsettings{
                        ApprovalMode = 'NoApproval'
                        IsRequestorJustificationRequired = $False
                        IsApprovalRequired = $False
                        IsApprovalRequiredForExtension = $False
                    };
                    RequestorSettings       = MSFT_MicrosoftGraphrequestorsettings{
                        AllowedRequestors = @(
                            MSFT_MicrosoftGraphuserset{
                                IsBackup = $False
                                Id = 'e27eb9b9-27c3-462d-8d65-3bcd763b0ed0'
                                odataType = '#microsoft.graph.connectedOrganizationMembers'
                            }
                        )
                        AcceptRequests = $True
                        ScopeType = 'SpecificConnectedOrganizationSubjects'
                    };
                    Ensure                     = "Present"
                    Credential                 = $Credscredential
                }
                AADEntitlementManagementAccessPackageCatalog 'myAccessPackageCatalog'
                {
                    DisplayName         = 'General'
                    CatalogStatus       = 'Published'
                    CatalogType         = 'ServiceDefault'
                    Description         = 'Built-in catalog.'
                    IsExternallyVisible = $True
                    Managedidentity     = $False
                    Ensure              = 'Present'
                    Credential          = $Credscredential
                }
                AADEntitlementManagementAccessPackageCatalogResource 'myAccessPackageCatalogResource'
                {
                    DisplayName         = 'Communication site'
                    AddedBy             = 'admin@contoso.onmicrosoft.com'
                    AddedOn             = '05/11/2022 16:21:15'
                    CatalogId           = 'f34c2d92-9e9d-4703-ba9b-955b6ac8dcb3'
                    Description         = 'https://contoso.sharepoint.com/'
                    IsPendingOnboarding = $False
                    OriginId            = 'https://contoso.sharepoint.com/'
                    OriginSystem        = 'SharePointOnline'
                    ResourceType        = 'SharePoint Online Site'
                    Url                 = 'https://contoso.sharepoint.com/'
                    Ensure              = 'Present'
                    Credential          = $Credscredential
                }
                AADEntitlementManagementConnectedOrganization 'MyConnectedOrganization'
                {
                    Description           = "this is the tenant partner";
                    DisplayName           = "Test Tenant - DSC";
                    ExternalSponsors      = @("12345678-1234-1234-1234-123456789012");
                    IdentitySources       = @(
                        MSFT_AADEntitlementManagementConnectedOrganizationIdentitySource{
                            ExternalTenantId = "12345678-1234-1234-1234-123456789012"
                            DisplayName = 'Contoso'
                            odataType = '#microsoft.graph.azureActiveDirectoryTenant'
                        }
                    );
                    InternalSponsors      = @("12345678-1234-1234-1234-123456789012");
                    State                 = "configured";
                    Ensure                = "Present"
                    Credential            = $Credscredential
                }
                AADGroup 'MyGroups'
                {
                    DisplayName     = "DSCGroup"
                    Description     = "Microsoft DSC Group"
                    SecurityEnabled = $True
                    MailEnabled     = $True
                    GroupTypes      = @("Unified")
                    MailNickname    = "M365DSC"
                    Visibility      = "Private"
                    Ensure          = "Present"
                    Credential      = $Credscredential
                }
                AADNamedLocationPolicy 'CompanyNetwork'
                {
                    DisplayName = "Company Network"
                    IpRanges    = @("2.1.1.1/32", "1.2.2.2/32")
                    IsTrusted   = $True
                    OdataType   = "#microsoft.graph.ipNamedLocation"
                    Ensure      = "Present"
                    Credential  = $Credscredential
                }
                AADRoleDefinition 'AADRoleDefinition1'
                {
                    DisplayName                   = "DSCRole1"
                    Description                   = "DSC created role definition"
                    ResourceScopes                = "/"
                    IsEnabled                     = $true
                    RolePermissions               = "microsoft.directory/applicationPolicies/allProperties/read","microsoft.directory/applicationPolicies/allProperties/update","microsoft.directory/applicationPolicies/basic/update"
                    Version                       = "1.0"
                    Ensure                        = "Present"
                    Credential                    = $Credscredential
                }
                AADRoleEligibilityScheduleRequest 'MyRequest'
                {
                    Action               = "AdminAssign";
                    Credential           = $Credscredential;
                    DirectoryScopeId     = "/";
                    Ensure               = "Present";
                    IsValidationOnly     = $False;
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
                AADRoleSetting '28b253d8-cde5-471f-a331-fe7320023cdd'
                {
                    ActivateApprover                                          = @();
                    ActivationMaxDuration                                     = "PT8H";
                    ActivationReqJustification                                = $True;
                    ActivationReqMFA                                          = $False;
                    ActivationReqTicket                                       = $False;
                    ActiveAlertNotificationAdditionalRecipient                = @();
                    ActiveAlertNotificationDefaultRecipient                   = $True;
                    ActiveAlertNotificationOnlyCritical                       = $False;
                    ActiveApproveNotificationAdditionalRecipient              = @();
                    ActiveApproveNotificationDefaultRecipient                 = $True;
                    ActiveApproveNotificationOnlyCritical                     = $False;
                    ActiveAssigneeNotificationAdditionalRecipient             = @();
                    ActiveAssigneeNotificationDefaultRecipient                = $True;
                    ActiveAssigneeNotificationOnlyCritical                    = $False;
                    ApprovaltoActivate                                        = $False;
                    AssignmentReqJustification                                = $True;
                    AssignmentReqMFA                                          = $False;
                    Displayname                                               = "Application Administrator";
                    ElegibilityAssignmentReqJustification                     = $False;
                    ElegibilityAssignmentReqMFA                               = $False;
                    EligibleAlertNotificationAdditionalRecipient              = @();
                    EligibleAlertNotificationDefaultRecipient                 = $True;
                    EligibleAlertNotificationOnlyCritical                     = $False;
                    EligibleApproveNotificationAdditionalRecipient            = @();
                    EligibleApproveNotificationDefaultRecipient               = $True;
                    EligibleApproveNotificationOnlyCritical                   = $False;
                    EligibleAssigneeNotificationAdditionalRecipient           = @();
                    EligibleAssigneeNotificationDefaultRecipient              = $True;
                    EligibleAssigneeNotificationOnlyCritical                  = $False;
                    EligibleAssignmentAlertNotificationAdditionalRecipient    = @();
                    EligibleAssignmentAlertNotificationDefaultRecipient       = $True;
                    EligibleAssignmentAlertNotificationOnlyCritical           = $False;
                    EligibleAssignmentAssigneeNotificationAdditionalRecipient = @();
                    EligibleAssignmentAssigneeNotificationDefaultRecipient    = $True;
                    EligibleAssignmentAssigneeNotificationOnlyCritical        = $False;
                    ExpireActiveAssignment                                    = "P180D";
                    ExpireEligibleAssignment                                  = "P365D";
                    PermanentActiveAssignmentisExpirationRequired             = $False;
                    PermanentEligibleAssignmentisExpirationRequired           = $False;
                    Credential                                                = $Credscredential
                    Ensure                                                    = 'Present'
                }
                AADServicePrincipal 'AADServicePrincipal'
                {
                    AppId                         = "<AppID GUID>"
                    DisplayName                   = "AADAppName"
                    AlternativeNames              = "AlternativeName1","AlternativeName2"
                    AccountEnabled                = $true
                    AppRoleAssignmentRequired     = $false
                    ErrorUrl                      = ""
                    Homepage                      = "https://AADAppName.contoso.com"
                    LogoutUrl                     = "https://AADAppName.contoso.com/logout"
                    PublisherName                 = "Contoso"
                    ReplyURLs                     = "https://AADAppName.contoso.com"
                    SamlMetadataURL               = ""
                    ServicePrincipalNames         = "<AppID GUID>", "https://AADAppName.contoso.com"
                    ServicePrincipalType          = "Application"
                    Tags                          = "{WindowsAzureActiveDirectoryIntegratedApp}"
                    Ensure                        = "Present"
                    Credential                    = $Credscredential
                }
                AADSocialIdentityProvider 'AADSocialIdentityProvider-Google'
                {
                    ClientId             = "Google-OAUTH";
                    ClientSecret         = "FakeSecret";
                    Credential           = $credsCredential;
                    DisplayName          = "My Google Provider";
                    Ensure               = "Present";
                    IdentityProviderType = "Google";
                }
                AADUser 'ConfigureJohnSMith'
                {
                    UserPrincipalName  = "John.Smith@$Organization"
                    FirstName          = "John"
                    LastName           = "Smith"
                    DisplayName        = "John J. Smith"
                    City               = "Gatineau"
                    Country            = "Canada"
                    Office             = "Ottawa - Queen"
                    LicenseAssignment  = @("O365dsc1:ENTERPRISEPREMIUM")
                    UsageLocation      = "US"
                    Ensure             = "Present"
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
