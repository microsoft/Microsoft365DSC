<#
This example creates a new Intune Trusted Root Certificate Configuration Policy for iOs devices
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
        IntuneTrustedRootCertificateIOS "ConfigureIntuneTrustedRootCertificateIOS"
        {
            Description            = "IntuneTrustedRootCertificateIOS Description";
            DisplayName            = "IntuneTrustedRootCertificateIOS DisplayName";
            Ensure                 = "Present";
            certFileName           = "newfakename.cer"; #changed value
            trustedRootCertificate = "insertValidBase64StringHereForAnotherCert" #changed value
            ApplicationId          = $ApplicationId;
            TenantId               = $TenantId;
            CertificateThumbprint  = $CertificateThumbprint;
        }
    }
}
