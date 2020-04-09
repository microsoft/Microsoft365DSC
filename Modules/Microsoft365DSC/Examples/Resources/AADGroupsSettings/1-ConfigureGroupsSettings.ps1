<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADGroupsSettings GeneralGroupsSettings
        {
            AllowGuestsToAccessGroups     = $True;
            AllowGuestsToBeGroupOwner     = $True;
            AllowToAddGuests              = $True;
            EnableGroupCreation           = $True;
            Ensure                        = "Present";
            GlobalAdminAccount            = $credsGlobalAdmin;
            GroupCreationAllowedGroupName = "All Company";
            GuestUsageGuidelinesUrl       = "https://contoso.com/guestusage";
            IsSingleInstance              = "Yes";
            UsageGuidelinesUrl            = "https://contoso.com/usage";
        }
    }
}
