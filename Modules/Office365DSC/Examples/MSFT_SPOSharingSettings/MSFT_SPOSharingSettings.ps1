<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration SharingSettingsConfig
{
    Import-DSCResource -ModuleName Office365DSC
    $credsGlobalAdmin = Get-Credential -UserName "TenantAdmin@O365DSC1.onmicrosoft.com" -Message "Global Admin"
    Node localhost
    {
        SPOSharingSettings MyTenant
        {
            IsSingleInstance                              = "Yes"
            CentralAdminUrl                               = "https://o365dsc1-admin.sharepoint.com"
            GlobalAdminAccount                            = $credsGlobalAdmin
            SharingCapability                             = 'ExternalUserSharingOnly'
            ShowEveryoneClaim                             = $false
            ShowAllUsersClaim                             = $false
            ShowEveryoneExceptExternalUsersClaim          = $true
            ProvisionSharedWithEveryoneFolder             = $false
            EnableGuestSignInAcceleration                 = $false
            BccExternalSharingInvitations                 = $false
            BccExternalSharingInvitationsList             = ""
            RequireAnonymousLinksExpireInDays             = 730
            SharingAllowedDomainList                      = "contoso.com"
            SharingBlockedDomainList                      = "contoso.com"
            SharingDomainRestrictionMode                  = "None"
            DefaultSharingLinkType                        = "AnonymousAccess"
            PreventExternalUsersFromResharing             = $false
            ShowPeoplePickerSuggestionsForGuestUsers      = $false
            FileAnonymousLinkType                         = "Edit"
            FolderAnonymousLinkType                       = "Edit"
            NotifyOwnersWhenItemsReshared                 = $true
            DefaultLinkPermission                         ="View"
            RequireAcceptingAccountMatchInvitedAccount    = $false
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

SharingSettingsConfig -ConfigurationData $configData
