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
        EXOFocusedInbox "EXOFocusedInbox-Test"
        {
            Ensure                       = "Present";
            FocusedInboxOn               = $False; # Updated Property
            FocusedInboxOnLastUpdateTime = "1/1/0001 12:00:00 AM";
            Identity                     = "admin@$TenantId";
            ApplicationId                = $ApplicationId;
            TenantId                     = $TenantId;
            CertificateThumbprint        = $CertificateThumbprint;
        }
        
    }
}
