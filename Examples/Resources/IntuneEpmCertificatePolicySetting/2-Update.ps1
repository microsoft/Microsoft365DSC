<#
This example updates a Intune Firewall Policy for Windows10.
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
            CertificateFile       = "<Base64EncodedCertificateContent>"; # Update with new Base64 encoded certificate content
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
