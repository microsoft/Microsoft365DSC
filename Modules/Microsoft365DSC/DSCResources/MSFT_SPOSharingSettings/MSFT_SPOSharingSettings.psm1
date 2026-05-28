Confirm-M365DSCModuleDependency -ModuleName 'MSFT_SPOSharingSettings'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [System.String]
        [ValidateSet('ExistingExternalUserSharingOnly', 'ExternalUserAndGuestSharing', 'Disabled', 'ExternalUserSharingOnly')]
        $SharingCapability,

        [Parameter()]
        [System.String]
        [ValidateSet('ExistingExternalUserSharingOnly', 'ExternalUserAndGuestSharing', 'Disabled', 'ExternalUserSharingOnly')]
        $MySiteSharingCapability,

        [Parameter()]
        [System.Boolean]
        $ShowEveryoneClaim,

        [Parameter()]
        [System.Boolean]
        $ShowAllUsersClaim,

        [Parameter()]
        [System.Boolean]
        $ShowEveryoneExceptExternalUsersClaim,

        [Parameter()]
        [System.Boolean]
        $ProvisionSharedWithEveryoneFolder,

        [Parameter()]
        [System.Boolean]
        $EnableGuestSignInAcceleration,

        [Parameter()]
        [System.Boolean]
        $BccExternalSharingInvitations,

        [Parameter()]
        [System.String]
        $BccExternalSharingInvitationsList,

        [Parameter()]
        [System.Uint32]
        $RequireAnonymousLinksExpireInDays,

        [Parameter()]
        [System.Uint32]
        $ExternalUserExpireInDays,

        [Parameter()]
        [System.String[]]
        $SharingAllowedDomainList,

        [Parameter()]
        [System.String[]]
        $SharingBlockedDomainList,

        [Parameter()]
        [System.String]
        [ValidateSet('None', 'AllowList', 'BlockList')]
        $SharingDomainRestrictionMode,

        [Parameter()]
        [System.String]
        [ValidateSet('None', 'Direct', 'Internal', 'AnonymousAccess')]
        $DefaultSharingLinkType,

        [Parameter()]
        [System.Boolean]
        $PreventExternalUsersFromResharing,

        [Parameter()]
        [System.Boolean]
        $ExternalUserExpirationRequired,

        [Parameter()]
        [System.Boolean]
        $ShowPeoplePickerSuggestionsForGuestUsers,

        [Parameter()]
        [System.String]
        [ValidateSet('View', 'Edit')]
        $FileAnonymousLinkType,

        [Parameter()]
        [System.String]
        [ValidateSet('View', 'Edit')]
        $FolderAnonymousLinkType,

        [Parameter()]
        [System.Boolean]
        $NotifyOwnersWhenItemsReshared,

        [Parameter()]
        [System.String]
        [ValidateSet('None', 'View', 'Edit')]
        $DefaultLinkPermission,

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
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message 'Getting configuration for SPO Sharing settings'

    try
    {
        if (-not $Script:ExportMode)
        {
            $null = New-M365DSCConnection -Workload 'PnP' `
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

        if ($null -eq $Script:SPOSharingSettings)
        {
            $Script:SPOSharingSettings = Get-PnPTenant -ErrorAction Stop
        }

        # Local filtering because server side filtering intermittently fails
        $MySite = Get-PnPTenantSite -Filter "Url -like '-my.sharepoint.'" | Where-Object -FilterScript { $_.Template -match '^SPSMSITEHOST#' }

        if ($null -ne $MySite)
        {
            $MySiteSharingCapability = (Get-PnPTenantSite -Identity $MySite.Url).SharingCapability
        }

        if ($null -ne $SPOSharingSettings.SharingAllowedDomainList)
        {
            $allowDomains = $SPOSharingSettings.SharingAllowedDomainList.Split(' ')
        }

        if ($null -ne $SPOSharingSettings.SharingBlockedDomainList)
        {
            $blockDomains = $SPOSharingSettings.SharingBlockedDomainList.Split(' ')
        }

        if ($SPOSharingSettings.DefaultLinkPermission -eq 'None')
        {
            $DefaultLinkPermission = 'Edit'
        }
        else
        {
            $DefaultLinkPermission = $SPOSharingSettings.DefaultLinkPermission
        }
        $results = @{
            IsSingleInstance                         = 'Yes'
            SharingCapability                        = $SPOSharingSettings.SharingCapability.ToString()
            ShowEveryoneClaim                        = $SPOSharingSettings.ShowEveryoneClaim
            ShowAllUsersClaim                        = $SPOSharingSettings.ShowAllUsersClaim
            ShowEveryoneExceptExternalUsersClaim     = $SPOSharingSettings.ShowEveryoneExceptExternalUsersClaim
            ProvisionSharedWithEveryoneFolder        = $SPOSharingSettings.ProvisionSharedWithEveryoneFolder
            EnableGuestSignInAcceleration            = $SPOSharingSettings.EnableGuestSignInAcceleration
            BccExternalSharingInvitations            = $SPOSharingSettings.BccExternalSharingInvitations
            BccExternalSharingInvitationsList        = $SPOSharingSettings.BccExternalSharingInvitationsList
            RequireAnonymousLinksExpireInDays        = $SPOSharingSettings.RequireAnonymousLinksExpireInDays
            ExternalUserExpireInDays                 = $SPOSharingSettings.ExternalUserExpireInDays
            ExternalUserExpirationRequired           = $SPOSharingSettings.ExternalUserExpirationRequired
            SharingAllowedDomainList                 = $allowDomains
            SharingBlockedDomainList                 = $blockDomains
            SharingDomainRestrictionMode             = $SPOSharingSettings.SharingDomainRestrictionMode.ToString()
            DefaultSharingLinkType                   = $SPOSharingSettings.DefaultSharingLinkType.ToString()
            PreventExternalUsersFromResharing        = $SPOSharingSettings.PreventExternalUsersFromResharing
            ShowPeoplePickerSuggestionsForGuestUsers = $SPOSharingSettings.ShowPeoplePickerSuggestionsForGuestUsers
            FileAnonymousLinkType                    = $SPOSharingSettings.FileAnonymousLinkType.ToString()
            FolderAnonymousLinkType                  = $SPOSharingSettings.FolderAnonymousLinkType.ToString()
            NotifyOwnersWhenItemsReshared            = $SPOSharingSettings.NotifyOwnersWhenItemsReshared
            DefaultLinkPermission                    = $DefaultLinkPermission
            Ensure                                   = 'Present'
            Credential                               = $Credential
            ApplicationId                            = $ApplicationId
            TenantId                                 = $TenantId
            ApplicationSecret                        = $ApplicationSecret
            CertificateThumbprint                    = $CertificateThumbprint
            CertificatePath                          = $CertificatePath
            CertificatePassword                      = $CertificatePassword
            ManagedIdentity                          = $ManagedIdentity.IsPresent
            AccessTokens                             = $AccessTokens
        }

        if (-not [System.String]::IsNullOrEmpty($MySiteSharingCapability))
        {
            $results.Add('MySiteSharingCapability', $MySiteSharingCapability)
        }
        return $results
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
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [System.String]
        [ValidateSet('ExistingExternalUserSharingOnly', 'ExternalUserAndGuestSharing', 'Disabled', 'ExternalUserSharingOnly')]
        $SharingCapability,

        [Parameter()]
        [System.String]
        [ValidateSet('ExistingExternalUserSharingOnly', 'ExternalUserAndGuestSharing', 'Disabled', 'ExternalUserSharingOnly')]
        $MySiteSharingCapability,

        [Parameter()]
        [System.Boolean]
        $ShowEveryoneClaim,

        [Parameter()]
        [System.Boolean]
        $ShowAllUsersClaim,

        [Parameter()]
        [System.Boolean]
        $ShowEveryoneExceptExternalUsersClaim,

        [Parameter()]
        [System.Boolean]
        $ProvisionSharedWithEveryoneFolder,

        [Parameter()]
        [System.Boolean]
        $EnableGuestSignInAcceleration,

        [Parameter()]
        [System.Boolean]
        $BccExternalSharingInvitations,

        [Parameter()]
        [System.String]
        $BccExternalSharingInvitationsList,

        [Parameter()]
        [System.Uint32]
        $RequireAnonymousLinksExpireInDays,

        [Parameter()]
        [System.Uint32]
        $ExternalUserExpireInDays,

        [Parameter()]
        [System.String[]]
        $SharingAllowedDomainList,

        [Parameter()]
        [System.String[]]
        $SharingBlockedDomainList,

        [Parameter()]
        [System.String]
        [ValidateSet('None', 'AllowList', 'BlockList')]
        $SharingDomainRestrictionMode,

        [Parameter()]
        [System.String]
        [ValidateSet('None', 'Direct', 'Internal', 'AnonymousAccess')]
        $DefaultSharingLinkType,

        [Parameter()]
        [System.Boolean]
        $PreventExternalUsersFromResharing,

        [Parameter()]
        [System.Boolean]
        $ExternalUserExpirationRequired,

        [Parameter()]
        [System.Boolean]
        $ShowPeoplePickerSuggestionsForGuestUsers,

        [Parameter()]
        [System.String]
        [ValidateSet('View', 'Edit')]
        $FileAnonymousLinkType,

        [Parameter()]
        [System.String]
        [ValidateSet('View', 'Edit')]
        $FolderAnonymousLinkType,

        [Parameter()]
        [System.Boolean]
        $NotifyOwnersWhenItemsReshared,

        [Parameter()]
        [System.String]
        [ValidateSet('None', 'View', 'Edit')]
        $DefaultLinkPermission,

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
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message 'Setting configuration for SPO Sharing settings'

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

    $null = New-M365DSCConnection -Workload 'PnP' `
        -InboundParameters $PSBoundParameters

    $CurrentParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    $CurrentParameters.Remove('IsSingleInstance') | Out-Null

    [bool]$SetMySharingCapability = $false
    if ($null -ne $CurrentParameters['MySiteSharingCapability'])
    {
        $SetMySharingCapability = $true
    }
    $CurrentParameters.Remove('MySiteSharingCapability') | Out-Null

    if ($null -eq $SignInAccelerationDomain)
    {
        $CurrentParameters.Remove('SignInAccelerationDomain') | Out-Null
        $CurrentParameters.Remove('EnableGuestSignInAcceleration') | Out-Null #removing EnableGuestSignInAcceleration since it can only be configured with a configured SignINAccerlation domain
    }
    if ($SharingCapability -ne 'ExternalUserAndGuestSharing')
    {
        Write-Warning -Message 'The sharing capabilities for the tenant are not configured to be ExternalUserAndGuestSharing for that the RequireAnonymousLinksExpireInDays property cannot be configured'
        $CurrentParameters.Remove('RequireAnonymousLinksExpireInDays') | Out-Null
    }
    if ($ExternalUserExpireInDays -and $ExternalUserExpirationRequired -eq $false)
    {
        Write-Warning -Message 'ExternalUserExpirationRequired is set to be false. For that the ExternalUserExpireInDays property cannot be configured'
        $CurrentParameters.Remove('ExternalUserExpireInDays') | Out-Null
    }
    if ($SharingCapability -ne 'ExternalUserAndGuestSharing' -and ($null -ne $FileAnonymousLinkType -or $null -ne $FolderAnonymousLinkType))
    {
        Write-Warning -Message 'If anonymous file or folder links are set, SharingCapability must be set to ExternalUserAndGuestSharing '
        $CurrentParameters.Remove('FolderAnonymousLinkType') | Out-Null
        $CurrentParameters.Remove('FileAnonymousLinkType') | Out-Null
    }

    if ($SharingDomainRestrictionMode -eq 'None')
    {
        Write-Warning -Message 'SharingDomainRestrictionMode is set to None. For that SharingAllowedDomainList / SharingBlockedDomainList cannot be configured'
        $CurrentParameters.Remove('SharingAllowedDomainList') | Out-Null
        $CurrentParameters.Remove('SharingBlockedDomainList') | Out-Null
    }
    elseif ($SharingDomainRestrictionMode -eq 'AllowList')
    {
        Write-Verbose -Message 'SharingDomainRestrictionMode is set to AllowList. For that SharingBlockedDomainList cannot be configured'
        $CurrentParameters.Remove('SharingBlockedDomainList') | Out-Null
    }
    elseif ($SharingDomainRestrictionMode -eq 'BlockList')
    {
        Write-Warning -Message 'SharingDomainRestrictionMode is set to BlockList. For that SharingAllowedDomainList cannot be configured'
        $CurrentParameters.Remove('SharingAllowedDomainList') | Out-Null
    }

    if ($null -ne $CurrentParameters['SharingAllowedDomainList'])
    {
        foreach ($allowedDomain in $SharingAllowedDomainList)
        {
            $allowed += $allowedDomain
            $allowed += ' '
        }
        $CurrentParameters['SharingAllowedDomainList'] = $allowed.trim()
    }

    if ($null -ne $CurrentParameters['SharingBlockedDomainList'])
    {
        foreach ($blockedDomain in $SharingBlockedDomainList)
        {
            $blocked += $blockedDomain
            $blocked += ' '
        }
        $CurrentParameters['SharingBlockedDomainList'] = $blocked.Trim()
    }

    if ($DefaultLinkPermission -eq 'None')
    {
        Write-Verbose -Message 'Valid values to set are View and Edit. A value of None will be set to Edit as its the default value.'
        $CurrentParameters['DefaultLinkPermission'] = 'Edit'
    }

    Set-PnPTenant @CurrentParameters | Out-Null
    if ($SetMySharingCapability)
    {
        $mysite = Get-PnPTenantSite -Filter "Url -like '-my.sharepoint.'" | Where-Object -FilterScript { $_.Template -notmatch '^RedirectSite#' }
        Set-PnPTenantSite -Identity $mysite.Url -SharingCapability $MySiteSharingCapability
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
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [System.String]
        [ValidateSet('ExistingExternalUserSharingOnly', 'ExternalUserAndGuestSharing', 'Disabled', 'ExternalUserSharingOnly')]
        $SharingCapability,

        [Parameter()]
        [System.String]
        [ValidateSet('ExistingExternalUserSharingOnly', 'ExternalUserAndGuestSharing', 'Disabled', 'ExternalUserSharingOnly')]
        $MySiteSharingCapability,

        [Parameter()]
        [System.Boolean]
        $ShowEveryoneClaim,

        [Parameter()]
        [System.Boolean]
        $ShowAllUsersClaim,

        [Parameter()]
        [System.Boolean]
        $ShowEveryoneExceptExternalUsersClaim,

        [Parameter()]
        [System.Boolean]
        $ProvisionSharedWithEveryoneFolder,

        [Parameter()]
        [System.Boolean]
        $EnableGuestSignInAcceleration,

        [Parameter()]
        [System.Boolean]
        $BccExternalSharingInvitations,

        [Parameter()]
        [System.String]
        $BccExternalSharingInvitationsList,

        [Parameter()]
        [System.Uint32]
        $RequireAnonymousLinksExpireInDays,

        [Parameter()]
        [System.Uint32]
        $ExternalUserExpireInDays,

        [Parameter()]
        [System.String[]]
        $SharingAllowedDomainList,

        [Parameter()]
        [System.String[]]
        $SharingBlockedDomainList,

        [Parameter()]
        [System.String]
        [ValidateSet('None', 'AllowList', 'BlockList')]
        $SharingDomainRestrictionMode,

        [Parameter()]
        [System.String]
        [ValidateSet('None', 'Direct', 'Internal', 'AnonymousAccess')]
        $DefaultSharingLinkType,

        [Parameter()]
        [System.Boolean]
        $PreventExternalUsersFromResharing,

        [Parameter()]
        [System.Boolean]
        $ExternalUserExpirationRequired,

        [Parameter()]
        [System.Boolean]
        $ShowPeoplePickerSuggestionsForGuestUsers,

        [Parameter()]
        [System.String]
        [ValidateSet('View', 'Edit')]
        $FileAnonymousLinkType,

        [Parameter()]
        [System.String]
        [ValidateSet('View', 'Edit')]
        $FolderAnonymousLinkType,

        [Parameter()]
        [System.Boolean]
        $NotifyOwnersWhenItemsReshared,

        [Parameter()]
        [System.String]
        [ValidateSet('None', 'View', 'Edit')]
        $DefaultLinkPermission,

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
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    if ($DefaultLinkPermission -eq 'None')
    {
        Write-Verbose -Message 'Valid values to set are View and Edit. A value of None will be set to Edit as its the default value.'
        $PSBoundParameters.DefaultLinkPermission = 'Edit'
    }

    if ($null -eq $SignInAccelerationDomain)
    {
        $PSBoundParameters.Remove('SignInAccelerationDomain') | Out-Null
        $PSBoundParameters.Remove('EnableGuestSignInAcceleration') | Out-Null #removing EnableGuestSignInAcceleration since it can only be configured with a configured SignINAccerlation domain
    }

    if ($SharingCapability -ne 'ExternalUserAndGuestSharing')
    {
        Write-Warning -Message 'The sharing capabilities for the tenant are not configured to be ExternalUserAndGuestSharing for that the RequireAnonymousLinksExpireInDays property cannot be configured'
        $PSBoundParameters.Remove('RequireAnonymousLinksExpireInDays') | Out-Null
    }

    if ($ExternalUserExpireInDays -and $ExternalUserExpirationRequired -eq $false)
    {
        Write-Warning -Message 'ExternalUserExpirationRequired is set to be false. For that the ExternalUserExpireInDays property cannot be configured'
        $PSBoundParameters.Remove('ExternalUserExpireInDays') | Out-Null
    }

    if ($SharingCapability -ne 'ExternalUserAndGuestSharing' -and ($null -ne $FileAnonymousLinkType -or $null -ne $FolderAnonymousLinkType))
    {
        Write-Warning -Message 'If anonymous file or folder links are set, SharingCapability must be set to ExternalUserAndGuestSharing '
        $PSBoundParameters.Remove('FolderAnonymousLinkType') | Out-Null
        $PSBoundParameters.Remove('FileAnonymousLinkType') | Out-Null
    }

    if ($SharingDomainRestrictionMode -eq 'None')
    {
        Write-Warning -Message 'SharingDomainRestrictionMode is set to None. For that SharingAllowedDomainList / SharingBlockedDomainList cannot be configured'
        $PSBoundParameters.Remove('SharingAllowedDomainList') | Out-Null
        $PSBoundParameters.Remove('SharingBlockedDomainList') | Out-Null
    }
    elseif ($SharingDomainRestrictionMode -eq 'AllowList')
    {
        Write-Verbose -Message 'SharingDomainRestrictionMode is set to AllowList. For that SharingBlockedDomainList cannot be configured'
        $PSBoundParameters.Remove('SharingBlockedDomainList') | Out-Null
    }
    elseif ($SharingDomainRestrictionMode -eq 'BlockList')
    {
        Write-Warning -Message 'SharingDomainRestrictionMode is set to BlockList. For that SharingAllowedDomainList cannot be configured'
        $PSBoundParameters.Remove('SharingAllowedDomainList') | Out-Null
    }

    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '')
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
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    try
    {
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
        $dscContent = [System.Text.StringBuilder]::new()
        $Params = @{
            IsSingleInstance      = 'Yes'
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            CertificatePath       = $CertificatePath
            CertificatePassword   = $CertificatePassword
            ManagedIdentity       = $ManagedIdentity.IsPresent
            Credential            = $Credential
            AccessTokens          = $AccessTokens
        }

        $Results = Get-TargetResource @Params
        if (-1 -eq $Results.RequireAnonymousLinksExpireInDays)
        {
            $Results.Remove('RequireAnonymousLinksExpireInDays') | Out-Null
        }
        $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
            -ConnectionMode $ConnectionMode `
            -ModulePath $PSScriptRoot `
            -Results $Results `
            -Credential $Credential
        [void]$dscContent.Append($currentDSCBlock)
        Save-M365DSCPartialExport -Content $currentDSCBlock `
            -FileName $Global:PartialExportFileName
        Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        return $dscContent.ToString()
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

Export-ModuleMember -Function *-TargetResource
