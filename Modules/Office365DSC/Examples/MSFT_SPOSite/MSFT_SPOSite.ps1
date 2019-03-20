<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration MSFT_SPOSite
{
    Import-DSCResource -ModuleName Office365DSC
    $credsGlobalAdmin = Get-Credential -UserName "admin@Office365DSC.onmicrosoft.com" -Message "Global Admin"
    Node localhost
    {
        SPOSite ee4a977d-4d7d-4968-9238-2a1702aa699c
        {
            Url                                         = "https://office365dsc.sharepoint.com/sites/testsite"
            ResourceQuota                               = 0
            CentralAdminUrl                             = "https://Office365DSC-admin.sharepoint.com"
            StorageQuota                                = 26214400
            LocaleId                                    = 1033
            Template                                    = "STS#3"
            GlobalAdminAccount                          = $credsGlobalAdmin
            Owner                                       = "admin@Office365DSC.onmicrosoft.com"
            CompatibilityLevel                          = 15
            Title                                       = "TestSite"
            Ensure                                      = "Present"
            #AllowSelfServiceUpgrade                     = $true
            #DenyAddAndCustomizePages                    = "Disabled"
            #ResourceQuotaWarningLevel                   = 0
            #StorageQuotaWarningLevel                    = 25574400
            LockState                                   = "Unlock"
            SharingCapability                           = "Disabled"
            CommentsOnSitePagesDisabled                 = $false
            SocialBarOnSitePagesDisabled                = $false
            #DisableAppViews                             =
            #DisableCompanyWideSharingLinks              =
            #DisableFlows                                =
            #DisabledWebpartIds                          =
            #RestrictedToGeo                             =
            #SharingAllowedDomainList                    =
            #SharingBlockedDomainList                    =
            #SharingDomainRestrictionMode                =
            #ShowPeoplePickerSuggestionsForGuestUsers    =
            #DefaultSharingLinkType                      =
            #DefaultLinkPermission                       =
        }
    }
}

$configData = @{
    AllNodes = @(
        @{
            NodeName                    = "localhost"
            PSDscAllowPlainTextPassword = $true;
            PSDscAllowDomainUser        = $true;
        }
    )
}

MSFT_SPOSite -ConfigurationData $configData
