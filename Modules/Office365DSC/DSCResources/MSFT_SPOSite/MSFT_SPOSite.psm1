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
        [System.UInt32]
        $TimeZoneId,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('CommunicationSite', 'TeamSite')]
        $Type,

        [Parameter()]
        [System.String]
        $HubUrl,

        [Parameter()]
        [System.String]
        $Classification,

        [Parameter()]
        [System.Boolean]
        $DisableFlows,

        [Parameter()]
        [System.String]
        $LogoFilePath,

        [Parameter()]
        [System.String]
        [ValidateSet("Disabled", "ExistingExternalUserSharingOnly", "ExternalUserSharingOnly", "ExternalUserAndGuestSharing")]
        $Sharing,

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
        [System.String]
        $Owner,

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
        [System.Boolean]
        $DisableSharingForNonOwners,

        [Parameter()]
        [System.UInt32]
        $LocaleId,

        [Parameter()]
        [System.String]
        [ValidateSet("NoRestriction", "BlockMoveOnly", "BlockFull", "Unknown")]
        $RestrictedToGeo,

        [Parameter()]
        [System.Boolean]
        $SocialBarOnSitePagesDisabled,

        [Parameter()]
        [System.String]
        $SiteDesign,

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
        Url                = $Url
        Title              = $Title
        Type               = $Type
        Ensure             = "Absent"
        GlobalAdminAccount = $GlobalAdminAccount
    }

    try
    {
        Write-Verbose -Message "Getting site collection $Url"

        $site = Get-PnPTenantSite -Url $Url
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
            $hubSite = Get-PnPHubSite -Identity $hubId

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

        return @{
            Url                            = $Url
            Title                          = $site.Title
            Type                           = $Type
            TimeZoneId                     = $site.TimeZoneId
            HubUrl                         = $CurrentHubUrl
            Classification                 = $site.Classification
            DisableFlows                   = $DisableFlowValue
            LogoFilePath                   = $LogoFilePath
            Sharing                        = $site.SharingCapabilities
            StorageMaximumLevel            = $site.StorageMaximumLevel
            StorageWarningLevel            = $site.StorageWarningLevel
            AllowSelfServiceUpgrade        = $site.AllowSelfServiceUpgrade
            Owner                          = $site.Owner
            CommentsOnSitePagesDisabled    = $site.CommentsOnSitePagesDisabled
            DefaultLinkPermission          = $site.DefaultLinkPermission
            DefaultSharingLinkType         = $site.DefaultSharingLinkType
            DisableAppViews                = $site.DisableAppViews
            DisableCompanyWideSharingLinks = $site.DisableCompanyWideSharingLinks
            DisableSharingForNonOwners     = $DisableSharingForNonOwners
            LocaleId                       = $site.Lcid
            RestrictedToGeo                = $site.RestrictedToRegion
            SocialBarOnSitePagesDisabled   = $site.SocialBarOnSitePagesDisabled
            SiteDesign                     = $SiteDesign
            Ensure                         = 'Present'
            GlobalAdminAccount             = $GlobalAdminAccount
        }
    }
    catch
    {
        Write-Verbose -Message "The specified Site Collection {$Url} doesn't exist."
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
        [System.UInt32]
        $TimeZoneId,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('CommunicationSite', 'TeamSite')]
        $Type,

        [Parameter()]
        [System.String]
        $HubUrl,

        [Parameter()]
        [System.String]
        $Classification,

        [Parameter()]
        [System.Boolean]
        $DisableFlows,

        [Parameter()]
        [System.String]
        $LogoFilePath,

        [Parameter()]
        [System.String]
        [ValidateSet("Disabled", "ExistingExternalUserSharingOnly", "ExternalUserSharingOnly", "ExternalUserAndGuestSharing")]
        $Sharing,

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
        [System.String]
        $Owner,

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
        [System.Boolean]
        $DisableSharingForNonOwners,

        [Parameter()]
        [System.UInt32]
        $LocaleId,

        [Parameter()]
        [System.String]
        [ValidateSet("NoRestriction", "BlockMoveOnly", "BlockFull", "Unknown")]
        $RestrictedToGeo,

        [Parameter()]
        [System.Boolean]
        $SocialBarOnSitePagesDisabled,

        [Parameter()]
        [System.String]
        $SiteDesign,

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

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform PnP

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("Ensure") | Out-Null
    $CurrentParameters.Remove("GlobalAdminAccount") | Out-Null
    if ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Absent')
    {
        $TemplateValue = "GROUP#0"
        if ($Type -eq 'CommunicationSite')
        {
            $TemplateValue = "SITEPAGEPUBLISHING#0"
        }
        $CreationParams = @{
            Title          = $Title
            Url            = $Url
            Template       = $TemplateValue
            Owner          = $Owner
            Lcid           = $LocaleID
            TimeZone       = $TimeZoneID
        }
        Write-Verbose -Message "Site {$Url} doesn't exist. Creating it."
        New-PnPTenantSite @CreationParams | Out-Null
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
                New-Office365DSCLogEntry -Error $_ -Message $Message -Source $MyInvocation.MyCommand.ModuleName
                throw $Message
            }
        }
    }
    if ($Ensure -ne 'Absent')
    {
        Write-Verbose -Message "Site {$Url} already exists, updating its settings"

        Test-MSCloudLogin -CloudCredential $GlobalAdminAccount -Platform PnP -ConnectionUrl $Url
        $UpdateParams = @{
            Classification                 = $Classification
            DisableFlows                   = $DisableFlows
            LogoFilePath                   = $LogoFilePath
            Sharing                        = $Sharing
            StorageMaximumLevel            = $StorageMaximumLevel
            StorageWarningLevel            = $StorageWarningLevel
            AllowSelfServiceUpgrade        = $AllowSelfServiceUpgrade
            Owners                         = $Owner
            CommentsOnSitePagesDisabled    = $CommentsOnSitePagesDisabled
            DefaultLinkPermission          = $DefaultLinkPermission
            DefaultSharingLinkType         = $DefaultSharingLinkType
            DisableAppViews                = $DisableAppViews
            DisableCompanyWideSharingLinks = $DisableCompanyWideSharingLinks
            DisableSharingForNonOwners     = $DisableSharingForNonOwners
            LocaleId                       = $LocaleId
            RestrictedToGeo                = $RestrictedToGeo
            SocialBarOnSitePagesDisabled   = $SocialBarOnSitePagesDisabled
        }

        $UpdateParams = Remove-NullEntriesFromHashtable -Hash $UpdateParams

        Set-PnPSite @UpdateParams
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
        [System.UInt32]
        $TimeZoneId,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('CommunicationSite', 'TeamSite')]
        $Type,

        [Parameter()]
        [System.String]
        $HubUrl,

        [Parameter()]
        [System.String]
        $Classification,

        [Parameter()]
        [System.Boolean]
        $DisableFlows,

        [Parameter()]
        [System.String]
        $LogoFilePath,

        [Parameter()]
        [System.String]
        [ValidateSet("Disabled", "ExistingExternalUserSharingOnly", "ExternalUserSharingOnly", "ExternalUserAndGuestSharing")]
        $Sharing,

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
        [System.String]
        $Owner,

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
        [System.Boolean]
        $DisableSharingForNonOwners,

        [Parameter()]
        [System.UInt32]
        $LocaleId,

        [Parameter()]
        [System.String]
        [ValidateSet("NoRestriction", "BlockMoveOnly", "BlockFull", "Unknown")]
        $RestrictedToGeo,

        [Parameter()]
        [System.Boolean]
        $SocialBarOnSitePagesDisabled,

        [Parameter()]
        [System.String]
        $SiteDesign,

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

    $sites = Get-PnPTenantSite

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
        $Type = "CommunicationSite"
        if ($site.Template -eq 'GROUP#0')
        {
            $Type = "TeamSite"
        }
        $params = @{
            GlobalAdminAccount = $GlobalAdminAccount
            Url                = $site.Url
            Type               = $Type
            Title              = $site.Title
            TimeZoneId         = $site.TimeZoneID
        }
        $result = Get-TargetResource @params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
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
