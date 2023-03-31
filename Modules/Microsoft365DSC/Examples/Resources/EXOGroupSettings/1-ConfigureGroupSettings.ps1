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
        $credential
    )

    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOGroupSettings 'TestGroup'
        {
            DisplayName                            = "Test Group";
            AccessType                             = "Public";
            AlwaysSubscribeMembersToCalendarEvents = $False;
            AuditLogAgeLimit                       = "90.00:00:00";
            AutoSubscribeNewMembers                = $False;
            CalendarMemberReadOnly                 = $False;
            ConnectorsEnabled                      = $True;
            Credential                             = $credential;
            HiddenFromAddressListsEnabled          = $True;
            HiddenFromExchangeClientsEnabled       = $True;
            InformationBarrierMode                 = "Open";
            Language                               = "en-US";
            MaxReceiveSize                         = "36 MB (37,748,736 bytes)";
            MaxSendSize                            = "35 MB (36,700,160 bytes)";
            ModerationEnabled                      = $False;
            Notes                                  = "My Notes";
            PrimarySmtpAddress                     = "TestGroup@contoso.com";
            RequireSenderAuthenticationEnabled     = $True;
            SubscriptionEnabled                    = $False;
        }
    }
}
