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
        [System.Boolean]
        $RequireAcceptingAccountMatchInvitedAccount,

        [Parameter()]
        [System.String]
        $SignInAccelerationDomain,

        [Parameter()]
        [System.Boolean]
        $UsePersistentCookiesForExplorerView,

        [Parameter()]
        [System.Boolean]
        $UserVoiceForFeedbackEnabled,

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

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter()]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration for SPO Tenant"

    Test-PnPOnlineConnection -SiteUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount

    $nullReturn = @{
        IsSingleInstance                              = 'Yes'
        MinCompatibilityLevel                         = $null
        MaxCompatibilityLevel                         = $null
        SearchResolveExactEmailOrUPN                  = $null
        OfficeClientADALDisabled                      = $null
        LegacyAuthProtocolsEnabled                    = $null
        RequireAcceptingAccountMatchInvitedAccount    = $null
        SignInAccelerationDomain                      = $null
        UsePersistentCookiesForExplorerView           = $null
        UserVoiceForFeedbackEnabled                   = $null
        PublicCdnEnabled                              = $null
        PublicCdnAllowedFileTypes                     = $null
        UseFindPeopleInPeoplePicker                   = $null
        NotificationsInSharePointEnabled              = $null
        OwnerAnonymousNotification                    = $null
        ApplyAppEnforcedRestrictionsToAdHocRecipients = $null
        FilePickerExternalImageSearchEnabled          = $null
        HideDefaultThemes                             = $null
        CentralAdminUrl                               = $null
        GlobalAdminAccount                            = $null
    }

    try
    {
        $SPOTenantSettings = Get-PNPTenant

        return @{
            IsSingleInstance                              = 'Yes'
            MinCompatibilityLevel                         = $SPOTenantSettings.MinCompatibilityLevel
            MaxCompatibilityLevel                         = $SPOTenantSettings.MaxCompatibilityLevel
            SearchResolveExactEmailOrUPN                  = $SPOTenantSettings.SearchResolveExactEmailOrUPN
            OfficeClientADALDisabled                      = $SPOTenantSettings.OfficeClientADALDisabled
            LegacyAuthProtocolsEnabled                    = $SPOTenantSettings.LegacyAuthProtocolsEnabled
            RequireAcceptingAccountMatchInvitedAccount    = $SPOTenantSettings.RequireAcceptingAccountMatchInvitedAccount
            SignInAccelerationDomain                      = $SPOTenantSettings.SignInAccelerationDomain
            UsePersistentCookiesForExplorerView           = $SPOTenantSettings.UsePersistentCookiesForExplorerView
            UserVoiceForFeedbackEnabled                   = $SPOTenantSettings.UserVoiceForFeedbackEnabled
            PublicCdnEnabled                              = $SPOTenantSettings.PublicCdnEnabled
            PublicCdnAllowedFileTypes                     = $SPOTenantSettings.PublicCdnAllowedFileTypes
            UseFindPeopleInPeoplePicker                   = $SPOTenantSettings.UseFindPeopleInPeoplePicker
            NotificationsInSharePointEnabled              = $SPOTenantSettings.NotificationsInSharePointEnabled
            OwnerAnonymousNotification                    = $SPOTenantSettings.OwnerAnonymousNotification
            ApplyAppEnforcedRestrictionsToAdHocRecipients = $SPOTenantSettings.ApplyAppEnforcedRestrictionsToAdHocRecipients
            FilePickerExternalImageSearchEnabled          = $SPOTenantSettings.FilePickerExternalImageSearchEnabled
            HideDefaultThemes                             = $SPOTenantSettings.HideDefaultThemes
            CentralAdminUrl                               = $CentralAdminUrl
            GlobalAdminAccount                            = $GlobalAdminAccount
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
        [System.Boolean]
        $RequireAcceptingAccountMatchInvitedAccount,

        [Parameter()]
        [System.String]
        $SignInAccelerationDomain,

        [Parameter()]
        [System.Boolean]
        $UsePersistentCookiesForExplorerView,

        [Parameter()]
        [System.Boolean]
        $UserVoiceForFeedbackEnabled,

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

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter()]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration for SPO Tenant"

    Test-PnPOnlineConnection -SiteUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount

    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("CentralAdminUrl")
    $CurrentParameters.Remove("GlobalAdminAccount")
    $CurrentParameters.Remove("IsSingleInstance")

    if($PublicCdnEnabled -eq $false)
    {
        Write-Verbose -Message "The use of the public CDN is not enabled, for that the PublicCdnAllowedFileTypes parameter can not be configured and will be removed"
        $CurrentParameters.Remove("PublicCdnAllowedFileTypes")
    }
    $tenant = Set-PnPTenant @CurrentParameters
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
        [System.Boolean]
        $RequireAcceptingAccountMatchInvitedAccount,

        [Parameter()]
        [System.String]
        $SignInAccelerationDomain,

        [Parameter()]
        [System.Boolean]
        $UsePersistentCookiesForExplorerView,

        [Parameter()]
        [System.Boolean]
        $UserVoiceForFeedbackEnabled,

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

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter()]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration for SPO Tenant"

    Test-PnPOnlineConnection -SiteUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-O365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-O365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
                                                  -DesiredValues $PSBoundParameters `
                                                  -ValuesToCheck @("IsSingleInstance", `
                                                                   "CentralAdminUrl", `
                                                                   "GlobalAdminAccount", `
                                                                   "MaxCompatibilityLevel", `
                                                                   "SearchResolveExactEmailOrUPN", `
                                                                   "OfficeClientADALDisabled", `
                                                                   "LegacyAuthProtocolsEnabled", `
                                                                   "RequireAcceptingAccountMatchInvitedAccount", `
                                                                   "SignInAccelerationDomain", `
                                                                   "UsePersistentCookiesForExplorerView", `
                                                                   "UserVoiceForFeedbackEnabled", `
                                                                   "PublicCdnEnabled", `
                                                                   "PublicCdnAllowedFileTypes", `
                                                                   "UseFindPeopleInPeoplePicker", `
                                                                   "NotificationsInSharePointEnabled", `
                                                                   "OwnerAnonymousNotification", `
                                                                   "ApplyAppEnforcedRestrictionsToAdHocRecipients", `
                                                                   "FilePickerExternalImageSearchEnabled", `
                                                                   "HideDefaultThemes")

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
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    Test-PnPOnlineConnection -GlobalAdminAccount $GlobalAdminAccount -SiteUrl $CentralAdminUrl

    $result = Get-TargetResource @PSBoundParameters
    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
    $content = "SPOTenantSettings " + (New-GUID).ToString() + "`r`n"
    $content += "{`r`n"
    $content += Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += "}`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
