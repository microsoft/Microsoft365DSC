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
        EXOMigration "EXOMigration-test"
        {
            AddUsers             = $False;
            BadItemLimit         = "";
            CompleteAfter        = "12/31/9999 11:59:59 PM";
            Ensure               = "Absent";
            Identity             = "test";
            LargeItemLimit       = "";
            MoveOptions          = @();
            NotificationEmails   = @("eac_admin@bellred.org");
            SkipMerging          = @();
            Status               = "Completed";
            Update               = $False;
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
