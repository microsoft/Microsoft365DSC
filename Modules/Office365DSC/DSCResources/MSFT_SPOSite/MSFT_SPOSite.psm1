function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Url,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Owner,

        [Parameter()]
        [System.UInt32]
        $StorageQuota,

        [Parameter()]
        [System.String]
        $Title,

        [Parameter()]
        [System.UInt32]
        $CompatibilityLevel,

        [Parameter()]
        [System.UInt32]
        $LocaleId,

        [Parameter()]
        [System.UInt32]
        $ResourceQuota,

        [Parameter()]
        [System.String]
        $Template,

        [Parameter()]
        [System.UInt32]
        $TimeZoneId,

        [Parameter()]
        [System.Boolean]
        $AllowSelfServiceUpgrade,

        [Parameter()]
        [System.Boolean]
        $DenyAddAndCustomizePages,

        [Parameter()]
        [System.String]
        [ValidateSet("NoAccess", "Unlock")]
        $LockState,

        [Parameter()]
        [System.UInt32]
        $ResourceQuotaWarningLevel,

        [Parameter()]
        [System.String]
        [ValidateSet("Disabled", "ExistingExternalUserSharingOnly", "ExternalUserSharingOnly", "ExternalUserAndGuestSharing")]
        $SharingCapability,

        [Parameter()]
        [System.UInt32]
        $StorageQuotaWarningLevel,

        [Parameter()]
        [System.boolean]
        $CommentsOnSitePagesDisabled,

        [Parameter()]
        [System.boolean]
        $SocialBarOnSitePagesDisabled,

        [Parameter()]
        [System.String]
        [ValidateSet("Unknown", "Disabled", "NotDisabled")]
        $DisableAppViews,

        [Parameter()]
        [System.String]
        [ValidateSet("Unknown", "Disabled", "NotDisabled")]
        $DisableCompanyWideSharingLinks,

        [Parameter()]
        [System.String]
        [ValidateSet("Unknown", "Disabled", "NotDisabled")]
        $DisableFlows,

        [Parameter()]
        [System.String]
        [ValidateSet("NoRestriction", "BlockMoveOnly", "BlockFull", "Unknown")]
        $RestrictedToGeo,

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
        [System.Boolean]
        $ShowPeoplePickerSuggestionsForGuestUsers,

        [Parameter()]
        [System.String]
        [ValidateSet("None", "AnonymousAccess", "Internal", "Direct")]
        $DefaultSharingLinkType,

        [Parameter()]
        [System.String]
        [ValidateSet("None", "View", "Edit")]
        $DefaultLinkPermission,

        [Parameter()]
        [System.String]
        $HubUrl,

        [Parameter()]
        [System.UInt32]
        $AnonymousLinkExpirationInDays,

        [Parameter()]
        [System.Boolean]
        $OverrideTenantAnonymousLinkExpirationPolicy,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration for site collection $Url"

    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
        -Platform SharePointOnline

    $nullReturn = @{
        Url                                      = $Url
        Owner                                       = $null
        #TimeZoneId                                 = $null
        LocaleId                                    = $null
        Template                                    = $null
        ResourceQuota                               = $null
        StorageQuota                                = $null
        CompatibilityLevel                          = $null
        Title                                       = $null
        AllowSelfServiceUpgrade                     = $null
        DenyAddAndCustomizePages                    = $null
        LockState                                   = $null
        ResourceQuotaWarningLevel                   = $null
        SharingCapability                           = $null
        StorageQuotaWarningLevel                    = $null
        CommentsOnSitePagesDisabled                 = $null
        SocialBarOnSitePagesDisabled                = $null
        DisableAppViews                             = $null
        DisableCompanyWideSharingLinks              = $null
        DisableFlows                                = $null
        RestrictedToGeo                             = $null
        SharingAllowedDomainList                    = $null
        SharingBlockedDomainList                    = $null
        SharingDomainRestrictionMode                = $null
        ShowPeoplePickerSuggestionsForGuestUsers    = $null
        DefaultSharingLinkType                      = $null
        DefaultLinkPermission                       = $null
        HubUrl                                      = $null
        AnonymousLinkExpirationInDays               = $null
        OverrideTenantAnonymousLinkExpirationPolicy = $null
        Ensure                                      = "Absent"
        GlobalAdminAccount                          = $GlobalAdminAccount
    }

    try
    {
        Write-Verbose -Message "Getting site collection $Url"
        $site = Get-SPOSite $Url
        if ($null -eq $site)
        {
            Write-Verbose -Message "The specified Site Collection doesn't exist."
            return $nullReturn
        }

        $DenyAddAndCustomizePagesValue = $false
        if ($site.DenyAddAndCustomizePages -eq "Enabled")
        {
            $DenyAddAndCustomizePagesValue = $true
        }
        if ($site.HubSiteId -ne "00000000-0000-0000-0000-000000000000")
        {
            $hubId = $site.HubSiteId
            $hubSites = Get-SPOHubSite

            $hubSite = $hubSites | Where-Object -FilterScript { $_.Id -eq $site.HubSiteId }
            if ($null -ne $hubSite)
            {
                $hubUrl = $hubSite.SiteUrl
            }
            else
            {
                Write-Warning "The site {$Url} is associated with Hub Site {$hubId} which no longer exists."
            }
        }

        if ($site.DenyAddAndCustomizePages -eq "Enabled")
        {
            $denyAddAndCustomizePages = $true
        }
        else
        {
            $denyAddAndCustomizePages = $false
        }

        return @{
            Url                                         = $site.Url
            Owner                                       = $site.Owner
            #TimeZoneId                                 = $site.TimeZoneId
            LocaleId                                    = $site.LocaleId
            Template                                    = $site.Template
            ResourceQuota                               = $site.ResourceQuota
            StorageQuota                                = $site.StorageQuota
            CompatibilityLevel                          = $site.CompatibilityLevel
            Title                                       = $site.Title
            AllowSelfServiceUpgrade                     = $site.AllowSelfServiceUpgrade
            DenyAddAndCustomizePages                    = $DenyAddAndCustomizePagesValue
            LockState                                   = $site.LockState
            ResourceQuotaWarningLevel                   = $site.ResourceQuotaWarningLevel
            SharingCapability                           = $site.SharingCapability
            StorageQuotaWarningLevel                    = $site.StorageQuotaWarningLevel
            CommentsOnSitePagesDisabled                 = $site.CommentsOnSitePagesDisabled
            SocialBarOnSitePagesDisabled                = $site.SocialBarOnSitePagesDisabled
            DisableAppViews                             = $site.DisableAppViews
            DisableCompanyWideSharingLinks              = $site.DisableCompanyWideSharingLinks
            DisableFlows                                = $site.DisableFlows
            RestrictedToGeo                             = $site.RestrictedToGeo
            SharingAllowedDomainList                    = $site.SharingAllowedDomainList
            SharingBlockedDomainList                    = $site.SharingBlockedDomainList
            SharingDomainRestrictionMode                = $site.SharingDomainRestrictionMode
            ShowPeoplePickerSuggestionsForGuestUsers    = $site.ShowPeoplePickerSuggestionsForGuestUsers
            DefaultSharingLinkType                      = $site.DefaultSharingLinkType
            DefaultLinkPermission                       = $site.DefaultLinkPermission
            HubUrl                                      = $hubUrl
            AnonymousLinkExpirationInDays               = $site.AnonymousLinkExpirationInDays
            OverrideTenantAnonymousLinkExpirationPolicy = $site.OverrideTenantAnonymousLinkExpirationPolicy
            GlobalAdminAccount                          = $GlobalAdminAccount
            Ensure                                      = "Present"
        }
    }
    catch
    {
        Write-Verbose -Message "The specified Site Collection doesn't exist."
        return $nullReturn
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Url,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Owner,

        [Parameter()]
        [System.UInt32]
        $StorageQuota = 26214400,

        [Parameter()]
        [System.String]
        $Title,

        [Parameter()]
        [System.UInt32]
        $CompatibilityLevel,

        [Parameter()]
        [System.UInt32]
        $LocaleId,

        [Parameter()]
        [System.UInt32]
        $ResourceQuota,

        [Parameter()]
        [System.String]
        $Template,

        [Parameter()]
        [System.UInt32]
        $TimeZoneId,

        [Parameter()]
        [System.Boolean]
        $AllowSelfServiceUpgrade,

        [Parameter()]
        [System.Boolean]
        $DenyAddAndCustomizePages,

        [Parameter()]
        [System.String]
        [ValidateSet("NoAccess", "Unlock")]
        $LockState,

        [Parameter()]
        [System.UInt32]
        $ResourceQuotaWarningLevel,

        [Parameter()]
        [System.String]
        [ValidateSet("Disabled", "ExistingExternalUserSharingOnly","ExternalUserSharingOnly","ExternalUserAndGuestSharing")]
        $SharingCapability,

        [Parameter()]
        [System.UInt32]
        $StorageQuotaWarningLevel,

        [Parameter()]
        [System.boolean]
        $CommentsOnSitePagesDisabled,

        [Parameter()]
        [System.boolean]
        $SocialBarOnSitePagesDisabled,

        [Parameter()]
        [System.String]
        [ValidateSet("Unknown", "Disabled","NotDisabled")]
        $DisableAppViews,

        [Parameter()]
        [System.String]
        [ValidateSet("Unknown", "Disabled","NotDisabled")]
        $DisableCompanyWideSharingLinks,

        [Parameter()]
        [System.String]
        [ValidateSet("Unknown", "Disabled","NotDisabled")]
        $DisableFlows,

        [Parameter()]
        [System.String]
        [ValidateSet("NoRestriction", "BlockMoveOnly", "BlockFull", "Unknown")]
        $RestrictedToGeo,

        [Parameter()]
        [System.String]
        $SharingAllowedDomainList,

        [Parameter()]
        [System.String]
        $SharingBlockedDomainList,

        [Parameter()]
        [System.String]
        [ValidateSet("None", "AllowList","BlockList")]
        $SharingDomainRestrictionMode,

        [Parameter()]
        [System.Boolean]
        $ShowPeoplePickerSuggestionsForGuestUsers,

        [Parameter()]
        [System.String]
        [ValidateSet("None", "AnonymousAccess","Internal","Direct")]
        $DefaultSharingLinkType,

        [Parameter()]
        [System.String]
        [ValidateSet("None", "View","Edit")]
        $DefaultLinkPermission,

        [Parameter()]
        [System.String]
        $HubUrl,

        [Parameter()]
        [System.UInt32]
        $AnonymousLinkExpirationInDays,

        [Parameter()]
        [System.Boolean]
        $OverrideTenantAnonymousLinkExpirationPolicy,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration for site collection $Url"

    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
                      -Platform SharePointOnline

    if ($Ensure -eq "Present")
    {
        $CurrentParameters = $PSBoundParameters
        Set-SPOSiteConfiguration @CurrentParameters
    }
    elseif ($Ensure -eq "Absent")
    {
        Write-Verbose -Message "Removing site $($Url)"
        try
        {
            Remove-SPOSite -Identity $Url -Confirm:$false
        }
        catch
        {
            if ($Error[0].Exception.Message -eq "File Not Found")
            {
                try
                {
                    $siteAlreadyDeleted = Get-SPODeletedSite -Identity $Url
                    if ($null -ne $siteAlreadyDeleted)
                    {
                        $Message = "The site $($Url) already exists in the deleted sites."
                        New-Office365DSCLogEntry -Error $_ -Message $Message
                        throw $Message
                    }
                }
                catch
                {
                    $Message = "The site $($Url) does not exist in the deleted sites."
                    New-Office365DSCLogEntry -Error $_ -Message $Message
                    throw $Message
                }
            }
        }
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Url,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Owner,

        [Parameter()]
        [System.UInt32]
        $StorageQuota = 26214400,

        [Parameter()]
        [System.String]
        $Title,

        [Parameter()]
        [System.UInt32]
        $CompatibilityLevel,

        [Parameter()]
        [System.UInt32]
        $LocaleId,

        [Parameter()]
        [System.UInt32]
        $ResourceQuota,

        [Parameter()]
        [System.String]
        $Template,

        [Parameter()]
        [System.UInt32]
        $TimeZoneId,

        [Parameter()]
        [System.Boolean]
        $AllowSelfServiceUpgrade,

        [Parameter()]
        [System.Boolean]
        $DenyAddAndCustomizePages,

        [Parameter()]
        [System.String]
        [ValidateSet("NoAccess", "Unlock")]
        $LockState,

        [Parameter()]
        [System.UInt32]
        $ResourceQuotaWarningLevel,

        [Parameter()]
        [System.String]
        [ValidateSet("Disabled", "ExistingExternalUserSharingOnly", "ExternalUserSharingOnly", "ExternalUserAndGuestSharing")]
        $SharingCapability,

        [Parameter()]
        [System.UInt32]
        $StorageQuotaWarningLevel,

        [Parameter()]
        [System.boolean]
        $CommentsOnSitePagesDisabled,

        [Parameter()]
        [System.boolean]
        $SocialBarOnSitePagesDisabled,

        [Parameter()]
        [System.String]
        [ValidateSet("Unknown", "Disabled", "NotDisabled")]
        $DisableAppViews,

        [Parameter()]
        [System.String]
        [ValidateSet("Unknown", "Disabled", "NotDisabled")]
        $DisableCompanyWideSharingLinks,

        [Parameter()]
        [System.String]
        [ValidateSet("Unknown", "Disabled", "NotDisabled")]
        $DisableFlows,

        [Parameter()]
        [System.String]
        [ValidateSet("NoRestriction", "BlockMoveOnly", "BlockFull", "Unknown")]
        $RestrictedToGeo,

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
        [System.Boolean]
        $ShowPeoplePickerSuggestionsForGuestUsers,

        [Parameter()]
        [System.String]
        [ValidateSet("None", "AnonymousAccess", "Internal", "Direct")]
        $DefaultSharingLinkType,

        [Parameter()]
        [System.String]
        [ValidateSet("None", "View", "Edit")]
        $DefaultLinkPermission,

        [Parameter()]
        [System.String]
        $HubUrl,

        [Parameter()]
        [System.UInt32]
        $AnonymousLinkExpirationInDays,

        [Parameter()]
        [System.Boolean]
        $OverrideTenantAnonymousLinkExpirationPolicy,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration for site collection $Url"
    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-O365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-O365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
                                                  -DesiredValues $PSBoundParameters `
                                                  -ValuesToCheck @("Ensure", `
                                                                   "Url", `
                                                                   "Title", `
                                                                   "Owner", `
                                                                   "StorageQuota", `
                                                                   "CompatibilityLevel", `
                                                                   "LocaleId", `
                                                                   "ResourceQuota", `
                                                                   "Template", `
                                                                   "TimeZoneId", `
                                                                   "AllowSelfServiceUpgrade", `
                                                                   "DenyAddAndCustomizePages", `
                                                                   "LockState", `
                                                                   "ResourceQuotaWarningLevel", `
                                                                   "SharingCapability", `
                                                                   "StorageQuotaWarningLevel", `
                                                                   "CommentsOnSitePagesDisabled", `
                                                                   "SocialBarOnSitePagesDisabled", `
                                                                   "DisableAppViews", `
                                                                   "DisableCompanyWideSharingLinks", `
                                                                   "DisableFlows", `
                                                                   "RestrictedToGeo", `
                                                                   "SharingAllowedDomainList", `
                                                                   "SharingBlockedDomainList", `
                                                                   "SharingDomainRestrictionMode", `
                                                                   "ShowPeoplePickerSuggestionsForGuestUsers", `
                                                                   "DefaultSharingLinkType", `
                                                                   "DefaultLinkPermission", `
                                                                   "HubUrl", `
                                                                   "AnonymousLinkExpirationInDays", `
                                                                   "OverrideTenantAnonymousLinkExpirationPolicy"
                                                                   )

    Write-Verbose -Message "Test-TargetResource returned $TestResult"

    return $TestResult
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Url,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Owner,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $result = Get-TargetResource @PSBoundParameters
    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
    if ($result.RestrictedToGeo -eq "Unknown")
    {
        $result.Remove("RestrictedToGeo")
    }
    $result.Remove("HubUrl")

    $content = "        SPOSite " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource

function Set-SPOSiteConfiguration
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Url,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Owner,

        [Parameter()]
        [System.UInt32]
        $StorageQuota = 26214400,

        [Parameter()]
        [System.String]
        $Title,

        [Parameter()]
        [System.UInt32]
        $CompatibilityLevel,

        [Parameter()]
        [System.UInt32]
        $LocaleId,

        [Parameter()]
        [System.UInt32]
        $ResourceQuota,

        [Parameter()]
        [System.String]
        $Template,

        [Parameter()]
        [System.UInt32]
        $TimeZoneId,

        [Parameter()]
        [System.Boolean]
        $AllowSelfServiceUpgrade,

        [Parameter()]
        [System.Boolean]
        $DenyAddAndCustomizePages,

        [Parameter()]
        [System.String]
        [ValidateSet("NoAccess", "Unlock")]
        $LockState,

        [Parameter()]
        [System.UInt32]
        $ResourceQuotaWarningLevel,

        [Parameter()]
        [System.String]
        [ValidateSet("Disabled", "ExistingExternalUserSharingOnly","ExternalUserSharingOnly","ExternalUserAndGuestSharing")]
        $SharingCapability,

        [Parameter()]
        [System.UInt32]
        $StorageQuotaWarningLevel,

        [Parameter()]
        [System.boolean]
        $CommentsOnSitePagesDisabled,

        [Parameter()]
        [System.boolean]
        $SocialBarOnSitePagesDisabled,

        [Parameter()]
        [System.String]
        [ValidateSet("Unknown", "Disabled","NotDisabled")]
        $DisableAppViews,

        [Parameter()]
        [System.String]
        [ValidateSet("Unknown", "Disabled","NotDisabled")]
        $DisableCompanyWideSharingLinks,

        [Parameter()]
        [System.String]
        [ValidateSet("Unknown", "Disabled","NotDisabled")]
        $DisableFlows,

        [Parameter()]
        [System.String]
        [ValidateSet("BlockMoveOnly", "BlockFull")]
        $RestrictedToGeo,

        [Parameter()]
        [System.String]
        $SharingAllowedDomainList,

        [Parameter()]
        [System.String]
        $SharingBlockedDomainList,

        [Parameter()]
        [System.String]
        [ValidateSet("None", "AllowList","BlockList")]
        $SharingDomainRestrictionMode,

        [Parameter()]
        [System.Boolean]
        $ShowPeoplePickerSuggestionsForGuestUsers,

        [Parameter()]
        [System.String]
        [ValidateSet("None", "AnonymousAccess","Internal","Direct")]
        $DefaultSharingLinkType,

        [Parameter()]
        [System.String]
        [ValidateSet("None", "View","Edit")]
        $DefaultLinkPermission,

        [Parameter()]
        [System.String]
        $HubUrl,

        [Parameter()]
        [System.UInt32]
        $AnonymousLinkExpirationInDays,

        [Parameter()]
        [System.Boolean]
        $OverrideTenantAnonymousLinkExpirationPolicy,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.Boolean]
        $IsSecondTry = $false
    )
    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
                      -Platform SharePointOnline
    $deletedSite = Get-SPODeletedSite | Where-Object -FilterScript { $_.Url -eq $Url }
    if ($deletedSite)
    {
        Write-Verbose -Message "A site with URL $($URL) was found in the Recycle Bin."
        Write-Verbose -Message "Restoring deleted SPOSite $($Url)"
        Restore-SPODeletedSite $deletedSite
        Start-Sleep -Seconds 5
    }
    try
    {
        $site = Get-SPOSite $Url
    }
    catch
    {
        Write-Verbose -Message "Site does not exist. Creating it"
    }
    if ($null -ne $site)
    {
        Write-Verbose -Message "Configuring site collection $Url"
        if ($site.LockState -eq "NoAccess")
        {
            $CurrentParameters = $PSBoundParameters
            Write-Debug "The site $url currently is in Lockstate NoAccess and for that cannot be changed"
            if ($CurrentParameters.ContainsKey("GlobalAdminAccount")) { $CurrentParameters.Remove("GlobalAdminAccount") }
            if ($CurrentParameters.ContainsKey("Ensure")) { $CurrentParameters.Remove("Ensure") }
            if ($CurrentParameters.ContainsKey("AllowSelfServiceUpgrade")) { $CurrentParameters.Remove("AllowSelfServiceUpgrade") }
            if ($CurrentParameters.ContainsKey("DenyAddAndCustomizePages")) { $CurrentParameters.Remove("DenyAddAndCustomizePages") }
            if ($CurrentParameters.ContainsKey("ResourceQuotaWarningLevel")) { $CurrentParameters.Remove("ResourceQuotaWarningLevel") }
            if ($CurrentParameters.ContainsKey("SharingCapability")) { $CurrentParameters.Remove("SharingCapability") }
            if ($CurrentParameters.ContainsKey("StorageQuotaWarningLevel")) { $CurrentParameters.Remove("StorageQuotaWarningLevel") }
            if ($CurrentParameters.ContainsKey("CommentsOnSitePagesDisabled")) { $CurrentParameters.Remove("CommentsOnSitePagesDisabled") }
            if ($CurrentParameters.ContainsKey("SocialBarOnSitePagesDisabled")) { $CurrentParameters.Remove("SocialBarOnSitePagesDisabled") }
            if ($CurrentParameters.ContainsKey("DisableAppViews")) { $CurrentParameters.Remove("DisableAppViews") }
            if ($CurrentParameters.ContainsKey("DisableCompanyWideSharingLinks")) { $CurrentParameters.Remove("DisableCompanyWideSharingLinks") }
            if ($CurrentParameters.ContainsKey("DisableFlows")) { $CurrentParameters.Remove("DisableFlows") }
            if ($CurrentParameters.ContainsKey("RestrictedToGeo")) { $CurrentParameters.Remove("RestrictedToGeo") }
            if ($CurrentParameters.ContainsKey("SharingAllowedDomainList")) { $CurrentParameters.Remove("SharingAllowedDomainList") }
            if ($CurrentParameters.ContainsKey("SharingBlockedDomainList")) { $CurrentParameters.Remove("SharingBlockedDomainList") }
            if ($CurrentParameters.ContainsKey("SharingDomainRestrictionMode")) { $CurrentParameters.Remove("SharingDomainRestrictionMode") }
            if ($CurrentParameters.ContainsKey("ShowPeoplePickerSuggestionsForGuestUsers")) { $CurrentParameters.Remove("ShowPeoplePickerSuggestionsForGuestUsers") }
            if ($CurrentParameters.ContainsKey("DefaultSharingLinkType")) { $CurrentParameters.Remove("DefaultSharingLinkType") }
            if ($CurrentParameters.ContainsKey("DefaultLinkPermission")) { $CurrentParameters.Remove("DefaultLinkPermission") }
            if ($CurrentParameters.ContainsKey("CompatibilityLevel")) { $CurrentParameters.Remove("CompatibilityLevel") }
            if ($CurrentParameters.ContainsKey("Template")) { $CurrentParameters.Remove("Template") }
            if ($CurrentParameters.ContainsKey("LocaleId")) { $CurrentParameters.Remove("LocaleId") }
            if ($CurrentParameters.ContainsKey("Url")) { $CurrentParameters.Remove("Url") }
            if ($CurrentParameters.ContainsKey("Owner")) { $CurrentParameters.Remove("Owner") }
            if ($CurrentParameters.ContainsKey("StorageQuota")) { $CurrentParameters.Remove("StorageQuota") }
            if ($CurrentParameters.ContainsKey("Title")) { $CurrentParameters.Remove("Title") }
            if ($CurrentParameters.ContainsKey("ResourceQuota")) { $CurrentParameters.Remove("ResourceQuota") }
            if ($CurrentParameters.ContainsKey("TimeZoneId")) { $CurrentParameters.Remove("TimeZoneId") }
            if ($CurrentParameters.ContainsKey("HubUrl")) { $CurrentParameters.Remove("HubUrl") }
            if ($CurrentParameters.ContainsKey("AnonymousLinkExpirationInDays")) { $CurrentParameters.Remove("AnonymousLinkExpirationInDays") }
            if ($CurrentParameters.ContainsKey("OverrideTenantAnonymousLinkExpirationPolicy")) { $CurrentParameters.Remove("OverrideTenantAnonymousLinkExpirationPolicy") }
            if ($CurrentParameters.Count -gt 0)
            {
                Set-SPOSite -Identity $Url @CurrentParameters -NoWait
            }
        }
        else
        {
            if ($PSBoundParameters.ContainsKey("HubUrl"))
            {
                if ($HubUrl -eq "")
                {
                    if ($site.HubSiteId -ne "00000000-0000-0000-0000-000000000000")
                    {
                        Remove-SPOHubSiteAssociation -Site $Url
                    }
                }
                else
                {
                    $hubSites = Get-SPOHubSite

                    $hubSite = $hubSites | Where-Object -FilterScript { $_.SiteUrl -eq $HubUrl }
                    if ($null -eq $hubSite)
                    {
                        throw ("Specified HubUrl ($HubUrl) is not a Hub site. Make sure you " + `
                                "have promoted that to a Hub site first.")
                    }

                    if ($site.HubSiteId -ne $hubSite.Id)
                    {
                        Add-SPOHubSiteAssociation -Site $Url -HubSite $HubUrl
                    }
                }
            }

            $CurrentParameters = $PSBoundParameters
            #Sites based on the GROUP#0 template should not be created via SharePoint but rather as part of an Office 365 group.
            #Once a site based on the GROUP#0 template has been created not all properties can be configured as they can be for other sitetemplates for that they will be removed
            if($CurrentParameters.Template -eq "GROUP#0")
            {
                if ($CurrentParameters.ContainsKey("Title")) { $CurrentParameters.Remove("Title") }
                if ($CurrentParameters.ContainsKey("CompatibilityLevel")) { $CurrentParameters.Remove("CompatibilityLevel") }
                if ($CurrentParameters.ContainsKey("LocaleId")) { $CurrentParameters.Remove("LocaleId") }
                if ($CurrentParameters.ContainsKey("Template")) { $CurrentParameters.Remove("Template") }
                if ($CurrentParameters.ContainsKey("TimeZoneId")) { $CurrentParameters.Remove("TimeZoneId") }
                if ($CurrentParameters.ContainsKey("CommentsOnSitePagesDisabled")) { $CurrentParameters.Remove("CommentsOnSitePagesDisabled") }
                if ($CurrentParameters.ContainsKey("DisableAppViews")) { $CurrentParameters.Remove("DisableAppViews") }
                if ($CurrentParameters.ContainsKey("DisableFlows")) { $CurrentParameters.Remove("DisableFlows") }
                if ($CurrentParameters.ContainsKey("RestrictedToGeo")) { $CurrentParameters.Remove("RestrictedToGeo") }
                if ($CurrentParameters.ContainsKey("SharingAllowedDomainList")) { $CurrentParameters.Remove("SharingAllowedDomainList") }
                if ($CurrentParameters.ContainsKey("SharingBlockedDomainList")) { $CurrentParameters.Remove("SharingBlockedDomainList") }
                if ($CurrentParameters.ContainsKey("SharingDomainRestrictionMode")) { $CurrentParameters.Remove("SharingDomainRestrictionMode") }
                if ($CurrentParameters.ContainsKey("HubUrl")) { $CurrentParameters.Remove("HubUrl") }
            }
            if ($CurrentParameters.SharingCapability -and $CurrentParameters.DenyAddAndCustomizePages)
            {
                Write-Warning -Message "Setting the DenyAddAndCustomizePages and the SharingCapability property via Set-SPOSite at the same time might cause the DenyAddAndCustomizePages property not to be configured as desired."
            }
            if ($CurrentParameters.StorageQuotaWarningLevel)
            {
                Write-Warning -Message "StorageQuotaWarningLevel can not be configured via Set-SPOSite"
            }
            if ($SharingDomainRestrictionMode -eq "")
            {
                Write-Verbose -Message "SharingDomainRestrictionMode is empty. For that SharingAllowedDomainList / SharingBlockedDomainList cannot be configured"
                if ($CurrentParameters.ContainsKey("ShareingAllowedDomainList")) { $CurrentParameters.Remove("SharingAllowedDomainList") }
                if ($CurrentParameters.ContainsKey("SharingBlockedDomainList")) { $CurrentParameters.Remove("SharingBlockedDomainList") }
            }
            if($SharingDomainRestrictionMode -eq "None")
            {
                Write-Verbose -Message "SharingDomainRestrictionMode is set to None. For that SharingAllowedDomainList / SharingBlockedDomainList cannot be configured"
                if ($CurrentParameters.ContainsKey("SharingAllowedDomainList")) { $CurrentParameters.Remove("SharingAllowedDomainList") }
                if ($CurrentParameters.ContainsKey("SharingBlockedDomainList")) { $CurrentParameters.Remove("SharingBlockedDomainList") }
            }
            elseif ($SharingDomainRestrictionMode -eq "AllowList")
            {
                Write-Verbose -Message "SharingDomainRestrictionMode is set to AllowList. For that SharingBlockedDomainList cannot be configured"
                if ($CurrentParameters.ContainsKey("SharingBlockedDomainList")) { $CurrentParameters.Remove("SharingBlockedDomainList") }
                if ($SharingAllowedDomainList -eq "")
                {
                    Write-Verbose -Message "No allowed domains specified. Not taking any action"
                    if ($CurrentParameters.ContainsKey("SharingAllowedDomainList")) { $CurrentParameters.Remove("SharingAllowedDomainList") }
                    if ($CurrentParameters.ContainsKey("SharingDomainRestrictionMode")) { $CurrentParameters.Remove("SharingDomainRestrictionMode") }
                }
            }
            elseif ($SharingDomainRestrictionMode -eq "BlockList")
            {
                Write-Verbose -Message "SharingDomainRestrictionMode is set to BlockList. For that SharingAllowedDomainList cannot be configured"
                if ($CurrentParameters.ContainsKey("SharingAllowedDomainList")) { $CurrentParameters.Remove("SharingAllowedDomainList") }
                if ($SharingBlockedDomainList -eq "")
                {
                    Write-Verbose -Message "No blocked domains specified. Not taking any action"
                    if ($CurrentParameters.ContainsKey("SharingBlockedDomainList")) { $CurrentParameters.Remove("SharingBlockedDomainList") }
                    if ($CurrentParameters.ContainsKey("SharingDomainRestrictionMode")) { $CurrentParameters.Remove("SharingDomainRestrictionMode") }
                }
            }
            if (($site.SharingCapability -ne "ExternalUserAndGuestSharing") -or ((Get-SPOTenant).SharingCapability -ne "ExternalUserAndGuestSharing") -and ($DefaultSharingLinkType -eq "AnonymousAccess"))
            {
                Write-Verbose -Message "Anonymous sharing has to be enabled in the SharingCapability on site and tenant level first before DefaultSharingLinkType can be set to Anonymous Access"
                if ($CurrentParameters.ContainsKey("DefaultSharingLinkType")) { $CurrentParameters.Remove("DefaultSharingLinkType") }
            }
            if ((Get-SPOTenant).showPeoplePickerSuggestionsForGuestUsers -eq $false)
            {
                Write-Verbose -Message "ShowPeoplePickerSuggestionsForGuestUsers for this site cannot be set since it is set to false on tenant level"
                if ($CurrentParameters.ContainsKey("showPeoplePickerSuggestionsForGuestUsers")) { $CurrentParameters.Remove("showPeoplePickerSuggestionsForGuestUsers") }
            }
            if($OverrideTenantAnonymousLinkExpirationPolicy -eq $false)
            {
                Write-Verbose -Message "As long as property <OverrideTenantAnonymousLinkExpirationPolicy> is set to false property <AnonymousLinkExpirationInDays> will not take any effect."
                #Write-Verbose -Message "If property <OverrideTenantAnonymousLinkExpirationPolicy> is set to false property <AnonymousLinkExpirationInDays> cannot be configured"
                #if ($CurrentParameters.ContainsKey("AnonymousLinkExpirationInDays")) { $CurrentParameters.Remove("AnonymousLinkExpirationInDays") }
                write-verbose -Message "$($OverrideTenantAnonymousLinkExpirationPolicy)"
                write-verbose -Message "$($AnonymousLinkExpirationInDays)"
            }
            if ($CurrentParameters.ContainsKey("GlobalAdminAccount")) { $CurrentParameters.Remove("GlobalAdminAccount") }
            if ($CurrentParameters.ContainsKey("Ensure")) { $CurrentParameters.Remove("Ensure") }
            if ($CurrentParameters.ContainsKey("Url")) { $CurrentParameters.Remove("Url") }
            if ($CurrentParameters.ContainsKey("CompatibilityLevel")) { $CurrentParameters.Remove("CompatibilityLevel") }
            if ($CurrentParameters.ContainsKey("Template")) { $CurrentParameters.Remove("Template") }
            if ($CurrentParameters.ContainsKey("LocaleId")) { $CurrentParameters.Remove("LocaleId") }
            if ($CurrentParameters.ContainsKey("HubUrl")) { $CurrentParameters.Remove("HubUrl") }
            if ($CurrentParameters.ContainsKey("IsSecondTry")) { $CurrentParameters.Remove("IsSecondTry") }
            if ($CurrentParameters.Count -gt 0)
            {
                Set-SPOSite -Identity $Url @CurrentParameters -NoWait
            }
        }
    }
    else
    {
        if($PSBoundParameters.Template -eq "GROUP#0")
        {
            throw "Group based sites (GROUP#0) should be created as part of an O365 group. Make sure to specify it as a configuration item"
        }
        else
        {
            Write-Verbose -Message "Creating site collection $Url"
            $siteCreation = @{
            Url                = $Url
            Owner              = $Owner
            StorageQuota       = $StorageQuota
            Title              = $Title
            CompatibilityLevel = $CompatibilityLevel
            LocaleId           = $LocaleId
            Template           = $Template
            }

            New-SPOSite @siteCreation

            if (-not $IsSecondTry)
            {
                $CurrentParameters4Config = $PSBoundParameters
                Set-SPOSiteConfiguration @CurrentParameters4Config -IsSecondTry $true
            }
            else
            {
                throw "There was an error trying to create SPOSite $Url"
            }
        }
        
    }
}
