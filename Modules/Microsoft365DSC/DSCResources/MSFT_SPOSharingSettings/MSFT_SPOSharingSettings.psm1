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
        [System.String[]]
        $SharingAllowedDomainList,

        [Parameter()]
        [System.String[]]
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

    Write-Verbose -Message "Getting configuration for SPO Sharing settings"
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
        $SPOSharingSettings = Get-PnPTenant -ErrorAction Stop

        if ($null -ne $SPOSharingSettings.SharingAllowedDomainList)
        {
            $allowDomains = $SPOSharingSettings.SharingAllowedDomainList.split(" ")
        }

        if ($null -ne $SPOSharingSettings.SharingBlockedDomainList)
        {
            $blockDomains = $SPOSharingSettings.SharingBlockedDomainList.split(" ")
        }

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
            SharingAllowedDomainList                   = $allowDomains
            SharingBlockedDomainList                   = $blockDomains
            SharingDomainRestrictionMode               = $SPOSharingSettings.SharingDomainRestrictionMode
            DefaultSharingLinkType                     = $SPOSharingSettings.DefaultSharingLinkType
            PreventExternalUsersFromResharing          = $SPOSharingSettings.PreventExternalUsersFromResharing
            ShowPeoplePickerSuggestionsForGuestUsers   = $SPOSharingSettings.ShowPeoplePickerSuggestionsForGuestUsers
            FileAnonymousLinkType                      = $SPOSharingSettings.FileAnonymousLinkType
            FolderAnonymousLinkType                    = $SPOSharingSettings.FolderAnonymousLinkType
            NotifyOwnersWhenItemsReshared              = $SPOSharingSettings.NotifyOwnersWhenItemsReshared
            DefaultLinkPermission                      = $SPOSharingSettings.DefaultLinkPermission
            RequireAcceptingAccountMatchInvitedAccount = $SPOSharingSettings.RequireAcceptingAccountMatchInvitedAccount
            Credential                         = $Credential
            ApplicationId                              = $ApplicationId
            TenantId                                   = $TenantId
            ApplicationSecret                          = $ApplicationSecret
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
        [System.String[]]
        $SharingAllowedDomainList,

        [Parameter()]
        [System.String[]]
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

    Write-Verbose -Message "Setting configuration for SPO Sharing settings"

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

    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("Credential") | Out-Null
    $CurrentParameters.Remove("Ensure") | Out-Null
    $CurrentParameters.Remove("Verbose") | Out-Null
    $CurrentParameters.Remove("IsSingleInstance") | Out-Null
    $CurrentParameters.Remove("ApplicationId") | Out-Null
    $CurrentParameters.Remove("TenantId") | Out-Null
    $CurrentParameters.Remove("CertificatePath") | Out-Null
    $CurrentParameters.Remove("CertificatePassword") | Out-Null
    $CurrentParameters.Remove("CertificateThumbprint") | Out-Null
    $CurrentParameters.Remove("ApplicationSecret") | Out-Null

    if ($null -eq $SharingAllowedDomainList -and $null -eq $SharingBlockedDomainList -and
        ($null -ne $RequireAcceptingAccountMatchInvitedAccount -and $RequireAcceptingAccountMatchInvitedAccount -eq $false))
    {
        Write-Verbose -Message "If SharingAllowedDomainList / SharingBlockedDomainList are set to null RequireAcceptingAccountMatchInvitedAccount must be set to True "
        $CurrentParameters.Remove("RequireAcceptingAccountMatchInvitedAccount") | Out-Null
    }

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

    if ($SharingCapability -ne 'ExternalUserAndGuestSharing' -and ($null -ne $FileAnonymousLinkType -or $null -ne $FolderAnonymousLinkType))
    {
        Write-Verbose -Message "If anonymous file or folder links are set, SharingCapability must be set to ExternalUserAndGuestSharing "
        $CurrentParameters.Remove("FolderAnonymousLinkType") | Out-Null
        $CurrentParameters.Remove("FileAnonymousLinkType") | Out-Null
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
        Write-Verbose -Message "Configuring Tenant with: $value"
    }

    if ($null -ne $CurrentParameters["SharingAllowedDomainList"])
    {
        foreach ($allowedDomain in $SharingAllowedDomainList)
        {
            $allowed += $allowedDomain
            $allowed += " "
        }
        $CurrentParameters["SharingAllowedDomainList"] = $allowed.trim()
    }

    if ($null -ne $CurrentParameters["SharingBlockedDomainList"])
    {
        foreach ($blockedDomain in $SharingBlockedDomainList)
        {
            $blocked += $blockedDomain
            $blocked += " "
        }
        $CurrentParameters["SharingBlockedDomainList"] = $blocked.Trim()
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
        [System.String[]]
        $SharingAllowedDomainList,

        [Parameter()]
        [System.String[]]
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
        $ConnectionMode = New-M365DSCConnection -Workload 'PNP' `
            -InboundParameters $PSBoundParameters

        #region Telemetry
        $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
        $CommandName  = $MyInvocation.MyCommand
        $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
            -CommandName $CommandName `
            -Parameters $PSBoundParameters
        Add-M365DSCTelemetryEvent -Data $data
        #endregion

        $Params = @{
            IsSingleInstance      = "Yes"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificatePassword   = $CertificatePassword
            CertificatePath       = $CertificatePath
            CertificateThumbprint = $CertificateThumbprint
            Credential    = $Credential
        }

        $Results = Get-TargetResource @Params
        if (-1 -eq $Results.RequireAnonymousLinksExpireInDays)
        {
            $Results.Remove("RequireAnonymousLinksExpireInDays") | Out-Null
        }
        $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
            -Results $Results
        $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
            -ConnectionMode $ConnectionMode `
            -ModulePath $PSScriptRoot `
            -Results $Results `
            -Credential $Credential
        $dscContent += $currentDSCBlock
        Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
        Write-Host $Global:M365DSCEmojiGreenCheckmark
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
