Configuration MSFT_SPOTenant
{
    Import-DSCResource -ModuleName Office365DSC
    $credsGlobalAdmin = Get-Credential -UserName "TenantAdmin@O365DSC1.onmicrosoft.com" -Message "Global Admin"
    Node localhost
    {
        SPOTenant  MyTenant
        {
            Ensure                                        = 'Present'
            Tenant                                        = "MyTenant"
            CentralAdminUrl                               = "https://o365dsc1-admin.sharepoint.com"
            GlobalAdminAccount                            = $credsGlobalAdmin
            SharingCapability                             = 'ExternalUserSharingOnly'
            MinCompatibilityLevel                         = 15
            MaxCompatibilityLevel                         = 15
            ExternalServicesEnabled                       = $true
            NoAccessRedirectUrl                           = ""
            disableContentTypeSyncSiteTemplatesList       = $true
            DisplayStartASiteOption                       = $true
            StartASiteFormUrl                             = ""
            ShowEveryoneClaim                             = $false
            ShowAllUsersClaim                             = $false
            ShowEveryoneExceptExternalUsersClaim          = $true
            SearchResolveExactEmailOrUPN                  = $false
            OfficeClientADALDisabled                      = $false
            LegacyAuthProtocolsEnabled                    = $true
            RequireAcceptingAccountMatchInvitedAccount    = $false
            ProvisionSharedWithEveryoneFolder             = $false
            SignInAccelerationDomain                      = $null
            EnableGuestSignInAcceleration                 = $false
            UsePersistentCookiesForExplorerView           = $false
            BccExternalSharingInvitationsList             = ""
            UserVoiceForFeedbackEnabled                   = $true
            PublicCdnEnabled                              = $false
            PublicCdnAllowedFileTypes                     = "CSS,EOT,GIF,ICO,JPEG,JPG,JS,MAP,PNG,SVG,TTF,WOFF"
            RequireAnonymousLinksExpireInDays             = 730 # setting the value back to 0 caused an error value has to be between 1 and 790 even though documented differently
            SharingAllowedDomainList                      = "contoso.com"
            SharingDomainRestrictionMode                  = "None" #depending on RequireAcceptinAccountMatchInvitedAccount
            SharingBlockedDomainList                      = "contoso.com"
            IPAddressWACTokenLifetime                     = 15
            UseFindPeopleInPeoplePicker                   = $false
            DefaultSharingLinkType                        = "AnonymousAccess" #According to the documentation the options should be None Direct Internal AnonymousAccess / during my tests I was not able to set it to None (all other options worked fine)
            PreventExternalUsersFromResharing             = $false
            ShowPeoplePickerSuggestionsForGuestUsers      = $false
            FileAnonymousLinkType                         = "Edit" #According to the documentation None should be an option but when running the set-spotenant cmdlet it will tell you that it is just View or Edit
            FolderAnonymousLinkType                       = "Edit" #According to the documentation None should be an option but when running the set-spotenant cmdlet it will tell you that it is just View or Edit
            NotifyOwnersWhenItemsReshared                 = $true
            NotificationsInSharePointEnabled              = $true
            SpecialCharactersStateInFileFolderNames       = "Allowed" #According to the documentation NoPreference should be an option but when running the set-spotenant cmdlet it will tell you that it is just Allowed or Disallowed.
            CommentsOnSitePagesDisabled                   = $false
            SocialBarOnSitePagesDisabled                  = $false
            PermissiveBrowserFileHandlingOverride         = $false # This flag is deprecated and cannot be configured for that it will be removed if configured.
            DisallowInfectedFileDownload                  = $false
            ApplyAppEnforcedRestrictionsToAdHocRecipients = $true
            FilePickerExternalImageSearchEnabled          = $true
            EmailAttestationRequired                      = $false
            EmailAttestationReAuthDays                    = 30
            SyncPrivacyProfileProperties                  = $true
            DisabledWebPartIds = "00000000-0000-0000-0000-000000000000" #The guid "00000000-0000-0000-0000-000000000000" resets the DisabledWebPartIds
            OrgNewsSiteUrl = ""
            EnableMinimumVersionRequirement = $true
            #ContentTypeSyncSiteTemplatesList = "MySites"
            #OneDriveStorageQuota                          = 1048576
            #OneDriveForGuestsEnabled                      = $false
            #IPAddressAllowList = "" #make sure to add your own IP address as well as a valid range in CIDR notation #setting the IPAddressAllowList was not possible while writing this resoruce
            #IPAddressEnforcement = $false
            #ODBMembersCanShare                            = "Unspecified"
            #ODBAccessRequests                             = "Unspecified"
            #NotifyOwnersWhenInvitationsAccepted           = $true
            #NotificationsInOneDriveForBusinessEnabled     = $true
            #OrphanedPersonalSitesRetentionPeriod          = 30
            #DefaultLinkPermission ="View" #Not documented under https://docs.microsoft.com/en-us/powershell/module/sharepoint-online/set-spotenant?view=sharepoint-ps initial value is None, once changed it cannot be re-set to None again
            #ConditionalAccessPolicy = "AllowFullAccess" #This setting requires Intune and a Azure AD Premium subscription
            #AllowDownloadingNonWebViewableFiles = $true #This setting requires Intune and a Azure AD Premium subscription / this parameter has been discontinued use LimitedAccessFileType instead.
            #LimitedAccessFileType = "WebPreviewableFiles" #This setting requires Intune and a Azure AD Premium subscription 
            #AllowEditing = $true #This setting requires Intune and a Azure AD Premium subscription
        }
    }
}

$configData = @{
    AllNodes = @(
        @{
            NodeName = "localhost"
            PSDscAllowPlainTextPassword = $true;
            PSDscAllowDomainUser = $true;
    }
    )
}
MSFT_SPOTenant -ConfigurationData $configData
