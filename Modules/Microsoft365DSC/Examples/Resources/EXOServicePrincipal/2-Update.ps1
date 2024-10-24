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
        EXOServicePrincipal 'ServicePrincipal'
        {
            AppId                = "703005d9-c467-413e-a085-295c3e09e6cb";
            DisplayName          = "Aditya Mukund";
            Ensure               = "Present";
            Identity             = "6dfb8885-0297-42e6-9c81-7bf7ee15551d";
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
