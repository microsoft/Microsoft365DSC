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
        EXOMigrationEndpoint "EXOMigrationEndpoint-testIMAP"
        {
            AcceptUntrustedCertificates   = $True;
            Authentication                = "Basic";
            ApplicationId                 = $ApplicationId
            TenantId                      = $TenantId
            CertificateThumbprint         = $CertificateThumbprint
            EndpointType                  = "IMAP";
            Ensure                        = "Present";
            Identity                      = "testIMAP";
            MailboxPermission             = "Admin";
            MaxConcurrentIncrementalSyncs = "10";
            MaxConcurrentMigrations       = "20";
            Port                          = 993;
            RemoteServer                  = "gmail.com";
            # value for security updated from Tls to None
            Security                      = "None";
        }
    }
}
