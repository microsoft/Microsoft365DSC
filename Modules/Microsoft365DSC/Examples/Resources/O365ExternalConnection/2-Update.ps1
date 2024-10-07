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
        O365ExternalConnection "O365ExternalConnection-Contoso HR"
        {
            ApplicationId         = $ApplicationId;
            AuthorizedAppIds      = @("MyApp", "MySecondApp"); # Drift
            CertificateThumbprint = $CertificateThumbprint;
            Description           = "Connection to index Contoso HR system";
            Ensure                = "Present";
            Id                    = "contosohr";
            Name                  = "Contoso HR Nik";
            TenantId              = $TenantId;
        }
    }
}
