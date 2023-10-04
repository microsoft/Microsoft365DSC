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
        $credsAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXODistributionGroup 'DemoDG'
        {
            Alias                              = "demodg";
            BccBlocked                         = $False;
            BypassNestedModerationEnabled      = $False;
            DisplayName                        = "My Demo DG";
            Ensure                             = "Present";
            HiddenGroupMembershipEnabled       = $True;
            ManagedBy                          = @("john.smith@contoso.com");
            MemberDepartRestriction            = "Open";
            MemberJoinRestriction              = "Closed";
            ModeratedBy                        = @("admin@contoso.com");
            ModerationEnabled                  = $False;
            Identity                           = "DemoDG";
            Name                               = "DemoDG";
            OrganizationalUnit                 = "nampr03a010.prod.outlook.com/Microsoft Exchange Hosted Organizations/contoso.com";
            PrimarySmtpAddress                 = "demodg@contoso.com";
            RequireSenderAuthenticationEnabled = $True;
            SendModerationNotifications        = "Always";
            Credential                         = $credsAdmin
        }
    }
}
