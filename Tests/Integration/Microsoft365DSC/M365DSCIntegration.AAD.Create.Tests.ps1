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
                AADAuthenticationMethodPolicyAuthenticator 'AADAuthenticationMethodPolicyAuthenticator-MicrosoftAuthenticator'
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
                AADAuthenticationMethodPolicyEmail 'AADAuthenticationMethodPolicyEmail-Email'
                {
                    AllowExternalIdToUseEmailOtp = "default";
                    Ensure                       = "Present";
                    ExcludeTargets               = @(
                        MSFT_AADAuthenticationMethodPolicyEmailExcludeTarget{
                            Id = 'fakegroup1'
                            TargetType = 'group'
                        }
                        MSFT_AADAuthenticationMethodPolicyEmailExcludeTarget{
                            Id = 'fakegroup2'
                            TargetType = 'group'
                        }
                    );
                    Id                           = "Email";
                    IncludeTargets               = @(
                        MSFT_AADAuthenticationMethodPolicyEmailIncludeTarget{
                            Id = 'fakegroup3'
                            TargetType = 'group'
                        }
                        MSFT_AADAuthenticationMethodPolicyEmailIncludeTarget{
                            Id = 'fakegroup4'
                            TargetType = 'group'
                        }
                    );
                    State                        = "enabled";
                    Credential                   = $credsCredential;
                }
                AADAuthenticationMethodPolicyFido2 'AADAuthenticationMethodPolicyFido2-Fido2'
                {
                    Ensure                           = "Present";
                    ExcludeTargets                   = @(
                        MSFT_AADAuthenticationMethodPolicyFido2ExcludeTarget{
                            Id = 'fakegroup1'
                            TargetType = 'group'
                        }
                        MSFT_AADAuthenticationMethodPolicyFido2ExcludeTarget{
                            Id = 'fakegroup2'
                            TargetType = 'group'
                        }
                    );
                    Id                               = "Fido2";
                    IncludeTargets                   = @(
                        MSFT_AADAuthenticationMethodPolicyFido2IncludeTarget{
                            Id = 'fakegroup3'
                            TargetType = 'group'
                        }
                        MSFT_AADAuthenticationMethodPolicyFido2IncludeTarget{
                            Id = 'fakegroup4'
                            TargetType = 'group'
                        }
                    );
                    IsAttestationEnforced            = $True;
                    IsSelfServiceRegistrationAllowed = $True;
                    KeyRestrictions                  = MSFT_MicrosoftGraphfido2KeyRestrictions{
                        IsEnforced = $False
                        EnforcementType = 'block'
                        AaGuids = @()
                    };
                    State                            = "enabled";
                    Credential                       = $credsCredential;
                }
                AADAuthenticationMethodPolicySms 'AADAuthenticationMethodPolicySms-Sms'
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
                AADAuthenticationMethodPolicySoftware 'AADAuthenticationMethodPolicySoftware-SoftwareOath'
                {
                    Credential            = $credsCredential;
                    Ensure                = "Present";
                    ExcludeTargets        = @(
                        MSFT_AADAuthenticationMethodPolicySoftwareExcludeTarget{
                            Id = 'fakegroup1'
                            TargetType = 'group'
                        }
                        MSFT_AADAuthenticationMethodPolicySoftwareExcludeTarget{
                            Id = 'fakegroup2'
                            TargetType = 'group'
                        }
                    );
                    Id                    = "SoftwareOath";
                    IncludeTargets        = @(
                        MSFT_AADAuthenticationMethodPolicySoftwareIncludeTarget{
                            Id = 'fakegroup3'
                            TargetType = 'group'
                        }
                        MSFT_AADAuthenticationMethodPolicySoftwareIncludeTarget{
                            Id = 'fakegroup4'
                            TargetType = 'group'
                        }
                    );
                    State                 = "enabled";
                }
                AADAuthenticationMethodPolicyTemporary 'AADAuthenticationMethodPolicyTemporary-TemporaryAccessPass'
                {
                    Credential               = $credsCredential;
                    DefaultLength            = 8;
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
                AADAuthenticationMethodPolicyVoice 'AADAuthenticationMethodPolicyVoice-Voice'
                {
                    Credential            = $credsCredential;
                    Ensure                = "Present";
                    Id                    = "Voice";
                    IsOfficePhoneAllowed  = $False;
                    ExcludeTargets           = @(
                        MSFT_AADAuthenticationMethodPolicyVoiceExcludeTarget{
                            Id = 'fakegroup1'
                            TargetType = 'group'
                        }
                        MSFT_AADAuthenticationMethodPolicyVoiceExcludeTarget{
                            Id = 'fakegroup2'
                            TargetType = 'group'
                        }
                    );
                    IncludeTargets           = @(
                        MSFT_AADAuthenticationMethodPolicyVoiceIncludeTarget{
                            Id = 'fakegroup3'
                            TargetType = 'group'
                        }
                        MSFT_AADAuthenticationMethodPolicyVoiceIncludeTarget{
                            Id = 'fakegroup4'
                            TargetType = 'group'
                        }
                    );
                    State                 = "disabled";
                }
                AADAuthenticationMethodPolicyX509 'AADAuthenticationMethodPolicyX509-X509Certificate'
                {
                    Credential                      = $credsCredential;
                    AuthenticationModeConfiguration = MSFT_MicrosoftGraphx509CertificateAuthenticationModeConfiguration{
                        Rules = @(@()
                        )
                        X509CertificateAuthenticationDefaultMode = 'x509CertificateMultiFactor'
                    };
                    CertificateUserBindings         = @(
                        MSFT_MicrosoftGraphx509CertificateUserBinding{
                            Priority = 1
                            UserProperty = 'onPremisesUserPrincipalName'
                            X509CertificateField = 'PrincipalName'
                        }
                        MSFT_MicrosoftGraphx509CertificateUserBinding{
                            Priority = 2
                            UserProperty = 'onPremisesUserPrincipalName'
                            X509CertificateField = 'RFC822Name'
                        }
                        MSFT_MicrosoftGraphx509CertificateUserBinding{
                            Priority = 3
                            UserProperty = 'certificateUserIds'
                            X509CertificateField = 'SubjectKeyIdentifier'
                        }
                    );
                    Ensure                          = "Present";
                    ExcludeTargets                  = @(
                        MSFT_AADAuthenticationMethodPolicyX509ExcludeTarget{
                            Id = 'fakegroup1'
                            TargetType = 'group'
                        }
                        MSFT_AADAuthenticationMethodPolicyX509ExcludeTarget{
                            Id = 'fakegroup2'
                            TargetType = 'group'
                        }
                    );
                    Id                              = "X509Certificate";
                    IncludeTargets                  = @(
                        MSFT_AADAuthenticationMethodPolicyX509IncludeTarget{
                            Id = 'fakegroup3'
                            TargetType = 'group'
                        }
                        MSFT_AADAuthenticationMethodPolicyX509IncludeTarget{
                            Id = 'fakegroup4'
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
                    DisplayName                          = 'Allin-example'
                    BuiltInControls                      = @('Mfa', 'CompliantDevice', 'DomainJoinedDevice', 'ApprovedApplication', 'CompliantApplication')
                    ClientAppTypes                       = @('ExchangeActiveSync', 'Browser', 'MobileAppsAndDesktopClients', 'Other')
                    CloudAppSecurityIsEnabled            = $True
                    CloudAppSecurityType                 = 'MonitorOnly'
                    ExcludeApplications                  = @('803ee9ca-3f7f-4824-bd6e-0b99d720c35c', '00000012-0000-0000-c000-000000000000', '00000007-0000-0000-c000-000000000000', 'Office365')
                    ExcludeGroups                        = @()
                    ExcludeLocations                     = @('Blocked Countries')
                    ExcludePlatforms                     = @('Windows', 'WindowsPhone', 'MacOS')
                    ExcludeRoles                         = @('Company Administrator', 'Application Administrator', 'Application Developer', 'Cloud Application Administrator', 'Cloud Device Administrator')
                    ExcludeUsers                         = @('admin@contoso.com', 'AAdmin@contoso.com', 'CAAdmin@contoso.com', 'AllanD@contoso.com', 'AlexW@contoso.com', 'GuestsOrExternalUsers')
                    ExcludeExternalTenantsMembers        = @()
                    ExcludeExternalTenantsMembershipKind = 'all'
                    ExcludeGuestOrExternalUserTypes      = @('internalGuest', 'b2bCollaborationMember')
                    GrantControlOperator                 = 'OR'
                    IncludeApplications                  = @('All')
                    IncludeGroups                        = @()
                    IncludeLocations                     = @('AllTrusted')
                    IncludePlatforms                     = @('Android', 'IOS')
                    IncludeRoles                         = @('Compliance Administrator')
                    IncludeUserActions                   = @()
                    IncludeUsers                         = @('Alexw@contoso.com')
                    IncludeExternalTenantsMembers        = @('11111111-1111-1111-1111-111111111111')
                    IncludeExternalTenantsMembershipKind = 'enumerated'
                    IncludeGuestOrExternalUserTypes      = @('b2bCollaborationGuest')
                    PersistentBrowserIsEnabled           = $false
                    PersistentBrowserMode                = ''
                    SignInFrequencyIsEnabled             = $true
                    SignInFrequencyType                  = 'Hours'
                    SignInFrequencyValue                 = 5
                    SignInRiskLevels                     = @('High', 'Medium')
                    State                                = 'disabled'
                    UserRiskLevels                       = @('High', 'Medium')
                    Ensure                               = 'Present'
                    Credential                           = $Credscredential
                }
                AADCrossTenantAccessPolicyConfigurationPartner 'AADCrossTenantAccessPolicyConfigurationPartner'
                {
                    B2BCollaborationInbound  = MSFT_AADCrossTenantAccessPolicyB2BSetting {
                        Applications = MSFT_AADCrossTenantAccessPolicyTargetConfiguration{
                            AccessType = 'allowed'
                            Targets    = @(
                                MSFT_AADCrossTenantAccessPolicyTarget{
                                    Target     = 'Office365'
                                    TargetType = 'application'
                                }
                            )
                        }
                        UsersAndGroups = MSFT_AADCrossTenantAccessPolicyTargetConfiguration{
                            AccessType = 'allowed'
                            Targets    = @(
                                MSFT_AADCrossTenantAccessPolicyTarget{
                                    Target     = 'AllUsers'
                                    TargetType = 'user'
                                }
                            )
                        }
                    }
                    B2BCollaborationOutbound = MSFT_AADCrossTenantAccessPolicyB2BSetting {
                        Applications = MSFT_AADCrossTenantAccessPolicyTargetConfiguration{
                            AccessType = 'allowed'
                            Targets    = @(
                                MSFT_AADCrossTenantAccessPolicyTarget{
                                    Target     = 'AllApplications'
                                    TargetType = 'application'
                                }
                            )
                        }
                    }
                    B2BDirectConnectInbound  = MSFT_AADCrossTenantAccessPolicyB2BSetting {
                        Applications = MSFT_AADCrossTenantAccessPolicyTargetConfiguration{
                            AccessType = 'blocked'
                            Targets    = @(
                                MSFT_AADCrossTenantAccessPolicyTarget{
                                    Target     = 'AllApplications'
                                    TargetType = 'application'
                                }
                            )
                        }
                    }
                    Credential               = $Credscredential;
                    Ensure                   = "Present";
                    PartnerTenantId          = "12345-12345-12345-12345-12345";
                }
                AADEntitlementManagementAccessPackage 'myAccessPackage'
                {
                    DisplayName                     = 'General'
                    AccessPackageResourceRoleScopes = @(
                        MSFT_AccessPackageResourceRoleScope {
                            Id                                   = 'e5b0c702-b949-4310-953e-2a51790722b8'
                            AccessPackageResourceOriginId        = '8721d9fd-c6ef-46df-b1b2-bb6f818bce5b'
                            AccessPackageResourceRoleDisplayName = 'AccessPackageRole'
                        }
                    )
                    CatalogId                       = '1b0e5aca-83e4-447b-84a8-3d8cffb4a331'
                    Description                     = 'Entitlement Access Package Example'
                    IsHidden                        = $false
                    IsRoleScopesVisible             = $true
                    IncompatibleAccessPackages      = @()
                    AccessPackagesIncompatibleWith  = @()
                    IncompatibleGroups              = @()
                    Ensure                          = 'Present'
                    Credential                      = $Credscredential
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
        Start-DscConfiguration Master -Wait -Force -Verbose
    }
    catch
    {
        throw $_
    }
