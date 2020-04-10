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

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration for SPO Sharing settings"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform PnP

    $nullReturn = @{
        IsSingleInstance                           = 'Yes'
        SharingCapability                          = $null
        ShowEveryoneClaim                          = $null
        ShowAllUsersClaim                          = $null
        ShowEveryoneExceptExternalUsersClaim       = $null
        ProvisionSharedWithEveryoneFolder          = $null
        EnableGuestSignInAcceleration              = $null
        BccExternalSharingInvitations              = $null
        BccExternalSharingInvitationsList          = $null
        RequireAnonymousLinksExpireInDays          = $null
        SharingAllowedDomainList                   = $null
        SharingBlockedDomainList                   = $null
        SharingDomainRestrictionMode               = $null
        DefaultSharingLinkType                     = $null
        PreventExternalUsersFromResharing          = $null
        ShowPeoplePickerSuggestionsForGuestUsers   = $null
        FileAnonymousLinkType                      = $null
        FolderAnonymousLinkType                    = $null
        NotifyOwnersWhenItemsReshared              = $null
        DefaultLinkPermission                      = $null
        RequireAcceptingAccountMatchInvitedAccount = $null
        GlobalAdminAccount                         = $null
    }

    try
    {
        $SPOSharingSettings = Get-PnPTenant

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
        }
    }
    catch
    {
        if ($error[0].Exception.Message -like "No connection available")
        {
            Write-Verbose -Message "Make sure that you are connected to your SPOService"
        }
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

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration for SPO Sharing settings"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform PnP

    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("GlobalAdminAccount")
    $CurrentParameters.Remove("Verbose")
    $CurrentParameters.Remove("IsSingleInstance")

    if ($null -eq $SignInAccelerationDomain)
    {
        $CurrentParameters.Remove("SignInAccelerationDomain")
        $CurrentParameters.Remove("EnableGuestSignInAcceleration")#removing EnableGuestSignInAcceleration since it can only be configured with a configured SignINAccerlation domain
    }
    if ($SharingCapability -ne "ExternalUserAndGuestSharing")
    {
        Write-Verbose -Message "The sharing capabilities for the tenant are not configured to be ExternalUserAndGuestSharing for that the RequireAnonymousLinksExpireInDays property cannot be configured"
        $CurrentParameters.Remove("RequireAnonymousLinksExpireInDays")
    }
    if ($RequireAcceptingAccountMatchInvitedAccount -eq $false)
    {
        Write-Verbose -Message "RequireAcceptingAccountMatchInvitedAccount is set to be false. For that SharingAllowedDomainList / SharingBlockedDomainList cannot be configured"
        $CurrentParameters.Remove("SharingAllowedDomainList")
        $CurrentParameters.Remove("SharingBlockedDomainList")
    }
    if ($SharingDomainRestrictionMode -eq "None")
    {
        Write-Verbose -Message "SharingDomainRestrictionMode is set to None. For that SharingAllowedDomainList / SharingBlockedDomainList cannot be configured"
        $CurrentParameters.Remove("SharingAllowedDomainList")
        $CurrentParameters.Remove("SharingBlockedDomainList")
    }
    elseif ($SharingDomainRestrictionMode -eq "AllowList")
    {
        Write-Verbose -Message "SharingDomainRestrictionMode is set to AllowList. For that SharingBlockedDomainList cannot be configured"
        $CurrentParameters.Remove("SharingBlockedDomainList")
    }
    elseif ($SharingDomainRestrictionMode -eq "BlockList")
    {
        Write-Verbose -Message "SharingDomainRestrictionMode is set to BlockList. For that SharingAllowedDomainList cannot be configured"
        $CurrentParameters.Remove("SharingAllowedDomainList")
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

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration for SPO Sharing settings"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-Microsoft365DSCParameterState -CurrentValues $CurrentValues `
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
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    $PSBoundParameters.Add("IsSingleInstance", "Yes")
    $result = Get-TargetResource @PSBoundParameters
    if (-1 -eq $result.RequireAnonymousLinksExpireInDays)
    {
        $result.Remove("RequireAnonymousLinksExpireInDays")
    }
    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
    $content = "        SPOSharingSettings " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
