function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Url,

        [Parameter()]
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
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration for site collection $Url"

    Test-SPOServiceConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount

    $nullReturn = @{
        Url                                         = $Url
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
        Ensure                                      = "Absent"
        GlobalAdminAccount                          = $GlobalAdminAccount
        CentralAdminUrl                             = $CentralAdminUrl
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
            $hubSites = Get-SPOHubSite

            $hubSite = $hubSites | Where-Object -FilterScript { $_.Id -eq $site.HubSiteId }
            if ($null -ne $hubSite)
            {
                $hubUrl = $hubSite.SiteUrl
            }
            else
            {
                throw "Cannot find Hub site with ID: $($site.HubSiteId)"
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
            GlobalAdminAccount                          = $GlobalAdminAccount
            CentralAdminUrl                             = $CentralAdminUrl
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

        [Parameter()]
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
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration for site collection $Url"

    Test-SPOServiceConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount

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
                        Write-Error $Message
                    }
                }
                catch
                {
                    $Message = "The site $($Url) does not exist in the deleted sites."
                    New-Office365DSCLogEntry -Error $_ -Message $Message
                    Write-Error $Message
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

        [Parameter()]
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
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration for site collection $Url"

    Test-SPOServiceConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount

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
                                                                   "DefaultLinkPermission",
                                                                   "HubUrl")

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
        $CentralAdminUrl,

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

        [Parameter()]
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
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    Test-SPOServiceConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount

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
            if ($CurrentParameters.ContainsKey("CentralAdminUrl")) { $null = $CurrentParameters.Remove("CentralAdminUrl") }
            if ($CurrentParameters.ContainsKey("GlobalAdminAccount")) { $null = $CurrentParameters.Remove("GlobalAdminAccount") }
            if ($CurrentParameters.ContainsKey("Ensure")) { $null = $CurrentParameters.Remove("Ensure") }
            if ($CurrentParameters.ContainsKey("AllowSelfServiceUpgrade")) { $null = $CurrentParameters.Remove("AllowSelfServiceUpgrade") }
            if ($CurrentParameters.ContainsKey("DenyAddAndCustomizePages")) { $null = $CurrentParameters.Remove("DenyAddAndCustomizePages") }
            if ($CurrentParameters.ContainsKey("ResourceQuotaWarningLevel")) { $null = $CurrentParameters.Remove("ResourceQuotaWarningLevel") }
            if ($CurrentParameters.ContainsKey("SharingCapability")) { $null = $CurrentParameters.Remove("SharingCapability") }
            if ($CurrentParameters.ContainsKey("StorageQuotaWarningLevel")) { $null = $CurrentParameters.Remove("StorageQuotaWarningLevel") }
            if ($CurrentParameters.ContainsKey("CommentsOnSitePagesDisabled")) { $null = $CurrentParameters.Remove("CommentsOnSitePagesDisabled") }
            if ($CurrentParameters.ContainsKey("SocialBarOnSitePagesDisabled")) { $null = $CurrentParameters.Remove("SocialBarOnSitePagesDisabled") }
            if ($CurrentParameters.ContainsKey("DisableAppViews")) { $null = $CurrentParameters.Remove("DisableAppViews") }
            if ($CurrentParameters.ContainsKey("DisableCompanyWideSharingLinks")) { $null = $CurrentParameters.Remove("DisableCompanyWideSharingLinks") }
            if ($CurrentParameters.ContainsKey("DisableFlows")) { $null = $CurrentParameters.Remove("DisableFlows") }
            if ($CurrentParameters.ContainsKey("RestrictedToGeo")) { $null = $CurrentParameters.Remove("RestrictedToGeo") }
            if ($CurrentParameters.ContainsKey("SharingAllowedDomainList")) { $null = $CurrentParameters.Remove("SharingAllowedDomainList") }
            if ($CurrentParameters.ContainsKey("SharingBlockedDomainList")) { $null = $CurrentParameters.Remove("SharingBlockedDomainList") }
            if ($CurrentParameters.ContainsKey("SharingDomainRestrictionMode")) { $null = $CurrentParameters.Remove("SharingDomainRestrictionMode") }
            if ($CurrentParameters.ContainsKey("ShowPeoplePickerSuggestionsForGuestUsers")) { $null = $CurrentParameters.Remove("ShowPeoplePickerSuggestionsForGuestUsers") }
            if ($CurrentParameters.ContainsKey("DefaultSharingLinkType")) { $null = $CurrentParameters.Remove("DefaultSharingLinkType") }
            if ($CurrentParameters.ContainsKey("DefaultLinkPermission")) { $null = $CurrentParameters.Remove("DefaultLinkPermission") }
            if ($CurrentParameters.ContainsKey("CompatibilityLevel")) { $null = $CurrentParameters.Remove("CompatibilityLevel") }
            if ($CurrentParameters.ContainsKey("Template")) { $null = $CurrentParameters.Remove("Template") }
            if ($CurrentParameters.ContainsKey("LocaleId")) { $null = $CurrentParameters.Remove("LocaleId") }
            if ($CurrentParameters.ContainsKey("Url")) { $null = $CurrentParameters.Remove("Url") }
            if ($CurrentParameters.ContainsKey("Owner")) { $null = $CurrentParameters.Remove("Owner") }
            if ($CurrentParameters.ContainsKey("StorageQuota")) { $null = $CurrentParameters.Remove("StorageQuota") }
            if ($CurrentParameters.ContainsKey("Title")) { $null = $CurrentParameters.Remove("Title") }
            if ($CurrentParameters.ContainsKey("ResourceQuota")) { $null = $CurrentParameters.Remove("ResourceQuota") }
            if ($CurrentParameters.ContainsKey("TimeZoneId")) { $null = $CurrentParameters.Remove("TimeZoneId") }
            if ($CurrentParameters.ContainsKey("HubUrl")) { $null = $CurrentParameters.Remove("HubUrl") }
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
                if ($CurrentParameters.ContainsKey("ShareingAllowedDomainList")) { $null = $CurrentParameters.Remove("SharingAllowedDomainList") }
                if ($CurrentParameters.ContainsKey("SharingBlockedDomainList")) { $null = $CurrentParameters.Remove("SharingBlockedDomainList") }
            }
            if($SharingDomainRestrictionMode -eq "None")
            {
                Write-Verbose -Message "SharingDomainRestrictionMode is set to None. For that SharingAllowedDomainList / SharingBlockedDomainList cannot be configured"
                if ($CurrentParameters.ContainsKey("SharingAllowedDomainList")) { $null = $CurrentParameters.Remove("SharingAllowedDomainList") }
                if ($CurrentParameters.ContainsKey("SharingBlockedDomainList")) { $null = $CurrentParameters.Remove("SharingBlockedDomainList") }
            }
            elseif ($SharingDomainRestrictionMode -eq "AllowList")
            {
                Write-Verbose -Message "SharingDomainRestrictionMode is set to AllowList. For that SharingBlockedDomainList cannot be configured"
                if ($CurrentParameters.ContainsKey("SharingBlockedDomainList")) { $null = $CurrentParameters.Remove("SharingBlockedDomainList") }
                if ($SharingAllowedDomainList -eq "")
                {
                    Write-Verbose -Message "No allowed domains specified. Not taking any action"
                    if ($CurrentParameters.ContainsKey("SharingAllowedDomainList")) { $null = $CurrentParameters.Remove("SharingAllowedDomainList") }
                    if ($CurrentParameters.ContainsKey("SharingDomainRestrictionMode")) { $null = $CurrentParameters.Remove("SharingDomainRestrictionMode") }
                }
            }
            elseif ($SharingDomainRestrictionMode -eq "BlockList")
            {
                Write-Verbose -Message "SharingDomainRestrictionMode is set to BlockList. For that SharingAllowedDomainList cannot be configured"
                if ($CurrentParameters.ContainsKey("SharingAllowedDomainList")) { $null = $CurrentParameters.Remove("SharingAllowedDomainList") }
                if ($SharingBlockedDomainList -eq "")
                {
                    Write-Verbose -Message "No blocked domains specified. Not taking any action"
                    if ($CurrentParameters.ContainsKey("SharingBlockedDomainList")) { $null = $CurrentParameters.Remove("SharingBlockedDomainList") }
                    if ($CurrentParameters.ContainsKey("SharingDomainRestrictionMode")) { $null = $CurrentParameters.Remove("SharingDomainRestrictionMode") }
                }
            }
            if (($site.SharingCapability -ne "ExternalUserAndGuestSharing") -or ((Get-SPOTenant).SharingCapability -ne "ExternalUserAndGuestSharing") -and ($DefaultSharingLinkType -eq "AnonymousAccess"))
            {
                Write-Verbose -Message "Anonymous sharing has to be enabled in the SharingCapability on site and tenant level first before DefaultSharingLinkType can be set to Anonymous Access"
                if ($CurrentParameters.ContainsKey("DefaultSharingLinkType")) { $null = $CurrentParameters.Remove("DefaultSharingLinkType") }
            }
            if ((Get-SPOTenant).showPeoplePickerSuggestionsForGuestUsers -eq $false)
            {
                Write-Verbose -Message "ShowPeoplePickerSuggestionsForGuestUsers for this site cannot be set since it is set to false on tenant level"
                if ($CurrentParameters.ContainsKey("showPeoplePickerSuggestionsForGuestUsers")) { $null = $CurrentParameters.Remove("showPeoplePickerSuggestionsForGuestUsers") }
            }
            if ($CurrentParameters.ContainsKey("CentralAdminUrl")) { $null = $CurrentParameters.Remove("CentralAdminUrl") }
            if ($CurrentParameters.ContainsKey("GlobalAdminAccount")) { $null = $CurrentParameters.Remove("GlobalAdminAccount") }
            if ($CurrentParameters.ContainsKey("Ensure")) { $null = $CurrentParameters.Remove("Ensure") }
            if ($CurrentParameters.ContainsKey("Url")) { $null = $CurrentParameters.Remove("Url") }
            if ($CurrentParameters.ContainsKey("CompatibilityLevel")) { $null = $CurrentParameters.Remove("CompatibilityLevel") }
            if ($CurrentParameters.ContainsKey("Template")) { $null = $CurrentParameters.Remove("Template") }
            if ($CurrentParameters.ContainsKey("LocaleId")) { $null = $CurrentParameters.Remove("LocaleId") }
            if ($CurrentParameters.ContainsKey("HubUrl")) { $null = $CurrentParameters.Remove("HubUrl") }
            if ($CurrentParameters.Count -gt 0)
            {
                Set-SPOSite -Identity $Url @CurrentParameters -NoWait
            }
        }
    }
    else
    {
        Write-Verbose -Message "Creating site collection $Url"
        $siteCreation = @{
            Url = $Url
            Owner = $Owner
            StorageQuota = $StorageQuota
            Title = $Title
            CompatibilityLevel = $CompatibilityLevel
            LocaleId = $LocaleId
            Template = $Template
        }
        New-SPOSite @siteCreation
        $CurrentParameters4Config = $PSBoundParameters
        Set-SPOSiteConfiguration @CurrentParameters4Config
    }
}
