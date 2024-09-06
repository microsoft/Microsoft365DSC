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
        EXOArcConfig "EXOArcConfig"
        {
            ArcTrustedSealers     = "example.com,example.org";
            Ensure                = "Present";
            IsSingleInstance      = "Yes";
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}

Example -ConfigurationData .\ConfigurationData.psd1 -Credential $Credential
