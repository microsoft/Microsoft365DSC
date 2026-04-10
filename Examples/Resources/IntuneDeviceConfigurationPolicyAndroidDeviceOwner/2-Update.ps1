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

    node localhost
    {
        IntuneDeviceConfigurationPolicyAndroidDeviceOwner 'myAndroidDeviceOwnerPolicy'
        {
            DisplayName                           = 'general confi - AndroidDeviceOwner'
            Assignments                           = @()
            AzureAdSharedDeviceDataClearApps      = @()
            CameraBlocked                         = $False # Updated Property
            CrossProfilePoliciesAllowDataSharing  = 'notConfigured'
            EnrollmentProfile                     = 'notConfigured'
            FactoryResetDeviceAdministratorEmails = @()
            GlobalProxy                           = MSFT_MicrosoftGraphandroiddeviceownerglobalproxy {
                odataType = '#microsoft.graph.androidDeviceOwnerGlobalProxyDirect'
                host      = 'myproxy.com'
                port      = 8083
            }
            KioskCustomizationStatusBar           = 'notConfigured'
            KioskCustomizationSystemNavigation    = 'notConfigured'
            KioskModeAppPositions                 = @()
            KioskModeApps                         = @()
            KioskModeManagedFolders               = @()
            KioskModeUseManagedHomeScreenApp      = 'notConfigured'
            KioskModeWifiAllowedSsids             = @()
            MicrophoneForceMute                   = $True
            NfcBlockOutgoingBeam                  = $True
            PasswordBlockKeyguardFeatures         = @()
            PasswordRequiredType                  = 'deviceDefault'
            PasswordRequireUnlock                 = 'deviceDefault'
            PersonalProfilePersonalApplications   = @()
            PersonalProfilePlayStoreMode          = 'notConfigured'
            ScreenCaptureBlocked                  = $True
            SecurityRequireVerifyApps             = $True
            StayOnModes                           = @()
            StorageBlockExternalMedia             = $True
            SystemUpdateFreezePeriods             = @(
                MSFT_MicrosoftGraphandroiddeviceownersystemupdatefreezeperiod {
                    startMonth = 12
                    startDay   = 23
                    endMonth   = 12
                    endDay     = 30
                })
            VpnAlwaysOnLockdownMode               = $False
            VpnAlwaysOnPackageIdentifier          = ''
            WorkProfilePasswordRequiredType       = 'deviceDefault'
            WorkProfilePasswordRequireUnlock      = 'deviceDefault'
            Ensure                                = 'Present'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
