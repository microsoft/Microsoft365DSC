<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Import-DscResource -ModuleName Microsoft365DSC

    Node localhost
    {
        IntuneAntivirusPolicySecurityExperienceWindows10ConfigMgr "IntuneAntivirusPolicySecurityExperienceWindows10ConfigMgr-Windows ConfigMgr - Windows Security experience"
        {
            ApplicationId                              = $ApplicationId;
            Assignments                                = @();
            CertificateThumbprint                      = $CertificateThumbprint;
            CompanyName                                = "contoso";
            Description                                = "";
            DisableAccountProtectionUI                 = "0";
            DisableAppBrowserUI                        = "1"; # Updated property
            DisableClearTpmButton                      = "0";
            DisableDeviceSecurityUI                    = "0";
            DisableEnhancedNotifications               = "0";
            DisableFamilyUI                            = "0";
            DisableHealthUI                            = "0";
            DisableNetworkUI                           = "0";
            DisableNotifications                       = "1";
            DisableTpmFirmwareUpdateWarning            = "0";
            DisableVirusUI                             = "0";
            DisplayName                                = "Windows ConfigMgr - Windows Security experience";
            Email                                      = "dummy@contoso.com";
            Ensure                                     = "Present";
            HideRansomwareDataRecovery                 = "0";
            HideWindowsSecurityNotificationAreaControl = "1";
            Phone                                      = "asdf";
            RoleScopeTagIds                            = @("0");
            TamperProtection                           = "1";
            TenantId                                   = $TenantId;
            URL                                        = "http://asdf";
        }
    }
}
