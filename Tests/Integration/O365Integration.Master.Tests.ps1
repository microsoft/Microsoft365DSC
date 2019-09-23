param
(
    [Parameter()]
    [System.String]
    $GlobalAdminUser,

    [Parameter()]
    [System.String]
    $GlobalAdminPassword,

    [Parameter(Mandatory=$true)]
    [System.String]
    $Domain
)

Configuration Master
{
    param
    (
        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdmin,

        [Parameter(Mandatory=$true)]
        [System.String]
        $Domain
    )

    Import-DscResource -ModuleName Office365DSC

    Node Localhost
    {
        EXOAcceptedDomain O365DSCDomain
        {
            Identity           = $Domain
            DomainType         = "Authoritative"
            GlobalAdminAccount = $GlobalAdmin
            Ensure             = "Present"
        }

        EXOAntiPhishPolicy AntiPhishPolicy
        {
            Identity                 = "Test AntiPhish Policy"
            AdminDisplayName         = "Default Monitoring Policy"
            AuthenticationFailAction = "Quarantine"
            GlobalAdminAccount       = $GlobalAdmin
            Ensure                   = "Present"
        }

        EXOAntiPhishRule AntiPhishRule
        {
            Identity           = "Test AntiPhish Rule"
            AntiPhishPolicy    = "Test AntiPhish Policy"
            Comments           = "This is a test Rule"
            SentToMemberOf     = @("O365DSCCore@$Domain")
            GlobalAdminAccount = $GlobalAdmin
            Ensure             = "Present"
            DependsOn          = "[O365Group]O365DSCCoreTeam"
        }

        <#EXOAtpPolicyForO365 AntiPhishPolicy
        {
            IsSingleInstance        = "Yes"
            AllowClickThrough       = $false
            BlockUrls               = "https://badurl.contoso.com"
            EnableATPForSPOTeamsODB = $true
            GlobalAdminAccount      = $GlobalAdmin
            Ensure                  = "Present"
        }#>

        O365User JohnSmith
        {
            UserPrincipalName  = "John.Smith@$Domain"
            DisplayName        = "John Smith"
            FirstName          = "John"
            LastName           = "Smith"
            City               = "Gatineau"
            Country            = "Canada"
            Office             = "HQ"
            PostalCode         = "5K5 K5K"
            GlobalAdminAccount = $GlobalAdmin
            Ensure             = "Present"
        }

        O365Group O365DSCCoreTeam
        {
            DisplayName          = "Office365DSC Core Team"
            MailNickName         = "O365DSCCore"
            ManagedBy            = "admin@$Domain"
            Description          = "Group for all the Core Team members"
            Members              = @("John.Smith@$Domain")
            GlobalAdminAccount   = $GlobalAdmin
            Ensure               = "Present"
            DependsOn            = "[O365User]JohnSmith"
        }

        SCComplianceSearch DemoSearchSPO
        {
            Case                                  = "Integration Case";
            HoldNames                             = @();
            Name                                  = "Integration Compliance Search - SPO";
            Ensure                                = "Present";
            Language                              = "iv";
            GlobalAdminAccount                    = $GlobalAdmin;
            AllowNotFoundExchangeLocationsEnabled = $False;
            SharePointLocation                    = @("All");
        }

        SCComplianceSearch DemoSearchEXO
        {
            Case                                  = "Integration Case";
            HoldNames                             = @();
            Name                                  = "Integration Compliance Search - EXO";
            Ensure                                = "Present";
            Language                              = "iv";
            GlobalAdminAccount                    = $GlobalAdmin;
            AllowNotFoundExchangeLocationsEnabled = $False;
            ExchangeLocation                      = @("All")
            PublicFolderLocation                  = @("All")
        }

        SCComplianceSearchAction DemoSearchActionExport
        {
            IncludeSharePointDocumentVersions   = $False;
            Action                              = "Export";
            SearchName                          = "Integration Compliance Search - EXO";
            GlobalAdminAccount                  = $GlobalAdmin;
            IncludeCredential                   = $False;
            RetryOnError                        = $False;
            ActionScope                         = "IndexedItemsOnly";
            Ensure                              = "Present";
            EnableDedupe                        = $False;
        }

        SCComplianceSearchAction DemoSearchActionRetention
        {
            IncludeSharePointDocumentVersions   = $False;
            Action                              = "Retention";
            SearchName                          = "Integration Compliance Search - EXO";
            GlobalAdminAccount                  = $GlobalAdmin;
            IncludeCredential                   = $False;
            RetryOnError                        = $False;
            ActionScope                         = "IndexedItemsOnly";
            Ensure                              = "Present";
            EnableDedupe                        = $False;
        }

        SCComplianceSearchAction DemoSearchActionPurge
        {
            Action                              = "Purge";
            SearchName                          = "Integration Compliance Search - EXO";
            GlobalAdminAccount                  = $GlobalAdmin;
            IncludeCredential                   = $False;
            RetryOnError                        = $False;
            Ensure                              = "Present";
        }

        SCComplianceCase DemoCase
        {
            Name               = "Integration Case"
            Description        = "This Case is generated by the Integration Tests"
            Status             = "Active"
            Ensure             = "Present"
            GlobalAdminAccount = $GlobalAdmin
        }

        SCCaseHoldPolicy DemoCaseHoldPolicy
        {
            Case                 = "Integration Case";
            ExchangeLocation     = "SharePointConference2019@o365dsc.onmicrosoft.com";
            Name                 = "Integration Hold";
            PublicFolderLocation = "All";
            Comment              = "This is a test for integration";
            Ensure               = "Present";
            Enabled              = $True;
            GlobalAdminAccount   = $GlobalAdmin;
        }

        SCCaseHoldRule DemoHoldRule
        {
            Name               = "Integration Hold"
            Policy             = "Integration Hold"
            Comment            = "This is a demo rule"
            Disabled           = $false
            ContentMatchQuery  = "filename:2016 budget filetype:xlsx"
            Ensure             = "Present"
            GlobalAdminAccount = $GlobalAdmin
        }

        SCComplianceTag DemoRule
        {
            Name               = "DemoTag"
            Comment            = "This is a Demo Tag"
            RetentionAction    = "Keep"
            RetentionDuration  = "1025"
            RetentionType      = "ModificationAgeInDays"
            FilePlanProperty   = MSFT_SCFilePlanProperty{
                FilePlanPropertyDepartment = "Human resources"
                FilePlanPropertyCategory = "Accounts receivable"
            }
            Ensure             = "Present"
            GlobalAdminAccount = $GlobalAdmin
        }

        SCDLPCompliancePolicy DLPPolicy
        {
            Name               = "MyDLPPolicy"
            Comment            = "Test Policy"
            Priority           = 1
            SharePointLocation = "https://$($Domain.Split('.')[0]).sharepoint.com/sites/Classic"
            Ensure             = "Present"
            GlobalAdminAccount = $GlobalAdmin
        }

        SCDLPComplianceRule DLPRule
        {
            Name                                = "MyDLPRule";
            Policy                              = "MyDLPPolicy"
            BlockAccess                         = $True;
            Ensure                              = "Present";
            GlobalAdminAccount                  = $GlobalAdmin;
            ContentContainsSensitiveInformation = MSFT_SCDLPSensitiveInformation
                                                  {
                                                      name = "U.S. Social Security Number (SSN)"
                                                  };
        }

        SCRetentionCompliancePolicy RCPolicy
        {
            Name               = "MyRCPolicy"
            Comment            = "Test Policy"
            Ensure             = "Present"
            GlobalAdminAccount = $GlobalAdmin
        }

        SCRetentionComplianceRule RCRule
        {
            Name                         = "DemoRule2"
            Policy                       = "MyRCPolicy"
            Comment                      = "This is a Demo Rule"
            RetentionComplianceAction    = "Keep"
            RetentionDuration            = "Unlimited"
            RetentionDurationDisplayHint = "Days"
            GlobalAdminAccount           = $GlobalAdmin
            Ensure                       = "Present"
        }

        SCSupervisoryReviewPolicy SRPolicy
        {
            Name               = "MySRPolicy"
            Comment            = "Test Policy"
            Reviewers          = @("admin@$Domain")
            Ensure             = "Present"
            GlobalAdminAccount = $GlobalAdmin
        }

        SCSupervisoryReviewRule SRRule
        {
            Name               = "DemoRule"
            Condition          = "(Reviewee:adminnonmfa@$Domain)"
            SamplingRate       = 100
            Policy             = 'MySRPolicy'
            Ensure             = "Present"
            GlobalAdminAccount = $GlobalAdmin
        }

        SPOSearchManagedProperty ManagedProp1
        {
            Name               = "Gilles"
            Type               = "Text"
            GlobalAdminAccount = $GlobalAdmin
            Ensure             = "Present"
        }

        SPOSite ClassicSite
        {
            Title                = "Classic Site"
            Url                  = "https://$($Domain.Split('.')[0]).sharepoint.com/sites/Classic"
            Owner                = "adminnonMFA@$Domain"
            Template             = "STS#0"
            GlobalAdminAccount   = $GlobalAdmin
            Ensure               = "Present"
        }

        SPOSite ModernSite
        {
            Title                = "Modern Site"
            Url                  = "https://$($Domain.Split('.')[0]).sharepoint.com/sites/Modern"
            Owner                = "adminnonmfa@$Domain"
            Template             = "STS#3"
            GlobalAdminAccount   = $GlobalAdmin
            Ensure               = "Present"
        }

        SPOPropertyBag MyKey
        {
            Url                = "https://$($Domain.Split('.')[0]).sharepoint.com/sites/Modern"
            Key                = "MyKey"
            Value              = "MyValue#3"
            GlobalAdminAccount = $GlobalAdmin
            Ensure             = "Present"
        }

        SPOSiteAuditSettings MyStorageEntity
        {
            Url                = "https://o365dsc.sharepoint.com/sites/Classic"
            AuditFlags         = "All"
            GlobalAdminAccount = $GlobalAdmin
        }

        <#SPOStorageEntity SiteEntity1
        {
            Key                = "SiteEntity1"
            Value              = "Modern Value"
            Description        = "Entity for Modern Site"
            EntityScope        = "Site"
            SiteUrl            = "https://o365dsc.sharepoint.com/sites/Modern"
            GlobalAdminAccount = $GlobalAdmin
            Ensure             = "Present"
        }

        SPOStorageEntity TenantEntity1
        {
            Key                = "TenantEntity1"
            Value              = "Tenant Value"
            Description        = "Entity for Tenant"
            EntityScope        = "Tenant"
            SiteUrl            = "https://o365dsc-admin.sharepoint.com/"
            GlobalAdminAccount = $GlobalAdmin
            Ensure             = "Present"
        }#>

        SPOTenantCDNPolicy PublicCDNPolicies
        {
            IncludeFileExtensions                = @('.jpg', '.png');
            ExcludeIfNoScriptDisabled            = $False;
            GlobalAdminAccount                   = $credsGlobalAdmin
            CDNType                              = "Public";
            ExcludeRestrictedSiteClassifications = @();
        }

        SPOTenantCDNPolicy PrivateCDNPolicies
        {
            IncludeFileExtensions                = @('.gif');
            ExcludeIfNoScriptDisabled            = $False;
            GlobalAdminAccount                   = $credsGlobalAdmin
            CDNType                              = "Private";
            ExcludeRestrictedSiteClassifications = @();
        }

        SPOUserProfileProperty AdminFavoriteFood
        {
            UserName           = "adminnonmfa@$Domain"
            Properties         = @(
                MSFT_SPOUserProfilePropertyInstance
                {
                    Key   = "FavoriteFood"
                    Value = "Pasta"
                }
            )
            GlobalAdminAccount = $GlobalAdmin
            Ensure             = "Present"
        }

        TeamsTeam TeamAlpha
        {
            DisplayName          = "Alpha Team"
            AllowAddRemoveApps   = $true
            AllowChannelMentions = $false
            GlobalAdminAccount   = $GlobalAdmin
            Ensure               = "Present"
        }

        TeamsChannel ChannelAlpha1
        {
            DisplayName        = "Channel Alpha"
            Description        = "Test Channel"
            TeamName           = "Alpha Team"
            GlobalAdminAccount = $GlobalAdmin
            Ensure             = "Present"
            DependsON          = "[TeamsTeam]TeamAlpha"
        }

        TeamsUser MemberJohn
        {
            TeamName           = "Alpha Team"
            User               = "John.Smith@$($Domain)"
            GlobalAdminAccount = $GlobalAdmin
            Ensure             = "Present"
            DependsON          = @("[O365User]JohnSmith","[TeamsTeam]TeamAlpha")
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
$password = ConvertTo-SecureString $GlobalAdminPassword -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($GlobalAdminUser, $password)
Master -ConfigurationData $ConfigurationData -GlobalAdmin $credential -Domain $Domain
Start-DscConfiguration Master -Wait -Force -Verbose
