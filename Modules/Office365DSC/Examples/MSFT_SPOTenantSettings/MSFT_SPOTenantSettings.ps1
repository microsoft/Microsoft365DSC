<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration MSFT_SPOTenantSettings
{
    Import-DSCResource -ModuleName Office365DSC
    $credsGlobalAdmin = Get-Credential -UserName "TenantAdmin@O365DSC1.onmicrosoft.com" -Message "Global Admin"
    Node localhost
    {
        SPOTenantSettings MyTenantSettings
        {
            IsSingleInstance             = "Yes"
            CentralAdminUrl              = "https://o365dsc1-admin.sharepoint.com"
            GlobalAdminAccount           = $credsGlobalAdmin
            MinCompatibilityLevel                           = 16
            MaxCompatibilityLevel                           = 16
            SearchResolveExactEmailOrUPN                    = $false
            OfficeClientADALDisabled                        = $false
            LegacyAuthProtocolsEnabled                      = $true
            RequireAcceptingAccountMatchInvitedAccount      = $true
            SignInAccelerationDomain                        = ""
            UsePersistentCookiesForExplorerView             = $false
            UserVoiceForFeedbackEnabled                     = $true
            PublicCdnEnabled                                = $false
            PublicCdnAllowedFileTypes                       = "CSS,EOT,GIF,ICO,JPEG,JPG,JS,MAP,PNG,SVG,TTF,WOFF"
            UseFindPeopleInPeoplePicker                     = $false
            NotificationsInSharePointEnabled                = $true
            OwnerAnonymousNotification                      = $true
            ApplyAppEnforcedRestrictionsToAdHocRecipients   = $true
            FilePickerExternalImageSearchEnabled            = $true
            HideDefaultThemes                               = $false
        }
    }
}

$configData = @{
    AllNodes = @(
        @{
            NodeName = "localhost"
            PSDscAllowPlainTextPassword = $true;
            PSDscAllowDomainUser = $true;
        }
    )
}

MSFT_SPOTenantSettings -ConfigurationData $configData
