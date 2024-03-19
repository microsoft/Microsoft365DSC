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

    node localhost
    {
        EXOMailboxPlan 'ConfigureMailboxPlan'
        {
            Ensure                   = "Present";
            Identity                 = "ExchangeOnlineEssentials";
            IssueWarningQuota        = "15 GB (16,106,127,360 bytes)";
            MaxReceiveSize           = "25 MB (26,214,400 bytes)";
            MaxSendSize              = "25 MB (26,214,400 bytes)";
            ProhibitSendQuota        = "15 GB (16,106,127,360 bytes)";
            ProhibitSendReceiveQuota = "15 GB (16,106,127,360 bytes)"; # Updated Property
            RetainDeletedItemsFor    = "14.00:00:00";
            RoleAssignmentPolicy     = "Default Role Assignment Policy";
            Credential               = $Credscredential
        }
    }
}
