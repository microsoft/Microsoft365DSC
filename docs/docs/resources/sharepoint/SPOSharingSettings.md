﻿# SPOSharingSettings

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Specifies the resource is a single instance, the value must be 'Yes' |Yes|
| **SharingCapability** | Write | String | Configures anonymous link types for folders |ExistingExternalUserSharingOnly, ExternalUserAndGuestSharing, Disabled, ExternalUserSharingOnly|
| **MySiteSharingCapability** | Write | String | Configures sharing capability for mysite (onedrive) |ExistingExternalUserSharingOnly, ExternalUserAndGuestSharing, Disabled, ExternalUserSharingOnly|
| **ShowEveryoneClaim** | Write | Boolean | Enables the administrator to hide the Everyone claim in the People Picker. ||
| **ShowAllUsersClaim** | Write | Boolean | Enables the administrator to hide the All Users claim groups in People Picker. ||
| **ShowEveryoneExceptExternalUsersClaim** | Write | Boolean | Enables the administrator to hide the Everyone except external users claim in the People Picker. ||
| **ProvisionSharedWithEveryoneFolder** | Write | Boolean | Creates a Shared with Everyone folder in every user's new OneDrive for Business document library. ||
| **EnableGuestSignInAcceleration** | Write | Boolean | Accelerates guest-enabled site collections as well as member-only site collections when the SignInAccelerationDomain parameter is set. ||
| **BccExternalSharingInvitations** | Write | Boolean | When the feature is enabled, all external sharing invitations that are sent will blind copy the e-mail messages listed in the BccExternalSharingsInvitationList. ||
| **BccExternalSharingInvitationsList** | Write | String | Specifies a list of e-mail addresses to be BCC'd when the BCC for External Sharing feature is enabled.Multiple addresses can be specified by creating a comma separated list with no spaces. ||
| **RequireAnonymousLinksExpireInDays** | Write | UInt32 | Specifies all anonymous links that have been created (or will be created) will expire after the set number of days. ||
| **SharingAllowedDomainList** | Write | StringArray[] | Specifies a list of email domains that is allowed for sharing with the external collaborators. Entry values as an array of domains. ||
| **SharingBlockedDomainList** | Write | StringArray[] | Specifies a list of email domains that is blocked or prohibited for sharing with the external collaborators. Entry values as an array of domains. ||
| **SharingDomainRestrictionMode** | Write | String | Specifies the external sharing mode for domains. |None, AllowList, BlockList|
| **DefaultSharingLinkType** | Write | String | Lets administrators choose what type of link appears is selected in the 'Get a link' sharing dialog box in OneDrive for Business and SharePoint Online |None, Direct, Internal, AnonymousAccess|
| **PreventExternalUsersFromResharing** | Write | Boolean | Allow or deny external users re-sharing ||
| **ShowPeoplePickerSuggestionsForGuestUsers** | Write | Boolean | Enables the administrator to hide the guest users claim in the People Picker. ||
| **FileAnonymousLinkType** | Write | String | Configures anonymous link types for files |View, Edit|
| **FolderAnonymousLinkType** | Write | String | Configures anonymous link types for folders |View, Edit|
| **NotifyOwnersWhenItemsReshared** | Write | Boolean | When this parameter is set to $true and another user re-shares a document from a userâs OneDrive for Business, the OneDrive for Business owner is notified by e-mail. ||
| **DefaultLinkPermission** | Write | String | Specifies the link permission on the tenant level. |None, View, Edit|
| **RequireAcceptingAccountMatchInvitedAccount** | Write | Boolean | Ensures that an external user can only accept an external sharing invitation with an account matching the invited email address.Administrators who desire increased control over external collaborators should consider enabling this feature. False (default) - When a document is shared with an external user, bob@contoso.com, it can be accepted by any user with access to the invitation link in the original e-mail.True - User must accept this invitation with bob@contoso.com. ||
| **Ensure** | Write | String | Only accepted value is 'Present'. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the account to authenticate with. ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **ApplicationSecret** | Write | String | Secret of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com ||
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for certificatePassword ||
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||


# SPOSharingSettings

### Description

This resource allows users to configure and monitor the sharing settings for
your SPO tenant sharing settings

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
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
        SPOSharingSettings 'ConfigureSharingSettings'
        {
            IsSingleInstance                           = "Yes"
            SharingCapability                          = 'ExternalUserSharingOnly'
            ShowEveryoneClaim                          = $false
            ShowAllUsersClaim                          = $false
            ShowEveryoneExceptExternalUsersClaim       = $true
            ProvisionSharedWithEveryoneFolder          = $false
            EnableGuestSignInAcceleration              = $false
            BccExternalSharingInvitations              = $false
            BccExternalSharingInvitationsList          = ""
            RequireAnonymousLinksExpireInDays          = 730
            SharingAllowedDomainList                   = @("contoso.com")
            SharingBlockedDomainList                   = @("contoso.com")
            SharingDomainRestrictionMode               = "None"
            DefaultSharingLinkType                     = "AnonymousAccess"
            PreventExternalUsersFromResharing          = $false
            ShowPeoplePickerSuggestionsForGuestUsers   = $false
            FileAnonymousLinkType                      = "Edit"
            FolderAnonymousLinkType                    = "Edit"
            NotifyOwnersWhenItemsReshared              = $true
            DefaultLinkPermission                      = "View"
            RequireAcceptingAccountMatchInvitedAccount = $false
            Ensure                                     = "Present"
            Credential                                 = $credsGlobalAdmin
        }
    }
}
```

