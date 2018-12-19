function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (

        [Parameter(Mandatory = $true)] 
        [validateSet("Present","Absent")]
        [System.String] 
        $Ensure,

        [Parameter(Mandatory = $true)]
        [System.String]
        ${Tenant},

        [Parameter()]
        [System.Uint32]
        ${MinCompatibilityLevel},
        
        [Parameter()]
        [System.Uint32]
        ${MaxCompatibilityLevel},

        [Parameter()]
        [System.boolean]
        ${ExternalServicesEnabled},

        [Parameter()]
        [System.String]
        ${NoAccessRedirectUrl},
        
        [Parameter()]
        [System.String]
        ${ContentTypeSyncSiteTemplatesList},

        [Parameter()]
        [System.Boolean]
        ${disableContentTypeSyncSiteTemplatesList},
        
        [Parameter()]
        [System.String]
        ${SharingCapability},

        [Parameter()]
        [System.boolean]
        ${DisplayStartASiteOption},

        [Parameter()]
        [System.String]
        ${StartASiteFormUrl},

        [Parameter()]
        [System.boolean]
        ${ShowEveryoneClaim},

        [Parameter()]
        [System.boolean]
        ${ShowAllUsersClaim},

        [Parameter()]
        [System.boolean]
        ${ShowEveryoneExceptExternalUsersClaim},

        [Parameter()]
        [System.boolean]
        ${SearchResolveExactEmailOrUPN},

        [Parameter()]
        [System.boolean]
        ${OfficeClientADALDisabled},

        [Parameter()]
        [System.boolean]
        ${LegacyAuthProtocolsEnabled},
        
        [Parameter()]
        [System.boolean]
        ${RequireAcceptingAccountMatchInvitedAccount},

        [Parameter()]
        [System.boolean]
        ${ProvisionSharedWithEveryoneFolder},

        [Parameter()]
        [System.String]
        ${SignInAccelerationDomain},

        [Parameter()]
        [System.boolean]
        ${EnableGuestSignInAcceleration},

        [Parameter()]
        [System.boolean]
        ${UsePersistentCookiesForExplorerView},

        [Parameter()]
        [System.boolean]
        ${BccExternalSharingInvitations},

        [Parameter()]
        [System.String]
        ${BccExternalSharingInvitationsList},

        [Parameter()]
        [System.boolean]
        ${UserVoiceForFeedbackEnabled},

        [System.boolean]
        ${PublicCdnEnabled},

        [Parameter()]
        [System.String]
        ${PublicCdnAllowedFileTypes},

        [Parameter()]
        [System.Uint32]
        ${RequireAnonymousLinksExpireInDays},

        [Parameter()]
        [System.String]
        ${SharingAllowedDomainList},

        [Parameter()]
        [System.String]
        ${SharingBlockedDomainList},

        [Parameter()]
        [System.String]
        ${SharingDomainRestrictionMode},

        [Parameter()]
        [long]
        ${OneDriveStorageQuota},

        [Parameter()]
        [System.boolean]
        ${OneDriveForGuestsEnabled},

        [Parameter()]
        [System.boolean]
        ${IPAddressEnforcement},

        [Parameter()]
        [System.String]
        ${IPAddressAllowList},

        [Parameter()]
        [System.Uint32]
        ${IPAddressWACTokenLifetime},

        [Parameter()]
        [System.boolean]
        ${UseFindPeopleInPeoplePicker},

        [Parameter()]
        [System.String]
        ${DefaultSharingLinkType},

        [Parameter()]
        [System.String]
        ${ODBMembersCanShare},

        [Parameter()]
        [System.String]
        ${ODBAccessRequests},

        [Parameter()]
        [System.boolean]
        ${PreventExternalUsersFromResharing},

        [Parameter()]
        [System.boolean]
        ${ShowPeoplePickerSuggestionsForGuestUsers},

        [Parameter()]
        [System.String]
        ${FileAnonymousLinkType},

        [Parameter()]
        [System.String]
        ${FolderAnonymousLinkType},

        [Parameter()]
        [System.boolean]
        ${NotifyOwnersWhenItemsReshared},

        [Parameter()]
        [System.boolean]
        ${NotifyOwnersWhenInvitationsAccepted},
        
        [Parameter()]
        [System.boolean]
        ${NotificationsInOneDriveForBusinessEnabled},

        [Parameter()]
        [System.boolean]
        ${NotificationsInSharePointEnabled},

        [Parameter()]
        [System.String]
        ${SpecialCharactersStateInFileFolderNames},
        
        [Parameter()]
        [System.boolean]
        ${OwnerAnonymousNotification},

        [Parameter()]
        [System.boolean]
        ${CommentsOnSitePagesDisabled},
        
        [Parameter()]
        [System.boolean]
        ${SocialBarOnSitePagesDisabled},

        [Parameter()]
        [System.Uint32]
        ${OrphanedPersonalSitesRetentionPeriod},

        [Parameter()]
        [System.boolean]
        ${PermissiveBrowserFileHandlingOverride},

        [Parameter()]
        [System.boolean]
        ${DisallowInfectedFileDownload},

        [Parameter()]
        [System.String]
        ${DefaultLinkPermission},

        [Parameter()]
        [System.String]
        ${ConditionalAccessPolicy},

        [Parameter()]
        [System.boolean]
        ${AllowDownloadingNonWebViewableFiles},

        [Parameter()]
        [System.String]
        ${LimitedAccessFileType},

        [Parameter()]
        [System.boolean]
        ${AllowEditing},

        [Parameter()]
        [System.boolean]
        ${ApplyAppEnforcedRestrictionsToAdHocRecipients},

        [Parameter()]
        [System.boolean]
        ${FilePickerExternalImageSearchEnabled},

        [Parameter()]
        [System.boolean]
        ${EmailAttestationRequired},

        [Parameter()]
        [System.Uint32]
        ${EmailAttestationReAuthDays},

        [Parameter()]
        [System.boolean]
        ${SyncPrivacyProfileProperties},

        [Parameter()]
        ${DisabledWebPartIds},

        [Parameter()]
        [System.String]
        ${OrgNewsSiteUrl},
        
        [Parameter()]
        [System.boolean]
        ${EnableMinimumVersionRequirement},

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )
    
    Test-SPOServiceConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount
    try
    {
        $spoTenant = Get-SPOTenant
            
        return @{
            MinCompatibilityLevel = $spoTenant.MinCompatibilityLevel
            MaxCompatibilityLevel = $spoTenant.MaxCompatibilityLevel
            ExternalServicesEnabled = $spoTenant.ExternalServicesEnabled
            NoAccessRedirectUrl = $spoTenant.NoAccessRedirectUrl
            SharingCapability = $spoTenant.SharingCapability
            DisplayStartASiteOption = $spoTenant.DisplayStartASiteOption
            StartASiteFormUrl = $spoTenant.StartASiteFormUrl
            ShowEveryoneClaim = $spoTenant.ShowEveryoneClaim
            ShowAllUsersClaim = $spoTenant.ShowAllUsersClaim
            ShowEveryoneExceptExternalUsersClaim = $spoTenant.ShowEveryoneExceptExternalUsersClaim
            SearchResolveExactEmailOrUPN = $spoTenant.SearchResolveExactEmailOrUPN
            OfficeClientADALDisabled = $spoTenant.OfficeClientADALDisabled
            LegacyAuthProtocolsEnabled = $spoTenant.LegacyAuthProtocolsEnabled
            RequireAcceptingAccountMatchInvitedAccount = $spoTenant.RequireAcceptingAccountMatchInvitedAccount
            ProvisionSharedWithEveryoneFolder = $spoTenant.ProvisionSharedWithEveryoneFolder
            SignInAccelerationDomain = $spoTenant.SignInAccelerationDomain
            EnableGuestSignInAcceleration = $spoTenant.EnableGuestSignInAcceleration
            UsePersistentCookiesForExplorerView = $spoTenant.UsePersistentCookiesForExplorerView
            ContentTypeSyncSiteTemplatesList = $spoTenant.ContentTypeSyncSiteTemplatesList
            ExcludeSiteTemplate = $spoTenant.ExcludeSiteTemplate
            BccExternalSharingInvitations = $spoTenant.BccExternalSharingInvitations
            BccExternalSharingInvitationsList = $spoTenant.BccExternalSharingInvitationsList
            UserVoiceForFeedbackEnabled = $spoTenant.UserVoiceForFeedbackEnabled
            PublicCdnEnabled = $spoTenant.PublicCdnEnabled
            PublicCdnAllowedFileTypes = $spoTenant.PublicCdnAllowedFileTypes
            RequireAnonymousLinksExpireInDays = $spoTenant.RequireAnonymousLinksExpireInDays
            SharingAllowedDomainList = $spoTenant.SharingAllowedDomainList
            SharingBlockedDomainList = $spoTenant.SharingBlockedDomainList
            SharingDomainRestrictionMode = $spoTenant.SharingDomainRestrictionMode
            OneDriveStorageQuota = $spoTenant.OneDriveStorageQuota
            OneDriveForGuestsEnabled = $spoTenant.OneDriveForGuestsEnabled
            IPAddressEnforcement = $spoTenant.IPAddressEnforcement
            IPAddressAllowList = $spoTenant.IPAddressAllowList
            IPAddressWACTokenLifetime = $spoTenant.IPAddressWACTokenLifetime
            UseFindPeopleInPeoplePicker = $spoTenant.UseFindPeopleInPeoplePicker
            DefaultSharingLinkType = $spoTenant.DefaultSharingLinkType
            ODBMembersCanShare = $spoTenant.ODBMembersCanShare
            ODBAccessRequests = $spoTenant.ODBAccessRequests
            PreventExternalUsersFromResharing = $spoTenant.PreventExternalUsersFromResharing
            ShowPeoplePickerSuggestionsForGuestUsers = $spoTenant.ShowPeoplePickerSuggestionsForGuestUsers
            FileAnonymousLinkType = $spoTenant.FileAnonymousLinkType
            FolderAnonymousLinkType = $spoTenant.FolderAnonymousLinkType
            NotifyOwnersWhenItemsReshared = $spoTenant.NotifyOwnersWhenItemsReshared
            NotifyOwnersWhenInvitationsAccepted = $spoTenant.NotifyOwnersWhenInvitationsAccepted
            NotificationsInOneDriveForBusinessEnabled = $spoTenant.NotificationsInOneDriveForBusinessEnabled
            NotificationsInSharePointEnabled = $spoTenant.NotificationsInSharePointEnabled
            SpecialCharactersStateInFileFolderNames = $spoTenant.SpecialCharactersStateInFileFolderNames
            OwnerAnonymousNotification = $spoTenant.OwnerAnonymousNotification
            CommentsOnSitePagesDisabled = $spoTenant.CommentsOnSitePagesDisabled
            CommentsOnFilesDisabled = $spoTenant.CommentsOnFilesDisabled
            SocialBarOnSitePagesDisabled = $spoTenant.SocialBarOnSitePagesDisabled
            OrphanedPersonalSitesRetentionPeriod = $spoTenant.OrphanedPersonalSitesRetentionPeriod
            PermissiveBrowserFileHandlingOverride = $spoTenant.PermissiveBrowserFileHandlingOverride
            DisallowInfectedFileDownload = $spoTenant.DisallowInfectedFileDownload
            DefaultLinkPermission = $spoTenant.DefaultLinkPermission
            CustomizedExternalSharingServiceUrl = $spoTenant.CustomizedExternalSharingServiceUrl
            ConditionalAccessPolicy = $spoTenant.ConditionalAccessPolicy
            AllowDownloadingNonWebViewableFiles = $spoTenant.AllowDownloadingNonWebViewableFiles
            LimitedAccessFileType = $spoTenant.LimitedAccessFileType
            AllowEditing = $spoTenant.AllowEditing
            ApplyAppEnforcedRestrictionsToAdHocRecipients = $spoTenant.ApplyAppEnforcedRestrictionsToAdHocRecipients
            FilePickerExternalImageSearchEnabled = $spoTenant.FilePickerExternalImageSearchEnabled
            EmailAttestationRequired = $spoTenant.EmailAttestationRequired
            EmailAttestationReAuthDays = $spoTenant.EmailAttestationReAuthDays
            SyncPrivacyProfileProperties = $spoTenant.SyncPrivacyProfileProperties
            DisabledWebPartIds = $spoTenant.DisabledWebPartIds
            OrgNewsSiteUrl = $spoTenant.OrgNewsSiteUrl
            EnableMinimumVersionRequirement = $spoTenant.EnableMinimumVersionRequirement
            MarkNewFilesSensitiveByDefault = $spoTenant.MarkNewFilesSensitiveByDefault
        }
    }
    catch
    {
        if($error[0].Exception.Message -like "No connection available")
        {
            write-Verbose "Make sure that you are connected to your SPOService"
            return $null
        }
    }
}
function Set-TargetResource
{
    [CmdletBinding()]
    param (

        [Parameter(Mandatory = $true)] 
        [validateSet("Present", "Absent")]
        [System.String] 
        $Ensure,

        [Parameter(Mandatory = $true)]
        [System.String]
        ${Tenant},

        [Parameter()]
        [System.Uint32]
        ${MinCompatibilityLevel},
        
        [Parameter()]
        [System.Uint32]
        ${MaxCompatibilityLevel},

        [Parameter()]
        [System.boolean]
        ${ExternalServicesEnabled},

        [Parameter()]
        [System.String]
        ${NoAccessRedirectUrl},
        
        [Parameter()]
        [System.String]
        ${ContentTypeSyncSiteTemplatesList},
       
        [Parameter()]
        [System.Boolean]
        ${disableContentTypeSyncSiteTemplatesList},
        
        [Parameter()]
        [System.String]
        ${SharingCapability},

        [Parameter()]
        [System.boolean]
        ${DisplayStartASiteOption},

        [Parameter()]
        [System.String]
        ${StartASiteFormUrl},

        [Parameter()]
        [System.boolean]
        ${ShowEveryoneClaim},

        [Parameter()]
        [System.boolean]
        ${ShowAllUsersClaim},

        [Parameter()]
        [System.boolean]
        ${ShowEveryoneExceptExternalUsersClaim},

        [Parameter()]
        [System.boolean]
        ${SearchResolveExactEmailOrUPN},

        [Parameter()]
        [System.boolean]
        ${OfficeClientADALDisabled},

        [Parameter()]
        [System.boolean]
        ${LegacyAuthProtocolsEnabled},
        
        [Parameter()]
        [System.boolean]
        ${RequireAcceptingAccountMatchInvitedAccount},

        [Parameter()]
        [System.boolean]
        ${ProvisionSharedWithEveryoneFolder},

        [Parameter()]
        [System.String]
        ${SignInAccelerationDomain},

        [Parameter()]
        [System.boolean]
        ${EnableGuestSignInAcceleration},

        [Parameter()]
        [System.boolean]
        ${UsePersistentCookiesForExplorerView},

        [Parameter()]
        [System.boolean]
        ${BccExternalSharingInvitations},

        [Parameter()]
        [System.String]
        ${BccExternalSharingInvitationsList},

        [Parameter()]
        [System.boolean]
        ${UserVoiceForFeedbackEnabled},

        [System.boolean]
        ${PublicCdnEnabled},

        [Parameter()]
        [System.String]
        ${PublicCdnAllowedFileTypes},

        [Parameter()]
        [System.Uint32]
        ${RequireAnonymousLinksExpireInDays},

        [Parameter()]
        [System.String]
        ${SharingAllowedDomainList},

        [Parameter()]
        [System.String]
        ${SharingBlockedDomainList},

        [Parameter()]
        [System.String]
        ${SharingDomainRestrictionMode},

        [Parameter()]
        [long]
        ${OneDriveStorageQuota},

        [Parameter()]
        [System.boolean]
        ${OneDriveForGuestsEnabled},

        [Parameter()]
        [System.boolean]
        ${IPAddressEnforcement},

        [Parameter()]
        [System.String]
        ${IPAddressAllowList},

        [Parameter()]
        [System.Uint32]
        ${IPAddressWACTokenLifetime},

        [Parameter()]
        [System.boolean]
        ${UseFindPeopleInPeoplePicker},

        [Parameter()]
        [System.String]
        ${DefaultSharingLinkType},

        [Parameter()]
        [System.String]
        ${ODBMembersCanShare},

        [Parameter()]
        [System.String]
        ${ODBAccessRequests},

        [Parameter()]
        [System.boolean]
        ${PreventExternalUsersFromResharing},

        [Parameter()]
        [System.boolean]
        ${ShowPeoplePickerSuggestionsForGuestUsers},

        [Parameter()]
        [System.String]
        ${FileAnonymousLinkType},

        [Parameter()]
        [System.String]
        ${FolderAnonymousLinkType},

        [Parameter()]
        [System.boolean]
        ${NotifyOwnersWhenItemsReshared},

        [Parameter()]
        [System.boolean]
        ${NotifyOwnersWhenInvitationsAccepted},
        
        [Parameter()]
        [System.boolean]
        ${NotificationsInOneDriveForBusinessEnabled},

        [Parameter()]
        [System.boolean]
        ${NotificationsInSharePointEnabled},

        [Parameter()]
        [System.String]
        ${SpecialCharactersStateInFileFolderNames},
        
        [Parameter()]
        [System.boolean]
        ${OwnerAnonymousNotification},

        [Parameter()]
        [System.boolean]
        ${CommentsOnSitePagesDisabled},
        
        [Parameter()]
        [System.boolean]
        ${SocialBarOnSitePagesDisabled},

        [Parameter()]
        [System.Uint32]
        ${OrphanedPersonalSitesRetentionPeriod},

        [Parameter()]
        [System.boolean]
        ${PermissiveBrowserFileHandlingOverride},

        [Parameter()]
        [System.boolean]
        ${DisallowInfectedFileDownload},

        [Parameter()]
        [System.String]
        ${DefaultLinkPermission},

        [Parameter()]
        [System.String]
        ${ConditionalAccessPolicy},

        [Parameter()]
        [System.boolean]
        ${AllowDownloadingNonWebViewableFiles},

        [Parameter()]
        [System.String]
        ${LimitedAccessFileType},

        [Parameter()]
        [System.boolean]
        ${AllowEditing},

        [Parameter()]
        [System.boolean]
        ${ApplyAppEnforcedRestrictionsToAdHocRecipients},

        [Parameter()]
        [System.boolean]
        ${FilePickerExternalImageSearchEnabled},

        [Parameter()]
        [System.boolean]
        ${EmailAttestationRequired},

        [Parameter()]
        [System.Uint32]
        ${EmailAttestationReAuthDays},

        [Parameter()]
        [System.boolean]
        ${SyncPrivacyProfileProperties},

        [Parameter()]
        ${DisabledWebPartIds},

        [Parameter()]
        [System.String]
        ${OrgNewsSiteUrl},
        
        [Parameter()]
        [System.boolean]
        ${EnableMinimumVersionRequirement},

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )
    
    Test-SPOServiceConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount
    
    if($Ensure -eq "Present")
    {
        $CurrentParameters = $PSBoundParameters
        $CurrentParameters.Remove("CentralAdminUrl")
        $CurrentParameters.Remove("GlobalAdminAccount")
        $CurrentParameters.Remove("Tenant")
        $CurrentParameters.Remove("Ensure")
        $CurrentParameters.Remove("Verbose")

        Write-Verbose -Message "------------------------"
        Write-Verbose -Message "%%% Setting Tenant %%%"
        Write-Verbose -Message "------------------------"
        write-verbose "*****disableContentTypeSyncSiteTemplatesList is set to $disableContentTypeSyncSiteTemplatesList"
        if($disableContentTypeSyncSiteTemplatesList -eq "True" -and $ContentTypeSyncSiteTemplatesList -eq "MySites")
        {
            Write-Verbose -Message "[INFO] Disabling ContentTypeSyncSiteTemplatesList (which is currently set to:$ContentTypeSyncSiteTemplatesList) using the ExcludeSiteTemplate switch"
            Set-SPOTenant -ContentTypeSyncSiteTemplatesList "MySites" -ExcludeSiteTemplate -Verbose
            $CurrentParameters.Remove("ContentTypeSyncSiteTemplatesList")
        }
        $CurrentParameters.Remove("disableContentTypeSyncSiteTemplatesList")
        
        Write-Verbose -Message "[INFO] Setting SignInAccelerationDomain and EnableGuestSignInAcceleration"
        if(($null -like $SignInAccelerationDomain) -and ($EnableGuestSignInAcceleration -eq $false))
        {
            write-verbose -message "[INFO] It is not possible to set EnableGuestSignInAccerlation when the SignInAccerlationDomain is set to be empty"
            Set-SPOTenant -SignInAccelerationDomain "" 
            $CurrentParameters.remove("SignInAccelerationDomain")
            $CurrentParameters.remove("EnableGuestSignInAcceleration")
        }
        elseif(($null -like $SignInAccelerationDomain) -and ($EnableGuestSignInAcceleration -eq $true))
        {
            write-verbose -message "[INFO] It is not possible to set EnableGuestSignInAccerlation when the SignInAccerlationDomain is set to be empty"
            Set-SPOTenant -SignInAccelerationDomain "" 
            $CurrentParameters.remove("SignInAccelerationDomain")
            $CurrentParameters.remove("EnableGuestSignInAcceleration")
        }
        elseif($null -notlike $SignInAccelerationDomain)
        {
            Write-Verbose -Message "[INFO] Configuring SignInAccelerationDomain since EnableGuestSignInAcceleration is not null "
        }

        if(($null -notlike $PublicCdnAllowedFileTypes) -and ($PublicCdnEnabled -eq $false))
        {
            Write-Verbose -Message "[INFO] To configure PublicCdnAllowedFileTypes you have to have the PublicCDNEnabled"
            $CurrentParameters.Remove("PublicCdnAllowedFileTypes")
        }

        if($SharingCapability -ne "ExternalUserAndGuestSharing ")
        {
            Write-Verbose -Message "[INFO] The sharing capabilities for the tenant are not configured to be ExternalUserAndGuestSharing for that the RequireAnonymousLinksExpireInDays property cannot be configured"
            $CurrentParameters.Remove("RequireAnonymousLinksExpireInDays")
        }
        if($RequireAcceptingAccountMatchInvitedAccount -eq $false)
        {
            Write-Verbose -Message "[INFO] RequireAcceptingAccountMatchInvitedAccount is set to be false. For that SharingAllowedDomainList / SharingBlockedDomainList cannot be configured"
            $CurrentParameters.Remove("SharingAllowedDomainList")
            $CurrentParameters.Remove("SharingBlockedDomainList")
        }
        if($SharingDomainRestrictionMode -eq "None")
        {
            Write-Verbose -Message "[INFO] SharingDomainRestrictionMode is set to None. For that SharingAllowedDomainList / SharingBlockedDomainList cannot be configured"
            $CurrentParameters.Remove("SharingAllowedDomainList")
            $CurrentParameters.Remove("SharingBlockedDomainList")
        }
        elseif ($SharingDomainRestrictionMode -eq "AllowList")
        {
            Write-Verbose -Message "[INFO] SharingDomainRestrictionMode is set to AllowList. For that SharingBlockedDomainList cannot be configured"
            $CurrentParameters.Remove("SharingBlockedDomainList")
        }
        elseif($SharingDomainRestrictionMode -eq "BlockList")
        {
            Write-Verbose -Message "[INFO] SharingDomainRestrictionMode is set to BlockList. For that SharingAllowedDomainList cannot be configured"
            $CurrentParameters.Remove("SharingAllowedDomainList")
        }
        if($OneDriveStorageQuota -lt 1024)
        {
            Write-Verbose -Message "[INFO] OneDriveStorageQuota minimum value should be set to 1024MB, setting it to that value"
            $OneDriveStorageQuota = 1024
        }
        if($IPAddressEnforcement -eq $true)
        {
            if($null -like $IPAddressAllowList)
            {
                Write-Verbose -Message "[INFO] IPAddressAllowList is empty. Please configure it, when you would like to set the IPAddressEnforcement property"
                $CurrentParameters.Remove("IPAddressEnforcement")
            }
            else
            {
                Write-Verbose -Message "[INFO] Making sure IPADdressEnforcement is set to true before passing in the list of the allowed IP addresses"
                set-spotenant -IPAddressEnforcement $IPAddressEnforcement -IPAddressAllowList $IPAddressAllowList #setting the ipaddress enforcement parameter and the list of allowed IP addresses
            }
        }
        if($null -notlike $PermissiveBrowserFileHandlingOverride)
        {
            Write-Verbose -Message "[INFO] The permissive browser handling is deprecated and cannot be configured. Removing this parameter from the configuration"
            $CurrentParameters.Remove("PermissiveBrowserFileHandlingOverride")
        }
        if($null -notlike $DisabledWebPartIds)
        {
            $DisabledWebPartIdsGUID = @()
            $DisabledWebParts = $DisabledWebPartIds.split(",")
            
            foreach($DisabledWebPartId in $DisabledWebParts)
            {
                if($DisabledWebPartId -eq "00000000-0000-0000-0000-000000000000")
                {
                    Write-Verbose -Message "[INFO] Re-setting the DisabledWebpartIDs"
                    set-spotenant -DisabledWebPartIds @()
                    $CurrentParameters.Remove("DisabledWebPartIds")
                }
                else
                {
                    write-Verbose -Message "[INFO] Setting the DisabledWebpartIDs property for tenant for webpart: $DisabledWebPartId"
                    $DisabledWebPartIdsGUID += [GUID]$DisabledWebPartId
                }
            }
            Set-SPOTenant -DisabledWebPartIds $DisabledWebPartIdsGUID
            $DisabledWebPartIdsGUID = @()
            $CurrentParameters.Remove("DisabledWebPartIds")
        }
        foreach($value in $CurrentParameters.GetEnumerator())
        {
            write-verbose -Message "[INFO] Configuring Tenant with: $value"
        }
        $tenant = Set-SPOTenant @CurrentParameters
    }
}
function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param (

        [Parameter(Mandatory = $true)] 
        [validateSet("Present", "Absent")]
        [System.String] 
        ${Ensure},

        [Parameter(Mandatory = $true)]
        [System.String]
        ${Tenant},

        [Parameter()]
        [System.Uint32]
        ${MinCompatibilityLevel},
        
        [Parameter()]
        [System.Uint32]
        ${MaxCompatibilityLevel},

        [Parameter()]
        [System.boolean]
        ${ExternalServicesEnabled},

        [Parameter()]
        [System.String]
        ${NoAccessRedirectUrl},
        
        [Parameter()]
        [System.String]
        ${ContentTypeSyncSiteTemplatesList},

        [Parameter()]
        [System.Boolean]
        ${disableContentTypeSyncSiteTemplatesList},
        
        [Parameter()]
        [System.String]
        ${SharingCapability},

        [Parameter()]
        [System.boolean]
        ${DisplayStartASiteOption},

        [Parameter()]
        [System.String]
        ${StartASiteFormUrl},

        [Parameter()]
        [System.boolean]
        ${ShowEveryoneClaim},

        [Parameter()]
        [System.boolean]
        ${ShowAllUsersClaim},

        [Parameter()]
        [System.boolean]
        ${ShowEveryoneExceptExternalUsersClaim},

        [Parameter()]
        [System.boolean]
        ${SearchResolveExactEmailOrUPN},

        [Parameter()]
        [System.boolean]
        ${OfficeClientADALDisabled},

        [Parameter()]
        [System.boolean]
        ${LegacyAuthProtocolsEnabled},
        
        [Parameter()]
        [System.boolean]
        ${RequireAcceptingAccountMatchInvitedAccount},

        [Parameter()]
        [System.boolean]
        ${ProvisionSharedWithEveryoneFolder},

        [Parameter()]
        [System.String]
        ${SignInAccelerationDomain},

        [Parameter()]
        [System.boolean]
        ${EnableGuestSignInAcceleration},

        [Parameter()]
        [System.boolean]
        ${UsePersistentCookiesForExplorerView},

        [Parameter()]
        [System.boolean]
        ${BccExternalSharingInvitations},

        [Parameter()]
        [System.String]
        ${BccExternalSharingInvitationsList},

        [Parameter()]
        [System.boolean]
        ${UserVoiceForFeedbackEnabled},

        [System.boolean]
        ${PublicCdnEnabled},

        [Parameter()]
        [System.String]
        ${PublicCdnAllowedFileTypes},

        [Parameter()]
        [System.Uint32]
        ${RequireAnonymousLinksExpireInDays},

        [Parameter()]
        [System.String]
        ${SharingAllowedDomainList},

        [Parameter()]
        [System.String]
        ${SharingBlockedDomainList},

        [Parameter()]
        [System.String]
        ${SharingDomainRestrictionMode},

        [Parameter()]
        [long]
        ${OneDriveStorageQuota},

        [Parameter()]
        [System.boolean]
        ${OneDriveForGuestsEnabled},

        [Parameter()]
        [System.boolean]
        ${IPAddressEnforcement},

        [Parameter()]
        [System.String]
        ${IPAddressAllowList},

        [Parameter()]
        [System.Uint32]
        ${IPAddressWACTokenLifetime},

        [Parameter()]
        [System.boolean]
        ${UseFindPeopleInPeoplePicker},

        [Parameter()]
        [System.String]
        ${DefaultSharingLinkType},

        [Parameter()]
        [System.String]
        ${ODBMembersCanShare},

        [Parameter()]
        [System.String]
        ${ODBAccessRequests},

        [Parameter()]
        [System.boolean]
        ${PreventExternalUsersFromResharing},

        [Parameter()]
        [System.boolean]
        ${ShowPeoplePickerSuggestionsForGuestUsers},

        [Parameter()]
        [System.String]
        ${FileAnonymousLinkType},

        [Parameter()]
        [System.String]
        ${FolderAnonymousLinkType},

        [Parameter()]
        [System.boolean]
        ${NotifyOwnersWhenItemsReshared},

        [Parameter()]
        [System.boolean]
        ${NotifyOwnersWhenInvitationsAccepted},
        
        [Parameter()]
        [System.boolean]
        ${NotificationsInOneDriveForBusinessEnabled},

        [Parameter()]
        [System.boolean]
        ${NotificationsInSharePointEnabled},

        [Parameter()]
        [System.String]
        ${SpecialCharactersStateInFileFolderNames},
        
        [Parameter()]
        [System.boolean]
        ${OwnerAnonymousNotification},

        [Parameter()]
        [System.boolean]
        ${CommentsOnSitePagesDisabled},
        
        [Parameter()]
        [System.boolean]
        ${SocialBarOnSitePagesDisabled},

        [Parameter()]
        [System.Uint32]
        ${OrphanedPersonalSitesRetentionPeriod},

        [Parameter()]
        [System.boolean]
        ${PermissiveBrowserFileHandlingOverride},

        [Parameter()]
        [System.boolean]
        ${DisallowInfectedFileDownload},

        [Parameter()]
        [System.String]
        ${DefaultLinkPermission},

        [Parameter()]
        [System.String]
        ${ConditionalAccessPolicy},

        [Parameter()]
        [System.boolean]
        ${AllowDownloadingNonWebViewableFiles},

        [Parameter()]
        [System.String]
        ${LimitedAccessFileType},

        [Parameter()]
        [System.boolean]
        ${AllowEditing},

        [Parameter()]
        [System.boolean]
        ${ApplyAppEnforcedRestrictionsToAdHocRecipients},

        [Parameter()]
        [System.boolean]
        ${FilePickerExternalImageSearchEnabled},

        [Parameter()]
        [System.boolean]
        ${EmailAttestationRequired},

        [Parameter()]
        [System.Uint32]
        ${EmailAttestationReAuthDays},

        [Parameter()]
        [System.boolean]
        ${SyncPrivacyProfileProperties},

        [Parameter()]
        ${DisabledWebPartIds},

        [Parameter()]
        [System.String]
        ${OrgNewsSiteUrl},
        
        [Parameter()]
        [System.boolean]
        ${EnableMinimumVersionRequirement},

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )
    Test-SPOServiceConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount
    Write-Verbose -Message "Testing SPO Tenant"
    $CurrentValues = Get-TargetResource @PSBoundParameters
    return Test-Office365DSCParameterState -CurrentValues $CurrentValues `
                                      -DesiredValues $PSBoundParameters `
                                           -ValuesToCheck @("Ensure", `
                                                            "MinCompatibilityLevel", `
                                                            "MaxCompatibilityLevel", `
                                                            "ExternalServicesEnabled", `
                                                            "NoAccessRedirectUrl", `
                                                            "SharingCapability", `
                                                            "DisplayStartASiteOption", `
                                                            "StartASiteFormUrl", `
                                                            "ShowEveryoneClaim", `
                                                            "ShowAllUsersClaim", `
                                                            "ShowEveryoneExceptExternalUsersClaim", `
                                                            "SearchResolveExactEmailOrUPN", `
                                                            "OfficeClientADALDisabled", `
                                                            "LegacyAuthProtocolsEnabled", `
                                                            "RequireAcceptingAccountMatchInvitedAccount", `
                                                            "ProvisionSharedWithEveryoneFolder", `
                                                            "SignInAccelerationDomain", `
                                                            "EnableGuestSignInAcceleration", `
                                                            "UsePersistentCookiesForExplorerView", `
                                                            "ContentTypeSyncSiteTemplatesList", `
                                                            "ExcludeSiteTemplate", `
                                                            "BccExternalSharingInvitations", `
                                                            "BccExternalSharingInvitationsList", `
                                                            "UserVoiceForFeedbackEnabled", `
                                                            "PublicCdnEnabled", `
                                                            "PublicCdnAllowedFileTypes", `
                                                            "RequireAnonymousLinksExpireInDays", `
                                                            "SharingAllowedDomainList", `
                                                            "SharingBlockedDomainList", `
                                                            "SharingDomainRestrictionMode", `
                                                            "OneDriveStorageQuota", `
                                                            "OneDriveForGuestsEnabled", `
                                                            "IPAddressEnforcement", `
                                                            "IPAddressAllowList", `
                                                            "IPAddressWACTokenLifetime", `
                                                            "UseFindPeopleInPeoplePicker", `
                                                            "DefaultSharingLinkType", `
                                                            "ODBMembersCanShare", `
                                                            "ODBAccessRequests", `
                                                            "PreventExternalUsersFromResharing", `
                                                            "ShowPeoplePickerSuggestionsForGuestUsers", `
                                                            "FileAnonymousLinkType", `
                                                            "FolderAnonymousLinkType", `
                                                            "NotifyOwnersWhenItemsReshared", `
                                                            "NotifyOwnersWhenInvitationsAccepted", `
                                                            "NotificationsInOneDriveForBusinessEnabled", `
                                                            "NotificationsInSharePointEnabled", `
                                                            "SpecialCharactersStateInFileFolderNames", `
                                                            "OwnerAnonymousNotification", `
                                                            "CommentsOnSitePagesDisabled", `
                                                            "CommentsOnFilesDisabled", `
                                                            "SocialBarOnSitePagesDisabled", `
                                                            "OrphanedPersonalSitesRetentionPeriod", `
                                                            "PermissiveBrowserFileHandlingOverride", `
                                                            "DisallowInfectedFileDownload", `
                                                            "DefaultLinkPermission", `
                                                            "CustomizedExternalSharingServiceUrl", `
                                                            "ConditionalAccessPolicy", `
                                                            "AllowDownloadingNonWebViewableFiles", `
                                                            "LimitedAccessFileType", `
                                                            "AllowEditing", `
                                                            "ApplyAppEnforcedRestrictionsToAdHocRecipients", `
                                                            "FilePickerExternalImageSearchEnabled", `
                                                            "EmailAttestationRequired", `
                                                            "EmailAttestationReAuthDays", `
                                                            "SyncPrivacyProfileProperties", `
                                                            "DisabledWebPartIds", `
                                                            "OrgNewsSiteUrl", `
                                                            "EnableMinimumVersionRequirement", `
                                                            "MarkNewFilesSensitiveByDefault", `
                                                            "disableContentTypeSyncSiteTemplatesList"
                                                            )
}
Export-ModuleMember -Function *-TargetResource
