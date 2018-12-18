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
        
        return $spoTenant
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
    
    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("CentralAdminUrl")
    $CurrentParameters.Remove("GlobalAdminAccount")
    $CurrentParameters.Remove("Tenant")
    $CurrentParameters.Remove("Ensure")
    $CurrentParameters.Remove("Verbose")

    Write-Verbose -Message "------------------------"
    Write-Verbose -Message "%%% Setting Tenant %%%"
    Write-Verbose -Message "------------------------"

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
        Write-Verbose -Message "[INFO]  configuring as is"
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
function Test-TargetResource
{
    [CmdletBinding()]
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
    Write-Verbose -Message "---------------------------"
    Write-Verbose -Message "%%% Testing SPOTenant %%%"
    Write-Verbose -Message "---------------------------"
    $CurrentValues = Get-TargetResource @PSBoundParameters
    out-file -FilePath C:\Users\thloesch\Desktop\output.txt -InputObject $CurrentValues
    $returnedTrue = @()
    $returnedFalse = @()
    if($Ensure -eq "Present")
    {
        #testing the compatibility range settings
        $compatibilityRange = $CurrentValues.CompatibilityRange
        $paramMinCompLevel = $compatibilityRange.split(",")[0]
        $paramMaxCompLevel = $CompatibilityRange.split(",")[1]
        
        Write-Verbose -Message "[INFO] MinCompatibilityLevel currently is: $paramMinCompLevel should be: $MinCompatibilityLevel"
        if($MinCompatibilityLevel -eq $paramMinCompLevel)
        {
            $returnedTrue = $returnedTrue + $MinCompatibilityLevel
        }
        else
        {
            $MinCompatibilityLevel = $paramMinCompLevel
            $returnedFalse = $returnedFalse + $MinCompatibilityLevel
        }
        
        Write-Verbose -Message "[INFO] MaxCompatibilityLevel currently is: $paramMaxCompLevel should be: $MaxCompatibilityLevel"
        if($MaxCompatibilityLevel -eq $paramMaxCompLevel)
        {
            $returnedTrue = $returnedTrue + $MaxCompatibilityLevel
        }
        else
        {
            $MaxCompatibilityLevel = $paramMaxCompLevel
            $returnedFalse = $returnedFalse + $MinCompatibilityLevel
        }
        #testing for ExternalServicesEnabled (services outside of the O365 datacenters)
        $paramExtServiceEnabled = $CurrentValues.ExternalServicesEnabled
        Write-Verbose -Message "[INFO] ExternalServicesEnabled currently is: $paramExtServiceEnabled should be: $ExternalServicesEnabled"
        if($ExternalServicesEnabled -eq $paramExtServiceEnabled)
        {
            $returnedTrue = $returnedTrue + $ExternalServicesEnabled
        }
        else
        {
            $ExternalServicesEnabled = $paramExtServiceEnabled
            $returnedFalse = $returnedFalse + $ExternalServicesEnabled
        }
        #testing for NoAccessRedirectUrl (URL of the redirected site for those site collections which have the locked state NoAccess)
        $paramNoAccessRedUrl = $CurrentValues.NoAccessRedirectUrl
        Write-Verbose -Message "[INFO] NoAccessRedirectUrl currently is: $paramNoAccessRedUrl should be: $NoAccessRedirectUrl"
        if($NoAccessRedirectUrl -eq $paramNoAccessRedUrl)
        {
            $returnedTrue = $returnedTrue + $paramNoAccessRedUrl
        }
        else
        {
            $NoAccessRedirectUrl = $paramNoAccessRedUrl
            $returnedFalse = $returnedFalse + $NoAccessRedirectUrl
        }
        #testing for ContentTypeSyncSiteTemplatesList (By default Content Type Hub will no longer push content types to OneDrive for Business sites (formerly known as MySites")
        $paramCTSyncSiteTemplateList = $CurrentValues.ContentTypeSyncSiteTemplatesList
        write-verbose -Message "[INFO] ContentTypeSyncSiteTemplatesList currently is $paramCTSyncSiteTemplateList should be $ContentTypeSyncSiteTemplatesList"
        if($ContentTypeSyncSiteTemplatesList -eq $paramCTSyncSiteTemplateList)
        {
            $returnedTrue = $returnedTrue + $paramCTSyncSiteTemplateList
        }
        else
        {
            $ContentTypeSyncSiteTemplatesList = $paramCTSyncSiteTemplateList
            $returnedFalse = $returnedFalse + $ContentTypeSyncSiteTemplatesList
        }
        #testing  for DisplayStartASiteOption ("Determines whether tenant users see the Start a Site menu option")
        $paramDispStartASiteOption = $CurrentValues.DisplayStartASiteOption
        write-verbose -Message "[INFO] DisplayStartASiteOption currently is $paramDispStartASiteOption should be $DisplayStartASiteOption"
        if($DisplayStartASiteOption -eq $paramDispStartASiteOption)
        {
            $returnedTrue = $returnedTrue + $paramDispStartASiteOption
        }
        else
        {
            $DisplayStartASiteOption = $paramDispStartASiteOption
            $returnedFalse = $returnedFalse + $DisplayStartASiteOption
        }
        #Testing for StartASiteFormUrl (Specifies URL of the form to load in the Start a Site dialog).
        $paramStartASiteFormURL = $CurrentValues.StartASiteFormUrl
        write-verbose -Message "[INFO] StartASiteFormUrl currently is $paramStartASiteFormURL should be $StartASiteFormUrl"
        if($StartASiteFormUrl -eq $paramStartASiteFormURL)
        {
            $returnedTrue = $returnedTrue + $paramStartASiteFormURL
        }
        else
        {
            $StartASiteFormUrl = $paramStartASiteFormURL
            $returnedFalse = $returnedFalse + $StartASiteFormUrl
        }
        #Testing for ShowEveryoneClaim  (Enables the administrator to hide the Everyone claim in the People Picker.)
        $paramShowEveryoneClaim = $CurrentValues.ShowEveryoneClaim
        write-verbose -Message "[INFO] ShowEveryoneClaim currently is $paramShowEveryoneClaim should be $ShowEveryoneClaim"
        if($ShowEveryoneClaim -eq $paramShowEveryoneClaim)
        {
            $returnedTrue = $returnedTrue + $paramShowEveryoneClaim
        }
        else
        {
            $ShowEveryoneClaim = $paramShowEveryoneClaim
            $returnedFalse = $returnedFalse + $ShowEveryoneClaim
        }
        #Testing for ShowAllUsersClaim (Enables the administrator to hide the All Users claim groups in People Picker)
        $paramShowAllUsersClaim = $CurrentValues.ShowAllUsersClaim
        write-verbose -Message "[INFO] ShowAllUsersClaim currently is $paramShowAllUsersClaim should be $ShowAllUsersClaim"
        if($ShowAllUsersClaim -eq $paramShowAllUsersClaim)
        {
            $returnedTrue = $returnedTrue + $paramShowAllUsersClaim
        }
        else
        {
            $ShowAllUsersClaim = $paramShowAllUsersClaim
            $returnedFalse = $returnedFalse + $ShowAllUsersClaim
        }
        #Testing for ShowEveryoneExceptExternalUsersClaim (Enables the administrator to hide the Everyone except external users claim in the People Picker)
        $paramShowEveryoneExceptExternalUsersClaim = $CurrentValues.ShowEveryoneExceptExternalUsersClaim
        write-verbose -Message "[INFO] ShowEveryoneExceptExternalUsersClaim currently is $paramShowEveryoneExceptExternalUsersClaim should be $ShowEveryoneExceptExternalUsersClaim"
        if($ShowEveryoneExceptExternalUsersClaim -eq $paramShowparamShowEveryoneExceptExternalUsersClaimAllUsersClaim)
        {
            $returnedTrue = $returnedTrue + $paramShowEveryoneExceptExternalUsersClaim
        }
        else
        {
            $ShowEveryoneExceptExternalUsersClaim = $paramShowEveryoneExceptExternalUsersClaim
            $returnedFalse = $returnedFalse + $ShowEveryoneExceptExternalUsersClaim
        }
        #Testing for SearchResolveExactEmailOrUPN (Removes the search capability from People Picker.)
        $paramSearchResolveExactEmailOrUPN = $CurrentValues.SearchResolveExactEmailOrUPN
        write-verbose -Message "[INFO] SearchResolveExactEmailOrUPN currently is $paramSearchResolveExactEmailOrUPN should be $SearchResolveExactEmailOrUPN"
        if($SearchResolveExactEmailOrUPN -eq $paramSearchResolveExactEmailOrUPN)
        {
            $returnedTrue = $returnedTrue + $paramSearchResolveExactEmailOrUPN
        }
        else
        {
            $SearchResolveExactEmailOrUPN = $paramSearchResolveExactEmailOrUPN
            $returnedFalse = $returnedFalse + $SearchResolveExactEmailOrUPN
        }
        #Testing for OfficeClientADALDisabled (When set to true this will disable the ability to use Modern Authentication that leverages ADAL across the tenant)
        $paramOfficeClientADALDisabled = $CurrentValues.OfficeClientADALDisabled
        write-verbose -Message "[INFO] OfficeClientADALDisabled currently is $paramOfficeClientADALDisabled should be $OfficeClientADALDisabled"
        if($OfficeClientADALDisabled -eq $paramOfficeClientADALDisabled)
        {
            $returnedTrue = $returnedTrue + $paramOfficeClientADALDisabled
        }
        else
        {
            $OfficeClientADALDisabled = $paramOfficeClientADALDisabled
            $returnedFalse = $returnedFalse + $OfficeClientADALDisabled
        }
        #Testing for LegacyAuthProtocolsEnabled (By default this value is set to True, which means that authentication using legacy protocols is enabled.)
        $paramLegacyAuthProtocolsEnabled = $CurrentValues.LegacyAuthProtocolsEnabled
        write-verbose -Message "[INFO] LegacyAuthProtocolsEnabled currently is $paramLegacyAuthProtocolsEnabled should be $LegacyAuthProtocolsEnabled"
        if($LegacyAuthProtocolsEnabled -eq $paramLegacyAuthProtocolsEnabled)
        {
            $returnedTrue = $returnedTrue + $paramLegacyAuthProtocolsEnabled
        }
        else
        {
            $LegacyAuthProtocolsEnabled = $paramLegacyAuthProtocolsEnabled
            $returnedFalse = $returnedFalse + $LegacyAuthProtocolsEnabled
        }
        #Testing RequireAcceptingAccountMatchInvitedAccount (Ensures that an external user can only accept an external sharing invitation with an account matching the invited email address)
        $paramRequireAcceptingAccountMatchInvitedAccount = $CurrentValues.RequireAcceptingAccountMatchInvitedAccount
        write-verbose -Message "[INFO] RequireAcceptingAccountMatchInvitedAccount currently is $paramRequireAcceptingAccountMatchInvitedAccount should be $RequireAcceptingAccountMatchInvitedAccount"
        if($RequireAcceptingAccountMatchInvitedAccount -eq $paramRequireAcceptingAccountMatchInvitedAccount)
        {
            $returnedTrue = $returnedTrue + $paramRequireAcceptingAccountMatchInvitedAccount
        }
        else
        {
            $RequireAcceptingAccountMatchInvitedAccount = $paramRequireAcceptingAccountMatchInvitedAccount
            $returnedFalse = $returnedFalse + $RequireAcceptingAccountMatchInvitedAccount
        }
        #Testing ProvisionSharedWithEveryoneFolder (Creates a Shared with Everyone folder in every user's new OneDrive for Business document library.)
        $paramProvisionSharedWithEveryoneFolder = $CurrentValues.ProvisionSharedWithEveryoneFolder
        write-verbose -Message "[INFO] ProvisionSharedWithEveryoneFolder currently is $paramProvisionSharedWithEveryoneFoldershould should be $ProvisionSharedWithEveryoneFolder"
        if($ProvisionSharedWithEveryoneFolder -eq $paramProvisionSharedWithEveryoneFolder)
        {
            $returnedTrue = $returnedTrue + $paramProvisionSharedWithEveryoneFolder
        }
        else
        {
            $ProvisionSharedWithEveryoneFolder = $paramProvisionSharedWithEveryoneFolder
            $returnedFalse = $returnedFalse + $ProvisionSharedWithEveryoneFolder
        }
        #Testing SignInAccelerationDomain (Specifies the home realm discovery value to be sent to Azure Active Directory (AAD) during the user sign-in process.)
        $paramSignInAccelerationDomain = $CurrentValues.SignInAccelerationDomain
        write-verbose -Message "[INFO] SignInAccelerationDomain currently is $paramSignInAccelerationDomain should be $SignInAccelerationDomain"
        if($SignInAccelerationDomain -eq $paramSignInAccelerationDomain)
        {
            $returnedTrue = $returnedTrue + $paramSignInAccelerationDomain
        }
        else
        {
            $SignInAccelerationDomain = $paramSignInAccelerationDomain
            $returnedFalse = $returnedFalse + $SignInAccelerationDomain
        }
        #Testing EnableGuestSignInAcceleration (Accelerates guest-enabled site collections as well as member-only site collections when the SignInAccelerationDomain parameter is set.)
        $paramEnableGuestSignInAcceleration = $CurrentValues.EnableGuestSignInAcceleration
        write-verbose -Message "[INFO] EnableGuestSignInAcceleration currently is $paramEnableGuestSignInAcceleration should be $EnableGuestSignInAcceleration"
        if($EnableGuestSignInAcceleration -eq $paramEnableGuestSignInAcceleration)
        {
            $returnedTrue = $returnedTrue + $paramEnableGuestSignInAcceleration
        }
        else
        {
            $EnableGuestSignInAcceleration = $paramEnableGuestSignInAcceleration
            $returnedFalse = $returnedFalse + $EnableGuestSignInAcceleration
        }
        #Testing UsePersistentCookiesForExplorerView (Lets SharePoint issue a special cookie that will allow this feature to work even when Keep Me Signed In is not selected.)
        $paramUsePersistentCookiesForExplorerView = $CurrentValues.UsePersistentCookiesForExplorerView
        write-verbose -Message "[INFO] UsePersistentCookiesForExplorerView currently is $paramUsePersistentCookiesForExplorerView should be $UsePersistentCookiesForExplorerView"
        if($UsePersistentCookiesForExplorerView -eq $paramUsePersistentCookiesForExplorerView)
        {
            $returnedTrue = $returnedTrue + $paramUsePersistentCookiesForExplorerView
        }
        else
        {
            $UsePersistentCookiesForExplorerView = $paramUsePersistentCookiesForExplorerView
            $returnedFalse = $returnedFalse + $UsePersistentCookiesForExplorerView
        }
        #Testing BccExternalSharingInvitationsList (Specifies a list of e-mail addresses to be BCC'd when the BCC for External Sharing feature is enabled.Multiple addresses can be specified by creating a comma separated list with no spaces.)
        $paramBccExternalSharingInvitationsList = $CurrentValues.BccExternalSharingInvitationsList
        write-verbose -Message "[INFO] BccExternalSharingInvitationsList currently is $paramBccExternalSharingInvitationsList should be $BccExternalSharingInvitationsList"
        if($BccExternalSharingInvitationsList -eq $paramBccExternalSharingInvitationsList)
        {
            $returnedTrue = $returnedTrue + $paramBccExternalSharingInvitationsList
        }
        else
        {
            $BccExternalSharingInvitationsList = $paramBccExternalSharingInvitationsList
            $returnedFalse = $returnedFalse + $BccExternalSharingInvitationsList
        }
        #Testing UserVoiceForFeedbackEnabled (When set to $true, the Feedback link will be shown at the bottom of all modern SharePoint Online pages.)
        $paramUserVoiceForFeedbackEnabled = $CurrentValues.UserVoiceForFeedbackEnabled
        write-verbose -Message "[INFO] UserVoiceForFeedbackEnabled currently is $paramUserVoiceForFeedbackEnabled should be $UserVoiceForFeedbackEnabled"
        if($UserVoiceForFeedbackEnabled -eq $paramUserVoiceForFeedbackEnabled)
        {
            $returnedTrue = $returnedTrue + $paramUserVoiceForFeedbackEnabled
        }
        else
        {
            $UserVoiceForFeedbackEnabled = $paramUserVoiceForFeedbackEnabled
            $returnedFalse = $returnedFalse + $UserVoiceForFeedbackEnabled
        }
        #Testing PublicCdnEnabled (Enabling or disabling public CDN)
        $paramPublicCdnEnabled = $CurrentValues.PublicCdnEnabled
        write-verbose -Message "[INFO] PublicCdnEnabled currently is $paramPublicCdnEnabled should be $PublicCdnEnabled"
        if($PublicCdnEnabled -eq $paramPublicCdnEnabled)
        {
            $returnedTrue = $returnedTrue + $paramPublicCdnEnabled
        }
        else
        {
            $PublicCdnEnabled = $paramPublicCdnEnabled
            $returnedFalse = $returnedFalse + $PublicCdnEnabled
        }
        #Testing PublicCdnAllowedFileTypes (Allowed file types for public CDNs)
        $paramPublicCdnAllowedFileTypes = $CurrentValues.PublicCdnAllowedFileTypes
        write-verbose -Message "[INFO] PublicCdnAllowedFileTypes currently is $paramPublicCdnAllowedFileTypes should be $PublicCdnAllowedFileTypes"
        if($PublicCdnAllowedFileTypes -eq $paramPublicCdnAllowedFileTypes)
        {
            $returnedTrue = $returnedTrue + $paramPublicCdnAllowedFileTypes
        }
        else
        {
            $PublicCdnAllowedFileTypes = $paramPublicCdnAllowedFileTypes
            $returnedFalse = $returnedFalse + $PublicCdnAllowedFileTypes
        }
        #Testing RequireAnonymousLinksExpireInDays (Specifies all anonymous links that have been created (or will be created) will expire after the set number of days)
        $paramRequireAnonymousLinksExpireInDays = $CurrentValues.RequireAnonymousLinksExpireInDays
        write-verbose -Message "[INFO] RequireAnonymousLinksExpireInDays currently is $paramRequireAnonymousLinksExpireInDays should be $RequireAnonymousLinksExpireInDays"
        if($RequireAnonymousLinksExpireInDays -eq $paramRequireAnonymousLinksExpireInDays)
        {
            $returnedTrue = $returnedTrue + $paramRequireAnonymousLinksExpireInDays
        }
        else
        {
            if($paramRequireAnonymousLinksExpireInDays -eq -1)
            {
                Write-Verbose -Message "[INFO] Initial value of the RequireAnonymousLinksExpireInDays property is set to be -1, setting it to 0 instead"
                $RequireAnonymousLinksExpireInDays = 0
                $returnedFalse = $returnedFalse + $RequireAnonymousLinksExpireInDays
            }
            else
            {
                $RequireAnonymousLinksExpireInDays = $paramRequireAnonymousLinksExpireInDays
                $returnedFalse = $returnedFalse + $RequireAnonymousLinksExpireInDays
            }

        }
        #Testing SharingAllowedDomainList (Specifies a list of email domains that is allowed for sharing with the external collaborators)
        $paramSharingAllowedDomainList = $CurrentValues.SharingAllowedDomainList
        write-verbose -Message "[INFO] SharingAllowedDomainList currently is $paramSharingAllowedDomainList should be $SharingAllowedDomainList"
        if($SharingAllowedDomainList -eq $paramSharingAllowedDomainList)
        {
            $returnedTrue = $returnedTrue + $paramSharingAllowedDomainList
        }
        else
        {
            $SharingAllowedDomainList = $paramSharingAllowedDomainList
            $returnedFalse = $returnedFalse + $SharingAllowedDomainList
        }
        #Testing SharingDomainRestrictionMode (Specifies the external sharing mode for domains.)
        $paramSharingDomainRestrictionMode = $CurrentValues.SharingDomainRestrictionMode
        write-verbose -Message "[INFO] SharingDomainRestrictionMode currently is $paramSharingDomainRestrictionMode should be $SharingDomainRestrictionMode"
        if($SharingDomainRestrictionMode -eq $paramSharingDomainRestrictionMode)
        {
            $returnedTrue = $returnedTrue + $paramSharingDomainRestrictionMode
        }
        else
        {
            $SharingDomainRestrictionMode = $paramSharingDomainRestrictionMode
            $returnedFalse = $returnedFalse + $SharingDomainRestrictionMode
        }
        #Testing SharingBlockedDomainList (Specifies a list of email domains that is blocked or prohibited for sharing with the external collaborators)
        $paramSharingBlockedDomainList = $CurrentValues.SharingBlockedDomainList
        write-verbose -Message "[INFO] SharingBlockedDomainList currently is $paramSharingBlockedDomainList should be $SharingBlockedDomainList"
        if($SharingBlockedDomainList -eq $paramSharingBlockedDomainList)
        {
            $returnedTrue = $returnedTrue + $paramSharingBlockedDomainList
        }
        else
        {
            $SharingBlockedDomainList = $paramSharingBlockedDomainList
            $returnedFalse = $returnedFalse + $SharingBlockedDomainList
        }
        #Testing OneDriveStorageQuota (Sets a default OneDrive for Business storage quota for the tenant.)
        $paramOneDriveStorageQuota = $CurrentValues.OneDriveStorageQuota
        write-verbose -Message "[INFO] OneDriveStorageQuota currently is $paramOneDriveStorageQuota should be $OneDriveStorageQuota"
        if($OneDriveStorageQuota -eq $paramOneDriveStorageQuota)
        {
            $returnedTrue = $returnedTrue + $paramOneDriveStorageQuota
        }
        else
        {
            $OneDriveStorageQuota = $paramOneDriveStorageQuota
            $returnedFalse = $returnedFalse + $OneDriveStorageQuota
        }
        #Testing OneDriveForGuestsEnabled (Lets OneDrive for Business creation for administrator managed guest users.)
        $paramOneDriveForGuestsEnabled = $CurrentValues.OneDriveForGuestsEnabled
        write-verbose -Message "[INFO] OneDriveForGuestsEnabled currently is $paramOneDriveForGuestsEnabled should be $OneDriveForGuestsEnabled"
        if($OneDriveForGuestsEnabled -eq $paramOneDriveForGuestsEnabled)
        {
            $returnedTrue = $returnedTrue + $paramOneDriveForGuestsEnabled
        }
        else
        {
            $OneDriveForGuestsEnabled = $paramOneDriveForGuestsEnabled
            $returnedFalse = $returnedFalse + $OneDriveForGuestsEnabled
        }
        #Testing IPAddressEnforcement (Allows access from network locations that are defined by an administrator.)
        $paramIPAddressEnforcement = $CurrentValues.IPAddressEnforcement
        write-verbose -Message "[INFO] IPAddressEnforcement currently is $paramIPAddressEnforcement should be $IPAddressEnforcement"
        if($IPAddressEnforcement -eq $paramIPAddressEnforcement)
        {
            $returnedTrue = $returnedTrue + $paramIPAddressEnforcement
        }
        else
        {
            $IPAddressEnforcement = $paramIPAddressEnforcement
            $returnedFalse = $returnedFalse + $IPAddressEnforcement
        }
        #Testinig IPAddressAllowList (Configures multiple IP addresses or IP address ranges (IPv4 or IPv6).)
        $paramIPAddressAllowList = $CurrentValues.IPAddressAllowList
        write-verbose -Message "[INFO] IPAddressAllowList currently is $paramIPAddressAllowList should be $IPAddressAllowList"
        if($IPAddressAllowList -eq $paramIPAddressAllowList)
        {
            $returnedTrue = $returnedTrue + $paramIPAddressAllowList
        }
        else
        {
            $IPAddressAllowList = $paramIPAddressAllowList
            $returnedFalse = $returnedFalse + $IPAddressAllowList
        }
        #Testing IPAddressWACTokenLifetime (Office webapps TokenLifeTime in minutes.)
        $paramIPAddressWACTokenLifetime = $CurrentValues.IPAddressWACTokenLifetime
        write-verbose -Message "[INFO] IPAddressWACTokenLifetime currently is $paramIPAddressWACTokenLifetime should be $IPAddressWACTokenLifetime"
        if($IPAddressWACTokenLifetime -eq $paramIPAddressWACTokenLifetime)
        {
            $returnedTrue = $returnedTrue + $paramIPAddressWACTokenLifetime
        }
        else
        {
            $IPAddressWACTokenLifetime = $paramIPAddressWACTokenLifetime
            $returnedFalse = $returnedFalse + $IPAddressWACTokenLifetime
        }
        #Testing UseFindPeopleInPeoplePicker (When set to $true, users aren't able to share with security groups or SharePoint groups.)
        $paramUseFindPeopleInPeoplePicker = $CurrentValues.UseFindPeopleInPeoplePicker
        write-verbose -Message "[INFO] UseFindPeopleInPeoplePicker currently is $paramUseFindPeopleInPeoplePicker should be $UseFindPeopleInPeoplePicker"
        if($UseFindPeopleInPeoplePicker -eq $paramUseFindPeopleInPeoplePicker)
        {
            $returnedTrue = $returnedTrue + $paramUseFindPeopleInPeoplePicker
        }
        else
        {
            $UseFindPeopleInPeoplePicker = $paramUseFindPeopleInPeoplePicker
            $returnedFalse = $returnedFalse + $UseFindPeopleInPeoplePicker
        }
        #Testing DefaultSharingLinkType (Lets administrators choose what type of link appears is selected in the “Get a link” sharing dialog box in OneDrive for Business and SharePoint Online.)
        $paramDefaultSharingLinkType = $CurrentValues.DefaultSharingLinkType
        write-verbose -Message "[INFO] DefaultSharingLinkType currently is $paramDefaultSharingLinkType should be $DefaultSharingLinkType"
        if($DefaultSharingLinkType -eq $paramDefaultSharingLinkType)
        {
            $returnedTrue = $returnedTrue + $paramDefaultSharingLinkType
        }
        else
        {
            $DefaultSharingLinkType = $paramDefaultSharingLinkType
            $returnedFalse = $returnedFalse + $DefaultSharingLinkType
        }
        #Testing ODBMembersCanShare (Lets administrators set policy on re-sharing behavior in OneDrive for Business.)
        $paramODBMembersCanShare = $CurrentValues.ODBMembersCanShare
        write-verbose -Message "[INFO] ODBMembersCanShare currently is $paramODBMembersCanShare should be $ODBMembersCanShare"
        if($ODBMembersCanShare -eq $paramODBMembersCanShare)
        {
            $returnedTrue = $returnedTrue + $paramODBMembersCanShare
        }
        else
        {
            $ODBMembersCanShare = $paramODBMembersCanShare
            $returnedFalse = $returnedFalse + $ODBMembersCanShare
        }
        #Testing ODBAccessRequests (Lets administrators set policy on access requests and requests to share in OneDrive for Business.)
        $paramODBAccessRequests = $CurrentValues.ODBAccessRequests
        write-verbose -Message "[INFO] ODBAccessRequests currently is $paramODBAccessRequests should be $ODBAccessRequests"
        if($ODBAccessRequests -eq $paramODBAccessRequests)
        {
            $returnedTrue = $returnedTrue + $paramODBAccessRequests
        }
        else
        {
            $ODBAccessRequests = $paramODBAccessRequests
            $returnedFalse = $returnedFalse + $ODBAccessRequests
        }
        #Testing PreventExternalUsersFromResharing (Allow or deny external users re-sharing.)
        $paramPreventExternalUsersFromResharing = $CurrentValues.PreventExternalUsersFromResharing
        write-verbose -Message "[INFO] PreventExternalUsersFromResharing currently is $paramPreventExternalUsersFromResharing should be $PreventExternalUsersFromResharing"
        if($PreventExternalUsersFromResharing -eq $paramPreventExternalUsersFromResharing)
        {
            $returnedTrue = $returnedTrue + $PreventExternalUsersFromResharing
        }
        else
        {
            $PreventExternalUsersFromResharing = $paramPreventExternalUsersFromResharing
            $returnedFalse = $returnedFalse + $PreventExternalUsersFromResharing
        }
        #Testing ShowPeoplePickerSuggestionsForGuestUsers (Enables the administrator to hide the guest users claim in the People Picker.)
        $paramShowPeoplePickerSuggestionsForGuestUsers = $CurrentValues.ShowPeoplePickerSuggestionsForGuestUsers
        write-verbose -Message "[INFO] ShowPeoplePickerSuggestionsForGuestUsers currently is $paramShowPeoplePickerSuggestionsForGuestUsers should be $ShowPeoplePickerSuggestionsForGuestUsers"
        if($ShowPeoplePickerSuggestionsForGuestUsers -eq $paramShowPeoplePickerSuggestionsForGuestUsers)
        {
            $returnedTrue = $returnedTrue + $ShowPeoplePickerSuggestionsForGuestUsers
        }
        else
        {
            $ShowPeoplePickerSuggestionsForGuestUsers = $paramShowPeoplePickerSuggestionsForGuestUsers
            $returnedFalse = $returnedFalse + $ShowPeoplePickerSuggestionsForGuestUsers
        }
        #Testing FileAnonymousLinkType (Configures anonymous link types for files.)
        $paramFileAnonymousLinkType = $CurrentValues.FileAnonymousLinkType
        write-verbose -Message "[INFO] FileAnonymousLinkType currently is $paramFileAnonymousLinkType should be $FileAnonymousLinkType"
        if($FileAnonymousLinkType -eq $paramFileAnonymousLinkType)
        {
            $returnedTrue = $returnedTrue + $FileAnonymousLinkType
        }
        else
        {
            $FileAnonymousLinkType = $paramFileAnonymousLinkType
            $returnedFalse = $returnedFalse + $FileAnonymousLinkType
        }
        #Testing FolderAnonymousLinkType (Configures anonymous link types for folders.)
        $paramFolderAnonymousLinkType = $CurrentValues.FolderAnonymousLinkType
        write-verbose -Message "[INFO] FolderAnonymousLinkType currently is $paramFolderAnonymousLinkType should be $FolderAnonymousLinkType"
        if($FolderAnonymousLinkType -eq $paramFolderAnonymousLinkType)
        {
            $returnedTrue = $returnedTrue + $FolderAnonymousLinkType
        }
        else
        {
            $FolderAnonymousLinkType = $paramFolderAnonymousLinkType
            $returnedFalse = $returnedFalse + $FolderAnonymousLinkType
        }
        #Testing NotifyOwnersWhenItemsReshared (When this parameter is set to $true and another user re-shares a document from a user’s OneDrive for Business, the OneDrive for Business owner is notified by e-mail.)
        $paramNotifyOwnersWhenItemsReshared = $CurrentValues.NotifyOwnersWhenItemsReshared
        write-verbose -Message "[INFO] NotifyOwnersWhenItemsReshared currently is $paramNotifyOwnersWhenItemsReshared should be $NotifyOwnersWhenItemsReshared"
        if($NotifyOwnersWhenItemsReshared -eq $paramNotifyOwnersWhenItemsReshared)
        {
            $returnedTrue = $returnedTrue + $NotifyOwnersWhenItemsReshared
        }
        else
        {
            $NotifyOwnersWhenItemsReshared = $paramNotifyOwnersWhenItemsReshared
            $returnedFalse = $returnedFalse + $NotifyOwnersWhenItemsReshared
        }
        #Testing NotifyOwnersWhenInvitationsAccepted (When this parameter is set to $true and when an external user accepts an invitation to a resource in a user’s OneDrive for Business, the OneDrive for Business owner is notified by e-mail.)
        $paramNotifyOwnersWhenInvitationsAccepted = $CurrentValues.NotifyOwnersWhenInvitationsAccepted
        write-verbose -Message "[INFO] NotifyOwnersWhenInvitationsAccepted currently is $paramNotifyOwnersWhenInvitationsAccepted should be $NotifyOwnersWhenInvitationsAccepted"
        if($NotifyOwnersWhenInvitationsAccepted -eq $paramNotifyOwnersWhenInvitationsAccepted)
        {
            $returnedTrue = $returnedTrue + $NotifyOwnersWhenInvitationsAccepted
        }
        else
        {
            $NotifyOwnersWhenInvitationsAccepted = $paramNotifyOwnersWhenInvitationsAccepted
            $returnedFalse = $returnedFalse + $NotifyOwnersWhenInvitationsAccepted
        }
        #Testing NotificationsInOneDriveForBusinessEnabled (Setting to enable/disable notifications in OneDrive for business)
        $paramNotificationsInOneDriveForBusinessEnabled = $CurrentValues.NotificationsInOneDriveForBusinessEnabled
        write-verbose -Message "[INFO] NotificationsInOneDriveForBusinessEnabled currently is $paramNotificationsInOneDriveForBusinessEnabled should be $NotificationsInOneDriveForBusinessEnabled"
        if($NotificationsInOneDriveForBusinessEnabled -eq $paramNotificationsInOneDriveForBusinessEnabled)
        {
            $returnedTrue = $returnedTrue + $NotificationsInOneDriveForBusinessEnabled
        }
        else
        {
            $NotificationsInOneDriveForBusinessEnabled = $paramNotificationsInOneDriveForBusinessEnabled
            $returnedFalse = $returnedFalse + $NotificationsInOneDriveForBusinessEnabled
        }
        #Testing NotificationsInSharePointEnabled (Setting to enable/disable notifications in SharePoint)
        $paramNotificationsInSharePointEnabled = $CurrentValues.NotificationsInSharePointEnabled
        write-verbose -Message "[INFO] NotificationsInSharePointEnabled currently is $paramNotificationsInSharePointEnabled should be $NotificationsInSharePointEnabled"
        if($NotificationsInSharePointEnabled -eq $paramNotificationsInSharePointEnabled)
        {
            $returnedTrue = $returnedTrue + $NotificationsInSharePointEnabled
        }
        else
        {
            $NotificationsInSharePointEnabled = $paramNotificationsInSharePointEnabled
            $returnedFalse = $returnedFalse + $NotificationsInSharePointEnabled
        }
        #Testing SpecialCharactersStateInFileFolderNames (SPermits the use of special characters in file and folder names in SharePoint Online and OneDrive for Business document libraries.)
        $paramSpecialCharactersStateInFileFolderNames = $CurrentValues.SpecialCharactersStateInFileFolderNames
        write-verbose -Message "[INFO] SpecialCharactersStateInFileFolderNames currently is $paramSpecialCharactersStateInFileFolderNames should be $SpecialCharactersStateInFileFolderNames"
        if($SpecialCharactersStateInFileFolderNames -eq $paramSpecialCharactersStateInFileFolderNames)
        {
            $returnedTrue = $returnedTrue + $SpecialCharactersStateInFileFolderNames
        }
        else
        {
            $SpecialCharactersStateInFileFolderNames = $paramSpecialCharactersStateInFileFolderNames
            $returnedFalse = $returnedFalse + $SpecialCharactersStateInFileFolderNames
        }
        #Testing CommentsOnSitePagesDisabled (When this feature is set to true, comments on site pages will be disabled)
        $paramCommentsOnSitePagesDisabled = $CurrentValues.CommentsOnSitePagesDisabled
        write-verbose -Message "[INFO] CommentsOnSitePagesDisabled currently is $paramCommentsOnSitePagesDisabled should be $CommentsOnSitePagesDisabled"
        if($CommentsOnSitePagesDisabled -eq $paramCommentsOnSitePagesDisabled)
        {
            $returnedTrue = $returnedTrue + $CommentsOnSitePagesDisabled
        }
        else
        {
            $CommentsOnSitePagesDisabled = $paramCommentsOnSitePagesDisabled
            $returnedFalse = $returnedFalse + $CommentsOnSitePagesDisabled
        }
        #Testing SocialBarOnSitePagesDisabled (Disables or enables the Social Bar.It will give users the ability to like a page, see the number of views, likes, and comments on a page, and see the people who have liked a page.)
        $paramSocialBarOnSitePagesDisabled = $CurrentValues.SocialBarOnSitePagesDisabled
        write-verbose -Message "[INFO] SocialBarOnSitePagesDisabled currently is $paramSocialBarOnSitePagesDisabled should be $SocialBarOnSitePagesDisabled"
        if($SocialBarOnSitePagesDisabled -eq $paramSocialBarOnSitePagesDisabled)
        {
            $returnedTrue = $returnedTrue + $SocialBarOnSitePagesDisabled
        }
        else
        {
            $SocialBarOnSitePagesDisabled = $paramSocialBarOnSitePagesDisabled
            $returnedFalse = $returnedFalse + $SocialBarOnSitePagesDisabled
        }
        #Testing OrphanedPersonalSitesRetentionPeriod (Specifies the number of days after a user's Active Directory account is deleted that their OneDrive for Business content will be deleted.)
        $paramOrphanedPersonalSitesRetentionPeriod = $CurrentValues.OrphanedPersonalSitesRetentionPeriod
        write-verbose -Message "[INFO] OrphanedPersonalSitesRetentionPeriod currently is $paramOrphanedPersonalSitesRetentionPeriod should be $OrphanedPersonalSitesRetentionPeriod"
        if($OrphanedPersonalSitesRetentionPeriod -eq $paramOrphanedPersonalSitesRetentionPeriod)
        {
            $returnedTrue = $returnedTrue + $OrphanedPersonalSitesRetentionPeriod
        }
        else
        {
            $OrphanedPersonalSitesRetentionPeriod = $paramOrphanedPersonalSitesRetentionPeriod
            $returnedFalse = $returnedFalse + $OrphanedPersonalSitesRetentionPeriod
        }
        #Testing PermissiveBrowserFileHandlingOverride (Enables the Permissive browser file handling. By default, the browser file handling is set to Strict (false).)
        $paramPermissiveBrowserFileHandlingOverride = $CurrentValues.PermissiveBrowserFileHandlingOverride
        write-verbose -Message "[INFO] PermissiveBrowserFileHandlingOverride currently is $paramPermissiveBrowserFileHandlingOverride should be $PermissiveBrowserFileHandlingOverride"
        if($PermissiveBrowserFileHandlingOverride -eq $paramPermissiveBrowserFileHandlingOverride)
        {
            $returnedTrue = $returnedTrue + $PermissiveBrowserFileHandlingOverride
        }
        else
        {
            $PermissiveBrowserFileHandlingOverride = $paramPermissiveBrowserFileHandlingOverride
            $returnedFalse = $returnedFalse + $PermissiveBrowserFileHandlingOverride
        }
        #Testing DisallowInfectedFileDownload (Prevents the Download button from being displayed on the Virus Found warning page.)
        $paramDisallowInfectedFileDownload = $CurrentValues.DisallowInfectedFileDownload
        write-verbose -Message "[INFO] DisallowInfectedFileDownload currently is $paramDisallowInfectedFileDownload should be $DisallowInfectedFileDownload"
        if($DisallowInfectedFileDownload -eq $paramDisallowInfectedFileDownload)
        {
            $returnedTrue = $returnedTrue + $DisallowInfectedFileDownload
        }
        else
        {
            $DisallowInfectedFileDownload = $paramDisallowInfectedFileDownload
            $returnedFalse = $returnedFalse + $DisallowInfectedFileDownload
        }
        #Testing DefaultLinkPermission ("Specifies the link permission on the tenant level.")
        $paramDefaultLinkPermission = $CurrentValues.DefaultLinkPermission
        write-verbose -Message "[INFO] DefaultLinkPermission currently is $paramDefaultLinkPermission should be $DefaultLinkPermission"
        if($DefaultLinkPermission -eq $paramDefaultLinkPermission)
        {
            $returnedTrue = $returnedTrue + $DefaultLinkPermission
        }
        else
        {
            $DefaultLinkPermission = $paramDefaultLinkPermission
            $returnedFalse = $returnedFalse + $DefaultLinkPermission
        }
        #Testing ConditionalAccessPolicy (Specifies the conditional access settings on the tenant level.)
        $paramConditionalAccessPolicy = $CurrentValues.ConditionalAccessPolicy
        write-verbose -Message "[INFO] ConditionalAccessPolicy currently is $paramConditionalAccessPolicy should be $ConditionalAccessPolicy"
        if($ConditionalAccessPolicy -eq $paramConditionalAccessPolicy)
        {
            $returnedTrue = $returnedTrue + $ConditionalAccessPolicy
        }
        else
        {
            $ConditionalAccessPolicy = $paramConditionalAccessPolicy
            $returnedFalse = $returnedFalse + $ConditionalAccessPolicy
        }
        #Testing AllowDownloadingNonWebViewableFiles (Prevents certain filetypes, that cannot be viewed on the web, from being downloaded)
        $paramAllowDownloadingNonWebViewableFiles = $CurrentValues.AllowDownloadingNonWebViewableFiles
        write-verbose -Message "[INFO] AllowDownloadingNonWebViewableFiles currently is $paramAllowDownloadingNonWebViewableFiles should be $AllowDownloadingNonWebViewableFiles"
        if($AllowDownloadingNonWebViewableFiles -eq $paramAllowDownloadingNonWebViewableFiles)
        {
            $returnedTrue = $returnedTrue + $AllowDownloadingNonWebViewableFiles
        }
        else
        {
            $AllowDownloadingNonWebViewableFiles = $paramAllowDownloadingNonWebViewableFiles
            $returnedFalse = $returnedFalse + $AllowDownloadingNonWebViewableFiles
        }
        #Testing LimitedAccessFileType("Prevents certain filetypes, that cannot be viewed on the web, from being downloaded.")
        $paramLimitedAccessFileType = $CurrentValues.LimitedAccessFileType
        write-verbose -Message "[INFO] LimitedAccessFileType currently is $paramLimitedAccessFileType should be $LimitedAccessFileType"
        if($LimitedAccessFileType -eq $paramLimitedAccessFileType)
        {
            $returnedTrue = $returnedTrue + $LimitedAccessFileType
        }
        else
        {
            $LimitedAccessFileType = $paramLimitedAccessFileType
            $returnedFalse = $returnedFalse + $LimitedAccessFileType
        }
        #Testing AllowEditing (Prevents users from editing files in the browser and copying and pasting file contents out of the browser window)
        $paramAllowEditing = $CurrentValues.AllowEditing
        write-verbose -Message "[INFO] AllowEditing currently is $paramAllowEditing should be $AllowEditing"
        if($AllowEditing -eq $paramAllowEditing)
        {
            $returnedTrue = $returnedTrue + $AllowEditing
        }
        else
        {
            $AllowEditing = $paramAllowEditing
            $returnedFalse = $returnedFalse + $AllowEditing
        }
        #Testing ApplyAppEnforcedRestrictionsToAdHocRecipients (When the feature is enabled, all guest users are subject to conditional access policy. By default guest users who are accessing SharePoint Online files with pass code are exempt from the conditional access policy.)
        $paramApplyAppEnforcedRestrictionsToAdHocRecipients = $CurrentValues.ApplyAppEnforcedRestrictionsToAdHocRecipients
        write-verbose -Message "[INFO] ApplyAppEnforcedRestrictionsToAdHocRecipients currently is $paramApplyAppEnforcedRestrictionsToAdHocRecipients should be $ApplyAppEnforcedRestrictionsToAdHocRecipients"
        if($ApplyAppEnforcedRestrictionsToAdHocRecipients -eq $paramApplyAppEnforcedRestrictionsToAdHocRecipients)
        {
            $returnedTrue = $returnedTrue + $ApplyAppEnforcedRestrictionsToAdHocRecipients
        }
        else
        {
            $ApplyAppEnforcedRestrictionsToAdHocRecipients = $paramApplyAppEnforcedRestrictionsToAdHocRecipients
            $returnedFalse = $returnedFalse + $ApplyAppEnforcedRestrictionsToAdHocRecipients
        }
        #Testing FilePickerExternalImageSearchEnabled (Enables file picker external image search)
        $paramFilePickerExternalImageSearchEnabled = $CurrentValues.FilePickerExternalImageSearchEnabled
        write-verbose -Message "[INFO] FilePickerExternalImageSearchEnabled currently is $paramFilePickerExternalImageSearchEnabled should be $FilePickerExternalImageSearchEnabled"
        if($FilePickerExternalImageSearchEnabled -eq $paramFilePickerExternalImageSearchEnabled)
        {
            $returnedTrue = $returnedTrue + $FilePickerExternalImageSearchEnabled
        }
        else
        {
            $FilePickerExternalImageSearchEnabled = $paramFilePickerExternalImageSearchEnabled
            $returnedFalse = $returnedFalse + $FilePickerExternalImageSearchEnabled
        }
        #Testing EmailAttestationRequired (Sets email attestation to required)
        $paramEmailAttestationRequired = $CurrentValues.EmailAttestationRequired
        write-verbose -Message "[INFO] EmailAttestationRequired currently is $paramEmailAttestationRequired should be $EmailAttestationRequired"
        if($EmailAttestationRequired -eq $paramEmailAttestationRequired)
        {
            $returnedTrue = $returnedTrue + $EmailAttestationRequired
        }
        else
        {
            $EmailAttestationRequired = $paramEmailAttestationRequired
            $returnedFalse = $returnedFalse + $EmailAttestationRequired
        }
        #Testing EmailAttestationReAuthDays (Sets email attestation re-auth days)
        $paramEmailAttestationReAuthDays = $CurrentValues.EmailAttestationReAuthDays
        write-verbose -Message "[INFO] EmailAttestationReAuthDays currently is $paramEmailAttestationReAuthDays should be $EmailAttestationReAuthDays"
        if($EmailAttestationReAuthDays -eq $paramEmailAttestationReAuthDays)
        {
            $returnedTrue = $returnedTrue + $EmailAttestationReAuthDays
        }
        else
        {
            $EmailAttestationReAuthDays = $paramEmailAttestationReAuthDays
            $returnedFalse = $returnedFalse + $EmailAttestationReAuthDays
        }
        #Testing SyncPrivacyProfileProperties (Syncs privacy profile properties. Allowed values true,false)
        $paramSyncPrivacyProfileProperties = $CurrentValues.SyncPrivacyProfileProperties
        write-verbose -Message "[INFO] SyncPrivacyProfileProperties currently is $paramSyncPrivacyProfileProperties should be $SyncPrivacyProfileProperties"
        if($SyncPrivacyProfileProperties -eq $paramSyncPrivacyProfileProperties)
        {
            $returnedTrue = $returnedTrue + $SyncPrivacyProfileProperties
        }
        else
        {
            $SyncPrivacyProfileProperties = $paramSyncPrivacyProfileProperties
            $returnedFalse = $returnedFalse + $SyncPrivacyProfileProperties
        }
        #Testing DisabledWebPartIds (Allows administrators prevent certain, specific web parts from being added to pages or rendering on pages on which they were previously added. Only web parts that utilize third-party services (Amazon Kindle, YouTube, Twitter) can be disabled in such a manner.)
        $paramDisabledWebPartIds = $CurrentValues.DisabledWebPartIds
        write-verbose -Message "[INFO] DisabledWebPartIds currently is $paramDisabledWebPartIds should be $DisabledWebPartIds"
        foreach($entry in $DisabledWebPartIds)
        {
            if($entry -eq $paramDisabledWebPartIds)
            {
                $returnedTrue = $returnedTrue + $entry
            }
            else
            {
                $entry = $paramDisabledWebPartIds
                $returnedFalse = $returnedFalse + $entry
            }
        }
        #Testing OrgNewsSiteUrl (IOrganization news site url.)
        $paramOrgNewsSiteUrl = $CurrentValues.OrgNewsSiteUrl
        write-verbose -Message "[INFO] OrgNewsSiteUrl currently is $paramOrgNewsSiteUrl should be $OrgNewsSiteUrl"
        if($OrgNewsSiteUrl -eq $paramOrgNewsSiteUrl)
        {
            $returnedTrue = $returnedTrue + $OrgNewsSiteUrl
        }
        else
        {
            $OrgNewsSiteUrl = $paramOrgNewsSiteUrl
            $returnedFalse = $returnedFalse + $OrgNewsSiteUrl
        }
        #Testing EnableMinimumVersionRequirement (Enables minimum version requirement.)
        $paramEnableMinimumVersionRequirement = $CurrentValues.EnableMinimumVersionRequirement
        write-verbose -Message "[INFO] EnableMinimumVersionRequirement currently is $paramEnableMinimumVersionRequirement should be $EnableMinimumVersionRequirement"
        if($EnableMinimumVersionRequirement -eq $paramEnableMinimumVersionRequirement)
        {
            $returnedTrue = $returnedTrue + $EnableMinimumVersionRequirement
        }
        else
        {
            $EnableMinimumVersionRequirement = $paramEnableMinimumVersionRequirement
            $returnedFalse = $returnedFalse + $EnableMinimumVersionRequirement
        }
    }
    else
    {
        return $false
    }
    if($returnedFalse.count -gt 0)
    {
        return $false
    }
    else
    {
        return $true
    }
    #return $false
}

Export-ModuleMember -Function *-TargetResource