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
                    GroupMembershipClaims     = "None"
                    Homepage                  = "https://$Domain"
                    IdentifierUris            = "https://$Domain"
                    KnownClientApplications   = ""
                    LogoutURL                 = "https://$Domain/logout"
                    PublicClient              = $false
                    ReplyURLs                 = "https://$Domain"
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
                AADAuthenticationStrengthPolicy 'AADAuthenticationStrengthPolicy-Example'
                {
                    AllowedCombinations  = @("windowsHelloForBusiness","fido2","x509CertificateMultiFactor","deviceBasedPush");
                    Description          = "This is an example";
                    DisplayName          = "Example";
                    Ensure               = "Present";
                    Credential           = $Credscredential;
                }
                AADConditionalAccessPolicy 'ConditionalAccessPolicy'
                {
                    BuiltInControls                          = @("mfa");
                    ClientAppTypes                           = @("all");
                    Credential                               = $Credscredential;
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
                    Credential                   = $credsCredential
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
                    DurationInDays          = 365;
                    RequestApprovalSettings = MSFT_MicrosoftGraphapprovalsettings{
                        ApprovalMode = 'NoApproval'
                        IsRequestorJustificationRequired = $False
                        IsApprovalRequired = $False
                        IsApprovalRequiredForExtension = $False
                    };
                    Ensure                     = "Present"
                    Credential                 = $Credscredential
                }
                AADEntitlementManagementAccessPackageCatalog 'myAccessPackageCatalog'
                {
                    DisplayName         = 'My Catalog'
                    CatalogStatus       = 'Published'
                    CatalogType         = 'UserManaged'
                    Description         = 'Built-in catalog.'
                    IsExternallyVisible = $True
                    Managedidentity     = $False
                    Ensure              = 'Present'
                    Credential          = $Credscredential
                }
                AADEntitlementManagementAccessPackageCatalogResource 'myAccessPackageCatalogResource'
                {
                    DisplayName         = 'Human Resources'
                    CatalogId           = 'My Catalog'
                    Description         = "https://$($Domain.Split('.')[0]).sharepoint.com/sites/HumanResources"
                    IsPendingOnboarding = $true
                    OriginId            = "https://$($Domain.Split('.')[0]).sharepoint.com/sites/HumanResources"
                    OriginSystem        = 'SharePointOnline'
                    ResourceType        = 'SharePoint Online Site'
                    Url                 = "https://$($Domain.Split('.')[0]).sharepoint.com/sites/HumanResources"
                    Ensure              = 'Present'
                    Credential          = $Credscredential
                }
                AADEntitlementManagementConnectedOrganization 'MyConnectedOrganization'
                {
                    Description           = "this is the tenant partner";
                    DisplayName           = "Test Tenant - DSC";
                    ExternalSponsors      = @("AdeleV@$Domain");
                    IdentitySources       = @(
                        MSFT_AADEntitlementManagementConnectedOrganizationIdentitySource{
                            ExternalTenantId = "e7a80bcf-696e-40ca-8775-a7f85fbb3ebc"
                            DisplayName = 'o365dsc'
                            odataType = '#microsoft.graph.azureActiveDirectoryTenant'
                        }
                    );
                    InternalSponsors      = @("AdeleV@$Domain");
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
                    Owners          = @("AdeleV@$Domain")
                    Ensure          = "Present"
                    Credential      = $Credscredential
                }
                AADNamedLocationPolicy 'CompanyNetwork'
                {
                    DisplayName = "Company Network"
                    IpRanges    = @("2.1.1.1/32", "1.2.2.2/32")
                    IsTrusted   = $False
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
                    Principal            = "AdeleV@$Domain";
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
                    AppId                         = 'AppDisplayName'
                    DisplayName                   = "AppDisplayName"
                    AlternativeNames              = "AlternativeName1","AlternativeName2"
                    AccountEnabled                = $true
                    AppRoleAssignmentRequired     = $false
                    Homepage                      = "https://$Domain"
                    LogoutUrl                     = "https://$Domain/logout"
                    ReplyURLs                     = "https://$Domain"
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
                AADTokenLifetimePolicy 'CreateTokenLifetimePolicy'
                {
                    DisplayName           = "PolicyDisplayName"
                    Definition            = @("{`"TokenLifetimePolicy`":{`"Version`":1,`"AccessTokenLifetime`":`"02:00:00`"}}");
                    IsOrganizationDefault = $false
                    Ensure                = "Present"
                    Credential            = $Credscredential
                }
                AADUser 'ConfigureJohnSMith'
                {
                    UserPrincipalName  = "John.Smith@$Domain"
                    FirstName          = "John"
                    LastName           = "Smith"
                    DisplayName        = "John J. Smith"
                    City               = "Gatineau"
                    Country            = "Canada"
                    Office             = "Ottawa - Queen"
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
