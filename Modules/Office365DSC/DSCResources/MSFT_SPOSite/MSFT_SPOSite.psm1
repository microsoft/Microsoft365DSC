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
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-O365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
        -Platform PnP

    $nullReturn = @{
        Url                                         = $Url
        Owner                                       = $null
        TimeZoneId                                  = $null
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
        $site = Get-PnPTenantSite $Url
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
            $hubSites = Get-PnPHubSite

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
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-O365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
        -Platform PnP

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("Ensure") | Out-Null
    $CurrentParameters.Remove("GlobalAdminAccount") | Out-Null
    if ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Absent')
    {
        $CreationParams = @{
            Title                     = $Title
            Url                       = $Url
            Owner                     = $Owner
            TimeZone                  = $TimeZoneID
            Lcid                      = $LocaleID
            Template                  = $Template
            ResourceQuota             = $ResourceQuota
            ResourceQuotaWarningLevel = $ResourceQuatoWarningLevel
            StorageQuota              = $Storage
            StorageQuotaWarningLevel  = $StorageQuotaWarningLevel
        }
        Write-Verbose -Message "Site {$Url} doesn't exist. Creating it."
        New-PnPTenantSite @CreationParams

        $UpdateParams = @{
            Title                   = $Title
            Sharing                 = $SharingCapability
            StorageMaximumLevel     = $StorageQuota
            StorageWarningLevel     = $StorageQuotaWarningLevel
            UserCodeMaximumLevel    = $ResourceQuota
            UserCodeWarningLevel    = $ResourceQuotaWarningLevel
            AllowSelfServiceUpgrade = $AllowSelfServiceUpgrade
            Owners                  = $Owner
            NoScriptSite            = $DenyAddAndCustomizePages
            DefaultLinkPermission   = $DefaultLinkPermission
            DefaultSharingLinkType  = $DefaultSharingLinkType
        }
        Write-Verbose -Message "Updating settings on newly created site {$Url}"
        New-PnPTenantSite @CreationParams

        if (-not [System.String]::IsNullOrEmpty($HubUrl)])
        {
            Write-Verbose "Assigning newly created site {$Url} to Hub Site {$HubUrl}"
            $hubSite = Get-PnPHubSite -Identity $HubUrl

            if ($null -eq $hubSite)
            {
                throw ("Specified HubUrl ($HubUrl) is not a Hub site. Make sure you " + `
                    "have promoted that to a Hub site first.")
            }

            if ($site.HubSiteId -ne $hubSite.Id)
            {
                Add-PnPHubSiteAssociation -Site $Url -HubSite $HubUrl
            }
        }
    }
    elseif ($Ensure -eq "Present" -and $CurrentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Site {$Url} already exists, updating its settings"
        Set-PnPTenantSite @CurrentParameters

        if ($PSBoundParameters.ContainsKey("HubUrl"))
        {
            if ($HubUrl -eq "")
            {
                if ($site.HubSiteId -ne "00000000-0000-0000-0000-000000000000")
                {
                    Remove-PnPHubSiteAssociation -Site $Url
                }
            }
            else
            {
                $hubSite = Get-PnPHubSite -Identity $HubUrl

                if ($null -eq $hubSite)
                {
                    throw ("Specified HubUrl ($HubUrl) is not a Hub site. Make sure you " + `
                        "have promoted that to a Hub site first.")
                }

                if ($site.HubSiteId -ne $hubSite.Id)
                {
                    Add-PnPHubSiteAssociation -Site $Url -HubSite $HubUrl
                }
            }
        }
    }
    elseif ($Ensure -eq "Absent" -and $CurrentValues.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Removing site {$Url}"
        try
        {
            Remove-PnPTenantSite -Identity $Url -Confirm:$false -SkipRecycleBin
        }
        catch
        {
            if ($Error[0].Exception.Message -eq "File Not Found")
            {
                $Message = "The site $($Url) does not exist."
                New-Office365DSCLogEntry -Error $_ -Message $Message -Source $MyInvocation.MyCommand.ModuleName
                throw $Message
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

    $CurrentValues.Remove("GlobalAdminAccount") | Out-Null
    $keysToCheck = $CurrentValues.Keys
    $TestResult = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $keysToCheck

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
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $InformationPreference = 'Continue'
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-O365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform PnP

    $invalidTemplates = @("SRCHCEN#0", "GROUP#0", "SPSMSITEHOST#0", "POINTPUBLISHINGHUB#0", "POINTPUBLISHINGTOPIC#0")
    $sites = Get-PnPTenantSite | Where-Object -FilterScript { $_.Template -notin $invalidTemplates }

    $partialContent = ""
    $content = ''
    $i = 1
    $organization = ""
    $principal = "" # Principal represents the "NetBios" name of the tenant (e.g. the O365DSC part of O365DSC.onmicrosoft.com)
    if ($GlobalAdminAccount.UserName.Contains("@"))
    {
        $organization = $GlobalAdminAccount.UserName.Split("@")[1]

        if ($organization.IndexOf(".") -gt 0)
        {
            $principal = $organization.Split(".")[0]
        }
    }
    foreach ($site in $sites)
    {
        Write-Information "    - [$i/$($sites.Length)] $($site.Url)"
        $params = @{
            GlobalAdminAccount = $GlobalAdminAccount
            Url                = $site.Url
            Owner              = "Reverse"
        }
        $result = Get-TargetResource @params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        if ($result.RestrictedToGeo -eq "Unknown")
        {
            $result.Remove("RestrictedToGeo")
        }
        $result.Remove("HubUrl")
        $result = Remove-NullEntriesFromHashTable -Hash $result

        $content += "        SPOSite " + (New-GUID).ToString() + "`r`n"
        $content += "        {`r`n"
        $partialContent = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $partialContent = Convert-DSCStringParamToVariable -DSCBlock $partialContent -ParameterName "GlobalAdminAccount"
        if ($partialContent.ToLower().Contains($principal.ToLower() + ".sharepoint.com"))
        {
            $partialContent = $partialContent -ireplace [regex]::Escape($principal + ".sharepoint.com"), "`$(`$OrganizationName.Split('.')[0]).sharepoint.com"
        }
        if ($partialContent.ToLower().Contains("@" + $organization.ToLower()))
        {
            $partialContent = $partialContent -ireplace [regex]::Escape("@" + $organization), "@`$OrganizationName"
        }
        if ($partialContent.ToLower().Contains("@" + $principal.ToLower()))
        {
            $partialContent = $partialContent -ireplace [regex]::Escape("@" + $principal), "@`$OrganizationName.Split('.')[0])"
        }
        $content += $partialContent
        $content += "        }`r`n"
        $i++
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
