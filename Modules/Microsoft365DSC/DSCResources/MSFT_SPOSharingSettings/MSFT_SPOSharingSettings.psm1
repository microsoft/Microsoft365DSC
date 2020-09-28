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
        [System.String]
        [ValidateSet("ExistingExternalUserSharingOnly", "ExternalUserAndGuestSharing", "Disabled", "ExternalUserSharingOnly")]
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
        [ValidateSet("None", "View", "Edit")]
        $DefaultLinkPermission,

        [Parameter()]
        [System.boolean]
        $RequireAcceptingAccountMatchInvitedAccount,

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

    Write-Verbose -Message "Getting configuration for SPO Sharing settings"
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
        $SPOSharingSettings = Get-PnPTenant -ErrorAction Stop

        return @{
            IsSingleInstance                           = 'Yes'
            SharingCapability                          = $SPOSharingSettings.SharingCapability
            ShowEveryoneClaim                          = $SPOSharingSettings.ShowEveryoneClaim
            ShowAllUsersClaim                          = $SPOSharingSettings.ShowAllUsersClaim
            ShowEveryoneExceptExternalUsersClaim       = $SPOSharingSettings.ShowEveryoneExceptExternalUsersClaim
            ProvisionSharedWithEveryoneFolder          = $SPOSharingSettings.ProvisionSharedWithEveryoneFolder
            EnableGuestSignInAcceleration              = $SPOSharingSettings.EnableGuestSignInAcceleration
            BccExternalSharingInvitations              = $SPOSharingSettings.BccExternalSharingInvitations
            BccExternalSharingInvitationsList          = $SPOSharingSettings.BccExternalSharingInvitationsList
            RequireAnonymousLinksExpireInDays          = $SPOSharingSettings.RequireAnonymousLinksExpireInDays
            SharingAllowedDomainList                   = $SPOSharingSettings.SharingAllowedDomainList
            SharingBlockedDomainList                   = $SPOSharingSettings.SharingBlockedDomainList
            SharingDomainRestrictionMode               = $SPOSharingSettings.SharingDomainRestrictionMode
            DefaultSharingLinkType                     = $SPOSharingSettings.DefaultSharingLinkType
            PreventExternalUsersFromResharing          = $SPOSharingSettings.PreventExternalUsersFromResharing
            ShowPeoplePickerSuggestionsForGuestUsers   = $SPOSharingSettings.ShowPeoplePickerSuggestionsForGuestUsers
            FileAnonymousLinkType                      = $SPOSharingSettings.FileAnonymousLinkType
            FolderAnonymousLinkType                    = $SPOSharingSettings.FolderAnonymousLinkType
            NotifyOwnersWhenItemsReshared              = $SPOSharingSettings.NotifyOwnersWhenItemsReshared
            DefaultLinkPermission                      = $SPOSharingSettings.DefaultLinkPermission
            RequireAcceptingAccountMatchInvitedAccount = $SPOSharingSettings.RequireAcceptingAccountMatchInvitedAccount
            GlobalAdminAccount                         = $GlobalAdminAccount
            ApplicationId                              = $ApplicationId
            TenantId                                   = $TenantId
            CertificatePassword                        = $CertificatePassword
            CertificatePath                            = $CertificatePath
            CertificateThumbprint                      = $CertificateThumbprint
        }
    }
    catch
    {
        if ($error[0].Exception.Message -like "No connection available")
        {
            Write-Verbose -Message "Make sure that you are connected to your SPOService"
        }
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
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
        [System.String]
        [ValidateSet("ExistingExternalUserSharingOnly", "ExternalUserAndGuestSharing", "Disabled", "ExternalUserSharingOnly")]
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
        [ValidateSet("None", "View", "Edit")]
        $DefaultLinkPermission,

        [Parameter()]
        [System.boolean]
        $RequireAcceptingAccountMatchInvitedAccount,

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

    Write-Verbose -Message "Setting configuration for SPO Sharing settings"
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

    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("GlobalAdminAccount") | Out-Null
    $CurrentParameters.Remove("Ensure") | Out-Null
    $CurrentParameters.Remove("Verbose") | Out-Null
    $CurrentParameters.Remove("IsSingleInstance") | Out-Null
    $CurrentParameters.Remove("ApplicationId") | Out-Null
    $CurrentParameters.Remove("TenantId") | Out-Null
    $CurrentParameters.Remove("CertificatePath") | Out-Null
    $CurrentParameters.Remove("CertificatePassword") | Out-Null
    $CurrentParameters.Remove("CertificateThumbprint") | Out-Null

    if ($null -eq $SignInAccelerationDomain)
    {
        $CurrentParameters.Remove("SignInAccelerationDomain") | Out-Null
        $CurrentParameters.Remove("EnableGuestSignInAcceleration") | Out-Null #removing EnableGuestSignInAcceleration since it can only be configured with a configured SignINAccerlation domain
    }
    if ($SharingCapability -ne "ExternalUserAndGuestSharing")
    {
        Write-Verbose -Message "The sharing capabilities for the tenant are not configured to be ExternalUserAndGuestSharing for that the RequireAnonymousLinksExpireInDays property cannot be configured"
        $CurrentParameters.Remove("RequireAnonymousLinksExpireInDays") | Out-Null
    }
    if ($RequireAcceptingAccountMatchInvitedAccount -eq $false)
    {
        Write-Verbose -Message "RequireAcceptingAccountMatchInvitedAccount is set to be false. For that SharingAllowedDomainList / SharingBlockedDomainList cannot be configured"
        $CurrentParameters.Remove("SharingAllowedDomainList") | Out-Null
        $CurrentParameters.Remove("SharingBlockedDomainList") | Out-Null
    }
    if ($SharingDomainRestrictionMode -eq "None")
    {
        Write-Verbose -Message "SharingDomainRestrictionMode is set to None. For that SharingAllowedDomainList / SharingBlockedDomainList cannot be configured"
        $CurrentParameters.Remove("SharingAllowedDomainList") | Out-Null
        $CurrentParameters.Remove("SharingBlockedDomainList") | Out-Null
    }
    elseif ($SharingDomainRestrictionMode -eq "AllowList")
    {
        Write-Verbose -Message "SharingDomainRestrictionMode is set to AllowList. For that SharingBlockedDomainList cannot be configured"
        $CurrentParameters.Remove("SharingBlockedDomainList") | Out-Null
    }
    elseif ($SharingDomainRestrictionMode -eq "BlockList")
    {
        Write-Verbose -Message "SharingDomainRestrictionMode is set to BlockList. For that SharingAllowedDomainList cannot be configured"
        $CurrentParameters.Remove("SharingAllowedDomainList") | Out-Null
    }
    foreach ($value in $CurrentParameters.GetEnumerator())
    {
        Write-verbose -Message "Configuring Tenant with: $value"
    }
    Set-PnPTenant @CurrentParameters | Out-Null
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
        [System.String]
        [ValidateSet("ExistingExternalUserSharingOnly", "ExternalUserAndGuestSharing", "Disabled", "ExternalUserSharingOnly")]
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
        [ValidateSet("None", "View", "Edit")]
        $DefaultLinkPermission,

        [Parameter()]
        [System.boolean]
        $RequireAcceptingAccountMatchInvitedAccount,

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

    Write-Verbose -Message "Testing configuration for SPO Sharing settings"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @("IsSingleInstance", `
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
            "RequireAcceptingAccountMatchInvitedAccount", `
            "DefaultLinkPermission")

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


    $ConnectionMode = New-M365DSCConnection -Platform 'PNP' `
        -InboundParameters $PSBoundParameters

    try
    {
        $Params = @{
            IsSingleInstance      = "Yes"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificatePassword   = $CertificatePassword
            CertificatePath       = $CertificatePath
            CertificateThumbprint = $CertificateThumbprint
            GlobalAdminAccount    = $GlobalAdminAccount
        }

        $Results = Get-TargetResource @Params
        if (-1 -eq $Results.RequireAnonymousLinksExpireInDays)
        {
            $Results.Remove("RequireAnonymousLinksExpireInDays") | Out-Null
        }
        $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
        $dscContent += Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -GlobalAdminAccount $GlobalAdminAccount
        Write-Host $Global:M365DSCEmojiGreenCheckmark
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
