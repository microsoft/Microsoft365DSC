<#
This example creates a new Intune Firewall Policy for Windows10.
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
        IntuneEpmCertificatePolicySetting "IntuneEpmCertificatePolicySetting-IntuneEpmCertificatePolicySetting_1"
        {
            Description           = "";
            DisplayName           = "IntuneEpmCertificatePolicySetting_1";
            Ensure                = "Present";
            CertificateFile       = "<Base64EncodedCertificateContent>";
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
