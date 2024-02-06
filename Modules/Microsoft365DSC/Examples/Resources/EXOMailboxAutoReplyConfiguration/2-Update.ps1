<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    $Domain = $Credscredential.Username.Split('@')[1]
    node localhost
    {
        EXOMailboxAutoReplyConfiguration "EXOMailboxAutoReplyConfiguration"
        {
            AutoDeclineFutureRequestsWhenOOF = $False;
            AutoReplyState                   = "Disabled";
            CreateOOFEvent                   = $False;
            Credential                       = $Credscredential;
            DeclineAllEventsForScheduledOOF  = $False;
            DeclineEventsForScheduledOOF     = $False;
            DeclineMeetingMessage            = "";
            EndTime                          = "1/23/2024 3:00:00 PM";
            Ensure                           = "Present";
            ExternalAudience                 = "All";
            ExternalMessage                  = (New-Guid).ToString(); # Updated Property
            Identity                         = "AdeleV@$Domain";
            InternalMessage                  = "";
            OOFEventSubject                  = "";
            StartTime                        = "1/22/2024 3:00:00 PM";
        }
    }
}
