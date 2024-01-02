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
        AADGroupsSettings 'GeneralGroupsSettings'
        {
            IsSingleInstance              = "Yes"
            AllowGuestsToAccessGroups     = $True
            AllowGuestsToBeGroupOwner     = $True
            AllowToAddGuests              = $True
            EnableGroupCreation           = $True
            GroupCreationAllowedGroupName = "All Company"
            GuestUsageGuidelinesUrl       = "https://contoso.com/guestusage"
            UsageGuidelinesUrl            = "https://contoso.com/usage"
            Ensure                        = "Present"
            Credential                    = $Credscredential
        }
    }
}
