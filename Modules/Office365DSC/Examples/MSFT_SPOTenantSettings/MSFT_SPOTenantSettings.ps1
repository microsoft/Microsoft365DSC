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
            MinCompatibilityLevel                           = 15
            #MaxCompatibilityLevel                           = $null
            #SearchResolveExactEmailOrUPN                    = $null
            #OfficeClientADALDisabled                        = $null
            #LegacyAuthProtocolsEnabled                      = $null
            #RequireAcceptingAccountMatchInvitedAccount      = $null
            #SignInAccelerationDomain                        = $null
            #UsePersistentCookiesForExplorerView             = $null
            #UserVoiceForFeedbackEnabled                     = $null
            #PublicCdnEnabled                                = $null
            #PublicCdnAllowedFileTypes                       = $null
            #UseFindPeopleInPeoplePicker                     = $null
            #NotificationsInSharePointEnabled                = $null
            #OwnerAnonymousNotification                      = $null
            #ApplyAppEnforcedRestrictionsToAdHocRecipients   = $null
            #FilePickerExternalImageSearchEnabled            = $null
            #HideDefaultThemes                               = $null
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
