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
        IntuneDeviceManagementAndroidDeviceOwnerEnrollmentProfile 'CreateProfile'
        {
            Id                      = "164655f7-1232-4d56-ae8f-b095196a0309"
            DisplayName             = "Android Owner Enrollment Profile"
            Description             = "Profile for enrolling Android devices"
            TokenExpirationDateTime = "2024-12-31T23:59:59Z"
            TokenValue              = "your-token-value"
            EnrollmentMode          = "corporateOwnedWorkProfile"
            QrCodeContent           = "your-qr-code-content"
            WifiSsid                = "your-wifi-ssid"
            WifiPassword            = "your-wifi-password"
            WifiSecurityType        = "wpa"
            Ensure                  = "Present"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
