    param
    (
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Configuration Master
    {
        param
        (
            [Parameter()]
            [System.String]
            $ApplicationId,

            [Parameter()]
            [System.String]
            $TenantId,

            [Parameter()]
            [System.String]
            $CertificateThumbprint
        )

        Import-DscResource -ModuleName Microsoft365DSC
        $Domain = $TenantId
        Node Localhost
        {
                AADAdministrativeUnit 'TestUnit'
                {
                    DisplayName                   = 'Test-Unit'
                    Description                   = 'Test Description Updated' # Updated Property
                    Visibility                    = 'Public'
                    MembershipRule                = "(user.country -eq `"US`")" # Updated Property
                    MembershipRuleProcessingState = 'On'
                    MembershipType                = 'Dynamic'
                    ScopedRoleMembers             = @(
                        MSFT_MicrosoftGraphScopedRoleMembership
                        {
                            RoleName       = 'User Administrator'
                            RoleMemberInfo = MSFT_MicrosoftGraphMember
                            {
                                Identity = "AdeleV@$TenantId" # Updated Property
                                Type     = "User"
                            }
                        }
                    )
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                }
                AADApplication 'AADApp1'
                {
                    DisplayName               = "AppDisplayName"
                    AvailableToOtherTenants   = $true # Updated Property
                    Description               = "Application Description"
                    GroupMembershipClaims     = "None"
                    Homepage                  = "https://$TenantId"
                    IdentifierUris            = "https://$TenantId"
                    KnownClientApplications   = ""
                    LogoutURL                 = "https://$TenantId/logout"
                    PublicClient              = $false
                    ReplyURLs                 = "https://$TenantId"
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
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                }
                AADAttributeSet 'AADAttributeSetTest'
                {
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                    Description          = "Attribute set with 420 attributes";
                    Ensure               = "Present";
                    Id                   = "TestAttributeSet";
                    MaxAttributesPerSet  = 300; # Updated Property
                }
                AADAuthenticationContextClassReference 'AADAuthenticationContextClassReference-Test'
                {
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                    Description          = "Context test Updated"; # Updated Property
                    DisplayName          = "My Context";
                    Ensure               = "Present";
                    Id                   = "c3";
                    IsAvailable          = $False; # Updated Property
                }
                AADAuthenticationFlowPolicy 'AADAuthenticationFlowPolicy'
                {
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                    Description              = "Authentication flows policy allows modification of settings related to authentication flows in AAD tenant, such as self-service sign up configuration.";
                    DisplayName              = "Authentication flows policy";
                    Id                       = "authenticationFlowsPolicy";
                    IsSingleInstance         = "Yes";
                    SelfServiceSignUpEnabled = $True;
                }
                AADAuthenticationMethodPolicy 'AADAuthenticationMethodPolicy-Authentication Methods Policy'
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
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                }
                AADAuthenticationMethodPolicyAuthenticator 'AADAuthenticationMethodPolicyAuthenticator-MicrosoftAuthenticator'
                {
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                    Ensure                = "Present";
                    ExcludeTargets        = @(
                        MSFT_AADAuthenticationMethodPolicyAuthenticatorExcludeTarget{
                            Id = 'Executives' # Updated Property
                            TargetType = 'group'
                        }
                    );
                    FeatureSettings       = MSFT_MicrosoftGraphmicrosoftAuthenticatorFeatureSettings{
                        DisplayLocationInformationRequiredState = MSFT_MicrosoftGraphAuthenticationMethodFeatureConfiguration{
                            IncludeTarget = MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget{
                                Id = 'all_users'
                                TargetType = 'group'
                            }
                            State = 'default'
                        }
                        CompanionAppAllowedState = MSFT_MicrosoftGraphAuthenticationMethodFeatureConfiguration{
                            IncludeTarget = MSFT_AADAuthenticationMethodPolicyAuthenticatorFeatureTarget{
                                Id = 'all_users'
                                TargetType = 'group'
                            }
                            State = 'default'
                        }
                        DisplayAppInformationRequiredState = MSFT_MicrosoftGraphAuthenticationMethodFeatureConfiguration{
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
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
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
                    State                        = "enabled"; # Updated Property
                }
                AADAuthenticationMethodPolicyFido2 'AADAuthenticationMethodPolicyFido2-Fido2'
                {
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
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
                    State                            = "enabled"; # Updated Property
                }
                AADAuthenticationMethodPolicySms 'AADAuthenticationMethodPolicySms-Sms'
                {
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
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
                AADAuthenticationMethodPolicySoftware 'AADAuthenticationMethodPolicySoftware-SoftwareOath'
                {
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
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
                    State                = "enabled"; # Updated Property
                }
                AADAuthenticationMethodPolicyTemporary 'AADAuthenticationMethodPolicyTemporary-TemporaryAccessPass'
                {
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                    DefaultLength            = 9; # Updated Property
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
                            Id = 'Executives'
                            TargetType = 'group'
                        }
                    );
                    IsUsableOnce             = $False;
                    MaximumLifetimeInMinutes = 480;
                    MinimumLifetimeInMinutes = 60;
                    State                    = "enabled";
                }
                AADAuthenticationMethodPolicyX509 'AADAuthenticationMethodPolicyX509-X509Certificate'
                {
                    AuthenticationModeConfiguration = MSFT_MicrosoftGraphx509CertificateAuthenticationModeConfiguration{
                        X509CertificateAuthenticationDefaultMode = 'x509CertificateSingleFactor'
                        Rules = @()
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
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
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
                    AllowedCombinations  = @("windowsHelloForBusiness","fido2","deviceBasedPush"); # Updated Property
                    Description          = "This is an example";
                    DisplayName          = "Example";
                    Ensure               = "Present";
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                }
                AADAuthorizationPolicy 'AADAuthPol'
                {
                    IsSingleInstance                                  = 'Yes'
                    DisplayName                                       = 'Authorization Policy'
                    Description                                       = 'Used to manage authorization related settings across the company.'
                    AllowEmailVerifiedUsersToJoinOrganization         = $true
                    AllowInvitesFrom                                  = 'everyone'
                    AllowedToSignUpEmailBasedSubscriptions            = $true
                    AllowedToUseSspr                                  = $true
                    BlockMsolPowerShell                               = $false
                    DefaultUserRoleAllowedToCreateApps                = $true
                    DefaultUserRoleAllowedToCreateSecurityGroups      = $true
                    DefaultUserRoleAllowedToReadOtherUsers            = $true
                    GuestUserRole                                     = 'Guest'
                    PermissionGrantPolicyIdsAssignedToDefaultUserRole = @()
                    Ensure                                            = 'Present'
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                }
                AADConditionalAccessPolicy 'ConditionalAccessPolicy'
                {
                    BuiltInControls                          = @("mfa");
                    ClientAppTypes                           = @("all");
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                    DeviceFilterMode                         = "exclude";
                    DeviceFilterRule                         = "device.trustType -eq `"AzureAD`" -or device.trustType -eq `"ServerAD`" -or device.trustType -eq `"Workplace`"";
                    DisplayName                              = "Example CAP";
                    Ensure                                   = "Present";
                    ExcludeUsers                             = @("admin@$Domain");
                    GrantControlOperator                     = "OR";
                    IncludeApplications                      = @("All");
                    IncludeRoles                             = @("Attack Payload Author");
                    SignInFrequencyInterval                  = "timeBased";
                    SignInFrequencyIsEnabled                 = $True;
                    SignInFrequencyType                      = "hours";
                    SignInFrequencyValue                     = 2; # Updated Porperty
                    State                                    = "disabled";
                }
                AADCrossTenantAccessPolicy 'AADCrossTenantAccessPolicy'
                {
                    AllowedCloudEndpoints = @("microsoftonline.us");
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                    DisplayName           = "MyXTAPPolicy";
                    Ensure                = "Present";
                    IsSingleInstance      = "Yes";
                }
                AADCrossTenantAccessPolicyConfigurationDefault 'AADCrossTenantAccessPolicyConfigurationDefault'
                {
                    B2BCollaborationInbound  = MSFT_AADCrossTenantAccessPolicyB2BSetting {
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
                        UsersAndGroups = MSFT_AADCrossTenantAccessPolicyTargetConfiguration{
                            AccessType = 'blocked'
                            Targets    = @(
                                MSFT_AADCrossTenantAccessPolicyTarget{
                                    Target     = 'AllUsers'
                                    TargetType = 'user'
                                }
                            )
                        }
                    }
                    B2BDirectConnectOutbound = MSFT_AADCrossTenantAccessPolicyB2BSetting {
                        Applications = MSFT_AADCrossTenantAccessPolicyTargetConfiguration{
                            AccessType = 'blocked'
                            Targets    = @(
                                MSFT_AADCrossTenantAccessPolicyTarget{
                                    Target     = 'AllApplications'
                                    TargetType = 'application'
                                }
                            )
                        }
                        UsersAndGroups = MSFT_AADCrossTenantAccessPolicyTargetConfiguration{
                            AccessType = 'blocked'
                            Targets    = @(
                                MSFT_AADCrossTenantAccessPolicyTarget{
                                    Target     = 'AllUsers'
                                    TargetType = 'user'
                                }
                            )
                        }
                    }
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                    Ensure                   = "Present";
                    InboundTrust             = MSFT_AADCrossTenantAccessPolicyInboundTrust {
                        IsCompliantDeviceAccepted           = $False
                        IsHybridAzureADJoinedDeviceAccepted = $False
                        IsMfaAccepted                       = $False
                    }
                    IsSingleInstance                        = "Yes";
                }
                AADCrossTenantAccessPolicyConfigurationPartner 'AADCrossTenantAccessPolicyConfigurationPartner'
                {
                    PartnerTenantId              = "e7a80bcf-696e-40ca-8775-a7f85fbb3ebc"; # O365DSC.onmicrosoft.com
                    AutomaticUserConsentSettings = MSFT_AADCrossTenantAccessPolicyAutomaticUserConsentSettings {
                        InboundAllowed           = $False # Updated Property
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
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                    Ensure                       = "Present";
                }
                AADEntitlementManagementAccessPackage 'myAccessPackage'
                {
                    AccessPackagesIncompatibleWith = @();
                    CatalogId                      = "General";
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                    Description                    = "Integration Tests";
                    DisplayName                    = "Integration Package";
                    Ensure                         = "Present";
                    IsHidden                       = $True; # Updated Property
                    IsRoleScopesVisible            = $True;
                }
                AADEntitlementManagementAccessPackageAssignmentPolicy 'myAssignments'
                {
                    AccessPackageId         = "Integration Package";
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
                    DurationInDays          = 180; # Updated Property
                    RequestApprovalSettings = MSFT_MicrosoftGraphapprovalsettings{
                        ApprovalMode = 'NoApproval'
                        IsRequestorJustificationRequired = $False
                        IsApprovalRequired = $False
                        IsApprovalRequiredForExtension = $False
                    };
                    Ensure                     = "Present"
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                }
                AADEntitlementManagementAccessPackageCatalog 'myAccessPackageCatalog'
                {
                    DisplayName         = 'My Catalog'
                    CatalogStatus       = 'Published'
                    CatalogType         = 'UserManaged'
                    Description         = 'Built-in catalog.'
                    IsExternallyVisible = $False # Updated Property
                    Managedidentity     = $False
                    Ensure              = 'Present'
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                }
                AADEntitlementManagementAccessPackageCatalogResource 'myAccessPackageCatalogResource'
                {
                    ApplicationId         = $ApplicationId;
                    CatalogId             = "My Catalog";
                    CertificateThumbprint = $CertificateThumbprint;
                    DisplayName           = "DSCGroup";
                    OriginSystem          = "AADGroup";
                    OriginId              = '849b3661-61a8-44a8-92e7-fcc91d296235'
                    Ensure                = "Present";
                    IsPendingOnboarding   = $False;
                    TenantId              = $TenantId;
                }
                AADEntitlementManagementConnectedOrganization 'MyConnectedOrganization'
                {
                    Description           = "This is the tenant partner - Updated"; # Updated Property
                    DisplayName           = "Test Tenant - DSC";
                    ExternalSponsors      = @("AdeleV@$TenantId");
                    IdentitySources       = @(
                        MSFT_AADEntitlementManagementConnectedOrganizationIdentitySource{
                            ExternalTenantId = "e7a80bcf-696e-40ca-8775-a7f85fbb3ebc"
                            DisplayName = 'o365dsc'
                            odataType = '#microsoft.graph.azureActiveDirectoryTenant'
                        }
                    );
                    InternalSponsors      = @("AdeleV@$TenantId");
                    State                 = "configured";
                    Ensure                = "Present"
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                }
                AADEntitlementManagementSettings 'AADEntitlementManagementSettings'
                {
                    ApplicationId                            = $ApplicationId;
                    CertificateThumbprint                    = $CertificateThumbprint;
                    DaysUntilExternalUserDeletedAfterBlocked = 30;
                    ExternalUserLifecycleAction              = "blockSignInAndDelete";
                    IsSingleInstance                         = "Yes";
                    TenantId                                 = $TenantId;
                }
                AADExternalIdentityPolicy 'AADExternalIdentityPolicy'
                {
                    AllowDeletedIdentitiesDataRemoval = $False;
                    AllowExternalIdentitiesToLeave    = $True;
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                    IsSingleInstance                  = "Yes";
                }
                AADGroup 'MyGroups'
                {
                    DisplayName     = "DSCGroup"
                    Description     = "Microsoft DSC Group Updated" # Updated Property
                    SecurityEnabled = $True
                    MailEnabled     = $True
                    GroupTypes      = @("Unified")
                    MailNickname    = "M365DSC"
                    Members         = @("AdeleV@$TenantId")
                    GroupAsMembers  = @("Group1")
                    Visibility      = "Private"
                    Owners          = @("admin@$TenantId", "AdeleV@$TenantId")
                    Ensure          = "Present"
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                }
                AADGroupLifecyclePolicy 'GroupLifecyclePolicy'
                {
                    IsSingleInstance            = "Yes"
                    AlternateNotificationEmails = @("john.smith@$TenantId")
                    GroupLifetimeInDays         = 99
                    ManagedGroupTypes           = "Selected"
                    Ensure                      = "Present"
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                }
                AADGroupsNamingPolicy 'GroupsNamingPolicy'
                {
                    IsSingleInstance              = "Yes"
                    CustomBlockedWordsList        = @("CEO", "President")
                    PrefixSuffixNamingRequirement = "[Title]Test[Company][GroupName][Office]Redmond"
                    Ensure                        = "Present"
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                }
                AADGroupsSettings 'GeneralGroupsSettings'
                {
                    IsSingleInstance              = "Yes"
                    AllowGuestsToAccessGroups     = $True
                    AllowGuestsToBeGroupOwner     = $True
                    AllowToAddGuests              = $True
                    EnableGroupCreation           = $True
                    GroupCreationAllowedGroupName = "All Company"
                    GuestUsageGuidelinesUrl       = "https://contoso.com/guestusage"
                    UsageGuidelinesUrl            = "https://contoso.com/usage"
                    Ensure                        = "Present"
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                }
                AADNamedLocationPolicy 'CompanyNetwork'
                {
                    DisplayName = "Company Network"
                    IpRanges    = @("2.1.1.1/32") # Updated Property
                    IsTrusted   = $False
                    OdataType   = "#microsoft.graph.ipNamedLocation"
                    Ensure      = "Present"
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                }
                AADRoleDefinition 'AADRoleDefinition1'
                {
                    DisplayName                   = "DSCRole1"
                    Description                   = "DSC created role definition"
                    ResourceScopes                = "/"
                    IsEnabled                     = $false # Updated Property
                    RolePermissions               = "microsoft.directory/applicationPolicies/allProperties/read","microsoft.directory/applicationPolicies/allProperties/update","microsoft.directory/applicationPolicies/basic/update"
                    Version                       = "1.0"
                    Ensure                        = "Present"
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                }
                AADRoleEligibilityScheduleRequest 'MyRequest'
                {
                    Action               = "AdminUpdate";
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                    DirectoryScopeId     = "/";
                    Ensure               = "Present";
                    IsValidationOnly     = $False;
                    Principal            = "AdeleV@$TenantId";
                    RoleDefinition       = "Teams Communications Administrator";
                    ScheduleInfo         = MSFT_AADRoleEligibilityScheduleRequestSchedule {
                        startDateTime             = '2023-09-01T02:45:44Z' # Updated Property
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
                    ActivationReqJustification                                = $False; # Updated Property
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
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                    Ensure                                                    = 'Present'
                }
                AADSecurityDefaults 'Defaults'
                {
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                    Description          = "Security defaults is a set of basic identity security mechanisms recommended by Microsoft. When enabled, these recommendations will be automatically enforced in your organization. Administrators and users will be better protected from common identity related attacks.";
                    DisplayName          = "Security Defaults";
                    IsEnabled            = $False;
                    IsSingleInstance     = "Yes";
                }
                AADServicePrincipal 'AADServicePrincipal'
                {
                    AppId                         = 'AppDisplayName'
                    DisplayName                   = "AppDisplayName"
                    AlternativeNames              = "AlternativeName1","AlternativeName3" # Updated Property
                    AccountEnabled                = $true
                    AppRoleAssignmentRequired     = $false
                    Homepage                      = "https://$TenantId"
                    LogoutUrl                     = "https://$TenantId/logout"
                    ReplyURLs                     = "https://$TenantId"
                    ServicePrincipalType          = "Application"
                    Tags                          = "{WindowsAzureActiveDirectoryIntegratedApp}"
                    Ensure                        = "Present"
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                }
                AADSocialIdentityProvider 'AADSocialIdentityProvider-Google'
                {
                    ClientId             = "Google-OAUTH";
                    ClientSecret         = "FakeSecret-Updated"; # Updated Property
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                    DisplayName          = "My Google Provider";
                    Ensure               = "Present";
                    IdentityProviderType = "Google";
                }
                AADTenantDetails 'ConfigureTenantDetails'
                {
                    IsSingleInstance                     = 'Yes'
                    TechnicalNotificationMails           = "example@contoso.com"
                    MarketingNotificationEmails          = "example@contoso.com"
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                }
                AADTokenLifetimePolicy 'SetTokenLifetimePolicy'
                {
                    DisplayName           = "PolicyDisplayName"
                    Definition            = @("{`"TokenLifetimePolicy`":{`"Version`":1,`"AccessTokenLifetime`":`"02:00:00`"}}");
                    IsOrganizationDefault = $true # Updated
                    Ensure                = "Present"
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                }
                AADUser 'ConfigureJohnSMith'
                {
                    UserPrincipalName  = "John.Smith@$TenantId"
                    FirstName          = "John"
                    LastName           = "Smith"
                    DisplayName        = "John J. Smith"
                    City               = "Ottawa" # Updated
                    Country            = "Canada"
                    Office             = "Ottawa - Queen"
                    UsageLocation      = "US"
                    Ensure             = "Present"
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
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
        Master -ConfigurationData $ConfigurationData -ApplicationId $ApplicationId -TenantId $TenantId -CertificateThumbprint $CertificateThumbprint
        Start-DscConfiguration Master -Wait -Force -Verbose -ErrorAction Stop
    }
    catch
    {
        throw $_
    }
