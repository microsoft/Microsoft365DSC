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
        AADConnectorGroupApplicationProxy "AADConnectorGroupApplicationProxy-testgroup"
        {
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            Ensure                = "Present";
            Id                    = "4984dcf7-d9e9-4663-90b4-5db09f92a669";
            Name                  = "testgroup-new";
            Region                = "nam";
        }
    }
}
