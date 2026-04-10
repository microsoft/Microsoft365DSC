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
        EXODistributionGroup 'DemoDG'
        {
            Alias                              = "demodg";
            BccBlocked                         = $True; # Updated Property
            BypassNestedModerationEnabled      = $False;
            DisplayName                        = "My Demo DG";
            Ensure                             = "Present";
            HiddenGroupMembershipEnabled       = $True;
            ManagedBy                          = @("adeleV@$TenantId");
            MemberDepartRestriction            = "Open";
            MemberJoinRestriction              = "Closed";
            ModeratedBy                        = @("alexW@$TenantId");
            ModerationEnabled                  = $False;
            Identity                           = "DemoDG";
            Name                               = "DemoDG";
            PrimarySmtpAddress                 = "demodg@$TenantId";
            RequireSenderAuthenticationEnabled = $True;
            SendModerationNotifications        = "Always";
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
