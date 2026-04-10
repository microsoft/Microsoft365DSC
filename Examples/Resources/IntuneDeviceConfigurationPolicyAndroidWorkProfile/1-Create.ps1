<#
This example creates a new General Device Configuration Policy for Android WorkProfile .
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
        IntuneDeviceConfigurationPolicyAndroidWorkProfile 97ed22e9-1429-40dc-ab3c-0055e538383b
        {
            DisplayName                                    = 'Android Work Profile - Device Restrictions - Standard'
            PasswordBlockFingerprintUnlock                 = $False
            PasswordBlockTrustAgents                       = $False
            PasswordMinimumLength                          = 6
            PasswordMinutesOfInactivityBeforeScreenTimeout = 15
            PasswordRequiredType                           = 'atLeastNumeric'
            SecurityRequireVerifyApps                      = $True
            WorkProfileBlockAddingAccounts                 = $True
            WorkProfileBlockCamera                         = $False
            WorkProfileBlockCrossProfileCallerId           = $False
            WorkProfileBlockCrossProfileContactsSearch     = $False
            WorkProfileBlockCrossProfileCopyPaste          = $True
            WorkProfileBlockNotificationsWhileDeviceLocked = $True
            WorkProfileBlockScreenCapture                  = $True
            WorkProfileBluetoothEnableContactSharing       = $False
            WorkProfileDataSharingType                     = 'allowPersonalToWork'
            WorkProfileDefaultAppPermissionPolicy          = 'deviceDefault'
            WorkProfilePasswordBlockFingerprintUnlock      = $False
            WorkProfilePasswordBlockTrustAgents            = $False
            WorkProfilePasswordRequiredType                = 'deviceDefault'
            WorkProfileRequirePassword                     = $False
            Ensure                                         = 'Present'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
