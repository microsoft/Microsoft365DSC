function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Tenant,

        [Parameter()]
        [System.String]
        [ValidateSet("ExternalUserAndGuestSharing", "Disabled", "ExternalUserSharingOnly")]
        $SharingCapability,

        [Parameter()]
        [System.boolean]
        $ShowEveryoneClaim,

        [Parameter()]
        [System.boolean]
        $ShowAllUsersClaim,

        [Parameter()]
        [System.boolean]
        $ShowEveryoneExceptExternalUsersClaim,

        [Parameter()]
        [System.boolean]
        $ProvisionSharedWithEveryoneFolder,

        [Parameter()]
        [System.boolean]
        $EnableGuestSignInAcceleration,

        [Parameter()]
        [System.boolean]
        $BccExternalSharingInvitations,

        [Parameter()]
        [System.String]
        $BccExternalSharingInvitationsList,

        [Parameter()]
        [System.Uint32]
        $RequireAnonymousLinksExpireInDays,

        [Parameter()]
        [System.String]
        $SharingAllowedDomainList,

        [Parameter()]
        [System.String]
        $SharingBlockedDomainList,

        [Parameter()]
        [System.String]
        [ValidateSet("None", "AllowList", "BlockList")]
        $SharingDomainRestrictionMode,

        [Parameter()]
        [System.String]
        [ValidateSet("None", "Direct", "Internal", "AnonymousAccess")]
        $DefaultSharingLinkType,

        [Parameter()]
        [System.boolean]
        $PreventExternalUsersFromResharing,

        [Parameter()]
        [System.boolean]
        $ShowPeoplePickerSuggestionsForGuestUsers,

        [Parameter()]
        [System.String]
        [ValidateSet("View", "Edit")]
        $FileAnonymousLinkType,

        [Parameter()]
        [System.String]
        [ValidateSet("View", "Edit")]
        $FolderAnonymousLinkType,

        [Parameter()]
        [System.boolean]
        $NotifyOwnersWhenItemsReshared,

        [Parameter()]
        [System.String]
        [ValidateSet("View", "Edit")]
        $DefaultLinkPermission
    )
    
    Test-SPOServiceConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount

    $nullReturn = @{
        SharingCapability                             = $null
        ShowEveryoneClaim                             = $null
        ShowAllUsersClaim                             = $null
        ShowEveryoneExceptExternalUsersClaim          = $null
        ProvisionSharedWithEveryoneFolder             = $null
        EnableGuestSignInAcceleration                 = $null
        BccExternalSharingInvitations                 = $null
        BccExternalSharingInvitationsList             = $null
        RequireAnonymousLinksExpireInDays             = $null
        SharingAllowedDomainList                      = $null
        SharingBlockedDomainList                      = $null
        SharingDomainRestrictionMode                  = $null
        DefaultSharingLinkType                        = $null
        PreventExternalUsersFromResharing             = $null
        ShowPeoplePickerSuggestionsForGuestUsers      = $null
        FileAnonymousLinkType                         = $null
        FolderAnonymousLinkType                       = $null
        NotifyOwnersWhenItemsReshared                 = $null
        DefaultLinkPermission                         = $null
    }
    
    try
    {
        $SPOSharingSettings = Get-SPOTenant

        return @{
            SharingCapability                             = $SPOSharingSettings.SharingCapability
            ShowEveryoneClaim                             = $SPOSharingSettings.ShowEveryoneClaim
            ShowAllUsersClaim                             = $SPOSharingSettings.ShowAllUsersClaim
            ShowEveryoneExceptExternalUsersClaim          = $SPOSharingSettings.ShowEveryoneExceptExternalUsersClaim
            ProvisionSharedWithEveryoneFolder             = $SPOSharingSettings.ProvisionSharedWithEveryoneFolder
            EnableGuestSignInAcceleration                 = $SPOSharingSettings.EnableGuestSignInAcceleration
            BccExternalSharingInvitations                 = $SPOSharingSettings.BccExternalSharingInvitations
            BccExternalSharingInvitationsList             = $SPOSharingSettings.BccExternalSharingInvitationsList
            RequireAnonymousLinksExpireInDays             = $SPOSharingSettings.RequireAnonymousLinksExpireInDays
            SharingAllowedDomainList                      = $SPOSharingSettings.SharingAllowedDomainList
            SharingBlockedDomainList                      = $SPOSharingSettings.SharingBlockedDomainList
            SharingDomainRestrictionMode                  = $SPOSharingSettings.SharingDomainRestrictionMode
            DefaultSharingLinkType                        = $SPOSharingSettings.DefaultSharingLinkType
            PreventExternalUsersFromResharing             = $SPOSharingSettings.PreventExternalUsersFromResharing
            ShowPeoplePickerSuggestionsForGuestUsers      = $SPOSharingSettings.ShowPeoplePickerSuggestionsForGuestUsers
            FileAnonymousLinkType                         = $SPOSharingSettings.FileAnonymousLinkType
            FolderAnonymousLinkType                       = $SPOSharingSettings.FolderAnonymousLinkType
            NotifyOwnersWhenItemsReshared                 = $SPOSharingSettings.NotifyOwnersWhenItemsReshared
            DefaultLinkPermission                         = $SPOSharingSettings.DefaultLinkPermission
        }
    }
    catch
    {
        if($error[0].Exception.Message -like "No connection available")
        {
            write-Verbose "Make sure that you are connected to your SPOService"
        }
        return $nullReturn
    }

}
function Set-TargetResource
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Tenant,

        [Parameter()]
        [System.String]
        [ValidateSet("ExternalUserAndGuestSharing", "Disabled", "ExternalUserSharingOnly")]
        $SharingCapability,

        [Parameter()]
        [System.boolean]
        $ShowEveryoneClaim,

        [Parameter()]
        [System.boolean]
        $ShowAllUsersClaim,

        [Parameter()]
        [System.boolean]
        $ShowEveryoneExceptExternalUsersClaim,

        [Parameter()]
        [System.boolean]
        $ProvisionSharedWithEveryoneFolder,

        [Parameter()]
        [System.boolean]
        $EnableGuestSignInAcceleration,

        [Parameter()]
        [System.boolean]
        $BccExternalSharingInvitations,

        [Parameter()]
        [System.String]
        $BccExternalSharingInvitationsList,

        [Parameter()]
        [System.Uint32]
        $RequireAnonymousLinksExpireInDays,

        [Parameter()]
        [System.String]
        $SharingAllowedDomainList,

        [Parameter()]
        [System.String]
        $SharingBlockedDomainList,

        [Parameter()]
        [System.String]
        [ValidateSet("None", "AllowList", "BlockList")]
        $SharingDomainRestrictionMode,

        [Parameter()]
        [System.String]
        [ValidateSet("None", "Direct", "Internal", "AnonymousAccess")]
        $DefaultSharingLinkType,

        [Parameter()]
        [System.boolean]
        $PreventExternalUsersFromResharing,

        [Parameter()]
        [System.boolean]
        $ShowPeoplePickerSuggestionsForGuestUsers,

        [Parameter()]
        [System.String]
        [ValidateSet("View", "Edit")]
        $FileAnonymousLinkType,

        [Parameter()]
        [System.String]
        [ValidateSet("View", "Edit")]
        $FolderAnonymousLinkType,

        [Parameter()]
        [System.boolean]
        $NotifyOwnersWhenItemsReshared,

        [Parameter()]
        [System.String]
        [ValidateSet("View", "Edit")]
        $DefaultLinkPermission
    )
    
    Test-SPOServiceConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount

    if($Ensure -eq "Present")
    {
        $CurrentParameters = $PSBoundParameters
        $CurrentParameters.Remove("CentralAdminUrl")
        $CurrentParameters.Remove("GlobalAdminAccount")
        $CurrentParameters.Remove("Ensure")
        $CurrentParameters.Remove("Verbose")

        Write-Verbose -Message "%%% Setting Tenant: $Tenant %%%"
        $CurrentParameters.Remove("Tenant")
        if($DisableContentTypeSyncSiteTemplatesList -eq "True" -and $ContentTypeSyncSiteTemplatesList -eq "MySites")
        {
            Write-Verbose -Message "Disabling ContentTypeSyncSiteTemplatesList (which is currently set to:$ContentTypeSyncSiteTemplatesList) using the ExcludeSiteTemplate switch"
            Set-SPOTenant -ContentTypeSyncSiteTemplatesList "MySites" -ExcludeSiteTemplate -Verbose
            $CurrentParameters.Remove("ContentTypeSyncSiteTemplatesList")
        }
        $CurrentParameters.Remove("DisableContentTypeSyncSiteTemplatesList")

        if($null -like $SignInAccelerationDomain)
        {
            $CurrentParameters.remove("SignInAccelerationDomain")
            $CurrentParameters.remove("EnableGuestSignInAcceleration")#removing EnableGuestSignInAcceleration since it can only be configured with a configured SignINAccerlation domain
        }
        if(($null -notlike $PublicCdnAllowedFileTypes) -and ($PublicCdnEnabled -eq $false))
        {
            Write-Verbose -Message "To configure PublicCdnAllowedFileTypes you have to have the PublicCDNEnabled"
            $CurrentParameters.Remove("PublicCdnAllowedFileTypes")
        }

        if($SharingCapability -ne "ExternalUserAndGuestSharing")
        {
            Write-Verbose -Message "The sharing capabilities for the tenant are not configured to be ExternalUserAndGuestSharing for that the RequireAnonymousLinksExpireInDays property cannot be configured"
            $CurrentParameters.Remove("RequireAnonymousLinksExpireInDays")
        }
        if($RequireAcceptingAccountMatchInvitedAccount -eq $false)
        {
            Write-Verbose -Message "RequireAcceptingAccountMatchInvitedAccount is set to be false. For that SharingAllowedDomainList / SharingBlockedDomainList cannot be configured"
            $CurrentParameters.Remove("SharingAllowedDomainList")
            $CurrentParameters.Remove("SharingBlockedDomainList")
        }
        if($SharingDomainRestrictionMode -eq "None")
        {
            Write-Verbose -Message "SharingDomainRestrictionMode is set to None. For that SharingAllowedDomainList / SharingBlockedDomainList cannot be configured"
            $CurrentParameters.Remove("SharingAllowedDomainList")
            $CurrentParameters.Remove("SharingBlockedDomainList")
        }
        elseif ($SharingDomainRestrictionMode -eq "AllowList")
        {
            Write-Verbose -Message "SharingDomainRestrictionMode is set to AllowList. For that SharingBlockedDomainList cannot be configured"
            $CurrentParameters.Remove("SharingBlockedDomainList")
        }
        elseif($SharingDomainRestrictionMode -eq "BlockList")
        {
            Write-Verbose -Message "SharingDomainRestrictionMode is set to BlockList. For that SharingAllowedDomainList cannot be configured"
            $CurrentParameters.Remove("SharingAllowedDomainList")
        }
        if($IPAddressEnforcement -eq $true)
        {
            if($null -like $IPAddressAllowList)
            {
                Write-Verbose -Message "IPAddressAllowList is empty. Please configure it, when you would like to set the IPAddressEnforcement property"
                $CurrentParameters.Remove("IPAddressEnforcement")
            }
            else
            {
                Write-Verbose -Message "Making sure IPADdressEnforcement is set to true before passing in the list of the allowed IP addresses"
                set-spotenant -IPAddressEnforcement $IPAddressEnforcement -IPAddressAllowList $IPAddressAllowList #setting the ipaddress enforcement parameter and the list of allowed IP addresses
            }
        }
        if($null -notlike $PermissiveBrowserFileHandlingOverride)
        {
            Write-Verbose -Message "The permissive browser handling is deprecated and cannot be configured. Removing this parameter from the configuration"
            $CurrentParameters.Remove("PermissiveBrowserFileHandlingOverride")
        }
        if($null -notlike $DisabledWebPartIds)
        {
            $DisabledWebPartIdsGUID = @()
            $DisabledWebParts = $DisabledWebPartIds.split(",")
            
            foreach($DisabledWebPartId in $DisabledWebParts)
            {
                write-Verbose -Message "Setting the DisabledWebpartIDs property for tenant for webpart: $DisabledWebPartId"
                $DisabledWebPartIdsGUID += [GUID]$DisabledWebPartId
            }
            Set-SPOTenant -DisabledWebPartIds $DisabledWebPartIdsGUID
            $DisabledWebPartIdsGUID = @()
            $CurrentParameters.Remove("DisabledWebPartIds")
        }
        else
        {
            set-spotenant -DisabledWebPartIds @()
        }
        foreach($value in $CurrentParameters.GetEnumerator())
        {
            write-verbose -Message "Configuring Tenant with: $value"
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
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Tenant,

        [Parameter()]
        [System.String]
        [ValidateSet("ExternalUserAndGuestSharing", "Disabled", "ExternalUserSharingOnly")]
        $SharingCapability,

        [Parameter()]
        [System.boolean]
        $ShowEveryoneClaim,

        [Parameter()]
        [System.boolean]
        $ShowAllUsersClaim,

        [Parameter()]
        [System.boolean]
        $ShowEveryoneExceptExternalUsersClaim,

        [Parameter()]
        [System.boolean]
        $ProvisionSharedWithEveryoneFolder,

        [Parameter()]
        [System.boolean]
        $EnableGuestSignInAcceleration,

        [Parameter()]
        [System.boolean]
        $BccExternalSharingInvitations,

        [Parameter()]
        [System.String]
        $BccExternalSharingInvitationsList,

        [Parameter()]
        [System.Uint32]
        $RequireAnonymousLinksExpireInDays,

        [Parameter()]
        [System.String]
        $SharingAllowedDomainList,

        [Parameter()]
        [System.String]
        $SharingBlockedDomainList,

        [Parameter()]
        [System.String]
        [ValidateSet("None", "AllowList", "BlockList")]
        $SharingDomainRestrictionMode,

        [Parameter()]
        [System.String]
        [ValidateSet("None", "Direct", "Internal", "AnonymousAccess")]
        $DefaultSharingLinkType,

        [Parameter()]
        [System.boolean]
        $PreventExternalUsersFromResharing,

        [Parameter()]
        [System.boolean]
        $ShowPeoplePickerSuggestionsForGuestUsers,

        [Parameter()]
        [System.String]
        [ValidateSet("View", "Edit")]
        $FileAnonymousLinkType,

        [Parameter()]
        [System.String]
        [ValidateSet("View", "Edit")]
        $FolderAnonymousLinkType,

        [Parameter()]
        [System.boolean]
        $NotifyOwnersWhenItemsReshared,

        [Parameter()]
        [System.String]
        [ValidateSet("View", "Edit")]
        $DefaultLinkPermission
    )
    Test-SPOServiceConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount
    Write-Verbose -Message "Testing SPO Tenant"
    $CurrentValues = Get-TargetResource @PSBoundParameters
    return Test-Office365DSCParameterState -CurrentValues $CurrentValues `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @("Ensure", `
            "SharingCapability", `
            "ShowEveryoneClaim", `
            "ShowAllUsersClaim", `
            "ShowEveryoneExceptExternalUsersClaim", `
            "ProvisionSharedWithEveryoneFolder", `
            "EnableGuestSignInAcceleration", `
            "BccExternalSharingInvitations", `
            "BccExternalSharingInvitationsList", `
            "RequireAnonymousLinksExpireInDays", `
            "SharingAllowedDomainList", `
            "SharingBlockedDomainList", `
            "SharingDomainRestrictionMode", `
            "DefaultSharingLinkType", `
            "PreventExternalUsersFromResharing", `
            "ShowPeoplePickerSuggestionsForGuestUsers", `
            "FileAnonymousLinkType", `
            "FolderAnonymousLinkType", `
            "NotifyOwnersWhenItemsReshared", `
            "DefaultLinkPermission"
    )
}
Export-ModuleMember -Function *-TargetResource
