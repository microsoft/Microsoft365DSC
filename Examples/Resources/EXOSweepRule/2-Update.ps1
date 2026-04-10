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
        EXOSweepRule 'MyRule'
        {
            ApplicationId         = $ApplicationId;
            CertificateThumbprint = $CertificateThumbprint;
            DestinationFolder     = "Test2:\Deleted Items";
            Enabled               = $True;
            Ensure                = "Present";
            KeepLatest            = 13; # Drift
            Mailbox               = "Test2";
            Name                  = "From Michelle";
            Provider              = "Exchange16";
            SenderName            = "michelle@fabrikam.com";
            SourceFolder          = "Test2:\Inbox";
            TenantId              = $TenantId;
        }
    }
}
