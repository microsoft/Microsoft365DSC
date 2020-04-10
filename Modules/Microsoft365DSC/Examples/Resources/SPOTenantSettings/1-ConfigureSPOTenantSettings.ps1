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
        SPOTenantSettings MyTenantSettings
        {
            IsSingleInstance                              = "Yes"
            GlobalAdminAccount                            = $credsGlobalAdmin
            MinCompatibilityLevel                         = 16
            MaxCompatibilityLevel                         = 16
            SearchResolveExactEmailOrUPN                  = $false
            OfficeClientADALDisabled                      = $false
            LegacyAuthProtocolsEnabled                    = $true
            RequireAcceptingAccountMatchInvitedAccount    = $true
            SignInAccelerationDomain                      = ""
            UsePersistentCookiesForExplorerView           = $false
            UserVoiceForFeedbackEnabled                   = $true
            PublicCdnEnabled                              = $false
            PublicCdnAllowedFileTypes                     = "CSS,EOT,GIF,ICO,JPEG,JPG,JS,MAP,PNG,SVG,TTF,WOFF"
            UseFindPeopleInPeoplePicker                   = $false
            NotificationsInSharePointEnabled              = $true
            OwnerAnonymousNotification                    = $true
            ApplyAppEnforcedRestrictionsToAdHocRecipients = $true
            FilePickerExternalImageSearchEnabled          = $true
            HideDefaultThemes                             = $false
            Ensure                                        = "Present"
        }
    }
}
