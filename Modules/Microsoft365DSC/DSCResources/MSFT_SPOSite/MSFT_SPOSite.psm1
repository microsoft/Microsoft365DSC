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
        $Title,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Owner,

        [Parameter(Mandatory = $true)]
        [System.UInt32]
        $TimeZoneId,

        [Parameter()]
        [System.String]
        $Template,

        [Parameter()]
        [System.String]
        $HubUrl,

        [Parameter()]
        [System.Boolean]
        $DisableFlows,

        [Parameter()]
        [System.String]
        [ValidateSet("Disabled", "ExistingExternalUserSharingOnly", "ExternalUserSharingOnly", "ExternalUserAndGuestSharing")]
        $SharingCapability,

        [Parameter()]
        [System.UInt32]
        $StorageMaximumLevel,

        [Parameter()]
        [System.UInt32]
        $StorageWarningLevel,

        [Parameter()]
        [System.Boolean]
        $AllowSelfServiceUpgrade,

        [Parameter()]
        [System.Boolean]
        $CommentsOnSitePagesDisabled,

        [Parameter()]
        [System.String]
        [ValidateSet("None", "View", "Edit")]
        $DefaultLinkPermission,

        [Parameter()]
        [System.String]
        [ValidateSet("None", "AnonymousAccess", "Internal", "Direct")]
        $DefaultSharingLinkType,

        [Parameter()]
        [System.String]
        [ValidateSet("Unknown", "Disabled", "NotDisabled")]
        $DisableAppViews,

        [Parameter()]
        [System.String]
        [ValidateSet("Unknown", "Disabled", "NotDisabled")]
        $DisableCompanyWideSharingLinks,

        [Parameter()]
        [System.UInt32]
        $LocaleId,

        [Parameter()]
        [System.Boolean]
        $DenyAddAndCustomizePages,

        [Parameter()]
        [System.boolean]
        $SocialBarOnSitePagesDisabled,

        [Parameter()]
        [System.String]
        [ValidateSet("NoRestriction", "BlockMoveOnly", "BlockFull", "Unknown")]
        $RestrictedToRegion,

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
        [System.UInt32]
        $AnonymousLinkExpirationInDays,

        [Parameter()]
        [System.Boolean]
        $OverrideTenantAnonymousLinkExpirationPolicy,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'PnP' `
        -InboundParameters $PSBoundParameters

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"

    try
    {
        Write-Verbose -Message "Getting site collection $Url"

        $site = Get-PnPTenantSite -Identity $Url -ErrorAction 'SilentlyContinue'
        if ($null -eq $site)
        {
            Write-Verbose -Message "The specified Site Collection {$Url} doesn't exist."
            return $nullReturn
        }

        $web = Get-PnPWeb -Includes RegionalSettings.TimeZone

        $CurrentHubUrl = $null
        if ($null -ne $site.HubSiteId -and $site.HubSiteId -ne '00000000-0000-0000-0000-000000000000')
        {
            $hubId = $site.HubSiteId
            Write-Verbose -Message "Site {$Url} is associated with HubSite {$hubId}"
            $hubSite = Get-PnPHubSite | Where-Object -FilterScript { $_.ID -eq $hubId }

            if ($null -ne $hubSite)
            {
                $CurrentHubUrl = $hubSite.SiteUrl
                Write-Verbose -Message "Found {$Url} hub association with {$CurrentHubUrl}"
            }
            else
            {
                Write-Warning "The site {$Url} is associated with Hub Site {$hubId} which no longer exists."
            }
        }

        $DisableFlowValue = $true
        if ($site.DisableFlows -eq 'NotDisabled')
        {
            $DisableFlowValue = $false
        }

        $DenyAddAndCustomizePagesValue = $true
        if ($site.DenyAddAndCustomizePagesValue -eq 'Enabled')
        {
            $DenyAddAndCustomizePagesValue = $false
        }

        $siteOwnerEmail = $site.OwnerEmail
        if ([System.String]::IsNullOrEmpty($siteOwnerEmail))
        {
            if ($null -ne $Credential)
            {
                $siteOwnerEmail = $Credential.UserName
            }
            else
            {
                try
                {
                    New-M365DSCConnection -Workload "MicrosoftGraph" `
                        -InboundParameters $PSBoundParameters | Out-Null
                    $app = Get-MgApplication -Filter "AppId eq '$ApplicationID'"
                    $owner = (Get-MgApplicationOwner -ApplicationId $app.ObjectId)
                    $siteOwnerEmail = $owner.UserPrincipalName
                }
                catch
                {
                    New-M365DSCLogEntry -Error $_ `
                        -Message "Could not obtain owner for SPOSite {$Url}" `
                        -Source $MyInvocation.MyCommand.ModuleName
                    Write-Verbose -Message "Could not obtain owner for SPOSite {$Url}"
                }
            }
        }
        return @{
            Url                                         = $Url
            Title                                       = $site.Title
            Template                                    = $site.Template
            TimeZoneId                                  = $web.RegionalSettings.TimeZone.Id
            HubUrl                                      = $CurrentHubUrl
            Classification                              = $site.Classification
            DisableFlows                                = $DisableFlowValue
            LogoFilePath                                = $LogoFilePath
            SharingCapability                           = $site.SharingCapability
            StorageMaximumLevel                         = $site.StorageQuota
            StorageWarningLevel                         = $site.StorageQuotaWarningLevel
            AllowSelfServiceUpgrade                     = $site.AllowSelfServiceUpgrade
            Owner                                       = $siteOwnerEmail
            CommentsOnSitePagesDisabled                 = $site.CommentsOnSitePagesDisabled
            DefaultLinkPermission                       = $site.DefaultLinkPermission
            DefaultSharingLinkType                      = $site.DefaultSharingLinkType
            DisableAppViews                             = $site.DisableAppViews
            DisableCompanyWideSharingLinks              = $site.DisableCompanyWideSharingLinks
            DisableSharingForNonOwners                  = $DisableSharingForNonOwners
            LocaleId                                    = $site.LocaleId
            RestrictedToRegion                          = $RestrictedToRegion
            SocialBarOnSitePagesDisabled                = $SocialBarOnSitePagesDisabled
            SiteDesign                                  = $SiteDesign
            DenyAddAndCustomizePages                    = $DenyAddAndCustomizePagesValue
            SharingAllowedDomainList                    = $SharingAllowedDomainList
            SharingBlockedDomainList                    = $SharingBlockedDomainList
            SharingDomainRestrictionMode                = $SharingDomainRestrictionMode
            ShowPeoplePickerSuggestionsForGuestUsers    = $ShowPeoplePickerSuggestionsForGuestUsers
            AnonymousLinkExpirationInDays               = $AnonymousLinkExpirationInDays
            OverrideTenantAnonymousLinkExpirationPolicy = $OverrideTenantAnonymousLinkExpirationPolicy
            Ensure                                      = 'Present'
            Credential                          = $Credential
            ApplicationId                               = $ApplicationId
            TenantId                                    = $TenantId
            ApplicationSecret                           = $ApplicationSecret
            CertificatePassword                         = $CertificatePassword
            CertificatePath                             = $CertificatePath
            CertificateThumbprint                       = $CertificateThumbprint
        }
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
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
        $Title,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Owner,

        [Parameter(Mandatory = $true)]
        [System.UInt32]
        $TimeZoneId,

        [Parameter()]
        [System.String]
        $Template,

        [Parameter()]
        [System.String]
        $HubUrl,

        [Parameter()]
        [System.Boolean]
        $DisableFlows,

        [Parameter()]
        [System.String]
        [ValidateSet("Disabled", "ExistingExternalUserSharingOnly", "ExternalUserSharingOnly", "ExternalUserAndGuestSharing")]
        $SharingCapability,

        [Parameter()]
        [System.UInt32]
        $StorageMaximumLevel,

        [Parameter()]
        [System.UInt32]
        $StorageWarningLevel,

        [Parameter()]
        [System.Boolean]
        $AllowSelfServiceUpgrade,

        [Parameter()]
        [System.Boolean]
        $CommentsOnSitePagesDisabled,

        [Parameter()]
        [System.String]
        [ValidateSet("None", "View", "Edit")]
        $DefaultLinkPermission,

        [Parameter()]
        [System.String]
        [ValidateSet("None", "AnonymousAccess", "Internal", "Direct")]
        $DefaultSharingLinkType,

        [Parameter()]
        [System.String]
        [ValidateSet("Unknown", "Disabled", "NotDisabled")]
        $DisableAppViews,

        [Parameter()]
        [System.String]
        [ValidateSet("Unknown", "Disabled", "NotDisabled")]
        $DisableCompanyWideSharingLinks,

        [Parameter()]
        [System.UInt32]
        $LocaleId,

        [Parameter()]
        [System.Boolean]
        $DenyAddAndCustomizePages,

        [Parameter()]
        [System.boolean]
        $SocialBarOnSitePagesDisabled,

        [Parameter()]
        [System.String]
        [ValidateSet("NoRestriction", "BlockMoveOnly", "BlockFull", "Unknown")]
        $RestrictedToRegion,

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
        [System.UInt32]
        $AnonymousLinkExpirationInDays,

        [Parameter()]
        [System.Boolean]
        $OverrideTenantAnonymousLinkExpirationPolicy,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Setting configuration for site collection $Url"

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Workload 'PnP' `
        -InboundParameters $PSBoundParameters

    $CurrentValues = Get-TargetResource @PSBoundParameters

    $context = Get-PnPContext
    if ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Site {$Url} doesn't exist. Creating it."

        $CreationParams = @{
            Title    = $Title
            Url      = $Url
            Template = $Template
            Owner    = $Owner
            Lcid     = $LocaleID
            TimeZone = $TimeZoneID
        }

        $supportedLanguages = (Get-PnPAvailableLanguage).Lcid
        if ($supportedLanguages -notcontains $CreationParams.Lcid)
        {
            Write-Verbose -Message ("Specified LocaleId {$($CreationParams.Lcid)} " + `
                    "is not supported. Creating the site collection in English {1033}")
            $CreationParams.Lcid = 1033
        }

        try
        {
            New-PnPTenantSite @CreationParams -ErrorAction Stop | Out-Null

            $site = $null
            $circuitBreaker = 0
            do
            {
                Write-Verbose -Message "Waiting for another 15 seconds for site to be ready."
                Start-Sleep -Seconds 15
                try
                {
                    $site = Get-PnPTenantSite -Identity $Url -ErrorAction Stop
                }
                catch
                {
                    $site = @{Status = 'Creating' }
                }
                $circuitBreaker++
            } while ($site.Status -eq 'Creating' -and $circuitBreaker -lt 20)

            Write-Verbose -Message "Site {$url} has been successfully created and is {$($site.Status)}."
        }
        catch
        {
            $Message = "Creation of the site $($Url) failed: $($_.Exception.Message)"
            Add-M365DSCEvent -Message $Message -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
            throw $Message
        }
    }
    elseif ($Ensure -eq "Absent" -and $CurrentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing site {$Url}"
        try
        {
            Remove-PnPTenantSite -Url $Url -SkipRecycleBin -Force
        }
        catch
        {
            if ($Error[0].Exception.Message -eq "File Not Found")
            {
                $Message = "The site $($Url) does not exist."
                New-M365DSCLogEntry -Error $_ -Message $Message -Source $MyInvocation.MyCommand.ModuleName
                throw $Message
            }
            if ($Error[0].Exception.Message -eq "This site belongs to a Microsoft 365 group. To delete the site, you must delete the group.")
            {
                $Message = "This site $($Url) belongs to a Microsoft 365 group. To delete the site, you must delete the group."
                New-M365DSCLogEntry -Error $_ -Message $Message -Source $MyInvocation.MyCommand.ModuleName
                throw $Message
            }
        }
    }
    if ($Ensure -ne 'Absent')
    {
        Write-Verbose -Message "Site {$Url} already exists, updating its settings"

        $DisableFlowsValue = 'NotDisabled'
        if ($DisableFlows)
        {
            $DisableFlowsValue = 'Disabled'
        }
        #region Ad-Hoc properties
        if (-not [System.String]::IsNullOrEmpty($DenyAddAndCustomizePages))
        {
            if ($DenyAddAndCustomizePages)
            {
                $deny = $True
            }
            else
            {
                $deny = $False
            }
        }
        $UpdateParams = @{
            Url                                         = $Url
            DisableFlows                                = $DisableFlowsValue
            SharingCapability                           = $SharingCapability
            StorageMaximumLevel                         = $StorageMaximumLevel
            StorageWarningLevel                         = $StorageWarningLevel
            # Cannot be set, throws an error about Object not being in a valid state;
            #AllowSelfServiceUpgrade        = $AllowSelfServiceUpgrade
            Owners                                      = $Owner
            CommentsOnSitePagesDisabled                 = $CommentsOnSitePagesDisabled
            DefaultLinkPermission                       = $DefaultLinkPermission
            DefaultSharingLinkType                      = $DefaultSharingLinkType
            DisableAppViews                             = $DisableAppViews
            DisableCompanyWideSharingLinks              = $DisableCompanyWideSharingLinks
            #LCID Cannot be set after a Template has been applied;
            #LocaleId                       = $LocaleId
            RestrictedToRegion                          = $RestrictedToRegion
            #SocialBarOnSitePagesDisabled                = $SocialBarOnSitePagesDisabled
            SharingAllowedDomainList                    = $SharingAllowedDomainList
            SharingBlockedDomainList                    = $SharingBlockedDomainList
            SharingDomainRestrictionMode                = $SharingDomainRestrictionMode
            AnonymousLinkExpirationInDays               = $AnonymousLinkExpirationInDays
            OverrideTenantAnonymousLinkExpirationPolicy = $OverrideTenantAnonymousLinkExpirationPolicy
            DenyAddAndCustomizePages                    = $deny
        }
        $UpdateParams = Remove-NullEntriesFromHashtable -Hash $UpdateParams

        $UpdateParams.Add("StorageQuota", $StorageMaximumLevel)
        $UpdateParams.Remove("StorageMaximumLevel") | Out-Null
        $UpdateParams.Add("StorageQuotaWarningLevel", $StorageWarningLevel)
        $UpdateParams.Remove("StorageWarningLevel") | Out-Null
        $UpdateParams.Add("Identity", $Url)
        $UpdateParams.Remove("Url") | Out-Null

        Set-PnPTenantSite @UpdateParams -ErrorAction Stop

        $UpdateParams = @{}
        $UpdateParams = @{
            SocialBarOnSitePagesDisabled = $SocialBarOnSitePagesDisabled
        }
        $UpdateParams = Remove-NullEntriesFromHashtable -Hash $UpdateParams

        if ($UpdateParams)
        {
            $ConnectionMode = New-M365DSCConnection -Workload 'PnP' `
                -InboundParameters $PSBoundParameters `
                -Url $Url
            Write-Verbose -Message "Updating props via Set-PNPSite on $($Url)"
            Set-PnPSite @UpdateParams -ErrorAction Stop
        }


        $site = Get-PnPTenantSite $Url

        if (-not [System.String]::IsNullOrEmpty($LocaleId) -and `
                $PSBoundParameters.LocaleId -ne $site.Lcid)
        {
            Write-Verbose -Message "Updating LocaleId of RootWeb to $($PSBoundParameters.LocaleId)"
            $ConnectionMode = New-M365DSCConnection -Workload 'PnP' `
                -InboundParameters $PSBoundParameters `
                -Url $Url

            $web = Get-PnPWeb
            $ctx = Get-PnPContext
            $ctx.Load($web.RegionalSettings)
            $ctx.ExecuteQuery()
            $web.RegionalSettings.LocaleId = $PSBoundParameters.LocaleId
            $web.Update()
            $ctx.ExecuteQuery()
        }

        Write-Verbose -Message "Settings Updated"
        if ($PSBoundParameters.ContainsKey("HubUrl"))
        {
            if ($PSBoundParameters.HubUrl.TrimEnd("/") -ne $PSBoundParameters.Url.TrimEnd("/"))
            {
                if ([System.String]::IsNullOrEmpty($HubUrl))
                {
                    if ($site.HubSiteId -ne "00000000-0000-0000-0000-000000000000")
                    {
                        Write-Verbose -Message "Removing Hub Site Association for {$Url}"
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
                        Write-Verbose -Message "Adding Hub Association on {$HubUrl} for site {$Url}"
                        Add-PnPHubSiteAssociation -Site $Url -HubSite $HubUrl
                    }
                }
            }
            else
            {
                Write-Verbose -Message ("Ignoring the HubUrl parameter because it is equal to " + `
                        "the site collection Url")
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
        $Title,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Owner,

        [Parameter(Mandatory = $true)]
        [System.UInt32]
        $TimeZoneId,

        [Parameter()]
        [System.String]
        $Template,

        [Parameter()]
        [System.String]
        $HubUrl,

        [Parameter()]
        [System.Boolean]
        $DisableFlows,

        [Parameter()]
        [System.String]
        [ValidateSet("Disabled", "ExistingExternalUserSharingOnly", "ExternalUserSharingOnly", "ExternalUserAndGuestSharing")]
        $SharingCapability,

        [Parameter()]
        [System.UInt32]
        $StorageMaximumLevel,

        [Parameter()]
        [System.UInt32]
        $StorageWarningLevel,

        [Parameter()]
        [System.Boolean]
        $AllowSelfServiceUpgrade,

        [Parameter()]
        [System.Boolean]
        $CommentsOnSitePagesDisabled,

        [Parameter()]
        [System.String]
        [ValidateSet("None", "View", "Edit")]
        $DefaultLinkPermission,

        [Parameter()]
        [System.String]
        [ValidateSet("None", "AnonymousAccess", "Internal", "Direct")]
        $DefaultSharingLinkType,

        [Parameter()]
        [System.String]
        [ValidateSet("Unknown", "Disabled", "NotDisabled")]
        $DisableAppViews,

        [Parameter()]
        [System.String]
        [ValidateSet("Unknown", "Disabled", "NotDisabled")]
        $DisableCompanyWideSharingLinks,

        [Parameter()]
        [System.UInt32]
        $LocaleId,

        [Parameter()]
        [System.Boolean]
        $DenyAddAndCustomizePages,

        [Parameter()]
        [System.boolean]
        $SocialBarOnSitePagesDisabled,

        [Parameter()]
        [System.String]
        [ValidateSet("NoRestriction", "BlockMoveOnly", "BlockFull", "Unknown")]
        $RestrictedToRegion,

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
        [System.UInt32]
        $AnonymousLinkExpirationInDays,

        [Parameter()]
        [System.Boolean]
        $OverrideTenantAnonymousLinkExpirationPolicy,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration for site collection $Url"
    $CurrentValues = Get-TargetResource @PSBoundParameters

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove("ApplicationId") | Out-Null
    $ValuesToCheck.Remove("TenantId") | Out-Null
    $ValuesToCheck.Remove("CertificatePath") | Out-Null
    $ValuesToCheck.Remove("CertificatePassword") | Out-Null
    $ValuesToCheck.Remove("CertificateThumbprint") | Out-Null
    $ValuesToCheck.Remove("ApplicationSecret") | Out-Null

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    Write-Verbose -Message "Test-TargetResource returned $TestResult"

    return $TestResult
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    try
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'PnP' `
            -InboundParameters $PSBoundParameters

        #region Telemetry
        $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
        $CommandName  = $MyInvocation.MyCommand
        $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
            -CommandName $CommandName `
            -Parameters $PSBoundParameters
        Add-M365DSCTelemetryEvent -Data $data
        #endregion

        $sites = Get-PnPTenantSite -ErrorAction Stop | Where-Object -FilterScript { $_.Template -ne 'SRCHCEN#0' -and $_.Template -ne 'SPSMSITEHOST#0' }
        $organization = ""
        $principal = "" # Principal represents the "NetBios" name of the tenant (e.g. the M365DSC part of M365DSC.onmicrosoft.com)
        if ($null -ne $Credential -and $Credential.UserName.Contains("@"))
        {
            $organization = $Credential.UserName.Split("@")[1]

            if ($organization.IndexOf(".") -gt 0)
            {
                $principal = $organization.Split(".")[0]
            }
        }
        else
        {
            $organization = $TenantId
            $principal = $organization.Split(".")[0]
        }
        $dscContent = ''
        $i = 1
        Write-Host "`r`n" -NoNewline
        foreach ($site in $sites)
        {
            Write-Host "    [$i/$($sites.Length)] $($site.Url)" -NoNewline
            $site = Get-PnPTenantSite -Identity $site.Url
            $siteTitle = "Null"
            if (-not [System.String]::IsNullOrEmpty($site.Title))
            {
                $siteTitle = $site.Title
            }

            $Params = @{
                Url                   = $site.Url
                Template              = $site.Template
                Owner                 = "admin@contoso.com" # Passing in bogus value to bypass null owner error
                Title                 = $siteTitle
                TimeZoneId            = $site.TimeZoneID
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificatePassword   = $CertificatePassword
                CertificatePath       = $CertificatePath
                CertificateThumbprint = $CertificateThumbprint
                Credential    = $Credential
            }

            try
            {
                $Results = Get-TargetResource @Params

                if ([System.String]::IsNullOrEmpty($Results.SharingDomainRestrictionMode))
                {
                    $Results.Remove("SharingDomainRestrictionMode") | Out-Null
                }
                if ([System.String]::IsNullOrEmpty($Results.RestrictedToRegion))
                {
                    $Results.Remove("RestrictedToRegion") | Out-Null
                }
                if ([System.String]::IsNullOrEmpty($Results.SharingAllowedDomainList))
                {
                    $Results.Remove("SharingAllowedDomainList") | Out-Null
                }
                if ([System.String]::IsNullOrEmpty($Results.SharingBlockedDomainList))
                {
                    $Results.Remove("SharingBlockedDomainList") | Out-Null
                }
                # Removing the HubUrl parameter if the value is equal to the Url parameter.
                # This to prevent issues if the site col has just been created and not yet
                # configured as a hubsite.
                if ([System.String]::IsNullOrEmpty($Results.HubUrl) -or `
                    ($Results.Url.TrimEnd("/") -eq $Results.HubUrl.TrimEnd("/")))
                {
                    $Results.Remove("HubUrl") | Out-Null
                }

                $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                    -Results $Results

                $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -Credential $Credential
                if ($currentDSCBlock.ToLower().Contains($organization.ToLower()) -or `
                        $currentDSCBlock.ToLower().Contains($principal.ToLower()))
                {
                    $currentDSCBlock = $currentDSCBlock -ireplace [regex]::Escape('https://' + $principal + '.sharepoint.com/'), "https://`$(`$OrganizationName.Split('.')[0]).sharepoint.com/"
                    $currentDSCBlock = $currentDSCBlock -ireplace [regex]::Escape("@" + $organization), "@`$(`$OrganizationName)"
                }
                $dscContent += $currentDSCBlock
                Save-M365DSCPartialExport -Content $currentDSCBlock `
                    -FileName $Global:PartialExportFileName
                Write-Host $Global:M365DSCEmojiGreenCheckMark
            }
            catch
            {
                Write-Host "$($Global:M365DSCEmojiYellowCircle) $_"
            }
            $i++
        }
        return $dscContent
    }
    catch
    {
        Write-Host $Global:M365DSCEmojiRedX
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return ""
    }
}

Export-ModuleMember -Function *-TargetResource
