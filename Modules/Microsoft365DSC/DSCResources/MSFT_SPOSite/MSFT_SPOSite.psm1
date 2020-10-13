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
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'PnP' `
                -InboundParameters $PSBoundParameters

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"

    try
    {
        Write-Verbose -Message "Getting site collection $Url"

        $site = Get-PnPTenantSite -Url $Url -ErrorAction 'SilentlyContinue'
        if ($null -eq $site)
        {
            Write-Verbose -Message "The specified Site Collection {$Url} doesn't exist."
            return $nullReturn
        }

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
            if ($null -ne $GlobalAdminAccount)
            {
                $siteOwnerEmail = $GlobalAdminAccount.UserName
            }
            else
            {
                try
                {
                    New-M365DSCConnection -Platform "AzureAD" `
                        -InboundParameters $PSBoundParameters | Out-Null
                    $app = Get-AzureADApplication -Filter "AppId eq '$ApplicationID'"
                    $owner = (Get-AzureADApplicationOwner -ObjectId $app.ObjectId)
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
            TimeZoneId                                  = $site.TimeZoneId
            HubUrl                                      = $CurrentHubUrl
            Classification                              = $site.Classification
            DisableFlows                                = $DisableFlowValue
            LogoFilePath                                = $LogoFilePath
            SharingCapability                           = $site.SharingCapabilities
            StorageMaximumLevel                         = $site.StorageMaximumLevel
            StorageWarningLevel                         = $site.StorageWarningLevel
            AllowSelfServiceUpgrade                     = $site.AllowSelfServiceUpgrade
            Owner                                       = $siteOwnerEmail
            CommentsOnSitePagesDisabled                 = $site.CommentsOnSitePagesDisabled
            DefaultLinkPermission                       = $site.DefaultLinkPermission
            DefaultSharingLinkType                      = $site.DefaultSharingLinkType
            DisableAppViews                             = $site.DisableAppViews
            DisableCompanyWideSharingLinks              = $site.DisableCompanyWideSharingLinks
            DisableSharingForNonOwners                  = $DisableSharingForNonOwners
            LocaleId                                    = $site.Lcid
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
            GlobalAdminAccount                          = $GlobalAdminAccount
            ApplicationId                               = $ApplicationId
            TenantId                                    = $TenantId
            CertificatePassword                         = $CertificatePassword
            CertificatePath                             = $CertificatePath
            CertificateThumbprint                       = $CertificateThumbprint
        }
    }
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
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
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'PnP' `
                -InboundParameters $PSBoundParameters

    $ConnectionParams = @{
        GlobalAdminAccount    = $GlobalAdminAccount
        ApplicationId         = $ApplicationId
        TenantId              = $TenantId
        CertificatePath       = $CertificatePath
        CertificatePassword   = $CertificatePassword
        CertificateThumbprint = $CertificateThumbprint
    }

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("Ensure") | Out-Null
    $CurrentParameters.Remove("GlobalAdminAccount") | Out-Null
    $CurrentParameters.Remove("ApplicationId") | Out-Null
    $CurrentParameters.Remove("TenantId") | Out-Null
    $CurrentParameters.Remove("CertificatePath") | Out-Null
    $CurrentParameters.Remove("CertificatePassword") | Out-Null
    $CurrentParameters.Remove("CertificateThumbprint") | Out-Null

    $context = Get-PnPContext
    if ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Absent')
    {
        $CreationParams = @{
            Title    = $Title
            Url      = $Url
            Template = $Template
            Owner    = $Owner
            Lcid     = $LocaleID
            TimeZone = $TimeZoneID
        }
        Write-Verbose -Message "Site {$Url} doesn't exist. Creating it."
        New-PnPTenantSite @CreationParams | Out-Null

        $site = $null
        $circuitBreaker = 0
        do
        {
            Write-Verbose -Message "Waiting for another 15 seconds for site to be ready."
            Start-Sleep -Seconds 15
            try
            {
                $site = Get-PnPTenantSite -Url $Url -ErrorAction Stop
            }
            catch
            {
                $site = @{Status = 'Creating' }
            }
            $circuitBreaker++
        } while ($site.Status -eq 'Creating' -and $circuitBreaker -lt 20)
        Write-Verbose -Message "Site {$url} has been successfully created and is {$($site.Status)}."
    }
    elseif ($Ensure -eq "Absent" -and $CurrentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing site {$Url}"
        try
        {
            Remove-PnPTenantSite -Url $Url -Confirm:$false -SkipRecycleBin -Force
        }
        catch
        {
            if ($Error[0].Exception.Message -eq "File Not Found")
            {
                $Message = "The site $($Url) does not exist."
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
        $UpdateParams = @{
            Url                            = $Url
            DisableFlows                   = $DisableFlowsValue
            SharingCapability              = $SharingCapability
            StorageMaximumLevel            = $StorageMaximumLevel
            StorageWarningLevel            = $StorageWarningLevel
            # Cannot be set, throws an error about Object not being in a valid state;
            #AllowSelfServiceUpgrade        = $AllowSelfServiceUpgrade
            Owners                         = $Owner
            CommentsOnSitePagesDisabled    = $CommentsOnSitePagesDisabled
            DefaultLinkPermission          = $DefaultLinkPermission
            DefaultSharingLinkType         = $DefaultSharingLinkType
            DisableAppViews                = $DisableAppViews
            DisableCompanyWideSharingLinks = $DisableCompanyWideSharingLinks
            #LCID Cannot be set after a Template has been applied;
            #LocaleId                       = $LocaleId
        }
        $UpdateParams = Remove-NullEntriesFromHashtable -Hash $UpdateParams

        Set-PnPTenantSite @UpdateParams -ErrorAction Stop

        $site = Get-PnpTenantSite $Url
        #region Ad-Hoc properties
        if (-not [System.String]::IsNullOrEmpty($DenyAddAndCustomizePages))
        {
            if ($DenyAddAndCustomizePages)
            {
                $site.DenyAddAndCustomizePages = 'Enabled'
            }
            else
            {
                $site.DenyAddAndCustomizePages = 'Disabled'
            }
        }

        if (-not [System.String]::IsNullOrEmpty($RestrictedToRegion))
        {
            $site.RestrictedToRegion = $RestrictedToRegion
        }

        if (-not [System.String]::IsNullOrEmpty($SocialBarOnSitePagesDisabled))
        {
            $site.SocialBarOnSitePagesDisabled = $SocialBarOnSitePagesDisabled
        }

        if (-not [System.String]::IsNullOrEmpty($SharingAllowedDomainList))
        {
            $site.SharingAllowedDomainList = $SharingAllowedDomainList
        }

        if (-not [System.String]::IsNullOrEmpty($SharingBlockedDomainList))
        {
            $site.SharingBlockedDomainList = $SharingBlockedDomainList
        }

        if (-not [System.String]::IsNullOrEmpty($SharingDomainRestrictionMode))
        {
            $site.SharingDomainRestrictionMode = $SharingDomainRestrictionMode
        }

        if (-not [System.String]::IsNullOrEmpty($AnonymousLinkExpirationInDays))
        {
            $site.AnonymousLinkExpirationInDays = $AnonymousLinkExpirationInDays
        }

        if (-not [System.String]::IsNullOrEmpty($OverrideTenantAnonymousLinkExpirationPolicy))
        {
            $site.OverrideTenantAnonymousLinkExpirationPolicy = $OverrideTenantAnonymousLinkExpirationPolicy
        }
        $site.Update() | Out-Null
        $context.ExecuteQuery()
        #endregion

        Write-Verbose -Message "Settings Updated"
        if ($PSBoundParameters.ContainsKey("HubUrl"))
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
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

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

    Write-Verbose -Message "Testing configuration for site collection $Url"
    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $CurrentValues.Remove("GlobalAdminAccount") | Out-Null
    $CurrentValues.Remove("ApplicationId") | Out-Null
    $CurrentValues.Remove("TenantId") | Out-Null
    $CurrentValues.Remove("CertificatePath") | Out-Null
    $CurrentValues.Remove("CertificatePassword") | Out-Null
    $CurrentValues.Remove("CertificateThumbprint") | Out-Null

    $keysToCheck = $CurrentValues.Keys
    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
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
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'PnP' `
                -InboundParameters $PSBoundParameters

    try
    {
        $sites = Get-PnPTenantSite -ErrorAction Stop | Where-Object -FilterScript { $_.Template -ne 'SRCHCEN#0' -and $_.Template -ne 'SPSMSITEHOST#0' }
        $organization = ""
        $principal = "" # Principal represents the "NetBios" name of the tenant (e.g. the M365DSC part of M365DSC.onmicrosoft.com)
        if ($null -ne $GlobalAdminAccount -and $GlobalAdminAccount.UserName.Contains("@"))
        {
            $organization = $GlobalAdminAccount.UserName.Split("@")[1]

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
        Write-Host "`r`n" -NoNewLine
        foreach ($site in $sites)
        {
            $site = Get-PnPTenantSite -Url $site.Url
            Write-Host "    [$i/$($sites.Length)] $($site.Url)" -NoNewLine
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
                CertificatePassword   = $CertificatePassword
                CertificatePath       = $CertificatePath
                CertificateThumbprint = $CertificateThumbprint
                GlobalAdminAccount    = $GlobalAdminAccount
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
                $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                            -Results $Results

                $partialContent = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                            -ConnectionMode $ConnectionMode `
                            -ModulePath $PSScriptRoot `
                            -Results $Results `
                            -GlobalAdminAccount $GlobalAdminAccount
                if ($partialContent.ToLower().Contains($organization.ToLower()) -or `
                $partialContent.ToLower().Contains($principal.ToLower()))
                {
                    $partialContent = $partialContent -ireplace [regex]::Escape('https://' + $principal + '.sharepoint.com/'), "https://`$(`$OrganizationName.Split('.')[0]).sharepoint.com/"
                    $partialContent = $partialContent -ireplace [regex]::Escape("@" + $organization), "@`$(`$OrganizationName)"
                }
                $dscContent += $partialContent
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
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
        return ""
    }
}

Export-ModuleMember -Function *-TargetResource
