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
        IntuneDeviceComplianceScriptWindows10 'Example'
        {
            DisplayName            = "custom";
            Ensure                 = "Present";
            EnforceSignatureCheck  = $False;
            Id                     = "00000000-0000-0000-0000-000000000000";
            RunAs32Bit             = $False; # Updated property
            RunAsAccount           = "system";
            DetectionScriptContent = "Write-Output `$true";
            Publisher              = "";
            ApplicationId          = $ApplicationId;
            TenantId               = $TenantId;
            CertificateThumbprint  = $CertificateThumbprint;
        }
    }
}
