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
        EXODistributionGroup 'DemoDG'
        {
            Alias                              = "demodg";
            BccBlocked                         = $True; # Updated Property
            BypassNestedModerationEnabled      = $False;
            DisplayName                        = "My Demo DG";
            Ensure                             = "Present";
            HiddenGroupMembershipEnabled       = $True;
            ManagedBy                          = @("adeleV@$Domain");
            MemberDepartRestriction            = "Open";
            MemberJoinRestriction              = "Closed";
            ModeratedBy                        = @("alexW@$Domain");
            ModerationEnabled                  = $False;
            Identity                           = "DemoDG";
            Name                               = "DemoDG";
            OrganizationalUnit                 = "nampr03a010.prod.outlook.com/Microsoft Exchange Hosted Organizations/$Domain";
            PrimarySmtpAddress                 = "demodg@$Domain";
            RequireSenderAuthenticationEnabled = $True;
            SendModerationNotifications        = "Always";
            Credential                         = $Credscredential
        }
    }
}
