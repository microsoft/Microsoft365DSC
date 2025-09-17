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
            CertificateThumbprint                      = $CertificateThumbprint;
            DisplayName                                = "Windows ConfigMgr - Windows Security experience";
            Ensure                                     = "Absent";
            TenantId                                   = $TenantId;
        }
    }
}
