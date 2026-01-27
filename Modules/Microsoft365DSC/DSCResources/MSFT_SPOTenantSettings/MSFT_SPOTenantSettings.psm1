Confirm-M365DSCModuleDependency -ModuleName 'MSFT_SPOTenantSettings'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $EnableAzureADB2BIntegration,

        [Parameter()]
        [ValidateSet('ExternalUserAndGuestSharing', 'Disabled', 'ExternalUserSharingOnly', 'ExistingExternalUserSharingOnly')]
        [System.String]
        $OneDriveSharingCapability,

        [Parameter()]
        [System.UInt32]
        $MinCompatibilityLevel,

        [Parameter()]
        [System.UInt32]
        $MaxCompatibilityLevel,

        [Parameter()]
        [System.Boolean]
        $SearchResolveExactEmailOrUPN,

        [Parameter()]
        [System.Boolean]
        $OfficeClientADALDisabled,

        [Parameter()]
        [System.Boolean]
        $LegacyAuthProtocolsEnabled,

        [Parameter()]
        [System.String]
        $SignInAccelerationDomain,

        [Parameter()]
        [System.Boolean]
        $UsePersistentCookiesForExplorerView,

        [Parameter()]
        [System.Boolean]
        $PublicCdnEnabled,

        [Parameter()]
        [System.String]
        $PublicCdnAllowedFileTypes,

        [Parameter()]
        [System.Boolean]
        $UseFindPeopleInPeoplePicker,

        [Parameter()]
        [System.Boolean]
        $NotificationsInSharePointEnabled,

        [Parameter()]
        [System.Boolean]
        $OwnerAnonymousNotification,

        [Parameter()]
        [System.Boolean]
        $ApplyAppEnforcedRestrictionsToAdHocRecipients,

        [Parameter()]
        [System.Boolean]
        $FilePickerExternalImageSearchEnabled,

        [Parameter()]
        [System.Boolean]
        $HideDefaultThemes,

        [Parameter()]
        [System.Boolean]
        $HideSyncButtonOnODB,

        [Parameter()]
        [System.Boolean]
        $HideSyncButtonOnTeamSite,

        [Parameter()]
        [ValidateSet('AllowExternalSharing', 'BlockExternalSharing')]
        [System.String]
        $MarkNewFilesSensitiveByDefault,

        [Parameter()]
        [System.Guid[]]
        $DisabledWebPartIds,

        [Parameter()]
        [System.Boolean]
        $IsFluidEnabled,

        [Parameter()]
        [System.Boolean]
        $SocialBarOnSitePagesDisabled,

        [Parameter()]
        [System.Boolean]
        $CommentsOnSitePagesDisabled,

        [Parameter()]
        [System.Boolean]
        $EnableAIPIntegration,

        [Parameter()]
        [System.String]
        $TenantDefaultTimezone,

        [Parameter()]
        [System.Boolean]
        $ExemptNativeUsersFromTenantLevelRestricedAccessControl,

        [Parameter()]
        [System.String[]]
        $AllowSelectSGsInODBListInTenant,

        [Parameter()]
        [System.String[]]
        $DenySelectSGsInODBListInTenant,

        [Parameter()]
        [System.String[]]
        $DenySelectSecurityGroupsInSPSitesList,

        [Parameter()]
        [System.String[]]
        $AllowSelectSecurityGroupsInSPSitesList,

        [Parameter()]
        [System.Boolean]
        $MobileFriendlyUrlEnabledInTenant,

        [Parameter()]
        [System.Boolean]
        $AllowDownloadingNonWebViewableFiles,

        [Parameter()]
        [System.Boolean]
        $AllowEditing,

        [Parameter()]
        [System.Boolean]
        $DisableCustomAppAuthentication,

        [Parameter()]
        [System.String[]]
        $DisabledModernListTemplateIds,

        [Parameter()]
        [System.Boolean]
        $DisablePersonalListCreation,

        [Parameter()]
        [System.Boolean]
        $DisplayNamesOfFileViewersInSpo,

        [Parameter()]
        [System.Boolean]
        $IsLoopEnabled,

        [Parameter()]
        [System.Boolean]
        $IsSharePointNewsfeedEnabled,

        [Parameter()]
        [System.Boolean]
        $IsSiteCreationEnabled,

        [Parameter()]
        [System.Boolean]
        $IsSiteCreationUiEnabled,

        [Parameter()]
        [System.Boolean]
        $IsSitePagesCreationEnabled,

        [Parameter()]
        [System.String]
        $NoAccessRedirectUrl,

        [Parameter()]
        [System.Boolean]
        $RequireAcceptingAccountMatchInvitedAccount,

        [Parameter()]
        [ValidateSet('NoPreference', 'Allowed', 'Disallowed')]
        [System.String]
        $SpecialCharactersStateInFileFolderNames,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message 'Getting configuration for SPO Tenant'

    try
    {
        if (-not $Script:ExportMode)
        {
            $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
                -InboundParameters $PSBoundParameters

            $null = New-M365DSCConnection -Workload 'PNP' `
                -InboundParameters $PSBoundParameters

            #Ensure the proper dependencies are installed in the current environment.
            Confirm-M365DSCDependencies

            #region Telemetry
            $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
            $CommandName = $MyInvocation.MyCommand
            $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
                -CommandName $CommandName `
                -Parameters $PSBoundParameters
            Add-M365DSCTelemetryEvent -Data $data
            #endregion
        }

        $nullReturn = $PSBoundParameters
        $nullReturn.Ensure = 'Absent'

        $SPOTenantSettings = Get-PnPTenant -ErrorAction Stop
        $SPOTenantGraphSettings = Get-MgAdminSharepointSetting -Property *
        $CompatibilityRange = $SPOTenantSettings.CompatibilityRange.Split(',')
        $MinCompat = $null
        $MaxCompat = $null
        if ($CompatibilityRange.Length -eq 2)
        {
            $MinCompat = $CompatibilityRange[0]
            $MaxCompat = $CompatibilityRange[1]
        }

        # Additional Properties via REST
        $parametersToRetrieve = @(
            'ExemptNativeUsersFromTenantLevelRestricedAccessControl',
            'AllowSelectSGsInODBListInTenant',
            'DenySelectSGsInODBListInTenant',
            'DenySelectSecurityGroupsInSPSitesList',
            'AllowSelectSecurityGroupsInSPSitesList',
            'EnableAzureADB2BIntegration',
            'HideSyncButtonOnODB',
            'MobileFriendlyUrlEnabledInTenant'
        )

        $response = Invoke-PnPSPRestMethod -Method Get `
            -Url "$((Get-MSCloudLoginConnectionProfile -Workload PnP).AdminUrl)/_api/SPO.Tenant?`$select=$($parametersToRetrieve -join ',')"

        return @{
            IsSingleInstance                                       = 'Yes'
            ExemptNativeUsersFromTenantLevelRestricedAccessControl = $response.ExemptNativeUsersFromTenantLevelRestricedAccessControl
            AllowSelectSGsInODBListInTenant                        = [System.String[]]$response.AllowSelectSGsInODBListInTenant
            DenySelectSGsInODBListInTenant                         = [System.String[]]$response.DenySelectSGsInODBListInTenant
            DenySelectSecurityGroupsInSPSitesList                  = [System.String[]]$response.DenySelectSecurityGroupsInSPSitesList
            AllowSelectSecurityGroupsInSPSitesList                 = [System.String[]]$response.AllowSelectSecurityGroupsInSPSitesList
            EnableAzureADB2BIntegration                            = $response.EnableAzureADB2BIntegration
            HideSyncButtonOnODB                                    = $response.HideSyncButtonOnODB
            MobileFriendlyUrlEnabledInTenant                       = $response.MobileFriendlyUrlEnabledInTenant
            #OneDriveSharingCapability                              = $response.ODBSharingCapability
            MinCompatibilityLevel                                  = $MinCompat
            MaxCompatibilityLevel                                  = $MaxCompat
            AllowDownloadingNonWebViewableFiles                    = $SPOTenantSettings.AllowDownloadingNonWebViewableFiles
            AllowEditing                                           = $SPOTenantSettings.AllowEditing
            ApplyAppEnforcedRestrictionsToAdHocRecipients          = $SPOTenantSettings.ApplyAppEnforcedRestrictionsToAdHocRecipients
            CommentsOnSitePagesDisabled                            = $SPOTenantSettings.CommentsOnSitePagesDisabled
            DisableCustomAppAuthentication                         = $SPOTenantSettings.DisableCustomAppAuthentication
            DisabledModernListTemplateIds                          = [System.String[]]$SPOTenantSettings.DisabledModernListTemplateIds
            DisabledWebPartIds                                     = [System.String[]]$SPOTenantSettings.DisabledWebPartIds
            DisablePersonalListCreation                            = $SPOTenantSettings.DisablePersonalListCreation
            #DisableSpacesActivation                                = $SPOTenantSettings.DisableSpacesActivation
            DisplayNamesOfFileViewersInSpo                         = $SPOTenantSettings.DisplayNamesOfFileViewersInSpo
            EnableAIPIntegration                                   = $SPOTenantSettings.EnableAIPIntegration
            FilePickerExternalImageSearchEnabled                   = $SPOTenantSettings.FilePickerExternalImageSearchEnabled
            HideDefaultThemes                                      = $SPOTenantSettings.HideDefaultThemes
            HideSyncButtonOnTeamSite                               = $SPOTenantSettings.HideSyncButtonOnTeamSite
            IsFluidEnabled                                         = $SPOTenantSettings.IsFluidEnabled
            IsLoopEnabled                                          = $SPOTenantSettings.IsLoopEnabled
            LegacyAuthProtocolsEnabled                             = $SPOTenantSettings.LegacyAuthProtocolsEnabled
            MarkNewFilesSensitiveByDefault                         = $SPOTenantSettings.MarkNewFilesSensitiveByDefault
            NoAccessRedirectUrl                                    = $SPOTenantSettings.NoAccessRedirectUrl
            NotificationsInSharePointEnabled                       = $SPOTenantSettings.NotificationsInSharePointEnabled
            OfficeClientADALDisabled                               = $SPOTenantSettings.OfficeClientADALDisabled
            OwnerAnonymousNotification                             = $SPOTenantSettings.OwnerAnonymousNotification
            #PermissiveBrowserFileHandlingOverride                  = $SPOTenantSettings.PermissiveBrowserFileHandlingOverride
            PublicCdnAllowedFileTypes                              = $SPOTenantSettings.PublicCdnAllowedFileTypes
            PublicCdnEnabled                                       = $SPOTenantSettings.PublicCdnEnabled
            #PublicCdnOrigins                                       = $SPOTenantSettings.PublicCdnOrigins
            RequireAcceptingAccountMatchInvitedAccount             = $SPOTenantSettings.RequireAcceptingAccountMatchInvitedAccount
            SearchResolveExactEmailOrUPN                           = $SPOTenantSettings.SearchResolveExactEmailOrUPN
            SignInAccelerationDomain                               = $SPOTenantSettings.SignInAccelerationDomain
            SocialBarOnSitePagesDisabled                           = $SPOTenantSettings.SocialBarOnSitePagesDisabled
            SpecialCharactersStateInFileFolderNames                = $SPOTenantSettings.SpecialCharactersStateInFileFolderNames
            UseFindPeopleInPeoplePicker                            = $SPOTenantSettings.UseFindPeopleInPeoplePicker
            UsePersistentCookiesForExplorerView                    = $SPOTenantSettings.UsePersistentCookiesForExplorerView
            IsSharePointNewsfeedEnabled                            = $SPOTenantGraphSettings.IsSharePointNewsfeedEnabled
            IsSiteCreationEnabled                                  = $SPOTenantGraphSettings.IsSiteCreationEnabled
            IsSiteCreationUiEnabled                                = $SPOTenantGraphSettings.IsSiteCreationUiEnabled
            IsSitePagesCreationEnabled                             = $SPOTenantGraphSettings.IsSitePagesCreationEnabled
            TenantDefaultTimezone                                  = $SPOTenantGraphSettings.TenantDefaultTimeZone
            Credential                                             = $Credential
            ApplicationId                                          = $ApplicationId
            TenantId                                               = $TenantId
            ApplicationSecret                                      = $ApplicationSecret
            CertificatePassword                                    = $CertificatePassword
            CertificatePath                                        = $CertificatePath
            CertificateThumbprint                                  = $CertificateThumbprint
            ManagedIdentity                                        = $ManagedIdentity.IsPresent
            Ensure                                                 = 'Present'
            AccessTokens                                           = $AccessTokens
        }
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (

        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $EnableAzureADB2BIntegration,

        [Parameter()]
        [ValidateSet('ExternalUserAndGuestSharing', 'Disabled', 'ExternalUserSharingOnly', 'ExistingExternalUserSharingOnly')]
        [System.String]
        $OneDriveSharingCapability,

        [Parameter()]
        [System.UInt32]
        $MinCompatibilityLevel,

        [Parameter()]
        [System.UInt32]
        $MaxCompatibilityLevel,

        [Parameter()]
        [System.Boolean]
        $SearchResolveExactEmailOrUPN,

        [Parameter()]
        [System.Boolean]
        $OfficeClientADALDisabled,

        [Parameter()]
        [System.Boolean]
        $LegacyAuthProtocolsEnabled,

        [Parameter()]
        [System.String]
        $SignInAccelerationDomain,

        [Parameter()]
        [System.Boolean]
        $UsePersistentCookiesForExplorerView,

        [Parameter()]
        [System.Boolean]
        $PublicCdnEnabled,

        [Parameter()]
        [System.String]
        $PublicCdnAllowedFileTypes,

        [Parameter()]
        [System.Boolean]
        $UseFindPeopleInPeoplePicker,

        [Parameter()]
        [System.Boolean]
        $NotificationsInSharePointEnabled,

        [Parameter()]
        [System.Boolean]
        $OwnerAnonymousNotification,

        [Parameter()]
        [System.Boolean]
        $ApplyAppEnforcedRestrictionsToAdHocRecipients,

        [Parameter()]
        [System.Boolean]
        $FilePickerExternalImageSearchEnabled,

        [Parameter()]
        [System.Boolean]
        $HideDefaultThemes,

        [Parameter()]
        [System.Boolean]
        $HideSyncButtonOnODB,

        [Parameter()]
        [System.Boolean]
        $HideSyncButtonOnTeamSite,

        [Parameter()]
        [ValidateSet('AllowExternalSharing', 'BlockExternalSharing')]
        [System.String]
        $MarkNewFilesSensitiveByDefault,

        [Parameter()]
        [System.Guid[]]
        $DisabledWebPartIds,

        [Parameter()]
        [System.Boolean]
        $IsFluidEnabled,

        [Parameter()]
        [System.Boolean]
        $SocialBarOnSitePagesDisabled,

        [Parameter()]
        [System.Boolean]
        $CommentsOnSitePagesDisabled,

        [Parameter()]
        [System.Boolean]
        $EnableAIPIntegration,

        [Parameter()]
        [System.String]
        $TenantDefaultTimezone,

        [Parameter()]
        [System.Boolean]
        $ExemptNativeUsersFromTenantLevelRestricedAccessControl,

        [Parameter()]
        [System.String[]]
        $AllowSelectSGsInODBListInTenant,

        [Parameter()]
        [System.String[]]
        $DenySelectSGsInODBListInTenant,

        [Parameter()]
        [System.String[]]
        $DenySelectSecurityGroupsInSPSitesList,

        [Parameter()]
        [System.String[]]
        $AllowSelectSecurityGroupsInSPSitesList,

        [Parameter()]
        [System.Boolean]
        $MobileFriendlyUrlEnabledInTenant,

        [Parameter()]
        [System.Boolean]
        $AllowDownloadingNonWebViewableFiles,

        [Parameter()]
        [System.Boolean]
        $AllowEditing,

        [Parameter()]
        [System.Boolean]
        $DisableCustomAppAuthentication,

        [Parameter()]
        [System.String[]]
        $DisabledModernListTemplateIds,

        [Parameter()]
        [System.Boolean]
        $DisablePersonalListCreation,

        [Parameter()]
        [System.Boolean]
        $DisplayNamesOfFileViewersInSpo,

        [Parameter()]
        [System.Boolean]
        $IsLoopEnabled,

        [Parameter()]
        [System.Boolean]
        $IsSharePointNewsfeedEnabled,

        [Parameter()]
        [System.Boolean]
        $IsSiteCreationEnabled,

        [Parameter()]
        [System.Boolean]
        $IsSiteCreationUiEnabled,

        [Parameter()]
        [System.Boolean]
        $IsSitePagesCreationEnabled,

        [Parameter()]
        [System.String]
        $NoAccessRedirectUrl,

        [Parameter()]
        [System.Boolean]
        $RequireAcceptingAccountMatchInvitedAccount,

        [Parameter()]
        [ValidateSet('NoPreference', 'Allowed', 'Disallowed')]
        [System.String]
        $SpecialCharactersStateInFileFolderNames,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    if ($PSBoundParameters.ContainsKey('OneDriveSharingCapability'))
    {
        Write-Warning -Message "The property 'OneDriveSharingCapability' is deprecated and will be ignored. Please use 'MySiteSharingCapability' in the SPOSharingSettings resource."
    }

    Write-Verbose -Message 'Updating configuration for the SPO Tenant Settings'

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    if (-not [string]::IsNullOrEmpty($TenantDefaultTimezone))
    {
        $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters
    }
    $null = New-M365DSCConnection -Workload 'PNP' -InboundParameters $PSBoundParameters

    $CurrentParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    $spoRestParameters = @(
        'ExemptNativeUsersFromTenantLevelRestricedAccessControl',
        'AllowSelectSGsInODBListInTenant',
        'DenySelectSGsInODBListInTenant',
        'DenySelectSecurityGroupsInSPSitesList',
        'AllowSelectSecurityGroupsInSPSitesList',
        'EnableAzureADB2BIntegration',
        'HideSyncButtonOnODB',
        'MobileFriendlyUrlEnabledInTenant'
    )
    $spoGraphParameters = @(
        'IsSharePointNewsfeedEnabled',
        'IsSiteCreationEnabled',
        'IsSiteCreationUiEnabled',
        'IsSitePagesCreationEnabled',
        'TenantDefaultTimezone'
    )
    $CurrentParameters.Remove('IsSingleInstance') | Out-Null
    $spoRestParametersSplat = @{}
    foreach ($param in $spoRestParameters)
    {
        $spoRestParametersSplat.Add($param, $CurrentParameters[$param])
        $CurrentParameters.Remove($param) | Out-Null
    }
    $spoGraphParametersSplat = @{}
    foreach ($param in $spoGraphParameters)
    {
        $spoGraphParametersSplat.Add($param, $CurrentParameters[$param])
        $CurrentParameters.Remove($param) | Out-Null
    }

    if ($PublicCdnEnabled -eq $false)
    {
        Write-Verbose -Message 'The use of the public CDN is not enabled, for that the PublicCdnAllowedFileTypes parameter can not be configured and will be removed'
        $CurrentParameters.Remove('PublicCdnAllowedFileTypes') | Out-Null
    }
    $null = Set-PnPTenant @CurrentParameters

    if ($spoGraphParametersSplat.Keys.Count -gt 0)
    {
        $null = Update-MgAdminSharepointSetting @spoGraphParametersSplat -ErrorAction Stop
    }

    # Updating via REST
    try
    {
        Write-Verbose -Message 'Updating properties via REST PATCH call.'
        Invoke-PnPSPRestMethod -Method PATCH `
            -Url "$((Get-MSCloudLoginConnectionProfile -Workload PnP).AdminUrl)/_api/SPO.Tenant" `
            -Content $spoRestParametersSplat
    }
    catch
    {
        if ($_.Exception.Message.Contains('The requested operation is part of an experimental feature that is not supported in the current environment.'))
        {
            Write-Verbose -Message 'Updating via REST: The associated feature is not available in the given tenant.'
        }
        else
        {
            throw $_
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
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $EnableAzureADB2BIntegration,

        [Parameter()]
        [ValidateSet('ExternalUserAndGuestSharing', 'Disabled', 'ExternalUserSharingOnly', 'ExistingExternalUserSharingOnly')]
        [System.String]
        $OneDriveSharingCapability,

        [Parameter()]
        [System.UInt32]
        $MinCompatibilityLevel,

        [Parameter()]
        [System.UInt32]
        $MaxCompatibilityLevel,

        [Parameter()]
        [System.Boolean]
        $SearchResolveExactEmailOrUPN,

        [Parameter()]
        [System.Boolean]
        $OfficeClientADALDisabled,

        [Parameter()]
        [System.Boolean]
        $LegacyAuthProtocolsEnabled,

        [Parameter()]
        [System.String]
        $SignInAccelerationDomain,

        [Parameter()]
        [System.Boolean]
        $UsePersistentCookiesForExplorerView,

        [Parameter()]
        [System.Boolean]
        $PublicCdnEnabled,

        [Parameter()]
        [System.String]
        $PublicCdnAllowedFileTypes,

        [Parameter()]
        [System.Boolean]
        $UseFindPeopleInPeoplePicker,

        [Parameter()]
        [System.Boolean]
        $NotificationsInSharePointEnabled,

        [Parameter()]
        [System.Boolean]
        $OwnerAnonymousNotification,

        [Parameter()]
        [System.Boolean]
        $ApplyAppEnforcedRestrictionsToAdHocRecipients,

        [Parameter()]
        [System.Boolean]
        $FilePickerExternalImageSearchEnabled,

        [Parameter()]
        [System.Boolean]
        $HideDefaultThemes,

        [Parameter()]
        [System.Boolean]
        $HideSyncButtonOnODB,

        [Parameter()]
        [System.Boolean]
        $HideSyncButtonOnTeamSite,

        [Parameter()]
        [ValidateSet('AllowExternalSharing', 'BlockExternalSharing')]
        [System.String]
        $MarkNewFilesSensitiveByDefault,

        [Parameter()]
        [System.Guid[]]
        $DisabledWebPartIds,

        [Parameter()]
        [System.Boolean]
        $IsFluidEnabled,

        [Parameter()]
        [System.Boolean]
        $SocialBarOnSitePagesDisabled,

        [Parameter()]
        [System.Boolean]
        $CommentsOnSitePagesDisabled,

        [Parameter()]
        [System.Boolean]
        $EnableAIPIntegration,

        [Parameter()]
        [System.String]
        $TenantDefaultTimezone,

        [Parameter()]
        [System.Boolean]
        $ExemptNativeUsersFromTenantLevelRestricedAccessControl,

        [Parameter()]
        [System.String[]]
        $AllowSelectSGsInODBListInTenant,

        [Parameter()]
        [System.String[]]
        $DenySelectSGsInODBListInTenant,

        [Parameter()]
        [System.String[]]
        $DenySelectSecurityGroupsInSPSitesList,

        [Parameter()]
        [System.String[]]
        $AllowSelectSecurityGroupsInSPSitesList,

        [Parameter()]
        [System.Boolean]
        $MobileFriendlyUrlEnabledInTenant,

        [Parameter()]
        [System.Boolean]
        $AllowDownloadingNonWebViewableFiles,

        [Parameter()]
        [System.Boolean]
        $AllowEditing,

        [Parameter()]
        [System.Boolean]
        $DisableCustomAppAuthentication,

        [Parameter()]
        [System.String[]]
        $DisabledModernListTemplateIds,

        [Parameter()]
        [System.Boolean]
        $DisablePersonalListCreation,

        [Parameter()]
        [System.Boolean]
        $DisplayNamesOfFileViewersInSpo,

        [Parameter()]
        [System.Boolean]
        $IsLoopEnabled,

        [Parameter()]
        [System.Boolean]
        $IsSharePointNewsfeedEnabled,

        [Parameter()]
        [System.Boolean]
        $IsSiteCreationEnabled,

        [Parameter()]
        [System.Boolean]
        $IsSiteCreationUiEnabled,

        [Parameter()]
        [System.Boolean]
        $IsSitePagesCreationEnabled,

        [Parameter()]
        [System.String]
        $NoAccessRedirectUrl,

        [Parameter()]
        [System.Boolean]
        $RequireAcceptingAccountMatchInvitedAccount,

        [Parameter()]
        [ValidateSet('NoPreference', 'Allowed', 'Disallowed')]
        [System.String]
        $SpecialCharactersStateInFileFolderNames,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    if ($PSBoundParameters.ContainsKey('OneDriveSharingCapability'))
    {
        Write-Warning -Message "The property 'OneDriveSharingCapability' is deprecated and will be ignored. Please use 'MySiteSharingCapability' in the SPOSharingSettings resource."
    }

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $compareParameters = Get-CompareParameters
    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
                                             -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '') `
                                             @compareParameters
    return $result
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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    try
    {
        $ConnectionModeGraph = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters

        $ConnectionMode = New-M365DSCConnection -Workload 'PNP' `
            -InboundParameters $PSBoundParameters

        #Ensure the proper dependencies are installed in the current environment.
        Confirm-M365DSCDependencies

        #region Telemetry
        $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
        $CommandName = $MyInvocation.MyCommand
        $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
            -CommandName $CommandName `
            -Parameters $PSBoundParameters
        Add-M365DSCTelemetryEvent -Data $data
        #endregion

        if ($null -ne $Global:M365DSCExportResourceInstancesCount)
        {
            $Global:M365DSCExportResourceInstancesCount++
        }

        $Script:ExportMode = $true

        $Params = @{
            IsSingleInstance      = 'Yes'
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificatePassword   = $CertificatePassword
            CertificatePath       = $CertificatePath
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            Credential            = $Credential
            AccessTokens          = $AccessTokens
        }

        $Results = Get-TargetResource @Params
        if ($null -eq $Results.MaxCompatibilityLevel)
        {
            $Results.Remove('MaxCompatibilityLevel') | Out-Null
        }
        if ($null -eq $Results.MinCompatibilityLevel)
        {
            $Results.Remove('MinCompatibilityLevel') | Out-Null
        }
        $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
            -ConnectionMode $ConnectionMode `
            -ModulePath $PSScriptRoot `
            -Results $Results `
            -Credential $Credential
        $dscContent += $currentDSCBlock
        Save-M365DSCPartialExport -Content $currentDSCBlock `
            -FileName $Global:PartialExportFileName
        Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        return $dscContent
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

function Get-CompareParameters
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()

    return @{
        ExcludedProperties = @('OneDriveSharingCapability')
    }
}

Export-ModuleMember -Function @('*-TargetResource', 'Get-CompareParameters')
