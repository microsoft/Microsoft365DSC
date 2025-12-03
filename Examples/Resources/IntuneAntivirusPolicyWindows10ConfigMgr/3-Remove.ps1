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
        IntuneAntivirusPolicyWindows10ConfigMgr "IntuneAntivirusPolicyWindows10ConfigMgr-Windows ConfigMgr - Microsoft Defender Antivirus"
        {
            ApplicationId                              = $ApplicationId;
            CertificateThumbprint                      = $CertificateThumbprint;
            DisplayName                                = "Windows ConfigMgr - Microsoft Defender Antivirus";
            Ensure                                     = "Absent";
            TenantId                                   = $TenantId;
        }
    }
}
