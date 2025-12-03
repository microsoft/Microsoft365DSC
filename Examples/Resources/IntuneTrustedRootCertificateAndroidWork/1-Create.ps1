<#
This example creates a new Intune Trusted Root Certificate Configuration Policy for Android Work devices
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
    Import-DscResource -ModuleName 'Microsoft365DSC'

    Node localhost
    {
        IntuneTrustedRootCertificateAndroidWork "ConfigureIntuneTrustedRootCertificateAndroidWork"
        {
            Description            = "IntuneTrustedRootCertificateAndroidWork Description";
            DisplayName            = "IntuneTrustedRootCertificateAndroidWork DisplayName";
            Ensure                 = "Present";
            certFileName           = "fakename.cer";
            trustedRootCertificate = "insertValidBase64StringHere";
            ApplicationId          = $ApplicationId;
            TenantId               = $TenantId;
            CertificateThumbprint  = $CertificateThumbprint;
        }
    }
}
