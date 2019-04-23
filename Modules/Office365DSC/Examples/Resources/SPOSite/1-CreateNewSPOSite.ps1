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
    Import-DscResource -ModuleName Office365DSC

    node localhost
    {
        SPOSite ee4a977d-4d7d-4968-9238-2a1702aa699c
        {
            Url                                         = "https://office365dsc.sharepoint.com/sites/testsite1"
            CentralAdminUrl                             = "https://Office365DSC-admin.sharepoint.com"
            StorageQuota                                = 26214400
            LocaleId                                    = 1033
            Template                                    = "STS#3"
            GlobalAdminAccount                          = $credsGlobalAdmin
            Owner                                       = "admin@Office365DSC.onmicrosoft.com"
            CompatibilityLevel                          = 15
            Title                                       = "TestSite"
            Ensure                                      = "Present"
            DenyAddAndCustomizePages                    = $false
            StorageQuotaWarningLevel                    = 25574400
            LockState                                   = "Unlock"
            SharingCapability                           = "Disabled"
            CommentsOnSitePagesDisabled                 = $false
            SocialBarOnSitePagesDisabled                = $false
            DisableAppViews                             = "NotDisabled"
            DisableCompanyWideSharingLinks              = "NotDisabled"
            DisableFlows                                = "NotDisabled"
            RestrictedToGeo                             = "BlockMoveOnly"
            SharingDomainRestrictionMode                = "None"
            SharingAllowedDomainList                    = ""
            SharingBlockedDomainList                    = ""
            ShowPeoplePickerSuggestionsForGuestUsers    = $false
            DefaultSharingLinkType                      = "None"
            DefaultLinkPermission                       = "None"
        }
        SPOSite ecd9c36d-d67b-46e6-801d-6faf145fd1d5
        {
            Url                                         = "https://office365dsc.sharepoint.com/sites/testsite2"
            CentralAdminUrl                             = "https://Office365DSC-admin.sharepoint.com"
            StorageQuota                                = 26214400
            LocaleId                                    = 1033
            Template                                    = "STS#3"
            GlobalAdminAccount                          = $credsGlobalAdmin
            Owner                                       = "admin@Office365DSC.onmicrosoft.com"
            CompatibilityLevel                          = 15
            Title                                       = "TestSite"
            Ensure                                      = "Present"
            DenyAddAndCustomizePages                    = $false
            StorageQuotaWarningLevel                    = 25574400
            LockState                                   = "Unlock"
            SharingCapability                           = "Disabled"
            CommentsOnSitePagesDisabled                 = $false
            SocialBarOnSitePagesDisabled                = $false
            DisableAppViews                             = "NotDisabled"
            DisableCompanyWideSharingLinks              = "NotDisabled"
            DisableFlows                                = "NotDisabled"
            RestrictedToGeo                             = "BlockMoveOnly"
            SharingDomainRestrictionMode                = "None"
            SharingAllowedDomainList                    = ""
            SharingBlockedDomainList                    = ""
            ShowPeoplePickerSuggestionsForGuestUsers    = $false
            DefaultSharingLinkType                      = "None"
            DefaultLinkPermission                       = "None"
        }
        SPOSite 6603245d-2cf0-45fa-b2ce-46060b2ffaca
        {
            Url                                         = "https://office365dsc.sharepoint.com/sites/testsite3"
            CentralAdminUrl                             = "https://Office365DSC-admin.sharepoint.com"
            StorageQuota                                = 26214400
            LocaleId                                    = 1033
            Template                                    = "STS#3"
            GlobalAdminAccount                          = $credsGlobalAdmin
            Owner                                       = "admin@Office365DSC.onmicrosoft.com"
            CompatibilityLevel                          = 15
            Title                                       = "TestSite"
            Ensure                                      = "Present"
            DenyAddAndCustomizePages                    = $false
            StorageQuotaWarningLevel                    = 25574400
            LockState                                   = "Unlock"
            SharingCapability                           = "ExternalUserSharingOnly"
            CommentsOnSitePagesDisabled                 = $false
            SocialBarOnSitePagesDisabled                = $false
            DisableAppViews                             = "NotDisabled"
            DisableCompanyWideSharingLinks              = "NotDisabled"
            DisableFlows                                = "NotDisabled"
            RestrictedToGeo                             = "BlockMoveOnly"
            SharingDomainRestrictionMode                = "None"
            SharingAllowedDomainList                    = ""
            SharingBlockedDomainList                    = ""
            ShowPeoplePickerSuggestionsForGuestUsers    = $false
            DefaultSharingLinkType                      = "None"
            DefaultLinkPermission                       = "None"
        }
        SPOSite ff3f784a-5611-4f61-81a4-4e17b1ee382b
        {
            Url                                         = "https://office365dsc.sharepoint.com/sites/testsite4"
            CentralAdminUrl                             = "https://Office365DSC-admin.sharepoint.com"
            StorageQuota                                = 26214400
            LocaleId                                    = 1033
            Template                                    = "STS#3"
            GlobalAdminAccount                          = $credsGlobalAdmin
            Owner                                       = "admin@Office365DSC.onmicrosoft.com"
            CompatibilityLevel                          = 15
            Title                                       = "TestSite"
            Ensure                                      = "Present"
            DenyAddAndCustomizePages                    = $false
            StorageQuotaWarningLevel                    = 25574400
            LockState                                   = "Unlock"
            SharingCapability                           = "ExistingExternalUserSharingOnly"
            CommentsOnSitePagesDisabled                 = $false
            SocialBarOnSitePagesDisabled                = $false
            DisableAppViews                             = "NotDisabled"
            DisableCompanyWideSharingLinks              = "NotDisabled"
            DisableFlows                                = "NotDisabled"
            RestrictedToGeo                             = "BlockMoveOnly"
            SharingDomainRestrictionMode                = "None"
            SharingAllowedDomainList                    = ""
            SharingBlockedDomainList                    = ""
            ShowPeoplePickerSuggestionsForGuestUsers    = $false
            DefaultSharingLinkType                      = "None"
            DefaultLinkPermission                       = "None"
        }
        SPOSite dedbecc0-f869-4e8b-8518-f4d15e6257d7
        {
            Url                                         = "https://office365dsc.sharepoint.com/sites/testsite5"
            CentralAdminUrl                             = "https://Office365DSC-admin.sharepoint.com"
            StorageQuota                                = 26214400
            LocaleId                                    = 1033
            Template                                    = "STS#3"
            GlobalAdminAccount                          = $credsGlobalAdmin
            Owner                                       = "admin@Office365DSC.onmicrosoft.com"
            CompatibilityLevel                          = 15
            Title                                       = "TestSite"
            Ensure                                      = "Present"
            DenyAddAndCustomizePages                    = $false
            StorageQuotaWarningLevel                    = 25574400
            LockState                                   = "Unlock"
            SharingCapability                           = "ExistingExternalUserSharingOnly"
            CommentsOnSitePagesDisabled                 = $false
            SocialBarOnSitePagesDisabled                = $false
            DisableAppViews                             = "NotDisabled"
            DisableCompanyWideSharingLinks              = "NotDisabled"
            DisableFlows                                = "NotDisabled"
            RestrictedToGeo                             = "BlockMoveOnly"
            SharingDomainRestrictionMode                = "None"
            SharingAllowedDomainList                    = ""
            SharingBlockedDomainList                    = ""
            ShowPeoplePickerSuggestionsForGuestUsers    = $false
            DefaultSharingLinkType                      = "None"
            DefaultLinkPermission                       = "None"
        }
    }
}
