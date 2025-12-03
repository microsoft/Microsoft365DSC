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
        IntuneDeviceComplianceScriptLinux 'Example'
        {
            Id                     = "12345678-1234-1234-1234-123456789012"
            Description            = "custom compliance script for Linux";
            DisplayName            = "custom";
            Ensure                 = "Present";
            DiscoveryScript        = "#!/bin/bash
echo false"; # Updated property
            ApplicationId          = $ApplicationId;
            TenantId               = $TenantId;
            CertificateThumbprint  = $CertificateThumbprint;
        }
    }
}
