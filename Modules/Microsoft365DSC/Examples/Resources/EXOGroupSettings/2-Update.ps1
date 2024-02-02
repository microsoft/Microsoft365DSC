<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )

    Import-DscResource -ModuleName Microsoft365DSC

    $Domain = $Credscredential.Username.Split('@')[1]
    node localhost
    {
        EXOGroupSettings 'TestGroup'
        {
            DisplayName                            = "All Company";
            AccessType                             = "Public";
            AlwaysSubscribeMembersToCalendarEvents = $False;
            AuditLogAgeLimit                       = "90.00:00:00";
            AutoSubscribeNewMembers                = $False;
            CalendarMemberReadOnly                 = $False;
            ConnectorsEnabled                      = $False; # Updated Property
            Credential                             = $Credscredential;
            HiddenFromAddressListsEnabled          = $True;
            HiddenFromExchangeClientsEnabled       = $True;
            InformationBarrierMode                 = "Open";
            Language                               = "en-US";
            MaxReceiveSize                         = "36 MB (37,748,736 bytes)";
            MaxSendSize                            = "35 MB (36,700,160 bytes)";
            ModerationEnabled                      = $False;
            Notes                                  = "My Notes";
            PrimarySmtpAddress                     = "TestGroup@$Domain";
            RequireSenderAuthenticationEnabled     = $True;
            SubscriptionEnabled                    = $False;
        }
    }
}
