Confirm-M365DSCModuleDependency -ModuleName 'MSFT_SPOTenantSettings'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (

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
        $SPOTenantGraphSettings = Get-MgAdminSharepointSetting -Property TenantDefaultTimeZone # get tenantDefaultTimezone
        $CompatibilityRange = $SPOTenantSettings.CompatibilityRange.Split(',')
        $MinCompat = $null
        $MaxCompat = $null
        if ($CompatibilityRange.Length -eq 2)
        {
            $MinCompat = $CompatibilityRange[0]
            $MaxCompat = $CompatibilityRange[1]
        }

        # Additional Properties via REST
        $parametersToRetrieve = @('ExemptNativeUsersFromTenantLevelRestricedAccessControl',
            'AllowSelectSGsInODBListInTenant',
            'DenySelectSGsInODBListInTenant',
            'DenySelectSecurityGroupsInSPSitesList',
            'AllowSelectSecurityGroupsInSPSitesList',
            'EnableAzureADB2BIntegration',
            'ODBSharingCapability')

        $response = Invoke-PnPSPRestMethod -Method Get `
            -Url "$((Get-MSCloudLoginConnectionProfile -Workload PnP).AdminUrl)/_api/SPO.Tenant?`$select=$($parametersToRetrieve -join ',')"


        return @{
            IsSingleInstance                                       = 'Yes'
            ExemptNativeUsersFromTenantLevelRestricedAccessControl = $response.ExemptNativeUsersFromTenantLevelRestricedAccessControl
            AllowSelectSGsInODBListInTenant                        = $response.AllowSelectSGsInODBListInTenant
            DenySelectSGsInODBListInTenant                         = $response.DenySelectSGsInODBListInTenant
            DenySelectSecurityGroupsInSPSitesList                  = $response.DenySelectSecurityGroupsInSPSitesList
            AllowSelectSecurityGroupsInSPSitesList                 = $response.AllowSelectSecurityGroupsInSPSitesList
            EnableAzureADB2BIntegration                            = $response.EnableAzureADB2BIntegration
            #OneDriveSharingCapability                              = $response.ODBSharingCapability
            MinCompatibilityLevel                                  = $MinCompat
            MaxCompatibilityLevel                                  = $MaxCompat
            SearchResolveExactEmailOrUPN                           = $SPOTenantSettings.SearchResolveExactEmailOrUPN
            OfficeClientADALDisabled                               = $SPOTenantSettings.OfficeClientADALDisabled
            LegacyAuthProtocolsEnabled                             = $SPOTenantSettings.LegacyAuthProtocolsEnabled
            SignInAccelerationDomain                               = $SPOTenantSettings.SignInAccelerationDomain
            UsePersistentCookiesForExplorerView                    = $SPOTenantSettings.UsePersistentCookiesForExplorerView
            PublicCdnEnabled                                       = $SPOTenantSettings.PublicCdnEnabled
            PublicCdnAllowedFileTypes                              = $SPOTenantSettings.PublicCdnAllowedFileTypes
            UseFindPeopleInPeoplePicker                            = $SPOTenantSettings.UseFindPeopleInPeoplePicker
            NotificationsInSharePointEnabled                       = $SPOTenantSettings.NotificationsInSharePointEnabled
            OwnerAnonymousNotification                             = $SPOTenantSettings.OwnerAnonymousNotification
            ApplyAppEnforcedRestrictionsToAdHocRecipients          = $SPOTenantSettings.ApplyAppEnforcedRestrictionsToAdHocRecipients
            FilePickerExternalImageSearchEnabled                   = $SPOTenantSettings.FilePickerExternalImageSearchEnabled
            HideDefaultThemes                                      = $SPOTenantSettings.HideDefaultThemes
            HideSyncButtonOnTeamSite                               = $SPOTenantSettings.HideSyncButtonOnTeamSite
            MarkNewFilesSensitiveByDefault                         = $SPOTenantSettings.MarkNewFilesSensitiveByDefault
            DisabledWebPartIds                                     = [String[]]$SPOTenantSettings.DisabledWebPartIds
            SocialBarOnSitePagesDisabled                           = $SPOTenantSettings.SocialBarOnSitePagesDisabled
            CommentsOnSitePagesDisabled                            = $SPOTenantSettings.CommentsOnSitePagesDisabled
            EnableAIPIntegration                                   = $SPOTenantSettings.EnableAIPIntegration
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
        if ($_.Exception.Message -like 'No connection available')
        {
            Write-Verbose -Message 'Make sure that you are connected to your SPOService'
        }

        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $nullReturn
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param (

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
    $CurrentParameters.Remove('IsSingleInstance') | Out-Null
    $CurrentParameters.Remove('ExemptNativeUsersFromTenantLevelRestricedAccessControl') | Out-Null
    $CurrentParameters.Remove('AllowSelectSGsInODBListInTenant') | Out-Null
    $CurrentParameters.Remove('DenySelectSGsInODBListInTenant') | Out-Null
    $CurrentParameters.Remove('DenySelectSecurityGroupsInSPSitesList') | Out-Null
    $CurrentParameters.Remove('AllowSelectSecurityGroupsInSPSitesList') | Out-Null
    $CurrentParameters.Remove('EnableAzureADB2BIntegration') | Out-Null
    $CurrentParameters.Remove('OneDriveSharingCapability') | Out-Null
    $CurrentParameters.Remove('TenantDefaultTimezone') | Out-Null # this one is updated separately using Graph

    if ($PublicCdnEnabled -eq $false)
    {
        Write-Verbose -Message 'The use of the public CDN is not enabled, for that the PublicCdnAllowedFileTypes parameter can not be configured and will be removed'
        $CurrentParameters.Remove('PublicCdnAllowedFileTypes') | Out-Null
    }
    $null = Set-PnPTenant @CurrentParameters

    if (-not [string]::IsNullOrEmpty($TenantDefaultTimezone))
    {
        $null = Update-MgAdminSharepointSetting -TenantDefaultTimezone $TenantDefaultTimezone -ErrorAction Stop
    }

    # Updating via REST
    try
    {
        $paramsToUpdate = @{}
        $needToUpdate = $false

        if ($null -ne $ExemptNativeUsersFromTenantLevelRestricedAccessControl)
        {
            $needToUpdate = $true
            $paramsToUpdate.Add('ExemptNativeUsersFromTenantLevelRestricedAccessControl', $ExemptNativeUsersFromTenantLevelRestricedAccessControl)
        }

        if ($null -ne $AllowSelectSGsInODBListInTenant)
        {
            $needToUpdate = $true
            $paramsToUpdate.Add('AllowSelectSGsInODBListInTenant', $AllowSelectSGsInODBListInTenant)
        }

        if ($null -ne $DenySelectSGsInODBListInTenant)
        {
            $needToUpdate = $true
            $paramsToUpdate.Add('DenySelectSGsInODBListInTenant', $DenySelectSGsInODBListInTenant)
        }

        if ($null -ne $DenySelectSecurityGroupsInSPSitesList)
        {
            $needToUpdate = $true
            $paramsToUpdate.Add('DenySelectSecurityGroupsInSPSitesList', $DenySelectSecurityGroupsInSPSitesList)
        }

        if ($null -ne $AllowSelectSecurityGroupsInSPSitesList)
        {
            $needToUpdate = $true
            $paramsToUpdate.Add('AllowSelectSecurityGroupsInSPSitesList', $AllowSelectSecurityGroupsInSPSitesList)
        }

        if ($null -ne $EnableAzureADB2BIntegration)
        {
            $needToUpdate = $true
            $paramsToUpdate.Add('EnableAzureADB2BIntegration', $EnableAzureADB2BIntegration)
        }

        if ($needToUpdate)
        {
            Write-Verbose -Message 'Updating properties via REST PATCH call.'
            Invoke-PnPSPRestMethod -Method PATCH `
                -Url "$((Get-MSCloudLoginConnectionProfile -Workload PnP).AdminUrl)/_api/SPO.Tenant" `
                -Content $paramsToUpdate
        }
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
    param (

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

    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
                                         -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '') `
                                         -ExcludedProperties @('OneDriveSharingCapability')
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
        Write-M365DSCHost -Message $Global:M365DSCEmojiRedX -CommitWrite

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
