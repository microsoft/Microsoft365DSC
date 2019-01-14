Configuration MSFT_SPOSharingSettings
{
    Import-DSCResource -ModuleName Office365DSC
    $credsGlobalAdmin = Get-Credential -UserName "TenantAdmin@O365DSC1.onmicrosoft.com" -Message "Global Admin"
    Node localhost
    {
        SPOSharingSettings MyTenant
        {
            Tenant                                        = "MyTenant"
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
            RequireAnonymousLinksExpireInDays             = 730 # setting the value back to 0 caused an error value has to be between 1 and 790 even though documented differently
            SharingAllowedDomainList                      = "contoso.com"
            SharingBlockedDomainList                      = "contoso.com"
            SharingDomainRestrictionMode                  = "None"
            DefaultSharingLinkType                        = "AnonymousAccess" #According to the documentation the options should be None Direct Internal AnonymousAccess / during my tests I was not able to set it to None (all other options worked fine)
            PreventExternalUsersFromResharing             = $false
            ShowPeoplePickerSuggestionsForGuestUsers      = $false
            FileAnonymousLinkType                         = "Edit" #According to the documentation None should be an option but when running the set-spotenant cmdlet it will tell you that it is just View or Edit
            FolderAnonymousLinkType                       = "Edit" #According to the documentation None should be an option but when running the set-spotenant cmdlet it will tell you that it is just View or Edit
            NotifyOwnersWhenItemsReshared                 = $true
            DefaultLinkPermission ="View" #Not documented under https://docs.microsoft.com/en-us/powershell/module/sharepoint-online/set-spotenant?view=sharepoint-ps initial value is None, once changed it cannot be re-set to None again
            RequireAcceptingAccountMatchInvitedAccount = $false
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
MSFT_SPOSharingSettings -ConfigurationData $configData
