<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        SPOSharingSettings MyTenant
        {
            IsSingleInstance                           = "Yes"
            GlobalAdminAccount                         = $credsGlobalAdmin
            SharingCapability                          = 'ExternalUserSharingOnly'
            ShowEveryoneClaim                          = $false
            ShowAllUsersClaim                          = $false
            ShowEveryoneExceptExternalUsersClaim       = $true
            ProvisionSharedWithEveryoneFolder          = $false
            EnableGuestSignInAcceleration              = $false
            BccExternalSharingInvitations              = $false
            BccExternalSharingInvitationsList          = ""
            RequireAnonymousLinksExpireInDays          = 730
            SharingAllowedDomainList                   = "contoso.com"
            SharingBlockedDomainList                   = "contoso.com"
            SharingDomainRestrictionMode               = "None"
            DefaultSharingLinkType                     = "AnonymousAccess"
            PreventExternalUsersFromResharing          = $false
            ShowPeoplePickerSuggestionsForGuestUsers   = $false
            FileAnonymousLinkType                      = "Edit"
            FolderAnonymousLinkType                    = "Edit"
            NotifyOwnersWhenItemsReshared              = $true
            DefaultLinkPermission                         ="View"
            RequireAcceptingAccountMatchInvitedAccount = $false
            Ensure                                     = "Present"
        }
    }
}
